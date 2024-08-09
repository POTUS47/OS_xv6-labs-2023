#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "e1000_dev.h"
#include "net.h"

#define TX_RING_SIZE 16
static struct tx_desc tx_ring[TX_RING_SIZE] __attribute__((aligned(16)));
static struct mbuf *tx_mbufs[TX_RING_SIZE];

#define RX_RING_SIZE 16
static struct rx_desc rx_ring[RX_RING_SIZE] __attribute__((aligned(16)));
static struct mbuf *rx_mbufs[RX_RING_SIZE];

// remember where the e1000's registers live.
static volatile uint32 *regs;

struct spinlock e1000_lock;

// called by pci_init().
// xregs is the memory address at which the
// e1000's registers are mapped.
void
e1000_init(uint32 *xregs)
{
  int i;

  initlock(&e1000_lock, "e1000");

  regs = xregs;

  // Reset the device
  regs[E1000_IMS] = 0; // disable interrupts
  regs[E1000_CTL] |= E1000_CTL_RST;
  regs[E1000_IMS] = 0; // redisable interrupts
  __sync_synchronize();

  // [E1000 14.5] Transmit initialization
  memset(tx_ring, 0, sizeof(tx_ring));
  for (i = 0; i < TX_RING_SIZE; i++) {
    tx_ring[i].status = E1000_TXD_STAT_DD;
    tx_mbufs[i] = 0;
  }
  regs[E1000_TDBAL] = (uint64) tx_ring;
  if(sizeof(tx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_TDLEN] = sizeof(tx_ring);
  regs[E1000_TDH] = regs[E1000_TDT] = 0;
  
  // [E1000 14.4] Receive initialization
  memset(rx_ring, 0, sizeof(rx_ring));
  for (i = 0; i < RX_RING_SIZE; i++) {
    rx_mbufs[i] = mbufalloc(0);
    if (!rx_mbufs[i])
      panic("e1000");
    rx_ring[i].addr = (uint64) rx_mbufs[i]->head;
  }
  regs[E1000_RDBAL] = (uint64) rx_ring;
  if(sizeof(rx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_RDH] = 0;
  regs[E1000_RDT] = RX_RING_SIZE - 1;
  regs[E1000_RDLEN] = sizeof(rx_ring);

  // filter by qemu's MAC address, 52:54:00:12:34:56
  regs[E1000_RA] = 0x12005452;
  regs[E1000_RA+1] = 0x5634 | (1<<31);
  // multicast table
  for (int i = 0; i < 4096/32; i++)
    regs[E1000_MTA + i] = 0;

  // transmitter control bits.
  regs[E1000_TCTL] = E1000_TCTL_EN |  // enable
    E1000_TCTL_PSP |                  // pad short packets
    (0x10 << E1000_TCTL_CT_SHIFT) |   // collision stuff
    (0x40 << E1000_TCTL_COLD_SHIFT);
  regs[E1000_TIPG] = 10 | (8<<10) | (6<<20); // inter-pkt gap

  // receiver control bits.
  regs[E1000_RCTL] = E1000_RCTL_EN | // enable receiver
    E1000_RCTL_BAM |                 // enable broadcast
    E1000_RCTL_SZ_2048 |             // 2048-byte rx buffers
    E1000_RCTL_SECRC;                // strip CRC
  
  // ask e1000 for receive interrupts.
  regs[E1000_RDTR] = 0; // interrupt after every received packet (no timer)
  regs[E1000_RADV] = 0; // interrupt after every packet (no timer)
  regs[E1000_IMS] = (1 << 7); // RXDW -- Receiver Descriptor Write Back
}

int e1000_transmit(struct mbuf *m)
{
  acquire(&e1000_lock);
  uint32 index = regs[E1000_TDT];
  if (!(tx_ring[index].status & E1000_TXD_STAT_DD)) // 如果用 E1000_TDT 索引到的 tx_ring 的元素的 E1000_TXD_STAT_DD 位没被设置，那么此descriptor的传输尚未结束，需要返回-1
  {
    release(&e1000_lock);
    return -1;
  }
  if (tx_mbufs[index])
  {
    mbuffree(tx_mbufs[index]); // 如果 tx_mbufs[index] 不为空指针，使用 mbuffree 回收它
  }

  tx_mbufs[index] = m; // 保存指向`mbuf`的指针，以便稍后释放
  memset(&tx_ring[index], 0, sizeof(tx_ring[index]));
  tx_ring[index].addr = (uint64)m->head; //`m->head`指向内存中数据包的内容
  tx_ring[index].length = m->len;        // m->len`是数据包的长度

  tx_ring[index].cmd = E1000_TXD_CMD_RS | E1000_TXD_CMD_EOP; // 设置必要的cmd标志

  regs[E1000_TDT] = (index + 1) % TX_RING_SIZE; // 通过将一加到`E1000_TDT`再对`TX_RING_SIZE`取模来更新环位置
  release(&e1000_lock);
  return 0;
}

static void
e1000_recv(void)
{
  while (1)
  { // 每次 recv 可能接收多个包

    uint32 index = (regs[E1000_RDT] + 1) % RX_RING_SIZE;

    struct rx_desc *desc = &rx_ring[index];
    // 如果需要接收的包都已经接收完毕，则退出
    if (!(desc->status & E1000_RXD_STAT_DD))
    {
      return;
    }

    rx_mbufs[index]->len = desc->length; // 将`mbuf`的`m->len`更新为描述符中报告的长度

    net_rx(rx_mbufs[index]); // 使用`net_rx()`将`mbuf`传送到网络栈

    // 使用`mbufalloc()`分配一个新的`mbuf`，以替换刚刚给`net_rx()`的`mbuf`。将其数据指针（`m->head`）编程到描述符中。将描述符的状态位清除为零。
    rx_mbufs[index] = mbufalloc(0);
    desc->addr = (uint64)rx_mbufs[index]->head;
    desc->status = 0;

    regs[E1000_RDT] = index; // 将`E1000_RDT`寄存器更新为最后处理的环描述符的索引。
  }
}

void
e1000_intr(void)
{
  // tell the e1000 we've seen this interrupt;
  // without this the e1000 won't raise any
  // further interrupts.
  regs[E1000_ICR] = 0xffffffff;

  e1000_recv();
}