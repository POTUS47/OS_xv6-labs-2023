// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem[NCPU];

void
kinit()
{
  for (int i = 0; i < NCPU;i++){
    initlock(&kmem[i].lock, "kmem");
  }
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  push_off();
  int cpuId = cpuid(); // 获得这是第几个cpu
  pop_off();

  acquire(&kmem[cpuId].lock);
  r->next = kmem[cpuId].freelist;
  kmem[cpuId].freelist = r;
  release(&kmem[cpuId].lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  push_off();
  int cpuId = cpuid(); // 获得这是第几个cpu
  pop_off();

  acquire(&kmem[cpuId].lock);
  r = kmem[cpuId].freelist;
  if(r){//如果自己还有空闲链表，就从自己这里获得
    kmem[cpuId].freelist = r->next;
    release(&kmem[cpuId].lock);
  }
  else{//自己的用完了
    release(&kmem[cpuId].lock);
    for (int i = 0; i < NCPU; i++){
      if (i != cpuId)
      {
        acquire(&kmem[i].lock);//获取对方的锁
        r = kmem[i].freelist;
        if (r)
        {
          kmem[i].freelist = r->next;
          release(&kmem[i].lock);
          break;
        }
        else{
          release(&kmem[i].lock);
        }
      }
    }
  }

  // if(r){
  //   memset((char *)r, 5, PGSIZE); // fill with junk
  // }
  return (void *)r;
}

