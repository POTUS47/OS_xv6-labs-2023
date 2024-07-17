
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001a117          	auipc	sp,0x1a
    80000004:	c7010113          	addi	sp,sp,-912 # 80019c70 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	776050ef          	jal	ra,8000578c <start>

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
    80000034:	d4078793          	addi	a5,a5,-704 # 80021d70 <end>
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
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	8b090913          	addi	s2,s2,-1872 # 80008900 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	132080e7          	jalr	306(ra) # 8000618c <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	1d2080e7          	jalr	466(ra) # 80006240 <release>
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
    8000008e:	bb8080e7          	jalr	-1096(ra) # 80005c42 <panic>

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
    800000f0:	81450513          	addi	a0,a0,-2028 # 80008900 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	008080e7          	jalr	8(ra) # 800060fc <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	c7050513          	addi	a0,a0,-912 # 80021d70 <end>
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
    80000122:	00008497          	auipc	s1,0x8
    80000126:	7de48493          	addi	s1,s1,2014 # 80008900 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	060080e7          	jalr	96(ra) # 8000618c <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00008517          	auipc	a0,0x8
    8000013e:	7c650513          	addi	a0,a0,1990 # 80008900 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	0fc080e7          	jalr	252(ra) # 80006240 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00008517          	auipc	a0,0x8
    8000016a:	79a50513          	addi	a0,a0,1946 # 80008900 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	0d2080e7          	jalr	210(ra) # 80006240 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	b56080e7          	jalr	-1194(ra) # 80000e84 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00008717          	auipc	a4,0x8
    8000033a:	59a70713          	addi	a4,a4,1434 # 800088d0 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	b3a080e7          	jalr	-1222(ra) # 80000e84 <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	930080e7          	jalr	-1744(ra) # 80005c8c <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	7e0080e7          	jalr	2016(ra) # 80001b4c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	d6c080e7          	jalr	-660(ra) # 800050e0 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	02a080e7          	jalr	42(ra) # 800013a6 <scheduler>
    consoleinit();
    80000384:	00005097          	auipc	ra,0x5
    80000388:	7d0080e7          	jalr	2000(ra) # 80005b54 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	ae6080e7          	jalr	-1306(ra) # 80005e72 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	8f0080e7          	jalr	-1808(ra) # 80005c8c <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	8e0080e7          	jalr	-1824(ra) # 80005c8c <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	8d0080e7          	jalr	-1840(ra) # 80005c8c <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	34a080e7          	jalr	842(ra) # 80000716 <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	9f4080e7          	jalr	-1548(ra) # 80000dd0 <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	740080e7          	jalr	1856(ra) # 80001b24 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	760080e7          	jalr	1888(ra) # 80001b4c <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	cd6080e7          	jalr	-810(ra) # 800050ca <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	ce4080e7          	jalr	-796(ra) # 800050e0 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	e92080e7          	jalr	-366(ra) # 80002296 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	536080e7          	jalr	1334(ra) # 80002942 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	4d4080e7          	jalr	1236(ra) # 800038e8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	dcc080e7          	jalr	-564(ra) # 800051e8 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d68080e7          	jalr	-664(ra) # 8000118c <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00008717          	auipc	a4,0x8
    80000436:	48f72f23          	sw	a5,1182(a4) # 800088d0 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000442:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000446:	00008797          	auipc	a5,0x8
    8000044a:	4927b783          	ld	a5,1170(a5) # 800088d8 <kernel_pagetable>
    8000044e:	83b1                	srli	a5,a5,0xc
    80000450:	577d                	li	a4,-1
    80000452:	177e                	slli	a4,a4,0x3f
    80000454:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000456:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000045a:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000045e:	6422                	ld	s0,8(sp)
    80000460:	0141                	addi	sp,sp,16
    80000462:	8082                	ret

0000000080000464 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000464:	7139                	addi	sp,sp,-64
    80000466:	fc06                	sd	ra,56(sp)
    80000468:	f822                	sd	s0,48(sp)
    8000046a:	f426                	sd	s1,40(sp)
    8000046c:	f04a                	sd	s2,32(sp)
    8000046e:	ec4e                	sd	s3,24(sp)
    80000470:	e852                	sd	s4,16(sp)
    80000472:	e456                	sd	s5,8(sp)
    80000474:	e05a                	sd	s6,0(sp)
    80000476:	0080                	addi	s0,sp,64
    80000478:	84aa                	mv	s1,a0
    8000047a:	89ae                	mv	s3,a1
    8000047c:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047e:	57fd                	li	a5,-1
    80000480:	83e9                	srli	a5,a5,0x1a
    80000482:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000484:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000486:	04b7f263          	bgeu	a5,a1,800004ca <walk+0x66>
    panic("walk");
    8000048a:	00008517          	auipc	a0,0x8
    8000048e:	bc650513          	addi	a0,a0,-1082 # 80008050 <etext+0x50>
    80000492:	00005097          	auipc	ra,0x5
    80000496:	7b0080e7          	jalr	1968(ra) # 80005c42 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000049a:	060a8663          	beqz	s5,80000506 <walk+0xa2>
    8000049e:	00000097          	auipc	ra,0x0
    800004a2:	c7a080e7          	jalr	-902(ra) # 80000118 <kalloc>
    800004a6:	84aa                	mv	s1,a0
    800004a8:	c529                	beqz	a0,800004f2 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004aa:	6605                	lui	a2,0x1
    800004ac:	4581                	li	a1,0
    800004ae:	00000097          	auipc	ra,0x0
    800004b2:	cca080e7          	jalr	-822(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b6:	00c4d793          	srli	a5,s1,0xc
    800004ba:	07aa                	slli	a5,a5,0xa
    800004bc:	0017e793          	ori	a5,a5,1
    800004c0:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c4:	3a5d                	addiw	s4,s4,-9
    800004c6:	036a0063          	beq	s4,s6,800004e6 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004ca:	0149d933          	srl	s2,s3,s4
    800004ce:	1ff97913          	andi	s2,s2,511
    800004d2:	090e                	slli	s2,s2,0x3
    800004d4:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d6:	00093483          	ld	s1,0(s2)
    800004da:	0014f793          	andi	a5,s1,1
    800004de:	dfd5                	beqz	a5,8000049a <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004e0:	80a9                	srli	s1,s1,0xa
    800004e2:	04b2                	slli	s1,s1,0xc
    800004e4:	b7c5                	j	800004c4 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e6:	00c9d513          	srli	a0,s3,0xc
    800004ea:	1ff57513          	andi	a0,a0,511
    800004ee:	050e                	slli	a0,a0,0x3
    800004f0:	9526                	add	a0,a0,s1
}
    800004f2:	70e2                	ld	ra,56(sp)
    800004f4:	7442                	ld	s0,48(sp)
    800004f6:	74a2                	ld	s1,40(sp)
    800004f8:	7902                	ld	s2,32(sp)
    800004fa:	69e2                	ld	s3,24(sp)
    800004fc:	6a42                	ld	s4,16(sp)
    800004fe:	6aa2                	ld	s5,8(sp)
    80000500:	6b02                	ld	s6,0(sp)
    80000502:	6121                	addi	sp,sp,64
    80000504:	8082                	ret
        return 0;
    80000506:	4501                	li	a0,0
    80000508:	b7ed                	j	800004f2 <walk+0x8e>

000000008000050a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000050a:	57fd                	li	a5,-1
    8000050c:	83e9                	srli	a5,a5,0x1a
    8000050e:	00b7f463          	bgeu	a5,a1,80000516 <walkaddr+0xc>
    return 0;
    80000512:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000514:	8082                	ret
{
    80000516:	1141                	addi	sp,sp,-16
    80000518:	e406                	sd	ra,8(sp)
    8000051a:	e022                	sd	s0,0(sp)
    8000051c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051e:	4601                	li	a2,0
    80000520:	00000097          	auipc	ra,0x0
    80000524:	f44080e7          	jalr	-188(ra) # 80000464 <walk>
  if(pte == 0)
    80000528:	c105                	beqz	a0,80000548 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000052a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000052c:	0117f693          	andi	a3,a5,17
    80000530:	4745                	li	a4,17
    return 0;
    80000532:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000534:	00e68663          	beq	a3,a4,80000540 <walkaddr+0x36>
}
    80000538:	60a2                	ld	ra,8(sp)
    8000053a:	6402                	ld	s0,0(sp)
    8000053c:	0141                	addi	sp,sp,16
    8000053e:	8082                	ret
  pa = PTE2PA(*pte);
    80000540:	00a7d513          	srli	a0,a5,0xa
    80000544:	0532                	slli	a0,a0,0xc
  return pa;
    80000546:	bfcd                	j	80000538 <walkaddr+0x2e>
    return 0;
    80000548:	4501                	li	a0,0
    8000054a:	b7fd                	j	80000538 <walkaddr+0x2e>

000000008000054c <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000054c:	715d                	addi	sp,sp,-80
    8000054e:	e486                	sd	ra,72(sp)
    80000550:	e0a2                	sd	s0,64(sp)
    80000552:	fc26                	sd	s1,56(sp)
    80000554:	f84a                	sd	s2,48(sp)
    80000556:	f44e                	sd	s3,40(sp)
    80000558:	f052                	sd	s4,32(sp)
    8000055a:	ec56                	sd	s5,24(sp)
    8000055c:	e85a                	sd	s6,16(sp)
    8000055e:	e45e                	sd	s7,8(sp)
    80000560:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000562:	03459793          	slli	a5,a1,0x34
    80000566:	e385                	bnez	a5,80000586 <mappages+0x3a>
    80000568:	8aaa                	mv	s5,a0
    8000056a:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000056c:	03461793          	slli	a5,a2,0x34
    80000570:	e39d                	bnez	a5,80000596 <mappages+0x4a>
    panic("mappages: size not aligned");

  if(size == 0)
    80000572:	ca15                	beqz	a2,800005a6 <mappages+0x5a>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000574:	79fd                	lui	s3,0xfffff
    80000576:	964e                	add	a2,a2,s3
    80000578:	00b609b3          	add	s3,a2,a1
  a = va;
    8000057c:	892e                	mv	s2,a1
    8000057e:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000582:	6b85                	lui	s7,0x1
    80000584:	a091                	j	800005c8 <mappages+0x7c>
    panic("mappages: va not aligned");
    80000586:	00008517          	auipc	a0,0x8
    8000058a:	ad250513          	addi	a0,a0,-1326 # 80008058 <etext+0x58>
    8000058e:	00005097          	auipc	ra,0x5
    80000592:	6b4080e7          	jalr	1716(ra) # 80005c42 <panic>
    panic("mappages: size not aligned");
    80000596:	00008517          	auipc	a0,0x8
    8000059a:	ae250513          	addi	a0,a0,-1310 # 80008078 <etext+0x78>
    8000059e:	00005097          	auipc	ra,0x5
    800005a2:	6a4080e7          	jalr	1700(ra) # 80005c42 <panic>
    panic("mappages: size");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	af250513          	addi	a0,a0,-1294 # 80008098 <etext+0x98>
    800005ae:	00005097          	auipc	ra,0x5
    800005b2:	694080e7          	jalr	1684(ra) # 80005c42 <panic>
      panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	af250513          	addi	a0,a0,-1294 # 800080a8 <etext+0xa8>
    800005be:	00005097          	auipc	ra,0x5
    800005c2:	684080e7          	jalr	1668(ra) # 80005c42 <panic>
    a += PGSIZE;
    800005c6:	995e                	add	s2,s2,s7
  for(;;){
    800005c8:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005cc:	4605                	li	a2,1
    800005ce:	85ca                	mv	a1,s2
    800005d0:	8556                	mv	a0,s5
    800005d2:	00000097          	auipc	ra,0x0
    800005d6:	e92080e7          	jalr	-366(ra) # 80000464 <walk>
    800005da:	cd19                	beqz	a0,800005f8 <mappages+0xac>
    if(*pte & PTE_V)
    800005dc:	611c                	ld	a5,0(a0)
    800005de:	8b85                	andi	a5,a5,1
    800005e0:	fbf9                	bnez	a5,800005b6 <mappages+0x6a>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005e2:	80b1                	srli	s1,s1,0xc
    800005e4:	04aa                	slli	s1,s1,0xa
    800005e6:	0164e4b3          	or	s1,s1,s6
    800005ea:	0014e493          	ori	s1,s1,1
    800005ee:	e104                	sd	s1,0(a0)
    if(a == last)
    800005f0:	fd391be3          	bne	s2,s3,800005c6 <mappages+0x7a>
    pa += PGSIZE;
  }
  return 0;
    800005f4:	4501                	li	a0,0
    800005f6:	a011                	j	800005fa <mappages+0xae>
      return -1;
    800005f8:	557d                	li	a0,-1
}
    800005fa:	60a6                	ld	ra,72(sp)
    800005fc:	6406                	ld	s0,64(sp)
    800005fe:	74e2                	ld	s1,56(sp)
    80000600:	7942                	ld	s2,48(sp)
    80000602:	79a2                	ld	s3,40(sp)
    80000604:	7a02                	ld	s4,32(sp)
    80000606:	6ae2                	ld	s5,24(sp)
    80000608:	6b42                	ld	s6,16(sp)
    8000060a:	6ba2                	ld	s7,8(sp)
    8000060c:	6161                	addi	sp,sp,80
    8000060e:	8082                	ret

0000000080000610 <kvmmap>:
{
    80000610:	1141                	addi	sp,sp,-16
    80000612:	e406                	sd	ra,8(sp)
    80000614:	e022                	sd	s0,0(sp)
    80000616:	0800                	addi	s0,sp,16
    80000618:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000061a:	86b2                	mv	a3,a2
    8000061c:	863e                	mv	a2,a5
    8000061e:	00000097          	auipc	ra,0x0
    80000622:	f2e080e7          	jalr	-210(ra) # 8000054c <mappages>
    80000626:	e509                	bnez	a0,80000630 <kvmmap+0x20>
}
    80000628:	60a2                	ld	ra,8(sp)
    8000062a:	6402                	ld	s0,0(sp)
    8000062c:	0141                	addi	sp,sp,16
    8000062e:	8082                	ret
    panic("kvmmap");
    80000630:	00008517          	auipc	a0,0x8
    80000634:	a8850513          	addi	a0,a0,-1400 # 800080b8 <etext+0xb8>
    80000638:	00005097          	auipc	ra,0x5
    8000063c:	60a080e7          	jalr	1546(ra) # 80005c42 <panic>

0000000080000640 <kvmmake>:
{
    80000640:	1101                	addi	sp,sp,-32
    80000642:	ec06                	sd	ra,24(sp)
    80000644:	e822                	sd	s0,16(sp)
    80000646:	e426                	sd	s1,8(sp)
    80000648:	e04a                	sd	s2,0(sp)
    8000064a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	acc080e7          	jalr	-1332(ra) # 80000118 <kalloc>
    80000654:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000656:	6605                	lui	a2,0x1
    80000658:	4581                	li	a1,0
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	b1e080e7          	jalr	-1250(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000662:	4719                	li	a4,6
    80000664:	6685                	lui	a3,0x1
    80000666:	10000637          	lui	a2,0x10000
    8000066a:	100005b7          	lui	a1,0x10000
    8000066e:	8526                	mv	a0,s1
    80000670:	00000097          	auipc	ra,0x0
    80000674:	fa0080e7          	jalr	-96(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000678:	4719                	li	a4,6
    8000067a:	6685                	lui	a3,0x1
    8000067c:	10001637          	lui	a2,0x10001
    80000680:	100015b7          	lui	a1,0x10001
    80000684:	8526                	mv	a0,s1
    80000686:	00000097          	auipc	ra,0x0
    8000068a:	f8a080e7          	jalr	-118(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000068e:	4719                	li	a4,6
    80000690:	004006b7          	lui	a3,0x400
    80000694:	0c000637          	lui	a2,0xc000
    80000698:	0c0005b7          	lui	a1,0xc000
    8000069c:	8526                	mv	a0,s1
    8000069e:	00000097          	auipc	ra,0x0
    800006a2:	f72080e7          	jalr	-142(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006a6:	00008917          	auipc	s2,0x8
    800006aa:	95a90913          	addi	s2,s2,-1702 # 80008000 <etext>
    800006ae:	4729                	li	a4,10
    800006b0:	80008697          	auipc	a3,0x80008
    800006b4:	95068693          	addi	a3,a3,-1712 # 8000 <_entry-0x7fff8000>
    800006b8:	4605                	li	a2,1
    800006ba:	067e                	slli	a2,a2,0x1f
    800006bc:	85b2                	mv	a1,a2
    800006be:	8526                	mv	a0,s1
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	f50080e7          	jalr	-176(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006c8:	4719                	li	a4,6
    800006ca:	46c5                	li	a3,17
    800006cc:	06ee                	slli	a3,a3,0x1b
    800006ce:	412686b3          	sub	a3,a3,s2
    800006d2:	864a                	mv	a2,s2
    800006d4:	85ca                	mv	a1,s2
    800006d6:	8526                	mv	a0,s1
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	f38080e7          	jalr	-200(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006e0:	4729                	li	a4,10
    800006e2:	6685                	lui	a3,0x1
    800006e4:	00007617          	auipc	a2,0x7
    800006e8:	91c60613          	addi	a2,a2,-1764 # 80007000 <_trampoline>
    800006ec:	040005b7          	lui	a1,0x4000
    800006f0:	15fd                	addi	a1,a1,-1
    800006f2:	05b2                	slli	a1,a1,0xc
    800006f4:	8526                	mv	a0,s1
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f1a080e7          	jalr	-230(ra) # 80000610 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006fe:	8526                	mv	a0,s1
    80000700:	00000097          	auipc	ra,0x0
    80000704:	63a080e7          	jalr	1594(ra) # 80000d3a <proc_mapstacks>
}
    80000708:	8526                	mv	a0,s1
    8000070a:	60e2                	ld	ra,24(sp)
    8000070c:	6442                	ld	s0,16(sp)
    8000070e:	64a2                	ld	s1,8(sp)
    80000710:	6902                	ld	s2,0(sp)
    80000712:	6105                	addi	sp,sp,32
    80000714:	8082                	ret

0000000080000716 <kvminit>:
{
    80000716:	1141                	addi	sp,sp,-16
    80000718:	e406                	sd	ra,8(sp)
    8000071a:	e022                	sd	s0,0(sp)
    8000071c:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000071e:	00000097          	auipc	ra,0x0
    80000722:	f22080e7          	jalr	-222(ra) # 80000640 <kvmmake>
    80000726:	00008797          	auipc	a5,0x8
    8000072a:	1aa7b923          	sd	a0,434(a5) # 800088d8 <kernel_pagetable>
}
    8000072e:	60a2                	ld	ra,8(sp)
    80000730:	6402                	ld	s0,0(sp)
    80000732:	0141                	addi	sp,sp,16
    80000734:	8082                	ret

0000000080000736 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000736:	715d                	addi	sp,sp,-80
    80000738:	e486                	sd	ra,72(sp)
    8000073a:	e0a2                	sd	s0,64(sp)
    8000073c:	fc26                	sd	s1,56(sp)
    8000073e:	f84a                	sd	s2,48(sp)
    80000740:	f44e                	sd	s3,40(sp)
    80000742:	f052                	sd	s4,32(sp)
    80000744:	ec56                	sd	s5,24(sp)
    80000746:	e85a                	sd	s6,16(sp)
    80000748:	e45e                	sd	s7,8(sp)
    8000074a:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000074c:	03459793          	slli	a5,a1,0x34
    80000750:	e795                	bnez	a5,8000077c <uvmunmap+0x46>
    80000752:	8a2a                	mv	s4,a0
    80000754:	892e                	mv	s2,a1
    80000756:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000758:	0632                	slli	a2,a2,0xc
    8000075a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000075e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000760:	6b05                	lui	s6,0x1
    80000762:	0735e863          	bltu	a1,s3,800007d2 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000766:	60a6                	ld	ra,72(sp)
    80000768:	6406                	ld	s0,64(sp)
    8000076a:	74e2                	ld	s1,56(sp)
    8000076c:	7942                	ld	s2,48(sp)
    8000076e:	79a2                	ld	s3,40(sp)
    80000770:	7a02                	ld	s4,32(sp)
    80000772:	6ae2                	ld	s5,24(sp)
    80000774:	6b42                	ld	s6,16(sp)
    80000776:	6ba2                	ld	s7,8(sp)
    80000778:	6161                	addi	sp,sp,80
    8000077a:	8082                	ret
    panic("uvmunmap: not aligned");
    8000077c:	00008517          	auipc	a0,0x8
    80000780:	94450513          	addi	a0,a0,-1724 # 800080c0 <etext+0xc0>
    80000784:	00005097          	auipc	ra,0x5
    80000788:	4be080e7          	jalr	1214(ra) # 80005c42 <panic>
      panic("uvmunmap: walk");
    8000078c:	00008517          	auipc	a0,0x8
    80000790:	94c50513          	addi	a0,a0,-1716 # 800080d8 <etext+0xd8>
    80000794:	00005097          	auipc	ra,0x5
    80000798:	4ae080e7          	jalr	1198(ra) # 80005c42 <panic>
      panic("uvmunmap: not mapped");
    8000079c:	00008517          	auipc	a0,0x8
    800007a0:	94c50513          	addi	a0,a0,-1716 # 800080e8 <etext+0xe8>
    800007a4:	00005097          	auipc	ra,0x5
    800007a8:	49e080e7          	jalr	1182(ra) # 80005c42 <panic>
      panic("uvmunmap: not a leaf");
    800007ac:	00008517          	auipc	a0,0x8
    800007b0:	95450513          	addi	a0,a0,-1708 # 80008100 <etext+0x100>
    800007b4:	00005097          	auipc	ra,0x5
    800007b8:	48e080e7          	jalr	1166(ra) # 80005c42 <panic>
      uint64 pa = PTE2PA(*pte);
    800007bc:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007be:	0532                	slli	a0,a0,0xc
    800007c0:	00000097          	auipc	ra,0x0
    800007c4:	85c080e7          	jalr	-1956(ra) # 8000001c <kfree>
    *pte = 0;
    800007c8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007cc:	995a                	add	s2,s2,s6
    800007ce:	f9397ce3          	bgeu	s2,s3,80000766 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007d2:	4601                	li	a2,0
    800007d4:	85ca                	mv	a1,s2
    800007d6:	8552                	mv	a0,s4
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	c8c080e7          	jalr	-884(ra) # 80000464 <walk>
    800007e0:	84aa                	mv	s1,a0
    800007e2:	d54d                	beqz	a0,8000078c <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007e4:	6108                	ld	a0,0(a0)
    800007e6:	00157793          	andi	a5,a0,1
    800007ea:	dbcd                	beqz	a5,8000079c <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007ec:	3ff57793          	andi	a5,a0,1023
    800007f0:	fb778ee3          	beq	a5,s7,800007ac <uvmunmap+0x76>
    if(do_free){
    800007f4:	fc0a8ae3          	beqz	s5,800007c8 <uvmunmap+0x92>
    800007f8:	b7d1                	j	800007bc <uvmunmap+0x86>

00000000800007fa <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007fa:	1101                	addi	sp,sp,-32
    800007fc:	ec06                	sd	ra,24(sp)
    800007fe:	e822                	sd	s0,16(sp)
    80000800:	e426                	sd	s1,8(sp)
    80000802:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000804:	00000097          	auipc	ra,0x0
    80000808:	914080e7          	jalr	-1772(ra) # 80000118 <kalloc>
    8000080c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000080e:	c519                	beqz	a0,8000081c <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000810:	6605                	lui	a2,0x1
    80000812:	4581                	li	a1,0
    80000814:	00000097          	auipc	ra,0x0
    80000818:	964080e7          	jalr	-1692(ra) # 80000178 <memset>
  return pagetable;
}
    8000081c:	8526                	mv	a0,s1
    8000081e:	60e2                	ld	ra,24(sp)
    80000820:	6442                	ld	s0,16(sp)
    80000822:	64a2                	ld	s1,8(sp)
    80000824:	6105                	addi	sp,sp,32
    80000826:	8082                	ret

0000000080000828 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000828:	7179                	addi	sp,sp,-48
    8000082a:	f406                	sd	ra,40(sp)
    8000082c:	f022                	sd	s0,32(sp)
    8000082e:	ec26                	sd	s1,24(sp)
    80000830:	e84a                	sd	s2,16(sp)
    80000832:	e44e                	sd	s3,8(sp)
    80000834:	e052                	sd	s4,0(sp)
    80000836:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000838:	6785                	lui	a5,0x1
    8000083a:	04f67863          	bgeu	a2,a5,8000088a <uvmfirst+0x62>
    8000083e:	8a2a                	mv	s4,a0
    80000840:	89ae                	mv	s3,a1
    80000842:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000844:	00000097          	auipc	ra,0x0
    80000848:	8d4080e7          	jalr	-1836(ra) # 80000118 <kalloc>
    8000084c:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000084e:	6605                	lui	a2,0x1
    80000850:	4581                	li	a1,0
    80000852:	00000097          	auipc	ra,0x0
    80000856:	926080e7          	jalr	-1754(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000085a:	4779                	li	a4,30
    8000085c:	86ca                	mv	a3,s2
    8000085e:	6605                	lui	a2,0x1
    80000860:	4581                	li	a1,0
    80000862:	8552                	mv	a0,s4
    80000864:	00000097          	auipc	ra,0x0
    80000868:	ce8080e7          	jalr	-792(ra) # 8000054c <mappages>
  memmove(mem, src, sz);
    8000086c:	8626                	mv	a2,s1
    8000086e:	85ce                	mv	a1,s3
    80000870:	854a                	mv	a0,s2
    80000872:	00000097          	auipc	ra,0x0
    80000876:	966080e7          	jalr	-1690(ra) # 800001d8 <memmove>
}
    8000087a:	70a2                	ld	ra,40(sp)
    8000087c:	7402                	ld	s0,32(sp)
    8000087e:	64e2                	ld	s1,24(sp)
    80000880:	6942                	ld	s2,16(sp)
    80000882:	69a2                	ld	s3,8(sp)
    80000884:	6a02                	ld	s4,0(sp)
    80000886:	6145                	addi	sp,sp,48
    80000888:	8082                	ret
    panic("uvmfirst: more than a page");
    8000088a:	00008517          	auipc	a0,0x8
    8000088e:	88e50513          	addi	a0,a0,-1906 # 80008118 <etext+0x118>
    80000892:	00005097          	auipc	ra,0x5
    80000896:	3b0080e7          	jalr	944(ra) # 80005c42 <panic>

000000008000089a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000089a:	1101                	addi	sp,sp,-32
    8000089c:	ec06                	sd	ra,24(sp)
    8000089e:	e822                	sd	s0,16(sp)
    800008a0:	e426                	sd	s1,8(sp)
    800008a2:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008a4:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008a6:	00b67d63          	bgeu	a2,a1,800008c0 <uvmdealloc+0x26>
    800008aa:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008ac:	6785                	lui	a5,0x1
    800008ae:	17fd                	addi	a5,a5,-1
    800008b0:	00f60733          	add	a4,a2,a5
    800008b4:	767d                	lui	a2,0xfffff
    800008b6:	8f71                	and	a4,a4,a2
    800008b8:	97ae                	add	a5,a5,a1
    800008ba:	8ff1                	and	a5,a5,a2
    800008bc:	00f76863          	bltu	a4,a5,800008cc <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008c0:	8526                	mv	a0,s1
    800008c2:	60e2                	ld	ra,24(sp)
    800008c4:	6442                	ld	s0,16(sp)
    800008c6:	64a2                	ld	s1,8(sp)
    800008c8:	6105                	addi	sp,sp,32
    800008ca:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008cc:	8f99                	sub	a5,a5,a4
    800008ce:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008d0:	4685                	li	a3,1
    800008d2:	0007861b          	sext.w	a2,a5
    800008d6:	85ba                	mv	a1,a4
    800008d8:	00000097          	auipc	ra,0x0
    800008dc:	e5e080e7          	jalr	-418(ra) # 80000736 <uvmunmap>
    800008e0:	b7c5                	j	800008c0 <uvmdealloc+0x26>

00000000800008e2 <uvmalloc>:
  if(newsz < oldsz)
    800008e2:	0ab66563          	bltu	a2,a1,8000098c <uvmalloc+0xaa>
{
    800008e6:	7139                	addi	sp,sp,-64
    800008e8:	fc06                	sd	ra,56(sp)
    800008ea:	f822                	sd	s0,48(sp)
    800008ec:	f426                	sd	s1,40(sp)
    800008ee:	f04a                	sd	s2,32(sp)
    800008f0:	ec4e                	sd	s3,24(sp)
    800008f2:	e852                	sd	s4,16(sp)
    800008f4:	e456                	sd	s5,8(sp)
    800008f6:	e05a                	sd	s6,0(sp)
    800008f8:	0080                	addi	s0,sp,64
    800008fa:	8aaa                	mv	s5,a0
    800008fc:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008fe:	6985                	lui	s3,0x1
    80000900:	19fd                	addi	s3,s3,-1
    80000902:	95ce                	add	a1,a1,s3
    80000904:	79fd                	lui	s3,0xfffff
    80000906:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000090a:	08c9f363          	bgeu	s3,a2,80000990 <uvmalloc+0xae>
    8000090e:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000910:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000914:	00000097          	auipc	ra,0x0
    80000918:	804080e7          	jalr	-2044(ra) # 80000118 <kalloc>
    8000091c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000091e:	c51d                	beqz	a0,8000094c <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000920:	6605                	lui	a2,0x1
    80000922:	4581                	li	a1,0
    80000924:	00000097          	auipc	ra,0x0
    80000928:	854080e7          	jalr	-1964(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000092c:	875a                	mv	a4,s6
    8000092e:	86a6                	mv	a3,s1
    80000930:	6605                	lui	a2,0x1
    80000932:	85ca                	mv	a1,s2
    80000934:	8556                	mv	a0,s5
    80000936:	00000097          	auipc	ra,0x0
    8000093a:	c16080e7          	jalr	-1002(ra) # 8000054c <mappages>
    8000093e:	e90d                	bnez	a0,80000970 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000940:	6785                	lui	a5,0x1
    80000942:	993e                	add	s2,s2,a5
    80000944:	fd4968e3          	bltu	s2,s4,80000914 <uvmalloc+0x32>
  return newsz;
    80000948:	8552                	mv	a0,s4
    8000094a:	a809                	j	8000095c <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    8000094c:	864e                	mv	a2,s3
    8000094e:	85ca                	mv	a1,s2
    80000950:	8556                	mv	a0,s5
    80000952:	00000097          	auipc	ra,0x0
    80000956:	f48080e7          	jalr	-184(ra) # 8000089a <uvmdealloc>
      return 0;
    8000095a:	4501                	li	a0,0
}
    8000095c:	70e2                	ld	ra,56(sp)
    8000095e:	7442                	ld	s0,48(sp)
    80000960:	74a2                	ld	s1,40(sp)
    80000962:	7902                	ld	s2,32(sp)
    80000964:	69e2                	ld	s3,24(sp)
    80000966:	6a42                	ld	s4,16(sp)
    80000968:	6aa2                	ld	s5,8(sp)
    8000096a:	6b02                	ld	s6,0(sp)
    8000096c:	6121                	addi	sp,sp,64
    8000096e:	8082                	ret
      kfree(mem);
    80000970:	8526                	mv	a0,s1
    80000972:	fffff097          	auipc	ra,0xfffff
    80000976:	6aa080e7          	jalr	1706(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000097a:	864e                	mv	a2,s3
    8000097c:	85ca                	mv	a1,s2
    8000097e:	8556                	mv	a0,s5
    80000980:	00000097          	auipc	ra,0x0
    80000984:	f1a080e7          	jalr	-230(ra) # 8000089a <uvmdealloc>
      return 0;
    80000988:	4501                	li	a0,0
    8000098a:	bfc9                	j	8000095c <uvmalloc+0x7a>
    return oldsz;
    8000098c:	852e                	mv	a0,a1
}
    8000098e:	8082                	ret
  return newsz;
    80000990:	8532                	mv	a0,a2
    80000992:	b7e9                	j	8000095c <uvmalloc+0x7a>

0000000080000994 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000994:	7179                	addi	sp,sp,-48
    80000996:	f406                	sd	ra,40(sp)
    80000998:	f022                	sd	s0,32(sp)
    8000099a:	ec26                	sd	s1,24(sp)
    8000099c:	e84a                	sd	s2,16(sp)
    8000099e:	e44e                	sd	s3,8(sp)
    800009a0:	e052                	sd	s4,0(sp)
    800009a2:	1800                	addi	s0,sp,48
    800009a4:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009a6:	84aa                	mv	s1,a0
    800009a8:	6905                	lui	s2,0x1
    800009aa:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ac:	4985                	li	s3,1
    800009ae:	a821                	j	800009c6 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009b0:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009b2:	0532                	slli	a0,a0,0xc
    800009b4:	00000097          	auipc	ra,0x0
    800009b8:	fe0080e7          	jalr	-32(ra) # 80000994 <freewalk>
      pagetable[i] = 0;
    800009bc:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009c0:	04a1                	addi	s1,s1,8
    800009c2:	03248163          	beq	s1,s2,800009e4 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009c6:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009c8:	00f57793          	andi	a5,a0,15
    800009cc:	ff3782e3          	beq	a5,s3,800009b0 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009d0:	8905                	andi	a0,a0,1
    800009d2:	d57d                	beqz	a0,800009c0 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009d4:	00007517          	auipc	a0,0x7
    800009d8:	76450513          	addi	a0,a0,1892 # 80008138 <etext+0x138>
    800009dc:	00005097          	auipc	ra,0x5
    800009e0:	266080e7          	jalr	614(ra) # 80005c42 <panic>
    }
  }
  kfree((void*)pagetable);
    800009e4:	8552                	mv	a0,s4
    800009e6:	fffff097          	auipc	ra,0xfffff
    800009ea:	636080e7          	jalr	1590(ra) # 8000001c <kfree>
}
    800009ee:	70a2                	ld	ra,40(sp)
    800009f0:	7402                	ld	s0,32(sp)
    800009f2:	64e2                	ld	s1,24(sp)
    800009f4:	6942                	ld	s2,16(sp)
    800009f6:	69a2                	ld	s3,8(sp)
    800009f8:	6a02                	ld	s4,0(sp)
    800009fa:	6145                	addi	sp,sp,48
    800009fc:	8082                	ret

00000000800009fe <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009fe:	1101                	addi	sp,sp,-32
    80000a00:	ec06                	sd	ra,24(sp)
    80000a02:	e822                	sd	s0,16(sp)
    80000a04:	e426                	sd	s1,8(sp)
    80000a06:	1000                	addi	s0,sp,32
    80000a08:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a0a:	e999                	bnez	a1,80000a20 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a0c:	8526                	mv	a0,s1
    80000a0e:	00000097          	auipc	ra,0x0
    80000a12:	f86080e7          	jalr	-122(ra) # 80000994 <freewalk>
}
    80000a16:	60e2                	ld	ra,24(sp)
    80000a18:	6442                	ld	s0,16(sp)
    80000a1a:	64a2                	ld	s1,8(sp)
    80000a1c:	6105                	addi	sp,sp,32
    80000a1e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a20:	6605                	lui	a2,0x1
    80000a22:	167d                	addi	a2,a2,-1
    80000a24:	962e                	add	a2,a2,a1
    80000a26:	4685                	li	a3,1
    80000a28:	8231                	srli	a2,a2,0xc
    80000a2a:	4581                	li	a1,0
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	d0a080e7          	jalr	-758(ra) # 80000736 <uvmunmap>
    80000a34:	bfe1                	j	80000a0c <uvmfree+0xe>

0000000080000a36 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a36:	c679                	beqz	a2,80000b04 <uvmcopy+0xce>
{
    80000a38:	715d                	addi	sp,sp,-80
    80000a3a:	e486                	sd	ra,72(sp)
    80000a3c:	e0a2                	sd	s0,64(sp)
    80000a3e:	fc26                	sd	s1,56(sp)
    80000a40:	f84a                	sd	s2,48(sp)
    80000a42:	f44e                	sd	s3,40(sp)
    80000a44:	f052                	sd	s4,32(sp)
    80000a46:	ec56                	sd	s5,24(sp)
    80000a48:	e85a                	sd	s6,16(sp)
    80000a4a:	e45e                	sd	s7,8(sp)
    80000a4c:	0880                	addi	s0,sp,80
    80000a4e:	8b2a                	mv	s6,a0
    80000a50:	8aae                	mv	s5,a1
    80000a52:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a54:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a56:	4601                	li	a2,0
    80000a58:	85ce                	mv	a1,s3
    80000a5a:	855a                	mv	a0,s6
    80000a5c:	00000097          	auipc	ra,0x0
    80000a60:	a08080e7          	jalr	-1528(ra) # 80000464 <walk>
    80000a64:	c531                	beqz	a0,80000ab0 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a66:	6118                	ld	a4,0(a0)
    80000a68:	00177793          	andi	a5,a4,1
    80000a6c:	cbb1                	beqz	a5,80000ac0 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a6e:	00a75593          	srli	a1,a4,0xa
    80000a72:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a76:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a7a:	fffff097          	auipc	ra,0xfffff
    80000a7e:	69e080e7          	jalr	1694(ra) # 80000118 <kalloc>
    80000a82:	892a                	mv	s2,a0
    80000a84:	c939                	beqz	a0,80000ada <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a86:	6605                	lui	a2,0x1
    80000a88:	85de                	mv	a1,s7
    80000a8a:	fffff097          	auipc	ra,0xfffff
    80000a8e:	74e080e7          	jalr	1870(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a92:	8726                	mv	a4,s1
    80000a94:	86ca                	mv	a3,s2
    80000a96:	6605                	lui	a2,0x1
    80000a98:	85ce                	mv	a1,s3
    80000a9a:	8556                	mv	a0,s5
    80000a9c:	00000097          	auipc	ra,0x0
    80000aa0:	ab0080e7          	jalr	-1360(ra) # 8000054c <mappages>
    80000aa4:	e515                	bnez	a0,80000ad0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000aa6:	6785                	lui	a5,0x1
    80000aa8:	99be                	add	s3,s3,a5
    80000aaa:	fb49e6e3          	bltu	s3,s4,80000a56 <uvmcopy+0x20>
    80000aae:	a081                	j	80000aee <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ab0:	00007517          	auipc	a0,0x7
    80000ab4:	69850513          	addi	a0,a0,1688 # 80008148 <etext+0x148>
    80000ab8:	00005097          	auipc	ra,0x5
    80000abc:	18a080e7          	jalr	394(ra) # 80005c42 <panic>
      panic("uvmcopy: page not present");
    80000ac0:	00007517          	auipc	a0,0x7
    80000ac4:	6a850513          	addi	a0,a0,1704 # 80008168 <etext+0x168>
    80000ac8:	00005097          	auipc	ra,0x5
    80000acc:	17a080e7          	jalr	378(ra) # 80005c42 <panic>
      kfree(mem);
    80000ad0:	854a                	mv	a0,s2
    80000ad2:	fffff097          	auipc	ra,0xfffff
    80000ad6:	54a080e7          	jalr	1354(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ada:	4685                	li	a3,1
    80000adc:	00c9d613          	srli	a2,s3,0xc
    80000ae0:	4581                	li	a1,0
    80000ae2:	8556                	mv	a0,s5
    80000ae4:	00000097          	auipc	ra,0x0
    80000ae8:	c52080e7          	jalr	-942(ra) # 80000736 <uvmunmap>
  return -1;
    80000aec:	557d                	li	a0,-1
}
    80000aee:	60a6                	ld	ra,72(sp)
    80000af0:	6406                	ld	s0,64(sp)
    80000af2:	74e2                	ld	s1,56(sp)
    80000af4:	7942                	ld	s2,48(sp)
    80000af6:	79a2                	ld	s3,40(sp)
    80000af8:	7a02                	ld	s4,32(sp)
    80000afa:	6ae2                	ld	s5,24(sp)
    80000afc:	6b42                	ld	s6,16(sp)
    80000afe:	6ba2                	ld	s7,8(sp)
    80000b00:	6161                	addi	sp,sp,80
    80000b02:	8082                	ret
  return 0;
    80000b04:	4501                	li	a0,0
}
    80000b06:	8082                	ret

0000000080000b08 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b08:	1141                	addi	sp,sp,-16
    80000b0a:	e406                	sd	ra,8(sp)
    80000b0c:	e022                	sd	s0,0(sp)
    80000b0e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b10:	4601                	li	a2,0
    80000b12:	00000097          	auipc	ra,0x0
    80000b16:	952080e7          	jalr	-1710(ra) # 80000464 <walk>
  if(pte == 0)
    80000b1a:	c901                	beqz	a0,80000b2a <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b1c:	611c                	ld	a5,0(a0)
    80000b1e:	9bbd                	andi	a5,a5,-17
    80000b20:	e11c                	sd	a5,0(a0)
}
    80000b22:	60a2                	ld	ra,8(sp)
    80000b24:	6402                	ld	s0,0(sp)
    80000b26:	0141                	addi	sp,sp,16
    80000b28:	8082                	ret
    panic("uvmclear");
    80000b2a:	00007517          	auipc	a0,0x7
    80000b2e:	65e50513          	addi	a0,a0,1630 # 80008188 <etext+0x188>
    80000b32:	00005097          	auipc	ra,0x5
    80000b36:	110080e7          	jalr	272(ra) # 80005c42 <panic>

0000000080000b3a <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000b3a:	cac9                	beqz	a3,80000bcc <copyout+0x92>
{
    80000b3c:	711d                	addi	sp,sp,-96
    80000b3e:	ec86                	sd	ra,88(sp)
    80000b40:	e8a2                	sd	s0,80(sp)
    80000b42:	e4a6                	sd	s1,72(sp)
    80000b44:	e0ca                	sd	s2,64(sp)
    80000b46:	fc4e                	sd	s3,56(sp)
    80000b48:	f852                	sd	s4,48(sp)
    80000b4a:	f456                	sd	s5,40(sp)
    80000b4c:	f05a                	sd	s6,32(sp)
    80000b4e:	ec5e                	sd	s7,24(sp)
    80000b50:	e862                	sd	s8,16(sp)
    80000b52:	e466                	sd	s9,8(sp)
    80000b54:	e06a                	sd	s10,0(sp)
    80000b56:	1080                	addi	s0,sp,96
    80000b58:	8baa                	mv	s7,a0
    80000b5a:	8aae                	mv	s5,a1
    80000b5c:	8b32                	mv	s6,a2
    80000b5e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b60:	74fd                	lui	s1,0xfffff
    80000b62:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000b64:	57fd                	li	a5,-1
    80000b66:	83e9                	srli	a5,a5,0x1a
    80000b68:	0697e463          	bltu	a5,s1,80000bd0 <copyout+0x96>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000b6c:	4cd5                	li	s9,21
    80000b6e:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000b70:	8c3e                	mv	s8,a5
    80000b72:	a035                	j	80000b9e <copyout+0x64>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000b74:	83a9                	srli	a5,a5,0xa
    80000b76:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b78:	409a8533          	sub	a0,s5,s1
    80000b7c:	0009061b          	sext.w	a2,s2
    80000b80:	85da                	mv	a1,s6
    80000b82:	953e                	add	a0,a0,a5
    80000b84:	fffff097          	auipc	ra,0xfffff
    80000b88:	654080e7          	jalr	1620(ra) # 800001d8 <memmove>

    len -= n;
    80000b8c:	412989b3          	sub	s3,s3,s2
    src += n;
    80000b90:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000b92:	02098b63          	beqz	s3,80000bc8 <copyout+0x8e>
    if(va0 >= MAXVA)
    80000b96:	034c6f63          	bltu	s8,s4,80000bd4 <copyout+0x9a>
    va0 = PGROUNDDOWN(dstva);
    80000b9a:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    80000b9c:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000b9e:	4601                	li	a2,0
    80000ba0:	85a6                	mv	a1,s1
    80000ba2:	855e                	mv	a0,s7
    80000ba4:	00000097          	auipc	ra,0x0
    80000ba8:	8c0080e7          	jalr	-1856(ra) # 80000464 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000bac:	c515                	beqz	a0,80000bd8 <copyout+0x9e>
    80000bae:	611c                	ld	a5,0(a0)
    80000bb0:	0157f713          	andi	a4,a5,21
    80000bb4:	05971163          	bne	a4,s9,80000bf6 <copyout+0xbc>
    n = PGSIZE - (dstva - va0);
    80000bb8:	01a48a33          	add	s4,s1,s10
    80000bbc:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000bc0:	fb29fae3          	bgeu	s3,s2,80000b74 <copyout+0x3a>
    80000bc4:	894e                	mv	s2,s3
    80000bc6:	b77d                	j	80000b74 <copyout+0x3a>
  }
  return 0;
    80000bc8:	4501                	li	a0,0
    80000bca:	a801                	j	80000bda <copyout+0xa0>
    80000bcc:	4501                	li	a0,0
}
    80000bce:	8082                	ret
      return -1;
    80000bd0:	557d                	li	a0,-1
    80000bd2:	a021                	j	80000bda <copyout+0xa0>
    80000bd4:	557d                	li	a0,-1
    80000bd6:	a011                	j	80000bda <copyout+0xa0>
      return -1;
    80000bd8:	557d                	li	a0,-1
}
    80000bda:	60e6                	ld	ra,88(sp)
    80000bdc:	6446                	ld	s0,80(sp)
    80000bde:	64a6                	ld	s1,72(sp)
    80000be0:	6906                	ld	s2,64(sp)
    80000be2:	79e2                	ld	s3,56(sp)
    80000be4:	7a42                	ld	s4,48(sp)
    80000be6:	7aa2                	ld	s5,40(sp)
    80000be8:	7b02                	ld	s6,32(sp)
    80000bea:	6be2                	ld	s7,24(sp)
    80000bec:	6c42                	ld	s8,16(sp)
    80000bee:	6ca2                	ld	s9,8(sp)
    80000bf0:	6d02                	ld	s10,0(sp)
    80000bf2:	6125                	addi	sp,sp,96
    80000bf4:	8082                	ret
      return -1;
    80000bf6:	557d                	li	a0,-1
    80000bf8:	b7cd                	j	80000bda <copyout+0xa0>

0000000080000bfa <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bfa:	c6bd                	beqz	a3,80000c68 <copyin+0x6e>
{
    80000bfc:	715d                	addi	sp,sp,-80
    80000bfe:	e486                	sd	ra,72(sp)
    80000c00:	e0a2                	sd	s0,64(sp)
    80000c02:	fc26                	sd	s1,56(sp)
    80000c04:	f84a                	sd	s2,48(sp)
    80000c06:	f44e                	sd	s3,40(sp)
    80000c08:	f052                	sd	s4,32(sp)
    80000c0a:	ec56                	sd	s5,24(sp)
    80000c0c:	e85a                	sd	s6,16(sp)
    80000c0e:	e45e                	sd	s7,8(sp)
    80000c10:	e062                	sd	s8,0(sp)
    80000c12:	0880                	addi	s0,sp,80
    80000c14:	8b2a                	mv	s6,a0
    80000c16:	8a2e                	mv	s4,a1
    80000c18:	8c32                	mv	s8,a2
    80000c1a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c1c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c1e:	6a85                	lui	s5,0x1
    80000c20:	a015                	j	80000c44 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c22:	9562                	add	a0,a0,s8
    80000c24:	0004861b          	sext.w	a2,s1
    80000c28:	412505b3          	sub	a1,a0,s2
    80000c2c:	8552                	mv	a0,s4
    80000c2e:	fffff097          	auipc	ra,0xfffff
    80000c32:	5aa080e7          	jalr	1450(ra) # 800001d8 <memmove>

    len -= n;
    80000c36:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c3a:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c3c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c40:	02098263          	beqz	s3,80000c64 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c44:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c48:	85ca                	mv	a1,s2
    80000c4a:	855a                	mv	a0,s6
    80000c4c:	00000097          	auipc	ra,0x0
    80000c50:	8be080e7          	jalr	-1858(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000c54:	cd01                	beqz	a0,80000c6c <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c56:	418904b3          	sub	s1,s2,s8
    80000c5a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c5c:	fc99f3e3          	bgeu	s3,s1,80000c22 <copyin+0x28>
    80000c60:	84ce                	mv	s1,s3
    80000c62:	b7c1                	j	80000c22 <copyin+0x28>
  }
  return 0;
    80000c64:	4501                	li	a0,0
    80000c66:	a021                	j	80000c6e <copyin+0x74>
    80000c68:	4501                	li	a0,0
}
    80000c6a:	8082                	ret
      return -1;
    80000c6c:	557d                	li	a0,-1
}
    80000c6e:	60a6                	ld	ra,72(sp)
    80000c70:	6406                	ld	s0,64(sp)
    80000c72:	74e2                	ld	s1,56(sp)
    80000c74:	7942                	ld	s2,48(sp)
    80000c76:	79a2                	ld	s3,40(sp)
    80000c78:	7a02                	ld	s4,32(sp)
    80000c7a:	6ae2                	ld	s5,24(sp)
    80000c7c:	6b42                	ld	s6,16(sp)
    80000c7e:	6ba2                	ld	s7,8(sp)
    80000c80:	6c02                	ld	s8,0(sp)
    80000c82:	6161                	addi	sp,sp,80
    80000c84:	8082                	ret

0000000080000c86 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c86:	c6c5                	beqz	a3,80000d2e <copyinstr+0xa8>
{
    80000c88:	715d                	addi	sp,sp,-80
    80000c8a:	e486                	sd	ra,72(sp)
    80000c8c:	e0a2                	sd	s0,64(sp)
    80000c8e:	fc26                	sd	s1,56(sp)
    80000c90:	f84a                	sd	s2,48(sp)
    80000c92:	f44e                	sd	s3,40(sp)
    80000c94:	f052                	sd	s4,32(sp)
    80000c96:	ec56                	sd	s5,24(sp)
    80000c98:	e85a                	sd	s6,16(sp)
    80000c9a:	e45e                	sd	s7,8(sp)
    80000c9c:	0880                	addi	s0,sp,80
    80000c9e:	8a2a                	mv	s4,a0
    80000ca0:	8b2e                	mv	s6,a1
    80000ca2:	8bb2                	mv	s7,a2
    80000ca4:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000ca6:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ca8:	6985                	lui	s3,0x1
    80000caa:	a035                	j	80000cd6 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000cac:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000cb0:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000cb2:	0017b793          	seqz	a5,a5
    80000cb6:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cba:	60a6                	ld	ra,72(sp)
    80000cbc:	6406                	ld	s0,64(sp)
    80000cbe:	74e2                	ld	s1,56(sp)
    80000cc0:	7942                	ld	s2,48(sp)
    80000cc2:	79a2                	ld	s3,40(sp)
    80000cc4:	7a02                	ld	s4,32(sp)
    80000cc6:	6ae2                	ld	s5,24(sp)
    80000cc8:	6b42                	ld	s6,16(sp)
    80000cca:	6ba2                	ld	s7,8(sp)
    80000ccc:	6161                	addi	sp,sp,80
    80000cce:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cd0:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cd4:	c8a9                	beqz	s1,80000d26 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cd6:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cda:	85ca                	mv	a1,s2
    80000cdc:	8552                	mv	a0,s4
    80000cde:	00000097          	auipc	ra,0x0
    80000ce2:	82c080e7          	jalr	-2004(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000ce6:	c131                	beqz	a0,80000d2a <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000ce8:	41790833          	sub	a6,s2,s7
    80000cec:	984e                	add	a6,a6,s3
    if(n > max)
    80000cee:	0104f363          	bgeu	s1,a6,80000cf4 <copyinstr+0x6e>
    80000cf2:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cf4:	955e                	add	a0,a0,s7
    80000cf6:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cfa:	fc080be3          	beqz	a6,80000cd0 <copyinstr+0x4a>
    80000cfe:	985a                	add	a6,a6,s6
    80000d00:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000d02:	41650633          	sub	a2,a0,s6
    80000d06:	14fd                	addi	s1,s1,-1
    80000d08:	9b26                	add	s6,s6,s1
    80000d0a:	00f60733          	add	a4,a2,a5
    80000d0e:	00074703          	lbu	a4,0(a4)
    80000d12:	df49                	beqz	a4,80000cac <copyinstr+0x26>
        *dst = *p;
    80000d14:	00e78023          	sb	a4,0(a5)
      --max;
    80000d18:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d1c:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d1e:	ff0796e3          	bne	a5,a6,80000d0a <copyinstr+0x84>
      dst++;
    80000d22:	8b42                	mv	s6,a6
    80000d24:	b775                	j	80000cd0 <copyinstr+0x4a>
    80000d26:	4781                	li	a5,0
    80000d28:	b769                	j	80000cb2 <copyinstr+0x2c>
      return -1;
    80000d2a:	557d                	li	a0,-1
    80000d2c:	b779                	j	80000cba <copyinstr+0x34>
  int got_null = 0;
    80000d2e:	4781                	li	a5,0
  if(got_null){
    80000d30:	0017b793          	seqz	a5,a5
    80000d34:	40f00533          	neg	a0,a5
}
    80000d38:	8082                	ret

0000000080000d3a <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d3a:	7139                	addi	sp,sp,-64
    80000d3c:	fc06                	sd	ra,56(sp)
    80000d3e:	f822                	sd	s0,48(sp)
    80000d40:	f426                	sd	s1,40(sp)
    80000d42:	f04a                	sd	s2,32(sp)
    80000d44:	ec4e                	sd	s3,24(sp)
    80000d46:	e852                	sd	s4,16(sp)
    80000d48:	e456                	sd	s5,8(sp)
    80000d4a:	e05a                	sd	s6,0(sp)
    80000d4c:	0080                	addi	s0,sp,64
    80000d4e:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d50:	00008497          	auipc	s1,0x8
    80000d54:	00048493          	mv	s1,s1
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d58:	8b26                	mv	s6,s1
    80000d5a:	00007a97          	auipc	s5,0x7
    80000d5e:	2a6a8a93          	addi	s5,s5,678 # 80008000 <etext>
    80000d62:	04000937          	lui	s2,0x4000
    80000d66:	197d                	addi	s2,s2,-1
    80000d68:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d6a:	0000ea17          	auipc	s4,0xe
    80000d6e:	9e6a0a13          	addi	s4,s4,-1562 # 8000e750 <tickslock>
    char *pa = kalloc();
    80000d72:	fffff097          	auipc	ra,0xfffff
    80000d76:	3a6080e7          	jalr	934(ra) # 80000118 <kalloc>
    80000d7a:	862a                	mv	a2,a0
    if(pa == 0)
    80000d7c:	c131                	beqz	a0,80000dc0 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d7e:	416485b3          	sub	a1,s1,s6
    80000d82:	858d                	srai	a1,a1,0x3
    80000d84:	000ab783          	ld	a5,0(s5)
    80000d88:	02f585b3          	mul	a1,a1,a5
    80000d8c:	2585                	addiw	a1,a1,1
    80000d8e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d92:	4719                	li	a4,6
    80000d94:	6685                	lui	a3,0x1
    80000d96:	40b905b3          	sub	a1,s2,a1
    80000d9a:	854e                	mv	a0,s3
    80000d9c:	00000097          	auipc	ra,0x0
    80000da0:	874080e7          	jalr	-1932(ra) # 80000610 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000da4:	16848493          	addi	s1,s1,360 # 80008eb8 <proc+0x168>
    80000da8:	fd4495e3          	bne	s1,s4,80000d72 <proc_mapstacks+0x38>
  }
}
    80000dac:	70e2                	ld	ra,56(sp)
    80000dae:	7442                	ld	s0,48(sp)
    80000db0:	74a2                	ld	s1,40(sp)
    80000db2:	7902                	ld	s2,32(sp)
    80000db4:	69e2                	ld	s3,24(sp)
    80000db6:	6a42                	ld	s4,16(sp)
    80000db8:	6aa2                	ld	s5,8(sp)
    80000dba:	6b02                	ld	s6,0(sp)
    80000dbc:	6121                	addi	sp,sp,64
    80000dbe:	8082                	ret
      panic("kalloc");
    80000dc0:	00007517          	auipc	a0,0x7
    80000dc4:	3d850513          	addi	a0,a0,984 # 80008198 <etext+0x198>
    80000dc8:	00005097          	auipc	ra,0x5
    80000dcc:	e7a080e7          	jalr	-390(ra) # 80005c42 <panic>

0000000080000dd0 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000dd0:	7139                	addi	sp,sp,-64
    80000dd2:	fc06                	sd	ra,56(sp)
    80000dd4:	f822                	sd	s0,48(sp)
    80000dd6:	f426                	sd	s1,40(sp)
    80000dd8:	f04a                	sd	s2,32(sp)
    80000dda:	ec4e                	sd	s3,24(sp)
    80000ddc:	e852                	sd	s4,16(sp)
    80000dde:	e456                	sd	s5,8(sp)
    80000de0:	e05a                	sd	s6,0(sp)
    80000de2:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000de4:	00007597          	auipc	a1,0x7
    80000de8:	3bc58593          	addi	a1,a1,956 # 800081a0 <etext+0x1a0>
    80000dec:	00008517          	auipc	a0,0x8
    80000df0:	b3450513          	addi	a0,a0,-1228 # 80008920 <pid_lock>
    80000df4:	00005097          	auipc	ra,0x5
    80000df8:	308080e7          	jalr	776(ra) # 800060fc <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dfc:	00007597          	auipc	a1,0x7
    80000e00:	3ac58593          	addi	a1,a1,940 # 800081a8 <etext+0x1a8>
    80000e04:	00008517          	auipc	a0,0x8
    80000e08:	b3450513          	addi	a0,a0,-1228 # 80008938 <wait_lock>
    80000e0c:	00005097          	auipc	ra,0x5
    80000e10:	2f0080e7          	jalr	752(ra) # 800060fc <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e14:	00008497          	auipc	s1,0x8
    80000e18:	f3c48493          	addi	s1,s1,-196 # 80008d50 <proc>
      initlock(&p->lock, "proc");
    80000e1c:	00007b17          	auipc	s6,0x7
    80000e20:	39cb0b13          	addi	s6,s6,924 # 800081b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000e24:	8aa6                	mv	s5,s1
    80000e26:	00007a17          	auipc	s4,0x7
    80000e2a:	1daa0a13          	addi	s4,s4,474 # 80008000 <etext>
    80000e2e:	04000937          	lui	s2,0x4000
    80000e32:	197d                	addi	s2,s2,-1
    80000e34:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e36:	0000e997          	auipc	s3,0xe
    80000e3a:	91a98993          	addi	s3,s3,-1766 # 8000e750 <tickslock>
      initlock(&p->lock, "proc");
    80000e3e:	85da                	mv	a1,s6
    80000e40:	8526                	mv	a0,s1
    80000e42:	00005097          	auipc	ra,0x5
    80000e46:	2ba080e7          	jalr	698(ra) # 800060fc <initlock>
      p->state = UNUSED;
    80000e4a:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000e4e:	415487b3          	sub	a5,s1,s5
    80000e52:	878d                	srai	a5,a5,0x3
    80000e54:	000a3703          	ld	a4,0(s4)
    80000e58:	02e787b3          	mul	a5,a5,a4
    80000e5c:	2785                	addiw	a5,a5,1
    80000e5e:	00d7979b          	slliw	a5,a5,0xd
    80000e62:	40f907b3          	sub	a5,s2,a5
    80000e66:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e68:	16848493          	addi	s1,s1,360
    80000e6c:	fd3499e3          	bne	s1,s3,80000e3e <procinit+0x6e>
  }
}
    80000e70:	70e2                	ld	ra,56(sp)
    80000e72:	7442                	ld	s0,48(sp)
    80000e74:	74a2                	ld	s1,40(sp)
    80000e76:	7902                	ld	s2,32(sp)
    80000e78:	69e2                	ld	s3,24(sp)
    80000e7a:	6a42                	ld	s4,16(sp)
    80000e7c:	6aa2                	ld	s5,8(sp)
    80000e7e:	6b02                	ld	s6,0(sp)
    80000e80:	6121                	addi	sp,sp,64
    80000e82:	8082                	ret

0000000080000e84 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e84:	1141                	addi	sp,sp,-16
    80000e86:	e422                	sd	s0,8(sp)
    80000e88:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e8a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e8c:	2501                	sext.w	a0,a0
    80000e8e:	6422                	ld	s0,8(sp)
    80000e90:	0141                	addi	sp,sp,16
    80000e92:	8082                	ret

0000000080000e94 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e94:	1141                	addi	sp,sp,-16
    80000e96:	e422                	sd	s0,8(sp)
    80000e98:	0800                	addi	s0,sp,16
    80000e9a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e9c:	2781                	sext.w	a5,a5
    80000e9e:	079e                	slli	a5,a5,0x7
  return c;
}
    80000ea0:	00008517          	auipc	a0,0x8
    80000ea4:	ab050513          	addi	a0,a0,-1360 # 80008950 <cpus>
    80000ea8:	953e                	add	a0,a0,a5
    80000eaa:	6422                	ld	s0,8(sp)
    80000eac:	0141                	addi	sp,sp,16
    80000eae:	8082                	ret

0000000080000eb0 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000eb0:	1101                	addi	sp,sp,-32
    80000eb2:	ec06                	sd	ra,24(sp)
    80000eb4:	e822                	sd	s0,16(sp)
    80000eb6:	e426                	sd	s1,8(sp)
    80000eb8:	1000                	addi	s0,sp,32
  push_off();
    80000eba:	00005097          	auipc	ra,0x5
    80000ebe:	286080e7          	jalr	646(ra) # 80006140 <push_off>
    80000ec2:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ec4:	2781                	sext.w	a5,a5
    80000ec6:	079e                	slli	a5,a5,0x7
    80000ec8:	00008717          	auipc	a4,0x8
    80000ecc:	a5870713          	addi	a4,a4,-1448 # 80008920 <pid_lock>
    80000ed0:	97ba                	add	a5,a5,a4
    80000ed2:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ed4:	00005097          	auipc	ra,0x5
    80000ed8:	30c080e7          	jalr	780(ra) # 800061e0 <pop_off>
  return p;
}
    80000edc:	8526                	mv	a0,s1
    80000ede:	60e2                	ld	ra,24(sp)
    80000ee0:	6442                	ld	s0,16(sp)
    80000ee2:	64a2                	ld	s1,8(sp)
    80000ee4:	6105                	addi	sp,sp,32
    80000ee6:	8082                	ret

0000000080000ee8 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ee8:	1141                	addi	sp,sp,-16
    80000eea:	e406                	sd	ra,8(sp)
    80000eec:	e022                	sd	s0,0(sp)
    80000eee:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ef0:	00000097          	auipc	ra,0x0
    80000ef4:	fc0080e7          	jalr	-64(ra) # 80000eb0 <myproc>
    80000ef8:	00005097          	auipc	ra,0x5
    80000efc:	348080e7          	jalr	840(ra) # 80006240 <release>

  if (first) {
    80000f00:	00008797          	auipc	a5,0x8
    80000f04:	9807a783          	lw	a5,-1664(a5) # 80008880 <first.1678>
    80000f08:	eb89                	bnez	a5,80000f1a <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000f0a:	00001097          	auipc	ra,0x1
    80000f0e:	c5a080e7          	jalr	-934(ra) # 80001b64 <usertrapret>
}
    80000f12:	60a2                	ld	ra,8(sp)
    80000f14:	6402                	ld	s0,0(sp)
    80000f16:	0141                	addi	sp,sp,16
    80000f18:	8082                	ret
    fsinit(ROOTDEV);
    80000f1a:	4505                	li	a0,1
    80000f1c:	00002097          	auipc	ra,0x2
    80000f20:	9a6080e7          	jalr	-1626(ra) # 800028c2 <fsinit>
    first = 0;
    80000f24:	00008797          	auipc	a5,0x8
    80000f28:	9407ae23          	sw	zero,-1700(a5) # 80008880 <first.1678>
    __sync_synchronize();
    80000f2c:	0ff0000f          	fence
    80000f30:	bfe9                	j	80000f0a <forkret+0x22>

0000000080000f32 <allocpid>:
{
    80000f32:	1101                	addi	sp,sp,-32
    80000f34:	ec06                	sd	ra,24(sp)
    80000f36:	e822                	sd	s0,16(sp)
    80000f38:	e426                	sd	s1,8(sp)
    80000f3a:	e04a                	sd	s2,0(sp)
    80000f3c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f3e:	00008917          	auipc	s2,0x8
    80000f42:	9e290913          	addi	s2,s2,-1566 # 80008920 <pid_lock>
    80000f46:	854a                	mv	a0,s2
    80000f48:	00005097          	auipc	ra,0x5
    80000f4c:	244080e7          	jalr	580(ra) # 8000618c <acquire>
  pid = nextpid;
    80000f50:	00008797          	auipc	a5,0x8
    80000f54:	93478793          	addi	a5,a5,-1740 # 80008884 <nextpid>
    80000f58:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f5a:	0014871b          	addiw	a4,s1,1
    80000f5e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f60:	854a                	mv	a0,s2
    80000f62:	00005097          	auipc	ra,0x5
    80000f66:	2de080e7          	jalr	734(ra) # 80006240 <release>
}
    80000f6a:	8526                	mv	a0,s1
    80000f6c:	60e2                	ld	ra,24(sp)
    80000f6e:	6442                	ld	s0,16(sp)
    80000f70:	64a2                	ld	s1,8(sp)
    80000f72:	6902                	ld	s2,0(sp)
    80000f74:	6105                	addi	sp,sp,32
    80000f76:	8082                	ret

0000000080000f78 <proc_pagetable>:
{
    80000f78:	1101                	addi	sp,sp,-32
    80000f7a:	ec06                	sd	ra,24(sp)
    80000f7c:	e822                	sd	s0,16(sp)
    80000f7e:	e426                	sd	s1,8(sp)
    80000f80:	e04a                	sd	s2,0(sp)
    80000f82:	1000                	addi	s0,sp,32
    80000f84:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f86:	00000097          	auipc	ra,0x0
    80000f8a:	874080e7          	jalr	-1932(ra) # 800007fa <uvmcreate>
    80000f8e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f90:	c121                	beqz	a0,80000fd0 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f92:	4729                	li	a4,10
    80000f94:	00006697          	auipc	a3,0x6
    80000f98:	06c68693          	addi	a3,a3,108 # 80007000 <_trampoline>
    80000f9c:	6605                	lui	a2,0x1
    80000f9e:	040005b7          	lui	a1,0x4000
    80000fa2:	15fd                	addi	a1,a1,-1
    80000fa4:	05b2                	slli	a1,a1,0xc
    80000fa6:	fffff097          	auipc	ra,0xfffff
    80000faa:	5a6080e7          	jalr	1446(ra) # 8000054c <mappages>
    80000fae:	02054863          	bltz	a0,80000fde <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fb2:	4719                	li	a4,6
    80000fb4:	05893683          	ld	a3,88(s2)
    80000fb8:	6605                	lui	a2,0x1
    80000fba:	020005b7          	lui	a1,0x2000
    80000fbe:	15fd                	addi	a1,a1,-1
    80000fc0:	05b6                	slli	a1,a1,0xd
    80000fc2:	8526                	mv	a0,s1
    80000fc4:	fffff097          	auipc	ra,0xfffff
    80000fc8:	588080e7          	jalr	1416(ra) # 8000054c <mappages>
    80000fcc:	02054163          	bltz	a0,80000fee <proc_pagetable+0x76>
}
    80000fd0:	8526                	mv	a0,s1
    80000fd2:	60e2                	ld	ra,24(sp)
    80000fd4:	6442                	ld	s0,16(sp)
    80000fd6:	64a2                	ld	s1,8(sp)
    80000fd8:	6902                	ld	s2,0(sp)
    80000fda:	6105                	addi	sp,sp,32
    80000fdc:	8082                	ret
    uvmfree(pagetable, 0);
    80000fde:	4581                	li	a1,0
    80000fe0:	8526                	mv	a0,s1
    80000fe2:	00000097          	auipc	ra,0x0
    80000fe6:	a1c080e7          	jalr	-1508(ra) # 800009fe <uvmfree>
    return 0;
    80000fea:	4481                	li	s1,0
    80000fec:	b7d5                	j	80000fd0 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fee:	4681                	li	a3,0
    80000ff0:	4605                	li	a2,1
    80000ff2:	040005b7          	lui	a1,0x4000
    80000ff6:	15fd                	addi	a1,a1,-1
    80000ff8:	05b2                	slli	a1,a1,0xc
    80000ffa:	8526                	mv	a0,s1
    80000ffc:	fffff097          	auipc	ra,0xfffff
    80001000:	73a080e7          	jalr	1850(ra) # 80000736 <uvmunmap>
    uvmfree(pagetable, 0);
    80001004:	4581                	li	a1,0
    80001006:	8526                	mv	a0,s1
    80001008:	00000097          	auipc	ra,0x0
    8000100c:	9f6080e7          	jalr	-1546(ra) # 800009fe <uvmfree>
    return 0;
    80001010:	4481                	li	s1,0
    80001012:	bf7d                	j	80000fd0 <proc_pagetable+0x58>

0000000080001014 <proc_freepagetable>:
{
    80001014:	1101                	addi	sp,sp,-32
    80001016:	ec06                	sd	ra,24(sp)
    80001018:	e822                	sd	s0,16(sp)
    8000101a:	e426                	sd	s1,8(sp)
    8000101c:	e04a                	sd	s2,0(sp)
    8000101e:	1000                	addi	s0,sp,32
    80001020:	84aa                	mv	s1,a0
    80001022:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001024:	4681                	li	a3,0
    80001026:	4605                	li	a2,1
    80001028:	040005b7          	lui	a1,0x4000
    8000102c:	15fd                	addi	a1,a1,-1
    8000102e:	05b2                	slli	a1,a1,0xc
    80001030:	fffff097          	auipc	ra,0xfffff
    80001034:	706080e7          	jalr	1798(ra) # 80000736 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001038:	4681                	li	a3,0
    8000103a:	4605                	li	a2,1
    8000103c:	020005b7          	lui	a1,0x2000
    80001040:	15fd                	addi	a1,a1,-1
    80001042:	05b6                	slli	a1,a1,0xd
    80001044:	8526                	mv	a0,s1
    80001046:	fffff097          	auipc	ra,0xfffff
    8000104a:	6f0080e7          	jalr	1776(ra) # 80000736 <uvmunmap>
  uvmfree(pagetable, sz);
    8000104e:	85ca                	mv	a1,s2
    80001050:	8526                	mv	a0,s1
    80001052:	00000097          	auipc	ra,0x0
    80001056:	9ac080e7          	jalr	-1620(ra) # 800009fe <uvmfree>
}
    8000105a:	60e2                	ld	ra,24(sp)
    8000105c:	6442                	ld	s0,16(sp)
    8000105e:	64a2                	ld	s1,8(sp)
    80001060:	6902                	ld	s2,0(sp)
    80001062:	6105                	addi	sp,sp,32
    80001064:	8082                	ret

0000000080001066 <freeproc>:
{
    80001066:	1101                	addi	sp,sp,-32
    80001068:	ec06                	sd	ra,24(sp)
    8000106a:	e822                	sd	s0,16(sp)
    8000106c:	e426                	sd	s1,8(sp)
    8000106e:	1000                	addi	s0,sp,32
    80001070:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001072:	6d28                	ld	a0,88(a0)
    80001074:	c509                	beqz	a0,8000107e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001076:	fffff097          	auipc	ra,0xfffff
    8000107a:	fa6080e7          	jalr	-90(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000107e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001082:	68a8                	ld	a0,80(s1)
    80001084:	c511                	beqz	a0,80001090 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001086:	64ac                	ld	a1,72(s1)
    80001088:	00000097          	auipc	ra,0x0
    8000108c:	f8c080e7          	jalr	-116(ra) # 80001014 <proc_freepagetable>
  p->pagetable = 0;
    80001090:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001094:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001098:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000109c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800010a0:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800010a4:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800010a8:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800010ac:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800010b0:	0004ac23          	sw	zero,24(s1)
}
    800010b4:	60e2                	ld	ra,24(sp)
    800010b6:	6442                	ld	s0,16(sp)
    800010b8:	64a2                	ld	s1,8(sp)
    800010ba:	6105                	addi	sp,sp,32
    800010bc:	8082                	ret

00000000800010be <allocproc>:
{
    800010be:	1101                	addi	sp,sp,-32
    800010c0:	ec06                	sd	ra,24(sp)
    800010c2:	e822                	sd	s0,16(sp)
    800010c4:	e426                	sd	s1,8(sp)
    800010c6:	e04a                	sd	s2,0(sp)
    800010c8:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ca:	00008497          	auipc	s1,0x8
    800010ce:	c8648493          	addi	s1,s1,-890 # 80008d50 <proc>
    800010d2:	0000d917          	auipc	s2,0xd
    800010d6:	67e90913          	addi	s2,s2,1662 # 8000e750 <tickslock>
    acquire(&p->lock);
    800010da:	8526                	mv	a0,s1
    800010dc:	00005097          	auipc	ra,0x5
    800010e0:	0b0080e7          	jalr	176(ra) # 8000618c <acquire>
    if(p->state == UNUSED) {
    800010e4:	4c9c                	lw	a5,24(s1)
    800010e6:	cf81                	beqz	a5,800010fe <allocproc+0x40>
      release(&p->lock);
    800010e8:	8526                	mv	a0,s1
    800010ea:	00005097          	auipc	ra,0x5
    800010ee:	156080e7          	jalr	342(ra) # 80006240 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010f2:	16848493          	addi	s1,s1,360
    800010f6:	ff2492e3          	bne	s1,s2,800010da <allocproc+0x1c>
  return 0;
    800010fa:	4481                	li	s1,0
    800010fc:	a889                	j	8000114e <allocproc+0x90>
  p->pid = allocpid();
    800010fe:	00000097          	auipc	ra,0x0
    80001102:	e34080e7          	jalr	-460(ra) # 80000f32 <allocpid>
    80001106:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001108:	4785                	li	a5,1
    8000110a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000110c:	fffff097          	auipc	ra,0xfffff
    80001110:	00c080e7          	jalr	12(ra) # 80000118 <kalloc>
    80001114:	892a                	mv	s2,a0
    80001116:	eca8                	sd	a0,88(s1)
    80001118:	c131                	beqz	a0,8000115c <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    8000111a:	8526                	mv	a0,s1
    8000111c:	00000097          	auipc	ra,0x0
    80001120:	e5c080e7          	jalr	-420(ra) # 80000f78 <proc_pagetable>
    80001124:	892a                	mv	s2,a0
    80001126:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001128:	c531                	beqz	a0,80001174 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000112a:	07000613          	li	a2,112
    8000112e:	4581                	li	a1,0
    80001130:	06048513          	addi	a0,s1,96
    80001134:	fffff097          	auipc	ra,0xfffff
    80001138:	044080e7          	jalr	68(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    8000113c:	00000797          	auipc	a5,0x0
    80001140:	dac78793          	addi	a5,a5,-596 # 80000ee8 <forkret>
    80001144:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001146:	60bc                	ld	a5,64(s1)
    80001148:	6705                	lui	a4,0x1
    8000114a:	97ba                	add	a5,a5,a4
    8000114c:	f4bc                	sd	a5,104(s1)
}
    8000114e:	8526                	mv	a0,s1
    80001150:	60e2                	ld	ra,24(sp)
    80001152:	6442                	ld	s0,16(sp)
    80001154:	64a2                	ld	s1,8(sp)
    80001156:	6902                	ld	s2,0(sp)
    80001158:	6105                	addi	sp,sp,32
    8000115a:	8082                	ret
    freeproc(p);
    8000115c:	8526                	mv	a0,s1
    8000115e:	00000097          	auipc	ra,0x0
    80001162:	f08080e7          	jalr	-248(ra) # 80001066 <freeproc>
    release(&p->lock);
    80001166:	8526                	mv	a0,s1
    80001168:	00005097          	auipc	ra,0x5
    8000116c:	0d8080e7          	jalr	216(ra) # 80006240 <release>
    return 0;
    80001170:	84ca                	mv	s1,s2
    80001172:	bff1                	j	8000114e <allocproc+0x90>
    freeproc(p);
    80001174:	8526                	mv	a0,s1
    80001176:	00000097          	auipc	ra,0x0
    8000117a:	ef0080e7          	jalr	-272(ra) # 80001066 <freeproc>
    release(&p->lock);
    8000117e:	8526                	mv	a0,s1
    80001180:	00005097          	auipc	ra,0x5
    80001184:	0c0080e7          	jalr	192(ra) # 80006240 <release>
    return 0;
    80001188:	84ca                	mv	s1,s2
    8000118a:	b7d1                	j	8000114e <allocproc+0x90>

000000008000118c <userinit>:
{
    8000118c:	1101                	addi	sp,sp,-32
    8000118e:	ec06                	sd	ra,24(sp)
    80001190:	e822                	sd	s0,16(sp)
    80001192:	e426                	sd	s1,8(sp)
    80001194:	1000                	addi	s0,sp,32
  p = allocproc();
    80001196:	00000097          	auipc	ra,0x0
    8000119a:	f28080e7          	jalr	-216(ra) # 800010be <allocproc>
    8000119e:	84aa                	mv	s1,a0
  initproc = p;
    800011a0:	00007797          	auipc	a5,0x7
    800011a4:	74a7b023          	sd	a0,1856(a5) # 800088e0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800011a8:	03400613          	li	a2,52
    800011ac:	00007597          	auipc	a1,0x7
    800011b0:	6e458593          	addi	a1,a1,1764 # 80008890 <initcode>
    800011b4:	6928                	ld	a0,80(a0)
    800011b6:	fffff097          	auipc	ra,0xfffff
    800011ba:	672080e7          	jalr	1650(ra) # 80000828 <uvmfirst>
  p->sz = PGSIZE;
    800011be:	6785                	lui	a5,0x1
    800011c0:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011c2:	6cb8                	ld	a4,88(s1)
    800011c4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011c8:	6cb8                	ld	a4,88(s1)
    800011ca:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011cc:	4641                	li	a2,16
    800011ce:	00007597          	auipc	a1,0x7
    800011d2:	ff258593          	addi	a1,a1,-14 # 800081c0 <etext+0x1c0>
    800011d6:	15848513          	addi	a0,s1,344
    800011da:	fffff097          	auipc	ra,0xfffff
    800011de:	0f0080e7          	jalr	240(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    800011e2:	00007517          	auipc	a0,0x7
    800011e6:	fee50513          	addi	a0,a0,-18 # 800081d0 <etext+0x1d0>
    800011ea:	00002097          	auipc	ra,0x2
    800011ee:	0fa080e7          	jalr	250(ra) # 800032e4 <namei>
    800011f2:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011f6:	478d                	li	a5,3
    800011f8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011fa:	8526                	mv	a0,s1
    800011fc:	00005097          	auipc	ra,0x5
    80001200:	044080e7          	jalr	68(ra) # 80006240 <release>
}
    80001204:	60e2                	ld	ra,24(sp)
    80001206:	6442                	ld	s0,16(sp)
    80001208:	64a2                	ld	s1,8(sp)
    8000120a:	6105                	addi	sp,sp,32
    8000120c:	8082                	ret

000000008000120e <growproc>:
{
    8000120e:	1101                	addi	sp,sp,-32
    80001210:	ec06                	sd	ra,24(sp)
    80001212:	e822                	sd	s0,16(sp)
    80001214:	e426                	sd	s1,8(sp)
    80001216:	e04a                	sd	s2,0(sp)
    80001218:	1000                	addi	s0,sp,32
    8000121a:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000121c:	00000097          	auipc	ra,0x0
    80001220:	c94080e7          	jalr	-876(ra) # 80000eb0 <myproc>
    80001224:	84aa                	mv	s1,a0
  sz = p->sz;
    80001226:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001228:	01204c63          	bgtz	s2,80001240 <growproc+0x32>
  } else if(n < 0){
    8000122c:	02094663          	bltz	s2,80001258 <growproc+0x4a>
  p->sz = sz;
    80001230:	e4ac                	sd	a1,72(s1)
  return 0;
    80001232:	4501                	li	a0,0
}
    80001234:	60e2                	ld	ra,24(sp)
    80001236:	6442                	ld	s0,16(sp)
    80001238:	64a2                	ld	s1,8(sp)
    8000123a:	6902                	ld	s2,0(sp)
    8000123c:	6105                	addi	sp,sp,32
    8000123e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001240:	4691                	li	a3,4
    80001242:	00b90633          	add	a2,s2,a1
    80001246:	6928                	ld	a0,80(a0)
    80001248:	fffff097          	auipc	ra,0xfffff
    8000124c:	69a080e7          	jalr	1690(ra) # 800008e2 <uvmalloc>
    80001250:	85aa                	mv	a1,a0
    80001252:	fd79                	bnez	a0,80001230 <growproc+0x22>
      return -1;
    80001254:	557d                	li	a0,-1
    80001256:	bff9                	j	80001234 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001258:	00b90633          	add	a2,s2,a1
    8000125c:	6928                	ld	a0,80(a0)
    8000125e:	fffff097          	auipc	ra,0xfffff
    80001262:	63c080e7          	jalr	1596(ra) # 8000089a <uvmdealloc>
    80001266:	85aa                	mv	a1,a0
    80001268:	b7e1                	j	80001230 <growproc+0x22>

000000008000126a <fork>:
{
    8000126a:	7179                	addi	sp,sp,-48
    8000126c:	f406                	sd	ra,40(sp)
    8000126e:	f022                	sd	s0,32(sp)
    80001270:	ec26                	sd	s1,24(sp)
    80001272:	e84a                	sd	s2,16(sp)
    80001274:	e44e                	sd	s3,8(sp)
    80001276:	e052                	sd	s4,0(sp)
    80001278:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000127a:	00000097          	auipc	ra,0x0
    8000127e:	c36080e7          	jalr	-970(ra) # 80000eb0 <myproc>
    80001282:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001284:	00000097          	auipc	ra,0x0
    80001288:	e3a080e7          	jalr	-454(ra) # 800010be <allocproc>
    8000128c:	10050b63          	beqz	a0,800013a2 <fork+0x138>
    80001290:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001292:	04893603          	ld	a2,72(s2)
    80001296:	692c                	ld	a1,80(a0)
    80001298:	05093503          	ld	a0,80(s2)
    8000129c:	fffff097          	auipc	ra,0xfffff
    800012a0:	79a080e7          	jalr	1946(ra) # 80000a36 <uvmcopy>
    800012a4:	04054663          	bltz	a0,800012f0 <fork+0x86>
  np->sz = p->sz;
    800012a8:	04893783          	ld	a5,72(s2)
    800012ac:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800012b0:	05893683          	ld	a3,88(s2)
    800012b4:	87b6                	mv	a5,a3
    800012b6:	0589b703          	ld	a4,88(s3)
    800012ba:	12068693          	addi	a3,a3,288
    800012be:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012c2:	6788                	ld	a0,8(a5)
    800012c4:	6b8c                	ld	a1,16(a5)
    800012c6:	6f90                	ld	a2,24(a5)
    800012c8:	01073023          	sd	a6,0(a4)
    800012cc:	e708                	sd	a0,8(a4)
    800012ce:	eb0c                	sd	a1,16(a4)
    800012d0:	ef10                	sd	a2,24(a4)
    800012d2:	02078793          	addi	a5,a5,32
    800012d6:	02070713          	addi	a4,a4,32
    800012da:	fed792e3          	bne	a5,a3,800012be <fork+0x54>
  np->trapframe->a0 = 0;
    800012de:	0589b783          	ld	a5,88(s3)
    800012e2:	0607b823          	sd	zero,112(a5)
    800012e6:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800012ea:	15000a13          	li	s4,336
    800012ee:	a03d                	j	8000131c <fork+0xb2>
    freeproc(np);
    800012f0:	854e                	mv	a0,s3
    800012f2:	00000097          	auipc	ra,0x0
    800012f6:	d74080e7          	jalr	-652(ra) # 80001066 <freeproc>
    release(&np->lock);
    800012fa:	854e                	mv	a0,s3
    800012fc:	00005097          	auipc	ra,0x5
    80001300:	f44080e7          	jalr	-188(ra) # 80006240 <release>
    return -1;
    80001304:	5a7d                	li	s4,-1
    80001306:	a069                	j	80001390 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    80001308:	00002097          	auipc	ra,0x2
    8000130c:	672080e7          	jalr	1650(ra) # 8000397a <filedup>
    80001310:	009987b3          	add	a5,s3,s1
    80001314:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001316:	04a1                	addi	s1,s1,8
    80001318:	01448763          	beq	s1,s4,80001326 <fork+0xbc>
    if(p->ofile[i])
    8000131c:	009907b3          	add	a5,s2,s1
    80001320:	6388                	ld	a0,0(a5)
    80001322:	f17d                	bnez	a0,80001308 <fork+0x9e>
    80001324:	bfcd                	j	80001316 <fork+0xac>
  np->cwd = idup(p->cwd);
    80001326:	15093503          	ld	a0,336(s2)
    8000132a:	00001097          	auipc	ra,0x1
    8000132e:	7d6080e7          	jalr	2006(ra) # 80002b00 <idup>
    80001332:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001336:	4641                	li	a2,16
    80001338:	15890593          	addi	a1,s2,344
    8000133c:	15898513          	addi	a0,s3,344
    80001340:	fffff097          	auipc	ra,0xfffff
    80001344:	f8a080e7          	jalr	-118(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    80001348:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    8000134c:	854e                	mv	a0,s3
    8000134e:	00005097          	auipc	ra,0x5
    80001352:	ef2080e7          	jalr	-270(ra) # 80006240 <release>
  acquire(&wait_lock);
    80001356:	00007497          	auipc	s1,0x7
    8000135a:	5e248493          	addi	s1,s1,1506 # 80008938 <wait_lock>
    8000135e:	8526                	mv	a0,s1
    80001360:	00005097          	auipc	ra,0x5
    80001364:	e2c080e7          	jalr	-468(ra) # 8000618c <acquire>
  np->parent = p;
    80001368:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    8000136c:	8526                	mv	a0,s1
    8000136e:	00005097          	auipc	ra,0x5
    80001372:	ed2080e7          	jalr	-302(ra) # 80006240 <release>
  acquire(&np->lock);
    80001376:	854e                	mv	a0,s3
    80001378:	00005097          	auipc	ra,0x5
    8000137c:	e14080e7          	jalr	-492(ra) # 8000618c <acquire>
  np->state = RUNNABLE;
    80001380:	478d                	li	a5,3
    80001382:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001386:	854e                	mv	a0,s3
    80001388:	00005097          	auipc	ra,0x5
    8000138c:	eb8080e7          	jalr	-328(ra) # 80006240 <release>
}
    80001390:	8552                	mv	a0,s4
    80001392:	70a2                	ld	ra,40(sp)
    80001394:	7402                	ld	s0,32(sp)
    80001396:	64e2                	ld	s1,24(sp)
    80001398:	6942                	ld	s2,16(sp)
    8000139a:	69a2                	ld	s3,8(sp)
    8000139c:	6a02                	ld	s4,0(sp)
    8000139e:	6145                	addi	sp,sp,48
    800013a0:	8082                	ret
    return -1;
    800013a2:	5a7d                	li	s4,-1
    800013a4:	b7f5                	j	80001390 <fork+0x126>

00000000800013a6 <scheduler>:
{
    800013a6:	7139                	addi	sp,sp,-64
    800013a8:	fc06                	sd	ra,56(sp)
    800013aa:	f822                	sd	s0,48(sp)
    800013ac:	f426                	sd	s1,40(sp)
    800013ae:	f04a                	sd	s2,32(sp)
    800013b0:	ec4e                	sd	s3,24(sp)
    800013b2:	e852                	sd	s4,16(sp)
    800013b4:	e456                	sd	s5,8(sp)
    800013b6:	e05a                	sd	s6,0(sp)
    800013b8:	0080                	addi	s0,sp,64
    800013ba:	8792                	mv	a5,tp
  int id = r_tp();
    800013bc:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013be:	00779a93          	slli	s5,a5,0x7
    800013c2:	00007717          	auipc	a4,0x7
    800013c6:	55e70713          	addi	a4,a4,1374 # 80008920 <pid_lock>
    800013ca:	9756                	add	a4,a4,s5
    800013cc:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013d0:	00007717          	auipc	a4,0x7
    800013d4:	58870713          	addi	a4,a4,1416 # 80008958 <cpus+0x8>
    800013d8:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013da:	498d                	li	s3,3
        p->state = RUNNING;
    800013dc:	4b11                	li	s6,4
        c->proc = p;
    800013de:	079e                	slli	a5,a5,0x7
    800013e0:	00007a17          	auipc	s4,0x7
    800013e4:	540a0a13          	addi	s4,s4,1344 # 80008920 <pid_lock>
    800013e8:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013ea:	0000d917          	auipc	s2,0xd
    800013ee:	36690913          	addi	s2,s2,870 # 8000e750 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013f2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013f6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013fa:	10079073          	csrw	sstatus,a5
    800013fe:	00008497          	auipc	s1,0x8
    80001402:	95248493          	addi	s1,s1,-1710 # 80008d50 <proc>
    80001406:	a03d                	j	80001434 <scheduler+0x8e>
        p->state = RUNNING;
    80001408:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000140c:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001410:	06048593          	addi	a1,s1,96
    80001414:	8556                	mv	a0,s5
    80001416:	00000097          	auipc	ra,0x0
    8000141a:	6a4080e7          	jalr	1700(ra) # 80001aba <swtch>
        c->proc = 0;
    8000141e:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001422:	8526                	mv	a0,s1
    80001424:	00005097          	auipc	ra,0x5
    80001428:	e1c080e7          	jalr	-484(ra) # 80006240 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000142c:	16848493          	addi	s1,s1,360
    80001430:	fd2481e3          	beq	s1,s2,800013f2 <scheduler+0x4c>
      acquire(&p->lock);
    80001434:	8526                	mv	a0,s1
    80001436:	00005097          	auipc	ra,0x5
    8000143a:	d56080e7          	jalr	-682(ra) # 8000618c <acquire>
      if(p->state == RUNNABLE) {
    8000143e:	4c9c                	lw	a5,24(s1)
    80001440:	ff3791e3          	bne	a5,s3,80001422 <scheduler+0x7c>
    80001444:	b7d1                	j	80001408 <scheduler+0x62>

0000000080001446 <sched>:
{
    80001446:	7179                	addi	sp,sp,-48
    80001448:	f406                	sd	ra,40(sp)
    8000144a:	f022                	sd	s0,32(sp)
    8000144c:	ec26                	sd	s1,24(sp)
    8000144e:	e84a                	sd	s2,16(sp)
    80001450:	e44e                	sd	s3,8(sp)
    80001452:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001454:	00000097          	auipc	ra,0x0
    80001458:	a5c080e7          	jalr	-1444(ra) # 80000eb0 <myproc>
    8000145c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000145e:	00005097          	auipc	ra,0x5
    80001462:	cb4080e7          	jalr	-844(ra) # 80006112 <holding>
    80001466:	c93d                	beqz	a0,800014dc <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001468:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000146a:	2781                	sext.w	a5,a5
    8000146c:	079e                	slli	a5,a5,0x7
    8000146e:	00007717          	auipc	a4,0x7
    80001472:	4b270713          	addi	a4,a4,1202 # 80008920 <pid_lock>
    80001476:	97ba                	add	a5,a5,a4
    80001478:	0a87a703          	lw	a4,168(a5)
    8000147c:	4785                	li	a5,1
    8000147e:	06f71763          	bne	a4,a5,800014ec <sched+0xa6>
  if(p->state == RUNNING)
    80001482:	4c98                	lw	a4,24(s1)
    80001484:	4791                	li	a5,4
    80001486:	06f70b63          	beq	a4,a5,800014fc <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000148a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000148e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001490:	efb5                	bnez	a5,8000150c <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001492:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001494:	00007917          	auipc	s2,0x7
    80001498:	48c90913          	addi	s2,s2,1164 # 80008920 <pid_lock>
    8000149c:	2781                	sext.w	a5,a5
    8000149e:	079e                	slli	a5,a5,0x7
    800014a0:	97ca                	add	a5,a5,s2
    800014a2:	0ac7a983          	lw	s3,172(a5)
    800014a6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014a8:	2781                	sext.w	a5,a5
    800014aa:	079e                	slli	a5,a5,0x7
    800014ac:	00007597          	auipc	a1,0x7
    800014b0:	4ac58593          	addi	a1,a1,1196 # 80008958 <cpus+0x8>
    800014b4:	95be                	add	a1,a1,a5
    800014b6:	06048513          	addi	a0,s1,96
    800014ba:	00000097          	auipc	ra,0x0
    800014be:	600080e7          	jalr	1536(ra) # 80001aba <swtch>
    800014c2:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014c4:	2781                	sext.w	a5,a5
    800014c6:	079e                	slli	a5,a5,0x7
    800014c8:	97ca                	add	a5,a5,s2
    800014ca:	0b37a623          	sw	s3,172(a5)
}
    800014ce:	70a2                	ld	ra,40(sp)
    800014d0:	7402                	ld	s0,32(sp)
    800014d2:	64e2                	ld	s1,24(sp)
    800014d4:	6942                	ld	s2,16(sp)
    800014d6:	69a2                	ld	s3,8(sp)
    800014d8:	6145                	addi	sp,sp,48
    800014da:	8082                	ret
    panic("sched p->lock");
    800014dc:	00007517          	auipc	a0,0x7
    800014e0:	cfc50513          	addi	a0,a0,-772 # 800081d8 <etext+0x1d8>
    800014e4:	00004097          	auipc	ra,0x4
    800014e8:	75e080e7          	jalr	1886(ra) # 80005c42 <panic>
    panic("sched locks");
    800014ec:	00007517          	auipc	a0,0x7
    800014f0:	cfc50513          	addi	a0,a0,-772 # 800081e8 <etext+0x1e8>
    800014f4:	00004097          	auipc	ra,0x4
    800014f8:	74e080e7          	jalr	1870(ra) # 80005c42 <panic>
    panic("sched running");
    800014fc:	00007517          	auipc	a0,0x7
    80001500:	cfc50513          	addi	a0,a0,-772 # 800081f8 <etext+0x1f8>
    80001504:	00004097          	auipc	ra,0x4
    80001508:	73e080e7          	jalr	1854(ra) # 80005c42 <panic>
    panic("sched interruptible");
    8000150c:	00007517          	auipc	a0,0x7
    80001510:	cfc50513          	addi	a0,a0,-772 # 80008208 <etext+0x208>
    80001514:	00004097          	auipc	ra,0x4
    80001518:	72e080e7          	jalr	1838(ra) # 80005c42 <panic>

000000008000151c <yield>:
{
    8000151c:	1101                	addi	sp,sp,-32
    8000151e:	ec06                	sd	ra,24(sp)
    80001520:	e822                	sd	s0,16(sp)
    80001522:	e426                	sd	s1,8(sp)
    80001524:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001526:	00000097          	auipc	ra,0x0
    8000152a:	98a080e7          	jalr	-1654(ra) # 80000eb0 <myproc>
    8000152e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001530:	00005097          	auipc	ra,0x5
    80001534:	c5c080e7          	jalr	-932(ra) # 8000618c <acquire>
  p->state = RUNNABLE;
    80001538:	478d                	li	a5,3
    8000153a:	cc9c                	sw	a5,24(s1)
  sched();
    8000153c:	00000097          	auipc	ra,0x0
    80001540:	f0a080e7          	jalr	-246(ra) # 80001446 <sched>
  release(&p->lock);
    80001544:	8526                	mv	a0,s1
    80001546:	00005097          	auipc	ra,0x5
    8000154a:	cfa080e7          	jalr	-774(ra) # 80006240 <release>
}
    8000154e:	60e2                	ld	ra,24(sp)
    80001550:	6442                	ld	s0,16(sp)
    80001552:	64a2                	ld	s1,8(sp)
    80001554:	6105                	addi	sp,sp,32
    80001556:	8082                	ret

0000000080001558 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001558:	7179                	addi	sp,sp,-48
    8000155a:	f406                	sd	ra,40(sp)
    8000155c:	f022                	sd	s0,32(sp)
    8000155e:	ec26                	sd	s1,24(sp)
    80001560:	e84a                	sd	s2,16(sp)
    80001562:	e44e                	sd	s3,8(sp)
    80001564:	1800                	addi	s0,sp,48
    80001566:	89aa                	mv	s3,a0
    80001568:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000156a:	00000097          	auipc	ra,0x0
    8000156e:	946080e7          	jalr	-1722(ra) # 80000eb0 <myproc>
    80001572:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001574:	00005097          	auipc	ra,0x5
    80001578:	c18080e7          	jalr	-1000(ra) # 8000618c <acquire>
  release(lk);
    8000157c:	854a                	mv	a0,s2
    8000157e:	00005097          	auipc	ra,0x5
    80001582:	cc2080e7          	jalr	-830(ra) # 80006240 <release>

  // Go to sleep.
  p->chan = chan;
    80001586:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000158a:	4789                	li	a5,2
    8000158c:	cc9c                	sw	a5,24(s1)

  sched();
    8000158e:	00000097          	auipc	ra,0x0
    80001592:	eb8080e7          	jalr	-328(ra) # 80001446 <sched>

  // Tidy up.
  p->chan = 0;
    80001596:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000159a:	8526                	mv	a0,s1
    8000159c:	00005097          	auipc	ra,0x5
    800015a0:	ca4080e7          	jalr	-860(ra) # 80006240 <release>
  acquire(lk);
    800015a4:	854a                	mv	a0,s2
    800015a6:	00005097          	auipc	ra,0x5
    800015aa:	be6080e7          	jalr	-1050(ra) # 8000618c <acquire>
}
    800015ae:	70a2                	ld	ra,40(sp)
    800015b0:	7402                	ld	s0,32(sp)
    800015b2:	64e2                	ld	s1,24(sp)
    800015b4:	6942                	ld	s2,16(sp)
    800015b6:	69a2                	ld	s3,8(sp)
    800015b8:	6145                	addi	sp,sp,48
    800015ba:	8082                	ret

00000000800015bc <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800015bc:	7139                	addi	sp,sp,-64
    800015be:	fc06                	sd	ra,56(sp)
    800015c0:	f822                	sd	s0,48(sp)
    800015c2:	f426                	sd	s1,40(sp)
    800015c4:	f04a                	sd	s2,32(sp)
    800015c6:	ec4e                	sd	s3,24(sp)
    800015c8:	e852                	sd	s4,16(sp)
    800015ca:	e456                	sd	s5,8(sp)
    800015cc:	0080                	addi	s0,sp,64
    800015ce:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800015d0:	00007497          	auipc	s1,0x7
    800015d4:	78048493          	addi	s1,s1,1920 # 80008d50 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800015d8:	4989                	li	s3,2
        p->state = RUNNABLE;
    800015da:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800015dc:	0000d917          	auipc	s2,0xd
    800015e0:	17490913          	addi	s2,s2,372 # 8000e750 <tickslock>
    800015e4:	a821                	j	800015fc <wakeup+0x40>
        p->state = RUNNABLE;
    800015e6:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800015ea:	8526                	mv	a0,s1
    800015ec:	00005097          	auipc	ra,0x5
    800015f0:	c54080e7          	jalr	-940(ra) # 80006240 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800015f4:	16848493          	addi	s1,s1,360
    800015f8:	03248463          	beq	s1,s2,80001620 <wakeup+0x64>
    if(p != myproc()){
    800015fc:	00000097          	auipc	ra,0x0
    80001600:	8b4080e7          	jalr	-1868(ra) # 80000eb0 <myproc>
    80001604:	fea488e3          	beq	s1,a0,800015f4 <wakeup+0x38>
      acquire(&p->lock);
    80001608:	8526                	mv	a0,s1
    8000160a:	00005097          	auipc	ra,0x5
    8000160e:	b82080e7          	jalr	-1150(ra) # 8000618c <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001612:	4c9c                	lw	a5,24(s1)
    80001614:	fd379be3          	bne	a5,s3,800015ea <wakeup+0x2e>
    80001618:	709c                	ld	a5,32(s1)
    8000161a:	fd4798e3          	bne	a5,s4,800015ea <wakeup+0x2e>
    8000161e:	b7e1                	j	800015e6 <wakeup+0x2a>
    }
  }
}
    80001620:	70e2                	ld	ra,56(sp)
    80001622:	7442                	ld	s0,48(sp)
    80001624:	74a2                	ld	s1,40(sp)
    80001626:	7902                	ld	s2,32(sp)
    80001628:	69e2                	ld	s3,24(sp)
    8000162a:	6a42                	ld	s4,16(sp)
    8000162c:	6aa2                	ld	s5,8(sp)
    8000162e:	6121                	addi	sp,sp,64
    80001630:	8082                	ret

0000000080001632 <reparent>:
{
    80001632:	7179                	addi	sp,sp,-48
    80001634:	f406                	sd	ra,40(sp)
    80001636:	f022                	sd	s0,32(sp)
    80001638:	ec26                	sd	s1,24(sp)
    8000163a:	e84a                	sd	s2,16(sp)
    8000163c:	e44e                	sd	s3,8(sp)
    8000163e:	e052                	sd	s4,0(sp)
    80001640:	1800                	addi	s0,sp,48
    80001642:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001644:	00007497          	auipc	s1,0x7
    80001648:	70c48493          	addi	s1,s1,1804 # 80008d50 <proc>
      pp->parent = initproc;
    8000164c:	00007a17          	auipc	s4,0x7
    80001650:	294a0a13          	addi	s4,s4,660 # 800088e0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001654:	0000d997          	auipc	s3,0xd
    80001658:	0fc98993          	addi	s3,s3,252 # 8000e750 <tickslock>
    8000165c:	a029                	j	80001666 <reparent+0x34>
    8000165e:	16848493          	addi	s1,s1,360
    80001662:	01348d63          	beq	s1,s3,8000167c <reparent+0x4a>
    if(pp->parent == p){
    80001666:	7c9c                	ld	a5,56(s1)
    80001668:	ff279be3          	bne	a5,s2,8000165e <reparent+0x2c>
      pp->parent = initproc;
    8000166c:	000a3503          	ld	a0,0(s4)
    80001670:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001672:	00000097          	auipc	ra,0x0
    80001676:	f4a080e7          	jalr	-182(ra) # 800015bc <wakeup>
    8000167a:	b7d5                	j	8000165e <reparent+0x2c>
}
    8000167c:	70a2                	ld	ra,40(sp)
    8000167e:	7402                	ld	s0,32(sp)
    80001680:	64e2                	ld	s1,24(sp)
    80001682:	6942                	ld	s2,16(sp)
    80001684:	69a2                	ld	s3,8(sp)
    80001686:	6a02                	ld	s4,0(sp)
    80001688:	6145                	addi	sp,sp,48
    8000168a:	8082                	ret

000000008000168c <exit>:
{
    8000168c:	7179                	addi	sp,sp,-48
    8000168e:	f406                	sd	ra,40(sp)
    80001690:	f022                	sd	s0,32(sp)
    80001692:	ec26                	sd	s1,24(sp)
    80001694:	e84a                	sd	s2,16(sp)
    80001696:	e44e                	sd	s3,8(sp)
    80001698:	e052                	sd	s4,0(sp)
    8000169a:	1800                	addi	s0,sp,48
    8000169c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000169e:	00000097          	auipc	ra,0x0
    800016a2:	812080e7          	jalr	-2030(ra) # 80000eb0 <myproc>
    800016a6:	89aa                	mv	s3,a0
  if(p == initproc)
    800016a8:	00007797          	auipc	a5,0x7
    800016ac:	2387b783          	ld	a5,568(a5) # 800088e0 <initproc>
    800016b0:	0d050493          	addi	s1,a0,208
    800016b4:	15050913          	addi	s2,a0,336
    800016b8:	02a79363          	bne	a5,a0,800016de <exit+0x52>
    panic("init exiting");
    800016bc:	00007517          	auipc	a0,0x7
    800016c0:	b6450513          	addi	a0,a0,-1180 # 80008220 <etext+0x220>
    800016c4:	00004097          	auipc	ra,0x4
    800016c8:	57e080e7          	jalr	1406(ra) # 80005c42 <panic>
      fileclose(f);
    800016cc:	00002097          	auipc	ra,0x2
    800016d0:	300080e7          	jalr	768(ra) # 800039cc <fileclose>
      p->ofile[fd] = 0;
    800016d4:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800016d8:	04a1                	addi	s1,s1,8
    800016da:	01248563          	beq	s1,s2,800016e4 <exit+0x58>
    if(p->ofile[fd]){
    800016de:	6088                	ld	a0,0(s1)
    800016e0:	f575                	bnez	a0,800016cc <exit+0x40>
    800016e2:	bfdd                	j	800016d8 <exit+0x4c>
  begin_op();
    800016e4:	00002097          	auipc	ra,0x2
    800016e8:	e1c080e7          	jalr	-484(ra) # 80003500 <begin_op>
  iput(p->cwd);
    800016ec:	1509b503          	ld	a0,336(s3)
    800016f0:	00001097          	auipc	ra,0x1
    800016f4:	608080e7          	jalr	1544(ra) # 80002cf8 <iput>
  end_op();
    800016f8:	00002097          	auipc	ra,0x2
    800016fc:	e88080e7          	jalr	-376(ra) # 80003580 <end_op>
  p->cwd = 0;
    80001700:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001704:	00007497          	auipc	s1,0x7
    80001708:	23448493          	addi	s1,s1,564 # 80008938 <wait_lock>
    8000170c:	8526                	mv	a0,s1
    8000170e:	00005097          	auipc	ra,0x5
    80001712:	a7e080e7          	jalr	-1410(ra) # 8000618c <acquire>
  reparent(p);
    80001716:	854e                	mv	a0,s3
    80001718:	00000097          	auipc	ra,0x0
    8000171c:	f1a080e7          	jalr	-230(ra) # 80001632 <reparent>
  wakeup(p->parent);
    80001720:	0389b503          	ld	a0,56(s3)
    80001724:	00000097          	auipc	ra,0x0
    80001728:	e98080e7          	jalr	-360(ra) # 800015bc <wakeup>
  acquire(&p->lock);
    8000172c:	854e                	mv	a0,s3
    8000172e:	00005097          	auipc	ra,0x5
    80001732:	a5e080e7          	jalr	-1442(ra) # 8000618c <acquire>
  p->xstate = status;
    80001736:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000173a:	4795                	li	a5,5
    8000173c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001740:	8526                	mv	a0,s1
    80001742:	00005097          	auipc	ra,0x5
    80001746:	afe080e7          	jalr	-1282(ra) # 80006240 <release>
  sched();
    8000174a:	00000097          	auipc	ra,0x0
    8000174e:	cfc080e7          	jalr	-772(ra) # 80001446 <sched>
  panic("zombie exit");
    80001752:	00007517          	auipc	a0,0x7
    80001756:	ade50513          	addi	a0,a0,-1314 # 80008230 <etext+0x230>
    8000175a:	00004097          	auipc	ra,0x4
    8000175e:	4e8080e7          	jalr	1256(ra) # 80005c42 <panic>

0000000080001762 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001762:	7179                	addi	sp,sp,-48
    80001764:	f406                	sd	ra,40(sp)
    80001766:	f022                	sd	s0,32(sp)
    80001768:	ec26                	sd	s1,24(sp)
    8000176a:	e84a                	sd	s2,16(sp)
    8000176c:	e44e                	sd	s3,8(sp)
    8000176e:	1800                	addi	s0,sp,48
    80001770:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001772:	00007497          	auipc	s1,0x7
    80001776:	5de48493          	addi	s1,s1,1502 # 80008d50 <proc>
    8000177a:	0000d997          	auipc	s3,0xd
    8000177e:	fd698993          	addi	s3,s3,-42 # 8000e750 <tickslock>
    acquire(&p->lock);
    80001782:	8526                	mv	a0,s1
    80001784:	00005097          	auipc	ra,0x5
    80001788:	a08080e7          	jalr	-1528(ra) # 8000618c <acquire>
    if(p->pid == pid){
    8000178c:	589c                	lw	a5,48(s1)
    8000178e:	01278d63          	beq	a5,s2,800017a8 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001792:	8526                	mv	a0,s1
    80001794:	00005097          	auipc	ra,0x5
    80001798:	aac080e7          	jalr	-1364(ra) # 80006240 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000179c:	16848493          	addi	s1,s1,360
    800017a0:	ff3491e3          	bne	s1,s3,80001782 <kill+0x20>
  }
  return -1;
    800017a4:	557d                	li	a0,-1
    800017a6:	a829                	j	800017c0 <kill+0x5e>
      p->killed = 1;
    800017a8:	4785                	li	a5,1
    800017aa:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800017ac:	4c98                	lw	a4,24(s1)
    800017ae:	4789                	li	a5,2
    800017b0:	00f70f63          	beq	a4,a5,800017ce <kill+0x6c>
      release(&p->lock);
    800017b4:	8526                	mv	a0,s1
    800017b6:	00005097          	auipc	ra,0x5
    800017ba:	a8a080e7          	jalr	-1398(ra) # 80006240 <release>
      return 0;
    800017be:	4501                	li	a0,0
}
    800017c0:	70a2                	ld	ra,40(sp)
    800017c2:	7402                	ld	s0,32(sp)
    800017c4:	64e2                	ld	s1,24(sp)
    800017c6:	6942                	ld	s2,16(sp)
    800017c8:	69a2                	ld	s3,8(sp)
    800017ca:	6145                	addi	sp,sp,48
    800017cc:	8082                	ret
        p->state = RUNNABLE;
    800017ce:	478d                	li	a5,3
    800017d0:	cc9c                	sw	a5,24(s1)
    800017d2:	b7cd                	j	800017b4 <kill+0x52>

00000000800017d4 <setkilled>:

void
setkilled(struct proc *p)
{
    800017d4:	1101                	addi	sp,sp,-32
    800017d6:	ec06                	sd	ra,24(sp)
    800017d8:	e822                	sd	s0,16(sp)
    800017da:	e426                	sd	s1,8(sp)
    800017dc:	1000                	addi	s0,sp,32
    800017de:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800017e0:	00005097          	auipc	ra,0x5
    800017e4:	9ac080e7          	jalr	-1620(ra) # 8000618c <acquire>
  p->killed = 1;
    800017e8:	4785                	li	a5,1
    800017ea:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800017ec:	8526                	mv	a0,s1
    800017ee:	00005097          	auipc	ra,0x5
    800017f2:	a52080e7          	jalr	-1454(ra) # 80006240 <release>
}
    800017f6:	60e2                	ld	ra,24(sp)
    800017f8:	6442                	ld	s0,16(sp)
    800017fa:	64a2                	ld	s1,8(sp)
    800017fc:	6105                	addi	sp,sp,32
    800017fe:	8082                	ret

0000000080001800 <killed>:

int
killed(struct proc *p)
{
    80001800:	1101                	addi	sp,sp,-32
    80001802:	ec06                	sd	ra,24(sp)
    80001804:	e822                	sd	s0,16(sp)
    80001806:	e426                	sd	s1,8(sp)
    80001808:	e04a                	sd	s2,0(sp)
    8000180a:	1000                	addi	s0,sp,32
    8000180c:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000180e:	00005097          	auipc	ra,0x5
    80001812:	97e080e7          	jalr	-1666(ra) # 8000618c <acquire>
  k = p->killed;
    80001816:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000181a:	8526                	mv	a0,s1
    8000181c:	00005097          	auipc	ra,0x5
    80001820:	a24080e7          	jalr	-1500(ra) # 80006240 <release>
  return k;
}
    80001824:	854a                	mv	a0,s2
    80001826:	60e2                	ld	ra,24(sp)
    80001828:	6442                	ld	s0,16(sp)
    8000182a:	64a2                	ld	s1,8(sp)
    8000182c:	6902                	ld	s2,0(sp)
    8000182e:	6105                	addi	sp,sp,32
    80001830:	8082                	ret

0000000080001832 <wait>:
{
    80001832:	715d                	addi	sp,sp,-80
    80001834:	e486                	sd	ra,72(sp)
    80001836:	e0a2                	sd	s0,64(sp)
    80001838:	fc26                	sd	s1,56(sp)
    8000183a:	f84a                	sd	s2,48(sp)
    8000183c:	f44e                	sd	s3,40(sp)
    8000183e:	f052                	sd	s4,32(sp)
    80001840:	ec56                	sd	s5,24(sp)
    80001842:	e85a                	sd	s6,16(sp)
    80001844:	e45e                	sd	s7,8(sp)
    80001846:	e062                	sd	s8,0(sp)
    80001848:	0880                	addi	s0,sp,80
    8000184a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000184c:	fffff097          	auipc	ra,0xfffff
    80001850:	664080e7          	jalr	1636(ra) # 80000eb0 <myproc>
    80001854:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001856:	00007517          	auipc	a0,0x7
    8000185a:	0e250513          	addi	a0,a0,226 # 80008938 <wait_lock>
    8000185e:	00005097          	auipc	ra,0x5
    80001862:	92e080e7          	jalr	-1746(ra) # 8000618c <acquire>
    havekids = 0;
    80001866:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001868:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000186a:	0000d997          	auipc	s3,0xd
    8000186e:	ee698993          	addi	s3,s3,-282 # 8000e750 <tickslock>
        havekids = 1;
    80001872:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001874:	00007c17          	auipc	s8,0x7
    80001878:	0c4c0c13          	addi	s8,s8,196 # 80008938 <wait_lock>
    havekids = 0;
    8000187c:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000187e:	00007497          	auipc	s1,0x7
    80001882:	4d248493          	addi	s1,s1,1234 # 80008d50 <proc>
    80001886:	a0bd                	j	800018f4 <wait+0xc2>
          pid = pp->pid;
    80001888:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000188c:	000b0e63          	beqz	s6,800018a8 <wait+0x76>
    80001890:	4691                	li	a3,4
    80001892:	02c48613          	addi	a2,s1,44
    80001896:	85da                	mv	a1,s6
    80001898:	05093503          	ld	a0,80(s2)
    8000189c:	fffff097          	auipc	ra,0xfffff
    800018a0:	29e080e7          	jalr	670(ra) # 80000b3a <copyout>
    800018a4:	02054563          	bltz	a0,800018ce <wait+0x9c>
          freeproc(pp);
    800018a8:	8526                	mv	a0,s1
    800018aa:	fffff097          	auipc	ra,0xfffff
    800018ae:	7bc080e7          	jalr	1980(ra) # 80001066 <freeproc>
          release(&pp->lock);
    800018b2:	8526                	mv	a0,s1
    800018b4:	00005097          	auipc	ra,0x5
    800018b8:	98c080e7          	jalr	-1652(ra) # 80006240 <release>
          release(&wait_lock);
    800018bc:	00007517          	auipc	a0,0x7
    800018c0:	07c50513          	addi	a0,a0,124 # 80008938 <wait_lock>
    800018c4:	00005097          	auipc	ra,0x5
    800018c8:	97c080e7          	jalr	-1668(ra) # 80006240 <release>
          return pid;
    800018cc:	a0b5                	j	80001938 <wait+0x106>
            release(&pp->lock);
    800018ce:	8526                	mv	a0,s1
    800018d0:	00005097          	auipc	ra,0x5
    800018d4:	970080e7          	jalr	-1680(ra) # 80006240 <release>
            release(&wait_lock);
    800018d8:	00007517          	auipc	a0,0x7
    800018dc:	06050513          	addi	a0,a0,96 # 80008938 <wait_lock>
    800018e0:	00005097          	auipc	ra,0x5
    800018e4:	960080e7          	jalr	-1696(ra) # 80006240 <release>
            return -1;
    800018e8:	59fd                	li	s3,-1
    800018ea:	a0b9                	j	80001938 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018ec:	16848493          	addi	s1,s1,360
    800018f0:	03348463          	beq	s1,s3,80001918 <wait+0xe6>
      if(pp->parent == p){
    800018f4:	7c9c                	ld	a5,56(s1)
    800018f6:	ff279be3          	bne	a5,s2,800018ec <wait+0xba>
        acquire(&pp->lock);
    800018fa:	8526                	mv	a0,s1
    800018fc:	00005097          	auipc	ra,0x5
    80001900:	890080e7          	jalr	-1904(ra) # 8000618c <acquire>
        if(pp->state == ZOMBIE){
    80001904:	4c9c                	lw	a5,24(s1)
    80001906:	f94781e3          	beq	a5,s4,80001888 <wait+0x56>
        release(&pp->lock);
    8000190a:	8526                	mv	a0,s1
    8000190c:	00005097          	auipc	ra,0x5
    80001910:	934080e7          	jalr	-1740(ra) # 80006240 <release>
        havekids = 1;
    80001914:	8756                	mv	a4,s5
    80001916:	bfd9                	j	800018ec <wait+0xba>
    if(!havekids || killed(p)){
    80001918:	c719                	beqz	a4,80001926 <wait+0xf4>
    8000191a:	854a                	mv	a0,s2
    8000191c:	00000097          	auipc	ra,0x0
    80001920:	ee4080e7          	jalr	-284(ra) # 80001800 <killed>
    80001924:	c51d                	beqz	a0,80001952 <wait+0x120>
      release(&wait_lock);
    80001926:	00007517          	auipc	a0,0x7
    8000192a:	01250513          	addi	a0,a0,18 # 80008938 <wait_lock>
    8000192e:	00005097          	auipc	ra,0x5
    80001932:	912080e7          	jalr	-1774(ra) # 80006240 <release>
      return -1;
    80001936:	59fd                	li	s3,-1
}
    80001938:	854e                	mv	a0,s3
    8000193a:	60a6                	ld	ra,72(sp)
    8000193c:	6406                	ld	s0,64(sp)
    8000193e:	74e2                	ld	s1,56(sp)
    80001940:	7942                	ld	s2,48(sp)
    80001942:	79a2                	ld	s3,40(sp)
    80001944:	7a02                	ld	s4,32(sp)
    80001946:	6ae2                	ld	s5,24(sp)
    80001948:	6b42                	ld	s6,16(sp)
    8000194a:	6ba2                	ld	s7,8(sp)
    8000194c:	6c02                	ld	s8,0(sp)
    8000194e:	6161                	addi	sp,sp,80
    80001950:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001952:	85e2                	mv	a1,s8
    80001954:	854a                	mv	a0,s2
    80001956:	00000097          	auipc	ra,0x0
    8000195a:	c02080e7          	jalr	-1022(ra) # 80001558 <sleep>
    havekids = 0;
    8000195e:	bf39                	j	8000187c <wait+0x4a>

0000000080001960 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001960:	7179                	addi	sp,sp,-48
    80001962:	f406                	sd	ra,40(sp)
    80001964:	f022                	sd	s0,32(sp)
    80001966:	ec26                	sd	s1,24(sp)
    80001968:	e84a                	sd	s2,16(sp)
    8000196a:	e44e                	sd	s3,8(sp)
    8000196c:	e052                	sd	s4,0(sp)
    8000196e:	1800                	addi	s0,sp,48
    80001970:	84aa                	mv	s1,a0
    80001972:	892e                	mv	s2,a1
    80001974:	89b2                	mv	s3,a2
    80001976:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001978:	fffff097          	auipc	ra,0xfffff
    8000197c:	538080e7          	jalr	1336(ra) # 80000eb0 <myproc>
  if(user_dst){
    80001980:	c08d                	beqz	s1,800019a2 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001982:	86d2                	mv	a3,s4
    80001984:	864e                	mv	a2,s3
    80001986:	85ca                	mv	a1,s2
    80001988:	6928                	ld	a0,80(a0)
    8000198a:	fffff097          	auipc	ra,0xfffff
    8000198e:	1b0080e7          	jalr	432(ra) # 80000b3a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001992:	70a2                	ld	ra,40(sp)
    80001994:	7402                	ld	s0,32(sp)
    80001996:	64e2                	ld	s1,24(sp)
    80001998:	6942                	ld	s2,16(sp)
    8000199a:	69a2                	ld	s3,8(sp)
    8000199c:	6a02                	ld	s4,0(sp)
    8000199e:	6145                	addi	sp,sp,48
    800019a0:	8082                	ret
    memmove((char *)dst, src, len);
    800019a2:	000a061b          	sext.w	a2,s4
    800019a6:	85ce                	mv	a1,s3
    800019a8:	854a                	mv	a0,s2
    800019aa:	fffff097          	auipc	ra,0xfffff
    800019ae:	82e080e7          	jalr	-2002(ra) # 800001d8 <memmove>
    return 0;
    800019b2:	8526                	mv	a0,s1
    800019b4:	bff9                	j	80001992 <either_copyout+0x32>

00000000800019b6 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019b6:	7179                	addi	sp,sp,-48
    800019b8:	f406                	sd	ra,40(sp)
    800019ba:	f022                	sd	s0,32(sp)
    800019bc:	ec26                	sd	s1,24(sp)
    800019be:	e84a                	sd	s2,16(sp)
    800019c0:	e44e                	sd	s3,8(sp)
    800019c2:	e052                	sd	s4,0(sp)
    800019c4:	1800                	addi	s0,sp,48
    800019c6:	892a                	mv	s2,a0
    800019c8:	84ae                	mv	s1,a1
    800019ca:	89b2                	mv	s3,a2
    800019cc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019ce:	fffff097          	auipc	ra,0xfffff
    800019d2:	4e2080e7          	jalr	1250(ra) # 80000eb0 <myproc>
  if(user_src){
    800019d6:	c08d                	beqz	s1,800019f8 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019d8:	86d2                	mv	a3,s4
    800019da:	864e                	mv	a2,s3
    800019dc:	85ca                	mv	a1,s2
    800019de:	6928                	ld	a0,80(a0)
    800019e0:	fffff097          	auipc	ra,0xfffff
    800019e4:	21a080e7          	jalr	538(ra) # 80000bfa <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019e8:	70a2                	ld	ra,40(sp)
    800019ea:	7402                	ld	s0,32(sp)
    800019ec:	64e2                	ld	s1,24(sp)
    800019ee:	6942                	ld	s2,16(sp)
    800019f0:	69a2                	ld	s3,8(sp)
    800019f2:	6a02                	ld	s4,0(sp)
    800019f4:	6145                	addi	sp,sp,48
    800019f6:	8082                	ret
    memmove(dst, (char*)src, len);
    800019f8:	000a061b          	sext.w	a2,s4
    800019fc:	85ce                	mv	a1,s3
    800019fe:	854a                	mv	a0,s2
    80001a00:	ffffe097          	auipc	ra,0xffffe
    80001a04:	7d8080e7          	jalr	2008(ra) # 800001d8 <memmove>
    return 0;
    80001a08:	8526                	mv	a0,s1
    80001a0a:	bff9                	j	800019e8 <either_copyin+0x32>

0000000080001a0c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a0c:	715d                	addi	sp,sp,-80
    80001a0e:	e486                	sd	ra,72(sp)
    80001a10:	e0a2                	sd	s0,64(sp)
    80001a12:	fc26                	sd	s1,56(sp)
    80001a14:	f84a                	sd	s2,48(sp)
    80001a16:	f44e                	sd	s3,40(sp)
    80001a18:	f052                	sd	s4,32(sp)
    80001a1a:	ec56                	sd	s5,24(sp)
    80001a1c:	e85a                	sd	s6,16(sp)
    80001a1e:	e45e                	sd	s7,8(sp)
    80001a20:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a22:	00006517          	auipc	a0,0x6
    80001a26:	62650513          	addi	a0,a0,1574 # 80008048 <etext+0x48>
    80001a2a:	00004097          	auipc	ra,0x4
    80001a2e:	262080e7          	jalr	610(ra) # 80005c8c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a32:	00007497          	auipc	s1,0x7
    80001a36:	47648493          	addi	s1,s1,1142 # 80008ea8 <proc+0x158>
    80001a3a:	0000d917          	auipc	s2,0xd
    80001a3e:	e6e90913          	addi	s2,s2,-402 # 8000e8a8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a42:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a44:	00006997          	auipc	s3,0x6
    80001a48:	7fc98993          	addi	s3,s3,2044 # 80008240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001a4c:	00006a97          	auipc	s5,0x6
    80001a50:	7fca8a93          	addi	s5,s5,2044 # 80008248 <etext+0x248>
    printf("\n");
    80001a54:	00006a17          	auipc	s4,0x6
    80001a58:	5f4a0a13          	addi	s4,s4,1524 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a5c:	00007b97          	auipc	s7,0x7
    80001a60:	82cb8b93          	addi	s7,s7,-2004 # 80008288 <states.1722>
    80001a64:	a00d                	j	80001a86 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a66:	ed86a583          	lw	a1,-296(a3)
    80001a6a:	8556                	mv	a0,s5
    80001a6c:	00004097          	auipc	ra,0x4
    80001a70:	220080e7          	jalr	544(ra) # 80005c8c <printf>
    printf("\n");
    80001a74:	8552                	mv	a0,s4
    80001a76:	00004097          	auipc	ra,0x4
    80001a7a:	216080e7          	jalr	534(ra) # 80005c8c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a7e:	16848493          	addi	s1,s1,360
    80001a82:	03248163          	beq	s1,s2,80001aa4 <procdump+0x98>
    if(p->state == UNUSED)
    80001a86:	86a6                	mv	a3,s1
    80001a88:	ec04a783          	lw	a5,-320(s1)
    80001a8c:	dbed                	beqz	a5,80001a7e <procdump+0x72>
      state = "???";
    80001a8e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a90:	fcfb6be3          	bltu	s6,a5,80001a66 <procdump+0x5a>
    80001a94:	1782                	slli	a5,a5,0x20
    80001a96:	9381                	srli	a5,a5,0x20
    80001a98:	078e                	slli	a5,a5,0x3
    80001a9a:	97de                	add	a5,a5,s7
    80001a9c:	6390                	ld	a2,0(a5)
    80001a9e:	f661                	bnez	a2,80001a66 <procdump+0x5a>
      state = "???";
    80001aa0:	864e                	mv	a2,s3
    80001aa2:	b7d1                	j	80001a66 <procdump+0x5a>
  }
}
    80001aa4:	60a6                	ld	ra,72(sp)
    80001aa6:	6406                	ld	s0,64(sp)
    80001aa8:	74e2                	ld	s1,56(sp)
    80001aaa:	7942                	ld	s2,48(sp)
    80001aac:	79a2                	ld	s3,40(sp)
    80001aae:	7a02                	ld	s4,32(sp)
    80001ab0:	6ae2                	ld	s5,24(sp)
    80001ab2:	6b42                	ld	s6,16(sp)
    80001ab4:	6ba2                	ld	s7,8(sp)
    80001ab6:	6161                	addi	sp,sp,80
    80001ab8:	8082                	ret

0000000080001aba <swtch>:
    80001aba:	00153023          	sd	ra,0(a0)
    80001abe:	00253423          	sd	sp,8(a0)
    80001ac2:	e900                	sd	s0,16(a0)
    80001ac4:	ed04                	sd	s1,24(a0)
    80001ac6:	03253023          	sd	s2,32(a0)
    80001aca:	03353423          	sd	s3,40(a0)
    80001ace:	03453823          	sd	s4,48(a0)
    80001ad2:	03553c23          	sd	s5,56(a0)
    80001ad6:	05653023          	sd	s6,64(a0)
    80001ada:	05753423          	sd	s7,72(a0)
    80001ade:	05853823          	sd	s8,80(a0)
    80001ae2:	05953c23          	sd	s9,88(a0)
    80001ae6:	07a53023          	sd	s10,96(a0)
    80001aea:	07b53423          	sd	s11,104(a0)
    80001aee:	0005b083          	ld	ra,0(a1)
    80001af2:	0085b103          	ld	sp,8(a1)
    80001af6:	6980                	ld	s0,16(a1)
    80001af8:	6d84                	ld	s1,24(a1)
    80001afa:	0205b903          	ld	s2,32(a1)
    80001afe:	0285b983          	ld	s3,40(a1)
    80001b02:	0305ba03          	ld	s4,48(a1)
    80001b06:	0385ba83          	ld	s5,56(a1)
    80001b0a:	0405bb03          	ld	s6,64(a1)
    80001b0e:	0485bb83          	ld	s7,72(a1)
    80001b12:	0505bc03          	ld	s8,80(a1)
    80001b16:	0585bc83          	ld	s9,88(a1)
    80001b1a:	0605bd03          	ld	s10,96(a1)
    80001b1e:	0685bd83          	ld	s11,104(a1)
    80001b22:	8082                	ret

0000000080001b24 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b24:	1141                	addi	sp,sp,-16
    80001b26:	e406                	sd	ra,8(sp)
    80001b28:	e022                	sd	s0,0(sp)
    80001b2a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b2c:	00006597          	auipc	a1,0x6
    80001b30:	78c58593          	addi	a1,a1,1932 # 800082b8 <states.1722+0x30>
    80001b34:	0000d517          	auipc	a0,0xd
    80001b38:	c1c50513          	addi	a0,a0,-996 # 8000e750 <tickslock>
    80001b3c:	00004097          	auipc	ra,0x4
    80001b40:	5c0080e7          	jalr	1472(ra) # 800060fc <initlock>
}
    80001b44:	60a2                	ld	ra,8(sp)
    80001b46:	6402                	ld	s0,0(sp)
    80001b48:	0141                	addi	sp,sp,16
    80001b4a:	8082                	ret

0000000080001b4c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b4c:	1141                	addi	sp,sp,-16
    80001b4e:	e422                	sd	s0,8(sp)
    80001b50:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b52:	00003797          	auipc	a5,0x3
    80001b56:	4be78793          	addi	a5,a5,1214 # 80005010 <kernelvec>
    80001b5a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b5e:	6422                	ld	s0,8(sp)
    80001b60:	0141                	addi	sp,sp,16
    80001b62:	8082                	ret

0000000080001b64 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b64:	1141                	addi	sp,sp,-16
    80001b66:	e406                	sd	ra,8(sp)
    80001b68:	e022                	sd	s0,0(sp)
    80001b6a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b6c:	fffff097          	auipc	ra,0xfffff
    80001b70:	344080e7          	jalr	836(ra) # 80000eb0 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b74:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b78:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b7a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b7e:	00005617          	auipc	a2,0x5
    80001b82:	48260613          	addi	a2,a2,1154 # 80007000 <_trampoline>
    80001b86:	00005697          	auipc	a3,0x5
    80001b8a:	47a68693          	addi	a3,a3,1146 # 80007000 <_trampoline>
    80001b8e:	8e91                	sub	a3,a3,a2
    80001b90:	040007b7          	lui	a5,0x4000
    80001b94:	17fd                	addi	a5,a5,-1
    80001b96:	07b2                	slli	a5,a5,0xc
    80001b98:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b9a:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b9e:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001ba0:	180026f3          	csrr	a3,satp
    80001ba4:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001ba6:	6d38                	ld	a4,88(a0)
    80001ba8:	6134                	ld	a3,64(a0)
    80001baa:	6585                	lui	a1,0x1
    80001bac:	96ae                	add	a3,a3,a1
    80001bae:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bb0:	6d38                	ld	a4,88(a0)
    80001bb2:	00000697          	auipc	a3,0x0
    80001bb6:	13068693          	addi	a3,a3,304 # 80001ce2 <usertrap>
    80001bba:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bbc:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bbe:	8692                	mv	a3,tp
    80001bc0:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bc2:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bc6:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bca:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bce:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bd2:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bd4:	6f18                	ld	a4,24(a4)
    80001bd6:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bda:	6928                	ld	a0,80(a0)
    80001bdc:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001bde:	00005717          	auipc	a4,0x5
    80001be2:	4be70713          	addi	a4,a4,1214 # 8000709c <userret>
    80001be6:	8f11                	sub	a4,a4,a2
    80001be8:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001bea:	577d                	li	a4,-1
    80001bec:	177e                	slli	a4,a4,0x3f
    80001bee:	8d59                	or	a0,a0,a4
    80001bf0:	9782                	jalr	a5
}
    80001bf2:	60a2                	ld	ra,8(sp)
    80001bf4:	6402                	ld	s0,0(sp)
    80001bf6:	0141                	addi	sp,sp,16
    80001bf8:	8082                	ret

0000000080001bfa <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bfa:	1101                	addi	sp,sp,-32
    80001bfc:	ec06                	sd	ra,24(sp)
    80001bfe:	e822                	sd	s0,16(sp)
    80001c00:	e426                	sd	s1,8(sp)
    80001c02:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c04:	0000d497          	auipc	s1,0xd
    80001c08:	b4c48493          	addi	s1,s1,-1204 # 8000e750 <tickslock>
    80001c0c:	8526                	mv	a0,s1
    80001c0e:	00004097          	auipc	ra,0x4
    80001c12:	57e080e7          	jalr	1406(ra) # 8000618c <acquire>
  ticks++;
    80001c16:	00007517          	auipc	a0,0x7
    80001c1a:	cd250513          	addi	a0,a0,-814 # 800088e8 <ticks>
    80001c1e:	411c                	lw	a5,0(a0)
    80001c20:	2785                	addiw	a5,a5,1
    80001c22:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c24:	00000097          	auipc	ra,0x0
    80001c28:	998080e7          	jalr	-1640(ra) # 800015bc <wakeup>
  release(&tickslock);
    80001c2c:	8526                	mv	a0,s1
    80001c2e:	00004097          	auipc	ra,0x4
    80001c32:	612080e7          	jalr	1554(ra) # 80006240 <release>
}
    80001c36:	60e2                	ld	ra,24(sp)
    80001c38:	6442                	ld	s0,16(sp)
    80001c3a:	64a2                	ld	s1,8(sp)
    80001c3c:	6105                	addi	sp,sp,32
    80001c3e:	8082                	ret

0000000080001c40 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c40:	1101                	addi	sp,sp,-32
    80001c42:	ec06                	sd	ra,24(sp)
    80001c44:	e822                	sd	s0,16(sp)
    80001c46:	e426                	sd	s1,8(sp)
    80001c48:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c4a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c4e:	00074d63          	bltz	a4,80001c68 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c52:	57fd                	li	a5,-1
    80001c54:	17fe                	slli	a5,a5,0x3f
    80001c56:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c58:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c5a:	06f70363          	beq	a4,a5,80001cc0 <devintr+0x80>
  }
}
    80001c5e:	60e2                	ld	ra,24(sp)
    80001c60:	6442                	ld	s0,16(sp)
    80001c62:	64a2                	ld	s1,8(sp)
    80001c64:	6105                	addi	sp,sp,32
    80001c66:	8082                	ret
     (scause & 0xff) == 9){
    80001c68:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c6c:	46a5                	li	a3,9
    80001c6e:	fed792e3          	bne	a5,a3,80001c52 <devintr+0x12>
    int irq = plic_claim();
    80001c72:	00003097          	auipc	ra,0x3
    80001c76:	4a6080e7          	jalr	1190(ra) # 80005118 <plic_claim>
    80001c7a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c7c:	47a9                	li	a5,10
    80001c7e:	02f50763          	beq	a0,a5,80001cac <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c82:	4785                	li	a5,1
    80001c84:	02f50963          	beq	a0,a5,80001cb6 <devintr+0x76>
    return 1;
    80001c88:	4505                	li	a0,1
    } else if(irq){
    80001c8a:	d8f1                	beqz	s1,80001c5e <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c8c:	85a6                	mv	a1,s1
    80001c8e:	00006517          	auipc	a0,0x6
    80001c92:	63250513          	addi	a0,a0,1586 # 800082c0 <states.1722+0x38>
    80001c96:	00004097          	auipc	ra,0x4
    80001c9a:	ff6080e7          	jalr	-10(ra) # 80005c8c <printf>
      plic_complete(irq);
    80001c9e:	8526                	mv	a0,s1
    80001ca0:	00003097          	auipc	ra,0x3
    80001ca4:	49c080e7          	jalr	1180(ra) # 8000513c <plic_complete>
    return 1;
    80001ca8:	4505                	li	a0,1
    80001caa:	bf55                	j	80001c5e <devintr+0x1e>
      uartintr();
    80001cac:	00004097          	auipc	ra,0x4
    80001cb0:	400080e7          	jalr	1024(ra) # 800060ac <uartintr>
    80001cb4:	b7ed                	j	80001c9e <devintr+0x5e>
      virtio_disk_intr();
    80001cb6:	00004097          	auipc	ra,0x4
    80001cba:	9b0080e7          	jalr	-1616(ra) # 80005666 <virtio_disk_intr>
    80001cbe:	b7c5                	j	80001c9e <devintr+0x5e>
    if(cpuid() == 0){
    80001cc0:	fffff097          	auipc	ra,0xfffff
    80001cc4:	1c4080e7          	jalr	452(ra) # 80000e84 <cpuid>
    80001cc8:	c901                	beqz	a0,80001cd8 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cca:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cce:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cd0:	14479073          	csrw	sip,a5
    return 2;
    80001cd4:	4509                	li	a0,2
    80001cd6:	b761                	j	80001c5e <devintr+0x1e>
      clockintr();
    80001cd8:	00000097          	auipc	ra,0x0
    80001cdc:	f22080e7          	jalr	-222(ra) # 80001bfa <clockintr>
    80001ce0:	b7ed                	j	80001cca <devintr+0x8a>

0000000080001ce2 <usertrap>:
{
    80001ce2:	1101                	addi	sp,sp,-32
    80001ce4:	ec06                	sd	ra,24(sp)
    80001ce6:	e822                	sd	s0,16(sp)
    80001ce8:	e426                	sd	s1,8(sp)
    80001cea:	e04a                	sd	s2,0(sp)
    80001cec:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cee:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cf2:	1007f793          	andi	a5,a5,256
    80001cf6:	e3b1                	bnez	a5,80001d3a <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cf8:	00003797          	auipc	a5,0x3
    80001cfc:	31878793          	addi	a5,a5,792 # 80005010 <kernelvec>
    80001d00:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d04:	fffff097          	auipc	ra,0xfffff
    80001d08:	1ac080e7          	jalr	428(ra) # 80000eb0 <myproc>
    80001d0c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d0e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d10:	14102773          	csrr	a4,sepc
    80001d14:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d16:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d1a:	47a1                	li	a5,8
    80001d1c:	02f70763          	beq	a4,a5,80001d4a <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d20:	00000097          	auipc	ra,0x0
    80001d24:	f20080e7          	jalr	-224(ra) # 80001c40 <devintr>
    80001d28:	892a                	mv	s2,a0
    80001d2a:	c151                	beqz	a0,80001dae <usertrap+0xcc>
  if(killed(p))
    80001d2c:	8526                	mv	a0,s1
    80001d2e:	00000097          	auipc	ra,0x0
    80001d32:	ad2080e7          	jalr	-1326(ra) # 80001800 <killed>
    80001d36:	c929                	beqz	a0,80001d88 <usertrap+0xa6>
    80001d38:	a099                	j	80001d7e <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001d3a:	00006517          	auipc	a0,0x6
    80001d3e:	5a650513          	addi	a0,a0,1446 # 800082e0 <states.1722+0x58>
    80001d42:	00004097          	auipc	ra,0x4
    80001d46:	f00080e7          	jalr	-256(ra) # 80005c42 <panic>
    if(killed(p))
    80001d4a:	00000097          	auipc	ra,0x0
    80001d4e:	ab6080e7          	jalr	-1354(ra) # 80001800 <killed>
    80001d52:	e921                	bnez	a0,80001da2 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001d54:	6cb8                	ld	a4,88(s1)
    80001d56:	6f1c                	ld	a5,24(a4)
    80001d58:	0791                	addi	a5,a5,4
    80001d5a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d5c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d60:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d64:	10079073          	csrw	sstatus,a5
    syscall();
    80001d68:	00000097          	auipc	ra,0x0
    80001d6c:	2d4080e7          	jalr	724(ra) # 8000203c <syscall>
  if(killed(p))
    80001d70:	8526                	mv	a0,s1
    80001d72:	00000097          	auipc	ra,0x0
    80001d76:	a8e080e7          	jalr	-1394(ra) # 80001800 <killed>
    80001d7a:	c911                	beqz	a0,80001d8e <usertrap+0xac>
    80001d7c:	4901                	li	s2,0
    exit(-1);
    80001d7e:	557d                	li	a0,-1
    80001d80:	00000097          	auipc	ra,0x0
    80001d84:	90c080e7          	jalr	-1780(ra) # 8000168c <exit>
  if(which_dev == 2)
    80001d88:	4789                	li	a5,2
    80001d8a:	04f90f63          	beq	s2,a5,80001de8 <usertrap+0x106>
  usertrapret();
    80001d8e:	00000097          	auipc	ra,0x0
    80001d92:	dd6080e7          	jalr	-554(ra) # 80001b64 <usertrapret>
}
    80001d96:	60e2                	ld	ra,24(sp)
    80001d98:	6442                	ld	s0,16(sp)
    80001d9a:	64a2                	ld	s1,8(sp)
    80001d9c:	6902                	ld	s2,0(sp)
    80001d9e:	6105                	addi	sp,sp,32
    80001da0:	8082                	ret
      exit(-1);
    80001da2:	557d                	li	a0,-1
    80001da4:	00000097          	auipc	ra,0x0
    80001da8:	8e8080e7          	jalr	-1816(ra) # 8000168c <exit>
    80001dac:	b765                	j	80001d54 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dae:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001db2:	5890                	lw	a2,48(s1)
    80001db4:	00006517          	auipc	a0,0x6
    80001db8:	54c50513          	addi	a0,a0,1356 # 80008300 <states.1722+0x78>
    80001dbc:	00004097          	auipc	ra,0x4
    80001dc0:	ed0080e7          	jalr	-304(ra) # 80005c8c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dc4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dc8:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dcc:	00006517          	auipc	a0,0x6
    80001dd0:	56450513          	addi	a0,a0,1380 # 80008330 <states.1722+0xa8>
    80001dd4:	00004097          	auipc	ra,0x4
    80001dd8:	eb8080e7          	jalr	-328(ra) # 80005c8c <printf>
    setkilled(p);
    80001ddc:	8526                	mv	a0,s1
    80001dde:	00000097          	auipc	ra,0x0
    80001de2:	9f6080e7          	jalr	-1546(ra) # 800017d4 <setkilled>
    80001de6:	b769                	j	80001d70 <usertrap+0x8e>
    yield();
    80001de8:	fffff097          	auipc	ra,0xfffff
    80001dec:	734080e7          	jalr	1844(ra) # 8000151c <yield>
    80001df0:	bf79                	j	80001d8e <usertrap+0xac>

0000000080001df2 <kerneltrap>:
{
    80001df2:	7179                	addi	sp,sp,-48
    80001df4:	f406                	sd	ra,40(sp)
    80001df6:	f022                	sd	s0,32(sp)
    80001df8:	ec26                	sd	s1,24(sp)
    80001dfa:	e84a                	sd	s2,16(sp)
    80001dfc:	e44e                	sd	s3,8(sp)
    80001dfe:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e00:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e04:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e08:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e0c:	1004f793          	andi	a5,s1,256
    80001e10:	cb85                	beqz	a5,80001e40 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e12:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e16:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e18:	ef85                	bnez	a5,80001e50 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e1a:	00000097          	auipc	ra,0x0
    80001e1e:	e26080e7          	jalr	-474(ra) # 80001c40 <devintr>
    80001e22:	cd1d                	beqz	a0,80001e60 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e24:	4789                	li	a5,2
    80001e26:	06f50a63          	beq	a0,a5,80001e9a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e2a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e2e:	10049073          	csrw	sstatus,s1
}
    80001e32:	70a2                	ld	ra,40(sp)
    80001e34:	7402                	ld	s0,32(sp)
    80001e36:	64e2                	ld	s1,24(sp)
    80001e38:	6942                	ld	s2,16(sp)
    80001e3a:	69a2                	ld	s3,8(sp)
    80001e3c:	6145                	addi	sp,sp,48
    80001e3e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e40:	00006517          	auipc	a0,0x6
    80001e44:	51050513          	addi	a0,a0,1296 # 80008350 <states.1722+0xc8>
    80001e48:	00004097          	auipc	ra,0x4
    80001e4c:	dfa080e7          	jalr	-518(ra) # 80005c42 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e50:	00006517          	auipc	a0,0x6
    80001e54:	52850513          	addi	a0,a0,1320 # 80008378 <states.1722+0xf0>
    80001e58:	00004097          	auipc	ra,0x4
    80001e5c:	dea080e7          	jalr	-534(ra) # 80005c42 <panic>
    printf("scause %p\n", scause);
    80001e60:	85ce                	mv	a1,s3
    80001e62:	00006517          	auipc	a0,0x6
    80001e66:	53650513          	addi	a0,a0,1334 # 80008398 <states.1722+0x110>
    80001e6a:	00004097          	auipc	ra,0x4
    80001e6e:	e22080e7          	jalr	-478(ra) # 80005c8c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e72:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e76:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e7a:	00006517          	auipc	a0,0x6
    80001e7e:	52e50513          	addi	a0,a0,1326 # 800083a8 <states.1722+0x120>
    80001e82:	00004097          	auipc	ra,0x4
    80001e86:	e0a080e7          	jalr	-502(ra) # 80005c8c <printf>
    panic("kerneltrap");
    80001e8a:	00006517          	auipc	a0,0x6
    80001e8e:	53650513          	addi	a0,a0,1334 # 800083c0 <states.1722+0x138>
    80001e92:	00004097          	auipc	ra,0x4
    80001e96:	db0080e7          	jalr	-592(ra) # 80005c42 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e9a:	fffff097          	auipc	ra,0xfffff
    80001e9e:	016080e7          	jalr	22(ra) # 80000eb0 <myproc>
    80001ea2:	d541                	beqz	a0,80001e2a <kerneltrap+0x38>
    80001ea4:	fffff097          	auipc	ra,0xfffff
    80001ea8:	00c080e7          	jalr	12(ra) # 80000eb0 <myproc>
    80001eac:	4d18                	lw	a4,24(a0)
    80001eae:	4791                	li	a5,4
    80001eb0:	f6f71de3          	bne	a4,a5,80001e2a <kerneltrap+0x38>
    yield();
    80001eb4:	fffff097          	auipc	ra,0xfffff
    80001eb8:	668080e7          	jalr	1640(ra) # 8000151c <yield>
    80001ebc:	b7bd                	j	80001e2a <kerneltrap+0x38>

0000000080001ebe <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ebe:	1101                	addi	sp,sp,-32
    80001ec0:	ec06                	sd	ra,24(sp)
    80001ec2:	e822                	sd	s0,16(sp)
    80001ec4:	e426                	sd	s1,8(sp)
    80001ec6:	1000                	addi	s0,sp,32
    80001ec8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001eca:	fffff097          	auipc	ra,0xfffff
    80001ece:	fe6080e7          	jalr	-26(ra) # 80000eb0 <myproc>
  switch (n) {
    80001ed2:	4795                	li	a5,5
    80001ed4:	0497e163          	bltu	a5,s1,80001f16 <argraw+0x58>
    80001ed8:	048a                	slli	s1,s1,0x2
    80001eda:	00006717          	auipc	a4,0x6
    80001ede:	51e70713          	addi	a4,a4,1310 # 800083f8 <states.1722+0x170>
    80001ee2:	94ba                	add	s1,s1,a4
    80001ee4:	409c                	lw	a5,0(s1)
    80001ee6:	97ba                	add	a5,a5,a4
    80001ee8:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001eea:	6d3c                	ld	a5,88(a0)
    80001eec:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001eee:	60e2                	ld	ra,24(sp)
    80001ef0:	6442                	ld	s0,16(sp)
    80001ef2:	64a2                	ld	s1,8(sp)
    80001ef4:	6105                	addi	sp,sp,32
    80001ef6:	8082                	ret
    return p->trapframe->a1;
    80001ef8:	6d3c                	ld	a5,88(a0)
    80001efa:	7fa8                	ld	a0,120(a5)
    80001efc:	bfcd                	j	80001eee <argraw+0x30>
    return p->trapframe->a2;
    80001efe:	6d3c                	ld	a5,88(a0)
    80001f00:	63c8                	ld	a0,128(a5)
    80001f02:	b7f5                	j	80001eee <argraw+0x30>
    return p->trapframe->a3;
    80001f04:	6d3c                	ld	a5,88(a0)
    80001f06:	67c8                	ld	a0,136(a5)
    80001f08:	b7dd                	j	80001eee <argraw+0x30>
    return p->trapframe->a4;
    80001f0a:	6d3c                	ld	a5,88(a0)
    80001f0c:	6bc8                	ld	a0,144(a5)
    80001f0e:	b7c5                	j	80001eee <argraw+0x30>
    return p->trapframe->a5;
    80001f10:	6d3c                	ld	a5,88(a0)
    80001f12:	6fc8                	ld	a0,152(a5)
    80001f14:	bfe9                	j	80001eee <argraw+0x30>
  panic("argraw");
    80001f16:	00006517          	auipc	a0,0x6
    80001f1a:	4ba50513          	addi	a0,a0,1210 # 800083d0 <states.1722+0x148>
    80001f1e:	00004097          	auipc	ra,0x4
    80001f22:	d24080e7          	jalr	-732(ra) # 80005c42 <panic>

0000000080001f26 <fetchaddr>:
{
    80001f26:	1101                	addi	sp,sp,-32
    80001f28:	ec06                	sd	ra,24(sp)
    80001f2a:	e822                	sd	s0,16(sp)
    80001f2c:	e426                	sd	s1,8(sp)
    80001f2e:	e04a                	sd	s2,0(sp)
    80001f30:	1000                	addi	s0,sp,32
    80001f32:	84aa                	mv	s1,a0
    80001f34:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f36:	fffff097          	auipc	ra,0xfffff
    80001f3a:	f7a080e7          	jalr	-134(ra) # 80000eb0 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f3e:	653c                	ld	a5,72(a0)
    80001f40:	02f4f863          	bgeu	s1,a5,80001f70 <fetchaddr+0x4a>
    80001f44:	00848713          	addi	a4,s1,8
    80001f48:	02e7e663          	bltu	a5,a4,80001f74 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f4c:	46a1                	li	a3,8
    80001f4e:	8626                	mv	a2,s1
    80001f50:	85ca                	mv	a1,s2
    80001f52:	6928                	ld	a0,80(a0)
    80001f54:	fffff097          	auipc	ra,0xfffff
    80001f58:	ca6080e7          	jalr	-858(ra) # 80000bfa <copyin>
    80001f5c:	00a03533          	snez	a0,a0
    80001f60:	40a00533          	neg	a0,a0
}
    80001f64:	60e2                	ld	ra,24(sp)
    80001f66:	6442                	ld	s0,16(sp)
    80001f68:	64a2                	ld	s1,8(sp)
    80001f6a:	6902                	ld	s2,0(sp)
    80001f6c:	6105                	addi	sp,sp,32
    80001f6e:	8082                	ret
    return -1;
    80001f70:	557d                	li	a0,-1
    80001f72:	bfcd                	j	80001f64 <fetchaddr+0x3e>
    80001f74:	557d                	li	a0,-1
    80001f76:	b7fd                	j	80001f64 <fetchaddr+0x3e>

0000000080001f78 <fetchstr>:
{
    80001f78:	7179                	addi	sp,sp,-48
    80001f7a:	f406                	sd	ra,40(sp)
    80001f7c:	f022                	sd	s0,32(sp)
    80001f7e:	ec26                	sd	s1,24(sp)
    80001f80:	e84a                	sd	s2,16(sp)
    80001f82:	e44e                	sd	s3,8(sp)
    80001f84:	1800                	addi	s0,sp,48
    80001f86:	892a                	mv	s2,a0
    80001f88:	84ae                	mv	s1,a1
    80001f8a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f8c:	fffff097          	auipc	ra,0xfffff
    80001f90:	f24080e7          	jalr	-220(ra) # 80000eb0 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f94:	86ce                	mv	a3,s3
    80001f96:	864a                	mv	a2,s2
    80001f98:	85a6                	mv	a1,s1
    80001f9a:	6928                	ld	a0,80(a0)
    80001f9c:	fffff097          	auipc	ra,0xfffff
    80001fa0:	cea080e7          	jalr	-790(ra) # 80000c86 <copyinstr>
    80001fa4:	00054e63          	bltz	a0,80001fc0 <fetchstr+0x48>
  return strlen(buf);
    80001fa8:	8526                	mv	a0,s1
    80001faa:	ffffe097          	auipc	ra,0xffffe
    80001fae:	352080e7          	jalr	850(ra) # 800002fc <strlen>
}
    80001fb2:	70a2                	ld	ra,40(sp)
    80001fb4:	7402                	ld	s0,32(sp)
    80001fb6:	64e2                	ld	s1,24(sp)
    80001fb8:	6942                	ld	s2,16(sp)
    80001fba:	69a2                	ld	s3,8(sp)
    80001fbc:	6145                	addi	sp,sp,48
    80001fbe:	8082                	ret
    return -1;
    80001fc0:	557d                	li	a0,-1
    80001fc2:	bfc5                	j	80001fb2 <fetchstr+0x3a>

0000000080001fc4 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001fc4:	1101                	addi	sp,sp,-32
    80001fc6:	ec06                	sd	ra,24(sp)
    80001fc8:	e822                	sd	s0,16(sp)
    80001fca:	e426                	sd	s1,8(sp)
    80001fcc:	1000                	addi	s0,sp,32
    80001fce:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fd0:	00000097          	auipc	ra,0x0
    80001fd4:	eee080e7          	jalr	-274(ra) # 80001ebe <argraw>
    80001fd8:	c088                	sw	a0,0(s1)
}
    80001fda:	60e2                	ld	ra,24(sp)
    80001fdc:	6442                	ld	s0,16(sp)
    80001fde:	64a2                	ld	s1,8(sp)
    80001fe0:	6105                	addi	sp,sp,32
    80001fe2:	8082                	ret

0000000080001fe4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001fe4:	1101                	addi	sp,sp,-32
    80001fe6:	ec06                	sd	ra,24(sp)
    80001fe8:	e822                	sd	s0,16(sp)
    80001fea:	e426                	sd	s1,8(sp)
    80001fec:	1000                	addi	s0,sp,32
    80001fee:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001ff0:	00000097          	auipc	ra,0x0
    80001ff4:	ece080e7          	jalr	-306(ra) # 80001ebe <argraw>
    80001ff8:	e088                	sd	a0,0(s1)
}
    80001ffa:	60e2                	ld	ra,24(sp)
    80001ffc:	6442                	ld	s0,16(sp)
    80001ffe:	64a2                	ld	s1,8(sp)
    80002000:	6105                	addi	sp,sp,32
    80002002:	8082                	ret

0000000080002004 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002004:	7179                	addi	sp,sp,-48
    80002006:	f406                	sd	ra,40(sp)
    80002008:	f022                	sd	s0,32(sp)
    8000200a:	ec26                	sd	s1,24(sp)
    8000200c:	e84a                	sd	s2,16(sp)
    8000200e:	1800                	addi	s0,sp,48
    80002010:	84ae                	mv	s1,a1
    80002012:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002014:	fd840593          	addi	a1,s0,-40
    80002018:	00000097          	auipc	ra,0x0
    8000201c:	fcc080e7          	jalr	-52(ra) # 80001fe4 <argaddr>
  return fetchstr(addr, buf, max);
    80002020:	864a                	mv	a2,s2
    80002022:	85a6                	mv	a1,s1
    80002024:	fd843503          	ld	a0,-40(s0)
    80002028:	00000097          	auipc	ra,0x0
    8000202c:	f50080e7          	jalr	-176(ra) # 80001f78 <fetchstr>
}
    80002030:	70a2                	ld	ra,40(sp)
    80002032:	7402                	ld	s0,32(sp)
    80002034:	64e2                	ld	s1,24(sp)
    80002036:	6942                	ld	s2,16(sp)
    80002038:	6145                	addi	sp,sp,48
    8000203a:	8082                	ret

000000008000203c <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    8000203c:	1101                	addi	sp,sp,-32
    8000203e:	ec06                	sd	ra,24(sp)
    80002040:	e822                	sd	s0,16(sp)
    80002042:	e426                	sd	s1,8(sp)
    80002044:	e04a                	sd	s2,0(sp)
    80002046:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002048:	fffff097          	auipc	ra,0xfffff
    8000204c:	e68080e7          	jalr	-408(ra) # 80000eb0 <myproc>
    80002050:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002052:	05853903          	ld	s2,88(a0)
    80002056:	0a893783          	ld	a5,168(s2)
    8000205a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000205e:	37fd                	addiw	a5,a5,-1
    80002060:	4751                	li	a4,20
    80002062:	00f76f63          	bltu	a4,a5,80002080 <syscall+0x44>
    80002066:	00369713          	slli	a4,a3,0x3
    8000206a:	00006797          	auipc	a5,0x6
    8000206e:	3a678793          	addi	a5,a5,934 # 80008410 <syscalls>
    80002072:	97ba                	add	a5,a5,a4
    80002074:	639c                	ld	a5,0(a5)
    80002076:	c789                	beqz	a5,80002080 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002078:	9782                	jalr	a5
    8000207a:	06a93823          	sd	a0,112(s2)
    8000207e:	a839                	j	8000209c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002080:	15848613          	addi	a2,s1,344
    80002084:	588c                	lw	a1,48(s1)
    80002086:	00006517          	auipc	a0,0x6
    8000208a:	35250513          	addi	a0,a0,850 # 800083d8 <states.1722+0x150>
    8000208e:	00004097          	auipc	ra,0x4
    80002092:	bfe080e7          	jalr	-1026(ra) # 80005c8c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002096:	6cbc                	ld	a5,88(s1)
    80002098:	577d                	li	a4,-1
    8000209a:	fbb8                	sd	a4,112(a5)
  }
}
    8000209c:	60e2                	ld	ra,24(sp)
    8000209e:	6442                	ld	s0,16(sp)
    800020a0:	64a2                	ld	s1,8(sp)
    800020a2:	6902                	ld	s2,0(sp)
    800020a4:	6105                	addi	sp,sp,32
    800020a6:	8082                	ret

00000000800020a8 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020a8:	1101                	addi	sp,sp,-32
    800020aa:	ec06                	sd	ra,24(sp)
    800020ac:	e822                	sd	s0,16(sp)
    800020ae:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800020b0:	fec40593          	addi	a1,s0,-20
    800020b4:	4501                	li	a0,0
    800020b6:	00000097          	auipc	ra,0x0
    800020ba:	f0e080e7          	jalr	-242(ra) # 80001fc4 <argint>
  exit(n);
    800020be:	fec42503          	lw	a0,-20(s0)
    800020c2:	fffff097          	auipc	ra,0xfffff
    800020c6:	5ca080e7          	jalr	1482(ra) # 8000168c <exit>
  return 0;  // not reached
}
    800020ca:	4501                	li	a0,0
    800020cc:	60e2                	ld	ra,24(sp)
    800020ce:	6442                	ld	s0,16(sp)
    800020d0:	6105                	addi	sp,sp,32
    800020d2:	8082                	ret

00000000800020d4 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020d4:	1141                	addi	sp,sp,-16
    800020d6:	e406                	sd	ra,8(sp)
    800020d8:	e022                	sd	s0,0(sp)
    800020da:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020dc:	fffff097          	auipc	ra,0xfffff
    800020e0:	dd4080e7          	jalr	-556(ra) # 80000eb0 <myproc>
}
    800020e4:	5908                	lw	a0,48(a0)
    800020e6:	60a2                	ld	ra,8(sp)
    800020e8:	6402                	ld	s0,0(sp)
    800020ea:	0141                	addi	sp,sp,16
    800020ec:	8082                	ret

00000000800020ee <sys_fork>:

uint64
sys_fork(void)
{
    800020ee:	1141                	addi	sp,sp,-16
    800020f0:	e406                	sd	ra,8(sp)
    800020f2:	e022                	sd	s0,0(sp)
    800020f4:	0800                	addi	s0,sp,16
  return fork();
    800020f6:	fffff097          	auipc	ra,0xfffff
    800020fa:	174080e7          	jalr	372(ra) # 8000126a <fork>
}
    800020fe:	60a2                	ld	ra,8(sp)
    80002100:	6402                	ld	s0,0(sp)
    80002102:	0141                	addi	sp,sp,16
    80002104:	8082                	ret

0000000080002106 <sys_wait>:

uint64
sys_wait(void)
{
    80002106:	1101                	addi	sp,sp,-32
    80002108:	ec06                	sd	ra,24(sp)
    8000210a:	e822                	sd	s0,16(sp)
    8000210c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000210e:	fe840593          	addi	a1,s0,-24
    80002112:	4501                	li	a0,0
    80002114:	00000097          	auipc	ra,0x0
    80002118:	ed0080e7          	jalr	-304(ra) # 80001fe4 <argaddr>
  return wait(p);
    8000211c:	fe843503          	ld	a0,-24(s0)
    80002120:	fffff097          	auipc	ra,0xfffff
    80002124:	712080e7          	jalr	1810(ra) # 80001832 <wait>
}
    80002128:	60e2                	ld	ra,24(sp)
    8000212a:	6442                	ld	s0,16(sp)
    8000212c:	6105                	addi	sp,sp,32
    8000212e:	8082                	ret

0000000080002130 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002130:	7179                	addi	sp,sp,-48
    80002132:	f406                	sd	ra,40(sp)
    80002134:	f022                	sd	s0,32(sp)
    80002136:	ec26                	sd	s1,24(sp)
    80002138:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000213a:	fdc40593          	addi	a1,s0,-36
    8000213e:	4501                	li	a0,0
    80002140:	00000097          	auipc	ra,0x0
    80002144:	e84080e7          	jalr	-380(ra) # 80001fc4 <argint>
  addr = myproc()->sz;
    80002148:	fffff097          	auipc	ra,0xfffff
    8000214c:	d68080e7          	jalr	-664(ra) # 80000eb0 <myproc>
    80002150:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002152:	fdc42503          	lw	a0,-36(s0)
    80002156:	fffff097          	auipc	ra,0xfffff
    8000215a:	0b8080e7          	jalr	184(ra) # 8000120e <growproc>
    8000215e:	00054863          	bltz	a0,8000216e <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002162:	8526                	mv	a0,s1
    80002164:	70a2                	ld	ra,40(sp)
    80002166:	7402                	ld	s0,32(sp)
    80002168:	64e2                	ld	s1,24(sp)
    8000216a:	6145                	addi	sp,sp,48
    8000216c:	8082                	ret
    return -1;
    8000216e:	54fd                	li	s1,-1
    80002170:	bfcd                	j	80002162 <sys_sbrk+0x32>

0000000080002172 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002172:	7139                	addi	sp,sp,-64
    80002174:	fc06                	sd	ra,56(sp)
    80002176:	f822                	sd	s0,48(sp)
    80002178:	f426                	sd	s1,40(sp)
    8000217a:	f04a                	sd	s2,32(sp)
    8000217c:	ec4e                	sd	s3,24(sp)
    8000217e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002180:	fcc40593          	addi	a1,s0,-52
    80002184:	4501                	li	a0,0
    80002186:	00000097          	auipc	ra,0x0
    8000218a:	e3e080e7          	jalr	-450(ra) # 80001fc4 <argint>
  if(n < 0)
    8000218e:	fcc42783          	lw	a5,-52(s0)
    80002192:	0607cf63          	bltz	a5,80002210 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002196:	0000c517          	auipc	a0,0xc
    8000219a:	5ba50513          	addi	a0,a0,1466 # 8000e750 <tickslock>
    8000219e:	00004097          	auipc	ra,0x4
    800021a2:	fee080e7          	jalr	-18(ra) # 8000618c <acquire>
  ticks0 = ticks;
    800021a6:	00006917          	auipc	s2,0x6
    800021aa:	74292903          	lw	s2,1858(s2) # 800088e8 <ticks>
  while(ticks - ticks0 < n){
    800021ae:	fcc42783          	lw	a5,-52(s0)
    800021b2:	cf9d                	beqz	a5,800021f0 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021b4:	0000c997          	auipc	s3,0xc
    800021b8:	59c98993          	addi	s3,s3,1436 # 8000e750 <tickslock>
    800021bc:	00006497          	auipc	s1,0x6
    800021c0:	72c48493          	addi	s1,s1,1836 # 800088e8 <ticks>
    if(killed(myproc())){
    800021c4:	fffff097          	auipc	ra,0xfffff
    800021c8:	cec080e7          	jalr	-788(ra) # 80000eb0 <myproc>
    800021cc:	fffff097          	auipc	ra,0xfffff
    800021d0:	634080e7          	jalr	1588(ra) # 80001800 <killed>
    800021d4:	e129                	bnez	a0,80002216 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    800021d6:	85ce                	mv	a1,s3
    800021d8:	8526                	mv	a0,s1
    800021da:	fffff097          	auipc	ra,0xfffff
    800021de:	37e080e7          	jalr	894(ra) # 80001558 <sleep>
  while(ticks - ticks0 < n){
    800021e2:	409c                	lw	a5,0(s1)
    800021e4:	412787bb          	subw	a5,a5,s2
    800021e8:	fcc42703          	lw	a4,-52(s0)
    800021ec:	fce7ece3          	bltu	a5,a4,800021c4 <sys_sleep+0x52>
  }
  release(&tickslock);
    800021f0:	0000c517          	auipc	a0,0xc
    800021f4:	56050513          	addi	a0,a0,1376 # 8000e750 <tickslock>
    800021f8:	00004097          	auipc	ra,0x4
    800021fc:	048080e7          	jalr	72(ra) # 80006240 <release>
  return 0;
    80002200:	4501                	li	a0,0
}
    80002202:	70e2                	ld	ra,56(sp)
    80002204:	7442                	ld	s0,48(sp)
    80002206:	74a2                	ld	s1,40(sp)
    80002208:	7902                	ld	s2,32(sp)
    8000220a:	69e2                	ld	s3,24(sp)
    8000220c:	6121                	addi	sp,sp,64
    8000220e:	8082                	ret
    n = 0;
    80002210:	fc042623          	sw	zero,-52(s0)
    80002214:	b749                	j	80002196 <sys_sleep+0x24>
      release(&tickslock);
    80002216:	0000c517          	auipc	a0,0xc
    8000221a:	53a50513          	addi	a0,a0,1338 # 8000e750 <tickslock>
    8000221e:	00004097          	auipc	ra,0x4
    80002222:	022080e7          	jalr	34(ra) # 80006240 <release>
      return -1;
    80002226:	557d                	li	a0,-1
    80002228:	bfe9                	j	80002202 <sys_sleep+0x90>

000000008000222a <sys_kill>:

uint64
sys_kill(void)
{
    8000222a:	1101                	addi	sp,sp,-32
    8000222c:	ec06                	sd	ra,24(sp)
    8000222e:	e822                	sd	s0,16(sp)
    80002230:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002232:	fec40593          	addi	a1,s0,-20
    80002236:	4501                	li	a0,0
    80002238:	00000097          	auipc	ra,0x0
    8000223c:	d8c080e7          	jalr	-628(ra) # 80001fc4 <argint>
  return kill(pid);
    80002240:	fec42503          	lw	a0,-20(s0)
    80002244:	fffff097          	auipc	ra,0xfffff
    80002248:	51e080e7          	jalr	1310(ra) # 80001762 <kill>
}
    8000224c:	60e2                	ld	ra,24(sp)
    8000224e:	6442                	ld	s0,16(sp)
    80002250:	6105                	addi	sp,sp,32
    80002252:	8082                	ret

0000000080002254 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002254:	1101                	addi	sp,sp,-32
    80002256:	ec06                	sd	ra,24(sp)
    80002258:	e822                	sd	s0,16(sp)
    8000225a:	e426                	sd	s1,8(sp)
    8000225c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000225e:	0000c517          	auipc	a0,0xc
    80002262:	4f250513          	addi	a0,a0,1266 # 8000e750 <tickslock>
    80002266:	00004097          	auipc	ra,0x4
    8000226a:	f26080e7          	jalr	-218(ra) # 8000618c <acquire>
  xticks = ticks;
    8000226e:	00006497          	auipc	s1,0x6
    80002272:	67a4a483          	lw	s1,1658(s1) # 800088e8 <ticks>
  release(&tickslock);
    80002276:	0000c517          	auipc	a0,0xc
    8000227a:	4da50513          	addi	a0,a0,1242 # 8000e750 <tickslock>
    8000227e:	00004097          	auipc	ra,0x4
    80002282:	fc2080e7          	jalr	-62(ra) # 80006240 <release>
  return xticks;
}
    80002286:	02049513          	slli	a0,s1,0x20
    8000228a:	9101                	srli	a0,a0,0x20
    8000228c:	60e2                	ld	ra,24(sp)
    8000228e:	6442                	ld	s0,16(sp)
    80002290:	64a2                	ld	s1,8(sp)
    80002292:	6105                	addi	sp,sp,32
    80002294:	8082                	ret

0000000080002296 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002296:	7179                	addi	sp,sp,-48
    80002298:	f406                	sd	ra,40(sp)
    8000229a:	f022                	sd	s0,32(sp)
    8000229c:	ec26                	sd	s1,24(sp)
    8000229e:	e84a                	sd	s2,16(sp)
    800022a0:	e44e                	sd	s3,8(sp)
    800022a2:	e052                	sd	s4,0(sp)
    800022a4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800022a6:	00006597          	auipc	a1,0x6
    800022aa:	21a58593          	addi	a1,a1,538 # 800084c0 <syscalls+0xb0>
    800022ae:	0000c517          	auipc	a0,0xc
    800022b2:	4ba50513          	addi	a0,a0,1210 # 8000e768 <bcache>
    800022b6:	00004097          	auipc	ra,0x4
    800022ba:	e46080e7          	jalr	-442(ra) # 800060fc <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800022be:	00014797          	auipc	a5,0x14
    800022c2:	4aa78793          	addi	a5,a5,1194 # 80016768 <bcache+0x8000>
    800022c6:	00014717          	auipc	a4,0x14
    800022ca:	70a70713          	addi	a4,a4,1802 # 800169d0 <bcache+0x8268>
    800022ce:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800022d2:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022d6:	0000c497          	auipc	s1,0xc
    800022da:	4aa48493          	addi	s1,s1,1194 # 8000e780 <bcache+0x18>
    b->next = bcache.head.next;
    800022de:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800022e0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800022e2:	00006a17          	auipc	s4,0x6
    800022e6:	1e6a0a13          	addi	s4,s4,486 # 800084c8 <syscalls+0xb8>
    b->next = bcache.head.next;
    800022ea:	2b893783          	ld	a5,696(s2)
    800022ee:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800022f0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800022f4:	85d2                	mv	a1,s4
    800022f6:	01048513          	addi	a0,s1,16
    800022fa:	00001097          	auipc	ra,0x1
    800022fe:	4c4080e7          	jalr	1220(ra) # 800037be <initsleeplock>
    bcache.head.next->prev = b;
    80002302:	2b893783          	ld	a5,696(s2)
    80002306:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002308:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000230c:	45848493          	addi	s1,s1,1112
    80002310:	fd349de3          	bne	s1,s3,800022ea <binit+0x54>
  }
}
    80002314:	70a2                	ld	ra,40(sp)
    80002316:	7402                	ld	s0,32(sp)
    80002318:	64e2                	ld	s1,24(sp)
    8000231a:	6942                	ld	s2,16(sp)
    8000231c:	69a2                	ld	s3,8(sp)
    8000231e:	6a02                	ld	s4,0(sp)
    80002320:	6145                	addi	sp,sp,48
    80002322:	8082                	ret

0000000080002324 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002324:	7179                	addi	sp,sp,-48
    80002326:	f406                	sd	ra,40(sp)
    80002328:	f022                	sd	s0,32(sp)
    8000232a:	ec26                	sd	s1,24(sp)
    8000232c:	e84a                	sd	s2,16(sp)
    8000232e:	e44e                	sd	s3,8(sp)
    80002330:	1800                	addi	s0,sp,48
    80002332:	89aa                	mv	s3,a0
    80002334:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002336:	0000c517          	auipc	a0,0xc
    8000233a:	43250513          	addi	a0,a0,1074 # 8000e768 <bcache>
    8000233e:	00004097          	auipc	ra,0x4
    80002342:	e4e080e7          	jalr	-434(ra) # 8000618c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002346:	00014497          	auipc	s1,0x14
    8000234a:	6da4b483          	ld	s1,1754(s1) # 80016a20 <bcache+0x82b8>
    8000234e:	00014797          	auipc	a5,0x14
    80002352:	68278793          	addi	a5,a5,1666 # 800169d0 <bcache+0x8268>
    80002356:	02f48f63          	beq	s1,a5,80002394 <bread+0x70>
    8000235a:	873e                	mv	a4,a5
    8000235c:	a021                	j	80002364 <bread+0x40>
    8000235e:	68a4                	ld	s1,80(s1)
    80002360:	02e48a63          	beq	s1,a4,80002394 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002364:	449c                	lw	a5,8(s1)
    80002366:	ff379ce3          	bne	a5,s3,8000235e <bread+0x3a>
    8000236a:	44dc                	lw	a5,12(s1)
    8000236c:	ff2799e3          	bne	a5,s2,8000235e <bread+0x3a>
      b->refcnt++;
    80002370:	40bc                	lw	a5,64(s1)
    80002372:	2785                	addiw	a5,a5,1
    80002374:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002376:	0000c517          	auipc	a0,0xc
    8000237a:	3f250513          	addi	a0,a0,1010 # 8000e768 <bcache>
    8000237e:	00004097          	auipc	ra,0x4
    80002382:	ec2080e7          	jalr	-318(ra) # 80006240 <release>
      acquiresleep(&b->lock);
    80002386:	01048513          	addi	a0,s1,16
    8000238a:	00001097          	auipc	ra,0x1
    8000238e:	46e080e7          	jalr	1134(ra) # 800037f8 <acquiresleep>
      return b;
    80002392:	a8b9                	j	800023f0 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002394:	00014497          	auipc	s1,0x14
    80002398:	6844b483          	ld	s1,1668(s1) # 80016a18 <bcache+0x82b0>
    8000239c:	00014797          	auipc	a5,0x14
    800023a0:	63478793          	addi	a5,a5,1588 # 800169d0 <bcache+0x8268>
    800023a4:	00f48863          	beq	s1,a5,800023b4 <bread+0x90>
    800023a8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800023aa:	40bc                	lw	a5,64(s1)
    800023ac:	cf81                	beqz	a5,800023c4 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023ae:	64a4                	ld	s1,72(s1)
    800023b0:	fee49de3          	bne	s1,a4,800023aa <bread+0x86>
  panic("bget: no buffers");
    800023b4:	00006517          	auipc	a0,0x6
    800023b8:	11c50513          	addi	a0,a0,284 # 800084d0 <syscalls+0xc0>
    800023bc:	00004097          	auipc	ra,0x4
    800023c0:	886080e7          	jalr	-1914(ra) # 80005c42 <panic>
      b->dev = dev;
    800023c4:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800023c8:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800023cc:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800023d0:	4785                	li	a5,1
    800023d2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023d4:	0000c517          	auipc	a0,0xc
    800023d8:	39450513          	addi	a0,a0,916 # 8000e768 <bcache>
    800023dc:	00004097          	auipc	ra,0x4
    800023e0:	e64080e7          	jalr	-412(ra) # 80006240 <release>
      acquiresleep(&b->lock);
    800023e4:	01048513          	addi	a0,s1,16
    800023e8:	00001097          	auipc	ra,0x1
    800023ec:	410080e7          	jalr	1040(ra) # 800037f8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800023f0:	409c                	lw	a5,0(s1)
    800023f2:	cb89                	beqz	a5,80002404 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800023f4:	8526                	mv	a0,s1
    800023f6:	70a2                	ld	ra,40(sp)
    800023f8:	7402                	ld	s0,32(sp)
    800023fa:	64e2                	ld	s1,24(sp)
    800023fc:	6942                	ld	s2,16(sp)
    800023fe:	69a2                	ld	s3,8(sp)
    80002400:	6145                	addi	sp,sp,48
    80002402:	8082                	ret
    virtio_disk_rw(b, 0);
    80002404:	4581                	li	a1,0
    80002406:	8526                	mv	a0,s1
    80002408:	00003097          	auipc	ra,0x3
    8000240c:	fd0080e7          	jalr	-48(ra) # 800053d8 <virtio_disk_rw>
    b->valid = 1;
    80002410:	4785                	li	a5,1
    80002412:	c09c                	sw	a5,0(s1)
  return b;
    80002414:	b7c5                	j	800023f4 <bread+0xd0>

0000000080002416 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002416:	1101                	addi	sp,sp,-32
    80002418:	ec06                	sd	ra,24(sp)
    8000241a:	e822                	sd	s0,16(sp)
    8000241c:	e426                	sd	s1,8(sp)
    8000241e:	1000                	addi	s0,sp,32
    80002420:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002422:	0541                	addi	a0,a0,16
    80002424:	00001097          	auipc	ra,0x1
    80002428:	46e080e7          	jalr	1134(ra) # 80003892 <holdingsleep>
    8000242c:	cd01                	beqz	a0,80002444 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000242e:	4585                	li	a1,1
    80002430:	8526                	mv	a0,s1
    80002432:	00003097          	auipc	ra,0x3
    80002436:	fa6080e7          	jalr	-90(ra) # 800053d8 <virtio_disk_rw>
}
    8000243a:	60e2                	ld	ra,24(sp)
    8000243c:	6442                	ld	s0,16(sp)
    8000243e:	64a2                	ld	s1,8(sp)
    80002440:	6105                	addi	sp,sp,32
    80002442:	8082                	ret
    panic("bwrite");
    80002444:	00006517          	auipc	a0,0x6
    80002448:	0a450513          	addi	a0,a0,164 # 800084e8 <syscalls+0xd8>
    8000244c:	00003097          	auipc	ra,0x3
    80002450:	7f6080e7          	jalr	2038(ra) # 80005c42 <panic>

0000000080002454 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002454:	1101                	addi	sp,sp,-32
    80002456:	ec06                	sd	ra,24(sp)
    80002458:	e822                	sd	s0,16(sp)
    8000245a:	e426                	sd	s1,8(sp)
    8000245c:	e04a                	sd	s2,0(sp)
    8000245e:	1000                	addi	s0,sp,32
    80002460:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002462:	01050913          	addi	s2,a0,16
    80002466:	854a                	mv	a0,s2
    80002468:	00001097          	auipc	ra,0x1
    8000246c:	42a080e7          	jalr	1066(ra) # 80003892 <holdingsleep>
    80002470:	c92d                	beqz	a0,800024e2 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002472:	854a                	mv	a0,s2
    80002474:	00001097          	auipc	ra,0x1
    80002478:	3da080e7          	jalr	986(ra) # 8000384e <releasesleep>

  acquire(&bcache.lock);
    8000247c:	0000c517          	auipc	a0,0xc
    80002480:	2ec50513          	addi	a0,a0,748 # 8000e768 <bcache>
    80002484:	00004097          	auipc	ra,0x4
    80002488:	d08080e7          	jalr	-760(ra) # 8000618c <acquire>
  b->refcnt--;
    8000248c:	40bc                	lw	a5,64(s1)
    8000248e:	37fd                	addiw	a5,a5,-1
    80002490:	0007871b          	sext.w	a4,a5
    80002494:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002496:	eb05                	bnez	a4,800024c6 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002498:	68bc                	ld	a5,80(s1)
    8000249a:	64b8                	ld	a4,72(s1)
    8000249c:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000249e:	64bc                	ld	a5,72(s1)
    800024a0:	68b8                	ld	a4,80(s1)
    800024a2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800024a4:	00014797          	auipc	a5,0x14
    800024a8:	2c478793          	addi	a5,a5,708 # 80016768 <bcache+0x8000>
    800024ac:	2b87b703          	ld	a4,696(a5)
    800024b0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800024b2:	00014717          	auipc	a4,0x14
    800024b6:	51e70713          	addi	a4,a4,1310 # 800169d0 <bcache+0x8268>
    800024ba:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800024bc:	2b87b703          	ld	a4,696(a5)
    800024c0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800024c2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800024c6:	0000c517          	auipc	a0,0xc
    800024ca:	2a250513          	addi	a0,a0,674 # 8000e768 <bcache>
    800024ce:	00004097          	auipc	ra,0x4
    800024d2:	d72080e7          	jalr	-654(ra) # 80006240 <release>
}
    800024d6:	60e2                	ld	ra,24(sp)
    800024d8:	6442                	ld	s0,16(sp)
    800024da:	64a2                	ld	s1,8(sp)
    800024dc:	6902                	ld	s2,0(sp)
    800024de:	6105                	addi	sp,sp,32
    800024e0:	8082                	ret
    panic("brelse");
    800024e2:	00006517          	auipc	a0,0x6
    800024e6:	00e50513          	addi	a0,a0,14 # 800084f0 <syscalls+0xe0>
    800024ea:	00003097          	auipc	ra,0x3
    800024ee:	758080e7          	jalr	1880(ra) # 80005c42 <panic>

00000000800024f2 <bpin>:

void
bpin(struct buf *b) {
    800024f2:	1101                	addi	sp,sp,-32
    800024f4:	ec06                	sd	ra,24(sp)
    800024f6:	e822                	sd	s0,16(sp)
    800024f8:	e426                	sd	s1,8(sp)
    800024fa:	1000                	addi	s0,sp,32
    800024fc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024fe:	0000c517          	auipc	a0,0xc
    80002502:	26a50513          	addi	a0,a0,618 # 8000e768 <bcache>
    80002506:	00004097          	auipc	ra,0x4
    8000250a:	c86080e7          	jalr	-890(ra) # 8000618c <acquire>
  b->refcnt++;
    8000250e:	40bc                	lw	a5,64(s1)
    80002510:	2785                	addiw	a5,a5,1
    80002512:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002514:	0000c517          	auipc	a0,0xc
    80002518:	25450513          	addi	a0,a0,596 # 8000e768 <bcache>
    8000251c:	00004097          	auipc	ra,0x4
    80002520:	d24080e7          	jalr	-732(ra) # 80006240 <release>
}
    80002524:	60e2                	ld	ra,24(sp)
    80002526:	6442                	ld	s0,16(sp)
    80002528:	64a2                	ld	s1,8(sp)
    8000252a:	6105                	addi	sp,sp,32
    8000252c:	8082                	ret

000000008000252e <bunpin>:

void
bunpin(struct buf *b) {
    8000252e:	1101                	addi	sp,sp,-32
    80002530:	ec06                	sd	ra,24(sp)
    80002532:	e822                	sd	s0,16(sp)
    80002534:	e426                	sd	s1,8(sp)
    80002536:	1000                	addi	s0,sp,32
    80002538:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000253a:	0000c517          	auipc	a0,0xc
    8000253e:	22e50513          	addi	a0,a0,558 # 8000e768 <bcache>
    80002542:	00004097          	auipc	ra,0x4
    80002546:	c4a080e7          	jalr	-950(ra) # 8000618c <acquire>
  b->refcnt--;
    8000254a:	40bc                	lw	a5,64(s1)
    8000254c:	37fd                	addiw	a5,a5,-1
    8000254e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002550:	0000c517          	auipc	a0,0xc
    80002554:	21850513          	addi	a0,a0,536 # 8000e768 <bcache>
    80002558:	00004097          	auipc	ra,0x4
    8000255c:	ce8080e7          	jalr	-792(ra) # 80006240 <release>
}
    80002560:	60e2                	ld	ra,24(sp)
    80002562:	6442                	ld	s0,16(sp)
    80002564:	64a2                	ld	s1,8(sp)
    80002566:	6105                	addi	sp,sp,32
    80002568:	8082                	ret

000000008000256a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000256a:	1101                	addi	sp,sp,-32
    8000256c:	ec06                	sd	ra,24(sp)
    8000256e:	e822                	sd	s0,16(sp)
    80002570:	e426                	sd	s1,8(sp)
    80002572:	e04a                	sd	s2,0(sp)
    80002574:	1000                	addi	s0,sp,32
    80002576:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002578:	00d5d59b          	srliw	a1,a1,0xd
    8000257c:	00015797          	auipc	a5,0x15
    80002580:	8c87a783          	lw	a5,-1848(a5) # 80016e44 <sb+0x1c>
    80002584:	9dbd                	addw	a1,a1,a5
    80002586:	00000097          	auipc	ra,0x0
    8000258a:	d9e080e7          	jalr	-610(ra) # 80002324 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000258e:	0074f713          	andi	a4,s1,7
    80002592:	4785                	li	a5,1
    80002594:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002598:	14ce                	slli	s1,s1,0x33
    8000259a:	90d9                	srli	s1,s1,0x36
    8000259c:	00950733          	add	a4,a0,s1
    800025a0:	05874703          	lbu	a4,88(a4)
    800025a4:	00e7f6b3          	and	a3,a5,a4
    800025a8:	c69d                	beqz	a3,800025d6 <bfree+0x6c>
    800025aa:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800025ac:	94aa                	add	s1,s1,a0
    800025ae:	fff7c793          	not	a5,a5
    800025b2:	8ff9                	and	a5,a5,a4
    800025b4:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800025b8:	00001097          	auipc	ra,0x1
    800025bc:	120080e7          	jalr	288(ra) # 800036d8 <log_write>
  brelse(bp);
    800025c0:	854a                	mv	a0,s2
    800025c2:	00000097          	auipc	ra,0x0
    800025c6:	e92080e7          	jalr	-366(ra) # 80002454 <brelse>
}
    800025ca:	60e2                	ld	ra,24(sp)
    800025cc:	6442                	ld	s0,16(sp)
    800025ce:	64a2                	ld	s1,8(sp)
    800025d0:	6902                	ld	s2,0(sp)
    800025d2:	6105                	addi	sp,sp,32
    800025d4:	8082                	ret
    panic("freeing free block");
    800025d6:	00006517          	auipc	a0,0x6
    800025da:	f2250513          	addi	a0,a0,-222 # 800084f8 <syscalls+0xe8>
    800025de:	00003097          	auipc	ra,0x3
    800025e2:	664080e7          	jalr	1636(ra) # 80005c42 <panic>

00000000800025e6 <balloc>:
{
    800025e6:	711d                	addi	sp,sp,-96
    800025e8:	ec86                	sd	ra,88(sp)
    800025ea:	e8a2                	sd	s0,80(sp)
    800025ec:	e4a6                	sd	s1,72(sp)
    800025ee:	e0ca                	sd	s2,64(sp)
    800025f0:	fc4e                	sd	s3,56(sp)
    800025f2:	f852                	sd	s4,48(sp)
    800025f4:	f456                	sd	s5,40(sp)
    800025f6:	f05a                	sd	s6,32(sp)
    800025f8:	ec5e                	sd	s7,24(sp)
    800025fa:	e862                	sd	s8,16(sp)
    800025fc:	e466                	sd	s9,8(sp)
    800025fe:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002600:	00015797          	auipc	a5,0x15
    80002604:	82c7a783          	lw	a5,-2004(a5) # 80016e2c <sb+0x4>
    80002608:	10078163          	beqz	a5,8000270a <balloc+0x124>
    8000260c:	8baa                	mv	s7,a0
    8000260e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002610:	00015b17          	auipc	s6,0x15
    80002614:	818b0b13          	addi	s6,s6,-2024 # 80016e28 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002618:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000261a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000261c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000261e:	6c89                	lui	s9,0x2
    80002620:	a061                	j	800026a8 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002622:	974a                	add	a4,a4,s2
    80002624:	8fd5                	or	a5,a5,a3
    80002626:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000262a:	854a                	mv	a0,s2
    8000262c:	00001097          	auipc	ra,0x1
    80002630:	0ac080e7          	jalr	172(ra) # 800036d8 <log_write>
        brelse(bp);
    80002634:	854a                	mv	a0,s2
    80002636:	00000097          	auipc	ra,0x0
    8000263a:	e1e080e7          	jalr	-482(ra) # 80002454 <brelse>
  bp = bread(dev, bno);
    8000263e:	85a6                	mv	a1,s1
    80002640:	855e                	mv	a0,s7
    80002642:	00000097          	auipc	ra,0x0
    80002646:	ce2080e7          	jalr	-798(ra) # 80002324 <bread>
    8000264a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000264c:	40000613          	li	a2,1024
    80002650:	4581                	li	a1,0
    80002652:	05850513          	addi	a0,a0,88
    80002656:	ffffe097          	auipc	ra,0xffffe
    8000265a:	b22080e7          	jalr	-1246(ra) # 80000178 <memset>
  log_write(bp);
    8000265e:	854a                	mv	a0,s2
    80002660:	00001097          	auipc	ra,0x1
    80002664:	078080e7          	jalr	120(ra) # 800036d8 <log_write>
  brelse(bp);
    80002668:	854a                	mv	a0,s2
    8000266a:	00000097          	auipc	ra,0x0
    8000266e:	dea080e7          	jalr	-534(ra) # 80002454 <brelse>
}
    80002672:	8526                	mv	a0,s1
    80002674:	60e6                	ld	ra,88(sp)
    80002676:	6446                	ld	s0,80(sp)
    80002678:	64a6                	ld	s1,72(sp)
    8000267a:	6906                	ld	s2,64(sp)
    8000267c:	79e2                	ld	s3,56(sp)
    8000267e:	7a42                	ld	s4,48(sp)
    80002680:	7aa2                	ld	s5,40(sp)
    80002682:	7b02                	ld	s6,32(sp)
    80002684:	6be2                	ld	s7,24(sp)
    80002686:	6c42                	ld	s8,16(sp)
    80002688:	6ca2                	ld	s9,8(sp)
    8000268a:	6125                	addi	sp,sp,96
    8000268c:	8082                	ret
    brelse(bp);
    8000268e:	854a                	mv	a0,s2
    80002690:	00000097          	auipc	ra,0x0
    80002694:	dc4080e7          	jalr	-572(ra) # 80002454 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002698:	015c87bb          	addw	a5,s9,s5
    8000269c:	00078a9b          	sext.w	s5,a5
    800026a0:	004b2703          	lw	a4,4(s6)
    800026a4:	06eaf363          	bgeu	s5,a4,8000270a <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    800026a8:	41fad79b          	sraiw	a5,s5,0x1f
    800026ac:	0137d79b          	srliw	a5,a5,0x13
    800026b0:	015787bb          	addw	a5,a5,s5
    800026b4:	40d7d79b          	sraiw	a5,a5,0xd
    800026b8:	01cb2583          	lw	a1,28(s6)
    800026bc:	9dbd                	addw	a1,a1,a5
    800026be:	855e                	mv	a0,s7
    800026c0:	00000097          	auipc	ra,0x0
    800026c4:	c64080e7          	jalr	-924(ra) # 80002324 <bread>
    800026c8:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026ca:	004b2503          	lw	a0,4(s6)
    800026ce:	000a849b          	sext.w	s1,s5
    800026d2:	8662                	mv	a2,s8
    800026d4:	faa4fde3          	bgeu	s1,a0,8000268e <balloc+0xa8>
      m = 1 << (bi % 8);
    800026d8:	41f6579b          	sraiw	a5,a2,0x1f
    800026dc:	01d7d69b          	srliw	a3,a5,0x1d
    800026e0:	00c6873b          	addw	a4,a3,a2
    800026e4:	00777793          	andi	a5,a4,7
    800026e8:	9f95                	subw	a5,a5,a3
    800026ea:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800026ee:	4037571b          	sraiw	a4,a4,0x3
    800026f2:	00e906b3          	add	a3,s2,a4
    800026f6:	0586c683          	lbu	a3,88(a3)
    800026fa:	00d7f5b3          	and	a1,a5,a3
    800026fe:	d195                	beqz	a1,80002622 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002700:	2605                	addiw	a2,a2,1
    80002702:	2485                	addiw	s1,s1,1
    80002704:	fd4618e3          	bne	a2,s4,800026d4 <balloc+0xee>
    80002708:	b759                	j	8000268e <balloc+0xa8>
  printf("balloc: out of blocks\n");
    8000270a:	00006517          	auipc	a0,0x6
    8000270e:	e0650513          	addi	a0,a0,-506 # 80008510 <syscalls+0x100>
    80002712:	00003097          	auipc	ra,0x3
    80002716:	57a080e7          	jalr	1402(ra) # 80005c8c <printf>
  return 0;
    8000271a:	4481                	li	s1,0
    8000271c:	bf99                	j	80002672 <balloc+0x8c>

000000008000271e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000271e:	7179                	addi	sp,sp,-48
    80002720:	f406                	sd	ra,40(sp)
    80002722:	f022                	sd	s0,32(sp)
    80002724:	ec26                	sd	s1,24(sp)
    80002726:	e84a                	sd	s2,16(sp)
    80002728:	e44e                	sd	s3,8(sp)
    8000272a:	e052                	sd	s4,0(sp)
    8000272c:	1800                	addi	s0,sp,48
    8000272e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002730:	47ad                	li	a5,11
    80002732:	02b7e763          	bltu	a5,a1,80002760 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80002736:	02059493          	slli	s1,a1,0x20
    8000273a:	9081                	srli	s1,s1,0x20
    8000273c:	048a                	slli	s1,s1,0x2
    8000273e:	94aa                	add	s1,s1,a0
    80002740:	0504a903          	lw	s2,80(s1)
    80002744:	06091e63          	bnez	s2,800027c0 <bmap+0xa2>
      addr = balloc(ip->dev);
    80002748:	4108                	lw	a0,0(a0)
    8000274a:	00000097          	auipc	ra,0x0
    8000274e:	e9c080e7          	jalr	-356(ra) # 800025e6 <balloc>
    80002752:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002756:	06090563          	beqz	s2,800027c0 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    8000275a:	0524a823          	sw	s2,80(s1)
    8000275e:	a08d                	j	800027c0 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002760:	ff45849b          	addiw	s1,a1,-12
    80002764:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002768:	0ff00793          	li	a5,255
    8000276c:	08e7e563          	bltu	a5,a4,800027f6 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002770:	08052903          	lw	s2,128(a0)
    80002774:	00091d63          	bnez	s2,8000278e <bmap+0x70>
      addr = balloc(ip->dev);
    80002778:	4108                	lw	a0,0(a0)
    8000277a:	00000097          	auipc	ra,0x0
    8000277e:	e6c080e7          	jalr	-404(ra) # 800025e6 <balloc>
    80002782:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002786:	02090d63          	beqz	s2,800027c0 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000278a:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000278e:	85ca                	mv	a1,s2
    80002790:	0009a503          	lw	a0,0(s3)
    80002794:	00000097          	auipc	ra,0x0
    80002798:	b90080e7          	jalr	-1136(ra) # 80002324 <bread>
    8000279c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000279e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800027a2:	02049593          	slli	a1,s1,0x20
    800027a6:	9181                	srli	a1,a1,0x20
    800027a8:	058a                	slli	a1,a1,0x2
    800027aa:	00b784b3          	add	s1,a5,a1
    800027ae:	0004a903          	lw	s2,0(s1)
    800027b2:	02090063          	beqz	s2,800027d2 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800027b6:	8552                	mv	a0,s4
    800027b8:	00000097          	auipc	ra,0x0
    800027bc:	c9c080e7          	jalr	-868(ra) # 80002454 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800027c0:	854a                	mv	a0,s2
    800027c2:	70a2                	ld	ra,40(sp)
    800027c4:	7402                	ld	s0,32(sp)
    800027c6:	64e2                	ld	s1,24(sp)
    800027c8:	6942                	ld	s2,16(sp)
    800027ca:	69a2                	ld	s3,8(sp)
    800027cc:	6a02                	ld	s4,0(sp)
    800027ce:	6145                	addi	sp,sp,48
    800027d0:	8082                	ret
      addr = balloc(ip->dev);
    800027d2:	0009a503          	lw	a0,0(s3)
    800027d6:	00000097          	auipc	ra,0x0
    800027da:	e10080e7          	jalr	-496(ra) # 800025e6 <balloc>
    800027de:	0005091b          	sext.w	s2,a0
      if(addr){
    800027e2:	fc090ae3          	beqz	s2,800027b6 <bmap+0x98>
        a[bn] = addr;
    800027e6:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800027ea:	8552                	mv	a0,s4
    800027ec:	00001097          	auipc	ra,0x1
    800027f0:	eec080e7          	jalr	-276(ra) # 800036d8 <log_write>
    800027f4:	b7c9                	j	800027b6 <bmap+0x98>
  panic("bmap: out of range");
    800027f6:	00006517          	auipc	a0,0x6
    800027fa:	d3250513          	addi	a0,a0,-718 # 80008528 <syscalls+0x118>
    800027fe:	00003097          	auipc	ra,0x3
    80002802:	444080e7          	jalr	1092(ra) # 80005c42 <panic>

0000000080002806 <iget>:
{
    80002806:	7179                	addi	sp,sp,-48
    80002808:	f406                	sd	ra,40(sp)
    8000280a:	f022                	sd	s0,32(sp)
    8000280c:	ec26                	sd	s1,24(sp)
    8000280e:	e84a                	sd	s2,16(sp)
    80002810:	e44e                	sd	s3,8(sp)
    80002812:	e052                	sd	s4,0(sp)
    80002814:	1800                	addi	s0,sp,48
    80002816:	89aa                	mv	s3,a0
    80002818:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000281a:	00014517          	auipc	a0,0x14
    8000281e:	62e50513          	addi	a0,a0,1582 # 80016e48 <itable>
    80002822:	00004097          	auipc	ra,0x4
    80002826:	96a080e7          	jalr	-1686(ra) # 8000618c <acquire>
  empty = 0;
    8000282a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000282c:	00014497          	auipc	s1,0x14
    80002830:	63448493          	addi	s1,s1,1588 # 80016e60 <itable+0x18>
    80002834:	00016697          	auipc	a3,0x16
    80002838:	0bc68693          	addi	a3,a3,188 # 800188f0 <log>
    8000283c:	a039                	j	8000284a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000283e:	02090b63          	beqz	s2,80002874 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002842:	08848493          	addi	s1,s1,136
    80002846:	02d48a63          	beq	s1,a3,8000287a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000284a:	449c                	lw	a5,8(s1)
    8000284c:	fef059e3          	blez	a5,8000283e <iget+0x38>
    80002850:	4098                	lw	a4,0(s1)
    80002852:	ff3716e3          	bne	a4,s3,8000283e <iget+0x38>
    80002856:	40d8                	lw	a4,4(s1)
    80002858:	ff4713e3          	bne	a4,s4,8000283e <iget+0x38>
      ip->ref++;
    8000285c:	2785                	addiw	a5,a5,1
    8000285e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002860:	00014517          	auipc	a0,0x14
    80002864:	5e850513          	addi	a0,a0,1512 # 80016e48 <itable>
    80002868:	00004097          	auipc	ra,0x4
    8000286c:	9d8080e7          	jalr	-1576(ra) # 80006240 <release>
      return ip;
    80002870:	8926                	mv	s2,s1
    80002872:	a03d                	j	800028a0 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002874:	f7f9                	bnez	a5,80002842 <iget+0x3c>
    80002876:	8926                	mv	s2,s1
    80002878:	b7e9                	j	80002842 <iget+0x3c>
  if(empty == 0)
    8000287a:	02090c63          	beqz	s2,800028b2 <iget+0xac>
  ip->dev = dev;
    8000287e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002882:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002886:	4785                	li	a5,1
    80002888:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000288c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002890:	00014517          	auipc	a0,0x14
    80002894:	5b850513          	addi	a0,a0,1464 # 80016e48 <itable>
    80002898:	00004097          	auipc	ra,0x4
    8000289c:	9a8080e7          	jalr	-1624(ra) # 80006240 <release>
}
    800028a0:	854a                	mv	a0,s2
    800028a2:	70a2                	ld	ra,40(sp)
    800028a4:	7402                	ld	s0,32(sp)
    800028a6:	64e2                	ld	s1,24(sp)
    800028a8:	6942                	ld	s2,16(sp)
    800028aa:	69a2                	ld	s3,8(sp)
    800028ac:	6a02                	ld	s4,0(sp)
    800028ae:	6145                	addi	sp,sp,48
    800028b0:	8082                	ret
    panic("iget: no inodes");
    800028b2:	00006517          	auipc	a0,0x6
    800028b6:	c8e50513          	addi	a0,a0,-882 # 80008540 <syscalls+0x130>
    800028ba:	00003097          	auipc	ra,0x3
    800028be:	388080e7          	jalr	904(ra) # 80005c42 <panic>

00000000800028c2 <fsinit>:
fsinit(int dev) {
    800028c2:	7179                	addi	sp,sp,-48
    800028c4:	f406                	sd	ra,40(sp)
    800028c6:	f022                	sd	s0,32(sp)
    800028c8:	ec26                	sd	s1,24(sp)
    800028ca:	e84a                	sd	s2,16(sp)
    800028cc:	e44e                	sd	s3,8(sp)
    800028ce:	1800                	addi	s0,sp,48
    800028d0:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800028d2:	4585                	li	a1,1
    800028d4:	00000097          	auipc	ra,0x0
    800028d8:	a50080e7          	jalr	-1456(ra) # 80002324 <bread>
    800028dc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800028de:	00014997          	auipc	s3,0x14
    800028e2:	54a98993          	addi	s3,s3,1354 # 80016e28 <sb>
    800028e6:	02000613          	li	a2,32
    800028ea:	05850593          	addi	a1,a0,88
    800028ee:	854e                	mv	a0,s3
    800028f0:	ffffe097          	auipc	ra,0xffffe
    800028f4:	8e8080e7          	jalr	-1816(ra) # 800001d8 <memmove>
  brelse(bp);
    800028f8:	8526                	mv	a0,s1
    800028fa:	00000097          	auipc	ra,0x0
    800028fe:	b5a080e7          	jalr	-1190(ra) # 80002454 <brelse>
  if(sb.magic != FSMAGIC)
    80002902:	0009a703          	lw	a4,0(s3)
    80002906:	102037b7          	lui	a5,0x10203
    8000290a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000290e:	02f71263          	bne	a4,a5,80002932 <fsinit+0x70>
  initlog(dev, &sb);
    80002912:	00014597          	auipc	a1,0x14
    80002916:	51658593          	addi	a1,a1,1302 # 80016e28 <sb>
    8000291a:	854a                	mv	a0,s2
    8000291c:	00001097          	auipc	ra,0x1
    80002920:	b40080e7          	jalr	-1216(ra) # 8000345c <initlog>
}
    80002924:	70a2                	ld	ra,40(sp)
    80002926:	7402                	ld	s0,32(sp)
    80002928:	64e2                	ld	s1,24(sp)
    8000292a:	6942                	ld	s2,16(sp)
    8000292c:	69a2                	ld	s3,8(sp)
    8000292e:	6145                	addi	sp,sp,48
    80002930:	8082                	ret
    panic("invalid file system");
    80002932:	00006517          	auipc	a0,0x6
    80002936:	c1e50513          	addi	a0,a0,-994 # 80008550 <syscalls+0x140>
    8000293a:	00003097          	auipc	ra,0x3
    8000293e:	308080e7          	jalr	776(ra) # 80005c42 <panic>

0000000080002942 <iinit>:
{
    80002942:	7179                	addi	sp,sp,-48
    80002944:	f406                	sd	ra,40(sp)
    80002946:	f022                	sd	s0,32(sp)
    80002948:	ec26                	sd	s1,24(sp)
    8000294a:	e84a                	sd	s2,16(sp)
    8000294c:	e44e                	sd	s3,8(sp)
    8000294e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002950:	00006597          	auipc	a1,0x6
    80002954:	c1858593          	addi	a1,a1,-1000 # 80008568 <syscalls+0x158>
    80002958:	00014517          	auipc	a0,0x14
    8000295c:	4f050513          	addi	a0,a0,1264 # 80016e48 <itable>
    80002960:	00003097          	auipc	ra,0x3
    80002964:	79c080e7          	jalr	1948(ra) # 800060fc <initlock>
  for(i = 0; i < NINODE; i++) {
    80002968:	00014497          	auipc	s1,0x14
    8000296c:	50848493          	addi	s1,s1,1288 # 80016e70 <itable+0x28>
    80002970:	00016997          	auipc	s3,0x16
    80002974:	f9098993          	addi	s3,s3,-112 # 80018900 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002978:	00006917          	auipc	s2,0x6
    8000297c:	bf890913          	addi	s2,s2,-1032 # 80008570 <syscalls+0x160>
    80002980:	85ca                	mv	a1,s2
    80002982:	8526                	mv	a0,s1
    80002984:	00001097          	auipc	ra,0x1
    80002988:	e3a080e7          	jalr	-454(ra) # 800037be <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000298c:	08848493          	addi	s1,s1,136
    80002990:	ff3498e3          	bne	s1,s3,80002980 <iinit+0x3e>
}
    80002994:	70a2                	ld	ra,40(sp)
    80002996:	7402                	ld	s0,32(sp)
    80002998:	64e2                	ld	s1,24(sp)
    8000299a:	6942                	ld	s2,16(sp)
    8000299c:	69a2                	ld	s3,8(sp)
    8000299e:	6145                	addi	sp,sp,48
    800029a0:	8082                	ret

00000000800029a2 <ialloc>:
{
    800029a2:	715d                	addi	sp,sp,-80
    800029a4:	e486                	sd	ra,72(sp)
    800029a6:	e0a2                	sd	s0,64(sp)
    800029a8:	fc26                	sd	s1,56(sp)
    800029aa:	f84a                	sd	s2,48(sp)
    800029ac:	f44e                	sd	s3,40(sp)
    800029ae:	f052                	sd	s4,32(sp)
    800029b0:	ec56                	sd	s5,24(sp)
    800029b2:	e85a                	sd	s6,16(sp)
    800029b4:	e45e                	sd	s7,8(sp)
    800029b6:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800029b8:	00014717          	auipc	a4,0x14
    800029bc:	47c72703          	lw	a4,1148(a4) # 80016e34 <sb+0xc>
    800029c0:	4785                	li	a5,1
    800029c2:	04e7fa63          	bgeu	a5,a4,80002a16 <ialloc+0x74>
    800029c6:	8aaa                	mv	s5,a0
    800029c8:	8bae                	mv	s7,a1
    800029ca:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800029cc:	00014a17          	auipc	s4,0x14
    800029d0:	45ca0a13          	addi	s4,s4,1116 # 80016e28 <sb>
    800029d4:	00048b1b          	sext.w	s6,s1
    800029d8:	0044d593          	srli	a1,s1,0x4
    800029dc:	018a2783          	lw	a5,24(s4)
    800029e0:	9dbd                	addw	a1,a1,a5
    800029e2:	8556                	mv	a0,s5
    800029e4:	00000097          	auipc	ra,0x0
    800029e8:	940080e7          	jalr	-1728(ra) # 80002324 <bread>
    800029ec:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800029ee:	05850993          	addi	s3,a0,88
    800029f2:	00f4f793          	andi	a5,s1,15
    800029f6:	079a                	slli	a5,a5,0x6
    800029f8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800029fa:	00099783          	lh	a5,0(s3)
    800029fe:	c3a1                	beqz	a5,80002a3e <ialloc+0x9c>
    brelse(bp);
    80002a00:	00000097          	auipc	ra,0x0
    80002a04:	a54080e7          	jalr	-1452(ra) # 80002454 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a08:	0485                	addi	s1,s1,1
    80002a0a:	00ca2703          	lw	a4,12(s4)
    80002a0e:	0004879b          	sext.w	a5,s1
    80002a12:	fce7e1e3          	bltu	a5,a4,800029d4 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002a16:	00006517          	auipc	a0,0x6
    80002a1a:	b6250513          	addi	a0,a0,-1182 # 80008578 <syscalls+0x168>
    80002a1e:	00003097          	auipc	ra,0x3
    80002a22:	26e080e7          	jalr	622(ra) # 80005c8c <printf>
  return 0;
    80002a26:	4501                	li	a0,0
}
    80002a28:	60a6                	ld	ra,72(sp)
    80002a2a:	6406                	ld	s0,64(sp)
    80002a2c:	74e2                	ld	s1,56(sp)
    80002a2e:	7942                	ld	s2,48(sp)
    80002a30:	79a2                	ld	s3,40(sp)
    80002a32:	7a02                	ld	s4,32(sp)
    80002a34:	6ae2                	ld	s5,24(sp)
    80002a36:	6b42                	ld	s6,16(sp)
    80002a38:	6ba2                	ld	s7,8(sp)
    80002a3a:	6161                	addi	sp,sp,80
    80002a3c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002a3e:	04000613          	li	a2,64
    80002a42:	4581                	li	a1,0
    80002a44:	854e                	mv	a0,s3
    80002a46:	ffffd097          	auipc	ra,0xffffd
    80002a4a:	732080e7          	jalr	1842(ra) # 80000178 <memset>
      dip->type = type;
    80002a4e:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a52:	854a                	mv	a0,s2
    80002a54:	00001097          	auipc	ra,0x1
    80002a58:	c84080e7          	jalr	-892(ra) # 800036d8 <log_write>
      brelse(bp);
    80002a5c:	854a                	mv	a0,s2
    80002a5e:	00000097          	auipc	ra,0x0
    80002a62:	9f6080e7          	jalr	-1546(ra) # 80002454 <brelse>
      return iget(dev, inum);
    80002a66:	85da                	mv	a1,s6
    80002a68:	8556                	mv	a0,s5
    80002a6a:	00000097          	auipc	ra,0x0
    80002a6e:	d9c080e7          	jalr	-612(ra) # 80002806 <iget>
    80002a72:	bf5d                	j	80002a28 <ialloc+0x86>

0000000080002a74 <iupdate>:
{
    80002a74:	1101                	addi	sp,sp,-32
    80002a76:	ec06                	sd	ra,24(sp)
    80002a78:	e822                	sd	s0,16(sp)
    80002a7a:	e426                	sd	s1,8(sp)
    80002a7c:	e04a                	sd	s2,0(sp)
    80002a7e:	1000                	addi	s0,sp,32
    80002a80:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a82:	415c                	lw	a5,4(a0)
    80002a84:	0047d79b          	srliw	a5,a5,0x4
    80002a88:	00014597          	auipc	a1,0x14
    80002a8c:	3b85a583          	lw	a1,952(a1) # 80016e40 <sb+0x18>
    80002a90:	9dbd                	addw	a1,a1,a5
    80002a92:	4108                	lw	a0,0(a0)
    80002a94:	00000097          	auipc	ra,0x0
    80002a98:	890080e7          	jalr	-1904(ra) # 80002324 <bread>
    80002a9c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a9e:	05850793          	addi	a5,a0,88
    80002aa2:	40c8                	lw	a0,4(s1)
    80002aa4:	893d                	andi	a0,a0,15
    80002aa6:	051a                	slli	a0,a0,0x6
    80002aa8:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002aaa:	04449703          	lh	a4,68(s1)
    80002aae:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002ab2:	04649703          	lh	a4,70(s1)
    80002ab6:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002aba:	04849703          	lh	a4,72(s1)
    80002abe:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002ac2:	04a49703          	lh	a4,74(s1)
    80002ac6:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002aca:	44f8                	lw	a4,76(s1)
    80002acc:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ace:	03400613          	li	a2,52
    80002ad2:	05048593          	addi	a1,s1,80
    80002ad6:	0531                	addi	a0,a0,12
    80002ad8:	ffffd097          	auipc	ra,0xffffd
    80002adc:	700080e7          	jalr	1792(ra) # 800001d8 <memmove>
  log_write(bp);
    80002ae0:	854a                	mv	a0,s2
    80002ae2:	00001097          	auipc	ra,0x1
    80002ae6:	bf6080e7          	jalr	-1034(ra) # 800036d8 <log_write>
  brelse(bp);
    80002aea:	854a                	mv	a0,s2
    80002aec:	00000097          	auipc	ra,0x0
    80002af0:	968080e7          	jalr	-1688(ra) # 80002454 <brelse>
}
    80002af4:	60e2                	ld	ra,24(sp)
    80002af6:	6442                	ld	s0,16(sp)
    80002af8:	64a2                	ld	s1,8(sp)
    80002afa:	6902                	ld	s2,0(sp)
    80002afc:	6105                	addi	sp,sp,32
    80002afe:	8082                	ret

0000000080002b00 <idup>:
{
    80002b00:	1101                	addi	sp,sp,-32
    80002b02:	ec06                	sd	ra,24(sp)
    80002b04:	e822                	sd	s0,16(sp)
    80002b06:	e426                	sd	s1,8(sp)
    80002b08:	1000                	addi	s0,sp,32
    80002b0a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b0c:	00014517          	auipc	a0,0x14
    80002b10:	33c50513          	addi	a0,a0,828 # 80016e48 <itable>
    80002b14:	00003097          	auipc	ra,0x3
    80002b18:	678080e7          	jalr	1656(ra) # 8000618c <acquire>
  ip->ref++;
    80002b1c:	449c                	lw	a5,8(s1)
    80002b1e:	2785                	addiw	a5,a5,1
    80002b20:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b22:	00014517          	auipc	a0,0x14
    80002b26:	32650513          	addi	a0,a0,806 # 80016e48 <itable>
    80002b2a:	00003097          	auipc	ra,0x3
    80002b2e:	716080e7          	jalr	1814(ra) # 80006240 <release>
}
    80002b32:	8526                	mv	a0,s1
    80002b34:	60e2                	ld	ra,24(sp)
    80002b36:	6442                	ld	s0,16(sp)
    80002b38:	64a2                	ld	s1,8(sp)
    80002b3a:	6105                	addi	sp,sp,32
    80002b3c:	8082                	ret

0000000080002b3e <ilock>:
{
    80002b3e:	1101                	addi	sp,sp,-32
    80002b40:	ec06                	sd	ra,24(sp)
    80002b42:	e822                	sd	s0,16(sp)
    80002b44:	e426                	sd	s1,8(sp)
    80002b46:	e04a                	sd	s2,0(sp)
    80002b48:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b4a:	c115                	beqz	a0,80002b6e <ilock+0x30>
    80002b4c:	84aa                	mv	s1,a0
    80002b4e:	451c                	lw	a5,8(a0)
    80002b50:	00f05f63          	blez	a5,80002b6e <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b54:	0541                	addi	a0,a0,16
    80002b56:	00001097          	auipc	ra,0x1
    80002b5a:	ca2080e7          	jalr	-862(ra) # 800037f8 <acquiresleep>
  if(ip->valid == 0){
    80002b5e:	40bc                	lw	a5,64(s1)
    80002b60:	cf99                	beqz	a5,80002b7e <ilock+0x40>
}
    80002b62:	60e2                	ld	ra,24(sp)
    80002b64:	6442                	ld	s0,16(sp)
    80002b66:	64a2                	ld	s1,8(sp)
    80002b68:	6902                	ld	s2,0(sp)
    80002b6a:	6105                	addi	sp,sp,32
    80002b6c:	8082                	ret
    panic("ilock");
    80002b6e:	00006517          	auipc	a0,0x6
    80002b72:	a2250513          	addi	a0,a0,-1502 # 80008590 <syscalls+0x180>
    80002b76:	00003097          	auipc	ra,0x3
    80002b7a:	0cc080e7          	jalr	204(ra) # 80005c42 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b7e:	40dc                	lw	a5,4(s1)
    80002b80:	0047d79b          	srliw	a5,a5,0x4
    80002b84:	00014597          	auipc	a1,0x14
    80002b88:	2bc5a583          	lw	a1,700(a1) # 80016e40 <sb+0x18>
    80002b8c:	9dbd                	addw	a1,a1,a5
    80002b8e:	4088                	lw	a0,0(s1)
    80002b90:	fffff097          	auipc	ra,0xfffff
    80002b94:	794080e7          	jalr	1940(ra) # 80002324 <bread>
    80002b98:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b9a:	05850593          	addi	a1,a0,88
    80002b9e:	40dc                	lw	a5,4(s1)
    80002ba0:	8bbd                	andi	a5,a5,15
    80002ba2:	079a                	slli	a5,a5,0x6
    80002ba4:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ba6:	00059783          	lh	a5,0(a1)
    80002baa:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002bae:	00259783          	lh	a5,2(a1)
    80002bb2:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002bb6:	00459783          	lh	a5,4(a1)
    80002bba:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002bbe:	00659783          	lh	a5,6(a1)
    80002bc2:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002bc6:	459c                	lw	a5,8(a1)
    80002bc8:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002bca:	03400613          	li	a2,52
    80002bce:	05b1                	addi	a1,a1,12
    80002bd0:	05048513          	addi	a0,s1,80
    80002bd4:	ffffd097          	auipc	ra,0xffffd
    80002bd8:	604080e7          	jalr	1540(ra) # 800001d8 <memmove>
    brelse(bp);
    80002bdc:	854a                	mv	a0,s2
    80002bde:	00000097          	auipc	ra,0x0
    80002be2:	876080e7          	jalr	-1930(ra) # 80002454 <brelse>
    ip->valid = 1;
    80002be6:	4785                	li	a5,1
    80002be8:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002bea:	04449783          	lh	a5,68(s1)
    80002bee:	fbb5                	bnez	a5,80002b62 <ilock+0x24>
      panic("ilock: no type");
    80002bf0:	00006517          	auipc	a0,0x6
    80002bf4:	9a850513          	addi	a0,a0,-1624 # 80008598 <syscalls+0x188>
    80002bf8:	00003097          	auipc	ra,0x3
    80002bfc:	04a080e7          	jalr	74(ra) # 80005c42 <panic>

0000000080002c00 <iunlock>:
{
    80002c00:	1101                	addi	sp,sp,-32
    80002c02:	ec06                	sd	ra,24(sp)
    80002c04:	e822                	sd	s0,16(sp)
    80002c06:	e426                	sd	s1,8(sp)
    80002c08:	e04a                	sd	s2,0(sp)
    80002c0a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c0c:	c905                	beqz	a0,80002c3c <iunlock+0x3c>
    80002c0e:	84aa                	mv	s1,a0
    80002c10:	01050913          	addi	s2,a0,16
    80002c14:	854a                	mv	a0,s2
    80002c16:	00001097          	auipc	ra,0x1
    80002c1a:	c7c080e7          	jalr	-900(ra) # 80003892 <holdingsleep>
    80002c1e:	cd19                	beqz	a0,80002c3c <iunlock+0x3c>
    80002c20:	449c                	lw	a5,8(s1)
    80002c22:	00f05d63          	blez	a5,80002c3c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c26:	854a                	mv	a0,s2
    80002c28:	00001097          	auipc	ra,0x1
    80002c2c:	c26080e7          	jalr	-986(ra) # 8000384e <releasesleep>
}
    80002c30:	60e2                	ld	ra,24(sp)
    80002c32:	6442                	ld	s0,16(sp)
    80002c34:	64a2                	ld	s1,8(sp)
    80002c36:	6902                	ld	s2,0(sp)
    80002c38:	6105                	addi	sp,sp,32
    80002c3a:	8082                	ret
    panic("iunlock");
    80002c3c:	00006517          	auipc	a0,0x6
    80002c40:	96c50513          	addi	a0,a0,-1684 # 800085a8 <syscalls+0x198>
    80002c44:	00003097          	auipc	ra,0x3
    80002c48:	ffe080e7          	jalr	-2(ra) # 80005c42 <panic>

0000000080002c4c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c4c:	7179                	addi	sp,sp,-48
    80002c4e:	f406                	sd	ra,40(sp)
    80002c50:	f022                	sd	s0,32(sp)
    80002c52:	ec26                	sd	s1,24(sp)
    80002c54:	e84a                	sd	s2,16(sp)
    80002c56:	e44e                	sd	s3,8(sp)
    80002c58:	e052                	sd	s4,0(sp)
    80002c5a:	1800                	addi	s0,sp,48
    80002c5c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c5e:	05050493          	addi	s1,a0,80
    80002c62:	08050913          	addi	s2,a0,128
    80002c66:	a021                	j	80002c6e <itrunc+0x22>
    80002c68:	0491                	addi	s1,s1,4
    80002c6a:	01248d63          	beq	s1,s2,80002c84 <itrunc+0x38>
    if(ip->addrs[i]){
    80002c6e:	408c                	lw	a1,0(s1)
    80002c70:	dde5                	beqz	a1,80002c68 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c72:	0009a503          	lw	a0,0(s3)
    80002c76:	00000097          	auipc	ra,0x0
    80002c7a:	8f4080e7          	jalr	-1804(ra) # 8000256a <bfree>
      ip->addrs[i] = 0;
    80002c7e:	0004a023          	sw	zero,0(s1)
    80002c82:	b7dd                	j	80002c68 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c84:	0809a583          	lw	a1,128(s3)
    80002c88:	e185                	bnez	a1,80002ca8 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c8a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c8e:	854e                	mv	a0,s3
    80002c90:	00000097          	auipc	ra,0x0
    80002c94:	de4080e7          	jalr	-540(ra) # 80002a74 <iupdate>
}
    80002c98:	70a2                	ld	ra,40(sp)
    80002c9a:	7402                	ld	s0,32(sp)
    80002c9c:	64e2                	ld	s1,24(sp)
    80002c9e:	6942                	ld	s2,16(sp)
    80002ca0:	69a2                	ld	s3,8(sp)
    80002ca2:	6a02                	ld	s4,0(sp)
    80002ca4:	6145                	addi	sp,sp,48
    80002ca6:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ca8:	0009a503          	lw	a0,0(s3)
    80002cac:	fffff097          	auipc	ra,0xfffff
    80002cb0:	678080e7          	jalr	1656(ra) # 80002324 <bread>
    80002cb4:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002cb6:	05850493          	addi	s1,a0,88
    80002cba:	45850913          	addi	s2,a0,1112
    80002cbe:	a811                	j	80002cd2 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002cc0:	0009a503          	lw	a0,0(s3)
    80002cc4:	00000097          	auipc	ra,0x0
    80002cc8:	8a6080e7          	jalr	-1882(ra) # 8000256a <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002ccc:	0491                	addi	s1,s1,4
    80002cce:	01248563          	beq	s1,s2,80002cd8 <itrunc+0x8c>
      if(a[j])
    80002cd2:	408c                	lw	a1,0(s1)
    80002cd4:	dde5                	beqz	a1,80002ccc <itrunc+0x80>
    80002cd6:	b7ed                	j	80002cc0 <itrunc+0x74>
    brelse(bp);
    80002cd8:	8552                	mv	a0,s4
    80002cda:	fffff097          	auipc	ra,0xfffff
    80002cde:	77a080e7          	jalr	1914(ra) # 80002454 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002ce2:	0809a583          	lw	a1,128(s3)
    80002ce6:	0009a503          	lw	a0,0(s3)
    80002cea:	00000097          	auipc	ra,0x0
    80002cee:	880080e7          	jalr	-1920(ra) # 8000256a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002cf2:	0809a023          	sw	zero,128(s3)
    80002cf6:	bf51                	j	80002c8a <itrunc+0x3e>

0000000080002cf8 <iput>:
{
    80002cf8:	1101                	addi	sp,sp,-32
    80002cfa:	ec06                	sd	ra,24(sp)
    80002cfc:	e822                	sd	s0,16(sp)
    80002cfe:	e426                	sd	s1,8(sp)
    80002d00:	e04a                	sd	s2,0(sp)
    80002d02:	1000                	addi	s0,sp,32
    80002d04:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d06:	00014517          	auipc	a0,0x14
    80002d0a:	14250513          	addi	a0,a0,322 # 80016e48 <itable>
    80002d0e:	00003097          	auipc	ra,0x3
    80002d12:	47e080e7          	jalr	1150(ra) # 8000618c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d16:	4498                	lw	a4,8(s1)
    80002d18:	4785                	li	a5,1
    80002d1a:	02f70363          	beq	a4,a5,80002d40 <iput+0x48>
  ip->ref--;
    80002d1e:	449c                	lw	a5,8(s1)
    80002d20:	37fd                	addiw	a5,a5,-1
    80002d22:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d24:	00014517          	auipc	a0,0x14
    80002d28:	12450513          	addi	a0,a0,292 # 80016e48 <itable>
    80002d2c:	00003097          	auipc	ra,0x3
    80002d30:	514080e7          	jalr	1300(ra) # 80006240 <release>
}
    80002d34:	60e2                	ld	ra,24(sp)
    80002d36:	6442                	ld	s0,16(sp)
    80002d38:	64a2                	ld	s1,8(sp)
    80002d3a:	6902                	ld	s2,0(sp)
    80002d3c:	6105                	addi	sp,sp,32
    80002d3e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d40:	40bc                	lw	a5,64(s1)
    80002d42:	dff1                	beqz	a5,80002d1e <iput+0x26>
    80002d44:	04a49783          	lh	a5,74(s1)
    80002d48:	fbf9                	bnez	a5,80002d1e <iput+0x26>
    acquiresleep(&ip->lock);
    80002d4a:	01048913          	addi	s2,s1,16
    80002d4e:	854a                	mv	a0,s2
    80002d50:	00001097          	auipc	ra,0x1
    80002d54:	aa8080e7          	jalr	-1368(ra) # 800037f8 <acquiresleep>
    release(&itable.lock);
    80002d58:	00014517          	auipc	a0,0x14
    80002d5c:	0f050513          	addi	a0,a0,240 # 80016e48 <itable>
    80002d60:	00003097          	auipc	ra,0x3
    80002d64:	4e0080e7          	jalr	1248(ra) # 80006240 <release>
    itrunc(ip);
    80002d68:	8526                	mv	a0,s1
    80002d6a:	00000097          	auipc	ra,0x0
    80002d6e:	ee2080e7          	jalr	-286(ra) # 80002c4c <itrunc>
    ip->type = 0;
    80002d72:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d76:	8526                	mv	a0,s1
    80002d78:	00000097          	auipc	ra,0x0
    80002d7c:	cfc080e7          	jalr	-772(ra) # 80002a74 <iupdate>
    ip->valid = 0;
    80002d80:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d84:	854a                	mv	a0,s2
    80002d86:	00001097          	auipc	ra,0x1
    80002d8a:	ac8080e7          	jalr	-1336(ra) # 8000384e <releasesleep>
    acquire(&itable.lock);
    80002d8e:	00014517          	auipc	a0,0x14
    80002d92:	0ba50513          	addi	a0,a0,186 # 80016e48 <itable>
    80002d96:	00003097          	auipc	ra,0x3
    80002d9a:	3f6080e7          	jalr	1014(ra) # 8000618c <acquire>
    80002d9e:	b741                	j	80002d1e <iput+0x26>

0000000080002da0 <iunlockput>:
{
    80002da0:	1101                	addi	sp,sp,-32
    80002da2:	ec06                	sd	ra,24(sp)
    80002da4:	e822                	sd	s0,16(sp)
    80002da6:	e426                	sd	s1,8(sp)
    80002da8:	1000                	addi	s0,sp,32
    80002daa:	84aa                	mv	s1,a0
  iunlock(ip);
    80002dac:	00000097          	auipc	ra,0x0
    80002db0:	e54080e7          	jalr	-428(ra) # 80002c00 <iunlock>
  iput(ip);
    80002db4:	8526                	mv	a0,s1
    80002db6:	00000097          	auipc	ra,0x0
    80002dba:	f42080e7          	jalr	-190(ra) # 80002cf8 <iput>
}
    80002dbe:	60e2                	ld	ra,24(sp)
    80002dc0:	6442                	ld	s0,16(sp)
    80002dc2:	64a2                	ld	s1,8(sp)
    80002dc4:	6105                	addi	sp,sp,32
    80002dc6:	8082                	ret

0000000080002dc8 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002dc8:	1141                	addi	sp,sp,-16
    80002dca:	e422                	sd	s0,8(sp)
    80002dcc:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002dce:	411c                	lw	a5,0(a0)
    80002dd0:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002dd2:	415c                	lw	a5,4(a0)
    80002dd4:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002dd6:	04451783          	lh	a5,68(a0)
    80002dda:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002dde:	04a51783          	lh	a5,74(a0)
    80002de2:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002de6:	04c56783          	lwu	a5,76(a0)
    80002dea:	e99c                	sd	a5,16(a1)
}
    80002dec:	6422                	ld	s0,8(sp)
    80002dee:	0141                	addi	sp,sp,16
    80002df0:	8082                	ret

0000000080002df2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002df2:	457c                	lw	a5,76(a0)
    80002df4:	0ed7e963          	bltu	a5,a3,80002ee6 <readi+0xf4>
{
    80002df8:	7159                	addi	sp,sp,-112
    80002dfa:	f486                	sd	ra,104(sp)
    80002dfc:	f0a2                	sd	s0,96(sp)
    80002dfe:	eca6                	sd	s1,88(sp)
    80002e00:	e8ca                	sd	s2,80(sp)
    80002e02:	e4ce                	sd	s3,72(sp)
    80002e04:	e0d2                	sd	s4,64(sp)
    80002e06:	fc56                	sd	s5,56(sp)
    80002e08:	f85a                	sd	s6,48(sp)
    80002e0a:	f45e                	sd	s7,40(sp)
    80002e0c:	f062                	sd	s8,32(sp)
    80002e0e:	ec66                	sd	s9,24(sp)
    80002e10:	e86a                	sd	s10,16(sp)
    80002e12:	e46e                	sd	s11,8(sp)
    80002e14:	1880                	addi	s0,sp,112
    80002e16:	8b2a                	mv	s6,a0
    80002e18:	8bae                	mv	s7,a1
    80002e1a:	8a32                	mv	s4,a2
    80002e1c:	84b6                	mv	s1,a3
    80002e1e:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002e20:	9f35                	addw	a4,a4,a3
    return 0;
    80002e22:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e24:	0ad76063          	bltu	a4,a3,80002ec4 <readi+0xd2>
  if(off + n > ip->size)
    80002e28:	00e7f463          	bgeu	a5,a4,80002e30 <readi+0x3e>
    n = ip->size - off;
    80002e2c:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e30:	0a0a8963          	beqz	s5,80002ee2 <readi+0xf0>
    80002e34:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e36:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e3a:	5c7d                	li	s8,-1
    80002e3c:	a82d                	j	80002e76 <readi+0x84>
    80002e3e:	020d1d93          	slli	s11,s10,0x20
    80002e42:	020ddd93          	srli	s11,s11,0x20
    80002e46:	05890613          	addi	a2,s2,88
    80002e4a:	86ee                	mv	a3,s11
    80002e4c:	963a                	add	a2,a2,a4
    80002e4e:	85d2                	mv	a1,s4
    80002e50:	855e                	mv	a0,s7
    80002e52:	fffff097          	auipc	ra,0xfffff
    80002e56:	b0e080e7          	jalr	-1266(ra) # 80001960 <either_copyout>
    80002e5a:	05850d63          	beq	a0,s8,80002eb4 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e5e:	854a                	mv	a0,s2
    80002e60:	fffff097          	auipc	ra,0xfffff
    80002e64:	5f4080e7          	jalr	1524(ra) # 80002454 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e68:	013d09bb          	addw	s3,s10,s3
    80002e6c:	009d04bb          	addw	s1,s10,s1
    80002e70:	9a6e                	add	s4,s4,s11
    80002e72:	0559f763          	bgeu	s3,s5,80002ec0 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002e76:	00a4d59b          	srliw	a1,s1,0xa
    80002e7a:	855a                	mv	a0,s6
    80002e7c:	00000097          	auipc	ra,0x0
    80002e80:	8a2080e7          	jalr	-1886(ra) # 8000271e <bmap>
    80002e84:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002e88:	cd85                	beqz	a1,80002ec0 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002e8a:	000b2503          	lw	a0,0(s6)
    80002e8e:	fffff097          	auipc	ra,0xfffff
    80002e92:	496080e7          	jalr	1174(ra) # 80002324 <bread>
    80002e96:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e98:	3ff4f713          	andi	a4,s1,1023
    80002e9c:	40ec87bb          	subw	a5,s9,a4
    80002ea0:	413a86bb          	subw	a3,s5,s3
    80002ea4:	8d3e                	mv	s10,a5
    80002ea6:	2781                	sext.w	a5,a5
    80002ea8:	0006861b          	sext.w	a2,a3
    80002eac:	f8f679e3          	bgeu	a2,a5,80002e3e <readi+0x4c>
    80002eb0:	8d36                	mv	s10,a3
    80002eb2:	b771                	j	80002e3e <readi+0x4c>
      brelse(bp);
    80002eb4:	854a                	mv	a0,s2
    80002eb6:	fffff097          	auipc	ra,0xfffff
    80002eba:	59e080e7          	jalr	1438(ra) # 80002454 <brelse>
      tot = -1;
    80002ebe:	59fd                	li	s3,-1
  }
  return tot;
    80002ec0:	0009851b          	sext.w	a0,s3
}
    80002ec4:	70a6                	ld	ra,104(sp)
    80002ec6:	7406                	ld	s0,96(sp)
    80002ec8:	64e6                	ld	s1,88(sp)
    80002eca:	6946                	ld	s2,80(sp)
    80002ecc:	69a6                	ld	s3,72(sp)
    80002ece:	6a06                	ld	s4,64(sp)
    80002ed0:	7ae2                	ld	s5,56(sp)
    80002ed2:	7b42                	ld	s6,48(sp)
    80002ed4:	7ba2                	ld	s7,40(sp)
    80002ed6:	7c02                	ld	s8,32(sp)
    80002ed8:	6ce2                	ld	s9,24(sp)
    80002eda:	6d42                	ld	s10,16(sp)
    80002edc:	6da2                	ld	s11,8(sp)
    80002ede:	6165                	addi	sp,sp,112
    80002ee0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ee2:	89d6                	mv	s3,s5
    80002ee4:	bff1                	j	80002ec0 <readi+0xce>
    return 0;
    80002ee6:	4501                	li	a0,0
}
    80002ee8:	8082                	ret

0000000080002eea <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002eea:	457c                	lw	a5,76(a0)
    80002eec:	10d7e863          	bltu	a5,a3,80002ffc <writei+0x112>
{
    80002ef0:	7159                	addi	sp,sp,-112
    80002ef2:	f486                	sd	ra,104(sp)
    80002ef4:	f0a2                	sd	s0,96(sp)
    80002ef6:	eca6                	sd	s1,88(sp)
    80002ef8:	e8ca                	sd	s2,80(sp)
    80002efa:	e4ce                	sd	s3,72(sp)
    80002efc:	e0d2                	sd	s4,64(sp)
    80002efe:	fc56                	sd	s5,56(sp)
    80002f00:	f85a                	sd	s6,48(sp)
    80002f02:	f45e                	sd	s7,40(sp)
    80002f04:	f062                	sd	s8,32(sp)
    80002f06:	ec66                	sd	s9,24(sp)
    80002f08:	e86a                	sd	s10,16(sp)
    80002f0a:	e46e                	sd	s11,8(sp)
    80002f0c:	1880                	addi	s0,sp,112
    80002f0e:	8aaa                	mv	s5,a0
    80002f10:	8bae                	mv	s7,a1
    80002f12:	8a32                	mv	s4,a2
    80002f14:	8936                	mv	s2,a3
    80002f16:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f18:	00e687bb          	addw	a5,a3,a4
    80002f1c:	0ed7e263          	bltu	a5,a3,80003000 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f20:	00043737          	lui	a4,0x43
    80002f24:	0ef76063          	bltu	a4,a5,80003004 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f28:	0c0b0863          	beqz	s6,80002ff8 <writei+0x10e>
    80002f2c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f2e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f32:	5c7d                	li	s8,-1
    80002f34:	a091                	j	80002f78 <writei+0x8e>
    80002f36:	020d1d93          	slli	s11,s10,0x20
    80002f3a:	020ddd93          	srli	s11,s11,0x20
    80002f3e:	05848513          	addi	a0,s1,88
    80002f42:	86ee                	mv	a3,s11
    80002f44:	8652                	mv	a2,s4
    80002f46:	85de                	mv	a1,s7
    80002f48:	953a                	add	a0,a0,a4
    80002f4a:	fffff097          	auipc	ra,0xfffff
    80002f4e:	a6c080e7          	jalr	-1428(ra) # 800019b6 <either_copyin>
    80002f52:	07850263          	beq	a0,s8,80002fb6 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f56:	8526                	mv	a0,s1
    80002f58:	00000097          	auipc	ra,0x0
    80002f5c:	780080e7          	jalr	1920(ra) # 800036d8 <log_write>
    brelse(bp);
    80002f60:	8526                	mv	a0,s1
    80002f62:	fffff097          	auipc	ra,0xfffff
    80002f66:	4f2080e7          	jalr	1266(ra) # 80002454 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f6a:	013d09bb          	addw	s3,s10,s3
    80002f6e:	012d093b          	addw	s2,s10,s2
    80002f72:	9a6e                	add	s4,s4,s11
    80002f74:	0569f663          	bgeu	s3,s6,80002fc0 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002f78:	00a9559b          	srliw	a1,s2,0xa
    80002f7c:	8556                	mv	a0,s5
    80002f7e:	fffff097          	auipc	ra,0xfffff
    80002f82:	7a0080e7          	jalr	1952(ra) # 8000271e <bmap>
    80002f86:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f8a:	c99d                	beqz	a1,80002fc0 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002f8c:	000aa503          	lw	a0,0(s5)
    80002f90:	fffff097          	auipc	ra,0xfffff
    80002f94:	394080e7          	jalr	916(ra) # 80002324 <bread>
    80002f98:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f9a:	3ff97713          	andi	a4,s2,1023
    80002f9e:	40ec87bb          	subw	a5,s9,a4
    80002fa2:	413b06bb          	subw	a3,s6,s3
    80002fa6:	8d3e                	mv	s10,a5
    80002fa8:	2781                	sext.w	a5,a5
    80002faa:	0006861b          	sext.w	a2,a3
    80002fae:	f8f674e3          	bgeu	a2,a5,80002f36 <writei+0x4c>
    80002fb2:	8d36                	mv	s10,a3
    80002fb4:	b749                	j	80002f36 <writei+0x4c>
      brelse(bp);
    80002fb6:	8526                	mv	a0,s1
    80002fb8:	fffff097          	auipc	ra,0xfffff
    80002fbc:	49c080e7          	jalr	1180(ra) # 80002454 <brelse>
  }

  if(off > ip->size)
    80002fc0:	04caa783          	lw	a5,76(s5)
    80002fc4:	0127f463          	bgeu	a5,s2,80002fcc <writei+0xe2>
    ip->size = off;
    80002fc8:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002fcc:	8556                	mv	a0,s5
    80002fce:	00000097          	auipc	ra,0x0
    80002fd2:	aa6080e7          	jalr	-1370(ra) # 80002a74 <iupdate>

  return tot;
    80002fd6:	0009851b          	sext.w	a0,s3
}
    80002fda:	70a6                	ld	ra,104(sp)
    80002fdc:	7406                	ld	s0,96(sp)
    80002fde:	64e6                	ld	s1,88(sp)
    80002fe0:	6946                	ld	s2,80(sp)
    80002fe2:	69a6                	ld	s3,72(sp)
    80002fe4:	6a06                	ld	s4,64(sp)
    80002fe6:	7ae2                	ld	s5,56(sp)
    80002fe8:	7b42                	ld	s6,48(sp)
    80002fea:	7ba2                	ld	s7,40(sp)
    80002fec:	7c02                	ld	s8,32(sp)
    80002fee:	6ce2                	ld	s9,24(sp)
    80002ff0:	6d42                	ld	s10,16(sp)
    80002ff2:	6da2                	ld	s11,8(sp)
    80002ff4:	6165                	addi	sp,sp,112
    80002ff6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ff8:	89da                	mv	s3,s6
    80002ffa:	bfc9                	j	80002fcc <writei+0xe2>
    return -1;
    80002ffc:	557d                	li	a0,-1
}
    80002ffe:	8082                	ret
    return -1;
    80003000:	557d                	li	a0,-1
    80003002:	bfe1                	j	80002fda <writei+0xf0>
    return -1;
    80003004:	557d                	li	a0,-1
    80003006:	bfd1                	j	80002fda <writei+0xf0>

0000000080003008 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003008:	1141                	addi	sp,sp,-16
    8000300a:	e406                	sd	ra,8(sp)
    8000300c:	e022                	sd	s0,0(sp)
    8000300e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003010:	4639                	li	a2,14
    80003012:	ffffd097          	auipc	ra,0xffffd
    80003016:	23e080e7          	jalr	574(ra) # 80000250 <strncmp>
}
    8000301a:	60a2                	ld	ra,8(sp)
    8000301c:	6402                	ld	s0,0(sp)
    8000301e:	0141                	addi	sp,sp,16
    80003020:	8082                	ret

0000000080003022 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003022:	7139                	addi	sp,sp,-64
    80003024:	fc06                	sd	ra,56(sp)
    80003026:	f822                	sd	s0,48(sp)
    80003028:	f426                	sd	s1,40(sp)
    8000302a:	f04a                	sd	s2,32(sp)
    8000302c:	ec4e                	sd	s3,24(sp)
    8000302e:	e852                	sd	s4,16(sp)
    80003030:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003032:	04451703          	lh	a4,68(a0)
    80003036:	4785                	li	a5,1
    80003038:	00f71a63          	bne	a4,a5,8000304c <dirlookup+0x2a>
    8000303c:	892a                	mv	s2,a0
    8000303e:	89ae                	mv	s3,a1
    80003040:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003042:	457c                	lw	a5,76(a0)
    80003044:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003046:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003048:	e79d                	bnez	a5,80003076 <dirlookup+0x54>
    8000304a:	a8a5                	j	800030c2 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000304c:	00005517          	auipc	a0,0x5
    80003050:	56450513          	addi	a0,a0,1380 # 800085b0 <syscalls+0x1a0>
    80003054:	00003097          	auipc	ra,0x3
    80003058:	bee080e7          	jalr	-1042(ra) # 80005c42 <panic>
      panic("dirlookup read");
    8000305c:	00005517          	auipc	a0,0x5
    80003060:	56c50513          	addi	a0,a0,1388 # 800085c8 <syscalls+0x1b8>
    80003064:	00003097          	auipc	ra,0x3
    80003068:	bde080e7          	jalr	-1058(ra) # 80005c42 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000306c:	24c1                	addiw	s1,s1,16
    8000306e:	04c92783          	lw	a5,76(s2)
    80003072:	04f4f763          	bgeu	s1,a5,800030c0 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003076:	4741                	li	a4,16
    80003078:	86a6                	mv	a3,s1
    8000307a:	fc040613          	addi	a2,s0,-64
    8000307e:	4581                	li	a1,0
    80003080:	854a                	mv	a0,s2
    80003082:	00000097          	auipc	ra,0x0
    80003086:	d70080e7          	jalr	-656(ra) # 80002df2 <readi>
    8000308a:	47c1                	li	a5,16
    8000308c:	fcf518e3          	bne	a0,a5,8000305c <dirlookup+0x3a>
    if(de.inum == 0)
    80003090:	fc045783          	lhu	a5,-64(s0)
    80003094:	dfe1                	beqz	a5,8000306c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003096:	fc240593          	addi	a1,s0,-62
    8000309a:	854e                	mv	a0,s3
    8000309c:	00000097          	auipc	ra,0x0
    800030a0:	f6c080e7          	jalr	-148(ra) # 80003008 <namecmp>
    800030a4:	f561                	bnez	a0,8000306c <dirlookup+0x4a>
      if(poff)
    800030a6:	000a0463          	beqz	s4,800030ae <dirlookup+0x8c>
        *poff = off;
    800030aa:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800030ae:	fc045583          	lhu	a1,-64(s0)
    800030b2:	00092503          	lw	a0,0(s2)
    800030b6:	fffff097          	auipc	ra,0xfffff
    800030ba:	750080e7          	jalr	1872(ra) # 80002806 <iget>
    800030be:	a011                	j	800030c2 <dirlookup+0xa0>
  return 0;
    800030c0:	4501                	li	a0,0
}
    800030c2:	70e2                	ld	ra,56(sp)
    800030c4:	7442                	ld	s0,48(sp)
    800030c6:	74a2                	ld	s1,40(sp)
    800030c8:	7902                	ld	s2,32(sp)
    800030ca:	69e2                	ld	s3,24(sp)
    800030cc:	6a42                	ld	s4,16(sp)
    800030ce:	6121                	addi	sp,sp,64
    800030d0:	8082                	ret

00000000800030d2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800030d2:	711d                	addi	sp,sp,-96
    800030d4:	ec86                	sd	ra,88(sp)
    800030d6:	e8a2                	sd	s0,80(sp)
    800030d8:	e4a6                	sd	s1,72(sp)
    800030da:	e0ca                	sd	s2,64(sp)
    800030dc:	fc4e                	sd	s3,56(sp)
    800030de:	f852                	sd	s4,48(sp)
    800030e0:	f456                	sd	s5,40(sp)
    800030e2:	f05a                	sd	s6,32(sp)
    800030e4:	ec5e                	sd	s7,24(sp)
    800030e6:	e862                	sd	s8,16(sp)
    800030e8:	e466                	sd	s9,8(sp)
    800030ea:	1080                	addi	s0,sp,96
    800030ec:	84aa                	mv	s1,a0
    800030ee:	8b2e                	mv	s6,a1
    800030f0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800030f2:	00054703          	lbu	a4,0(a0)
    800030f6:	02f00793          	li	a5,47
    800030fa:	02f70363          	beq	a4,a5,80003120 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800030fe:	ffffe097          	auipc	ra,0xffffe
    80003102:	db2080e7          	jalr	-590(ra) # 80000eb0 <myproc>
    80003106:	15053503          	ld	a0,336(a0)
    8000310a:	00000097          	auipc	ra,0x0
    8000310e:	9f6080e7          	jalr	-1546(ra) # 80002b00 <idup>
    80003112:	89aa                	mv	s3,a0
  while(*path == '/')
    80003114:	02f00913          	li	s2,47
  len = path - s;
    80003118:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    8000311a:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000311c:	4c05                	li	s8,1
    8000311e:	a865                	j	800031d6 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003120:	4585                	li	a1,1
    80003122:	4505                	li	a0,1
    80003124:	fffff097          	auipc	ra,0xfffff
    80003128:	6e2080e7          	jalr	1762(ra) # 80002806 <iget>
    8000312c:	89aa                	mv	s3,a0
    8000312e:	b7dd                	j	80003114 <namex+0x42>
      iunlockput(ip);
    80003130:	854e                	mv	a0,s3
    80003132:	00000097          	auipc	ra,0x0
    80003136:	c6e080e7          	jalr	-914(ra) # 80002da0 <iunlockput>
      return 0;
    8000313a:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000313c:	854e                	mv	a0,s3
    8000313e:	60e6                	ld	ra,88(sp)
    80003140:	6446                	ld	s0,80(sp)
    80003142:	64a6                	ld	s1,72(sp)
    80003144:	6906                	ld	s2,64(sp)
    80003146:	79e2                	ld	s3,56(sp)
    80003148:	7a42                	ld	s4,48(sp)
    8000314a:	7aa2                	ld	s5,40(sp)
    8000314c:	7b02                	ld	s6,32(sp)
    8000314e:	6be2                	ld	s7,24(sp)
    80003150:	6c42                	ld	s8,16(sp)
    80003152:	6ca2                	ld	s9,8(sp)
    80003154:	6125                	addi	sp,sp,96
    80003156:	8082                	ret
      iunlock(ip);
    80003158:	854e                	mv	a0,s3
    8000315a:	00000097          	auipc	ra,0x0
    8000315e:	aa6080e7          	jalr	-1370(ra) # 80002c00 <iunlock>
      return ip;
    80003162:	bfe9                	j	8000313c <namex+0x6a>
      iunlockput(ip);
    80003164:	854e                	mv	a0,s3
    80003166:	00000097          	auipc	ra,0x0
    8000316a:	c3a080e7          	jalr	-966(ra) # 80002da0 <iunlockput>
      return 0;
    8000316e:	89d2                	mv	s3,s4
    80003170:	b7f1                	j	8000313c <namex+0x6a>
  len = path - s;
    80003172:	40b48633          	sub	a2,s1,a1
    80003176:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000317a:	094cd463          	bge	s9,s4,80003202 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000317e:	4639                	li	a2,14
    80003180:	8556                	mv	a0,s5
    80003182:	ffffd097          	auipc	ra,0xffffd
    80003186:	056080e7          	jalr	86(ra) # 800001d8 <memmove>
  while(*path == '/')
    8000318a:	0004c783          	lbu	a5,0(s1)
    8000318e:	01279763          	bne	a5,s2,8000319c <namex+0xca>
    path++;
    80003192:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003194:	0004c783          	lbu	a5,0(s1)
    80003198:	ff278de3          	beq	a5,s2,80003192 <namex+0xc0>
    ilock(ip);
    8000319c:	854e                	mv	a0,s3
    8000319e:	00000097          	auipc	ra,0x0
    800031a2:	9a0080e7          	jalr	-1632(ra) # 80002b3e <ilock>
    if(ip->type != T_DIR){
    800031a6:	04499783          	lh	a5,68(s3)
    800031aa:	f98793e3          	bne	a5,s8,80003130 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800031ae:	000b0563          	beqz	s6,800031b8 <namex+0xe6>
    800031b2:	0004c783          	lbu	a5,0(s1)
    800031b6:	d3cd                	beqz	a5,80003158 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800031b8:	865e                	mv	a2,s7
    800031ba:	85d6                	mv	a1,s5
    800031bc:	854e                	mv	a0,s3
    800031be:	00000097          	auipc	ra,0x0
    800031c2:	e64080e7          	jalr	-412(ra) # 80003022 <dirlookup>
    800031c6:	8a2a                	mv	s4,a0
    800031c8:	dd51                	beqz	a0,80003164 <namex+0x92>
    iunlockput(ip);
    800031ca:	854e                	mv	a0,s3
    800031cc:	00000097          	auipc	ra,0x0
    800031d0:	bd4080e7          	jalr	-1068(ra) # 80002da0 <iunlockput>
    ip = next;
    800031d4:	89d2                	mv	s3,s4
  while(*path == '/')
    800031d6:	0004c783          	lbu	a5,0(s1)
    800031da:	05279763          	bne	a5,s2,80003228 <namex+0x156>
    path++;
    800031de:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031e0:	0004c783          	lbu	a5,0(s1)
    800031e4:	ff278de3          	beq	a5,s2,800031de <namex+0x10c>
  if(*path == 0)
    800031e8:	c79d                	beqz	a5,80003216 <namex+0x144>
    path++;
    800031ea:	85a6                	mv	a1,s1
  len = path - s;
    800031ec:	8a5e                	mv	s4,s7
    800031ee:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800031f0:	01278963          	beq	a5,s2,80003202 <namex+0x130>
    800031f4:	dfbd                	beqz	a5,80003172 <namex+0xa0>
    path++;
    800031f6:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800031f8:	0004c783          	lbu	a5,0(s1)
    800031fc:	ff279ce3          	bne	a5,s2,800031f4 <namex+0x122>
    80003200:	bf8d                	j	80003172 <namex+0xa0>
    memmove(name, s, len);
    80003202:	2601                	sext.w	a2,a2
    80003204:	8556                	mv	a0,s5
    80003206:	ffffd097          	auipc	ra,0xffffd
    8000320a:	fd2080e7          	jalr	-46(ra) # 800001d8 <memmove>
    name[len] = 0;
    8000320e:	9a56                	add	s4,s4,s5
    80003210:	000a0023          	sb	zero,0(s4)
    80003214:	bf9d                	j	8000318a <namex+0xb8>
  if(nameiparent){
    80003216:	f20b03e3          	beqz	s6,8000313c <namex+0x6a>
    iput(ip);
    8000321a:	854e                	mv	a0,s3
    8000321c:	00000097          	auipc	ra,0x0
    80003220:	adc080e7          	jalr	-1316(ra) # 80002cf8 <iput>
    return 0;
    80003224:	4981                	li	s3,0
    80003226:	bf19                	j	8000313c <namex+0x6a>
  if(*path == 0)
    80003228:	d7fd                	beqz	a5,80003216 <namex+0x144>
  while(*path != '/' && *path != 0)
    8000322a:	0004c783          	lbu	a5,0(s1)
    8000322e:	85a6                	mv	a1,s1
    80003230:	b7d1                	j	800031f4 <namex+0x122>

0000000080003232 <dirlink>:
{
    80003232:	7139                	addi	sp,sp,-64
    80003234:	fc06                	sd	ra,56(sp)
    80003236:	f822                	sd	s0,48(sp)
    80003238:	f426                	sd	s1,40(sp)
    8000323a:	f04a                	sd	s2,32(sp)
    8000323c:	ec4e                	sd	s3,24(sp)
    8000323e:	e852                	sd	s4,16(sp)
    80003240:	0080                	addi	s0,sp,64
    80003242:	892a                	mv	s2,a0
    80003244:	8a2e                	mv	s4,a1
    80003246:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003248:	4601                	li	a2,0
    8000324a:	00000097          	auipc	ra,0x0
    8000324e:	dd8080e7          	jalr	-552(ra) # 80003022 <dirlookup>
    80003252:	e93d                	bnez	a0,800032c8 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003254:	04c92483          	lw	s1,76(s2)
    80003258:	c49d                	beqz	s1,80003286 <dirlink+0x54>
    8000325a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000325c:	4741                	li	a4,16
    8000325e:	86a6                	mv	a3,s1
    80003260:	fc040613          	addi	a2,s0,-64
    80003264:	4581                	li	a1,0
    80003266:	854a                	mv	a0,s2
    80003268:	00000097          	auipc	ra,0x0
    8000326c:	b8a080e7          	jalr	-1142(ra) # 80002df2 <readi>
    80003270:	47c1                	li	a5,16
    80003272:	06f51163          	bne	a0,a5,800032d4 <dirlink+0xa2>
    if(de.inum == 0)
    80003276:	fc045783          	lhu	a5,-64(s0)
    8000327a:	c791                	beqz	a5,80003286 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000327c:	24c1                	addiw	s1,s1,16
    8000327e:	04c92783          	lw	a5,76(s2)
    80003282:	fcf4ede3          	bltu	s1,a5,8000325c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003286:	4639                	li	a2,14
    80003288:	85d2                	mv	a1,s4
    8000328a:	fc240513          	addi	a0,s0,-62
    8000328e:	ffffd097          	auipc	ra,0xffffd
    80003292:	ffe080e7          	jalr	-2(ra) # 8000028c <strncpy>
  de.inum = inum;
    80003296:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000329a:	4741                	li	a4,16
    8000329c:	86a6                	mv	a3,s1
    8000329e:	fc040613          	addi	a2,s0,-64
    800032a2:	4581                	li	a1,0
    800032a4:	854a                	mv	a0,s2
    800032a6:	00000097          	auipc	ra,0x0
    800032aa:	c44080e7          	jalr	-956(ra) # 80002eea <writei>
    800032ae:	1541                	addi	a0,a0,-16
    800032b0:	00a03533          	snez	a0,a0
    800032b4:	40a00533          	neg	a0,a0
}
    800032b8:	70e2                	ld	ra,56(sp)
    800032ba:	7442                	ld	s0,48(sp)
    800032bc:	74a2                	ld	s1,40(sp)
    800032be:	7902                	ld	s2,32(sp)
    800032c0:	69e2                	ld	s3,24(sp)
    800032c2:	6a42                	ld	s4,16(sp)
    800032c4:	6121                	addi	sp,sp,64
    800032c6:	8082                	ret
    iput(ip);
    800032c8:	00000097          	auipc	ra,0x0
    800032cc:	a30080e7          	jalr	-1488(ra) # 80002cf8 <iput>
    return -1;
    800032d0:	557d                	li	a0,-1
    800032d2:	b7dd                	j	800032b8 <dirlink+0x86>
      panic("dirlink read");
    800032d4:	00005517          	auipc	a0,0x5
    800032d8:	30450513          	addi	a0,a0,772 # 800085d8 <syscalls+0x1c8>
    800032dc:	00003097          	auipc	ra,0x3
    800032e0:	966080e7          	jalr	-1690(ra) # 80005c42 <panic>

00000000800032e4 <namei>:

struct inode*
namei(char *path)
{
    800032e4:	1101                	addi	sp,sp,-32
    800032e6:	ec06                	sd	ra,24(sp)
    800032e8:	e822                	sd	s0,16(sp)
    800032ea:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800032ec:	fe040613          	addi	a2,s0,-32
    800032f0:	4581                	li	a1,0
    800032f2:	00000097          	auipc	ra,0x0
    800032f6:	de0080e7          	jalr	-544(ra) # 800030d2 <namex>
}
    800032fa:	60e2                	ld	ra,24(sp)
    800032fc:	6442                	ld	s0,16(sp)
    800032fe:	6105                	addi	sp,sp,32
    80003300:	8082                	ret

0000000080003302 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003302:	1141                	addi	sp,sp,-16
    80003304:	e406                	sd	ra,8(sp)
    80003306:	e022                	sd	s0,0(sp)
    80003308:	0800                	addi	s0,sp,16
    8000330a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000330c:	4585                	li	a1,1
    8000330e:	00000097          	auipc	ra,0x0
    80003312:	dc4080e7          	jalr	-572(ra) # 800030d2 <namex>
}
    80003316:	60a2                	ld	ra,8(sp)
    80003318:	6402                	ld	s0,0(sp)
    8000331a:	0141                	addi	sp,sp,16
    8000331c:	8082                	ret

000000008000331e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000331e:	1101                	addi	sp,sp,-32
    80003320:	ec06                	sd	ra,24(sp)
    80003322:	e822                	sd	s0,16(sp)
    80003324:	e426                	sd	s1,8(sp)
    80003326:	e04a                	sd	s2,0(sp)
    80003328:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000332a:	00015917          	auipc	s2,0x15
    8000332e:	5c690913          	addi	s2,s2,1478 # 800188f0 <log>
    80003332:	01892583          	lw	a1,24(s2)
    80003336:	02892503          	lw	a0,40(s2)
    8000333a:	fffff097          	auipc	ra,0xfffff
    8000333e:	fea080e7          	jalr	-22(ra) # 80002324 <bread>
    80003342:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003344:	02c92683          	lw	a3,44(s2)
    80003348:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000334a:	02d05763          	blez	a3,80003378 <write_head+0x5a>
    8000334e:	00015797          	auipc	a5,0x15
    80003352:	5d278793          	addi	a5,a5,1490 # 80018920 <log+0x30>
    80003356:	05c50713          	addi	a4,a0,92
    8000335a:	36fd                	addiw	a3,a3,-1
    8000335c:	1682                	slli	a3,a3,0x20
    8000335e:	9281                	srli	a3,a3,0x20
    80003360:	068a                	slli	a3,a3,0x2
    80003362:	00015617          	auipc	a2,0x15
    80003366:	5c260613          	addi	a2,a2,1474 # 80018924 <log+0x34>
    8000336a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000336c:	4390                	lw	a2,0(a5)
    8000336e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003370:	0791                	addi	a5,a5,4
    80003372:	0711                	addi	a4,a4,4
    80003374:	fed79ce3          	bne	a5,a3,8000336c <write_head+0x4e>
  }
  bwrite(buf);
    80003378:	8526                	mv	a0,s1
    8000337a:	fffff097          	auipc	ra,0xfffff
    8000337e:	09c080e7          	jalr	156(ra) # 80002416 <bwrite>
  brelse(buf);
    80003382:	8526                	mv	a0,s1
    80003384:	fffff097          	auipc	ra,0xfffff
    80003388:	0d0080e7          	jalr	208(ra) # 80002454 <brelse>
}
    8000338c:	60e2                	ld	ra,24(sp)
    8000338e:	6442                	ld	s0,16(sp)
    80003390:	64a2                	ld	s1,8(sp)
    80003392:	6902                	ld	s2,0(sp)
    80003394:	6105                	addi	sp,sp,32
    80003396:	8082                	ret

0000000080003398 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003398:	00015797          	auipc	a5,0x15
    8000339c:	5847a783          	lw	a5,1412(a5) # 8001891c <log+0x2c>
    800033a0:	0af05d63          	blez	a5,8000345a <install_trans+0xc2>
{
    800033a4:	7139                	addi	sp,sp,-64
    800033a6:	fc06                	sd	ra,56(sp)
    800033a8:	f822                	sd	s0,48(sp)
    800033aa:	f426                	sd	s1,40(sp)
    800033ac:	f04a                	sd	s2,32(sp)
    800033ae:	ec4e                	sd	s3,24(sp)
    800033b0:	e852                	sd	s4,16(sp)
    800033b2:	e456                	sd	s5,8(sp)
    800033b4:	e05a                	sd	s6,0(sp)
    800033b6:	0080                	addi	s0,sp,64
    800033b8:	8b2a                	mv	s6,a0
    800033ba:	00015a97          	auipc	s5,0x15
    800033be:	566a8a93          	addi	s5,s5,1382 # 80018920 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033c2:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033c4:	00015997          	auipc	s3,0x15
    800033c8:	52c98993          	addi	s3,s3,1324 # 800188f0 <log>
    800033cc:	a035                	j	800033f8 <install_trans+0x60>
      bunpin(dbuf);
    800033ce:	8526                	mv	a0,s1
    800033d0:	fffff097          	auipc	ra,0xfffff
    800033d4:	15e080e7          	jalr	350(ra) # 8000252e <bunpin>
    brelse(lbuf);
    800033d8:	854a                	mv	a0,s2
    800033da:	fffff097          	auipc	ra,0xfffff
    800033de:	07a080e7          	jalr	122(ra) # 80002454 <brelse>
    brelse(dbuf);
    800033e2:	8526                	mv	a0,s1
    800033e4:	fffff097          	auipc	ra,0xfffff
    800033e8:	070080e7          	jalr	112(ra) # 80002454 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033ec:	2a05                	addiw	s4,s4,1
    800033ee:	0a91                	addi	s5,s5,4
    800033f0:	02c9a783          	lw	a5,44(s3)
    800033f4:	04fa5963          	bge	s4,a5,80003446 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033f8:	0189a583          	lw	a1,24(s3)
    800033fc:	014585bb          	addw	a1,a1,s4
    80003400:	2585                	addiw	a1,a1,1
    80003402:	0289a503          	lw	a0,40(s3)
    80003406:	fffff097          	auipc	ra,0xfffff
    8000340a:	f1e080e7          	jalr	-226(ra) # 80002324 <bread>
    8000340e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003410:	000aa583          	lw	a1,0(s5)
    80003414:	0289a503          	lw	a0,40(s3)
    80003418:	fffff097          	auipc	ra,0xfffff
    8000341c:	f0c080e7          	jalr	-244(ra) # 80002324 <bread>
    80003420:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003422:	40000613          	li	a2,1024
    80003426:	05890593          	addi	a1,s2,88
    8000342a:	05850513          	addi	a0,a0,88
    8000342e:	ffffd097          	auipc	ra,0xffffd
    80003432:	daa080e7          	jalr	-598(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003436:	8526                	mv	a0,s1
    80003438:	fffff097          	auipc	ra,0xfffff
    8000343c:	fde080e7          	jalr	-34(ra) # 80002416 <bwrite>
    if(recovering == 0)
    80003440:	f80b1ce3          	bnez	s6,800033d8 <install_trans+0x40>
    80003444:	b769                	j	800033ce <install_trans+0x36>
}
    80003446:	70e2                	ld	ra,56(sp)
    80003448:	7442                	ld	s0,48(sp)
    8000344a:	74a2                	ld	s1,40(sp)
    8000344c:	7902                	ld	s2,32(sp)
    8000344e:	69e2                	ld	s3,24(sp)
    80003450:	6a42                	ld	s4,16(sp)
    80003452:	6aa2                	ld	s5,8(sp)
    80003454:	6b02                	ld	s6,0(sp)
    80003456:	6121                	addi	sp,sp,64
    80003458:	8082                	ret
    8000345a:	8082                	ret

000000008000345c <initlog>:
{
    8000345c:	7179                	addi	sp,sp,-48
    8000345e:	f406                	sd	ra,40(sp)
    80003460:	f022                	sd	s0,32(sp)
    80003462:	ec26                	sd	s1,24(sp)
    80003464:	e84a                	sd	s2,16(sp)
    80003466:	e44e                	sd	s3,8(sp)
    80003468:	1800                	addi	s0,sp,48
    8000346a:	892a                	mv	s2,a0
    8000346c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000346e:	00015497          	auipc	s1,0x15
    80003472:	48248493          	addi	s1,s1,1154 # 800188f0 <log>
    80003476:	00005597          	auipc	a1,0x5
    8000347a:	17258593          	addi	a1,a1,370 # 800085e8 <syscalls+0x1d8>
    8000347e:	8526                	mv	a0,s1
    80003480:	00003097          	auipc	ra,0x3
    80003484:	c7c080e7          	jalr	-900(ra) # 800060fc <initlock>
  log.start = sb->logstart;
    80003488:	0149a583          	lw	a1,20(s3)
    8000348c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000348e:	0109a783          	lw	a5,16(s3)
    80003492:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003494:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003498:	854a                	mv	a0,s2
    8000349a:	fffff097          	auipc	ra,0xfffff
    8000349e:	e8a080e7          	jalr	-374(ra) # 80002324 <bread>
  log.lh.n = lh->n;
    800034a2:	4d3c                	lw	a5,88(a0)
    800034a4:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800034a6:	02f05563          	blez	a5,800034d0 <initlog+0x74>
    800034aa:	05c50713          	addi	a4,a0,92
    800034ae:	00015697          	auipc	a3,0x15
    800034b2:	47268693          	addi	a3,a3,1138 # 80018920 <log+0x30>
    800034b6:	37fd                	addiw	a5,a5,-1
    800034b8:	1782                	slli	a5,a5,0x20
    800034ba:	9381                	srli	a5,a5,0x20
    800034bc:	078a                	slli	a5,a5,0x2
    800034be:	06050613          	addi	a2,a0,96
    800034c2:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800034c4:	4310                	lw	a2,0(a4)
    800034c6:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800034c8:	0711                	addi	a4,a4,4
    800034ca:	0691                	addi	a3,a3,4
    800034cc:	fef71ce3          	bne	a4,a5,800034c4 <initlog+0x68>
  brelse(buf);
    800034d0:	fffff097          	auipc	ra,0xfffff
    800034d4:	f84080e7          	jalr	-124(ra) # 80002454 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800034d8:	4505                	li	a0,1
    800034da:	00000097          	auipc	ra,0x0
    800034de:	ebe080e7          	jalr	-322(ra) # 80003398 <install_trans>
  log.lh.n = 0;
    800034e2:	00015797          	auipc	a5,0x15
    800034e6:	4207ad23          	sw	zero,1082(a5) # 8001891c <log+0x2c>
  write_head(); // clear the log
    800034ea:	00000097          	auipc	ra,0x0
    800034ee:	e34080e7          	jalr	-460(ra) # 8000331e <write_head>
}
    800034f2:	70a2                	ld	ra,40(sp)
    800034f4:	7402                	ld	s0,32(sp)
    800034f6:	64e2                	ld	s1,24(sp)
    800034f8:	6942                	ld	s2,16(sp)
    800034fa:	69a2                	ld	s3,8(sp)
    800034fc:	6145                	addi	sp,sp,48
    800034fe:	8082                	ret

0000000080003500 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003500:	1101                	addi	sp,sp,-32
    80003502:	ec06                	sd	ra,24(sp)
    80003504:	e822                	sd	s0,16(sp)
    80003506:	e426                	sd	s1,8(sp)
    80003508:	e04a                	sd	s2,0(sp)
    8000350a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000350c:	00015517          	auipc	a0,0x15
    80003510:	3e450513          	addi	a0,a0,996 # 800188f0 <log>
    80003514:	00003097          	auipc	ra,0x3
    80003518:	c78080e7          	jalr	-904(ra) # 8000618c <acquire>
  while(1){
    if(log.committing){
    8000351c:	00015497          	auipc	s1,0x15
    80003520:	3d448493          	addi	s1,s1,980 # 800188f0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003524:	4979                	li	s2,30
    80003526:	a039                	j	80003534 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003528:	85a6                	mv	a1,s1
    8000352a:	8526                	mv	a0,s1
    8000352c:	ffffe097          	auipc	ra,0xffffe
    80003530:	02c080e7          	jalr	44(ra) # 80001558 <sleep>
    if(log.committing){
    80003534:	50dc                	lw	a5,36(s1)
    80003536:	fbed                	bnez	a5,80003528 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003538:	509c                	lw	a5,32(s1)
    8000353a:	0017871b          	addiw	a4,a5,1
    8000353e:	0007069b          	sext.w	a3,a4
    80003542:	0027179b          	slliw	a5,a4,0x2
    80003546:	9fb9                	addw	a5,a5,a4
    80003548:	0017979b          	slliw	a5,a5,0x1
    8000354c:	54d8                	lw	a4,44(s1)
    8000354e:	9fb9                	addw	a5,a5,a4
    80003550:	00f95963          	bge	s2,a5,80003562 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003554:	85a6                	mv	a1,s1
    80003556:	8526                	mv	a0,s1
    80003558:	ffffe097          	auipc	ra,0xffffe
    8000355c:	000080e7          	jalr	ra # 80001558 <sleep>
    80003560:	bfd1                	j	80003534 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003562:	00015517          	auipc	a0,0x15
    80003566:	38e50513          	addi	a0,a0,910 # 800188f0 <log>
    8000356a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000356c:	00003097          	auipc	ra,0x3
    80003570:	cd4080e7          	jalr	-812(ra) # 80006240 <release>
      break;
    }
  }
}
    80003574:	60e2                	ld	ra,24(sp)
    80003576:	6442                	ld	s0,16(sp)
    80003578:	64a2                	ld	s1,8(sp)
    8000357a:	6902                	ld	s2,0(sp)
    8000357c:	6105                	addi	sp,sp,32
    8000357e:	8082                	ret

0000000080003580 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003580:	7139                	addi	sp,sp,-64
    80003582:	fc06                	sd	ra,56(sp)
    80003584:	f822                	sd	s0,48(sp)
    80003586:	f426                	sd	s1,40(sp)
    80003588:	f04a                	sd	s2,32(sp)
    8000358a:	ec4e                	sd	s3,24(sp)
    8000358c:	e852                	sd	s4,16(sp)
    8000358e:	e456                	sd	s5,8(sp)
    80003590:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003592:	00015497          	auipc	s1,0x15
    80003596:	35e48493          	addi	s1,s1,862 # 800188f0 <log>
    8000359a:	8526                	mv	a0,s1
    8000359c:	00003097          	auipc	ra,0x3
    800035a0:	bf0080e7          	jalr	-1040(ra) # 8000618c <acquire>
  log.outstanding -= 1;
    800035a4:	509c                	lw	a5,32(s1)
    800035a6:	37fd                	addiw	a5,a5,-1
    800035a8:	0007891b          	sext.w	s2,a5
    800035ac:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800035ae:	50dc                	lw	a5,36(s1)
    800035b0:	efb9                	bnez	a5,8000360e <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800035b2:	06091663          	bnez	s2,8000361e <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800035b6:	00015497          	auipc	s1,0x15
    800035ba:	33a48493          	addi	s1,s1,826 # 800188f0 <log>
    800035be:	4785                	li	a5,1
    800035c0:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800035c2:	8526                	mv	a0,s1
    800035c4:	00003097          	auipc	ra,0x3
    800035c8:	c7c080e7          	jalr	-900(ra) # 80006240 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800035cc:	54dc                	lw	a5,44(s1)
    800035ce:	06f04763          	bgtz	a5,8000363c <end_op+0xbc>
    acquire(&log.lock);
    800035d2:	00015497          	auipc	s1,0x15
    800035d6:	31e48493          	addi	s1,s1,798 # 800188f0 <log>
    800035da:	8526                	mv	a0,s1
    800035dc:	00003097          	auipc	ra,0x3
    800035e0:	bb0080e7          	jalr	-1104(ra) # 8000618c <acquire>
    log.committing = 0;
    800035e4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800035e8:	8526                	mv	a0,s1
    800035ea:	ffffe097          	auipc	ra,0xffffe
    800035ee:	fd2080e7          	jalr	-46(ra) # 800015bc <wakeup>
    release(&log.lock);
    800035f2:	8526                	mv	a0,s1
    800035f4:	00003097          	auipc	ra,0x3
    800035f8:	c4c080e7          	jalr	-948(ra) # 80006240 <release>
}
    800035fc:	70e2                	ld	ra,56(sp)
    800035fe:	7442                	ld	s0,48(sp)
    80003600:	74a2                	ld	s1,40(sp)
    80003602:	7902                	ld	s2,32(sp)
    80003604:	69e2                	ld	s3,24(sp)
    80003606:	6a42                	ld	s4,16(sp)
    80003608:	6aa2                	ld	s5,8(sp)
    8000360a:	6121                	addi	sp,sp,64
    8000360c:	8082                	ret
    panic("log.committing");
    8000360e:	00005517          	auipc	a0,0x5
    80003612:	fe250513          	addi	a0,a0,-30 # 800085f0 <syscalls+0x1e0>
    80003616:	00002097          	auipc	ra,0x2
    8000361a:	62c080e7          	jalr	1580(ra) # 80005c42 <panic>
    wakeup(&log);
    8000361e:	00015497          	auipc	s1,0x15
    80003622:	2d248493          	addi	s1,s1,722 # 800188f0 <log>
    80003626:	8526                	mv	a0,s1
    80003628:	ffffe097          	auipc	ra,0xffffe
    8000362c:	f94080e7          	jalr	-108(ra) # 800015bc <wakeup>
  release(&log.lock);
    80003630:	8526                	mv	a0,s1
    80003632:	00003097          	auipc	ra,0x3
    80003636:	c0e080e7          	jalr	-1010(ra) # 80006240 <release>
  if(do_commit){
    8000363a:	b7c9                	j	800035fc <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000363c:	00015a97          	auipc	s5,0x15
    80003640:	2e4a8a93          	addi	s5,s5,740 # 80018920 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003644:	00015a17          	auipc	s4,0x15
    80003648:	2aca0a13          	addi	s4,s4,684 # 800188f0 <log>
    8000364c:	018a2583          	lw	a1,24(s4)
    80003650:	012585bb          	addw	a1,a1,s2
    80003654:	2585                	addiw	a1,a1,1
    80003656:	028a2503          	lw	a0,40(s4)
    8000365a:	fffff097          	auipc	ra,0xfffff
    8000365e:	cca080e7          	jalr	-822(ra) # 80002324 <bread>
    80003662:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003664:	000aa583          	lw	a1,0(s5)
    80003668:	028a2503          	lw	a0,40(s4)
    8000366c:	fffff097          	auipc	ra,0xfffff
    80003670:	cb8080e7          	jalr	-840(ra) # 80002324 <bread>
    80003674:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003676:	40000613          	li	a2,1024
    8000367a:	05850593          	addi	a1,a0,88
    8000367e:	05848513          	addi	a0,s1,88
    80003682:	ffffd097          	auipc	ra,0xffffd
    80003686:	b56080e7          	jalr	-1194(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    8000368a:	8526                	mv	a0,s1
    8000368c:	fffff097          	auipc	ra,0xfffff
    80003690:	d8a080e7          	jalr	-630(ra) # 80002416 <bwrite>
    brelse(from);
    80003694:	854e                	mv	a0,s3
    80003696:	fffff097          	auipc	ra,0xfffff
    8000369a:	dbe080e7          	jalr	-578(ra) # 80002454 <brelse>
    brelse(to);
    8000369e:	8526                	mv	a0,s1
    800036a0:	fffff097          	auipc	ra,0xfffff
    800036a4:	db4080e7          	jalr	-588(ra) # 80002454 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036a8:	2905                	addiw	s2,s2,1
    800036aa:	0a91                	addi	s5,s5,4
    800036ac:	02ca2783          	lw	a5,44(s4)
    800036b0:	f8f94ee3          	blt	s2,a5,8000364c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800036b4:	00000097          	auipc	ra,0x0
    800036b8:	c6a080e7          	jalr	-918(ra) # 8000331e <write_head>
    install_trans(0); // Now install writes to home locations
    800036bc:	4501                	li	a0,0
    800036be:	00000097          	auipc	ra,0x0
    800036c2:	cda080e7          	jalr	-806(ra) # 80003398 <install_trans>
    log.lh.n = 0;
    800036c6:	00015797          	auipc	a5,0x15
    800036ca:	2407ab23          	sw	zero,598(a5) # 8001891c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800036ce:	00000097          	auipc	ra,0x0
    800036d2:	c50080e7          	jalr	-944(ra) # 8000331e <write_head>
    800036d6:	bdf5                	j	800035d2 <end_op+0x52>

00000000800036d8 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800036d8:	1101                	addi	sp,sp,-32
    800036da:	ec06                	sd	ra,24(sp)
    800036dc:	e822                	sd	s0,16(sp)
    800036de:	e426                	sd	s1,8(sp)
    800036e0:	e04a                	sd	s2,0(sp)
    800036e2:	1000                	addi	s0,sp,32
    800036e4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800036e6:	00015917          	auipc	s2,0x15
    800036ea:	20a90913          	addi	s2,s2,522 # 800188f0 <log>
    800036ee:	854a                	mv	a0,s2
    800036f0:	00003097          	auipc	ra,0x3
    800036f4:	a9c080e7          	jalr	-1380(ra) # 8000618c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800036f8:	02c92603          	lw	a2,44(s2)
    800036fc:	47f5                	li	a5,29
    800036fe:	06c7c563          	blt	a5,a2,80003768 <log_write+0x90>
    80003702:	00015797          	auipc	a5,0x15
    80003706:	20a7a783          	lw	a5,522(a5) # 8001890c <log+0x1c>
    8000370a:	37fd                	addiw	a5,a5,-1
    8000370c:	04f65e63          	bge	a2,a5,80003768 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003710:	00015797          	auipc	a5,0x15
    80003714:	2007a783          	lw	a5,512(a5) # 80018910 <log+0x20>
    80003718:	06f05063          	blez	a5,80003778 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000371c:	4781                	li	a5,0
    8000371e:	06c05563          	blez	a2,80003788 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003722:	44cc                	lw	a1,12(s1)
    80003724:	00015717          	auipc	a4,0x15
    80003728:	1fc70713          	addi	a4,a4,508 # 80018920 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000372c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000372e:	4314                	lw	a3,0(a4)
    80003730:	04b68c63          	beq	a3,a1,80003788 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003734:	2785                	addiw	a5,a5,1
    80003736:	0711                	addi	a4,a4,4
    80003738:	fef61be3          	bne	a2,a5,8000372e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000373c:	0621                	addi	a2,a2,8
    8000373e:	060a                	slli	a2,a2,0x2
    80003740:	00015797          	auipc	a5,0x15
    80003744:	1b078793          	addi	a5,a5,432 # 800188f0 <log>
    80003748:	963e                	add	a2,a2,a5
    8000374a:	44dc                	lw	a5,12(s1)
    8000374c:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000374e:	8526                	mv	a0,s1
    80003750:	fffff097          	auipc	ra,0xfffff
    80003754:	da2080e7          	jalr	-606(ra) # 800024f2 <bpin>
    log.lh.n++;
    80003758:	00015717          	auipc	a4,0x15
    8000375c:	19870713          	addi	a4,a4,408 # 800188f0 <log>
    80003760:	575c                	lw	a5,44(a4)
    80003762:	2785                	addiw	a5,a5,1
    80003764:	d75c                	sw	a5,44(a4)
    80003766:	a835                	j	800037a2 <log_write+0xca>
    panic("too big a transaction");
    80003768:	00005517          	auipc	a0,0x5
    8000376c:	e9850513          	addi	a0,a0,-360 # 80008600 <syscalls+0x1f0>
    80003770:	00002097          	auipc	ra,0x2
    80003774:	4d2080e7          	jalr	1234(ra) # 80005c42 <panic>
    panic("log_write outside of trans");
    80003778:	00005517          	auipc	a0,0x5
    8000377c:	ea050513          	addi	a0,a0,-352 # 80008618 <syscalls+0x208>
    80003780:	00002097          	auipc	ra,0x2
    80003784:	4c2080e7          	jalr	1218(ra) # 80005c42 <panic>
  log.lh.block[i] = b->blockno;
    80003788:	00878713          	addi	a4,a5,8
    8000378c:	00271693          	slli	a3,a4,0x2
    80003790:	00015717          	auipc	a4,0x15
    80003794:	16070713          	addi	a4,a4,352 # 800188f0 <log>
    80003798:	9736                	add	a4,a4,a3
    8000379a:	44d4                	lw	a3,12(s1)
    8000379c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000379e:	faf608e3          	beq	a2,a5,8000374e <log_write+0x76>
  }
  release(&log.lock);
    800037a2:	00015517          	auipc	a0,0x15
    800037a6:	14e50513          	addi	a0,a0,334 # 800188f0 <log>
    800037aa:	00003097          	auipc	ra,0x3
    800037ae:	a96080e7          	jalr	-1386(ra) # 80006240 <release>
}
    800037b2:	60e2                	ld	ra,24(sp)
    800037b4:	6442                	ld	s0,16(sp)
    800037b6:	64a2                	ld	s1,8(sp)
    800037b8:	6902                	ld	s2,0(sp)
    800037ba:	6105                	addi	sp,sp,32
    800037bc:	8082                	ret

00000000800037be <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800037be:	1101                	addi	sp,sp,-32
    800037c0:	ec06                	sd	ra,24(sp)
    800037c2:	e822                	sd	s0,16(sp)
    800037c4:	e426                	sd	s1,8(sp)
    800037c6:	e04a                	sd	s2,0(sp)
    800037c8:	1000                	addi	s0,sp,32
    800037ca:	84aa                	mv	s1,a0
    800037cc:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800037ce:	00005597          	auipc	a1,0x5
    800037d2:	e6a58593          	addi	a1,a1,-406 # 80008638 <syscalls+0x228>
    800037d6:	0521                	addi	a0,a0,8
    800037d8:	00003097          	auipc	ra,0x3
    800037dc:	924080e7          	jalr	-1756(ra) # 800060fc <initlock>
  lk->name = name;
    800037e0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800037e4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037e8:	0204a423          	sw	zero,40(s1)
}
    800037ec:	60e2                	ld	ra,24(sp)
    800037ee:	6442                	ld	s0,16(sp)
    800037f0:	64a2                	ld	s1,8(sp)
    800037f2:	6902                	ld	s2,0(sp)
    800037f4:	6105                	addi	sp,sp,32
    800037f6:	8082                	ret

00000000800037f8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800037f8:	1101                	addi	sp,sp,-32
    800037fa:	ec06                	sd	ra,24(sp)
    800037fc:	e822                	sd	s0,16(sp)
    800037fe:	e426                	sd	s1,8(sp)
    80003800:	e04a                	sd	s2,0(sp)
    80003802:	1000                	addi	s0,sp,32
    80003804:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003806:	00850913          	addi	s2,a0,8
    8000380a:	854a                	mv	a0,s2
    8000380c:	00003097          	auipc	ra,0x3
    80003810:	980080e7          	jalr	-1664(ra) # 8000618c <acquire>
  while (lk->locked) {
    80003814:	409c                	lw	a5,0(s1)
    80003816:	cb89                	beqz	a5,80003828 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003818:	85ca                	mv	a1,s2
    8000381a:	8526                	mv	a0,s1
    8000381c:	ffffe097          	auipc	ra,0xffffe
    80003820:	d3c080e7          	jalr	-708(ra) # 80001558 <sleep>
  while (lk->locked) {
    80003824:	409c                	lw	a5,0(s1)
    80003826:	fbed                	bnez	a5,80003818 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003828:	4785                	li	a5,1
    8000382a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000382c:	ffffd097          	auipc	ra,0xffffd
    80003830:	684080e7          	jalr	1668(ra) # 80000eb0 <myproc>
    80003834:	591c                	lw	a5,48(a0)
    80003836:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003838:	854a                	mv	a0,s2
    8000383a:	00003097          	auipc	ra,0x3
    8000383e:	a06080e7          	jalr	-1530(ra) # 80006240 <release>
}
    80003842:	60e2                	ld	ra,24(sp)
    80003844:	6442                	ld	s0,16(sp)
    80003846:	64a2                	ld	s1,8(sp)
    80003848:	6902                	ld	s2,0(sp)
    8000384a:	6105                	addi	sp,sp,32
    8000384c:	8082                	ret

000000008000384e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000384e:	1101                	addi	sp,sp,-32
    80003850:	ec06                	sd	ra,24(sp)
    80003852:	e822                	sd	s0,16(sp)
    80003854:	e426                	sd	s1,8(sp)
    80003856:	e04a                	sd	s2,0(sp)
    80003858:	1000                	addi	s0,sp,32
    8000385a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000385c:	00850913          	addi	s2,a0,8
    80003860:	854a                	mv	a0,s2
    80003862:	00003097          	auipc	ra,0x3
    80003866:	92a080e7          	jalr	-1750(ra) # 8000618c <acquire>
  lk->locked = 0;
    8000386a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000386e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003872:	8526                	mv	a0,s1
    80003874:	ffffe097          	auipc	ra,0xffffe
    80003878:	d48080e7          	jalr	-696(ra) # 800015bc <wakeup>
  release(&lk->lk);
    8000387c:	854a                	mv	a0,s2
    8000387e:	00003097          	auipc	ra,0x3
    80003882:	9c2080e7          	jalr	-1598(ra) # 80006240 <release>
}
    80003886:	60e2                	ld	ra,24(sp)
    80003888:	6442                	ld	s0,16(sp)
    8000388a:	64a2                	ld	s1,8(sp)
    8000388c:	6902                	ld	s2,0(sp)
    8000388e:	6105                	addi	sp,sp,32
    80003890:	8082                	ret

0000000080003892 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003892:	7179                	addi	sp,sp,-48
    80003894:	f406                	sd	ra,40(sp)
    80003896:	f022                	sd	s0,32(sp)
    80003898:	ec26                	sd	s1,24(sp)
    8000389a:	e84a                	sd	s2,16(sp)
    8000389c:	e44e                	sd	s3,8(sp)
    8000389e:	1800                	addi	s0,sp,48
    800038a0:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800038a2:	00850913          	addi	s2,a0,8
    800038a6:	854a                	mv	a0,s2
    800038a8:	00003097          	auipc	ra,0x3
    800038ac:	8e4080e7          	jalr	-1820(ra) # 8000618c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800038b0:	409c                	lw	a5,0(s1)
    800038b2:	ef99                	bnez	a5,800038d0 <holdingsleep+0x3e>
    800038b4:	4481                	li	s1,0
  release(&lk->lk);
    800038b6:	854a                	mv	a0,s2
    800038b8:	00003097          	auipc	ra,0x3
    800038bc:	988080e7          	jalr	-1656(ra) # 80006240 <release>
  return r;
}
    800038c0:	8526                	mv	a0,s1
    800038c2:	70a2                	ld	ra,40(sp)
    800038c4:	7402                	ld	s0,32(sp)
    800038c6:	64e2                	ld	s1,24(sp)
    800038c8:	6942                	ld	s2,16(sp)
    800038ca:	69a2                	ld	s3,8(sp)
    800038cc:	6145                	addi	sp,sp,48
    800038ce:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800038d0:	0284a983          	lw	s3,40(s1)
    800038d4:	ffffd097          	auipc	ra,0xffffd
    800038d8:	5dc080e7          	jalr	1500(ra) # 80000eb0 <myproc>
    800038dc:	5904                	lw	s1,48(a0)
    800038de:	413484b3          	sub	s1,s1,s3
    800038e2:	0014b493          	seqz	s1,s1
    800038e6:	bfc1                	j	800038b6 <holdingsleep+0x24>

00000000800038e8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800038e8:	1141                	addi	sp,sp,-16
    800038ea:	e406                	sd	ra,8(sp)
    800038ec:	e022                	sd	s0,0(sp)
    800038ee:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800038f0:	00005597          	auipc	a1,0x5
    800038f4:	d5858593          	addi	a1,a1,-680 # 80008648 <syscalls+0x238>
    800038f8:	00015517          	auipc	a0,0x15
    800038fc:	14050513          	addi	a0,a0,320 # 80018a38 <ftable>
    80003900:	00002097          	auipc	ra,0x2
    80003904:	7fc080e7          	jalr	2044(ra) # 800060fc <initlock>
}
    80003908:	60a2                	ld	ra,8(sp)
    8000390a:	6402                	ld	s0,0(sp)
    8000390c:	0141                	addi	sp,sp,16
    8000390e:	8082                	ret

0000000080003910 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003910:	1101                	addi	sp,sp,-32
    80003912:	ec06                	sd	ra,24(sp)
    80003914:	e822                	sd	s0,16(sp)
    80003916:	e426                	sd	s1,8(sp)
    80003918:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000391a:	00015517          	auipc	a0,0x15
    8000391e:	11e50513          	addi	a0,a0,286 # 80018a38 <ftable>
    80003922:	00003097          	auipc	ra,0x3
    80003926:	86a080e7          	jalr	-1942(ra) # 8000618c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000392a:	00015497          	auipc	s1,0x15
    8000392e:	12648493          	addi	s1,s1,294 # 80018a50 <ftable+0x18>
    80003932:	00016717          	auipc	a4,0x16
    80003936:	0be70713          	addi	a4,a4,190 # 800199f0 <disk>
    if(f->ref == 0){
    8000393a:	40dc                	lw	a5,4(s1)
    8000393c:	cf99                	beqz	a5,8000395a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000393e:	02848493          	addi	s1,s1,40
    80003942:	fee49ce3          	bne	s1,a4,8000393a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003946:	00015517          	auipc	a0,0x15
    8000394a:	0f250513          	addi	a0,a0,242 # 80018a38 <ftable>
    8000394e:	00003097          	auipc	ra,0x3
    80003952:	8f2080e7          	jalr	-1806(ra) # 80006240 <release>
  return 0;
    80003956:	4481                	li	s1,0
    80003958:	a819                	j	8000396e <filealloc+0x5e>
      f->ref = 1;
    8000395a:	4785                	li	a5,1
    8000395c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000395e:	00015517          	auipc	a0,0x15
    80003962:	0da50513          	addi	a0,a0,218 # 80018a38 <ftable>
    80003966:	00003097          	auipc	ra,0x3
    8000396a:	8da080e7          	jalr	-1830(ra) # 80006240 <release>
}
    8000396e:	8526                	mv	a0,s1
    80003970:	60e2                	ld	ra,24(sp)
    80003972:	6442                	ld	s0,16(sp)
    80003974:	64a2                	ld	s1,8(sp)
    80003976:	6105                	addi	sp,sp,32
    80003978:	8082                	ret

000000008000397a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000397a:	1101                	addi	sp,sp,-32
    8000397c:	ec06                	sd	ra,24(sp)
    8000397e:	e822                	sd	s0,16(sp)
    80003980:	e426                	sd	s1,8(sp)
    80003982:	1000                	addi	s0,sp,32
    80003984:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003986:	00015517          	auipc	a0,0x15
    8000398a:	0b250513          	addi	a0,a0,178 # 80018a38 <ftable>
    8000398e:	00002097          	auipc	ra,0x2
    80003992:	7fe080e7          	jalr	2046(ra) # 8000618c <acquire>
  if(f->ref < 1)
    80003996:	40dc                	lw	a5,4(s1)
    80003998:	02f05263          	blez	a5,800039bc <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000399c:	2785                	addiw	a5,a5,1
    8000399e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800039a0:	00015517          	auipc	a0,0x15
    800039a4:	09850513          	addi	a0,a0,152 # 80018a38 <ftable>
    800039a8:	00003097          	auipc	ra,0x3
    800039ac:	898080e7          	jalr	-1896(ra) # 80006240 <release>
  return f;
}
    800039b0:	8526                	mv	a0,s1
    800039b2:	60e2                	ld	ra,24(sp)
    800039b4:	6442                	ld	s0,16(sp)
    800039b6:	64a2                	ld	s1,8(sp)
    800039b8:	6105                	addi	sp,sp,32
    800039ba:	8082                	ret
    panic("filedup");
    800039bc:	00005517          	auipc	a0,0x5
    800039c0:	c9450513          	addi	a0,a0,-876 # 80008650 <syscalls+0x240>
    800039c4:	00002097          	auipc	ra,0x2
    800039c8:	27e080e7          	jalr	638(ra) # 80005c42 <panic>

00000000800039cc <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800039cc:	7139                	addi	sp,sp,-64
    800039ce:	fc06                	sd	ra,56(sp)
    800039d0:	f822                	sd	s0,48(sp)
    800039d2:	f426                	sd	s1,40(sp)
    800039d4:	f04a                	sd	s2,32(sp)
    800039d6:	ec4e                	sd	s3,24(sp)
    800039d8:	e852                	sd	s4,16(sp)
    800039da:	e456                	sd	s5,8(sp)
    800039dc:	0080                	addi	s0,sp,64
    800039de:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800039e0:	00015517          	auipc	a0,0x15
    800039e4:	05850513          	addi	a0,a0,88 # 80018a38 <ftable>
    800039e8:	00002097          	auipc	ra,0x2
    800039ec:	7a4080e7          	jalr	1956(ra) # 8000618c <acquire>
  if(f->ref < 1)
    800039f0:	40dc                	lw	a5,4(s1)
    800039f2:	06f05163          	blez	a5,80003a54 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800039f6:	37fd                	addiw	a5,a5,-1
    800039f8:	0007871b          	sext.w	a4,a5
    800039fc:	c0dc                	sw	a5,4(s1)
    800039fe:	06e04363          	bgtz	a4,80003a64 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a02:	0004a903          	lw	s2,0(s1)
    80003a06:	0094ca83          	lbu	s5,9(s1)
    80003a0a:	0104ba03          	ld	s4,16(s1)
    80003a0e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a12:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a16:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a1a:	00015517          	auipc	a0,0x15
    80003a1e:	01e50513          	addi	a0,a0,30 # 80018a38 <ftable>
    80003a22:	00003097          	auipc	ra,0x3
    80003a26:	81e080e7          	jalr	-2018(ra) # 80006240 <release>

  if(ff.type == FD_PIPE){
    80003a2a:	4785                	li	a5,1
    80003a2c:	04f90d63          	beq	s2,a5,80003a86 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a30:	3979                	addiw	s2,s2,-2
    80003a32:	4785                	li	a5,1
    80003a34:	0527e063          	bltu	a5,s2,80003a74 <fileclose+0xa8>
    begin_op();
    80003a38:	00000097          	auipc	ra,0x0
    80003a3c:	ac8080e7          	jalr	-1336(ra) # 80003500 <begin_op>
    iput(ff.ip);
    80003a40:	854e                	mv	a0,s3
    80003a42:	fffff097          	auipc	ra,0xfffff
    80003a46:	2b6080e7          	jalr	694(ra) # 80002cf8 <iput>
    end_op();
    80003a4a:	00000097          	auipc	ra,0x0
    80003a4e:	b36080e7          	jalr	-1226(ra) # 80003580 <end_op>
    80003a52:	a00d                	j	80003a74 <fileclose+0xa8>
    panic("fileclose");
    80003a54:	00005517          	auipc	a0,0x5
    80003a58:	c0450513          	addi	a0,a0,-1020 # 80008658 <syscalls+0x248>
    80003a5c:	00002097          	auipc	ra,0x2
    80003a60:	1e6080e7          	jalr	486(ra) # 80005c42 <panic>
    release(&ftable.lock);
    80003a64:	00015517          	auipc	a0,0x15
    80003a68:	fd450513          	addi	a0,a0,-44 # 80018a38 <ftable>
    80003a6c:	00002097          	auipc	ra,0x2
    80003a70:	7d4080e7          	jalr	2004(ra) # 80006240 <release>
  }
}
    80003a74:	70e2                	ld	ra,56(sp)
    80003a76:	7442                	ld	s0,48(sp)
    80003a78:	74a2                	ld	s1,40(sp)
    80003a7a:	7902                	ld	s2,32(sp)
    80003a7c:	69e2                	ld	s3,24(sp)
    80003a7e:	6a42                	ld	s4,16(sp)
    80003a80:	6aa2                	ld	s5,8(sp)
    80003a82:	6121                	addi	sp,sp,64
    80003a84:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a86:	85d6                	mv	a1,s5
    80003a88:	8552                	mv	a0,s4
    80003a8a:	00000097          	auipc	ra,0x0
    80003a8e:	34c080e7          	jalr	844(ra) # 80003dd6 <pipeclose>
    80003a92:	b7cd                	j	80003a74 <fileclose+0xa8>

0000000080003a94 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a94:	715d                	addi	sp,sp,-80
    80003a96:	e486                	sd	ra,72(sp)
    80003a98:	e0a2                	sd	s0,64(sp)
    80003a9a:	fc26                	sd	s1,56(sp)
    80003a9c:	f84a                	sd	s2,48(sp)
    80003a9e:	f44e                	sd	s3,40(sp)
    80003aa0:	0880                	addi	s0,sp,80
    80003aa2:	84aa                	mv	s1,a0
    80003aa4:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003aa6:	ffffd097          	auipc	ra,0xffffd
    80003aaa:	40a080e7          	jalr	1034(ra) # 80000eb0 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003aae:	409c                	lw	a5,0(s1)
    80003ab0:	37f9                	addiw	a5,a5,-2
    80003ab2:	4705                	li	a4,1
    80003ab4:	04f76763          	bltu	a4,a5,80003b02 <filestat+0x6e>
    80003ab8:	892a                	mv	s2,a0
    ilock(f->ip);
    80003aba:	6c88                	ld	a0,24(s1)
    80003abc:	fffff097          	auipc	ra,0xfffff
    80003ac0:	082080e7          	jalr	130(ra) # 80002b3e <ilock>
    stati(f->ip, &st);
    80003ac4:	fb840593          	addi	a1,s0,-72
    80003ac8:	6c88                	ld	a0,24(s1)
    80003aca:	fffff097          	auipc	ra,0xfffff
    80003ace:	2fe080e7          	jalr	766(ra) # 80002dc8 <stati>
    iunlock(f->ip);
    80003ad2:	6c88                	ld	a0,24(s1)
    80003ad4:	fffff097          	auipc	ra,0xfffff
    80003ad8:	12c080e7          	jalr	300(ra) # 80002c00 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003adc:	46e1                	li	a3,24
    80003ade:	fb840613          	addi	a2,s0,-72
    80003ae2:	85ce                	mv	a1,s3
    80003ae4:	05093503          	ld	a0,80(s2)
    80003ae8:	ffffd097          	auipc	ra,0xffffd
    80003aec:	052080e7          	jalr	82(ra) # 80000b3a <copyout>
    80003af0:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003af4:	60a6                	ld	ra,72(sp)
    80003af6:	6406                	ld	s0,64(sp)
    80003af8:	74e2                	ld	s1,56(sp)
    80003afa:	7942                	ld	s2,48(sp)
    80003afc:	79a2                	ld	s3,40(sp)
    80003afe:	6161                	addi	sp,sp,80
    80003b00:	8082                	ret
  return -1;
    80003b02:	557d                	li	a0,-1
    80003b04:	bfc5                	j	80003af4 <filestat+0x60>

0000000080003b06 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b06:	7179                	addi	sp,sp,-48
    80003b08:	f406                	sd	ra,40(sp)
    80003b0a:	f022                	sd	s0,32(sp)
    80003b0c:	ec26                	sd	s1,24(sp)
    80003b0e:	e84a                	sd	s2,16(sp)
    80003b10:	e44e                	sd	s3,8(sp)
    80003b12:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b14:	00854783          	lbu	a5,8(a0)
    80003b18:	c3d5                	beqz	a5,80003bbc <fileread+0xb6>
    80003b1a:	84aa                	mv	s1,a0
    80003b1c:	89ae                	mv	s3,a1
    80003b1e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b20:	411c                	lw	a5,0(a0)
    80003b22:	4705                	li	a4,1
    80003b24:	04e78963          	beq	a5,a4,80003b76 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b28:	470d                	li	a4,3
    80003b2a:	04e78d63          	beq	a5,a4,80003b84 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b2e:	4709                	li	a4,2
    80003b30:	06e79e63          	bne	a5,a4,80003bac <fileread+0xa6>
    ilock(f->ip);
    80003b34:	6d08                	ld	a0,24(a0)
    80003b36:	fffff097          	auipc	ra,0xfffff
    80003b3a:	008080e7          	jalr	8(ra) # 80002b3e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b3e:	874a                	mv	a4,s2
    80003b40:	5094                	lw	a3,32(s1)
    80003b42:	864e                	mv	a2,s3
    80003b44:	4585                	li	a1,1
    80003b46:	6c88                	ld	a0,24(s1)
    80003b48:	fffff097          	auipc	ra,0xfffff
    80003b4c:	2aa080e7          	jalr	682(ra) # 80002df2 <readi>
    80003b50:	892a                	mv	s2,a0
    80003b52:	00a05563          	blez	a0,80003b5c <fileread+0x56>
      f->off += r;
    80003b56:	509c                	lw	a5,32(s1)
    80003b58:	9fa9                	addw	a5,a5,a0
    80003b5a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003b5c:	6c88                	ld	a0,24(s1)
    80003b5e:	fffff097          	auipc	ra,0xfffff
    80003b62:	0a2080e7          	jalr	162(ra) # 80002c00 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003b66:	854a                	mv	a0,s2
    80003b68:	70a2                	ld	ra,40(sp)
    80003b6a:	7402                	ld	s0,32(sp)
    80003b6c:	64e2                	ld	s1,24(sp)
    80003b6e:	6942                	ld	s2,16(sp)
    80003b70:	69a2                	ld	s3,8(sp)
    80003b72:	6145                	addi	sp,sp,48
    80003b74:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b76:	6908                	ld	a0,16(a0)
    80003b78:	00000097          	auipc	ra,0x0
    80003b7c:	3ce080e7          	jalr	974(ra) # 80003f46 <piperead>
    80003b80:	892a                	mv	s2,a0
    80003b82:	b7d5                	j	80003b66 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b84:	02451783          	lh	a5,36(a0)
    80003b88:	03079693          	slli	a3,a5,0x30
    80003b8c:	92c1                	srli	a3,a3,0x30
    80003b8e:	4725                	li	a4,9
    80003b90:	02d76863          	bltu	a4,a3,80003bc0 <fileread+0xba>
    80003b94:	0792                	slli	a5,a5,0x4
    80003b96:	00015717          	auipc	a4,0x15
    80003b9a:	e0270713          	addi	a4,a4,-510 # 80018998 <devsw>
    80003b9e:	97ba                	add	a5,a5,a4
    80003ba0:	639c                	ld	a5,0(a5)
    80003ba2:	c38d                	beqz	a5,80003bc4 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003ba4:	4505                	li	a0,1
    80003ba6:	9782                	jalr	a5
    80003ba8:	892a                	mv	s2,a0
    80003baa:	bf75                	j	80003b66 <fileread+0x60>
    panic("fileread");
    80003bac:	00005517          	auipc	a0,0x5
    80003bb0:	abc50513          	addi	a0,a0,-1348 # 80008668 <syscalls+0x258>
    80003bb4:	00002097          	auipc	ra,0x2
    80003bb8:	08e080e7          	jalr	142(ra) # 80005c42 <panic>
    return -1;
    80003bbc:	597d                	li	s2,-1
    80003bbe:	b765                	j	80003b66 <fileread+0x60>
      return -1;
    80003bc0:	597d                	li	s2,-1
    80003bc2:	b755                	j	80003b66 <fileread+0x60>
    80003bc4:	597d                	li	s2,-1
    80003bc6:	b745                	j	80003b66 <fileread+0x60>

0000000080003bc8 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003bc8:	715d                	addi	sp,sp,-80
    80003bca:	e486                	sd	ra,72(sp)
    80003bcc:	e0a2                	sd	s0,64(sp)
    80003bce:	fc26                	sd	s1,56(sp)
    80003bd0:	f84a                	sd	s2,48(sp)
    80003bd2:	f44e                	sd	s3,40(sp)
    80003bd4:	f052                	sd	s4,32(sp)
    80003bd6:	ec56                	sd	s5,24(sp)
    80003bd8:	e85a                	sd	s6,16(sp)
    80003bda:	e45e                	sd	s7,8(sp)
    80003bdc:	e062                	sd	s8,0(sp)
    80003bde:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003be0:	00954783          	lbu	a5,9(a0)
    80003be4:	10078663          	beqz	a5,80003cf0 <filewrite+0x128>
    80003be8:	892a                	mv	s2,a0
    80003bea:	8aae                	mv	s5,a1
    80003bec:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bee:	411c                	lw	a5,0(a0)
    80003bf0:	4705                	li	a4,1
    80003bf2:	02e78263          	beq	a5,a4,80003c16 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bf6:	470d                	li	a4,3
    80003bf8:	02e78663          	beq	a5,a4,80003c24 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bfc:	4709                	li	a4,2
    80003bfe:	0ee79163          	bne	a5,a4,80003ce0 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c02:	0ac05d63          	blez	a2,80003cbc <filewrite+0xf4>
    int i = 0;
    80003c06:	4981                	li	s3,0
    80003c08:	6b05                	lui	s6,0x1
    80003c0a:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003c0e:	6b85                	lui	s7,0x1
    80003c10:	c00b8b9b          	addiw	s7,s7,-1024
    80003c14:	a861                	j	80003cac <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003c16:	6908                	ld	a0,16(a0)
    80003c18:	00000097          	auipc	ra,0x0
    80003c1c:	22e080e7          	jalr	558(ra) # 80003e46 <pipewrite>
    80003c20:	8a2a                	mv	s4,a0
    80003c22:	a045                	j	80003cc2 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c24:	02451783          	lh	a5,36(a0)
    80003c28:	03079693          	slli	a3,a5,0x30
    80003c2c:	92c1                	srli	a3,a3,0x30
    80003c2e:	4725                	li	a4,9
    80003c30:	0cd76263          	bltu	a4,a3,80003cf4 <filewrite+0x12c>
    80003c34:	0792                	slli	a5,a5,0x4
    80003c36:	00015717          	auipc	a4,0x15
    80003c3a:	d6270713          	addi	a4,a4,-670 # 80018998 <devsw>
    80003c3e:	97ba                	add	a5,a5,a4
    80003c40:	679c                	ld	a5,8(a5)
    80003c42:	cbdd                	beqz	a5,80003cf8 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003c44:	4505                	li	a0,1
    80003c46:	9782                	jalr	a5
    80003c48:	8a2a                	mv	s4,a0
    80003c4a:	a8a5                	j	80003cc2 <filewrite+0xfa>
    80003c4c:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003c50:	00000097          	auipc	ra,0x0
    80003c54:	8b0080e7          	jalr	-1872(ra) # 80003500 <begin_op>
      ilock(f->ip);
    80003c58:	01893503          	ld	a0,24(s2)
    80003c5c:	fffff097          	auipc	ra,0xfffff
    80003c60:	ee2080e7          	jalr	-286(ra) # 80002b3e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c64:	8762                	mv	a4,s8
    80003c66:	02092683          	lw	a3,32(s2)
    80003c6a:	01598633          	add	a2,s3,s5
    80003c6e:	4585                	li	a1,1
    80003c70:	01893503          	ld	a0,24(s2)
    80003c74:	fffff097          	auipc	ra,0xfffff
    80003c78:	276080e7          	jalr	630(ra) # 80002eea <writei>
    80003c7c:	84aa                	mv	s1,a0
    80003c7e:	00a05763          	blez	a0,80003c8c <filewrite+0xc4>
        f->off += r;
    80003c82:	02092783          	lw	a5,32(s2)
    80003c86:	9fa9                	addw	a5,a5,a0
    80003c88:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c8c:	01893503          	ld	a0,24(s2)
    80003c90:	fffff097          	auipc	ra,0xfffff
    80003c94:	f70080e7          	jalr	-144(ra) # 80002c00 <iunlock>
      end_op();
    80003c98:	00000097          	auipc	ra,0x0
    80003c9c:	8e8080e7          	jalr	-1816(ra) # 80003580 <end_op>

      if(r != n1){
    80003ca0:	009c1f63          	bne	s8,s1,80003cbe <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003ca4:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ca8:	0149db63          	bge	s3,s4,80003cbe <filewrite+0xf6>
      int n1 = n - i;
    80003cac:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003cb0:	84be                	mv	s1,a5
    80003cb2:	2781                	sext.w	a5,a5
    80003cb4:	f8fb5ce3          	bge	s6,a5,80003c4c <filewrite+0x84>
    80003cb8:	84de                	mv	s1,s7
    80003cba:	bf49                	j	80003c4c <filewrite+0x84>
    int i = 0;
    80003cbc:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003cbe:	013a1f63          	bne	s4,s3,80003cdc <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003cc2:	8552                	mv	a0,s4
    80003cc4:	60a6                	ld	ra,72(sp)
    80003cc6:	6406                	ld	s0,64(sp)
    80003cc8:	74e2                	ld	s1,56(sp)
    80003cca:	7942                	ld	s2,48(sp)
    80003ccc:	79a2                	ld	s3,40(sp)
    80003cce:	7a02                	ld	s4,32(sp)
    80003cd0:	6ae2                	ld	s5,24(sp)
    80003cd2:	6b42                	ld	s6,16(sp)
    80003cd4:	6ba2                	ld	s7,8(sp)
    80003cd6:	6c02                	ld	s8,0(sp)
    80003cd8:	6161                	addi	sp,sp,80
    80003cda:	8082                	ret
    ret = (i == n ? n : -1);
    80003cdc:	5a7d                	li	s4,-1
    80003cde:	b7d5                	j	80003cc2 <filewrite+0xfa>
    panic("filewrite");
    80003ce0:	00005517          	auipc	a0,0x5
    80003ce4:	99850513          	addi	a0,a0,-1640 # 80008678 <syscalls+0x268>
    80003ce8:	00002097          	auipc	ra,0x2
    80003cec:	f5a080e7          	jalr	-166(ra) # 80005c42 <panic>
    return -1;
    80003cf0:	5a7d                	li	s4,-1
    80003cf2:	bfc1                	j	80003cc2 <filewrite+0xfa>
      return -1;
    80003cf4:	5a7d                	li	s4,-1
    80003cf6:	b7f1                	j	80003cc2 <filewrite+0xfa>
    80003cf8:	5a7d                	li	s4,-1
    80003cfa:	b7e1                	j	80003cc2 <filewrite+0xfa>

0000000080003cfc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003cfc:	7179                	addi	sp,sp,-48
    80003cfe:	f406                	sd	ra,40(sp)
    80003d00:	f022                	sd	s0,32(sp)
    80003d02:	ec26                	sd	s1,24(sp)
    80003d04:	e84a                	sd	s2,16(sp)
    80003d06:	e44e                	sd	s3,8(sp)
    80003d08:	e052                	sd	s4,0(sp)
    80003d0a:	1800                	addi	s0,sp,48
    80003d0c:	84aa                	mv	s1,a0
    80003d0e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d10:	0005b023          	sd	zero,0(a1)
    80003d14:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d18:	00000097          	auipc	ra,0x0
    80003d1c:	bf8080e7          	jalr	-1032(ra) # 80003910 <filealloc>
    80003d20:	e088                	sd	a0,0(s1)
    80003d22:	c551                	beqz	a0,80003dae <pipealloc+0xb2>
    80003d24:	00000097          	auipc	ra,0x0
    80003d28:	bec080e7          	jalr	-1044(ra) # 80003910 <filealloc>
    80003d2c:	00aa3023          	sd	a0,0(s4)
    80003d30:	c92d                	beqz	a0,80003da2 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d32:	ffffc097          	auipc	ra,0xffffc
    80003d36:	3e6080e7          	jalr	998(ra) # 80000118 <kalloc>
    80003d3a:	892a                	mv	s2,a0
    80003d3c:	c125                	beqz	a0,80003d9c <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003d3e:	4985                	li	s3,1
    80003d40:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d44:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d48:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d4c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d50:	00005597          	auipc	a1,0x5
    80003d54:	93858593          	addi	a1,a1,-1736 # 80008688 <syscalls+0x278>
    80003d58:	00002097          	auipc	ra,0x2
    80003d5c:	3a4080e7          	jalr	932(ra) # 800060fc <initlock>
  (*f0)->type = FD_PIPE;
    80003d60:	609c                	ld	a5,0(s1)
    80003d62:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d66:	609c                	ld	a5,0(s1)
    80003d68:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d6c:	609c                	ld	a5,0(s1)
    80003d6e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d72:	609c                	ld	a5,0(s1)
    80003d74:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d78:	000a3783          	ld	a5,0(s4)
    80003d7c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d80:	000a3783          	ld	a5,0(s4)
    80003d84:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d88:	000a3783          	ld	a5,0(s4)
    80003d8c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d90:	000a3783          	ld	a5,0(s4)
    80003d94:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d98:	4501                	li	a0,0
    80003d9a:	a025                	j	80003dc2 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d9c:	6088                	ld	a0,0(s1)
    80003d9e:	e501                	bnez	a0,80003da6 <pipealloc+0xaa>
    80003da0:	a039                	j	80003dae <pipealloc+0xb2>
    80003da2:	6088                	ld	a0,0(s1)
    80003da4:	c51d                	beqz	a0,80003dd2 <pipealloc+0xd6>
    fileclose(*f0);
    80003da6:	00000097          	auipc	ra,0x0
    80003daa:	c26080e7          	jalr	-986(ra) # 800039cc <fileclose>
  if(*f1)
    80003dae:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003db2:	557d                	li	a0,-1
  if(*f1)
    80003db4:	c799                	beqz	a5,80003dc2 <pipealloc+0xc6>
    fileclose(*f1);
    80003db6:	853e                	mv	a0,a5
    80003db8:	00000097          	auipc	ra,0x0
    80003dbc:	c14080e7          	jalr	-1004(ra) # 800039cc <fileclose>
  return -1;
    80003dc0:	557d                	li	a0,-1
}
    80003dc2:	70a2                	ld	ra,40(sp)
    80003dc4:	7402                	ld	s0,32(sp)
    80003dc6:	64e2                	ld	s1,24(sp)
    80003dc8:	6942                	ld	s2,16(sp)
    80003dca:	69a2                	ld	s3,8(sp)
    80003dcc:	6a02                	ld	s4,0(sp)
    80003dce:	6145                	addi	sp,sp,48
    80003dd0:	8082                	ret
  return -1;
    80003dd2:	557d                	li	a0,-1
    80003dd4:	b7fd                	j	80003dc2 <pipealloc+0xc6>

0000000080003dd6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003dd6:	1101                	addi	sp,sp,-32
    80003dd8:	ec06                	sd	ra,24(sp)
    80003dda:	e822                	sd	s0,16(sp)
    80003ddc:	e426                	sd	s1,8(sp)
    80003dde:	e04a                	sd	s2,0(sp)
    80003de0:	1000                	addi	s0,sp,32
    80003de2:	84aa                	mv	s1,a0
    80003de4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003de6:	00002097          	auipc	ra,0x2
    80003dea:	3a6080e7          	jalr	934(ra) # 8000618c <acquire>
  if(writable){
    80003dee:	02090d63          	beqz	s2,80003e28 <pipeclose+0x52>
    pi->writeopen = 0;
    80003df2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003df6:	21848513          	addi	a0,s1,536
    80003dfa:	ffffd097          	auipc	ra,0xffffd
    80003dfe:	7c2080e7          	jalr	1986(ra) # 800015bc <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e02:	2204b783          	ld	a5,544(s1)
    80003e06:	eb95                	bnez	a5,80003e3a <pipeclose+0x64>
    release(&pi->lock);
    80003e08:	8526                	mv	a0,s1
    80003e0a:	00002097          	auipc	ra,0x2
    80003e0e:	436080e7          	jalr	1078(ra) # 80006240 <release>
    kfree((char*)pi);
    80003e12:	8526                	mv	a0,s1
    80003e14:	ffffc097          	auipc	ra,0xffffc
    80003e18:	208080e7          	jalr	520(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e1c:	60e2                	ld	ra,24(sp)
    80003e1e:	6442                	ld	s0,16(sp)
    80003e20:	64a2                	ld	s1,8(sp)
    80003e22:	6902                	ld	s2,0(sp)
    80003e24:	6105                	addi	sp,sp,32
    80003e26:	8082                	ret
    pi->readopen = 0;
    80003e28:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e2c:	21c48513          	addi	a0,s1,540
    80003e30:	ffffd097          	auipc	ra,0xffffd
    80003e34:	78c080e7          	jalr	1932(ra) # 800015bc <wakeup>
    80003e38:	b7e9                	j	80003e02 <pipeclose+0x2c>
    release(&pi->lock);
    80003e3a:	8526                	mv	a0,s1
    80003e3c:	00002097          	auipc	ra,0x2
    80003e40:	404080e7          	jalr	1028(ra) # 80006240 <release>
}
    80003e44:	bfe1                	j	80003e1c <pipeclose+0x46>

0000000080003e46 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e46:	7159                	addi	sp,sp,-112
    80003e48:	f486                	sd	ra,104(sp)
    80003e4a:	f0a2                	sd	s0,96(sp)
    80003e4c:	eca6                	sd	s1,88(sp)
    80003e4e:	e8ca                	sd	s2,80(sp)
    80003e50:	e4ce                	sd	s3,72(sp)
    80003e52:	e0d2                	sd	s4,64(sp)
    80003e54:	fc56                	sd	s5,56(sp)
    80003e56:	f85a                	sd	s6,48(sp)
    80003e58:	f45e                	sd	s7,40(sp)
    80003e5a:	f062                	sd	s8,32(sp)
    80003e5c:	ec66                	sd	s9,24(sp)
    80003e5e:	1880                	addi	s0,sp,112
    80003e60:	84aa                	mv	s1,a0
    80003e62:	8aae                	mv	s5,a1
    80003e64:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e66:	ffffd097          	auipc	ra,0xffffd
    80003e6a:	04a080e7          	jalr	74(ra) # 80000eb0 <myproc>
    80003e6e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e70:	8526                	mv	a0,s1
    80003e72:	00002097          	auipc	ra,0x2
    80003e76:	31a080e7          	jalr	794(ra) # 8000618c <acquire>
  while(i < n){
    80003e7a:	0d405463          	blez	s4,80003f42 <pipewrite+0xfc>
    80003e7e:	8ba6                	mv	s7,s1
  int i = 0;
    80003e80:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e82:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e84:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e88:	21c48c13          	addi	s8,s1,540
    80003e8c:	a08d                	j	80003eee <pipewrite+0xa8>
      release(&pi->lock);
    80003e8e:	8526                	mv	a0,s1
    80003e90:	00002097          	auipc	ra,0x2
    80003e94:	3b0080e7          	jalr	944(ra) # 80006240 <release>
      return -1;
    80003e98:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e9a:	854a                	mv	a0,s2
    80003e9c:	70a6                	ld	ra,104(sp)
    80003e9e:	7406                	ld	s0,96(sp)
    80003ea0:	64e6                	ld	s1,88(sp)
    80003ea2:	6946                	ld	s2,80(sp)
    80003ea4:	69a6                	ld	s3,72(sp)
    80003ea6:	6a06                	ld	s4,64(sp)
    80003ea8:	7ae2                	ld	s5,56(sp)
    80003eaa:	7b42                	ld	s6,48(sp)
    80003eac:	7ba2                	ld	s7,40(sp)
    80003eae:	7c02                	ld	s8,32(sp)
    80003eb0:	6ce2                	ld	s9,24(sp)
    80003eb2:	6165                	addi	sp,sp,112
    80003eb4:	8082                	ret
      wakeup(&pi->nread);
    80003eb6:	8566                	mv	a0,s9
    80003eb8:	ffffd097          	auipc	ra,0xffffd
    80003ebc:	704080e7          	jalr	1796(ra) # 800015bc <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003ec0:	85de                	mv	a1,s7
    80003ec2:	8562                	mv	a0,s8
    80003ec4:	ffffd097          	auipc	ra,0xffffd
    80003ec8:	694080e7          	jalr	1684(ra) # 80001558 <sleep>
    80003ecc:	a839                	j	80003eea <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003ece:	21c4a783          	lw	a5,540(s1)
    80003ed2:	0017871b          	addiw	a4,a5,1
    80003ed6:	20e4ae23          	sw	a4,540(s1)
    80003eda:	1ff7f793          	andi	a5,a5,511
    80003ede:	97a6                	add	a5,a5,s1
    80003ee0:	f9f44703          	lbu	a4,-97(s0)
    80003ee4:	00e78c23          	sb	a4,24(a5)
      i++;
    80003ee8:	2905                	addiw	s2,s2,1
  while(i < n){
    80003eea:	05495063          	bge	s2,s4,80003f2a <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80003eee:	2204a783          	lw	a5,544(s1)
    80003ef2:	dfd1                	beqz	a5,80003e8e <pipewrite+0x48>
    80003ef4:	854e                	mv	a0,s3
    80003ef6:	ffffe097          	auipc	ra,0xffffe
    80003efa:	90a080e7          	jalr	-1782(ra) # 80001800 <killed>
    80003efe:	f941                	bnez	a0,80003e8e <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f00:	2184a783          	lw	a5,536(s1)
    80003f04:	21c4a703          	lw	a4,540(s1)
    80003f08:	2007879b          	addiw	a5,a5,512
    80003f0c:	faf705e3          	beq	a4,a5,80003eb6 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f10:	4685                	li	a3,1
    80003f12:	01590633          	add	a2,s2,s5
    80003f16:	f9f40593          	addi	a1,s0,-97
    80003f1a:	0509b503          	ld	a0,80(s3)
    80003f1e:	ffffd097          	auipc	ra,0xffffd
    80003f22:	cdc080e7          	jalr	-804(ra) # 80000bfa <copyin>
    80003f26:	fb6514e3          	bne	a0,s6,80003ece <pipewrite+0x88>
  wakeup(&pi->nread);
    80003f2a:	21848513          	addi	a0,s1,536
    80003f2e:	ffffd097          	auipc	ra,0xffffd
    80003f32:	68e080e7          	jalr	1678(ra) # 800015bc <wakeup>
  release(&pi->lock);
    80003f36:	8526                	mv	a0,s1
    80003f38:	00002097          	auipc	ra,0x2
    80003f3c:	308080e7          	jalr	776(ra) # 80006240 <release>
  return i;
    80003f40:	bfa9                	j	80003e9a <pipewrite+0x54>
  int i = 0;
    80003f42:	4901                	li	s2,0
    80003f44:	b7dd                	j	80003f2a <pipewrite+0xe4>

0000000080003f46 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f46:	715d                	addi	sp,sp,-80
    80003f48:	e486                	sd	ra,72(sp)
    80003f4a:	e0a2                	sd	s0,64(sp)
    80003f4c:	fc26                	sd	s1,56(sp)
    80003f4e:	f84a                	sd	s2,48(sp)
    80003f50:	f44e                	sd	s3,40(sp)
    80003f52:	f052                	sd	s4,32(sp)
    80003f54:	ec56                	sd	s5,24(sp)
    80003f56:	e85a                	sd	s6,16(sp)
    80003f58:	0880                	addi	s0,sp,80
    80003f5a:	84aa                	mv	s1,a0
    80003f5c:	892e                	mv	s2,a1
    80003f5e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f60:	ffffd097          	auipc	ra,0xffffd
    80003f64:	f50080e7          	jalr	-176(ra) # 80000eb0 <myproc>
    80003f68:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f6a:	8b26                	mv	s6,s1
    80003f6c:	8526                	mv	a0,s1
    80003f6e:	00002097          	auipc	ra,0x2
    80003f72:	21e080e7          	jalr	542(ra) # 8000618c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f76:	2184a703          	lw	a4,536(s1)
    80003f7a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f7e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f82:	02f71763          	bne	a4,a5,80003fb0 <piperead+0x6a>
    80003f86:	2244a783          	lw	a5,548(s1)
    80003f8a:	c39d                	beqz	a5,80003fb0 <piperead+0x6a>
    if(killed(pr)){
    80003f8c:	8552                	mv	a0,s4
    80003f8e:	ffffe097          	auipc	ra,0xffffe
    80003f92:	872080e7          	jalr	-1934(ra) # 80001800 <killed>
    80003f96:	e941                	bnez	a0,80004026 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f98:	85da                	mv	a1,s6
    80003f9a:	854e                	mv	a0,s3
    80003f9c:	ffffd097          	auipc	ra,0xffffd
    80003fa0:	5bc080e7          	jalr	1468(ra) # 80001558 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fa4:	2184a703          	lw	a4,536(s1)
    80003fa8:	21c4a783          	lw	a5,540(s1)
    80003fac:	fcf70de3          	beq	a4,a5,80003f86 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fb0:	09505263          	blez	s5,80004034 <piperead+0xee>
    80003fb4:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fb6:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80003fb8:	2184a783          	lw	a5,536(s1)
    80003fbc:	21c4a703          	lw	a4,540(s1)
    80003fc0:	02f70d63          	beq	a4,a5,80003ffa <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003fc4:	0017871b          	addiw	a4,a5,1
    80003fc8:	20e4ac23          	sw	a4,536(s1)
    80003fcc:	1ff7f793          	andi	a5,a5,511
    80003fd0:	97a6                	add	a5,a5,s1
    80003fd2:	0187c783          	lbu	a5,24(a5)
    80003fd6:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fda:	4685                	li	a3,1
    80003fdc:	fbf40613          	addi	a2,s0,-65
    80003fe0:	85ca                	mv	a1,s2
    80003fe2:	050a3503          	ld	a0,80(s4)
    80003fe6:	ffffd097          	auipc	ra,0xffffd
    80003fea:	b54080e7          	jalr	-1196(ra) # 80000b3a <copyout>
    80003fee:	01650663          	beq	a0,s6,80003ffa <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003ff2:	2985                	addiw	s3,s3,1
    80003ff4:	0905                	addi	s2,s2,1
    80003ff6:	fd3a91e3          	bne	s5,s3,80003fb8 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003ffa:	21c48513          	addi	a0,s1,540
    80003ffe:	ffffd097          	auipc	ra,0xffffd
    80004002:	5be080e7          	jalr	1470(ra) # 800015bc <wakeup>
  release(&pi->lock);
    80004006:	8526                	mv	a0,s1
    80004008:	00002097          	auipc	ra,0x2
    8000400c:	238080e7          	jalr	568(ra) # 80006240 <release>
  return i;
}
    80004010:	854e                	mv	a0,s3
    80004012:	60a6                	ld	ra,72(sp)
    80004014:	6406                	ld	s0,64(sp)
    80004016:	74e2                	ld	s1,56(sp)
    80004018:	7942                	ld	s2,48(sp)
    8000401a:	79a2                	ld	s3,40(sp)
    8000401c:	7a02                	ld	s4,32(sp)
    8000401e:	6ae2                	ld	s5,24(sp)
    80004020:	6b42                	ld	s6,16(sp)
    80004022:	6161                	addi	sp,sp,80
    80004024:	8082                	ret
      release(&pi->lock);
    80004026:	8526                	mv	a0,s1
    80004028:	00002097          	auipc	ra,0x2
    8000402c:	218080e7          	jalr	536(ra) # 80006240 <release>
      return -1;
    80004030:	59fd                	li	s3,-1
    80004032:	bff9                	j	80004010 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004034:	4981                	li	s3,0
    80004036:	b7d1                	j	80003ffa <piperead+0xb4>

0000000080004038 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004038:	1141                	addi	sp,sp,-16
    8000403a:	e422                	sd	s0,8(sp)
    8000403c:	0800                	addi	s0,sp,16
    8000403e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004040:	8905                	andi	a0,a0,1
    80004042:	c111                	beqz	a0,80004046 <flags2perm+0xe>
      perm = PTE_X;
    80004044:	4521                	li	a0,8
    if(flags & 0x2)
    80004046:	8b89                	andi	a5,a5,2
    80004048:	c399                	beqz	a5,8000404e <flags2perm+0x16>
      perm |= PTE_W;
    8000404a:	00456513          	ori	a0,a0,4
    return perm;
}
    8000404e:	6422                	ld	s0,8(sp)
    80004050:	0141                	addi	sp,sp,16
    80004052:	8082                	ret

0000000080004054 <exec>:

int
exec(char *path, char **argv)
{
    80004054:	df010113          	addi	sp,sp,-528
    80004058:	20113423          	sd	ra,520(sp)
    8000405c:	20813023          	sd	s0,512(sp)
    80004060:	ffa6                	sd	s1,504(sp)
    80004062:	fbca                	sd	s2,496(sp)
    80004064:	f7ce                	sd	s3,488(sp)
    80004066:	f3d2                	sd	s4,480(sp)
    80004068:	efd6                	sd	s5,472(sp)
    8000406a:	ebda                	sd	s6,464(sp)
    8000406c:	e7de                	sd	s7,456(sp)
    8000406e:	e3e2                	sd	s8,448(sp)
    80004070:	ff66                	sd	s9,440(sp)
    80004072:	fb6a                	sd	s10,432(sp)
    80004074:	f76e                	sd	s11,424(sp)
    80004076:	0c00                	addi	s0,sp,528
    80004078:	84aa                	mv	s1,a0
    8000407a:	dea43c23          	sd	a0,-520(s0)
    8000407e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004082:	ffffd097          	auipc	ra,0xffffd
    80004086:	e2e080e7          	jalr	-466(ra) # 80000eb0 <myproc>
    8000408a:	892a                	mv	s2,a0

  begin_op();
    8000408c:	fffff097          	auipc	ra,0xfffff
    80004090:	474080e7          	jalr	1140(ra) # 80003500 <begin_op>

  if((ip = namei(path)) == 0){
    80004094:	8526                	mv	a0,s1
    80004096:	fffff097          	auipc	ra,0xfffff
    8000409a:	24e080e7          	jalr	590(ra) # 800032e4 <namei>
    8000409e:	c92d                	beqz	a0,80004110 <exec+0xbc>
    800040a0:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800040a2:	fffff097          	auipc	ra,0xfffff
    800040a6:	a9c080e7          	jalr	-1380(ra) # 80002b3e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800040aa:	04000713          	li	a4,64
    800040ae:	4681                	li	a3,0
    800040b0:	e5040613          	addi	a2,s0,-432
    800040b4:	4581                	li	a1,0
    800040b6:	8526                	mv	a0,s1
    800040b8:	fffff097          	auipc	ra,0xfffff
    800040bc:	d3a080e7          	jalr	-710(ra) # 80002df2 <readi>
    800040c0:	04000793          	li	a5,64
    800040c4:	00f51a63          	bne	a0,a5,800040d8 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800040c8:	e5042703          	lw	a4,-432(s0)
    800040cc:	464c47b7          	lui	a5,0x464c4
    800040d0:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800040d4:	04f70463          	beq	a4,a5,8000411c <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800040d8:	8526                	mv	a0,s1
    800040da:	fffff097          	auipc	ra,0xfffff
    800040de:	cc6080e7          	jalr	-826(ra) # 80002da0 <iunlockput>
    end_op();
    800040e2:	fffff097          	auipc	ra,0xfffff
    800040e6:	49e080e7          	jalr	1182(ra) # 80003580 <end_op>
  }
  return -1;
    800040ea:	557d                	li	a0,-1
}
    800040ec:	20813083          	ld	ra,520(sp)
    800040f0:	20013403          	ld	s0,512(sp)
    800040f4:	74fe                	ld	s1,504(sp)
    800040f6:	795e                	ld	s2,496(sp)
    800040f8:	79be                	ld	s3,488(sp)
    800040fa:	7a1e                	ld	s4,480(sp)
    800040fc:	6afe                	ld	s5,472(sp)
    800040fe:	6b5e                	ld	s6,464(sp)
    80004100:	6bbe                	ld	s7,456(sp)
    80004102:	6c1e                	ld	s8,448(sp)
    80004104:	7cfa                	ld	s9,440(sp)
    80004106:	7d5a                	ld	s10,432(sp)
    80004108:	7dba                	ld	s11,424(sp)
    8000410a:	21010113          	addi	sp,sp,528
    8000410e:	8082                	ret
    end_op();
    80004110:	fffff097          	auipc	ra,0xfffff
    80004114:	470080e7          	jalr	1136(ra) # 80003580 <end_op>
    return -1;
    80004118:	557d                	li	a0,-1
    8000411a:	bfc9                	j	800040ec <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000411c:	854a                	mv	a0,s2
    8000411e:	ffffd097          	auipc	ra,0xffffd
    80004122:	e5a080e7          	jalr	-422(ra) # 80000f78 <proc_pagetable>
    80004126:	8baa                	mv	s7,a0
    80004128:	d945                	beqz	a0,800040d8 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000412a:	e7042983          	lw	s3,-400(s0)
    8000412e:	e8845783          	lhu	a5,-376(s0)
    80004132:	c7ad                	beqz	a5,8000419c <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004134:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004136:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80004138:	6c85                	lui	s9,0x1
    8000413a:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000413e:	def43823          	sd	a5,-528(s0)
    80004142:	ac0d                	j	80004374 <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004144:	00004517          	auipc	a0,0x4
    80004148:	54c50513          	addi	a0,a0,1356 # 80008690 <syscalls+0x280>
    8000414c:	00002097          	auipc	ra,0x2
    80004150:	af6080e7          	jalr	-1290(ra) # 80005c42 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004154:	8756                	mv	a4,s5
    80004156:	012d86bb          	addw	a3,s11,s2
    8000415a:	4581                	li	a1,0
    8000415c:	8526                	mv	a0,s1
    8000415e:	fffff097          	auipc	ra,0xfffff
    80004162:	c94080e7          	jalr	-876(ra) # 80002df2 <readi>
    80004166:	2501                	sext.w	a0,a0
    80004168:	1aaa9a63          	bne	s5,a0,8000431c <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    8000416c:	6785                	lui	a5,0x1
    8000416e:	0127893b          	addw	s2,a5,s2
    80004172:	77fd                	lui	a5,0xfffff
    80004174:	01478a3b          	addw	s4,a5,s4
    80004178:	1f897563          	bgeu	s2,s8,80004362 <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    8000417c:	02091593          	slli	a1,s2,0x20
    80004180:	9181                	srli	a1,a1,0x20
    80004182:	95ea                	add	a1,a1,s10
    80004184:	855e                	mv	a0,s7
    80004186:	ffffc097          	auipc	ra,0xffffc
    8000418a:	384080e7          	jalr	900(ra) # 8000050a <walkaddr>
    8000418e:	862a                	mv	a2,a0
    if(pa == 0)
    80004190:	d955                	beqz	a0,80004144 <exec+0xf0>
      n = PGSIZE;
    80004192:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004194:	fd9a70e3          	bgeu	s4,s9,80004154 <exec+0x100>
      n = sz - i;
    80004198:	8ad2                	mv	s5,s4
    8000419a:	bf6d                	j	80004154 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000419c:	4a01                	li	s4,0
  iunlockput(ip);
    8000419e:	8526                	mv	a0,s1
    800041a0:	fffff097          	auipc	ra,0xfffff
    800041a4:	c00080e7          	jalr	-1024(ra) # 80002da0 <iunlockput>
  end_op();
    800041a8:	fffff097          	auipc	ra,0xfffff
    800041ac:	3d8080e7          	jalr	984(ra) # 80003580 <end_op>
  p = myproc();
    800041b0:	ffffd097          	auipc	ra,0xffffd
    800041b4:	d00080e7          	jalr	-768(ra) # 80000eb0 <myproc>
    800041b8:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800041ba:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800041be:	6785                	lui	a5,0x1
    800041c0:	17fd                	addi	a5,a5,-1
    800041c2:	9a3e                	add	s4,s4,a5
    800041c4:	757d                	lui	a0,0xfffff
    800041c6:	00aa77b3          	and	a5,s4,a0
    800041ca:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800041ce:	4691                	li	a3,4
    800041d0:	6609                	lui	a2,0x2
    800041d2:	963e                	add	a2,a2,a5
    800041d4:	85be                	mv	a1,a5
    800041d6:	855e                	mv	a0,s7
    800041d8:	ffffc097          	auipc	ra,0xffffc
    800041dc:	70a080e7          	jalr	1802(ra) # 800008e2 <uvmalloc>
    800041e0:	8b2a                	mv	s6,a0
  ip = 0;
    800041e2:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800041e4:	12050c63          	beqz	a0,8000431c <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    800041e8:	75f9                	lui	a1,0xffffe
    800041ea:	95aa                	add	a1,a1,a0
    800041ec:	855e                	mv	a0,s7
    800041ee:	ffffd097          	auipc	ra,0xffffd
    800041f2:	91a080e7          	jalr	-1766(ra) # 80000b08 <uvmclear>
  stackbase = sp - PGSIZE;
    800041f6:	7c7d                	lui	s8,0xfffff
    800041f8:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800041fa:	e0043783          	ld	a5,-512(s0)
    800041fe:	6388                	ld	a0,0(a5)
    80004200:	c535                	beqz	a0,8000426c <exec+0x218>
    80004202:	e9040993          	addi	s3,s0,-368
    80004206:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000420a:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000420c:	ffffc097          	auipc	ra,0xffffc
    80004210:	0f0080e7          	jalr	240(ra) # 800002fc <strlen>
    80004214:	2505                	addiw	a0,a0,1
    80004216:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000421a:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000421e:	13896663          	bltu	s2,s8,8000434a <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004222:	e0043d83          	ld	s11,-512(s0)
    80004226:	000dba03          	ld	s4,0(s11)
    8000422a:	8552                	mv	a0,s4
    8000422c:	ffffc097          	auipc	ra,0xffffc
    80004230:	0d0080e7          	jalr	208(ra) # 800002fc <strlen>
    80004234:	0015069b          	addiw	a3,a0,1
    80004238:	8652                	mv	a2,s4
    8000423a:	85ca                	mv	a1,s2
    8000423c:	855e                	mv	a0,s7
    8000423e:	ffffd097          	auipc	ra,0xffffd
    80004242:	8fc080e7          	jalr	-1796(ra) # 80000b3a <copyout>
    80004246:	10054663          	bltz	a0,80004352 <exec+0x2fe>
    ustack[argc] = sp;
    8000424a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000424e:	0485                	addi	s1,s1,1
    80004250:	008d8793          	addi	a5,s11,8
    80004254:	e0f43023          	sd	a5,-512(s0)
    80004258:	008db503          	ld	a0,8(s11)
    8000425c:	c911                	beqz	a0,80004270 <exec+0x21c>
    if(argc >= MAXARG)
    8000425e:	09a1                	addi	s3,s3,8
    80004260:	fb3c96e3          	bne	s9,s3,8000420c <exec+0x1b8>
  sz = sz1;
    80004264:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004268:	4481                	li	s1,0
    8000426a:	a84d                	j	8000431c <exec+0x2c8>
  sp = sz;
    8000426c:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    8000426e:	4481                	li	s1,0
  ustack[argc] = 0;
    80004270:	00349793          	slli	a5,s1,0x3
    80004274:	f9040713          	addi	a4,s0,-112
    80004278:	97ba                	add	a5,a5,a4
    8000427a:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    8000427e:	00148693          	addi	a3,s1,1
    80004282:	068e                	slli	a3,a3,0x3
    80004284:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004288:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000428c:	01897663          	bgeu	s2,s8,80004298 <exec+0x244>
  sz = sz1;
    80004290:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004294:	4481                	li	s1,0
    80004296:	a059                	j	8000431c <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004298:	e9040613          	addi	a2,s0,-368
    8000429c:	85ca                	mv	a1,s2
    8000429e:	855e                	mv	a0,s7
    800042a0:	ffffd097          	auipc	ra,0xffffd
    800042a4:	89a080e7          	jalr	-1894(ra) # 80000b3a <copyout>
    800042a8:	0a054963          	bltz	a0,8000435a <exec+0x306>
  p->trapframe->a1 = sp;
    800042ac:	058ab783          	ld	a5,88(s5)
    800042b0:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800042b4:	df843783          	ld	a5,-520(s0)
    800042b8:	0007c703          	lbu	a4,0(a5)
    800042bc:	cf11                	beqz	a4,800042d8 <exec+0x284>
    800042be:	0785                	addi	a5,a5,1
    if(*s == '/')
    800042c0:	02f00693          	li	a3,47
    800042c4:	a039                	j	800042d2 <exec+0x27e>
      last = s+1;
    800042c6:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800042ca:	0785                	addi	a5,a5,1
    800042cc:	fff7c703          	lbu	a4,-1(a5)
    800042d0:	c701                	beqz	a4,800042d8 <exec+0x284>
    if(*s == '/')
    800042d2:	fed71ce3          	bne	a4,a3,800042ca <exec+0x276>
    800042d6:	bfc5                	j	800042c6 <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    800042d8:	4641                	li	a2,16
    800042da:	df843583          	ld	a1,-520(s0)
    800042de:	158a8513          	addi	a0,s5,344
    800042e2:	ffffc097          	auipc	ra,0xffffc
    800042e6:	fe8080e7          	jalr	-24(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    800042ea:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800042ee:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800042f2:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800042f6:	058ab783          	ld	a5,88(s5)
    800042fa:	e6843703          	ld	a4,-408(s0)
    800042fe:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004300:	058ab783          	ld	a5,88(s5)
    80004304:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004308:	85ea                	mv	a1,s10
    8000430a:	ffffd097          	auipc	ra,0xffffd
    8000430e:	d0a080e7          	jalr	-758(ra) # 80001014 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004312:	0004851b          	sext.w	a0,s1
    80004316:	bbd9                	j	800040ec <exec+0x98>
    80004318:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000431c:	e0843583          	ld	a1,-504(s0)
    80004320:	855e                	mv	a0,s7
    80004322:	ffffd097          	auipc	ra,0xffffd
    80004326:	cf2080e7          	jalr	-782(ra) # 80001014 <proc_freepagetable>
  if(ip){
    8000432a:	da0497e3          	bnez	s1,800040d8 <exec+0x84>
  return -1;
    8000432e:	557d                	li	a0,-1
    80004330:	bb75                	j	800040ec <exec+0x98>
    80004332:	e1443423          	sd	s4,-504(s0)
    80004336:	b7dd                	j	8000431c <exec+0x2c8>
    80004338:	e1443423          	sd	s4,-504(s0)
    8000433c:	b7c5                	j	8000431c <exec+0x2c8>
    8000433e:	e1443423          	sd	s4,-504(s0)
    80004342:	bfe9                	j	8000431c <exec+0x2c8>
    80004344:	e1443423          	sd	s4,-504(s0)
    80004348:	bfd1                	j	8000431c <exec+0x2c8>
  sz = sz1;
    8000434a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000434e:	4481                	li	s1,0
    80004350:	b7f1                	j	8000431c <exec+0x2c8>
  sz = sz1;
    80004352:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004356:	4481                	li	s1,0
    80004358:	b7d1                	j	8000431c <exec+0x2c8>
  sz = sz1;
    8000435a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000435e:	4481                	li	s1,0
    80004360:	bf75                	j	8000431c <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004362:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004366:	2b05                	addiw	s6,s6,1
    80004368:	0389899b          	addiw	s3,s3,56
    8000436c:	e8845783          	lhu	a5,-376(s0)
    80004370:	e2fb57e3          	bge	s6,a5,8000419e <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004374:	2981                	sext.w	s3,s3
    80004376:	03800713          	li	a4,56
    8000437a:	86ce                	mv	a3,s3
    8000437c:	e1840613          	addi	a2,s0,-488
    80004380:	4581                	li	a1,0
    80004382:	8526                	mv	a0,s1
    80004384:	fffff097          	auipc	ra,0xfffff
    80004388:	a6e080e7          	jalr	-1426(ra) # 80002df2 <readi>
    8000438c:	03800793          	li	a5,56
    80004390:	f8f514e3          	bne	a0,a5,80004318 <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    80004394:	e1842783          	lw	a5,-488(s0)
    80004398:	4705                	li	a4,1
    8000439a:	fce796e3          	bne	a5,a4,80004366 <exec+0x312>
    if(ph.memsz < ph.filesz)
    8000439e:	e4043903          	ld	s2,-448(s0)
    800043a2:	e3843783          	ld	a5,-456(s0)
    800043a6:	f8f966e3          	bltu	s2,a5,80004332 <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043aa:	e2843783          	ld	a5,-472(s0)
    800043ae:	993e                	add	s2,s2,a5
    800043b0:	f8f964e3          	bltu	s2,a5,80004338 <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    800043b4:	df043703          	ld	a4,-528(s0)
    800043b8:	8ff9                	and	a5,a5,a4
    800043ba:	f3d1                	bnez	a5,8000433e <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800043bc:	e1c42503          	lw	a0,-484(s0)
    800043c0:	00000097          	auipc	ra,0x0
    800043c4:	c78080e7          	jalr	-904(ra) # 80004038 <flags2perm>
    800043c8:	86aa                	mv	a3,a0
    800043ca:	864a                	mv	a2,s2
    800043cc:	85d2                	mv	a1,s4
    800043ce:	855e                	mv	a0,s7
    800043d0:	ffffc097          	auipc	ra,0xffffc
    800043d4:	512080e7          	jalr	1298(ra) # 800008e2 <uvmalloc>
    800043d8:	e0a43423          	sd	a0,-504(s0)
    800043dc:	d525                	beqz	a0,80004344 <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800043de:	e2843d03          	ld	s10,-472(s0)
    800043e2:	e2042d83          	lw	s11,-480(s0)
    800043e6:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800043ea:	f60c0ce3          	beqz	s8,80004362 <exec+0x30e>
    800043ee:	8a62                	mv	s4,s8
    800043f0:	4901                	li	s2,0
    800043f2:	b369                	j	8000417c <exec+0x128>

00000000800043f4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800043f4:	7179                	addi	sp,sp,-48
    800043f6:	f406                	sd	ra,40(sp)
    800043f8:	f022                	sd	s0,32(sp)
    800043fa:	ec26                	sd	s1,24(sp)
    800043fc:	e84a                	sd	s2,16(sp)
    800043fe:	1800                	addi	s0,sp,48
    80004400:	892e                	mv	s2,a1
    80004402:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004404:	fdc40593          	addi	a1,s0,-36
    80004408:	ffffe097          	auipc	ra,0xffffe
    8000440c:	bbc080e7          	jalr	-1092(ra) # 80001fc4 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004410:	fdc42703          	lw	a4,-36(s0)
    80004414:	47bd                	li	a5,15
    80004416:	02e7eb63          	bltu	a5,a4,8000444c <argfd+0x58>
    8000441a:	ffffd097          	auipc	ra,0xffffd
    8000441e:	a96080e7          	jalr	-1386(ra) # 80000eb0 <myproc>
    80004422:	fdc42703          	lw	a4,-36(s0)
    80004426:	01a70793          	addi	a5,a4,26
    8000442a:	078e                	slli	a5,a5,0x3
    8000442c:	953e                	add	a0,a0,a5
    8000442e:	611c                	ld	a5,0(a0)
    80004430:	c385                	beqz	a5,80004450 <argfd+0x5c>
    return -1;
  if(pfd)
    80004432:	00090463          	beqz	s2,8000443a <argfd+0x46>
    *pfd = fd;
    80004436:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000443a:	4501                	li	a0,0
  if(pf)
    8000443c:	c091                	beqz	s1,80004440 <argfd+0x4c>
    *pf = f;
    8000443e:	e09c                	sd	a5,0(s1)
}
    80004440:	70a2                	ld	ra,40(sp)
    80004442:	7402                	ld	s0,32(sp)
    80004444:	64e2                	ld	s1,24(sp)
    80004446:	6942                	ld	s2,16(sp)
    80004448:	6145                	addi	sp,sp,48
    8000444a:	8082                	ret
    return -1;
    8000444c:	557d                	li	a0,-1
    8000444e:	bfcd                	j	80004440 <argfd+0x4c>
    80004450:	557d                	li	a0,-1
    80004452:	b7fd                	j	80004440 <argfd+0x4c>

0000000080004454 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004454:	1101                	addi	sp,sp,-32
    80004456:	ec06                	sd	ra,24(sp)
    80004458:	e822                	sd	s0,16(sp)
    8000445a:	e426                	sd	s1,8(sp)
    8000445c:	1000                	addi	s0,sp,32
    8000445e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004460:	ffffd097          	auipc	ra,0xffffd
    80004464:	a50080e7          	jalr	-1456(ra) # 80000eb0 <myproc>
    80004468:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000446a:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffdd360>
    8000446e:	4501                	li	a0,0
    80004470:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004472:	6398                	ld	a4,0(a5)
    80004474:	cb19                	beqz	a4,8000448a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004476:	2505                	addiw	a0,a0,1
    80004478:	07a1                	addi	a5,a5,8
    8000447a:	fed51ce3          	bne	a0,a3,80004472 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000447e:	557d                	li	a0,-1
}
    80004480:	60e2                	ld	ra,24(sp)
    80004482:	6442                	ld	s0,16(sp)
    80004484:	64a2                	ld	s1,8(sp)
    80004486:	6105                	addi	sp,sp,32
    80004488:	8082                	ret
      p->ofile[fd] = f;
    8000448a:	01a50793          	addi	a5,a0,26
    8000448e:	078e                	slli	a5,a5,0x3
    80004490:	963e                	add	a2,a2,a5
    80004492:	e204                	sd	s1,0(a2)
      return fd;
    80004494:	b7f5                	j	80004480 <fdalloc+0x2c>

0000000080004496 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004496:	715d                	addi	sp,sp,-80
    80004498:	e486                	sd	ra,72(sp)
    8000449a:	e0a2                	sd	s0,64(sp)
    8000449c:	fc26                	sd	s1,56(sp)
    8000449e:	f84a                	sd	s2,48(sp)
    800044a0:	f44e                	sd	s3,40(sp)
    800044a2:	f052                	sd	s4,32(sp)
    800044a4:	ec56                	sd	s5,24(sp)
    800044a6:	e85a                	sd	s6,16(sp)
    800044a8:	0880                	addi	s0,sp,80
    800044aa:	8b2e                	mv	s6,a1
    800044ac:	89b2                	mv	s3,a2
    800044ae:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800044b0:	fb040593          	addi	a1,s0,-80
    800044b4:	fffff097          	auipc	ra,0xfffff
    800044b8:	e4e080e7          	jalr	-434(ra) # 80003302 <nameiparent>
    800044bc:	84aa                	mv	s1,a0
    800044be:	16050063          	beqz	a0,8000461e <create+0x188>
    return 0;

  ilock(dp);
    800044c2:	ffffe097          	auipc	ra,0xffffe
    800044c6:	67c080e7          	jalr	1660(ra) # 80002b3e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800044ca:	4601                	li	a2,0
    800044cc:	fb040593          	addi	a1,s0,-80
    800044d0:	8526                	mv	a0,s1
    800044d2:	fffff097          	auipc	ra,0xfffff
    800044d6:	b50080e7          	jalr	-1200(ra) # 80003022 <dirlookup>
    800044da:	8aaa                	mv	s5,a0
    800044dc:	c931                	beqz	a0,80004530 <create+0x9a>
    iunlockput(dp);
    800044de:	8526                	mv	a0,s1
    800044e0:	fffff097          	auipc	ra,0xfffff
    800044e4:	8c0080e7          	jalr	-1856(ra) # 80002da0 <iunlockput>
    ilock(ip);
    800044e8:	8556                	mv	a0,s5
    800044ea:	ffffe097          	auipc	ra,0xffffe
    800044ee:	654080e7          	jalr	1620(ra) # 80002b3e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800044f2:	000b059b          	sext.w	a1,s6
    800044f6:	4789                	li	a5,2
    800044f8:	02f59563          	bne	a1,a5,80004522 <create+0x8c>
    800044fc:	044ad783          	lhu	a5,68(s5)
    80004500:	37f9                	addiw	a5,a5,-2
    80004502:	17c2                	slli	a5,a5,0x30
    80004504:	93c1                	srli	a5,a5,0x30
    80004506:	4705                	li	a4,1
    80004508:	00f76d63          	bltu	a4,a5,80004522 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000450c:	8556                	mv	a0,s5
    8000450e:	60a6                	ld	ra,72(sp)
    80004510:	6406                	ld	s0,64(sp)
    80004512:	74e2                	ld	s1,56(sp)
    80004514:	7942                	ld	s2,48(sp)
    80004516:	79a2                	ld	s3,40(sp)
    80004518:	7a02                	ld	s4,32(sp)
    8000451a:	6ae2                	ld	s5,24(sp)
    8000451c:	6b42                	ld	s6,16(sp)
    8000451e:	6161                	addi	sp,sp,80
    80004520:	8082                	ret
    iunlockput(ip);
    80004522:	8556                	mv	a0,s5
    80004524:	fffff097          	auipc	ra,0xfffff
    80004528:	87c080e7          	jalr	-1924(ra) # 80002da0 <iunlockput>
    return 0;
    8000452c:	4a81                	li	s5,0
    8000452e:	bff9                	j	8000450c <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004530:	85da                	mv	a1,s6
    80004532:	4088                	lw	a0,0(s1)
    80004534:	ffffe097          	auipc	ra,0xffffe
    80004538:	46e080e7          	jalr	1134(ra) # 800029a2 <ialloc>
    8000453c:	8a2a                	mv	s4,a0
    8000453e:	c921                	beqz	a0,8000458e <create+0xf8>
  ilock(ip);
    80004540:	ffffe097          	auipc	ra,0xffffe
    80004544:	5fe080e7          	jalr	1534(ra) # 80002b3e <ilock>
  ip->major = major;
    80004548:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000454c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004550:	4785                	li	a5,1
    80004552:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    80004556:	8552                	mv	a0,s4
    80004558:	ffffe097          	auipc	ra,0xffffe
    8000455c:	51c080e7          	jalr	1308(ra) # 80002a74 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004560:	000b059b          	sext.w	a1,s6
    80004564:	4785                	li	a5,1
    80004566:	02f58b63          	beq	a1,a5,8000459c <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    8000456a:	004a2603          	lw	a2,4(s4)
    8000456e:	fb040593          	addi	a1,s0,-80
    80004572:	8526                	mv	a0,s1
    80004574:	fffff097          	auipc	ra,0xfffff
    80004578:	cbe080e7          	jalr	-834(ra) # 80003232 <dirlink>
    8000457c:	06054f63          	bltz	a0,800045fa <create+0x164>
  iunlockput(dp);
    80004580:	8526                	mv	a0,s1
    80004582:	fffff097          	auipc	ra,0xfffff
    80004586:	81e080e7          	jalr	-2018(ra) # 80002da0 <iunlockput>
  return ip;
    8000458a:	8ad2                	mv	s5,s4
    8000458c:	b741                	j	8000450c <create+0x76>
    iunlockput(dp);
    8000458e:	8526                	mv	a0,s1
    80004590:	fffff097          	auipc	ra,0xfffff
    80004594:	810080e7          	jalr	-2032(ra) # 80002da0 <iunlockput>
    return 0;
    80004598:	8ad2                	mv	s5,s4
    8000459a:	bf8d                	j	8000450c <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000459c:	004a2603          	lw	a2,4(s4)
    800045a0:	00004597          	auipc	a1,0x4
    800045a4:	11058593          	addi	a1,a1,272 # 800086b0 <syscalls+0x2a0>
    800045a8:	8552                	mv	a0,s4
    800045aa:	fffff097          	auipc	ra,0xfffff
    800045ae:	c88080e7          	jalr	-888(ra) # 80003232 <dirlink>
    800045b2:	04054463          	bltz	a0,800045fa <create+0x164>
    800045b6:	40d0                	lw	a2,4(s1)
    800045b8:	00004597          	auipc	a1,0x4
    800045bc:	10058593          	addi	a1,a1,256 # 800086b8 <syscalls+0x2a8>
    800045c0:	8552                	mv	a0,s4
    800045c2:	fffff097          	auipc	ra,0xfffff
    800045c6:	c70080e7          	jalr	-912(ra) # 80003232 <dirlink>
    800045ca:	02054863          	bltz	a0,800045fa <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    800045ce:	004a2603          	lw	a2,4(s4)
    800045d2:	fb040593          	addi	a1,s0,-80
    800045d6:	8526                	mv	a0,s1
    800045d8:	fffff097          	auipc	ra,0xfffff
    800045dc:	c5a080e7          	jalr	-934(ra) # 80003232 <dirlink>
    800045e0:	00054d63          	bltz	a0,800045fa <create+0x164>
    dp->nlink++;  // for ".."
    800045e4:	04a4d783          	lhu	a5,74(s1)
    800045e8:	2785                	addiw	a5,a5,1
    800045ea:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800045ee:	8526                	mv	a0,s1
    800045f0:	ffffe097          	auipc	ra,0xffffe
    800045f4:	484080e7          	jalr	1156(ra) # 80002a74 <iupdate>
    800045f8:	b761                	j	80004580 <create+0xea>
  ip->nlink = 0;
    800045fa:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800045fe:	8552                	mv	a0,s4
    80004600:	ffffe097          	auipc	ra,0xffffe
    80004604:	474080e7          	jalr	1140(ra) # 80002a74 <iupdate>
  iunlockput(ip);
    80004608:	8552                	mv	a0,s4
    8000460a:	ffffe097          	auipc	ra,0xffffe
    8000460e:	796080e7          	jalr	1942(ra) # 80002da0 <iunlockput>
  iunlockput(dp);
    80004612:	8526                	mv	a0,s1
    80004614:	ffffe097          	auipc	ra,0xffffe
    80004618:	78c080e7          	jalr	1932(ra) # 80002da0 <iunlockput>
  return 0;
    8000461c:	bdc5                	j	8000450c <create+0x76>
    return 0;
    8000461e:	8aaa                	mv	s5,a0
    80004620:	b5f5                	j	8000450c <create+0x76>

0000000080004622 <sys_dup>:
{
    80004622:	7179                	addi	sp,sp,-48
    80004624:	f406                	sd	ra,40(sp)
    80004626:	f022                	sd	s0,32(sp)
    80004628:	ec26                	sd	s1,24(sp)
    8000462a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000462c:	fd840613          	addi	a2,s0,-40
    80004630:	4581                	li	a1,0
    80004632:	4501                	li	a0,0
    80004634:	00000097          	auipc	ra,0x0
    80004638:	dc0080e7          	jalr	-576(ra) # 800043f4 <argfd>
    return -1;
    8000463c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000463e:	02054363          	bltz	a0,80004664 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004642:	fd843503          	ld	a0,-40(s0)
    80004646:	00000097          	auipc	ra,0x0
    8000464a:	e0e080e7          	jalr	-498(ra) # 80004454 <fdalloc>
    8000464e:	84aa                	mv	s1,a0
    return -1;
    80004650:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004652:	00054963          	bltz	a0,80004664 <sys_dup+0x42>
  filedup(f);
    80004656:	fd843503          	ld	a0,-40(s0)
    8000465a:	fffff097          	auipc	ra,0xfffff
    8000465e:	320080e7          	jalr	800(ra) # 8000397a <filedup>
  return fd;
    80004662:	87a6                	mv	a5,s1
}
    80004664:	853e                	mv	a0,a5
    80004666:	70a2                	ld	ra,40(sp)
    80004668:	7402                	ld	s0,32(sp)
    8000466a:	64e2                	ld	s1,24(sp)
    8000466c:	6145                	addi	sp,sp,48
    8000466e:	8082                	ret

0000000080004670 <sys_read>:
{
    80004670:	7179                	addi	sp,sp,-48
    80004672:	f406                	sd	ra,40(sp)
    80004674:	f022                	sd	s0,32(sp)
    80004676:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004678:	fd840593          	addi	a1,s0,-40
    8000467c:	4505                	li	a0,1
    8000467e:	ffffe097          	auipc	ra,0xffffe
    80004682:	966080e7          	jalr	-1690(ra) # 80001fe4 <argaddr>
  argint(2, &n);
    80004686:	fe440593          	addi	a1,s0,-28
    8000468a:	4509                	li	a0,2
    8000468c:	ffffe097          	auipc	ra,0xffffe
    80004690:	938080e7          	jalr	-1736(ra) # 80001fc4 <argint>
  if(argfd(0, 0, &f) < 0)
    80004694:	fe840613          	addi	a2,s0,-24
    80004698:	4581                	li	a1,0
    8000469a:	4501                	li	a0,0
    8000469c:	00000097          	auipc	ra,0x0
    800046a0:	d58080e7          	jalr	-680(ra) # 800043f4 <argfd>
    800046a4:	87aa                	mv	a5,a0
    return -1;
    800046a6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800046a8:	0007cc63          	bltz	a5,800046c0 <sys_read+0x50>
  return fileread(f, p, n);
    800046ac:	fe442603          	lw	a2,-28(s0)
    800046b0:	fd843583          	ld	a1,-40(s0)
    800046b4:	fe843503          	ld	a0,-24(s0)
    800046b8:	fffff097          	auipc	ra,0xfffff
    800046bc:	44e080e7          	jalr	1102(ra) # 80003b06 <fileread>
}
    800046c0:	70a2                	ld	ra,40(sp)
    800046c2:	7402                	ld	s0,32(sp)
    800046c4:	6145                	addi	sp,sp,48
    800046c6:	8082                	ret

00000000800046c8 <sys_write>:
{
    800046c8:	7179                	addi	sp,sp,-48
    800046ca:	f406                	sd	ra,40(sp)
    800046cc:	f022                	sd	s0,32(sp)
    800046ce:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800046d0:	fd840593          	addi	a1,s0,-40
    800046d4:	4505                	li	a0,1
    800046d6:	ffffe097          	auipc	ra,0xffffe
    800046da:	90e080e7          	jalr	-1778(ra) # 80001fe4 <argaddr>
  argint(2, &n);
    800046de:	fe440593          	addi	a1,s0,-28
    800046e2:	4509                	li	a0,2
    800046e4:	ffffe097          	auipc	ra,0xffffe
    800046e8:	8e0080e7          	jalr	-1824(ra) # 80001fc4 <argint>
  if(argfd(0, 0, &f) < 0)
    800046ec:	fe840613          	addi	a2,s0,-24
    800046f0:	4581                	li	a1,0
    800046f2:	4501                	li	a0,0
    800046f4:	00000097          	auipc	ra,0x0
    800046f8:	d00080e7          	jalr	-768(ra) # 800043f4 <argfd>
    800046fc:	87aa                	mv	a5,a0
    return -1;
    800046fe:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004700:	0007cc63          	bltz	a5,80004718 <sys_write+0x50>
  return filewrite(f, p, n);
    80004704:	fe442603          	lw	a2,-28(s0)
    80004708:	fd843583          	ld	a1,-40(s0)
    8000470c:	fe843503          	ld	a0,-24(s0)
    80004710:	fffff097          	auipc	ra,0xfffff
    80004714:	4b8080e7          	jalr	1208(ra) # 80003bc8 <filewrite>
}
    80004718:	70a2                	ld	ra,40(sp)
    8000471a:	7402                	ld	s0,32(sp)
    8000471c:	6145                	addi	sp,sp,48
    8000471e:	8082                	ret

0000000080004720 <sys_close>:
{
    80004720:	1101                	addi	sp,sp,-32
    80004722:	ec06                	sd	ra,24(sp)
    80004724:	e822                	sd	s0,16(sp)
    80004726:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004728:	fe040613          	addi	a2,s0,-32
    8000472c:	fec40593          	addi	a1,s0,-20
    80004730:	4501                	li	a0,0
    80004732:	00000097          	auipc	ra,0x0
    80004736:	cc2080e7          	jalr	-830(ra) # 800043f4 <argfd>
    return -1;
    8000473a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000473c:	02054463          	bltz	a0,80004764 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004740:	ffffc097          	auipc	ra,0xffffc
    80004744:	770080e7          	jalr	1904(ra) # 80000eb0 <myproc>
    80004748:	fec42783          	lw	a5,-20(s0)
    8000474c:	07e9                	addi	a5,a5,26
    8000474e:	078e                	slli	a5,a5,0x3
    80004750:	97aa                	add	a5,a5,a0
    80004752:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004756:	fe043503          	ld	a0,-32(s0)
    8000475a:	fffff097          	auipc	ra,0xfffff
    8000475e:	272080e7          	jalr	626(ra) # 800039cc <fileclose>
  return 0;
    80004762:	4781                	li	a5,0
}
    80004764:	853e                	mv	a0,a5
    80004766:	60e2                	ld	ra,24(sp)
    80004768:	6442                	ld	s0,16(sp)
    8000476a:	6105                	addi	sp,sp,32
    8000476c:	8082                	ret

000000008000476e <sys_fstat>:
{
    8000476e:	1101                	addi	sp,sp,-32
    80004770:	ec06                	sd	ra,24(sp)
    80004772:	e822                	sd	s0,16(sp)
    80004774:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004776:	fe040593          	addi	a1,s0,-32
    8000477a:	4505                	li	a0,1
    8000477c:	ffffe097          	auipc	ra,0xffffe
    80004780:	868080e7          	jalr	-1944(ra) # 80001fe4 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004784:	fe840613          	addi	a2,s0,-24
    80004788:	4581                	li	a1,0
    8000478a:	4501                	li	a0,0
    8000478c:	00000097          	auipc	ra,0x0
    80004790:	c68080e7          	jalr	-920(ra) # 800043f4 <argfd>
    80004794:	87aa                	mv	a5,a0
    return -1;
    80004796:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004798:	0007ca63          	bltz	a5,800047ac <sys_fstat+0x3e>
  return filestat(f, st);
    8000479c:	fe043583          	ld	a1,-32(s0)
    800047a0:	fe843503          	ld	a0,-24(s0)
    800047a4:	fffff097          	auipc	ra,0xfffff
    800047a8:	2f0080e7          	jalr	752(ra) # 80003a94 <filestat>
}
    800047ac:	60e2                	ld	ra,24(sp)
    800047ae:	6442                	ld	s0,16(sp)
    800047b0:	6105                	addi	sp,sp,32
    800047b2:	8082                	ret

00000000800047b4 <sys_link>:
{
    800047b4:	7169                	addi	sp,sp,-304
    800047b6:	f606                	sd	ra,296(sp)
    800047b8:	f222                	sd	s0,288(sp)
    800047ba:	ee26                	sd	s1,280(sp)
    800047bc:	ea4a                	sd	s2,272(sp)
    800047be:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047c0:	08000613          	li	a2,128
    800047c4:	ed040593          	addi	a1,s0,-304
    800047c8:	4501                	li	a0,0
    800047ca:	ffffe097          	auipc	ra,0xffffe
    800047ce:	83a080e7          	jalr	-1990(ra) # 80002004 <argstr>
    return -1;
    800047d2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047d4:	10054e63          	bltz	a0,800048f0 <sys_link+0x13c>
    800047d8:	08000613          	li	a2,128
    800047dc:	f5040593          	addi	a1,s0,-176
    800047e0:	4505                	li	a0,1
    800047e2:	ffffe097          	auipc	ra,0xffffe
    800047e6:	822080e7          	jalr	-2014(ra) # 80002004 <argstr>
    return -1;
    800047ea:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047ec:	10054263          	bltz	a0,800048f0 <sys_link+0x13c>
  begin_op();
    800047f0:	fffff097          	auipc	ra,0xfffff
    800047f4:	d10080e7          	jalr	-752(ra) # 80003500 <begin_op>
  if((ip = namei(old)) == 0){
    800047f8:	ed040513          	addi	a0,s0,-304
    800047fc:	fffff097          	auipc	ra,0xfffff
    80004800:	ae8080e7          	jalr	-1304(ra) # 800032e4 <namei>
    80004804:	84aa                	mv	s1,a0
    80004806:	c551                	beqz	a0,80004892 <sys_link+0xde>
  ilock(ip);
    80004808:	ffffe097          	auipc	ra,0xffffe
    8000480c:	336080e7          	jalr	822(ra) # 80002b3e <ilock>
  if(ip->type == T_DIR){
    80004810:	04449703          	lh	a4,68(s1)
    80004814:	4785                	li	a5,1
    80004816:	08f70463          	beq	a4,a5,8000489e <sys_link+0xea>
  ip->nlink++;
    8000481a:	04a4d783          	lhu	a5,74(s1)
    8000481e:	2785                	addiw	a5,a5,1
    80004820:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004824:	8526                	mv	a0,s1
    80004826:	ffffe097          	auipc	ra,0xffffe
    8000482a:	24e080e7          	jalr	590(ra) # 80002a74 <iupdate>
  iunlock(ip);
    8000482e:	8526                	mv	a0,s1
    80004830:	ffffe097          	auipc	ra,0xffffe
    80004834:	3d0080e7          	jalr	976(ra) # 80002c00 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004838:	fd040593          	addi	a1,s0,-48
    8000483c:	f5040513          	addi	a0,s0,-176
    80004840:	fffff097          	auipc	ra,0xfffff
    80004844:	ac2080e7          	jalr	-1342(ra) # 80003302 <nameiparent>
    80004848:	892a                	mv	s2,a0
    8000484a:	c935                	beqz	a0,800048be <sys_link+0x10a>
  ilock(dp);
    8000484c:	ffffe097          	auipc	ra,0xffffe
    80004850:	2f2080e7          	jalr	754(ra) # 80002b3e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004854:	00092703          	lw	a4,0(s2)
    80004858:	409c                	lw	a5,0(s1)
    8000485a:	04f71d63          	bne	a4,a5,800048b4 <sys_link+0x100>
    8000485e:	40d0                	lw	a2,4(s1)
    80004860:	fd040593          	addi	a1,s0,-48
    80004864:	854a                	mv	a0,s2
    80004866:	fffff097          	auipc	ra,0xfffff
    8000486a:	9cc080e7          	jalr	-1588(ra) # 80003232 <dirlink>
    8000486e:	04054363          	bltz	a0,800048b4 <sys_link+0x100>
  iunlockput(dp);
    80004872:	854a                	mv	a0,s2
    80004874:	ffffe097          	auipc	ra,0xffffe
    80004878:	52c080e7          	jalr	1324(ra) # 80002da0 <iunlockput>
  iput(ip);
    8000487c:	8526                	mv	a0,s1
    8000487e:	ffffe097          	auipc	ra,0xffffe
    80004882:	47a080e7          	jalr	1146(ra) # 80002cf8 <iput>
  end_op();
    80004886:	fffff097          	auipc	ra,0xfffff
    8000488a:	cfa080e7          	jalr	-774(ra) # 80003580 <end_op>
  return 0;
    8000488e:	4781                	li	a5,0
    80004890:	a085                	j	800048f0 <sys_link+0x13c>
    end_op();
    80004892:	fffff097          	auipc	ra,0xfffff
    80004896:	cee080e7          	jalr	-786(ra) # 80003580 <end_op>
    return -1;
    8000489a:	57fd                	li	a5,-1
    8000489c:	a891                	j	800048f0 <sys_link+0x13c>
    iunlockput(ip);
    8000489e:	8526                	mv	a0,s1
    800048a0:	ffffe097          	auipc	ra,0xffffe
    800048a4:	500080e7          	jalr	1280(ra) # 80002da0 <iunlockput>
    end_op();
    800048a8:	fffff097          	auipc	ra,0xfffff
    800048ac:	cd8080e7          	jalr	-808(ra) # 80003580 <end_op>
    return -1;
    800048b0:	57fd                	li	a5,-1
    800048b2:	a83d                	j	800048f0 <sys_link+0x13c>
    iunlockput(dp);
    800048b4:	854a                	mv	a0,s2
    800048b6:	ffffe097          	auipc	ra,0xffffe
    800048ba:	4ea080e7          	jalr	1258(ra) # 80002da0 <iunlockput>
  ilock(ip);
    800048be:	8526                	mv	a0,s1
    800048c0:	ffffe097          	auipc	ra,0xffffe
    800048c4:	27e080e7          	jalr	638(ra) # 80002b3e <ilock>
  ip->nlink--;
    800048c8:	04a4d783          	lhu	a5,74(s1)
    800048cc:	37fd                	addiw	a5,a5,-1
    800048ce:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048d2:	8526                	mv	a0,s1
    800048d4:	ffffe097          	auipc	ra,0xffffe
    800048d8:	1a0080e7          	jalr	416(ra) # 80002a74 <iupdate>
  iunlockput(ip);
    800048dc:	8526                	mv	a0,s1
    800048de:	ffffe097          	auipc	ra,0xffffe
    800048e2:	4c2080e7          	jalr	1218(ra) # 80002da0 <iunlockput>
  end_op();
    800048e6:	fffff097          	auipc	ra,0xfffff
    800048ea:	c9a080e7          	jalr	-870(ra) # 80003580 <end_op>
  return -1;
    800048ee:	57fd                	li	a5,-1
}
    800048f0:	853e                	mv	a0,a5
    800048f2:	70b2                	ld	ra,296(sp)
    800048f4:	7412                	ld	s0,288(sp)
    800048f6:	64f2                	ld	s1,280(sp)
    800048f8:	6952                	ld	s2,272(sp)
    800048fa:	6155                	addi	sp,sp,304
    800048fc:	8082                	ret

00000000800048fe <sys_unlink>:
{
    800048fe:	7151                	addi	sp,sp,-240
    80004900:	f586                	sd	ra,232(sp)
    80004902:	f1a2                	sd	s0,224(sp)
    80004904:	eda6                	sd	s1,216(sp)
    80004906:	e9ca                	sd	s2,208(sp)
    80004908:	e5ce                	sd	s3,200(sp)
    8000490a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000490c:	08000613          	li	a2,128
    80004910:	f3040593          	addi	a1,s0,-208
    80004914:	4501                	li	a0,0
    80004916:	ffffd097          	auipc	ra,0xffffd
    8000491a:	6ee080e7          	jalr	1774(ra) # 80002004 <argstr>
    8000491e:	18054163          	bltz	a0,80004aa0 <sys_unlink+0x1a2>
  begin_op();
    80004922:	fffff097          	auipc	ra,0xfffff
    80004926:	bde080e7          	jalr	-1058(ra) # 80003500 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000492a:	fb040593          	addi	a1,s0,-80
    8000492e:	f3040513          	addi	a0,s0,-208
    80004932:	fffff097          	auipc	ra,0xfffff
    80004936:	9d0080e7          	jalr	-1584(ra) # 80003302 <nameiparent>
    8000493a:	84aa                	mv	s1,a0
    8000493c:	c979                	beqz	a0,80004a12 <sys_unlink+0x114>
  ilock(dp);
    8000493e:	ffffe097          	auipc	ra,0xffffe
    80004942:	200080e7          	jalr	512(ra) # 80002b3e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004946:	00004597          	auipc	a1,0x4
    8000494a:	d6a58593          	addi	a1,a1,-662 # 800086b0 <syscalls+0x2a0>
    8000494e:	fb040513          	addi	a0,s0,-80
    80004952:	ffffe097          	auipc	ra,0xffffe
    80004956:	6b6080e7          	jalr	1718(ra) # 80003008 <namecmp>
    8000495a:	14050a63          	beqz	a0,80004aae <sys_unlink+0x1b0>
    8000495e:	00004597          	auipc	a1,0x4
    80004962:	d5a58593          	addi	a1,a1,-678 # 800086b8 <syscalls+0x2a8>
    80004966:	fb040513          	addi	a0,s0,-80
    8000496a:	ffffe097          	auipc	ra,0xffffe
    8000496e:	69e080e7          	jalr	1694(ra) # 80003008 <namecmp>
    80004972:	12050e63          	beqz	a0,80004aae <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004976:	f2c40613          	addi	a2,s0,-212
    8000497a:	fb040593          	addi	a1,s0,-80
    8000497e:	8526                	mv	a0,s1
    80004980:	ffffe097          	auipc	ra,0xffffe
    80004984:	6a2080e7          	jalr	1698(ra) # 80003022 <dirlookup>
    80004988:	892a                	mv	s2,a0
    8000498a:	12050263          	beqz	a0,80004aae <sys_unlink+0x1b0>
  ilock(ip);
    8000498e:	ffffe097          	auipc	ra,0xffffe
    80004992:	1b0080e7          	jalr	432(ra) # 80002b3e <ilock>
  if(ip->nlink < 1)
    80004996:	04a91783          	lh	a5,74(s2)
    8000499a:	08f05263          	blez	a5,80004a1e <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000499e:	04491703          	lh	a4,68(s2)
    800049a2:	4785                	li	a5,1
    800049a4:	08f70563          	beq	a4,a5,80004a2e <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800049a8:	4641                	li	a2,16
    800049aa:	4581                	li	a1,0
    800049ac:	fc040513          	addi	a0,s0,-64
    800049b0:	ffffb097          	auipc	ra,0xffffb
    800049b4:	7c8080e7          	jalr	1992(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049b8:	4741                	li	a4,16
    800049ba:	f2c42683          	lw	a3,-212(s0)
    800049be:	fc040613          	addi	a2,s0,-64
    800049c2:	4581                	li	a1,0
    800049c4:	8526                	mv	a0,s1
    800049c6:	ffffe097          	auipc	ra,0xffffe
    800049ca:	524080e7          	jalr	1316(ra) # 80002eea <writei>
    800049ce:	47c1                	li	a5,16
    800049d0:	0af51563          	bne	a0,a5,80004a7a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800049d4:	04491703          	lh	a4,68(s2)
    800049d8:	4785                	li	a5,1
    800049da:	0af70863          	beq	a4,a5,80004a8a <sys_unlink+0x18c>
  iunlockput(dp);
    800049de:	8526                	mv	a0,s1
    800049e0:	ffffe097          	auipc	ra,0xffffe
    800049e4:	3c0080e7          	jalr	960(ra) # 80002da0 <iunlockput>
  ip->nlink--;
    800049e8:	04a95783          	lhu	a5,74(s2)
    800049ec:	37fd                	addiw	a5,a5,-1
    800049ee:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800049f2:	854a                	mv	a0,s2
    800049f4:	ffffe097          	auipc	ra,0xffffe
    800049f8:	080080e7          	jalr	128(ra) # 80002a74 <iupdate>
  iunlockput(ip);
    800049fc:	854a                	mv	a0,s2
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	3a2080e7          	jalr	930(ra) # 80002da0 <iunlockput>
  end_op();
    80004a06:	fffff097          	auipc	ra,0xfffff
    80004a0a:	b7a080e7          	jalr	-1158(ra) # 80003580 <end_op>
  return 0;
    80004a0e:	4501                	li	a0,0
    80004a10:	a84d                	j	80004ac2 <sys_unlink+0x1c4>
    end_op();
    80004a12:	fffff097          	auipc	ra,0xfffff
    80004a16:	b6e080e7          	jalr	-1170(ra) # 80003580 <end_op>
    return -1;
    80004a1a:	557d                	li	a0,-1
    80004a1c:	a05d                	j	80004ac2 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a1e:	00004517          	auipc	a0,0x4
    80004a22:	ca250513          	addi	a0,a0,-862 # 800086c0 <syscalls+0x2b0>
    80004a26:	00001097          	auipc	ra,0x1
    80004a2a:	21c080e7          	jalr	540(ra) # 80005c42 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a2e:	04c92703          	lw	a4,76(s2)
    80004a32:	02000793          	li	a5,32
    80004a36:	f6e7f9e3          	bgeu	a5,a4,800049a8 <sys_unlink+0xaa>
    80004a3a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a3e:	4741                	li	a4,16
    80004a40:	86ce                	mv	a3,s3
    80004a42:	f1840613          	addi	a2,s0,-232
    80004a46:	4581                	li	a1,0
    80004a48:	854a                	mv	a0,s2
    80004a4a:	ffffe097          	auipc	ra,0xffffe
    80004a4e:	3a8080e7          	jalr	936(ra) # 80002df2 <readi>
    80004a52:	47c1                	li	a5,16
    80004a54:	00f51b63          	bne	a0,a5,80004a6a <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a58:	f1845783          	lhu	a5,-232(s0)
    80004a5c:	e7a1                	bnez	a5,80004aa4 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a5e:	29c1                	addiw	s3,s3,16
    80004a60:	04c92783          	lw	a5,76(s2)
    80004a64:	fcf9ede3          	bltu	s3,a5,80004a3e <sys_unlink+0x140>
    80004a68:	b781                	j	800049a8 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a6a:	00004517          	auipc	a0,0x4
    80004a6e:	c6e50513          	addi	a0,a0,-914 # 800086d8 <syscalls+0x2c8>
    80004a72:	00001097          	auipc	ra,0x1
    80004a76:	1d0080e7          	jalr	464(ra) # 80005c42 <panic>
    panic("unlink: writei");
    80004a7a:	00004517          	auipc	a0,0x4
    80004a7e:	c7650513          	addi	a0,a0,-906 # 800086f0 <syscalls+0x2e0>
    80004a82:	00001097          	auipc	ra,0x1
    80004a86:	1c0080e7          	jalr	448(ra) # 80005c42 <panic>
    dp->nlink--;
    80004a8a:	04a4d783          	lhu	a5,74(s1)
    80004a8e:	37fd                	addiw	a5,a5,-1
    80004a90:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a94:	8526                	mv	a0,s1
    80004a96:	ffffe097          	auipc	ra,0xffffe
    80004a9a:	fde080e7          	jalr	-34(ra) # 80002a74 <iupdate>
    80004a9e:	b781                	j	800049de <sys_unlink+0xe0>
    return -1;
    80004aa0:	557d                	li	a0,-1
    80004aa2:	a005                	j	80004ac2 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004aa4:	854a                	mv	a0,s2
    80004aa6:	ffffe097          	auipc	ra,0xffffe
    80004aaa:	2fa080e7          	jalr	762(ra) # 80002da0 <iunlockput>
  iunlockput(dp);
    80004aae:	8526                	mv	a0,s1
    80004ab0:	ffffe097          	auipc	ra,0xffffe
    80004ab4:	2f0080e7          	jalr	752(ra) # 80002da0 <iunlockput>
  end_op();
    80004ab8:	fffff097          	auipc	ra,0xfffff
    80004abc:	ac8080e7          	jalr	-1336(ra) # 80003580 <end_op>
  return -1;
    80004ac0:	557d                	li	a0,-1
}
    80004ac2:	70ae                	ld	ra,232(sp)
    80004ac4:	740e                	ld	s0,224(sp)
    80004ac6:	64ee                	ld	s1,216(sp)
    80004ac8:	694e                	ld	s2,208(sp)
    80004aca:	69ae                	ld	s3,200(sp)
    80004acc:	616d                	addi	sp,sp,240
    80004ace:	8082                	ret

0000000080004ad0 <sys_open>:

uint64
sys_open(void)
{
    80004ad0:	7131                	addi	sp,sp,-192
    80004ad2:	fd06                	sd	ra,184(sp)
    80004ad4:	f922                	sd	s0,176(sp)
    80004ad6:	f526                	sd	s1,168(sp)
    80004ad8:	f14a                	sd	s2,160(sp)
    80004ada:	ed4e                	sd	s3,152(sp)
    80004adc:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004ade:	f4c40593          	addi	a1,s0,-180
    80004ae2:	4505                	li	a0,1
    80004ae4:	ffffd097          	auipc	ra,0xffffd
    80004ae8:	4e0080e7          	jalr	1248(ra) # 80001fc4 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004aec:	08000613          	li	a2,128
    80004af0:	f5040593          	addi	a1,s0,-176
    80004af4:	4501                	li	a0,0
    80004af6:	ffffd097          	auipc	ra,0xffffd
    80004afa:	50e080e7          	jalr	1294(ra) # 80002004 <argstr>
    80004afe:	87aa                	mv	a5,a0
    return -1;
    80004b00:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b02:	0a07c963          	bltz	a5,80004bb4 <sys_open+0xe4>

  begin_op();
    80004b06:	fffff097          	auipc	ra,0xfffff
    80004b0a:	9fa080e7          	jalr	-1542(ra) # 80003500 <begin_op>

  if(omode & O_CREATE){
    80004b0e:	f4c42783          	lw	a5,-180(s0)
    80004b12:	2007f793          	andi	a5,a5,512
    80004b16:	cfc5                	beqz	a5,80004bce <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b18:	4681                	li	a3,0
    80004b1a:	4601                	li	a2,0
    80004b1c:	4589                	li	a1,2
    80004b1e:	f5040513          	addi	a0,s0,-176
    80004b22:	00000097          	auipc	ra,0x0
    80004b26:	974080e7          	jalr	-1676(ra) # 80004496 <create>
    80004b2a:	84aa                	mv	s1,a0
    if(ip == 0){
    80004b2c:	c959                	beqz	a0,80004bc2 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b2e:	04449703          	lh	a4,68(s1)
    80004b32:	478d                	li	a5,3
    80004b34:	00f71763          	bne	a4,a5,80004b42 <sys_open+0x72>
    80004b38:	0464d703          	lhu	a4,70(s1)
    80004b3c:	47a5                	li	a5,9
    80004b3e:	0ce7ed63          	bltu	a5,a4,80004c18 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b42:	fffff097          	auipc	ra,0xfffff
    80004b46:	dce080e7          	jalr	-562(ra) # 80003910 <filealloc>
    80004b4a:	89aa                	mv	s3,a0
    80004b4c:	10050363          	beqz	a0,80004c52 <sys_open+0x182>
    80004b50:	00000097          	auipc	ra,0x0
    80004b54:	904080e7          	jalr	-1788(ra) # 80004454 <fdalloc>
    80004b58:	892a                	mv	s2,a0
    80004b5a:	0e054763          	bltz	a0,80004c48 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b5e:	04449703          	lh	a4,68(s1)
    80004b62:	478d                	li	a5,3
    80004b64:	0cf70563          	beq	a4,a5,80004c2e <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b68:	4789                	li	a5,2
    80004b6a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b6e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004b72:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b76:	f4c42783          	lw	a5,-180(s0)
    80004b7a:	0017c713          	xori	a4,a5,1
    80004b7e:	8b05                	andi	a4,a4,1
    80004b80:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b84:	0037f713          	andi	a4,a5,3
    80004b88:	00e03733          	snez	a4,a4
    80004b8c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b90:	4007f793          	andi	a5,a5,1024
    80004b94:	c791                	beqz	a5,80004ba0 <sys_open+0xd0>
    80004b96:	04449703          	lh	a4,68(s1)
    80004b9a:	4789                	li	a5,2
    80004b9c:	0af70063          	beq	a4,a5,80004c3c <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004ba0:	8526                	mv	a0,s1
    80004ba2:	ffffe097          	auipc	ra,0xffffe
    80004ba6:	05e080e7          	jalr	94(ra) # 80002c00 <iunlock>
  end_op();
    80004baa:	fffff097          	auipc	ra,0xfffff
    80004bae:	9d6080e7          	jalr	-1578(ra) # 80003580 <end_op>

  return fd;
    80004bb2:	854a                	mv	a0,s2
}
    80004bb4:	70ea                	ld	ra,184(sp)
    80004bb6:	744a                	ld	s0,176(sp)
    80004bb8:	74aa                	ld	s1,168(sp)
    80004bba:	790a                	ld	s2,160(sp)
    80004bbc:	69ea                	ld	s3,152(sp)
    80004bbe:	6129                	addi	sp,sp,192
    80004bc0:	8082                	ret
      end_op();
    80004bc2:	fffff097          	auipc	ra,0xfffff
    80004bc6:	9be080e7          	jalr	-1602(ra) # 80003580 <end_op>
      return -1;
    80004bca:	557d                	li	a0,-1
    80004bcc:	b7e5                	j	80004bb4 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004bce:	f5040513          	addi	a0,s0,-176
    80004bd2:	ffffe097          	auipc	ra,0xffffe
    80004bd6:	712080e7          	jalr	1810(ra) # 800032e4 <namei>
    80004bda:	84aa                	mv	s1,a0
    80004bdc:	c905                	beqz	a0,80004c0c <sys_open+0x13c>
    ilock(ip);
    80004bde:	ffffe097          	auipc	ra,0xffffe
    80004be2:	f60080e7          	jalr	-160(ra) # 80002b3e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004be6:	04449703          	lh	a4,68(s1)
    80004bea:	4785                	li	a5,1
    80004bec:	f4f711e3          	bne	a4,a5,80004b2e <sys_open+0x5e>
    80004bf0:	f4c42783          	lw	a5,-180(s0)
    80004bf4:	d7b9                	beqz	a5,80004b42 <sys_open+0x72>
      iunlockput(ip);
    80004bf6:	8526                	mv	a0,s1
    80004bf8:	ffffe097          	auipc	ra,0xffffe
    80004bfc:	1a8080e7          	jalr	424(ra) # 80002da0 <iunlockput>
      end_op();
    80004c00:	fffff097          	auipc	ra,0xfffff
    80004c04:	980080e7          	jalr	-1664(ra) # 80003580 <end_op>
      return -1;
    80004c08:	557d                	li	a0,-1
    80004c0a:	b76d                	j	80004bb4 <sys_open+0xe4>
      end_op();
    80004c0c:	fffff097          	auipc	ra,0xfffff
    80004c10:	974080e7          	jalr	-1676(ra) # 80003580 <end_op>
      return -1;
    80004c14:	557d                	li	a0,-1
    80004c16:	bf79                	j	80004bb4 <sys_open+0xe4>
    iunlockput(ip);
    80004c18:	8526                	mv	a0,s1
    80004c1a:	ffffe097          	auipc	ra,0xffffe
    80004c1e:	186080e7          	jalr	390(ra) # 80002da0 <iunlockput>
    end_op();
    80004c22:	fffff097          	auipc	ra,0xfffff
    80004c26:	95e080e7          	jalr	-1698(ra) # 80003580 <end_op>
    return -1;
    80004c2a:	557d                	li	a0,-1
    80004c2c:	b761                	j	80004bb4 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c2e:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c32:	04649783          	lh	a5,70(s1)
    80004c36:	02f99223          	sh	a5,36(s3)
    80004c3a:	bf25                	j	80004b72 <sys_open+0xa2>
    itrunc(ip);
    80004c3c:	8526                	mv	a0,s1
    80004c3e:	ffffe097          	auipc	ra,0xffffe
    80004c42:	00e080e7          	jalr	14(ra) # 80002c4c <itrunc>
    80004c46:	bfa9                	j	80004ba0 <sys_open+0xd0>
      fileclose(f);
    80004c48:	854e                	mv	a0,s3
    80004c4a:	fffff097          	auipc	ra,0xfffff
    80004c4e:	d82080e7          	jalr	-638(ra) # 800039cc <fileclose>
    iunlockput(ip);
    80004c52:	8526                	mv	a0,s1
    80004c54:	ffffe097          	auipc	ra,0xffffe
    80004c58:	14c080e7          	jalr	332(ra) # 80002da0 <iunlockput>
    end_op();
    80004c5c:	fffff097          	auipc	ra,0xfffff
    80004c60:	924080e7          	jalr	-1756(ra) # 80003580 <end_op>
    return -1;
    80004c64:	557d                	li	a0,-1
    80004c66:	b7b9                	j	80004bb4 <sys_open+0xe4>

0000000080004c68 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c68:	7175                	addi	sp,sp,-144
    80004c6a:	e506                	sd	ra,136(sp)
    80004c6c:	e122                	sd	s0,128(sp)
    80004c6e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c70:	fffff097          	auipc	ra,0xfffff
    80004c74:	890080e7          	jalr	-1904(ra) # 80003500 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c78:	08000613          	li	a2,128
    80004c7c:	f7040593          	addi	a1,s0,-144
    80004c80:	4501                	li	a0,0
    80004c82:	ffffd097          	auipc	ra,0xffffd
    80004c86:	382080e7          	jalr	898(ra) # 80002004 <argstr>
    80004c8a:	02054963          	bltz	a0,80004cbc <sys_mkdir+0x54>
    80004c8e:	4681                	li	a3,0
    80004c90:	4601                	li	a2,0
    80004c92:	4585                	li	a1,1
    80004c94:	f7040513          	addi	a0,s0,-144
    80004c98:	fffff097          	auipc	ra,0xfffff
    80004c9c:	7fe080e7          	jalr	2046(ra) # 80004496 <create>
    80004ca0:	cd11                	beqz	a0,80004cbc <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ca2:	ffffe097          	auipc	ra,0xffffe
    80004ca6:	0fe080e7          	jalr	254(ra) # 80002da0 <iunlockput>
  end_op();
    80004caa:	fffff097          	auipc	ra,0xfffff
    80004cae:	8d6080e7          	jalr	-1834(ra) # 80003580 <end_op>
  return 0;
    80004cb2:	4501                	li	a0,0
}
    80004cb4:	60aa                	ld	ra,136(sp)
    80004cb6:	640a                	ld	s0,128(sp)
    80004cb8:	6149                	addi	sp,sp,144
    80004cba:	8082                	ret
    end_op();
    80004cbc:	fffff097          	auipc	ra,0xfffff
    80004cc0:	8c4080e7          	jalr	-1852(ra) # 80003580 <end_op>
    return -1;
    80004cc4:	557d                	li	a0,-1
    80004cc6:	b7fd                	j	80004cb4 <sys_mkdir+0x4c>

0000000080004cc8 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004cc8:	7135                	addi	sp,sp,-160
    80004cca:	ed06                	sd	ra,152(sp)
    80004ccc:	e922                	sd	s0,144(sp)
    80004cce:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004cd0:	fffff097          	auipc	ra,0xfffff
    80004cd4:	830080e7          	jalr	-2000(ra) # 80003500 <begin_op>
  argint(1, &major);
    80004cd8:	f6c40593          	addi	a1,s0,-148
    80004cdc:	4505                	li	a0,1
    80004cde:	ffffd097          	auipc	ra,0xffffd
    80004ce2:	2e6080e7          	jalr	742(ra) # 80001fc4 <argint>
  argint(2, &minor);
    80004ce6:	f6840593          	addi	a1,s0,-152
    80004cea:	4509                	li	a0,2
    80004cec:	ffffd097          	auipc	ra,0xffffd
    80004cf0:	2d8080e7          	jalr	728(ra) # 80001fc4 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cf4:	08000613          	li	a2,128
    80004cf8:	f7040593          	addi	a1,s0,-144
    80004cfc:	4501                	li	a0,0
    80004cfe:	ffffd097          	auipc	ra,0xffffd
    80004d02:	306080e7          	jalr	774(ra) # 80002004 <argstr>
    80004d06:	02054b63          	bltz	a0,80004d3c <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d0a:	f6841683          	lh	a3,-152(s0)
    80004d0e:	f6c41603          	lh	a2,-148(s0)
    80004d12:	458d                	li	a1,3
    80004d14:	f7040513          	addi	a0,s0,-144
    80004d18:	fffff097          	auipc	ra,0xfffff
    80004d1c:	77e080e7          	jalr	1918(ra) # 80004496 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d20:	cd11                	beqz	a0,80004d3c <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d22:	ffffe097          	auipc	ra,0xffffe
    80004d26:	07e080e7          	jalr	126(ra) # 80002da0 <iunlockput>
  end_op();
    80004d2a:	fffff097          	auipc	ra,0xfffff
    80004d2e:	856080e7          	jalr	-1962(ra) # 80003580 <end_op>
  return 0;
    80004d32:	4501                	li	a0,0
}
    80004d34:	60ea                	ld	ra,152(sp)
    80004d36:	644a                	ld	s0,144(sp)
    80004d38:	610d                	addi	sp,sp,160
    80004d3a:	8082                	ret
    end_op();
    80004d3c:	fffff097          	auipc	ra,0xfffff
    80004d40:	844080e7          	jalr	-1980(ra) # 80003580 <end_op>
    return -1;
    80004d44:	557d                	li	a0,-1
    80004d46:	b7fd                	j	80004d34 <sys_mknod+0x6c>

0000000080004d48 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d48:	7135                	addi	sp,sp,-160
    80004d4a:	ed06                	sd	ra,152(sp)
    80004d4c:	e922                	sd	s0,144(sp)
    80004d4e:	e526                	sd	s1,136(sp)
    80004d50:	e14a                	sd	s2,128(sp)
    80004d52:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d54:	ffffc097          	auipc	ra,0xffffc
    80004d58:	15c080e7          	jalr	348(ra) # 80000eb0 <myproc>
    80004d5c:	892a                	mv	s2,a0
  
  begin_op();
    80004d5e:	ffffe097          	auipc	ra,0xffffe
    80004d62:	7a2080e7          	jalr	1954(ra) # 80003500 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d66:	08000613          	li	a2,128
    80004d6a:	f6040593          	addi	a1,s0,-160
    80004d6e:	4501                	li	a0,0
    80004d70:	ffffd097          	auipc	ra,0xffffd
    80004d74:	294080e7          	jalr	660(ra) # 80002004 <argstr>
    80004d78:	04054b63          	bltz	a0,80004dce <sys_chdir+0x86>
    80004d7c:	f6040513          	addi	a0,s0,-160
    80004d80:	ffffe097          	auipc	ra,0xffffe
    80004d84:	564080e7          	jalr	1380(ra) # 800032e4 <namei>
    80004d88:	84aa                	mv	s1,a0
    80004d8a:	c131                	beqz	a0,80004dce <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d8c:	ffffe097          	auipc	ra,0xffffe
    80004d90:	db2080e7          	jalr	-590(ra) # 80002b3e <ilock>
  if(ip->type != T_DIR){
    80004d94:	04449703          	lh	a4,68(s1)
    80004d98:	4785                	li	a5,1
    80004d9a:	04f71063          	bne	a4,a5,80004dda <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004d9e:	8526                	mv	a0,s1
    80004da0:	ffffe097          	auipc	ra,0xffffe
    80004da4:	e60080e7          	jalr	-416(ra) # 80002c00 <iunlock>
  iput(p->cwd);
    80004da8:	15093503          	ld	a0,336(s2)
    80004dac:	ffffe097          	auipc	ra,0xffffe
    80004db0:	f4c080e7          	jalr	-180(ra) # 80002cf8 <iput>
  end_op();
    80004db4:	ffffe097          	auipc	ra,0xffffe
    80004db8:	7cc080e7          	jalr	1996(ra) # 80003580 <end_op>
  p->cwd = ip;
    80004dbc:	14993823          	sd	s1,336(s2)
  return 0;
    80004dc0:	4501                	li	a0,0
}
    80004dc2:	60ea                	ld	ra,152(sp)
    80004dc4:	644a                	ld	s0,144(sp)
    80004dc6:	64aa                	ld	s1,136(sp)
    80004dc8:	690a                	ld	s2,128(sp)
    80004dca:	610d                	addi	sp,sp,160
    80004dcc:	8082                	ret
    end_op();
    80004dce:	ffffe097          	auipc	ra,0xffffe
    80004dd2:	7b2080e7          	jalr	1970(ra) # 80003580 <end_op>
    return -1;
    80004dd6:	557d                	li	a0,-1
    80004dd8:	b7ed                	j	80004dc2 <sys_chdir+0x7a>
    iunlockput(ip);
    80004dda:	8526                	mv	a0,s1
    80004ddc:	ffffe097          	auipc	ra,0xffffe
    80004de0:	fc4080e7          	jalr	-60(ra) # 80002da0 <iunlockput>
    end_op();
    80004de4:	ffffe097          	auipc	ra,0xffffe
    80004de8:	79c080e7          	jalr	1948(ra) # 80003580 <end_op>
    return -1;
    80004dec:	557d                	li	a0,-1
    80004dee:	bfd1                	j	80004dc2 <sys_chdir+0x7a>

0000000080004df0 <sys_exec>:

uint64
sys_exec(void)
{
    80004df0:	7145                	addi	sp,sp,-464
    80004df2:	e786                	sd	ra,456(sp)
    80004df4:	e3a2                	sd	s0,448(sp)
    80004df6:	ff26                	sd	s1,440(sp)
    80004df8:	fb4a                	sd	s2,432(sp)
    80004dfa:	f74e                	sd	s3,424(sp)
    80004dfc:	f352                	sd	s4,416(sp)
    80004dfe:	ef56                	sd	s5,408(sp)
    80004e00:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004e02:	e3840593          	addi	a1,s0,-456
    80004e06:	4505                	li	a0,1
    80004e08:	ffffd097          	auipc	ra,0xffffd
    80004e0c:	1dc080e7          	jalr	476(ra) # 80001fe4 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004e10:	08000613          	li	a2,128
    80004e14:	f4040593          	addi	a1,s0,-192
    80004e18:	4501                	li	a0,0
    80004e1a:	ffffd097          	auipc	ra,0xffffd
    80004e1e:	1ea080e7          	jalr	490(ra) # 80002004 <argstr>
    80004e22:	87aa                	mv	a5,a0
    return -1;
    80004e24:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004e26:	0c07c263          	bltz	a5,80004eea <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004e2a:	10000613          	li	a2,256
    80004e2e:	4581                	li	a1,0
    80004e30:	e4040513          	addi	a0,s0,-448
    80004e34:	ffffb097          	auipc	ra,0xffffb
    80004e38:	344080e7          	jalr	836(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e3c:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004e40:	89a6                	mv	s3,s1
    80004e42:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e44:	02000a13          	li	s4,32
    80004e48:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e4c:	00391513          	slli	a0,s2,0x3
    80004e50:	e3040593          	addi	a1,s0,-464
    80004e54:	e3843783          	ld	a5,-456(s0)
    80004e58:	953e                	add	a0,a0,a5
    80004e5a:	ffffd097          	auipc	ra,0xffffd
    80004e5e:	0cc080e7          	jalr	204(ra) # 80001f26 <fetchaddr>
    80004e62:	02054a63          	bltz	a0,80004e96 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004e66:	e3043783          	ld	a5,-464(s0)
    80004e6a:	c3b9                	beqz	a5,80004eb0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e6c:	ffffb097          	auipc	ra,0xffffb
    80004e70:	2ac080e7          	jalr	684(ra) # 80000118 <kalloc>
    80004e74:	85aa                	mv	a1,a0
    80004e76:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004e7a:	cd11                	beqz	a0,80004e96 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e7c:	6605                	lui	a2,0x1
    80004e7e:	e3043503          	ld	a0,-464(s0)
    80004e82:	ffffd097          	auipc	ra,0xffffd
    80004e86:	0f6080e7          	jalr	246(ra) # 80001f78 <fetchstr>
    80004e8a:	00054663          	bltz	a0,80004e96 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004e8e:	0905                	addi	s2,s2,1
    80004e90:	09a1                	addi	s3,s3,8
    80004e92:	fb491be3          	bne	s2,s4,80004e48 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e96:	10048913          	addi	s2,s1,256
    80004e9a:	6088                	ld	a0,0(s1)
    80004e9c:	c531                	beqz	a0,80004ee8 <sys_exec+0xf8>
    kfree(argv[i]);
    80004e9e:	ffffb097          	auipc	ra,0xffffb
    80004ea2:	17e080e7          	jalr	382(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ea6:	04a1                	addi	s1,s1,8
    80004ea8:	ff2499e3          	bne	s1,s2,80004e9a <sys_exec+0xaa>
  return -1;
    80004eac:	557d                	li	a0,-1
    80004eae:	a835                	j	80004eea <sys_exec+0xfa>
      argv[i] = 0;
    80004eb0:	0a8e                	slli	s5,s5,0x3
    80004eb2:	fc040793          	addi	a5,s0,-64
    80004eb6:	9abe                	add	s5,s5,a5
    80004eb8:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004ebc:	e4040593          	addi	a1,s0,-448
    80004ec0:	f4040513          	addi	a0,s0,-192
    80004ec4:	fffff097          	auipc	ra,0xfffff
    80004ec8:	190080e7          	jalr	400(ra) # 80004054 <exec>
    80004ecc:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ece:	10048993          	addi	s3,s1,256
    80004ed2:	6088                	ld	a0,0(s1)
    80004ed4:	c901                	beqz	a0,80004ee4 <sys_exec+0xf4>
    kfree(argv[i]);
    80004ed6:	ffffb097          	auipc	ra,0xffffb
    80004eda:	146080e7          	jalr	326(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ede:	04a1                	addi	s1,s1,8
    80004ee0:	ff3499e3          	bne	s1,s3,80004ed2 <sys_exec+0xe2>
  return ret;
    80004ee4:	854a                	mv	a0,s2
    80004ee6:	a011                	j	80004eea <sys_exec+0xfa>
  return -1;
    80004ee8:	557d                	li	a0,-1
}
    80004eea:	60be                	ld	ra,456(sp)
    80004eec:	641e                	ld	s0,448(sp)
    80004eee:	74fa                	ld	s1,440(sp)
    80004ef0:	795a                	ld	s2,432(sp)
    80004ef2:	79ba                	ld	s3,424(sp)
    80004ef4:	7a1a                	ld	s4,416(sp)
    80004ef6:	6afa                	ld	s5,408(sp)
    80004ef8:	6179                	addi	sp,sp,464
    80004efa:	8082                	ret

0000000080004efc <sys_pipe>:

uint64
sys_pipe(void)
{
    80004efc:	7139                	addi	sp,sp,-64
    80004efe:	fc06                	sd	ra,56(sp)
    80004f00:	f822                	sd	s0,48(sp)
    80004f02:	f426                	sd	s1,40(sp)
    80004f04:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f06:	ffffc097          	auipc	ra,0xffffc
    80004f0a:	faa080e7          	jalr	-86(ra) # 80000eb0 <myproc>
    80004f0e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004f10:	fd840593          	addi	a1,s0,-40
    80004f14:	4501                	li	a0,0
    80004f16:	ffffd097          	auipc	ra,0xffffd
    80004f1a:	0ce080e7          	jalr	206(ra) # 80001fe4 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004f1e:	fc840593          	addi	a1,s0,-56
    80004f22:	fd040513          	addi	a0,s0,-48
    80004f26:	fffff097          	auipc	ra,0xfffff
    80004f2a:	dd6080e7          	jalr	-554(ra) # 80003cfc <pipealloc>
    return -1;
    80004f2e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f30:	0c054463          	bltz	a0,80004ff8 <sys_pipe+0xfc>
  fd0 = -1;
    80004f34:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f38:	fd043503          	ld	a0,-48(s0)
    80004f3c:	fffff097          	auipc	ra,0xfffff
    80004f40:	518080e7          	jalr	1304(ra) # 80004454 <fdalloc>
    80004f44:	fca42223          	sw	a0,-60(s0)
    80004f48:	08054b63          	bltz	a0,80004fde <sys_pipe+0xe2>
    80004f4c:	fc843503          	ld	a0,-56(s0)
    80004f50:	fffff097          	auipc	ra,0xfffff
    80004f54:	504080e7          	jalr	1284(ra) # 80004454 <fdalloc>
    80004f58:	fca42023          	sw	a0,-64(s0)
    80004f5c:	06054863          	bltz	a0,80004fcc <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f60:	4691                	li	a3,4
    80004f62:	fc440613          	addi	a2,s0,-60
    80004f66:	fd843583          	ld	a1,-40(s0)
    80004f6a:	68a8                	ld	a0,80(s1)
    80004f6c:	ffffc097          	auipc	ra,0xffffc
    80004f70:	bce080e7          	jalr	-1074(ra) # 80000b3a <copyout>
    80004f74:	02054063          	bltz	a0,80004f94 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f78:	4691                	li	a3,4
    80004f7a:	fc040613          	addi	a2,s0,-64
    80004f7e:	fd843583          	ld	a1,-40(s0)
    80004f82:	0591                	addi	a1,a1,4
    80004f84:	68a8                	ld	a0,80(s1)
    80004f86:	ffffc097          	auipc	ra,0xffffc
    80004f8a:	bb4080e7          	jalr	-1100(ra) # 80000b3a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f8e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f90:	06055463          	bgez	a0,80004ff8 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80004f94:	fc442783          	lw	a5,-60(s0)
    80004f98:	07e9                	addi	a5,a5,26
    80004f9a:	078e                	slli	a5,a5,0x3
    80004f9c:	97a6                	add	a5,a5,s1
    80004f9e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004fa2:	fc042503          	lw	a0,-64(s0)
    80004fa6:	0569                	addi	a0,a0,26
    80004fa8:	050e                	slli	a0,a0,0x3
    80004faa:	94aa                	add	s1,s1,a0
    80004fac:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004fb0:	fd043503          	ld	a0,-48(s0)
    80004fb4:	fffff097          	auipc	ra,0xfffff
    80004fb8:	a18080e7          	jalr	-1512(ra) # 800039cc <fileclose>
    fileclose(wf);
    80004fbc:	fc843503          	ld	a0,-56(s0)
    80004fc0:	fffff097          	auipc	ra,0xfffff
    80004fc4:	a0c080e7          	jalr	-1524(ra) # 800039cc <fileclose>
    return -1;
    80004fc8:	57fd                	li	a5,-1
    80004fca:	a03d                	j	80004ff8 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80004fcc:	fc442783          	lw	a5,-60(s0)
    80004fd0:	0007c763          	bltz	a5,80004fde <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80004fd4:	07e9                	addi	a5,a5,26
    80004fd6:	078e                	slli	a5,a5,0x3
    80004fd8:	94be                	add	s1,s1,a5
    80004fda:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004fde:	fd043503          	ld	a0,-48(s0)
    80004fe2:	fffff097          	auipc	ra,0xfffff
    80004fe6:	9ea080e7          	jalr	-1558(ra) # 800039cc <fileclose>
    fileclose(wf);
    80004fea:	fc843503          	ld	a0,-56(s0)
    80004fee:	fffff097          	auipc	ra,0xfffff
    80004ff2:	9de080e7          	jalr	-1570(ra) # 800039cc <fileclose>
    return -1;
    80004ff6:	57fd                	li	a5,-1
}
    80004ff8:	853e                	mv	a0,a5
    80004ffa:	70e2                	ld	ra,56(sp)
    80004ffc:	7442                	ld	s0,48(sp)
    80004ffe:	74a2                	ld	s1,40(sp)
    80005000:	6121                	addi	sp,sp,64
    80005002:	8082                	ret
	...

0000000080005010 <kernelvec>:
    80005010:	7111                	addi	sp,sp,-256
    80005012:	e006                	sd	ra,0(sp)
    80005014:	e40a                	sd	sp,8(sp)
    80005016:	e80e                	sd	gp,16(sp)
    80005018:	ec12                	sd	tp,24(sp)
    8000501a:	f016                	sd	t0,32(sp)
    8000501c:	f41a                	sd	t1,40(sp)
    8000501e:	f81e                	sd	t2,48(sp)
    80005020:	fc22                	sd	s0,56(sp)
    80005022:	e0a6                	sd	s1,64(sp)
    80005024:	e4aa                	sd	a0,72(sp)
    80005026:	e8ae                	sd	a1,80(sp)
    80005028:	ecb2                	sd	a2,88(sp)
    8000502a:	f0b6                	sd	a3,96(sp)
    8000502c:	f4ba                	sd	a4,104(sp)
    8000502e:	f8be                	sd	a5,112(sp)
    80005030:	fcc2                	sd	a6,120(sp)
    80005032:	e146                	sd	a7,128(sp)
    80005034:	e54a                	sd	s2,136(sp)
    80005036:	e94e                	sd	s3,144(sp)
    80005038:	ed52                	sd	s4,152(sp)
    8000503a:	f156                	sd	s5,160(sp)
    8000503c:	f55a                	sd	s6,168(sp)
    8000503e:	f95e                	sd	s7,176(sp)
    80005040:	fd62                	sd	s8,184(sp)
    80005042:	e1e6                	sd	s9,192(sp)
    80005044:	e5ea                	sd	s10,200(sp)
    80005046:	e9ee                	sd	s11,208(sp)
    80005048:	edf2                	sd	t3,216(sp)
    8000504a:	f1f6                	sd	t4,224(sp)
    8000504c:	f5fa                	sd	t5,232(sp)
    8000504e:	f9fe                	sd	t6,240(sp)
    80005050:	da3fc0ef          	jal	ra,80001df2 <kerneltrap>
    80005054:	6082                	ld	ra,0(sp)
    80005056:	6122                	ld	sp,8(sp)
    80005058:	61c2                	ld	gp,16(sp)
    8000505a:	7282                	ld	t0,32(sp)
    8000505c:	7322                	ld	t1,40(sp)
    8000505e:	73c2                	ld	t2,48(sp)
    80005060:	7462                	ld	s0,56(sp)
    80005062:	6486                	ld	s1,64(sp)
    80005064:	6526                	ld	a0,72(sp)
    80005066:	65c6                	ld	a1,80(sp)
    80005068:	6666                	ld	a2,88(sp)
    8000506a:	7686                	ld	a3,96(sp)
    8000506c:	7726                	ld	a4,104(sp)
    8000506e:	77c6                	ld	a5,112(sp)
    80005070:	7866                	ld	a6,120(sp)
    80005072:	688a                	ld	a7,128(sp)
    80005074:	692a                	ld	s2,136(sp)
    80005076:	69ca                	ld	s3,144(sp)
    80005078:	6a6a                	ld	s4,152(sp)
    8000507a:	7a8a                	ld	s5,160(sp)
    8000507c:	7b2a                	ld	s6,168(sp)
    8000507e:	7bca                	ld	s7,176(sp)
    80005080:	7c6a                	ld	s8,184(sp)
    80005082:	6c8e                	ld	s9,192(sp)
    80005084:	6d2e                	ld	s10,200(sp)
    80005086:	6dce                	ld	s11,208(sp)
    80005088:	6e6e                	ld	t3,216(sp)
    8000508a:	7e8e                	ld	t4,224(sp)
    8000508c:	7f2e                	ld	t5,232(sp)
    8000508e:	7fce                	ld	t6,240(sp)
    80005090:	6111                	addi	sp,sp,256
    80005092:	10200073          	sret
    80005096:	00000013          	nop
    8000509a:	00000013          	nop
    8000509e:	0001                	nop

00000000800050a0 <timervec>:
    800050a0:	34051573          	csrrw	a0,mscratch,a0
    800050a4:	e10c                	sd	a1,0(a0)
    800050a6:	e510                	sd	a2,8(a0)
    800050a8:	e914                	sd	a3,16(a0)
    800050aa:	6d0c                	ld	a1,24(a0)
    800050ac:	7110                	ld	a2,32(a0)
    800050ae:	6194                	ld	a3,0(a1)
    800050b0:	96b2                	add	a3,a3,a2
    800050b2:	e194                	sd	a3,0(a1)
    800050b4:	4589                	li	a1,2
    800050b6:	14459073          	csrw	sip,a1
    800050ba:	6914                	ld	a3,16(a0)
    800050bc:	6510                	ld	a2,8(a0)
    800050be:	610c                	ld	a1,0(a0)
    800050c0:	34051573          	csrrw	a0,mscratch,a0
    800050c4:	30200073          	mret
	...

00000000800050ca <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800050ca:	1141                	addi	sp,sp,-16
    800050cc:	e422                	sd	s0,8(sp)
    800050ce:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800050d0:	0c0007b7          	lui	a5,0xc000
    800050d4:	4705                	li	a4,1
    800050d6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800050d8:	c3d8                	sw	a4,4(a5)
}
    800050da:	6422                	ld	s0,8(sp)
    800050dc:	0141                	addi	sp,sp,16
    800050de:	8082                	ret

00000000800050e0 <plicinithart>:

void
plicinithart(void)
{
    800050e0:	1141                	addi	sp,sp,-16
    800050e2:	e406                	sd	ra,8(sp)
    800050e4:	e022                	sd	s0,0(sp)
    800050e6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800050e8:	ffffc097          	auipc	ra,0xffffc
    800050ec:	d9c080e7          	jalr	-612(ra) # 80000e84 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800050f0:	0085171b          	slliw	a4,a0,0x8
    800050f4:	0c0027b7          	lui	a5,0xc002
    800050f8:	97ba                	add	a5,a5,a4
    800050fa:	40200713          	li	a4,1026
    800050fe:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005102:	00d5151b          	slliw	a0,a0,0xd
    80005106:	0c2017b7          	lui	a5,0xc201
    8000510a:	953e                	add	a0,a0,a5
    8000510c:	00052023          	sw	zero,0(a0)
}
    80005110:	60a2                	ld	ra,8(sp)
    80005112:	6402                	ld	s0,0(sp)
    80005114:	0141                	addi	sp,sp,16
    80005116:	8082                	ret

0000000080005118 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005118:	1141                	addi	sp,sp,-16
    8000511a:	e406                	sd	ra,8(sp)
    8000511c:	e022                	sd	s0,0(sp)
    8000511e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005120:	ffffc097          	auipc	ra,0xffffc
    80005124:	d64080e7          	jalr	-668(ra) # 80000e84 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005128:	00d5179b          	slliw	a5,a0,0xd
    8000512c:	0c201537          	lui	a0,0xc201
    80005130:	953e                	add	a0,a0,a5
  return irq;
}
    80005132:	4148                	lw	a0,4(a0)
    80005134:	60a2                	ld	ra,8(sp)
    80005136:	6402                	ld	s0,0(sp)
    80005138:	0141                	addi	sp,sp,16
    8000513a:	8082                	ret

000000008000513c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000513c:	1101                	addi	sp,sp,-32
    8000513e:	ec06                	sd	ra,24(sp)
    80005140:	e822                	sd	s0,16(sp)
    80005142:	e426                	sd	s1,8(sp)
    80005144:	1000                	addi	s0,sp,32
    80005146:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005148:	ffffc097          	auipc	ra,0xffffc
    8000514c:	d3c080e7          	jalr	-708(ra) # 80000e84 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005150:	00d5151b          	slliw	a0,a0,0xd
    80005154:	0c2017b7          	lui	a5,0xc201
    80005158:	97aa                	add	a5,a5,a0
    8000515a:	c3c4                	sw	s1,4(a5)
}
    8000515c:	60e2                	ld	ra,24(sp)
    8000515e:	6442                	ld	s0,16(sp)
    80005160:	64a2                	ld	s1,8(sp)
    80005162:	6105                	addi	sp,sp,32
    80005164:	8082                	ret

0000000080005166 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005166:	1141                	addi	sp,sp,-16
    80005168:	e406                	sd	ra,8(sp)
    8000516a:	e022                	sd	s0,0(sp)
    8000516c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000516e:	479d                	li	a5,7
    80005170:	04a7cc63          	blt	a5,a0,800051c8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005174:	00015797          	auipc	a5,0x15
    80005178:	87c78793          	addi	a5,a5,-1924 # 800199f0 <disk>
    8000517c:	97aa                	add	a5,a5,a0
    8000517e:	0187c783          	lbu	a5,24(a5)
    80005182:	ebb9                	bnez	a5,800051d8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005184:	00451613          	slli	a2,a0,0x4
    80005188:	00015797          	auipc	a5,0x15
    8000518c:	86878793          	addi	a5,a5,-1944 # 800199f0 <disk>
    80005190:	6394                	ld	a3,0(a5)
    80005192:	96b2                	add	a3,a3,a2
    80005194:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005198:	6398                	ld	a4,0(a5)
    8000519a:	9732                	add	a4,a4,a2
    8000519c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800051a0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800051a4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800051a8:	953e                	add	a0,a0,a5
    800051aa:	4785                	li	a5,1
    800051ac:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800051b0:	00015517          	auipc	a0,0x15
    800051b4:	85850513          	addi	a0,a0,-1960 # 80019a08 <disk+0x18>
    800051b8:	ffffc097          	auipc	ra,0xffffc
    800051bc:	404080e7          	jalr	1028(ra) # 800015bc <wakeup>
}
    800051c0:	60a2                	ld	ra,8(sp)
    800051c2:	6402                	ld	s0,0(sp)
    800051c4:	0141                	addi	sp,sp,16
    800051c6:	8082                	ret
    panic("free_desc 1");
    800051c8:	00003517          	auipc	a0,0x3
    800051cc:	53850513          	addi	a0,a0,1336 # 80008700 <syscalls+0x2f0>
    800051d0:	00001097          	auipc	ra,0x1
    800051d4:	a72080e7          	jalr	-1422(ra) # 80005c42 <panic>
    panic("free_desc 2");
    800051d8:	00003517          	auipc	a0,0x3
    800051dc:	53850513          	addi	a0,a0,1336 # 80008710 <syscalls+0x300>
    800051e0:	00001097          	auipc	ra,0x1
    800051e4:	a62080e7          	jalr	-1438(ra) # 80005c42 <panic>

00000000800051e8 <virtio_disk_init>:
{
    800051e8:	1101                	addi	sp,sp,-32
    800051ea:	ec06                	sd	ra,24(sp)
    800051ec:	e822                	sd	s0,16(sp)
    800051ee:	e426                	sd	s1,8(sp)
    800051f0:	e04a                	sd	s2,0(sp)
    800051f2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800051f4:	00003597          	auipc	a1,0x3
    800051f8:	52c58593          	addi	a1,a1,1324 # 80008720 <syscalls+0x310>
    800051fc:	00015517          	auipc	a0,0x15
    80005200:	91c50513          	addi	a0,a0,-1764 # 80019b18 <disk+0x128>
    80005204:	00001097          	auipc	ra,0x1
    80005208:	ef8080e7          	jalr	-264(ra) # 800060fc <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000520c:	100017b7          	lui	a5,0x10001
    80005210:	4398                	lw	a4,0(a5)
    80005212:	2701                	sext.w	a4,a4
    80005214:	747277b7          	lui	a5,0x74727
    80005218:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000521c:	14f71e63          	bne	a4,a5,80005378 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005220:	100017b7          	lui	a5,0x10001
    80005224:	43dc                	lw	a5,4(a5)
    80005226:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005228:	4709                	li	a4,2
    8000522a:	14e79763          	bne	a5,a4,80005378 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000522e:	100017b7          	lui	a5,0x10001
    80005232:	479c                	lw	a5,8(a5)
    80005234:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005236:	14e79163          	bne	a5,a4,80005378 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000523a:	100017b7          	lui	a5,0x10001
    8000523e:	47d8                	lw	a4,12(a5)
    80005240:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005242:	554d47b7          	lui	a5,0x554d4
    80005246:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000524a:	12f71763          	bne	a4,a5,80005378 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000524e:	100017b7          	lui	a5,0x10001
    80005252:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005256:	4705                	li	a4,1
    80005258:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000525a:	470d                	li	a4,3
    8000525c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000525e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005260:	c7ffe737          	lui	a4,0xc7ffe
    80005264:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc9ef>
    80005268:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000526a:	2701                	sext.w	a4,a4
    8000526c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000526e:	472d                	li	a4,11
    80005270:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005272:	0707a903          	lw	s2,112(a5)
    80005276:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005278:	00897793          	andi	a5,s2,8
    8000527c:	10078663          	beqz	a5,80005388 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005280:	100017b7          	lui	a5,0x10001
    80005284:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005288:	43fc                	lw	a5,68(a5)
    8000528a:	2781                	sext.w	a5,a5
    8000528c:	10079663          	bnez	a5,80005398 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005290:	100017b7          	lui	a5,0x10001
    80005294:	5bdc                	lw	a5,52(a5)
    80005296:	2781                	sext.w	a5,a5
  if(max == 0)
    80005298:	10078863          	beqz	a5,800053a8 <virtio_disk_init+0x1c0>
  if(max < NUM)
    8000529c:	471d                	li	a4,7
    8000529e:	10f77d63          	bgeu	a4,a5,800053b8 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    800052a2:	ffffb097          	auipc	ra,0xffffb
    800052a6:	e76080e7          	jalr	-394(ra) # 80000118 <kalloc>
    800052aa:	00014497          	auipc	s1,0x14
    800052ae:	74648493          	addi	s1,s1,1862 # 800199f0 <disk>
    800052b2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800052b4:	ffffb097          	auipc	ra,0xffffb
    800052b8:	e64080e7          	jalr	-412(ra) # 80000118 <kalloc>
    800052bc:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800052be:	ffffb097          	auipc	ra,0xffffb
    800052c2:	e5a080e7          	jalr	-422(ra) # 80000118 <kalloc>
    800052c6:	87aa                	mv	a5,a0
    800052c8:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800052ca:	6088                	ld	a0,0(s1)
    800052cc:	cd75                	beqz	a0,800053c8 <virtio_disk_init+0x1e0>
    800052ce:	00014717          	auipc	a4,0x14
    800052d2:	72a73703          	ld	a4,1834(a4) # 800199f8 <disk+0x8>
    800052d6:	cb6d                	beqz	a4,800053c8 <virtio_disk_init+0x1e0>
    800052d8:	cbe5                	beqz	a5,800053c8 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    800052da:	6605                	lui	a2,0x1
    800052dc:	4581                	li	a1,0
    800052de:	ffffb097          	auipc	ra,0xffffb
    800052e2:	e9a080e7          	jalr	-358(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    800052e6:	00014497          	auipc	s1,0x14
    800052ea:	70a48493          	addi	s1,s1,1802 # 800199f0 <disk>
    800052ee:	6605                	lui	a2,0x1
    800052f0:	4581                	li	a1,0
    800052f2:	6488                	ld	a0,8(s1)
    800052f4:	ffffb097          	auipc	ra,0xffffb
    800052f8:	e84080e7          	jalr	-380(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    800052fc:	6605                	lui	a2,0x1
    800052fe:	4581                	li	a1,0
    80005300:	6888                	ld	a0,16(s1)
    80005302:	ffffb097          	auipc	ra,0xffffb
    80005306:	e76080e7          	jalr	-394(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000530a:	100017b7          	lui	a5,0x10001
    8000530e:	4721                	li	a4,8
    80005310:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005312:	4098                	lw	a4,0(s1)
    80005314:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005318:	40d8                	lw	a4,4(s1)
    8000531a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000531e:	6498                	ld	a4,8(s1)
    80005320:	0007069b          	sext.w	a3,a4
    80005324:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005328:	9701                	srai	a4,a4,0x20
    8000532a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000532e:	6898                	ld	a4,16(s1)
    80005330:	0007069b          	sext.w	a3,a4
    80005334:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005338:	9701                	srai	a4,a4,0x20
    8000533a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000533e:	4685                	li	a3,1
    80005340:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    80005342:	4705                	li	a4,1
    80005344:	00d48c23          	sb	a3,24(s1)
    80005348:	00e48ca3          	sb	a4,25(s1)
    8000534c:	00e48d23          	sb	a4,26(s1)
    80005350:	00e48da3          	sb	a4,27(s1)
    80005354:	00e48e23          	sb	a4,28(s1)
    80005358:	00e48ea3          	sb	a4,29(s1)
    8000535c:	00e48f23          	sb	a4,30(s1)
    80005360:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005364:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005368:	0727a823          	sw	s2,112(a5)
}
    8000536c:	60e2                	ld	ra,24(sp)
    8000536e:	6442                	ld	s0,16(sp)
    80005370:	64a2                	ld	s1,8(sp)
    80005372:	6902                	ld	s2,0(sp)
    80005374:	6105                	addi	sp,sp,32
    80005376:	8082                	ret
    panic("could not find virtio disk");
    80005378:	00003517          	auipc	a0,0x3
    8000537c:	3b850513          	addi	a0,a0,952 # 80008730 <syscalls+0x320>
    80005380:	00001097          	auipc	ra,0x1
    80005384:	8c2080e7          	jalr	-1854(ra) # 80005c42 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005388:	00003517          	auipc	a0,0x3
    8000538c:	3c850513          	addi	a0,a0,968 # 80008750 <syscalls+0x340>
    80005390:	00001097          	auipc	ra,0x1
    80005394:	8b2080e7          	jalr	-1870(ra) # 80005c42 <panic>
    panic("virtio disk should not be ready");
    80005398:	00003517          	auipc	a0,0x3
    8000539c:	3d850513          	addi	a0,a0,984 # 80008770 <syscalls+0x360>
    800053a0:	00001097          	auipc	ra,0x1
    800053a4:	8a2080e7          	jalr	-1886(ra) # 80005c42 <panic>
    panic("virtio disk has no queue 0");
    800053a8:	00003517          	auipc	a0,0x3
    800053ac:	3e850513          	addi	a0,a0,1000 # 80008790 <syscalls+0x380>
    800053b0:	00001097          	auipc	ra,0x1
    800053b4:	892080e7          	jalr	-1902(ra) # 80005c42 <panic>
    panic("virtio disk max queue too short");
    800053b8:	00003517          	auipc	a0,0x3
    800053bc:	3f850513          	addi	a0,a0,1016 # 800087b0 <syscalls+0x3a0>
    800053c0:	00001097          	auipc	ra,0x1
    800053c4:	882080e7          	jalr	-1918(ra) # 80005c42 <panic>
    panic("virtio disk kalloc");
    800053c8:	00003517          	auipc	a0,0x3
    800053cc:	40850513          	addi	a0,a0,1032 # 800087d0 <syscalls+0x3c0>
    800053d0:	00001097          	auipc	ra,0x1
    800053d4:	872080e7          	jalr	-1934(ra) # 80005c42 <panic>

00000000800053d8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053d8:	7159                	addi	sp,sp,-112
    800053da:	f486                	sd	ra,104(sp)
    800053dc:	f0a2                	sd	s0,96(sp)
    800053de:	eca6                	sd	s1,88(sp)
    800053e0:	e8ca                	sd	s2,80(sp)
    800053e2:	e4ce                	sd	s3,72(sp)
    800053e4:	e0d2                	sd	s4,64(sp)
    800053e6:	fc56                	sd	s5,56(sp)
    800053e8:	f85a                	sd	s6,48(sp)
    800053ea:	f45e                	sd	s7,40(sp)
    800053ec:	f062                	sd	s8,32(sp)
    800053ee:	ec66                	sd	s9,24(sp)
    800053f0:	e86a                	sd	s10,16(sp)
    800053f2:	1880                	addi	s0,sp,112
    800053f4:	892a                	mv	s2,a0
    800053f6:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053f8:	00c52c83          	lw	s9,12(a0)
    800053fc:	001c9c9b          	slliw	s9,s9,0x1
    80005400:	1c82                	slli	s9,s9,0x20
    80005402:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005406:	00014517          	auipc	a0,0x14
    8000540a:	71250513          	addi	a0,a0,1810 # 80019b18 <disk+0x128>
    8000540e:	00001097          	auipc	ra,0x1
    80005412:	d7e080e7          	jalr	-642(ra) # 8000618c <acquire>
  for(int i = 0; i < 3; i++){
    80005416:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005418:	4ba1                	li	s7,8
      disk.free[i] = 0;
    8000541a:	00014b17          	auipc	s6,0x14
    8000541e:	5d6b0b13          	addi	s6,s6,1494 # 800199f0 <disk>
  for(int i = 0; i < 3; i++){
    80005422:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005424:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005426:	00014c17          	auipc	s8,0x14
    8000542a:	6f2c0c13          	addi	s8,s8,1778 # 80019b18 <disk+0x128>
    8000542e:	a8b5                	j	800054aa <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    80005430:	00fb06b3          	add	a3,s6,a5
    80005434:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005438:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000543a:	0207c563          	bltz	a5,80005464 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000543e:	2485                	addiw	s1,s1,1
    80005440:	0711                	addi	a4,a4,4
    80005442:	1f548a63          	beq	s1,s5,80005636 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    80005446:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005448:	00014697          	auipc	a3,0x14
    8000544c:	5a868693          	addi	a3,a3,1448 # 800199f0 <disk>
    80005450:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005452:	0186c583          	lbu	a1,24(a3)
    80005456:	fde9                	bnez	a1,80005430 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005458:	2785                	addiw	a5,a5,1
    8000545a:	0685                	addi	a3,a3,1
    8000545c:	ff779be3          	bne	a5,s7,80005452 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    80005460:	57fd                	li	a5,-1
    80005462:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005464:	02905a63          	blez	s1,80005498 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    80005468:	f9042503          	lw	a0,-112(s0)
    8000546c:	00000097          	auipc	ra,0x0
    80005470:	cfa080e7          	jalr	-774(ra) # 80005166 <free_desc>
      for(int j = 0; j < i; j++)
    80005474:	4785                	li	a5,1
    80005476:	0297d163          	bge	a5,s1,80005498 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000547a:	f9442503          	lw	a0,-108(s0)
    8000547e:	00000097          	auipc	ra,0x0
    80005482:	ce8080e7          	jalr	-792(ra) # 80005166 <free_desc>
      for(int j = 0; j < i; j++)
    80005486:	4789                	li	a5,2
    80005488:	0097d863          	bge	a5,s1,80005498 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000548c:	f9842503          	lw	a0,-104(s0)
    80005490:	00000097          	auipc	ra,0x0
    80005494:	cd6080e7          	jalr	-810(ra) # 80005166 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005498:	85e2                	mv	a1,s8
    8000549a:	00014517          	auipc	a0,0x14
    8000549e:	56e50513          	addi	a0,a0,1390 # 80019a08 <disk+0x18>
    800054a2:	ffffc097          	auipc	ra,0xffffc
    800054a6:	0b6080e7          	jalr	182(ra) # 80001558 <sleep>
  for(int i = 0; i < 3; i++){
    800054aa:	f9040713          	addi	a4,s0,-112
    800054ae:	84ce                	mv	s1,s3
    800054b0:	bf59                	j	80005446 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800054b2:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    800054b6:	00479693          	slli	a3,a5,0x4
    800054ba:	00014797          	auipc	a5,0x14
    800054be:	53678793          	addi	a5,a5,1334 # 800199f0 <disk>
    800054c2:	97b6                	add	a5,a5,a3
    800054c4:	4685                	li	a3,1
    800054c6:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800054c8:	00014597          	auipc	a1,0x14
    800054cc:	52858593          	addi	a1,a1,1320 # 800199f0 <disk>
    800054d0:	00a60793          	addi	a5,a2,10
    800054d4:	0792                	slli	a5,a5,0x4
    800054d6:	97ae                	add	a5,a5,a1
    800054d8:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    800054dc:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800054e0:	f6070693          	addi	a3,a4,-160
    800054e4:	619c                	ld	a5,0(a1)
    800054e6:	97b6                	add	a5,a5,a3
    800054e8:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800054ea:	6188                	ld	a0,0(a1)
    800054ec:	96aa                	add	a3,a3,a0
    800054ee:	47c1                	li	a5,16
    800054f0:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800054f2:	4785                	li	a5,1
    800054f4:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    800054f8:	f9442783          	lw	a5,-108(s0)
    800054fc:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005500:	0792                	slli	a5,a5,0x4
    80005502:	953e                	add	a0,a0,a5
    80005504:	05890693          	addi	a3,s2,88
    80005508:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000550a:	6188                	ld	a0,0(a1)
    8000550c:	97aa                	add	a5,a5,a0
    8000550e:	40000693          	li	a3,1024
    80005512:	c794                	sw	a3,8(a5)
  if(write)
    80005514:	100d0d63          	beqz	s10,8000562e <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005518:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000551c:	00c7d683          	lhu	a3,12(a5)
    80005520:	0016e693          	ori	a3,a3,1
    80005524:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80005528:	f9842583          	lw	a1,-104(s0)
    8000552c:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005530:	00014697          	auipc	a3,0x14
    80005534:	4c068693          	addi	a3,a3,1216 # 800199f0 <disk>
    80005538:	00260793          	addi	a5,a2,2
    8000553c:	0792                	slli	a5,a5,0x4
    8000553e:	97b6                	add	a5,a5,a3
    80005540:	587d                	li	a6,-1
    80005542:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005546:	0592                	slli	a1,a1,0x4
    80005548:	952e                	add	a0,a0,a1
    8000554a:	f9070713          	addi	a4,a4,-112
    8000554e:	9736                	add	a4,a4,a3
    80005550:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    80005552:	6298                	ld	a4,0(a3)
    80005554:	972e                	add	a4,a4,a1
    80005556:	4585                	li	a1,1
    80005558:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000555a:	4509                	li	a0,2
    8000555c:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    80005560:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005564:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80005568:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000556c:	6698                	ld	a4,8(a3)
    8000556e:	00275783          	lhu	a5,2(a4)
    80005572:	8b9d                	andi	a5,a5,7
    80005574:	0786                	slli	a5,a5,0x1
    80005576:	97ba                	add	a5,a5,a4
    80005578:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    8000557c:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005580:	6698                	ld	a4,8(a3)
    80005582:	00275783          	lhu	a5,2(a4)
    80005586:	2785                	addiw	a5,a5,1
    80005588:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000558c:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005590:	100017b7          	lui	a5,0x10001
    80005594:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005598:	00492703          	lw	a4,4(s2)
    8000559c:	4785                	li	a5,1
    8000559e:	02f71163          	bne	a4,a5,800055c0 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    800055a2:	00014997          	auipc	s3,0x14
    800055a6:	57698993          	addi	s3,s3,1398 # 80019b18 <disk+0x128>
  while(b->disk == 1) {
    800055aa:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800055ac:	85ce                	mv	a1,s3
    800055ae:	854a                	mv	a0,s2
    800055b0:	ffffc097          	auipc	ra,0xffffc
    800055b4:	fa8080e7          	jalr	-88(ra) # 80001558 <sleep>
  while(b->disk == 1) {
    800055b8:	00492783          	lw	a5,4(s2)
    800055bc:	fe9788e3          	beq	a5,s1,800055ac <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    800055c0:	f9042903          	lw	s2,-112(s0)
    800055c4:	00290793          	addi	a5,s2,2
    800055c8:	00479713          	slli	a4,a5,0x4
    800055cc:	00014797          	auipc	a5,0x14
    800055d0:	42478793          	addi	a5,a5,1060 # 800199f0 <disk>
    800055d4:	97ba                	add	a5,a5,a4
    800055d6:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800055da:	00014997          	auipc	s3,0x14
    800055de:	41698993          	addi	s3,s3,1046 # 800199f0 <disk>
    800055e2:	00491713          	slli	a4,s2,0x4
    800055e6:	0009b783          	ld	a5,0(s3)
    800055ea:	97ba                	add	a5,a5,a4
    800055ec:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800055f0:	854a                	mv	a0,s2
    800055f2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800055f6:	00000097          	auipc	ra,0x0
    800055fa:	b70080e7          	jalr	-1168(ra) # 80005166 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800055fe:	8885                	andi	s1,s1,1
    80005600:	f0ed                	bnez	s1,800055e2 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005602:	00014517          	auipc	a0,0x14
    80005606:	51650513          	addi	a0,a0,1302 # 80019b18 <disk+0x128>
    8000560a:	00001097          	auipc	ra,0x1
    8000560e:	c36080e7          	jalr	-970(ra) # 80006240 <release>
}
    80005612:	70a6                	ld	ra,104(sp)
    80005614:	7406                	ld	s0,96(sp)
    80005616:	64e6                	ld	s1,88(sp)
    80005618:	6946                	ld	s2,80(sp)
    8000561a:	69a6                	ld	s3,72(sp)
    8000561c:	6a06                	ld	s4,64(sp)
    8000561e:	7ae2                	ld	s5,56(sp)
    80005620:	7b42                	ld	s6,48(sp)
    80005622:	7ba2                	ld	s7,40(sp)
    80005624:	7c02                	ld	s8,32(sp)
    80005626:	6ce2                	ld	s9,24(sp)
    80005628:	6d42                	ld	s10,16(sp)
    8000562a:	6165                	addi	sp,sp,112
    8000562c:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000562e:	4689                	li	a3,2
    80005630:	00d79623          	sh	a3,12(a5)
    80005634:	b5e5                	j	8000551c <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005636:	f9042603          	lw	a2,-112(s0)
    8000563a:	00a60713          	addi	a4,a2,10
    8000563e:	0712                	slli	a4,a4,0x4
    80005640:	00014517          	auipc	a0,0x14
    80005644:	3b850513          	addi	a0,a0,952 # 800199f8 <disk+0x8>
    80005648:	953a                	add	a0,a0,a4
  if(write)
    8000564a:	e60d14e3          	bnez	s10,800054b2 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    8000564e:	00a60793          	addi	a5,a2,10
    80005652:	00479693          	slli	a3,a5,0x4
    80005656:	00014797          	auipc	a5,0x14
    8000565a:	39a78793          	addi	a5,a5,922 # 800199f0 <disk>
    8000565e:	97b6                	add	a5,a5,a3
    80005660:	0007a423          	sw	zero,8(a5)
    80005664:	b595                	j	800054c8 <virtio_disk_rw+0xf0>

0000000080005666 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005666:	1101                	addi	sp,sp,-32
    80005668:	ec06                	sd	ra,24(sp)
    8000566a:	e822                	sd	s0,16(sp)
    8000566c:	e426                	sd	s1,8(sp)
    8000566e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005670:	00014497          	auipc	s1,0x14
    80005674:	38048493          	addi	s1,s1,896 # 800199f0 <disk>
    80005678:	00014517          	auipc	a0,0x14
    8000567c:	4a050513          	addi	a0,a0,1184 # 80019b18 <disk+0x128>
    80005680:	00001097          	auipc	ra,0x1
    80005684:	b0c080e7          	jalr	-1268(ra) # 8000618c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005688:	10001737          	lui	a4,0x10001
    8000568c:	533c                	lw	a5,96(a4)
    8000568e:	8b8d                	andi	a5,a5,3
    80005690:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005692:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005696:	689c                	ld	a5,16(s1)
    80005698:	0204d703          	lhu	a4,32(s1)
    8000569c:	0027d783          	lhu	a5,2(a5)
    800056a0:	04f70863          	beq	a4,a5,800056f0 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800056a4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056a8:	6898                	ld	a4,16(s1)
    800056aa:	0204d783          	lhu	a5,32(s1)
    800056ae:	8b9d                	andi	a5,a5,7
    800056b0:	078e                	slli	a5,a5,0x3
    800056b2:	97ba                	add	a5,a5,a4
    800056b4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056b6:	00278713          	addi	a4,a5,2
    800056ba:	0712                	slli	a4,a4,0x4
    800056bc:	9726                	add	a4,a4,s1
    800056be:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800056c2:	e721                	bnez	a4,8000570a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056c4:	0789                	addi	a5,a5,2
    800056c6:	0792                	slli	a5,a5,0x4
    800056c8:	97a6                	add	a5,a5,s1
    800056ca:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800056cc:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056d0:	ffffc097          	auipc	ra,0xffffc
    800056d4:	eec080e7          	jalr	-276(ra) # 800015bc <wakeup>

    disk.used_idx += 1;
    800056d8:	0204d783          	lhu	a5,32(s1)
    800056dc:	2785                	addiw	a5,a5,1
    800056de:	17c2                	slli	a5,a5,0x30
    800056e0:	93c1                	srli	a5,a5,0x30
    800056e2:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800056e6:	6898                	ld	a4,16(s1)
    800056e8:	00275703          	lhu	a4,2(a4)
    800056ec:	faf71ce3          	bne	a4,a5,800056a4 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800056f0:	00014517          	auipc	a0,0x14
    800056f4:	42850513          	addi	a0,a0,1064 # 80019b18 <disk+0x128>
    800056f8:	00001097          	auipc	ra,0x1
    800056fc:	b48080e7          	jalr	-1208(ra) # 80006240 <release>
}
    80005700:	60e2                	ld	ra,24(sp)
    80005702:	6442                	ld	s0,16(sp)
    80005704:	64a2                	ld	s1,8(sp)
    80005706:	6105                	addi	sp,sp,32
    80005708:	8082                	ret
      panic("virtio_disk_intr status");
    8000570a:	00003517          	auipc	a0,0x3
    8000570e:	0de50513          	addi	a0,a0,222 # 800087e8 <syscalls+0x3d8>
    80005712:	00000097          	auipc	ra,0x0
    80005716:	530080e7          	jalr	1328(ra) # 80005c42 <panic>

000000008000571a <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000571a:	1141                	addi	sp,sp,-16
    8000571c:	e422                	sd	s0,8(sp)
    8000571e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005720:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005724:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005728:	0037979b          	slliw	a5,a5,0x3
    8000572c:	02004737          	lui	a4,0x2004
    80005730:	97ba                	add	a5,a5,a4
    80005732:	0200c737          	lui	a4,0x200c
    80005736:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000573a:	000f4637          	lui	a2,0xf4
    8000573e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005742:	95b2                	add	a1,a1,a2
    80005744:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005746:	00269713          	slli	a4,a3,0x2
    8000574a:	9736                	add	a4,a4,a3
    8000574c:	00371693          	slli	a3,a4,0x3
    80005750:	00014717          	auipc	a4,0x14
    80005754:	3e070713          	addi	a4,a4,992 # 80019b30 <timer_scratch>
    80005758:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000575a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000575c:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000575e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005762:	00000797          	auipc	a5,0x0
    80005766:	93e78793          	addi	a5,a5,-1730 # 800050a0 <timervec>
    8000576a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000576e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005772:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005776:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000577a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000577e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005782:	30479073          	csrw	mie,a5
}
    80005786:	6422                	ld	s0,8(sp)
    80005788:	0141                	addi	sp,sp,16
    8000578a:	8082                	ret

000000008000578c <start>:
{
    8000578c:	1141                	addi	sp,sp,-16
    8000578e:	e406                	sd	ra,8(sp)
    80005790:	e022                	sd	s0,0(sp)
    80005792:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005794:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005798:	7779                	lui	a4,0xffffe
    8000579a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdca8f>
    8000579e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057a0:	6705                	lui	a4,0x1
    800057a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057ac:	ffffb797          	auipc	a5,0xffffb
    800057b0:	b7a78793          	addi	a5,a5,-1158 # 80000326 <main>
    800057b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800057b8:	4781                	li	a5,0
    800057ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057be:	67c1                	lui	a5,0x10
    800057c0:	17fd                	addi	a5,a5,-1
    800057c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057ce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057d6:	57fd                	li	a5,-1
    800057d8:	83a9                	srli	a5,a5,0xa
    800057da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057de:	47bd                	li	a5,15
    800057e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800057e4:	00000097          	auipc	ra,0x0
    800057e8:	f36080e7          	jalr	-202(ra) # 8000571a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800057f0:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800057f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800057f4:	30200073          	mret
}
    800057f8:	60a2                	ld	ra,8(sp)
    800057fa:	6402                	ld	s0,0(sp)
    800057fc:	0141                	addi	sp,sp,16
    800057fe:	8082                	ret

0000000080005800 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005800:	715d                	addi	sp,sp,-80
    80005802:	e486                	sd	ra,72(sp)
    80005804:	e0a2                	sd	s0,64(sp)
    80005806:	fc26                	sd	s1,56(sp)
    80005808:	f84a                	sd	s2,48(sp)
    8000580a:	f44e                	sd	s3,40(sp)
    8000580c:	f052                	sd	s4,32(sp)
    8000580e:	ec56                	sd	s5,24(sp)
    80005810:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005812:	04c05663          	blez	a2,8000585e <consolewrite+0x5e>
    80005816:	8a2a                	mv	s4,a0
    80005818:	84ae                	mv	s1,a1
    8000581a:	89b2                	mv	s3,a2
    8000581c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000581e:	5afd                	li	s5,-1
    80005820:	4685                	li	a3,1
    80005822:	8626                	mv	a2,s1
    80005824:	85d2                	mv	a1,s4
    80005826:	fbf40513          	addi	a0,s0,-65
    8000582a:	ffffc097          	auipc	ra,0xffffc
    8000582e:	18c080e7          	jalr	396(ra) # 800019b6 <either_copyin>
    80005832:	01550c63          	beq	a0,s5,8000584a <consolewrite+0x4a>
      break;
    uartputc(c);
    80005836:	fbf44503          	lbu	a0,-65(s0)
    8000583a:	00000097          	auipc	ra,0x0
    8000583e:	794080e7          	jalr	1940(ra) # 80005fce <uartputc>
  for(i = 0; i < n; i++){
    80005842:	2905                	addiw	s2,s2,1
    80005844:	0485                	addi	s1,s1,1
    80005846:	fd299de3          	bne	s3,s2,80005820 <consolewrite+0x20>
  }

  return i;
}
    8000584a:	854a                	mv	a0,s2
    8000584c:	60a6                	ld	ra,72(sp)
    8000584e:	6406                	ld	s0,64(sp)
    80005850:	74e2                	ld	s1,56(sp)
    80005852:	7942                	ld	s2,48(sp)
    80005854:	79a2                	ld	s3,40(sp)
    80005856:	7a02                	ld	s4,32(sp)
    80005858:	6ae2                	ld	s5,24(sp)
    8000585a:	6161                	addi	sp,sp,80
    8000585c:	8082                	ret
  for(i = 0; i < n; i++){
    8000585e:	4901                	li	s2,0
    80005860:	b7ed                	j	8000584a <consolewrite+0x4a>

0000000080005862 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005862:	7119                	addi	sp,sp,-128
    80005864:	fc86                	sd	ra,120(sp)
    80005866:	f8a2                	sd	s0,112(sp)
    80005868:	f4a6                	sd	s1,104(sp)
    8000586a:	f0ca                	sd	s2,96(sp)
    8000586c:	ecce                	sd	s3,88(sp)
    8000586e:	e8d2                	sd	s4,80(sp)
    80005870:	e4d6                	sd	s5,72(sp)
    80005872:	e0da                	sd	s6,64(sp)
    80005874:	fc5e                	sd	s7,56(sp)
    80005876:	f862                	sd	s8,48(sp)
    80005878:	f466                	sd	s9,40(sp)
    8000587a:	f06a                	sd	s10,32(sp)
    8000587c:	ec6e                	sd	s11,24(sp)
    8000587e:	0100                	addi	s0,sp,128
    80005880:	8b2a                	mv	s6,a0
    80005882:	8aae                	mv	s5,a1
    80005884:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005886:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    8000588a:	0001c517          	auipc	a0,0x1c
    8000588e:	3e650513          	addi	a0,a0,998 # 80021c70 <cons>
    80005892:	00001097          	auipc	ra,0x1
    80005896:	8fa080e7          	jalr	-1798(ra) # 8000618c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000589a:	0001c497          	auipc	s1,0x1c
    8000589e:	3d648493          	addi	s1,s1,982 # 80021c70 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058a2:	89a6                	mv	s3,s1
    800058a4:	0001c917          	auipc	s2,0x1c
    800058a8:	46490913          	addi	s2,s2,1124 # 80021d08 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800058ac:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058ae:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800058b0:	4da9                	li	s11,10
  while(n > 0){
    800058b2:	07405b63          	blez	s4,80005928 <consoleread+0xc6>
    while(cons.r == cons.w){
    800058b6:	0984a783          	lw	a5,152(s1)
    800058ba:	09c4a703          	lw	a4,156(s1)
    800058be:	02f71763          	bne	a4,a5,800058ec <consoleread+0x8a>
      if(killed(myproc())){
    800058c2:	ffffb097          	auipc	ra,0xffffb
    800058c6:	5ee080e7          	jalr	1518(ra) # 80000eb0 <myproc>
    800058ca:	ffffc097          	auipc	ra,0xffffc
    800058ce:	f36080e7          	jalr	-202(ra) # 80001800 <killed>
    800058d2:	e535                	bnez	a0,8000593e <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    800058d4:	85ce                	mv	a1,s3
    800058d6:	854a                	mv	a0,s2
    800058d8:	ffffc097          	auipc	ra,0xffffc
    800058dc:	c80080e7          	jalr	-896(ra) # 80001558 <sleep>
    while(cons.r == cons.w){
    800058e0:	0984a783          	lw	a5,152(s1)
    800058e4:	09c4a703          	lw	a4,156(s1)
    800058e8:	fcf70de3          	beq	a4,a5,800058c2 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800058ec:	0017871b          	addiw	a4,a5,1
    800058f0:	08e4ac23          	sw	a4,152(s1)
    800058f4:	07f7f713          	andi	a4,a5,127
    800058f8:	9726                	add	a4,a4,s1
    800058fa:	01874703          	lbu	a4,24(a4)
    800058fe:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005902:	079c0663          	beq	s8,s9,8000596e <consoleread+0x10c>
    cbuf = c;
    80005906:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000590a:	4685                	li	a3,1
    8000590c:	f8f40613          	addi	a2,s0,-113
    80005910:	85d6                	mv	a1,s5
    80005912:	855a                	mv	a0,s6
    80005914:	ffffc097          	auipc	ra,0xffffc
    80005918:	04c080e7          	jalr	76(ra) # 80001960 <either_copyout>
    8000591c:	01a50663          	beq	a0,s10,80005928 <consoleread+0xc6>
    dst++;
    80005920:	0a85                	addi	s5,s5,1
    --n;
    80005922:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005924:	f9bc17e3          	bne	s8,s11,800058b2 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005928:	0001c517          	auipc	a0,0x1c
    8000592c:	34850513          	addi	a0,a0,840 # 80021c70 <cons>
    80005930:	00001097          	auipc	ra,0x1
    80005934:	910080e7          	jalr	-1776(ra) # 80006240 <release>

  return target - n;
    80005938:	414b853b          	subw	a0,s7,s4
    8000593c:	a811                	j	80005950 <consoleread+0xee>
        release(&cons.lock);
    8000593e:	0001c517          	auipc	a0,0x1c
    80005942:	33250513          	addi	a0,a0,818 # 80021c70 <cons>
    80005946:	00001097          	auipc	ra,0x1
    8000594a:	8fa080e7          	jalr	-1798(ra) # 80006240 <release>
        return -1;
    8000594e:	557d                	li	a0,-1
}
    80005950:	70e6                	ld	ra,120(sp)
    80005952:	7446                	ld	s0,112(sp)
    80005954:	74a6                	ld	s1,104(sp)
    80005956:	7906                	ld	s2,96(sp)
    80005958:	69e6                	ld	s3,88(sp)
    8000595a:	6a46                	ld	s4,80(sp)
    8000595c:	6aa6                	ld	s5,72(sp)
    8000595e:	6b06                	ld	s6,64(sp)
    80005960:	7be2                	ld	s7,56(sp)
    80005962:	7c42                	ld	s8,48(sp)
    80005964:	7ca2                	ld	s9,40(sp)
    80005966:	7d02                	ld	s10,32(sp)
    80005968:	6de2                	ld	s11,24(sp)
    8000596a:	6109                	addi	sp,sp,128
    8000596c:	8082                	ret
      if(n < target){
    8000596e:	000a071b          	sext.w	a4,s4
    80005972:	fb777be3          	bgeu	a4,s7,80005928 <consoleread+0xc6>
        cons.r--;
    80005976:	0001c717          	auipc	a4,0x1c
    8000597a:	38f72923          	sw	a5,914(a4) # 80021d08 <cons+0x98>
    8000597e:	b76d                	j	80005928 <consoleread+0xc6>

0000000080005980 <consputc>:
{
    80005980:	1141                	addi	sp,sp,-16
    80005982:	e406                	sd	ra,8(sp)
    80005984:	e022                	sd	s0,0(sp)
    80005986:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005988:	10000793          	li	a5,256
    8000598c:	00f50a63          	beq	a0,a5,800059a0 <consputc+0x20>
    uartputc_sync(c);
    80005990:	00000097          	auipc	ra,0x0
    80005994:	564080e7          	jalr	1380(ra) # 80005ef4 <uartputc_sync>
}
    80005998:	60a2                	ld	ra,8(sp)
    8000599a:	6402                	ld	s0,0(sp)
    8000599c:	0141                	addi	sp,sp,16
    8000599e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059a0:	4521                	li	a0,8
    800059a2:	00000097          	auipc	ra,0x0
    800059a6:	552080e7          	jalr	1362(ra) # 80005ef4 <uartputc_sync>
    800059aa:	02000513          	li	a0,32
    800059ae:	00000097          	auipc	ra,0x0
    800059b2:	546080e7          	jalr	1350(ra) # 80005ef4 <uartputc_sync>
    800059b6:	4521                	li	a0,8
    800059b8:	00000097          	auipc	ra,0x0
    800059bc:	53c080e7          	jalr	1340(ra) # 80005ef4 <uartputc_sync>
    800059c0:	bfe1                	j	80005998 <consputc+0x18>

00000000800059c2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059c2:	1101                	addi	sp,sp,-32
    800059c4:	ec06                	sd	ra,24(sp)
    800059c6:	e822                	sd	s0,16(sp)
    800059c8:	e426                	sd	s1,8(sp)
    800059ca:	e04a                	sd	s2,0(sp)
    800059cc:	1000                	addi	s0,sp,32
    800059ce:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059d0:	0001c517          	auipc	a0,0x1c
    800059d4:	2a050513          	addi	a0,a0,672 # 80021c70 <cons>
    800059d8:	00000097          	auipc	ra,0x0
    800059dc:	7b4080e7          	jalr	1972(ra) # 8000618c <acquire>

  switch(c){
    800059e0:	47d5                	li	a5,21
    800059e2:	0af48663          	beq	s1,a5,80005a8e <consoleintr+0xcc>
    800059e6:	0297ca63          	blt	a5,s1,80005a1a <consoleintr+0x58>
    800059ea:	47a1                	li	a5,8
    800059ec:	0ef48763          	beq	s1,a5,80005ada <consoleintr+0x118>
    800059f0:	47c1                	li	a5,16
    800059f2:	10f49a63          	bne	s1,a5,80005b06 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800059f6:	ffffc097          	auipc	ra,0xffffc
    800059fa:	016080e7          	jalr	22(ra) # 80001a0c <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800059fe:	0001c517          	auipc	a0,0x1c
    80005a02:	27250513          	addi	a0,a0,626 # 80021c70 <cons>
    80005a06:	00001097          	auipc	ra,0x1
    80005a0a:	83a080e7          	jalr	-1990(ra) # 80006240 <release>
}
    80005a0e:	60e2                	ld	ra,24(sp)
    80005a10:	6442                	ld	s0,16(sp)
    80005a12:	64a2                	ld	s1,8(sp)
    80005a14:	6902                	ld	s2,0(sp)
    80005a16:	6105                	addi	sp,sp,32
    80005a18:	8082                	ret
  switch(c){
    80005a1a:	07f00793          	li	a5,127
    80005a1e:	0af48e63          	beq	s1,a5,80005ada <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005a22:	0001c717          	auipc	a4,0x1c
    80005a26:	24e70713          	addi	a4,a4,590 # 80021c70 <cons>
    80005a2a:	0a072783          	lw	a5,160(a4)
    80005a2e:	09872703          	lw	a4,152(a4)
    80005a32:	9f99                	subw	a5,a5,a4
    80005a34:	07f00713          	li	a4,127
    80005a38:	fcf763e3          	bltu	a4,a5,800059fe <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a3c:	47b5                	li	a5,13
    80005a3e:	0cf48763          	beq	s1,a5,80005b0c <consoleintr+0x14a>
      consputc(c);
    80005a42:	8526                	mv	a0,s1
    80005a44:	00000097          	auipc	ra,0x0
    80005a48:	f3c080e7          	jalr	-196(ra) # 80005980 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a4c:	0001c797          	auipc	a5,0x1c
    80005a50:	22478793          	addi	a5,a5,548 # 80021c70 <cons>
    80005a54:	0a07a683          	lw	a3,160(a5)
    80005a58:	0016871b          	addiw	a4,a3,1
    80005a5c:	0007061b          	sext.w	a2,a4
    80005a60:	0ae7a023          	sw	a4,160(a5)
    80005a64:	07f6f693          	andi	a3,a3,127
    80005a68:	97b6                	add	a5,a5,a3
    80005a6a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005a6e:	47a9                	li	a5,10
    80005a70:	0cf48563          	beq	s1,a5,80005b3a <consoleintr+0x178>
    80005a74:	4791                	li	a5,4
    80005a76:	0cf48263          	beq	s1,a5,80005b3a <consoleintr+0x178>
    80005a7a:	0001c797          	auipc	a5,0x1c
    80005a7e:	28e7a783          	lw	a5,654(a5) # 80021d08 <cons+0x98>
    80005a82:	9f1d                	subw	a4,a4,a5
    80005a84:	08000793          	li	a5,128
    80005a88:	f6f71be3          	bne	a4,a5,800059fe <consoleintr+0x3c>
    80005a8c:	a07d                	j	80005b3a <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005a8e:	0001c717          	auipc	a4,0x1c
    80005a92:	1e270713          	addi	a4,a4,482 # 80021c70 <cons>
    80005a96:	0a072783          	lw	a5,160(a4)
    80005a9a:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005a9e:	0001c497          	auipc	s1,0x1c
    80005aa2:	1d248493          	addi	s1,s1,466 # 80021c70 <cons>
    while(cons.e != cons.w &&
    80005aa6:	4929                	li	s2,10
    80005aa8:	f4f70be3          	beq	a4,a5,800059fe <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005aac:	37fd                	addiw	a5,a5,-1
    80005aae:	07f7f713          	andi	a4,a5,127
    80005ab2:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ab4:	01874703          	lbu	a4,24(a4)
    80005ab8:	f52703e3          	beq	a4,s2,800059fe <consoleintr+0x3c>
      cons.e--;
    80005abc:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ac0:	10000513          	li	a0,256
    80005ac4:	00000097          	auipc	ra,0x0
    80005ac8:	ebc080e7          	jalr	-324(ra) # 80005980 <consputc>
    while(cons.e != cons.w &&
    80005acc:	0a04a783          	lw	a5,160(s1)
    80005ad0:	09c4a703          	lw	a4,156(s1)
    80005ad4:	fcf71ce3          	bne	a4,a5,80005aac <consoleintr+0xea>
    80005ad8:	b71d                	j	800059fe <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005ada:	0001c717          	auipc	a4,0x1c
    80005ade:	19670713          	addi	a4,a4,406 # 80021c70 <cons>
    80005ae2:	0a072783          	lw	a5,160(a4)
    80005ae6:	09c72703          	lw	a4,156(a4)
    80005aea:	f0f70ae3          	beq	a4,a5,800059fe <consoleintr+0x3c>
      cons.e--;
    80005aee:	37fd                	addiw	a5,a5,-1
    80005af0:	0001c717          	auipc	a4,0x1c
    80005af4:	22f72023          	sw	a5,544(a4) # 80021d10 <cons+0xa0>
      consputc(BACKSPACE);
    80005af8:	10000513          	li	a0,256
    80005afc:	00000097          	auipc	ra,0x0
    80005b00:	e84080e7          	jalr	-380(ra) # 80005980 <consputc>
    80005b04:	bded                	j	800059fe <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b06:	ee048ce3          	beqz	s1,800059fe <consoleintr+0x3c>
    80005b0a:	bf21                	j	80005a22 <consoleintr+0x60>
      consputc(c);
    80005b0c:	4529                	li	a0,10
    80005b0e:	00000097          	auipc	ra,0x0
    80005b12:	e72080e7          	jalr	-398(ra) # 80005980 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b16:	0001c797          	auipc	a5,0x1c
    80005b1a:	15a78793          	addi	a5,a5,346 # 80021c70 <cons>
    80005b1e:	0a07a703          	lw	a4,160(a5)
    80005b22:	0017069b          	addiw	a3,a4,1
    80005b26:	0006861b          	sext.w	a2,a3
    80005b2a:	0ad7a023          	sw	a3,160(a5)
    80005b2e:	07f77713          	andi	a4,a4,127
    80005b32:	97ba                	add	a5,a5,a4
    80005b34:	4729                	li	a4,10
    80005b36:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b3a:	0001c797          	auipc	a5,0x1c
    80005b3e:	1cc7a923          	sw	a2,466(a5) # 80021d0c <cons+0x9c>
        wakeup(&cons.r);
    80005b42:	0001c517          	auipc	a0,0x1c
    80005b46:	1c650513          	addi	a0,a0,454 # 80021d08 <cons+0x98>
    80005b4a:	ffffc097          	auipc	ra,0xffffc
    80005b4e:	a72080e7          	jalr	-1422(ra) # 800015bc <wakeup>
    80005b52:	b575                	j	800059fe <consoleintr+0x3c>

0000000080005b54 <consoleinit>:

void
consoleinit(void)
{
    80005b54:	1141                	addi	sp,sp,-16
    80005b56:	e406                	sd	ra,8(sp)
    80005b58:	e022                	sd	s0,0(sp)
    80005b5a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b5c:	00003597          	auipc	a1,0x3
    80005b60:	ca458593          	addi	a1,a1,-860 # 80008800 <syscalls+0x3f0>
    80005b64:	0001c517          	auipc	a0,0x1c
    80005b68:	10c50513          	addi	a0,a0,268 # 80021c70 <cons>
    80005b6c:	00000097          	auipc	ra,0x0
    80005b70:	590080e7          	jalr	1424(ra) # 800060fc <initlock>

  uartinit();
    80005b74:	00000097          	auipc	ra,0x0
    80005b78:	330080e7          	jalr	816(ra) # 80005ea4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b7c:	00013797          	auipc	a5,0x13
    80005b80:	e1c78793          	addi	a5,a5,-484 # 80018998 <devsw>
    80005b84:	00000717          	auipc	a4,0x0
    80005b88:	cde70713          	addi	a4,a4,-802 # 80005862 <consoleread>
    80005b8c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b8e:	00000717          	auipc	a4,0x0
    80005b92:	c7270713          	addi	a4,a4,-910 # 80005800 <consolewrite>
    80005b96:	ef98                	sd	a4,24(a5)
}
    80005b98:	60a2                	ld	ra,8(sp)
    80005b9a:	6402                	ld	s0,0(sp)
    80005b9c:	0141                	addi	sp,sp,16
    80005b9e:	8082                	ret

0000000080005ba0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005ba0:	7179                	addi	sp,sp,-48
    80005ba2:	f406                	sd	ra,40(sp)
    80005ba4:	f022                	sd	s0,32(sp)
    80005ba6:	ec26                	sd	s1,24(sp)
    80005ba8:	e84a                	sd	s2,16(sp)
    80005baa:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005bac:	c219                	beqz	a2,80005bb2 <printint+0x12>
    80005bae:	08054663          	bltz	a0,80005c3a <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005bb2:	2501                	sext.w	a0,a0
    80005bb4:	4881                	li	a7,0
    80005bb6:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005bba:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005bbc:	2581                	sext.w	a1,a1
    80005bbe:	00003617          	auipc	a2,0x3
    80005bc2:	c7260613          	addi	a2,a2,-910 # 80008830 <digits>
    80005bc6:	883a                	mv	a6,a4
    80005bc8:	2705                	addiw	a4,a4,1
    80005bca:	02b577bb          	remuw	a5,a0,a1
    80005bce:	1782                	slli	a5,a5,0x20
    80005bd0:	9381                	srli	a5,a5,0x20
    80005bd2:	97b2                	add	a5,a5,a2
    80005bd4:	0007c783          	lbu	a5,0(a5)
    80005bd8:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005bdc:	0005079b          	sext.w	a5,a0
    80005be0:	02b5553b          	divuw	a0,a0,a1
    80005be4:	0685                	addi	a3,a3,1
    80005be6:	feb7f0e3          	bgeu	a5,a1,80005bc6 <printint+0x26>

  if(sign)
    80005bea:	00088b63          	beqz	a7,80005c00 <printint+0x60>
    buf[i++] = '-';
    80005bee:	fe040793          	addi	a5,s0,-32
    80005bf2:	973e                	add	a4,a4,a5
    80005bf4:	02d00793          	li	a5,45
    80005bf8:	fef70823          	sb	a5,-16(a4)
    80005bfc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c00:	02e05763          	blez	a4,80005c2e <printint+0x8e>
    80005c04:	fd040793          	addi	a5,s0,-48
    80005c08:	00e784b3          	add	s1,a5,a4
    80005c0c:	fff78913          	addi	s2,a5,-1
    80005c10:	993a                	add	s2,s2,a4
    80005c12:	377d                	addiw	a4,a4,-1
    80005c14:	1702                	slli	a4,a4,0x20
    80005c16:	9301                	srli	a4,a4,0x20
    80005c18:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c1c:	fff4c503          	lbu	a0,-1(s1)
    80005c20:	00000097          	auipc	ra,0x0
    80005c24:	d60080e7          	jalr	-672(ra) # 80005980 <consputc>
  while(--i >= 0)
    80005c28:	14fd                	addi	s1,s1,-1
    80005c2a:	ff2499e3          	bne	s1,s2,80005c1c <printint+0x7c>
}
    80005c2e:	70a2                	ld	ra,40(sp)
    80005c30:	7402                	ld	s0,32(sp)
    80005c32:	64e2                	ld	s1,24(sp)
    80005c34:	6942                	ld	s2,16(sp)
    80005c36:	6145                	addi	sp,sp,48
    80005c38:	8082                	ret
    x = -xx;
    80005c3a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c3e:	4885                	li	a7,1
    x = -xx;
    80005c40:	bf9d                	j	80005bb6 <printint+0x16>

0000000080005c42 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c42:	1101                	addi	sp,sp,-32
    80005c44:	ec06                	sd	ra,24(sp)
    80005c46:	e822                	sd	s0,16(sp)
    80005c48:	e426                	sd	s1,8(sp)
    80005c4a:	1000                	addi	s0,sp,32
    80005c4c:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c4e:	0001c797          	auipc	a5,0x1c
    80005c52:	0e07a123          	sw	zero,226(a5) # 80021d30 <pr+0x18>
  printf("panic: ");
    80005c56:	00003517          	auipc	a0,0x3
    80005c5a:	bb250513          	addi	a0,a0,-1102 # 80008808 <syscalls+0x3f8>
    80005c5e:	00000097          	auipc	ra,0x0
    80005c62:	02e080e7          	jalr	46(ra) # 80005c8c <printf>
  printf(s);
    80005c66:	8526                	mv	a0,s1
    80005c68:	00000097          	auipc	ra,0x0
    80005c6c:	024080e7          	jalr	36(ra) # 80005c8c <printf>
  printf("\n");
    80005c70:	00002517          	auipc	a0,0x2
    80005c74:	3d850513          	addi	a0,a0,984 # 80008048 <etext+0x48>
    80005c78:	00000097          	auipc	ra,0x0
    80005c7c:	014080e7          	jalr	20(ra) # 80005c8c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c80:	4785                	li	a5,1
    80005c82:	00003717          	auipc	a4,0x3
    80005c86:	c6f72523          	sw	a5,-918(a4) # 800088ec <panicked>
  for(;;)
    80005c8a:	a001                	j	80005c8a <panic+0x48>

0000000080005c8c <printf>:
{
    80005c8c:	7131                	addi	sp,sp,-192
    80005c8e:	fc86                	sd	ra,120(sp)
    80005c90:	f8a2                	sd	s0,112(sp)
    80005c92:	f4a6                	sd	s1,104(sp)
    80005c94:	f0ca                	sd	s2,96(sp)
    80005c96:	ecce                	sd	s3,88(sp)
    80005c98:	e8d2                	sd	s4,80(sp)
    80005c9a:	e4d6                	sd	s5,72(sp)
    80005c9c:	e0da                	sd	s6,64(sp)
    80005c9e:	fc5e                	sd	s7,56(sp)
    80005ca0:	f862                	sd	s8,48(sp)
    80005ca2:	f466                	sd	s9,40(sp)
    80005ca4:	f06a                	sd	s10,32(sp)
    80005ca6:	ec6e                	sd	s11,24(sp)
    80005ca8:	0100                	addi	s0,sp,128
    80005caa:	8a2a                	mv	s4,a0
    80005cac:	e40c                	sd	a1,8(s0)
    80005cae:	e810                	sd	a2,16(s0)
    80005cb0:	ec14                	sd	a3,24(s0)
    80005cb2:	f018                	sd	a4,32(s0)
    80005cb4:	f41c                	sd	a5,40(s0)
    80005cb6:	03043823          	sd	a6,48(s0)
    80005cba:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005cbe:	0001cd97          	auipc	s11,0x1c
    80005cc2:	072dad83          	lw	s11,114(s11) # 80021d30 <pr+0x18>
  if(locking)
    80005cc6:	020d9b63          	bnez	s11,80005cfc <printf+0x70>
  if (fmt == 0)
    80005cca:	040a0263          	beqz	s4,80005d0e <printf+0x82>
  va_start(ap, fmt);
    80005cce:	00840793          	addi	a5,s0,8
    80005cd2:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cd6:	000a4503          	lbu	a0,0(s4)
    80005cda:	16050263          	beqz	a0,80005e3e <printf+0x1b2>
    80005cde:	4481                	li	s1,0
    if(c != '%'){
    80005ce0:	02500a93          	li	s5,37
    switch(c){
    80005ce4:	07000b13          	li	s6,112
  consputc('x');
    80005ce8:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005cea:	00003b97          	auipc	s7,0x3
    80005cee:	b46b8b93          	addi	s7,s7,-1210 # 80008830 <digits>
    switch(c){
    80005cf2:	07300c93          	li	s9,115
    80005cf6:	06400c13          	li	s8,100
    80005cfa:	a82d                	j	80005d34 <printf+0xa8>
    acquire(&pr.lock);
    80005cfc:	0001c517          	auipc	a0,0x1c
    80005d00:	01c50513          	addi	a0,a0,28 # 80021d18 <pr>
    80005d04:	00000097          	auipc	ra,0x0
    80005d08:	488080e7          	jalr	1160(ra) # 8000618c <acquire>
    80005d0c:	bf7d                	j	80005cca <printf+0x3e>
    panic("null fmt");
    80005d0e:	00003517          	auipc	a0,0x3
    80005d12:	b0a50513          	addi	a0,a0,-1270 # 80008818 <syscalls+0x408>
    80005d16:	00000097          	auipc	ra,0x0
    80005d1a:	f2c080e7          	jalr	-212(ra) # 80005c42 <panic>
      consputc(c);
    80005d1e:	00000097          	auipc	ra,0x0
    80005d22:	c62080e7          	jalr	-926(ra) # 80005980 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d26:	2485                	addiw	s1,s1,1
    80005d28:	009a07b3          	add	a5,s4,s1
    80005d2c:	0007c503          	lbu	a0,0(a5)
    80005d30:	10050763          	beqz	a0,80005e3e <printf+0x1b2>
    if(c != '%'){
    80005d34:	ff5515e3          	bne	a0,s5,80005d1e <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d38:	2485                	addiw	s1,s1,1
    80005d3a:	009a07b3          	add	a5,s4,s1
    80005d3e:	0007c783          	lbu	a5,0(a5)
    80005d42:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005d46:	cfe5                	beqz	a5,80005e3e <printf+0x1b2>
    switch(c){
    80005d48:	05678a63          	beq	a5,s6,80005d9c <printf+0x110>
    80005d4c:	02fb7663          	bgeu	s6,a5,80005d78 <printf+0xec>
    80005d50:	09978963          	beq	a5,s9,80005de2 <printf+0x156>
    80005d54:	07800713          	li	a4,120
    80005d58:	0ce79863          	bne	a5,a4,80005e28 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005d5c:	f8843783          	ld	a5,-120(s0)
    80005d60:	00878713          	addi	a4,a5,8
    80005d64:	f8e43423          	sd	a4,-120(s0)
    80005d68:	4605                	li	a2,1
    80005d6a:	85ea                	mv	a1,s10
    80005d6c:	4388                	lw	a0,0(a5)
    80005d6e:	00000097          	auipc	ra,0x0
    80005d72:	e32080e7          	jalr	-462(ra) # 80005ba0 <printint>
      break;
    80005d76:	bf45                	j	80005d26 <printf+0x9a>
    switch(c){
    80005d78:	0b578263          	beq	a5,s5,80005e1c <printf+0x190>
    80005d7c:	0b879663          	bne	a5,s8,80005e28 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005d80:	f8843783          	ld	a5,-120(s0)
    80005d84:	00878713          	addi	a4,a5,8
    80005d88:	f8e43423          	sd	a4,-120(s0)
    80005d8c:	4605                	li	a2,1
    80005d8e:	45a9                	li	a1,10
    80005d90:	4388                	lw	a0,0(a5)
    80005d92:	00000097          	auipc	ra,0x0
    80005d96:	e0e080e7          	jalr	-498(ra) # 80005ba0 <printint>
      break;
    80005d9a:	b771                	j	80005d26 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005d9c:	f8843783          	ld	a5,-120(s0)
    80005da0:	00878713          	addi	a4,a5,8
    80005da4:	f8e43423          	sd	a4,-120(s0)
    80005da8:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005dac:	03000513          	li	a0,48
    80005db0:	00000097          	auipc	ra,0x0
    80005db4:	bd0080e7          	jalr	-1072(ra) # 80005980 <consputc>
  consputc('x');
    80005db8:	07800513          	li	a0,120
    80005dbc:	00000097          	auipc	ra,0x0
    80005dc0:	bc4080e7          	jalr	-1084(ra) # 80005980 <consputc>
    80005dc4:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005dc6:	03c9d793          	srli	a5,s3,0x3c
    80005dca:	97de                	add	a5,a5,s7
    80005dcc:	0007c503          	lbu	a0,0(a5)
    80005dd0:	00000097          	auipc	ra,0x0
    80005dd4:	bb0080e7          	jalr	-1104(ra) # 80005980 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005dd8:	0992                	slli	s3,s3,0x4
    80005dda:	397d                	addiw	s2,s2,-1
    80005ddc:	fe0915e3          	bnez	s2,80005dc6 <printf+0x13a>
    80005de0:	b799                	j	80005d26 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005de2:	f8843783          	ld	a5,-120(s0)
    80005de6:	00878713          	addi	a4,a5,8
    80005dea:	f8e43423          	sd	a4,-120(s0)
    80005dee:	0007b903          	ld	s2,0(a5)
    80005df2:	00090e63          	beqz	s2,80005e0e <printf+0x182>
      for(; *s; s++)
    80005df6:	00094503          	lbu	a0,0(s2)
    80005dfa:	d515                	beqz	a0,80005d26 <printf+0x9a>
        consputc(*s);
    80005dfc:	00000097          	auipc	ra,0x0
    80005e00:	b84080e7          	jalr	-1148(ra) # 80005980 <consputc>
      for(; *s; s++)
    80005e04:	0905                	addi	s2,s2,1
    80005e06:	00094503          	lbu	a0,0(s2)
    80005e0a:	f96d                	bnez	a0,80005dfc <printf+0x170>
    80005e0c:	bf29                	j	80005d26 <printf+0x9a>
        s = "(null)";
    80005e0e:	00003917          	auipc	s2,0x3
    80005e12:	a0290913          	addi	s2,s2,-1534 # 80008810 <syscalls+0x400>
      for(; *s; s++)
    80005e16:	02800513          	li	a0,40
    80005e1a:	b7cd                	j	80005dfc <printf+0x170>
      consputc('%');
    80005e1c:	8556                	mv	a0,s5
    80005e1e:	00000097          	auipc	ra,0x0
    80005e22:	b62080e7          	jalr	-1182(ra) # 80005980 <consputc>
      break;
    80005e26:	b701                	j	80005d26 <printf+0x9a>
      consputc('%');
    80005e28:	8556                	mv	a0,s5
    80005e2a:	00000097          	auipc	ra,0x0
    80005e2e:	b56080e7          	jalr	-1194(ra) # 80005980 <consputc>
      consputc(c);
    80005e32:	854a                	mv	a0,s2
    80005e34:	00000097          	auipc	ra,0x0
    80005e38:	b4c080e7          	jalr	-1204(ra) # 80005980 <consputc>
      break;
    80005e3c:	b5ed                	j	80005d26 <printf+0x9a>
  if(locking)
    80005e3e:	020d9163          	bnez	s11,80005e60 <printf+0x1d4>
}
    80005e42:	70e6                	ld	ra,120(sp)
    80005e44:	7446                	ld	s0,112(sp)
    80005e46:	74a6                	ld	s1,104(sp)
    80005e48:	7906                	ld	s2,96(sp)
    80005e4a:	69e6                	ld	s3,88(sp)
    80005e4c:	6a46                	ld	s4,80(sp)
    80005e4e:	6aa6                	ld	s5,72(sp)
    80005e50:	6b06                	ld	s6,64(sp)
    80005e52:	7be2                	ld	s7,56(sp)
    80005e54:	7c42                	ld	s8,48(sp)
    80005e56:	7ca2                	ld	s9,40(sp)
    80005e58:	7d02                	ld	s10,32(sp)
    80005e5a:	6de2                	ld	s11,24(sp)
    80005e5c:	6129                	addi	sp,sp,192
    80005e5e:	8082                	ret
    release(&pr.lock);
    80005e60:	0001c517          	auipc	a0,0x1c
    80005e64:	eb850513          	addi	a0,a0,-328 # 80021d18 <pr>
    80005e68:	00000097          	auipc	ra,0x0
    80005e6c:	3d8080e7          	jalr	984(ra) # 80006240 <release>
}
    80005e70:	bfc9                	j	80005e42 <printf+0x1b6>

0000000080005e72 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e72:	1101                	addi	sp,sp,-32
    80005e74:	ec06                	sd	ra,24(sp)
    80005e76:	e822                	sd	s0,16(sp)
    80005e78:	e426                	sd	s1,8(sp)
    80005e7a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e7c:	0001c497          	auipc	s1,0x1c
    80005e80:	e9c48493          	addi	s1,s1,-356 # 80021d18 <pr>
    80005e84:	00003597          	auipc	a1,0x3
    80005e88:	9a458593          	addi	a1,a1,-1628 # 80008828 <syscalls+0x418>
    80005e8c:	8526                	mv	a0,s1
    80005e8e:	00000097          	auipc	ra,0x0
    80005e92:	26e080e7          	jalr	622(ra) # 800060fc <initlock>
  pr.locking = 1;
    80005e96:	4785                	li	a5,1
    80005e98:	cc9c                	sw	a5,24(s1)
}
    80005e9a:	60e2                	ld	ra,24(sp)
    80005e9c:	6442                	ld	s0,16(sp)
    80005e9e:	64a2                	ld	s1,8(sp)
    80005ea0:	6105                	addi	sp,sp,32
    80005ea2:	8082                	ret

0000000080005ea4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ea4:	1141                	addi	sp,sp,-16
    80005ea6:	e406                	sd	ra,8(sp)
    80005ea8:	e022                	sd	s0,0(sp)
    80005eaa:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005eac:	100007b7          	lui	a5,0x10000
    80005eb0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005eb4:	f8000713          	li	a4,-128
    80005eb8:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005ebc:	470d                	li	a4,3
    80005ebe:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005ec2:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005ec6:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005eca:	469d                	li	a3,7
    80005ecc:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005ed0:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005ed4:	00003597          	auipc	a1,0x3
    80005ed8:	97458593          	addi	a1,a1,-1676 # 80008848 <digits+0x18>
    80005edc:	0001c517          	auipc	a0,0x1c
    80005ee0:	e5c50513          	addi	a0,a0,-420 # 80021d38 <uart_tx_lock>
    80005ee4:	00000097          	auipc	ra,0x0
    80005ee8:	218080e7          	jalr	536(ra) # 800060fc <initlock>
}
    80005eec:	60a2                	ld	ra,8(sp)
    80005eee:	6402                	ld	s0,0(sp)
    80005ef0:	0141                	addi	sp,sp,16
    80005ef2:	8082                	ret

0000000080005ef4 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005ef4:	1101                	addi	sp,sp,-32
    80005ef6:	ec06                	sd	ra,24(sp)
    80005ef8:	e822                	sd	s0,16(sp)
    80005efa:	e426                	sd	s1,8(sp)
    80005efc:	1000                	addi	s0,sp,32
    80005efe:	84aa                	mv	s1,a0
  push_off();
    80005f00:	00000097          	auipc	ra,0x0
    80005f04:	240080e7          	jalr	576(ra) # 80006140 <push_off>

  if(panicked){
    80005f08:	00003797          	auipc	a5,0x3
    80005f0c:	9e47a783          	lw	a5,-1564(a5) # 800088ec <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f10:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f14:	c391                	beqz	a5,80005f18 <uartputc_sync+0x24>
    for(;;)
    80005f16:	a001                	j	80005f16 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f18:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f1c:	0ff7f793          	andi	a5,a5,255
    80005f20:	0207f793          	andi	a5,a5,32
    80005f24:	dbf5                	beqz	a5,80005f18 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f26:	0ff4f793          	andi	a5,s1,255
    80005f2a:	10000737          	lui	a4,0x10000
    80005f2e:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f32:	00000097          	auipc	ra,0x0
    80005f36:	2ae080e7          	jalr	686(ra) # 800061e0 <pop_off>
}
    80005f3a:	60e2                	ld	ra,24(sp)
    80005f3c:	6442                	ld	s0,16(sp)
    80005f3e:	64a2                	ld	s1,8(sp)
    80005f40:	6105                	addi	sp,sp,32
    80005f42:	8082                	ret

0000000080005f44 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f44:	00003717          	auipc	a4,0x3
    80005f48:	9ac73703          	ld	a4,-1620(a4) # 800088f0 <uart_tx_r>
    80005f4c:	00003797          	auipc	a5,0x3
    80005f50:	9ac7b783          	ld	a5,-1620(a5) # 800088f8 <uart_tx_w>
    80005f54:	06e78c63          	beq	a5,a4,80005fcc <uartstart+0x88>
{
    80005f58:	7139                	addi	sp,sp,-64
    80005f5a:	fc06                	sd	ra,56(sp)
    80005f5c:	f822                	sd	s0,48(sp)
    80005f5e:	f426                	sd	s1,40(sp)
    80005f60:	f04a                	sd	s2,32(sp)
    80005f62:	ec4e                	sd	s3,24(sp)
    80005f64:	e852                	sd	s4,16(sp)
    80005f66:	e456                	sd	s5,8(sp)
    80005f68:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f6a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f6e:	0001ca17          	auipc	s4,0x1c
    80005f72:	dcaa0a13          	addi	s4,s4,-566 # 80021d38 <uart_tx_lock>
    uart_tx_r += 1;
    80005f76:	00003497          	auipc	s1,0x3
    80005f7a:	97a48493          	addi	s1,s1,-1670 # 800088f0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005f7e:	00003997          	auipc	s3,0x3
    80005f82:	97a98993          	addi	s3,s3,-1670 # 800088f8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f86:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005f8a:	0ff7f793          	andi	a5,a5,255
    80005f8e:	0207f793          	andi	a5,a5,32
    80005f92:	c785                	beqz	a5,80005fba <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f94:	01f77793          	andi	a5,a4,31
    80005f98:	97d2                	add	a5,a5,s4
    80005f9a:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80005f9e:	0705                	addi	a4,a4,1
    80005fa0:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005fa2:	8526                	mv	a0,s1
    80005fa4:	ffffb097          	auipc	ra,0xffffb
    80005fa8:	618080e7          	jalr	1560(ra) # 800015bc <wakeup>
    
    WriteReg(THR, c);
    80005fac:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005fb0:	6098                	ld	a4,0(s1)
    80005fb2:	0009b783          	ld	a5,0(s3)
    80005fb6:	fce798e3          	bne	a5,a4,80005f86 <uartstart+0x42>
  }
}
    80005fba:	70e2                	ld	ra,56(sp)
    80005fbc:	7442                	ld	s0,48(sp)
    80005fbe:	74a2                	ld	s1,40(sp)
    80005fc0:	7902                	ld	s2,32(sp)
    80005fc2:	69e2                	ld	s3,24(sp)
    80005fc4:	6a42                	ld	s4,16(sp)
    80005fc6:	6aa2                	ld	s5,8(sp)
    80005fc8:	6121                	addi	sp,sp,64
    80005fca:	8082                	ret
    80005fcc:	8082                	ret

0000000080005fce <uartputc>:
{
    80005fce:	7179                	addi	sp,sp,-48
    80005fd0:	f406                	sd	ra,40(sp)
    80005fd2:	f022                	sd	s0,32(sp)
    80005fd4:	ec26                	sd	s1,24(sp)
    80005fd6:	e84a                	sd	s2,16(sp)
    80005fd8:	e44e                	sd	s3,8(sp)
    80005fda:	e052                	sd	s4,0(sp)
    80005fdc:	1800                	addi	s0,sp,48
    80005fde:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80005fe0:	0001c517          	auipc	a0,0x1c
    80005fe4:	d5850513          	addi	a0,a0,-680 # 80021d38 <uart_tx_lock>
    80005fe8:	00000097          	auipc	ra,0x0
    80005fec:	1a4080e7          	jalr	420(ra) # 8000618c <acquire>
  if(panicked){
    80005ff0:	00003797          	auipc	a5,0x3
    80005ff4:	8fc7a783          	lw	a5,-1796(a5) # 800088ec <panicked>
    80005ff8:	e7c9                	bnez	a5,80006082 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005ffa:	00003797          	auipc	a5,0x3
    80005ffe:	8fe7b783          	ld	a5,-1794(a5) # 800088f8 <uart_tx_w>
    80006002:	00003717          	auipc	a4,0x3
    80006006:	8ee73703          	ld	a4,-1810(a4) # 800088f0 <uart_tx_r>
    8000600a:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000600e:	0001ca17          	auipc	s4,0x1c
    80006012:	d2aa0a13          	addi	s4,s4,-726 # 80021d38 <uart_tx_lock>
    80006016:	00003497          	auipc	s1,0x3
    8000601a:	8da48493          	addi	s1,s1,-1830 # 800088f0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000601e:	00003917          	auipc	s2,0x3
    80006022:	8da90913          	addi	s2,s2,-1830 # 800088f8 <uart_tx_w>
    80006026:	00f71f63          	bne	a4,a5,80006044 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000602a:	85d2                	mv	a1,s4
    8000602c:	8526                	mv	a0,s1
    8000602e:	ffffb097          	auipc	ra,0xffffb
    80006032:	52a080e7          	jalr	1322(ra) # 80001558 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006036:	00093783          	ld	a5,0(s2)
    8000603a:	6098                	ld	a4,0(s1)
    8000603c:	02070713          	addi	a4,a4,32
    80006040:	fef705e3          	beq	a4,a5,8000602a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006044:	0001c497          	auipc	s1,0x1c
    80006048:	cf448493          	addi	s1,s1,-780 # 80021d38 <uart_tx_lock>
    8000604c:	01f7f713          	andi	a4,a5,31
    80006050:	9726                	add	a4,a4,s1
    80006052:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80006056:	0785                	addi	a5,a5,1
    80006058:	00003717          	auipc	a4,0x3
    8000605c:	8af73023          	sd	a5,-1888(a4) # 800088f8 <uart_tx_w>
  uartstart();
    80006060:	00000097          	auipc	ra,0x0
    80006064:	ee4080e7          	jalr	-284(ra) # 80005f44 <uartstart>
  release(&uart_tx_lock);
    80006068:	8526                	mv	a0,s1
    8000606a:	00000097          	auipc	ra,0x0
    8000606e:	1d6080e7          	jalr	470(ra) # 80006240 <release>
}
    80006072:	70a2                	ld	ra,40(sp)
    80006074:	7402                	ld	s0,32(sp)
    80006076:	64e2                	ld	s1,24(sp)
    80006078:	6942                	ld	s2,16(sp)
    8000607a:	69a2                	ld	s3,8(sp)
    8000607c:	6a02                	ld	s4,0(sp)
    8000607e:	6145                	addi	sp,sp,48
    80006080:	8082                	ret
    for(;;)
    80006082:	a001                	j	80006082 <uartputc+0xb4>

0000000080006084 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006084:	1141                	addi	sp,sp,-16
    80006086:	e422                	sd	s0,8(sp)
    80006088:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000608a:	100007b7          	lui	a5,0x10000
    8000608e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006092:	8b85                	andi	a5,a5,1
    80006094:	cb91                	beqz	a5,800060a8 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006096:	100007b7          	lui	a5,0x10000
    8000609a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000609e:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800060a2:	6422                	ld	s0,8(sp)
    800060a4:	0141                	addi	sp,sp,16
    800060a6:	8082                	ret
    return -1;
    800060a8:	557d                	li	a0,-1
    800060aa:	bfe5                	j	800060a2 <uartgetc+0x1e>

00000000800060ac <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800060ac:	1101                	addi	sp,sp,-32
    800060ae:	ec06                	sd	ra,24(sp)
    800060b0:	e822                	sd	s0,16(sp)
    800060b2:	e426                	sd	s1,8(sp)
    800060b4:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060b6:	54fd                	li	s1,-1
    int c = uartgetc();
    800060b8:	00000097          	auipc	ra,0x0
    800060bc:	fcc080e7          	jalr	-52(ra) # 80006084 <uartgetc>
    if(c == -1)
    800060c0:	00950763          	beq	a0,s1,800060ce <uartintr+0x22>
      break;
    consoleintr(c);
    800060c4:	00000097          	auipc	ra,0x0
    800060c8:	8fe080e7          	jalr	-1794(ra) # 800059c2 <consoleintr>
  while(1){
    800060cc:	b7f5                	j	800060b8 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800060ce:	0001c497          	auipc	s1,0x1c
    800060d2:	c6a48493          	addi	s1,s1,-918 # 80021d38 <uart_tx_lock>
    800060d6:	8526                	mv	a0,s1
    800060d8:	00000097          	auipc	ra,0x0
    800060dc:	0b4080e7          	jalr	180(ra) # 8000618c <acquire>
  uartstart();
    800060e0:	00000097          	auipc	ra,0x0
    800060e4:	e64080e7          	jalr	-412(ra) # 80005f44 <uartstart>
  release(&uart_tx_lock);
    800060e8:	8526                	mv	a0,s1
    800060ea:	00000097          	auipc	ra,0x0
    800060ee:	156080e7          	jalr	342(ra) # 80006240 <release>
}
    800060f2:	60e2                	ld	ra,24(sp)
    800060f4:	6442                	ld	s0,16(sp)
    800060f6:	64a2                	ld	s1,8(sp)
    800060f8:	6105                	addi	sp,sp,32
    800060fa:	8082                	ret

00000000800060fc <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800060fc:	1141                	addi	sp,sp,-16
    800060fe:	e422                	sd	s0,8(sp)
    80006100:	0800                	addi	s0,sp,16
  lk->name = name;
    80006102:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006104:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006108:	00053823          	sd	zero,16(a0)
}
    8000610c:	6422                	ld	s0,8(sp)
    8000610e:	0141                	addi	sp,sp,16
    80006110:	8082                	ret

0000000080006112 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006112:	411c                	lw	a5,0(a0)
    80006114:	e399                	bnez	a5,8000611a <holding+0x8>
    80006116:	4501                	li	a0,0
  return r;
}
    80006118:	8082                	ret
{
    8000611a:	1101                	addi	sp,sp,-32
    8000611c:	ec06                	sd	ra,24(sp)
    8000611e:	e822                	sd	s0,16(sp)
    80006120:	e426                	sd	s1,8(sp)
    80006122:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006124:	6904                	ld	s1,16(a0)
    80006126:	ffffb097          	auipc	ra,0xffffb
    8000612a:	d6e080e7          	jalr	-658(ra) # 80000e94 <mycpu>
    8000612e:	40a48533          	sub	a0,s1,a0
    80006132:	00153513          	seqz	a0,a0
}
    80006136:	60e2                	ld	ra,24(sp)
    80006138:	6442                	ld	s0,16(sp)
    8000613a:	64a2                	ld	s1,8(sp)
    8000613c:	6105                	addi	sp,sp,32
    8000613e:	8082                	ret

0000000080006140 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006140:	1101                	addi	sp,sp,-32
    80006142:	ec06                	sd	ra,24(sp)
    80006144:	e822                	sd	s0,16(sp)
    80006146:	e426                	sd	s1,8(sp)
    80006148:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000614a:	100024f3          	csrr	s1,sstatus
    8000614e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006152:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006154:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006158:	ffffb097          	auipc	ra,0xffffb
    8000615c:	d3c080e7          	jalr	-708(ra) # 80000e94 <mycpu>
    80006160:	5d3c                	lw	a5,120(a0)
    80006162:	cf89                	beqz	a5,8000617c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006164:	ffffb097          	auipc	ra,0xffffb
    80006168:	d30080e7          	jalr	-720(ra) # 80000e94 <mycpu>
    8000616c:	5d3c                	lw	a5,120(a0)
    8000616e:	2785                	addiw	a5,a5,1
    80006170:	dd3c                	sw	a5,120(a0)
}
    80006172:	60e2                	ld	ra,24(sp)
    80006174:	6442                	ld	s0,16(sp)
    80006176:	64a2                	ld	s1,8(sp)
    80006178:	6105                	addi	sp,sp,32
    8000617a:	8082                	ret
    mycpu()->intena = old;
    8000617c:	ffffb097          	auipc	ra,0xffffb
    80006180:	d18080e7          	jalr	-744(ra) # 80000e94 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006184:	8085                	srli	s1,s1,0x1
    80006186:	8885                	andi	s1,s1,1
    80006188:	dd64                	sw	s1,124(a0)
    8000618a:	bfe9                	j	80006164 <push_off+0x24>

000000008000618c <acquire>:
{
    8000618c:	1101                	addi	sp,sp,-32
    8000618e:	ec06                	sd	ra,24(sp)
    80006190:	e822                	sd	s0,16(sp)
    80006192:	e426                	sd	s1,8(sp)
    80006194:	1000                	addi	s0,sp,32
    80006196:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006198:	00000097          	auipc	ra,0x0
    8000619c:	fa8080e7          	jalr	-88(ra) # 80006140 <push_off>
  if(holding(lk))
    800061a0:	8526                	mv	a0,s1
    800061a2:	00000097          	auipc	ra,0x0
    800061a6:	f70080e7          	jalr	-144(ra) # 80006112 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061aa:	4705                	li	a4,1
  if(holding(lk))
    800061ac:	e115                	bnez	a0,800061d0 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061ae:	87ba                	mv	a5,a4
    800061b0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061b4:	2781                	sext.w	a5,a5
    800061b6:	ffe5                	bnez	a5,800061ae <acquire+0x22>
  __sync_synchronize();
    800061b8:	0ff0000f          	fence
  lk->cpu = mycpu();
    800061bc:	ffffb097          	auipc	ra,0xffffb
    800061c0:	cd8080e7          	jalr	-808(ra) # 80000e94 <mycpu>
    800061c4:	e888                	sd	a0,16(s1)
}
    800061c6:	60e2                	ld	ra,24(sp)
    800061c8:	6442                	ld	s0,16(sp)
    800061ca:	64a2                	ld	s1,8(sp)
    800061cc:	6105                	addi	sp,sp,32
    800061ce:	8082                	ret
    panic("acquire");
    800061d0:	00002517          	auipc	a0,0x2
    800061d4:	68050513          	addi	a0,a0,1664 # 80008850 <digits+0x20>
    800061d8:	00000097          	auipc	ra,0x0
    800061dc:	a6a080e7          	jalr	-1430(ra) # 80005c42 <panic>

00000000800061e0 <pop_off>:

void
pop_off(void)
{
    800061e0:	1141                	addi	sp,sp,-16
    800061e2:	e406                	sd	ra,8(sp)
    800061e4:	e022                	sd	s0,0(sp)
    800061e6:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800061e8:	ffffb097          	auipc	ra,0xffffb
    800061ec:	cac080e7          	jalr	-852(ra) # 80000e94 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061f0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800061f4:	8b89                	andi	a5,a5,2
  if(intr_get())
    800061f6:	e78d                	bnez	a5,80006220 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800061f8:	5d3c                	lw	a5,120(a0)
    800061fa:	02f05b63          	blez	a5,80006230 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800061fe:	37fd                	addiw	a5,a5,-1
    80006200:	0007871b          	sext.w	a4,a5
    80006204:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006206:	eb09                	bnez	a4,80006218 <pop_off+0x38>
    80006208:	5d7c                	lw	a5,124(a0)
    8000620a:	c799                	beqz	a5,80006218 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000620c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006210:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006214:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006218:	60a2                	ld	ra,8(sp)
    8000621a:	6402                	ld	s0,0(sp)
    8000621c:	0141                	addi	sp,sp,16
    8000621e:	8082                	ret
    panic("pop_off - interruptible");
    80006220:	00002517          	auipc	a0,0x2
    80006224:	63850513          	addi	a0,a0,1592 # 80008858 <digits+0x28>
    80006228:	00000097          	auipc	ra,0x0
    8000622c:	a1a080e7          	jalr	-1510(ra) # 80005c42 <panic>
    panic("pop_off");
    80006230:	00002517          	auipc	a0,0x2
    80006234:	64050513          	addi	a0,a0,1600 # 80008870 <digits+0x40>
    80006238:	00000097          	auipc	ra,0x0
    8000623c:	a0a080e7          	jalr	-1526(ra) # 80005c42 <panic>

0000000080006240 <release>:
{
    80006240:	1101                	addi	sp,sp,-32
    80006242:	ec06                	sd	ra,24(sp)
    80006244:	e822                	sd	s0,16(sp)
    80006246:	e426                	sd	s1,8(sp)
    80006248:	1000                	addi	s0,sp,32
    8000624a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000624c:	00000097          	auipc	ra,0x0
    80006250:	ec6080e7          	jalr	-314(ra) # 80006112 <holding>
    80006254:	c115                	beqz	a0,80006278 <release+0x38>
  lk->cpu = 0;
    80006256:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000625a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000625e:	0f50000f          	fence	iorw,ow
    80006262:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006266:	00000097          	auipc	ra,0x0
    8000626a:	f7a080e7          	jalr	-134(ra) # 800061e0 <pop_off>
}
    8000626e:	60e2                	ld	ra,24(sp)
    80006270:	6442                	ld	s0,16(sp)
    80006272:	64a2                	ld	s1,8(sp)
    80006274:	6105                	addi	sp,sp,32
    80006276:	8082                	ret
    panic("release");
    80006278:	00002517          	auipc	a0,0x2
    8000627c:	60050513          	addi	a0,a0,1536 # 80008878 <digits+0x48>
    80006280:	00000097          	auipc	ra,0x0
    80006284:	9c2080e7          	jalr	-1598(ra) # 80005c42 <panic>
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
