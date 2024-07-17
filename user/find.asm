
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char *
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
    static char buf[DIRSIZ + 1];
    char *p;

    // Find first character after last slash.
    for (p = path + strlen(path); p >= path && *p != '/'; p--) // p指向路径字符串的末尾（即空字符 \0 的位置）
  10:	00000097          	auipc	ra,0x0
  14:	36e080e7          	jalr	878(ra) # 37e <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
        ;
    p++; // p指向最后一个/后的第一个字符
  36:	00178493          	addi	s1,a5,1

    // Return blank-padded name.
    if (strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	342080e7          	jalr	834(ra) # 37e <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
        return p;
    memmove(buf, p, strlen(p));
    memset(buf + strlen(p), ' ', DIRSIZ - strlen(p)); // 保证 buf的总长度为DIRSIZ，即使文件名不够长也会用空格填充
    return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
    memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	320080e7          	jalr	800(ra) # 37e <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	faa98993          	addi	s3,s3,-86 # 1010 <buf.1106>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	480080e7          	jalr	1152(ra) # 4f6 <memmove>
    memset(buf + strlen(p), ' ', DIRSIZ - strlen(p)); // 保证 buf的总长度为DIRSIZ，即使文件名不够长也会用空格填充
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	2fe080e7          	jalr	766(ra) # 37e <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	2f0080e7          	jalr	752(ra) # 37e <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	300080e7          	jalr	768(ra) # 3a8 <memset>
    return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <findName>:

void findName(char *path,char *name)
{
  b4:	d8010113          	addi	sp,sp,-640
  b8:	26113c23          	sd	ra,632(sp)
  bc:	26813823          	sd	s0,624(sp)
  c0:	26913423          	sd	s1,616(sp)
  c4:	27213023          	sd	s2,608(sp)
  c8:	25313c23          	sd	s3,600(sp)
  cc:	25413823          	sd	s4,592(sp)
  d0:	25513423          	sd	s5,584(sp)
  d4:	25613023          	sd	s6,576(sp)
  d8:	23713c23          	sd	s7,568(sp)
  dc:	0500                	addi	s0,sp,640
  de:	892a                	mv	s2,a0
  e0:	89ae                	mv	s3,a1
    struct dirent de;  // 目录项结构体，用于存储从目录中读取的每个文件或目录项的信息。
    struct stat st;    // 文件状态结构体，用于获取文件或目录的详细信息
    char *temp = ".";
    char *temp1 = "..";

    if ((fd = open(path, O_RDONLY)) < 0)
  e2:	4581                	li	a1,0
  e4:	00000097          	auipc	ra,0x0
  e8:	508080e7          	jalr	1288(ra) # 5ec <open>
  ec:	06054c63          	bltz	a0,164 <findName+0xb0>
  f0:	84aa                	mv	s1,a0
    {
        fprintf(2, "ls: cannot open %s\n", path);
        return;
    }

    if (fstat(fd, &st) < 0)
  f2:	d8840593          	addi	a1,s0,-632
  f6:	00000097          	auipc	ra,0x0
  fa:	50e080e7          	jalr	1294(ra) # 604 <fstat>
  fe:	06054e63          	bltz	a0,17a <findName+0xc6>
        fprintf(2, "ls: cannot stat %s\n", path);
        close(fd);
        return;
    }

    switch (st.type)
 102:	d9041783          	lh	a5,-624(s0)
 106:	0007869b          	sext.w	a3,a5
 10a:	4705                	li	a4,1
 10c:	0ae68663          	beq	a3,a4,1b8 <findName+0x104>
 110:	37f9                	addiw	a5,a5,-2
 112:	17c2                	slli	a5,a5,0x30
 114:	93c1                	srli	a5,a5,0x30
 116:	00f76d63          	bltu	a4,a5,130 <findName+0x7c>
    {
    case T_DEVICE: // 如果是普通文件或设备文件，就打印出它的文件名，文件类型，索引节点号和大小
    case T_FILE:
        if (strcmp(fmtname(path),name)==0){
 11a:	854a                	mv	a0,s2
 11c:	00000097          	auipc	ra,0x0
 120:	ee4080e7          	jalr	-284(ra) # 0 <fmtname>
 124:	85ce                	mv	a1,s3
 126:	00000097          	auipc	ra,0x0
 12a:	22c080e7          	jalr	556(ra) # 352 <strcmp>
 12e:	c535                	beqz	a0,19a <findName+0xe6>
                }
            } 
        }
        break;
    }
    close(fd);
 130:	8526                	mv	a0,s1
 132:	00000097          	auipc	ra,0x0
 136:	4a2080e7          	jalr	1186(ra) # 5d4 <close>
}
 13a:	27813083          	ld	ra,632(sp)
 13e:	27013403          	ld	s0,624(sp)
 142:	26813483          	ld	s1,616(sp)
 146:	26013903          	ld	s2,608(sp)
 14a:	25813983          	ld	s3,600(sp)
 14e:	25013a03          	ld	s4,592(sp)
 152:	24813a83          	ld	s5,584(sp)
 156:	24013b03          	ld	s6,576(sp)
 15a:	23813b83          	ld	s7,568(sp)
 15e:	28010113          	addi	sp,sp,640
 162:	8082                	ret
        fprintf(2, "ls: cannot open %s\n", path);
 164:	864a                	mv	a2,s2
 166:	00001597          	auipc	a1,0x1
 16a:	96a58593          	addi	a1,a1,-1686 # ad0 <malloc+0xee>
 16e:	4509                	li	a0,2
 170:	00000097          	auipc	ra,0x0
 174:	786080e7          	jalr	1926(ra) # 8f6 <fprintf>
        return;
 178:	b7c9                	j	13a <findName+0x86>
        fprintf(2, "ls: cannot stat %s\n", path);
 17a:	864a                	mv	a2,s2
 17c:	00001597          	auipc	a1,0x1
 180:	96c58593          	addi	a1,a1,-1684 # ae8 <malloc+0x106>
 184:	4509                	li	a0,2
 186:	00000097          	auipc	ra,0x0
 18a:	770080e7          	jalr	1904(ra) # 8f6 <fprintf>
        close(fd);
 18e:	8526                	mv	a0,s1
 190:	00000097          	auipc	ra,0x0
 194:	444080e7          	jalr	1092(ra) # 5d4 <close>
        return;
 198:	b74d                	j	13a <findName+0x86>
            printf("%s\n", fmtname(path));
 19a:	854a                	mv	a0,s2
 19c:	00000097          	auipc	ra,0x0
 1a0:	e64080e7          	jalr	-412(ra) # 0 <fmtname>
 1a4:	85aa                	mv	a1,a0
 1a6:	00001517          	auipc	a0,0x1
 1aa:	93a50513          	addi	a0,a0,-1734 # ae0 <malloc+0xfe>
 1ae:	00000097          	auipc	ra,0x0
 1b2:	776080e7          	jalr	1910(ra) # 924 <printf>
 1b6:	bfad                	j	130 <findName+0x7c>
        if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf)
 1b8:	854a                	mv	a0,s2
 1ba:	00000097          	auipc	ra,0x0
 1be:	1c4080e7          	jalr	452(ra) # 37e <strlen>
 1c2:	2541                	addiw	a0,a0,16
 1c4:	20000793          	li	a5,512
 1c8:	00a7fb63          	bgeu	a5,a0,1de <findName+0x12a>
            printf("ls: path too long\n");
 1cc:	00001517          	auipc	a0,0x1
 1d0:	93450513          	addi	a0,a0,-1740 # b00 <malloc+0x11e>
 1d4:	00000097          	auipc	ra,0x0
 1d8:	750080e7          	jalr	1872(ra) # 924 <printf>
            break;
 1dc:	bf91                	j	130 <findName+0x7c>
        strcpy(buf, path);
 1de:	85ca                	mv	a1,s2
 1e0:	db040513          	addi	a0,s0,-592
 1e4:	00000097          	auipc	ra,0x0
 1e8:	152080e7          	jalr	338(ra) # 336 <strcpy>
        p = buf + strlen(buf); // 指针p移动到路径最后
 1ec:	db040513          	addi	a0,s0,-592
 1f0:	00000097          	auipc	ra,0x0
 1f4:	18e080e7          	jalr	398(ra) # 37e <strlen>
 1f8:	02051913          	slli	s2,a0,0x20
 1fc:	02095913          	srli	s2,s2,0x20
 200:	db040793          	addi	a5,s0,-592
 204:	993e                	add	s2,s2,a5
        *p++ = '/';            // p当前位置写入一个/，然后p再往后移动一次（表示进入此目录）
 206:	00190b13          	addi	s6,s2,1
 20a:	02f00793          	li	a5,47
 20e:	00f90023          	sb	a5,0(s2)
            if(strcmp(de.name,temp)==0){
 212:	00001a97          	auipc	s5,0x1
 216:	906a8a93          	addi	s5,s5,-1786 # b18 <malloc+0x136>
            if (strcmp(de.name, temp1) == 0)
 21a:	00001b97          	auipc	s7,0x1
 21e:	906b8b93          	addi	s7,s7,-1786 # b20 <malloc+0x13e>
            if(strcmp(de.name,temp)==0){
 222:	da240a13          	addi	s4,s0,-606
        while (read(fd, &de, sizeof(de)) == sizeof(de))
 226:	4641                	li	a2,16
 228:	da040593          	addi	a1,s0,-608
 22c:	8526                	mv	a0,s1
 22e:	00000097          	auipc	ra,0x0
 232:	396080e7          	jalr	918(ra) # 5c4 <read>
 236:	47c1                	li	a5,16
 238:	eef51ce3          	bne	a0,a5,130 <findName+0x7c>
            if (de.inum == 0) // 跳过空目录项（inum为0）
 23c:	da045783          	lhu	a5,-608(s0)
 240:	d3fd                	beqz	a5,226 <findName+0x172>
            if(strcmp(de.name,temp)==0){
 242:	85d6                	mv	a1,s5
 244:	8552                	mv	a0,s4
 246:	00000097          	auipc	ra,0x0
 24a:	10c080e7          	jalr	268(ra) # 352 <strcmp>
 24e:	dd61                	beqz	a0,226 <findName+0x172>
            if (strcmp(de.name, temp1) == 0)
 250:	85de                	mv	a1,s7
 252:	8552                	mv	a0,s4
 254:	00000097          	auipc	ra,0x0
 258:	0fe080e7          	jalr	254(ra) # 352 <strcmp>
 25c:	d569                	beqz	a0,226 <findName+0x172>
            memmove(p, de.name, DIRSIZ); // 将目录项的名称复制到buf的末尾，并进行文件状态获取
 25e:	4639                	li	a2,14
 260:	da240593          	addi	a1,s0,-606
 264:	855a                	mv	a0,s6
 266:	00000097          	auipc	ra,0x0
 26a:	290080e7          	jalr	656(ra) # 4f6 <memmove>
            p[DIRSIZ] = 0;
 26e:	000907a3          	sb	zero,15(s2)
            if (stat(buf, &st) < 0)
 272:	d8840593          	addi	a1,s0,-632
 276:	db040513          	addi	a0,s0,-592
 27a:	00000097          	auipc	ra,0x0
 27e:	1ec080e7          	jalr	492(ra) # 466 <stat>
 282:	02054763          	bltz	a0,2b0 <findName+0x1fc>
            if (strcmp(de.name, name) == 0)
 286:	85ce                	mv	a1,s3
 288:	da240513          	addi	a0,s0,-606
 28c:	00000097          	auipc	ra,0x0
 290:	0c6080e7          	jalr	198(ra) # 352 <strcmp>
 294:	c90d                	beqz	a0,2c6 <findName+0x212>
                if (st.type == T_DIR)
 296:	d9041703          	lh	a4,-624(s0)
 29a:	4785                	li	a5,1
 29c:	f8f715e3          	bne	a4,a5,226 <findName+0x172>
                    findName(buf, name);
 2a0:	85ce                	mv	a1,s3
 2a2:	db040513          	addi	a0,s0,-592
 2a6:	00000097          	auipc	ra,0x0
 2aa:	e0e080e7          	jalr	-498(ra) # b4 <findName>
 2ae:	bfa5                	j	226 <findName+0x172>
                printf("ls: cannot stat %s\n", buf);
 2b0:	db040593          	addi	a1,s0,-592
 2b4:	00001517          	auipc	a0,0x1
 2b8:	83450513          	addi	a0,a0,-1996 # ae8 <malloc+0x106>
 2bc:	00000097          	auipc	ra,0x0
 2c0:	668080e7          	jalr	1640(ra) # 924 <printf>
                continue;
 2c4:	b78d                	j	226 <findName+0x172>
                 printf("%s\n", buf);
 2c6:	db040593          	addi	a1,s0,-592
 2ca:	00001517          	auipc	a0,0x1
 2ce:	81650513          	addi	a0,a0,-2026 # ae0 <malloc+0xfe>
 2d2:	00000097          	auipc	ra,0x0
 2d6:	652080e7          	jalr	1618(ra) # 924 <printf>
 2da:	b7b1                	j	226 <findName+0x172>

00000000000002dc <main>:

int main(int argc, char *argv[])
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e406                	sd	ra,8(sp)
 2e0:	e022                	sd	s0,0(sp)
 2e2:	0800                	addi	s0,sp,16
    if (argc < 2)
 2e4:	4705                	li	a4,1
 2e6:	00a75e63          	bge	a4,a0,302 <main+0x26>
 2ea:	87ae                	mv	a5,a1
    {
        printf("User forgets to pass an argument\n");
        exit(0);
    }
    findName(argv[1], argv[2]);
 2ec:	698c                	ld	a1,16(a1)
 2ee:	6788                	ld	a0,8(a5)
 2f0:	00000097          	auipc	ra,0x0
 2f4:	dc4080e7          	jalr	-572(ra) # b4 <findName>
    exit(0);
 2f8:	4501                	li	a0,0
 2fa:	00000097          	auipc	ra,0x0
 2fe:	2b2080e7          	jalr	690(ra) # 5ac <exit>
        printf("User forgets to pass an argument\n");
 302:	00001517          	auipc	a0,0x1
 306:	82650513          	addi	a0,a0,-2010 # b28 <malloc+0x146>
 30a:	00000097          	auipc	ra,0x0
 30e:	61a080e7          	jalr	1562(ra) # 924 <printf>
        exit(0);
 312:	4501                	li	a0,0
 314:	00000097          	auipc	ra,0x0
 318:	298080e7          	jalr	664(ra) # 5ac <exit>

000000000000031c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e406                	sd	ra,8(sp)
 320:	e022                	sd	s0,0(sp)
 322:	0800                	addi	s0,sp,16
  extern int main();
  main();
 324:	00000097          	auipc	ra,0x0
 328:	fb8080e7          	jalr	-72(ra) # 2dc <main>
  exit(0);
 32c:	4501                	li	a0,0
 32e:	00000097          	auipc	ra,0x0
 332:	27e080e7          	jalr	638(ra) # 5ac <exit>

0000000000000336 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 336:	1141                	addi	sp,sp,-16
 338:	e422                	sd	s0,8(sp)
 33a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 33c:	87aa                	mv	a5,a0
 33e:	0585                	addi	a1,a1,1
 340:	0785                	addi	a5,a5,1
 342:	fff5c703          	lbu	a4,-1(a1)
 346:	fee78fa3          	sb	a4,-1(a5)
 34a:	fb75                	bnez	a4,33e <strcpy+0x8>
    ;
  return os;
}
 34c:	6422                	ld	s0,8(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret

0000000000000352 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 352:	1141                	addi	sp,sp,-16
 354:	e422                	sd	s0,8(sp)
 356:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 358:	00054783          	lbu	a5,0(a0)
 35c:	cb91                	beqz	a5,370 <strcmp+0x1e>
 35e:	0005c703          	lbu	a4,0(a1)
 362:	00f71763          	bne	a4,a5,370 <strcmp+0x1e>
    p++, q++;
 366:	0505                	addi	a0,a0,1
 368:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 36a:	00054783          	lbu	a5,0(a0)
 36e:	fbe5                	bnez	a5,35e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 370:	0005c503          	lbu	a0,0(a1)
}
 374:	40a7853b          	subw	a0,a5,a0
 378:	6422                	ld	s0,8(sp)
 37a:	0141                	addi	sp,sp,16
 37c:	8082                	ret

000000000000037e <strlen>:

uint
strlen(const char *s)
{
 37e:	1141                	addi	sp,sp,-16
 380:	e422                	sd	s0,8(sp)
 382:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 384:	00054783          	lbu	a5,0(a0)
 388:	cf91                	beqz	a5,3a4 <strlen+0x26>
 38a:	0505                	addi	a0,a0,1
 38c:	87aa                	mv	a5,a0
 38e:	4685                	li	a3,1
 390:	9e89                	subw	a3,a3,a0
 392:	00f6853b          	addw	a0,a3,a5
 396:	0785                	addi	a5,a5,1
 398:	fff7c703          	lbu	a4,-1(a5)
 39c:	fb7d                	bnez	a4,392 <strlen+0x14>
    ;
  return n;
}
 39e:	6422                	ld	s0,8(sp)
 3a0:	0141                	addi	sp,sp,16
 3a2:	8082                	ret
  for(n = 0; s[n]; n++)
 3a4:	4501                	li	a0,0
 3a6:	bfe5                	j	39e <strlen+0x20>

00000000000003a8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3a8:	1141                	addi	sp,sp,-16
 3aa:	e422                	sd	s0,8(sp)
 3ac:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 3ae:	ce09                	beqz	a2,3c8 <memset+0x20>
 3b0:	87aa                	mv	a5,a0
 3b2:	fff6071b          	addiw	a4,a2,-1
 3b6:	1702                	slli	a4,a4,0x20
 3b8:	9301                	srli	a4,a4,0x20
 3ba:	0705                	addi	a4,a4,1
 3bc:	972a                	add	a4,a4,a0
    cdst[i] = c;
 3be:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3c2:	0785                	addi	a5,a5,1
 3c4:	fee79de3          	bne	a5,a4,3be <memset+0x16>
  }
  return dst;
}
 3c8:	6422                	ld	s0,8(sp)
 3ca:	0141                	addi	sp,sp,16
 3cc:	8082                	ret

00000000000003ce <strchr>:

char*
strchr(const char *s, char c)
{
 3ce:	1141                	addi	sp,sp,-16
 3d0:	e422                	sd	s0,8(sp)
 3d2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3d4:	00054783          	lbu	a5,0(a0)
 3d8:	cb99                	beqz	a5,3ee <strchr+0x20>
    if(*s == c)
 3da:	00f58763          	beq	a1,a5,3e8 <strchr+0x1a>
  for(; *s; s++)
 3de:	0505                	addi	a0,a0,1
 3e0:	00054783          	lbu	a5,0(a0)
 3e4:	fbfd                	bnez	a5,3da <strchr+0xc>
      return (char*)s;
  return 0;
 3e6:	4501                	li	a0,0
}
 3e8:	6422                	ld	s0,8(sp)
 3ea:	0141                	addi	sp,sp,16
 3ec:	8082                	ret
  return 0;
 3ee:	4501                	li	a0,0
 3f0:	bfe5                	j	3e8 <strchr+0x1a>

00000000000003f2 <gets>:

char*
gets(char *buf, int max)
{
 3f2:	711d                	addi	sp,sp,-96
 3f4:	ec86                	sd	ra,88(sp)
 3f6:	e8a2                	sd	s0,80(sp)
 3f8:	e4a6                	sd	s1,72(sp)
 3fa:	e0ca                	sd	s2,64(sp)
 3fc:	fc4e                	sd	s3,56(sp)
 3fe:	f852                	sd	s4,48(sp)
 400:	f456                	sd	s5,40(sp)
 402:	f05a                	sd	s6,32(sp)
 404:	ec5e                	sd	s7,24(sp)
 406:	1080                	addi	s0,sp,96
 408:	8baa                	mv	s7,a0
 40a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 40c:	892a                	mv	s2,a0
 40e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 410:	4aa9                	li	s5,10
 412:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 414:	89a6                	mv	s3,s1
 416:	2485                	addiw	s1,s1,1
 418:	0344d863          	bge	s1,s4,448 <gets+0x56>
    cc = read(0, &c, 1);
 41c:	4605                	li	a2,1
 41e:	faf40593          	addi	a1,s0,-81
 422:	4501                	li	a0,0
 424:	00000097          	auipc	ra,0x0
 428:	1a0080e7          	jalr	416(ra) # 5c4 <read>
    if(cc < 1)
 42c:	00a05e63          	blez	a0,448 <gets+0x56>
    buf[i++] = c;
 430:	faf44783          	lbu	a5,-81(s0)
 434:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 438:	01578763          	beq	a5,s5,446 <gets+0x54>
 43c:	0905                	addi	s2,s2,1
 43e:	fd679be3          	bne	a5,s6,414 <gets+0x22>
  for(i=0; i+1 < max; ){
 442:	89a6                	mv	s3,s1
 444:	a011                	j	448 <gets+0x56>
 446:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 448:	99de                	add	s3,s3,s7
 44a:	00098023          	sb	zero,0(s3)
  return buf;
}
 44e:	855e                	mv	a0,s7
 450:	60e6                	ld	ra,88(sp)
 452:	6446                	ld	s0,80(sp)
 454:	64a6                	ld	s1,72(sp)
 456:	6906                	ld	s2,64(sp)
 458:	79e2                	ld	s3,56(sp)
 45a:	7a42                	ld	s4,48(sp)
 45c:	7aa2                	ld	s5,40(sp)
 45e:	7b02                	ld	s6,32(sp)
 460:	6be2                	ld	s7,24(sp)
 462:	6125                	addi	sp,sp,96
 464:	8082                	ret

0000000000000466 <stat>:

int
stat(const char *n, struct stat *st)
{
 466:	1101                	addi	sp,sp,-32
 468:	ec06                	sd	ra,24(sp)
 46a:	e822                	sd	s0,16(sp)
 46c:	e426                	sd	s1,8(sp)
 46e:	e04a                	sd	s2,0(sp)
 470:	1000                	addi	s0,sp,32
 472:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 474:	4581                	li	a1,0
 476:	00000097          	auipc	ra,0x0
 47a:	176080e7          	jalr	374(ra) # 5ec <open>
  if(fd < 0)
 47e:	02054563          	bltz	a0,4a8 <stat+0x42>
 482:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 484:	85ca                	mv	a1,s2
 486:	00000097          	auipc	ra,0x0
 48a:	17e080e7          	jalr	382(ra) # 604 <fstat>
 48e:	892a                	mv	s2,a0
  close(fd);
 490:	8526                	mv	a0,s1
 492:	00000097          	auipc	ra,0x0
 496:	142080e7          	jalr	322(ra) # 5d4 <close>
  return r;
}
 49a:	854a                	mv	a0,s2
 49c:	60e2                	ld	ra,24(sp)
 49e:	6442                	ld	s0,16(sp)
 4a0:	64a2                	ld	s1,8(sp)
 4a2:	6902                	ld	s2,0(sp)
 4a4:	6105                	addi	sp,sp,32
 4a6:	8082                	ret
    return -1;
 4a8:	597d                	li	s2,-1
 4aa:	bfc5                	j	49a <stat+0x34>

00000000000004ac <atoi>:

int
atoi(const char *s)
{
 4ac:	1141                	addi	sp,sp,-16
 4ae:	e422                	sd	s0,8(sp)
 4b0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4b2:	00054603          	lbu	a2,0(a0)
 4b6:	fd06079b          	addiw	a5,a2,-48
 4ba:	0ff7f793          	andi	a5,a5,255
 4be:	4725                	li	a4,9
 4c0:	02f76963          	bltu	a4,a5,4f2 <atoi+0x46>
 4c4:	86aa                	mv	a3,a0
  n = 0;
 4c6:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 4c8:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 4ca:	0685                	addi	a3,a3,1
 4cc:	0025179b          	slliw	a5,a0,0x2
 4d0:	9fa9                	addw	a5,a5,a0
 4d2:	0017979b          	slliw	a5,a5,0x1
 4d6:	9fb1                	addw	a5,a5,a2
 4d8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4dc:	0006c603          	lbu	a2,0(a3)
 4e0:	fd06071b          	addiw	a4,a2,-48
 4e4:	0ff77713          	andi	a4,a4,255
 4e8:	fee5f1e3          	bgeu	a1,a4,4ca <atoi+0x1e>
  return n;
}
 4ec:	6422                	ld	s0,8(sp)
 4ee:	0141                	addi	sp,sp,16
 4f0:	8082                	ret
  n = 0;
 4f2:	4501                	li	a0,0
 4f4:	bfe5                	j	4ec <atoi+0x40>

00000000000004f6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4f6:	1141                	addi	sp,sp,-16
 4f8:	e422                	sd	s0,8(sp)
 4fa:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4fc:	02b57663          	bgeu	a0,a1,528 <memmove+0x32>
    while(n-- > 0)
 500:	02c05163          	blez	a2,522 <memmove+0x2c>
 504:	fff6079b          	addiw	a5,a2,-1
 508:	1782                	slli	a5,a5,0x20
 50a:	9381                	srli	a5,a5,0x20
 50c:	0785                	addi	a5,a5,1
 50e:	97aa                	add	a5,a5,a0
  dst = vdst;
 510:	872a                	mv	a4,a0
      *dst++ = *src++;
 512:	0585                	addi	a1,a1,1
 514:	0705                	addi	a4,a4,1
 516:	fff5c683          	lbu	a3,-1(a1)
 51a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 51e:	fee79ae3          	bne	a5,a4,512 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 522:	6422                	ld	s0,8(sp)
 524:	0141                	addi	sp,sp,16
 526:	8082                	ret
    dst += n;
 528:	00c50733          	add	a4,a0,a2
    src += n;
 52c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 52e:	fec05ae3          	blez	a2,522 <memmove+0x2c>
 532:	fff6079b          	addiw	a5,a2,-1
 536:	1782                	slli	a5,a5,0x20
 538:	9381                	srli	a5,a5,0x20
 53a:	fff7c793          	not	a5,a5
 53e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 540:	15fd                	addi	a1,a1,-1
 542:	177d                	addi	a4,a4,-1
 544:	0005c683          	lbu	a3,0(a1)
 548:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 54c:	fee79ae3          	bne	a5,a4,540 <memmove+0x4a>
 550:	bfc9                	j	522 <memmove+0x2c>

0000000000000552 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 552:	1141                	addi	sp,sp,-16
 554:	e422                	sd	s0,8(sp)
 556:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 558:	ca05                	beqz	a2,588 <memcmp+0x36>
 55a:	fff6069b          	addiw	a3,a2,-1
 55e:	1682                	slli	a3,a3,0x20
 560:	9281                	srli	a3,a3,0x20
 562:	0685                	addi	a3,a3,1
 564:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 566:	00054783          	lbu	a5,0(a0)
 56a:	0005c703          	lbu	a4,0(a1)
 56e:	00e79863          	bne	a5,a4,57e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 572:	0505                	addi	a0,a0,1
    p2++;
 574:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 576:	fed518e3          	bne	a0,a3,566 <memcmp+0x14>
  }
  return 0;
 57a:	4501                	li	a0,0
 57c:	a019                	j	582 <memcmp+0x30>
      return *p1 - *p2;
 57e:	40e7853b          	subw	a0,a5,a4
}
 582:	6422                	ld	s0,8(sp)
 584:	0141                	addi	sp,sp,16
 586:	8082                	ret
  return 0;
 588:	4501                	li	a0,0
 58a:	bfe5                	j	582 <memcmp+0x30>

000000000000058c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 58c:	1141                	addi	sp,sp,-16
 58e:	e406                	sd	ra,8(sp)
 590:	e022                	sd	s0,0(sp)
 592:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 594:	00000097          	auipc	ra,0x0
 598:	f62080e7          	jalr	-158(ra) # 4f6 <memmove>
}
 59c:	60a2                	ld	ra,8(sp)
 59e:	6402                	ld	s0,0(sp)
 5a0:	0141                	addi	sp,sp,16
 5a2:	8082                	ret

00000000000005a4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5a4:	4885                	li	a7,1
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <exit>:
.global exit
exit:
 li a7, SYS_exit
 5ac:	4889                	li	a7,2
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5b4:	488d                	li	a7,3
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5bc:	4891                	li	a7,4
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <read>:
.global read
read:
 li a7, SYS_read
 5c4:	4895                	li	a7,5
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <write>:
.global write
write:
 li a7, SYS_write
 5cc:	48c1                	li	a7,16
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <close>:
.global close
close:
 li a7, SYS_close
 5d4:	48d5                	li	a7,21
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <kill>:
.global kill
kill:
 li a7, SYS_kill
 5dc:	4899                	li	a7,6
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5e4:	489d                	li	a7,7
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <open>:
.global open
open:
 li a7, SYS_open
 5ec:	48bd                	li	a7,15
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5f4:	48c5                	li	a7,17
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5fc:	48c9                	li	a7,18
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 604:	48a1                	li	a7,8
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <link>:
.global link
link:
 li a7, SYS_link
 60c:	48cd                	li	a7,19
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 614:	48d1                	li	a7,20
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 61c:	48a5                	li	a7,9
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <dup>:
.global dup
dup:
 li a7, SYS_dup
 624:	48a9                	li	a7,10
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 62c:	48ad                	li	a7,11
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 634:	48b1                	li	a7,12
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 63c:	48b5                	li	a7,13
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 644:	48b9                	li	a7,14
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 64c:	1101                	addi	sp,sp,-32
 64e:	ec06                	sd	ra,24(sp)
 650:	e822                	sd	s0,16(sp)
 652:	1000                	addi	s0,sp,32
 654:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 658:	4605                	li	a2,1
 65a:	fef40593          	addi	a1,s0,-17
 65e:	00000097          	auipc	ra,0x0
 662:	f6e080e7          	jalr	-146(ra) # 5cc <write>
}
 666:	60e2                	ld	ra,24(sp)
 668:	6442                	ld	s0,16(sp)
 66a:	6105                	addi	sp,sp,32
 66c:	8082                	ret

000000000000066e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 66e:	7139                	addi	sp,sp,-64
 670:	fc06                	sd	ra,56(sp)
 672:	f822                	sd	s0,48(sp)
 674:	f426                	sd	s1,40(sp)
 676:	f04a                	sd	s2,32(sp)
 678:	ec4e                	sd	s3,24(sp)
 67a:	0080                	addi	s0,sp,64
 67c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 67e:	c299                	beqz	a3,684 <printint+0x16>
 680:	0805c863          	bltz	a1,710 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 684:	2581                	sext.w	a1,a1
  neg = 0;
 686:	4881                	li	a7,0
 688:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 68c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 68e:	2601                	sext.w	a2,a2
 690:	00000517          	auipc	a0,0x0
 694:	4c850513          	addi	a0,a0,1224 # b58 <digits>
 698:	883a                	mv	a6,a4
 69a:	2705                	addiw	a4,a4,1
 69c:	02c5f7bb          	remuw	a5,a1,a2
 6a0:	1782                	slli	a5,a5,0x20
 6a2:	9381                	srli	a5,a5,0x20
 6a4:	97aa                	add	a5,a5,a0
 6a6:	0007c783          	lbu	a5,0(a5)
 6aa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6ae:	0005879b          	sext.w	a5,a1
 6b2:	02c5d5bb          	divuw	a1,a1,a2
 6b6:	0685                	addi	a3,a3,1
 6b8:	fec7f0e3          	bgeu	a5,a2,698 <printint+0x2a>
  if(neg)
 6bc:	00088b63          	beqz	a7,6d2 <printint+0x64>
    buf[i++] = '-';
 6c0:	fd040793          	addi	a5,s0,-48
 6c4:	973e                	add	a4,a4,a5
 6c6:	02d00793          	li	a5,45
 6ca:	fef70823          	sb	a5,-16(a4)
 6ce:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6d2:	02e05863          	blez	a4,702 <printint+0x94>
 6d6:	fc040793          	addi	a5,s0,-64
 6da:	00e78933          	add	s2,a5,a4
 6de:	fff78993          	addi	s3,a5,-1
 6e2:	99ba                	add	s3,s3,a4
 6e4:	377d                	addiw	a4,a4,-1
 6e6:	1702                	slli	a4,a4,0x20
 6e8:	9301                	srli	a4,a4,0x20
 6ea:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6ee:	fff94583          	lbu	a1,-1(s2)
 6f2:	8526                	mv	a0,s1
 6f4:	00000097          	auipc	ra,0x0
 6f8:	f58080e7          	jalr	-168(ra) # 64c <putc>
  while(--i >= 0)
 6fc:	197d                	addi	s2,s2,-1
 6fe:	ff3918e3          	bne	s2,s3,6ee <printint+0x80>
}
 702:	70e2                	ld	ra,56(sp)
 704:	7442                	ld	s0,48(sp)
 706:	74a2                	ld	s1,40(sp)
 708:	7902                	ld	s2,32(sp)
 70a:	69e2                	ld	s3,24(sp)
 70c:	6121                	addi	sp,sp,64
 70e:	8082                	ret
    x = -xx;
 710:	40b005bb          	negw	a1,a1
    neg = 1;
 714:	4885                	li	a7,1
    x = -xx;
 716:	bf8d                	j	688 <printint+0x1a>

0000000000000718 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 718:	7119                	addi	sp,sp,-128
 71a:	fc86                	sd	ra,120(sp)
 71c:	f8a2                	sd	s0,112(sp)
 71e:	f4a6                	sd	s1,104(sp)
 720:	f0ca                	sd	s2,96(sp)
 722:	ecce                	sd	s3,88(sp)
 724:	e8d2                	sd	s4,80(sp)
 726:	e4d6                	sd	s5,72(sp)
 728:	e0da                	sd	s6,64(sp)
 72a:	fc5e                	sd	s7,56(sp)
 72c:	f862                	sd	s8,48(sp)
 72e:	f466                	sd	s9,40(sp)
 730:	f06a                	sd	s10,32(sp)
 732:	ec6e                	sd	s11,24(sp)
 734:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 736:	0005c903          	lbu	s2,0(a1)
 73a:	18090f63          	beqz	s2,8d8 <vprintf+0x1c0>
 73e:	8aaa                	mv	s5,a0
 740:	8b32                	mv	s6,a2
 742:	00158493          	addi	s1,a1,1
  state = 0;
 746:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 748:	02500a13          	li	s4,37
      if(c == 'd'){
 74c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 750:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 754:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 758:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 75c:	00000b97          	auipc	s7,0x0
 760:	3fcb8b93          	addi	s7,s7,1020 # b58 <digits>
 764:	a839                	j	782 <vprintf+0x6a>
        putc(fd, c);
 766:	85ca                	mv	a1,s2
 768:	8556                	mv	a0,s5
 76a:	00000097          	auipc	ra,0x0
 76e:	ee2080e7          	jalr	-286(ra) # 64c <putc>
 772:	a019                	j	778 <vprintf+0x60>
    } else if(state == '%'){
 774:	01498f63          	beq	s3,s4,792 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 778:	0485                	addi	s1,s1,1
 77a:	fff4c903          	lbu	s2,-1(s1)
 77e:	14090d63          	beqz	s2,8d8 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 782:	0009079b          	sext.w	a5,s2
    if(state == 0){
 786:	fe0997e3          	bnez	s3,774 <vprintf+0x5c>
      if(c == '%'){
 78a:	fd479ee3          	bne	a5,s4,766 <vprintf+0x4e>
        state = '%';
 78e:	89be                	mv	s3,a5
 790:	b7e5                	j	778 <vprintf+0x60>
      if(c == 'd'){
 792:	05878063          	beq	a5,s8,7d2 <vprintf+0xba>
      } else if(c == 'l') {
 796:	05978c63          	beq	a5,s9,7ee <vprintf+0xd6>
      } else if(c == 'x') {
 79a:	07a78863          	beq	a5,s10,80a <vprintf+0xf2>
      } else if(c == 'p') {
 79e:	09b78463          	beq	a5,s11,826 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 7a2:	07300713          	li	a4,115
 7a6:	0ce78663          	beq	a5,a4,872 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7aa:	06300713          	li	a4,99
 7ae:	0ee78e63          	beq	a5,a4,8aa <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 7b2:	11478863          	beq	a5,s4,8c2 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7b6:	85d2                	mv	a1,s4
 7b8:	8556                	mv	a0,s5
 7ba:	00000097          	auipc	ra,0x0
 7be:	e92080e7          	jalr	-366(ra) # 64c <putc>
        putc(fd, c);
 7c2:	85ca                	mv	a1,s2
 7c4:	8556                	mv	a0,s5
 7c6:	00000097          	auipc	ra,0x0
 7ca:	e86080e7          	jalr	-378(ra) # 64c <putc>
      }
      state = 0;
 7ce:	4981                	li	s3,0
 7d0:	b765                	j	778 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7d2:	008b0913          	addi	s2,s6,8
 7d6:	4685                	li	a3,1
 7d8:	4629                	li	a2,10
 7da:	000b2583          	lw	a1,0(s6)
 7de:	8556                	mv	a0,s5
 7e0:	00000097          	auipc	ra,0x0
 7e4:	e8e080e7          	jalr	-370(ra) # 66e <printint>
 7e8:	8b4a                	mv	s6,s2
      state = 0;
 7ea:	4981                	li	s3,0
 7ec:	b771                	j	778 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ee:	008b0913          	addi	s2,s6,8
 7f2:	4681                	li	a3,0
 7f4:	4629                	li	a2,10
 7f6:	000b2583          	lw	a1,0(s6)
 7fa:	8556                	mv	a0,s5
 7fc:	00000097          	auipc	ra,0x0
 800:	e72080e7          	jalr	-398(ra) # 66e <printint>
 804:	8b4a                	mv	s6,s2
      state = 0;
 806:	4981                	li	s3,0
 808:	bf85                	j	778 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 80a:	008b0913          	addi	s2,s6,8
 80e:	4681                	li	a3,0
 810:	4641                	li	a2,16
 812:	000b2583          	lw	a1,0(s6)
 816:	8556                	mv	a0,s5
 818:	00000097          	auipc	ra,0x0
 81c:	e56080e7          	jalr	-426(ra) # 66e <printint>
 820:	8b4a                	mv	s6,s2
      state = 0;
 822:	4981                	li	s3,0
 824:	bf91                	j	778 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 826:	008b0793          	addi	a5,s6,8
 82a:	f8f43423          	sd	a5,-120(s0)
 82e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 832:	03000593          	li	a1,48
 836:	8556                	mv	a0,s5
 838:	00000097          	auipc	ra,0x0
 83c:	e14080e7          	jalr	-492(ra) # 64c <putc>
  putc(fd, 'x');
 840:	85ea                	mv	a1,s10
 842:	8556                	mv	a0,s5
 844:	00000097          	auipc	ra,0x0
 848:	e08080e7          	jalr	-504(ra) # 64c <putc>
 84c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 84e:	03c9d793          	srli	a5,s3,0x3c
 852:	97de                	add	a5,a5,s7
 854:	0007c583          	lbu	a1,0(a5)
 858:	8556                	mv	a0,s5
 85a:	00000097          	auipc	ra,0x0
 85e:	df2080e7          	jalr	-526(ra) # 64c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 862:	0992                	slli	s3,s3,0x4
 864:	397d                	addiw	s2,s2,-1
 866:	fe0914e3          	bnez	s2,84e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 86a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 86e:	4981                	li	s3,0
 870:	b721                	j	778 <vprintf+0x60>
        s = va_arg(ap, char*);
 872:	008b0993          	addi	s3,s6,8
 876:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 87a:	02090163          	beqz	s2,89c <vprintf+0x184>
        while(*s != 0){
 87e:	00094583          	lbu	a1,0(s2)
 882:	c9a1                	beqz	a1,8d2 <vprintf+0x1ba>
          putc(fd, *s);
 884:	8556                	mv	a0,s5
 886:	00000097          	auipc	ra,0x0
 88a:	dc6080e7          	jalr	-570(ra) # 64c <putc>
          s++;
 88e:	0905                	addi	s2,s2,1
        while(*s != 0){
 890:	00094583          	lbu	a1,0(s2)
 894:	f9e5                	bnez	a1,884 <vprintf+0x16c>
        s = va_arg(ap, char*);
 896:	8b4e                	mv	s6,s3
      state = 0;
 898:	4981                	li	s3,0
 89a:	bdf9                	j	778 <vprintf+0x60>
          s = "(null)";
 89c:	00000917          	auipc	s2,0x0
 8a0:	2b490913          	addi	s2,s2,692 # b50 <malloc+0x16e>
        while(*s != 0){
 8a4:	02800593          	li	a1,40
 8a8:	bff1                	j	884 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 8aa:	008b0913          	addi	s2,s6,8
 8ae:	000b4583          	lbu	a1,0(s6)
 8b2:	8556                	mv	a0,s5
 8b4:	00000097          	auipc	ra,0x0
 8b8:	d98080e7          	jalr	-616(ra) # 64c <putc>
 8bc:	8b4a                	mv	s6,s2
      state = 0;
 8be:	4981                	li	s3,0
 8c0:	bd65                	j	778 <vprintf+0x60>
        putc(fd, c);
 8c2:	85d2                	mv	a1,s4
 8c4:	8556                	mv	a0,s5
 8c6:	00000097          	auipc	ra,0x0
 8ca:	d86080e7          	jalr	-634(ra) # 64c <putc>
      state = 0;
 8ce:	4981                	li	s3,0
 8d0:	b565                	j	778 <vprintf+0x60>
        s = va_arg(ap, char*);
 8d2:	8b4e                	mv	s6,s3
      state = 0;
 8d4:	4981                	li	s3,0
 8d6:	b54d                	j	778 <vprintf+0x60>
    }
  }
}
 8d8:	70e6                	ld	ra,120(sp)
 8da:	7446                	ld	s0,112(sp)
 8dc:	74a6                	ld	s1,104(sp)
 8de:	7906                	ld	s2,96(sp)
 8e0:	69e6                	ld	s3,88(sp)
 8e2:	6a46                	ld	s4,80(sp)
 8e4:	6aa6                	ld	s5,72(sp)
 8e6:	6b06                	ld	s6,64(sp)
 8e8:	7be2                	ld	s7,56(sp)
 8ea:	7c42                	ld	s8,48(sp)
 8ec:	7ca2                	ld	s9,40(sp)
 8ee:	7d02                	ld	s10,32(sp)
 8f0:	6de2                	ld	s11,24(sp)
 8f2:	6109                	addi	sp,sp,128
 8f4:	8082                	ret

00000000000008f6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8f6:	715d                	addi	sp,sp,-80
 8f8:	ec06                	sd	ra,24(sp)
 8fa:	e822                	sd	s0,16(sp)
 8fc:	1000                	addi	s0,sp,32
 8fe:	e010                	sd	a2,0(s0)
 900:	e414                	sd	a3,8(s0)
 902:	e818                	sd	a4,16(s0)
 904:	ec1c                	sd	a5,24(s0)
 906:	03043023          	sd	a6,32(s0)
 90a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 90e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 912:	8622                	mv	a2,s0
 914:	00000097          	auipc	ra,0x0
 918:	e04080e7          	jalr	-508(ra) # 718 <vprintf>
}
 91c:	60e2                	ld	ra,24(sp)
 91e:	6442                	ld	s0,16(sp)
 920:	6161                	addi	sp,sp,80
 922:	8082                	ret

0000000000000924 <printf>:

void
printf(const char *fmt, ...)
{
 924:	711d                	addi	sp,sp,-96
 926:	ec06                	sd	ra,24(sp)
 928:	e822                	sd	s0,16(sp)
 92a:	1000                	addi	s0,sp,32
 92c:	e40c                	sd	a1,8(s0)
 92e:	e810                	sd	a2,16(s0)
 930:	ec14                	sd	a3,24(s0)
 932:	f018                	sd	a4,32(s0)
 934:	f41c                	sd	a5,40(s0)
 936:	03043823          	sd	a6,48(s0)
 93a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 93e:	00840613          	addi	a2,s0,8
 942:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 946:	85aa                	mv	a1,a0
 948:	4505                	li	a0,1
 94a:	00000097          	auipc	ra,0x0
 94e:	dce080e7          	jalr	-562(ra) # 718 <vprintf>
}
 952:	60e2                	ld	ra,24(sp)
 954:	6442                	ld	s0,16(sp)
 956:	6125                	addi	sp,sp,96
 958:	8082                	ret

000000000000095a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 95a:	1141                	addi	sp,sp,-16
 95c:	e422                	sd	s0,8(sp)
 95e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 960:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 964:	00000797          	auipc	a5,0x0
 968:	69c7b783          	ld	a5,1692(a5) # 1000 <freep>
 96c:	a805                	j	99c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 96e:	4618                	lw	a4,8(a2)
 970:	9db9                	addw	a1,a1,a4
 972:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 976:	6398                	ld	a4,0(a5)
 978:	6318                	ld	a4,0(a4)
 97a:	fee53823          	sd	a4,-16(a0)
 97e:	a091                	j	9c2 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 980:	ff852703          	lw	a4,-8(a0)
 984:	9e39                	addw	a2,a2,a4
 986:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 988:	ff053703          	ld	a4,-16(a0)
 98c:	e398                	sd	a4,0(a5)
 98e:	a099                	j	9d4 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 990:	6398                	ld	a4,0(a5)
 992:	00e7e463          	bltu	a5,a4,99a <free+0x40>
 996:	00e6ea63          	bltu	a3,a4,9aa <free+0x50>
{
 99a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 99c:	fed7fae3          	bgeu	a5,a3,990 <free+0x36>
 9a0:	6398                	ld	a4,0(a5)
 9a2:	00e6e463          	bltu	a3,a4,9aa <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a6:	fee7eae3          	bltu	a5,a4,99a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 9aa:	ff852583          	lw	a1,-8(a0)
 9ae:	6390                	ld	a2,0(a5)
 9b0:	02059713          	slli	a4,a1,0x20
 9b4:	9301                	srli	a4,a4,0x20
 9b6:	0712                	slli	a4,a4,0x4
 9b8:	9736                	add	a4,a4,a3
 9ba:	fae60ae3          	beq	a2,a4,96e <free+0x14>
    bp->s.ptr = p->s.ptr;
 9be:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9c2:	4790                	lw	a2,8(a5)
 9c4:	02061713          	slli	a4,a2,0x20
 9c8:	9301                	srli	a4,a4,0x20
 9ca:	0712                	slli	a4,a4,0x4
 9cc:	973e                	add	a4,a4,a5
 9ce:	fae689e3          	beq	a3,a4,980 <free+0x26>
  } else
    p->s.ptr = bp;
 9d2:	e394                	sd	a3,0(a5)
  freep = p;
 9d4:	00000717          	auipc	a4,0x0
 9d8:	62f73623          	sd	a5,1580(a4) # 1000 <freep>
}
 9dc:	6422                	ld	s0,8(sp)
 9de:	0141                	addi	sp,sp,16
 9e0:	8082                	ret

00000000000009e2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9e2:	7139                	addi	sp,sp,-64
 9e4:	fc06                	sd	ra,56(sp)
 9e6:	f822                	sd	s0,48(sp)
 9e8:	f426                	sd	s1,40(sp)
 9ea:	f04a                	sd	s2,32(sp)
 9ec:	ec4e                	sd	s3,24(sp)
 9ee:	e852                	sd	s4,16(sp)
 9f0:	e456                	sd	s5,8(sp)
 9f2:	e05a                	sd	s6,0(sp)
 9f4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f6:	02051493          	slli	s1,a0,0x20
 9fa:	9081                	srli	s1,s1,0x20
 9fc:	04bd                	addi	s1,s1,15
 9fe:	8091                	srli	s1,s1,0x4
 a00:	0014899b          	addiw	s3,s1,1
 a04:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a06:	00000517          	auipc	a0,0x0
 a0a:	5fa53503          	ld	a0,1530(a0) # 1000 <freep>
 a0e:	c515                	beqz	a0,a3a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a10:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a12:	4798                	lw	a4,8(a5)
 a14:	02977f63          	bgeu	a4,s1,a52 <malloc+0x70>
 a18:	8a4e                	mv	s4,s3
 a1a:	0009871b          	sext.w	a4,s3
 a1e:	6685                	lui	a3,0x1
 a20:	00d77363          	bgeu	a4,a3,a26 <malloc+0x44>
 a24:	6a05                	lui	s4,0x1
 a26:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a2a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a2e:	00000917          	auipc	s2,0x0
 a32:	5d290913          	addi	s2,s2,1490 # 1000 <freep>
  if(p == (char*)-1)
 a36:	5afd                	li	s5,-1
 a38:	a88d                	j	aaa <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 a3a:	00000797          	auipc	a5,0x0
 a3e:	5e678793          	addi	a5,a5,1510 # 1020 <base>
 a42:	00000717          	auipc	a4,0x0
 a46:	5af73f23          	sd	a5,1470(a4) # 1000 <freep>
 a4a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a4c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a50:	b7e1                	j	a18 <malloc+0x36>
      if(p->s.size == nunits)
 a52:	02e48b63          	beq	s1,a4,a88 <malloc+0xa6>
        p->s.size -= nunits;
 a56:	4137073b          	subw	a4,a4,s3
 a5a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a5c:	1702                	slli	a4,a4,0x20
 a5e:	9301                	srli	a4,a4,0x20
 a60:	0712                	slli	a4,a4,0x4
 a62:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a64:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a68:	00000717          	auipc	a4,0x0
 a6c:	58a73c23          	sd	a0,1432(a4) # 1000 <freep>
      return (void*)(p + 1);
 a70:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a74:	70e2                	ld	ra,56(sp)
 a76:	7442                	ld	s0,48(sp)
 a78:	74a2                	ld	s1,40(sp)
 a7a:	7902                	ld	s2,32(sp)
 a7c:	69e2                	ld	s3,24(sp)
 a7e:	6a42                	ld	s4,16(sp)
 a80:	6aa2                	ld	s5,8(sp)
 a82:	6b02                	ld	s6,0(sp)
 a84:	6121                	addi	sp,sp,64
 a86:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a88:	6398                	ld	a4,0(a5)
 a8a:	e118                	sd	a4,0(a0)
 a8c:	bff1                	j	a68 <malloc+0x86>
  hp->s.size = nu;
 a8e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a92:	0541                	addi	a0,a0,16
 a94:	00000097          	auipc	ra,0x0
 a98:	ec6080e7          	jalr	-314(ra) # 95a <free>
  return freep;
 a9c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 aa0:	d971                	beqz	a0,a74 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aa4:	4798                	lw	a4,8(a5)
 aa6:	fa9776e3          	bgeu	a4,s1,a52 <malloc+0x70>
    if(p == freep)
 aaa:	00093703          	ld	a4,0(s2)
 aae:	853e                	mv	a0,a5
 ab0:	fef719e3          	bne	a4,a5,aa2 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 ab4:	8552                	mv	a0,s4
 ab6:	00000097          	auipc	ra,0x0
 aba:	b7e080e7          	jalr	-1154(ra) # 634 <sbrk>
  if(p == (char*)-1)
 abe:	fd5518e3          	bne	a0,s5,a8e <malloc+0xac>
        return 0;
 ac2:	4501                	li	a0,0
 ac4:	bf45                	j	a74 <malloc+0x92>
