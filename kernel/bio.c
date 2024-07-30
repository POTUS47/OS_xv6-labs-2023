// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.

#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

#define NBUK 13
#define hash(dev, blockno) ((dev * blockno) % NBUK) // we use "mod" to establish func of hash

struct bucket
{
  struct spinlock lock;
  struct buf head; // the head of current bucket
};

struct
{
  struct spinlock lock;
  struct buf buf[NBUF];        // the cache has 30 bufs
  struct bucket buckets[NBUK]; // the cache has 13 buckets
} bcache;

void binit(void)
{
  struct buf *b;
  struct buf *prev_b;

  initlock(&bcache.lock, "bcache");

  for (int i = 0; i < NBUK; i++)
  {
    initlock(&bcache.buckets[i].lock, "bcache.bucket");
    bcache.buckets[i].head.next = (void *)0; // setting 0 for each tail of bucket
    // we pass all bufs to buckets[0] firstly
    if (i == 0)
    {
      prev_b = &bcache.buckets[i].head;
      for (b = bcache.buf; b < bcache.buf + NBUF; b++)
      {
        if (b == bcache.buf + NBUF - 1) // buf[29]
          b->next = (void *)0;          // set tail of 0 for the buckets[0] of bufs
        prev_b->next = b;
        b->timestamp = ticks; // when initialize kernel, ticks == 0
        initsleeplock(&b->lock, "buffer");
        prev_b = b; // next linking
      }
    }
  }
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf *
bget(uint dev, uint blockno)
{
  struct buf *b;
  int buk_id = hash(dev, blockno); // get buk_id by mapping of hash

  // Is the block already cached?
  // atomic: one bucket.lock only be acquired by one process
  acquire(&bcache.buckets[buk_id].lock);
  b = bcache.buckets[buk_id].head.next; // the first buf in buckets[buk_id]
  while (b)
  {
    if (b->dev == dev && b->blockno == blockno)
    {
      // acquire(&bcache.buckets[buk_id].lock);
      b->refcnt++;
      release(&bcache.buckets[buk_id].lock);
      acquiresleep(&b->lock);
      return b;
    }
    b = b->next;
  }
  release(&bcache.buckets[buk_id].lock);

  // Not cached.
  // Recycle the least recently used (LRU) unused buffer.
  int max_timestamp = 0;
  int lru_buk_id = -1; //
  int is_better = 0;   // we have better lru_buk_id?
  struct buf *lru_b = (void *)0;
  struct buf *prev_lru_b = (void *)0;

  // atomic: we alway lock buckets[lru_buk_id] to avoid be used by other process
  // find lru_buk_id when refcnt == 0 and getting max_timestamp in each bucket[i]
  struct buf *prev_b = (void *)0;
  for (int i = 0; i < NBUK; i++)
  {
    prev_b = &bcache.buckets[i].head;
    acquire(&bcache.buckets[i].lock);
    while (prev_b->next)
    {
      // we must use ">=" max_timestamp == 0 at first time in eviction
      if (prev_b->next->refcnt == 0 && prev_b->next->timestamp >= max_timestamp)
      {
        max_timestamp = prev_b->next->timestamp;
        is_better = 1;
        prev_lru_b = prev_b; // get prev_lru_b
        // not use break, we must find the max_timestamp until we running in the tail of buckets[12]
      }
      prev_b = prev_b->next;
    }
    if (is_better)
    {
      if (lru_buk_id != -1)
        release(&bcache.buckets[lru_buk_id].lock); // release old buckets[lru_buk_id]
      lru_buk_id = i;                              // get new lru_buk_id and alway lock it
    }
    else
      release(&bcache.buckets[i].lock); // not better lru_buk_id, so we release current bucket[i]
    is_better = 0;                      // reset is_better to go next bucket[i]
  }

  // get lru_b
  lru_b = prev_lru_b->next;

  // steal lru_b from buckets[lru_buk_id] by prev_lru_b
  // and release buckets[lru_buk_id].lock
  if (lru_b)
  {
    prev_lru_b->next = prev_lru_b->next->next;
    release(&bcache.buckets[lru_buk_id].lock);
  }

  // cache lru_b to buckets[buk_id]
  // atomic: one bucket.lock only be acquired by one process
  acquire(&bcache.lock);
  acquire(&bcache.buckets[buk_id].lock);
  if (lru_b)
  {
    lru_b->next = bcache.buckets[buk_id].head.next;
    bcache.buckets[buk_id].head.next = lru_b;
  }

  // if two processes will use the same block(same blockno) in buckets[lru_buk_id]
  // one process can check it that if already here we get it
  // otherwise, we will use same block in two processes and cache double
  // then "panic freeing free block"
  b = bcache.buckets[buk_id].head.next; // the first buf in buckets[buk_id]
  while (b)
  {
    if (b->dev == dev && b->blockno == blockno)
    {
      b->refcnt++;
      release(&bcache.buckets[buk_id].lock);
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
    b = b->next;
  }

  // not find lru_b when travel each bucket
  if (lru_b == 0)
    panic("bget: no buffers");

  lru_b->dev = dev;
  lru_b->blockno = blockno;
  lru_b->valid = 0;
  lru_b->refcnt = 1;
  release(&bcache.buckets[buk_id].lock);
  release(&bcache.lock);
  acquiresleep(&lru_b->lock);
  return lru_b;
}

// Return a locked buf with the contents of the indicated block.
struct buf *
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid)
  {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void bwrite(struct buf *b)
{
  if (!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void brelse(struct buf *b)
{
  if (!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);

  int buk_id = hash(b->dev, b->blockno);
  acquire(&bcache.buckets[buk_id].lock);
  b->refcnt--;
  // update timestamp when it is a free buf (b->refcnt == 0)
  if (b->refcnt == 0)
    b->timestamp = ticks;
  release(&bcache.buckets[buk_id].lock);
}

void bpin(struct buf *b)
{
  int buk_id = hash(b->dev, b->blockno);
  acquire(&bcache.buckets[buk_id].lock);
  b->refcnt++;
  release(&bcache.buckets[buk_id].lock);
}

void bunpin(struct buf *b)
{
  int buk_id = hash(b->dev, b->blockno);
  acquire(&bcache.buckets[buk_id].lock);
  b->refcnt--;
  release(&bcache.buckets[buk_id].lock);
}
