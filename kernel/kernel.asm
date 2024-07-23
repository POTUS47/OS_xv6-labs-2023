
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001a117          	auipc	sp,0x1a
    80000004:	0c010113          	addi	sp,sp,192 # 8001a0c0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0b7050ef          	jal	ra,800058cc <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	19078793          	addi	a5,a5,400 # 800221c0 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	154080e7          	jalr	340(ra) # 8000019c <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	b0090913          	addi	s2,s2,-1280 # 80008b50 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	272080e7          	jalr	626(ra) # 800062cc <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	312080e7          	jalr	786(ra) # 80006380 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	cf8080e7          	jalr	-776(ra) # 80005d82 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	a6450513          	addi	a0,a0,-1436 # 80008b50 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	148080e7          	jalr	328(ra) # 8000623c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	0c050513          	addi	a0,a0,192 # 800221c0 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	a2e48493          	addi	s1,s1,-1490 # 80008b50 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	1a0080e7          	jalr	416(ra) # 800062cc <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	a1650513          	addi	a0,a0,-1514 # 80008b50 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	23c080e7          	jalr	572(ra) # 80006380 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	04a080e7          	jalr	74(ra) # 8000019c <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	9ea50513          	addi	a0,a0,-1558 # 80008b50 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	212080e7          	jalr	530(ra) # 80006380 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <get_amount_freemem>:

uint64
get_amount_freemem()
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  uint64 num_page = 0;
  struct run *page = kmem.freelist;
    8000017e:	00009797          	auipc	a5,0x9
    80000182:	9ea7b783          	ld	a5,-1558(a5) # 80008b68 <kmem+0x18>
  while (page)
    80000186:	cb89                	beqz	a5,80000198 <get_amount_freemem+0x20>
  uint64 num_page = 0;
    80000188:	4501                	li	a0,0
  {
    /* count for number of page */
    num_page++;
    8000018a:	0505                	addi	a0,a0,1
    /* perare next page */
    page = page->next;
    8000018c:	639c                	ld	a5,0(a5)
  while (page)
    8000018e:	fff5                	bnez	a5,8000018a <get_amount_freemem+0x12>
  }
  return PGSIZE * num_page;
}
    80000190:	0532                	slli	a0,a0,0xc
    80000192:	6422                	ld	s0,8(sp)
    80000194:	0141                	addi	sp,sp,16
    80000196:	8082                	ret
  uint64 num_page = 0;
    80000198:	4501                	li	a0,0
    8000019a:	bfdd                	j	80000190 <get_amount_freemem+0x18>

000000008000019c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001a2:	ce09                	beqz	a2,800001bc <memset+0x20>
    800001a4:	87aa                	mv	a5,a0
    800001a6:	fff6071b          	addiw	a4,a2,-1
    800001aa:	1702                	slli	a4,a4,0x20
    800001ac:	9301                	srli	a4,a4,0x20
    800001ae:	0705                	addi	a4,a4,1
    800001b0:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800001b2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001b6:	0785                	addi	a5,a5,1
    800001b8:	fee79de3          	bne	a5,a4,800001b2 <memset+0x16>
  }
  return dst;
}
    800001bc:	6422                	ld	s0,8(sp)
    800001be:	0141                	addi	sp,sp,16
    800001c0:	8082                	ret

00000000800001c2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001c2:	1141                	addi	sp,sp,-16
    800001c4:	e422                	sd	s0,8(sp)
    800001c6:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001c8:	ca05                	beqz	a2,800001f8 <memcmp+0x36>
    800001ca:	fff6069b          	addiw	a3,a2,-1
    800001ce:	1682                	slli	a3,a3,0x20
    800001d0:	9281                	srli	a3,a3,0x20
    800001d2:	0685                	addi	a3,a3,1
    800001d4:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001d6:	00054783          	lbu	a5,0(a0)
    800001da:	0005c703          	lbu	a4,0(a1)
    800001de:	00e79863          	bne	a5,a4,800001ee <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001e2:	0505                	addi	a0,a0,1
    800001e4:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001e6:	fed518e3          	bne	a0,a3,800001d6 <memcmp+0x14>
  }

  return 0;
    800001ea:	4501                	li	a0,0
    800001ec:	a019                	j	800001f2 <memcmp+0x30>
      return *s1 - *s2;
    800001ee:	40e7853b          	subw	a0,a5,a4
}
    800001f2:	6422                	ld	s0,8(sp)
    800001f4:	0141                	addi	sp,sp,16
    800001f6:	8082                	ret
  return 0;
    800001f8:	4501                	li	a0,0
    800001fa:	bfe5                	j	800001f2 <memcmp+0x30>

00000000800001fc <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001fc:	1141                	addi	sp,sp,-16
    800001fe:	e422                	sd	s0,8(sp)
    80000200:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000202:	ca0d                	beqz	a2,80000234 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000204:	00a5f963          	bgeu	a1,a0,80000216 <memmove+0x1a>
    80000208:	02061693          	slli	a3,a2,0x20
    8000020c:	9281                	srli	a3,a3,0x20
    8000020e:	00d58733          	add	a4,a1,a3
    80000212:	02e56463          	bltu	a0,a4,8000023a <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000216:	fff6079b          	addiw	a5,a2,-1
    8000021a:	1782                	slli	a5,a5,0x20
    8000021c:	9381                	srli	a5,a5,0x20
    8000021e:	0785                	addi	a5,a5,1
    80000220:	97ae                	add	a5,a5,a1
    80000222:	872a                	mv	a4,a0
      *d++ = *s++;
    80000224:	0585                	addi	a1,a1,1
    80000226:	0705                	addi	a4,a4,1
    80000228:	fff5c683          	lbu	a3,-1(a1)
    8000022c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000230:	fef59ae3          	bne	a1,a5,80000224 <memmove+0x28>

  return dst;
}
    80000234:	6422                	ld	s0,8(sp)
    80000236:	0141                	addi	sp,sp,16
    80000238:	8082                	ret
    d += n;
    8000023a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000023c:	fff6079b          	addiw	a5,a2,-1
    80000240:	1782                	slli	a5,a5,0x20
    80000242:	9381                	srli	a5,a5,0x20
    80000244:	fff7c793          	not	a5,a5
    80000248:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000024a:	177d                	addi	a4,a4,-1
    8000024c:	16fd                	addi	a3,a3,-1
    8000024e:	00074603          	lbu	a2,0(a4)
    80000252:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000256:	fef71ae3          	bne	a4,a5,8000024a <memmove+0x4e>
    8000025a:	bfe9                	j	80000234 <memmove+0x38>

000000008000025c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000025c:	1141                	addi	sp,sp,-16
    8000025e:	e406                	sd	ra,8(sp)
    80000260:	e022                	sd	s0,0(sp)
    80000262:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000264:	00000097          	auipc	ra,0x0
    80000268:	f98080e7          	jalr	-104(ra) # 800001fc <memmove>
}
    8000026c:	60a2                	ld	ra,8(sp)
    8000026e:	6402                	ld	s0,0(sp)
    80000270:	0141                	addi	sp,sp,16
    80000272:	8082                	ret

0000000080000274 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000274:	1141                	addi	sp,sp,-16
    80000276:	e422                	sd	s0,8(sp)
    80000278:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000027a:	ce11                	beqz	a2,80000296 <strncmp+0x22>
    8000027c:	00054783          	lbu	a5,0(a0)
    80000280:	cf89                	beqz	a5,8000029a <strncmp+0x26>
    80000282:	0005c703          	lbu	a4,0(a1)
    80000286:	00f71a63          	bne	a4,a5,8000029a <strncmp+0x26>
    n--, p++, q++;
    8000028a:	367d                	addiw	a2,a2,-1
    8000028c:	0505                	addi	a0,a0,1
    8000028e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000290:	f675                	bnez	a2,8000027c <strncmp+0x8>
  if(n == 0)
    return 0;
    80000292:	4501                	li	a0,0
    80000294:	a809                	j	800002a6 <strncmp+0x32>
    80000296:	4501                	li	a0,0
    80000298:	a039                	j	800002a6 <strncmp+0x32>
  if(n == 0)
    8000029a:	ca09                	beqz	a2,800002ac <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    8000029c:	00054503          	lbu	a0,0(a0)
    800002a0:	0005c783          	lbu	a5,0(a1)
    800002a4:	9d1d                	subw	a0,a0,a5
}
    800002a6:	6422                	ld	s0,8(sp)
    800002a8:	0141                	addi	sp,sp,16
    800002aa:	8082                	ret
    return 0;
    800002ac:	4501                	li	a0,0
    800002ae:	bfe5                	j	800002a6 <strncmp+0x32>

00000000800002b0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002b0:	1141                	addi	sp,sp,-16
    800002b2:	e422                	sd	s0,8(sp)
    800002b4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002b6:	872a                	mv	a4,a0
    800002b8:	8832                	mv	a6,a2
    800002ba:	367d                	addiw	a2,a2,-1
    800002bc:	01005963          	blez	a6,800002ce <strncpy+0x1e>
    800002c0:	0705                	addi	a4,a4,1
    800002c2:	0005c783          	lbu	a5,0(a1)
    800002c6:	fef70fa3          	sb	a5,-1(a4)
    800002ca:	0585                	addi	a1,a1,1
    800002cc:	f7f5                	bnez	a5,800002b8 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002ce:	00c05d63          	blez	a2,800002e8 <strncpy+0x38>
    800002d2:	86ba                	mv	a3,a4
    *s++ = 0;
    800002d4:	0685                	addi	a3,a3,1
    800002d6:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002da:	fff6c793          	not	a5,a3
    800002de:	9fb9                	addw	a5,a5,a4
    800002e0:	010787bb          	addw	a5,a5,a6
    800002e4:	fef048e3          	bgtz	a5,800002d4 <strncpy+0x24>
  return os;
}
    800002e8:	6422                	ld	s0,8(sp)
    800002ea:	0141                	addi	sp,sp,16
    800002ec:	8082                	ret

00000000800002ee <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ee:	1141                	addi	sp,sp,-16
    800002f0:	e422                	sd	s0,8(sp)
    800002f2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002f4:	02c05363          	blez	a2,8000031a <safestrcpy+0x2c>
    800002f8:	fff6069b          	addiw	a3,a2,-1
    800002fc:	1682                	slli	a3,a3,0x20
    800002fe:	9281                	srli	a3,a3,0x20
    80000300:	96ae                	add	a3,a3,a1
    80000302:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000304:	00d58963          	beq	a1,a3,80000316 <safestrcpy+0x28>
    80000308:	0585                	addi	a1,a1,1
    8000030a:	0785                	addi	a5,a5,1
    8000030c:	fff5c703          	lbu	a4,-1(a1)
    80000310:	fee78fa3          	sb	a4,-1(a5)
    80000314:	fb65                	bnez	a4,80000304 <safestrcpy+0x16>
    ;
  *s = 0;
    80000316:	00078023          	sb	zero,0(a5)
  return os;
}
    8000031a:	6422                	ld	s0,8(sp)
    8000031c:	0141                	addi	sp,sp,16
    8000031e:	8082                	ret

0000000080000320 <strlen>:

int
strlen(const char *s)
{
    80000320:	1141                	addi	sp,sp,-16
    80000322:	e422                	sd	s0,8(sp)
    80000324:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000326:	00054783          	lbu	a5,0(a0)
    8000032a:	cf91                	beqz	a5,80000346 <strlen+0x26>
    8000032c:	0505                	addi	a0,a0,1
    8000032e:	87aa                	mv	a5,a0
    80000330:	4685                	li	a3,1
    80000332:	9e89                	subw	a3,a3,a0
    80000334:	00f6853b          	addw	a0,a3,a5
    80000338:	0785                	addi	a5,a5,1
    8000033a:	fff7c703          	lbu	a4,-1(a5)
    8000033e:	fb7d                	bnez	a4,80000334 <strlen+0x14>
    ;
  return n;
}
    80000340:	6422                	ld	s0,8(sp)
    80000342:	0141                	addi	sp,sp,16
    80000344:	8082                	ret
  for(n = 0; s[n]; n++)
    80000346:	4501                	li	a0,0
    80000348:	bfe5                	j	80000340 <strlen+0x20>

000000008000034a <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000034a:	1141                	addi	sp,sp,-16
    8000034c:	e406                	sd	ra,8(sp)
    8000034e:	e022                	sd	s0,0(sp)
    80000350:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000352:	00001097          	auipc	ra,0x1
    80000356:	b56080e7          	jalr	-1194(ra) # 80000ea8 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000035a:	00008717          	auipc	a4,0x8
    8000035e:	7c670713          	addi	a4,a4,1990 # 80008b20 <started>
  if(cpuid() == 0){
    80000362:	c139                	beqz	a0,800003a8 <main+0x5e>
    while(started == 0)
    80000364:	431c                	lw	a5,0(a4)
    80000366:	2781                	sext.w	a5,a5
    80000368:	dff5                	beqz	a5,80000364 <main+0x1a>
      ;
    __sync_synchronize();
    8000036a:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	b3a080e7          	jalr	-1222(ra) # 80000ea8 <cpuid>
    80000376:	85aa                	mv	a1,a0
    80000378:	00008517          	auipc	a0,0x8
    8000037c:	cc050513          	addi	a0,a0,-832 # 80008038 <etext+0x38>
    80000380:	00006097          	auipc	ra,0x6
    80000384:	a4c080e7          	jalr	-1460(ra) # 80005dcc <printf>
    kvminithart();    // turn on paging
    80000388:	00000097          	auipc	ra,0x0
    8000038c:	0d8080e7          	jalr	216(ra) # 80000460 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000390:	00002097          	auipc	ra,0x2
    80000394:	83c080e7          	jalr	-1988(ra) # 80001bcc <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000398:	00005097          	auipc	ra,0x5
    8000039c:	e88080e7          	jalr	-376(ra) # 80005220 <plicinithart>
  }

  scheduler();        
    800003a0:	00001097          	auipc	ra,0x1
    800003a4:	032080e7          	jalr	50(ra) # 800013d2 <scheduler>
    consoleinit();
    800003a8:	00006097          	auipc	ra,0x6
    800003ac:	8ec080e7          	jalr	-1812(ra) # 80005c94 <consoleinit>
    printfinit();
    800003b0:	00006097          	auipc	ra,0x6
    800003b4:	c02080e7          	jalr	-1022(ra) # 80005fb2 <printfinit>
    printf("\n");
    800003b8:	00008517          	auipc	a0,0x8
    800003bc:	c9050513          	addi	a0,a0,-880 # 80008048 <etext+0x48>
    800003c0:	00006097          	auipc	ra,0x6
    800003c4:	a0c080e7          	jalr	-1524(ra) # 80005dcc <printf>
    printf("xv6 kernel is booting\n");
    800003c8:	00008517          	auipc	a0,0x8
    800003cc:	c5850513          	addi	a0,a0,-936 # 80008020 <etext+0x20>
    800003d0:	00006097          	auipc	ra,0x6
    800003d4:	9fc080e7          	jalr	-1540(ra) # 80005dcc <printf>
    printf("\n");
    800003d8:	00008517          	auipc	a0,0x8
    800003dc:	c7050513          	addi	a0,a0,-912 # 80008048 <etext+0x48>
    800003e0:	00006097          	auipc	ra,0x6
    800003e4:	9ec080e7          	jalr	-1556(ra) # 80005dcc <printf>
    kinit();         // physical page allocator
    800003e8:	00000097          	auipc	ra,0x0
    800003ec:	cf4080e7          	jalr	-780(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003f0:	00000097          	auipc	ra,0x0
    800003f4:	34a080e7          	jalr	842(ra) # 8000073a <kvminit>
    kvminithart();   // turn on paging
    800003f8:	00000097          	auipc	ra,0x0
    800003fc:	068080e7          	jalr	104(ra) # 80000460 <kvminithart>
    procinit();      // process table
    80000400:	00001097          	auipc	ra,0x1
    80000404:	9f4080e7          	jalr	-1548(ra) # 80000df4 <procinit>
    trapinit();      // trap vectors
    80000408:	00001097          	auipc	ra,0x1
    8000040c:	79c080e7          	jalr	1948(ra) # 80001ba4 <trapinit>
    trapinithart();  // install kernel trap vector
    80000410:	00001097          	auipc	ra,0x1
    80000414:	7bc080e7          	jalr	1980(ra) # 80001bcc <trapinithart>
    plicinit();      // set up interrupt controller
    80000418:	00005097          	auipc	ra,0x5
    8000041c:	df2080e7          	jalr	-526(ra) # 8000520a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000420:	00005097          	auipc	ra,0x5
    80000424:	e00080e7          	jalr	-512(ra) # 80005220 <plicinithart>
    binit();         // buffer cache
    80000428:	00002097          	auipc	ra,0x2
    8000042c:	fb0080e7          	jalr	-80(ra) # 800023d8 <binit>
    iinit();         // inode table
    80000430:	00002097          	auipc	ra,0x2
    80000434:	654080e7          	jalr	1620(ra) # 80002a84 <iinit>
    fileinit();      // file table
    80000438:	00003097          	auipc	ra,0x3
    8000043c:	5f2080e7          	jalr	1522(ra) # 80003a2a <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000440:	00005097          	auipc	ra,0x5
    80000444:	ee8080e7          	jalr	-280(ra) # 80005328 <virtio_disk_init>
    userinit();      // first user process
    80000448:	00001097          	auipc	ra,0x1
    8000044c:	d68080e7          	jalr	-664(ra) # 800011b0 <userinit>
    __sync_synchronize();
    80000450:	0ff0000f          	fence
    started = 1;
    80000454:	4785                	li	a5,1
    80000456:	00008717          	auipc	a4,0x8
    8000045a:	6cf72523          	sw	a5,1738(a4) # 80008b20 <started>
    8000045e:	b789                	j	800003a0 <main+0x56>

0000000080000460 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000460:	1141                	addi	sp,sp,-16
    80000462:	e422                	sd	s0,8(sp)
    80000464:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000466:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000046a:	00008797          	auipc	a5,0x8
    8000046e:	6be7b783          	ld	a5,1726(a5) # 80008b28 <kernel_pagetable>
    80000472:	83b1                	srli	a5,a5,0xc
    80000474:	577d                	li	a4,-1
    80000476:	177e                	slli	a4,a4,0x3f
    80000478:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000047a:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000047e:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000482:	6422                	ld	s0,8(sp)
    80000484:	0141                	addi	sp,sp,16
    80000486:	8082                	ret

0000000080000488 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000488:	7139                	addi	sp,sp,-64
    8000048a:	fc06                	sd	ra,56(sp)
    8000048c:	f822                	sd	s0,48(sp)
    8000048e:	f426                	sd	s1,40(sp)
    80000490:	f04a                	sd	s2,32(sp)
    80000492:	ec4e                	sd	s3,24(sp)
    80000494:	e852                	sd	s4,16(sp)
    80000496:	e456                	sd	s5,8(sp)
    80000498:	e05a                	sd	s6,0(sp)
    8000049a:	0080                	addi	s0,sp,64
    8000049c:	84aa                	mv	s1,a0
    8000049e:	89ae                	mv	s3,a1
    800004a0:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004a2:	57fd                	li	a5,-1
    800004a4:	83e9                	srli	a5,a5,0x1a
    800004a6:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004a8:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004aa:	04b7f263          	bgeu	a5,a1,800004ee <walk+0x66>
    panic("walk");
    800004ae:	00008517          	auipc	a0,0x8
    800004b2:	ba250513          	addi	a0,a0,-1118 # 80008050 <etext+0x50>
    800004b6:	00006097          	auipc	ra,0x6
    800004ba:	8cc080e7          	jalr	-1844(ra) # 80005d82 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004be:	060a8663          	beqz	s5,8000052a <walk+0xa2>
    800004c2:	00000097          	auipc	ra,0x0
    800004c6:	c56080e7          	jalr	-938(ra) # 80000118 <kalloc>
    800004ca:	84aa                	mv	s1,a0
    800004cc:	c529                	beqz	a0,80000516 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004ce:	6605                	lui	a2,0x1
    800004d0:	4581                	li	a1,0
    800004d2:	00000097          	auipc	ra,0x0
    800004d6:	cca080e7          	jalr	-822(ra) # 8000019c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004da:	00c4d793          	srli	a5,s1,0xc
    800004de:	07aa                	slli	a5,a5,0xa
    800004e0:	0017e793          	ori	a5,a5,1
    800004e4:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004e8:	3a5d                	addiw	s4,s4,-9
    800004ea:	036a0063          	beq	s4,s6,8000050a <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004ee:	0149d933          	srl	s2,s3,s4
    800004f2:	1ff97913          	andi	s2,s2,511
    800004f6:	090e                	slli	s2,s2,0x3
    800004f8:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004fa:	00093483          	ld	s1,0(s2)
    800004fe:	0014f793          	andi	a5,s1,1
    80000502:	dfd5                	beqz	a5,800004be <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000504:	80a9                	srli	s1,s1,0xa
    80000506:	04b2                	slli	s1,s1,0xc
    80000508:	b7c5                	j	800004e8 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000050a:	00c9d513          	srli	a0,s3,0xc
    8000050e:	1ff57513          	andi	a0,a0,511
    80000512:	050e                	slli	a0,a0,0x3
    80000514:	9526                	add	a0,a0,s1
}
    80000516:	70e2                	ld	ra,56(sp)
    80000518:	7442                	ld	s0,48(sp)
    8000051a:	74a2                	ld	s1,40(sp)
    8000051c:	7902                	ld	s2,32(sp)
    8000051e:	69e2                	ld	s3,24(sp)
    80000520:	6a42                	ld	s4,16(sp)
    80000522:	6aa2                	ld	s5,8(sp)
    80000524:	6b02                	ld	s6,0(sp)
    80000526:	6121                	addi	sp,sp,64
    80000528:	8082                	ret
        return 0;
    8000052a:	4501                	li	a0,0
    8000052c:	b7ed                	j	80000516 <walk+0x8e>

000000008000052e <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000052e:	57fd                	li	a5,-1
    80000530:	83e9                	srli	a5,a5,0x1a
    80000532:	00b7f463          	bgeu	a5,a1,8000053a <walkaddr+0xc>
    return 0;
    80000536:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000538:	8082                	ret
{
    8000053a:	1141                	addi	sp,sp,-16
    8000053c:	e406                	sd	ra,8(sp)
    8000053e:	e022                	sd	s0,0(sp)
    80000540:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000542:	4601                	li	a2,0
    80000544:	00000097          	auipc	ra,0x0
    80000548:	f44080e7          	jalr	-188(ra) # 80000488 <walk>
  if(pte == 0)
    8000054c:	c105                	beqz	a0,8000056c <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000054e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000550:	0117f693          	andi	a3,a5,17
    80000554:	4745                	li	a4,17
    return 0;
    80000556:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000558:	00e68663          	beq	a3,a4,80000564 <walkaddr+0x36>
}
    8000055c:	60a2                	ld	ra,8(sp)
    8000055e:	6402                	ld	s0,0(sp)
    80000560:	0141                	addi	sp,sp,16
    80000562:	8082                	ret
  pa = PTE2PA(*pte);
    80000564:	00a7d513          	srli	a0,a5,0xa
    80000568:	0532                	slli	a0,a0,0xc
  return pa;
    8000056a:	bfcd                	j	8000055c <walkaddr+0x2e>
    return 0;
    8000056c:	4501                	li	a0,0
    8000056e:	b7fd                	j	8000055c <walkaddr+0x2e>

0000000080000570 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000570:	715d                	addi	sp,sp,-80
    80000572:	e486                	sd	ra,72(sp)
    80000574:	e0a2                	sd	s0,64(sp)
    80000576:	fc26                	sd	s1,56(sp)
    80000578:	f84a                	sd	s2,48(sp)
    8000057a:	f44e                	sd	s3,40(sp)
    8000057c:	f052                	sd	s4,32(sp)
    8000057e:	ec56                	sd	s5,24(sp)
    80000580:	e85a                	sd	s6,16(sp)
    80000582:	e45e                	sd	s7,8(sp)
    80000584:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000586:	03459793          	slli	a5,a1,0x34
    8000058a:	e385                	bnez	a5,800005aa <mappages+0x3a>
    8000058c:	8aaa                	mv	s5,a0
    8000058e:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80000590:	03461793          	slli	a5,a2,0x34
    80000594:	e39d                	bnez	a5,800005ba <mappages+0x4a>
    panic("mappages: size not aligned");

  if(size == 0)
    80000596:	ca15                	beqz	a2,800005ca <mappages+0x5a>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000598:	79fd                	lui	s3,0xfffff
    8000059a:	964e                	add	a2,a2,s3
    8000059c:	00b609b3          	add	s3,a2,a1
  a = va;
    800005a0:	892e                	mv	s2,a1
    800005a2:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005a6:	6b85                	lui	s7,0x1
    800005a8:	a091                	j	800005ec <mappages+0x7c>
    panic("mappages: va not aligned");
    800005aa:	00008517          	auipc	a0,0x8
    800005ae:	aae50513          	addi	a0,a0,-1362 # 80008058 <etext+0x58>
    800005b2:	00005097          	auipc	ra,0x5
    800005b6:	7d0080e7          	jalr	2000(ra) # 80005d82 <panic>
    panic("mappages: size not aligned");
    800005ba:	00008517          	auipc	a0,0x8
    800005be:	abe50513          	addi	a0,a0,-1346 # 80008078 <etext+0x78>
    800005c2:	00005097          	auipc	ra,0x5
    800005c6:	7c0080e7          	jalr	1984(ra) # 80005d82 <panic>
    panic("mappages: size");
    800005ca:	00008517          	auipc	a0,0x8
    800005ce:	ace50513          	addi	a0,a0,-1330 # 80008098 <etext+0x98>
    800005d2:	00005097          	auipc	ra,0x5
    800005d6:	7b0080e7          	jalr	1968(ra) # 80005d82 <panic>
      panic("mappages: remap");
    800005da:	00008517          	auipc	a0,0x8
    800005de:	ace50513          	addi	a0,a0,-1330 # 800080a8 <etext+0xa8>
    800005e2:	00005097          	auipc	ra,0x5
    800005e6:	7a0080e7          	jalr	1952(ra) # 80005d82 <panic>
    a += PGSIZE;
    800005ea:	995e                	add	s2,s2,s7
  for(;;){
    800005ec:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005f0:	4605                	li	a2,1
    800005f2:	85ca                	mv	a1,s2
    800005f4:	8556                	mv	a0,s5
    800005f6:	00000097          	auipc	ra,0x0
    800005fa:	e92080e7          	jalr	-366(ra) # 80000488 <walk>
    800005fe:	cd19                	beqz	a0,8000061c <mappages+0xac>
    if(*pte & PTE_V)
    80000600:	611c                	ld	a5,0(a0)
    80000602:	8b85                	andi	a5,a5,1
    80000604:	fbf9                	bnez	a5,800005da <mappages+0x6a>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000606:	80b1                	srli	s1,s1,0xc
    80000608:	04aa                	slli	s1,s1,0xa
    8000060a:	0164e4b3          	or	s1,s1,s6
    8000060e:	0014e493          	ori	s1,s1,1
    80000612:	e104                	sd	s1,0(a0)
    if(a == last)
    80000614:	fd391be3          	bne	s2,s3,800005ea <mappages+0x7a>
    pa += PGSIZE;
  }
  return 0;
    80000618:	4501                	li	a0,0
    8000061a:	a011                	j	8000061e <mappages+0xae>
      return -1;
    8000061c:	557d                	li	a0,-1
}
    8000061e:	60a6                	ld	ra,72(sp)
    80000620:	6406                	ld	s0,64(sp)
    80000622:	74e2                	ld	s1,56(sp)
    80000624:	7942                	ld	s2,48(sp)
    80000626:	79a2                	ld	s3,40(sp)
    80000628:	7a02                	ld	s4,32(sp)
    8000062a:	6ae2                	ld	s5,24(sp)
    8000062c:	6b42                	ld	s6,16(sp)
    8000062e:	6ba2                	ld	s7,8(sp)
    80000630:	6161                	addi	sp,sp,80
    80000632:	8082                	ret

0000000080000634 <kvmmap>:
{
    80000634:	1141                	addi	sp,sp,-16
    80000636:	e406                	sd	ra,8(sp)
    80000638:	e022                	sd	s0,0(sp)
    8000063a:	0800                	addi	s0,sp,16
    8000063c:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000063e:	86b2                	mv	a3,a2
    80000640:	863e                	mv	a2,a5
    80000642:	00000097          	auipc	ra,0x0
    80000646:	f2e080e7          	jalr	-210(ra) # 80000570 <mappages>
    8000064a:	e509                	bnez	a0,80000654 <kvmmap+0x20>
}
    8000064c:	60a2                	ld	ra,8(sp)
    8000064e:	6402                	ld	s0,0(sp)
    80000650:	0141                	addi	sp,sp,16
    80000652:	8082                	ret
    panic("kvmmap");
    80000654:	00008517          	auipc	a0,0x8
    80000658:	a6450513          	addi	a0,a0,-1436 # 800080b8 <etext+0xb8>
    8000065c:	00005097          	auipc	ra,0x5
    80000660:	726080e7          	jalr	1830(ra) # 80005d82 <panic>

0000000080000664 <kvmmake>:
{
    80000664:	1101                	addi	sp,sp,-32
    80000666:	ec06                	sd	ra,24(sp)
    80000668:	e822                	sd	s0,16(sp)
    8000066a:	e426                	sd	s1,8(sp)
    8000066c:	e04a                	sd	s2,0(sp)
    8000066e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000670:	00000097          	auipc	ra,0x0
    80000674:	aa8080e7          	jalr	-1368(ra) # 80000118 <kalloc>
    80000678:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000067a:	6605                	lui	a2,0x1
    8000067c:	4581                	li	a1,0
    8000067e:	00000097          	auipc	ra,0x0
    80000682:	b1e080e7          	jalr	-1250(ra) # 8000019c <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000686:	4719                	li	a4,6
    80000688:	6685                	lui	a3,0x1
    8000068a:	10000637          	lui	a2,0x10000
    8000068e:	100005b7          	lui	a1,0x10000
    80000692:	8526                	mv	a0,s1
    80000694:	00000097          	auipc	ra,0x0
    80000698:	fa0080e7          	jalr	-96(ra) # 80000634 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000069c:	4719                	li	a4,6
    8000069e:	6685                	lui	a3,0x1
    800006a0:	10001637          	lui	a2,0x10001
    800006a4:	100015b7          	lui	a1,0x10001
    800006a8:	8526                	mv	a0,s1
    800006aa:	00000097          	auipc	ra,0x0
    800006ae:	f8a080e7          	jalr	-118(ra) # 80000634 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006b2:	4719                	li	a4,6
    800006b4:	004006b7          	lui	a3,0x400
    800006b8:	0c000637          	lui	a2,0xc000
    800006bc:	0c0005b7          	lui	a1,0xc000
    800006c0:	8526                	mv	a0,s1
    800006c2:	00000097          	auipc	ra,0x0
    800006c6:	f72080e7          	jalr	-142(ra) # 80000634 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006ca:	00008917          	auipc	s2,0x8
    800006ce:	93690913          	addi	s2,s2,-1738 # 80008000 <etext>
    800006d2:	4729                	li	a4,10
    800006d4:	80008697          	auipc	a3,0x80008
    800006d8:	92c68693          	addi	a3,a3,-1748 # 8000 <_entry-0x7fff8000>
    800006dc:	4605                	li	a2,1
    800006de:	067e                	slli	a2,a2,0x1f
    800006e0:	85b2                	mv	a1,a2
    800006e2:	8526                	mv	a0,s1
    800006e4:	00000097          	auipc	ra,0x0
    800006e8:	f50080e7          	jalr	-176(ra) # 80000634 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006ec:	4719                	li	a4,6
    800006ee:	46c5                	li	a3,17
    800006f0:	06ee                	slli	a3,a3,0x1b
    800006f2:	412686b3          	sub	a3,a3,s2
    800006f6:	864a                	mv	a2,s2
    800006f8:	85ca                	mv	a1,s2
    800006fa:	8526                	mv	a0,s1
    800006fc:	00000097          	auipc	ra,0x0
    80000700:	f38080e7          	jalr	-200(ra) # 80000634 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000704:	4729                	li	a4,10
    80000706:	6685                	lui	a3,0x1
    80000708:	00007617          	auipc	a2,0x7
    8000070c:	8f860613          	addi	a2,a2,-1800 # 80007000 <_trampoline>
    80000710:	040005b7          	lui	a1,0x4000
    80000714:	15fd                	addi	a1,a1,-1
    80000716:	05b2                	slli	a1,a1,0xc
    80000718:	8526                	mv	a0,s1
    8000071a:	00000097          	auipc	ra,0x0
    8000071e:	f1a080e7          	jalr	-230(ra) # 80000634 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000722:	8526                	mv	a0,s1
    80000724:	00000097          	auipc	ra,0x0
    80000728:	63a080e7          	jalr	1594(ra) # 80000d5e <proc_mapstacks>
}
    8000072c:	8526                	mv	a0,s1
    8000072e:	60e2                	ld	ra,24(sp)
    80000730:	6442                	ld	s0,16(sp)
    80000732:	64a2                	ld	s1,8(sp)
    80000734:	6902                	ld	s2,0(sp)
    80000736:	6105                	addi	sp,sp,32
    80000738:	8082                	ret

000000008000073a <kvminit>:
{
    8000073a:	1141                	addi	sp,sp,-16
    8000073c:	e406                	sd	ra,8(sp)
    8000073e:	e022                	sd	s0,0(sp)
    80000740:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000742:	00000097          	auipc	ra,0x0
    80000746:	f22080e7          	jalr	-222(ra) # 80000664 <kvmmake>
    8000074a:	00008797          	auipc	a5,0x8
    8000074e:	3ca7bf23          	sd	a0,990(a5) # 80008b28 <kernel_pagetable>
}
    80000752:	60a2                	ld	ra,8(sp)
    80000754:	6402                	ld	s0,0(sp)
    80000756:	0141                	addi	sp,sp,16
    80000758:	8082                	ret

000000008000075a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000075a:	715d                	addi	sp,sp,-80
    8000075c:	e486                	sd	ra,72(sp)
    8000075e:	e0a2                	sd	s0,64(sp)
    80000760:	fc26                	sd	s1,56(sp)
    80000762:	f84a                	sd	s2,48(sp)
    80000764:	f44e                	sd	s3,40(sp)
    80000766:	f052                	sd	s4,32(sp)
    80000768:	ec56                	sd	s5,24(sp)
    8000076a:	e85a                	sd	s6,16(sp)
    8000076c:	e45e                	sd	s7,8(sp)
    8000076e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000770:	03459793          	slli	a5,a1,0x34
    80000774:	e795                	bnez	a5,800007a0 <uvmunmap+0x46>
    80000776:	8a2a                	mv	s4,a0
    80000778:	892e                	mv	s2,a1
    8000077a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077c:	0632                	slli	a2,a2,0xc
    8000077e:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000782:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000784:	6b05                	lui	s6,0x1
    80000786:	0735e863          	bltu	a1,s3,800007f6 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000078a:	60a6                	ld	ra,72(sp)
    8000078c:	6406                	ld	s0,64(sp)
    8000078e:	74e2                	ld	s1,56(sp)
    80000790:	7942                	ld	s2,48(sp)
    80000792:	79a2                	ld	s3,40(sp)
    80000794:	7a02                	ld	s4,32(sp)
    80000796:	6ae2                	ld	s5,24(sp)
    80000798:	6b42                	ld	s6,16(sp)
    8000079a:	6ba2                	ld	s7,8(sp)
    8000079c:	6161                	addi	sp,sp,80
    8000079e:	8082                	ret
    panic("uvmunmap: not aligned");
    800007a0:	00008517          	auipc	a0,0x8
    800007a4:	92050513          	addi	a0,a0,-1760 # 800080c0 <etext+0xc0>
    800007a8:	00005097          	auipc	ra,0x5
    800007ac:	5da080e7          	jalr	1498(ra) # 80005d82 <panic>
      panic("uvmunmap: walk");
    800007b0:	00008517          	auipc	a0,0x8
    800007b4:	92850513          	addi	a0,a0,-1752 # 800080d8 <etext+0xd8>
    800007b8:	00005097          	auipc	ra,0x5
    800007bc:	5ca080e7          	jalr	1482(ra) # 80005d82 <panic>
      panic("uvmunmap: not mapped");
    800007c0:	00008517          	auipc	a0,0x8
    800007c4:	92850513          	addi	a0,a0,-1752 # 800080e8 <etext+0xe8>
    800007c8:	00005097          	auipc	ra,0x5
    800007cc:	5ba080e7          	jalr	1466(ra) # 80005d82 <panic>
      panic("uvmunmap: not a leaf");
    800007d0:	00008517          	auipc	a0,0x8
    800007d4:	93050513          	addi	a0,a0,-1744 # 80008100 <etext+0x100>
    800007d8:	00005097          	auipc	ra,0x5
    800007dc:	5aa080e7          	jalr	1450(ra) # 80005d82 <panic>
      uint64 pa = PTE2PA(*pte);
    800007e0:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007e2:	0532                	slli	a0,a0,0xc
    800007e4:	00000097          	auipc	ra,0x0
    800007e8:	838080e7          	jalr	-1992(ra) # 8000001c <kfree>
    *pte = 0;
    800007ec:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007f0:	995a                	add	s2,s2,s6
    800007f2:	f9397ce3          	bgeu	s2,s3,8000078a <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007f6:	4601                	li	a2,0
    800007f8:	85ca                	mv	a1,s2
    800007fa:	8552                	mv	a0,s4
    800007fc:	00000097          	auipc	ra,0x0
    80000800:	c8c080e7          	jalr	-884(ra) # 80000488 <walk>
    80000804:	84aa                	mv	s1,a0
    80000806:	d54d                	beqz	a0,800007b0 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80000808:	6108                	ld	a0,0(a0)
    8000080a:	00157793          	andi	a5,a0,1
    8000080e:	dbcd                	beqz	a5,800007c0 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000810:	3ff57793          	andi	a5,a0,1023
    80000814:	fb778ee3          	beq	a5,s7,800007d0 <uvmunmap+0x76>
    if(do_free){
    80000818:	fc0a8ae3          	beqz	s5,800007ec <uvmunmap+0x92>
    8000081c:	b7d1                	j	800007e0 <uvmunmap+0x86>

000000008000081e <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000081e:	1101                	addi	sp,sp,-32
    80000820:	ec06                	sd	ra,24(sp)
    80000822:	e822                	sd	s0,16(sp)
    80000824:	e426                	sd	s1,8(sp)
    80000826:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000828:	00000097          	auipc	ra,0x0
    8000082c:	8f0080e7          	jalr	-1808(ra) # 80000118 <kalloc>
    80000830:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000832:	c519                	beqz	a0,80000840 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000834:	6605                	lui	a2,0x1
    80000836:	4581                	li	a1,0
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	964080e7          	jalr	-1692(ra) # 8000019c <memset>
  return pagetable;
}
    80000840:	8526                	mv	a0,s1
    80000842:	60e2                	ld	ra,24(sp)
    80000844:	6442                	ld	s0,16(sp)
    80000846:	64a2                	ld	s1,8(sp)
    80000848:	6105                	addi	sp,sp,32
    8000084a:	8082                	ret

000000008000084c <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000084c:	7179                	addi	sp,sp,-48
    8000084e:	f406                	sd	ra,40(sp)
    80000850:	f022                	sd	s0,32(sp)
    80000852:	ec26                	sd	s1,24(sp)
    80000854:	e84a                	sd	s2,16(sp)
    80000856:	e44e                	sd	s3,8(sp)
    80000858:	e052                	sd	s4,0(sp)
    8000085a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000085c:	6785                	lui	a5,0x1
    8000085e:	04f67863          	bgeu	a2,a5,800008ae <uvmfirst+0x62>
    80000862:	8a2a                	mv	s4,a0
    80000864:	89ae                	mv	s3,a1
    80000866:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000868:	00000097          	auipc	ra,0x0
    8000086c:	8b0080e7          	jalr	-1872(ra) # 80000118 <kalloc>
    80000870:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000872:	6605                	lui	a2,0x1
    80000874:	4581                	li	a1,0
    80000876:	00000097          	auipc	ra,0x0
    8000087a:	926080e7          	jalr	-1754(ra) # 8000019c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000087e:	4779                	li	a4,30
    80000880:	86ca                	mv	a3,s2
    80000882:	6605                	lui	a2,0x1
    80000884:	4581                	li	a1,0
    80000886:	8552                	mv	a0,s4
    80000888:	00000097          	auipc	ra,0x0
    8000088c:	ce8080e7          	jalr	-792(ra) # 80000570 <mappages>
  memmove(mem, src, sz);
    80000890:	8626                	mv	a2,s1
    80000892:	85ce                	mv	a1,s3
    80000894:	854a                	mv	a0,s2
    80000896:	00000097          	auipc	ra,0x0
    8000089a:	966080e7          	jalr	-1690(ra) # 800001fc <memmove>
}
    8000089e:	70a2                	ld	ra,40(sp)
    800008a0:	7402                	ld	s0,32(sp)
    800008a2:	64e2                	ld	s1,24(sp)
    800008a4:	6942                	ld	s2,16(sp)
    800008a6:	69a2                	ld	s3,8(sp)
    800008a8:	6a02                	ld	s4,0(sp)
    800008aa:	6145                	addi	sp,sp,48
    800008ac:	8082                	ret
    panic("uvmfirst: more than a page");
    800008ae:	00008517          	auipc	a0,0x8
    800008b2:	86a50513          	addi	a0,a0,-1942 # 80008118 <etext+0x118>
    800008b6:	00005097          	auipc	ra,0x5
    800008ba:	4cc080e7          	jalr	1228(ra) # 80005d82 <panic>

00000000800008be <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008be:	1101                	addi	sp,sp,-32
    800008c0:	ec06                	sd	ra,24(sp)
    800008c2:	e822                	sd	s0,16(sp)
    800008c4:	e426                	sd	s1,8(sp)
    800008c6:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008c8:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008ca:	00b67d63          	bgeu	a2,a1,800008e4 <uvmdealloc+0x26>
    800008ce:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008d0:	6785                	lui	a5,0x1
    800008d2:	17fd                	addi	a5,a5,-1
    800008d4:	00f60733          	add	a4,a2,a5
    800008d8:	767d                	lui	a2,0xfffff
    800008da:	8f71                	and	a4,a4,a2
    800008dc:	97ae                	add	a5,a5,a1
    800008de:	8ff1                	and	a5,a5,a2
    800008e0:	00f76863          	bltu	a4,a5,800008f0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008e4:	8526                	mv	a0,s1
    800008e6:	60e2                	ld	ra,24(sp)
    800008e8:	6442                	ld	s0,16(sp)
    800008ea:	64a2                	ld	s1,8(sp)
    800008ec:	6105                	addi	sp,sp,32
    800008ee:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008f0:	8f99                	sub	a5,a5,a4
    800008f2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008f4:	4685                	li	a3,1
    800008f6:	0007861b          	sext.w	a2,a5
    800008fa:	85ba                	mv	a1,a4
    800008fc:	00000097          	auipc	ra,0x0
    80000900:	e5e080e7          	jalr	-418(ra) # 8000075a <uvmunmap>
    80000904:	b7c5                	j	800008e4 <uvmdealloc+0x26>

0000000080000906 <uvmalloc>:
  if(newsz < oldsz)
    80000906:	0ab66563          	bltu	a2,a1,800009b0 <uvmalloc+0xaa>
{
    8000090a:	7139                	addi	sp,sp,-64
    8000090c:	fc06                	sd	ra,56(sp)
    8000090e:	f822                	sd	s0,48(sp)
    80000910:	f426                	sd	s1,40(sp)
    80000912:	f04a                	sd	s2,32(sp)
    80000914:	ec4e                	sd	s3,24(sp)
    80000916:	e852                	sd	s4,16(sp)
    80000918:	e456                	sd	s5,8(sp)
    8000091a:	e05a                	sd	s6,0(sp)
    8000091c:	0080                	addi	s0,sp,64
    8000091e:	8aaa                	mv	s5,a0
    80000920:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000922:	6985                	lui	s3,0x1
    80000924:	19fd                	addi	s3,s3,-1
    80000926:	95ce                	add	a1,a1,s3
    80000928:	79fd                	lui	s3,0xfffff
    8000092a:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000092e:	08c9f363          	bgeu	s3,a2,800009b4 <uvmalloc+0xae>
    80000932:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000934:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000938:	fffff097          	auipc	ra,0xfffff
    8000093c:	7e0080e7          	jalr	2016(ra) # 80000118 <kalloc>
    80000940:	84aa                	mv	s1,a0
    if(mem == 0){
    80000942:	c51d                	beqz	a0,80000970 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000944:	6605                	lui	a2,0x1
    80000946:	4581                	li	a1,0
    80000948:	00000097          	auipc	ra,0x0
    8000094c:	854080e7          	jalr	-1964(ra) # 8000019c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000950:	875a                	mv	a4,s6
    80000952:	86a6                	mv	a3,s1
    80000954:	6605                	lui	a2,0x1
    80000956:	85ca                	mv	a1,s2
    80000958:	8556                	mv	a0,s5
    8000095a:	00000097          	auipc	ra,0x0
    8000095e:	c16080e7          	jalr	-1002(ra) # 80000570 <mappages>
    80000962:	e90d                	bnez	a0,80000994 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000964:	6785                	lui	a5,0x1
    80000966:	993e                	add	s2,s2,a5
    80000968:	fd4968e3          	bltu	s2,s4,80000938 <uvmalloc+0x32>
  return newsz;
    8000096c:	8552                	mv	a0,s4
    8000096e:	a809                	j	80000980 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000970:	864e                	mv	a2,s3
    80000972:	85ca                	mv	a1,s2
    80000974:	8556                	mv	a0,s5
    80000976:	00000097          	auipc	ra,0x0
    8000097a:	f48080e7          	jalr	-184(ra) # 800008be <uvmdealloc>
      return 0;
    8000097e:	4501                	li	a0,0
}
    80000980:	70e2                	ld	ra,56(sp)
    80000982:	7442                	ld	s0,48(sp)
    80000984:	74a2                	ld	s1,40(sp)
    80000986:	7902                	ld	s2,32(sp)
    80000988:	69e2                	ld	s3,24(sp)
    8000098a:	6a42                	ld	s4,16(sp)
    8000098c:	6aa2                	ld	s5,8(sp)
    8000098e:	6b02                	ld	s6,0(sp)
    80000990:	6121                	addi	sp,sp,64
    80000992:	8082                	ret
      kfree(mem);
    80000994:	8526                	mv	a0,s1
    80000996:	fffff097          	auipc	ra,0xfffff
    8000099a:	686080e7          	jalr	1670(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000099e:	864e                	mv	a2,s3
    800009a0:	85ca                	mv	a1,s2
    800009a2:	8556                	mv	a0,s5
    800009a4:	00000097          	auipc	ra,0x0
    800009a8:	f1a080e7          	jalr	-230(ra) # 800008be <uvmdealloc>
      return 0;
    800009ac:	4501                	li	a0,0
    800009ae:	bfc9                	j	80000980 <uvmalloc+0x7a>
    return oldsz;
    800009b0:	852e                	mv	a0,a1
}
    800009b2:	8082                	ret
  return newsz;
    800009b4:	8532                	mv	a0,a2
    800009b6:	b7e9                	j	80000980 <uvmalloc+0x7a>

00000000800009b8 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009b8:	7179                	addi	sp,sp,-48
    800009ba:	f406                	sd	ra,40(sp)
    800009bc:	f022                	sd	s0,32(sp)
    800009be:	ec26                	sd	s1,24(sp)
    800009c0:	e84a                	sd	s2,16(sp)
    800009c2:	e44e                	sd	s3,8(sp)
    800009c4:	e052                	sd	s4,0(sp)
    800009c6:	1800                	addi	s0,sp,48
    800009c8:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009ca:	84aa                	mv	s1,a0
    800009cc:	6905                	lui	s2,0x1
    800009ce:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009d0:	4985                	li	s3,1
    800009d2:	a821                	j	800009ea <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009d4:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009d6:	0532                	slli	a0,a0,0xc
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	fe0080e7          	jalr	-32(ra) # 800009b8 <freewalk>
      pagetable[i] = 0;
    800009e0:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009e4:	04a1                	addi	s1,s1,8
    800009e6:	03248163          	beq	s1,s2,80000a08 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009ea:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ec:	00f57793          	andi	a5,a0,15
    800009f0:	ff3782e3          	beq	a5,s3,800009d4 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009f4:	8905                	andi	a0,a0,1
    800009f6:	d57d                	beqz	a0,800009e4 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009f8:	00007517          	auipc	a0,0x7
    800009fc:	74050513          	addi	a0,a0,1856 # 80008138 <etext+0x138>
    80000a00:	00005097          	auipc	ra,0x5
    80000a04:	382080e7          	jalr	898(ra) # 80005d82 <panic>
    }
  }
  kfree((void*)pagetable);
    80000a08:	8552                	mv	a0,s4
    80000a0a:	fffff097          	auipc	ra,0xfffff
    80000a0e:	612080e7          	jalr	1554(ra) # 8000001c <kfree>
}
    80000a12:	70a2                	ld	ra,40(sp)
    80000a14:	7402                	ld	s0,32(sp)
    80000a16:	64e2                	ld	s1,24(sp)
    80000a18:	6942                	ld	s2,16(sp)
    80000a1a:	69a2                	ld	s3,8(sp)
    80000a1c:	6a02                	ld	s4,0(sp)
    80000a1e:	6145                	addi	sp,sp,48
    80000a20:	8082                	ret

0000000080000a22 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a22:	1101                	addi	sp,sp,-32
    80000a24:	ec06                	sd	ra,24(sp)
    80000a26:	e822                	sd	s0,16(sp)
    80000a28:	e426                	sd	s1,8(sp)
    80000a2a:	1000                	addi	s0,sp,32
    80000a2c:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a2e:	e999                	bnez	a1,80000a44 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a30:	8526                	mv	a0,s1
    80000a32:	00000097          	auipc	ra,0x0
    80000a36:	f86080e7          	jalr	-122(ra) # 800009b8 <freewalk>
}
    80000a3a:	60e2                	ld	ra,24(sp)
    80000a3c:	6442                	ld	s0,16(sp)
    80000a3e:	64a2                	ld	s1,8(sp)
    80000a40:	6105                	addi	sp,sp,32
    80000a42:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a44:	6605                	lui	a2,0x1
    80000a46:	167d                	addi	a2,a2,-1
    80000a48:	962e                	add	a2,a2,a1
    80000a4a:	4685                	li	a3,1
    80000a4c:	8231                	srli	a2,a2,0xc
    80000a4e:	4581                	li	a1,0
    80000a50:	00000097          	auipc	ra,0x0
    80000a54:	d0a080e7          	jalr	-758(ra) # 8000075a <uvmunmap>
    80000a58:	bfe1                	j	80000a30 <uvmfree+0xe>

0000000080000a5a <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a5a:	c679                	beqz	a2,80000b28 <uvmcopy+0xce>
{
    80000a5c:	715d                	addi	sp,sp,-80
    80000a5e:	e486                	sd	ra,72(sp)
    80000a60:	e0a2                	sd	s0,64(sp)
    80000a62:	fc26                	sd	s1,56(sp)
    80000a64:	f84a                	sd	s2,48(sp)
    80000a66:	f44e                	sd	s3,40(sp)
    80000a68:	f052                	sd	s4,32(sp)
    80000a6a:	ec56                	sd	s5,24(sp)
    80000a6c:	e85a                	sd	s6,16(sp)
    80000a6e:	e45e                	sd	s7,8(sp)
    80000a70:	0880                	addi	s0,sp,80
    80000a72:	8b2a                	mv	s6,a0
    80000a74:	8aae                	mv	s5,a1
    80000a76:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a78:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a7a:	4601                	li	a2,0
    80000a7c:	85ce                	mv	a1,s3
    80000a7e:	855a                	mv	a0,s6
    80000a80:	00000097          	auipc	ra,0x0
    80000a84:	a08080e7          	jalr	-1528(ra) # 80000488 <walk>
    80000a88:	c531                	beqz	a0,80000ad4 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a8a:	6118                	ld	a4,0(a0)
    80000a8c:	00177793          	andi	a5,a4,1
    80000a90:	cbb1                	beqz	a5,80000ae4 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a92:	00a75593          	srli	a1,a4,0xa
    80000a96:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a9a:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a9e:	fffff097          	auipc	ra,0xfffff
    80000aa2:	67a080e7          	jalr	1658(ra) # 80000118 <kalloc>
    80000aa6:	892a                	mv	s2,a0
    80000aa8:	c939                	beqz	a0,80000afe <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000aaa:	6605                	lui	a2,0x1
    80000aac:	85de                	mv	a1,s7
    80000aae:	fffff097          	auipc	ra,0xfffff
    80000ab2:	74e080e7          	jalr	1870(ra) # 800001fc <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000ab6:	8726                	mv	a4,s1
    80000ab8:	86ca                	mv	a3,s2
    80000aba:	6605                	lui	a2,0x1
    80000abc:	85ce                	mv	a1,s3
    80000abe:	8556                	mv	a0,s5
    80000ac0:	00000097          	auipc	ra,0x0
    80000ac4:	ab0080e7          	jalr	-1360(ra) # 80000570 <mappages>
    80000ac8:	e515                	bnez	a0,80000af4 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000aca:	6785                	lui	a5,0x1
    80000acc:	99be                	add	s3,s3,a5
    80000ace:	fb49e6e3          	bltu	s3,s4,80000a7a <uvmcopy+0x20>
    80000ad2:	a081                	j	80000b12 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ad4:	00007517          	auipc	a0,0x7
    80000ad8:	67450513          	addi	a0,a0,1652 # 80008148 <etext+0x148>
    80000adc:	00005097          	auipc	ra,0x5
    80000ae0:	2a6080e7          	jalr	678(ra) # 80005d82 <panic>
      panic("uvmcopy: page not present");
    80000ae4:	00007517          	auipc	a0,0x7
    80000ae8:	68450513          	addi	a0,a0,1668 # 80008168 <etext+0x168>
    80000aec:	00005097          	auipc	ra,0x5
    80000af0:	296080e7          	jalr	662(ra) # 80005d82 <panic>
      kfree(mem);
    80000af4:	854a                	mv	a0,s2
    80000af6:	fffff097          	auipc	ra,0xfffff
    80000afa:	526080e7          	jalr	1318(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000afe:	4685                	li	a3,1
    80000b00:	00c9d613          	srli	a2,s3,0xc
    80000b04:	4581                	li	a1,0
    80000b06:	8556                	mv	a0,s5
    80000b08:	00000097          	auipc	ra,0x0
    80000b0c:	c52080e7          	jalr	-942(ra) # 8000075a <uvmunmap>
  return -1;
    80000b10:	557d                	li	a0,-1
}
    80000b12:	60a6                	ld	ra,72(sp)
    80000b14:	6406                	ld	s0,64(sp)
    80000b16:	74e2                	ld	s1,56(sp)
    80000b18:	7942                	ld	s2,48(sp)
    80000b1a:	79a2                	ld	s3,40(sp)
    80000b1c:	7a02                	ld	s4,32(sp)
    80000b1e:	6ae2                	ld	s5,24(sp)
    80000b20:	6b42                	ld	s6,16(sp)
    80000b22:	6ba2                	ld	s7,8(sp)
    80000b24:	6161                	addi	sp,sp,80
    80000b26:	8082                	ret
  return 0;
    80000b28:	4501                	li	a0,0
}
    80000b2a:	8082                	ret

0000000080000b2c <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b2c:	1141                	addi	sp,sp,-16
    80000b2e:	e406                	sd	ra,8(sp)
    80000b30:	e022                	sd	s0,0(sp)
    80000b32:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b34:	4601                	li	a2,0
    80000b36:	00000097          	auipc	ra,0x0
    80000b3a:	952080e7          	jalr	-1710(ra) # 80000488 <walk>
  if(pte == 0)
    80000b3e:	c901                	beqz	a0,80000b4e <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b40:	611c                	ld	a5,0(a0)
    80000b42:	9bbd                	andi	a5,a5,-17
    80000b44:	e11c                	sd	a5,0(a0)
}
    80000b46:	60a2                	ld	ra,8(sp)
    80000b48:	6402                	ld	s0,0(sp)
    80000b4a:	0141                	addi	sp,sp,16
    80000b4c:	8082                	ret
    panic("uvmclear");
    80000b4e:	00007517          	auipc	a0,0x7
    80000b52:	63a50513          	addi	a0,a0,1594 # 80008188 <etext+0x188>
    80000b56:	00005097          	auipc	ra,0x5
    80000b5a:	22c080e7          	jalr	556(ra) # 80005d82 <panic>

0000000080000b5e <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000b5e:	cac9                	beqz	a3,80000bf0 <copyout+0x92>
{
    80000b60:	711d                	addi	sp,sp,-96
    80000b62:	ec86                	sd	ra,88(sp)
    80000b64:	e8a2                	sd	s0,80(sp)
    80000b66:	e4a6                	sd	s1,72(sp)
    80000b68:	e0ca                	sd	s2,64(sp)
    80000b6a:	fc4e                	sd	s3,56(sp)
    80000b6c:	f852                	sd	s4,48(sp)
    80000b6e:	f456                	sd	s5,40(sp)
    80000b70:	f05a                	sd	s6,32(sp)
    80000b72:	ec5e                	sd	s7,24(sp)
    80000b74:	e862                	sd	s8,16(sp)
    80000b76:	e466                	sd	s9,8(sp)
    80000b78:	e06a                	sd	s10,0(sp)
    80000b7a:	1080                	addi	s0,sp,96
    80000b7c:	8baa                	mv	s7,a0
    80000b7e:	8aae                	mv	s5,a1
    80000b80:	8b32                	mv	s6,a2
    80000b82:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b84:	74fd                	lui	s1,0xfffff
    80000b86:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000b88:	57fd                	li	a5,-1
    80000b8a:	83e9                	srli	a5,a5,0x1a
    80000b8c:	0697e463          	bltu	a5,s1,80000bf4 <copyout+0x96>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000b90:	4cd5                	li	s9,21
    80000b92:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000b94:	8c3e                	mv	s8,a5
    80000b96:	a035                	j	80000bc2 <copyout+0x64>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000b98:	83a9                	srli	a5,a5,0xa
    80000b9a:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b9c:	409a8533          	sub	a0,s5,s1
    80000ba0:	0009061b          	sext.w	a2,s2
    80000ba4:	85da                	mv	a1,s6
    80000ba6:	953e                	add	a0,a0,a5
    80000ba8:	fffff097          	auipc	ra,0xfffff
    80000bac:	654080e7          	jalr	1620(ra) # 800001fc <memmove>

    len -= n;
    80000bb0:	412989b3          	sub	s3,s3,s2
    src += n;
    80000bb4:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000bb6:	02098b63          	beqz	s3,80000bec <copyout+0x8e>
    if(va0 >= MAXVA)
    80000bba:	034c6f63          	bltu	s8,s4,80000bf8 <copyout+0x9a>
    va0 = PGROUNDDOWN(dstva);
    80000bbe:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    80000bc0:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000bc2:	4601                	li	a2,0
    80000bc4:	85a6                	mv	a1,s1
    80000bc6:	855e                	mv	a0,s7
    80000bc8:	00000097          	auipc	ra,0x0
    80000bcc:	8c0080e7          	jalr	-1856(ra) # 80000488 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000bd0:	c515                	beqz	a0,80000bfc <copyout+0x9e>
    80000bd2:	611c                	ld	a5,0(a0)
    80000bd4:	0157f713          	andi	a4,a5,21
    80000bd8:	05971163          	bne	a4,s9,80000c1a <copyout+0xbc>
    n = PGSIZE - (dstva - va0);
    80000bdc:	01a48a33          	add	s4,s1,s10
    80000be0:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000be4:	fb29fae3          	bgeu	s3,s2,80000b98 <copyout+0x3a>
    80000be8:	894e                	mv	s2,s3
    80000bea:	b77d                	j	80000b98 <copyout+0x3a>
  }
  return 0;
    80000bec:	4501                	li	a0,0
    80000bee:	a801                	j	80000bfe <copyout+0xa0>
    80000bf0:	4501                	li	a0,0
}
    80000bf2:	8082                	ret
      return -1;
    80000bf4:	557d                	li	a0,-1
    80000bf6:	a021                	j	80000bfe <copyout+0xa0>
    80000bf8:	557d                	li	a0,-1
    80000bfa:	a011                	j	80000bfe <copyout+0xa0>
      return -1;
    80000bfc:	557d                	li	a0,-1
}
    80000bfe:	60e6                	ld	ra,88(sp)
    80000c00:	6446                	ld	s0,80(sp)
    80000c02:	64a6                	ld	s1,72(sp)
    80000c04:	6906                	ld	s2,64(sp)
    80000c06:	79e2                	ld	s3,56(sp)
    80000c08:	7a42                	ld	s4,48(sp)
    80000c0a:	7aa2                	ld	s5,40(sp)
    80000c0c:	7b02                	ld	s6,32(sp)
    80000c0e:	6be2                	ld	s7,24(sp)
    80000c10:	6c42                	ld	s8,16(sp)
    80000c12:	6ca2                	ld	s9,8(sp)
    80000c14:	6d02                	ld	s10,0(sp)
    80000c16:	6125                	addi	sp,sp,96
    80000c18:	8082                	ret
      return -1;
    80000c1a:	557d                	li	a0,-1
    80000c1c:	b7cd                	j	80000bfe <copyout+0xa0>

0000000080000c1e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c1e:	c6bd                	beqz	a3,80000c8c <copyin+0x6e>
{
    80000c20:	715d                	addi	sp,sp,-80
    80000c22:	e486                	sd	ra,72(sp)
    80000c24:	e0a2                	sd	s0,64(sp)
    80000c26:	fc26                	sd	s1,56(sp)
    80000c28:	f84a                	sd	s2,48(sp)
    80000c2a:	f44e                	sd	s3,40(sp)
    80000c2c:	f052                	sd	s4,32(sp)
    80000c2e:	ec56                	sd	s5,24(sp)
    80000c30:	e85a                	sd	s6,16(sp)
    80000c32:	e45e                	sd	s7,8(sp)
    80000c34:	e062                	sd	s8,0(sp)
    80000c36:	0880                	addi	s0,sp,80
    80000c38:	8b2a                	mv	s6,a0
    80000c3a:	8a2e                	mv	s4,a1
    80000c3c:	8c32                	mv	s8,a2
    80000c3e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c40:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c42:	6a85                	lui	s5,0x1
    80000c44:	a015                	j	80000c68 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c46:	9562                	add	a0,a0,s8
    80000c48:	0004861b          	sext.w	a2,s1
    80000c4c:	412505b3          	sub	a1,a0,s2
    80000c50:	8552                	mv	a0,s4
    80000c52:	fffff097          	auipc	ra,0xfffff
    80000c56:	5aa080e7          	jalr	1450(ra) # 800001fc <memmove>

    len -= n;
    80000c5a:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c5e:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c60:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c64:	02098263          	beqz	s3,80000c88 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c68:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c6c:	85ca                	mv	a1,s2
    80000c6e:	855a                	mv	a0,s6
    80000c70:	00000097          	auipc	ra,0x0
    80000c74:	8be080e7          	jalr	-1858(ra) # 8000052e <walkaddr>
    if(pa0 == 0)
    80000c78:	cd01                	beqz	a0,80000c90 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c7a:	418904b3          	sub	s1,s2,s8
    80000c7e:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c80:	fc99f3e3          	bgeu	s3,s1,80000c46 <copyin+0x28>
    80000c84:	84ce                	mv	s1,s3
    80000c86:	b7c1                	j	80000c46 <copyin+0x28>
  }
  return 0;
    80000c88:	4501                	li	a0,0
    80000c8a:	a021                	j	80000c92 <copyin+0x74>
    80000c8c:	4501                	li	a0,0
}
    80000c8e:	8082                	ret
      return -1;
    80000c90:	557d                	li	a0,-1
}
    80000c92:	60a6                	ld	ra,72(sp)
    80000c94:	6406                	ld	s0,64(sp)
    80000c96:	74e2                	ld	s1,56(sp)
    80000c98:	7942                	ld	s2,48(sp)
    80000c9a:	79a2                	ld	s3,40(sp)
    80000c9c:	7a02                	ld	s4,32(sp)
    80000c9e:	6ae2                	ld	s5,24(sp)
    80000ca0:	6b42                	ld	s6,16(sp)
    80000ca2:	6ba2                	ld	s7,8(sp)
    80000ca4:	6c02                	ld	s8,0(sp)
    80000ca6:	6161                	addi	sp,sp,80
    80000ca8:	8082                	ret

0000000080000caa <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000caa:	c6c5                	beqz	a3,80000d52 <copyinstr+0xa8>
{
    80000cac:	715d                	addi	sp,sp,-80
    80000cae:	e486                	sd	ra,72(sp)
    80000cb0:	e0a2                	sd	s0,64(sp)
    80000cb2:	fc26                	sd	s1,56(sp)
    80000cb4:	f84a                	sd	s2,48(sp)
    80000cb6:	f44e                	sd	s3,40(sp)
    80000cb8:	f052                	sd	s4,32(sp)
    80000cba:	ec56                	sd	s5,24(sp)
    80000cbc:	e85a                	sd	s6,16(sp)
    80000cbe:	e45e                	sd	s7,8(sp)
    80000cc0:	0880                	addi	s0,sp,80
    80000cc2:	8a2a                	mv	s4,a0
    80000cc4:	8b2e                	mv	s6,a1
    80000cc6:	8bb2                	mv	s7,a2
    80000cc8:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000cca:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ccc:	6985                	lui	s3,0x1
    80000cce:	a035                	j	80000cfa <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000cd0:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000cd4:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000cd6:	0017b793          	seqz	a5,a5
    80000cda:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cde:	60a6                	ld	ra,72(sp)
    80000ce0:	6406                	ld	s0,64(sp)
    80000ce2:	74e2                	ld	s1,56(sp)
    80000ce4:	7942                	ld	s2,48(sp)
    80000ce6:	79a2                	ld	s3,40(sp)
    80000ce8:	7a02                	ld	s4,32(sp)
    80000cea:	6ae2                	ld	s5,24(sp)
    80000cec:	6b42                	ld	s6,16(sp)
    80000cee:	6ba2                	ld	s7,8(sp)
    80000cf0:	6161                	addi	sp,sp,80
    80000cf2:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cf4:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cf8:	c8a9                	beqz	s1,80000d4a <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cfa:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cfe:	85ca                	mv	a1,s2
    80000d00:	8552                	mv	a0,s4
    80000d02:	00000097          	auipc	ra,0x0
    80000d06:	82c080e7          	jalr	-2004(ra) # 8000052e <walkaddr>
    if(pa0 == 0)
    80000d0a:	c131                	beqz	a0,80000d4e <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000d0c:	41790833          	sub	a6,s2,s7
    80000d10:	984e                	add	a6,a6,s3
    if(n > max)
    80000d12:	0104f363          	bgeu	s1,a6,80000d18 <copyinstr+0x6e>
    80000d16:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000d18:	955e                	add	a0,a0,s7
    80000d1a:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000d1e:	fc080be3          	beqz	a6,80000cf4 <copyinstr+0x4a>
    80000d22:	985a                	add	a6,a6,s6
    80000d24:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000d26:	41650633          	sub	a2,a0,s6
    80000d2a:	14fd                	addi	s1,s1,-1
    80000d2c:	9b26                	add	s6,s6,s1
    80000d2e:	00f60733          	add	a4,a2,a5
    80000d32:	00074703          	lbu	a4,0(a4)
    80000d36:	df49                	beqz	a4,80000cd0 <copyinstr+0x26>
        *dst = *p;
    80000d38:	00e78023          	sb	a4,0(a5)
      --max;
    80000d3c:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d40:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d42:	ff0796e3          	bne	a5,a6,80000d2e <copyinstr+0x84>
      dst++;
    80000d46:	8b42                	mv	s6,a6
    80000d48:	b775                	j	80000cf4 <copyinstr+0x4a>
    80000d4a:	4781                	li	a5,0
    80000d4c:	b769                	j	80000cd6 <copyinstr+0x2c>
      return -1;
    80000d4e:	557d                	li	a0,-1
    80000d50:	b779                	j	80000cde <copyinstr+0x34>
  int got_null = 0;
    80000d52:	4781                	li	a5,0
  if(got_null){
    80000d54:	0017b793          	seqz	a5,a5
    80000d58:	40f00533          	neg	a0,a5
}
    80000d5c:	8082                	ret

0000000080000d5e <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d5e:	7139                	addi	sp,sp,-64
    80000d60:	fc06                	sd	ra,56(sp)
    80000d62:	f822                	sd	s0,48(sp)
    80000d64:	f426                	sd	s1,40(sp)
    80000d66:	f04a                	sd	s2,32(sp)
    80000d68:	ec4e                	sd	s3,24(sp)
    80000d6a:	e852                	sd	s4,16(sp)
    80000d6c:	e456                	sd	s5,8(sp)
    80000d6e:	e05a                	sd	s6,0(sp)
    80000d70:	0080                	addi	s0,sp,64
    80000d72:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d74:	00008497          	auipc	s1,0x8
    80000d78:	22c48493          	addi	s1,s1,556 # 80008fa0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d7c:	8b26                	mv	s6,s1
    80000d7e:	00007a97          	auipc	s5,0x7
    80000d82:	282a8a93          	addi	s5,s5,642 # 80008000 <etext>
    80000d86:	04000937          	lui	s2,0x4000
    80000d8a:	197d                	addi	s2,s2,-1
    80000d8c:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d8e:	0000ea17          	auipc	s4,0xe
    80000d92:	e12a0a13          	addi	s4,s4,-494 # 8000eba0 <tickslock>
    char *pa = kalloc();
    80000d96:	fffff097          	auipc	ra,0xfffff
    80000d9a:	382080e7          	jalr	898(ra) # 80000118 <kalloc>
    80000d9e:	862a                	mv	a2,a0
    if(pa == 0)
    80000da0:	c131                	beqz	a0,80000de4 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000da2:	416485b3          	sub	a1,s1,s6
    80000da6:	8591                	srai	a1,a1,0x4
    80000da8:	000ab783          	ld	a5,0(s5)
    80000dac:	02f585b3          	mul	a1,a1,a5
    80000db0:	2585                	addiw	a1,a1,1
    80000db2:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000db6:	4719                	li	a4,6
    80000db8:	6685                	lui	a3,0x1
    80000dba:	40b905b3          	sub	a1,s2,a1
    80000dbe:	854e                	mv	a0,s3
    80000dc0:	00000097          	auipc	ra,0x0
    80000dc4:	874080e7          	jalr	-1932(ra) # 80000634 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dc8:	17048493          	addi	s1,s1,368
    80000dcc:	fd4495e3          	bne	s1,s4,80000d96 <proc_mapstacks+0x38>
  }
}
    80000dd0:	70e2                	ld	ra,56(sp)
    80000dd2:	7442                	ld	s0,48(sp)
    80000dd4:	74a2                	ld	s1,40(sp)
    80000dd6:	7902                	ld	s2,32(sp)
    80000dd8:	69e2                	ld	s3,24(sp)
    80000dda:	6a42                	ld	s4,16(sp)
    80000ddc:	6aa2                	ld	s5,8(sp)
    80000dde:	6b02                	ld	s6,0(sp)
    80000de0:	6121                	addi	sp,sp,64
    80000de2:	8082                	ret
      panic("kalloc");
    80000de4:	00007517          	auipc	a0,0x7
    80000de8:	3b450513          	addi	a0,a0,948 # 80008198 <etext+0x198>
    80000dec:	00005097          	auipc	ra,0x5
    80000df0:	f96080e7          	jalr	-106(ra) # 80005d82 <panic>

0000000080000df4 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000df4:	7139                	addi	sp,sp,-64
    80000df6:	fc06                	sd	ra,56(sp)
    80000df8:	f822                	sd	s0,48(sp)
    80000dfa:	f426                	sd	s1,40(sp)
    80000dfc:	f04a                	sd	s2,32(sp)
    80000dfe:	ec4e                	sd	s3,24(sp)
    80000e00:	e852                	sd	s4,16(sp)
    80000e02:	e456                	sd	s5,8(sp)
    80000e04:	e05a                	sd	s6,0(sp)
    80000e06:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e08:	00007597          	auipc	a1,0x7
    80000e0c:	39858593          	addi	a1,a1,920 # 800081a0 <etext+0x1a0>
    80000e10:	00008517          	auipc	a0,0x8
    80000e14:	d6050513          	addi	a0,a0,-672 # 80008b70 <pid_lock>
    80000e18:	00005097          	auipc	ra,0x5
    80000e1c:	424080e7          	jalr	1060(ra) # 8000623c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e20:	00007597          	auipc	a1,0x7
    80000e24:	38858593          	addi	a1,a1,904 # 800081a8 <etext+0x1a8>
    80000e28:	00008517          	auipc	a0,0x8
    80000e2c:	d6050513          	addi	a0,a0,-672 # 80008b88 <wait_lock>
    80000e30:	00005097          	auipc	ra,0x5
    80000e34:	40c080e7          	jalr	1036(ra) # 8000623c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e38:	00008497          	auipc	s1,0x8
    80000e3c:	16848493          	addi	s1,s1,360 # 80008fa0 <proc>
      initlock(&p->lock, "proc");
    80000e40:	00007b17          	auipc	s6,0x7
    80000e44:	378b0b13          	addi	s6,s6,888 # 800081b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000e48:	8aa6                	mv	s5,s1
    80000e4a:	00007a17          	auipc	s4,0x7
    80000e4e:	1b6a0a13          	addi	s4,s4,438 # 80008000 <etext>
    80000e52:	04000937          	lui	s2,0x4000
    80000e56:	197d                	addi	s2,s2,-1
    80000e58:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e5a:	0000e997          	auipc	s3,0xe
    80000e5e:	d4698993          	addi	s3,s3,-698 # 8000eba0 <tickslock>
      initlock(&p->lock, "proc");
    80000e62:	85da                	mv	a1,s6
    80000e64:	8526                	mv	a0,s1
    80000e66:	00005097          	auipc	ra,0x5
    80000e6a:	3d6080e7          	jalr	982(ra) # 8000623c <initlock>
      p->state = UNUSED;
    80000e6e:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000e72:	415487b3          	sub	a5,s1,s5
    80000e76:	8791                	srai	a5,a5,0x4
    80000e78:	000a3703          	ld	a4,0(s4)
    80000e7c:	02e787b3          	mul	a5,a5,a4
    80000e80:	2785                	addiw	a5,a5,1
    80000e82:	00d7979b          	slliw	a5,a5,0xd
    80000e86:	40f907b3          	sub	a5,s2,a5
    80000e8a:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e8c:	17048493          	addi	s1,s1,368
    80000e90:	fd3499e3          	bne	s1,s3,80000e62 <procinit+0x6e>
  }
}
    80000e94:	70e2                	ld	ra,56(sp)
    80000e96:	7442                	ld	s0,48(sp)
    80000e98:	74a2                	ld	s1,40(sp)
    80000e9a:	7902                	ld	s2,32(sp)
    80000e9c:	69e2                	ld	s3,24(sp)
    80000e9e:	6a42                	ld	s4,16(sp)
    80000ea0:	6aa2                	ld	s5,8(sp)
    80000ea2:	6b02                	ld	s6,0(sp)
    80000ea4:	6121                	addi	sp,sp,64
    80000ea6:	8082                	ret

0000000080000ea8 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000ea8:	1141                	addi	sp,sp,-16
    80000eaa:	e422                	sd	s0,8(sp)
    80000eac:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000eae:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000eb0:	2501                	sext.w	a0,a0
    80000eb2:	6422                	ld	s0,8(sp)
    80000eb4:	0141                	addi	sp,sp,16
    80000eb6:	8082                	ret

0000000080000eb8 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000eb8:	1141                	addi	sp,sp,-16
    80000eba:	e422                	sd	s0,8(sp)
    80000ebc:	0800                	addi	s0,sp,16
    80000ebe:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000ec0:	2781                	sext.w	a5,a5
    80000ec2:	079e                	slli	a5,a5,0x7
  return c;
}
    80000ec4:	00008517          	auipc	a0,0x8
    80000ec8:	cdc50513          	addi	a0,a0,-804 # 80008ba0 <cpus>
    80000ecc:	953e                	add	a0,a0,a5
    80000ece:	6422                	ld	s0,8(sp)
    80000ed0:	0141                	addi	sp,sp,16
    80000ed2:	8082                	ret

0000000080000ed4 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000ed4:	1101                	addi	sp,sp,-32
    80000ed6:	ec06                	sd	ra,24(sp)
    80000ed8:	e822                	sd	s0,16(sp)
    80000eda:	e426                	sd	s1,8(sp)
    80000edc:	1000                	addi	s0,sp,32
  push_off();
    80000ede:	00005097          	auipc	ra,0x5
    80000ee2:	3a2080e7          	jalr	930(ra) # 80006280 <push_off>
    80000ee6:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ee8:	2781                	sext.w	a5,a5
    80000eea:	079e                	slli	a5,a5,0x7
    80000eec:	00008717          	auipc	a4,0x8
    80000ef0:	c8470713          	addi	a4,a4,-892 # 80008b70 <pid_lock>
    80000ef4:	97ba                	add	a5,a5,a4
    80000ef6:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ef8:	00005097          	auipc	ra,0x5
    80000efc:	428080e7          	jalr	1064(ra) # 80006320 <pop_off>
  return p;
}
    80000f00:	8526                	mv	a0,s1
    80000f02:	60e2                	ld	ra,24(sp)
    80000f04:	6442                	ld	s0,16(sp)
    80000f06:	64a2                	ld	s1,8(sp)
    80000f08:	6105                	addi	sp,sp,32
    80000f0a:	8082                	ret

0000000080000f0c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f0c:	1141                	addi	sp,sp,-16
    80000f0e:	e406                	sd	ra,8(sp)
    80000f10:	e022                	sd	s0,0(sp)
    80000f12:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f14:	00000097          	auipc	ra,0x0
    80000f18:	fc0080e7          	jalr	-64(ra) # 80000ed4 <myproc>
    80000f1c:	00005097          	auipc	ra,0x5
    80000f20:	464080e7          	jalr	1124(ra) # 80006380 <release>

  if (first) {
    80000f24:	00008797          	auipc	a5,0x8
    80000f28:	aec7a783          	lw	a5,-1300(a5) # 80008a10 <first.1683>
    80000f2c:	eb89                	bnez	a5,80000f3e <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000f2e:	00001097          	auipc	ra,0x1
    80000f32:	cb6080e7          	jalr	-842(ra) # 80001be4 <usertrapret>
}
    80000f36:	60a2                	ld	ra,8(sp)
    80000f38:	6402                	ld	s0,0(sp)
    80000f3a:	0141                	addi	sp,sp,16
    80000f3c:	8082                	ret
    fsinit(ROOTDEV);
    80000f3e:	4505                	li	a0,1
    80000f40:	00002097          	auipc	ra,0x2
    80000f44:	ac4080e7          	jalr	-1340(ra) # 80002a04 <fsinit>
    first = 0;
    80000f48:	00008797          	auipc	a5,0x8
    80000f4c:	ac07a423          	sw	zero,-1336(a5) # 80008a10 <first.1683>
    __sync_synchronize();
    80000f50:	0ff0000f          	fence
    80000f54:	bfe9                	j	80000f2e <forkret+0x22>

0000000080000f56 <allocpid>:
{
    80000f56:	1101                	addi	sp,sp,-32
    80000f58:	ec06                	sd	ra,24(sp)
    80000f5a:	e822                	sd	s0,16(sp)
    80000f5c:	e426                	sd	s1,8(sp)
    80000f5e:	e04a                	sd	s2,0(sp)
    80000f60:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f62:	00008917          	auipc	s2,0x8
    80000f66:	c0e90913          	addi	s2,s2,-1010 # 80008b70 <pid_lock>
    80000f6a:	854a                	mv	a0,s2
    80000f6c:	00005097          	auipc	ra,0x5
    80000f70:	360080e7          	jalr	864(ra) # 800062cc <acquire>
  pid = nextpid;
    80000f74:	00008797          	auipc	a5,0x8
    80000f78:	aa078793          	addi	a5,a5,-1376 # 80008a14 <nextpid>
    80000f7c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f7e:	0014871b          	addiw	a4,s1,1
    80000f82:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f84:	854a                	mv	a0,s2
    80000f86:	00005097          	auipc	ra,0x5
    80000f8a:	3fa080e7          	jalr	1018(ra) # 80006380 <release>
}
    80000f8e:	8526                	mv	a0,s1
    80000f90:	60e2                	ld	ra,24(sp)
    80000f92:	6442                	ld	s0,16(sp)
    80000f94:	64a2                	ld	s1,8(sp)
    80000f96:	6902                	ld	s2,0(sp)
    80000f98:	6105                	addi	sp,sp,32
    80000f9a:	8082                	ret

0000000080000f9c <proc_pagetable>:
{
    80000f9c:	1101                	addi	sp,sp,-32
    80000f9e:	ec06                	sd	ra,24(sp)
    80000fa0:	e822                	sd	s0,16(sp)
    80000fa2:	e426                	sd	s1,8(sp)
    80000fa4:	e04a                	sd	s2,0(sp)
    80000fa6:	1000                	addi	s0,sp,32
    80000fa8:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000faa:	00000097          	auipc	ra,0x0
    80000fae:	874080e7          	jalr	-1932(ra) # 8000081e <uvmcreate>
    80000fb2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000fb4:	c121                	beqz	a0,80000ff4 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000fb6:	4729                	li	a4,10
    80000fb8:	00006697          	auipc	a3,0x6
    80000fbc:	04868693          	addi	a3,a3,72 # 80007000 <_trampoline>
    80000fc0:	6605                	lui	a2,0x1
    80000fc2:	040005b7          	lui	a1,0x4000
    80000fc6:	15fd                	addi	a1,a1,-1
    80000fc8:	05b2                	slli	a1,a1,0xc
    80000fca:	fffff097          	auipc	ra,0xfffff
    80000fce:	5a6080e7          	jalr	1446(ra) # 80000570 <mappages>
    80000fd2:	02054863          	bltz	a0,80001002 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fd6:	4719                	li	a4,6
    80000fd8:	05893683          	ld	a3,88(s2)
    80000fdc:	6605                	lui	a2,0x1
    80000fde:	020005b7          	lui	a1,0x2000
    80000fe2:	15fd                	addi	a1,a1,-1
    80000fe4:	05b6                	slli	a1,a1,0xd
    80000fe6:	8526                	mv	a0,s1
    80000fe8:	fffff097          	auipc	ra,0xfffff
    80000fec:	588080e7          	jalr	1416(ra) # 80000570 <mappages>
    80000ff0:	02054163          	bltz	a0,80001012 <proc_pagetable+0x76>
}
    80000ff4:	8526                	mv	a0,s1
    80000ff6:	60e2                	ld	ra,24(sp)
    80000ff8:	6442                	ld	s0,16(sp)
    80000ffa:	64a2                	ld	s1,8(sp)
    80000ffc:	6902                	ld	s2,0(sp)
    80000ffe:	6105                	addi	sp,sp,32
    80001000:	8082                	ret
    uvmfree(pagetable, 0);
    80001002:	4581                	li	a1,0
    80001004:	8526                	mv	a0,s1
    80001006:	00000097          	auipc	ra,0x0
    8000100a:	a1c080e7          	jalr	-1508(ra) # 80000a22 <uvmfree>
    return 0;
    8000100e:	4481                	li	s1,0
    80001010:	b7d5                	j	80000ff4 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001012:	4681                	li	a3,0
    80001014:	4605                	li	a2,1
    80001016:	040005b7          	lui	a1,0x4000
    8000101a:	15fd                	addi	a1,a1,-1
    8000101c:	05b2                	slli	a1,a1,0xc
    8000101e:	8526                	mv	a0,s1
    80001020:	fffff097          	auipc	ra,0xfffff
    80001024:	73a080e7          	jalr	1850(ra) # 8000075a <uvmunmap>
    uvmfree(pagetable, 0);
    80001028:	4581                	li	a1,0
    8000102a:	8526                	mv	a0,s1
    8000102c:	00000097          	auipc	ra,0x0
    80001030:	9f6080e7          	jalr	-1546(ra) # 80000a22 <uvmfree>
    return 0;
    80001034:	4481                	li	s1,0
    80001036:	bf7d                	j	80000ff4 <proc_pagetable+0x58>

0000000080001038 <proc_freepagetable>:
{
    80001038:	1101                	addi	sp,sp,-32
    8000103a:	ec06                	sd	ra,24(sp)
    8000103c:	e822                	sd	s0,16(sp)
    8000103e:	e426                	sd	s1,8(sp)
    80001040:	e04a                	sd	s2,0(sp)
    80001042:	1000                	addi	s0,sp,32
    80001044:	84aa                	mv	s1,a0
    80001046:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001048:	4681                	li	a3,0
    8000104a:	4605                	li	a2,1
    8000104c:	040005b7          	lui	a1,0x4000
    80001050:	15fd                	addi	a1,a1,-1
    80001052:	05b2                	slli	a1,a1,0xc
    80001054:	fffff097          	auipc	ra,0xfffff
    80001058:	706080e7          	jalr	1798(ra) # 8000075a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000105c:	4681                	li	a3,0
    8000105e:	4605                	li	a2,1
    80001060:	020005b7          	lui	a1,0x2000
    80001064:	15fd                	addi	a1,a1,-1
    80001066:	05b6                	slli	a1,a1,0xd
    80001068:	8526                	mv	a0,s1
    8000106a:	fffff097          	auipc	ra,0xfffff
    8000106e:	6f0080e7          	jalr	1776(ra) # 8000075a <uvmunmap>
  uvmfree(pagetable, sz);
    80001072:	85ca                	mv	a1,s2
    80001074:	8526                	mv	a0,s1
    80001076:	00000097          	auipc	ra,0x0
    8000107a:	9ac080e7          	jalr	-1620(ra) # 80000a22 <uvmfree>
}
    8000107e:	60e2                	ld	ra,24(sp)
    80001080:	6442                	ld	s0,16(sp)
    80001082:	64a2                	ld	s1,8(sp)
    80001084:	6902                	ld	s2,0(sp)
    80001086:	6105                	addi	sp,sp,32
    80001088:	8082                	ret

000000008000108a <freeproc>:
{
    8000108a:	1101                	addi	sp,sp,-32
    8000108c:	ec06                	sd	ra,24(sp)
    8000108e:	e822                	sd	s0,16(sp)
    80001090:	e426                	sd	s1,8(sp)
    80001092:	1000                	addi	s0,sp,32
    80001094:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001096:	6d28                	ld	a0,88(a0)
    80001098:	c509                	beqz	a0,800010a2 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000109a:	fffff097          	auipc	ra,0xfffff
    8000109e:	f82080e7          	jalr	-126(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800010a2:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800010a6:	68a8                	ld	a0,80(s1)
    800010a8:	c511                	beqz	a0,800010b4 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800010aa:	64ac                	ld	a1,72(s1)
    800010ac:	00000097          	auipc	ra,0x0
    800010b0:	f8c080e7          	jalr	-116(ra) # 80001038 <proc_freepagetable>
  p->pagetable = 0;
    800010b4:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800010b8:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800010bc:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800010c0:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800010c4:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800010c8:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800010cc:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800010d0:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800010d4:	0004ac23          	sw	zero,24(s1)
}
    800010d8:	60e2                	ld	ra,24(sp)
    800010da:	6442                	ld	s0,16(sp)
    800010dc:	64a2                	ld	s1,8(sp)
    800010de:	6105                	addi	sp,sp,32
    800010e0:	8082                	ret

00000000800010e2 <allocproc>:
{
    800010e2:	1101                	addi	sp,sp,-32
    800010e4:	ec06                	sd	ra,24(sp)
    800010e6:	e822                	sd	s0,16(sp)
    800010e8:	e426                	sd	s1,8(sp)
    800010ea:	e04a                	sd	s2,0(sp)
    800010ec:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ee:	00008497          	auipc	s1,0x8
    800010f2:	eb248493          	addi	s1,s1,-334 # 80008fa0 <proc>
    800010f6:	0000e917          	auipc	s2,0xe
    800010fa:	aaa90913          	addi	s2,s2,-1366 # 8000eba0 <tickslock>
    acquire(&p->lock);
    800010fe:	8526                	mv	a0,s1
    80001100:	00005097          	auipc	ra,0x5
    80001104:	1cc080e7          	jalr	460(ra) # 800062cc <acquire>
    if(p->state == UNUSED) {
    80001108:	4c9c                	lw	a5,24(s1)
    8000110a:	cf81                	beqz	a5,80001122 <allocproc+0x40>
      release(&p->lock);
    8000110c:	8526                	mv	a0,s1
    8000110e:	00005097          	auipc	ra,0x5
    80001112:	272080e7          	jalr	626(ra) # 80006380 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001116:	17048493          	addi	s1,s1,368
    8000111a:	ff2492e3          	bne	s1,s2,800010fe <allocproc+0x1c>
  return 0;
    8000111e:	4481                	li	s1,0
    80001120:	a889                	j	80001172 <allocproc+0x90>
  p->pid = allocpid();
    80001122:	00000097          	auipc	ra,0x0
    80001126:	e34080e7          	jalr	-460(ra) # 80000f56 <allocpid>
    8000112a:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000112c:	4785                	li	a5,1
    8000112e:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001130:	fffff097          	auipc	ra,0xfffff
    80001134:	fe8080e7          	jalr	-24(ra) # 80000118 <kalloc>
    80001138:	892a                	mv	s2,a0
    8000113a:	eca8                	sd	a0,88(s1)
    8000113c:	c131                	beqz	a0,80001180 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    8000113e:	8526                	mv	a0,s1
    80001140:	00000097          	auipc	ra,0x0
    80001144:	e5c080e7          	jalr	-420(ra) # 80000f9c <proc_pagetable>
    80001148:	892a                	mv	s2,a0
    8000114a:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000114c:	c531                	beqz	a0,80001198 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000114e:	07000613          	li	a2,112
    80001152:	4581                	li	a1,0
    80001154:	06048513          	addi	a0,s1,96
    80001158:	fffff097          	auipc	ra,0xfffff
    8000115c:	044080e7          	jalr	68(ra) # 8000019c <memset>
  p->context.ra = (uint64)forkret;
    80001160:	00000797          	auipc	a5,0x0
    80001164:	dac78793          	addi	a5,a5,-596 # 80000f0c <forkret>
    80001168:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000116a:	60bc                	ld	a5,64(s1)
    8000116c:	6705                	lui	a4,0x1
    8000116e:	97ba                	add	a5,a5,a4
    80001170:	f4bc                	sd	a5,104(s1)
}
    80001172:	8526                	mv	a0,s1
    80001174:	60e2                	ld	ra,24(sp)
    80001176:	6442                	ld	s0,16(sp)
    80001178:	64a2                	ld	s1,8(sp)
    8000117a:	6902                	ld	s2,0(sp)
    8000117c:	6105                	addi	sp,sp,32
    8000117e:	8082                	ret
    freeproc(p);
    80001180:	8526                	mv	a0,s1
    80001182:	00000097          	auipc	ra,0x0
    80001186:	f08080e7          	jalr	-248(ra) # 8000108a <freeproc>
    release(&p->lock);
    8000118a:	8526                	mv	a0,s1
    8000118c:	00005097          	auipc	ra,0x5
    80001190:	1f4080e7          	jalr	500(ra) # 80006380 <release>
    return 0;
    80001194:	84ca                	mv	s1,s2
    80001196:	bff1                	j	80001172 <allocproc+0x90>
    freeproc(p);
    80001198:	8526                	mv	a0,s1
    8000119a:	00000097          	auipc	ra,0x0
    8000119e:	ef0080e7          	jalr	-272(ra) # 8000108a <freeproc>
    release(&p->lock);
    800011a2:	8526                	mv	a0,s1
    800011a4:	00005097          	auipc	ra,0x5
    800011a8:	1dc080e7          	jalr	476(ra) # 80006380 <release>
    return 0;
    800011ac:	84ca                	mv	s1,s2
    800011ae:	b7d1                	j	80001172 <allocproc+0x90>

00000000800011b0 <userinit>:
{
    800011b0:	1101                	addi	sp,sp,-32
    800011b2:	ec06                	sd	ra,24(sp)
    800011b4:	e822                	sd	s0,16(sp)
    800011b6:	e426                	sd	s1,8(sp)
    800011b8:	1000                	addi	s0,sp,32
  p = allocproc();
    800011ba:	00000097          	auipc	ra,0x0
    800011be:	f28080e7          	jalr	-216(ra) # 800010e2 <allocproc>
    800011c2:	84aa                	mv	s1,a0
  initproc = p;
    800011c4:	00008797          	auipc	a5,0x8
    800011c8:	96a7b623          	sd	a0,-1684(a5) # 80008b30 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800011cc:	03400613          	li	a2,52
    800011d0:	00008597          	auipc	a1,0x8
    800011d4:	85058593          	addi	a1,a1,-1968 # 80008a20 <initcode>
    800011d8:	6928                	ld	a0,80(a0)
    800011da:	fffff097          	auipc	ra,0xfffff
    800011de:	672080e7          	jalr	1650(ra) # 8000084c <uvmfirst>
  p->sz = PGSIZE;
    800011e2:	6785                	lui	a5,0x1
    800011e4:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011e6:	6cb8                	ld	a4,88(s1)
    800011e8:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011ec:	6cb8                	ld	a4,88(s1)
    800011ee:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011f0:	4641                	li	a2,16
    800011f2:	00007597          	auipc	a1,0x7
    800011f6:	fce58593          	addi	a1,a1,-50 # 800081c0 <etext+0x1c0>
    800011fa:	15848513          	addi	a0,s1,344
    800011fe:	fffff097          	auipc	ra,0xfffff
    80001202:	0f0080e7          	jalr	240(ra) # 800002ee <safestrcpy>
  p->cwd = namei("/");
    80001206:	00007517          	auipc	a0,0x7
    8000120a:	fca50513          	addi	a0,a0,-54 # 800081d0 <etext+0x1d0>
    8000120e:	00002097          	auipc	ra,0x2
    80001212:	218080e7          	jalr	536(ra) # 80003426 <namei>
    80001216:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000121a:	478d                	li	a5,3
    8000121c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000121e:	8526                	mv	a0,s1
    80001220:	00005097          	auipc	ra,0x5
    80001224:	160080e7          	jalr	352(ra) # 80006380 <release>
}
    80001228:	60e2                	ld	ra,24(sp)
    8000122a:	6442                	ld	s0,16(sp)
    8000122c:	64a2                	ld	s1,8(sp)
    8000122e:	6105                	addi	sp,sp,32
    80001230:	8082                	ret

0000000080001232 <growproc>:
{
    80001232:	1101                	addi	sp,sp,-32
    80001234:	ec06                	sd	ra,24(sp)
    80001236:	e822                	sd	s0,16(sp)
    80001238:	e426                	sd	s1,8(sp)
    8000123a:	e04a                	sd	s2,0(sp)
    8000123c:	1000                	addi	s0,sp,32
    8000123e:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001240:	00000097          	auipc	ra,0x0
    80001244:	c94080e7          	jalr	-876(ra) # 80000ed4 <myproc>
    80001248:	84aa                	mv	s1,a0
  sz = p->sz;
    8000124a:	652c                	ld	a1,72(a0)
  if(n > 0){
    8000124c:	01204c63          	bgtz	s2,80001264 <growproc+0x32>
  } else if(n < 0){
    80001250:	02094663          	bltz	s2,8000127c <growproc+0x4a>
  p->sz = sz;
    80001254:	e4ac                	sd	a1,72(s1)
  return 0;
    80001256:	4501                	li	a0,0
}
    80001258:	60e2                	ld	ra,24(sp)
    8000125a:	6442                	ld	s0,16(sp)
    8000125c:	64a2                	ld	s1,8(sp)
    8000125e:	6902                	ld	s2,0(sp)
    80001260:	6105                	addi	sp,sp,32
    80001262:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001264:	4691                	li	a3,4
    80001266:	00b90633          	add	a2,s2,a1
    8000126a:	6928                	ld	a0,80(a0)
    8000126c:	fffff097          	auipc	ra,0xfffff
    80001270:	69a080e7          	jalr	1690(ra) # 80000906 <uvmalloc>
    80001274:	85aa                	mv	a1,a0
    80001276:	fd79                	bnez	a0,80001254 <growproc+0x22>
      return -1;
    80001278:	557d                	li	a0,-1
    8000127a:	bff9                	j	80001258 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000127c:	00b90633          	add	a2,s2,a1
    80001280:	6928                	ld	a0,80(a0)
    80001282:	fffff097          	auipc	ra,0xfffff
    80001286:	63c080e7          	jalr	1596(ra) # 800008be <uvmdealloc>
    8000128a:	85aa                	mv	a1,a0
    8000128c:	b7e1                	j	80001254 <growproc+0x22>

000000008000128e <fork>:
{
    8000128e:	7179                	addi	sp,sp,-48
    80001290:	f406                	sd	ra,40(sp)
    80001292:	f022                	sd	s0,32(sp)
    80001294:	ec26                	sd	s1,24(sp)
    80001296:	e84a                	sd	s2,16(sp)
    80001298:	e44e                	sd	s3,8(sp)
    8000129a:	e052                	sd	s4,0(sp)
    8000129c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000129e:	00000097          	auipc	ra,0x0
    800012a2:	c36080e7          	jalr	-970(ra) # 80000ed4 <myproc>
    800012a6:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    800012a8:	00000097          	auipc	ra,0x0
    800012ac:	e3a080e7          	jalr	-454(ra) # 800010e2 <allocproc>
    800012b0:	10050f63          	beqz	a0,800013ce <fork+0x140>
    800012b4:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800012b6:	04893603          	ld	a2,72(s2)
    800012ba:	692c                	ld	a1,80(a0)
    800012bc:	05093503          	ld	a0,80(s2)
    800012c0:	fffff097          	auipc	ra,0xfffff
    800012c4:	79a080e7          	jalr	1946(ra) # 80000a5a <uvmcopy>
    800012c8:	04054a63          	bltz	a0,8000131c <fork+0x8e>
  np->sz = p->sz;
    800012cc:	04893783          	ld	a5,72(s2)
    800012d0:	04f9b423          	sd	a5,72(s3)
  np->mask = p->mask;
    800012d4:	16893783          	ld	a5,360(s2)
    800012d8:	16f9b423          	sd	a5,360(s3)
  *(np->trapframe) = *(p->trapframe);
    800012dc:	05893683          	ld	a3,88(s2)
    800012e0:	87b6                	mv	a5,a3
    800012e2:	0589b703          	ld	a4,88(s3)
    800012e6:	12068693          	addi	a3,a3,288
    800012ea:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012ee:	6788                	ld	a0,8(a5)
    800012f0:	6b8c                	ld	a1,16(a5)
    800012f2:	6f90                	ld	a2,24(a5)
    800012f4:	01073023          	sd	a6,0(a4)
    800012f8:	e708                	sd	a0,8(a4)
    800012fa:	eb0c                	sd	a1,16(a4)
    800012fc:	ef10                	sd	a2,24(a4)
    800012fe:	02078793          	addi	a5,a5,32
    80001302:	02070713          	addi	a4,a4,32
    80001306:	fed792e3          	bne	a5,a3,800012ea <fork+0x5c>
  np->trapframe->a0 = 0;
    8000130a:	0589b783          	ld	a5,88(s3)
    8000130e:	0607b823          	sd	zero,112(a5)
    80001312:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001316:	15000a13          	li	s4,336
    8000131a:	a03d                	j	80001348 <fork+0xba>
    freeproc(np);
    8000131c:	854e                	mv	a0,s3
    8000131e:	00000097          	auipc	ra,0x0
    80001322:	d6c080e7          	jalr	-660(ra) # 8000108a <freeproc>
    release(&np->lock);
    80001326:	854e                	mv	a0,s3
    80001328:	00005097          	auipc	ra,0x5
    8000132c:	058080e7          	jalr	88(ra) # 80006380 <release>
    return -1;
    80001330:	5a7d                	li	s4,-1
    80001332:	a069                	j	800013bc <fork+0x12e>
      np->ofile[i] = filedup(p->ofile[i]);
    80001334:	00002097          	auipc	ra,0x2
    80001338:	788080e7          	jalr	1928(ra) # 80003abc <filedup>
    8000133c:	009987b3          	add	a5,s3,s1
    80001340:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001342:	04a1                	addi	s1,s1,8
    80001344:	01448763          	beq	s1,s4,80001352 <fork+0xc4>
    if(p->ofile[i])
    80001348:	009907b3          	add	a5,s2,s1
    8000134c:	6388                	ld	a0,0(a5)
    8000134e:	f17d                	bnez	a0,80001334 <fork+0xa6>
    80001350:	bfcd                	j	80001342 <fork+0xb4>
  np->cwd = idup(p->cwd);
    80001352:	15093503          	ld	a0,336(s2)
    80001356:	00002097          	auipc	ra,0x2
    8000135a:	8ec080e7          	jalr	-1812(ra) # 80002c42 <idup>
    8000135e:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001362:	4641                	li	a2,16
    80001364:	15890593          	addi	a1,s2,344
    80001368:	15898513          	addi	a0,s3,344
    8000136c:	fffff097          	auipc	ra,0xfffff
    80001370:	f82080e7          	jalr	-126(ra) # 800002ee <safestrcpy>
  pid = np->pid;
    80001374:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001378:	854e                	mv	a0,s3
    8000137a:	00005097          	auipc	ra,0x5
    8000137e:	006080e7          	jalr	6(ra) # 80006380 <release>
  acquire(&wait_lock);
    80001382:	00008497          	auipc	s1,0x8
    80001386:	80648493          	addi	s1,s1,-2042 # 80008b88 <wait_lock>
    8000138a:	8526                	mv	a0,s1
    8000138c:	00005097          	auipc	ra,0x5
    80001390:	f40080e7          	jalr	-192(ra) # 800062cc <acquire>
  np->parent = p;
    80001394:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001398:	8526                	mv	a0,s1
    8000139a:	00005097          	auipc	ra,0x5
    8000139e:	fe6080e7          	jalr	-26(ra) # 80006380 <release>
  acquire(&np->lock);
    800013a2:	854e                	mv	a0,s3
    800013a4:	00005097          	auipc	ra,0x5
    800013a8:	f28080e7          	jalr	-216(ra) # 800062cc <acquire>
  np->state = RUNNABLE;
    800013ac:	478d                	li	a5,3
    800013ae:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800013b2:	854e                	mv	a0,s3
    800013b4:	00005097          	auipc	ra,0x5
    800013b8:	fcc080e7          	jalr	-52(ra) # 80006380 <release>
}
    800013bc:	8552                	mv	a0,s4
    800013be:	70a2                	ld	ra,40(sp)
    800013c0:	7402                	ld	s0,32(sp)
    800013c2:	64e2                	ld	s1,24(sp)
    800013c4:	6942                	ld	s2,16(sp)
    800013c6:	69a2                	ld	s3,8(sp)
    800013c8:	6a02                	ld	s4,0(sp)
    800013ca:	6145                	addi	sp,sp,48
    800013cc:	8082                	ret
    return -1;
    800013ce:	5a7d                	li	s4,-1
    800013d0:	b7f5                	j	800013bc <fork+0x12e>

00000000800013d2 <scheduler>:
{
    800013d2:	7139                	addi	sp,sp,-64
    800013d4:	fc06                	sd	ra,56(sp)
    800013d6:	f822                	sd	s0,48(sp)
    800013d8:	f426                	sd	s1,40(sp)
    800013da:	f04a                	sd	s2,32(sp)
    800013dc:	ec4e                	sd	s3,24(sp)
    800013de:	e852                	sd	s4,16(sp)
    800013e0:	e456                	sd	s5,8(sp)
    800013e2:	e05a                	sd	s6,0(sp)
    800013e4:	0080                	addi	s0,sp,64
    800013e6:	8792                	mv	a5,tp
  int id = r_tp();
    800013e8:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013ea:	00779a93          	slli	s5,a5,0x7
    800013ee:	00007717          	auipc	a4,0x7
    800013f2:	78270713          	addi	a4,a4,1922 # 80008b70 <pid_lock>
    800013f6:	9756                	add	a4,a4,s5
    800013f8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013fc:	00007717          	auipc	a4,0x7
    80001400:	7ac70713          	addi	a4,a4,1964 # 80008ba8 <cpus+0x8>
    80001404:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001406:	498d                	li	s3,3
        p->state = RUNNING;
    80001408:	4b11                	li	s6,4
        c->proc = p;
    8000140a:	079e                	slli	a5,a5,0x7
    8000140c:	00007a17          	auipc	s4,0x7
    80001410:	764a0a13          	addi	s4,s4,1892 # 80008b70 <pid_lock>
    80001414:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001416:	0000d917          	auipc	s2,0xd
    8000141a:	78a90913          	addi	s2,s2,1930 # 8000eba0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000141e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001422:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001426:	10079073          	csrw	sstatus,a5
    8000142a:	00008497          	auipc	s1,0x8
    8000142e:	b7648493          	addi	s1,s1,-1162 # 80008fa0 <proc>
    80001432:	a03d                	j	80001460 <scheduler+0x8e>
        p->state = RUNNING;
    80001434:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001438:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000143c:	06048593          	addi	a1,s1,96
    80001440:	8556                	mv	a0,s5
    80001442:	00000097          	auipc	ra,0x0
    80001446:	6f8080e7          	jalr	1784(ra) # 80001b3a <swtch>
        c->proc = 0;
    8000144a:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    8000144e:	8526                	mv	a0,s1
    80001450:	00005097          	auipc	ra,0x5
    80001454:	f30080e7          	jalr	-208(ra) # 80006380 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001458:	17048493          	addi	s1,s1,368
    8000145c:	fd2481e3          	beq	s1,s2,8000141e <scheduler+0x4c>
      acquire(&p->lock);
    80001460:	8526                	mv	a0,s1
    80001462:	00005097          	auipc	ra,0x5
    80001466:	e6a080e7          	jalr	-406(ra) # 800062cc <acquire>
      if(p->state == RUNNABLE) {
    8000146a:	4c9c                	lw	a5,24(s1)
    8000146c:	ff3791e3          	bne	a5,s3,8000144e <scheduler+0x7c>
    80001470:	b7d1                	j	80001434 <scheduler+0x62>

0000000080001472 <sched>:
{
    80001472:	7179                	addi	sp,sp,-48
    80001474:	f406                	sd	ra,40(sp)
    80001476:	f022                	sd	s0,32(sp)
    80001478:	ec26                	sd	s1,24(sp)
    8000147a:	e84a                	sd	s2,16(sp)
    8000147c:	e44e                	sd	s3,8(sp)
    8000147e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001480:	00000097          	auipc	ra,0x0
    80001484:	a54080e7          	jalr	-1452(ra) # 80000ed4 <myproc>
    80001488:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000148a:	00005097          	auipc	ra,0x5
    8000148e:	dc8080e7          	jalr	-568(ra) # 80006252 <holding>
    80001492:	c93d                	beqz	a0,80001508 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001494:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001496:	2781                	sext.w	a5,a5
    80001498:	079e                	slli	a5,a5,0x7
    8000149a:	00007717          	auipc	a4,0x7
    8000149e:	6d670713          	addi	a4,a4,1750 # 80008b70 <pid_lock>
    800014a2:	97ba                	add	a5,a5,a4
    800014a4:	0a87a703          	lw	a4,168(a5)
    800014a8:	4785                	li	a5,1
    800014aa:	06f71763          	bne	a4,a5,80001518 <sched+0xa6>
  if(p->state == RUNNING)
    800014ae:	4c98                	lw	a4,24(s1)
    800014b0:	4791                	li	a5,4
    800014b2:	06f70b63          	beq	a4,a5,80001528 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014b6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014ba:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014bc:	efb5                	bnez	a5,80001538 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014be:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014c0:	00007917          	auipc	s2,0x7
    800014c4:	6b090913          	addi	s2,s2,1712 # 80008b70 <pid_lock>
    800014c8:	2781                	sext.w	a5,a5
    800014ca:	079e                	slli	a5,a5,0x7
    800014cc:	97ca                	add	a5,a5,s2
    800014ce:	0ac7a983          	lw	s3,172(a5)
    800014d2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014d4:	2781                	sext.w	a5,a5
    800014d6:	079e                	slli	a5,a5,0x7
    800014d8:	00007597          	auipc	a1,0x7
    800014dc:	6d058593          	addi	a1,a1,1744 # 80008ba8 <cpus+0x8>
    800014e0:	95be                	add	a1,a1,a5
    800014e2:	06048513          	addi	a0,s1,96
    800014e6:	00000097          	auipc	ra,0x0
    800014ea:	654080e7          	jalr	1620(ra) # 80001b3a <swtch>
    800014ee:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014f0:	2781                	sext.w	a5,a5
    800014f2:	079e                	slli	a5,a5,0x7
    800014f4:	97ca                	add	a5,a5,s2
    800014f6:	0b37a623          	sw	s3,172(a5)
}
    800014fa:	70a2                	ld	ra,40(sp)
    800014fc:	7402                	ld	s0,32(sp)
    800014fe:	64e2                	ld	s1,24(sp)
    80001500:	6942                	ld	s2,16(sp)
    80001502:	69a2                	ld	s3,8(sp)
    80001504:	6145                	addi	sp,sp,48
    80001506:	8082                	ret
    panic("sched p->lock");
    80001508:	00007517          	auipc	a0,0x7
    8000150c:	cd050513          	addi	a0,a0,-816 # 800081d8 <etext+0x1d8>
    80001510:	00005097          	auipc	ra,0x5
    80001514:	872080e7          	jalr	-1934(ra) # 80005d82 <panic>
    panic("sched locks");
    80001518:	00007517          	auipc	a0,0x7
    8000151c:	cd050513          	addi	a0,a0,-816 # 800081e8 <etext+0x1e8>
    80001520:	00005097          	auipc	ra,0x5
    80001524:	862080e7          	jalr	-1950(ra) # 80005d82 <panic>
    panic("sched running");
    80001528:	00007517          	auipc	a0,0x7
    8000152c:	cd050513          	addi	a0,a0,-816 # 800081f8 <etext+0x1f8>
    80001530:	00005097          	auipc	ra,0x5
    80001534:	852080e7          	jalr	-1966(ra) # 80005d82 <panic>
    panic("sched interruptible");
    80001538:	00007517          	auipc	a0,0x7
    8000153c:	cd050513          	addi	a0,a0,-816 # 80008208 <etext+0x208>
    80001540:	00005097          	auipc	ra,0x5
    80001544:	842080e7          	jalr	-1982(ra) # 80005d82 <panic>

0000000080001548 <yield>:
{
    80001548:	1101                	addi	sp,sp,-32
    8000154a:	ec06                	sd	ra,24(sp)
    8000154c:	e822                	sd	s0,16(sp)
    8000154e:	e426                	sd	s1,8(sp)
    80001550:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001552:	00000097          	auipc	ra,0x0
    80001556:	982080e7          	jalr	-1662(ra) # 80000ed4 <myproc>
    8000155a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000155c:	00005097          	auipc	ra,0x5
    80001560:	d70080e7          	jalr	-656(ra) # 800062cc <acquire>
  p->state = RUNNABLE;
    80001564:	478d                	li	a5,3
    80001566:	cc9c                	sw	a5,24(s1)
  sched();
    80001568:	00000097          	auipc	ra,0x0
    8000156c:	f0a080e7          	jalr	-246(ra) # 80001472 <sched>
  release(&p->lock);
    80001570:	8526                	mv	a0,s1
    80001572:	00005097          	auipc	ra,0x5
    80001576:	e0e080e7          	jalr	-498(ra) # 80006380 <release>
}
    8000157a:	60e2                	ld	ra,24(sp)
    8000157c:	6442                	ld	s0,16(sp)
    8000157e:	64a2                	ld	s1,8(sp)
    80001580:	6105                	addi	sp,sp,32
    80001582:	8082                	ret

0000000080001584 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001584:	7179                	addi	sp,sp,-48
    80001586:	f406                	sd	ra,40(sp)
    80001588:	f022                	sd	s0,32(sp)
    8000158a:	ec26                	sd	s1,24(sp)
    8000158c:	e84a                	sd	s2,16(sp)
    8000158e:	e44e                	sd	s3,8(sp)
    80001590:	1800                	addi	s0,sp,48
    80001592:	89aa                	mv	s3,a0
    80001594:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001596:	00000097          	auipc	ra,0x0
    8000159a:	93e080e7          	jalr	-1730(ra) # 80000ed4 <myproc>
    8000159e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800015a0:	00005097          	auipc	ra,0x5
    800015a4:	d2c080e7          	jalr	-724(ra) # 800062cc <acquire>
  release(lk);
    800015a8:	854a                	mv	a0,s2
    800015aa:	00005097          	auipc	ra,0x5
    800015ae:	dd6080e7          	jalr	-554(ra) # 80006380 <release>

  // Go to sleep.
  p->chan = chan;
    800015b2:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015b6:	4789                	li	a5,2
    800015b8:	cc9c                	sw	a5,24(s1)

  sched();
    800015ba:	00000097          	auipc	ra,0x0
    800015be:	eb8080e7          	jalr	-328(ra) # 80001472 <sched>

  // Tidy up.
  p->chan = 0;
    800015c2:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015c6:	8526                	mv	a0,s1
    800015c8:	00005097          	auipc	ra,0x5
    800015cc:	db8080e7          	jalr	-584(ra) # 80006380 <release>
  acquire(lk);
    800015d0:	854a                	mv	a0,s2
    800015d2:	00005097          	auipc	ra,0x5
    800015d6:	cfa080e7          	jalr	-774(ra) # 800062cc <acquire>
}
    800015da:	70a2                	ld	ra,40(sp)
    800015dc:	7402                	ld	s0,32(sp)
    800015de:	64e2                	ld	s1,24(sp)
    800015e0:	6942                	ld	s2,16(sp)
    800015e2:	69a2                	ld	s3,8(sp)
    800015e4:	6145                	addi	sp,sp,48
    800015e6:	8082                	ret

00000000800015e8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800015e8:	7139                	addi	sp,sp,-64
    800015ea:	fc06                	sd	ra,56(sp)
    800015ec:	f822                	sd	s0,48(sp)
    800015ee:	f426                	sd	s1,40(sp)
    800015f0:	f04a                	sd	s2,32(sp)
    800015f2:	ec4e                	sd	s3,24(sp)
    800015f4:	e852                	sd	s4,16(sp)
    800015f6:	e456                	sd	s5,8(sp)
    800015f8:	0080                	addi	s0,sp,64
    800015fa:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800015fc:	00008497          	auipc	s1,0x8
    80001600:	9a448493          	addi	s1,s1,-1628 # 80008fa0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001604:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001606:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001608:	0000d917          	auipc	s2,0xd
    8000160c:	59890913          	addi	s2,s2,1432 # 8000eba0 <tickslock>
    80001610:	a821                	j	80001628 <wakeup+0x40>
        p->state = RUNNABLE;
    80001612:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001616:	8526                	mv	a0,s1
    80001618:	00005097          	auipc	ra,0x5
    8000161c:	d68080e7          	jalr	-664(ra) # 80006380 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001620:	17048493          	addi	s1,s1,368
    80001624:	03248463          	beq	s1,s2,8000164c <wakeup+0x64>
    if(p != myproc()){
    80001628:	00000097          	auipc	ra,0x0
    8000162c:	8ac080e7          	jalr	-1876(ra) # 80000ed4 <myproc>
    80001630:	fea488e3          	beq	s1,a0,80001620 <wakeup+0x38>
      acquire(&p->lock);
    80001634:	8526                	mv	a0,s1
    80001636:	00005097          	auipc	ra,0x5
    8000163a:	c96080e7          	jalr	-874(ra) # 800062cc <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000163e:	4c9c                	lw	a5,24(s1)
    80001640:	fd379be3          	bne	a5,s3,80001616 <wakeup+0x2e>
    80001644:	709c                	ld	a5,32(s1)
    80001646:	fd4798e3          	bne	a5,s4,80001616 <wakeup+0x2e>
    8000164a:	b7e1                	j	80001612 <wakeup+0x2a>
    }
  }
}
    8000164c:	70e2                	ld	ra,56(sp)
    8000164e:	7442                	ld	s0,48(sp)
    80001650:	74a2                	ld	s1,40(sp)
    80001652:	7902                	ld	s2,32(sp)
    80001654:	69e2                	ld	s3,24(sp)
    80001656:	6a42                	ld	s4,16(sp)
    80001658:	6aa2                	ld	s5,8(sp)
    8000165a:	6121                	addi	sp,sp,64
    8000165c:	8082                	ret

000000008000165e <reparent>:
{
    8000165e:	7179                	addi	sp,sp,-48
    80001660:	f406                	sd	ra,40(sp)
    80001662:	f022                	sd	s0,32(sp)
    80001664:	ec26                	sd	s1,24(sp)
    80001666:	e84a                	sd	s2,16(sp)
    80001668:	e44e                	sd	s3,8(sp)
    8000166a:	e052                	sd	s4,0(sp)
    8000166c:	1800                	addi	s0,sp,48
    8000166e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001670:	00008497          	auipc	s1,0x8
    80001674:	93048493          	addi	s1,s1,-1744 # 80008fa0 <proc>
      pp->parent = initproc;
    80001678:	00007a17          	auipc	s4,0x7
    8000167c:	4b8a0a13          	addi	s4,s4,1208 # 80008b30 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001680:	0000d997          	auipc	s3,0xd
    80001684:	52098993          	addi	s3,s3,1312 # 8000eba0 <tickslock>
    80001688:	a029                	j	80001692 <reparent+0x34>
    8000168a:	17048493          	addi	s1,s1,368
    8000168e:	01348d63          	beq	s1,s3,800016a8 <reparent+0x4a>
    if(pp->parent == p){
    80001692:	7c9c                	ld	a5,56(s1)
    80001694:	ff279be3          	bne	a5,s2,8000168a <reparent+0x2c>
      pp->parent = initproc;
    80001698:	000a3503          	ld	a0,0(s4)
    8000169c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000169e:	00000097          	auipc	ra,0x0
    800016a2:	f4a080e7          	jalr	-182(ra) # 800015e8 <wakeup>
    800016a6:	b7d5                	j	8000168a <reparent+0x2c>
}
    800016a8:	70a2                	ld	ra,40(sp)
    800016aa:	7402                	ld	s0,32(sp)
    800016ac:	64e2                	ld	s1,24(sp)
    800016ae:	6942                	ld	s2,16(sp)
    800016b0:	69a2                	ld	s3,8(sp)
    800016b2:	6a02                	ld	s4,0(sp)
    800016b4:	6145                	addi	sp,sp,48
    800016b6:	8082                	ret

00000000800016b8 <exit>:
{
    800016b8:	7179                	addi	sp,sp,-48
    800016ba:	f406                	sd	ra,40(sp)
    800016bc:	f022                	sd	s0,32(sp)
    800016be:	ec26                	sd	s1,24(sp)
    800016c0:	e84a                	sd	s2,16(sp)
    800016c2:	e44e                	sd	s3,8(sp)
    800016c4:	e052                	sd	s4,0(sp)
    800016c6:	1800                	addi	s0,sp,48
    800016c8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800016ca:	00000097          	auipc	ra,0x0
    800016ce:	80a080e7          	jalr	-2038(ra) # 80000ed4 <myproc>
    800016d2:	89aa                	mv	s3,a0
  if(p == initproc)
    800016d4:	00007797          	auipc	a5,0x7
    800016d8:	45c7b783          	ld	a5,1116(a5) # 80008b30 <initproc>
    800016dc:	0d050493          	addi	s1,a0,208
    800016e0:	15050913          	addi	s2,a0,336
    800016e4:	02a79363          	bne	a5,a0,8000170a <exit+0x52>
    panic("init exiting");
    800016e8:	00007517          	auipc	a0,0x7
    800016ec:	b3850513          	addi	a0,a0,-1224 # 80008220 <etext+0x220>
    800016f0:	00004097          	auipc	ra,0x4
    800016f4:	692080e7          	jalr	1682(ra) # 80005d82 <panic>
      fileclose(f);
    800016f8:	00002097          	auipc	ra,0x2
    800016fc:	416080e7          	jalr	1046(ra) # 80003b0e <fileclose>
      p->ofile[fd] = 0;
    80001700:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001704:	04a1                	addi	s1,s1,8
    80001706:	01248563          	beq	s1,s2,80001710 <exit+0x58>
    if(p->ofile[fd]){
    8000170a:	6088                	ld	a0,0(s1)
    8000170c:	f575                	bnez	a0,800016f8 <exit+0x40>
    8000170e:	bfdd                	j	80001704 <exit+0x4c>
  begin_op();
    80001710:	00002097          	auipc	ra,0x2
    80001714:	f32080e7          	jalr	-206(ra) # 80003642 <begin_op>
  iput(p->cwd);
    80001718:	1509b503          	ld	a0,336(s3)
    8000171c:	00001097          	auipc	ra,0x1
    80001720:	71e080e7          	jalr	1822(ra) # 80002e3a <iput>
  end_op();
    80001724:	00002097          	auipc	ra,0x2
    80001728:	f9e080e7          	jalr	-98(ra) # 800036c2 <end_op>
  p->cwd = 0;
    8000172c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001730:	00007497          	auipc	s1,0x7
    80001734:	45848493          	addi	s1,s1,1112 # 80008b88 <wait_lock>
    80001738:	8526                	mv	a0,s1
    8000173a:	00005097          	auipc	ra,0x5
    8000173e:	b92080e7          	jalr	-1134(ra) # 800062cc <acquire>
  reparent(p);
    80001742:	854e                	mv	a0,s3
    80001744:	00000097          	auipc	ra,0x0
    80001748:	f1a080e7          	jalr	-230(ra) # 8000165e <reparent>
  wakeup(p->parent);
    8000174c:	0389b503          	ld	a0,56(s3)
    80001750:	00000097          	auipc	ra,0x0
    80001754:	e98080e7          	jalr	-360(ra) # 800015e8 <wakeup>
  acquire(&p->lock);
    80001758:	854e                	mv	a0,s3
    8000175a:	00005097          	auipc	ra,0x5
    8000175e:	b72080e7          	jalr	-1166(ra) # 800062cc <acquire>
  p->xstate = status;
    80001762:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001766:	4795                	li	a5,5
    80001768:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000176c:	8526                	mv	a0,s1
    8000176e:	00005097          	auipc	ra,0x5
    80001772:	c12080e7          	jalr	-1006(ra) # 80006380 <release>
  sched();
    80001776:	00000097          	auipc	ra,0x0
    8000177a:	cfc080e7          	jalr	-772(ra) # 80001472 <sched>
  panic("zombie exit");
    8000177e:	00007517          	auipc	a0,0x7
    80001782:	ab250513          	addi	a0,a0,-1358 # 80008230 <etext+0x230>
    80001786:	00004097          	auipc	ra,0x4
    8000178a:	5fc080e7          	jalr	1532(ra) # 80005d82 <panic>

000000008000178e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000178e:	7179                	addi	sp,sp,-48
    80001790:	f406                	sd	ra,40(sp)
    80001792:	f022                	sd	s0,32(sp)
    80001794:	ec26                	sd	s1,24(sp)
    80001796:	e84a                	sd	s2,16(sp)
    80001798:	e44e                	sd	s3,8(sp)
    8000179a:	1800                	addi	s0,sp,48
    8000179c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000179e:	00008497          	auipc	s1,0x8
    800017a2:	80248493          	addi	s1,s1,-2046 # 80008fa0 <proc>
    800017a6:	0000d997          	auipc	s3,0xd
    800017aa:	3fa98993          	addi	s3,s3,1018 # 8000eba0 <tickslock>
    acquire(&p->lock);
    800017ae:	8526                	mv	a0,s1
    800017b0:	00005097          	auipc	ra,0x5
    800017b4:	b1c080e7          	jalr	-1252(ra) # 800062cc <acquire>
    if(p->pid == pid){
    800017b8:	589c                	lw	a5,48(s1)
    800017ba:	01278d63          	beq	a5,s2,800017d4 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800017be:	8526                	mv	a0,s1
    800017c0:	00005097          	auipc	ra,0x5
    800017c4:	bc0080e7          	jalr	-1088(ra) # 80006380 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800017c8:	17048493          	addi	s1,s1,368
    800017cc:	ff3491e3          	bne	s1,s3,800017ae <kill+0x20>
  }
  return -1;
    800017d0:	557d                	li	a0,-1
    800017d2:	a829                	j	800017ec <kill+0x5e>
      p->killed = 1;
    800017d4:	4785                	li	a5,1
    800017d6:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800017d8:	4c98                	lw	a4,24(s1)
    800017da:	4789                	li	a5,2
    800017dc:	00f70f63          	beq	a4,a5,800017fa <kill+0x6c>
      release(&p->lock);
    800017e0:	8526                	mv	a0,s1
    800017e2:	00005097          	auipc	ra,0x5
    800017e6:	b9e080e7          	jalr	-1122(ra) # 80006380 <release>
      return 0;
    800017ea:	4501                	li	a0,0
}
    800017ec:	70a2                	ld	ra,40(sp)
    800017ee:	7402                	ld	s0,32(sp)
    800017f0:	64e2                	ld	s1,24(sp)
    800017f2:	6942                	ld	s2,16(sp)
    800017f4:	69a2                	ld	s3,8(sp)
    800017f6:	6145                	addi	sp,sp,48
    800017f8:	8082                	ret
        p->state = RUNNABLE;
    800017fa:	478d                	li	a5,3
    800017fc:	cc9c                	sw	a5,24(s1)
    800017fe:	b7cd                	j	800017e0 <kill+0x52>

0000000080001800 <setkilled>:

void
setkilled(struct proc *p)
{
    80001800:	1101                	addi	sp,sp,-32
    80001802:	ec06                	sd	ra,24(sp)
    80001804:	e822                	sd	s0,16(sp)
    80001806:	e426                	sd	s1,8(sp)
    80001808:	1000                	addi	s0,sp,32
    8000180a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000180c:	00005097          	auipc	ra,0x5
    80001810:	ac0080e7          	jalr	-1344(ra) # 800062cc <acquire>
  p->killed = 1;
    80001814:	4785                	li	a5,1
    80001816:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001818:	8526                	mv	a0,s1
    8000181a:	00005097          	auipc	ra,0x5
    8000181e:	b66080e7          	jalr	-1178(ra) # 80006380 <release>
}
    80001822:	60e2                	ld	ra,24(sp)
    80001824:	6442                	ld	s0,16(sp)
    80001826:	64a2                	ld	s1,8(sp)
    80001828:	6105                	addi	sp,sp,32
    8000182a:	8082                	ret

000000008000182c <killed>:

int
killed(struct proc *p)
{
    8000182c:	1101                	addi	sp,sp,-32
    8000182e:	ec06                	sd	ra,24(sp)
    80001830:	e822                	sd	s0,16(sp)
    80001832:	e426                	sd	s1,8(sp)
    80001834:	e04a                	sd	s2,0(sp)
    80001836:	1000                	addi	s0,sp,32
    80001838:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000183a:	00005097          	auipc	ra,0x5
    8000183e:	a92080e7          	jalr	-1390(ra) # 800062cc <acquire>
  k = p->killed;
    80001842:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001846:	8526                	mv	a0,s1
    80001848:	00005097          	auipc	ra,0x5
    8000184c:	b38080e7          	jalr	-1224(ra) # 80006380 <release>
  return k;
}
    80001850:	854a                	mv	a0,s2
    80001852:	60e2                	ld	ra,24(sp)
    80001854:	6442                	ld	s0,16(sp)
    80001856:	64a2                	ld	s1,8(sp)
    80001858:	6902                	ld	s2,0(sp)
    8000185a:	6105                	addi	sp,sp,32
    8000185c:	8082                	ret

000000008000185e <wait>:
{
    8000185e:	715d                	addi	sp,sp,-80
    80001860:	e486                	sd	ra,72(sp)
    80001862:	e0a2                	sd	s0,64(sp)
    80001864:	fc26                	sd	s1,56(sp)
    80001866:	f84a                	sd	s2,48(sp)
    80001868:	f44e                	sd	s3,40(sp)
    8000186a:	f052                	sd	s4,32(sp)
    8000186c:	ec56                	sd	s5,24(sp)
    8000186e:	e85a                	sd	s6,16(sp)
    80001870:	e45e                	sd	s7,8(sp)
    80001872:	e062                	sd	s8,0(sp)
    80001874:	0880                	addi	s0,sp,80
    80001876:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001878:	fffff097          	auipc	ra,0xfffff
    8000187c:	65c080e7          	jalr	1628(ra) # 80000ed4 <myproc>
    80001880:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001882:	00007517          	auipc	a0,0x7
    80001886:	30650513          	addi	a0,a0,774 # 80008b88 <wait_lock>
    8000188a:	00005097          	auipc	ra,0x5
    8000188e:	a42080e7          	jalr	-1470(ra) # 800062cc <acquire>
    havekids = 0;
    80001892:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001894:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001896:	0000d997          	auipc	s3,0xd
    8000189a:	30a98993          	addi	s3,s3,778 # 8000eba0 <tickslock>
        havekids = 1;
    8000189e:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018a0:	00007c17          	auipc	s8,0x7
    800018a4:	2e8c0c13          	addi	s8,s8,744 # 80008b88 <wait_lock>
    havekids = 0;
    800018a8:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018aa:	00007497          	auipc	s1,0x7
    800018ae:	6f648493          	addi	s1,s1,1782 # 80008fa0 <proc>
    800018b2:	a0bd                	j	80001920 <wait+0xc2>
          pid = pp->pid;
    800018b4:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800018b8:	000b0e63          	beqz	s6,800018d4 <wait+0x76>
    800018bc:	4691                	li	a3,4
    800018be:	02c48613          	addi	a2,s1,44
    800018c2:	85da                	mv	a1,s6
    800018c4:	05093503          	ld	a0,80(s2)
    800018c8:	fffff097          	auipc	ra,0xfffff
    800018cc:	296080e7          	jalr	662(ra) # 80000b5e <copyout>
    800018d0:	02054563          	bltz	a0,800018fa <wait+0x9c>
          freeproc(pp);
    800018d4:	8526                	mv	a0,s1
    800018d6:	fffff097          	auipc	ra,0xfffff
    800018da:	7b4080e7          	jalr	1972(ra) # 8000108a <freeproc>
          release(&pp->lock);
    800018de:	8526                	mv	a0,s1
    800018e0:	00005097          	auipc	ra,0x5
    800018e4:	aa0080e7          	jalr	-1376(ra) # 80006380 <release>
          release(&wait_lock);
    800018e8:	00007517          	auipc	a0,0x7
    800018ec:	2a050513          	addi	a0,a0,672 # 80008b88 <wait_lock>
    800018f0:	00005097          	auipc	ra,0x5
    800018f4:	a90080e7          	jalr	-1392(ra) # 80006380 <release>
          return pid;
    800018f8:	a0b5                	j	80001964 <wait+0x106>
            release(&pp->lock);
    800018fa:	8526                	mv	a0,s1
    800018fc:	00005097          	auipc	ra,0x5
    80001900:	a84080e7          	jalr	-1404(ra) # 80006380 <release>
            release(&wait_lock);
    80001904:	00007517          	auipc	a0,0x7
    80001908:	28450513          	addi	a0,a0,644 # 80008b88 <wait_lock>
    8000190c:	00005097          	auipc	ra,0x5
    80001910:	a74080e7          	jalr	-1420(ra) # 80006380 <release>
            return -1;
    80001914:	59fd                	li	s3,-1
    80001916:	a0b9                	j	80001964 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001918:	17048493          	addi	s1,s1,368
    8000191c:	03348463          	beq	s1,s3,80001944 <wait+0xe6>
      if(pp->parent == p){
    80001920:	7c9c                	ld	a5,56(s1)
    80001922:	ff279be3          	bne	a5,s2,80001918 <wait+0xba>
        acquire(&pp->lock);
    80001926:	8526                	mv	a0,s1
    80001928:	00005097          	auipc	ra,0x5
    8000192c:	9a4080e7          	jalr	-1628(ra) # 800062cc <acquire>
        if(pp->state == ZOMBIE){
    80001930:	4c9c                	lw	a5,24(s1)
    80001932:	f94781e3          	beq	a5,s4,800018b4 <wait+0x56>
        release(&pp->lock);
    80001936:	8526                	mv	a0,s1
    80001938:	00005097          	auipc	ra,0x5
    8000193c:	a48080e7          	jalr	-1464(ra) # 80006380 <release>
        havekids = 1;
    80001940:	8756                	mv	a4,s5
    80001942:	bfd9                	j	80001918 <wait+0xba>
    if(!havekids || killed(p)){
    80001944:	c719                	beqz	a4,80001952 <wait+0xf4>
    80001946:	854a                	mv	a0,s2
    80001948:	00000097          	auipc	ra,0x0
    8000194c:	ee4080e7          	jalr	-284(ra) # 8000182c <killed>
    80001950:	c51d                	beqz	a0,8000197e <wait+0x120>
      release(&wait_lock);
    80001952:	00007517          	auipc	a0,0x7
    80001956:	23650513          	addi	a0,a0,566 # 80008b88 <wait_lock>
    8000195a:	00005097          	auipc	ra,0x5
    8000195e:	a26080e7          	jalr	-1498(ra) # 80006380 <release>
      return -1;
    80001962:	59fd                	li	s3,-1
}
    80001964:	854e                	mv	a0,s3
    80001966:	60a6                	ld	ra,72(sp)
    80001968:	6406                	ld	s0,64(sp)
    8000196a:	74e2                	ld	s1,56(sp)
    8000196c:	7942                	ld	s2,48(sp)
    8000196e:	79a2                	ld	s3,40(sp)
    80001970:	7a02                	ld	s4,32(sp)
    80001972:	6ae2                	ld	s5,24(sp)
    80001974:	6b42                	ld	s6,16(sp)
    80001976:	6ba2                	ld	s7,8(sp)
    80001978:	6c02                	ld	s8,0(sp)
    8000197a:	6161                	addi	sp,sp,80
    8000197c:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000197e:	85e2                	mv	a1,s8
    80001980:	854a                	mv	a0,s2
    80001982:	00000097          	auipc	ra,0x0
    80001986:	c02080e7          	jalr	-1022(ra) # 80001584 <sleep>
    havekids = 0;
    8000198a:	bf39                	j	800018a8 <wait+0x4a>

000000008000198c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000198c:	7179                	addi	sp,sp,-48
    8000198e:	f406                	sd	ra,40(sp)
    80001990:	f022                	sd	s0,32(sp)
    80001992:	ec26                	sd	s1,24(sp)
    80001994:	e84a                	sd	s2,16(sp)
    80001996:	e44e                	sd	s3,8(sp)
    80001998:	e052                	sd	s4,0(sp)
    8000199a:	1800                	addi	s0,sp,48
    8000199c:	84aa                	mv	s1,a0
    8000199e:	892e                	mv	s2,a1
    800019a0:	89b2                	mv	s3,a2
    800019a2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019a4:	fffff097          	auipc	ra,0xfffff
    800019a8:	530080e7          	jalr	1328(ra) # 80000ed4 <myproc>
  if(user_dst){
    800019ac:	c08d                	beqz	s1,800019ce <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019ae:	86d2                	mv	a3,s4
    800019b0:	864e                	mv	a2,s3
    800019b2:	85ca                	mv	a1,s2
    800019b4:	6928                	ld	a0,80(a0)
    800019b6:	fffff097          	auipc	ra,0xfffff
    800019ba:	1a8080e7          	jalr	424(ra) # 80000b5e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019be:	70a2                	ld	ra,40(sp)
    800019c0:	7402                	ld	s0,32(sp)
    800019c2:	64e2                	ld	s1,24(sp)
    800019c4:	6942                	ld	s2,16(sp)
    800019c6:	69a2                	ld	s3,8(sp)
    800019c8:	6a02                	ld	s4,0(sp)
    800019ca:	6145                	addi	sp,sp,48
    800019cc:	8082                	ret
    memmove((char *)dst, src, len);
    800019ce:	000a061b          	sext.w	a2,s4
    800019d2:	85ce                	mv	a1,s3
    800019d4:	854a                	mv	a0,s2
    800019d6:	fffff097          	auipc	ra,0xfffff
    800019da:	826080e7          	jalr	-2010(ra) # 800001fc <memmove>
    return 0;
    800019de:	8526                	mv	a0,s1
    800019e0:	bff9                	j	800019be <either_copyout+0x32>

00000000800019e2 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019e2:	7179                	addi	sp,sp,-48
    800019e4:	f406                	sd	ra,40(sp)
    800019e6:	f022                	sd	s0,32(sp)
    800019e8:	ec26                	sd	s1,24(sp)
    800019ea:	e84a                	sd	s2,16(sp)
    800019ec:	e44e                	sd	s3,8(sp)
    800019ee:	e052                	sd	s4,0(sp)
    800019f0:	1800                	addi	s0,sp,48
    800019f2:	892a                	mv	s2,a0
    800019f4:	84ae                	mv	s1,a1
    800019f6:	89b2                	mv	s3,a2
    800019f8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019fa:	fffff097          	auipc	ra,0xfffff
    800019fe:	4da080e7          	jalr	1242(ra) # 80000ed4 <myproc>
  if(user_src){
    80001a02:	c08d                	beqz	s1,80001a24 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a04:	86d2                	mv	a3,s4
    80001a06:	864e                	mv	a2,s3
    80001a08:	85ca                	mv	a1,s2
    80001a0a:	6928                	ld	a0,80(a0)
    80001a0c:	fffff097          	auipc	ra,0xfffff
    80001a10:	212080e7          	jalr	530(ra) # 80000c1e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a14:	70a2                	ld	ra,40(sp)
    80001a16:	7402                	ld	s0,32(sp)
    80001a18:	64e2                	ld	s1,24(sp)
    80001a1a:	6942                	ld	s2,16(sp)
    80001a1c:	69a2                	ld	s3,8(sp)
    80001a1e:	6a02                	ld	s4,0(sp)
    80001a20:	6145                	addi	sp,sp,48
    80001a22:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a24:	000a061b          	sext.w	a2,s4
    80001a28:	85ce                	mv	a1,s3
    80001a2a:	854a                	mv	a0,s2
    80001a2c:	ffffe097          	auipc	ra,0xffffe
    80001a30:	7d0080e7          	jalr	2000(ra) # 800001fc <memmove>
    return 0;
    80001a34:	8526                	mv	a0,s1
    80001a36:	bff9                	j	80001a14 <either_copyin+0x32>

0000000080001a38 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a38:	715d                	addi	sp,sp,-80
    80001a3a:	e486                	sd	ra,72(sp)
    80001a3c:	e0a2                	sd	s0,64(sp)
    80001a3e:	fc26                	sd	s1,56(sp)
    80001a40:	f84a                	sd	s2,48(sp)
    80001a42:	f44e                	sd	s3,40(sp)
    80001a44:	f052                	sd	s4,32(sp)
    80001a46:	ec56                	sd	s5,24(sp)
    80001a48:	e85a                	sd	s6,16(sp)
    80001a4a:	e45e                	sd	s7,8(sp)
    80001a4c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a4e:	00006517          	auipc	a0,0x6
    80001a52:	5fa50513          	addi	a0,a0,1530 # 80008048 <etext+0x48>
    80001a56:	00004097          	auipc	ra,0x4
    80001a5a:	376080e7          	jalr	886(ra) # 80005dcc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a5e:	00007497          	auipc	s1,0x7
    80001a62:	69a48493          	addi	s1,s1,1690 # 800090f8 <proc+0x158>
    80001a66:	0000d917          	auipc	s2,0xd
    80001a6a:	29290913          	addi	s2,s2,658 # 8000ecf8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a6e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a70:	00006997          	auipc	s3,0x6
    80001a74:	7d098993          	addi	s3,s3,2000 # 80008240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001a78:	00006a97          	auipc	s5,0x6
    80001a7c:	7d0a8a93          	addi	s5,s5,2000 # 80008248 <etext+0x248>
    printf("\n");
    80001a80:	00006a17          	auipc	s4,0x6
    80001a84:	5c8a0a13          	addi	s4,s4,1480 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a88:	00007b97          	auipc	s7,0x7
    80001a8c:	800b8b93          	addi	s7,s7,-2048 # 80008288 <states.1727>
    80001a90:	a00d                	j	80001ab2 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a92:	ed86a583          	lw	a1,-296(a3)
    80001a96:	8556                	mv	a0,s5
    80001a98:	00004097          	auipc	ra,0x4
    80001a9c:	334080e7          	jalr	820(ra) # 80005dcc <printf>
    printf("\n");
    80001aa0:	8552                	mv	a0,s4
    80001aa2:	00004097          	auipc	ra,0x4
    80001aa6:	32a080e7          	jalr	810(ra) # 80005dcc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001aaa:	17048493          	addi	s1,s1,368
    80001aae:	03248163          	beq	s1,s2,80001ad0 <procdump+0x98>
    if(p->state == UNUSED)
    80001ab2:	86a6                	mv	a3,s1
    80001ab4:	ec04a783          	lw	a5,-320(s1)
    80001ab8:	dbed                	beqz	a5,80001aaa <procdump+0x72>
      state = "???";
    80001aba:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001abc:	fcfb6be3          	bltu	s6,a5,80001a92 <procdump+0x5a>
    80001ac0:	1782                	slli	a5,a5,0x20
    80001ac2:	9381                	srli	a5,a5,0x20
    80001ac4:	078e                	slli	a5,a5,0x3
    80001ac6:	97de                	add	a5,a5,s7
    80001ac8:	6390                	ld	a2,0(a5)
    80001aca:	f661                	bnez	a2,80001a92 <procdump+0x5a>
      state = "???";
    80001acc:	864e                	mv	a2,s3
    80001ace:	b7d1                	j	80001a92 <procdump+0x5a>
  }
}
    80001ad0:	60a6                	ld	ra,72(sp)
    80001ad2:	6406                	ld	s0,64(sp)
    80001ad4:	74e2                	ld	s1,56(sp)
    80001ad6:	7942                	ld	s2,48(sp)
    80001ad8:	79a2                	ld	s3,40(sp)
    80001ada:	7a02                	ld	s4,32(sp)
    80001adc:	6ae2                	ld	s5,24(sp)
    80001ade:	6b42                	ld	s6,16(sp)
    80001ae0:	6ba2                	ld	s7,8(sp)
    80001ae2:	6161                	addi	sp,sp,80
    80001ae4:	8082                	ret

0000000080001ae6 <get_nproc>:

uint64
get_nproc(void)
{
    80001ae6:	7179                	addi	sp,sp,-48
    80001ae8:	f406                	sd	ra,40(sp)
    80001aea:	f022                	sd	s0,32(sp)
    80001aec:	ec26                	sd	s1,24(sp)
    80001aee:	e84a                	sd	s2,16(sp)
    80001af0:	e44e                	sd	s3,8(sp)
    80001af2:	1800                	addi	s0,sp,48
  uint64 nproc = 0;
  struct proc *p;
  /* use spinlock to avoid race(accessing 'nproc') between different threads */
  for (p = &proc[0]; p < &proc[NPROC]; p++)
    80001af4:	00007497          	auipc	s1,0x7
    80001af8:	4ac48493          	addi	s1,s1,1196 # 80008fa0 <proc>
  uint64 nproc = 0;
    80001afc:	4901                	li	s2,0
  for (p = &proc[0]; p < &proc[NPROC]; p++)
    80001afe:	0000d997          	auipc	s3,0xd
    80001b02:	0a298993          	addi	s3,s3,162 # 8000eba0 <tickslock>
  {
    acquire(&p->lock);
    80001b06:	8526                	mv	a0,s1
    80001b08:	00004097          	auipc	ra,0x4
    80001b0c:	7c4080e7          	jalr	1988(ra) # 800062cc <acquire>
    if (p->state != UNUSED)
    80001b10:	4c9c                	lw	a5,24(s1)
      nproc++;
    80001b12:	00f037b3          	snez	a5,a5
    80001b16:	993e                	add	s2,s2,a5
    release(&p->lock);
    80001b18:	8526                	mv	a0,s1
    80001b1a:	00005097          	auipc	ra,0x5
    80001b1e:	866080e7          	jalr	-1946(ra) # 80006380 <release>
  for (p = &proc[0]; p < &proc[NPROC]; p++)
    80001b22:	17048493          	addi	s1,s1,368
    80001b26:	ff3490e3          	bne	s1,s3,80001b06 <get_nproc+0x20>
  }
  return nproc;
}
    80001b2a:	854a                	mv	a0,s2
    80001b2c:	70a2                	ld	ra,40(sp)
    80001b2e:	7402                	ld	s0,32(sp)
    80001b30:	64e2                	ld	s1,24(sp)
    80001b32:	6942                	ld	s2,16(sp)
    80001b34:	69a2                	ld	s3,8(sp)
    80001b36:	6145                	addi	sp,sp,48
    80001b38:	8082                	ret

0000000080001b3a <swtch>:
    80001b3a:	00153023          	sd	ra,0(a0)
    80001b3e:	00253423          	sd	sp,8(a0)
    80001b42:	e900                	sd	s0,16(a0)
    80001b44:	ed04                	sd	s1,24(a0)
    80001b46:	03253023          	sd	s2,32(a0)
    80001b4a:	03353423          	sd	s3,40(a0)
    80001b4e:	03453823          	sd	s4,48(a0)
    80001b52:	03553c23          	sd	s5,56(a0)
    80001b56:	05653023          	sd	s6,64(a0)
    80001b5a:	05753423          	sd	s7,72(a0)
    80001b5e:	05853823          	sd	s8,80(a0)
    80001b62:	05953c23          	sd	s9,88(a0)
    80001b66:	07a53023          	sd	s10,96(a0)
    80001b6a:	07b53423          	sd	s11,104(a0)
    80001b6e:	0005b083          	ld	ra,0(a1)
    80001b72:	0085b103          	ld	sp,8(a1)
    80001b76:	6980                	ld	s0,16(a1)
    80001b78:	6d84                	ld	s1,24(a1)
    80001b7a:	0205b903          	ld	s2,32(a1)
    80001b7e:	0285b983          	ld	s3,40(a1)
    80001b82:	0305ba03          	ld	s4,48(a1)
    80001b86:	0385ba83          	ld	s5,56(a1)
    80001b8a:	0405bb03          	ld	s6,64(a1)
    80001b8e:	0485bb83          	ld	s7,72(a1)
    80001b92:	0505bc03          	ld	s8,80(a1)
    80001b96:	0585bc83          	ld	s9,88(a1)
    80001b9a:	0605bd03          	ld	s10,96(a1)
    80001b9e:	0685bd83          	ld	s11,104(a1)
    80001ba2:	8082                	ret

0000000080001ba4 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ba4:	1141                	addi	sp,sp,-16
    80001ba6:	e406                	sd	ra,8(sp)
    80001ba8:	e022                	sd	s0,0(sp)
    80001baa:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001bac:	00006597          	auipc	a1,0x6
    80001bb0:	70c58593          	addi	a1,a1,1804 # 800082b8 <states.1727+0x30>
    80001bb4:	0000d517          	auipc	a0,0xd
    80001bb8:	fec50513          	addi	a0,a0,-20 # 8000eba0 <tickslock>
    80001bbc:	00004097          	auipc	ra,0x4
    80001bc0:	680080e7          	jalr	1664(ra) # 8000623c <initlock>
}
    80001bc4:	60a2                	ld	ra,8(sp)
    80001bc6:	6402                	ld	s0,0(sp)
    80001bc8:	0141                	addi	sp,sp,16
    80001bca:	8082                	ret

0000000080001bcc <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001bcc:	1141                	addi	sp,sp,-16
    80001bce:	e422                	sd	s0,8(sp)
    80001bd0:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bd2:	00003797          	auipc	a5,0x3
    80001bd6:	57e78793          	addi	a5,a5,1406 # 80005150 <kernelvec>
    80001bda:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001bde:	6422                	ld	s0,8(sp)
    80001be0:	0141                	addi	sp,sp,16
    80001be2:	8082                	ret

0000000080001be4 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001be4:	1141                	addi	sp,sp,-16
    80001be6:	e406                	sd	ra,8(sp)
    80001be8:	e022                	sd	s0,0(sp)
    80001bea:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bec:	fffff097          	auipc	ra,0xfffff
    80001bf0:	2e8080e7          	jalr	744(ra) # 80000ed4 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bf4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001bf8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bfa:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001bfe:	00005617          	auipc	a2,0x5
    80001c02:	40260613          	addi	a2,a2,1026 # 80007000 <_trampoline>
    80001c06:	00005697          	auipc	a3,0x5
    80001c0a:	3fa68693          	addi	a3,a3,1018 # 80007000 <_trampoline>
    80001c0e:	8e91                	sub	a3,a3,a2
    80001c10:	040007b7          	lui	a5,0x4000
    80001c14:	17fd                	addi	a5,a5,-1
    80001c16:	07b2                	slli	a5,a5,0xc
    80001c18:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c1a:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c1e:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c20:	180026f3          	csrr	a3,satp
    80001c24:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c26:	6d38                	ld	a4,88(a0)
    80001c28:	6134                	ld	a3,64(a0)
    80001c2a:	6585                	lui	a1,0x1
    80001c2c:	96ae                	add	a3,a3,a1
    80001c2e:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c30:	6d38                	ld	a4,88(a0)
    80001c32:	00000697          	auipc	a3,0x0
    80001c36:	13068693          	addi	a3,a3,304 # 80001d62 <usertrap>
    80001c3a:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c3c:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c3e:	8692                	mv	a3,tp
    80001c40:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c42:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c46:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c4a:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c4e:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c52:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c54:	6f18                	ld	a4,24(a4)
    80001c56:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c5a:	6928                	ld	a0,80(a0)
    80001c5c:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c5e:	00005717          	auipc	a4,0x5
    80001c62:	43e70713          	addi	a4,a4,1086 # 8000709c <userret>
    80001c66:	8f11                	sub	a4,a4,a2
    80001c68:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c6a:	577d                	li	a4,-1
    80001c6c:	177e                	slli	a4,a4,0x3f
    80001c6e:	8d59                	or	a0,a0,a4
    80001c70:	9782                	jalr	a5
}
    80001c72:	60a2                	ld	ra,8(sp)
    80001c74:	6402                	ld	s0,0(sp)
    80001c76:	0141                	addi	sp,sp,16
    80001c78:	8082                	ret

0000000080001c7a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c7a:	1101                	addi	sp,sp,-32
    80001c7c:	ec06                	sd	ra,24(sp)
    80001c7e:	e822                	sd	s0,16(sp)
    80001c80:	e426                	sd	s1,8(sp)
    80001c82:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c84:	0000d497          	auipc	s1,0xd
    80001c88:	f1c48493          	addi	s1,s1,-228 # 8000eba0 <tickslock>
    80001c8c:	8526                	mv	a0,s1
    80001c8e:	00004097          	auipc	ra,0x4
    80001c92:	63e080e7          	jalr	1598(ra) # 800062cc <acquire>
  ticks++;
    80001c96:	00007517          	auipc	a0,0x7
    80001c9a:	ea250513          	addi	a0,a0,-350 # 80008b38 <ticks>
    80001c9e:	411c                	lw	a5,0(a0)
    80001ca0:	2785                	addiw	a5,a5,1
    80001ca2:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001ca4:	00000097          	auipc	ra,0x0
    80001ca8:	944080e7          	jalr	-1724(ra) # 800015e8 <wakeup>
  release(&tickslock);
    80001cac:	8526                	mv	a0,s1
    80001cae:	00004097          	auipc	ra,0x4
    80001cb2:	6d2080e7          	jalr	1746(ra) # 80006380 <release>
}
    80001cb6:	60e2                	ld	ra,24(sp)
    80001cb8:	6442                	ld	s0,16(sp)
    80001cba:	64a2                	ld	s1,8(sp)
    80001cbc:	6105                	addi	sp,sp,32
    80001cbe:	8082                	ret

0000000080001cc0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001cc0:	1101                	addi	sp,sp,-32
    80001cc2:	ec06                	sd	ra,24(sp)
    80001cc4:	e822                	sd	s0,16(sp)
    80001cc6:	e426                	sd	s1,8(sp)
    80001cc8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cca:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001cce:	00074d63          	bltz	a4,80001ce8 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001cd2:	57fd                	li	a5,-1
    80001cd4:	17fe                	slli	a5,a5,0x3f
    80001cd6:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001cd8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001cda:	06f70363          	beq	a4,a5,80001d40 <devintr+0x80>
  }
}
    80001cde:	60e2                	ld	ra,24(sp)
    80001ce0:	6442                	ld	s0,16(sp)
    80001ce2:	64a2                	ld	s1,8(sp)
    80001ce4:	6105                	addi	sp,sp,32
    80001ce6:	8082                	ret
     (scause & 0xff) == 9){
    80001ce8:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001cec:	46a5                	li	a3,9
    80001cee:	fed792e3          	bne	a5,a3,80001cd2 <devintr+0x12>
    int irq = plic_claim();
    80001cf2:	00003097          	auipc	ra,0x3
    80001cf6:	566080e7          	jalr	1382(ra) # 80005258 <plic_claim>
    80001cfa:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001cfc:	47a9                	li	a5,10
    80001cfe:	02f50763          	beq	a0,a5,80001d2c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d02:	4785                	li	a5,1
    80001d04:	02f50963          	beq	a0,a5,80001d36 <devintr+0x76>
    return 1;
    80001d08:	4505                	li	a0,1
    } else if(irq){
    80001d0a:	d8f1                	beqz	s1,80001cde <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d0c:	85a6                	mv	a1,s1
    80001d0e:	00006517          	auipc	a0,0x6
    80001d12:	5b250513          	addi	a0,a0,1458 # 800082c0 <states.1727+0x38>
    80001d16:	00004097          	auipc	ra,0x4
    80001d1a:	0b6080e7          	jalr	182(ra) # 80005dcc <printf>
      plic_complete(irq);
    80001d1e:	8526                	mv	a0,s1
    80001d20:	00003097          	auipc	ra,0x3
    80001d24:	55c080e7          	jalr	1372(ra) # 8000527c <plic_complete>
    return 1;
    80001d28:	4505                	li	a0,1
    80001d2a:	bf55                	j	80001cde <devintr+0x1e>
      uartintr();
    80001d2c:	00004097          	auipc	ra,0x4
    80001d30:	4c0080e7          	jalr	1216(ra) # 800061ec <uartintr>
    80001d34:	b7ed                	j	80001d1e <devintr+0x5e>
      virtio_disk_intr();
    80001d36:	00004097          	auipc	ra,0x4
    80001d3a:	a70080e7          	jalr	-1424(ra) # 800057a6 <virtio_disk_intr>
    80001d3e:	b7c5                	j	80001d1e <devintr+0x5e>
    if(cpuid() == 0){
    80001d40:	fffff097          	auipc	ra,0xfffff
    80001d44:	168080e7          	jalr	360(ra) # 80000ea8 <cpuid>
    80001d48:	c901                	beqz	a0,80001d58 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d4a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d4e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d50:	14479073          	csrw	sip,a5
    return 2;
    80001d54:	4509                	li	a0,2
    80001d56:	b761                	j	80001cde <devintr+0x1e>
      clockintr();
    80001d58:	00000097          	auipc	ra,0x0
    80001d5c:	f22080e7          	jalr	-222(ra) # 80001c7a <clockintr>
    80001d60:	b7ed                	j	80001d4a <devintr+0x8a>

0000000080001d62 <usertrap>:
{
    80001d62:	1101                	addi	sp,sp,-32
    80001d64:	ec06                	sd	ra,24(sp)
    80001d66:	e822                	sd	s0,16(sp)
    80001d68:	e426                	sd	s1,8(sp)
    80001d6a:	e04a                	sd	s2,0(sp)
    80001d6c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d6e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d72:	1007f793          	andi	a5,a5,256
    80001d76:	e3b1                	bnez	a5,80001dba <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d78:	00003797          	auipc	a5,0x3
    80001d7c:	3d878793          	addi	a5,a5,984 # 80005150 <kernelvec>
    80001d80:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d84:	fffff097          	auipc	ra,0xfffff
    80001d88:	150080e7          	jalr	336(ra) # 80000ed4 <myproc>
    80001d8c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d8e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d90:	14102773          	csrr	a4,sepc
    80001d94:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d96:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d9a:	47a1                	li	a5,8
    80001d9c:	02f70763          	beq	a4,a5,80001dca <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001da0:	00000097          	auipc	ra,0x0
    80001da4:	f20080e7          	jalr	-224(ra) # 80001cc0 <devintr>
    80001da8:	892a                	mv	s2,a0
    80001daa:	c151                	beqz	a0,80001e2e <usertrap+0xcc>
  if(killed(p))
    80001dac:	8526                	mv	a0,s1
    80001dae:	00000097          	auipc	ra,0x0
    80001db2:	a7e080e7          	jalr	-1410(ra) # 8000182c <killed>
    80001db6:	c929                	beqz	a0,80001e08 <usertrap+0xa6>
    80001db8:	a099                	j	80001dfe <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001dba:	00006517          	auipc	a0,0x6
    80001dbe:	52650513          	addi	a0,a0,1318 # 800082e0 <states.1727+0x58>
    80001dc2:	00004097          	auipc	ra,0x4
    80001dc6:	fc0080e7          	jalr	-64(ra) # 80005d82 <panic>
    if(killed(p))
    80001dca:	00000097          	auipc	ra,0x0
    80001dce:	a62080e7          	jalr	-1438(ra) # 8000182c <killed>
    80001dd2:	e921                	bnez	a0,80001e22 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001dd4:	6cb8                	ld	a4,88(s1)
    80001dd6:	6f1c                	ld	a5,24(a4)
    80001dd8:	0791                	addi	a5,a5,4
    80001dda:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ddc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001de0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001de4:	10079073          	csrw	sstatus,a5
    syscall();
    80001de8:	00000097          	auipc	ra,0x0
    80001dec:	2d4080e7          	jalr	724(ra) # 800020bc <syscall>
  if(killed(p))
    80001df0:	8526                	mv	a0,s1
    80001df2:	00000097          	auipc	ra,0x0
    80001df6:	a3a080e7          	jalr	-1478(ra) # 8000182c <killed>
    80001dfa:	c911                	beqz	a0,80001e0e <usertrap+0xac>
    80001dfc:	4901                	li	s2,0
    exit(-1);
    80001dfe:	557d                	li	a0,-1
    80001e00:	00000097          	auipc	ra,0x0
    80001e04:	8b8080e7          	jalr	-1864(ra) # 800016b8 <exit>
  if(which_dev == 2)
    80001e08:	4789                	li	a5,2
    80001e0a:	04f90f63          	beq	s2,a5,80001e68 <usertrap+0x106>
  usertrapret();
    80001e0e:	00000097          	auipc	ra,0x0
    80001e12:	dd6080e7          	jalr	-554(ra) # 80001be4 <usertrapret>
}
    80001e16:	60e2                	ld	ra,24(sp)
    80001e18:	6442                	ld	s0,16(sp)
    80001e1a:	64a2                	ld	s1,8(sp)
    80001e1c:	6902                	ld	s2,0(sp)
    80001e1e:	6105                	addi	sp,sp,32
    80001e20:	8082                	ret
      exit(-1);
    80001e22:	557d                	li	a0,-1
    80001e24:	00000097          	auipc	ra,0x0
    80001e28:	894080e7          	jalr	-1900(ra) # 800016b8 <exit>
    80001e2c:	b765                	j	80001dd4 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e2e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e32:	5890                	lw	a2,48(s1)
    80001e34:	00006517          	auipc	a0,0x6
    80001e38:	4cc50513          	addi	a0,a0,1228 # 80008300 <states.1727+0x78>
    80001e3c:	00004097          	auipc	ra,0x4
    80001e40:	f90080e7          	jalr	-112(ra) # 80005dcc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e44:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e48:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e4c:	00006517          	auipc	a0,0x6
    80001e50:	4e450513          	addi	a0,a0,1252 # 80008330 <states.1727+0xa8>
    80001e54:	00004097          	auipc	ra,0x4
    80001e58:	f78080e7          	jalr	-136(ra) # 80005dcc <printf>
    setkilled(p);
    80001e5c:	8526                	mv	a0,s1
    80001e5e:	00000097          	auipc	ra,0x0
    80001e62:	9a2080e7          	jalr	-1630(ra) # 80001800 <setkilled>
    80001e66:	b769                	j	80001df0 <usertrap+0x8e>
    yield();
    80001e68:	fffff097          	auipc	ra,0xfffff
    80001e6c:	6e0080e7          	jalr	1760(ra) # 80001548 <yield>
    80001e70:	bf79                	j	80001e0e <usertrap+0xac>

0000000080001e72 <kerneltrap>:
{
    80001e72:	7179                	addi	sp,sp,-48
    80001e74:	f406                	sd	ra,40(sp)
    80001e76:	f022                	sd	s0,32(sp)
    80001e78:	ec26                	sd	s1,24(sp)
    80001e7a:	e84a                	sd	s2,16(sp)
    80001e7c:	e44e                	sd	s3,8(sp)
    80001e7e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e80:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e84:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e88:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e8c:	1004f793          	andi	a5,s1,256
    80001e90:	cb85                	beqz	a5,80001ec0 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e92:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e96:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e98:	ef85                	bnez	a5,80001ed0 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e9a:	00000097          	auipc	ra,0x0
    80001e9e:	e26080e7          	jalr	-474(ra) # 80001cc0 <devintr>
    80001ea2:	cd1d                	beqz	a0,80001ee0 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ea4:	4789                	li	a5,2
    80001ea6:	06f50a63          	beq	a0,a5,80001f1a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001eaa:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001eae:	10049073          	csrw	sstatus,s1
}
    80001eb2:	70a2                	ld	ra,40(sp)
    80001eb4:	7402                	ld	s0,32(sp)
    80001eb6:	64e2                	ld	s1,24(sp)
    80001eb8:	6942                	ld	s2,16(sp)
    80001eba:	69a2                	ld	s3,8(sp)
    80001ebc:	6145                	addi	sp,sp,48
    80001ebe:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ec0:	00006517          	auipc	a0,0x6
    80001ec4:	49050513          	addi	a0,a0,1168 # 80008350 <states.1727+0xc8>
    80001ec8:	00004097          	auipc	ra,0x4
    80001ecc:	eba080e7          	jalr	-326(ra) # 80005d82 <panic>
    panic("kerneltrap: interrupts enabled");
    80001ed0:	00006517          	auipc	a0,0x6
    80001ed4:	4a850513          	addi	a0,a0,1192 # 80008378 <states.1727+0xf0>
    80001ed8:	00004097          	auipc	ra,0x4
    80001edc:	eaa080e7          	jalr	-342(ra) # 80005d82 <panic>
    printf("scause %p\n", scause);
    80001ee0:	85ce                	mv	a1,s3
    80001ee2:	00006517          	auipc	a0,0x6
    80001ee6:	4b650513          	addi	a0,a0,1206 # 80008398 <states.1727+0x110>
    80001eea:	00004097          	auipc	ra,0x4
    80001eee:	ee2080e7          	jalr	-286(ra) # 80005dcc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ef2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ef6:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001efa:	00006517          	auipc	a0,0x6
    80001efe:	4ae50513          	addi	a0,a0,1198 # 800083a8 <states.1727+0x120>
    80001f02:	00004097          	auipc	ra,0x4
    80001f06:	eca080e7          	jalr	-310(ra) # 80005dcc <printf>
    panic("kerneltrap");
    80001f0a:	00006517          	auipc	a0,0x6
    80001f0e:	4b650513          	addi	a0,a0,1206 # 800083c0 <states.1727+0x138>
    80001f12:	00004097          	auipc	ra,0x4
    80001f16:	e70080e7          	jalr	-400(ra) # 80005d82 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f1a:	fffff097          	auipc	ra,0xfffff
    80001f1e:	fba080e7          	jalr	-70(ra) # 80000ed4 <myproc>
    80001f22:	d541                	beqz	a0,80001eaa <kerneltrap+0x38>
    80001f24:	fffff097          	auipc	ra,0xfffff
    80001f28:	fb0080e7          	jalr	-80(ra) # 80000ed4 <myproc>
    80001f2c:	4d18                	lw	a4,24(a0)
    80001f2e:	4791                	li	a5,4
    80001f30:	f6f71de3          	bne	a4,a5,80001eaa <kerneltrap+0x38>
    yield();
    80001f34:	fffff097          	auipc	ra,0xfffff
    80001f38:	614080e7          	jalr	1556(ra) # 80001548 <yield>
    80001f3c:	b7bd                	j	80001eaa <kerneltrap+0x38>

0000000080001f3e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f3e:	1101                	addi	sp,sp,-32
    80001f40:	ec06                	sd	ra,24(sp)
    80001f42:	e822                	sd	s0,16(sp)
    80001f44:	e426                	sd	s1,8(sp)
    80001f46:	1000                	addi	s0,sp,32
    80001f48:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f4a:	fffff097          	auipc	ra,0xfffff
    80001f4e:	f8a080e7          	jalr	-118(ra) # 80000ed4 <myproc>
  switch (n)
    80001f52:	4795                	li	a5,5
    80001f54:	0497e163          	bltu	a5,s1,80001f96 <argraw+0x58>
    80001f58:	048a                	slli	s1,s1,0x2
    80001f5a:	00006717          	auipc	a4,0x6
    80001f5e:	61e70713          	addi	a4,a4,1566 # 80008578 <states.1727+0x2f0>
    80001f62:	94ba                	add	s1,s1,a4
    80001f64:	409c                	lw	a5,0(s1)
    80001f66:	97ba                	add	a5,a5,a4
    80001f68:	8782                	jr	a5
  {
  case 0:
    return p->trapframe->a0;
    80001f6a:	6d3c                	ld	a5,88(a0)
    80001f6c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f6e:	60e2                	ld	ra,24(sp)
    80001f70:	6442                	ld	s0,16(sp)
    80001f72:	64a2                	ld	s1,8(sp)
    80001f74:	6105                	addi	sp,sp,32
    80001f76:	8082                	ret
    return p->trapframe->a1;
    80001f78:	6d3c                	ld	a5,88(a0)
    80001f7a:	7fa8                	ld	a0,120(a5)
    80001f7c:	bfcd                	j	80001f6e <argraw+0x30>
    return p->trapframe->a2;
    80001f7e:	6d3c                	ld	a5,88(a0)
    80001f80:	63c8                	ld	a0,128(a5)
    80001f82:	b7f5                	j	80001f6e <argraw+0x30>
    return p->trapframe->a3;
    80001f84:	6d3c                	ld	a5,88(a0)
    80001f86:	67c8                	ld	a0,136(a5)
    80001f88:	b7dd                	j	80001f6e <argraw+0x30>
    return p->trapframe->a4;
    80001f8a:	6d3c                	ld	a5,88(a0)
    80001f8c:	6bc8                	ld	a0,144(a5)
    80001f8e:	b7c5                	j	80001f6e <argraw+0x30>
    return p->trapframe->a5;
    80001f90:	6d3c                	ld	a5,88(a0)
    80001f92:	6fc8                	ld	a0,152(a5)
    80001f94:	bfe9                	j	80001f6e <argraw+0x30>
  panic("argraw");
    80001f96:	00006517          	auipc	a0,0x6
    80001f9a:	43a50513          	addi	a0,a0,1082 # 800083d0 <states.1727+0x148>
    80001f9e:	00004097          	auipc	ra,0x4
    80001fa2:	de4080e7          	jalr	-540(ra) # 80005d82 <panic>

0000000080001fa6 <fetchaddr>:
{
    80001fa6:	1101                	addi	sp,sp,-32
    80001fa8:	ec06                	sd	ra,24(sp)
    80001faa:	e822                	sd	s0,16(sp)
    80001fac:	e426                	sd	s1,8(sp)
    80001fae:	e04a                	sd	s2,0(sp)
    80001fb0:	1000                	addi	s0,sp,32
    80001fb2:	84aa                	mv	s1,a0
    80001fb4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001fb6:	fffff097          	auipc	ra,0xfffff
    80001fba:	f1e080e7          	jalr	-226(ra) # 80000ed4 <myproc>
  if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001fbe:	653c                	ld	a5,72(a0)
    80001fc0:	02f4f863          	bgeu	s1,a5,80001ff0 <fetchaddr+0x4a>
    80001fc4:	00848713          	addi	a4,s1,8
    80001fc8:	02e7e663          	bltu	a5,a4,80001ff4 <fetchaddr+0x4e>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001fcc:	46a1                	li	a3,8
    80001fce:	8626                	mv	a2,s1
    80001fd0:	85ca                	mv	a1,s2
    80001fd2:	6928                	ld	a0,80(a0)
    80001fd4:	fffff097          	auipc	ra,0xfffff
    80001fd8:	c4a080e7          	jalr	-950(ra) # 80000c1e <copyin>
    80001fdc:	00a03533          	snez	a0,a0
    80001fe0:	40a00533          	neg	a0,a0
}
    80001fe4:	60e2                	ld	ra,24(sp)
    80001fe6:	6442                	ld	s0,16(sp)
    80001fe8:	64a2                	ld	s1,8(sp)
    80001fea:	6902                	ld	s2,0(sp)
    80001fec:	6105                	addi	sp,sp,32
    80001fee:	8082                	ret
    return -1;
    80001ff0:	557d                	li	a0,-1
    80001ff2:	bfcd                	j	80001fe4 <fetchaddr+0x3e>
    80001ff4:	557d                	li	a0,-1
    80001ff6:	b7fd                	j	80001fe4 <fetchaddr+0x3e>

0000000080001ff8 <fetchstr>:
{
    80001ff8:	7179                	addi	sp,sp,-48
    80001ffa:	f406                	sd	ra,40(sp)
    80001ffc:	f022                	sd	s0,32(sp)
    80001ffe:	ec26                	sd	s1,24(sp)
    80002000:	e84a                	sd	s2,16(sp)
    80002002:	e44e                	sd	s3,8(sp)
    80002004:	1800                	addi	s0,sp,48
    80002006:	892a                	mv	s2,a0
    80002008:	84ae                	mv	s1,a1
    8000200a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000200c:	fffff097          	auipc	ra,0xfffff
    80002010:	ec8080e7          	jalr	-312(ra) # 80000ed4 <myproc>
  if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80002014:	86ce                	mv	a3,s3
    80002016:	864a                	mv	a2,s2
    80002018:	85a6                	mv	a1,s1
    8000201a:	6928                	ld	a0,80(a0)
    8000201c:	fffff097          	auipc	ra,0xfffff
    80002020:	c8e080e7          	jalr	-882(ra) # 80000caa <copyinstr>
    80002024:	00054e63          	bltz	a0,80002040 <fetchstr+0x48>
  return strlen(buf);
    80002028:	8526                	mv	a0,s1
    8000202a:	ffffe097          	auipc	ra,0xffffe
    8000202e:	2f6080e7          	jalr	758(ra) # 80000320 <strlen>
}
    80002032:	70a2                	ld	ra,40(sp)
    80002034:	7402                	ld	s0,32(sp)
    80002036:	64e2                	ld	s1,24(sp)
    80002038:	6942                	ld	s2,16(sp)
    8000203a:	69a2                	ld	s3,8(sp)
    8000203c:	6145                	addi	sp,sp,48
    8000203e:	8082                	ret
    return -1;
    80002040:	557d                	li	a0,-1
    80002042:	bfc5                	j	80002032 <fetchstr+0x3a>

0000000080002044 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    80002044:	1101                	addi	sp,sp,-32
    80002046:	ec06                	sd	ra,24(sp)
    80002048:	e822                	sd	s0,16(sp)
    8000204a:	e426                	sd	s1,8(sp)
    8000204c:	1000                	addi	s0,sp,32
    8000204e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002050:	00000097          	auipc	ra,0x0
    80002054:	eee080e7          	jalr	-274(ra) # 80001f3e <argraw>
    80002058:	c088                	sw	a0,0(s1)
}
    8000205a:	60e2                	ld	ra,24(sp)
    8000205c:	6442                	ld	s0,16(sp)
    8000205e:	64a2                	ld	s1,8(sp)
    80002060:	6105                	addi	sp,sp,32
    80002062:	8082                	ret

0000000080002064 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    80002064:	1101                	addi	sp,sp,-32
    80002066:	ec06                	sd	ra,24(sp)
    80002068:	e822                	sd	s0,16(sp)
    8000206a:	e426                	sd	s1,8(sp)
    8000206c:	1000                	addi	s0,sp,32
    8000206e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002070:	00000097          	auipc	ra,0x0
    80002074:	ece080e7          	jalr	-306(ra) # 80001f3e <argraw>
    80002078:	e088                	sd	a0,0(s1)
}
    8000207a:	60e2                	ld	ra,24(sp)
    8000207c:	6442                	ld	s0,16(sp)
    8000207e:	64a2                	ld	s1,8(sp)
    80002080:	6105                	addi	sp,sp,32
    80002082:	8082                	ret

0000000080002084 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    80002084:	7179                	addi	sp,sp,-48
    80002086:	f406                	sd	ra,40(sp)
    80002088:	f022                	sd	s0,32(sp)
    8000208a:	ec26                	sd	s1,24(sp)
    8000208c:	e84a                	sd	s2,16(sp)
    8000208e:	1800                	addi	s0,sp,48
    80002090:	84ae                	mv	s1,a1
    80002092:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002094:	fd840593          	addi	a1,s0,-40
    80002098:	00000097          	auipc	ra,0x0
    8000209c:	fcc080e7          	jalr	-52(ra) # 80002064 <argaddr>
  return fetchstr(addr, buf, max);
    800020a0:	864a                	mv	a2,s2
    800020a2:	85a6                	mv	a1,s1
    800020a4:	fd843503          	ld	a0,-40(s0)
    800020a8:	00000097          	auipc	ra,0x0
    800020ac:	f50080e7          	jalr	-176(ra) # 80001ff8 <fetchstr>
}
    800020b0:	70a2                	ld	ra,40(sp)
    800020b2:	7402                	ld	s0,32(sp)
    800020b4:	64e2                	ld	s1,24(sp)
    800020b6:	6942                	ld	s2,16(sp)
    800020b8:	6145                	addi	sp,sp,48
    800020ba:	8082                	ret

00000000800020bc <syscall>:
    [SYS_trace] "syscall trace",
    [SYS_sysinfo] "syscall sysinfo",
};

void syscall(void)
{
    800020bc:	7179                	addi	sp,sp,-48
    800020be:	f406                	sd	ra,40(sp)
    800020c0:	f022                	sd	s0,32(sp)
    800020c2:	ec26                	sd	s1,24(sp)
    800020c4:	e84a                	sd	s2,16(sp)
    800020c6:	e44e                	sd	s3,8(sp)
    800020c8:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    800020ca:	fffff097          	auipc	ra,0xfffff
    800020ce:	e0a080e7          	jalr	-502(ra) # 80000ed4 <myproc>
    800020d2:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020d4:	6d3c                	ld	a5,88(a0)
    800020d6:	77dc                	ld	a5,168(a5)
    800020d8:	0007891b          	sext.w	s2,a5

  if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    800020dc:	37fd                	addiw	a5,a5,-1
    800020de:	4759                	li	a4,22
    800020e0:	04f76a63          	bltu	a4,a5,80002134 <syscall+0x78>
    800020e4:	00391713          	slli	a4,s2,0x3
    800020e8:	00006797          	auipc	a5,0x6
    800020ec:	4a878793          	addi	a5,a5,1192 # 80008590 <syscalls>
    800020f0:	97ba                	add	a5,a5,a4
    800020f2:	639c                	ld	a5,0(a5)
    800020f4:	c3a1                	beqz	a5,80002134 <syscall+0x78>
  {
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    uint64 a0 = syscalls[num]();
    800020f6:	9782                	jalr	a5
    800020f8:	89aa                	mv	s3,a0
    if ((p->mask >> num) & 0b1)
    800020fa:	1684b783          	ld	a5,360(s1)
    800020fe:	0127d7b3          	srl	a5,a5,s2
    80002102:	8b85                	andi	a5,a5,1
    80002104:	e789                	bnez	a5,8000210e <syscall+0x52>
    {
      printf("%d: %s -> %d\n", p->pid, syscalls_name[num], a0);
    }
    p->trapframe->a0 = a0;
    80002106:	6cbc                	ld	a5,88(s1)
    80002108:	0737b823          	sd	s3,112(a5)
  {
    8000210c:	a099                	j	80002152 <syscall+0x96>
      printf("%d: %s -> %d\n", p->pid, syscalls_name[num], a0);
    8000210e:	090e                	slli	s2,s2,0x3
    80002110:	00007797          	auipc	a5,0x7
    80002114:	94878793          	addi	a5,a5,-1720 # 80008a58 <syscalls_name>
    80002118:	993e                	add	s2,s2,a5
    8000211a:	86aa                	mv	a3,a0
    8000211c:	00093603          	ld	a2,0(s2)
    80002120:	588c                	lw	a1,48(s1)
    80002122:	00006517          	auipc	a0,0x6
    80002126:	2b650513          	addi	a0,a0,694 # 800083d8 <states.1727+0x150>
    8000212a:	00004097          	auipc	ra,0x4
    8000212e:	ca2080e7          	jalr	-862(ra) # 80005dcc <printf>
    80002132:	bfd1                	j	80002106 <syscall+0x4a>
  }else
    {
      printf("%d %s: unknown sys call %d\n",
    80002134:	86ca                	mv	a3,s2
    80002136:	15848613          	addi	a2,s1,344
    8000213a:	588c                	lw	a1,48(s1)
    8000213c:	00006517          	auipc	a0,0x6
    80002140:	2ac50513          	addi	a0,a0,684 # 800083e8 <states.1727+0x160>
    80002144:	00004097          	auipc	ra,0x4
    80002148:	c88080e7          	jalr	-888(ra) # 80005dcc <printf>
             p->pid, p->name, num);
      p->trapframe->a0 = -1;
    8000214c:	6cbc                	ld	a5,88(s1)
    8000214e:	577d                	li	a4,-1
    80002150:	fbb8                	sd	a4,112(a5)
    }
}
    80002152:	70a2                	ld	ra,40(sp)
    80002154:	7402                	ld	s0,32(sp)
    80002156:	64e2                	ld	s1,24(sp)
    80002158:	6942                	ld	s2,16(sp)
    8000215a:	69a2                	ld	s3,8(sp)
    8000215c:	6145                	addi	sp,sp,48
    8000215e:	8082                	ret

0000000080002160 <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    80002160:	1101                	addi	sp,sp,-32
    80002162:	ec06                	sd	ra,24(sp)
    80002164:	e822                	sd	s0,16(sp)
    80002166:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002168:	fec40593          	addi	a1,s0,-20
    8000216c:	4501                	li	a0,0
    8000216e:	00000097          	auipc	ra,0x0
    80002172:	ed6080e7          	jalr	-298(ra) # 80002044 <argint>
  exit(n);
    80002176:	fec42503          	lw	a0,-20(s0)
    8000217a:	fffff097          	auipc	ra,0xfffff
    8000217e:	53e080e7          	jalr	1342(ra) # 800016b8 <exit>
  return 0;  // not reached
}
    80002182:	4501                	li	a0,0
    80002184:	60e2                	ld	ra,24(sp)
    80002186:	6442                	ld	s0,16(sp)
    80002188:	6105                	addi	sp,sp,32
    8000218a:	8082                	ret

000000008000218c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000218c:	1141                	addi	sp,sp,-16
    8000218e:	e406                	sd	ra,8(sp)
    80002190:	e022                	sd	s0,0(sp)
    80002192:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002194:	fffff097          	auipc	ra,0xfffff
    80002198:	d40080e7          	jalr	-704(ra) # 80000ed4 <myproc>
}
    8000219c:	5908                	lw	a0,48(a0)
    8000219e:	60a2                	ld	ra,8(sp)
    800021a0:	6402                	ld	s0,0(sp)
    800021a2:	0141                	addi	sp,sp,16
    800021a4:	8082                	ret

00000000800021a6 <sys_fork>:

uint64
sys_fork(void)
{
    800021a6:	1141                	addi	sp,sp,-16
    800021a8:	e406                	sd	ra,8(sp)
    800021aa:	e022                	sd	s0,0(sp)
    800021ac:	0800                	addi	s0,sp,16
  return fork();
    800021ae:	fffff097          	auipc	ra,0xfffff
    800021b2:	0e0080e7          	jalr	224(ra) # 8000128e <fork>
}
    800021b6:	60a2                	ld	ra,8(sp)
    800021b8:	6402                	ld	s0,0(sp)
    800021ba:	0141                	addi	sp,sp,16
    800021bc:	8082                	ret

00000000800021be <sys_wait>:

uint64
sys_wait(void)
{
    800021be:	1101                	addi	sp,sp,-32
    800021c0:	ec06                	sd	ra,24(sp)
    800021c2:	e822                	sd	s0,16(sp)
    800021c4:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800021c6:	fe840593          	addi	a1,s0,-24
    800021ca:	4501                	li	a0,0
    800021cc:	00000097          	auipc	ra,0x0
    800021d0:	e98080e7          	jalr	-360(ra) # 80002064 <argaddr>
  return wait(p);
    800021d4:	fe843503          	ld	a0,-24(s0)
    800021d8:	fffff097          	auipc	ra,0xfffff
    800021dc:	686080e7          	jalr	1670(ra) # 8000185e <wait>
}
    800021e0:	60e2                	ld	ra,24(sp)
    800021e2:	6442                	ld	s0,16(sp)
    800021e4:	6105                	addi	sp,sp,32
    800021e6:	8082                	ret

00000000800021e8 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021e8:	7179                	addi	sp,sp,-48
    800021ea:	f406                	sd	ra,40(sp)
    800021ec:	f022                	sd	s0,32(sp)
    800021ee:	ec26                	sd	s1,24(sp)
    800021f0:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800021f2:	fdc40593          	addi	a1,s0,-36
    800021f6:	4501                	li	a0,0
    800021f8:	00000097          	auipc	ra,0x0
    800021fc:	e4c080e7          	jalr	-436(ra) # 80002044 <argint>
  addr = myproc()->sz;
    80002200:	fffff097          	auipc	ra,0xfffff
    80002204:	cd4080e7          	jalr	-812(ra) # 80000ed4 <myproc>
    80002208:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000220a:	fdc42503          	lw	a0,-36(s0)
    8000220e:	fffff097          	auipc	ra,0xfffff
    80002212:	024080e7          	jalr	36(ra) # 80001232 <growproc>
    80002216:	00054863          	bltz	a0,80002226 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    8000221a:	8526                	mv	a0,s1
    8000221c:	70a2                	ld	ra,40(sp)
    8000221e:	7402                	ld	s0,32(sp)
    80002220:	64e2                	ld	s1,24(sp)
    80002222:	6145                	addi	sp,sp,48
    80002224:	8082                	ret
    return -1;
    80002226:	54fd                	li	s1,-1
    80002228:	bfcd                	j	8000221a <sys_sbrk+0x32>

000000008000222a <sys_sleep>:

uint64
sys_sleep(void)
{
    8000222a:	7139                	addi	sp,sp,-64
    8000222c:	fc06                	sd	ra,56(sp)
    8000222e:	f822                	sd	s0,48(sp)
    80002230:	f426                	sd	s1,40(sp)
    80002232:	f04a                	sd	s2,32(sp)
    80002234:	ec4e                	sd	s3,24(sp)
    80002236:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002238:	fcc40593          	addi	a1,s0,-52
    8000223c:	4501                	li	a0,0
    8000223e:	00000097          	auipc	ra,0x0
    80002242:	e06080e7          	jalr	-506(ra) # 80002044 <argint>
  if(n < 0)
    80002246:	fcc42783          	lw	a5,-52(s0)
    8000224a:	0607cf63          	bltz	a5,800022c8 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    8000224e:	0000d517          	auipc	a0,0xd
    80002252:	95250513          	addi	a0,a0,-1710 # 8000eba0 <tickslock>
    80002256:	00004097          	auipc	ra,0x4
    8000225a:	076080e7          	jalr	118(ra) # 800062cc <acquire>
  ticks0 = ticks;
    8000225e:	00007917          	auipc	s2,0x7
    80002262:	8da92903          	lw	s2,-1830(s2) # 80008b38 <ticks>
  while(ticks - ticks0 < n){
    80002266:	fcc42783          	lw	a5,-52(s0)
    8000226a:	cf9d                	beqz	a5,800022a8 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000226c:	0000d997          	auipc	s3,0xd
    80002270:	93498993          	addi	s3,s3,-1740 # 8000eba0 <tickslock>
    80002274:	00007497          	auipc	s1,0x7
    80002278:	8c448493          	addi	s1,s1,-1852 # 80008b38 <ticks>
    if(killed(myproc())){
    8000227c:	fffff097          	auipc	ra,0xfffff
    80002280:	c58080e7          	jalr	-936(ra) # 80000ed4 <myproc>
    80002284:	fffff097          	auipc	ra,0xfffff
    80002288:	5a8080e7          	jalr	1448(ra) # 8000182c <killed>
    8000228c:	e129                	bnez	a0,800022ce <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    8000228e:	85ce                	mv	a1,s3
    80002290:	8526                	mv	a0,s1
    80002292:	fffff097          	auipc	ra,0xfffff
    80002296:	2f2080e7          	jalr	754(ra) # 80001584 <sleep>
  while(ticks - ticks0 < n){
    8000229a:	409c                	lw	a5,0(s1)
    8000229c:	412787bb          	subw	a5,a5,s2
    800022a0:	fcc42703          	lw	a4,-52(s0)
    800022a4:	fce7ece3          	bltu	a5,a4,8000227c <sys_sleep+0x52>
  }
  release(&tickslock);
    800022a8:	0000d517          	auipc	a0,0xd
    800022ac:	8f850513          	addi	a0,a0,-1800 # 8000eba0 <tickslock>
    800022b0:	00004097          	auipc	ra,0x4
    800022b4:	0d0080e7          	jalr	208(ra) # 80006380 <release>
  return 0;
    800022b8:	4501                	li	a0,0
}
    800022ba:	70e2                	ld	ra,56(sp)
    800022bc:	7442                	ld	s0,48(sp)
    800022be:	74a2                	ld	s1,40(sp)
    800022c0:	7902                	ld	s2,32(sp)
    800022c2:	69e2                	ld	s3,24(sp)
    800022c4:	6121                	addi	sp,sp,64
    800022c6:	8082                	ret
    n = 0;
    800022c8:	fc042623          	sw	zero,-52(s0)
    800022cc:	b749                	j	8000224e <sys_sleep+0x24>
      release(&tickslock);
    800022ce:	0000d517          	auipc	a0,0xd
    800022d2:	8d250513          	addi	a0,a0,-1838 # 8000eba0 <tickslock>
    800022d6:	00004097          	auipc	ra,0x4
    800022da:	0aa080e7          	jalr	170(ra) # 80006380 <release>
      return -1;
    800022de:	557d                	li	a0,-1
    800022e0:	bfe9                	j	800022ba <sys_sleep+0x90>

00000000800022e2 <sys_kill>:

uint64
sys_kill(void)
{
    800022e2:	1101                	addi	sp,sp,-32
    800022e4:	ec06                	sd	ra,24(sp)
    800022e6:	e822                	sd	s0,16(sp)
    800022e8:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800022ea:	fec40593          	addi	a1,s0,-20
    800022ee:	4501                	li	a0,0
    800022f0:	00000097          	auipc	ra,0x0
    800022f4:	d54080e7          	jalr	-684(ra) # 80002044 <argint>
  return kill(pid);
    800022f8:	fec42503          	lw	a0,-20(s0)
    800022fc:	fffff097          	auipc	ra,0xfffff
    80002300:	492080e7          	jalr	1170(ra) # 8000178e <kill>
}
    80002304:	60e2                	ld	ra,24(sp)
    80002306:	6442                	ld	s0,16(sp)
    80002308:	6105                	addi	sp,sp,32
    8000230a:	8082                	ret

000000008000230c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000230c:	1101                	addi	sp,sp,-32
    8000230e:	ec06                	sd	ra,24(sp)
    80002310:	e822                	sd	s0,16(sp)
    80002312:	e426                	sd	s1,8(sp)
    80002314:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002316:	0000d517          	auipc	a0,0xd
    8000231a:	88a50513          	addi	a0,a0,-1910 # 8000eba0 <tickslock>
    8000231e:	00004097          	auipc	ra,0x4
    80002322:	fae080e7          	jalr	-82(ra) # 800062cc <acquire>
  xticks = ticks;
    80002326:	00007497          	auipc	s1,0x7
    8000232a:	8124a483          	lw	s1,-2030(s1) # 80008b38 <ticks>
  release(&tickslock);
    8000232e:	0000d517          	auipc	a0,0xd
    80002332:	87250513          	addi	a0,a0,-1934 # 8000eba0 <tickslock>
    80002336:	00004097          	auipc	ra,0x4
    8000233a:	04a080e7          	jalr	74(ra) # 80006380 <release>
  return xticks;
}
    8000233e:	02049513          	slli	a0,s1,0x20
    80002342:	9101                	srli	a0,a0,0x20
    80002344:	60e2                	ld	ra,24(sp)
    80002346:	6442                	ld	s0,16(sp)
    80002348:	64a2                	ld	s1,8(sp)
    8000234a:	6105                	addi	sp,sp,32
    8000234c:	8082                	ret

000000008000234e <sys_trace>:

uint64 sys_trace(void)
{
    8000234e:	1101                	addi	sp,sp,-32
    80002350:	ec06                	sd	ra,24(sp)
    80002352:	e822                	sd	s0,16(sp)
    80002354:	1000                	addi	s0,sp,32
  int mask;
  argint(0, &mask);//将a0寄存器中的数据取出暂存到mask中
    80002356:	fec40593          	addi	a1,s0,-20
    8000235a:	4501                	li	a0,0
    8000235c:	00000097          	auipc	ra,0x0
    80002360:	ce8080e7          	jalr	-792(ra) # 80002044 <argint>
  struct proc *p = myproc();
    80002364:	fffff097          	auipc	ra,0xfffff
    80002368:	b70080e7          	jalr	-1168(ra) # 80000ed4 <myproc>
  p->mask = mask;//当前进程的mask字段被赋值为mask
    8000236c:	fec42783          	lw	a5,-20(s0)
    80002370:	16f53423          	sd	a5,360(a0)
  return 0;
}
    80002374:	4501                	li	a0,0
    80002376:	60e2                	ld	ra,24(sp)
    80002378:	6442                	ld	s0,16(sp)
    8000237a:	6105                	addi	sp,sp,32
    8000237c:	8082                	ret

000000008000237e <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    8000237e:	7139                	addi	sp,sp,-64
    80002380:	fc06                	sd	ra,56(sp)
    80002382:	f822                	sd	s0,48(sp)
    80002384:	f426                	sd	s1,40(sp)
    80002386:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80002388:	fffff097          	auipc	ra,0xfffff
    8000238c:	b4c080e7          	jalr	-1204(ra) # 80000ed4 <myproc>
    80002390:	84aa                	mv	s1,a0
  struct sysinfo info;
  uint64 addr;

  /* get virtual address*/
  argaddr(0, &addr);
    80002392:	fc840593          	addi	a1,s0,-56
    80002396:	4501                	li	a0,0
    80002398:	00000097          	auipc	ra,0x0
    8000239c:	ccc080e7          	jalr	-820(ra) # 80002064 <argaddr>

  /* get info*/
  info.freemem = get_amount_freemem();
    800023a0:	ffffe097          	auipc	ra,0xffffe
    800023a4:	dd8080e7          	jalr	-552(ra) # 80000178 <get_amount_freemem>
    800023a8:	fca43823          	sd	a0,-48(s0)
  info.nproc = get_nproc();
    800023ac:	fffff097          	auipc	ra,0xfffff
    800023b0:	73a080e7          	jalr	1850(ra) # 80001ae6 <get_nproc>
    800023b4:	fca43c23          	sd	a0,-40(s0)

  /* Copy len bytes from src(info) to virtual address dstva(addr) in a given page table. */
  if (copyout(p->pagetable, addr, (char *)&info, sizeof(info)) < 0)
    800023b8:	46c1                	li	a3,16
    800023ba:	fd040613          	addi	a2,s0,-48
    800023be:	fc843583          	ld	a1,-56(s0)
    800023c2:	68a8                	ld	a0,80(s1)
    800023c4:	ffffe097          	auipc	ra,0xffffe
    800023c8:	79a080e7          	jalr	1946(ra) # 80000b5e <copyout>
    return -1;
  return 0;
}
    800023cc:	957d                	srai	a0,a0,0x3f
    800023ce:	70e2                	ld	ra,56(sp)
    800023d0:	7442                	ld	s0,48(sp)
    800023d2:	74a2                	ld	s1,40(sp)
    800023d4:	6121                	addi	sp,sp,64
    800023d6:	8082                	ret

00000000800023d8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023d8:	7179                	addi	sp,sp,-48
    800023da:	f406                	sd	ra,40(sp)
    800023dc:	f022                	sd	s0,32(sp)
    800023de:	ec26                	sd	s1,24(sp)
    800023e0:	e84a                	sd	s2,16(sp)
    800023e2:	e44e                	sd	s3,8(sp)
    800023e4:	e052                	sd	s4,0(sp)
    800023e6:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023e8:	00006597          	auipc	a1,0x6
    800023ec:	26858593          	addi	a1,a1,616 # 80008650 <syscalls+0xc0>
    800023f0:	0000c517          	auipc	a0,0xc
    800023f4:	7c850513          	addi	a0,a0,1992 # 8000ebb8 <bcache>
    800023f8:	00004097          	auipc	ra,0x4
    800023fc:	e44080e7          	jalr	-444(ra) # 8000623c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002400:	00014797          	auipc	a5,0x14
    80002404:	7b878793          	addi	a5,a5,1976 # 80016bb8 <bcache+0x8000>
    80002408:	00015717          	auipc	a4,0x15
    8000240c:	a1870713          	addi	a4,a4,-1512 # 80016e20 <bcache+0x8268>
    80002410:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002414:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002418:	0000c497          	auipc	s1,0xc
    8000241c:	7b848493          	addi	s1,s1,1976 # 8000ebd0 <bcache+0x18>
    b->next = bcache.head.next;
    80002420:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002422:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002424:	00006a17          	auipc	s4,0x6
    80002428:	234a0a13          	addi	s4,s4,564 # 80008658 <syscalls+0xc8>
    b->next = bcache.head.next;
    8000242c:	2b893783          	ld	a5,696(s2)
    80002430:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002432:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002436:	85d2                	mv	a1,s4
    80002438:	01048513          	addi	a0,s1,16
    8000243c:	00001097          	auipc	ra,0x1
    80002440:	4c4080e7          	jalr	1220(ra) # 80003900 <initsleeplock>
    bcache.head.next->prev = b;
    80002444:	2b893783          	ld	a5,696(s2)
    80002448:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000244a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000244e:	45848493          	addi	s1,s1,1112
    80002452:	fd349de3          	bne	s1,s3,8000242c <binit+0x54>
  }
}
    80002456:	70a2                	ld	ra,40(sp)
    80002458:	7402                	ld	s0,32(sp)
    8000245a:	64e2                	ld	s1,24(sp)
    8000245c:	6942                	ld	s2,16(sp)
    8000245e:	69a2                	ld	s3,8(sp)
    80002460:	6a02                	ld	s4,0(sp)
    80002462:	6145                	addi	sp,sp,48
    80002464:	8082                	ret

0000000080002466 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002466:	7179                	addi	sp,sp,-48
    80002468:	f406                	sd	ra,40(sp)
    8000246a:	f022                	sd	s0,32(sp)
    8000246c:	ec26                	sd	s1,24(sp)
    8000246e:	e84a                	sd	s2,16(sp)
    80002470:	e44e                	sd	s3,8(sp)
    80002472:	1800                	addi	s0,sp,48
    80002474:	89aa                	mv	s3,a0
    80002476:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002478:	0000c517          	auipc	a0,0xc
    8000247c:	74050513          	addi	a0,a0,1856 # 8000ebb8 <bcache>
    80002480:	00004097          	auipc	ra,0x4
    80002484:	e4c080e7          	jalr	-436(ra) # 800062cc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002488:	00015497          	auipc	s1,0x15
    8000248c:	9e84b483          	ld	s1,-1560(s1) # 80016e70 <bcache+0x82b8>
    80002490:	00015797          	auipc	a5,0x15
    80002494:	99078793          	addi	a5,a5,-1648 # 80016e20 <bcache+0x8268>
    80002498:	02f48f63          	beq	s1,a5,800024d6 <bread+0x70>
    8000249c:	873e                	mv	a4,a5
    8000249e:	a021                	j	800024a6 <bread+0x40>
    800024a0:	68a4                	ld	s1,80(s1)
    800024a2:	02e48a63          	beq	s1,a4,800024d6 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800024a6:	449c                	lw	a5,8(s1)
    800024a8:	ff379ce3          	bne	a5,s3,800024a0 <bread+0x3a>
    800024ac:	44dc                	lw	a5,12(s1)
    800024ae:	ff2799e3          	bne	a5,s2,800024a0 <bread+0x3a>
      b->refcnt++;
    800024b2:	40bc                	lw	a5,64(s1)
    800024b4:	2785                	addiw	a5,a5,1
    800024b6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024b8:	0000c517          	auipc	a0,0xc
    800024bc:	70050513          	addi	a0,a0,1792 # 8000ebb8 <bcache>
    800024c0:	00004097          	auipc	ra,0x4
    800024c4:	ec0080e7          	jalr	-320(ra) # 80006380 <release>
      acquiresleep(&b->lock);
    800024c8:	01048513          	addi	a0,s1,16
    800024cc:	00001097          	auipc	ra,0x1
    800024d0:	46e080e7          	jalr	1134(ra) # 8000393a <acquiresleep>
      return b;
    800024d4:	a8b9                	j	80002532 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024d6:	00015497          	auipc	s1,0x15
    800024da:	9924b483          	ld	s1,-1646(s1) # 80016e68 <bcache+0x82b0>
    800024de:	00015797          	auipc	a5,0x15
    800024e2:	94278793          	addi	a5,a5,-1726 # 80016e20 <bcache+0x8268>
    800024e6:	00f48863          	beq	s1,a5,800024f6 <bread+0x90>
    800024ea:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024ec:	40bc                	lw	a5,64(s1)
    800024ee:	cf81                	beqz	a5,80002506 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024f0:	64a4                	ld	s1,72(s1)
    800024f2:	fee49de3          	bne	s1,a4,800024ec <bread+0x86>
  panic("bget: no buffers");
    800024f6:	00006517          	auipc	a0,0x6
    800024fa:	16a50513          	addi	a0,a0,362 # 80008660 <syscalls+0xd0>
    800024fe:	00004097          	auipc	ra,0x4
    80002502:	884080e7          	jalr	-1916(ra) # 80005d82 <panic>
      b->dev = dev;
    80002506:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    8000250a:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000250e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002512:	4785                	li	a5,1
    80002514:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002516:	0000c517          	auipc	a0,0xc
    8000251a:	6a250513          	addi	a0,a0,1698 # 8000ebb8 <bcache>
    8000251e:	00004097          	auipc	ra,0x4
    80002522:	e62080e7          	jalr	-414(ra) # 80006380 <release>
      acquiresleep(&b->lock);
    80002526:	01048513          	addi	a0,s1,16
    8000252a:	00001097          	auipc	ra,0x1
    8000252e:	410080e7          	jalr	1040(ra) # 8000393a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002532:	409c                	lw	a5,0(s1)
    80002534:	cb89                	beqz	a5,80002546 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002536:	8526                	mv	a0,s1
    80002538:	70a2                	ld	ra,40(sp)
    8000253a:	7402                	ld	s0,32(sp)
    8000253c:	64e2                	ld	s1,24(sp)
    8000253e:	6942                	ld	s2,16(sp)
    80002540:	69a2                	ld	s3,8(sp)
    80002542:	6145                	addi	sp,sp,48
    80002544:	8082                	ret
    virtio_disk_rw(b, 0);
    80002546:	4581                	li	a1,0
    80002548:	8526                	mv	a0,s1
    8000254a:	00003097          	auipc	ra,0x3
    8000254e:	fce080e7          	jalr	-50(ra) # 80005518 <virtio_disk_rw>
    b->valid = 1;
    80002552:	4785                	li	a5,1
    80002554:	c09c                	sw	a5,0(s1)
  return b;
    80002556:	b7c5                	j	80002536 <bread+0xd0>

0000000080002558 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002558:	1101                	addi	sp,sp,-32
    8000255a:	ec06                	sd	ra,24(sp)
    8000255c:	e822                	sd	s0,16(sp)
    8000255e:	e426                	sd	s1,8(sp)
    80002560:	1000                	addi	s0,sp,32
    80002562:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002564:	0541                	addi	a0,a0,16
    80002566:	00001097          	auipc	ra,0x1
    8000256a:	46e080e7          	jalr	1134(ra) # 800039d4 <holdingsleep>
    8000256e:	cd01                	beqz	a0,80002586 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002570:	4585                	li	a1,1
    80002572:	8526                	mv	a0,s1
    80002574:	00003097          	auipc	ra,0x3
    80002578:	fa4080e7          	jalr	-92(ra) # 80005518 <virtio_disk_rw>
}
    8000257c:	60e2                	ld	ra,24(sp)
    8000257e:	6442                	ld	s0,16(sp)
    80002580:	64a2                	ld	s1,8(sp)
    80002582:	6105                	addi	sp,sp,32
    80002584:	8082                	ret
    panic("bwrite");
    80002586:	00006517          	auipc	a0,0x6
    8000258a:	0f250513          	addi	a0,a0,242 # 80008678 <syscalls+0xe8>
    8000258e:	00003097          	auipc	ra,0x3
    80002592:	7f4080e7          	jalr	2036(ra) # 80005d82 <panic>

0000000080002596 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002596:	1101                	addi	sp,sp,-32
    80002598:	ec06                	sd	ra,24(sp)
    8000259a:	e822                	sd	s0,16(sp)
    8000259c:	e426                	sd	s1,8(sp)
    8000259e:	e04a                	sd	s2,0(sp)
    800025a0:	1000                	addi	s0,sp,32
    800025a2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025a4:	01050913          	addi	s2,a0,16
    800025a8:	854a                	mv	a0,s2
    800025aa:	00001097          	auipc	ra,0x1
    800025ae:	42a080e7          	jalr	1066(ra) # 800039d4 <holdingsleep>
    800025b2:	c92d                	beqz	a0,80002624 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800025b4:	854a                	mv	a0,s2
    800025b6:	00001097          	auipc	ra,0x1
    800025ba:	3da080e7          	jalr	986(ra) # 80003990 <releasesleep>

  acquire(&bcache.lock);
    800025be:	0000c517          	auipc	a0,0xc
    800025c2:	5fa50513          	addi	a0,a0,1530 # 8000ebb8 <bcache>
    800025c6:	00004097          	auipc	ra,0x4
    800025ca:	d06080e7          	jalr	-762(ra) # 800062cc <acquire>
  b->refcnt--;
    800025ce:	40bc                	lw	a5,64(s1)
    800025d0:	37fd                	addiw	a5,a5,-1
    800025d2:	0007871b          	sext.w	a4,a5
    800025d6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025d8:	eb05                	bnez	a4,80002608 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025da:	68bc                	ld	a5,80(s1)
    800025dc:	64b8                	ld	a4,72(s1)
    800025de:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800025e0:	64bc                	ld	a5,72(s1)
    800025e2:	68b8                	ld	a4,80(s1)
    800025e4:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800025e6:	00014797          	auipc	a5,0x14
    800025ea:	5d278793          	addi	a5,a5,1490 # 80016bb8 <bcache+0x8000>
    800025ee:	2b87b703          	ld	a4,696(a5)
    800025f2:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025f4:	00015717          	auipc	a4,0x15
    800025f8:	82c70713          	addi	a4,a4,-2004 # 80016e20 <bcache+0x8268>
    800025fc:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025fe:	2b87b703          	ld	a4,696(a5)
    80002602:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002604:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002608:	0000c517          	auipc	a0,0xc
    8000260c:	5b050513          	addi	a0,a0,1456 # 8000ebb8 <bcache>
    80002610:	00004097          	auipc	ra,0x4
    80002614:	d70080e7          	jalr	-656(ra) # 80006380 <release>
}
    80002618:	60e2                	ld	ra,24(sp)
    8000261a:	6442                	ld	s0,16(sp)
    8000261c:	64a2                	ld	s1,8(sp)
    8000261e:	6902                	ld	s2,0(sp)
    80002620:	6105                	addi	sp,sp,32
    80002622:	8082                	ret
    panic("brelse");
    80002624:	00006517          	auipc	a0,0x6
    80002628:	05c50513          	addi	a0,a0,92 # 80008680 <syscalls+0xf0>
    8000262c:	00003097          	auipc	ra,0x3
    80002630:	756080e7          	jalr	1878(ra) # 80005d82 <panic>

0000000080002634 <bpin>:

void
bpin(struct buf *b) {
    80002634:	1101                	addi	sp,sp,-32
    80002636:	ec06                	sd	ra,24(sp)
    80002638:	e822                	sd	s0,16(sp)
    8000263a:	e426                	sd	s1,8(sp)
    8000263c:	1000                	addi	s0,sp,32
    8000263e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002640:	0000c517          	auipc	a0,0xc
    80002644:	57850513          	addi	a0,a0,1400 # 8000ebb8 <bcache>
    80002648:	00004097          	auipc	ra,0x4
    8000264c:	c84080e7          	jalr	-892(ra) # 800062cc <acquire>
  b->refcnt++;
    80002650:	40bc                	lw	a5,64(s1)
    80002652:	2785                	addiw	a5,a5,1
    80002654:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002656:	0000c517          	auipc	a0,0xc
    8000265a:	56250513          	addi	a0,a0,1378 # 8000ebb8 <bcache>
    8000265e:	00004097          	auipc	ra,0x4
    80002662:	d22080e7          	jalr	-734(ra) # 80006380 <release>
}
    80002666:	60e2                	ld	ra,24(sp)
    80002668:	6442                	ld	s0,16(sp)
    8000266a:	64a2                	ld	s1,8(sp)
    8000266c:	6105                	addi	sp,sp,32
    8000266e:	8082                	ret

0000000080002670 <bunpin>:

void
bunpin(struct buf *b) {
    80002670:	1101                	addi	sp,sp,-32
    80002672:	ec06                	sd	ra,24(sp)
    80002674:	e822                	sd	s0,16(sp)
    80002676:	e426                	sd	s1,8(sp)
    80002678:	1000                	addi	s0,sp,32
    8000267a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000267c:	0000c517          	auipc	a0,0xc
    80002680:	53c50513          	addi	a0,a0,1340 # 8000ebb8 <bcache>
    80002684:	00004097          	auipc	ra,0x4
    80002688:	c48080e7          	jalr	-952(ra) # 800062cc <acquire>
  b->refcnt--;
    8000268c:	40bc                	lw	a5,64(s1)
    8000268e:	37fd                	addiw	a5,a5,-1
    80002690:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002692:	0000c517          	auipc	a0,0xc
    80002696:	52650513          	addi	a0,a0,1318 # 8000ebb8 <bcache>
    8000269a:	00004097          	auipc	ra,0x4
    8000269e:	ce6080e7          	jalr	-794(ra) # 80006380 <release>
}
    800026a2:	60e2                	ld	ra,24(sp)
    800026a4:	6442                	ld	s0,16(sp)
    800026a6:	64a2                	ld	s1,8(sp)
    800026a8:	6105                	addi	sp,sp,32
    800026aa:	8082                	ret

00000000800026ac <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800026ac:	1101                	addi	sp,sp,-32
    800026ae:	ec06                	sd	ra,24(sp)
    800026b0:	e822                	sd	s0,16(sp)
    800026b2:	e426                	sd	s1,8(sp)
    800026b4:	e04a                	sd	s2,0(sp)
    800026b6:	1000                	addi	s0,sp,32
    800026b8:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026ba:	00d5d59b          	srliw	a1,a1,0xd
    800026be:	00015797          	auipc	a5,0x15
    800026c2:	bd67a783          	lw	a5,-1066(a5) # 80017294 <sb+0x1c>
    800026c6:	9dbd                	addw	a1,a1,a5
    800026c8:	00000097          	auipc	ra,0x0
    800026cc:	d9e080e7          	jalr	-610(ra) # 80002466 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800026d0:	0074f713          	andi	a4,s1,7
    800026d4:	4785                	li	a5,1
    800026d6:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800026da:	14ce                	slli	s1,s1,0x33
    800026dc:	90d9                	srli	s1,s1,0x36
    800026de:	00950733          	add	a4,a0,s1
    800026e2:	05874703          	lbu	a4,88(a4)
    800026e6:	00e7f6b3          	and	a3,a5,a4
    800026ea:	c69d                	beqz	a3,80002718 <bfree+0x6c>
    800026ec:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026ee:	94aa                	add	s1,s1,a0
    800026f0:	fff7c793          	not	a5,a5
    800026f4:	8ff9                	and	a5,a5,a4
    800026f6:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800026fa:	00001097          	auipc	ra,0x1
    800026fe:	120080e7          	jalr	288(ra) # 8000381a <log_write>
  brelse(bp);
    80002702:	854a                	mv	a0,s2
    80002704:	00000097          	auipc	ra,0x0
    80002708:	e92080e7          	jalr	-366(ra) # 80002596 <brelse>
}
    8000270c:	60e2                	ld	ra,24(sp)
    8000270e:	6442                	ld	s0,16(sp)
    80002710:	64a2                	ld	s1,8(sp)
    80002712:	6902                	ld	s2,0(sp)
    80002714:	6105                	addi	sp,sp,32
    80002716:	8082                	ret
    panic("freeing free block");
    80002718:	00006517          	auipc	a0,0x6
    8000271c:	f7050513          	addi	a0,a0,-144 # 80008688 <syscalls+0xf8>
    80002720:	00003097          	auipc	ra,0x3
    80002724:	662080e7          	jalr	1634(ra) # 80005d82 <panic>

0000000080002728 <balloc>:
{
    80002728:	711d                	addi	sp,sp,-96
    8000272a:	ec86                	sd	ra,88(sp)
    8000272c:	e8a2                	sd	s0,80(sp)
    8000272e:	e4a6                	sd	s1,72(sp)
    80002730:	e0ca                	sd	s2,64(sp)
    80002732:	fc4e                	sd	s3,56(sp)
    80002734:	f852                	sd	s4,48(sp)
    80002736:	f456                	sd	s5,40(sp)
    80002738:	f05a                	sd	s6,32(sp)
    8000273a:	ec5e                	sd	s7,24(sp)
    8000273c:	e862                	sd	s8,16(sp)
    8000273e:	e466                	sd	s9,8(sp)
    80002740:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002742:	00015797          	auipc	a5,0x15
    80002746:	b3a7a783          	lw	a5,-1222(a5) # 8001727c <sb+0x4>
    8000274a:	10078163          	beqz	a5,8000284c <balloc+0x124>
    8000274e:	8baa                	mv	s7,a0
    80002750:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002752:	00015b17          	auipc	s6,0x15
    80002756:	b26b0b13          	addi	s6,s6,-1242 # 80017278 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000275a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000275c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000275e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002760:	6c89                	lui	s9,0x2
    80002762:	a061                	j	800027ea <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002764:	974a                	add	a4,a4,s2
    80002766:	8fd5                	or	a5,a5,a3
    80002768:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000276c:	854a                	mv	a0,s2
    8000276e:	00001097          	auipc	ra,0x1
    80002772:	0ac080e7          	jalr	172(ra) # 8000381a <log_write>
        brelse(bp);
    80002776:	854a                	mv	a0,s2
    80002778:	00000097          	auipc	ra,0x0
    8000277c:	e1e080e7          	jalr	-482(ra) # 80002596 <brelse>
  bp = bread(dev, bno);
    80002780:	85a6                	mv	a1,s1
    80002782:	855e                	mv	a0,s7
    80002784:	00000097          	auipc	ra,0x0
    80002788:	ce2080e7          	jalr	-798(ra) # 80002466 <bread>
    8000278c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000278e:	40000613          	li	a2,1024
    80002792:	4581                	li	a1,0
    80002794:	05850513          	addi	a0,a0,88
    80002798:	ffffe097          	auipc	ra,0xffffe
    8000279c:	a04080e7          	jalr	-1532(ra) # 8000019c <memset>
  log_write(bp);
    800027a0:	854a                	mv	a0,s2
    800027a2:	00001097          	auipc	ra,0x1
    800027a6:	078080e7          	jalr	120(ra) # 8000381a <log_write>
  brelse(bp);
    800027aa:	854a                	mv	a0,s2
    800027ac:	00000097          	auipc	ra,0x0
    800027b0:	dea080e7          	jalr	-534(ra) # 80002596 <brelse>
}
    800027b4:	8526                	mv	a0,s1
    800027b6:	60e6                	ld	ra,88(sp)
    800027b8:	6446                	ld	s0,80(sp)
    800027ba:	64a6                	ld	s1,72(sp)
    800027bc:	6906                	ld	s2,64(sp)
    800027be:	79e2                	ld	s3,56(sp)
    800027c0:	7a42                	ld	s4,48(sp)
    800027c2:	7aa2                	ld	s5,40(sp)
    800027c4:	7b02                	ld	s6,32(sp)
    800027c6:	6be2                	ld	s7,24(sp)
    800027c8:	6c42                	ld	s8,16(sp)
    800027ca:	6ca2                	ld	s9,8(sp)
    800027cc:	6125                	addi	sp,sp,96
    800027ce:	8082                	ret
    brelse(bp);
    800027d0:	854a                	mv	a0,s2
    800027d2:	00000097          	auipc	ra,0x0
    800027d6:	dc4080e7          	jalr	-572(ra) # 80002596 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027da:	015c87bb          	addw	a5,s9,s5
    800027de:	00078a9b          	sext.w	s5,a5
    800027e2:	004b2703          	lw	a4,4(s6)
    800027e6:	06eaf363          	bgeu	s5,a4,8000284c <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    800027ea:	41fad79b          	sraiw	a5,s5,0x1f
    800027ee:	0137d79b          	srliw	a5,a5,0x13
    800027f2:	015787bb          	addw	a5,a5,s5
    800027f6:	40d7d79b          	sraiw	a5,a5,0xd
    800027fa:	01cb2583          	lw	a1,28(s6)
    800027fe:	9dbd                	addw	a1,a1,a5
    80002800:	855e                	mv	a0,s7
    80002802:	00000097          	auipc	ra,0x0
    80002806:	c64080e7          	jalr	-924(ra) # 80002466 <bread>
    8000280a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000280c:	004b2503          	lw	a0,4(s6)
    80002810:	000a849b          	sext.w	s1,s5
    80002814:	8662                	mv	a2,s8
    80002816:	faa4fde3          	bgeu	s1,a0,800027d0 <balloc+0xa8>
      m = 1 << (bi % 8);
    8000281a:	41f6579b          	sraiw	a5,a2,0x1f
    8000281e:	01d7d69b          	srliw	a3,a5,0x1d
    80002822:	00c6873b          	addw	a4,a3,a2
    80002826:	00777793          	andi	a5,a4,7
    8000282a:	9f95                	subw	a5,a5,a3
    8000282c:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002830:	4037571b          	sraiw	a4,a4,0x3
    80002834:	00e906b3          	add	a3,s2,a4
    80002838:	0586c683          	lbu	a3,88(a3)
    8000283c:	00d7f5b3          	and	a1,a5,a3
    80002840:	d195                	beqz	a1,80002764 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002842:	2605                	addiw	a2,a2,1
    80002844:	2485                	addiw	s1,s1,1
    80002846:	fd4618e3          	bne	a2,s4,80002816 <balloc+0xee>
    8000284a:	b759                	j	800027d0 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    8000284c:	00006517          	auipc	a0,0x6
    80002850:	e5450513          	addi	a0,a0,-428 # 800086a0 <syscalls+0x110>
    80002854:	00003097          	auipc	ra,0x3
    80002858:	578080e7          	jalr	1400(ra) # 80005dcc <printf>
  return 0;
    8000285c:	4481                	li	s1,0
    8000285e:	bf99                	j	800027b4 <balloc+0x8c>

0000000080002860 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002860:	7179                	addi	sp,sp,-48
    80002862:	f406                	sd	ra,40(sp)
    80002864:	f022                	sd	s0,32(sp)
    80002866:	ec26                	sd	s1,24(sp)
    80002868:	e84a                	sd	s2,16(sp)
    8000286a:	e44e                	sd	s3,8(sp)
    8000286c:	e052                	sd	s4,0(sp)
    8000286e:	1800                	addi	s0,sp,48
    80002870:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002872:	47ad                	li	a5,11
    80002874:	02b7e763          	bltu	a5,a1,800028a2 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80002878:	02059493          	slli	s1,a1,0x20
    8000287c:	9081                	srli	s1,s1,0x20
    8000287e:	048a                	slli	s1,s1,0x2
    80002880:	94aa                	add	s1,s1,a0
    80002882:	0504a903          	lw	s2,80(s1)
    80002886:	06091e63          	bnez	s2,80002902 <bmap+0xa2>
      addr = balloc(ip->dev);
    8000288a:	4108                	lw	a0,0(a0)
    8000288c:	00000097          	auipc	ra,0x0
    80002890:	e9c080e7          	jalr	-356(ra) # 80002728 <balloc>
    80002894:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002898:	06090563          	beqz	s2,80002902 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    8000289c:	0524a823          	sw	s2,80(s1)
    800028a0:	a08d                	j	80002902 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    800028a2:	ff45849b          	addiw	s1,a1,-12
    800028a6:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028aa:	0ff00793          	li	a5,255
    800028ae:	08e7e563          	bltu	a5,a4,80002938 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800028b2:	08052903          	lw	s2,128(a0)
    800028b6:	00091d63          	bnez	s2,800028d0 <bmap+0x70>
      addr = balloc(ip->dev);
    800028ba:	4108                	lw	a0,0(a0)
    800028bc:	00000097          	auipc	ra,0x0
    800028c0:	e6c080e7          	jalr	-404(ra) # 80002728 <balloc>
    800028c4:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800028c8:	02090d63          	beqz	s2,80002902 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800028cc:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800028d0:	85ca                	mv	a1,s2
    800028d2:	0009a503          	lw	a0,0(s3)
    800028d6:	00000097          	auipc	ra,0x0
    800028da:	b90080e7          	jalr	-1136(ra) # 80002466 <bread>
    800028de:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028e0:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800028e4:	02049593          	slli	a1,s1,0x20
    800028e8:	9181                	srli	a1,a1,0x20
    800028ea:	058a                	slli	a1,a1,0x2
    800028ec:	00b784b3          	add	s1,a5,a1
    800028f0:	0004a903          	lw	s2,0(s1)
    800028f4:	02090063          	beqz	s2,80002914 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800028f8:	8552                	mv	a0,s4
    800028fa:	00000097          	auipc	ra,0x0
    800028fe:	c9c080e7          	jalr	-868(ra) # 80002596 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002902:	854a                	mv	a0,s2
    80002904:	70a2                	ld	ra,40(sp)
    80002906:	7402                	ld	s0,32(sp)
    80002908:	64e2                	ld	s1,24(sp)
    8000290a:	6942                	ld	s2,16(sp)
    8000290c:	69a2                	ld	s3,8(sp)
    8000290e:	6a02                	ld	s4,0(sp)
    80002910:	6145                	addi	sp,sp,48
    80002912:	8082                	ret
      addr = balloc(ip->dev);
    80002914:	0009a503          	lw	a0,0(s3)
    80002918:	00000097          	auipc	ra,0x0
    8000291c:	e10080e7          	jalr	-496(ra) # 80002728 <balloc>
    80002920:	0005091b          	sext.w	s2,a0
      if(addr){
    80002924:	fc090ae3          	beqz	s2,800028f8 <bmap+0x98>
        a[bn] = addr;
    80002928:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000292c:	8552                	mv	a0,s4
    8000292e:	00001097          	auipc	ra,0x1
    80002932:	eec080e7          	jalr	-276(ra) # 8000381a <log_write>
    80002936:	b7c9                	j	800028f8 <bmap+0x98>
  panic("bmap: out of range");
    80002938:	00006517          	auipc	a0,0x6
    8000293c:	d8050513          	addi	a0,a0,-640 # 800086b8 <syscalls+0x128>
    80002940:	00003097          	auipc	ra,0x3
    80002944:	442080e7          	jalr	1090(ra) # 80005d82 <panic>

0000000080002948 <iget>:
{
    80002948:	7179                	addi	sp,sp,-48
    8000294a:	f406                	sd	ra,40(sp)
    8000294c:	f022                	sd	s0,32(sp)
    8000294e:	ec26                	sd	s1,24(sp)
    80002950:	e84a                	sd	s2,16(sp)
    80002952:	e44e                	sd	s3,8(sp)
    80002954:	e052                	sd	s4,0(sp)
    80002956:	1800                	addi	s0,sp,48
    80002958:	89aa                	mv	s3,a0
    8000295a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000295c:	00015517          	auipc	a0,0x15
    80002960:	93c50513          	addi	a0,a0,-1732 # 80017298 <itable>
    80002964:	00004097          	auipc	ra,0x4
    80002968:	968080e7          	jalr	-1688(ra) # 800062cc <acquire>
  empty = 0;
    8000296c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000296e:	00015497          	auipc	s1,0x15
    80002972:	94248493          	addi	s1,s1,-1726 # 800172b0 <itable+0x18>
    80002976:	00016697          	auipc	a3,0x16
    8000297a:	3ca68693          	addi	a3,a3,970 # 80018d40 <log>
    8000297e:	a039                	j	8000298c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002980:	02090b63          	beqz	s2,800029b6 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002984:	08848493          	addi	s1,s1,136
    80002988:	02d48a63          	beq	s1,a3,800029bc <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000298c:	449c                	lw	a5,8(s1)
    8000298e:	fef059e3          	blez	a5,80002980 <iget+0x38>
    80002992:	4098                	lw	a4,0(s1)
    80002994:	ff3716e3          	bne	a4,s3,80002980 <iget+0x38>
    80002998:	40d8                	lw	a4,4(s1)
    8000299a:	ff4713e3          	bne	a4,s4,80002980 <iget+0x38>
      ip->ref++;
    8000299e:	2785                	addiw	a5,a5,1
    800029a0:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029a2:	00015517          	auipc	a0,0x15
    800029a6:	8f650513          	addi	a0,a0,-1802 # 80017298 <itable>
    800029aa:	00004097          	auipc	ra,0x4
    800029ae:	9d6080e7          	jalr	-1578(ra) # 80006380 <release>
      return ip;
    800029b2:	8926                	mv	s2,s1
    800029b4:	a03d                	j	800029e2 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029b6:	f7f9                	bnez	a5,80002984 <iget+0x3c>
    800029b8:	8926                	mv	s2,s1
    800029ba:	b7e9                	j	80002984 <iget+0x3c>
  if(empty == 0)
    800029bc:	02090c63          	beqz	s2,800029f4 <iget+0xac>
  ip->dev = dev;
    800029c0:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029c4:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029c8:	4785                	li	a5,1
    800029ca:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029ce:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800029d2:	00015517          	auipc	a0,0x15
    800029d6:	8c650513          	addi	a0,a0,-1850 # 80017298 <itable>
    800029da:	00004097          	auipc	ra,0x4
    800029de:	9a6080e7          	jalr	-1626(ra) # 80006380 <release>
}
    800029e2:	854a                	mv	a0,s2
    800029e4:	70a2                	ld	ra,40(sp)
    800029e6:	7402                	ld	s0,32(sp)
    800029e8:	64e2                	ld	s1,24(sp)
    800029ea:	6942                	ld	s2,16(sp)
    800029ec:	69a2                	ld	s3,8(sp)
    800029ee:	6a02                	ld	s4,0(sp)
    800029f0:	6145                	addi	sp,sp,48
    800029f2:	8082                	ret
    panic("iget: no inodes");
    800029f4:	00006517          	auipc	a0,0x6
    800029f8:	cdc50513          	addi	a0,a0,-804 # 800086d0 <syscalls+0x140>
    800029fc:	00003097          	auipc	ra,0x3
    80002a00:	386080e7          	jalr	902(ra) # 80005d82 <panic>

0000000080002a04 <fsinit>:
fsinit(int dev) {
    80002a04:	7179                	addi	sp,sp,-48
    80002a06:	f406                	sd	ra,40(sp)
    80002a08:	f022                	sd	s0,32(sp)
    80002a0a:	ec26                	sd	s1,24(sp)
    80002a0c:	e84a                	sd	s2,16(sp)
    80002a0e:	e44e                	sd	s3,8(sp)
    80002a10:	1800                	addi	s0,sp,48
    80002a12:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a14:	4585                	li	a1,1
    80002a16:	00000097          	auipc	ra,0x0
    80002a1a:	a50080e7          	jalr	-1456(ra) # 80002466 <bread>
    80002a1e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a20:	00015997          	auipc	s3,0x15
    80002a24:	85898993          	addi	s3,s3,-1960 # 80017278 <sb>
    80002a28:	02000613          	li	a2,32
    80002a2c:	05850593          	addi	a1,a0,88
    80002a30:	854e                	mv	a0,s3
    80002a32:	ffffd097          	auipc	ra,0xffffd
    80002a36:	7ca080e7          	jalr	1994(ra) # 800001fc <memmove>
  brelse(bp);
    80002a3a:	8526                	mv	a0,s1
    80002a3c:	00000097          	auipc	ra,0x0
    80002a40:	b5a080e7          	jalr	-1190(ra) # 80002596 <brelse>
  if(sb.magic != FSMAGIC)
    80002a44:	0009a703          	lw	a4,0(s3)
    80002a48:	102037b7          	lui	a5,0x10203
    80002a4c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a50:	02f71263          	bne	a4,a5,80002a74 <fsinit+0x70>
  initlog(dev, &sb);
    80002a54:	00015597          	auipc	a1,0x15
    80002a58:	82458593          	addi	a1,a1,-2012 # 80017278 <sb>
    80002a5c:	854a                	mv	a0,s2
    80002a5e:	00001097          	auipc	ra,0x1
    80002a62:	b40080e7          	jalr	-1216(ra) # 8000359e <initlog>
}
    80002a66:	70a2                	ld	ra,40(sp)
    80002a68:	7402                	ld	s0,32(sp)
    80002a6a:	64e2                	ld	s1,24(sp)
    80002a6c:	6942                	ld	s2,16(sp)
    80002a6e:	69a2                	ld	s3,8(sp)
    80002a70:	6145                	addi	sp,sp,48
    80002a72:	8082                	ret
    panic("invalid file system");
    80002a74:	00006517          	auipc	a0,0x6
    80002a78:	c6c50513          	addi	a0,a0,-916 # 800086e0 <syscalls+0x150>
    80002a7c:	00003097          	auipc	ra,0x3
    80002a80:	306080e7          	jalr	774(ra) # 80005d82 <panic>

0000000080002a84 <iinit>:
{
    80002a84:	7179                	addi	sp,sp,-48
    80002a86:	f406                	sd	ra,40(sp)
    80002a88:	f022                	sd	s0,32(sp)
    80002a8a:	ec26                	sd	s1,24(sp)
    80002a8c:	e84a                	sd	s2,16(sp)
    80002a8e:	e44e                	sd	s3,8(sp)
    80002a90:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a92:	00006597          	auipc	a1,0x6
    80002a96:	c6658593          	addi	a1,a1,-922 # 800086f8 <syscalls+0x168>
    80002a9a:	00014517          	auipc	a0,0x14
    80002a9e:	7fe50513          	addi	a0,a0,2046 # 80017298 <itable>
    80002aa2:	00003097          	auipc	ra,0x3
    80002aa6:	79a080e7          	jalr	1946(ra) # 8000623c <initlock>
  for(i = 0; i < NINODE; i++) {
    80002aaa:	00015497          	auipc	s1,0x15
    80002aae:	81648493          	addi	s1,s1,-2026 # 800172c0 <itable+0x28>
    80002ab2:	00016997          	auipc	s3,0x16
    80002ab6:	29e98993          	addi	s3,s3,670 # 80018d50 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002aba:	00006917          	auipc	s2,0x6
    80002abe:	c4690913          	addi	s2,s2,-954 # 80008700 <syscalls+0x170>
    80002ac2:	85ca                	mv	a1,s2
    80002ac4:	8526                	mv	a0,s1
    80002ac6:	00001097          	auipc	ra,0x1
    80002aca:	e3a080e7          	jalr	-454(ra) # 80003900 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002ace:	08848493          	addi	s1,s1,136
    80002ad2:	ff3498e3          	bne	s1,s3,80002ac2 <iinit+0x3e>
}
    80002ad6:	70a2                	ld	ra,40(sp)
    80002ad8:	7402                	ld	s0,32(sp)
    80002ada:	64e2                	ld	s1,24(sp)
    80002adc:	6942                	ld	s2,16(sp)
    80002ade:	69a2                	ld	s3,8(sp)
    80002ae0:	6145                	addi	sp,sp,48
    80002ae2:	8082                	ret

0000000080002ae4 <ialloc>:
{
    80002ae4:	715d                	addi	sp,sp,-80
    80002ae6:	e486                	sd	ra,72(sp)
    80002ae8:	e0a2                	sd	s0,64(sp)
    80002aea:	fc26                	sd	s1,56(sp)
    80002aec:	f84a                	sd	s2,48(sp)
    80002aee:	f44e                	sd	s3,40(sp)
    80002af0:	f052                	sd	s4,32(sp)
    80002af2:	ec56                	sd	s5,24(sp)
    80002af4:	e85a                	sd	s6,16(sp)
    80002af6:	e45e                	sd	s7,8(sp)
    80002af8:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002afa:	00014717          	auipc	a4,0x14
    80002afe:	78a72703          	lw	a4,1930(a4) # 80017284 <sb+0xc>
    80002b02:	4785                	li	a5,1
    80002b04:	04e7fa63          	bgeu	a5,a4,80002b58 <ialloc+0x74>
    80002b08:	8aaa                	mv	s5,a0
    80002b0a:	8bae                	mv	s7,a1
    80002b0c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b0e:	00014a17          	auipc	s4,0x14
    80002b12:	76aa0a13          	addi	s4,s4,1898 # 80017278 <sb>
    80002b16:	00048b1b          	sext.w	s6,s1
    80002b1a:	0044d593          	srli	a1,s1,0x4
    80002b1e:	018a2783          	lw	a5,24(s4)
    80002b22:	9dbd                	addw	a1,a1,a5
    80002b24:	8556                	mv	a0,s5
    80002b26:	00000097          	auipc	ra,0x0
    80002b2a:	940080e7          	jalr	-1728(ra) # 80002466 <bread>
    80002b2e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b30:	05850993          	addi	s3,a0,88
    80002b34:	00f4f793          	andi	a5,s1,15
    80002b38:	079a                	slli	a5,a5,0x6
    80002b3a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b3c:	00099783          	lh	a5,0(s3)
    80002b40:	c3a1                	beqz	a5,80002b80 <ialloc+0x9c>
    brelse(bp);
    80002b42:	00000097          	auipc	ra,0x0
    80002b46:	a54080e7          	jalr	-1452(ra) # 80002596 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b4a:	0485                	addi	s1,s1,1
    80002b4c:	00ca2703          	lw	a4,12(s4)
    80002b50:	0004879b          	sext.w	a5,s1
    80002b54:	fce7e1e3          	bltu	a5,a4,80002b16 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002b58:	00006517          	auipc	a0,0x6
    80002b5c:	bb050513          	addi	a0,a0,-1104 # 80008708 <syscalls+0x178>
    80002b60:	00003097          	auipc	ra,0x3
    80002b64:	26c080e7          	jalr	620(ra) # 80005dcc <printf>
  return 0;
    80002b68:	4501                	li	a0,0
}
    80002b6a:	60a6                	ld	ra,72(sp)
    80002b6c:	6406                	ld	s0,64(sp)
    80002b6e:	74e2                	ld	s1,56(sp)
    80002b70:	7942                	ld	s2,48(sp)
    80002b72:	79a2                	ld	s3,40(sp)
    80002b74:	7a02                	ld	s4,32(sp)
    80002b76:	6ae2                	ld	s5,24(sp)
    80002b78:	6b42                	ld	s6,16(sp)
    80002b7a:	6ba2                	ld	s7,8(sp)
    80002b7c:	6161                	addi	sp,sp,80
    80002b7e:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b80:	04000613          	li	a2,64
    80002b84:	4581                	li	a1,0
    80002b86:	854e                	mv	a0,s3
    80002b88:	ffffd097          	auipc	ra,0xffffd
    80002b8c:	614080e7          	jalr	1556(ra) # 8000019c <memset>
      dip->type = type;
    80002b90:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b94:	854a                	mv	a0,s2
    80002b96:	00001097          	auipc	ra,0x1
    80002b9a:	c84080e7          	jalr	-892(ra) # 8000381a <log_write>
      brelse(bp);
    80002b9e:	854a                	mv	a0,s2
    80002ba0:	00000097          	auipc	ra,0x0
    80002ba4:	9f6080e7          	jalr	-1546(ra) # 80002596 <brelse>
      return iget(dev, inum);
    80002ba8:	85da                	mv	a1,s6
    80002baa:	8556                	mv	a0,s5
    80002bac:	00000097          	auipc	ra,0x0
    80002bb0:	d9c080e7          	jalr	-612(ra) # 80002948 <iget>
    80002bb4:	bf5d                	j	80002b6a <ialloc+0x86>

0000000080002bb6 <iupdate>:
{
    80002bb6:	1101                	addi	sp,sp,-32
    80002bb8:	ec06                	sd	ra,24(sp)
    80002bba:	e822                	sd	s0,16(sp)
    80002bbc:	e426                	sd	s1,8(sp)
    80002bbe:	e04a                	sd	s2,0(sp)
    80002bc0:	1000                	addi	s0,sp,32
    80002bc2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bc4:	415c                	lw	a5,4(a0)
    80002bc6:	0047d79b          	srliw	a5,a5,0x4
    80002bca:	00014597          	auipc	a1,0x14
    80002bce:	6c65a583          	lw	a1,1734(a1) # 80017290 <sb+0x18>
    80002bd2:	9dbd                	addw	a1,a1,a5
    80002bd4:	4108                	lw	a0,0(a0)
    80002bd6:	00000097          	auipc	ra,0x0
    80002bda:	890080e7          	jalr	-1904(ra) # 80002466 <bread>
    80002bde:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002be0:	05850793          	addi	a5,a0,88
    80002be4:	40c8                	lw	a0,4(s1)
    80002be6:	893d                	andi	a0,a0,15
    80002be8:	051a                	slli	a0,a0,0x6
    80002bea:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002bec:	04449703          	lh	a4,68(s1)
    80002bf0:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002bf4:	04649703          	lh	a4,70(s1)
    80002bf8:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002bfc:	04849703          	lh	a4,72(s1)
    80002c00:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002c04:	04a49703          	lh	a4,74(s1)
    80002c08:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002c0c:	44f8                	lw	a4,76(s1)
    80002c0e:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c10:	03400613          	li	a2,52
    80002c14:	05048593          	addi	a1,s1,80
    80002c18:	0531                	addi	a0,a0,12
    80002c1a:	ffffd097          	auipc	ra,0xffffd
    80002c1e:	5e2080e7          	jalr	1506(ra) # 800001fc <memmove>
  log_write(bp);
    80002c22:	854a                	mv	a0,s2
    80002c24:	00001097          	auipc	ra,0x1
    80002c28:	bf6080e7          	jalr	-1034(ra) # 8000381a <log_write>
  brelse(bp);
    80002c2c:	854a                	mv	a0,s2
    80002c2e:	00000097          	auipc	ra,0x0
    80002c32:	968080e7          	jalr	-1688(ra) # 80002596 <brelse>
}
    80002c36:	60e2                	ld	ra,24(sp)
    80002c38:	6442                	ld	s0,16(sp)
    80002c3a:	64a2                	ld	s1,8(sp)
    80002c3c:	6902                	ld	s2,0(sp)
    80002c3e:	6105                	addi	sp,sp,32
    80002c40:	8082                	ret

0000000080002c42 <idup>:
{
    80002c42:	1101                	addi	sp,sp,-32
    80002c44:	ec06                	sd	ra,24(sp)
    80002c46:	e822                	sd	s0,16(sp)
    80002c48:	e426                	sd	s1,8(sp)
    80002c4a:	1000                	addi	s0,sp,32
    80002c4c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c4e:	00014517          	auipc	a0,0x14
    80002c52:	64a50513          	addi	a0,a0,1610 # 80017298 <itable>
    80002c56:	00003097          	auipc	ra,0x3
    80002c5a:	676080e7          	jalr	1654(ra) # 800062cc <acquire>
  ip->ref++;
    80002c5e:	449c                	lw	a5,8(s1)
    80002c60:	2785                	addiw	a5,a5,1
    80002c62:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c64:	00014517          	auipc	a0,0x14
    80002c68:	63450513          	addi	a0,a0,1588 # 80017298 <itable>
    80002c6c:	00003097          	auipc	ra,0x3
    80002c70:	714080e7          	jalr	1812(ra) # 80006380 <release>
}
    80002c74:	8526                	mv	a0,s1
    80002c76:	60e2                	ld	ra,24(sp)
    80002c78:	6442                	ld	s0,16(sp)
    80002c7a:	64a2                	ld	s1,8(sp)
    80002c7c:	6105                	addi	sp,sp,32
    80002c7e:	8082                	ret

0000000080002c80 <ilock>:
{
    80002c80:	1101                	addi	sp,sp,-32
    80002c82:	ec06                	sd	ra,24(sp)
    80002c84:	e822                	sd	s0,16(sp)
    80002c86:	e426                	sd	s1,8(sp)
    80002c88:	e04a                	sd	s2,0(sp)
    80002c8a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c8c:	c115                	beqz	a0,80002cb0 <ilock+0x30>
    80002c8e:	84aa                	mv	s1,a0
    80002c90:	451c                	lw	a5,8(a0)
    80002c92:	00f05f63          	blez	a5,80002cb0 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c96:	0541                	addi	a0,a0,16
    80002c98:	00001097          	auipc	ra,0x1
    80002c9c:	ca2080e7          	jalr	-862(ra) # 8000393a <acquiresleep>
  if(ip->valid == 0){
    80002ca0:	40bc                	lw	a5,64(s1)
    80002ca2:	cf99                	beqz	a5,80002cc0 <ilock+0x40>
}
    80002ca4:	60e2                	ld	ra,24(sp)
    80002ca6:	6442                	ld	s0,16(sp)
    80002ca8:	64a2                	ld	s1,8(sp)
    80002caa:	6902                	ld	s2,0(sp)
    80002cac:	6105                	addi	sp,sp,32
    80002cae:	8082                	ret
    panic("ilock");
    80002cb0:	00006517          	auipc	a0,0x6
    80002cb4:	a7050513          	addi	a0,a0,-1424 # 80008720 <syscalls+0x190>
    80002cb8:	00003097          	auipc	ra,0x3
    80002cbc:	0ca080e7          	jalr	202(ra) # 80005d82 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cc0:	40dc                	lw	a5,4(s1)
    80002cc2:	0047d79b          	srliw	a5,a5,0x4
    80002cc6:	00014597          	auipc	a1,0x14
    80002cca:	5ca5a583          	lw	a1,1482(a1) # 80017290 <sb+0x18>
    80002cce:	9dbd                	addw	a1,a1,a5
    80002cd0:	4088                	lw	a0,0(s1)
    80002cd2:	fffff097          	auipc	ra,0xfffff
    80002cd6:	794080e7          	jalr	1940(ra) # 80002466 <bread>
    80002cda:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cdc:	05850593          	addi	a1,a0,88
    80002ce0:	40dc                	lw	a5,4(s1)
    80002ce2:	8bbd                	andi	a5,a5,15
    80002ce4:	079a                	slli	a5,a5,0x6
    80002ce6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ce8:	00059783          	lh	a5,0(a1)
    80002cec:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002cf0:	00259783          	lh	a5,2(a1)
    80002cf4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002cf8:	00459783          	lh	a5,4(a1)
    80002cfc:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d00:	00659783          	lh	a5,6(a1)
    80002d04:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d08:	459c                	lw	a5,8(a1)
    80002d0a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d0c:	03400613          	li	a2,52
    80002d10:	05b1                	addi	a1,a1,12
    80002d12:	05048513          	addi	a0,s1,80
    80002d16:	ffffd097          	auipc	ra,0xffffd
    80002d1a:	4e6080e7          	jalr	1254(ra) # 800001fc <memmove>
    brelse(bp);
    80002d1e:	854a                	mv	a0,s2
    80002d20:	00000097          	auipc	ra,0x0
    80002d24:	876080e7          	jalr	-1930(ra) # 80002596 <brelse>
    ip->valid = 1;
    80002d28:	4785                	li	a5,1
    80002d2a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d2c:	04449783          	lh	a5,68(s1)
    80002d30:	fbb5                	bnez	a5,80002ca4 <ilock+0x24>
      panic("ilock: no type");
    80002d32:	00006517          	auipc	a0,0x6
    80002d36:	9f650513          	addi	a0,a0,-1546 # 80008728 <syscalls+0x198>
    80002d3a:	00003097          	auipc	ra,0x3
    80002d3e:	048080e7          	jalr	72(ra) # 80005d82 <panic>

0000000080002d42 <iunlock>:
{
    80002d42:	1101                	addi	sp,sp,-32
    80002d44:	ec06                	sd	ra,24(sp)
    80002d46:	e822                	sd	s0,16(sp)
    80002d48:	e426                	sd	s1,8(sp)
    80002d4a:	e04a                	sd	s2,0(sp)
    80002d4c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d4e:	c905                	beqz	a0,80002d7e <iunlock+0x3c>
    80002d50:	84aa                	mv	s1,a0
    80002d52:	01050913          	addi	s2,a0,16
    80002d56:	854a                	mv	a0,s2
    80002d58:	00001097          	auipc	ra,0x1
    80002d5c:	c7c080e7          	jalr	-900(ra) # 800039d4 <holdingsleep>
    80002d60:	cd19                	beqz	a0,80002d7e <iunlock+0x3c>
    80002d62:	449c                	lw	a5,8(s1)
    80002d64:	00f05d63          	blez	a5,80002d7e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d68:	854a                	mv	a0,s2
    80002d6a:	00001097          	auipc	ra,0x1
    80002d6e:	c26080e7          	jalr	-986(ra) # 80003990 <releasesleep>
}
    80002d72:	60e2                	ld	ra,24(sp)
    80002d74:	6442                	ld	s0,16(sp)
    80002d76:	64a2                	ld	s1,8(sp)
    80002d78:	6902                	ld	s2,0(sp)
    80002d7a:	6105                	addi	sp,sp,32
    80002d7c:	8082                	ret
    panic("iunlock");
    80002d7e:	00006517          	auipc	a0,0x6
    80002d82:	9ba50513          	addi	a0,a0,-1606 # 80008738 <syscalls+0x1a8>
    80002d86:	00003097          	auipc	ra,0x3
    80002d8a:	ffc080e7          	jalr	-4(ra) # 80005d82 <panic>

0000000080002d8e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d8e:	7179                	addi	sp,sp,-48
    80002d90:	f406                	sd	ra,40(sp)
    80002d92:	f022                	sd	s0,32(sp)
    80002d94:	ec26                	sd	s1,24(sp)
    80002d96:	e84a                	sd	s2,16(sp)
    80002d98:	e44e                	sd	s3,8(sp)
    80002d9a:	e052                	sd	s4,0(sp)
    80002d9c:	1800                	addi	s0,sp,48
    80002d9e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002da0:	05050493          	addi	s1,a0,80
    80002da4:	08050913          	addi	s2,a0,128
    80002da8:	a021                	j	80002db0 <itrunc+0x22>
    80002daa:	0491                	addi	s1,s1,4
    80002dac:	01248d63          	beq	s1,s2,80002dc6 <itrunc+0x38>
    if(ip->addrs[i]){
    80002db0:	408c                	lw	a1,0(s1)
    80002db2:	dde5                	beqz	a1,80002daa <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002db4:	0009a503          	lw	a0,0(s3)
    80002db8:	00000097          	auipc	ra,0x0
    80002dbc:	8f4080e7          	jalr	-1804(ra) # 800026ac <bfree>
      ip->addrs[i] = 0;
    80002dc0:	0004a023          	sw	zero,0(s1)
    80002dc4:	b7dd                	j	80002daa <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002dc6:	0809a583          	lw	a1,128(s3)
    80002dca:	e185                	bnez	a1,80002dea <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002dcc:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002dd0:	854e                	mv	a0,s3
    80002dd2:	00000097          	auipc	ra,0x0
    80002dd6:	de4080e7          	jalr	-540(ra) # 80002bb6 <iupdate>
}
    80002dda:	70a2                	ld	ra,40(sp)
    80002ddc:	7402                	ld	s0,32(sp)
    80002dde:	64e2                	ld	s1,24(sp)
    80002de0:	6942                	ld	s2,16(sp)
    80002de2:	69a2                	ld	s3,8(sp)
    80002de4:	6a02                	ld	s4,0(sp)
    80002de6:	6145                	addi	sp,sp,48
    80002de8:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002dea:	0009a503          	lw	a0,0(s3)
    80002dee:	fffff097          	auipc	ra,0xfffff
    80002df2:	678080e7          	jalr	1656(ra) # 80002466 <bread>
    80002df6:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002df8:	05850493          	addi	s1,a0,88
    80002dfc:	45850913          	addi	s2,a0,1112
    80002e00:	a811                	j	80002e14 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002e02:	0009a503          	lw	a0,0(s3)
    80002e06:	00000097          	auipc	ra,0x0
    80002e0a:	8a6080e7          	jalr	-1882(ra) # 800026ac <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002e0e:	0491                	addi	s1,s1,4
    80002e10:	01248563          	beq	s1,s2,80002e1a <itrunc+0x8c>
      if(a[j])
    80002e14:	408c                	lw	a1,0(s1)
    80002e16:	dde5                	beqz	a1,80002e0e <itrunc+0x80>
    80002e18:	b7ed                	j	80002e02 <itrunc+0x74>
    brelse(bp);
    80002e1a:	8552                	mv	a0,s4
    80002e1c:	fffff097          	auipc	ra,0xfffff
    80002e20:	77a080e7          	jalr	1914(ra) # 80002596 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e24:	0809a583          	lw	a1,128(s3)
    80002e28:	0009a503          	lw	a0,0(s3)
    80002e2c:	00000097          	auipc	ra,0x0
    80002e30:	880080e7          	jalr	-1920(ra) # 800026ac <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e34:	0809a023          	sw	zero,128(s3)
    80002e38:	bf51                	j	80002dcc <itrunc+0x3e>

0000000080002e3a <iput>:
{
    80002e3a:	1101                	addi	sp,sp,-32
    80002e3c:	ec06                	sd	ra,24(sp)
    80002e3e:	e822                	sd	s0,16(sp)
    80002e40:	e426                	sd	s1,8(sp)
    80002e42:	e04a                	sd	s2,0(sp)
    80002e44:	1000                	addi	s0,sp,32
    80002e46:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e48:	00014517          	auipc	a0,0x14
    80002e4c:	45050513          	addi	a0,a0,1104 # 80017298 <itable>
    80002e50:	00003097          	auipc	ra,0x3
    80002e54:	47c080e7          	jalr	1148(ra) # 800062cc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e58:	4498                	lw	a4,8(s1)
    80002e5a:	4785                	li	a5,1
    80002e5c:	02f70363          	beq	a4,a5,80002e82 <iput+0x48>
  ip->ref--;
    80002e60:	449c                	lw	a5,8(s1)
    80002e62:	37fd                	addiw	a5,a5,-1
    80002e64:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e66:	00014517          	auipc	a0,0x14
    80002e6a:	43250513          	addi	a0,a0,1074 # 80017298 <itable>
    80002e6e:	00003097          	auipc	ra,0x3
    80002e72:	512080e7          	jalr	1298(ra) # 80006380 <release>
}
    80002e76:	60e2                	ld	ra,24(sp)
    80002e78:	6442                	ld	s0,16(sp)
    80002e7a:	64a2                	ld	s1,8(sp)
    80002e7c:	6902                	ld	s2,0(sp)
    80002e7e:	6105                	addi	sp,sp,32
    80002e80:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e82:	40bc                	lw	a5,64(s1)
    80002e84:	dff1                	beqz	a5,80002e60 <iput+0x26>
    80002e86:	04a49783          	lh	a5,74(s1)
    80002e8a:	fbf9                	bnez	a5,80002e60 <iput+0x26>
    acquiresleep(&ip->lock);
    80002e8c:	01048913          	addi	s2,s1,16
    80002e90:	854a                	mv	a0,s2
    80002e92:	00001097          	auipc	ra,0x1
    80002e96:	aa8080e7          	jalr	-1368(ra) # 8000393a <acquiresleep>
    release(&itable.lock);
    80002e9a:	00014517          	auipc	a0,0x14
    80002e9e:	3fe50513          	addi	a0,a0,1022 # 80017298 <itable>
    80002ea2:	00003097          	auipc	ra,0x3
    80002ea6:	4de080e7          	jalr	1246(ra) # 80006380 <release>
    itrunc(ip);
    80002eaa:	8526                	mv	a0,s1
    80002eac:	00000097          	auipc	ra,0x0
    80002eb0:	ee2080e7          	jalr	-286(ra) # 80002d8e <itrunc>
    ip->type = 0;
    80002eb4:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002eb8:	8526                	mv	a0,s1
    80002eba:	00000097          	auipc	ra,0x0
    80002ebe:	cfc080e7          	jalr	-772(ra) # 80002bb6 <iupdate>
    ip->valid = 0;
    80002ec2:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002ec6:	854a                	mv	a0,s2
    80002ec8:	00001097          	auipc	ra,0x1
    80002ecc:	ac8080e7          	jalr	-1336(ra) # 80003990 <releasesleep>
    acquire(&itable.lock);
    80002ed0:	00014517          	auipc	a0,0x14
    80002ed4:	3c850513          	addi	a0,a0,968 # 80017298 <itable>
    80002ed8:	00003097          	auipc	ra,0x3
    80002edc:	3f4080e7          	jalr	1012(ra) # 800062cc <acquire>
    80002ee0:	b741                	j	80002e60 <iput+0x26>

0000000080002ee2 <iunlockput>:
{
    80002ee2:	1101                	addi	sp,sp,-32
    80002ee4:	ec06                	sd	ra,24(sp)
    80002ee6:	e822                	sd	s0,16(sp)
    80002ee8:	e426                	sd	s1,8(sp)
    80002eea:	1000                	addi	s0,sp,32
    80002eec:	84aa                	mv	s1,a0
  iunlock(ip);
    80002eee:	00000097          	auipc	ra,0x0
    80002ef2:	e54080e7          	jalr	-428(ra) # 80002d42 <iunlock>
  iput(ip);
    80002ef6:	8526                	mv	a0,s1
    80002ef8:	00000097          	auipc	ra,0x0
    80002efc:	f42080e7          	jalr	-190(ra) # 80002e3a <iput>
}
    80002f00:	60e2                	ld	ra,24(sp)
    80002f02:	6442                	ld	s0,16(sp)
    80002f04:	64a2                	ld	s1,8(sp)
    80002f06:	6105                	addi	sp,sp,32
    80002f08:	8082                	ret

0000000080002f0a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f0a:	1141                	addi	sp,sp,-16
    80002f0c:	e422                	sd	s0,8(sp)
    80002f0e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f10:	411c                	lw	a5,0(a0)
    80002f12:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f14:	415c                	lw	a5,4(a0)
    80002f16:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f18:	04451783          	lh	a5,68(a0)
    80002f1c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f20:	04a51783          	lh	a5,74(a0)
    80002f24:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f28:	04c56783          	lwu	a5,76(a0)
    80002f2c:	e99c                	sd	a5,16(a1)
}
    80002f2e:	6422                	ld	s0,8(sp)
    80002f30:	0141                	addi	sp,sp,16
    80002f32:	8082                	ret

0000000080002f34 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f34:	457c                	lw	a5,76(a0)
    80002f36:	0ed7e963          	bltu	a5,a3,80003028 <readi+0xf4>
{
    80002f3a:	7159                	addi	sp,sp,-112
    80002f3c:	f486                	sd	ra,104(sp)
    80002f3e:	f0a2                	sd	s0,96(sp)
    80002f40:	eca6                	sd	s1,88(sp)
    80002f42:	e8ca                	sd	s2,80(sp)
    80002f44:	e4ce                	sd	s3,72(sp)
    80002f46:	e0d2                	sd	s4,64(sp)
    80002f48:	fc56                	sd	s5,56(sp)
    80002f4a:	f85a                	sd	s6,48(sp)
    80002f4c:	f45e                	sd	s7,40(sp)
    80002f4e:	f062                	sd	s8,32(sp)
    80002f50:	ec66                	sd	s9,24(sp)
    80002f52:	e86a                	sd	s10,16(sp)
    80002f54:	e46e                	sd	s11,8(sp)
    80002f56:	1880                	addi	s0,sp,112
    80002f58:	8b2a                	mv	s6,a0
    80002f5a:	8bae                	mv	s7,a1
    80002f5c:	8a32                	mv	s4,a2
    80002f5e:	84b6                	mv	s1,a3
    80002f60:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002f62:	9f35                	addw	a4,a4,a3
    return 0;
    80002f64:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f66:	0ad76063          	bltu	a4,a3,80003006 <readi+0xd2>
  if(off + n > ip->size)
    80002f6a:	00e7f463          	bgeu	a5,a4,80002f72 <readi+0x3e>
    n = ip->size - off;
    80002f6e:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f72:	0a0a8963          	beqz	s5,80003024 <readi+0xf0>
    80002f76:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f78:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f7c:	5c7d                	li	s8,-1
    80002f7e:	a82d                	j	80002fb8 <readi+0x84>
    80002f80:	020d1d93          	slli	s11,s10,0x20
    80002f84:	020ddd93          	srli	s11,s11,0x20
    80002f88:	05890613          	addi	a2,s2,88
    80002f8c:	86ee                	mv	a3,s11
    80002f8e:	963a                	add	a2,a2,a4
    80002f90:	85d2                	mv	a1,s4
    80002f92:	855e                	mv	a0,s7
    80002f94:	fffff097          	auipc	ra,0xfffff
    80002f98:	9f8080e7          	jalr	-1544(ra) # 8000198c <either_copyout>
    80002f9c:	05850d63          	beq	a0,s8,80002ff6 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002fa0:	854a                	mv	a0,s2
    80002fa2:	fffff097          	auipc	ra,0xfffff
    80002fa6:	5f4080e7          	jalr	1524(ra) # 80002596 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002faa:	013d09bb          	addw	s3,s10,s3
    80002fae:	009d04bb          	addw	s1,s10,s1
    80002fb2:	9a6e                	add	s4,s4,s11
    80002fb4:	0559f763          	bgeu	s3,s5,80003002 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002fb8:	00a4d59b          	srliw	a1,s1,0xa
    80002fbc:	855a                	mv	a0,s6
    80002fbe:	00000097          	auipc	ra,0x0
    80002fc2:	8a2080e7          	jalr	-1886(ra) # 80002860 <bmap>
    80002fc6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002fca:	cd85                	beqz	a1,80003002 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002fcc:	000b2503          	lw	a0,0(s6)
    80002fd0:	fffff097          	auipc	ra,0xfffff
    80002fd4:	496080e7          	jalr	1174(ra) # 80002466 <bread>
    80002fd8:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fda:	3ff4f713          	andi	a4,s1,1023
    80002fde:	40ec87bb          	subw	a5,s9,a4
    80002fe2:	413a86bb          	subw	a3,s5,s3
    80002fe6:	8d3e                	mv	s10,a5
    80002fe8:	2781                	sext.w	a5,a5
    80002fea:	0006861b          	sext.w	a2,a3
    80002fee:	f8f679e3          	bgeu	a2,a5,80002f80 <readi+0x4c>
    80002ff2:	8d36                	mv	s10,a3
    80002ff4:	b771                	j	80002f80 <readi+0x4c>
      brelse(bp);
    80002ff6:	854a                	mv	a0,s2
    80002ff8:	fffff097          	auipc	ra,0xfffff
    80002ffc:	59e080e7          	jalr	1438(ra) # 80002596 <brelse>
      tot = -1;
    80003000:	59fd                	li	s3,-1
  }
  return tot;
    80003002:	0009851b          	sext.w	a0,s3
}
    80003006:	70a6                	ld	ra,104(sp)
    80003008:	7406                	ld	s0,96(sp)
    8000300a:	64e6                	ld	s1,88(sp)
    8000300c:	6946                	ld	s2,80(sp)
    8000300e:	69a6                	ld	s3,72(sp)
    80003010:	6a06                	ld	s4,64(sp)
    80003012:	7ae2                	ld	s5,56(sp)
    80003014:	7b42                	ld	s6,48(sp)
    80003016:	7ba2                	ld	s7,40(sp)
    80003018:	7c02                	ld	s8,32(sp)
    8000301a:	6ce2                	ld	s9,24(sp)
    8000301c:	6d42                	ld	s10,16(sp)
    8000301e:	6da2                	ld	s11,8(sp)
    80003020:	6165                	addi	sp,sp,112
    80003022:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003024:	89d6                	mv	s3,s5
    80003026:	bff1                	j	80003002 <readi+0xce>
    return 0;
    80003028:	4501                	li	a0,0
}
    8000302a:	8082                	ret

000000008000302c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000302c:	457c                	lw	a5,76(a0)
    8000302e:	10d7e863          	bltu	a5,a3,8000313e <writei+0x112>
{
    80003032:	7159                	addi	sp,sp,-112
    80003034:	f486                	sd	ra,104(sp)
    80003036:	f0a2                	sd	s0,96(sp)
    80003038:	eca6                	sd	s1,88(sp)
    8000303a:	e8ca                	sd	s2,80(sp)
    8000303c:	e4ce                	sd	s3,72(sp)
    8000303e:	e0d2                	sd	s4,64(sp)
    80003040:	fc56                	sd	s5,56(sp)
    80003042:	f85a                	sd	s6,48(sp)
    80003044:	f45e                	sd	s7,40(sp)
    80003046:	f062                	sd	s8,32(sp)
    80003048:	ec66                	sd	s9,24(sp)
    8000304a:	e86a                	sd	s10,16(sp)
    8000304c:	e46e                	sd	s11,8(sp)
    8000304e:	1880                	addi	s0,sp,112
    80003050:	8aaa                	mv	s5,a0
    80003052:	8bae                	mv	s7,a1
    80003054:	8a32                	mv	s4,a2
    80003056:	8936                	mv	s2,a3
    80003058:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000305a:	00e687bb          	addw	a5,a3,a4
    8000305e:	0ed7e263          	bltu	a5,a3,80003142 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003062:	00043737          	lui	a4,0x43
    80003066:	0ef76063          	bltu	a4,a5,80003146 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000306a:	0c0b0863          	beqz	s6,8000313a <writei+0x10e>
    8000306e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003070:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003074:	5c7d                	li	s8,-1
    80003076:	a091                	j	800030ba <writei+0x8e>
    80003078:	020d1d93          	slli	s11,s10,0x20
    8000307c:	020ddd93          	srli	s11,s11,0x20
    80003080:	05848513          	addi	a0,s1,88
    80003084:	86ee                	mv	a3,s11
    80003086:	8652                	mv	a2,s4
    80003088:	85de                	mv	a1,s7
    8000308a:	953a                	add	a0,a0,a4
    8000308c:	fffff097          	auipc	ra,0xfffff
    80003090:	956080e7          	jalr	-1706(ra) # 800019e2 <either_copyin>
    80003094:	07850263          	beq	a0,s8,800030f8 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003098:	8526                	mv	a0,s1
    8000309a:	00000097          	auipc	ra,0x0
    8000309e:	780080e7          	jalr	1920(ra) # 8000381a <log_write>
    brelse(bp);
    800030a2:	8526                	mv	a0,s1
    800030a4:	fffff097          	auipc	ra,0xfffff
    800030a8:	4f2080e7          	jalr	1266(ra) # 80002596 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030ac:	013d09bb          	addw	s3,s10,s3
    800030b0:	012d093b          	addw	s2,s10,s2
    800030b4:	9a6e                	add	s4,s4,s11
    800030b6:	0569f663          	bgeu	s3,s6,80003102 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800030ba:	00a9559b          	srliw	a1,s2,0xa
    800030be:	8556                	mv	a0,s5
    800030c0:	fffff097          	auipc	ra,0xfffff
    800030c4:	7a0080e7          	jalr	1952(ra) # 80002860 <bmap>
    800030c8:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800030cc:	c99d                	beqz	a1,80003102 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800030ce:	000aa503          	lw	a0,0(s5)
    800030d2:	fffff097          	auipc	ra,0xfffff
    800030d6:	394080e7          	jalr	916(ra) # 80002466 <bread>
    800030da:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030dc:	3ff97713          	andi	a4,s2,1023
    800030e0:	40ec87bb          	subw	a5,s9,a4
    800030e4:	413b06bb          	subw	a3,s6,s3
    800030e8:	8d3e                	mv	s10,a5
    800030ea:	2781                	sext.w	a5,a5
    800030ec:	0006861b          	sext.w	a2,a3
    800030f0:	f8f674e3          	bgeu	a2,a5,80003078 <writei+0x4c>
    800030f4:	8d36                	mv	s10,a3
    800030f6:	b749                	j	80003078 <writei+0x4c>
      brelse(bp);
    800030f8:	8526                	mv	a0,s1
    800030fa:	fffff097          	auipc	ra,0xfffff
    800030fe:	49c080e7          	jalr	1180(ra) # 80002596 <brelse>
  }

  if(off > ip->size)
    80003102:	04caa783          	lw	a5,76(s5)
    80003106:	0127f463          	bgeu	a5,s2,8000310e <writei+0xe2>
    ip->size = off;
    8000310a:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000310e:	8556                	mv	a0,s5
    80003110:	00000097          	auipc	ra,0x0
    80003114:	aa6080e7          	jalr	-1370(ra) # 80002bb6 <iupdate>

  return tot;
    80003118:	0009851b          	sext.w	a0,s3
}
    8000311c:	70a6                	ld	ra,104(sp)
    8000311e:	7406                	ld	s0,96(sp)
    80003120:	64e6                	ld	s1,88(sp)
    80003122:	6946                	ld	s2,80(sp)
    80003124:	69a6                	ld	s3,72(sp)
    80003126:	6a06                	ld	s4,64(sp)
    80003128:	7ae2                	ld	s5,56(sp)
    8000312a:	7b42                	ld	s6,48(sp)
    8000312c:	7ba2                	ld	s7,40(sp)
    8000312e:	7c02                	ld	s8,32(sp)
    80003130:	6ce2                	ld	s9,24(sp)
    80003132:	6d42                	ld	s10,16(sp)
    80003134:	6da2                	ld	s11,8(sp)
    80003136:	6165                	addi	sp,sp,112
    80003138:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000313a:	89da                	mv	s3,s6
    8000313c:	bfc9                	j	8000310e <writei+0xe2>
    return -1;
    8000313e:	557d                	li	a0,-1
}
    80003140:	8082                	ret
    return -1;
    80003142:	557d                	li	a0,-1
    80003144:	bfe1                	j	8000311c <writei+0xf0>
    return -1;
    80003146:	557d                	li	a0,-1
    80003148:	bfd1                	j	8000311c <writei+0xf0>

000000008000314a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000314a:	1141                	addi	sp,sp,-16
    8000314c:	e406                	sd	ra,8(sp)
    8000314e:	e022                	sd	s0,0(sp)
    80003150:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003152:	4639                	li	a2,14
    80003154:	ffffd097          	auipc	ra,0xffffd
    80003158:	120080e7          	jalr	288(ra) # 80000274 <strncmp>
}
    8000315c:	60a2                	ld	ra,8(sp)
    8000315e:	6402                	ld	s0,0(sp)
    80003160:	0141                	addi	sp,sp,16
    80003162:	8082                	ret

0000000080003164 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003164:	7139                	addi	sp,sp,-64
    80003166:	fc06                	sd	ra,56(sp)
    80003168:	f822                	sd	s0,48(sp)
    8000316a:	f426                	sd	s1,40(sp)
    8000316c:	f04a                	sd	s2,32(sp)
    8000316e:	ec4e                	sd	s3,24(sp)
    80003170:	e852                	sd	s4,16(sp)
    80003172:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003174:	04451703          	lh	a4,68(a0)
    80003178:	4785                	li	a5,1
    8000317a:	00f71a63          	bne	a4,a5,8000318e <dirlookup+0x2a>
    8000317e:	892a                	mv	s2,a0
    80003180:	89ae                	mv	s3,a1
    80003182:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003184:	457c                	lw	a5,76(a0)
    80003186:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003188:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000318a:	e79d                	bnez	a5,800031b8 <dirlookup+0x54>
    8000318c:	a8a5                	j	80003204 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000318e:	00005517          	auipc	a0,0x5
    80003192:	5b250513          	addi	a0,a0,1458 # 80008740 <syscalls+0x1b0>
    80003196:	00003097          	auipc	ra,0x3
    8000319a:	bec080e7          	jalr	-1044(ra) # 80005d82 <panic>
      panic("dirlookup read");
    8000319e:	00005517          	auipc	a0,0x5
    800031a2:	5ba50513          	addi	a0,a0,1466 # 80008758 <syscalls+0x1c8>
    800031a6:	00003097          	auipc	ra,0x3
    800031aa:	bdc080e7          	jalr	-1060(ra) # 80005d82 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031ae:	24c1                	addiw	s1,s1,16
    800031b0:	04c92783          	lw	a5,76(s2)
    800031b4:	04f4f763          	bgeu	s1,a5,80003202 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031b8:	4741                	li	a4,16
    800031ba:	86a6                	mv	a3,s1
    800031bc:	fc040613          	addi	a2,s0,-64
    800031c0:	4581                	li	a1,0
    800031c2:	854a                	mv	a0,s2
    800031c4:	00000097          	auipc	ra,0x0
    800031c8:	d70080e7          	jalr	-656(ra) # 80002f34 <readi>
    800031cc:	47c1                	li	a5,16
    800031ce:	fcf518e3          	bne	a0,a5,8000319e <dirlookup+0x3a>
    if(de.inum == 0)
    800031d2:	fc045783          	lhu	a5,-64(s0)
    800031d6:	dfe1                	beqz	a5,800031ae <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031d8:	fc240593          	addi	a1,s0,-62
    800031dc:	854e                	mv	a0,s3
    800031de:	00000097          	auipc	ra,0x0
    800031e2:	f6c080e7          	jalr	-148(ra) # 8000314a <namecmp>
    800031e6:	f561                	bnez	a0,800031ae <dirlookup+0x4a>
      if(poff)
    800031e8:	000a0463          	beqz	s4,800031f0 <dirlookup+0x8c>
        *poff = off;
    800031ec:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031f0:	fc045583          	lhu	a1,-64(s0)
    800031f4:	00092503          	lw	a0,0(s2)
    800031f8:	fffff097          	auipc	ra,0xfffff
    800031fc:	750080e7          	jalr	1872(ra) # 80002948 <iget>
    80003200:	a011                	j	80003204 <dirlookup+0xa0>
  return 0;
    80003202:	4501                	li	a0,0
}
    80003204:	70e2                	ld	ra,56(sp)
    80003206:	7442                	ld	s0,48(sp)
    80003208:	74a2                	ld	s1,40(sp)
    8000320a:	7902                	ld	s2,32(sp)
    8000320c:	69e2                	ld	s3,24(sp)
    8000320e:	6a42                	ld	s4,16(sp)
    80003210:	6121                	addi	sp,sp,64
    80003212:	8082                	ret

0000000080003214 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003214:	711d                	addi	sp,sp,-96
    80003216:	ec86                	sd	ra,88(sp)
    80003218:	e8a2                	sd	s0,80(sp)
    8000321a:	e4a6                	sd	s1,72(sp)
    8000321c:	e0ca                	sd	s2,64(sp)
    8000321e:	fc4e                	sd	s3,56(sp)
    80003220:	f852                	sd	s4,48(sp)
    80003222:	f456                	sd	s5,40(sp)
    80003224:	f05a                	sd	s6,32(sp)
    80003226:	ec5e                	sd	s7,24(sp)
    80003228:	e862                	sd	s8,16(sp)
    8000322a:	e466                	sd	s9,8(sp)
    8000322c:	1080                	addi	s0,sp,96
    8000322e:	84aa                	mv	s1,a0
    80003230:	8b2e                	mv	s6,a1
    80003232:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003234:	00054703          	lbu	a4,0(a0)
    80003238:	02f00793          	li	a5,47
    8000323c:	02f70363          	beq	a4,a5,80003262 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003240:	ffffe097          	auipc	ra,0xffffe
    80003244:	c94080e7          	jalr	-876(ra) # 80000ed4 <myproc>
    80003248:	15053503          	ld	a0,336(a0)
    8000324c:	00000097          	auipc	ra,0x0
    80003250:	9f6080e7          	jalr	-1546(ra) # 80002c42 <idup>
    80003254:	89aa                	mv	s3,a0
  while(*path == '/')
    80003256:	02f00913          	li	s2,47
  len = path - s;
    8000325a:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    8000325c:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000325e:	4c05                	li	s8,1
    80003260:	a865                	j	80003318 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003262:	4585                	li	a1,1
    80003264:	4505                	li	a0,1
    80003266:	fffff097          	auipc	ra,0xfffff
    8000326a:	6e2080e7          	jalr	1762(ra) # 80002948 <iget>
    8000326e:	89aa                	mv	s3,a0
    80003270:	b7dd                	j	80003256 <namex+0x42>
      iunlockput(ip);
    80003272:	854e                	mv	a0,s3
    80003274:	00000097          	auipc	ra,0x0
    80003278:	c6e080e7          	jalr	-914(ra) # 80002ee2 <iunlockput>
      return 0;
    8000327c:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000327e:	854e                	mv	a0,s3
    80003280:	60e6                	ld	ra,88(sp)
    80003282:	6446                	ld	s0,80(sp)
    80003284:	64a6                	ld	s1,72(sp)
    80003286:	6906                	ld	s2,64(sp)
    80003288:	79e2                	ld	s3,56(sp)
    8000328a:	7a42                	ld	s4,48(sp)
    8000328c:	7aa2                	ld	s5,40(sp)
    8000328e:	7b02                	ld	s6,32(sp)
    80003290:	6be2                	ld	s7,24(sp)
    80003292:	6c42                	ld	s8,16(sp)
    80003294:	6ca2                	ld	s9,8(sp)
    80003296:	6125                	addi	sp,sp,96
    80003298:	8082                	ret
      iunlock(ip);
    8000329a:	854e                	mv	a0,s3
    8000329c:	00000097          	auipc	ra,0x0
    800032a0:	aa6080e7          	jalr	-1370(ra) # 80002d42 <iunlock>
      return ip;
    800032a4:	bfe9                	j	8000327e <namex+0x6a>
      iunlockput(ip);
    800032a6:	854e                	mv	a0,s3
    800032a8:	00000097          	auipc	ra,0x0
    800032ac:	c3a080e7          	jalr	-966(ra) # 80002ee2 <iunlockput>
      return 0;
    800032b0:	89d2                	mv	s3,s4
    800032b2:	b7f1                	j	8000327e <namex+0x6a>
  len = path - s;
    800032b4:	40b48633          	sub	a2,s1,a1
    800032b8:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800032bc:	094cd463          	bge	s9,s4,80003344 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800032c0:	4639                	li	a2,14
    800032c2:	8556                	mv	a0,s5
    800032c4:	ffffd097          	auipc	ra,0xffffd
    800032c8:	f38080e7          	jalr	-200(ra) # 800001fc <memmove>
  while(*path == '/')
    800032cc:	0004c783          	lbu	a5,0(s1)
    800032d0:	01279763          	bne	a5,s2,800032de <namex+0xca>
    path++;
    800032d4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032d6:	0004c783          	lbu	a5,0(s1)
    800032da:	ff278de3          	beq	a5,s2,800032d4 <namex+0xc0>
    ilock(ip);
    800032de:	854e                	mv	a0,s3
    800032e0:	00000097          	auipc	ra,0x0
    800032e4:	9a0080e7          	jalr	-1632(ra) # 80002c80 <ilock>
    if(ip->type != T_DIR){
    800032e8:	04499783          	lh	a5,68(s3)
    800032ec:	f98793e3          	bne	a5,s8,80003272 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800032f0:	000b0563          	beqz	s6,800032fa <namex+0xe6>
    800032f4:	0004c783          	lbu	a5,0(s1)
    800032f8:	d3cd                	beqz	a5,8000329a <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032fa:	865e                	mv	a2,s7
    800032fc:	85d6                	mv	a1,s5
    800032fe:	854e                	mv	a0,s3
    80003300:	00000097          	auipc	ra,0x0
    80003304:	e64080e7          	jalr	-412(ra) # 80003164 <dirlookup>
    80003308:	8a2a                	mv	s4,a0
    8000330a:	dd51                	beqz	a0,800032a6 <namex+0x92>
    iunlockput(ip);
    8000330c:	854e                	mv	a0,s3
    8000330e:	00000097          	auipc	ra,0x0
    80003312:	bd4080e7          	jalr	-1068(ra) # 80002ee2 <iunlockput>
    ip = next;
    80003316:	89d2                	mv	s3,s4
  while(*path == '/')
    80003318:	0004c783          	lbu	a5,0(s1)
    8000331c:	05279763          	bne	a5,s2,8000336a <namex+0x156>
    path++;
    80003320:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003322:	0004c783          	lbu	a5,0(s1)
    80003326:	ff278de3          	beq	a5,s2,80003320 <namex+0x10c>
  if(*path == 0)
    8000332a:	c79d                	beqz	a5,80003358 <namex+0x144>
    path++;
    8000332c:	85a6                	mv	a1,s1
  len = path - s;
    8000332e:	8a5e                	mv	s4,s7
    80003330:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003332:	01278963          	beq	a5,s2,80003344 <namex+0x130>
    80003336:	dfbd                	beqz	a5,800032b4 <namex+0xa0>
    path++;
    80003338:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000333a:	0004c783          	lbu	a5,0(s1)
    8000333e:	ff279ce3          	bne	a5,s2,80003336 <namex+0x122>
    80003342:	bf8d                	j	800032b4 <namex+0xa0>
    memmove(name, s, len);
    80003344:	2601                	sext.w	a2,a2
    80003346:	8556                	mv	a0,s5
    80003348:	ffffd097          	auipc	ra,0xffffd
    8000334c:	eb4080e7          	jalr	-332(ra) # 800001fc <memmove>
    name[len] = 0;
    80003350:	9a56                	add	s4,s4,s5
    80003352:	000a0023          	sb	zero,0(s4)
    80003356:	bf9d                	j	800032cc <namex+0xb8>
  if(nameiparent){
    80003358:	f20b03e3          	beqz	s6,8000327e <namex+0x6a>
    iput(ip);
    8000335c:	854e                	mv	a0,s3
    8000335e:	00000097          	auipc	ra,0x0
    80003362:	adc080e7          	jalr	-1316(ra) # 80002e3a <iput>
    return 0;
    80003366:	4981                	li	s3,0
    80003368:	bf19                	j	8000327e <namex+0x6a>
  if(*path == 0)
    8000336a:	d7fd                	beqz	a5,80003358 <namex+0x144>
  while(*path != '/' && *path != 0)
    8000336c:	0004c783          	lbu	a5,0(s1)
    80003370:	85a6                	mv	a1,s1
    80003372:	b7d1                	j	80003336 <namex+0x122>

0000000080003374 <dirlink>:
{
    80003374:	7139                	addi	sp,sp,-64
    80003376:	fc06                	sd	ra,56(sp)
    80003378:	f822                	sd	s0,48(sp)
    8000337a:	f426                	sd	s1,40(sp)
    8000337c:	f04a                	sd	s2,32(sp)
    8000337e:	ec4e                	sd	s3,24(sp)
    80003380:	e852                	sd	s4,16(sp)
    80003382:	0080                	addi	s0,sp,64
    80003384:	892a                	mv	s2,a0
    80003386:	8a2e                	mv	s4,a1
    80003388:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000338a:	4601                	li	a2,0
    8000338c:	00000097          	auipc	ra,0x0
    80003390:	dd8080e7          	jalr	-552(ra) # 80003164 <dirlookup>
    80003394:	e93d                	bnez	a0,8000340a <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003396:	04c92483          	lw	s1,76(s2)
    8000339a:	c49d                	beqz	s1,800033c8 <dirlink+0x54>
    8000339c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000339e:	4741                	li	a4,16
    800033a0:	86a6                	mv	a3,s1
    800033a2:	fc040613          	addi	a2,s0,-64
    800033a6:	4581                	li	a1,0
    800033a8:	854a                	mv	a0,s2
    800033aa:	00000097          	auipc	ra,0x0
    800033ae:	b8a080e7          	jalr	-1142(ra) # 80002f34 <readi>
    800033b2:	47c1                	li	a5,16
    800033b4:	06f51163          	bne	a0,a5,80003416 <dirlink+0xa2>
    if(de.inum == 0)
    800033b8:	fc045783          	lhu	a5,-64(s0)
    800033bc:	c791                	beqz	a5,800033c8 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033be:	24c1                	addiw	s1,s1,16
    800033c0:	04c92783          	lw	a5,76(s2)
    800033c4:	fcf4ede3          	bltu	s1,a5,8000339e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033c8:	4639                	li	a2,14
    800033ca:	85d2                	mv	a1,s4
    800033cc:	fc240513          	addi	a0,s0,-62
    800033d0:	ffffd097          	auipc	ra,0xffffd
    800033d4:	ee0080e7          	jalr	-288(ra) # 800002b0 <strncpy>
  de.inum = inum;
    800033d8:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033dc:	4741                	li	a4,16
    800033de:	86a6                	mv	a3,s1
    800033e0:	fc040613          	addi	a2,s0,-64
    800033e4:	4581                	li	a1,0
    800033e6:	854a                	mv	a0,s2
    800033e8:	00000097          	auipc	ra,0x0
    800033ec:	c44080e7          	jalr	-956(ra) # 8000302c <writei>
    800033f0:	1541                	addi	a0,a0,-16
    800033f2:	00a03533          	snez	a0,a0
    800033f6:	40a00533          	neg	a0,a0
}
    800033fa:	70e2                	ld	ra,56(sp)
    800033fc:	7442                	ld	s0,48(sp)
    800033fe:	74a2                	ld	s1,40(sp)
    80003400:	7902                	ld	s2,32(sp)
    80003402:	69e2                	ld	s3,24(sp)
    80003404:	6a42                	ld	s4,16(sp)
    80003406:	6121                	addi	sp,sp,64
    80003408:	8082                	ret
    iput(ip);
    8000340a:	00000097          	auipc	ra,0x0
    8000340e:	a30080e7          	jalr	-1488(ra) # 80002e3a <iput>
    return -1;
    80003412:	557d                	li	a0,-1
    80003414:	b7dd                	j	800033fa <dirlink+0x86>
      panic("dirlink read");
    80003416:	00005517          	auipc	a0,0x5
    8000341a:	35250513          	addi	a0,a0,850 # 80008768 <syscalls+0x1d8>
    8000341e:	00003097          	auipc	ra,0x3
    80003422:	964080e7          	jalr	-1692(ra) # 80005d82 <panic>

0000000080003426 <namei>:

struct inode*
namei(char *path)
{
    80003426:	1101                	addi	sp,sp,-32
    80003428:	ec06                	sd	ra,24(sp)
    8000342a:	e822                	sd	s0,16(sp)
    8000342c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000342e:	fe040613          	addi	a2,s0,-32
    80003432:	4581                	li	a1,0
    80003434:	00000097          	auipc	ra,0x0
    80003438:	de0080e7          	jalr	-544(ra) # 80003214 <namex>
}
    8000343c:	60e2                	ld	ra,24(sp)
    8000343e:	6442                	ld	s0,16(sp)
    80003440:	6105                	addi	sp,sp,32
    80003442:	8082                	ret

0000000080003444 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003444:	1141                	addi	sp,sp,-16
    80003446:	e406                	sd	ra,8(sp)
    80003448:	e022                	sd	s0,0(sp)
    8000344a:	0800                	addi	s0,sp,16
    8000344c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000344e:	4585                	li	a1,1
    80003450:	00000097          	auipc	ra,0x0
    80003454:	dc4080e7          	jalr	-572(ra) # 80003214 <namex>
}
    80003458:	60a2                	ld	ra,8(sp)
    8000345a:	6402                	ld	s0,0(sp)
    8000345c:	0141                	addi	sp,sp,16
    8000345e:	8082                	ret

0000000080003460 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003460:	1101                	addi	sp,sp,-32
    80003462:	ec06                	sd	ra,24(sp)
    80003464:	e822                	sd	s0,16(sp)
    80003466:	e426                	sd	s1,8(sp)
    80003468:	e04a                	sd	s2,0(sp)
    8000346a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000346c:	00016917          	auipc	s2,0x16
    80003470:	8d490913          	addi	s2,s2,-1836 # 80018d40 <log>
    80003474:	01892583          	lw	a1,24(s2)
    80003478:	02892503          	lw	a0,40(s2)
    8000347c:	fffff097          	auipc	ra,0xfffff
    80003480:	fea080e7          	jalr	-22(ra) # 80002466 <bread>
    80003484:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003486:	02c92683          	lw	a3,44(s2)
    8000348a:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000348c:	02d05763          	blez	a3,800034ba <write_head+0x5a>
    80003490:	00016797          	auipc	a5,0x16
    80003494:	8e078793          	addi	a5,a5,-1824 # 80018d70 <log+0x30>
    80003498:	05c50713          	addi	a4,a0,92
    8000349c:	36fd                	addiw	a3,a3,-1
    8000349e:	1682                	slli	a3,a3,0x20
    800034a0:	9281                	srli	a3,a3,0x20
    800034a2:	068a                	slli	a3,a3,0x2
    800034a4:	00016617          	auipc	a2,0x16
    800034a8:	8d060613          	addi	a2,a2,-1840 # 80018d74 <log+0x34>
    800034ac:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800034ae:	4390                	lw	a2,0(a5)
    800034b0:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034b2:	0791                	addi	a5,a5,4
    800034b4:	0711                	addi	a4,a4,4
    800034b6:	fed79ce3          	bne	a5,a3,800034ae <write_head+0x4e>
  }
  bwrite(buf);
    800034ba:	8526                	mv	a0,s1
    800034bc:	fffff097          	auipc	ra,0xfffff
    800034c0:	09c080e7          	jalr	156(ra) # 80002558 <bwrite>
  brelse(buf);
    800034c4:	8526                	mv	a0,s1
    800034c6:	fffff097          	auipc	ra,0xfffff
    800034ca:	0d0080e7          	jalr	208(ra) # 80002596 <brelse>
}
    800034ce:	60e2                	ld	ra,24(sp)
    800034d0:	6442                	ld	s0,16(sp)
    800034d2:	64a2                	ld	s1,8(sp)
    800034d4:	6902                	ld	s2,0(sp)
    800034d6:	6105                	addi	sp,sp,32
    800034d8:	8082                	ret

00000000800034da <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034da:	00016797          	auipc	a5,0x16
    800034de:	8927a783          	lw	a5,-1902(a5) # 80018d6c <log+0x2c>
    800034e2:	0af05d63          	blez	a5,8000359c <install_trans+0xc2>
{
    800034e6:	7139                	addi	sp,sp,-64
    800034e8:	fc06                	sd	ra,56(sp)
    800034ea:	f822                	sd	s0,48(sp)
    800034ec:	f426                	sd	s1,40(sp)
    800034ee:	f04a                	sd	s2,32(sp)
    800034f0:	ec4e                	sd	s3,24(sp)
    800034f2:	e852                	sd	s4,16(sp)
    800034f4:	e456                	sd	s5,8(sp)
    800034f6:	e05a                	sd	s6,0(sp)
    800034f8:	0080                	addi	s0,sp,64
    800034fa:	8b2a                	mv	s6,a0
    800034fc:	00016a97          	auipc	s5,0x16
    80003500:	874a8a93          	addi	s5,s5,-1932 # 80018d70 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003504:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003506:	00016997          	auipc	s3,0x16
    8000350a:	83a98993          	addi	s3,s3,-1990 # 80018d40 <log>
    8000350e:	a035                	j	8000353a <install_trans+0x60>
      bunpin(dbuf);
    80003510:	8526                	mv	a0,s1
    80003512:	fffff097          	auipc	ra,0xfffff
    80003516:	15e080e7          	jalr	350(ra) # 80002670 <bunpin>
    brelse(lbuf);
    8000351a:	854a                	mv	a0,s2
    8000351c:	fffff097          	auipc	ra,0xfffff
    80003520:	07a080e7          	jalr	122(ra) # 80002596 <brelse>
    brelse(dbuf);
    80003524:	8526                	mv	a0,s1
    80003526:	fffff097          	auipc	ra,0xfffff
    8000352a:	070080e7          	jalr	112(ra) # 80002596 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000352e:	2a05                	addiw	s4,s4,1
    80003530:	0a91                	addi	s5,s5,4
    80003532:	02c9a783          	lw	a5,44(s3)
    80003536:	04fa5963          	bge	s4,a5,80003588 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000353a:	0189a583          	lw	a1,24(s3)
    8000353e:	014585bb          	addw	a1,a1,s4
    80003542:	2585                	addiw	a1,a1,1
    80003544:	0289a503          	lw	a0,40(s3)
    80003548:	fffff097          	auipc	ra,0xfffff
    8000354c:	f1e080e7          	jalr	-226(ra) # 80002466 <bread>
    80003550:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003552:	000aa583          	lw	a1,0(s5)
    80003556:	0289a503          	lw	a0,40(s3)
    8000355a:	fffff097          	auipc	ra,0xfffff
    8000355e:	f0c080e7          	jalr	-244(ra) # 80002466 <bread>
    80003562:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003564:	40000613          	li	a2,1024
    80003568:	05890593          	addi	a1,s2,88
    8000356c:	05850513          	addi	a0,a0,88
    80003570:	ffffd097          	auipc	ra,0xffffd
    80003574:	c8c080e7          	jalr	-884(ra) # 800001fc <memmove>
    bwrite(dbuf);  // write dst to disk
    80003578:	8526                	mv	a0,s1
    8000357a:	fffff097          	auipc	ra,0xfffff
    8000357e:	fde080e7          	jalr	-34(ra) # 80002558 <bwrite>
    if(recovering == 0)
    80003582:	f80b1ce3          	bnez	s6,8000351a <install_trans+0x40>
    80003586:	b769                	j	80003510 <install_trans+0x36>
}
    80003588:	70e2                	ld	ra,56(sp)
    8000358a:	7442                	ld	s0,48(sp)
    8000358c:	74a2                	ld	s1,40(sp)
    8000358e:	7902                	ld	s2,32(sp)
    80003590:	69e2                	ld	s3,24(sp)
    80003592:	6a42                	ld	s4,16(sp)
    80003594:	6aa2                	ld	s5,8(sp)
    80003596:	6b02                	ld	s6,0(sp)
    80003598:	6121                	addi	sp,sp,64
    8000359a:	8082                	ret
    8000359c:	8082                	ret

000000008000359e <initlog>:
{
    8000359e:	7179                	addi	sp,sp,-48
    800035a0:	f406                	sd	ra,40(sp)
    800035a2:	f022                	sd	s0,32(sp)
    800035a4:	ec26                	sd	s1,24(sp)
    800035a6:	e84a                	sd	s2,16(sp)
    800035a8:	e44e                	sd	s3,8(sp)
    800035aa:	1800                	addi	s0,sp,48
    800035ac:	892a                	mv	s2,a0
    800035ae:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035b0:	00015497          	auipc	s1,0x15
    800035b4:	79048493          	addi	s1,s1,1936 # 80018d40 <log>
    800035b8:	00005597          	auipc	a1,0x5
    800035bc:	1c058593          	addi	a1,a1,448 # 80008778 <syscalls+0x1e8>
    800035c0:	8526                	mv	a0,s1
    800035c2:	00003097          	auipc	ra,0x3
    800035c6:	c7a080e7          	jalr	-902(ra) # 8000623c <initlock>
  log.start = sb->logstart;
    800035ca:	0149a583          	lw	a1,20(s3)
    800035ce:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035d0:	0109a783          	lw	a5,16(s3)
    800035d4:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035d6:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800035da:	854a                	mv	a0,s2
    800035dc:	fffff097          	auipc	ra,0xfffff
    800035e0:	e8a080e7          	jalr	-374(ra) # 80002466 <bread>
  log.lh.n = lh->n;
    800035e4:	4d3c                	lw	a5,88(a0)
    800035e6:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035e8:	02f05563          	blez	a5,80003612 <initlog+0x74>
    800035ec:	05c50713          	addi	a4,a0,92
    800035f0:	00015697          	auipc	a3,0x15
    800035f4:	78068693          	addi	a3,a3,1920 # 80018d70 <log+0x30>
    800035f8:	37fd                	addiw	a5,a5,-1
    800035fa:	1782                	slli	a5,a5,0x20
    800035fc:	9381                	srli	a5,a5,0x20
    800035fe:	078a                	slli	a5,a5,0x2
    80003600:	06050613          	addi	a2,a0,96
    80003604:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003606:	4310                	lw	a2,0(a4)
    80003608:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000360a:	0711                	addi	a4,a4,4
    8000360c:	0691                	addi	a3,a3,4
    8000360e:	fef71ce3          	bne	a4,a5,80003606 <initlog+0x68>
  brelse(buf);
    80003612:	fffff097          	auipc	ra,0xfffff
    80003616:	f84080e7          	jalr	-124(ra) # 80002596 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000361a:	4505                	li	a0,1
    8000361c:	00000097          	auipc	ra,0x0
    80003620:	ebe080e7          	jalr	-322(ra) # 800034da <install_trans>
  log.lh.n = 0;
    80003624:	00015797          	auipc	a5,0x15
    80003628:	7407a423          	sw	zero,1864(a5) # 80018d6c <log+0x2c>
  write_head(); // clear the log
    8000362c:	00000097          	auipc	ra,0x0
    80003630:	e34080e7          	jalr	-460(ra) # 80003460 <write_head>
}
    80003634:	70a2                	ld	ra,40(sp)
    80003636:	7402                	ld	s0,32(sp)
    80003638:	64e2                	ld	s1,24(sp)
    8000363a:	6942                	ld	s2,16(sp)
    8000363c:	69a2                	ld	s3,8(sp)
    8000363e:	6145                	addi	sp,sp,48
    80003640:	8082                	ret

0000000080003642 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003642:	1101                	addi	sp,sp,-32
    80003644:	ec06                	sd	ra,24(sp)
    80003646:	e822                	sd	s0,16(sp)
    80003648:	e426                	sd	s1,8(sp)
    8000364a:	e04a                	sd	s2,0(sp)
    8000364c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000364e:	00015517          	auipc	a0,0x15
    80003652:	6f250513          	addi	a0,a0,1778 # 80018d40 <log>
    80003656:	00003097          	auipc	ra,0x3
    8000365a:	c76080e7          	jalr	-906(ra) # 800062cc <acquire>
  while(1){
    if(log.committing){
    8000365e:	00015497          	auipc	s1,0x15
    80003662:	6e248493          	addi	s1,s1,1762 # 80018d40 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003666:	4979                	li	s2,30
    80003668:	a039                	j	80003676 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000366a:	85a6                	mv	a1,s1
    8000366c:	8526                	mv	a0,s1
    8000366e:	ffffe097          	auipc	ra,0xffffe
    80003672:	f16080e7          	jalr	-234(ra) # 80001584 <sleep>
    if(log.committing){
    80003676:	50dc                	lw	a5,36(s1)
    80003678:	fbed                	bnez	a5,8000366a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000367a:	509c                	lw	a5,32(s1)
    8000367c:	0017871b          	addiw	a4,a5,1
    80003680:	0007069b          	sext.w	a3,a4
    80003684:	0027179b          	slliw	a5,a4,0x2
    80003688:	9fb9                	addw	a5,a5,a4
    8000368a:	0017979b          	slliw	a5,a5,0x1
    8000368e:	54d8                	lw	a4,44(s1)
    80003690:	9fb9                	addw	a5,a5,a4
    80003692:	00f95963          	bge	s2,a5,800036a4 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003696:	85a6                	mv	a1,s1
    80003698:	8526                	mv	a0,s1
    8000369a:	ffffe097          	auipc	ra,0xffffe
    8000369e:	eea080e7          	jalr	-278(ra) # 80001584 <sleep>
    800036a2:	bfd1                	j	80003676 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800036a4:	00015517          	auipc	a0,0x15
    800036a8:	69c50513          	addi	a0,a0,1692 # 80018d40 <log>
    800036ac:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800036ae:	00003097          	auipc	ra,0x3
    800036b2:	cd2080e7          	jalr	-814(ra) # 80006380 <release>
      break;
    }
  }
}
    800036b6:	60e2                	ld	ra,24(sp)
    800036b8:	6442                	ld	s0,16(sp)
    800036ba:	64a2                	ld	s1,8(sp)
    800036bc:	6902                	ld	s2,0(sp)
    800036be:	6105                	addi	sp,sp,32
    800036c0:	8082                	ret

00000000800036c2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036c2:	7139                	addi	sp,sp,-64
    800036c4:	fc06                	sd	ra,56(sp)
    800036c6:	f822                	sd	s0,48(sp)
    800036c8:	f426                	sd	s1,40(sp)
    800036ca:	f04a                	sd	s2,32(sp)
    800036cc:	ec4e                	sd	s3,24(sp)
    800036ce:	e852                	sd	s4,16(sp)
    800036d0:	e456                	sd	s5,8(sp)
    800036d2:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036d4:	00015497          	auipc	s1,0x15
    800036d8:	66c48493          	addi	s1,s1,1644 # 80018d40 <log>
    800036dc:	8526                	mv	a0,s1
    800036de:	00003097          	auipc	ra,0x3
    800036e2:	bee080e7          	jalr	-1042(ra) # 800062cc <acquire>
  log.outstanding -= 1;
    800036e6:	509c                	lw	a5,32(s1)
    800036e8:	37fd                	addiw	a5,a5,-1
    800036ea:	0007891b          	sext.w	s2,a5
    800036ee:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036f0:	50dc                	lw	a5,36(s1)
    800036f2:	efb9                	bnez	a5,80003750 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800036f4:	06091663          	bnez	s2,80003760 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800036f8:	00015497          	auipc	s1,0x15
    800036fc:	64848493          	addi	s1,s1,1608 # 80018d40 <log>
    80003700:	4785                	li	a5,1
    80003702:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003704:	8526                	mv	a0,s1
    80003706:	00003097          	auipc	ra,0x3
    8000370a:	c7a080e7          	jalr	-902(ra) # 80006380 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000370e:	54dc                	lw	a5,44(s1)
    80003710:	06f04763          	bgtz	a5,8000377e <end_op+0xbc>
    acquire(&log.lock);
    80003714:	00015497          	auipc	s1,0x15
    80003718:	62c48493          	addi	s1,s1,1580 # 80018d40 <log>
    8000371c:	8526                	mv	a0,s1
    8000371e:	00003097          	auipc	ra,0x3
    80003722:	bae080e7          	jalr	-1106(ra) # 800062cc <acquire>
    log.committing = 0;
    80003726:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000372a:	8526                	mv	a0,s1
    8000372c:	ffffe097          	auipc	ra,0xffffe
    80003730:	ebc080e7          	jalr	-324(ra) # 800015e8 <wakeup>
    release(&log.lock);
    80003734:	8526                	mv	a0,s1
    80003736:	00003097          	auipc	ra,0x3
    8000373a:	c4a080e7          	jalr	-950(ra) # 80006380 <release>
}
    8000373e:	70e2                	ld	ra,56(sp)
    80003740:	7442                	ld	s0,48(sp)
    80003742:	74a2                	ld	s1,40(sp)
    80003744:	7902                	ld	s2,32(sp)
    80003746:	69e2                	ld	s3,24(sp)
    80003748:	6a42                	ld	s4,16(sp)
    8000374a:	6aa2                	ld	s5,8(sp)
    8000374c:	6121                	addi	sp,sp,64
    8000374e:	8082                	ret
    panic("log.committing");
    80003750:	00005517          	auipc	a0,0x5
    80003754:	03050513          	addi	a0,a0,48 # 80008780 <syscalls+0x1f0>
    80003758:	00002097          	auipc	ra,0x2
    8000375c:	62a080e7          	jalr	1578(ra) # 80005d82 <panic>
    wakeup(&log);
    80003760:	00015497          	auipc	s1,0x15
    80003764:	5e048493          	addi	s1,s1,1504 # 80018d40 <log>
    80003768:	8526                	mv	a0,s1
    8000376a:	ffffe097          	auipc	ra,0xffffe
    8000376e:	e7e080e7          	jalr	-386(ra) # 800015e8 <wakeup>
  release(&log.lock);
    80003772:	8526                	mv	a0,s1
    80003774:	00003097          	auipc	ra,0x3
    80003778:	c0c080e7          	jalr	-1012(ra) # 80006380 <release>
  if(do_commit){
    8000377c:	b7c9                	j	8000373e <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000377e:	00015a97          	auipc	s5,0x15
    80003782:	5f2a8a93          	addi	s5,s5,1522 # 80018d70 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003786:	00015a17          	auipc	s4,0x15
    8000378a:	5baa0a13          	addi	s4,s4,1466 # 80018d40 <log>
    8000378e:	018a2583          	lw	a1,24(s4)
    80003792:	012585bb          	addw	a1,a1,s2
    80003796:	2585                	addiw	a1,a1,1
    80003798:	028a2503          	lw	a0,40(s4)
    8000379c:	fffff097          	auipc	ra,0xfffff
    800037a0:	cca080e7          	jalr	-822(ra) # 80002466 <bread>
    800037a4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037a6:	000aa583          	lw	a1,0(s5)
    800037aa:	028a2503          	lw	a0,40(s4)
    800037ae:	fffff097          	auipc	ra,0xfffff
    800037b2:	cb8080e7          	jalr	-840(ra) # 80002466 <bread>
    800037b6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037b8:	40000613          	li	a2,1024
    800037bc:	05850593          	addi	a1,a0,88
    800037c0:	05848513          	addi	a0,s1,88
    800037c4:	ffffd097          	auipc	ra,0xffffd
    800037c8:	a38080e7          	jalr	-1480(ra) # 800001fc <memmove>
    bwrite(to);  // write the log
    800037cc:	8526                	mv	a0,s1
    800037ce:	fffff097          	auipc	ra,0xfffff
    800037d2:	d8a080e7          	jalr	-630(ra) # 80002558 <bwrite>
    brelse(from);
    800037d6:	854e                	mv	a0,s3
    800037d8:	fffff097          	auipc	ra,0xfffff
    800037dc:	dbe080e7          	jalr	-578(ra) # 80002596 <brelse>
    brelse(to);
    800037e0:	8526                	mv	a0,s1
    800037e2:	fffff097          	auipc	ra,0xfffff
    800037e6:	db4080e7          	jalr	-588(ra) # 80002596 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037ea:	2905                	addiw	s2,s2,1
    800037ec:	0a91                	addi	s5,s5,4
    800037ee:	02ca2783          	lw	a5,44(s4)
    800037f2:	f8f94ee3          	blt	s2,a5,8000378e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037f6:	00000097          	auipc	ra,0x0
    800037fa:	c6a080e7          	jalr	-918(ra) # 80003460 <write_head>
    install_trans(0); // Now install writes to home locations
    800037fe:	4501                	li	a0,0
    80003800:	00000097          	auipc	ra,0x0
    80003804:	cda080e7          	jalr	-806(ra) # 800034da <install_trans>
    log.lh.n = 0;
    80003808:	00015797          	auipc	a5,0x15
    8000380c:	5607a223          	sw	zero,1380(a5) # 80018d6c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003810:	00000097          	auipc	ra,0x0
    80003814:	c50080e7          	jalr	-944(ra) # 80003460 <write_head>
    80003818:	bdf5                	j	80003714 <end_op+0x52>

000000008000381a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000381a:	1101                	addi	sp,sp,-32
    8000381c:	ec06                	sd	ra,24(sp)
    8000381e:	e822                	sd	s0,16(sp)
    80003820:	e426                	sd	s1,8(sp)
    80003822:	e04a                	sd	s2,0(sp)
    80003824:	1000                	addi	s0,sp,32
    80003826:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003828:	00015917          	auipc	s2,0x15
    8000382c:	51890913          	addi	s2,s2,1304 # 80018d40 <log>
    80003830:	854a                	mv	a0,s2
    80003832:	00003097          	auipc	ra,0x3
    80003836:	a9a080e7          	jalr	-1382(ra) # 800062cc <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000383a:	02c92603          	lw	a2,44(s2)
    8000383e:	47f5                	li	a5,29
    80003840:	06c7c563          	blt	a5,a2,800038aa <log_write+0x90>
    80003844:	00015797          	auipc	a5,0x15
    80003848:	5187a783          	lw	a5,1304(a5) # 80018d5c <log+0x1c>
    8000384c:	37fd                	addiw	a5,a5,-1
    8000384e:	04f65e63          	bge	a2,a5,800038aa <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003852:	00015797          	auipc	a5,0x15
    80003856:	50e7a783          	lw	a5,1294(a5) # 80018d60 <log+0x20>
    8000385a:	06f05063          	blez	a5,800038ba <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000385e:	4781                	li	a5,0
    80003860:	06c05563          	blez	a2,800038ca <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003864:	44cc                	lw	a1,12(s1)
    80003866:	00015717          	auipc	a4,0x15
    8000386a:	50a70713          	addi	a4,a4,1290 # 80018d70 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000386e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003870:	4314                	lw	a3,0(a4)
    80003872:	04b68c63          	beq	a3,a1,800038ca <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003876:	2785                	addiw	a5,a5,1
    80003878:	0711                	addi	a4,a4,4
    8000387a:	fef61be3          	bne	a2,a5,80003870 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000387e:	0621                	addi	a2,a2,8
    80003880:	060a                	slli	a2,a2,0x2
    80003882:	00015797          	auipc	a5,0x15
    80003886:	4be78793          	addi	a5,a5,1214 # 80018d40 <log>
    8000388a:	963e                	add	a2,a2,a5
    8000388c:	44dc                	lw	a5,12(s1)
    8000388e:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003890:	8526                	mv	a0,s1
    80003892:	fffff097          	auipc	ra,0xfffff
    80003896:	da2080e7          	jalr	-606(ra) # 80002634 <bpin>
    log.lh.n++;
    8000389a:	00015717          	auipc	a4,0x15
    8000389e:	4a670713          	addi	a4,a4,1190 # 80018d40 <log>
    800038a2:	575c                	lw	a5,44(a4)
    800038a4:	2785                	addiw	a5,a5,1
    800038a6:	d75c                	sw	a5,44(a4)
    800038a8:	a835                	j	800038e4 <log_write+0xca>
    panic("too big a transaction");
    800038aa:	00005517          	auipc	a0,0x5
    800038ae:	ee650513          	addi	a0,a0,-282 # 80008790 <syscalls+0x200>
    800038b2:	00002097          	auipc	ra,0x2
    800038b6:	4d0080e7          	jalr	1232(ra) # 80005d82 <panic>
    panic("log_write outside of trans");
    800038ba:	00005517          	auipc	a0,0x5
    800038be:	eee50513          	addi	a0,a0,-274 # 800087a8 <syscalls+0x218>
    800038c2:	00002097          	auipc	ra,0x2
    800038c6:	4c0080e7          	jalr	1216(ra) # 80005d82 <panic>
  log.lh.block[i] = b->blockno;
    800038ca:	00878713          	addi	a4,a5,8
    800038ce:	00271693          	slli	a3,a4,0x2
    800038d2:	00015717          	auipc	a4,0x15
    800038d6:	46e70713          	addi	a4,a4,1134 # 80018d40 <log>
    800038da:	9736                	add	a4,a4,a3
    800038dc:	44d4                	lw	a3,12(s1)
    800038de:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038e0:	faf608e3          	beq	a2,a5,80003890 <log_write+0x76>
  }
  release(&log.lock);
    800038e4:	00015517          	auipc	a0,0x15
    800038e8:	45c50513          	addi	a0,a0,1116 # 80018d40 <log>
    800038ec:	00003097          	auipc	ra,0x3
    800038f0:	a94080e7          	jalr	-1388(ra) # 80006380 <release>
}
    800038f4:	60e2                	ld	ra,24(sp)
    800038f6:	6442                	ld	s0,16(sp)
    800038f8:	64a2                	ld	s1,8(sp)
    800038fa:	6902                	ld	s2,0(sp)
    800038fc:	6105                	addi	sp,sp,32
    800038fe:	8082                	ret

0000000080003900 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003900:	1101                	addi	sp,sp,-32
    80003902:	ec06                	sd	ra,24(sp)
    80003904:	e822                	sd	s0,16(sp)
    80003906:	e426                	sd	s1,8(sp)
    80003908:	e04a                	sd	s2,0(sp)
    8000390a:	1000                	addi	s0,sp,32
    8000390c:	84aa                	mv	s1,a0
    8000390e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003910:	00005597          	auipc	a1,0x5
    80003914:	eb858593          	addi	a1,a1,-328 # 800087c8 <syscalls+0x238>
    80003918:	0521                	addi	a0,a0,8
    8000391a:	00003097          	auipc	ra,0x3
    8000391e:	922080e7          	jalr	-1758(ra) # 8000623c <initlock>
  lk->name = name;
    80003922:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003926:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000392a:	0204a423          	sw	zero,40(s1)
}
    8000392e:	60e2                	ld	ra,24(sp)
    80003930:	6442                	ld	s0,16(sp)
    80003932:	64a2                	ld	s1,8(sp)
    80003934:	6902                	ld	s2,0(sp)
    80003936:	6105                	addi	sp,sp,32
    80003938:	8082                	ret

000000008000393a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000393a:	1101                	addi	sp,sp,-32
    8000393c:	ec06                	sd	ra,24(sp)
    8000393e:	e822                	sd	s0,16(sp)
    80003940:	e426                	sd	s1,8(sp)
    80003942:	e04a                	sd	s2,0(sp)
    80003944:	1000                	addi	s0,sp,32
    80003946:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003948:	00850913          	addi	s2,a0,8
    8000394c:	854a                	mv	a0,s2
    8000394e:	00003097          	auipc	ra,0x3
    80003952:	97e080e7          	jalr	-1666(ra) # 800062cc <acquire>
  while (lk->locked) {
    80003956:	409c                	lw	a5,0(s1)
    80003958:	cb89                	beqz	a5,8000396a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000395a:	85ca                	mv	a1,s2
    8000395c:	8526                	mv	a0,s1
    8000395e:	ffffe097          	auipc	ra,0xffffe
    80003962:	c26080e7          	jalr	-986(ra) # 80001584 <sleep>
  while (lk->locked) {
    80003966:	409c                	lw	a5,0(s1)
    80003968:	fbed                	bnez	a5,8000395a <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000396a:	4785                	li	a5,1
    8000396c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000396e:	ffffd097          	auipc	ra,0xffffd
    80003972:	566080e7          	jalr	1382(ra) # 80000ed4 <myproc>
    80003976:	591c                	lw	a5,48(a0)
    80003978:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000397a:	854a                	mv	a0,s2
    8000397c:	00003097          	auipc	ra,0x3
    80003980:	a04080e7          	jalr	-1532(ra) # 80006380 <release>
}
    80003984:	60e2                	ld	ra,24(sp)
    80003986:	6442                	ld	s0,16(sp)
    80003988:	64a2                	ld	s1,8(sp)
    8000398a:	6902                	ld	s2,0(sp)
    8000398c:	6105                	addi	sp,sp,32
    8000398e:	8082                	ret

0000000080003990 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003990:	1101                	addi	sp,sp,-32
    80003992:	ec06                	sd	ra,24(sp)
    80003994:	e822                	sd	s0,16(sp)
    80003996:	e426                	sd	s1,8(sp)
    80003998:	e04a                	sd	s2,0(sp)
    8000399a:	1000                	addi	s0,sp,32
    8000399c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000399e:	00850913          	addi	s2,a0,8
    800039a2:	854a                	mv	a0,s2
    800039a4:	00003097          	auipc	ra,0x3
    800039a8:	928080e7          	jalr	-1752(ra) # 800062cc <acquire>
  lk->locked = 0;
    800039ac:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039b0:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039b4:	8526                	mv	a0,s1
    800039b6:	ffffe097          	auipc	ra,0xffffe
    800039ba:	c32080e7          	jalr	-974(ra) # 800015e8 <wakeup>
  release(&lk->lk);
    800039be:	854a                	mv	a0,s2
    800039c0:	00003097          	auipc	ra,0x3
    800039c4:	9c0080e7          	jalr	-1600(ra) # 80006380 <release>
}
    800039c8:	60e2                	ld	ra,24(sp)
    800039ca:	6442                	ld	s0,16(sp)
    800039cc:	64a2                	ld	s1,8(sp)
    800039ce:	6902                	ld	s2,0(sp)
    800039d0:	6105                	addi	sp,sp,32
    800039d2:	8082                	ret

00000000800039d4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039d4:	7179                	addi	sp,sp,-48
    800039d6:	f406                	sd	ra,40(sp)
    800039d8:	f022                	sd	s0,32(sp)
    800039da:	ec26                	sd	s1,24(sp)
    800039dc:	e84a                	sd	s2,16(sp)
    800039de:	e44e                	sd	s3,8(sp)
    800039e0:	1800                	addi	s0,sp,48
    800039e2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039e4:	00850913          	addi	s2,a0,8
    800039e8:	854a                	mv	a0,s2
    800039ea:	00003097          	auipc	ra,0x3
    800039ee:	8e2080e7          	jalr	-1822(ra) # 800062cc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039f2:	409c                	lw	a5,0(s1)
    800039f4:	ef99                	bnez	a5,80003a12 <holdingsleep+0x3e>
    800039f6:	4481                	li	s1,0
  release(&lk->lk);
    800039f8:	854a                	mv	a0,s2
    800039fa:	00003097          	auipc	ra,0x3
    800039fe:	986080e7          	jalr	-1658(ra) # 80006380 <release>
  return r;
}
    80003a02:	8526                	mv	a0,s1
    80003a04:	70a2                	ld	ra,40(sp)
    80003a06:	7402                	ld	s0,32(sp)
    80003a08:	64e2                	ld	s1,24(sp)
    80003a0a:	6942                	ld	s2,16(sp)
    80003a0c:	69a2                	ld	s3,8(sp)
    80003a0e:	6145                	addi	sp,sp,48
    80003a10:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a12:	0284a983          	lw	s3,40(s1)
    80003a16:	ffffd097          	auipc	ra,0xffffd
    80003a1a:	4be080e7          	jalr	1214(ra) # 80000ed4 <myproc>
    80003a1e:	5904                	lw	s1,48(a0)
    80003a20:	413484b3          	sub	s1,s1,s3
    80003a24:	0014b493          	seqz	s1,s1
    80003a28:	bfc1                	j	800039f8 <holdingsleep+0x24>

0000000080003a2a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a2a:	1141                	addi	sp,sp,-16
    80003a2c:	e406                	sd	ra,8(sp)
    80003a2e:	e022                	sd	s0,0(sp)
    80003a30:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a32:	00005597          	auipc	a1,0x5
    80003a36:	da658593          	addi	a1,a1,-602 # 800087d8 <syscalls+0x248>
    80003a3a:	00015517          	auipc	a0,0x15
    80003a3e:	44e50513          	addi	a0,a0,1102 # 80018e88 <ftable>
    80003a42:	00002097          	auipc	ra,0x2
    80003a46:	7fa080e7          	jalr	2042(ra) # 8000623c <initlock>
}
    80003a4a:	60a2                	ld	ra,8(sp)
    80003a4c:	6402                	ld	s0,0(sp)
    80003a4e:	0141                	addi	sp,sp,16
    80003a50:	8082                	ret

0000000080003a52 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a52:	1101                	addi	sp,sp,-32
    80003a54:	ec06                	sd	ra,24(sp)
    80003a56:	e822                	sd	s0,16(sp)
    80003a58:	e426                	sd	s1,8(sp)
    80003a5a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a5c:	00015517          	auipc	a0,0x15
    80003a60:	42c50513          	addi	a0,a0,1068 # 80018e88 <ftable>
    80003a64:	00003097          	auipc	ra,0x3
    80003a68:	868080e7          	jalr	-1944(ra) # 800062cc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a6c:	00015497          	auipc	s1,0x15
    80003a70:	43448493          	addi	s1,s1,1076 # 80018ea0 <ftable+0x18>
    80003a74:	00016717          	auipc	a4,0x16
    80003a78:	3cc70713          	addi	a4,a4,972 # 80019e40 <disk>
    if(f->ref == 0){
    80003a7c:	40dc                	lw	a5,4(s1)
    80003a7e:	cf99                	beqz	a5,80003a9c <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a80:	02848493          	addi	s1,s1,40
    80003a84:	fee49ce3          	bne	s1,a4,80003a7c <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a88:	00015517          	auipc	a0,0x15
    80003a8c:	40050513          	addi	a0,a0,1024 # 80018e88 <ftable>
    80003a90:	00003097          	auipc	ra,0x3
    80003a94:	8f0080e7          	jalr	-1808(ra) # 80006380 <release>
  return 0;
    80003a98:	4481                	li	s1,0
    80003a9a:	a819                	j	80003ab0 <filealloc+0x5e>
      f->ref = 1;
    80003a9c:	4785                	li	a5,1
    80003a9e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003aa0:	00015517          	auipc	a0,0x15
    80003aa4:	3e850513          	addi	a0,a0,1000 # 80018e88 <ftable>
    80003aa8:	00003097          	auipc	ra,0x3
    80003aac:	8d8080e7          	jalr	-1832(ra) # 80006380 <release>
}
    80003ab0:	8526                	mv	a0,s1
    80003ab2:	60e2                	ld	ra,24(sp)
    80003ab4:	6442                	ld	s0,16(sp)
    80003ab6:	64a2                	ld	s1,8(sp)
    80003ab8:	6105                	addi	sp,sp,32
    80003aba:	8082                	ret

0000000080003abc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003abc:	1101                	addi	sp,sp,-32
    80003abe:	ec06                	sd	ra,24(sp)
    80003ac0:	e822                	sd	s0,16(sp)
    80003ac2:	e426                	sd	s1,8(sp)
    80003ac4:	1000                	addi	s0,sp,32
    80003ac6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003ac8:	00015517          	auipc	a0,0x15
    80003acc:	3c050513          	addi	a0,a0,960 # 80018e88 <ftable>
    80003ad0:	00002097          	auipc	ra,0x2
    80003ad4:	7fc080e7          	jalr	2044(ra) # 800062cc <acquire>
  if(f->ref < 1)
    80003ad8:	40dc                	lw	a5,4(s1)
    80003ada:	02f05263          	blez	a5,80003afe <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003ade:	2785                	addiw	a5,a5,1
    80003ae0:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003ae2:	00015517          	auipc	a0,0x15
    80003ae6:	3a650513          	addi	a0,a0,934 # 80018e88 <ftable>
    80003aea:	00003097          	auipc	ra,0x3
    80003aee:	896080e7          	jalr	-1898(ra) # 80006380 <release>
  return f;
}
    80003af2:	8526                	mv	a0,s1
    80003af4:	60e2                	ld	ra,24(sp)
    80003af6:	6442                	ld	s0,16(sp)
    80003af8:	64a2                	ld	s1,8(sp)
    80003afa:	6105                	addi	sp,sp,32
    80003afc:	8082                	ret
    panic("filedup");
    80003afe:	00005517          	auipc	a0,0x5
    80003b02:	ce250513          	addi	a0,a0,-798 # 800087e0 <syscalls+0x250>
    80003b06:	00002097          	auipc	ra,0x2
    80003b0a:	27c080e7          	jalr	636(ra) # 80005d82 <panic>

0000000080003b0e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b0e:	7139                	addi	sp,sp,-64
    80003b10:	fc06                	sd	ra,56(sp)
    80003b12:	f822                	sd	s0,48(sp)
    80003b14:	f426                	sd	s1,40(sp)
    80003b16:	f04a                	sd	s2,32(sp)
    80003b18:	ec4e                	sd	s3,24(sp)
    80003b1a:	e852                	sd	s4,16(sp)
    80003b1c:	e456                	sd	s5,8(sp)
    80003b1e:	0080                	addi	s0,sp,64
    80003b20:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b22:	00015517          	auipc	a0,0x15
    80003b26:	36650513          	addi	a0,a0,870 # 80018e88 <ftable>
    80003b2a:	00002097          	auipc	ra,0x2
    80003b2e:	7a2080e7          	jalr	1954(ra) # 800062cc <acquire>
  if(f->ref < 1)
    80003b32:	40dc                	lw	a5,4(s1)
    80003b34:	06f05163          	blez	a5,80003b96 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b38:	37fd                	addiw	a5,a5,-1
    80003b3a:	0007871b          	sext.w	a4,a5
    80003b3e:	c0dc                	sw	a5,4(s1)
    80003b40:	06e04363          	bgtz	a4,80003ba6 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b44:	0004a903          	lw	s2,0(s1)
    80003b48:	0094ca83          	lbu	s5,9(s1)
    80003b4c:	0104ba03          	ld	s4,16(s1)
    80003b50:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b54:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b58:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b5c:	00015517          	auipc	a0,0x15
    80003b60:	32c50513          	addi	a0,a0,812 # 80018e88 <ftable>
    80003b64:	00003097          	auipc	ra,0x3
    80003b68:	81c080e7          	jalr	-2020(ra) # 80006380 <release>

  if(ff.type == FD_PIPE){
    80003b6c:	4785                	li	a5,1
    80003b6e:	04f90d63          	beq	s2,a5,80003bc8 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b72:	3979                	addiw	s2,s2,-2
    80003b74:	4785                	li	a5,1
    80003b76:	0527e063          	bltu	a5,s2,80003bb6 <fileclose+0xa8>
    begin_op();
    80003b7a:	00000097          	auipc	ra,0x0
    80003b7e:	ac8080e7          	jalr	-1336(ra) # 80003642 <begin_op>
    iput(ff.ip);
    80003b82:	854e                	mv	a0,s3
    80003b84:	fffff097          	auipc	ra,0xfffff
    80003b88:	2b6080e7          	jalr	694(ra) # 80002e3a <iput>
    end_op();
    80003b8c:	00000097          	auipc	ra,0x0
    80003b90:	b36080e7          	jalr	-1226(ra) # 800036c2 <end_op>
    80003b94:	a00d                	j	80003bb6 <fileclose+0xa8>
    panic("fileclose");
    80003b96:	00005517          	auipc	a0,0x5
    80003b9a:	c5250513          	addi	a0,a0,-942 # 800087e8 <syscalls+0x258>
    80003b9e:	00002097          	auipc	ra,0x2
    80003ba2:	1e4080e7          	jalr	484(ra) # 80005d82 <panic>
    release(&ftable.lock);
    80003ba6:	00015517          	auipc	a0,0x15
    80003baa:	2e250513          	addi	a0,a0,738 # 80018e88 <ftable>
    80003bae:	00002097          	auipc	ra,0x2
    80003bb2:	7d2080e7          	jalr	2002(ra) # 80006380 <release>
  }
}
    80003bb6:	70e2                	ld	ra,56(sp)
    80003bb8:	7442                	ld	s0,48(sp)
    80003bba:	74a2                	ld	s1,40(sp)
    80003bbc:	7902                	ld	s2,32(sp)
    80003bbe:	69e2                	ld	s3,24(sp)
    80003bc0:	6a42                	ld	s4,16(sp)
    80003bc2:	6aa2                	ld	s5,8(sp)
    80003bc4:	6121                	addi	sp,sp,64
    80003bc6:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003bc8:	85d6                	mv	a1,s5
    80003bca:	8552                	mv	a0,s4
    80003bcc:	00000097          	auipc	ra,0x0
    80003bd0:	34c080e7          	jalr	844(ra) # 80003f18 <pipeclose>
    80003bd4:	b7cd                	j	80003bb6 <fileclose+0xa8>

0000000080003bd6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003bd6:	715d                	addi	sp,sp,-80
    80003bd8:	e486                	sd	ra,72(sp)
    80003bda:	e0a2                	sd	s0,64(sp)
    80003bdc:	fc26                	sd	s1,56(sp)
    80003bde:	f84a                	sd	s2,48(sp)
    80003be0:	f44e                	sd	s3,40(sp)
    80003be2:	0880                	addi	s0,sp,80
    80003be4:	84aa                	mv	s1,a0
    80003be6:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003be8:	ffffd097          	auipc	ra,0xffffd
    80003bec:	2ec080e7          	jalr	748(ra) # 80000ed4 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003bf0:	409c                	lw	a5,0(s1)
    80003bf2:	37f9                	addiw	a5,a5,-2
    80003bf4:	4705                	li	a4,1
    80003bf6:	04f76763          	bltu	a4,a5,80003c44 <filestat+0x6e>
    80003bfa:	892a                	mv	s2,a0
    ilock(f->ip);
    80003bfc:	6c88                	ld	a0,24(s1)
    80003bfe:	fffff097          	auipc	ra,0xfffff
    80003c02:	082080e7          	jalr	130(ra) # 80002c80 <ilock>
    stati(f->ip, &st);
    80003c06:	fb840593          	addi	a1,s0,-72
    80003c0a:	6c88                	ld	a0,24(s1)
    80003c0c:	fffff097          	auipc	ra,0xfffff
    80003c10:	2fe080e7          	jalr	766(ra) # 80002f0a <stati>
    iunlock(f->ip);
    80003c14:	6c88                	ld	a0,24(s1)
    80003c16:	fffff097          	auipc	ra,0xfffff
    80003c1a:	12c080e7          	jalr	300(ra) # 80002d42 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c1e:	46e1                	li	a3,24
    80003c20:	fb840613          	addi	a2,s0,-72
    80003c24:	85ce                	mv	a1,s3
    80003c26:	05093503          	ld	a0,80(s2)
    80003c2a:	ffffd097          	auipc	ra,0xffffd
    80003c2e:	f34080e7          	jalr	-204(ra) # 80000b5e <copyout>
    80003c32:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c36:	60a6                	ld	ra,72(sp)
    80003c38:	6406                	ld	s0,64(sp)
    80003c3a:	74e2                	ld	s1,56(sp)
    80003c3c:	7942                	ld	s2,48(sp)
    80003c3e:	79a2                	ld	s3,40(sp)
    80003c40:	6161                	addi	sp,sp,80
    80003c42:	8082                	ret
  return -1;
    80003c44:	557d                	li	a0,-1
    80003c46:	bfc5                	j	80003c36 <filestat+0x60>

0000000080003c48 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c48:	7179                	addi	sp,sp,-48
    80003c4a:	f406                	sd	ra,40(sp)
    80003c4c:	f022                	sd	s0,32(sp)
    80003c4e:	ec26                	sd	s1,24(sp)
    80003c50:	e84a                	sd	s2,16(sp)
    80003c52:	e44e                	sd	s3,8(sp)
    80003c54:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c56:	00854783          	lbu	a5,8(a0)
    80003c5a:	c3d5                	beqz	a5,80003cfe <fileread+0xb6>
    80003c5c:	84aa                	mv	s1,a0
    80003c5e:	89ae                	mv	s3,a1
    80003c60:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c62:	411c                	lw	a5,0(a0)
    80003c64:	4705                	li	a4,1
    80003c66:	04e78963          	beq	a5,a4,80003cb8 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c6a:	470d                	li	a4,3
    80003c6c:	04e78d63          	beq	a5,a4,80003cc6 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c70:	4709                	li	a4,2
    80003c72:	06e79e63          	bne	a5,a4,80003cee <fileread+0xa6>
    ilock(f->ip);
    80003c76:	6d08                	ld	a0,24(a0)
    80003c78:	fffff097          	auipc	ra,0xfffff
    80003c7c:	008080e7          	jalr	8(ra) # 80002c80 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c80:	874a                	mv	a4,s2
    80003c82:	5094                	lw	a3,32(s1)
    80003c84:	864e                	mv	a2,s3
    80003c86:	4585                	li	a1,1
    80003c88:	6c88                	ld	a0,24(s1)
    80003c8a:	fffff097          	auipc	ra,0xfffff
    80003c8e:	2aa080e7          	jalr	682(ra) # 80002f34 <readi>
    80003c92:	892a                	mv	s2,a0
    80003c94:	00a05563          	blez	a0,80003c9e <fileread+0x56>
      f->off += r;
    80003c98:	509c                	lw	a5,32(s1)
    80003c9a:	9fa9                	addw	a5,a5,a0
    80003c9c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c9e:	6c88                	ld	a0,24(s1)
    80003ca0:	fffff097          	auipc	ra,0xfffff
    80003ca4:	0a2080e7          	jalr	162(ra) # 80002d42 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003ca8:	854a                	mv	a0,s2
    80003caa:	70a2                	ld	ra,40(sp)
    80003cac:	7402                	ld	s0,32(sp)
    80003cae:	64e2                	ld	s1,24(sp)
    80003cb0:	6942                	ld	s2,16(sp)
    80003cb2:	69a2                	ld	s3,8(sp)
    80003cb4:	6145                	addi	sp,sp,48
    80003cb6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003cb8:	6908                	ld	a0,16(a0)
    80003cba:	00000097          	auipc	ra,0x0
    80003cbe:	3ce080e7          	jalr	974(ra) # 80004088 <piperead>
    80003cc2:	892a                	mv	s2,a0
    80003cc4:	b7d5                	j	80003ca8 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cc6:	02451783          	lh	a5,36(a0)
    80003cca:	03079693          	slli	a3,a5,0x30
    80003cce:	92c1                	srli	a3,a3,0x30
    80003cd0:	4725                	li	a4,9
    80003cd2:	02d76863          	bltu	a4,a3,80003d02 <fileread+0xba>
    80003cd6:	0792                	slli	a5,a5,0x4
    80003cd8:	00015717          	auipc	a4,0x15
    80003cdc:	11070713          	addi	a4,a4,272 # 80018de8 <devsw>
    80003ce0:	97ba                	add	a5,a5,a4
    80003ce2:	639c                	ld	a5,0(a5)
    80003ce4:	c38d                	beqz	a5,80003d06 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003ce6:	4505                	li	a0,1
    80003ce8:	9782                	jalr	a5
    80003cea:	892a                	mv	s2,a0
    80003cec:	bf75                	j	80003ca8 <fileread+0x60>
    panic("fileread");
    80003cee:	00005517          	auipc	a0,0x5
    80003cf2:	b0a50513          	addi	a0,a0,-1270 # 800087f8 <syscalls+0x268>
    80003cf6:	00002097          	auipc	ra,0x2
    80003cfa:	08c080e7          	jalr	140(ra) # 80005d82 <panic>
    return -1;
    80003cfe:	597d                	li	s2,-1
    80003d00:	b765                	j	80003ca8 <fileread+0x60>
      return -1;
    80003d02:	597d                	li	s2,-1
    80003d04:	b755                	j	80003ca8 <fileread+0x60>
    80003d06:	597d                	li	s2,-1
    80003d08:	b745                	j	80003ca8 <fileread+0x60>

0000000080003d0a <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d0a:	715d                	addi	sp,sp,-80
    80003d0c:	e486                	sd	ra,72(sp)
    80003d0e:	e0a2                	sd	s0,64(sp)
    80003d10:	fc26                	sd	s1,56(sp)
    80003d12:	f84a                	sd	s2,48(sp)
    80003d14:	f44e                	sd	s3,40(sp)
    80003d16:	f052                	sd	s4,32(sp)
    80003d18:	ec56                	sd	s5,24(sp)
    80003d1a:	e85a                	sd	s6,16(sp)
    80003d1c:	e45e                	sd	s7,8(sp)
    80003d1e:	e062                	sd	s8,0(sp)
    80003d20:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d22:	00954783          	lbu	a5,9(a0)
    80003d26:	10078663          	beqz	a5,80003e32 <filewrite+0x128>
    80003d2a:	892a                	mv	s2,a0
    80003d2c:	8aae                	mv	s5,a1
    80003d2e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d30:	411c                	lw	a5,0(a0)
    80003d32:	4705                	li	a4,1
    80003d34:	02e78263          	beq	a5,a4,80003d58 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d38:	470d                	li	a4,3
    80003d3a:	02e78663          	beq	a5,a4,80003d66 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d3e:	4709                	li	a4,2
    80003d40:	0ee79163          	bne	a5,a4,80003e22 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d44:	0ac05d63          	blez	a2,80003dfe <filewrite+0xf4>
    int i = 0;
    80003d48:	4981                	li	s3,0
    80003d4a:	6b05                	lui	s6,0x1
    80003d4c:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d50:	6b85                	lui	s7,0x1
    80003d52:	c00b8b9b          	addiw	s7,s7,-1024
    80003d56:	a861                	j	80003dee <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d58:	6908                	ld	a0,16(a0)
    80003d5a:	00000097          	auipc	ra,0x0
    80003d5e:	22e080e7          	jalr	558(ra) # 80003f88 <pipewrite>
    80003d62:	8a2a                	mv	s4,a0
    80003d64:	a045                	j	80003e04 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d66:	02451783          	lh	a5,36(a0)
    80003d6a:	03079693          	slli	a3,a5,0x30
    80003d6e:	92c1                	srli	a3,a3,0x30
    80003d70:	4725                	li	a4,9
    80003d72:	0cd76263          	bltu	a4,a3,80003e36 <filewrite+0x12c>
    80003d76:	0792                	slli	a5,a5,0x4
    80003d78:	00015717          	auipc	a4,0x15
    80003d7c:	07070713          	addi	a4,a4,112 # 80018de8 <devsw>
    80003d80:	97ba                	add	a5,a5,a4
    80003d82:	679c                	ld	a5,8(a5)
    80003d84:	cbdd                	beqz	a5,80003e3a <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d86:	4505                	li	a0,1
    80003d88:	9782                	jalr	a5
    80003d8a:	8a2a                	mv	s4,a0
    80003d8c:	a8a5                	j	80003e04 <filewrite+0xfa>
    80003d8e:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d92:	00000097          	auipc	ra,0x0
    80003d96:	8b0080e7          	jalr	-1872(ra) # 80003642 <begin_op>
      ilock(f->ip);
    80003d9a:	01893503          	ld	a0,24(s2)
    80003d9e:	fffff097          	auipc	ra,0xfffff
    80003da2:	ee2080e7          	jalr	-286(ra) # 80002c80 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003da6:	8762                	mv	a4,s8
    80003da8:	02092683          	lw	a3,32(s2)
    80003dac:	01598633          	add	a2,s3,s5
    80003db0:	4585                	li	a1,1
    80003db2:	01893503          	ld	a0,24(s2)
    80003db6:	fffff097          	auipc	ra,0xfffff
    80003dba:	276080e7          	jalr	630(ra) # 8000302c <writei>
    80003dbe:	84aa                	mv	s1,a0
    80003dc0:	00a05763          	blez	a0,80003dce <filewrite+0xc4>
        f->off += r;
    80003dc4:	02092783          	lw	a5,32(s2)
    80003dc8:	9fa9                	addw	a5,a5,a0
    80003dca:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003dce:	01893503          	ld	a0,24(s2)
    80003dd2:	fffff097          	auipc	ra,0xfffff
    80003dd6:	f70080e7          	jalr	-144(ra) # 80002d42 <iunlock>
      end_op();
    80003dda:	00000097          	auipc	ra,0x0
    80003dde:	8e8080e7          	jalr	-1816(ra) # 800036c2 <end_op>

      if(r != n1){
    80003de2:	009c1f63          	bne	s8,s1,80003e00 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003de6:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003dea:	0149db63          	bge	s3,s4,80003e00 <filewrite+0xf6>
      int n1 = n - i;
    80003dee:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003df2:	84be                	mv	s1,a5
    80003df4:	2781                	sext.w	a5,a5
    80003df6:	f8fb5ce3          	bge	s6,a5,80003d8e <filewrite+0x84>
    80003dfa:	84de                	mv	s1,s7
    80003dfc:	bf49                	j	80003d8e <filewrite+0x84>
    int i = 0;
    80003dfe:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e00:	013a1f63          	bne	s4,s3,80003e1e <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e04:	8552                	mv	a0,s4
    80003e06:	60a6                	ld	ra,72(sp)
    80003e08:	6406                	ld	s0,64(sp)
    80003e0a:	74e2                	ld	s1,56(sp)
    80003e0c:	7942                	ld	s2,48(sp)
    80003e0e:	79a2                	ld	s3,40(sp)
    80003e10:	7a02                	ld	s4,32(sp)
    80003e12:	6ae2                	ld	s5,24(sp)
    80003e14:	6b42                	ld	s6,16(sp)
    80003e16:	6ba2                	ld	s7,8(sp)
    80003e18:	6c02                	ld	s8,0(sp)
    80003e1a:	6161                	addi	sp,sp,80
    80003e1c:	8082                	ret
    ret = (i == n ? n : -1);
    80003e1e:	5a7d                	li	s4,-1
    80003e20:	b7d5                	j	80003e04 <filewrite+0xfa>
    panic("filewrite");
    80003e22:	00005517          	auipc	a0,0x5
    80003e26:	9e650513          	addi	a0,a0,-1562 # 80008808 <syscalls+0x278>
    80003e2a:	00002097          	auipc	ra,0x2
    80003e2e:	f58080e7          	jalr	-168(ra) # 80005d82 <panic>
    return -1;
    80003e32:	5a7d                	li	s4,-1
    80003e34:	bfc1                	j	80003e04 <filewrite+0xfa>
      return -1;
    80003e36:	5a7d                	li	s4,-1
    80003e38:	b7f1                	j	80003e04 <filewrite+0xfa>
    80003e3a:	5a7d                	li	s4,-1
    80003e3c:	b7e1                	j	80003e04 <filewrite+0xfa>

0000000080003e3e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e3e:	7179                	addi	sp,sp,-48
    80003e40:	f406                	sd	ra,40(sp)
    80003e42:	f022                	sd	s0,32(sp)
    80003e44:	ec26                	sd	s1,24(sp)
    80003e46:	e84a                	sd	s2,16(sp)
    80003e48:	e44e                	sd	s3,8(sp)
    80003e4a:	e052                	sd	s4,0(sp)
    80003e4c:	1800                	addi	s0,sp,48
    80003e4e:	84aa                	mv	s1,a0
    80003e50:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e52:	0005b023          	sd	zero,0(a1)
    80003e56:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e5a:	00000097          	auipc	ra,0x0
    80003e5e:	bf8080e7          	jalr	-1032(ra) # 80003a52 <filealloc>
    80003e62:	e088                	sd	a0,0(s1)
    80003e64:	c551                	beqz	a0,80003ef0 <pipealloc+0xb2>
    80003e66:	00000097          	auipc	ra,0x0
    80003e6a:	bec080e7          	jalr	-1044(ra) # 80003a52 <filealloc>
    80003e6e:	00aa3023          	sd	a0,0(s4)
    80003e72:	c92d                	beqz	a0,80003ee4 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e74:	ffffc097          	auipc	ra,0xffffc
    80003e78:	2a4080e7          	jalr	676(ra) # 80000118 <kalloc>
    80003e7c:	892a                	mv	s2,a0
    80003e7e:	c125                	beqz	a0,80003ede <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e80:	4985                	li	s3,1
    80003e82:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e86:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e8a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e8e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e92:	00004597          	auipc	a1,0x4
    80003e96:	5ae58593          	addi	a1,a1,1454 # 80008440 <states.1727+0x1b8>
    80003e9a:	00002097          	auipc	ra,0x2
    80003e9e:	3a2080e7          	jalr	930(ra) # 8000623c <initlock>
  (*f0)->type = FD_PIPE;
    80003ea2:	609c                	ld	a5,0(s1)
    80003ea4:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003ea8:	609c                	ld	a5,0(s1)
    80003eaa:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003eae:	609c                	ld	a5,0(s1)
    80003eb0:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003eb4:	609c                	ld	a5,0(s1)
    80003eb6:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003eba:	000a3783          	ld	a5,0(s4)
    80003ebe:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ec2:	000a3783          	ld	a5,0(s4)
    80003ec6:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003eca:	000a3783          	ld	a5,0(s4)
    80003ece:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ed2:	000a3783          	ld	a5,0(s4)
    80003ed6:	0127b823          	sd	s2,16(a5)
  return 0;
    80003eda:	4501                	li	a0,0
    80003edc:	a025                	j	80003f04 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ede:	6088                	ld	a0,0(s1)
    80003ee0:	e501                	bnez	a0,80003ee8 <pipealloc+0xaa>
    80003ee2:	a039                	j	80003ef0 <pipealloc+0xb2>
    80003ee4:	6088                	ld	a0,0(s1)
    80003ee6:	c51d                	beqz	a0,80003f14 <pipealloc+0xd6>
    fileclose(*f0);
    80003ee8:	00000097          	auipc	ra,0x0
    80003eec:	c26080e7          	jalr	-986(ra) # 80003b0e <fileclose>
  if(*f1)
    80003ef0:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ef4:	557d                	li	a0,-1
  if(*f1)
    80003ef6:	c799                	beqz	a5,80003f04 <pipealloc+0xc6>
    fileclose(*f1);
    80003ef8:	853e                	mv	a0,a5
    80003efa:	00000097          	auipc	ra,0x0
    80003efe:	c14080e7          	jalr	-1004(ra) # 80003b0e <fileclose>
  return -1;
    80003f02:	557d                	li	a0,-1
}
    80003f04:	70a2                	ld	ra,40(sp)
    80003f06:	7402                	ld	s0,32(sp)
    80003f08:	64e2                	ld	s1,24(sp)
    80003f0a:	6942                	ld	s2,16(sp)
    80003f0c:	69a2                	ld	s3,8(sp)
    80003f0e:	6a02                	ld	s4,0(sp)
    80003f10:	6145                	addi	sp,sp,48
    80003f12:	8082                	ret
  return -1;
    80003f14:	557d                	li	a0,-1
    80003f16:	b7fd                	j	80003f04 <pipealloc+0xc6>

0000000080003f18 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f18:	1101                	addi	sp,sp,-32
    80003f1a:	ec06                	sd	ra,24(sp)
    80003f1c:	e822                	sd	s0,16(sp)
    80003f1e:	e426                	sd	s1,8(sp)
    80003f20:	e04a                	sd	s2,0(sp)
    80003f22:	1000                	addi	s0,sp,32
    80003f24:	84aa                	mv	s1,a0
    80003f26:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f28:	00002097          	auipc	ra,0x2
    80003f2c:	3a4080e7          	jalr	932(ra) # 800062cc <acquire>
  if(writable){
    80003f30:	02090d63          	beqz	s2,80003f6a <pipeclose+0x52>
    pi->writeopen = 0;
    80003f34:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f38:	21848513          	addi	a0,s1,536
    80003f3c:	ffffd097          	auipc	ra,0xffffd
    80003f40:	6ac080e7          	jalr	1708(ra) # 800015e8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f44:	2204b783          	ld	a5,544(s1)
    80003f48:	eb95                	bnez	a5,80003f7c <pipeclose+0x64>
    release(&pi->lock);
    80003f4a:	8526                	mv	a0,s1
    80003f4c:	00002097          	auipc	ra,0x2
    80003f50:	434080e7          	jalr	1076(ra) # 80006380 <release>
    kfree((char*)pi);
    80003f54:	8526                	mv	a0,s1
    80003f56:	ffffc097          	auipc	ra,0xffffc
    80003f5a:	0c6080e7          	jalr	198(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f5e:	60e2                	ld	ra,24(sp)
    80003f60:	6442                	ld	s0,16(sp)
    80003f62:	64a2                	ld	s1,8(sp)
    80003f64:	6902                	ld	s2,0(sp)
    80003f66:	6105                	addi	sp,sp,32
    80003f68:	8082                	ret
    pi->readopen = 0;
    80003f6a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f6e:	21c48513          	addi	a0,s1,540
    80003f72:	ffffd097          	auipc	ra,0xffffd
    80003f76:	676080e7          	jalr	1654(ra) # 800015e8 <wakeup>
    80003f7a:	b7e9                	j	80003f44 <pipeclose+0x2c>
    release(&pi->lock);
    80003f7c:	8526                	mv	a0,s1
    80003f7e:	00002097          	auipc	ra,0x2
    80003f82:	402080e7          	jalr	1026(ra) # 80006380 <release>
}
    80003f86:	bfe1                	j	80003f5e <pipeclose+0x46>

0000000080003f88 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f88:	7159                	addi	sp,sp,-112
    80003f8a:	f486                	sd	ra,104(sp)
    80003f8c:	f0a2                	sd	s0,96(sp)
    80003f8e:	eca6                	sd	s1,88(sp)
    80003f90:	e8ca                	sd	s2,80(sp)
    80003f92:	e4ce                	sd	s3,72(sp)
    80003f94:	e0d2                	sd	s4,64(sp)
    80003f96:	fc56                	sd	s5,56(sp)
    80003f98:	f85a                	sd	s6,48(sp)
    80003f9a:	f45e                	sd	s7,40(sp)
    80003f9c:	f062                	sd	s8,32(sp)
    80003f9e:	ec66                	sd	s9,24(sp)
    80003fa0:	1880                	addi	s0,sp,112
    80003fa2:	84aa                	mv	s1,a0
    80003fa4:	8aae                	mv	s5,a1
    80003fa6:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fa8:	ffffd097          	auipc	ra,0xffffd
    80003fac:	f2c080e7          	jalr	-212(ra) # 80000ed4 <myproc>
    80003fb0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fb2:	8526                	mv	a0,s1
    80003fb4:	00002097          	auipc	ra,0x2
    80003fb8:	318080e7          	jalr	792(ra) # 800062cc <acquire>
  while(i < n){
    80003fbc:	0d405463          	blez	s4,80004084 <pipewrite+0xfc>
    80003fc0:	8ba6                	mv	s7,s1
  int i = 0;
    80003fc2:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fc4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fc6:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fca:	21c48c13          	addi	s8,s1,540
    80003fce:	a08d                	j	80004030 <pipewrite+0xa8>
      release(&pi->lock);
    80003fd0:	8526                	mv	a0,s1
    80003fd2:	00002097          	auipc	ra,0x2
    80003fd6:	3ae080e7          	jalr	942(ra) # 80006380 <release>
      return -1;
    80003fda:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fdc:	854a                	mv	a0,s2
    80003fde:	70a6                	ld	ra,104(sp)
    80003fe0:	7406                	ld	s0,96(sp)
    80003fe2:	64e6                	ld	s1,88(sp)
    80003fe4:	6946                	ld	s2,80(sp)
    80003fe6:	69a6                	ld	s3,72(sp)
    80003fe8:	6a06                	ld	s4,64(sp)
    80003fea:	7ae2                	ld	s5,56(sp)
    80003fec:	7b42                	ld	s6,48(sp)
    80003fee:	7ba2                	ld	s7,40(sp)
    80003ff0:	7c02                	ld	s8,32(sp)
    80003ff2:	6ce2                	ld	s9,24(sp)
    80003ff4:	6165                	addi	sp,sp,112
    80003ff6:	8082                	ret
      wakeup(&pi->nread);
    80003ff8:	8566                	mv	a0,s9
    80003ffa:	ffffd097          	auipc	ra,0xffffd
    80003ffe:	5ee080e7          	jalr	1518(ra) # 800015e8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004002:	85de                	mv	a1,s7
    80004004:	8562                	mv	a0,s8
    80004006:	ffffd097          	auipc	ra,0xffffd
    8000400a:	57e080e7          	jalr	1406(ra) # 80001584 <sleep>
    8000400e:	a839                	j	8000402c <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004010:	21c4a783          	lw	a5,540(s1)
    80004014:	0017871b          	addiw	a4,a5,1
    80004018:	20e4ae23          	sw	a4,540(s1)
    8000401c:	1ff7f793          	andi	a5,a5,511
    80004020:	97a6                	add	a5,a5,s1
    80004022:	f9f44703          	lbu	a4,-97(s0)
    80004026:	00e78c23          	sb	a4,24(a5)
      i++;
    8000402a:	2905                	addiw	s2,s2,1
  while(i < n){
    8000402c:	05495063          	bge	s2,s4,8000406c <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80004030:	2204a783          	lw	a5,544(s1)
    80004034:	dfd1                	beqz	a5,80003fd0 <pipewrite+0x48>
    80004036:	854e                	mv	a0,s3
    80004038:	ffffd097          	auipc	ra,0xffffd
    8000403c:	7f4080e7          	jalr	2036(ra) # 8000182c <killed>
    80004040:	f941                	bnez	a0,80003fd0 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004042:	2184a783          	lw	a5,536(s1)
    80004046:	21c4a703          	lw	a4,540(s1)
    8000404a:	2007879b          	addiw	a5,a5,512
    8000404e:	faf705e3          	beq	a4,a5,80003ff8 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004052:	4685                	li	a3,1
    80004054:	01590633          	add	a2,s2,s5
    80004058:	f9f40593          	addi	a1,s0,-97
    8000405c:	0509b503          	ld	a0,80(s3)
    80004060:	ffffd097          	auipc	ra,0xffffd
    80004064:	bbe080e7          	jalr	-1090(ra) # 80000c1e <copyin>
    80004068:	fb6514e3          	bne	a0,s6,80004010 <pipewrite+0x88>
  wakeup(&pi->nread);
    8000406c:	21848513          	addi	a0,s1,536
    80004070:	ffffd097          	auipc	ra,0xffffd
    80004074:	578080e7          	jalr	1400(ra) # 800015e8 <wakeup>
  release(&pi->lock);
    80004078:	8526                	mv	a0,s1
    8000407a:	00002097          	auipc	ra,0x2
    8000407e:	306080e7          	jalr	774(ra) # 80006380 <release>
  return i;
    80004082:	bfa9                	j	80003fdc <pipewrite+0x54>
  int i = 0;
    80004084:	4901                	li	s2,0
    80004086:	b7dd                	j	8000406c <pipewrite+0xe4>

0000000080004088 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004088:	715d                	addi	sp,sp,-80
    8000408a:	e486                	sd	ra,72(sp)
    8000408c:	e0a2                	sd	s0,64(sp)
    8000408e:	fc26                	sd	s1,56(sp)
    80004090:	f84a                	sd	s2,48(sp)
    80004092:	f44e                	sd	s3,40(sp)
    80004094:	f052                	sd	s4,32(sp)
    80004096:	ec56                	sd	s5,24(sp)
    80004098:	e85a                	sd	s6,16(sp)
    8000409a:	0880                	addi	s0,sp,80
    8000409c:	84aa                	mv	s1,a0
    8000409e:	892e                	mv	s2,a1
    800040a0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040a2:	ffffd097          	auipc	ra,0xffffd
    800040a6:	e32080e7          	jalr	-462(ra) # 80000ed4 <myproc>
    800040aa:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040ac:	8b26                	mv	s6,s1
    800040ae:	8526                	mv	a0,s1
    800040b0:	00002097          	auipc	ra,0x2
    800040b4:	21c080e7          	jalr	540(ra) # 800062cc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040b8:	2184a703          	lw	a4,536(s1)
    800040bc:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040c0:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040c4:	02f71763          	bne	a4,a5,800040f2 <piperead+0x6a>
    800040c8:	2244a783          	lw	a5,548(s1)
    800040cc:	c39d                	beqz	a5,800040f2 <piperead+0x6a>
    if(killed(pr)){
    800040ce:	8552                	mv	a0,s4
    800040d0:	ffffd097          	auipc	ra,0xffffd
    800040d4:	75c080e7          	jalr	1884(ra) # 8000182c <killed>
    800040d8:	e941                	bnez	a0,80004168 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040da:	85da                	mv	a1,s6
    800040dc:	854e                	mv	a0,s3
    800040de:	ffffd097          	auipc	ra,0xffffd
    800040e2:	4a6080e7          	jalr	1190(ra) # 80001584 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040e6:	2184a703          	lw	a4,536(s1)
    800040ea:	21c4a783          	lw	a5,540(s1)
    800040ee:	fcf70de3          	beq	a4,a5,800040c8 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040f2:	09505263          	blez	s5,80004176 <piperead+0xee>
    800040f6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040f8:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800040fa:	2184a783          	lw	a5,536(s1)
    800040fe:	21c4a703          	lw	a4,540(s1)
    80004102:	02f70d63          	beq	a4,a5,8000413c <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004106:	0017871b          	addiw	a4,a5,1
    8000410a:	20e4ac23          	sw	a4,536(s1)
    8000410e:	1ff7f793          	andi	a5,a5,511
    80004112:	97a6                	add	a5,a5,s1
    80004114:	0187c783          	lbu	a5,24(a5)
    80004118:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000411c:	4685                	li	a3,1
    8000411e:	fbf40613          	addi	a2,s0,-65
    80004122:	85ca                	mv	a1,s2
    80004124:	050a3503          	ld	a0,80(s4)
    80004128:	ffffd097          	auipc	ra,0xffffd
    8000412c:	a36080e7          	jalr	-1482(ra) # 80000b5e <copyout>
    80004130:	01650663          	beq	a0,s6,8000413c <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004134:	2985                	addiw	s3,s3,1
    80004136:	0905                	addi	s2,s2,1
    80004138:	fd3a91e3          	bne	s5,s3,800040fa <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000413c:	21c48513          	addi	a0,s1,540
    80004140:	ffffd097          	auipc	ra,0xffffd
    80004144:	4a8080e7          	jalr	1192(ra) # 800015e8 <wakeup>
  release(&pi->lock);
    80004148:	8526                	mv	a0,s1
    8000414a:	00002097          	auipc	ra,0x2
    8000414e:	236080e7          	jalr	566(ra) # 80006380 <release>
  return i;
}
    80004152:	854e                	mv	a0,s3
    80004154:	60a6                	ld	ra,72(sp)
    80004156:	6406                	ld	s0,64(sp)
    80004158:	74e2                	ld	s1,56(sp)
    8000415a:	7942                	ld	s2,48(sp)
    8000415c:	79a2                	ld	s3,40(sp)
    8000415e:	7a02                	ld	s4,32(sp)
    80004160:	6ae2                	ld	s5,24(sp)
    80004162:	6b42                	ld	s6,16(sp)
    80004164:	6161                	addi	sp,sp,80
    80004166:	8082                	ret
      release(&pi->lock);
    80004168:	8526                	mv	a0,s1
    8000416a:	00002097          	auipc	ra,0x2
    8000416e:	216080e7          	jalr	534(ra) # 80006380 <release>
      return -1;
    80004172:	59fd                	li	s3,-1
    80004174:	bff9                	j	80004152 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004176:	4981                	li	s3,0
    80004178:	b7d1                	j	8000413c <piperead+0xb4>

000000008000417a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000417a:	1141                	addi	sp,sp,-16
    8000417c:	e422                	sd	s0,8(sp)
    8000417e:	0800                	addi	s0,sp,16
    80004180:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004182:	8905                	andi	a0,a0,1
    80004184:	c111                	beqz	a0,80004188 <flags2perm+0xe>
      perm = PTE_X;
    80004186:	4521                	li	a0,8
    if(flags & 0x2)
    80004188:	8b89                	andi	a5,a5,2
    8000418a:	c399                	beqz	a5,80004190 <flags2perm+0x16>
      perm |= PTE_W;
    8000418c:	00456513          	ori	a0,a0,4
    return perm;
}
    80004190:	6422                	ld	s0,8(sp)
    80004192:	0141                	addi	sp,sp,16
    80004194:	8082                	ret

0000000080004196 <exec>:

int
exec(char *path, char **argv)
{
    80004196:	df010113          	addi	sp,sp,-528
    8000419a:	20113423          	sd	ra,520(sp)
    8000419e:	20813023          	sd	s0,512(sp)
    800041a2:	ffa6                	sd	s1,504(sp)
    800041a4:	fbca                	sd	s2,496(sp)
    800041a6:	f7ce                	sd	s3,488(sp)
    800041a8:	f3d2                	sd	s4,480(sp)
    800041aa:	efd6                	sd	s5,472(sp)
    800041ac:	ebda                	sd	s6,464(sp)
    800041ae:	e7de                	sd	s7,456(sp)
    800041b0:	e3e2                	sd	s8,448(sp)
    800041b2:	ff66                	sd	s9,440(sp)
    800041b4:	fb6a                	sd	s10,432(sp)
    800041b6:	f76e                	sd	s11,424(sp)
    800041b8:	0c00                	addi	s0,sp,528
    800041ba:	84aa                	mv	s1,a0
    800041bc:	dea43c23          	sd	a0,-520(s0)
    800041c0:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041c4:	ffffd097          	auipc	ra,0xffffd
    800041c8:	d10080e7          	jalr	-752(ra) # 80000ed4 <myproc>
    800041cc:	892a                	mv	s2,a0

  begin_op();
    800041ce:	fffff097          	auipc	ra,0xfffff
    800041d2:	474080e7          	jalr	1140(ra) # 80003642 <begin_op>

  if((ip = namei(path)) == 0){
    800041d6:	8526                	mv	a0,s1
    800041d8:	fffff097          	auipc	ra,0xfffff
    800041dc:	24e080e7          	jalr	590(ra) # 80003426 <namei>
    800041e0:	c92d                	beqz	a0,80004252 <exec+0xbc>
    800041e2:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041e4:	fffff097          	auipc	ra,0xfffff
    800041e8:	a9c080e7          	jalr	-1380(ra) # 80002c80 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041ec:	04000713          	li	a4,64
    800041f0:	4681                	li	a3,0
    800041f2:	e5040613          	addi	a2,s0,-432
    800041f6:	4581                	li	a1,0
    800041f8:	8526                	mv	a0,s1
    800041fa:	fffff097          	auipc	ra,0xfffff
    800041fe:	d3a080e7          	jalr	-710(ra) # 80002f34 <readi>
    80004202:	04000793          	li	a5,64
    80004206:	00f51a63          	bne	a0,a5,8000421a <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000420a:	e5042703          	lw	a4,-432(s0)
    8000420e:	464c47b7          	lui	a5,0x464c4
    80004212:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004216:	04f70463          	beq	a4,a5,8000425e <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000421a:	8526                	mv	a0,s1
    8000421c:	fffff097          	auipc	ra,0xfffff
    80004220:	cc6080e7          	jalr	-826(ra) # 80002ee2 <iunlockput>
    end_op();
    80004224:	fffff097          	auipc	ra,0xfffff
    80004228:	49e080e7          	jalr	1182(ra) # 800036c2 <end_op>
  }
  return -1;
    8000422c:	557d                	li	a0,-1
}
    8000422e:	20813083          	ld	ra,520(sp)
    80004232:	20013403          	ld	s0,512(sp)
    80004236:	74fe                	ld	s1,504(sp)
    80004238:	795e                	ld	s2,496(sp)
    8000423a:	79be                	ld	s3,488(sp)
    8000423c:	7a1e                	ld	s4,480(sp)
    8000423e:	6afe                	ld	s5,472(sp)
    80004240:	6b5e                	ld	s6,464(sp)
    80004242:	6bbe                	ld	s7,456(sp)
    80004244:	6c1e                	ld	s8,448(sp)
    80004246:	7cfa                	ld	s9,440(sp)
    80004248:	7d5a                	ld	s10,432(sp)
    8000424a:	7dba                	ld	s11,424(sp)
    8000424c:	21010113          	addi	sp,sp,528
    80004250:	8082                	ret
    end_op();
    80004252:	fffff097          	auipc	ra,0xfffff
    80004256:	470080e7          	jalr	1136(ra) # 800036c2 <end_op>
    return -1;
    8000425a:	557d                	li	a0,-1
    8000425c:	bfc9                	j	8000422e <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000425e:	854a                	mv	a0,s2
    80004260:	ffffd097          	auipc	ra,0xffffd
    80004264:	d3c080e7          	jalr	-708(ra) # 80000f9c <proc_pagetable>
    80004268:	8baa                	mv	s7,a0
    8000426a:	d945                	beqz	a0,8000421a <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000426c:	e7042983          	lw	s3,-400(s0)
    80004270:	e8845783          	lhu	a5,-376(s0)
    80004274:	c7ad                	beqz	a5,800042de <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004276:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004278:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    8000427a:	6c85                	lui	s9,0x1
    8000427c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004280:	def43823          	sd	a5,-528(s0)
    80004284:	ac0d                	j	800044b6 <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004286:	00004517          	auipc	a0,0x4
    8000428a:	59250513          	addi	a0,a0,1426 # 80008818 <syscalls+0x288>
    8000428e:	00002097          	auipc	ra,0x2
    80004292:	af4080e7          	jalr	-1292(ra) # 80005d82 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004296:	8756                	mv	a4,s5
    80004298:	012d86bb          	addw	a3,s11,s2
    8000429c:	4581                	li	a1,0
    8000429e:	8526                	mv	a0,s1
    800042a0:	fffff097          	auipc	ra,0xfffff
    800042a4:	c94080e7          	jalr	-876(ra) # 80002f34 <readi>
    800042a8:	2501                	sext.w	a0,a0
    800042aa:	1aaa9a63          	bne	s5,a0,8000445e <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    800042ae:	6785                	lui	a5,0x1
    800042b0:	0127893b          	addw	s2,a5,s2
    800042b4:	77fd                	lui	a5,0xfffff
    800042b6:	01478a3b          	addw	s4,a5,s4
    800042ba:	1f897563          	bgeu	s2,s8,800044a4 <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    800042be:	02091593          	slli	a1,s2,0x20
    800042c2:	9181                	srli	a1,a1,0x20
    800042c4:	95ea                	add	a1,a1,s10
    800042c6:	855e                	mv	a0,s7
    800042c8:	ffffc097          	auipc	ra,0xffffc
    800042cc:	266080e7          	jalr	614(ra) # 8000052e <walkaddr>
    800042d0:	862a                	mv	a2,a0
    if(pa == 0)
    800042d2:	d955                	beqz	a0,80004286 <exec+0xf0>
      n = PGSIZE;
    800042d4:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800042d6:	fd9a70e3          	bgeu	s4,s9,80004296 <exec+0x100>
      n = sz - i;
    800042da:	8ad2                	mv	s5,s4
    800042dc:	bf6d                	j	80004296 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042de:	4a01                	li	s4,0
  iunlockput(ip);
    800042e0:	8526                	mv	a0,s1
    800042e2:	fffff097          	auipc	ra,0xfffff
    800042e6:	c00080e7          	jalr	-1024(ra) # 80002ee2 <iunlockput>
  end_op();
    800042ea:	fffff097          	auipc	ra,0xfffff
    800042ee:	3d8080e7          	jalr	984(ra) # 800036c2 <end_op>
  p = myproc();
    800042f2:	ffffd097          	auipc	ra,0xffffd
    800042f6:	be2080e7          	jalr	-1054(ra) # 80000ed4 <myproc>
    800042fa:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800042fc:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004300:	6785                	lui	a5,0x1
    80004302:	17fd                	addi	a5,a5,-1
    80004304:	9a3e                	add	s4,s4,a5
    80004306:	757d                	lui	a0,0xfffff
    80004308:	00aa77b3          	and	a5,s4,a0
    8000430c:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004310:	4691                	li	a3,4
    80004312:	6609                	lui	a2,0x2
    80004314:	963e                	add	a2,a2,a5
    80004316:	85be                	mv	a1,a5
    80004318:	855e                	mv	a0,s7
    8000431a:	ffffc097          	auipc	ra,0xffffc
    8000431e:	5ec080e7          	jalr	1516(ra) # 80000906 <uvmalloc>
    80004322:	8b2a                	mv	s6,a0
  ip = 0;
    80004324:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004326:	12050c63          	beqz	a0,8000445e <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000432a:	75f9                	lui	a1,0xffffe
    8000432c:	95aa                	add	a1,a1,a0
    8000432e:	855e                	mv	a0,s7
    80004330:	ffffc097          	auipc	ra,0xffffc
    80004334:	7fc080e7          	jalr	2044(ra) # 80000b2c <uvmclear>
  stackbase = sp - PGSIZE;
    80004338:	7c7d                	lui	s8,0xfffff
    8000433a:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000433c:	e0043783          	ld	a5,-512(s0)
    80004340:	6388                	ld	a0,0(a5)
    80004342:	c535                	beqz	a0,800043ae <exec+0x218>
    80004344:	e9040993          	addi	s3,s0,-368
    80004348:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000434c:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000434e:	ffffc097          	auipc	ra,0xffffc
    80004352:	fd2080e7          	jalr	-46(ra) # 80000320 <strlen>
    80004356:	2505                	addiw	a0,a0,1
    80004358:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000435c:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004360:	13896663          	bltu	s2,s8,8000448c <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004364:	e0043d83          	ld	s11,-512(s0)
    80004368:	000dba03          	ld	s4,0(s11)
    8000436c:	8552                	mv	a0,s4
    8000436e:	ffffc097          	auipc	ra,0xffffc
    80004372:	fb2080e7          	jalr	-78(ra) # 80000320 <strlen>
    80004376:	0015069b          	addiw	a3,a0,1
    8000437a:	8652                	mv	a2,s4
    8000437c:	85ca                	mv	a1,s2
    8000437e:	855e                	mv	a0,s7
    80004380:	ffffc097          	auipc	ra,0xffffc
    80004384:	7de080e7          	jalr	2014(ra) # 80000b5e <copyout>
    80004388:	10054663          	bltz	a0,80004494 <exec+0x2fe>
    ustack[argc] = sp;
    8000438c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004390:	0485                	addi	s1,s1,1
    80004392:	008d8793          	addi	a5,s11,8
    80004396:	e0f43023          	sd	a5,-512(s0)
    8000439a:	008db503          	ld	a0,8(s11)
    8000439e:	c911                	beqz	a0,800043b2 <exec+0x21c>
    if(argc >= MAXARG)
    800043a0:	09a1                	addi	s3,s3,8
    800043a2:	fb3c96e3          	bne	s9,s3,8000434e <exec+0x1b8>
  sz = sz1;
    800043a6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043aa:	4481                	li	s1,0
    800043ac:	a84d                	j	8000445e <exec+0x2c8>
  sp = sz;
    800043ae:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800043b0:	4481                	li	s1,0
  ustack[argc] = 0;
    800043b2:	00349793          	slli	a5,s1,0x3
    800043b6:	f9040713          	addi	a4,s0,-112
    800043ba:	97ba                	add	a5,a5,a4
    800043bc:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800043c0:	00148693          	addi	a3,s1,1
    800043c4:	068e                	slli	a3,a3,0x3
    800043c6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043ca:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800043ce:	01897663          	bgeu	s2,s8,800043da <exec+0x244>
  sz = sz1;
    800043d2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043d6:	4481                	li	s1,0
    800043d8:	a059                	j	8000445e <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043da:	e9040613          	addi	a2,s0,-368
    800043de:	85ca                	mv	a1,s2
    800043e0:	855e                	mv	a0,s7
    800043e2:	ffffc097          	auipc	ra,0xffffc
    800043e6:	77c080e7          	jalr	1916(ra) # 80000b5e <copyout>
    800043ea:	0a054963          	bltz	a0,8000449c <exec+0x306>
  p->trapframe->a1 = sp;
    800043ee:	058ab783          	ld	a5,88(s5)
    800043f2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043f6:	df843783          	ld	a5,-520(s0)
    800043fa:	0007c703          	lbu	a4,0(a5)
    800043fe:	cf11                	beqz	a4,8000441a <exec+0x284>
    80004400:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004402:	02f00693          	li	a3,47
    80004406:	a039                	j	80004414 <exec+0x27e>
      last = s+1;
    80004408:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000440c:	0785                	addi	a5,a5,1
    8000440e:	fff7c703          	lbu	a4,-1(a5)
    80004412:	c701                	beqz	a4,8000441a <exec+0x284>
    if(*s == '/')
    80004414:	fed71ce3          	bne	a4,a3,8000440c <exec+0x276>
    80004418:	bfc5                	j	80004408 <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    8000441a:	4641                	li	a2,16
    8000441c:	df843583          	ld	a1,-520(s0)
    80004420:	158a8513          	addi	a0,s5,344
    80004424:	ffffc097          	auipc	ra,0xffffc
    80004428:	eca080e7          	jalr	-310(ra) # 800002ee <safestrcpy>
  oldpagetable = p->pagetable;
    8000442c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004430:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004434:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004438:	058ab783          	ld	a5,88(s5)
    8000443c:	e6843703          	ld	a4,-408(s0)
    80004440:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004442:	058ab783          	ld	a5,88(s5)
    80004446:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000444a:	85ea                	mv	a1,s10
    8000444c:	ffffd097          	auipc	ra,0xffffd
    80004450:	bec080e7          	jalr	-1044(ra) # 80001038 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004454:	0004851b          	sext.w	a0,s1
    80004458:	bbd9                	j	8000422e <exec+0x98>
    8000445a:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000445e:	e0843583          	ld	a1,-504(s0)
    80004462:	855e                	mv	a0,s7
    80004464:	ffffd097          	auipc	ra,0xffffd
    80004468:	bd4080e7          	jalr	-1068(ra) # 80001038 <proc_freepagetable>
  if(ip){
    8000446c:	da0497e3          	bnez	s1,8000421a <exec+0x84>
  return -1;
    80004470:	557d                	li	a0,-1
    80004472:	bb75                	j	8000422e <exec+0x98>
    80004474:	e1443423          	sd	s4,-504(s0)
    80004478:	b7dd                	j	8000445e <exec+0x2c8>
    8000447a:	e1443423          	sd	s4,-504(s0)
    8000447e:	b7c5                	j	8000445e <exec+0x2c8>
    80004480:	e1443423          	sd	s4,-504(s0)
    80004484:	bfe9                	j	8000445e <exec+0x2c8>
    80004486:	e1443423          	sd	s4,-504(s0)
    8000448a:	bfd1                	j	8000445e <exec+0x2c8>
  sz = sz1;
    8000448c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004490:	4481                	li	s1,0
    80004492:	b7f1                	j	8000445e <exec+0x2c8>
  sz = sz1;
    80004494:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004498:	4481                	li	s1,0
    8000449a:	b7d1                	j	8000445e <exec+0x2c8>
  sz = sz1;
    8000449c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044a0:	4481                	li	s1,0
    800044a2:	bf75                	j	8000445e <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044a4:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044a8:	2b05                	addiw	s6,s6,1
    800044aa:	0389899b          	addiw	s3,s3,56
    800044ae:	e8845783          	lhu	a5,-376(s0)
    800044b2:	e2fb57e3          	bge	s6,a5,800042e0 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044b6:	2981                	sext.w	s3,s3
    800044b8:	03800713          	li	a4,56
    800044bc:	86ce                	mv	a3,s3
    800044be:	e1840613          	addi	a2,s0,-488
    800044c2:	4581                	li	a1,0
    800044c4:	8526                	mv	a0,s1
    800044c6:	fffff097          	auipc	ra,0xfffff
    800044ca:	a6e080e7          	jalr	-1426(ra) # 80002f34 <readi>
    800044ce:	03800793          	li	a5,56
    800044d2:	f8f514e3          	bne	a0,a5,8000445a <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    800044d6:	e1842783          	lw	a5,-488(s0)
    800044da:	4705                	li	a4,1
    800044dc:	fce796e3          	bne	a5,a4,800044a8 <exec+0x312>
    if(ph.memsz < ph.filesz)
    800044e0:	e4043903          	ld	s2,-448(s0)
    800044e4:	e3843783          	ld	a5,-456(s0)
    800044e8:	f8f966e3          	bltu	s2,a5,80004474 <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044ec:	e2843783          	ld	a5,-472(s0)
    800044f0:	993e                	add	s2,s2,a5
    800044f2:	f8f964e3          	bltu	s2,a5,8000447a <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    800044f6:	df043703          	ld	a4,-528(s0)
    800044fa:	8ff9                	and	a5,a5,a4
    800044fc:	f3d1                	bnez	a5,80004480 <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044fe:	e1c42503          	lw	a0,-484(s0)
    80004502:	00000097          	auipc	ra,0x0
    80004506:	c78080e7          	jalr	-904(ra) # 8000417a <flags2perm>
    8000450a:	86aa                	mv	a3,a0
    8000450c:	864a                	mv	a2,s2
    8000450e:	85d2                	mv	a1,s4
    80004510:	855e                	mv	a0,s7
    80004512:	ffffc097          	auipc	ra,0xffffc
    80004516:	3f4080e7          	jalr	1012(ra) # 80000906 <uvmalloc>
    8000451a:	e0a43423          	sd	a0,-504(s0)
    8000451e:	d525                	beqz	a0,80004486 <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004520:	e2843d03          	ld	s10,-472(s0)
    80004524:	e2042d83          	lw	s11,-480(s0)
    80004528:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000452c:	f60c0ce3          	beqz	s8,800044a4 <exec+0x30e>
    80004530:	8a62                	mv	s4,s8
    80004532:	4901                	li	s2,0
    80004534:	b369                	j	800042be <exec+0x128>

0000000080004536 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004536:	7179                	addi	sp,sp,-48
    80004538:	f406                	sd	ra,40(sp)
    8000453a:	f022                	sd	s0,32(sp)
    8000453c:	ec26                	sd	s1,24(sp)
    8000453e:	e84a                	sd	s2,16(sp)
    80004540:	1800                	addi	s0,sp,48
    80004542:	892e                	mv	s2,a1
    80004544:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004546:	fdc40593          	addi	a1,s0,-36
    8000454a:	ffffe097          	auipc	ra,0xffffe
    8000454e:	afa080e7          	jalr	-1286(ra) # 80002044 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004552:	fdc42703          	lw	a4,-36(s0)
    80004556:	47bd                	li	a5,15
    80004558:	02e7eb63          	bltu	a5,a4,8000458e <argfd+0x58>
    8000455c:	ffffd097          	auipc	ra,0xffffd
    80004560:	978080e7          	jalr	-1672(ra) # 80000ed4 <myproc>
    80004564:	fdc42703          	lw	a4,-36(s0)
    80004568:	01a70793          	addi	a5,a4,26
    8000456c:	078e                	slli	a5,a5,0x3
    8000456e:	953e                	add	a0,a0,a5
    80004570:	611c                	ld	a5,0(a0)
    80004572:	c385                	beqz	a5,80004592 <argfd+0x5c>
    return -1;
  if(pfd)
    80004574:	00090463          	beqz	s2,8000457c <argfd+0x46>
    *pfd = fd;
    80004578:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000457c:	4501                	li	a0,0
  if(pf)
    8000457e:	c091                	beqz	s1,80004582 <argfd+0x4c>
    *pf = f;
    80004580:	e09c                	sd	a5,0(s1)
}
    80004582:	70a2                	ld	ra,40(sp)
    80004584:	7402                	ld	s0,32(sp)
    80004586:	64e2                	ld	s1,24(sp)
    80004588:	6942                	ld	s2,16(sp)
    8000458a:	6145                	addi	sp,sp,48
    8000458c:	8082                	ret
    return -1;
    8000458e:	557d                	li	a0,-1
    80004590:	bfcd                	j	80004582 <argfd+0x4c>
    80004592:	557d                	li	a0,-1
    80004594:	b7fd                	j	80004582 <argfd+0x4c>

0000000080004596 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004596:	1101                	addi	sp,sp,-32
    80004598:	ec06                	sd	ra,24(sp)
    8000459a:	e822                	sd	s0,16(sp)
    8000459c:	e426                	sd	s1,8(sp)
    8000459e:	1000                	addi	s0,sp,32
    800045a0:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045a2:	ffffd097          	auipc	ra,0xffffd
    800045a6:	932080e7          	jalr	-1742(ra) # 80000ed4 <myproc>
    800045aa:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045ac:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffdcf10>
    800045b0:	4501                	li	a0,0
    800045b2:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045b4:	6398                	ld	a4,0(a5)
    800045b6:	cb19                	beqz	a4,800045cc <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045b8:	2505                	addiw	a0,a0,1
    800045ba:	07a1                	addi	a5,a5,8
    800045bc:	fed51ce3          	bne	a0,a3,800045b4 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045c0:	557d                	li	a0,-1
}
    800045c2:	60e2                	ld	ra,24(sp)
    800045c4:	6442                	ld	s0,16(sp)
    800045c6:	64a2                	ld	s1,8(sp)
    800045c8:	6105                	addi	sp,sp,32
    800045ca:	8082                	ret
      p->ofile[fd] = f;
    800045cc:	01a50793          	addi	a5,a0,26
    800045d0:	078e                	slli	a5,a5,0x3
    800045d2:	963e                	add	a2,a2,a5
    800045d4:	e204                	sd	s1,0(a2)
      return fd;
    800045d6:	b7f5                	j	800045c2 <fdalloc+0x2c>

00000000800045d8 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045d8:	715d                	addi	sp,sp,-80
    800045da:	e486                	sd	ra,72(sp)
    800045dc:	e0a2                	sd	s0,64(sp)
    800045de:	fc26                	sd	s1,56(sp)
    800045e0:	f84a                	sd	s2,48(sp)
    800045e2:	f44e                	sd	s3,40(sp)
    800045e4:	f052                	sd	s4,32(sp)
    800045e6:	ec56                	sd	s5,24(sp)
    800045e8:	e85a                	sd	s6,16(sp)
    800045ea:	0880                	addi	s0,sp,80
    800045ec:	8b2e                	mv	s6,a1
    800045ee:	89b2                	mv	s3,a2
    800045f0:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045f2:	fb040593          	addi	a1,s0,-80
    800045f6:	fffff097          	auipc	ra,0xfffff
    800045fa:	e4e080e7          	jalr	-434(ra) # 80003444 <nameiparent>
    800045fe:	84aa                	mv	s1,a0
    80004600:	16050063          	beqz	a0,80004760 <create+0x188>
    return 0;

  ilock(dp);
    80004604:	ffffe097          	auipc	ra,0xffffe
    80004608:	67c080e7          	jalr	1660(ra) # 80002c80 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000460c:	4601                	li	a2,0
    8000460e:	fb040593          	addi	a1,s0,-80
    80004612:	8526                	mv	a0,s1
    80004614:	fffff097          	auipc	ra,0xfffff
    80004618:	b50080e7          	jalr	-1200(ra) # 80003164 <dirlookup>
    8000461c:	8aaa                	mv	s5,a0
    8000461e:	c931                	beqz	a0,80004672 <create+0x9a>
    iunlockput(dp);
    80004620:	8526                	mv	a0,s1
    80004622:	fffff097          	auipc	ra,0xfffff
    80004626:	8c0080e7          	jalr	-1856(ra) # 80002ee2 <iunlockput>
    ilock(ip);
    8000462a:	8556                	mv	a0,s5
    8000462c:	ffffe097          	auipc	ra,0xffffe
    80004630:	654080e7          	jalr	1620(ra) # 80002c80 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004634:	000b059b          	sext.w	a1,s6
    80004638:	4789                	li	a5,2
    8000463a:	02f59563          	bne	a1,a5,80004664 <create+0x8c>
    8000463e:	044ad783          	lhu	a5,68(s5)
    80004642:	37f9                	addiw	a5,a5,-2
    80004644:	17c2                	slli	a5,a5,0x30
    80004646:	93c1                	srli	a5,a5,0x30
    80004648:	4705                	li	a4,1
    8000464a:	00f76d63          	bltu	a4,a5,80004664 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000464e:	8556                	mv	a0,s5
    80004650:	60a6                	ld	ra,72(sp)
    80004652:	6406                	ld	s0,64(sp)
    80004654:	74e2                	ld	s1,56(sp)
    80004656:	7942                	ld	s2,48(sp)
    80004658:	79a2                	ld	s3,40(sp)
    8000465a:	7a02                	ld	s4,32(sp)
    8000465c:	6ae2                	ld	s5,24(sp)
    8000465e:	6b42                	ld	s6,16(sp)
    80004660:	6161                	addi	sp,sp,80
    80004662:	8082                	ret
    iunlockput(ip);
    80004664:	8556                	mv	a0,s5
    80004666:	fffff097          	auipc	ra,0xfffff
    8000466a:	87c080e7          	jalr	-1924(ra) # 80002ee2 <iunlockput>
    return 0;
    8000466e:	4a81                	li	s5,0
    80004670:	bff9                	j	8000464e <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004672:	85da                	mv	a1,s6
    80004674:	4088                	lw	a0,0(s1)
    80004676:	ffffe097          	auipc	ra,0xffffe
    8000467a:	46e080e7          	jalr	1134(ra) # 80002ae4 <ialloc>
    8000467e:	8a2a                	mv	s4,a0
    80004680:	c921                	beqz	a0,800046d0 <create+0xf8>
  ilock(ip);
    80004682:	ffffe097          	auipc	ra,0xffffe
    80004686:	5fe080e7          	jalr	1534(ra) # 80002c80 <ilock>
  ip->major = major;
    8000468a:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000468e:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004692:	4785                	li	a5,1
    80004694:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    80004698:	8552                	mv	a0,s4
    8000469a:	ffffe097          	auipc	ra,0xffffe
    8000469e:	51c080e7          	jalr	1308(ra) # 80002bb6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800046a2:	000b059b          	sext.w	a1,s6
    800046a6:	4785                	li	a5,1
    800046a8:	02f58b63          	beq	a1,a5,800046de <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    800046ac:	004a2603          	lw	a2,4(s4)
    800046b0:	fb040593          	addi	a1,s0,-80
    800046b4:	8526                	mv	a0,s1
    800046b6:	fffff097          	auipc	ra,0xfffff
    800046ba:	cbe080e7          	jalr	-834(ra) # 80003374 <dirlink>
    800046be:	06054f63          	bltz	a0,8000473c <create+0x164>
  iunlockput(dp);
    800046c2:	8526                	mv	a0,s1
    800046c4:	fffff097          	auipc	ra,0xfffff
    800046c8:	81e080e7          	jalr	-2018(ra) # 80002ee2 <iunlockput>
  return ip;
    800046cc:	8ad2                	mv	s5,s4
    800046ce:	b741                	j	8000464e <create+0x76>
    iunlockput(dp);
    800046d0:	8526                	mv	a0,s1
    800046d2:	fffff097          	auipc	ra,0xfffff
    800046d6:	810080e7          	jalr	-2032(ra) # 80002ee2 <iunlockput>
    return 0;
    800046da:	8ad2                	mv	s5,s4
    800046dc:	bf8d                	j	8000464e <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046de:	004a2603          	lw	a2,4(s4)
    800046e2:	00004597          	auipc	a1,0x4
    800046e6:	15658593          	addi	a1,a1,342 # 80008838 <syscalls+0x2a8>
    800046ea:	8552                	mv	a0,s4
    800046ec:	fffff097          	auipc	ra,0xfffff
    800046f0:	c88080e7          	jalr	-888(ra) # 80003374 <dirlink>
    800046f4:	04054463          	bltz	a0,8000473c <create+0x164>
    800046f8:	40d0                	lw	a2,4(s1)
    800046fa:	00004597          	auipc	a1,0x4
    800046fe:	14658593          	addi	a1,a1,326 # 80008840 <syscalls+0x2b0>
    80004702:	8552                	mv	a0,s4
    80004704:	fffff097          	auipc	ra,0xfffff
    80004708:	c70080e7          	jalr	-912(ra) # 80003374 <dirlink>
    8000470c:	02054863          	bltz	a0,8000473c <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    80004710:	004a2603          	lw	a2,4(s4)
    80004714:	fb040593          	addi	a1,s0,-80
    80004718:	8526                	mv	a0,s1
    8000471a:	fffff097          	auipc	ra,0xfffff
    8000471e:	c5a080e7          	jalr	-934(ra) # 80003374 <dirlink>
    80004722:	00054d63          	bltz	a0,8000473c <create+0x164>
    dp->nlink++;  // for ".."
    80004726:	04a4d783          	lhu	a5,74(s1)
    8000472a:	2785                	addiw	a5,a5,1
    8000472c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004730:	8526                	mv	a0,s1
    80004732:	ffffe097          	auipc	ra,0xffffe
    80004736:	484080e7          	jalr	1156(ra) # 80002bb6 <iupdate>
    8000473a:	b761                	j	800046c2 <create+0xea>
  ip->nlink = 0;
    8000473c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004740:	8552                	mv	a0,s4
    80004742:	ffffe097          	auipc	ra,0xffffe
    80004746:	474080e7          	jalr	1140(ra) # 80002bb6 <iupdate>
  iunlockput(ip);
    8000474a:	8552                	mv	a0,s4
    8000474c:	ffffe097          	auipc	ra,0xffffe
    80004750:	796080e7          	jalr	1942(ra) # 80002ee2 <iunlockput>
  iunlockput(dp);
    80004754:	8526                	mv	a0,s1
    80004756:	ffffe097          	auipc	ra,0xffffe
    8000475a:	78c080e7          	jalr	1932(ra) # 80002ee2 <iunlockput>
  return 0;
    8000475e:	bdc5                	j	8000464e <create+0x76>
    return 0;
    80004760:	8aaa                	mv	s5,a0
    80004762:	b5f5                	j	8000464e <create+0x76>

0000000080004764 <sys_dup>:
{
    80004764:	7179                	addi	sp,sp,-48
    80004766:	f406                	sd	ra,40(sp)
    80004768:	f022                	sd	s0,32(sp)
    8000476a:	ec26                	sd	s1,24(sp)
    8000476c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000476e:	fd840613          	addi	a2,s0,-40
    80004772:	4581                	li	a1,0
    80004774:	4501                	li	a0,0
    80004776:	00000097          	auipc	ra,0x0
    8000477a:	dc0080e7          	jalr	-576(ra) # 80004536 <argfd>
    return -1;
    8000477e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004780:	02054363          	bltz	a0,800047a6 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004784:	fd843503          	ld	a0,-40(s0)
    80004788:	00000097          	auipc	ra,0x0
    8000478c:	e0e080e7          	jalr	-498(ra) # 80004596 <fdalloc>
    80004790:	84aa                	mv	s1,a0
    return -1;
    80004792:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004794:	00054963          	bltz	a0,800047a6 <sys_dup+0x42>
  filedup(f);
    80004798:	fd843503          	ld	a0,-40(s0)
    8000479c:	fffff097          	auipc	ra,0xfffff
    800047a0:	320080e7          	jalr	800(ra) # 80003abc <filedup>
  return fd;
    800047a4:	87a6                	mv	a5,s1
}
    800047a6:	853e                	mv	a0,a5
    800047a8:	70a2                	ld	ra,40(sp)
    800047aa:	7402                	ld	s0,32(sp)
    800047ac:	64e2                	ld	s1,24(sp)
    800047ae:	6145                	addi	sp,sp,48
    800047b0:	8082                	ret

00000000800047b2 <sys_read>:
{
    800047b2:	7179                	addi	sp,sp,-48
    800047b4:	f406                	sd	ra,40(sp)
    800047b6:	f022                	sd	s0,32(sp)
    800047b8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800047ba:	fd840593          	addi	a1,s0,-40
    800047be:	4505                	li	a0,1
    800047c0:	ffffe097          	auipc	ra,0xffffe
    800047c4:	8a4080e7          	jalr	-1884(ra) # 80002064 <argaddr>
  argint(2, &n);
    800047c8:	fe440593          	addi	a1,s0,-28
    800047cc:	4509                	li	a0,2
    800047ce:	ffffe097          	auipc	ra,0xffffe
    800047d2:	876080e7          	jalr	-1930(ra) # 80002044 <argint>
  if(argfd(0, 0, &f) < 0)
    800047d6:	fe840613          	addi	a2,s0,-24
    800047da:	4581                	li	a1,0
    800047dc:	4501                	li	a0,0
    800047de:	00000097          	auipc	ra,0x0
    800047e2:	d58080e7          	jalr	-680(ra) # 80004536 <argfd>
    800047e6:	87aa                	mv	a5,a0
    return -1;
    800047e8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047ea:	0007cc63          	bltz	a5,80004802 <sys_read+0x50>
  return fileread(f, p, n);
    800047ee:	fe442603          	lw	a2,-28(s0)
    800047f2:	fd843583          	ld	a1,-40(s0)
    800047f6:	fe843503          	ld	a0,-24(s0)
    800047fa:	fffff097          	auipc	ra,0xfffff
    800047fe:	44e080e7          	jalr	1102(ra) # 80003c48 <fileread>
}
    80004802:	70a2                	ld	ra,40(sp)
    80004804:	7402                	ld	s0,32(sp)
    80004806:	6145                	addi	sp,sp,48
    80004808:	8082                	ret

000000008000480a <sys_write>:
{
    8000480a:	7179                	addi	sp,sp,-48
    8000480c:	f406                	sd	ra,40(sp)
    8000480e:	f022                	sd	s0,32(sp)
    80004810:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004812:	fd840593          	addi	a1,s0,-40
    80004816:	4505                	li	a0,1
    80004818:	ffffe097          	auipc	ra,0xffffe
    8000481c:	84c080e7          	jalr	-1972(ra) # 80002064 <argaddr>
  argint(2, &n);
    80004820:	fe440593          	addi	a1,s0,-28
    80004824:	4509                	li	a0,2
    80004826:	ffffe097          	auipc	ra,0xffffe
    8000482a:	81e080e7          	jalr	-2018(ra) # 80002044 <argint>
  if(argfd(0, 0, &f) < 0)
    8000482e:	fe840613          	addi	a2,s0,-24
    80004832:	4581                	li	a1,0
    80004834:	4501                	li	a0,0
    80004836:	00000097          	auipc	ra,0x0
    8000483a:	d00080e7          	jalr	-768(ra) # 80004536 <argfd>
    8000483e:	87aa                	mv	a5,a0
    return -1;
    80004840:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004842:	0007cc63          	bltz	a5,8000485a <sys_write+0x50>
  return filewrite(f, p, n);
    80004846:	fe442603          	lw	a2,-28(s0)
    8000484a:	fd843583          	ld	a1,-40(s0)
    8000484e:	fe843503          	ld	a0,-24(s0)
    80004852:	fffff097          	auipc	ra,0xfffff
    80004856:	4b8080e7          	jalr	1208(ra) # 80003d0a <filewrite>
}
    8000485a:	70a2                	ld	ra,40(sp)
    8000485c:	7402                	ld	s0,32(sp)
    8000485e:	6145                	addi	sp,sp,48
    80004860:	8082                	ret

0000000080004862 <sys_close>:
{
    80004862:	1101                	addi	sp,sp,-32
    80004864:	ec06                	sd	ra,24(sp)
    80004866:	e822                	sd	s0,16(sp)
    80004868:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000486a:	fe040613          	addi	a2,s0,-32
    8000486e:	fec40593          	addi	a1,s0,-20
    80004872:	4501                	li	a0,0
    80004874:	00000097          	auipc	ra,0x0
    80004878:	cc2080e7          	jalr	-830(ra) # 80004536 <argfd>
    return -1;
    8000487c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000487e:	02054463          	bltz	a0,800048a6 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004882:	ffffc097          	auipc	ra,0xffffc
    80004886:	652080e7          	jalr	1618(ra) # 80000ed4 <myproc>
    8000488a:	fec42783          	lw	a5,-20(s0)
    8000488e:	07e9                	addi	a5,a5,26
    80004890:	078e                	slli	a5,a5,0x3
    80004892:	97aa                	add	a5,a5,a0
    80004894:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004898:	fe043503          	ld	a0,-32(s0)
    8000489c:	fffff097          	auipc	ra,0xfffff
    800048a0:	272080e7          	jalr	626(ra) # 80003b0e <fileclose>
  return 0;
    800048a4:	4781                	li	a5,0
}
    800048a6:	853e                	mv	a0,a5
    800048a8:	60e2                	ld	ra,24(sp)
    800048aa:	6442                	ld	s0,16(sp)
    800048ac:	6105                	addi	sp,sp,32
    800048ae:	8082                	ret

00000000800048b0 <sys_fstat>:
{
    800048b0:	1101                	addi	sp,sp,-32
    800048b2:	ec06                	sd	ra,24(sp)
    800048b4:	e822                	sd	s0,16(sp)
    800048b6:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800048b8:	fe040593          	addi	a1,s0,-32
    800048bc:	4505                	li	a0,1
    800048be:	ffffd097          	auipc	ra,0xffffd
    800048c2:	7a6080e7          	jalr	1958(ra) # 80002064 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800048c6:	fe840613          	addi	a2,s0,-24
    800048ca:	4581                	li	a1,0
    800048cc:	4501                	li	a0,0
    800048ce:	00000097          	auipc	ra,0x0
    800048d2:	c68080e7          	jalr	-920(ra) # 80004536 <argfd>
    800048d6:	87aa                	mv	a5,a0
    return -1;
    800048d8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048da:	0007ca63          	bltz	a5,800048ee <sys_fstat+0x3e>
  return filestat(f, st);
    800048de:	fe043583          	ld	a1,-32(s0)
    800048e2:	fe843503          	ld	a0,-24(s0)
    800048e6:	fffff097          	auipc	ra,0xfffff
    800048ea:	2f0080e7          	jalr	752(ra) # 80003bd6 <filestat>
}
    800048ee:	60e2                	ld	ra,24(sp)
    800048f0:	6442                	ld	s0,16(sp)
    800048f2:	6105                	addi	sp,sp,32
    800048f4:	8082                	ret

00000000800048f6 <sys_link>:
{
    800048f6:	7169                	addi	sp,sp,-304
    800048f8:	f606                	sd	ra,296(sp)
    800048fa:	f222                	sd	s0,288(sp)
    800048fc:	ee26                	sd	s1,280(sp)
    800048fe:	ea4a                	sd	s2,272(sp)
    80004900:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004902:	08000613          	li	a2,128
    80004906:	ed040593          	addi	a1,s0,-304
    8000490a:	4501                	li	a0,0
    8000490c:	ffffd097          	auipc	ra,0xffffd
    80004910:	778080e7          	jalr	1912(ra) # 80002084 <argstr>
    return -1;
    80004914:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004916:	10054e63          	bltz	a0,80004a32 <sys_link+0x13c>
    8000491a:	08000613          	li	a2,128
    8000491e:	f5040593          	addi	a1,s0,-176
    80004922:	4505                	li	a0,1
    80004924:	ffffd097          	auipc	ra,0xffffd
    80004928:	760080e7          	jalr	1888(ra) # 80002084 <argstr>
    return -1;
    8000492c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000492e:	10054263          	bltz	a0,80004a32 <sys_link+0x13c>
  begin_op();
    80004932:	fffff097          	auipc	ra,0xfffff
    80004936:	d10080e7          	jalr	-752(ra) # 80003642 <begin_op>
  if((ip = namei(old)) == 0){
    8000493a:	ed040513          	addi	a0,s0,-304
    8000493e:	fffff097          	auipc	ra,0xfffff
    80004942:	ae8080e7          	jalr	-1304(ra) # 80003426 <namei>
    80004946:	84aa                	mv	s1,a0
    80004948:	c551                	beqz	a0,800049d4 <sys_link+0xde>
  ilock(ip);
    8000494a:	ffffe097          	auipc	ra,0xffffe
    8000494e:	336080e7          	jalr	822(ra) # 80002c80 <ilock>
  if(ip->type == T_DIR){
    80004952:	04449703          	lh	a4,68(s1)
    80004956:	4785                	li	a5,1
    80004958:	08f70463          	beq	a4,a5,800049e0 <sys_link+0xea>
  ip->nlink++;
    8000495c:	04a4d783          	lhu	a5,74(s1)
    80004960:	2785                	addiw	a5,a5,1
    80004962:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004966:	8526                	mv	a0,s1
    80004968:	ffffe097          	auipc	ra,0xffffe
    8000496c:	24e080e7          	jalr	590(ra) # 80002bb6 <iupdate>
  iunlock(ip);
    80004970:	8526                	mv	a0,s1
    80004972:	ffffe097          	auipc	ra,0xffffe
    80004976:	3d0080e7          	jalr	976(ra) # 80002d42 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000497a:	fd040593          	addi	a1,s0,-48
    8000497e:	f5040513          	addi	a0,s0,-176
    80004982:	fffff097          	auipc	ra,0xfffff
    80004986:	ac2080e7          	jalr	-1342(ra) # 80003444 <nameiparent>
    8000498a:	892a                	mv	s2,a0
    8000498c:	c935                	beqz	a0,80004a00 <sys_link+0x10a>
  ilock(dp);
    8000498e:	ffffe097          	auipc	ra,0xffffe
    80004992:	2f2080e7          	jalr	754(ra) # 80002c80 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004996:	00092703          	lw	a4,0(s2)
    8000499a:	409c                	lw	a5,0(s1)
    8000499c:	04f71d63          	bne	a4,a5,800049f6 <sys_link+0x100>
    800049a0:	40d0                	lw	a2,4(s1)
    800049a2:	fd040593          	addi	a1,s0,-48
    800049a6:	854a                	mv	a0,s2
    800049a8:	fffff097          	auipc	ra,0xfffff
    800049ac:	9cc080e7          	jalr	-1588(ra) # 80003374 <dirlink>
    800049b0:	04054363          	bltz	a0,800049f6 <sys_link+0x100>
  iunlockput(dp);
    800049b4:	854a                	mv	a0,s2
    800049b6:	ffffe097          	auipc	ra,0xffffe
    800049ba:	52c080e7          	jalr	1324(ra) # 80002ee2 <iunlockput>
  iput(ip);
    800049be:	8526                	mv	a0,s1
    800049c0:	ffffe097          	auipc	ra,0xffffe
    800049c4:	47a080e7          	jalr	1146(ra) # 80002e3a <iput>
  end_op();
    800049c8:	fffff097          	auipc	ra,0xfffff
    800049cc:	cfa080e7          	jalr	-774(ra) # 800036c2 <end_op>
  return 0;
    800049d0:	4781                	li	a5,0
    800049d2:	a085                	j	80004a32 <sys_link+0x13c>
    end_op();
    800049d4:	fffff097          	auipc	ra,0xfffff
    800049d8:	cee080e7          	jalr	-786(ra) # 800036c2 <end_op>
    return -1;
    800049dc:	57fd                	li	a5,-1
    800049de:	a891                	j	80004a32 <sys_link+0x13c>
    iunlockput(ip);
    800049e0:	8526                	mv	a0,s1
    800049e2:	ffffe097          	auipc	ra,0xffffe
    800049e6:	500080e7          	jalr	1280(ra) # 80002ee2 <iunlockput>
    end_op();
    800049ea:	fffff097          	auipc	ra,0xfffff
    800049ee:	cd8080e7          	jalr	-808(ra) # 800036c2 <end_op>
    return -1;
    800049f2:	57fd                	li	a5,-1
    800049f4:	a83d                	j	80004a32 <sys_link+0x13c>
    iunlockput(dp);
    800049f6:	854a                	mv	a0,s2
    800049f8:	ffffe097          	auipc	ra,0xffffe
    800049fc:	4ea080e7          	jalr	1258(ra) # 80002ee2 <iunlockput>
  ilock(ip);
    80004a00:	8526                	mv	a0,s1
    80004a02:	ffffe097          	auipc	ra,0xffffe
    80004a06:	27e080e7          	jalr	638(ra) # 80002c80 <ilock>
  ip->nlink--;
    80004a0a:	04a4d783          	lhu	a5,74(s1)
    80004a0e:	37fd                	addiw	a5,a5,-1
    80004a10:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a14:	8526                	mv	a0,s1
    80004a16:	ffffe097          	auipc	ra,0xffffe
    80004a1a:	1a0080e7          	jalr	416(ra) # 80002bb6 <iupdate>
  iunlockput(ip);
    80004a1e:	8526                	mv	a0,s1
    80004a20:	ffffe097          	auipc	ra,0xffffe
    80004a24:	4c2080e7          	jalr	1218(ra) # 80002ee2 <iunlockput>
  end_op();
    80004a28:	fffff097          	auipc	ra,0xfffff
    80004a2c:	c9a080e7          	jalr	-870(ra) # 800036c2 <end_op>
  return -1;
    80004a30:	57fd                	li	a5,-1
}
    80004a32:	853e                	mv	a0,a5
    80004a34:	70b2                	ld	ra,296(sp)
    80004a36:	7412                	ld	s0,288(sp)
    80004a38:	64f2                	ld	s1,280(sp)
    80004a3a:	6952                	ld	s2,272(sp)
    80004a3c:	6155                	addi	sp,sp,304
    80004a3e:	8082                	ret

0000000080004a40 <sys_unlink>:
{
    80004a40:	7151                	addi	sp,sp,-240
    80004a42:	f586                	sd	ra,232(sp)
    80004a44:	f1a2                	sd	s0,224(sp)
    80004a46:	eda6                	sd	s1,216(sp)
    80004a48:	e9ca                	sd	s2,208(sp)
    80004a4a:	e5ce                	sd	s3,200(sp)
    80004a4c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a4e:	08000613          	li	a2,128
    80004a52:	f3040593          	addi	a1,s0,-208
    80004a56:	4501                	li	a0,0
    80004a58:	ffffd097          	auipc	ra,0xffffd
    80004a5c:	62c080e7          	jalr	1580(ra) # 80002084 <argstr>
    80004a60:	18054163          	bltz	a0,80004be2 <sys_unlink+0x1a2>
  begin_op();
    80004a64:	fffff097          	auipc	ra,0xfffff
    80004a68:	bde080e7          	jalr	-1058(ra) # 80003642 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a6c:	fb040593          	addi	a1,s0,-80
    80004a70:	f3040513          	addi	a0,s0,-208
    80004a74:	fffff097          	auipc	ra,0xfffff
    80004a78:	9d0080e7          	jalr	-1584(ra) # 80003444 <nameiparent>
    80004a7c:	84aa                	mv	s1,a0
    80004a7e:	c979                	beqz	a0,80004b54 <sys_unlink+0x114>
  ilock(dp);
    80004a80:	ffffe097          	auipc	ra,0xffffe
    80004a84:	200080e7          	jalr	512(ra) # 80002c80 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a88:	00004597          	auipc	a1,0x4
    80004a8c:	db058593          	addi	a1,a1,-592 # 80008838 <syscalls+0x2a8>
    80004a90:	fb040513          	addi	a0,s0,-80
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	6b6080e7          	jalr	1718(ra) # 8000314a <namecmp>
    80004a9c:	14050a63          	beqz	a0,80004bf0 <sys_unlink+0x1b0>
    80004aa0:	00004597          	auipc	a1,0x4
    80004aa4:	da058593          	addi	a1,a1,-608 # 80008840 <syscalls+0x2b0>
    80004aa8:	fb040513          	addi	a0,s0,-80
    80004aac:	ffffe097          	auipc	ra,0xffffe
    80004ab0:	69e080e7          	jalr	1694(ra) # 8000314a <namecmp>
    80004ab4:	12050e63          	beqz	a0,80004bf0 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004ab8:	f2c40613          	addi	a2,s0,-212
    80004abc:	fb040593          	addi	a1,s0,-80
    80004ac0:	8526                	mv	a0,s1
    80004ac2:	ffffe097          	auipc	ra,0xffffe
    80004ac6:	6a2080e7          	jalr	1698(ra) # 80003164 <dirlookup>
    80004aca:	892a                	mv	s2,a0
    80004acc:	12050263          	beqz	a0,80004bf0 <sys_unlink+0x1b0>
  ilock(ip);
    80004ad0:	ffffe097          	auipc	ra,0xffffe
    80004ad4:	1b0080e7          	jalr	432(ra) # 80002c80 <ilock>
  if(ip->nlink < 1)
    80004ad8:	04a91783          	lh	a5,74(s2)
    80004adc:	08f05263          	blez	a5,80004b60 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ae0:	04491703          	lh	a4,68(s2)
    80004ae4:	4785                	li	a5,1
    80004ae6:	08f70563          	beq	a4,a5,80004b70 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004aea:	4641                	li	a2,16
    80004aec:	4581                	li	a1,0
    80004aee:	fc040513          	addi	a0,s0,-64
    80004af2:	ffffb097          	auipc	ra,0xffffb
    80004af6:	6aa080e7          	jalr	1706(ra) # 8000019c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004afa:	4741                	li	a4,16
    80004afc:	f2c42683          	lw	a3,-212(s0)
    80004b00:	fc040613          	addi	a2,s0,-64
    80004b04:	4581                	li	a1,0
    80004b06:	8526                	mv	a0,s1
    80004b08:	ffffe097          	auipc	ra,0xffffe
    80004b0c:	524080e7          	jalr	1316(ra) # 8000302c <writei>
    80004b10:	47c1                	li	a5,16
    80004b12:	0af51563          	bne	a0,a5,80004bbc <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b16:	04491703          	lh	a4,68(s2)
    80004b1a:	4785                	li	a5,1
    80004b1c:	0af70863          	beq	a4,a5,80004bcc <sys_unlink+0x18c>
  iunlockput(dp);
    80004b20:	8526                	mv	a0,s1
    80004b22:	ffffe097          	auipc	ra,0xffffe
    80004b26:	3c0080e7          	jalr	960(ra) # 80002ee2 <iunlockput>
  ip->nlink--;
    80004b2a:	04a95783          	lhu	a5,74(s2)
    80004b2e:	37fd                	addiw	a5,a5,-1
    80004b30:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b34:	854a                	mv	a0,s2
    80004b36:	ffffe097          	auipc	ra,0xffffe
    80004b3a:	080080e7          	jalr	128(ra) # 80002bb6 <iupdate>
  iunlockput(ip);
    80004b3e:	854a                	mv	a0,s2
    80004b40:	ffffe097          	auipc	ra,0xffffe
    80004b44:	3a2080e7          	jalr	930(ra) # 80002ee2 <iunlockput>
  end_op();
    80004b48:	fffff097          	auipc	ra,0xfffff
    80004b4c:	b7a080e7          	jalr	-1158(ra) # 800036c2 <end_op>
  return 0;
    80004b50:	4501                	li	a0,0
    80004b52:	a84d                	j	80004c04 <sys_unlink+0x1c4>
    end_op();
    80004b54:	fffff097          	auipc	ra,0xfffff
    80004b58:	b6e080e7          	jalr	-1170(ra) # 800036c2 <end_op>
    return -1;
    80004b5c:	557d                	li	a0,-1
    80004b5e:	a05d                	j	80004c04 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b60:	00004517          	auipc	a0,0x4
    80004b64:	ce850513          	addi	a0,a0,-792 # 80008848 <syscalls+0x2b8>
    80004b68:	00001097          	auipc	ra,0x1
    80004b6c:	21a080e7          	jalr	538(ra) # 80005d82 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b70:	04c92703          	lw	a4,76(s2)
    80004b74:	02000793          	li	a5,32
    80004b78:	f6e7f9e3          	bgeu	a5,a4,80004aea <sys_unlink+0xaa>
    80004b7c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b80:	4741                	li	a4,16
    80004b82:	86ce                	mv	a3,s3
    80004b84:	f1840613          	addi	a2,s0,-232
    80004b88:	4581                	li	a1,0
    80004b8a:	854a                	mv	a0,s2
    80004b8c:	ffffe097          	auipc	ra,0xffffe
    80004b90:	3a8080e7          	jalr	936(ra) # 80002f34 <readi>
    80004b94:	47c1                	li	a5,16
    80004b96:	00f51b63          	bne	a0,a5,80004bac <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b9a:	f1845783          	lhu	a5,-232(s0)
    80004b9e:	e7a1                	bnez	a5,80004be6 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ba0:	29c1                	addiw	s3,s3,16
    80004ba2:	04c92783          	lw	a5,76(s2)
    80004ba6:	fcf9ede3          	bltu	s3,a5,80004b80 <sys_unlink+0x140>
    80004baa:	b781                	j	80004aea <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004bac:	00004517          	auipc	a0,0x4
    80004bb0:	cb450513          	addi	a0,a0,-844 # 80008860 <syscalls+0x2d0>
    80004bb4:	00001097          	auipc	ra,0x1
    80004bb8:	1ce080e7          	jalr	462(ra) # 80005d82 <panic>
    panic("unlink: writei");
    80004bbc:	00004517          	auipc	a0,0x4
    80004bc0:	cbc50513          	addi	a0,a0,-836 # 80008878 <syscalls+0x2e8>
    80004bc4:	00001097          	auipc	ra,0x1
    80004bc8:	1be080e7          	jalr	446(ra) # 80005d82 <panic>
    dp->nlink--;
    80004bcc:	04a4d783          	lhu	a5,74(s1)
    80004bd0:	37fd                	addiw	a5,a5,-1
    80004bd2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bd6:	8526                	mv	a0,s1
    80004bd8:	ffffe097          	auipc	ra,0xffffe
    80004bdc:	fde080e7          	jalr	-34(ra) # 80002bb6 <iupdate>
    80004be0:	b781                	j	80004b20 <sys_unlink+0xe0>
    return -1;
    80004be2:	557d                	li	a0,-1
    80004be4:	a005                	j	80004c04 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004be6:	854a                	mv	a0,s2
    80004be8:	ffffe097          	auipc	ra,0xffffe
    80004bec:	2fa080e7          	jalr	762(ra) # 80002ee2 <iunlockput>
  iunlockput(dp);
    80004bf0:	8526                	mv	a0,s1
    80004bf2:	ffffe097          	auipc	ra,0xffffe
    80004bf6:	2f0080e7          	jalr	752(ra) # 80002ee2 <iunlockput>
  end_op();
    80004bfa:	fffff097          	auipc	ra,0xfffff
    80004bfe:	ac8080e7          	jalr	-1336(ra) # 800036c2 <end_op>
  return -1;
    80004c02:	557d                	li	a0,-1
}
    80004c04:	70ae                	ld	ra,232(sp)
    80004c06:	740e                	ld	s0,224(sp)
    80004c08:	64ee                	ld	s1,216(sp)
    80004c0a:	694e                	ld	s2,208(sp)
    80004c0c:	69ae                	ld	s3,200(sp)
    80004c0e:	616d                	addi	sp,sp,240
    80004c10:	8082                	ret

0000000080004c12 <sys_open>:

uint64
sys_open(void)
{
    80004c12:	7131                	addi	sp,sp,-192
    80004c14:	fd06                	sd	ra,184(sp)
    80004c16:	f922                	sd	s0,176(sp)
    80004c18:	f526                	sd	s1,168(sp)
    80004c1a:	f14a                	sd	s2,160(sp)
    80004c1c:	ed4e                	sd	s3,152(sp)
    80004c1e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004c20:	f4c40593          	addi	a1,s0,-180
    80004c24:	4505                	li	a0,1
    80004c26:	ffffd097          	auipc	ra,0xffffd
    80004c2a:	41e080e7          	jalr	1054(ra) # 80002044 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c2e:	08000613          	li	a2,128
    80004c32:	f5040593          	addi	a1,s0,-176
    80004c36:	4501                	li	a0,0
    80004c38:	ffffd097          	auipc	ra,0xffffd
    80004c3c:	44c080e7          	jalr	1100(ra) # 80002084 <argstr>
    80004c40:	87aa                	mv	a5,a0
    return -1;
    80004c42:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c44:	0a07c963          	bltz	a5,80004cf6 <sys_open+0xe4>

  begin_op();
    80004c48:	fffff097          	auipc	ra,0xfffff
    80004c4c:	9fa080e7          	jalr	-1542(ra) # 80003642 <begin_op>

  if(omode & O_CREATE){
    80004c50:	f4c42783          	lw	a5,-180(s0)
    80004c54:	2007f793          	andi	a5,a5,512
    80004c58:	cfc5                	beqz	a5,80004d10 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c5a:	4681                	li	a3,0
    80004c5c:	4601                	li	a2,0
    80004c5e:	4589                	li	a1,2
    80004c60:	f5040513          	addi	a0,s0,-176
    80004c64:	00000097          	auipc	ra,0x0
    80004c68:	974080e7          	jalr	-1676(ra) # 800045d8 <create>
    80004c6c:	84aa                	mv	s1,a0
    if(ip == 0){
    80004c6e:	c959                	beqz	a0,80004d04 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c70:	04449703          	lh	a4,68(s1)
    80004c74:	478d                	li	a5,3
    80004c76:	00f71763          	bne	a4,a5,80004c84 <sys_open+0x72>
    80004c7a:	0464d703          	lhu	a4,70(s1)
    80004c7e:	47a5                	li	a5,9
    80004c80:	0ce7ed63          	bltu	a5,a4,80004d5a <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c84:	fffff097          	auipc	ra,0xfffff
    80004c88:	dce080e7          	jalr	-562(ra) # 80003a52 <filealloc>
    80004c8c:	89aa                	mv	s3,a0
    80004c8e:	10050363          	beqz	a0,80004d94 <sys_open+0x182>
    80004c92:	00000097          	auipc	ra,0x0
    80004c96:	904080e7          	jalr	-1788(ra) # 80004596 <fdalloc>
    80004c9a:	892a                	mv	s2,a0
    80004c9c:	0e054763          	bltz	a0,80004d8a <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ca0:	04449703          	lh	a4,68(s1)
    80004ca4:	478d                	li	a5,3
    80004ca6:	0cf70563          	beq	a4,a5,80004d70 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004caa:	4789                	li	a5,2
    80004cac:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004cb0:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004cb4:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004cb8:	f4c42783          	lw	a5,-180(s0)
    80004cbc:	0017c713          	xori	a4,a5,1
    80004cc0:	8b05                	andi	a4,a4,1
    80004cc2:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cc6:	0037f713          	andi	a4,a5,3
    80004cca:	00e03733          	snez	a4,a4
    80004cce:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cd2:	4007f793          	andi	a5,a5,1024
    80004cd6:	c791                	beqz	a5,80004ce2 <sys_open+0xd0>
    80004cd8:	04449703          	lh	a4,68(s1)
    80004cdc:	4789                	li	a5,2
    80004cde:	0af70063          	beq	a4,a5,80004d7e <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004ce2:	8526                	mv	a0,s1
    80004ce4:	ffffe097          	auipc	ra,0xffffe
    80004ce8:	05e080e7          	jalr	94(ra) # 80002d42 <iunlock>
  end_op();
    80004cec:	fffff097          	auipc	ra,0xfffff
    80004cf0:	9d6080e7          	jalr	-1578(ra) # 800036c2 <end_op>

  return fd;
    80004cf4:	854a                	mv	a0,s2
}
    80004cf6:	70ea                	ld	ra,184(sp)
    80004cf8:	744a                	ld	s0,176(sp)
    80004cfa:	74aa                	ld	s1,168(sp)
    80004cfc:	790a                	ld	s2,160(sp)
    80004cfe:	69ea                	ld	s3,152(sp)
    80004d00:	6129                	addi	sp,sp,192
    80004d02:	8082                	ret
      end_op();
    80004d04:	fffff097          	auipc	ra,0xfffff
    80004d08:	9be080e7          	jalr	-1602(ra) # 800036c2 <end_op>
      return -1;
    80004d0c:	557d                	li	a0,-1
    80004d0e:	b7e5                	j	80004cf6 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d10:	f5040513          	addi	a0,s0,-176
    80004d14:	ffffe097          	auipc	ra,0xffffe
    80004d18:	712080e7          	jalr	1810(ra) # 80003426 <namei>
    80004d1c:	84aa                	mv	s1,a0
    80004d1e:	c905                	beqz	a0,80004d4e <sys_open+0x13c>
    ilock(ip);
    80004d20:	ffffe097          	auipc	ra,0xffffe
    80004d24:	f60080e7          	jalr	-160(ra) # 80002c80 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d28:	04449703          	lh	a4,68(s1)
    80004d2c:	4785                	li	a5,1
    80004d2e:	f4f711e3          	bne	a4,a5,80004c70 <sys_open+0x5e>
    80004d32:	f4c42783          	lw	a5,-180(s0)
    80004d36:	d7b9                	beqz	a5,80004c84 <sys_open+0x72>
      iunlockput(ip);
    80004d38:	8526                	mv	a0,s1
    80004d3a:	ffffe097          	auipc	ra,0xffffe
    80004d3e:	1a8080e7          	jalr	424(ra) # 80002ee2 <iunlockput>
      end_op();
    80004d42:	fffff097          	auipc	ra,0xfffff
    80004d46:	980080e7          	jalr	-1664(ra) # 800036c2 <end_op>
      return -1;
    80004d4a:	557d                	li	a0,-1
    80004d4c:	b76d                	j	80004cf6 <sys_open+0xe4>
      end_op();
    80004d4e:	fffff097          	auipc	ra,0xfffff
    80004d52:	974080e7          	jalr	-1676(ra) # 800036c2 <end_op>
      return -1;
    80004d56:	557d                	li	a0,-1
    80004d58:	bf79                	j	80004cf6 <sys_open+0xe4>
    iunlockput(ip);
    80004d5a:	8526                	mv	a0,s1
    80004d5c:	ffffe097          	auipc	ra,0xffffe
    80004d60:	186080e7          	jalr	390(ra) # 80002ee2 <iunlockput>
    end_op();
    80004d64:	fffff097          	auipc	ra,0xfffff
    80004d68:	95e080e7          	jalr	-1698(ra) # 800036c2 <end_op>
    return -1;
    80004d6c:	557d                	li	a0,-1
    80004d6e:	b761                	j	80004cf6 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004d70:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d74:	04649783          	lh	a5,70(s1)
    80004d78:	02f99223          	sh	a5,36(s3)
    80004d7c:	bf25                	j	80004cb4 <sys_open+0xa2>
    itrunc(ip);
    80004d7e:	8526                	mv	a0,s1
    80004d80:	ffffe097          	auipc	ra,0xffffe
    80004d84:	00e080e7          	jalr	14(ra) # 80002d8e <itrunc>
    80004d88:	bfa9                	j	80004ce2 <sys_open+0xd0>
      fileclose(f);
    80004d8a:	854e                	mv	a0,s3
    80004d8c:	fffff097          	auipc	ra,0xfffff
    80004d90:	d82080e7          	jalr	-638(ra) # 80003b0e <fileclose>
    iunlockput(ip);
    80004d94:	8526                	mv	a0,s1
    80004d96:	ffffe097          	auipc	ra,0xffffe
    80004d9a:	14c080e7          	jalr	332(ra) # 80002ee2 <iunlockput>
    end_op();
    80004d9e:	fffff097          	auipc	ra,0xfffff
    80004da2:	924080e7          	jalr	-1756(ra) # 800036c2 <end_op>
    return -1;
    80004da6:	557d                	li	a0,-1
    80004da8:	b7b9                	j	80004cf6 <sys_open+0xe4>

0000000080004daa <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004daa:	7175                	addi	sp,sp,-144
    80004dac:	e506                	sd	ra,136(sp)
    80004dae:	e122                	sd	s0,128(sp)
    80004db0:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004db2:	fffff097          	auipc	ra,0xfffff
    80004db6:	890080e7          	jalr	-1904(ra) # 80003642 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004dba:	08000613          	li	a2,128
    80004dbe:	f7040593          	addi	a1,s0,-144
    80004dc2:	4501                	li	a0,0
    80004dc4:	ffffd097          	auipc	ra,0xffffd
    80004dc8:	2c0080e7          	jalr	704(ra) # 80002084 <argstr>
    80004dcc:	02054963          	bltz	a0,80004dfe <sys_mkdir+0x54>
    80004dd0:	4681                	li	a3,0
    80004dd2:	4601                	li	a2,0
    80004dd4:	4585                	li	a1,1
    80004dd6:	f7040513          	addi	a0,s0,-144
    80004dda:	fffff097          	auipc	ra,0xfffff
    80004dde:	7fe080e7          	jalr	2046(ra) # 800045d8 <create>
    80004de2:	cd11                	beqz	a0,80004dfe <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004de4:	ffffe097          	auipc	ra,0xffffe
    80004de8:	0fe080e7          	jalr	254(ra) # 80002ee2 <iunlockput>
  end_op();
    80004dec:	fffff097          	auipc	ra,0xfffff
    80004df0:	8d6080e7          	jalr	-1834(ra) # 800036c2 <end_op>
  return 0;
    80004df4:	4501                	li	a0,0
}
    80004df6:	60aa                	ld	ra,136(sp)
    80004df8:	640a                	ld	s0,128(sp)
    80004dfa:	6149                	addi	sp,sp,144
    80004dfc:	8082                	ret
    end_op();
    80004dfe:	fffff097          	auipc	ra,0xfffff
    80004e02:	8c4080e7          	jalr	-1852(ra) # 800036c2 <end_op>
    return -1;
    80004e06:	557d                	li	a0,-1
    80004e08:	b7fd                	j	80004df6 <sys_mkdir+0x4c>

0000000080004e0a <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e0a:	7135                	addi	sp,sp,-160
    80004e0c:	ed06                	sd	ra,152(sp)
    80004e0e:	e922                	sd	s0,144(sp)
    80004e10:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e12:	fffff097          	auipc	ra,0xfffff
    80004e16:	830080e7          	jalr	-2000(ra) # 80003642 <begin_op>
  argint(1, &major);
    80004e1a:	f6c40593          	addi	a1,s0,-148
    80004e1e:	4505                	li	a0,1
    80004e20:	ffffd097          	auipc	ra,0xffffd
    80004e24:	224080e7          	jalr	548(ra) # 80002044 <argint>
  argint(2, &minor);
    80004e28:	f6840593          	addi	a1,s0,-152
    80004e2c:	4509                	li	a0,2
    80004e2e:	ffffd097          	auipc	ra,0xffffd
    80004e32:	216080e7          	jalr	534(ra) # 80002044 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e36:	08000613          	li	a2,128
    80004e3a:	f7040593          	addi	a1,s0,-144
    80004e3e:	4501                	li	a0,0
    80004e40:	ffffd097          	auipc	ra,0xffffd
    80004e44:	244080e7          	jalr	580(ra) # 80002084 <argstr>
    80004e48:	02054b63          	bltz	a0,80004e7e <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e4c:	f6841683          	lh	a3,-152(s0)
    80004e50:	f6c41603          	lh	a2,-148(s0)
    80004e54:	458d                	li	a1,3
    80004e56:	f7040513          	addi	a0,s0,-144
    80004e5a:	fffff097          	auipc	ra,0xfffff
    80004e5e:	77e080e7          	jalr	1918(ra) # 800045d8 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e62:	cd11                	beqz	a0,80004e7e <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e64:	ffffe097          	auipc	ra,0xffffe
    80004e68:	07e080e7          	jalr	126(ra) # 80002ee2 <iunlockput>
  end_op();
    80004e6c:	fffff097          	auipc	ra,0xfffff
    80004e70:	856080e7          	jalr	-1962(ra) # 800036c2 <end_op>
  return 0;
    80004e74:	4501                	li	a0,0
}
    80004e76:	60ea                	ld	ra,152(sp)
    80004e78:	644a                	ld	s0,144(sp)
    80004e7a:	610d                	addi	sp,sp,160
    80004e7c:	8082                	ret
    end_op();
    80004e7e:	fffff097          	auipc	ra,0xfffff
    80004e82:	844080e7          	jalr	-1980(ra) # 800036c2 <end_op>
    return -1;
    80004e86:	557d                	li	a0,-1
    80004e88:	b7fd                	j	80004e76 <sys_mknod+0x6c>

0000000080004e8a <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e8a:	7135                	addi	sp,sp,-160
    80004e8c:	ed06                	sd	ra,152(sp)
    80004e8e:	e922                	sd	s0,144(sp)
    80004e90:	e526                	sd	s1,136(sp)
    80004e92:	e14a                	sd	s2,128(sp)
    80004e94:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e96:	ffffc097          	auipc	ra,0xffffc
    80004e9a:	03e080e7          	jalr	62(ra) # 80000ed4 <myproc>
    80004e9e:	892a                	mv	s2,a0
  
  begin_op();
    80004ea0:	ffffe097          	auipc	ra,0xffffe
    80004ea4:	7a2080e7          	jalr	1954(ra) # 80003642 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ea8:	08000613          	li	a2,128
    80004eac:	f6040593          	addi	a1,s0,-160
    80004eb0:	4501                	li	a0,0
    80004eb2:	ffffd097          	auipc	ra,0xffffd
    80004eb6:	1d2080e7          	jalr	466(ra) # 80002084 <argstr>
    80004eba:	04054b63          	bltz	a0,80004f10 <sys_chdir+0x86>
    80004ebe:	f6040513          	addi	a0,s0,-160
    80004ec2:	ffffe097          	auipc	ra,0xffffe
    80004ec6:	564080e7          	jalr	1380(ra) # 80003426 <namei>
    80004eca:	84aa                	mv	s1,a0
    80004ecc:	c131                	beqz	a0,80004f10 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ece:	ffffe097          	auipc	ra,0xffffe
    80004ed2:	db2080e7          	jalr	-590(ra) # 80002c80 <ilock>
  if(ip->type != T_DIR){
    80004ed6:	04449703          	lh	a4,68(s1)
    80004eda:	4785                	li	a5,1
    80004edc:	04f71063          	bne	a4,a5,80004f1c <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004ee0:	8526                	mv	a0,s1
    80004ee2:	ffffe097          	auipc	ra,0xffffe
    80004ee6:	e60080e7          	jalr	-416(ra) # 80002d42 <iunlock>
  iput(p->cwd);
    80004eea:	15093503          	ld	a0,336(s2)
    80004eee:	ffffe097          	auipc	ra,0xffffe
    80004ef2:	f4c080e7          	jalr	-180(ra) # 80002e3a <iput>
  end_op();
    80004ef6:	ffffe097          	auipc	ra,0xffffe
    80004efa:	7cc080e7          	jalr	1996(ra) # 800036c2 <end_op>
  p->cwd = ip;
    80004efe:	14993823          	sd	s1,336(s2)
  return 0;
    80004f02:	4501                	li	a0,0
}
    80004f04:	60ea                	ld	ra,152(sp)
    80004f06:	644a                	ld	s0,144(sp)
    80004f08:	64aa                	ld	s1,136(sp)
    80004f0a:	690a                	ld	s2,128(sp)
    80004f0c:	610d                	addi	sp,sp,160
    80004f0e:	8082                	ret
    end_op();
    80004f10:	ffffe097          	auipc	ra,0xffffe
    80004f14:	7b2080e7          	jalr	1970(ra) # 800036c2 <end_op>
    return -1;
    80004f18:	557d                	li	a0,-1
    80004f1a:	b7ed                	j	80004f04 <sys_chdir+0x7a>
    iunlockput(ip);
    80004f1c:	8526                	mv	a0,s1
    80004f1e:	ffffe097          	auipc	ra,0xffffe
    80004f22:	fc4080e7          	jalr	-60(ra) # 80002ee2 <iunlockput>
    end_op();
    80004f26:	ffffe097          	auipc	ra,0xffffe
    80004f2a:	79c080e7          	jalr	1948(ra) # 800036c2 <end_op>
    return -1;
    80004f2e:	557d                	li	a0,-1
    80004f30:	bfd1                	j	80004f04 <sys_chdir+0x7a>

0000000080004f32 <sys_exec>:

uint64
sys_exec(void)
{
    80004f32:	7145                	addi	sp,sp,-464
    80004f34:	e786                	sd	ra,456(sp)
    80004f36:	e3a2                	sd	s0,448(sp)
    80004f38:	ff26                	sd	s1,440(sp)
    80004f3a:	fb4a                	sd	s2,432(sp)
    80004f3c:	f74e                	sd	s3,424(sp)
    80004f3e:	f352                	sd	s4,416(sp)
    80004f40:	ef56                	sd	s5,408(sp)
    80004f42:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004f44:	e3840593          	addi	a1,s0,-456
    80004f48:	4505                	li	a0,1
    80004f4a:	ffffd097          	auipc	ra,0xffffd
    80004f4e:	11a080e7          	jalr	282(ra) # 80002064 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004f52:	08000613          	li	a2,128
    80004f56:	f4040593          	addi	a1,s0,-192
    80004f5a:	4501                	li	a0,0
    80004f5c:	ffffd097          	auipc	ra,0xffffd
    80004f60:	128080e7          	jalr	296(ra) # 80002084 <argstr>
    80004f64:	87aa                	mv	a5,a0
    return -1;
    80004f66:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004f68:	0c07c263          	bltz	a5,8000502c <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004f6c:	10000613          	li	a2,256
    80004f70:	4581                	li	a1,0
    80004f72:	e4040513          	addi	a0,s0,-448
    80004f76:	ffffb097          	auipc	ra,0xffffb
    80004f7a:	226080e7          	jalr	550(ra) # 8000019c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f7e:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f82:	89a6                	mv	s3,s1
    80004f84:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f86:	02000a13          	li	s4,32
    80004f8a:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f8e:	00391513          	slli	a0,s2,0x3
    80004f92:	e3040593          	addi	a1,s0,-464
    80004f96:	e3843783          	ld	a5,-456(s0)
    80004f9a:	953e                	add	a0,a0,a5
    80004f9c:	ffffd097          	auipc	ra,0xffffd
    80004fa0:	00a080e7          	jalr	10(ra) # 80001fa6 <fetchaddr>
    80004fa4:	02054a63          	bltz	a0,80004fd8 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004fa8:	e3043783          	ld	a5,-464(s0)
    80004fac:	c3b9                	beqz	a5,80004ff2 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004fae:	ffffb097          	auipc	ra,0xffffb
    80004fb2:	16a080e7          	jalr	362(ra) # 80000118 <kalloc>
    80004fb6:	85aa                	mv	a1,a0
    80004fb8:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004fbc:	cd11                	beqz	a0,80004fd8 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fbe:	6605                	lui	a2,0x1
    80004fc0:	e3043503          	ld	a0,-464(s0)
    80004fc4:	ffffd097          	auipc	ra,0xffffd
    80004fc8:	034080e7          	jalr	52(ra) # 80001ff8 <fetchstr>
    80004fcc:	00054663          	bltz	a0,80004fd8 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004fd0:	0905                	addi	s2,s2,1
    80004fd2:	09a1                	addi	s3,s3,8
    80004fd4:	fb491be3          	bne	s2,s4,80004f8a <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fd8:	10048913          	addi	s2,s1,256
    80004fdc:	6088                	ld	a0,0(s1)
    80004fde:	c531                	beqz	a0,8000502a <sys_exec+0xf8>
    kfree(argv[i]);
    80004fe0:	ffffb097          	auipc	ra,0xffffb
    80004fe4:	03c080e7          	jalr	60(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fe8:	04a1                	addi	s1,s1,8
    80004fea:	ff2499e3          	bne	s1,s2,80004fdc <sys_exec+0xaa>
  return -1;
    80004fee:	557d                	li	a0,-1
    80004ff0:	a835                	j	8000502c <sys_exec+0xfa>
      argv[i] = 0;
    80004ff2:	0a8e                	slli	s5,s5,0x3
    80004ff4:	fc040793          	addi	a5,s0,-64
    80004ff8:	9abe                	add	s5,s5,a5
    80004ffa:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004ffe:	e4040593          	addi	a1,s0,-448
    80005002:	f4040513          	addi	a0,s0,-192
    80005006:	fffff097          	auipc	ra,0xfffff
    8000500a:	190080e7          	jalr	400(ra) # 80004196 <exec>
    8000500e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005010:	10048993          	addi	s3,s1,256
    80005014:	6088                	ld	a0,0(s1)
    80005016:	c901                	beqz	a0,80005026 <sys_exec+0xf4>
    kfree(argv[i]);
    80005018:	ffffb097          	auipc	ra,0xffffb
    8000501c:	004080e7          	jalr	4(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005020:	04a1                	addi	s1,s1,8
    80005022:	ff3499e3          	bne	s1,s3,80005014 <sys_exec+0xe2>
  return ret;
    80005026:	854a                	mv	a0,s2
    80005028:	a011                	j	8000502c <sys_exec+0xfa>
  return -1;
    8000502a:	557d                	li	a0,-1
}
    8000502c:	60be                	ld	ra,456(sp)
    8000502e:	641e                	ld	s0,448(sp)
    80005030:	74fa                	ld	s1,440(sp)
    80005032:	795a                	ld	s2,432(sp)
    80005034:	79ba                	ld	s3,424(sp)
    80005036:	7a1a                	ld	s4,416(sp)
    80005038:	6afa                	ld	s5,408(sp)
    8000503a:	6179                	addi	sp,sp,464
    8000503c:	8082                	ret

000000008000503e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000503e:	7139                	addi	sp,sp,-64
    80005040:	fc06                	sd	ra,56(sp)
    80005042:	f822                	sd	s0,48(sp)
    80005044:	f426                	sd	s1,40(sp)
    80005046:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005048:	ffffc097          	auipc	ra,0xffffc
    8000504c:	e8c080e7          	jalr	-372(ra) # 80000ed4 <myproc>
    80005050:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005052:	fd840593          	addi	a1,s0,-40
    80005056:	4501                	li	a0,0
    80005058:	ffffd097          	auipc	ra,0xffffd
    8000505c:	00c080e7          	jalr	12(ra) # 80002064 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005060:	fc840593          	addi	a1,s0,-56
    80005064:	fd040513          	addi	a0,s0,-48
    80005068:	fffff097          	auipc	ra,0xfffff
    8000506c:	dd6080e7          	jalr	-554(ra) # 80003e3e <pipealloc>
    return -1;
    80005070:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005072:	0c054463          	bltz	a0,8000513a <sys_pipe+0xfc>
  fd0 = -1;
    80005076:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000507a:	fd043503          	ld	a0,-48(s0)
    8000507e:	fffff097          	auipc	ra,0xfffff
    80005082:	518080e7          	jalr	1304(ra) # 80004596 <fdalloc>
    80005086:	fca42223          	sw	a0,-60(s0)
    8000508a:	08054b63          	bltz	a0,80005120 <sys_pipe+0xe2>
    8000508e:	fc843503          	ld	a0,-56(s0)
    80005092:	fffff097          	auipc	ra,0xfffff
    80005096:	504080e7          	jalr	1284(ra) # 80004596 <fdalloc>
    8000509a:	fca42023          	sw	a0,-64(s0)
    8000509e:	06054863          	bltz	a0,8000510e <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050a2:	4691                	li	a3,4
    800050a4:	fc440613          	addi	a2,s0,-60
    800050a8:	fd843583          	ld	a1,-40(s0)
    800050ac:	68a8                	ld	a0,80(s1)
    800050ae:	ffffc097          	auipc	ra,0xffffc
    800050b2:	ab0080e7          	jalr	-1360(ra) # 80000b5e <copyout>
    800050b6:	02054063          	bltz	a0,800050d6 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800050ba:	4691                	li	a3,4
    800050bc:	fc040613          	addi	a2,s0,-64
    800050c0:	fd843583          	ld	a1,-40(s0)
    800050c4:	0591                	addi	a1,a1,4
    800050c6:	68a8                	ld	a0,80(s1)
    800050c8:	ffffc097          	auipc	ra,0xffffc
    800050cc:	a96080e7          	jalr	-1386(ra) # 80000b5e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050d0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050d2:	06055463          	bgez	a0,8000513a <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800050d6:	fc442783          	lw	a5,-60(s0)
    800050da:	07e9                	addi	a5,a5,26
    800050dc:	078e                	slli	a5,a5,0x3
    800050de:	97a6                	add	a5,a5,s1
    800050e0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800050e4:	fc042503          	lw	a0,-64(s0)
    800050e8:	0569                	addi	a0,a0,26
    800050ea:	050e                	slli	a0,a0,0x3
    800050ec:	94aa                	add	s1,s1,a0
    800050ee:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800050f2:	fd043503          	ld	a0,-48(s0)
    800050f6:	fffff097          	auipc	ra,0xfffff
    800050fa:	a18080e7          	jalr	-1512(ra) # 80003b0e <fileclose>
    fileclose(wf);
    800050fe:	fc843503          	ld	a0,-56(s0)
    80005102:	fffff097          	auipc	ra,0xfffff
    80005106:	a0c080e7          	jalr	-1524(ra) # 80003b0e <fileclose>
    return -1;
    8000510a:	57fd                	li	a5,-1
    8000510c:	a03d                	j	8000513a <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000510e:	fc442783          	lw	a5,-60(s0)
    80005112:	0007c763          	bltz	a5,80005120 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005116:	07e9                	addi	a5,a5,26
    80005118:	078e                	slli	a5,a5,0x3
    8000511a:	94be                	add	s1,s1,a5
    8000511c:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005120:	fd043503          	ld	a0,-48(s0)
    80005124:	fffff097          	auipc	ra,0xfffff
    80005128:	9ea080e7          	jalr	-1558(ra) # 80003b0e <fileclose>
    fileclose(wf);
    8000512c:	fc843503          	ld	a0,-56(s0)
    80005130:	fffff097          	auipc	ra,0xfffff
    80005134:	9de080e7          	jalr	-1570(ra) # 80003b0e <fileclose>
    return -1;
    80005138:	57fd                	li	a5,-1
}
    8000513a:	853e                	mv	a0,a5
    8000513c:	70e2                	ld	ra,56(sp)
    8000513e:	7442                	ld	s0,48(sp)
    80005140:	74a2                	ld	s1,40(sp)
    80005142:	6121                	addi	sp,sp,64
    80005144:	8082                	ret
	...

0000000080005150 <kernelvec>:
    80005150:	7111                	addi	sp,sp,-256
    80005152:	e006                	sd	ra,0(sp)
    80005154:	e40a                	sd	sp,8(sp)
    80005156:	e80e                	sd	gp,16(sp)
    80005158:	ec12                	sd	tp,24(sp)
    8000515a:	f016                	sd	t0,32(sp)
    8000515c:	f41a                	sd	t1,40(sp)
    8000515e:	f81e                	sd	t2,48(sp)
    80005160:	fc22                	sd	s0,56(sp)
    80005162:	e0a6                	sd	s1,64(sp)
    80005164:	e4aa                	sd	a0,72(sp)
    80005166:	e8ae                	sd	a1,80(sp)
    80005168:	ecb2                	sd	a2,88(sp)
    8000516a:	f0b6                	sd	a3,96(sp)
    8000516c:	f4ba                	sd	a4,104(sp)
    8000516e:	f8be                	sd	a5,112(sp)
    80005170:	fcc2                	sd	a6,120(sp)
    80005172:	e146                	sd	a7,128(sp)
    80005174:	e54a                	sd	s2,136(sp)
    80005176:	e94e                	sd	s3,144(sp)
    80005178:	ed52                	sd	s4,152(sp)
    8000517a:	f156                	sd	s5,160(sp)
    8000517c:	f55a                	sd	s6,168(sp)
    8000517e:	f95e                	sd	s7,176(sp)
    80005180:	fd62                	sd	s8,184(sp)
    80005182:	e1e6                	sd	s9,192(sp)
    80005184:	e5ea                	sd	s10,200(sp)
    80005186:	e9ee                	sd	s11,208(sp)
    80005188:	edf2                	sd	t3,216(sp)
    8000518a:	f1f6                	sd	t4,224(sp)
    8000518c:	f5fa                	sd	t5,232(sp)
    8000518e:	f9fe                	sd	t6,240(sp)
    80005190:	ce3fc0ef          	jal	ra,80001e72 <kerneltrap>
    80005194:	6082                	ld	ra,0(sp)
    80005196:	6122                	ld	sp,8(sp)
    80005198:	61c2                	ld	gp,16(sp)
    8000519a:	7282                	ld	t0,32(sp)
    8000519c:	7322                	ld	t1,40(sp)
    8000519e:	73c2                	ld	t2,48(sp)
    800051a0:	7462                	ld	s0,56(sp)
    800051a2:	6486                	ld	s1,64(sp)
    800051a4:	6526                	ld	a0,72(sp)
    800051a6:	65c6                	ld	a1,80(sp)
    800051a8:	6666                	ld	a2,88(sp)
    800051aa:	7686                	ld	a3,96(sp)
    800051ac:	7726                	ld	a4,104(sp)
    800051ae:	77c6                	ld	a5,112(sp)
    800051b0:	7866                	ld	a6,120(sp)
    800051b2:	688a                	ld	a7,128(sp)
    800051b4:	692a                	ld	s2,136(sp)
    800051b6:	69ca                	ld	s3,144(sp)
    800051b8:	6a6a                	ld	s4,152(sp)
    800051ba:	7a8a                	ld	s5,160(sp)
    800051bc:	7b2a                	ld	s6,168(sp)
    800051be:	7bca                	ld	s7,176(sp)
    800051c0:	7c6a                	ld	s8,184(sp)
    800051c2:	6c8e                	ld	s9,192(sp)
    800051c4:	6d2e                	ld	s10,200(sp)
    800051c6:	6dce                	ld	s11,208(sp)
    800051c8:	6e6e                	ld	t3,216(sp)
    800051ca:	7e8e                	ld	t4,224(sp)
    800051cc:	7f2e                	ld	t5,232(sp)
    800051ce:	7fce                	ld	t6,240(sp)
    800051d0:	6111                	addi	sp,sp,256
    800051d2:	10200073          	sret
    800051d6:	00000013          	nop
    800051da:	00000013          	nop
    800051de:	0001                	nop

00000000800051e0 <timervec>:
    800051e0:	34051573          	csrrw	a0,mscratch,a0
    800051e4:	e10c                	sd	a1,0(a0)
    800051e6:	e510                	sd	a2,8(a0)
    800051e8:	e914                	sd	a3,16(a0)
    800051ea:	6d0c                	ld	a1,24(a0)
    800051ec:	7110                	ld	a2,32(a0)
    800051ee:	6194                	ld	a3,0(a1)
    800051f0:	96b2                	add	a3,a3,a2
    800051f2:	e194                	sd	a3,0(a1)
    800051f4:	4589                	li	a1,2
    800051f6:	14459073          	csrw	sip,a1
    800051fa:	6914                	ld	a3,16(a0)
    800051fc:	6510                	ld	a2,8(a0)
    800051fe:	610c                	ld	a1,0(a0)
    80005200:	34051573          	csrrw	a0,mscratch,a0
    80005204:	30200073          	mret
	...

000000008000520a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000520a:	1141                	addi	sp,sp,-16
    8000520c:	e422                	sd	s0,8(sp)
    8000520e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005210:	0c0007b7          	lui	a5,0xc000
    80005214:	4705                	li	a4,1
    80005216:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005218:	c3d8                	sw	a4,4(a5)
}
    8000521a:	6422                	ld	s0,8(sp)
    8000521c:	0141                	addi	sp,sp,16
    8000521e:	8082                	ret

0000000080005220 <plicinithart>:

void
plicinithart(void)
{
    80005220:	1141                	addi	sp,sp,-16
    80005222:	e406                	sd	ra,8(sp)
    80005224:	e022                	sd	s0,0(sp)
    80005226:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005228:	ffffc097          	auipc	ra,0xffffc
    8000522c:	c80080e7          	jalr	-896(ra) # 80000ea8 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005230:	0085171b          	slliw	a4,a0,0x8
    80005234:	0c0027b7          	lui	a5,0xc002
    80005238:	97ba                	add	a5,a5,a4
    8000523a:	40200713          	li	a4,1026
    8000523e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005242:	00d5151b          	slliw	a0,a0,0xd
    80005246:	0c2017b7          	lui	a5,0xc201
    8000524a:	953e                	add	a0,a0,a5
    8000524c:	00052023          	sw	zero,0(a0)
}
    80005250:	60a2                	ld	ra,8(sp)
    80005252:	6402                	ld	s0,0(sp)
    80005254:	0141                	addi	sp,sp,16
    80005256:	8082                	ret

0000000080005258 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005258:	1141                	addi	sp,sp,-16
    8000525a:	e406                	sd	ra,8(sp)
    8000525c:	e022                	sd	s0,0(sp)
    8000525e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005260:	ffffc097          	auipc	ra,0xffffc
    80005264:	c48080e7          	jalr	-952(ra) # 80000ea8 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005268:	00d5179b          	slliw	a5,a0,0xd
    8000526c:	0c201537          	lui	a0,0xc201
    80005270:	953e                	add	a0,a0,a5
  return irq;
}
    80005272:	4148                	lw	a0,4(a0)
    80005274:	60a2                	ld	ra,8(sp)
    80005276:	6402                	ld	s0,0(sp)
    80005278:	0141                	addi	sp,sp,16
    8000527a:	8082                	ret

000000008000527c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000527c:	1101                	addi	sp,sp,-32
    8000527e:	ec06                	sd	ra,24(sp)
    80005280:	e822                	sd	s0,16(sp)
    80005282:	e426                	sd	s1,8(sp)
    80005284:	1000                	addi	s0,sp,32
    80005286:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005288:	ffffc097          	auipc	ra,0xffffc
    8000528c:	c20080e7          	jalr	-992(ra) # 80000ea8 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005290:	00d5151b          	slliw	a0,a0,0xd
    80005294:	0c2017b7          	lui	a5,0xc201
    80005298:	97aa                	add	a5,a5,a0
    8000529a:	c3c4                	sw	s1,4(a5)
}
    8000529c:	60e2                	ld	ra,24(sp)
    8000529e:	6442                	ld	s0,16(sp)
    800052a0:	64a2                	ld	s1,8(sp)
    800052a2:	6105                	addi	sp,sp,32
    800052a4:	8082                	ret

00000000800052a6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052a6:	1141                	addi	sp,sp,-16
    800052a8:	e406                	sd	ra,8(sp)
    800052aa:	e022                	sd	s0,0(sp)
    800052ac:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800052ae:	479d                	li	a5,7
    800052b0:	04a7cc63          	blt	a5,a0,80005308 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800052b4:	00015797          	auipc	a5,0x15
    800052b8:	b8c78793          	addi	a5,a5,-1140 # 80019e40 <disk>
    800052bc:	97aa                	add	a5,a5,a0
    800052be:	0187c783          	lbu	a5,24(a5)
    800052c2:	ebb9                	bnez	a5,80005318 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800052c4:	00451613          	slli	a2,a0,0x4
    800052c8:	00015797          	auipc	a5,0x15
    800052cc:	b7878793          	addi	a5,a5,-1160 # 80019e40 <disk>
    800052d0:	6394                	ld	a3,0(a5)
    800052d2:	96b2                	add	a3,a3,a2
    800052d4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800052d8:	6398                	ld	a4,0(a5)
    800052da:	9732                	add	a4,a4,a2
    800052dc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800052e0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800052e4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800052e8:	953e                	add	a0,a0,a5
    800052ea:	4785                	li	a5,1
    800052ec:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800052f0:	00015517          	auipc	a0,0x15
    800052f4:	b6850513          	addi	a0,a0,-1176 # 80019e58 <disk+0x18>
    800052f8:	ffffc097          	auipc	ra,0xffffc
    800052fc:	2f0080e7          	jalr	752(ra) # 800015e8 <wakeup>
}
    80005300:	60a2                	ld	ra,8(sp)
    80005302:	6402                	ld	s0,0(sp)
    80005304:	0141                	addi	sp,sp,16
    80005306:	8082                	ret
    panic("free_desc 1");
    80005308:	00003517          	auipc	a0,0x3
    8000530c:	58050513          	addi	a0,a0,1408 # 80008888 <syscalls+0x2f8>
    80005310:	00001097          	auipc	ra,0x1
    80005314:	a72080e7          	jalr	-1422(ra) # 80005d82 <panic>
    panic("free_desc 2");
    80005318:	00003517          	auipc	a0,0x3
    8000531c:	58050513          	addi	a0,a0,1408 # 80008898 <syscalls+0x308>
    80005320:	00001097          	auipc	ra,0x1
    80005324:	a62080e7          	jalr	-1438(ra) # 80005d82 <panic>

0000000080005328 <virtio_disk_init>:
{
    80005328:	1101                	addi	sp,sp,-32
    8000532a:	ec06                	sd	ra,24(sp)
    8000532c:	e822                	sd	s0,16(sp)
    8000532e:	e426                	sd	s1,8(sp)
    80005330:	e04a                	sd	s2,0(sp)
    80005332:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005334:	00003597          	auipc	a1,0x3
    80005338:	57458593          	addi	a1,a1,1396 # 800088a8 <syscalls+0x318>
    8000533c:	00015517          	auipc	a0,0x15
    80005340:	c2c50513          	addi	a0,a0,-980 # 80019f68 <disk+0x128>
    80005344:	00001097          	auipc	ra,0x1
    80005348:	ef8080e7          	jalr	-264(ra) # 8000623c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000534c:	100017b7          	lui	a5,0x10001
    80005350:	4398                	lw	a4,0(a5)
    80005352:	2701                	sext.w	a4,a4
    80005354:	747277b7          	lui	a5,0x74727
    80005358:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000535c:	14f71e63          	bne	a4,a5,800054b8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005360:	100017b7          	lui	a5,0x10001
    80005364:	43dc                	lw	a5,4(a5)
    80005366:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005368:	4709                	li	a4,2
    8000536a:	14e79763          	bne	a5,a4,800054b8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000536e:	100017b7          	lui	a5,0x10001
    80005372:	479c                	lw	a5,8(a5)
    80005374:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005376:	14e79163          	bne	a5,a4,800054b8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000537a:	100017b7          	lui	a5,0x10001
    8000537e:	47d8                	lw	a4,12(a5)
    80005380:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005382:	554d47b7          	lui	a5,0x554d4
    80005386:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000538a:	12f71763          	bne	a4,a5,800054b8 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000538e:	100017b7          	lui	a5,0x10001
    80005392:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005396:	4705                	li	a4,1
    80005398:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000539a:	470d                	li	a4,3
    8000539c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000539e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800053a0:	c7ffe737          	lui	a4,0xc7ffe
    800053a4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc59f>
    800053a8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800053aa:	2701                	sext.w	a4,a4
    800053ac:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053ae:	472d                	li	a4,11
    800053b0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800053b2:	0707a903          	lw	s2,112(a5)
    800053b6:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800053b8:	00897793          	andi	a5,s2,8
    800053bc:	10078663          	beqz	a5,800054c8 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800053c0:	100017b7          	lui	a5,0x10001
    800053c4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800053c8:	43fc                	lw	a5,68(a5)
    800053ca:	2781                	sext.w	a5,a5
    800053cc:	10079663          	bnez	a5,800054d8 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800053d0:	100017b7          	lui	a5,0x10001
    800053d4:	5bdc                	lw	a5,52(a5)
    800053d6:	2781                	sext.w	a5,a5
  if(max == 0)
    800053d8:	10078863          	beqz	a5,800054e8 <virtio_disk_init+0x1c0>
  if(max < NUM)
    800053dc:	471d                	li	a4,7
    800053de:	10f77d63          	bgeu	a4,a5,800054f8 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    800053e2:	ffffb097          	auipc	ra,0xffffb
    800053e6:	d36080e7          	jalr	-714(ra) # 80000118 <kalloc>
    800053ea:	00015497          	auipc	s1,0x15
    800053ee:	a5648493          	addi	s1,s1,-1450 # 80019e40 <disk>
    800053f2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800053f4:	ffffb097          	auipc	ra,0xffffb
    800053f8:	d24080e7          	jalr	-732(ra) # 80000118 <kalloc>
    800053fc:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800053fe:	ffffb097          	auipc	ra,0xffffb
    80005402:	d1a080e7          	jalr	-742(ra) # 80000118 <kalloc>
    80005406:	87aa                	mv	a5,a0
    80005408:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    8000540a:	6088                	ld	a0,0(s1)
    8000540c:	cd75                	beqz	a0,80005508 <virtio_disk_init+0x1e0>
    8000540e:	00015717          	auipc	a4,0x15
    80005412:	a3a73703          	ld	a4,-1478(a4) # 80019e48 <disk+0x8>
    80005416:	cb6d                	beqz	a4,80005508 <virtio_disk_init+0x1e0>
    80005418:	cbe5                	beqz	a5,80005508 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    8000541a:	6605                	lui	a2,0x1
    8000541c:	4581                	li	a1,0
    8000541e:	ffffb097          	auipc	ra,0xffffb
    80005422:	d7e080e7          	jalr	-642(ra) # 8000019c <memset>
  memset(disk.avail, 0, PGSIZE);
    80005426:	00015497          	auipc	s1,0x15
    8000542a:	a1a48493          	addi	s1,s1,-1510 # 80019e40 <disk>
    8000542e:	6605                	lui	a2,0x1
    80005430:	4581                	li	a1,0
    80005432:	6488                	ld	a0,8(s1)
    80005434:	ffffb097          	auipc	ra,0xffffb
    80005438:	d68080e7          	jalr	-664(ra) # 8000019c <memset>
  memset(disk.used, 0, PGSIZE);
    8000543c:	6605                	lui	a2,0x1
    8000543e:	4581                	li	a1,0
    80005440:	6888                	ld	a0,16(s1)
    80005442:	ffffb097          	auipc	ra,0xffffb
    80005446:	d5a080e7          	jalr	-678(ra) # 8000019c <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000544a:	100017b7          	lui	a5,0x10001
    8000544e:	4721                	li	a4,8
    80005450:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005452:	4098                	lw	a4,0(s1)
    80005454:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005458:	40d8                	lw	a4,4(s1)
    8000545a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000545e:	6498                	ld	a4,8(s1)
    80005460:	0007069b          	sext.w	a3,a4
    80005464:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005468:	9701                	srai	a4,a4,0x20
    8000546a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000546e:	6898                	ld	a4,16(s1)
    80005470:	0007069b          	sext.w	a3,a4
    80005474:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005478:	9701                	srai	a4,a4,0x20
    8000547a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000547e:	4685                	li	a3,1
    80005480:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    80005482:	4705                	li	a4,1
    80005484:	00d48c23          	sb	a3,24(s1)
    80005488:	00e48ca3          	sb	a4,25(s1)
    8000548c:	00e48d23          	sb	a4,26(s1)
    80005490:	00e48da3          	sb	a4,27(s1)
    80005494:	00e48e23          	sb	a4,28(s1)
    80005498:	00e48ea3          	sb	a4,29(s1)
    8000549c:	00e48f23          	sb	a4,30(s1)
    800054a0:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800054a4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800054a8:	0727a823          	sw	s2,112(a5)
}
    800054ac:	60e2                	ld	ra,24(sp)
    800054ae:	6442                	ld	s0,16(sp)
    800054b0:	64a2                	ld	s1,8(sp)
    800054b2:	6902                	ld	s2,0(sp)
    800054b4:	6105                	addi	sp,sp,32
    800054b6:	8082                	ret
    panic("could not find virtio disk");
    800054b8:	00003517          	auipc	a0,0x3
    800054bc:	40050513          	addi	a0,a0,1024 # 800088b8 <syscalls+0x328>
    800054c0:	00001097          	auipc	ra,0x1
    800054c4:	8c2080e7          	jalr	-1854(ra) # 80005d82 <panic>
    panic("virtio disk FEATURES_OK unset");
    800054c8:	00003517          	auipc	a0,0x3
    800054cc:	41050513          	addi	a0,a0,1040 # 800088d8 <syscalls+0x348>
    800054d0:	00001097          	auipc	ra,0x1
    800054d4:	8b2080e7          	jalr	-1870(ra) # 80005d82 <panic>
    panic("virtio disk should not be ready");
    800054d8:	00003517          	auipc	a0,0x3
    800054dc:	42050513          	addi	a0,a0,1056 # 800088f8 <syscalls+0x368>
    800054e0:	00001097          	auipc	ra,0x1
    800054e4:	8a2080e7          	jalr	-1886(ra) # 80005d82 <panic>
    panic("virtio disk has no queue 0");
    800054e8:	00003517          	auipc	a0,0x3
    800054ec:	43050513          	addi	a0,a0,1072 # 80008918 <syscalls+0x388>
    800054f0:	00001097          	auipc	ra,0x1
    800054f4:	892080e7          	jalr	-1902(ra) # 80005d82 <panic>
    panic("virtio disk max queue too short");
    800054f8:	00003517          	auipc	a0,0x3
    800054fc:	44050513          	addi	a0,a0,1088 # 80008938 <syscalls+0x3a8>
    80005500:	00001097          	auipc	ra,0x1
    80005504:	882080e7          	jalr	-1918(ra) # 80005d82 <panic>
    panic("virtio disk kalloc");
    80005508:	00003517          	auipc	a0,0x3
    8000550c:	45050513          	addi	a0,a0,1104 # 80008958 <syscalls+0x3c8>
    80005510:	00001097          	auipc	ra,0x1
    80005514:	872080e7          	jalr	-1934(ra) # 80005d82 <panic>

0000000080005518 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005518:	7159                	addi	sp,sp,-112
    8000551a:	f486                	sd	ra,104(sp)
    8000551c:	f0a2                	sd	s0,96(sp)
    8000551e:	eca6                	sd	s1,88(sp)
    80005520:	e8ca                	sd	s2,80(sp)
    80005522:	e4ce                	sd	s3,72(sp)
    80005524:	e0d2                	sd	s4,64(sp)
    80005526:	fc56                	sd	s5,56(sp)
    80005528:	f85a                	sd	s6,48(sp)
    8000552a:	f45e                	sd	s7,40(sp)
    8000552c:	f062                	sd	s8,32(sp)
    8000552e:	ec66                	sd	s9,24(sp)
    80005530:	e86a                	sd	s10,16(sp)
    80005532:	1880                	addi	s0,sp,112
    80005534:	892a                	mv	s2,a0
    80005536:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005538:	00c52c83          	lw	s9,12(a0)
    8000553c:	001c9c9b          	slliw	s9,s9,0x1
    80005540:	1c82                	slli	s9,s9,0x20
    80005542:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005546:	00015517          	auipc	a0,0x15
    8000554a:	a2250513          	addi	a0,a0,-1502 # 80019f68 <disk+0x128>
    8000554e:	00001097          	auipc	ra,0x1
    80005552:	d7e080e7          	jalr	-642(ra) # 800062cc <acquire>
  for(int i = 0; i < 3; i++){
    80005556:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005558:	4ba1                	li	s7,8
      disk.free[i] = 0;
    8000555a:	00015b17          	auipc	s6,0x15
    8000555e:	8e6b0b13          	addi	s6,s6,-1818 # 80019e40 <disk>
  for(int i = 0; i < 3; i++){
    80005562:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005564:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005566:	00015c17          	auipc	s8,0x15
    8000556a:	a02c0c13          	addi	s8,s8,-1534 # 80019f68 <disk+0x128>
    8000556e:	a8b5                	j	800055ea <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    80005570:	00fb06b3          	add	a3,s6,a5
    80005574:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005578:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000557a:	0207c563          	bltz	a5,800055a4 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000557e:	2485                	addiw	s1,s1,1
    80005580:	0711                	addi	a4,a4,4
    80005582:	1f548a63          	beq	s1,s5,80005776 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    80005586:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005588:	00015697          	auipc	a3,0x15
    8000558c:	8b868693          	addi	a3,a3,-1864 # 80019e40 <disk>
    80005590:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005592:	0186c583          	lbu	a1,24(a3)
    80005596:	fde9                	bnez	a1,80005570 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005598:	2785                	addiw	a5,a5,1
    8000559a:	0685                	addi	a3,a3,1
    8000559c:	ff779be3          	bne	a5,s7,80005592 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800055a0:	57fd                	li	a5,-1
    800055a2:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800055a4:	02905a63          	blez	s1,800055d8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800055a8:	f9042503          	lw	a0,-112(s0)
    800055ac:	00000097          	auipc	ra,0x0
    800055b0:	cfa080e7          	jalr	-774(ra) # 800052a6 <free_desc>
      for(int j = 0; j < i; j++)
    800055b4:	4785                	li	a5,1
    800055b6:	0297d163          	bge	a5,s1,800055d8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800055ba:	f9442503          	lw	a0,-108(s0)
    800055be:	00000097          	auipc	ra,0x0
    800055c2:	ce8080e7          	jalr	-792(ra) # 800052a6 <free_desc>
      for(int j = 0; j < i; j++)
    800055c6:	4789                	li	a5,2
    800055c8:	0097d863          	bge	a5,s1,800055d8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800055cc:	f9842503          	lw	a0,-104(s0)
    800055d0:	00000097          	auipc	ra,0x0
    800055d4:	cd6080e7          	jalr	-810(ra) # 800052a6 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055d8:	85e2                	mv	a1,s8
    800055da:	00015517          	auipc	a0,0x15
    800055de:	87e50513          	addi	a0,a0,-1922 # 80019e58 <disk+0x18>
    800055e2:	ffffc097          	auipc	ra,0xffffc
    800055e6:	fa2080e7          	jalr	-94(ra) # 80001584 <sleep>
  for(int i = 0; i < 3; i++){
    800055ea:	f9040713          	addi	a4,s0,-112
    800055ee:	84ce                	mv	s1,s3
    800055f0:	bf59                	j	80005586 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800055f2:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    800055f6:	00479693          	slli	a3,a5,0x4
    800055fa:	00015797          	auipc	a5,0x15
    800055fe:	84678793          	addi	a5,a5,-1978 # 80019e40 <disk>
    80005602:	97b6                	add	a5,a5,a3
    80005604:	4685                	li	a3,1
    80005606:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005608:	00015597          	auipc	a1,0x15
    8000560c:	83858593          	addi	a1,a1,-1992 # 80019e40 <disk>
    80005610:	00a60793          	addi	a5,a2,10
    80005614:	0792                	slli	a5,a5,0x4
    80005616:	97ae                	add	a5,a5,a1
    80005618:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000561c:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005620:	f6070693          	addi	a3,a4,-160
    80005624:	619c                	ld	a5,0(a1)
    80005626:	97b6                	add	a5,a5,a3
    80005628:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000562a:	6188                	ld	a0,0(a1)
    8000562c:	96aa                	add	a3,a3,a0
    8000562e:	47c1                	li	a5,16
    80005630:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005632:	4785                	li	a5,1
    80005634:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005638:	f9442783          	lw	a5,-108(s0)
    8000563c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005640:	0792                	slli	a5,a5,0x4
    80005642:	953e                	add	a0,a0,a5
    80005644:	05890693          	addi	a3,s2,88
    80005648:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000564a:	6188                	ld	a0,0(a1)
    8000564c:	97aa                	add	a5,a5,a0
    8000564e:	40000693          	li	a3,1024
    80005652:	c794                	sw	a3,8(a5)
  if(write)
    80005654:	100d0d63          	beqz	s10,8000576e <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005658:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000565c:	00c7d683          	lhu	a3,12(a5)
    80005660:	0016e693          	ori	a3,a3,1
    80005664:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80005668:	f9842583          	lw	a1,-104(s0)
    8000566c:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005670:	00014697          	auipc	a3,0x14
    80005674:	7d068693          	addi	a3,a3,2000 # 80019e40 <disk>
    80005678:	00260793          	addi	a5,a2,2
    8000567c:	0792                	slli	a5,a5,0x4
    8000567e:	97b6                	add	a5,a5,a3
    80005680:	587d                	li	a6,-1
    80005682:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005686:	0592                	slli	a1,a1,0x4
    80005688:	952e                	add	a0,a0,a1
    8000568a:	f9070713          	addi	a4,a4,-112
    8000568e:	9736                	add	a4,a4,a3
    80005690:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    80005692:	6298                	ld	a4,0(a3)
    80005694:	972e                	add	a4,a4,a1
    80005696:	4585                	li	a1,1
    80005698:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000569a:	4509                	li	a0,2
    8000569c:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    800056a0:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056a4:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    800056a8:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056ac:	6698                	ld	a4,8(a3)
    800056ae:	00275783          	lhu	a5,2(a4)
    800056b2:	8b9d                	andi	a5,a5,7
    800056b4:	0786                	slli	a5,a5,0x1
    800056b6:	97ba                	add	a5,a5,a4
    800056b8:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    800056bc:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056c0:	6698                	ld	a4,8(a3)
    800056c2:	00275783          	lhu	a5,2(a4)
    800056c6:	2785                	addiw	a5,a5,1
    800056c8:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056cc:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056d0:	100017b7          	lui	a5,0x10001
    800056d4:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800056d8:	00492703          	lw	a4,4(s2)
    800056dc:	4785                	li	a5,1
    800056de:	02f71163          	bne	a4,a5,80005700 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    800056e2:	00015997          	auipc	s3,0x15
    800056e6:	88698993          	addi	s3,s3,-1914 # 80019f68 <disk+0x128>
  while(b->disk == 1) {
    800056ea:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800056ec:	85ce                	mv	a1,s3
    800056ee:	854a                	mv	a0,s2
    800056f0:	ffffc097          	auipc	ra,0xffffc
    800056f4:	e94080e7          	jalr	-364(ra) # 80001584 <sleep>
  while(b->disk == 1) {
    800056f8:	00492783          	lw	a5,4(s2)
    800056fc:	fe9788e3          	beq	a5,s1,800056ec <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    80005700:	f9042903          	lw	s2,-112(s0)
    80005704:	00290793          	addi	a5,s2,2
    80005708:	00479713          	slli	a4,a5,0x4
    8000570c:	00014797          	auipc	a5,0x14
    80005710:	73478793          	addi	a5,a5,1844 # 80019e40 <disk>
    80005714:	97ba                	add	a5,a5,a4
    80005716:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000571a:	00014997          	auipc	s3,0x14
    8000571e:	72698993          	addi	s3,s3,1830 # 80019e40 <disk>
    80005722:	00491713          	slli	a4,s2,0x4
    80005726:	0009b783          	ld	a5,0(s3)
    8000572a:	97ba                	add	a5,a5,a4
    8000572c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005730:	854a                	mv	a0,s2
    80005732:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005736:	00000097          	auipc	ra,0x0
    8000573a:	b70080e7          	jalr	-1168(ra) # 800052a6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000573e:	8885                	andi	s1,s1,1
    80005740:	f0ed                	bnez	s1,80005722 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005742:	00015517          	auipc	a0,0x15
    80005746:	82650513          	addi	a0,a0,-2010 # 80019f68 <disk+0x128>
    8000574a:	00001097          	auipc	ra,0x1
    8000574e:	c36080e7          	jalr	-970(ra) # 80006380 <release>
}
    80005752:	70a6                	ld	ra,104(sp)
    80005754:	7406                	ld	s0,96(sp)
    80005756:	64e6                	ld	s1,88(sp)
    80005758:	6946                	ld	s2,80(sp)
    8000575a:	69a6                	ld	s3,72(sp)
    8000575c:	6a06                	ld	s4,64(sp)
    8000575e:	7ae2                	ld	s5,56(sp)
    80005760:	7b42                	ld	s6,48(sp)
    80005762:	7ba2                	ld	s7,40(sp)
    80005764:	7c02                	ld	s8,32(sp)
    80005766:	6ce2                	ld	s9,24(sp)
    80005768:	6d42                	ld	s10,16(sp)
    8000576a:	6165                	addi	sp,sp,112
    8000576c:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000576e:	4689                	li	a3,2
    80005770:	00d79623          	sh	a3,12(a5)
    80005774:	b5e5                	j	8000565c <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005776:	f9042603          	lw	a2,-112(s0)
    8000577a:	00a60713          	addi	a4,a2,10
    8000577e:	0712                	slli	a4,a4,0x4
    80005780:	00014517          	auipc	a0,0x14
    80005784:	6c850513          	addi	a0,a0,1736 # 80019e48 <disk+0x8>
    80005788:	953a                	add	a0,a0,a4
  if(write)
    8000578a:	e60d14e3          	bnez	s10,800055f2 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    8000578e:	00a60793          	addi	a5,a2,10
    80005792:	00479693          	slli	a3,a5,0x4
    80005796:	00014797          	auipc	a5,0x14
    8000579a:	6aa78793          	addi	a5,a5,1706 # 80019e40 <disk>
    8000579e:	97b6                	add	a5,a5,a3
    800057a0:	0007a423          	sw	zero,8(a5)
    800057a4:	b595                	j	80005608 <virtio_disk_rw+0xf0>

00000000800057a6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057a6:	1101                	addi	sp,sp,-32
    800057a8:	ec06                	sd	ra,24(sp)
    800057aa:	e822                	sd	s0,16(sp)
    800057ac:	e426                	sd	s1,8(sp)
    800057ae:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057b0:	00014497          	auipc	s1,0x14
    800057b4:	69048493          	addi	s1,s1,1680 # 80019e40 <disk>
    800057b8:	00014517          	auipc	a0,0x14
    800057bc:	7b050513          	addi	a0,a0,1968 # 80019f68 <disk+0x128>
    800057c0:	00001097          	auipc	ra,0x1
    800057c4:	b0c080e7          	jalr	-1268(ra) # 800062cc <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057c8:	10001737          	lui	a4,0x10001
    800057cc:	533c                	lw	a5,96(a4)
    800057ce:	8b8d                	andi	a5,a5,3
    800057d0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800057d2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057d6:	689c                	ld	a5,16(s1)
    800057d8:	0204d703          	lhu	a4,32(s1)
    800057dc:	0027d783          	lhu	a5,2(a5)
    800057e0:	04f70863          	beq	a4,a5,80005830 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800057e4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057e8:	6898                	ld	a4,16(s1)
    800057ea:	0204d783          	lhu	a5,32(s1)
    800057ee:	8b9d                	andi	a5,a5,7
    800057f0:	078e                	slli	a5,a5,0x3
    800057f2:	97ba                	add	a5,a5,a4
    800057f4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057f6:	00278713          	addi	a4,a5,2
    800057fa:	0712                	slli	a4,a4,0x4
    800057fc:	9726                	add	a4,a4,s1
    800057fe:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005802:	e721                	bnez	a4,8000584a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005804:	0789                	addi	a5,a5,2
    80005806:	0792                	slli	a5,a5,0x4
    80005808:	97a6                	add	a5,a5,s1
    8000580a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000580c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005810:	ffffc097          	auipc	ra,0xffffc
    80005814:	dd8080e7          	jalr	-552(ra) # 800015e8 <wakeup>

    disk.used_idx += 1;
    80005818:	0204d783          	lhu	a5,32(s1)
    8000581c:	2785                	addiw	a5,a5,1
    8000581e:	17c2                	slli	a5,a5,0x30
    80005820:	93c1                	srli	a5,a5,0x30
    80005822:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005826:	6898                	ld	a4,16(s1)
    80005828:	00275703          	lhu	a4,2(a4)
    8000582c:	faf71ce3          	bne	a4,a5,800057e4 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005830:	00014517          	auipc	a0,0x14
    80005834:	73850513          	addi	a0,a0,1848 # 80019f68 <disk+0x128>
    80005838:	00001097          	auipc	ra,0x1
    8000583c:	b48080e7          	jalr	-1208(ra) # 80006380 <release>
}
    80005840:	60e2                	ld	ra,24(sp)
    80005842:	6442                	ld	s0,16(sp)
    80005844:	64a2                	ld	s1,8(sp)
    80005846:	6105                	addi	sp,sp,32
    80005848:	8082                	ret
      panic("virtio_disk_intr status");
    8000584a:	00003517          	auipc	a0,0x3
    8000584e:	12650513          	addi	a0,a0,294 # 80008970 <syscalls+0x3e0>
    80005852:	00000097          	auipc	ra,0x0
    80005856:	530080e7          	jalr	1328(ra) # 80005d82 <panic>

000000008000585a <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000585a:	1141                	addi	sp,sp,-16
    8000585c:	e422                	sd	s0,8(sp)
    8000585e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005860:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005864:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005868:	0037979b          	slliw	a5,a5,0x3
    8000586c:	02004737          	lui	a4,0x2004
    80005870:	97ba                	add	a5,a5,a4
    80005872:	0200c737          	lui	a4,0x200c
    80005876:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000587a:	000f4637          	lui	a2,0xf4
    8000587e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005882:	95b2                	add	a1,a1,a2
    80005884:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005886:	00269713          	slli	a4,a3,0x2
    8000588a:	9736                	add	a4,a4,a3
    8000588c:	00371693          	slli	a3,a4,0x3
    80005890:	00014717          	auipc	a4,0x14
    80005894:	6f070713          	addi	a4,a4,1776 # 80019f80 <timer_scratch>
    80005898:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000589a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000589c:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000589e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058a2:	00000797          	auipc	a5,0x0
    800058a6:	93e78793          	addi	a5,a5,-1730 # 800051e0 <timervec>
    800058aa:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058ae:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058b2:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058b6:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800058ba:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058be:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800058c2:	30479073          	csrw	mie,a5
}
    800058c6:	6422                	ld	s0,8(sp)
    800058c8:	0141                	addi	sp,sp,16
    800058ca:	8082                	ret

00000000800058cc <start>:
{
    800058cc:	1141                	addi	sp,sp,-16
    800058ce:	e406                	sd	ra,8(sp)
    800058d0:	e022                	sd	s0,0(sp)
    800058d2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058d4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058d8:	7779                	lui	a4,0xffffe
    800058da:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc63f>
    800058de:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058e0:	6705                	lui	a4,0x1
    800058e2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058e6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058e8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058ec:	ffffb797          	auipc	a5,0xffffb
    800058f0:	a5e78793          	addi	a5,a5,-1442 # 8000034a <main>
    800058f4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058f8:	4781                	li	a5,0
    800058fa:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800058fe:	67c1                	lui	a5,0x10
    80005900:	17fd                	addi	a5,a5,-1
    80005902:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005906:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000590a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000590e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005912:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005916:	57fd                	li	a5,-1
    80005918:	83a9                	srli	a5,a5,0xa
    8000591a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000591e:	47bd                	li	a5,15
    80005920:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005924:	00000097          	auipc	ra,0x0
    80005928:	f36080e7          	jalr	-202(ra) # 8000585a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000592c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005930:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005932:	823e                	mv	tp,a5
  asm volatile("mret");
    80005934:	30200073          	mret
}
    80005938:	60a2                	ld	ra,8(sp)
    8000593a:	6402                	ld	s0,0(sp)
    8000593c:	0141                	addi	sp,sp,16
    8000593e:	8082                	ret

0000000080005940 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005940:	715d                	addi	sp,sp,-80
    80005942:	e486                	sd	ra,72(sp)
    80005944:	e0a2                	sd	s0,64(sp)
    80005946:	fc26                	sd	s1,56(sp)
    80005948:	f84a                	sd	s2,48(sp)
    8000594a:	f44e                	sd	s3,40(sp)
    8000594c:	f052                	sd	s4,32(sp)
    8000594e:	ec56                	sd	s5,24(sp)
    80005950:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005952:	04c05663          	blez	a2,8000599e <consolewrite+0x5e>
    80005956:	8a2a                	mv	s4,a0
    80005958:	84ae                	mv	s1,a1
    8000595a:	89b2                	mv	s3,a2
    8000595c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000595e:	5afd                	li	s5,-1
    80005960:	4685                	li	a3,1
    80005962:	8626                	mv	a2,s1
    80005964:	85d2                	mv	a1,s4
    80005966:	fbf40513          	addi	a0,s0,-65
    8000596a:	ffffc097          	auipc	ra,0xffffc
    8000596e:	078080e7          	jalr	120(ra) # 800019e2 <either_copyin>
    80005972:	01550c63          	beq	a0,s5,8000598a <consolewrite+0x4a>
      break;
    uartputc(c);
    80005976:	fbf44503          	lbu	a0,-65(s0)
    8000597a:	00000097          	auipc	ra,0x0
    8000597e:	794080e7          	jalr	1940(ra) # 8000610e <uartputc>
  for(i = 0; i < n; i++){
    80005982:	2905                	addiw	s2,s2,1
    80005984:	0485                	addi	s1,s1,1
    80005986:	fd299de3          	bne	s3,s2,80005960 <consolewrite+0x20>
  }

  return i;
}
    8000598a:	854a                	mv	a0,s2
    8000598c:	60a6                	ld	ra,72(sp)
    8000598e:	6406                	ld	s0,64(sp)
    80005990:	74e2                	ld	s1,56(sp)
    80005992:	7942                	ld	s2,48(sp)
    80005994:	79a2                	ld	s3,40(sp)
    80005996:	7a02                	ld	s4,32(sp)
    80005998:	6ae2                	ld	s5,24(sp)
    8000599a:	6161                	addi	sp,sp,80
    8000599c:	8082                	ret
  for(i = 0; i < n; i++){
    8000599e:	4901                	li	s2,0
    800059a0:	b7ed                	j	8000598a <consolewrite+0x4a>

00000000800059a2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059a2:	7119                	addi	sp,sp,-128
    800059a4:	fc86                	sd	ra,120(sp)
    800059a6:	f8a2                	sd	s0,112(sp)
    800059a8:	f4a6                	sd	s1,104(sp)
    800059aa:	f0ca                	sd	s2,96(sp)
    800059ac:	ecce                	sd	s3,88(sp)
    800059ae:	e8d2                	sd	s4,80(sp)
    800059b0:	e4d6                	sd	s5,72(sp)
    800059b2:	e0da                	sd	s6,64(sp)
    800059b4:	fc5e                	sd	s7,56(sp)
    800059b6:	f862                	sd	s8,48(sp)
    800059b8:	f466                	sd	s9,40(sp)
    800059ba:	f06a                	sd	s10,32(sp)
    800059bc:	ec6e                	sd	s11,24(sp)
    800059be:	0100                	addi	s0,sp,128
    800059c0:	8b2a                	mv	s6,a0
    800059c2:	8aae                	mv	s5,a1
    800059c4:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059c6:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800059ca:	0001c517          	auipc	a0,0x1c
    800059ce:	6f650513          	addi	a0,a0,1782 # 800220c0 <cons>
    800059d2:	00001097          	auipc	ra,0x1
    800059d6:	8fa080e7          	jalr	-1798(ra) # 800062cc <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059da:	0001c497          	auipc	s1,0x1c
    800059de:	6e648493          	addi	s1,s1,1766 # 800220c0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059e2:	89a6                	mv	s3,s1
    800059e4:	0001c917          	auipc	s2,0x1c
    800059e8:	77490913          	addi	s2,s2,1908 # 80022158 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800059ec:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059ee:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800059f0:	4da9                	li	s11,10
  while(n > 0){
    800059f2:	07405b63          	blez	s4,80005a68 <consoleread+0xc6>
    while(cons.r == cons.w){
    800059f6:	0984a783          	lw	a5,152(s1)
    800059fa:	09c4a703          	lw	a4,156(s1)
    800059fe:	02f71763          	bne	a4,a5,80005a2c <consoleread+0x8a>
      if(killed(myproc())){
    80005a02:	ffffb097          	auipc	ra,0xffffb
    80005a06:	4d2080e7          	jalr	1234(ra) # 80000ed4 <myproc>
    80005a0a:	ffffc097          	auipc	ra,0xffffc
    80005a0e:	e22080e7          	jalr	-478(ra) # 8000182c <killed>
    80005a12:	e535                	bnez	a0,80005a7e <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005a14:	85ce                	mv	a1,s3
    80005a16:	854a                	mv	a0,s2
    80005a18:	ffffc097          	auipc	ra,0xffffc
    80005a1c:	b6c080e7          	jalr	-1172(ra) # 80001584 <sleep>
    while(cons.r == cons.w){
    80005a20:	0984a783          	lw	a5,152(s1)
    80005a24:	09c4a703          	lw	a4,156(s1)
    80005a28:	fcf70de3          	beq	a4,a5,80005a02 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005a2c:	0017871b          	addiw	a4,a5,1
    80005a30:	08e4ac23          	sw	a4,152(s1)
    80005a34:	07f7f713          	andi	a4,a5,127
    80005a38:	9726                	add	a4,a4,s1
    80005a3a:	01874703          	lbu	a4,24(a4)
    80005a3e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005a42:	079c0663          	beq	s8,s9,80005aae <consoleread+0x10c>
    cbuf = c;
    80005a46:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a4a:	4685                	li	a3,1
    80005a4c:	f8f40613          	addi	a2,s0,-113
    80005a50:	85d6                	mv	a1,s5
    80005a52:	855a                	mv	a0,s6
    80005a54:	ffffc097          	auipc	ra,0xffffc
    80005a58:	f38080e7          	jalr	-200(ra) # 8000198c <either_copyout>
    80005a5c:	01a50663          	beq	a0,s10,80005a68 <consoleread+0xc6>
    dst++;
    80005a60:	0a85                	addi	s5,s5,1
    --n;
    80005a62:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005a64:	f9bc17e3          	bne	s8,s11,800059f2 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a68:	0001c517          	auipc	a0,0x1c
    80005a6c:	65850513          	addi	a0,a0,1624 # 800220c0 <cons>
    80005a70:	00001097          	auipc	ra,0x1
    80005a74:	910080e7          	jalr	-1776(ra) # 80006380 <release>

  return target - n;
    80005a78:	414b853b          	subw	a0,s7,s4
    80005a7c:	a811                	j	80005a90 <consoleread+0xee>
        release(&cons.lock);
    80005a7e:	0001c517          	auipc	a0,0x1c
    80005a82:	64250513          	addi	a0,a0,1602 # 800220c0 <cons>
    80005a86:	00001097          	auipc	ra,0x1
    80005a8a:	8fa080e7          	jalr	-1798(ra) # 80006380 <release>
        return -1;
    80005a8e:	557d                	li	a0,-1
}
    80005a90:	70e6                	ld	ra,120(sp)
    80005a92:	7446                	ld	s0,112(sp)
    80005a94:	74a6                	ld	s1,104(sp)
    80005a96:	7906                	ld	s2,96(sp)
    80005a98:	69e6                	ld	s3,88(sp)
    80005a9a:	6a46                	ld	s4,80(sp)
    80005a9c:	6aa6                	ld	s5,72(sp)
    80005a9e:	6b06                	ld	s6,64(sp)
    80005aa0:	7be2                	ld	s7,56(sp)
    80005aa2:	7c42                	ld	s8,48(sp)
    80005aa4:	7ca2                	ld	s9,40(sp)
    80005aa6:	7d02                	ld	s10,32(sp)
    80005aa8:	6de2                	ld	s11,24(sp)
    80005aaa:	6109                	addi	sp,sp,128
    80005aac:	8082                	ret
      if(n < target){
    80005aae:	000a071b          	sext.w	a4,s4
    80005ab2:	fb777be3          	bgeu	a4,s7,80005a68 <consoleread+0xc6>
        cons.r--;
    80005ab6:	0001c717          	auipc	a4,0x1c
    80005aba:	6af72123          	sw	a5,1698(a4) # 80022158 <cons+0x98>
    80005abe:	b76d                	j	80005a68 <consoleread+0xc6>

0000000080005ac0 <consputc>:
{
    80005ac0:	1141                	addi	sp,sp,-16
    80005ac2:	e406                	sd	ra,8(sp)
    80005ac4:	e022                	sd	s0,0(sp)
    80005ac6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005ac8:	10000793          	li	a5,256
    80005acc:	00f50a63          	beq	a0,a5,80005ae0 <consputc+0x20>
    uartputc_sync(c);
    80005ad0:	00000097          	auipc	ra,0x0
    80005ad4:	564080e7          	jalr	1380(ra) # 80006034 <uartputc_sync>
}
    80005ad8:	60a2                	ld	ra,8(sp)
    80005ada:	6402                	ld	s0,0(sp)
    80005adc:	0141                	addi	sp,sp,16
    80005ade:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ae0:	4521                	li	a0,8
    80005ae2:	00000097          	auipc	ra,0x0
    80005ae6:	552080e7          	jalr	1362(ra) # 80006034 <uartputc_sync>
    80005aea:	02000513          	li	a0,32
    80005aee:	00000097          	auipc	ra,0x0
    80005af2:	546080e7          	jalr	1350(ra) # 80006034 <uartputc_sync>
    80005af6:	4521                	li	a0,8
    80005af8:	00000097          	auipc	ra,0x0
    80005afc:	53c080e7          	jalr	1340(ra) # 80006034 <uartputc_sync>
    80005b00:	bfe1                	j	80005ad8 <consputc+0x18>

0000000080005b02 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b02:	1101                	addi	sp,sp,-32
    80005b04:	ec06                	sd	ra,24(sp)
    80005b06:	e822                	sd	s0,16(sp)
    80005b08:	e426                	sd	s1,8(sp)
    80005b0a:	e04a                	sd	s2,0(sp)
    80005b0c:	1000                	addi	s0,sp,32
    80005b0e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b10:	0001c517          	auipc	a0,0x1c
    80005b14:	5b050513          	addi	a0,a0,1456 # 800220c0 <cons>
    80005b18:	00000097          	auipc	ra,0x0
    80005b1c:	7b4080e7          	jalr	1972(ra) # 800062cc <acquire>

  switch(c){
    80005b20:	47d5                	li	a5,21
    80005b22:	0af48663          	beq	s1,a5,80005bce <consoleintr+0xcc>
    80005b26:	0297ca63          	blt	a5,s1,80005b5a <consoleintr+0x58>
    80005b2a:	47a1                	li	a5,8
    80005b2c:	0ef48763          	beq	s1,a5,80005c1a <consoleintr+0x118>
    80005b30:	47c1                	li	a5,16
    80005b32:	10f49a63          	bne	s1,a5,80005c46 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b36:	ffffc097          	auipc	ra,0xffffc
    80005b3a:	f02080e7          	jalr	-254(ra) # 80001a38 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b3e:	0001c517          	auipc	a0,0x1c
    80005b42:	58250513          	addi	a0,a0,1410 # 800220c0 <cons>
    80005b46:	00001097          	auipc	ra,0x1
    80005b4a:	83a080e7          	jalr	-1990(ra) # 80006380 <release>
}
    80005b4e:	60e2                	ld	ra,24(sp)
    80005b50:	6442                	ld	s0,16(sp)
    80005b52:	64a2                	ld	s1,8(sp)
    80005b54:	6902                	ld	s2,0(sp)
    80005b56:	6105                	addi	sp,sp,32
    80005b58:	8082                	ret
  switch(c){
    80005b5a:	07f00793          	li	a5,127
    80005b5e:	0af48e63          	beq	s1,a5,80005c1a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b62:	0001c717          	auipc	a4,0x1c
    80005b66:	55e70713          	addi	a4,a4,1374 # 800220c0 <cons>
    80005b6a:	0a072783          	lw	a5,160(a4)
    80005b6e:	09872703          	lw	a4,152(a4)
    80005b72:	9f99                	subw	a5,a5,a4
    80005b74:	07f00713          	li	a4,127
    80005b78:	fcf763e3          	bltu	a4,a5,80005b3e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b7c:	47b5                	li	a5,13
    80005b7e:	0cf48763          	beq	s1,a5,80005c4c <consoleintr+0x14a>
      consputc(c);
    80005b82:	8526                	mv	a0,s1
    80005b84:	00000097          	auipc	ra,0x0
    80005b88:	f3c080e7          	jalr	-196(ra) # 80005ac0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b8c:	0001c797          	auipc	a5,0x1c
    80005b90:	53478793          	addi	a5,a5,1332 # 800220c0 <cons>
    80005b94:	0a07a683          	lw	a3,160(a5)
    80005b98:	0016871b          	addiw	a4,a3,1
    80005b9c:	0007061b          	sext.w	a2,a4
    80005ba0:	0ae7a023          	sw	a4,160(a5)
    80005ba4:	07f6f693          	andi	a3,a3,127
    80005ba8:	97b6                	add	a5,a5,a3
    80005baa:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005bae:	47a9                	li	a5,10
    80005bb0:	0cf48563          	beq	s1,a5,80005c7a <consoleintr+0x178>
    80005bb4:	4791                	li	a5,4
    80005bb6:	0cf48263          	beq	s1,a5,80005c7a <consoleintr+0x178>
    80005bba:	0001c797          	auipc	a5,0x1c
    80005bbe:	59e7a783          	lw	a5,1438(a5) # 80022158 <cons+0x98>
    80005bc2:	9f1d                	subw	a4,a4,a5
    80005bc4:	08000793          	li	a5,128
    80005bc8:	f6f71be3          	bne	a4,a5,80005b3e <consoleintr+0x3c>
    80005bcc:	a07d                	j	80005c7a <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005bce:	0001c717          	auipc	a4,0x1c
    80005bd2:	4f270713          	addi	a4,a4,1266 # 800220c0 <cons>
    80005bd6:	0a072783          	lw	a5,160(a4)
    80005bda:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005bde:	0001c497          	auipc	s1,0x1c
    80005be2:	4e248493          	addi	s1,s1,1250 # 800220c0 <cons>
    while(cons.e != cons.w &&
    80005be6:	4929                	li	s2,10
    80005be8:	f4f70be3          	beq	a4,a5,80005b3e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005bec:	37fd                	addiw	a5,a5,-1
    80005bee:	07f7f713          	andi	a4,a5,127
    80005bf2:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005bf4:	01874703          	lbu	a4,24(a4)
    80005bf8:	f52703e3          	beq	a4,s2,80005b3e <consoleintr+0x3c>
      cons.e--;
    80005bfc:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c00:	10000513          	li	a0,256
    80005c04:	00000097          	auipc	ra,0x0
    80005c08:	ebc080e7          	jalr	-324(ra) # 80005ac0 <consputc>
    while(cons.e != cons.w &&
    80005c0c:	0a04a783          	lw	a5,160(s1)
    80005c10:	09c4a703          	lw	a4,156(s1)
    80005c14:	fcf71ce3          	bne	a4,a5,80005bec <consoleintr+0xea>
    80005c18:	b71d                	j	80005b3e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c1a:	0001c717          	auipc	a4,0x1c
    80005c1e:	4a670713          	addi	a4,a4,1190 # 800220c0 <cons>
    80005c22:	0a072783          	lw	a5,160(a4)
    80005c26:	09c72703          	lw	a4,156(a4)
    80005c2a:	f0f70ae3          	beq	a4,a5,80005b3e <consoleintr+0x3c>
      cons.e--;
    80005c2e:	37fd                	addiw	a5,a5,-1
    80005c30:	0001c717          	auipc	a4,0x1c
    80005c34:	52f72823          	sw	a5,1328(a4) # 80022160 <cons+0xa0>
      consputc(BACKSPACE);
    80005c38:	10000513          	li	a0,256
    80005c3c:	00000097          	auipc	ra,0x0
    80005c40:	e84080e7          	jalr	-380(ra) # 80005ac0 <consputc>
    80005c44:	bded                	j	80005b3e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c46:	ee048ce3          	beqz	s1,80005b3e <consoleintr+0x3c>
    80005c4a:	bf21                	j	80005b62 <consoleintr+0x60>
      consputc(c);
    80005c4c:	4529                	li	a0,10
    80005c4e:	00000097          	auipc	ra,0x0
    80005c52:	e72080e7          	jalr	-398(ra) # 80005ac0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c56:	0001c797          	auipc	a5,0x1c
    80005c5a:	46a78793          	addi	a5,a5,1130 # 800220c0 <cons>
    80005c5e:	0a07a703          	lw	a4,160(a5)
    80005c62:	0017069b          	addiw	a3,a4,1
    80005c66:	0006861b          	sext.w	a2,a3
    80005c6a:	0ad7a023          	sw	a3,160(a5)
    80005c6e:	07f77713          	andi	a4,a4,127
    80005c72:	97ba                	add	a5,a5,a4
    80005c74:	4729                	li	a4,10
    80005c76:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c7a:	0001c797          	auipc	a5,0x1c
    80005c7e:	4ec7a123          	sw	a2,1250(a5) # 8002215c <cons+0x9c>
        wakeup(&cons.r);
    80005c82:	0001c517          	auipc	a0,0x1c
    80005c86:	4d650513          	addi	a0,a0,1238 # 80022158 <cons+0x98>
    80005c8a:	ffffc097          	auipc	ra,0xffffc
    80005c8e:	95e080e7          	jalr	-1698(ra) # 800015e8 <wakeup>
    80005c92:	b575                	j	80005b3e <consoleintr+0x3c>

0000000080005c94 <consoleinit>:

void
consoleinit(void)
{
    80005c94:	1141                	addi	sp,sp,-16
    80005c96:	e406                	sd	ra,8(sp)
    80005c98:	e022                	sd	s0,0(sp)
    80005c9a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c9c:	00003597          	auipc	a1,0x3
    80005ca0:	cec58593          	addi	a1,a1,-788 # 80008988 <syscalls+0x3f8>
    80005ca4:	0001c517          	auipc	a0,0x1c
    80005ca8:	41c50513          	addi	a0,a0,1052 # 800220c0 <cons>
    80005cac:	00000097          	auipc	ra,0x0
    80005cb0:	590080e7          	jalr	1424(ra) # 8000623c <initlock>

  uartinit();
    80005cb4:	00000097          	auipc	ra,0x0
    80005cb8:	330080e7          	jalr	816(ra) # 80005fe4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005cbc:	00013797          	auipc	a5,0x13
    80005cc0:	12c78793          	addi	a5,a5,300 # 80018de8 <devsw>
    80005cc4:	00000717          	auipc	a4,0x0
    80005cc8:	cde70713          	addi	a4,a4,-802 # 800059a2 <consoleread>
    80005ccc:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005cce:	00000717          	auipc	a4,0x0
    80005cd2:	c7270713          	addi	a4,a4,-910 # 80005940 <consolewrite>
    80005cd6:	ef98                	sd	a4,24(a5)
}
    80005cd8:	60a2                	ld	ra,8(sp)
    80005cda:	6402                	ld	s0,0(sp)
    80005cdc:	0141                	addi	sp,sp,16
    80005cde:	8082                	ret

0000000080005ce0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005ce0:	7179                	addi	sp,sp,-48
    80005ce2:	f406                	sd	ra,40(sp)
    80005ce4:	f022                	sd	s0,32(sp)
    80005ce6:	ec26                	sd	s1,24(sp)
    80005ce8:	e84a                	sd	s2,16(sp)
    80005cea:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005cec:	c219                	beqz	a2,80005cf2 <printint+0x12>
    80005cee:	08054663          	bltz	a0,80005d7a <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005cf2:	2501                	sext.w	a0,a0
    80005cf4:	4881                	li	a7,0
    80005cf6:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005cfa:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005cfc:	2581                	sext.w	a1,a1
    80005cfe:	00003617          	auipc	a2,0x3
    80005d02:	cba60613          	addi	a2,a2,-838 # 800089b8 <digits>
    80005d06:	883a                	mv	a6,a4
    80005d08:	2705                	addiw	a4,a4,1
    80005d0a:	02b577bb          	remuw	a5,a0,a1
    80005d0e:	1782                	slli	a5,a5,0x20
    80005d10:	9381                	srli	a5,a5,0x20
    80005d12:	97b2                	add	a5,a5,a2
    80005d14:	0007c783          	lbu	a5,0(a5)
    80005d18:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d1c:	0005079b          	sext.w	a5,a0
    80005d20:	02b5553b          	divuw	a0,a0,a1
    80005d24:	0685                	addi	a3,a3,1
    80005d26:	feb7f0e3          	bgeu	a5,a1,80005d06 <printint+0x26>

  if(sign)
    80005d2a:	00088b63          	beqz	a7,80005d40 <printint+0x60>
    buf[i++] = '-';
    80005d2e:	fe040793          	addi	a5,s0,-32
    80005d32:	973e                	add	a4,a4,a5
    80005d34:	02d00793          	li	a5,45
    80005d38:	fef70823          	sb	a5,-16(a4)
    80005d3c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d40:	02e05763          	blez	a4,80005d6e <printint+0x8e>
    80005d44:	fd040793          	addi	a5,s0,-48
    80005d48:	00e784b3          	add	s1,a5,a4
    80005d4c:	fff78913          	addi	s2,a5,-1
    80005d50:	993a                	add	s2,s2,a4
    80005d52:	377d                	addiw	a4,a4,-1
    80005d54:	1702                	slli	a4,a4,0x20
    80005d56:	9301                	srli	a4,a4,0x20
    80005d58:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d5c:	fff4c503          	lbu	a0,-1(s1)
    80005d60:	00000097          	auipc	ra,0x0
    80005d64:	d60080e7          	jalr	-672(ra) # 80005ac0 <consputc>
  while(--i >= 0)
    80005d68:	14fd                	addi	s1,s1,-1
    80005d6a:	ff2499e3          	bne	s1,s2,80005d5c <printint+0x7c>
}
    80005d6e:	70a2                	ld	ra,40(sp)
    80005d70:	7402                	ld	s0,32(sp)
    80005d72:	64e2                	ld	s1,24(sp)
    80005d74:	6942                	ld	s2,16(sp)
    80005d76:	6145                	addi	sp,sp,48
    80005d78:	8082                	ret
    x = -xx;
    80005d7a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d7e:	4885                	li	a7,1
    x = -xx;
    80005d80:	bf9d                	j	80005cf6 <printint+0x16>

0000000080005d82 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d82:	1101                	addi	sp,sp,-32
    80005d84:	ec06                	sd	ra,24(sp)
    80005d86:	e822                	sd	s0,16(sp)
    80005d88:	e426                	sd	s1,8(sp)
    80005d8a:	1000                	addi	s0,sp,32
    80005d8c:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d8e:	0001c797          	auipc	a5,0x1c
    80005d92:	3e07a923          	sw	zero,1010(a5) # 80022180 <pr+0x18>
  printf("panic: ");
    80005d96:	00003517          	auipc	a0,0x3
    80005d9a:	bfa50513          	addi	a0,a0,-1030 # 80008990 <syscalls+0x400>
    80005d9e:	00000097          	auipc	ra,0x0
    80005da2:	02e080e7          	jalr	46(ra) # 80005dcc <printf>
  printf(s);
    80005da6:	8526                	mv	a0,s1
    80005da8:	00000097          	auipc	ra,0x0
    80005dac:	024080e7          	jalr	36(ra) # 80005dcc <printf>
  printf("\n");
    80005db0:	00002517          	auipc	a0,0x2
    80005db4:	29850513          	addi	a0,a0,664 # 80008048 <etext+0x48>
    80005db8:	00000097          	auipc	ra,0x0
    80005dbc:	014080e7          	jalr	20(ra) # 80005dcc <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005dc0:	4785                	li	a5,1
    80005dc2:	00003717          	auipc	a4,0x3
    80005dc6:	d6f72d23          	sw	a5,-646(a4) # 80008b3c <panicked>
  for(;;)
    80005dca:	a001                	j	80005dca <panic+0x48>

0000000080005dcc <printf>:
{
    80005dcc:	7131                	addi	sp,sp,-192
    80005dce:	fc86                	sd	ra,120(sp)
    80005dd0:	f8a2                	sd	s0,112(sp)
    80005dd2:	f4a6                	sd	s1,104(sp)
    80005dd4:	f0ca                	sd	s2,96(sp)
    80005dd6:	ecce                	sd	s3,88(sp)
    80005dd8:	e8d2                	sd	s4,80(sp)
    80005dda:	e4d6                	sd	s5,72(sp)
    80005ddc:	e0da                	sd	s6,64(sp)
    80005dde:	fc5e                	sd	s7,56(sp)
    80005de0:	f862                	sd	s8,48(sp)
    80005de2:	f466                	sd	s9,40(sp)
    80005de4:	f06a                	sd	s10,32(sp)
    80005de6:	ec6e                	sd	s11,24(sp)
    80005de8:	0100                	addi	s0,sp,128
    80005dea:	8a2a                	mv	s4,a0
    80005dec:	e40c                	sd	a1,8(s0)
    80005dee:	e810                	sd	a2,16(s0)
    80005df0:	ec14                	sd	a3,24(s0)
    80005df2:	f018                	sd	a4,32(s0)
    80005df4:	f41c                	sd	a5,40(s0)
    80005df6:	03043823          	sd	a6,48(s0)
    80005dfa:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005dfe:	0001cd97          	auipc	s11,0x1c
    80005e02:	382dad83          	lw	s11,898(s11) # 80022180 <pr+0x18>
  if(locking)
    80005e06:	020d9b63          	bnez	s11,80005e3c <printf+0x70>
  if (fmt == 0)
    80005e0a:	040a0263          	beqz	s4,80005e4e <printf+0x82>
  va_start(ap, fmt);
    80005e0e:	00840793          	addi	a5,s0,8
    80005e12:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e16:	000a4503          	lbu	a0,0(s4)
    80005e1a:	16050263          	beqz	a0,80005f7e <printf+0x1b2>
    80005e1e:	4481                	li	s1,0
    if(c != '%'){
    80005e20:	02500a93          	li	s5,37
    switch(c){
    80005e24:	07000b13          	li	s6,112
  consputc('x');
    80005e28:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e2a:	00003b97          	auipc	s7,0x3
    80005e2e:	b8eb8b93          	addi	s7,s7,-1138 # 800089b8 <digits>
    switch(c){
    80005e32:	07300c93          	li	s9,115
    80005e36:	06400c13          	li	s8,100
    80005e3a:	a82d                	j	80005e74 <printf+0xa8>
    acquire(&pr.lock);
    80005e3c:	0001c517          	auipc	a0,0x1c
    80005e40:	32c50513          	addi	a0,a0,812 # 80022168 <pr>
    80005e44:	00000097          	auipc	ra,0x0
    80005e48:	488080e7          	jalr	1160(ra) # 800062cc <acquire>
    80005e4c:	bf7d                	j	80005e0a <printf+0x3e>
    panic("null fmt");
    80005e4e:	00003517          	auipc	a0,0x3
    80005e52:	b5250513          	addi	a0,a0,-1198 # 800089a0 <syscalls+0x410>
    80005e56:	00000097          	auipc	ra,0x0
    80005e5a:	f2c080e7          	jalr	-212(ra) # 80005d82 <panic>
      consputc(c);
    80005e5e:	00000097          	auipc	ra,0x0
    80005e62:	c62080e7          	jalr	-926(ra) # 80005ac0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e66:	2485                	addiw	s1,s1,1
    80005e68:	009a07b3          	add	a5,s4,s1
    80005e6c:	0007c503          	lbu	a0,0(a5)
    80005e70:	10050763          	beqz	a0,80005f7e <printf+0x1b2>
    if(c != '%'){
    80005e74:	ff5515e3          	bne	a0,s5,80005e5e <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e78:	2485                	addiw	s1,s1,1
    80005e7a:	009a07b3          	add	a5,s4,s1
    80005e7e:	0007c783          	lbu	a5,0(a5)
    80005e82:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005e86:	cfe5                	beqz	a5,80005f7e <printf+0x1b2>
    switch(c){
    80005e88:	05678a63          	beq	a5,s6,80005edc <printf+0x110>
    80005e8c:	02fb7663          	bgeu	s6,a5,80005eb8 <printf+0xec>
    80005e90:	09978963          	beq	a5,s9,80005f22 <printf+0x156>
    80005e94:	07800713          	li	a4,120
    80005e98:	0ce79863          	bne	a5,a4,80005f68 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005e9c:	f8843783          	ld	a5,-120(s0)
    80005ea0:	00878713          	addi	a4,a5,8
    80005ea4:	f8e43423          	sd	a4,-120(s0)
    80005ea8:	4605                	li	a2,1
    80005eaa:	85ea                	mv	a1,s10
    80005eac:	4388                	lw	a0,0(a5)
    80005eae:	00000097          	auipc	ra,0x0
    80005eb2:	e32080e7          	jalr	-462(ra) # 80005ce0 <printint>
      break;
    80005eb6:	bf45                	j	80005e66 <printf+0x9a>
    switch(c){
    80005eb8:	0b578263          	beq	a5,s5,80005f5c <printf+0x190>
    80005ebc:	0b879663          	bne	a5,s8,80005f68 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005ec0:	f8843783          	ld	a5,-120(s0)
    80005ec4:	00878713          	addi	a4,a5,8
    80005ec8:	f8e43423          	sd	a4,-120(s0)
    80005ecc:	4605                	li	a2,1
    80005ece:	45a9                	li	a1,10
    80005ed0:	4388                	lw	a0,0(a5)
    80005ed2:	00000097          	auipc	ra,0x0
    80005ed6:	e0e080e7          	jalr	-498(ra) # 80005ce0 <printint>
      break;
    80005eda:	b771                	j	80005e66 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005edc:	f8843783          	ld	a5,-120(s0)
    80005ee0:	00878713          	addi	a4,a5,8
    80005ee4:	f8e43423          	sd	a4,-120(s0)
    80005ee8:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005eec:	03000513          	li	a0,48
    80005ef0:	00000097          	auipc	ra,0x0
    80005ef4:	bd0080e7          	jalr	-1072(ra) # 80005ac0 <consputc>
  consputc('x');
    80005ef8:	07800513          	li	a0,120
    80005efc:	00000097          	auipc	ra,0x0
    80005f00:	bc4080e7          	jalr	-1084(ra) # 80005ac0 <consputc>
    80005f04:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f06:	03c9d793          	srli	a5,s3,0x3c
    80005f0a:	97de                	add	a5,a5,s7
    80005f0c:	0007c503          	lbu	a0,0(a5)
    80005f10:	00000097          	auipc	ra,0x0
    80005f14:	bb0080e7          	jalr	-1104(ra) # 80005ac0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f18:	0992                	slli	s3,s3,0x4
    80005f1a:	397d                	addiw	s2,s2,-1
    80005f1c:	fe0915e3          	bnez	s2,80005f06 <printf+0x13a>
    80005f20:	b799                	j	80005e66 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f22:	f8843783          	ld	a5,-120(s0)
    80005f26:	00878713          	addi	a4,a5,8
    80005f2a:	f8e43423          	sd	a4,-120(s0)
    80005f2e:	0007b903          	ld	s2,0(a5)
    80005f32:	00090e63          	beqz	s2,80005f4e <printf+0x182>
      for(; *s; s++)
    80005f36:	00094503          	lbu	a0,0(s2)
    80005f3a:	d515                	beqz	a0,80005e66 <printf+0x9a>
        consputc(*s);
    80005f3c:	00000097          	auipc	ra,0x0
    80005f40:	b84080e7          	jalr	-1148(ra) # 80005ac0 <consputc>
      for(; *s; s++)
    80005f44:	0905                	addi	s2,s2,1
    80005f46:	00094503          	lbu	a0,0(s2)
    80005f4a:	f96d                	bnez	a0,80005f3c <printf+0x170>
    80005f4c:	bf29                	j	80005e66 <printf+0x9a>
        s = "(null)";
    80005f4e:	00003917          	auipc	s2,0x3
    80005f52:	a4a90913          	addi	s2,s2,-1462 # 80008998 <syscalls+0x408>
      for(; *s; s++)
    80005f56:	02800513          	li	a0,40
    80005f5a:	b7cd                	j	80005f3c <printf+0x170>
      consputc('%');
    80005f5c:	8556                	mv	a0,s5
    80005f5e:	00000097          	auipc	ra,0x0
    80005f62:	b62080e7          	jalr	-1182(ra) # 80005ac0 <consputc>
      break;
    80005f66:	b701                	j	80005e66 <printf+0x9a>
      consputc('%');
    80005f68:	8556                	mv	a0,s5
    80005f6a:	00000097          	auipc	ra,0x0
    80005f6e:	b56080e7          	jalr	-1194(ra) # 80005ac0 <consputc>
      consputc(c);
    80005f72:	854a                	mv	a0,s2
    80005f74:	00000097          	auipc	ra,0x0
    80005f78:	b4c080e7          	jalr	-1204(ra) # 80005ac0 <consputc>
      break;
    80005f7c:	b5ed                	j	80005e66 <printf+0x9a>
  if(locking)
    80005f7e:	020d9163          	bnez	s11,80005fa0 <printf+0x1d4>
}
    80005f82:	70e6                	ld	ra,120(sp)
    80005f84:	7446                	ld	s0,112(sp)
    80005f86:	74a6                	ld	s1,104(sp)
    80005f88:	7906                	ld	s2,96(sp)
    80005f8a:	69e6                	ld	s3,88(sp)
    80005f8c:	6a46                	ld	s4,80(sp)
    80005f8e:	6aa6                	ld	s5,72(sp)
    80005f90:	6b06                	ld	s6,64(sp)
    80005f92:	7be2                	ld	s7,56(sp)
    80005f94:	7c42                	ld	s8,48(sp)
    80005f96:	7ca2                	ld	s9,40(sp)
    80005f98:	7d02                	ld	s10,32(sp)
    80005f9a:	6de2                	ld	s11,24(sp)
    80005f9c:	6129                	addi	sp,sp,192
    80005f9e:	8082                	ret
    release(&pr.lock);
    80005fa0:	0001c517          	auipc	a0,0x1c
    80005fa4:	1c850513          	addi	a0,a0,456 # 80022168 <pr>
    80005fa8:	00000097          	auipc	ra,0x0
    80005fac:	3d8080e7          	jalr	984(ra) # 80006380 <release>
}
    80005fb0:	bfc9                	j	80005f82 <printf+0x1b6>

0000000080005fb2 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005fb2:	1101                	addi	sp,sp,-32
    80005fb4:	ec06                	sd	ra,24(sp)
    80005fb6:	e822                	sd	s0,16(sp)
    80005fb8:	e426                	sd	s1,8(sp)
    80005fba:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005fbc:	0001c497          	auipc	s1,0x1c
    80005fc0:	1ac48493          	addi	s1,s1,428 # 80022168 <pr>
    80005fc4:	00003597          	auipc	a1,0x3
    80005fc8:	9ec58593          	addi	a1,a1,-1556 # 800089b0 <syscalls+0x420>
    80005fcc:	8526                	mv	a0,s1
    80005fce:	00000097          	auipc	ra,0x0
    80005fd2:	26e080e7          	jalr	622(ra) # 8000623c <initlock>
  pr.locking = 1;
    80005fd6:	4785                	li	a5,1
    80005fd8:	cc9c                	sw	a5,24(s1)
}
    80005fda:	60e2                	ld	ra,24(sp)
    80005fdc:	6442                	ld	s0,16(sp)
    80005fde:	64a2                	ld	s1,8(sp)
    80005fe0:	6105                	addi	sp,sp,32
    80005fe2:	8082                	ret

0000000080005fe4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005fe4:	1141                	addi	sp,sp,-16
    80005fe6:	e406                	sd	ra,8(sp)
    80005fe8:	e022                	sd	s0,0(sp)
    80005fea:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005fec:	100007b7          	lui	a5,0x10000
    80005ff0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005ff4:	f8000713          	li	a4,-128
    80005ff8:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005ffc:	470d                	li	a4,3
    80005ffe:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006002:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006006:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000600a:	469d                	li	a3,7
    8000600c:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006010:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006014:	00003597          	auipc	a1,0x3
    80006018:	9bc58593          	addi	a1,a1,-1604 # 800089d0 <digits+0x18>
    8000601c:	0001c517          	auipc	a0,0x1c
    80006020:	16c50513          	addi	a0,a0,364 # 80022188 <uart_tx_lock>
    80006024:	00000097          	auipc	ra,0x0
    80006028:	218080e7          	jalr	536(ra) # 8000623c <initlock>
}
    8000602c:	60a2                	ld	ra,8(sp)
    8000602e:	6402                	ld	s0,0(sp)
    80006030:	0141                	addi	sp,sp,16
    80006032:	8082                	ret

0000000080006034 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006034:	1101                	addi	sp,sp,-32
    80006036:	ec06                	sd	ra,24(sp)
    80006038:	e822                	sd	s0,16(sp)
    8000603a:	e426                	sd	s1,8(sp)
    8000603c:	1000                	addi	s0,sp,32
    8000603e:	84aa                	mv	s1,a0
  push_off();
    80006040:	00000097          	auipc	ra,0x0
    80006044:	240080e7          	jalr	576(ra) # 80006280 <push_off>

  if(panicked){
    80006048:	00003797          	auipc	a5,0x3
    8000604c:	af47a783          	lw	a5,-1292(a5) # 80008b3c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006050:	10000737          	lui	a4,0x10000
  if(panicked){
    80006054:	c391                	beqz	a5,80006058 <uartputc_sync+0x24>
    for(;;)
    80006056:	a001                	j	80006056 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006058:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000605c:	0ff7f793          	andi	a5,a5,255
    80006060:	0207f793          	andi	a5,a5,32
    80006064:	dbf5                	beqz	a5,80006058 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006066:	0ff4f793          	andi	a5,s1,255
    8000606a:	10000737          	lui	a4,0x10000
    8000606e:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006072:	00000097          	auipc	ra,0x0
    80006076:	2ae080e7          	jalr	686(ra) # 80006320 <pop_off>
}
    8000607a:	60e2                	ld	ra,24(sp)
    8000607c:	6442                	ld	s0,16(sp)
    8000607e:	64a2                	ld	s1,8(sp)
    80006080:	6105                	addi	sp,sp,32
    80006082:	8082                	ret

0000000080006084 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006084:	00003717          	auipc	a4,0x3
    80006088:	abc73703          	ld	a4,-1348(a4) # 80008b40 <uart_tx_r>
    8000608c:	00003797          	auipc	a5,0x3
    80006090:	abc7b783          	ld	a5,-1348(a5) # 80008b48 <uart_tx_w>
    80006094:	06e78c63          	beq	a5,a4,8000610c <uartstart+0x88>
{
    80006098:	7139                	addi	sp,sp,-64
    8000609a:	fc06                	sd	ra,56(sp)
    8000609c:	f822                	sd	s0,48(sp)
    8000609e:	f426                	sd	s1,40(sp)
    800060a0:	f04a                	sd	s2,32(sp)
    800060a2:	ec4e                	sd	s3,24(sp)
    800060a4:	e852                	sd	s4,16(sp)
    800060a6:	e456                	sd	s5,8(sp)
    800060a8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060aa:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060ae:	0001ca17          	auipc	s4,0x1c
    800060b2:	0daa0a13          	addi	s4,s4,218 # 80022188 <uart_tx_lock>
    uart_tx_r += 1;
    800060b6:	00003497          	auipc	s1,0x3
    800060ba:	a8a48493          	addi	s1,s1,-1398 # 80008b40 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800060be:	00003997          	auipc	s3,0x3
    800060c2:	a8a98993          	addi	s3,s3,-1398 # 80008b48 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060c6:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800060ca:	0ff7f793          	andi	a5,a5,255
    800060ce:	0207f793          	andi	a5,a5,32
    800060d2:	c785                	beqz	a5,800060fa <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060d4:	01f77793          	andi	a5,a4,31
    800060d8:	97d2                	add	a5,a5,s4
    800060da:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800060de:	0705                	addi	a4,a4,1
    800060e0:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800060e2:	8526                	mv	a0,s1
    800060e4:	ffffb097          	auipc	ra,0xffffb
    800060e8:	504080e7          	jalr	1284(ra) # 800015e8 <wakeup>
    
    WriteReg(THR, c);
    800060ec:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800060f0:	6098                	ld	a4,0(s1)
    800060f2:	0009b783          	ld	a5,0(s3)
    800060f6:	fce798e3          	bne	a5,a4,800060c6 <uartstart+0x42>
  }
}
    800060fa:	70e2                	ld	ra,56(sp)
    800060fc:	7442                	ld	s0,48(sp)
    800060fe:	74a2                	ld	s1,40(sp)
    80006100:	7902                	ld	s2,32(sp)
    80006102:	69e2                	ld	s3,24(sp)
    80006104:	6a42                	ld	s4,16(sp)
    80006106:	6aa2                	ld	s5,8(sp)
    80006108:	6121                	addi	sp,sp,64
    8000610a:	8082                	ret
    8000610c:	8082                	ret

000000008000610e <uartputc>:
{
    8000610e:	7179                	addi	sp,sp,-48
    80006110:	f406                	sd	ra,40(sp)
    80006112:	f022                	sd	s0,32(sp)
    80006114:	ec26                	sd	s1,24(sp)
    80006116:	e84a                	sd	s2,16(sp)
    80006118:	e44e                	sd	s3,8(sp)
    8000611a:	e052                	sd	s4,0(sp)
    8000611c:	1800                	addi	s0,sp,48
    8000611e:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006120:	0001c517          	auipc	a0,0x1c
    80006124:	06850513          	addi	a0,a0,104 # 80022188 <uart_tx_lock>
    80006128:	00000097          	auipc	ra,0x0
    8000612c:	1a4080e7          	jalr	420(ra) # 800062cc <acquire>
  if(panicked){
    80006130:	00003797          	auipc	a5,0x3
    80006134:	a0c7a783          	lw	a5,-1524(a5) # 80008b3c <panicked>
    80006138:	e7c9                	bnez	a5,800061c2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000613a:	00003797          	auipc	a5,0x3
    8000613e:	a0e7b783          	ld	a5,-1522(a5) # 80008b48 <uart_tx_w>
    80006142:	00003717          	auipc	a4,0x3
    80006146:	9fe73703          	ld	a4,-1538(a4) # 80008b40 <uart_tx_r>
    8000614a:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000614e:	0001ca17          	auipc	s4,0x1c
    80006152:	03aa0a13          	addi	s4,s4,58 # 80022188 <uart_tx_lock>
    80006156:	00003497          	auipc	s1,0x3
    8000615a:	9ea48493          	addi	s1,s1,-1558 # 80008b40 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000615e:	00003917          	auipc	s2,0x3
    80006162:	9ea90913          	addi	s2,s2,-1558 # 80008b48 <uart_tx_w>
    80006166:	00f71f63          	bne	a4,a5,80006184 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000616a:	85d2                	mv	a1,s4
    8000616c:	8526                	mv	a0,s1
    8000616e:	ffffb097          	auipc	ra,0xffffb
    80006172:	416080e7          	jalr	1046(ra) # 80001584 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006176:	00093783          	ld	a5,0(s2)
    8000617a:	6098                	ld	a4,0(s1)
    8000617c:	02070713          	addi	a4,a4,32
    80006180:	fef705e3          	beq	a4,a5,8000616a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006184:	0001c497          	auipc	s1,0x1c
    80006188:	00448493          	addi	s1,s1,4 # 80022188 <uart_tx_lock>
    8000618c:	01f7f713          	andi	a4,a5,31
    80006190:	9726                	add	a4,a4,s1
    80006192:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80006196:	0785                	addi	a5,a5,1
    80006198:	00003717          	auipc	a4,0x3
    8000619c:	9af73823          	sd	a5,-1616(a4) # 80008b48 <uart_tx_w>
  uartstart();
    800061a0:	00000097          	auipc	ra,0x0
    800061a4:	ee4080e7          	jalr	-284(ra) # 80006084 <uartstart>
  release(&uart_tx_lock);
    800061a8:	8526                	mv	a0,s1
    800061aa:	00000097          	auipc	ra,0x0
    800061ae:	1d6080e7          	jalr	470(ra) # 80006380 <release>
}
    800061b2:	70a2                	ld	ra,40(sp)
    800061b4:	7402                	ld	s0,32(sp)
    800061b6:	64e2                	ld	s1,24(sp)
    800061b8:	6942                	ld	s2,16(sp)
    800061ba:	69a2                	ld	s3,8(sp)
    800061bc:	6a02                	ld	s4,0(sp)
    800061be:	6145                	addi	sp,sp,48
    800061c0:	8082                	ret
    for(;;)
    800061c2:	a001                	j	800061c2 <uartputc+0xb4>

00000000800061c4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061c4:	1141                	addi	sp,sp,-16
    800061c6:	e422                	sd	s0,8(sp)
    800061c8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061ca:	100007b7          	lui	a5,0x10000
    800061ce:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800061d2:	8b85                	andi	a5,a5,1
    800061d4:	cb91                	beqz	a5,800061e8 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800061d6:	100007b7          	lui	a5,0x10000
    800061da:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800061de:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800061e2:	6422                	ld	s0,8(sp)
    800061e4:	0141                	addi	sp,sp,16
    800061e6:	8082                	ret
    return -1;
    800061e8:	557d                	li	a0,-1
    800061ea:	bfe5                	j	800061e2 <uartgetc+0x1e>

00000000800061ec <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800061ec:	1101                	addi	sp,sp,-32
    800061ee:	ec06                	sd	ra,24(sp)
    800061f0:	e822                	sd	s0,16(sp)
    800061f2:	e426                	sd	s1,8(sp)
    800061f4:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061f6:	54fd                	li	s1,-1
    int c = uartgetc();
    800061f8:	00000097          	auipc	ra,0x0
    800061fc:	fcc080e7          	jalr	-52(ra) # 800061c4 <uartgetc>
    if(c == -1)
    80006200:	00950763          	beq	a0,s1,8000620e <uartintr+0x22>
      break;
    consoleintr(c);
    80006204:	00000097          	auipc	ra,0x0
    80006208:	8fe080e7          	jalr	-1794(ra) # 80005b02 <consoleintr>
  while(1){
    8000620c:	b7f5                	j	800061f8 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000620e:	0001c497          	auipc	s1,0x1c
    80006212:	f7a48493          	addi	s1,s1,-134 # 80022188 <uart_tx_lock>
    80006216:	8526                	mv	a0,s1
    80006218:	00000097          	auipc	ra,0x0
    8000621c:	0b4080e7          	jalr	180(ra) # 800062cc <acquire>
  uartstart();
    80006220:	00000097          	auipc	ra,0x0
    80006224:	e64080e7          	jalr	-412(ra) # 80006084 <uartstart>
  release(&uart_tx_lock);
    80006228:	8526                	mv	a0,s1
    8000622a:	00000097          	auipc	ra,0x0
    8000622e:	156080e7          	jalr	342(ra) # 80006380 <release>
}
    80006232:	60e2                	ld	ra,24(sp)
    80006234:	6442                	ld	s0,16(sp)
    80006236:	64a2                	ld	s1,8(sp)
    80006238:	6105                	addi	sp,sp,32
    8000623a:	8082                	ret

000000008000623c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000623c:	1141                	addi	sp,sp,-16
    8000623e:	e422                	sd	s0,8(sp)
    80006240:	0800                	addi	s0,sp,16
  lk->name = name;
    80006242:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006244:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006248:	00053823          	sd	zero,16(a0)
}
    8000624c:	6422                	ld	s0,8(sp)
    8000624e:	0141                	addi	sp,sp,16
    80006250:	8082                	ret

0000000080006252 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006252:	411c                	lw	a5,0(a0)
    80006254:	e399                	bnez	a5,8000625a <holding+0x8>
    80006256:	4501                	li	a0,0
  return r;
}
    80006258:	8082                	ret
{
    8000625a:	1101                	addi	sp,sp,-32
    8000625c:	ec06                	sd	ra,24(sp)
    8000625e:	e822                	sd	s0,16(sp)
    80006260:	e426                	sd	s1,8(sp)
    80006262:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006264:	6904                	ld	s1,16(a0)
    80006266:	ffffb097          	auipc	ra,0xffffb
    8000626a:	c52080e7          	jalr	-942(ra) # 80000eb8 <mycpu>
    8000626e:	40a48533          	sub	a0,s1,a0
    80006272:	00153513          	seqz	a0,a0
}
    80006276:	60e2                	ld	ra,24(sp)
    80006278:	6442                	ld	s0,16(sp)
    8000627a:	64a2                	ld	s1,8(sp)
    8000627c:	6105                	addi	sp,sp,32
    8000627e:	8082                	ret

0000000080006280 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006280:	1101                	addi	sp,sp,-32
    80006282:	ec06                	sd	ra,24(sp)
    80006284:	e822                	sd	s0,16(sp)
    80006286:	e426                	sd	s1,8(sp)
    80006288:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000628a:	100024f3          	csrr	s1,sstatus
    8000628e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006292:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006294:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006298:	ffffb097          	auipc	ra,0xffffb
    8000629c:	c20080e7          	jalr	-992(ra) # 80000eb8 <mycpu>
    800062a0:	5d3c                	lw	a5,120(a0)
    800062a2:	cf89                	beqz	a5,800062bc <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062a4:	ffffb097          	auipc	ra,0xffffb
    800062a8:	c14080e7          	jalr	-1004(ra) # 80000eb8 <mycpu>
    800062ac:	5d3c                	lw	a5,120(a0)
    800062ae:	2785                	addiw	a5,a5,1
    800062b0:	dd3c                	sw	a5,120(a0)
}
    800062b2:	60e2                	ld	ra,24(sp)
    800062b4:	6442                	ld	s0,16(sp)
    800062b6:	64a2                	ld	s1,8(sp)
    800062b8:	6105                	addi	sp,sp,32
    800062ba:	8082                	ret
    mycpu()->intena = old;
    800062bc:	ffffb097          	auipc	ra,0xffffb
    800062c0:	bfc080e7          	jalr	-1028(ra) # 80000eb8 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062c4:	8085                	srli	s1,s1,0x1
    800062c6:	8885                	andi	s1,s1,1
    800062c8:	dd64                	sw	s1,124(a0)
    800062ca:	bfe9                	j	800062a4 <push_off+0x24>

00000000800062cc <acquire>:
{
    800062cc:	1101                	addi	sp,sp,-32
    800062ce:	ec06                	sd	ra,24(sp)
    800062d0:	e822                	sd	s0,16(sp)
    800062d2:	e426                	sd	s1,8(sp)
    800062d4:	1000                	addi	s0,sp,32
    800062d6:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800062d8:	00000097          	auipc	ra,0x0
    800062dc:	fa8080e7          	jalr	-88(ra) # 80006280 <push_off>
  if(holding(lk))
    800062e0:	8526                	mv	a0,s1
    800062e2:	00000097          	auipc	ra,0x0
    800062e6:	f70080e7          	jalr	-144(ra) # 80006252 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062ea:	4705                	li	a4,1
  if(holding(lk))
    800062ec:	e115                	bnez	a0,80006310 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062ee:	87ba                	mv	a5,a4
    800062f0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062f4:	2781                	sext.w	a5,a5
    800062f6:	ffe5                	bnez	a5,800062ee <acquire+0x22>
  __sync_synchronize();
    800062f8:	0ff0000f          	fence
  lk->cpu = mycpu();
    800062fc:	ffffb097          	auipc	ra,0xffffb
    80006300:	bbc080e7          	jalr	-1092(ra) # 80000eb8 <mycpu>
    80006304:	e888                	sd	a0,16(s1)
}
    80006306:	60e2                	ld	ra,24(sp)
    80006308:	6442                	ld	s0,16(sp)
    8000630a:	64a2                	ld	s1,8(sp)
    8000630c:	6105                	addi	sp,sp,32
    8000630e:	8082                	ret
    panic("acquire");
    80006310:	00002517          	auipc	a0,0x2
    80006314:	6c850513          	addi	a0,a0,1736 # 800089d8 <digits+0x20>
    80006318:	00000097          	auipc	ra,0x0
    8000631c:	a6a080e7          	jalr	-1430(ra) # 80005d82 <panic>

0000000080006320 <pop_off>:

void
pop_off(void)
{
    80006320:	1141                	addi	sp,sp,-16
    80006322:	e406                	sd	ra,8(sp)
    80006324:	e022                	sd	s0,0(sp)
    80006326:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006328:	ffffb097          	auipc	ra,0xffffb
    8000632c:	b90080e7          	jalr	-1136(ra) # 80000eb8 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006330:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006334:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006336:	e78d                	bnez	a5,80006360 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006338:	5d3c                	lw	a5,120(a0)
    8000633a:	02f05b63          	blez	a5,80006370 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000633e:	37fd                	addiw	a5,a5,-1
    80006340:	0007871b          	sext.w	a4,a5
    80006344:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006346:	eb09                	bnez	a4,80006358 <pop_off+0x38>
    80006348:	5d7c                	lw	a5,124(a0)
    8000634a:	c799                	beqz	a5,80006358 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000634c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006350:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006354:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006358:	60a2                	ld	ra,8(sp)
    8000635a:	6402                	ld	s0,0(sp)
    8000635c:	0141                	addi	sp,sp,16
    8000635e:	8082                	ret
    panic("pop_off - interruptible");
    80006360:	00002517          	auipc	a0,0x2
    80006364:	68050513          	addi	a0,a0,1664 # 800089e0 <digits+0x28>
    80006368:	00000097          	auipc	ra,0x0
    8000636c:	a1a080e7          	jalr	-1510(ra) # 80005d82 <panic>
    panic("pop_off");
    80006370:	00002517          	auipc	a0,0x2
    80006374:	68850513          	addi	a0,a0,1672 # 800089f8 <digits+0x40>
    80006378:	00000097          	auipc	ra,0x0
    8000637c:	a0a080e7          	jalr	-1526(ra) # 80005d82 <panic>

0000000080006380 <release>:
{
    80006380:	1101                	addi	sp,sp,-32
    80006382:	ec06                	sd	ra,24(sp)
    80006384:	e822                	sd	s0,16(sp)
    80006386:	e426                	sd	s1,8(sp)
    80006388:	1000                	addi	s0,sp,32
    8000638a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000638c:	00000097          	auipc	ra,0x0
    80006390:	ec6080e7          	jalr	-314(ra) # 80006252 <holding>
    80006394:	c115                	beqz	a0,800063b8 <release+0x38>
  lk->cpu = 0;
    80006396:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000639a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000639e:	0f50000f          	fence	iorw,ow
    800063a2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063a6:	00000097          	auipc	ra,0x0
    800063aa:	f7a080e7          	jalr	-134(ra) # 80006320 <pop_off>
}
    800063ae:	60e2                	ld	ra,24(sp)
    800063b0:	6442                	ld	s0,16(sp)
    800063b2:	64a2                	ld	s1,8(sp)
    800063b4:	6105                	addi	sp,sp,32
    800063b6:	8082                	ret
    panic("release");
    800063b8:	00002517          	auipc	a0,0x2
    800063bc:	64850513          	addi	a0,a0,1608 # 80008a00 <digits+0x48>
    800063c0:	00000097          	auipc	ra,0x0
    800063c4:	9c2080e7          	jalr	-1598(ra) # 80005d82 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
