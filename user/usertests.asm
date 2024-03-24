
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	c2e080e7          	jalr	-978(ra) # 5c3e <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	c1c080e7          	jalr	-996(ra) # 5c3e <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	10250513          	addi	a0,a0,258 # 6140 <malloc+0x10c>
      46:	00006097          	auipc	ra,0x6
      4a:	f30080e7          	jalr	-208(ra) # 5f76 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	bae080e7          	jalr	-1106(ra) # 5bfe <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	0000a797          	auipc	a5,0xa
      5c:	51078793          	addi	a5,a5,1296 # a568 <uninit>
      60:	0000d697          	auipc	a3,0xd
      64:	c1868693          	addi	a3,a3,-1000 # cc78 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	0e050513          	addi	a0,a0,224 # 6160 <malloc+0x12c>
      88:	00006097          	auipc	ra,0x6
      8c:	eee080e7          	jalr	-274(ra) # 5f76 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	b6c080e7          	jalr	-1172(ra) # 5bfe <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	0d050513          	addi	a0,a0,208 # 6178 <malloc+0x144>
      b0:	00006097          	auipc	ra,0x6
      b4:	b8e080e7          	jalr	-1138(ra) # 5c3e <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	b6a080e7          	jalr	-1174(ra) # 5c26 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	0d250513          	addi	a0,a0,210 # 6198 <malloc+0x164>
      ce:	00006097          	auipc	ra,0x6
      d2:	b70080e7          	jalr	-1168(ra) # 5c3e <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	09a50513          	addi	a0,a0,154 # 6180 <malloc+0x14c>
      ee:	00006097          	auipc	ra,0x6
      f2:	e88080e7          	jalr	-376(ra) # 5f76 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	b06080e7          	jalr	-1274(ra) # 5bfe <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	0a650513          	addi	a0,a0,166 # 61a8 <malloc+0x174>
     10a:	00006097          	auipc	ra,0x6
     10e:	e6c080e7          	jalr	-404(ra) # 5f76 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	aea080e7          	jalr	-1302(ra) # 5bfe <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	0a450513          	addi	a0,a0,164 # 61d0 <malloc+0x19c>
     134:	00006097          	auipc	ra,0x6
     138:	b1a080e7          	jalr	-1254(ra) # 5c4e <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	09050513          	addi	a0,a0,144 # 61d0 <malloc+0x19c>
     148:	00006097          	auipc	ra,0x6
     14c:	af6080e7          	jalr	-1290(ra) # 5c3e <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	08c58593          	addi	a1,a1,140 # 61e0 <malloc+0x1ac>
     15c:	00006097          	auipc	ra,0x6
     160:	ac2080e7          	jalr	-1342(ra) # 5c1e <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	06850513          	addi	a0,a0,104 # 61d0 <malloc+0x19c>
     170:	00006097          	auipc	ra,0x6
     174:	ace080e7          	jalr	-1330(ra) # 5c3e <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	06c58593          	addi	a1,a1,108 # 61e8 <malloc+0x1b4>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	a98080e7          	jalr	-1384(ra) # 5c1e <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	03c50513          	addi	a0,a0,60 # 61d0 <malloc+0x19c>
     19c:	00006097          	auipc	ra,0x6
     1a0:	ab2080e7          	jalr	-1358(ra) # 5c4e <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	a80080e7          	jalr	-1408(ra) # 5c26 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	a76080e7          	jalr	-1418(ra) # 5c26 <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	02650513          	addi	a0,a0,38 # 61f0 <malloc+0x1bc>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	da4080e7          	jalr	-604(ra) # 5f76 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	a22080e7          	jalr	-1502(ra) # 5bfe <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00006097          	auipc	ra,0x6
     214:	a2e080e7          	jalr	-1490(ra) # 5c3e <open>
    close(fd);
     218:	00006097          	auipc	ra,0x6
     21c:	a0e080e7          	jalr	-1522(ra) # 5c26 <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	andi	s1,s1,255
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00006097          	auipc	ra,0x6
     24a:	a08080e7          	jalr	-1528(ra) # 5c4e <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	andi	s1,s1,255
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	f9c50513          	addi	a0,a0,-100 # 6218 <malloc+0x1e4>
     284:	00006097          	auipc	ra,0x6
     288:	9ca080e7          	jalr	-1590(ra) # 5c4e <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	f88a8a93          	addi	s5,s5,-120 # 6218 <malloc+0x1e4>
      int cc = write(fd, buf, sz);
     298:	0000da17          	auipc	s4,0xd
     29c:	9e0a0a13          	addi	s4,s4,-1568 # cc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <fourteen+0x19b>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00006097          	auipc	ra,0x6
     2b0:	992080e7          	jalr	-1646(ra) # 5c3e <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00006097          	auipc	ra,0x6
     2c2:	960080e7          	jalr	-1696(ra) # 5c1e <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49463          	bne	s1,a0,330 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00006097          	auipc	ra,0x6
     2d6:	94c080e7          	jalr	-1716(ra) # 5c1e <write>
      if(cc != sz){
     2da:	04951963          	bne	a0,s1,32c <bigwrite+0xc8>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00006097          	auipc	ra,0x6
     2e4:	946080e7          	jalr	-1722(ra) # 5c26 <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00006097          	auipc	ra,0x6
     2ee:	964080e7          	jalr	-1692(ra) # 5c4e <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	f1650513          	addi	a0,a0,-234 # 6228 <malloc+0x1f4>
     31a:	00006097          	auipc	ra,0x6
     31e:	c5c080e7          	jalr	-932(ra) # 5f76 <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00006097          	auipc	ra,0x6
     328:	8da080e7          	jalr	-1830(ra) # 5bfe <exit>
     32c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     32e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     330:	86ce                	mv	a3,s3
     332:	8626                	mv	a2,s1
     334:	85de                	mv	a1,s7
     336:	00006517          	auipc	a0,0x6
     33a:	f1250513          	addi	a0,a0,-238 # 6248 <malloc+0x214>
     33e:	00006097          	auipc	ra,0x6
     342:	c38080e7          	jalr	-968(ra) # 5f76 <printf>
        exit(1);
     346:	4505                	li	a0,1
     348:	00006097          	auipc	ra,0x6
     34c:	8b6080e7          	jalr	-1866(ra) # 5bfe <exit>

0000000000000350 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     350:	7179                	addi	sp,sp,-48
     352:	f406                	sd	ra,40(sp)
     354:	f022                	sd	s0,32(sp)
     356:	ec26                	sd	s1,24(sp)
     358:	e84a                	sd	s2,16(sp)
     35a:	e44e                	sd	s3,8(sp)
     35c:	e052                	sd	s4,0(sp)
     35e:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     360:	00006517          	auipc	a0,0x6
     364:	f0050513          	addi	a0,a0,-256 # 6260 <malloc+0x22c>
     368:	00006097          	auipc	ra,0x6
     36c:	8e6080e7          	jalr	-1818(ra) # 5c4e <unlink>
     370:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     374:	00006997          	auipc	s3,0x6
     378:	eec98993          	addi	s3,s3,-276 # 6260 <malloc+0x22c>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     37c:	5a7d                	li	s4,-1
     37e:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     382:	20100593          	li	a1,513
     386:	854e                	mv	a0,s3
     388:	00006097          	auipc	ra,0x6
     38c:	8b6080e7          	jalr	-1866(ra) # 5c3e <open>
     390:	84aa                	mv	s1,a0
    if(fd < 0){
     392:	06054b63          	bltz	a0,408 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
     396:	4605                	li	a2,1
     398:	85d2                	mv	a1,s4
     39a:	00006097          	auipc	ra,0x6
     39e:	884080e7          	jalr	-1916(ra) # 5c1e <write>
    close(fd);
     3a2:	8526                	mv	a0,s1
     3a4:	00006097          	auipc	ra,0x6
     3a8:	882080e7          	jalr	-1918(ra) # 5c26 <close>
    unlink("junk");
     3ac:	854e                	mv	a0,s3
     3ae:	00006097          	auipc	ra,0x6
     3b2:	8a0080e7          	jalr	-1888(ra) # 5c4e <unlink>
  for(int i = 0; i < assumed_free; i++){
     3b6:	397d                	addiw	s2,s2,-1
     3b8:	fc0915e3          	bnez	s2,382 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3bc:	20100593          	li	a1,513
     3c0:	00006517          	auipc	a0,0x6
     3c4:	ea050513          	addi	a0,a0,-352 # 6260 <malloc+0x22c>
     3c8:	00006097          	auipc	ra,0x6
     3cc:	876080e7          	jalr	-1930(ra) # 5c3e <open>
     3d0:	84aa                	mv	s1,a0
  if(fd < 0){
     3d2:	04054863          	bltz	a0,422 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     3d6:	4605                	li	a2,1
     3d8:	00006597          	auipc	a1,0x6
     3dc:	e1058593          	addi	a1,a1,-496 # 61e8 <malloc+0x1b4>
     3e0:	00006097          	auipc	ra,0x6
     3e4:	83e080e7          	jalr	-1986(ra) # 5c1e <write>
     3e8:	4785                	li	a5,1
     3ea:	04f50963          	beq	a0,a5,43c <badwrite+0xec>
    printf("write failed\n");
     3ee:	00006517          	auipc	a0,0x6
     3f2:	e9250513          	addi	a0,a0,-366 # 6280 <malloc+0x24c>
     3f6:	00006097          	auipc	ra,0x6
     3fa:	b80080e7          	jalr	-1152(ra) # 5f76 <printf>
    exit(1);
     3fe:	4505                	li	a0,1
     400:	00005097          	auipc	ra,0x5
     404:	7fe080e7          	jalr	2046(ra) # 5bfe <exit>
      printf("open junk failed\n");
     408:	00006517          	auipc	a0,0x6
     40c:	e6050513          	addi	a0,a0,-416 # 6268 <malloc+0x234>
     410:	00006097          	auipc	ra,0x6
     414:	b66080e7          	jalr	-1178(ra) # 5f76 <printf>
      exit(1);
     418:	4505                	li	a0,1
     41a:	00005097          	auipc	ra,0x5
     41e:	7e4080e7          	jalr	2020(ra) # 5bfe <exit>
    printf("open junk failed\n");
     422:	00006517          	auipc	a0,0x6
     426:	e4650513          	addi	a0,a0,-442 # 6268 <malloc+0x234>
     42a:	00006097          	auipc	ra,0x6
     42e:	b4c080e7          	jalr	-1204(ra) # 5f76 <printf>
    exit(1);
     432:	4505                	li	a0,1
     434:	00005097          	auipc	ra,0x5
     438:	7ca080e7          	jalr	1994(ra) # 5bfe <exit>
  }
  close(fd);
     43c:	8526                	mv	a0,s1
     43e:	00005097          	auipc	ra,0x5
     442:	7e8080e7          	jalr	2024(ra) # 5c26 <close>
  unlink("junk");
     446:	00006517          	auipc	a0,0x6
     44a:	e1a50513          	addi	a0,a0,-486 # 6260 <malloc+0x22c>
     44e:	00006097          	auipc	ra,0x6
     452:	800080e7          	jalr	-2048(ra) # 5c4e <unlink>

  exit(0);
     456:	4501                	li	a0,0
     458:	00005097          	auipc	ra,0x5
     45c:	7a6080e7          	jalr	1958(ra) # 5bfe <exit>

0000000000000460 <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     460:	715d                	addi	sp,sp,-80
     462:	e486                	sd	ra,72(sp)
     464:	e0a2                	sd	s0,64(sp)
     466:	fc26                	sd	s1,56(sp)
     468:	f84a                	sd	s2,48(sp)
     46a:	f44e                	sd	s3,40(sp)
     46c:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     46e:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     470:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     474:	40000993          	li	s3,1024
    name[0] = 'z';
     478:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     47c:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     480:	41f4d79b          	sraiw	a5,s1,0x1f
     484:	01b7d71b          	srliw	a4,a5,0x1b
     488:	009707bb          	addw	a5,a4,s1
     48c:	4057d69b          	sraiw	a3,a5,0x5
     490:	0306869b          	addiw	a3,a3,48
     494:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     498:	8bfd                	andi	a5,a5,31
     49a:	9f99                	subw	a5,a5,a4
     49c:	0307879b          	addiw	a5,a5,48
     4a0:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4a4:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4a8:	fb040513          	addi	a0,s0,-80
     4ac:	00005097          	auipc	ra,0x5
     4b0:	7a2080e7          	jalr	1954(ra) # 5c4e <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4b4:	60200593          	li	a1,1538
     4b8:	fb040513          	addi	a0,s0,-80
     4bc:	00005097          	auipc	ra,0x5
     4c0:	782080e7          	jalr	1922(ra) # 5c3e <open>
    if(fd < 0){
     4c4:	00054963          	bltz	a0,4d6 <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4c8:	00005097          	auipc	ra,0x5
     4cc:	75e080e7          	jalr	1886(ra) # 5c26 <close>
  for(int i = 0; i < nzz; i++){
     4d0:	2485                	addiw	s1,s1,1
     4d2:	fb3493e3          	bne	s1,s3,478 <outofinodes+0x18>
     4d6:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     4d8:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     4dc:	40000993          	li	s3,1024
    name[0] = 'z';
     4e0:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4e4:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4e8:	41f4d79b          	sraiw	a5,s1,0x1f
     4ec:	01b7d71b          	srliw	a4,a5,0x1b
     4f0:	009707bb          	addw	a5,a4,s1
     4f4:	4057d69b          	sraiw	a3,a5,0x5
     4f8:	0306869b          	addiw	a3,a3,48
     4fc:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     500:	8bfd                	andi	a5,a5,31
     502:	9f99                	subw	a5,a5,a4
     504:	0307879b          	addiw	a5,a5,48
     508:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     50c:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     510:	fb040513          	addi	a0,s0,-80
     514:	00005097          	auipc	ra,0x5
     518:	73a080e7          	jalr	1850(ra) # 5c4e <unlink>
  for(int i = 0; i < nzz; i++){
     51c:	2485                	addiw	s1,s1,1
     51e:	fd3491e3          	bne	s1,s3,4e0 <outofinodes+0x80>
  }
}
     522:	60a6                	ld	ra,72(sp)
     524:	6406                	ld	s0,64(sp)
     526:	74e2                	ld	s1,56(sp)
     528:	7942                	ld	s2,48(sp)
     52a:	79a2                	ld	s3,40(sp)
     52c:	6161                	addi	sp,sp,80
     52e:	8082                	ret

0000000000000530 <copyin>:
{
     530:	715d                	addi	sp,sp,-80
     532:	e486                	sd	ra,72(sp)
     534:	e0a2                	sd	s0,64(sp)
     536:	fc26                	sd	s1,56(sp)
     538:	f84a                	sd	s2,48(sp)
     53a:	f44e                	sd	s3,40(sp)
     53c:	f052                	sd	s4,32(sp)
     53e:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     540:	4785                	li	a5,1
     542:	07fe                	slli	a5,a5,0x1f
     544:	fcf43023          	sd	a5,-64(s0)
     548:	57fd                	li	a5,-1
     54a:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     54e:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     552:	00006a17          	auipc	s4,0x6
     556:	d3ea0a13          	addi	s4,s4,-706 # 6290 <malloc+0x25c>
    uint64 addr = addrs[ai];
     55a:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     55e:	20100593          	li	a1,513
     562:	8552                	mv	a0,s4
     564:	00005097          	auipc	ra,0x5
     568:	6da080e7          	jalr	1754(ra) # 5c3e <open>
     56c:	84aa                	mv	s1,a0
    if(fd < 0){
     56e:	08054863          	bltz	a0,5fe <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     572:	6609                	lui	a2,0x2
     574:	85ce                	mv	a1,s3
     576:	00005097          	auipc	ra,0x5
     57a:	6a8080e7          	jalr	1704(ra) # 5c1e <write>
    if(n >= 0){
     57e:	08055d63          	bgez	a0,618 <copyin+0xe8>
    close(fd);
     582:	8526                	mv	a0,s1
     584:	00005097          	auipc	ra,0x5
     588:	6a2080e7          	jalr	1698(ra) # 5c26 <close>
    unlink("copyin1");
     58c:	8552                	mv	a0,s4
     58e:	00005097          	auipc	ra,0x5
     592:	6c0080e7          	jalr	1728(ra) # 5c4e <unlink>
    n = write(1, (char*)addr, 8192);
     596:	6609                	lui	a2,0x2
     598:	85ce                	mv	a1,s3
     59a:	4505                	li	a0,1
     59c:	00005097          	auipc	ra,0x5
     5a0:	682080e7          	jalr	1666(ra) # 5c1e <write>
    if(n > 0){
     5a4:	08a04963          	bgtz	a0,636 <copyin+0x106>
    if(pipe(fds) < 0){
     5a8:	fb840513          	addi	a0,s0,-72
     5ac:	00005097          	auipc	ra,0x5
     5b0:	662080e7          	jalr	1634(ra) # 5c0e <pipe>
     5b4:	0a054063          	bltz	a0,654 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     5b8:	6609                	lui	a2,0x2
     5ba:	85ce                	mv	a1,s3
     5bc:	fbc42503          	lw	a0,-68(s0)
     5c0:	00005097          	auipc	ra,0x5
     5c4:	65e080e7          	jalr	1630(ra) # 5c1e <write>
    if(n > 0){
     5c8:	0aa04363          	bgtz	a0,66e <copyin+0x13e>
    close(fds[0]);
     5cc:	fb842503          	lw	a0,-72(s0)
     5d0:	00005097          	auipc	ra,0x5
     5d4:	656080e7          	jalr	1622(ra) # 5c26 <close>
    close(fds[1]);
     5d8:	fbc42503          	lw	a0,-68(s0)
     5dc:	00005097          	auipc	ra,0x5
     5e0:	64a080e7          	jalr	1610(ra) # 5c26 <close>
  for(int ai = 0; ai < 2; ai++){
     5e4:	0921                	addi	s2,s2,8
     5e6:	fd040793          	addi	a5,s0,-48
     5ea:	f6f918e3          	bne	s2,a5,55a <copyin+0x2a>
}
     5ee:	60a6                	ld	ra,72(sp)
     5f0:	6406                	ld	s0,64(sp)
     5f2:	74e2                	ld	s1,56(sp)
     5f4:	7942                	ld	s2,48(sp)
     5f6:	79a2                	ld	s3,40(sp)
     5f8:	7a02                	ld	s4,32(sp)
     5fa:	6161                	addi	sp,sp,80
     5fc:	8082                	ret
      printf("open(copyin1) failed\n");
     5fe:	00006517          	auipc	a0,0x6
     602:	c9a50513          	addi	a0,a0,-870 # 6298 <malloc+0x264>
     606:	00006097          	auipc	ra,0x6
     60a:	970080e7          	jalr	-1680(ra) # 5f76 <printf>
      exit(1);
     60e:	4505                	li	a0,1
     610:	00005097          	auipc	ra,0x5
     614:	5ee080e7          	jalr	1518(ra) # 5bfe <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     618:	862a                	mv	a2,a0
     61a:	85ce                	mv	a1,s3
     61c:	00006517          	auipc	a0,0x6
     620:	c9450513          	addi	a0,a0,-876 # 62b0 <malloc+0x27c>
     624:	00006097          	auipc	ra,0x6
     628:	952080e7          	jalr	-1710(ra) # 5f76 <printf>
      exit(1);
     62c:	4505                	li	a0,1
     62e:	00005097          	auipc	ra,0x5
     632:	5d0080e7          	jalr	1488(ra) # 5bfe <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     636:	862a                	mv	a2,a0
     638:	85ce                	mv	a1,s3
     63a:	00006517          	auipc	a0,0x6
     63e:	ca650513          	addi	a0,a0,-858 # 62e0 <malloc+0x2ac>
     642:	00006097          	auipc	ra,0x6
     646:	934080e7          	jalr	-1740(ra) # 5f76 <printf>
      exit(1);
     64a:	4505                	li	a0,1
     64c:	00005097          	auipc	ra,0x5
     650:	5b2080e7          	jalr	1458(ra) # 5bfe <exit>
      printf("pipe() failed\n");
     654:	00006517          	auipc	a0,0x6
     658:	cbc50513          	addi	a0,a0,-836 # 6310 <malloc+0x2dc>
     65c:	00006097          	auipc	ra,0x6
     660:	91a080e7          	jalr	-1766(ra) # 5f76 <printf>
      exit(1);
     664:	4505                	li	a0,1
     666:	00005097          	auipc	ra,0x5
     66a:	598080e7          	jalr	1432(ra) # 5bfe <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     66e:	862a                	mv	a2,a0
     670:	85ce                	mv	a1,s3
     672:	00006517          	auipc	a0,0x6
     676:	cae50513          	addi	a0,a0,-850 # 6320 <malloc+0x2ec>
     67a:	00006097          	auipc	ra,0x6
     67e:	8fc080e7          	jalr	-1796(ra) # 5f76 <printf>
      exit(1);
     682:	4505                	li	a0,1
     684:	00005097          	auipc	ra,0x5
     688:	57a080e7          	jalr	1402(ra) # 5bfe <exit>

000000000000068c <copyout>:
{
     68c:	711d                	addi	sp,sp,-96
     68e:	ec86                	sd	ra,88(sp)
     690:	e8a2                	sd	s0,80(sp)
     692:	e4a6                	sd	s1,72(sp)
     694:	e0ca                	sd	s2,64(sp)
     696:	fc4e                	sd	s3,56(sp)
     698:	f852                	sd	s4,48(sp)
     69a:	f456                	sd	s5,40(sp)
     69c:	f05a                	sd	s6,32(sp)
     69e:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0LL, 0x80000000LL, 0xffffffffffffffff };
     6a0:	fa043423          	sd	zero,-88(s0)
     6a4:	4785                	li	a5,1
     6a6:	07fe                	slli	a5,a5,0x1f
     6a8:	faf43823          	sd	a5,-80(s0)
     6ac:	57fd                	li	a5,-1
     6ae:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     6b2:	fa840913          	addi	s2,s0,-88
     6b6:	fb840b13          	addi	s6,s0,-72
    int fd = open("README", 0);
     6ba:	00006a17          	auipc	s4,0x6
     6be:	c96a0a13          	addi	s4,s4,-874 # 6350 <malloc+0x31c>
    n = write(fds[1], "x", 1);
     6c2:	00006a97          	auipc	s5,0x6
     6c6:	b26a8a93          	addi	s5,s5,-1242 # 61e8 <malloc+0x1b4>
    uint64 addr = addrs[ai];
     6ca:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     6ce:	4581                	li	a1,0
     6d0:	8552                	mv	a0,s4
     6d2:	00005097          	auipc	ra,0x5
     6d6:	56c080e7          	jalr	1388(ra) # 5c3e <open>
     6da:	84aa                	mv	s1,a0
    if(fd < 0){
     6dc:	08054563          	bltz	a0,766 <copyout+0xda>
    int n = read(fd, (void*)addr, 8192);
     6e0:	6609                	lui	a2,0x2
     6e2:	85ce                	mv	a1,s3
     6e4:	00005097          	auipc	ra,0x5
     6e8:	532080e7          	jalr	1330(ra) # 5c16 <read>
    if(n > 0){
     6ec:	08a04a63          	bgtz	a0,780 <copyout+0xf4>
    close(fd);
     6f0:	8526                	mv	a0,s1
     6f2:	00005097          	auipc	ra,0x5
     6f6:	534080e7          	jalr	1332(ra) # 5c26 <close>
    if(pipe(fds) < 0){
     6fa:	fa040513          	addi	a0,s0,-96
     6fe:	00005097          	auipc	ra,0x5
     702:	510080e7          	jalr	1296(ra) # 5c0e <pipe>
     706:	08054c63          	bltz	a0,79e <copyout+0x112>
    n = write(fds[1], "x", 1);
     70a:	4605                	li	a2,1
     70c:	85d6                	mv	a1,s5
     70e:	fa442503          	lw	a0,-92(s0)
     712:	00005097          	auipc	ra,0x5
     716:	50c080e7          	jalr	1292(ra) # 5c1e <write>
    if(n != 1){
     71a:	4785                	li	a5,1
     71c:	08f51e63          	bne	a0,a5,7b8 <copyout+0x12c>
    n = read(fds[0], (void*)addr, 8192);
     720:	6609                	lui	a2,0x2
     722:	85ce                	mv	a1,s3
     724:	fa042503          	lw	a0,-96(s0)
     728:	00005097          	auipc	ra,0x5
     72c:	4ee080e7          	jalr	1262(ra) # 5c16 <read>
    if(n > 0){
     730:	0aa04163          	bgtz	a0,7d2 <copyout+0x146>
    close(fds[0]);
     734:	fa042503          	lw	a0,-96(s0)
     738:	00005097          	auipc	ra,0x5
     73c:	4ee080e7          	jalr	1262(ra) # 5c26 <close>
    close(fds[1]);
     740:	fa442503          	lw	a0,-92(s0)
     744:	00005097          	auipc	ra,0x5
     748:	4e2080e7          	jalr	1250(ra) # 5c26 <close>
  for(int ai = 0; ai < 2; ai++){
     74c:	0921                	addi	s2,s2,8
     74e:	f7691ee3          	bne	s2,s6,6ca <copyout+0x3e>
}
     752:	60e6                	ld	ra,88(sp)
     754:	6446                	ld	s0,80(sp)
     756:	64a6                	ld	s1,72(sp)
     758:	6906                	ld	s2,64(sp)
     75a:	79e2                	ld	s3,56(sp)
     75c:	7a42                	ld	s4,48(sp)
     75e:	7aa2                	ld	s5,40(sp)
     760:	7b02                	ld	s6,32(sp)
     762:	6125                	addi	sp,sp,96
     764:	8082                	ret
      printf("open(README) failed\n");
     766:	00006517          	auipc	a0,0x6
     76a:	bf250513          	addi	a0,a0,-1038 # 6358 <malloc+0x324>
     76e:	00006097          	auipc	ra,0x6
     772:	808080e7          	jalr	-2040(ra) # 5f76 <printf>
      exit(1);
     776:	4505                	li	a0,1
     778:	00005097          	auipc	ra,0x5
     77c:	486080e7          	jalr	1158(ra) # 5bfe <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     780:	862a                	mv	a2,a0
     782:	85ce                	mv	a1,s3
     784:	00006517          	auipc	a0,0x6
     788:	bec50513          	addi	a0,a0,-1044 # 6370 <malloc+0x33c>
     78c:	00005097          	auipc	ra,0x5
     790:	7ea080e7          	jalr	2026(ra) # 5f76 <printf>
      exit(1);
     794:	4505                	li	a0,1
     796:	00005097          	auipc	ra,0x5
     79a:	468080e7          	jalr	1128(ra) # 5bfe <exit>
      printf("pipe() failed\n");
     79e:	00006517          	auipc	a0,0x6
     7a2:	b7250513          	addi	a0,a0,-1166 # 6310 <malloc+0x2dc>
     7a6:	00005097          	auipc	ra,0x5
     7aa:	7d0080e7          	jalr	2000(ra) # 5f76 <printf>
      exit(1);
     7ae:	4505                	li	a0,1
     7b0:	00005097          	auipc	ra,0x5
     7b4:	44e080e7          	jalr	1102(ra) # 5bfe <exit>
      printf("pipe write failed\n");
     7b8:	00006517          	auipc	a0,0x6
     7bc:	be850513          	addi	a0,a0,-1048 # 63a0 <malloc+0x36c>
     7c0:	00005097          	auipc	ra,0x5
     7c4:	7b6080e7          	jalr	1974(ra) # 5f76 <printf>
      exit(1);
     7c8:	4505                	li	a0,1
     7ca:	00005097          	auipc	ra,0x5
     7ce:	434080e7          	jalr	1076(ra) # 5bfe <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7d2:	862a                	mv	a2,a0
     7d4:	85ce                	mv	a1,s3
     7d6:	00006517          	auipc	a0,0x6
     7da:	be250513          	addi	a0,a0,-1054 # 63b8 <malloc+0x384>
     7de:	00005097          	auipc	ra,0x5
     7e2:	798080e7          	jalr	1944(ra) # 5f76 <printf>
      exit(1);
     7e6:	4505                	li	a0,1
     7e8:	00005097          	auipc	ra,0x5
     7ec:	416080e7          	jalr	1046(ra) # 5bfe <exit>

00000000000007f0 <truncate1>:
{
     7f0:	711d                	addi	sp,sp,-96
     7f2:	ec86                	sd	ra,88(sp)
     7f4:	e8a2                	sd	s0,80(sp)
     7f6:	e4a6                	sd	s1,72(sp)
     7f8:	e0ca                	sd	s2,64(sp)
     7fa:	fc4e                	sd	s3,56(sp)
     7fc:	f852                	sd	s4,48(sp)
     7fe:	f456                	sd	s5,40(sp)
     800:	1080                	addi	s0,sp,96
     802:	8aaa                	mv	s5,a0
  unlink("truncfile");
     804:	00006517          	auipc	a0,0x6
     808:	9cc50513          	addi	a0,a0,-1588 # 61d0 <malloc+0x19c>
     80c:	00005097          	auipc	ra,0x5
     810:	442080e7          	jalr	1090(ra) # 5c4e <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     814:	60100593          	li	a1,1537
     818:	00006517          	auipc	a0,0x6
     81c:	9b850513          	addi	a0,a0,-1608 # 61d0 <malloc+0x19c>
     820:	00005097          	auipc	ra,0x5
     824:	41e080e7          	jalr	1054(ra) # 5c3e <open>
     828:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     82a:	4611                	li	a2,4
     82c:	00006597          	auipc	a1,0x6
     830:	9b458593          	addi	a1,a1,-1612 # 61e0 <malloc+0x1ac>
     834:	00005097          	auipc	ra,0x5
     838:	3ea080e7          	jalr	1002(ra) # 5c1e <write>
  close(fd1);
     83c:	8526                	mv	a0,s1
     83e:	00005097          	auipc	ra,0x5
     842:	3e8080e7          	jalr	1000(ra) # 5c26 <close>
  int fd2 = open("truncfile", O_RDONLY);
     846:	4581                	li	a1,0
     848:	00006517          	auipc	a0,0x6
     84c:	98850513          	addi	a0,a0,-1656 # 61d0 <malloc+0x19c>
     850:	00005097          	auipc	ra,0x5
     854:	3ee080e7          	jalr	1006(ra) # 5c3e <open>
     858:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     85a:	02000613          	li	a2,32
     85e:	fa040593          	addi	a1,s0,-96
     862:	00005097          	auipc	ra,0x5
     866:	3b4080e7          	jalr	948(ra) # 5c16 <read>
  if(n != 4){
     86a:	4791                	li	a5,4
     86c:	0cf51e63          	bne	a0,a5,948 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     870:	40100593          	li	a1,1025
     874:	00006517          	auipc	a0,0x6
     878:	95c50513          	addi	a0,a0,-1700 # 61d0 <malloc+0x19c>
     87c:	00005097          	auipc	ra,0x5
     880:	3c2080e7          	jalr	962(ra) # 5c3e <open>
     884:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     886:	4581                	li	a1,0
     888:	00006517          	auipc	a0,0x6
     88c:	94850513          	addi	a0,a0,-1720 # 61d0 <malloc+0x19c>
     890:	00005097          	auipc	ra,0x5
     894:	3ae080e7          	jalr	942(ra) # 5c3e <open>
     898:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     89a:	02000613          	li	a2,32
     89e:	fa040593          	addi	a1,s0,-96
     8a2:	00005097          	auipc	ra,0x5
     8a6:	374080e7          	jalr	884(ra) # 5c16 <read>
     8aa:	8a2a                	mv	s4,a0
  if(n != 0){
     8ac:	ed4d                	bnez	a0,966 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8ae:	02000613          	li	a2,32
     8b2:	fa040593          	addi	a1,s0,-96
     8b6:	8526                	mv	a0,s1
     8b8:	00005097          	auipc	ra,0x5
     8bc:	35e080e7          	jalr	862(ra) # 5c16 <read>
     8c0:	8a2a                	mv	s4,a0
  if(n != 0){
     8c2:	e971                	bnez	a0,996 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8c4:	4619                	li	a2,6
     8c6:	00006597          	auipc	a1,0x6
     8ca:	b8258593          	addi	a1,a1,-1150 # 6448 <malloc+0x414>
     8ce:	854e                	mv	a0,s3
     8d0:	00005097          	auipc	ra,0x5
     8d4:	34e080e7          	jalr	846(ra) # 5c1e <write>
  n = read(fd3, buf, sizeof(buf));
     8d8:	02000613          	li	a2,32
     8dc:	fa040593          	addi	a1,s0,-96
     8e0:	854a                	mv	a0,s2
     8e2:	00005097          	auipc	ra,0x5
     8e6:	334080e7          	jalr	820(ra) # 5c16 <read>
  if(n != 6){
     8ea:	4799                	li	a5,6
     8ec:	0cf51d63          	bne	a0,a5,9c6 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     8f0:	02000613          	li	a2,32
     8f4:	fa040593          	addi	a1,s0,-96
     8f8:	8526                	mv	a0,s1
     8fa:	00005097          	auipc	ra,0x5
     8fe:	31c080e7          	jalr	796(ra) # 5c16 <read>
  if(n != 2){
     902:	4789                	li	a5,2
     904:	0ef51063          	bne	a0,a5,9e4 <truncate1+0x1f4>
  unlink("truncfile");
     908:	00006517          	auipc	a0,0x6
     90c:	8c850513          	addi	a0,a0,-1848 # 61d0 <malloc+0x19c>
     910:	00005097          	auipc	ra,0x5
     914:	33e080e7          	jalr	830(ra) # 5c4e <unlink>
  close(fd1);
     918:	854e                	mv	a0,s3
     91a:	00005097          	auipc	ra,0x5
     91e:	30c080e7          	jalr	780(ra) # 5c26 <close>
  close(fd2);
     922:	8526                	mv	a0,s1
     924:	00005097          	auipc	ra,0x5
     928:	302080e7          	jalr	770(ra) # 5c26 <close>
  close(fd3);
     92c:	854a                	mv	a0,s2
     92e:	00005097          	auipc	ra,0x5
     932:	2f8080e7          	jalr	760(ra) # 5c26 <close>
}
     936:	60e6                	ld	ra,88(sp)
     938:	6446                	ld	s0,80(sp)
     93a:	64a6                	ld	s1,72(sp)
     93c:	6906                	ld	s2,64(sp)
     93e:	79e2                	ld	s3,56(sp)
     940:	7a42                	ld	s4,48(sp)
     942:	7aa2                	ld	s5,40(sp)
     944:	6125                	addi	sp,sp,96
     946:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     948:	862a                	mv	a2,a0
     94a:	85d6                	mv	a1,s5
     94c:	00006517          	auipc	a0,0x6
     950:	a9c50513          	addi	a0,a0,-1380 # 63e8 <malloc+0x3b4>
     954:	00005097          	auipc	ra,0x5
     958:	622080e7          	jalr	1570(ra) # 5f76 <printf>
    exit(1);
     95c:	4505                	li	a0,1
     95e:	00005097          	auipc	ra,0x5
     962:	2a0080e7          	jalr	672(ra) # 5bfe <exit>
    printf("aaa fd3=%d\n", fd3);
     966:	85ca                	mv	a1,s2
     968:	00006517          	auipc	a0,0x6
     96c:	aa050513          	addi	a0,a0,-1376 # 6408 <malloc+0x3d4>
     970:	00005097          	auipc	ra,0x5
     974:	606080e7          	jalr	1542(ra) # 5f76 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     978:	8652                	mv	a2,s4
     97a:	85d6                	mv	a1,s5
     97c:	00006517          	auipc	a0,0x6
     980:	a9c50513          	addi	a0,a0,-1380 # 6418 <malloc+0x3e4>
     984:	00005097          	auipc	ra,0x5
     988:	5f2080e7          	jalr	1522(ra) # 5f76 <printf>
    exit(1);
     98c:	4505                	li	a0,1
     98e:	00005097          	auipc	ra,0x5
     992:	270080e7          	jalr	624(ra) # 5bfe <exit>
    printf("bbb fd2=%d\n", fd2);
     996:	85a6                	mv	a1,s1
     998:	00006517          	auipc	a0,0x6
     99c:	aa050513          	addi	a0,a0,-1376 # 6438 <malloc+0x404>
     9a0:	00005097          	auipc	ra,0x5
     9a4:	5d6080e7          	jalr	1494(ra) # 5f76 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     9a8:	8652                	mv	a2,s4
     9aa:	85d6                	mv	a1,s5
     9ac:	00006517          	auipc	a0,0x6
     9b0:	a6c50513          	addi	a0,a0,-1428 # 6418 <malloc+0x3e4>
     9b4:	00005097          	auipc	ra,0x5
     9b8:	5c2080e7          	jalr	1474(ra) # 5f76 <printf>
    exit(1);
     9bc:	4505                	li	a0,1
     9be:	00005097          	auipc	ra,0x5
     9c2:	240080e7          	jalr	576(ra) # 5bfe <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9c6:	862a                	mv	a2,a0
     9c8:	85d6                	mv	a1,s5
     9ca:	00006517          	auipc	a0,0x6
     9ce:	a8650513          	addi	a0,a0,-1402 # 6450 <malloc+0x41c>
     9d2:	00005097          	auipc	ra,0x5
     9d6:	5a4080e7          	jalr	1444(ra) # 5f76 <printf>
    exit(1);
     9da:	4505                	li	a0,1
     9dc:	00005097          	auipc	ra,0x5
     9e0:	222080e7          	jalr	546(ra) # 5bfe <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9e4:	862a                	mv	a2,a0
     9e6:	85d6                	mv	a1,s5
     9e8:	00006517          	auipc	a0,0x6
     9ec:	a8850513          	addi	a0,a0,-1400 # 6470 <malloc+0x43c>
     9f0:	00005097          	auipc	ra,0x5
     9f4:	586080e7          	jalr	1414(ra) # 5f76 <printf>
    exit(1);
     9f8:	4505                	li	a0,1
     9fa:	00005097          	auipc	ra,0x5
     9fe:	204080e7          	jalr	516(ra) # 5bfe <exit>

0000000000000a02 <writetest>:
{
     a02:	7139                	addi	sp,sp,-64
     a04:	fc06                	sd	ra,56(sp)
     a06:	f822                	sd	s0,48(sp)
     a08:	f426                	sd	s1,40(sp)
     a0a:	f04a                	sd	s2,32(sp)
     a0c:	ec4e                	sd	s3,24(sp)
     a0e:	e852                	sd	s4,16(sp)
     a10:	e456                	sd	s5,8(sp)
     a12:	e05a                	sd	s6,0(sp)
     a14:	0080                	addi	s0,sp,64
     a16:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     a18:	20200593          	li	a1,514
     a1c:	00006517          	auipc	a0,0x6
     a20:	a7450513          	addi	a0,a0,-1420 # 6490 <malloc+0x45c>
     a24:	00005097          	auipc	ra,0x5
     a28:	21a080e7          	jalr	538(ra) # 5c3e <open>
  if(fd < 0){
     a2c:	0a054d63          	bltz	a0,ae6 <writetest+0xe4>
     a30:	892a                	mv	s2,a0
     a32:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a34:	00006997          	auipc	s3,0x6
     a38:	a8498993          	addi	s3,s3,-1404 # 64b8 <malloc+0x484>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a3c:	00006a97          	auipc	s5,0x6
     a40:	ab4a8a93          	addi	s5,s5,-1356 # 64f0 <malloc+0x4bc>
  for(i = 0; i < N; i++){
     a44:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a48:	4629                	li	a2,10
     a4a:	85ce                	mv	a1,s3
     a4c:	854a                	mv	a0,s2
     a4e:	00005097          	auipc	ra,0x5
     a52:	1d0080e7          	jalr	464(ra) # 5c1e <write>
     a56:	47a9                	li	a5,10
     a58:	0af51563          	bne	a0,a5,b02 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a5c:	4629                	li	a2,10
     a5e:	85d6                	mv	a1,s5
     a60:	854a                	mv	a0,s2
     a62:	00005097          	auipc	ra,0x5
     a66:	1bc080e7          	jalr	444(ra) # 5c1e <write>
     a6a:	47a9                	li	a5,10
     a6c:	0af51a63          	bne	a0,a5,b20 <writetest+0x11e>
  for(i = 0; i < N; i++){
     a70:	2485                	addiw	s1,s1,1
     a72:	fd449be3          	bne	s1,s4,a48 <writetest+0x46>
  close(fd);
     a76:	854a                	mv	a0,s2
     a78:	00005097          	auipc	ra,0x5
     a7c:	1ae080e7          	jalr	430(ra) # 5c26 <close>
  fd = open("small", O_RDONLY);
     a80:	4581                	li	a1,0
     a82:	00006517          	auipc	a0,0x6
     a86:	a0e50513          	addi	a0,a0,-1522 # 6490 <malloc+0x45c>
     a8a:	00005097          	auipc	ra,0x5
     a8e:	1b4080e7          	jalr	436(ra) # 5c3e <open>
     a92:	84aa                	mv	s1,a0
  if(fd < 0){
     a94:	0a054563          	bltz	a0,b3e <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     a98:	7d000613          	li	a2,2000
     a9c:	0000c597          	auipc	a1,0xc
     aa0:	1dc58593          	addi	a1,a1,476 # cc78 <buf>
     aa4:	00005097          	auipc	ra,0x5
     aa8:	172080e7          	jalr	370(ra) # 5c16 <read>
  if(i != N*SZ*2){
     aac:	7d000793          	li	a5,2000
     ab0:	0af51563          	bne	a0,a5,b5a <writetest+0x158>
  close(fd);
     ab4:	8526                	mv	a0,s1
     ab6:	00005097          	auipc	ra,0x5
     aba:	170080e7          	jalr	368(ra) # 5c26 <close>
  if(unlink("small") < 0){
     abe:	00006517          	auipc	a0,0x6
     ac2:	9d250513          	addi	a0,a0,-1582 # 6490 <malloc+0x45c>
     ac6:	00005097          	auipc	ra,0x5
     aca:	188080e7          	jalr	392(ra) # 5c4e <unlink>
     ace:	0a054463          	bltz	a0,b76 <writetest+0x174>
}
     ad2:	70e2                	ld	ra,56(sp)
     ad4:	7442                	ld	s0,48(sp)
     ad6:	74a2                	ld	s1,40(sp)
     ad8:	7902                	ld	s2,32(sp)
     ada:	69e2                	ld	s3,24(sp)
     adc:	6a42                	ld	s4,16(sp)
     ade:	6aa2                	ld	s5,8(sp)
     ae0:	6b02                	ld	s6,0(sp)
     ae2:	6121                	addi	sp,sp,64
     ae4:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     ae6:	85da                	mv	a1,s6
     ae8:	00006517          	auipc	a0,0x6
     aec:	9b050513          	addi	a0,a0,-1616 # 6498 <malloc+0x464>
     af0:	00005097          	auipc	ra,0x5
     af4:	486080e7          	jalr	1158(ra) # 5f76 <printf>
    exit(1);
     af8:	4505                	li	a0,1
     afa:	00005097          	auipc	ra,0x5
     afe:	104080e7          	jalr	260(ra) # 5bfe <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     b02:	8626                	mv	a2,s1
     b04:	85da                	mv	a1,s6
     b06:	00006517          	auipc	a0,0x6
     b0a:	9c250513          	addi	a0,a0,-1598 # 64c8 <malloc+0x494>
     b0e:	00005097          	auipc	ra,0x5
     b12:	468080e7          	jalr	1128(ra) # 5f76 <printf>
      exit(1);
     b16:	4505                	li	a0,1
     b18:	00005097          	auipc	ra,0x5
     b1c:	0e6080e7          	jalr	230(ra) # 5bfe <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b20:	8626                	mv	a2,s1
     b22:	85da                	mv	a1,s6
     b24:	00006517          	auipc	a0,0x6
     b28:	9dc50513          	addi	a0,a0,-1572 # 6500 <malloc+0x4cc>
     b2c:	00005097          	auipc	ra,0x5
     b30:	44a080e7          	jalr	1098(ra) # 5f76 <printf>
      exit(1);
     b34:	4505                	li	a0,1
     b36:	00005097          	auipc	ra,0x5
     b3a:	0c8080e7          	jalr	200(ra) # 5bfe <exit>
    printf("%s: error: open small failed!\n", s);
     b3e:	85da                	mv	a1,s6
     b40:	00006517          	auipc	a0,0x6
     b44:	9e850513          	addi	a0,a0,-1560 # 6528 <malloc+0x4f4>
     b48:	00005097          	auipc	ra,0x5
     b4c:	42e080e7          	jalr	1070(ra) # 5f76 <printf>
    exit(1);
     b50:	4505                	li	a0,1
     b52:	00005097          	auipc	ra,0x5
     b56:	0ac080e7          	jalr	172(ra) # 5bfe <exit>
    printf("%s: read failed\n", s);
     b5a:	85da                	mv	a1,s6
     b5c:	00006517          	auipc	a0,0x6
     b60:	9ec50513          	addi	a0,a0,-1556 # 6548 <malloc+0x514>
     b64:	00005097          	auipc	ra,0x5
     b68:	412080e7          	jalr	1042(ra) # 5f76 <printf>
    exit(1);
     b6c:	4505                	li	a0,1
     b6e:	00005097          	auipc	ra,0x5
     b72:	090080e7          	jalr	144(ra) # 5bfe <exit>
    printf("%s: unlink small failed\n", s);
     b76:	85da                	mv	a1,s6
     b78:	00006517          	auipc	a0,0x6
     b7c:	9e850513          	addi	a0,a0,-1560 # 6560 <malloc+0x52c>
     b80:	00005097          	auipc	ra,0x5
     b84:	3f6080e7          	jalr	1014(ra) # 5f76 <printf>
    exit(1);
     b88:	4505                	li	a0,1
     b8a:	00005097          	auipc	ra,0x5
     b8e:	074080e7          	jalr	116(ra) # 5bfe <exit>

0000000000000b92 <writebig>:
{
     b92:	7139                	addi	sp,sp,-64
     b94:	fc06                	sd	ra,56(sp)
     b96:	f822                	sd	s0,48(sp)
     b98:	f426                	sd	s1,40(sp)
     b9a:	f04a                	sd	s2,32(sp)
     b9c:	ec4e                	sd	s3,24(sp)
     b9e:	e852                	sd	s4,16(sp)
     ba0:	e456                	sd	s5,8(sp)
     ba2:	0080                	addi	s0,sp,64
     ba4:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     ba6:	20200593          	li	a1,514
     baa:	00006517          	auipc	a0,0x6
     bae:	9d650513          	addi	a0,a0,-1578 # 6580 <malloc+0x54c>
     bb2:	00005097          	auipc	ra,0x5
     bb6:	08c080e7          	jalr	140(ra) # 5c3e <open>
     bba:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     bbc:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     bbe:	0000c917          	auipc	s2,0xc
     bc2:	0ba90913          	addi	s2,s2,186 # cc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     bc6:	10c00a13          	li	s4,268
  if(fd < 0){
     bca:	06054c63          	bltz	a0,c42 <writebig+0xb0>
    ((int*)buf)[0] = i;
     bce:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     bd2:	40000613          	li	a2,1024
     bd6:	85ca                	mv	a1,s2
     bd8:	854e                	mv	a0,s3
     bda:	00005097          	auipc	ra,0x5
     bde:	044080e7          	jalr	68(ra) # 5c1e <write>
     be2:	40000793          	li	a5,1024
     be6:	06f51c63          	bne	a0,a5,c5e <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     bea:	2485                	addiw	s1,s1,1
     bec:	ff4491e3          	bne	s1,s4,bce <writebig+0x3c>
  close(fd);
     bf0:	854e                	mv	a0,s3
     bf2:	00005097          	auipc	ra,0x5
     bf6:	034080e7          	jalr	52(ra) # 5c26 <close>
  fd = open("big", O_RDONLY);
     bfa:	4581                	li	a1,0
     bfc:	00006517          	auipc	a0,0x6
     c00:	98450513          	addi	a0,a0,-1660 # 6580 <malloc+0x54c>
     c04:	00005097          	auipc	ra,0x5
     c08:	03a080e7          	jalr	58(ra) # 5c3e <open>
     c0c:	89aa                	mv	s3,a0
  n = 0;
     c0e:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c10:	0000c917          	auipc	s2,0xc
     c14:	06890913          	addi	s2,s2,104 # cc78 <buf>
  if(fd < 0){
     c18:	06054263          	bltz	a0,c7c <writebig+0xea>
    i = read(fd, buf, BSIZE);
     c1c:	40000613          	li	a2,1024
     c20:	85ca                	mv	a1,s2
     c22:	854e                	mv	a0,s3
     c24:	00005097          	auipc	ra,0x5
     c28:	ff2080e7          	jalr	-14(ra) # 5c16 <read>
    if(i == 0){
     c2c:	c535                	beqz	a0,c98 <writebig+0x106>
    } else if(i != BSIZE){
     c2e:	40000793          	li	a5,1024
     c32:	0af51f63          	bne	a0,a5,cf0 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     c36:	00092683          	lw	a3,0(s2)
     c3a:	0c969a63          	bne	a3,s1,d0e <writebig+0x17c>
    n++;
     c3e:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c40:	bff1                	j	c1c <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     c42:	85d6                	mv	a1,s5
     c44:	00006517          	auipc	a0,0x6
     c48:	94450513          	addi	a0,a0,-1724 # 6588 <malloc+0x554>
     c4c:	00005097          	auipc	ra,0x5
     c50:	32a080e7          	jalr	810(ra) # 5f76 <printf>
    exit(1);
     c54:	4505                	li	a0,1
     c56:	00005097          	auipc	ra,0x5
     c5a:	fa8080e7          	jalr	-88(ra) # 5bfe <exit>
      printf("%s: error: write big file failed\n", s, i);
     c5e:	8626                	mv	a2,s1
     c60:	85d6                	mv	a1,s5
     c62:	00006517          	auipc	a0,0x6
     c66:	94650513          	addi	a0,a0,-1722 # 65a8 <malloc+0x574>
     c6a:	00005097          	auipc	ra,0x5
     c6e:	30c080e7          	jalr	780(ra) # 5f76 <printf>
      exit(1);
     c72:	4505                	li	a0,1
     c74:	00005097          	auipc	ra,0x5
     c78:	f8a080e7          	jalr	-118(ra) # 5bfe <exit>
    printf("%s: error: open big failed!\n", s);
     c7c:	85d6                	mv	a1,s5
     c7e:	00006517          	auipc	a0,0x6
     c82:	95250513          	addi	a0,a0,-1710 # 65d0 <malloc+0x59c>
     c86:	00005097          	auipc	ra,0x5
     c8a:	2f0080e7          	jalr	752(ra) # 5f76 <printf>
    exit(1);
     c8e:	4505                	li	a0,1
     c90:	00005097          	auipc	ra,0x5
     c94:	f6e080e7          	jalr	-146(ra) # 5bfe <exit>
      if(n == MAXFILE - 1){
     c98:	10b00793          	li	a5,267
     c9c:	02f48a63          	beq	s1,a5,cd0 <writebig+0x13e>
  close(fd);
     ca0:	854e                	mv	a0,s3
     ca2:	00005097          	auipc	ra,0x5
     ca6:	f84080e7          	jalr	-124(ra) # 5c26 <close>
  if(unlink("big") < 0){
     caa:	00006517          	auipc	a0,0x6
     cae:	8d650513          	addi	a0,a0,-1834 # 6580 <malloc+0x54c>
     cb2:	00005097          	auipc	ra,0x5
     cb6:	f9c080e7          	jalr	-100(ra) # 5c4e <unlink>
     cba:	06054963          	bltz	a0,d2c <writebig+0x19a>
}
     cbe:	70e2                	ld	ra,56(sp)
     cc0:	7442                	ld	s0,48(sp)
     cc2:	74a2                	ld	s1,40(sp)
     cc4:	7902                	ld	s2,32(sp)
     cc6:	69e2                	ld	s3,24(sp)
     cc8:	6a42                	ld	s4,16(sp)
     cca:	6aa2                	ld	s5,8(sp)
     ccc:	6121                	addi	sp,sp,64
     cce:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     cd0:	10b00613          	li	a2,267
     cd4:	85d6                	mv	a1,s5
     cd6:	00006517          	auipc	a0,0x6
     cda:	91a50513          	addi	a0,a0,-1766 # 65f0 <malloc+0x5bc>
     cde:	00005097          	auipc	ra,0x5
     ce2:	298080e7          	jalr	664(ra) # 5f76 <printf>
        exit(1);
     ce6:	4505                	li	a0,1
     ce8:	00005097          	auipc	ra,0x5
     cec:	f16080e7          	jalr	-234(ra) # 5bfe <exit>
      printf("%s: read failed %d\n", s, i);
     cf0:	862a                	mv	a2,a0
     cf2:	85d6                	mv	a1,s5
     cf4:	00006517          	auipc	a0,0x6
     cf8:	92450513          	addi	a0,a0,-1756 # 6618 <malloc+0x5e4>
     cfc:	00005097          	auipc	ra,0x5
     d00:	27a080e7          	jalr	634(ra) # 5f76 <printf>
      exit(1);
     d04:	4505                	li	a0,1
     d06:	00005097          	auipc	ra,0x5
     d0a:	ef8080e7          	jalr	-264(ra) # 5bfe <exit>
      printf("%s: read content of block %d is %d\n", s,
     d0e:	8626                	mv	a2,s1
     d10:	85d6                	mv	a1,s5
     d12:	00006517          	auipc	a0,0x6
     d16:	91e50513          	addi	a0,a0,-1762 # 6630 <malloc+0x5fc>
     d1a:	00005097          	auipc	ra,0x5
     d1e:	25c080e7          	jalr	604(ra) # 5f76 <printf>
      exit(1);
     d22:	4505                	li	a0,1
     d24:	00005097          	auipc	ra,0x5
     d28:	eda080e7          	jalr	-294(ra) # 5bfe <exit>
    printf("%s: unlink big failed\n", s);
     d2c:	85d6                	mv	a1,s5
     d2e:	00006517          	auipc	a0,0x6
     d32:	92a50513          	addi	a0,a0,-1750 # 6658 <malloc+0x624>
     d36:	00005097          	auipc	ra,0x5
     d3a:	240080e7          	jalr	576(ra) # 5f76 <printf>
    exit(1);
     d3e:	4505                	li	a0,1
     d40:	00005097          	auipc	ra,0x5
     d44:	ebe080e7          	jalr	-322(ra) # 5bfe <exit>

0000000000000d48 <unlinkread>:
{
     d48:	7179                	addi	sp,sp,-48
     d4a:	f406                	sd	ra,40(sp)
     d4c:	f022                	sd	s0,32(sp)
     d4e:	ec26                	sd	s1,24(sp)
     d50:	e84a                	sd	s2,16(sp)
     d52:	e44e                	sd	s3,8(sp)
     d54:	1800                	addi	s0,sp,48
     d56:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     d58:	20200593          	li	a1,514
     d5c:	00006517          	auipc	a0,0x6
     d60:	91450513          	addi	a0,a0,-1772 # 6670 <malloc+0x63c>
     d64:	00005097          	auipc	ra,0x5
     d68:	eda080e7          	jalr	-294(ra) # 5c3e <open>
  if(fd < 0){
     d6c:	0e054563          	bltz	a0,e56 <unlinkread+0x10e>
     d70:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     d72:	4615                	li	a2,5
     d74:	00006597          	auipc	a1,0x6
     d78:	92c58593          	addi	a1,a1,-1748 # 66a0 <malloc+0x66c>
     d7c:	00005097          	auipc	ra,0x5
     d80:	ea2080e7          	jalr	-350(ra) # 5c1e <write>
  close(fd);
     d84:	8526                	mv	a0,s1
     d86:	00005097          	auipc	ra,0x5
     d8a:	ea0080e7          	jalr	-352(ra) # 5c26 <close>
  fd = open("unlinkread", O_RDWR);
     d8e:	4589                	li	a1,2
     d90:	00006517          	auipc	a0,0x6
     d94:	8e050513          	addi	a0,a0,-1824 # 6670 <malloc+0x63c>
     d98:	00005097          	auipc	ra,0x5
     d9c:	ea6080e7          	jalr	-346(ra) # 5c3e <open>
     da0:	84aa                	mv	s1,a0
  if(fd < 0){
     da2:	0c054863          	bltz	a0,e72 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     da6:	00006517          	auipc	a0,0x6
     daa:	8ca50513          	addi	a0,a0,-1846 # 6670 <malloc+0x63c>
     dae:	00005097          	auipc	ra,0x5
     db2:	ea0080e7          	jalr	-352(ra) # 5c4e <unlink>
     db6:	ed61                	bnez	a0,e8e <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     db8:	20200593          	li	a1,514
     dbc:	00006517          	auipc	a0,0x6
     dc0:	8b450513          	addi	a0,a0,-1868 # 6670 <malloc+0x63c>
     dc4:	00005097          	auipc	ra,0x5
     dc8:	e7a080e7          	jalr	-390(ra) # 5c3e <open>
     dcc:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     dce:	460d                	li	a2,3
     dd0:	00006597          	auipc	a1,0x6
     dd4:	91858593          	addi	a1,a1,-1768 # 66e8 <malloc+0x6b4>
     dd8:	00005097          	auipc	ra,0x5
     ddc:	e46080e7          	jalr	-442(ra) # 5c1e <write>
  close(fd1);
     de0:	854a                	mv	a0,s2
     de2:	00005097          	auipc	ra,0x5
     de6:	e44080e7          	jalr	-444(ra) # 5c26 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     dea:	660d                	lui	a2,0x3
     dec:	0000c597          	auipc	a1,0xc
     df0:	e8c58593          	addi	a1,a1,-372 # cc78 <buf>
     df4:	8526                	mv	a0,s1
     df6:	00005097          	auipc	ra,0x5
     dfa:	e20080e7          	jalr	-480(ra) # 5c16 <read>
     dfe:	4795                	li	a5,5
     e00:	0af51563          	bne	a0,a5,eaa <unlinkread+0x162>
  if(buf[0] != 'h'){
     e04:	0000c717          	auipc	a4,0xc
     e08:	e7474703          	lbu	a4,-396(a4) # cc78 <buf>
     e0c:	06800793          	li	a5,104
     e10:	0af71b63          	bne	a4,a5,ec6 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     e14:	4629                	li	a2,10
     e16:	0000c597          	auipc	a1,0xc
     e1a:	e6258593          	addi	a1,a1,-414 # cc78 <buf>
     e1e:	8526                	mv	a0,s1
     e20:	00005097          	auipc	ra,0x5
     e24:	dfe080e7          	jalr	-514(ra) # 5c1e <write>
     e28:	47a9                	li	a5,10
     e2a:	0af51c63          	bne	a0,a5,ee2 <unlinkread+0x19a>
  close(fd);
     e2e:	8526                	mv	a0,s1
     e30:	00005097          	auipc	ra,0x5
     e34:	df6080e7          	jalr	-522(ra) # 5c26 <close>
  unlink("unlinkread");
     e38:	00006517          	auipc	a0,0x6
     e3c:	83850513          	addi	a0,a0,-1992 # 6670 <malloc+0x63c>
     e40:	00005097          	auipc	ra,0x5
     e44:	e0e080e7          	jalr	-498(ra) # 5c4e <unlink>
}
     e48:	70a2                	ld	ra,40(sp)
     e4a:	7402                	ld	s0,32(sp)
     e4c:	64e2                	ld	s1,24(sp)
     e4e:	6942                	ld	s2,16(sp)
     e50:	69a2                	ld	s3,8(sp)
     e52:	6145                	addi	sp,sp,48
     e54:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     e56:	85ce                	mv	a1,s3
     e58:	00006517          	auipc	a0,0x6
     e5c:	82850513          	addi	a0,a0,-2008 # 6680 <malloc+0x64c>
     e60:	00005097          	auipc	ra,0x5
     e64:	116080e7          	jalr	278(ra) # 5f76 <printf>
    exit(1);
     e68:	4505                	li	a0,1
     e6a:	00005097          	auipc	ra,0x5
     e6e:	d94080e7          	jalr	-620(ra) # 5bfe <exit>
    printf("%s: open unlinkread failed\n", s);
     e72:	85ce                	mv	a1,s3
     e74:	00006517          	auipc	a0,0x6
     e78:	83450513          	addi	a0,a0,-1996 # 66a8 <malloc+0x674>
     e7c:	00005097          	auipc	ra,0x5
     e80:	0fa080e7          	jalr	250(ra) # 5f76 <printf>
    exit(1);
     e84:	4505                	li	a0,1
     e86:	00005097          	auipc	ra,0x5
     e8a:	d78080e7          	jalr	-648(ra) # 5bfe <exit>
    printf("%s: unlink unlinkread failed\n", s);
     e8e:	85ce                	mv	a1,s3
     e90:	00006517          	auipc	a0,0x6
     e94:	83850513          	addi	a0,a0,-1992 # 66c8 <malloc+0x694>
     e98:	00005097          	auipc	ra,0x5
     e9c:	0de080e7          	jalr	222(ra) # 5f76 <printf>
    exit(1);
     ea0:	4505                	li	a0,1
     ea2:	00005097          	auipc	ra,0x5
     ea6:	d5c080e7          	jalr	-676(ra) # 5bfe <exit>
    printf("%s: unlinkread read failed", s);
     eaa:	85ce                	mv	a1,s3
     eac:	00006517          	auipc	a0,0x6
     eb0:	84450513          	addi	a0,a0,-1980 # 66f0 <malloc+0x6bc>
     eb4:	00005097          	auipc	ra,0x5
     eb8:	0c2080e7          	jalr	194(ra) # 5f76 <printf>
    exit(1);
     ebc:	4505                	li	a0,1
     ebe:	00005097          	auipc	ra,0x5
     ec2:	d40080e7          	jalr	-704(ra) # 5bfe <exit>
    printf("%s: unlinkread wrong data\n", s);
     ec6:	85ce                	mv	a1,s3
     ec8:	00006517          	auipc	a0,0x6
     ecc:	84850513          	addi	a0,a0,-1976 # 6710 <malloc+0x6dc>
     ed0:	00005097          	auipc	ra,0x5
     ed4:	0a6080e7          	jalr	166(ra) # 5f76 <printf>
    exit(1);
     ed8:	4505                	li	a0,1
     eda:	00005097          	auipc	ra,0x5
     ede:	d24080e7          	jalr	-732(ra) # 5bfe <exit>
    printf("%s: unlinkread write failed\n", s);
     ee2:	85ce                	mv	a1,s3
     ee4:	00006517          	auipc	a0,0x6
     ee8:	84c50513          	addi	a0,a0,-1972 # 6730 <malloc+0x6fc>
     eec:	00005097          	auipc	ra,0x5
     ef0:	08a080e7          	jalr	138(ra) # 5f76 <printf>
    exit(1);
     ef4:	4505                	li	a0,1
     ef6:	00005097          	auipc	ra,0x5
     efa:	d08080e7          	jalr	-760(ra) # 5bfe <exit>

0000000000000efe <linktest>:
{
     efe:	1101                	addi	sp,sp,-32
     f00:	ec06                	sd	ra,24(sp)
     f02:	e822                	sd	s0,16(sp)
     f04:	e426                	sd	s1,8(sp)
     f06:	e04a                	sd	s2,0(sp)
     f08:	1000                	addi	s0,sp,32
     f0a:	892a                	mv	s2,a0
  unlink("lf1");
     f0c:	00006517          	auipc	a0,0x6
     f10:	84450513          	addi	a0,a0,-1980 # 6750 <malloc+0x71c>
     f14:	00005097          	auipc	ra,0x5
     f18:	d3a080e7          	jalr	-710(ra) # 5c4e <unlink>
  unlink("lf2");
     f1c:	00006517          	auipc	a0,0x6
     f20:	83c50513          	addi	a0,a0,-1988 # 6758 <malloc+0x724>
     f24:	00005097          	auipc	ra,0x5
     f28:	d2a080e7          	jalr	-726(ra) # 5c4e <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     f2c:	20200593          	li	a1,514
     f30:	00006517          	auipc	a0,0x6
     f34:	82050513          	addi	a0,a0,-2016 # 6750 <malloc+0x71c>
     f38:	00005097          	auipc	ra,0x5
     f3c:	d06080e7          	jalr	-762(ra) # 5c3e <open>
  if(fd < 0){
     f40:	10054763          	bltz	a0,104e <linktest+0x150>
     f44:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     f46:	4615                	li	a2,5
     f48:	00005597          	auipc	a1,0x5
     f4c:	75858593          	addi	a1,a1,1880 # 66a0 <malloc+0x66c>
     f50:	00005097          	auipc	ra,0x5
     f54:	cce080e7          	jalr	-818(ra) # 5c1e <write>
     f58:	4795                	li	a5,5
     f5a:	10f51863          	bne	a0,a5,106a <linktest+0x16c>
  close(fd);
     f5e:	8526                	mv	a0,s1
     f60:	00005097          	auipc	ra,0x5
     f64:	cc6080e7          	jalr	-826(ra) # 5c26 <close>
  if(link("lf1", "lf2") < 0){
     f68:	00005597          	auipc	a1,0x5
     f6c:	7f058593          	addi	a1,a1,2032 # 6758 <malloc+0x724>
     f70:	00005517          	auipc	a0,0x5
     f74:	7e050513          	addi	a0,a0,2016 # 6750 <malloc+0x71c>
     f78:	00005097          	auipc	ra,0x5
     f7c:	ce6080e7          	jalr	-794(ra) # 5c5e <link>
     f80:	10054363          	bltz	a0,1086 <linktest+0x188>
  unlink("lf1");
     f84:	00005517          	auipc	a0,0x5
     f88:	7cc50513          	addi	a0,a0,1996 # 6750 <malloc+0x71c>
     f8c:	00005097          	auipc	ra,0x5
     f90:	cc2080e7          	jalr	-830(ra) # 5c4e <unlink>
  if(open("lf1", 0) >= 0){
     f94:	4581                	li	a1,0
     f96:	00005517          	auipc	a0,0x5
     f9a:	7ba50513          	addi	a0,a0,1978 # 6750 <malloc+0x71c>
     f9e:	00005097          	auipc	ra,0x5
     fa2:	ca0080e7          	jalr	-864(ra) # 5c3e <open>
     fa6:	0e055e63          	bgez	a0,10a2 <linktest+0x1a4>
  fd = open("lf2", 0);
     faa:	4581                	li	a1,0
     fac:	00005517          	auipc	a0,0x5
     fb0:	7ac50513          	addi	a0,a0,1964 # 6758 <malloc+0x724>
     fb4:	00005097          	auipc	ra,0x5
     fb8:	c8a080e7          	jalr	-886(ra) # 5c3e <open>
     fbc:	84aa                	mv	s1,a0
  if(fd < 0){
     fbe:	10054063          	bltz	a0,10be <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     fc2:	660d                	lui	a2,0x3
     fc4:	0000c597          	auipc	a1,0xc
     fc8:	cb458593          	addi	a1,a1,-844 # cc78 <buf>
     fcc:	00005097          	auipc	ra,0x5
     fd0:	c4a080e7          	jalr	-950(ra) # 5c16 <read>
     fd4:	4795                	li	a5,5
     fd6:	10f51263          	bne	a0,a5,10da <linktest+0x1dc>
  close(fd);
     fda:	8526                	mv	a0,s1
     fdc:	00005097          	auipc	ra,0x5
     fe0:	c4a080e7          	jalr	-950(ra) # 5c26 <close>
  if(link("lf2", "lf2") >= 0){
     fe4:	00005597          	auipc	a1,0x5
     fe8:	77458593          	addi	a1,a1,1908 # 6758 <malloc+0x724>
     fec:	852e                	mv	a0,a1
     fee:	00005097          	auipc	ra,0x5
     ff2:	c70080e7          	jalr	-912(ra) # 5c5e <link>
     ff6:	10055063          	bgez	a0,10f6 <linktest+0x1f8>
  unlink("lf2");
     ffa:	00005517          	auipc	a0,0x5
     ffe:	75e50513          	addi	a0,a0,1886 # 6758 <malloc+0x724>
    1002:	00005097          	auipc	ra,0x5
    1006:	c4c080e7          	jalr	-948(ra) # 5c4e <unlink>
  if(link("lf2", "lf1") >= 0){
    100a:	00005597          	auipc	a1,0x5
    100e:	74658593          	addi	a1,a1,1862 # 6750 <malloc+0x71c>
    1012:	00005517          	auipc	a0,0x5
    1016:	74650513          	addi	a0,a0,1862 # 6758 <malloc+0x724>
    101a:	00005097          	auipc	ra,0x5
    101e:	c44080e7          	jalr	-956(ra) # 5c5e <link>
    1022:	0e055863          	bgez	a0,1112 <linktest+0x214>
  if(link(".", "lf1") >= 0){
    1026:	00005597          	auipc	a1,0x5
    102a:	72a58593          	addi	a1,a1,1834 # 6750 <malloc+0x71c>
    102e:	00006517          	auipc	a0,0x6
    1032:	83250513          	addi	a0,a0,-1998 # 6860 <malloc+0x82c>
    1036:	00005097          	auipc	ra,0x5
    103a:	c28080e7          	jalr	-984(ra) # 5c5e <link>
    103e:	0e055863          	bgez	a0,112e <linktest+0x230>
}
    1042:	60e2                	ld	ra,24(sp)
    1044:	6442                	ld	s0,16(sp)
    1046:	64a2                	ld	s1,8(sp)
    1048:	6902                	ld	s2,0(sp)
    104a:	6105                	addi	sp,sp,32
    104c:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    104e:	85ca                	mv	a1,s2
    1050:	00005517          	auipc	a0,0x5
    1054:	71050513          	addi	a0,a0,1808 # 6760 <malloc+0x72c>
    1058:	00005097          	auipc	ra,0x5
    105c:	f1e080e7          	jalr	-226(ra) # 5f76 <printf>
    exit(1);
    1060:	4505                	li	a0,1
    1062:	00005097          	auipc	ra,0x5
    1066:	b9c080e7          	jalr	-1124(ra) # 5bfe <exit>
    printf("%s: write lf1 failed\n", s);
    106a:	85ca                	mv	a1,s2
    106c:	00005517          	auipc	a0,0x5
    1070:	70c50513          	addi	a0,a0,1804 # 6778 <malloc+0x744>
    1074:	00005097          	auipc	ra,0x5
    1078:	f02080e7          	jalr	-254(ra) # 5f76 <printf>
    exit(1);
    107c:	4505                	li	a0,1
    107e:	00005097          	auipc	ra,0x5
    1082:	b80080e7          	jalr	-1152(ra) # 5bfe <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    1086:	85ca                	mv	a1,s2
    1088:	00005517          	auipc	a0,0x5
    108c:	70850513          	addi	a0,a0,1800 # 6790 <malloc+0x75c>
    1090:	00005097          	auipc	ra,0x5
    1094:	ee6080e7          	jalr	-282(ra) # 5f76 <printf>
    exit(1);
    1098:	4505                	li	a0,1
    109a:	00005097          	auipc	ra,0x5
    109e:	b64080e7          	jalr	-1180(ra) # 5bfe <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    10a2:	85ca                	mv	a1,s2
    10a4:	00005517          	auipc	a0,0x5
    10a8:	70c50513          	addi	a0,a0,1804 # 67b0 <malloc+0x77c>
    10ac:	00005097          	auipc	ra,0x5
    10b0:	eca080e7          	jalr	-310(ra) # 5f76 <printf>
    exit(1);
    10b4:	4505                	li	a0,1
    10b6:	00005097          	auipc	ra,0x5
    10ba:	b48080e7          	jalr	-1208(ra) # 5bfe <exit>
    printf("%s: open lf2 failed\n", s);
    10be:	85ca                	mv	a1,s2
    10c0:	00005517          	auipc	a0,0x5
    10c4:	72050513          	addi	a0,a0,1824 # 67e0 <malloc+0x7ac>
    10c8:	00005097          	auipc	ra,0x5
    10cc:	eae080e7          	jalr	-338(ra) # 5f76 <printf>
    exit(1);
    10d0:	4505                	li	a0,1
    10d2:	00005097          	auipc	ra,0x5
    10d6:	b2c080e7          	jalr	-1236(ra) # 5bfe <exit>
    printf("%s: read lf2 failed\n", s);
    10da:	85ca                	mv	a1,s2
    10dc:	00005517          	auipc	a0,0x5
    10e0:	71c50513          	addi	a0,a0,1820 # 67f8 <malloc+0x7c4>
    10e4:	00005097          	auipc	ra,0x5
    10e8:	e92080e7          	jalr	-366(ra) # 5f76 <printf>
    exit(1);
    10ec:	4505                	li	a0,1
    10ee:	00005097          	auipc	ra,0x5
    10f2:	b10080e7          	jalr	-1264(ra) # 5bfe <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    10f6:	85ca                	mv	a1,s2
    10f8:	00005517          	auipc	a0,0x5
    10fc:	71850513          	addi	a0,a0,1816 # 6810 <malloc+0x7dc>
    1100:	00005097          	auipc	ra,0x5
    1104:	e76080e7          	jalr	-394(ra) # 5f76 <printf>
    exit(1);
    1108:	4505                	li	a0,1
    110a:	00005097          	auipc	ra,0x5
    110e:	af4080e7          	jalr	-1292(ra) # 5bfe <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    1112:	85ca                	mv	a1,s2
    1114:	00005517          	auipc	a0,0x5
    1118:	72450513          	addi	a0,a0,1828 # 6838 <malloc+0x804>
    111c:	00005097          	auipc	ra,0x5
    1120:	e5a080e7          	jalr	-422(ra) # 5f76 <printf>
    exit(1);
    1124:	4505                	li	a0,1
    1126:	00005097          	auipc	ra,0x5
    112a:	ad8080e7          	jalr	-1320(ra) # 5bfe <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    112e:	85ca                	mv	a1,s2
    1130:	00005517          	auipc	a0,0x5
    1134:	73850513          	addi	a0,a0,1848 # 6868 <malloc+0x834>
    1138:	00005097          	auipc	ra,0x5
    113c:	e3e080e7          	jalr	-450(ra) # 5f76 <printf>
    exit(1);
    1140:	4505                	li	a0,1
    1142:	00005097          	auipc	ra,0x5
    1146:	abc080e7          	jalr	-1348(ra) # 5bfe <exit>

000000000000114a <validatetest>:
{
    114a:	7139                	addi	sp,sp,-64
    114c:	fc06                	sd	ra,56(sp)
    114e:	f822                	sd	s0,48(sp)
    1150:	f426                	sd	s1,40(sp)
    1152:	f04a                	sd	s2,32(sp)
    1154:	ec4e                	sd	s3,24(sp)
    1156:	e852                	sd	s4,16(sp)
    1158:	e456                	sd	s5,8(sp)
    115a:	e05a                	sd	s6,0(sp)
    115c:	0080                	addi	s0,sp,64
    115e:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1160:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    1162:	00005997          	auipc	s3,0x5
    1166:	72698993          	addi	s3,s3,1830 # 6888 <malloc+0x854>
    116a:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    116c:	6a85                	lui	s5,0x1
    116e:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    1172:	85a6                	mv	a1,s1
    1174:	854e                	mv	a0,s3
    1176:	00005097          	auipc	ra,0x5
    117a:	ae8080e7          	jalr	-1304(ra) # 5c5e <link>
    117e:	01251f63          	bne	a0,s2,119c <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1182:	94d6                	add	s1,s1,s5
    1184:	ff4497e3          	bne	s1,s4,1172 <validatetest+0x28>
}
    1188:	70e2                	ld	ra,56(sp)
    118a:	7442                	ld	s0,48(sp)
    118c:	74a2                	ld	s1,40(sp)
    118e:	7902                	ld	s2,32(sp)
    1190:	69e2                	ld	s3,24(sp)
    1192:	6a42                	ld	s4,16(sp)
    1194:	6aa2                	ld	s5,8(sp)
    1196:	6b02                	ld	s6,0(sp)
    1198:	6121                	addi	sp,sp,64
    119a:	8082                	ret
      printf("%s: link should not succeed\n", s);
    119c:	85da                	mv	a1,s6
    119e:	00005517          	auipc	a0,0x5
    11a2:	6fa50513          	addi	a0,a0,1786 # 6898 <malloc+0x864>
    11a6:	00005097          	auipc	ra,0x5
    11aa:	dd0080e7          	jalr	-560(ra) # 5f76 <printf>
      exit(1);
    11ae:	4505                	li	a0,1
    11b0:	00005097          	auipc	ra,0x5
    11b4:	a4e080e7          	jalr	-1458(ra) # 5bfe <exit>

00000000000011b8 <bigdir>:
{
    11b8:	715d                	addi	sp,sp,-80
    11ba:	e486                	sd	ra,72(sp)
    11bc:	e0a2                	sd	s0,64(sp)
    11be:	fc26                	sd	s1,56(sp)
    11c0:	f84a                	sd	s2,48(sp)
    11c2:	f44e                	sd	s3,40(sp)
    11c4:	f052                	sd	s4,32(sp)
    11c6:	ec56                	sd	s5,24(sp)
    11c8:	e85a                	sd	s6,16(sp)
    11ca:	0880                	addi	s0,sp,80
    11cc:	89aa                	mv	s3,a0
  unlink("bd");
    11ce:	00005517          	auipc	a0,0x5
    11d2:	6ea50513          	addi	a0,a0,1770 # 68b8 <malloc+0x884>
    11d6:	00005097          	auipc	ra,0x5
    11da:	a78080e7          	jalr	-1416(ra) # 5c4e <unlink>
  fd = open("bd", O_CREATE);
    11de:	20000593          	li	a1,512
    11e2:	00005517          	auipc	a0,0x5
    11e6:	6d650513          	addi	a0,a0,1750 # 68b8 <malloc+0x884>
    11ea:	00005097          	auipc	ra,0x5
    11ee:	a54080e7          	jalr	-1452(ra) # 5c3e <open>
  if(fd < 0){
    11f2:	0c054963          	bltz	a0,12c4 <bigdir+0x10c>
  close(fd);
    11f6:	00005097          	auipc	ra,0x5
    11fa:	a30080e7          	jalr	-1488(ra) # 5c26 <close>
  for(i = 0; i < N; i++){
    11fe:	4901                	li	s2,0
    name[0] = 'x';
    1200:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    1204:	00005a17          	auipc	s4,0x5
    1208:	6b4a0a13          	addi	s4,s4,1716 # 68b8 <malloc+0x884>
  for(i = 0; i < N; i++){
    120c:	1f400b13          	li	s6,500
    name[0] = 'x';
    1210:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    1214:	41f9579b          	sraiw	a5,s2,0x1f
    1218:	01a7d71b          	srliw	a4,a5,0x1a
    121c:	012707bb          	addw	a5,a4,s2
    1220:	4067d69b          	sraiw	a3,a5,0x6
    1224:	0306869b          	addiw	a3,a3,48
    1228:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    122c:	03f7f793          	andi	a5,a5,63
    1230:	9f99                	subw	a5,a5,a4
    1232:	0307879b          	addiw	a5,a5,48
    1236:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    123a:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    123e:	fb040593          	addi	a1,s0,-80
    1242:	8552                	mv	a0,s4
    1244:	00005097          	auipc	ra,0x5
    1248:	a1a080e7          	jalr	-1510(ra) # 5c5e <link>
    124c:	84aa                	mv	s1,a0
    124e:	e949                	bnez	a0,12e0 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1250:	2905                	addiw	s2,s2,1
    1252:	fb691fe3          	bne	s2,s6,1210 <bigdir+0x58>
  unlink("bd");
    1256:	00005517          	auipc	a0,0x5
    125a:	66250513          	addi	a0,a0,1634 # 68b8 <malloc+0x884>
    125e:	00005097          	auipc	ra,0x5
    1262:	9f0080e7          	jalr	-1552(ra) # 5c4e <unlink>
    name[0] = 'x';
    1266:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    126a:	1f400a13          	li	s4,500
    name[0] = 'x';
    126e:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1272:	41f4d79b          	sraiw	a5,s1,0x1f
    1276:	01a7d71b          	srliw	a4,a5,0x1a
    127a:	009707bb          	addw	a5,a4,s1
    127e:	4067d69b          	sraiw	a3,a5,0x6
    1282:	0306869b          	addiw	a3,a3,48
    1286:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    128a:	03f7f793          	andi	a5,a5,63
    128e:	9f99                	subw	a5,a5,a4
    1290:	0307879b          	addiw	a5,a5,48
    1294:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1298:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    129c:	fb040513          	addi	a0,s0,-80
    12a0:	00005097          	auipc	ra,0x5
    12a4:	9ae080e7          	jalr	-1618(ra) # 5c4e <unlink>
    12a8:	ed21                	bnez	a0,1300 <bigdir+0x148>
  for(i = 0; i < N; i++){
    12aa:	2485                	addiw	s1,s1,1
    12ac:	fd4491e3          	bne	s1,s4,126e <bigdir+0xb6>
}
    12b0:	60a6                	ld	ra,72(sp)
    12b2:	6406                	ld	s0,64(sp)
    12b4:	74e2                	ld	s1,56(sp)
    12b6:	7942                	ld	s2,48(sp)
    12b8:	79a2                	ld	s3,40(sp)
    12ba:	7a02                	ld	s4,32(sp)
    12bc:	6ae2                	ld	s5,24(sp)
    12be:	6b42                	ld	s6,16(sp)
    12c0:	6161                	addi	sp,sp,80
    12c2:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    12c4:	85ce                	mv	a1,s3
    12c6:	00005517          	auipc	a0,0x5
    12ca:	5fa50513          	addi	a0,a0,1530 # 68c0 <malloc+0x88c>
    12ce:	00005097          	auipc	ra,0x5
    12d2:	ca8080e7          	jalr	-856(ra) # 5f76 <printf>
    exit(1);
    12d6:	4505                	li	a0,1
    12d8:	00005097          	auipc	ra,0x5
    12dc:	926080e7          	jalr	-1754(ra) # 5bfe <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12e0:	fb040613          	addi	a2,s0,-80
    12e4:	85ce                	mv	a1,s3
    12e6:	00005517          	auipc	a0,0x5
    12ea:	5fa50513          	addi	a0,a0,1530 # 68e0 <malloc+0x8ac>
    12ee:	00005097          	auipc	ra,0x5
    12f2:	c88080e7          	jalr	-888(ra) # 5f76 <printf>
      exit(1);
    12f6:	4505                	li	a0,1
    12f8:	00005097          	auipc	ra,0x5
    12fc:	906080e7          	jalr	-1786(ra) # 5bfe <exit>
      printf("%s: bigdir unlink failed", s);
    1300:	85ce                	mv	a1,s3
    1302:	00005517          	auipc	a0,0x5
    1306:	5fe50513          	addi	a0,a0,1534 # 6900 <malloc+0x8cc>
    130a:	00005097          	auipc	ra,0x5
    130e:	c6c080e7          	jalr	-916(ra) # 5f76 <printf>
      exit(1);
    1312:	4505                	li	a0,1
    1314:	00005097          	auipc	ra,0x5
    1318:	8ea080e7          	jalr	-1814(ra) # 5bfe <exit>

000000000000131c <pgbug>:
{
    131c:	7179                	addi	sp,sp,-48
    131e:	f406                	sd	ra,40(sp)
    1320:	f022                	sd	s0,32(sp)
    1322:	ec26                	sd	s1,24(sp)
    1324:	1800                	addi	s0,sp,48
  argv[0] = 0;
    1326:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    132a:	00008497          	auipc	s1,0x8
    132e:	cd648493          	addi	s1,s1,-810 # 9000 <big>
    1332:	fd840593          	addi	a1,s0,-40
    1336:	6088                	ld	a0,0(s1)
    1338:	00005097          	auipc	ra,0x5
    133c:	8fe080e7          	jalr	-1794(ra) # 5c36 <exec>
  pipe(big);
    1340:	6088                	ld	a0,0(s1)
    1342:	00005097          	auipc	ra,0x5
    1346:	8cc080e7          	jalr	-1844(ra) # 5c0e <pipe>
  exit(0);
    134a:	4501                	li	a0,0
    134c:	00005097          	auipc	ra,0x5
    1350:	8b2080e7          	jalr	-1870(ra) # 5bfe <exit>

0000000000001354 <badarg>:
{
    1354:	7139                	addi	sp,sp,-64
    1356:	fc06                	sd	ra,56(sp)
    1358:	f822                	sd	s0,48(sp)
    135a:	f426                	sd	s1,40(sp)
    135c:	f04a                	sd	s2,32(sp)
    135e:	ec4e                	sd	s3,24(sp)
    1360:	0080                	addi	s0,sp,64
    1362:	64b1                	lui	s1,0xc
    1364:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1de8>
    argv[0] = (char*)0xffffffff;
    1368:	597d                	li	s2,-1
    136a:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    136e:	00005997          	auipc	s3,0x5
    1372:	e0a98993          	addi	s3,s3,-502 # 6178 <malloc+0x144>
    argv[0] = (char*)0xffffffff;
    1376:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    137a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    137e:	fc040593          	addi	a1,s0,-64
    1382:	854e                	mv	a0,s3
    1384:	00005097          	auipc	ra,0x5
    1388:	8b2080e7          	jalr	-1870(ra) # 5c36 <exec>
  for(int i = 0; i < 50000; i++){
    138c:	34fd                	addiw	s1,s1,-1
    138e:	f4e5                	bnez	s1,1376 <badarg+0x22>
  exit(0);
    1390:	4501                	li	a0,0
    1392:	00005097          	auipc	ra,0x5
    1396:	86c080e7          	jalr	-1940(ra) # 5bfe <exit>

000000000000139a <copyinstr2>:
{
    139a:	7155                	addi	sp,sp,-208
    139c:	e586                	sd	ra,200(sp)
    139e:	e1a2                	sd	s0,192(sp)
    13a0:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    13a2:	f6840793          	addi	a5,s0,-152
    13a6:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    13aa:	07800713          	li	a4,120
    13ae:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    13b2:	0785                	addi	a5,a5,1
    13b4:	fed79de3          	bne	a5,a3,13ae <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    13b8:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    13bc:	f6840513          	addi	a0,s0,-152
    13c0:	00005097          	auipc	ra,0x5
    13c4:	88e080e7          	jalr	-1906(ra) # 5c4e <unlink>
  if(ret != -1){
    13c8:	57fd                	li	a5,-1
    13ca:	0ef51063          	bne	a0,a5,14aa <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    13ce:	20100593          	li	a1,513
    13d2:	f6840513          	addi	a0,s0,-152
    13d6:	00005097          	auipc	ra,0x5
    13da:	868080e7          	jalr	-1944(ra) # 5c3e <open>
  if(fd != -1){
    13de:	57fd                	li	a5,-1
    13e0:	0ef51563          	bne	a0,a5,14ca <copyinstr2+0x130>
  ret = link(b, b);
    13e4:	f6840593          	addi	a1,s0,-152
    13e8:	852e                	mv	a0,a1
    13ea:	00005097          	auipc	ra,0x5
    13ee:	874080e7          	jalr	-1932(ra) # 5c5e <link>
  if(ret != -1){
    13f2:	57fd                	li	a5,-1
    13f4:	0ef51b63          	bne	a0,a5,14ea <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    13f8:	00006797          	auipc	a5,0x6
    13fc:	76078793          	addi	a5,a5,1888 # 7b58 <malloc+0x1b24>
    1400:	f4f43c23          	sd	a5,-168(s0)
    1404:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1408:	f5840593          	addi	a1,s0,-168
    140c:	f6840513          	addi	a0,s0,-152
    1410:	00005097          	auipc	ra,0x5
    1414:	826080e7          	jalr	-2010(ra) # 5c36 <exec>
  if(ret != -1){
    1418:	57fd                	li	a5,-1
    141a:	0ef51963          	bne	a0,a5,150c <copyinstr2+0x172>
  int pid = fork();
    141e:	00004097          	auipc	ra,0x4
    1422:	7d8080e7          	jalr	2008(ra) # 5bf6 <fork>
  if(pid < 0){
    1426:	10054363          	bltz	a0,152c <copyinstr2+0x192>
  if(pid == 0){
    142a:	12051463          	bnez	a0,1552 <copyinstr2+0x1b8>
    142e:	00008797          	auipc	a5,0x8
    1432:	13278793          	addi	a5,a5,306 # 9560 <big.1266>
    1436:	00009697          	auipc	a3,0x9
    143a:	12a68693          	addi	a3,a3,298 # a560 <big.1266+0x1000>
      big[i] = 'x';
    143e:	07800713          	li	a4,120
    1442:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1446:	0785                	addi	a5,a5,1
    1448:	fed79de3          	bne	a5,a3,1442 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    144c:	00009797          	auipc	a5,0x9
    1450:	10078a23          	sb	zero,276(a5) # a560 <big.1266+0x1000>
    char *args2[] = { big, big, big, 0 };
    1454:	00007797          	auipc	a5,0x7
    1458:	12478793          	addi	a5,a5,292 # 8578 <malloc+0x2544>
    145c:	6390                	ld	a2,0(a5)
    145e:	6794                	ld	a3,8(a5)
    1460:	6b98                	ld	a4,16(a5)
    1462:	6f9c                	ld	a5,24(a5)
    1464:	f2c43823          	sd	a2,-208(s0)
    1468:	f2d43c23          	sd	a3,-200(s0)
    146c:	f4e43023          	sd	a4,-192(s0)
    1470:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1474:	f3040593          	addi	a1,s0,-208
    1478:	00005517          	auipc	a0,0x5
    147c:	d0050513          	addi	a0,a0,-768 # 6178 <malloc+0x144>
    1480:	00004097          	auipc	ra,0x4
    1484:	7b6080e7          	jalr	1974(ra) # 5c36 <exec>
    if(ret != -1){
    1488:	57fd                	li	a5,-1
    148a:	0af50e63          	beq	a0,a5,1546 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    148e:	55fd                	li	a1,-1
    1490:	00005517          	auipc	a0,0x5
    1494:	51850513          	addi	a0,a0,1304 # 69a8 <malloc+0x974>
    1498:	00005097          	auipc	ra,0x5
    149c:	ade080e7          	jalr	-1314(ra) # 5f76 <printf>
      exit(1);
    14a0:	4505                	li	a0,1
    14a2:	00004097          	auipc	ra,0x4
    14a6:	75c080e7          	jalr	1884(ra) # 5bfe <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    14aa:	862a                	mv	a2,a0
    14ac:	f6840593          	addi	a1,s0,-152
    14b0:	00005517          	auipc	a0,0x5
    14b4:	47050513          	addi	a0,a0,1136 # 6920 <malloc+0x8ec>
    14b8:	00005097          	auipc	ra,0x5
    14bc:	abe080e7          	jalr	-1346(ra) # 5f76 <printf>
    exit(1);
    14c0:	4505                	li	a0,1
    14c2:	00004097          	auipc	ra,0x4
    14c6:	73c080e7          	jalr	1852(ra) # 5bfe <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    14ca:	862a                	mv	a2,a0
    14cc:	f6840593          	addi	a1,s0,-152
    14d0:	00005517          	auipc	a0,0x5
    14d4:	47050513          	addi	a0,a0,1136 # 6940 <malloc+0x90c>
    14d8:	00005097          	auipc	ra,0x5
    14dc:	a9e080e7          	jalr	-1378(ra) # 5f76 <printf>
    exit(1);
    14e0:	4505                	li	a0,1
    14e2:	00004097          	auipc	ra,0x4
    14e6:	71c080e7          	jalr	1820(ra) # 5bfe <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14ea:	86aa                	mv	a3,a0
    14ec:	f6840613          	addi	a2,s0,-152
    14f0:	85b2                	mv	a1,a2
    14f2:	00005517          	auipc	a0,0x5
    14f6:	46e50513          	addi	a0,a0,1134 # 6960 <malloc+0x92c>
    14fa:	00005097          	auipc	ra,0x5
    14fe:	a7c080e7          	jalr	-1412(ra) # 5f76 <printf>
    exit(1);
    1502:	4505                	li	a0,1
    1504:	00004097          	auipc	ra,0x4
    1508:	6fa080e7          	jalr	1786(ra) # 5bfe <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    150c:	567d                	li	a2,-1
    150e:	f6840593          	addi	a1,s0,-152
    1512:	00005517          	auipc	a0,0x5
    1516:	47650513          	addi	a0,a0,1142 # 6988 <malloc+0x954>
    151a:	00005097          	auipc	ra,0x5
    151e:	a5c080e7          	jalr	-1444(ra) # 5f76 <printf>
    exit(1);
    1522:	4505                	li	a0,1
    1524:	00004097          	auipc	ra,0x4
    1528:	6da080e7          	jalr	1754(ra) # 5bfe <exit>
    printf("fork failed\n");
    152c:	00006517          	auipc	a0,0x6
    1530:	8dc50513          	addi	a0,a0,-1828 # 6e08 <malloc+0xdd4>
    1534:	00005097          	auipc	ra,0x5
    1538:	a42080e7          	jalr	-1470(ra) # 5f76 <printf>
    exit(1);
    153c:	4505                	li	a0,1
    153e:	00004097          	auipc	ra,0x4
    1542:	6c0080e7          	jalr	1728(ra) # 5bfe <exit>
    exit(747); // OK
    1546:	2eb00513          	li	a0,747
    154a:	00004097          	auipc	ra,0x4
    154e:	6b4080e7          	jalr	1716(ra) # 5bfe <exit>
  int st = 0;
    1552:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1556:	f5440513          	addi	a0,s0,-172
    155a:	00004097          	auipc	ra,0x4
    155e:	6ac080e7          	jalr	1708(ra) # 5c06 <wait>
  if(st != 747){
    1562:	f5442703          	lw	a4,-172(s0)
    1566:	2eb00793          	li	a5,747
    156a:	00f71663          	bne	a4,a5,1576 <copyinstr2+0x1dc>
}
    156e:	60ae                	ld	ra,200(sp)
    1570:	640e                	ld	s0,192(sp)
    1572:	6169                	addi	sp,sp,208
    1574:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1576:	00005517          	auipc	a0,0x5
    157a:	45a50513          	addi	a0,a0,1114 # 69d0 <malloc+0x99c>
    157e:	00005097          	auipc	ra,0x5
    1582:	9f8080e7          	jalr	-1544(ra) # 5f76 <printf>
    exit(1);
    1586:	4505                	li	a0,1
    1588:	00004097          	auipc	ra,0x4
    158c:	676080e7          	jalr	1654(ra) # 5bfe <exit>

0000000000001590 <truncate3>:
{
    1590:	7159                	addi	sp,sp,-112
    1592:	f486                	sd	ra,104(sp)
    1594:	f0a2                	sd	s0,96(sp)
    1596:	eca6                	sd	s1,88(sp)
    1598:	e8ca                	sd	s2,80(sp)
    159a:	e4ce                	sd	s3,72(sp)
    159c:	e0d2                	sd	s4,64(sp)
    159e:	fc56                	sd	s5,56(sp)
    15a0:	1880                	addi	s0,sp,112
    15a2:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    15a4:	60100593          	li	a1,1537
    15a8:	00005517          	auipc	a0,0x5
    15ac:	c2850513          	addi	a0,a0,-984 # 61d0 <malloc+0x19c>
    15b0:	00004097          	auipc	ra,0x4
    15b4:	68e080e7          	jalr	1678(ra) # 5c3e <open>
    15b8:	00004097          	auipc	ra,0x4
    15bc:	66e080e7          	jalr	1646(ra) # 5c26 <close>
  pid = fork();
    15c0:	00004097          	auipc	ra,0x4
    15c4:	636080e7          	jalr	1590(ra) # 5bf6 <fork>
  if(pid < 0){
    15c8:	08054063          	bltz	a0,1648 <truncate3+0xb8>
  if(pid == 0){
    15cc:	e969                	bnez	a0,169e <truncate3+0x10e>
    15ce:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    15d2:	00005a17          	auipc	s4,0x5
    15d6:	bfea0a13          	addi	s4,s4,-1026 # 61d0 <malloc+0x19c>
      int n = write(fd, "1234567890", 10);
    15da:	00005a97          	auipc	s5,0x5
    15de:	456a8a93          	addi	s5,s5,1110 # 6a30 <malloc+0x9fc>
      int fd = open("truncfile", O_WRONLY);
    15e2:	4585                	li	a1,1
    15e4:	8552                	mv	a0,s4
    15e6:	00004097          	auipc	ra,0x4
    15ea:	658080e7          	jalr	1624(ra) # 5c3e <open>
    15ee:	84aa                	mv	s1,a0
      if(fd < 0){
    15f0:	06054a63          	bltz	a0,1664 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    15f4:	4629                	li	a2,10
    15f6:	85d6                	mv	a1,s5
    15f8:	00004097          	auipc	ra,0x4
    15fc:	626080e7          	jalr	1574(ra) # 5c1e <write>
      if(n != 10){
    1600:	47a9                	li	a5,10
    1602:	06f51f63          	bne	a0,a5,1680 <truncate3+0xf0>
      close(fd);
    1606:	8526                	mv	a0,s1
    1608:	00004097          	auipc	ra,0x4
    160c:	61e080e7          	jalr	1566(ra) # 5c26 <close>
      fd = open("truncfile", O_RDONLY);
    1610:	4581                	li	a1,0
    1612:	8552                	mv	a0,s4
    1614:	00004097          	auipc	ra,0x4
    1618:	62a080e7          	jalr	1578(ra) # 5c3e <open>
    161c:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    161e:	02000613          	li	a2,32
    1622:	f9840593          	addi	a1,s0,-104
    1626:	00004097          	auipc	ra,0x4
    162a:	5f0080e7          	jalr	1520(ra) # 5c16 <read>
      close(fd);
    162e:	8526                	mv	a0,s1
    1630:	00004097          	auipc	ra,0x4
    1634:	5f6080e7          	jalr	1526(ra) # 5c26 <close>
    for(int i = 0; i < 100; i++){
    1638:	39fd                	addiw	s3,s3,-1
    163a:	fa0994e3          	bnez	s3,15e2 <truncate3+0x52>
    exit(0);
    163e:	4501                	li	a0,0
    1640:	00004097          	auipc	ra,0x4
    1644:	5be080e7          	jalr	1470(ra) # 5bfe <exit>
    printf("%s: fork failed\n", s);
    1648:	85ca                	mv	a1,s2
    164a:	00005517          	auipc	a0,0x5
    164e:	3b650513          	addi	a0,a0,950 # 6a00 <malloc+0x9cc>
    1652:	00005097          	auipc	ra,0x5
    1656:	924080e7          	jalr	-1756(ra) # 5f76 <printf>
    exit(1);
    165a:	4505                	li	a0,1
    165c:	00004097          	auipc	ra,0x4
    1660:	5a2080e7          	jalr	1442(ra) # 5bfe <exit>
        printf("%s: open failed\n", s);
    1664:	85ca                	mv	a1,s2
    1666:	00005517          	auipc	a0,0x5
    166a:	3b250513          	addi	a0,a0,946 # 6a18 <malloc+0x9e4>
    166e:	00005097          	auipc	ra,0x5
    1672:	908080e7          	jalr	-1784(ra) # 5f76 <printf>
        exit(1);
    1676:	4505                	li	a0,1
    1678:	00004097          	auipc	ra,0x4
    167c:	586080e7          	jalr	1414(ra) # 5bfe <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1680:	862a                	mv	a2,a0
    1682:	85ca                	mv	a1,s2
    1684:	00005517          	auipc	a0,0x5
    1688:	3bc50513          	addi	a0,a0,956 # 6a40 <malloc+0xa0c>
    168c:	00005097          	auipc	ra,0x5
    1690:	8ea080e7          	jalr	-1814(ra) # 5f76 <printf>
        exit(1);
    1694:	4505                	li	a0,1
    1696:	00004097          	auipc	ra,0x4
    169a:	568080e7          	jalr	1384(ra) # 5bfe <exit>
    169e:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16a2:	00005a17          	auipc	s4,0x5
    16a6:	b2ea0a13          	addi	s4,s4,-1234 # 61d0 <malloc+0x19c>
    int n = write(fd, "xxx", 3);
    16aa:	00005a97          	auipc	s5,0x5
    16ae:	3b6a8a93          	addi	s5,s5,950 # 6a60 <malloc+0xa2c>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16b2:	60100593          	li	a1,1537
    16b6:	8552                	mv	a0,s4
    16b8:	00004097          	auipc	ra,0x4
    16bc:	586080e7          	jalr	1414(ra) # 5c3e <open>
    16c0:	84aa                	mv	s1,a0
    if(fd < 0){
    16c2:	04054763          	bltz	a0,1710 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    16c6:	460d                	li	a2,3
    16c8:	85d6                	mv	a1,s5
    16ca:	00004097          	auipc	ra,0x4
    16ce:	554080e7          	jalr	1364(ra) # 5c1e <write>
    if(n != 3){
    16d2:	478d                	li	a5,3
    16d4:	04f51c63          	bne	a0,a5,172c <truncate3+0x19c>
    close(fd);
    16d8:	8526                	mv	a0,s1
    16da:	00004097          	auipc	ra,0x4
    16de:	54c080e7          	jalr	1356(ra) # 5c26 <close>
  for(int i = 0; i < 150; i++){
    16e2:	39fd                	addiw	s3,s3,-1
    16e4:	fc0997e3          	bnez	s3,16b2 <truncate3+0x122>
  wait(&xstatus);
    16e8:	fbc40513          	addi	a0,s0,-68
    16ec:	00004097          	auipc	ra,0x4
    16f0:	51a080e7          	jalr	1306(ra) # 5c06 <wait>
  unlink("truncfile");
    16f4:	00005517          	auipc	a0,0x5
    16f8:	adc50513          	addi	a0,a0,-1316 # 61d0 <malloc+0x19c>
    16fc:	00004097          	auipc	ra,0x4
    1700:	552080e7          	jalr	1362(ra) # 5c4e <unlink>
  exit(xstatus);
    1704:	fbc42503          	lw	a0,-68(s0)
    1708:	00004097          	auipc	ra,0x4
    170c:	4f6080e7          	jalr	1270(ra) # 5bfe <exit>
      printf("%s: open failed\n", s);
    1710:	85ca                	mv	a1,s2
    1712:	00005517          	auipc	a0,0x5
    1716:	30650513          	addi	a0,a0,774 # 6a18 <malloc+0x9e4>
    171a:	00005097          	auipc	ra,0x5
    171e:	85c080e7          	jalr	-1956(ra) # 5f76 <printf>
      exit(1);
    1722:	4505                	li	a0,1
    1724:	00004097          	auipc	ra,0x4
    1728:	4da080e7          	jalr	1242(ra) # 5bfe <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    172c:	862a                	mv	a2,a0
    172e:	85ca                	mv	a1,s2
    1730:	00005517          	auipc	a0,0x5
    1734:	33850513          	addi	a0,a0,824 # 6a68 <malloc+0xa34>
    1738:	00005097          	auipc	ra,0x5
    173c:	83e080e7          	jalr	-1986(ra) # 5f76 <printf>
      exit(1);
    1740:	4505                	li	a0,1
    1742:	00004097          	auipc	ra,0x4
    1746:	4bc080e7          	jalr	1212(ra) # 5bfe <exit>

000000000000174a <exectest>:
{
    174a:	715d                	addi	sp,sp,-80
    174c:	e486                	sd	ra,72(sp)
    174e:	e0a2                	sd	s0,64(sp)
    1750:	fc26                	sd	s1,56(sp)
    1752:	f84a                	sd	s2,48(sp)
    1754:	0880                	addi	s0,sp,80
    1756:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1758:	00005797          	auipc	a5,0x5
    175c:	a2078793          	addi	a5,a5,-1504 # 6178 <malloc+0x144>
    1760:	fcf43023          	sd	a5,-64(s0)
    1764:	00005797          	auipc	a5,0x5
    1768:	32478793          	addi	a5,a5,804 # 6a88 <malloc+0xa54>
    176c:	fcf43423          	sd	a5,-56(s0)
    1770:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1774:	00005517          	auipc	a0,0x5
    1778:	31c50513          	addi	a0,a0,796 # 6a90 <malloc+0xa5c>
    177c:	00004097          	auipc	ra,0x4
    1780:	4d2080e7          	jalr	1234(ra) # 5c4e <unlink>
  pid = fork();
    1784:	00004097          	auipc	ra,0x4
    1788:	472080e7          	jalr	1138(ra) # 5bf6 <fork>
  if(pid < 0) {
    178c:	04054663          	bltz	a0,17d8 <exectest+0x8e>
    1790:	84aa                	mv	s1,a0
  if(pid == 0) {
    1792:	e959                	bnez	a0,1828 <exectest+0xde>
    close(1);
    1794:	4505                	li	a0,1
    1796:	00004097          	auipc	ra,0x4
    179a:	490080e7          	jalr	1168(ra) # 5c26 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    179e:	20100593          	li	a1,513
    17a2:	00005517          	auipc	a0,0x5
    17a6:	2ee50513          	addi	a0,a0,750 # 6a90 <malloc+0xa5c>
    17aa:	00004097          	auipc	ra,0x4
    17ae:	494080e7          	jalr	1172(ra) # 5c3e <open>
    if(fd < 0) {
    17b2:	04054163          	bltz	a0,17f4 <exectest+0xaa>
    if(fd != 1) {
    17b6:	4785                	li	a5,1
    17b8:	04f50c63          	beq	a0,a5,1810 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    17bc:	85ca                	mv	a1,s2
    17be:	00005517          	auipc	a0,0x5
    17c2:	2f250513          	addi	a0,a0,754 # 6ab0 <malloc+0xa7c>
    17c6:	00004097          	auipc	ra,0x4
    17ca:	7b0080e7          	jalr	1968(ra) # 5f76 <printf>
      exit(1);
    17ce:	4505                	li	a0,1
    17d0:	00004097          	auipc	ra,0x4
    17d4:	42e080e7          	jalr	1070(ra) # 5bfe <exit>
     printf("%s: fork failed\n", s);
    17d8:	85ca                	mv	a1,s2
    17da:	00005517          	auipc	a0,0x5
    17de:	22650513          	addi	a0,a0,550 # 6a00 <malloc+0x9cc>
    17e2:	00004097          	auipc	ra,0x4
    17e6:	794080e7          	jalr	1940(ra) # 5f76 <printf>
     exit(1);
    17ea:	4505                	li	a0,1
    17ec:	00004097          	auipc	ra,0x4
    17f0:	412080e7          	jalr	1042(ra) # 5bfe <exit>
      printf("%s: create failed\n", s);
    17f4:	85ca                	mv	a1,s2
    17f6:	00005517          	auipc	a0,0x5
    17fa:	2a250513          	addi	a0,a0,674 # 6a98 <malloc+0xa64>
    17fe:	00004097          	auipc	ra,0x4
    1802:	778080e7          	jalr	1912(ra) # 5f76 <printf>
      exit(1);
    1806:	4505                	li	a0,1
    1808:	00004097          	auipc	ra,0x4
    180c:	3f6080e7          	jalr	1014(ra) # 5bfe <exit>
    if(exec("echo", echoargv) < 0){
    1810:	fc040593          	addi	a1,s0,-64
    1814:	00005517          	auipc	a0,0x5
    1818:	96450513          	addi	a0,a0,-1692 # 6178 <malloc+0x144>
    181c:	00004097          	auipc	ra,0x4
    1820:	41a080e7          	jalr	1050(ra) # 5c36 <exec>
    1824:	02054163          	bltz	a0,1846 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1828:	fdc40513          	addi	a0,s0,-36
    182c:	00004097          	auipc	ra,0x4
    1830:	3da080e7          	jalr	986(ra) # 5c06 <wait>
    1834:	02951763          	bne	a0,s1,1862 <exectest+0x118>
  if(xstatus != 0)
    1838:	fdc42503          	lw	a0,-36(s0)
    183c:	cd0d                	beqz	a0,1876 <exectest+0x12c>
    exit(xstatus);
    183e:	00004097          	auipc	ra,0x4
    1842:	3c0080e7          	jalr	960(ra) # 5bfe <exit>
      printf("%s: exec echo failed\n", s);
    1846:	85ca                	mv	a1,s2
    1848:	00005517          	auipc	a0,0x5
    184c:	27850513          	addi	a0,a0,632 # 6ac0 <malloc+0xa8c>
    1850:	00004097          	auipc	ra,0x4
    1854:	726080e7          	jalr	1830(ra) # 5f76 <printf>
      exit(1);
    1858:	4505                	li	a0,1
    185a:	00004097          	auipc	ra,0x4
    185e:	3a4080e7          	jalr	932(ra) # 5bfe <exit>
    printf("%s: wait failed!\n", s);
    1862:	85ca                	mv	a1,s2
    1864:	00005517          	auipc	a0,0x5
    1868:	27450513          	addi	a0,a0,628 # 6ad8 <malloc+0xaa4>
    186c:	00004097          	auipc	ra,0x4
    1870:	70a080e7          	jalr	1802(ra) # 5f76 <printf>
    1874:	b7d1                	j	1838 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    1876:	4581                	li	a1,0
    1878:	00005517          	auipc	a0,0x5
    187c:	21850513          	addi	a0,a0,536 # 6a90 <malloc+0xa5c>
    1880:	00004097          	auipc	ra,0x4
    1884:	3be080e7          	jalr	958(ra) # 5c3e <open>
  if(fd < 0) {
    1888:	02054a63          	bltz	a0,18bc <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    188c:	4609                	li	a2,2
    188e:	fb840593          	addi	a1,s0,-72
    1892:	00004097          	auipc	ra,0x4
    1896:	384080e7          	jalr	900(ra) # 5c16 <read>
    189a:	4789                	li	a5,2
    189c:	02f50e63          	beq	a0,a5,18d8 <exectest+0x18e>
    printf("%s: read failed\n", s);
    18a0:	85ca                	mv	a1,s2
    18a2:	00005517          	auipc	a0,0x5
    18a6:	ca650513          	addi	a0,a0,-858 # 6548 <malloc+0x514>
    18aa:	00004097          	auipc	ra,0x4
    18ae:	6cc080e7          	jalr	1740(ra) # 5f76 <printf>
    exit(1);
    18b2:	4505                	li	a0,1
    18b4:	00004097          	auipc	ra,0x4
    18b8:	34a080e7          	jalr	842(ra) # 5bfe <exit>
    printf("%s: open failed\n", s);
    18bc:	85ca                	mv	a1,s2
    18be:	00005517          	auipc	a0,0x5
    18c2:	15a50513          	addi	a0,a0,346 # 6a18 <malloc+0x9e4>
    18c6:	00004097          	auipc	ra,0x4
    18ca:	6b0080e7          	jalr	1712(ra) # 5f76 <printf>
    exit(1);
    18ce:	4505                	li	a0,1
    18d0:	00004097          	auipc	ra,0x4
    18d4:	32e080e7          	jalr	814(ra) # 5bfe <exit>
  unlink("echo-ok");
    18d8:	00005517          	auipc	a0,0x5
    18dc:	1b850513          	addi	a0,a0,440 # 6a90 <malloc+0xa5c>
    18e0:	00004097          	auipc	ra,0x4
    18e4:	36e080e7          	jalr	878(ra) # 5c4e <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    18e8:	fb844703          	lbu	a4,-72(s0)
    18ec:	04f00793          	li	a5,79
    18f0:	00f71863          	bne	a4,a5,1900 <exectest+0x1b6>
    18f4:	fb944703          	lbu	a4,-71(s0)
    18f8:	04b00793          	li	a5,75
    18fc:	02f70063          	beq	a4,a5,191c <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1900:	85ca                	mv	a1,s2
    1902:	00005517          	auipc	a0,0x5
    1906:	1ee50513          	addi	a0,a0,494 # 6af0 <malloc+0xabc>
    190a:	00004097          	auipc	ra,0x4
    190e:	66c080e7          	jalr	1644(ra) # 5f76 <printf>
    exit(1);
    1912:	4505                	li	a0,1
    1914:	00004097          	auipc	ra,0x4
    1918:	2ea080e7          	jalr	746(ra) # 5bfe <exit>
    exit(0);
    191c:	4501                	li	a0,0
    191e:	00004097          	auipc	ra,0x4
    1922:	2e0080e7          	jalr	736(ra) # 5bfe <exit>

0000000000001926 <pipe1>:
{
    1926:	711d                	addi	sp,sp,-96
    1928:	ec86                	sd	ra,88(sp)
    192a:	e8a2                	sd	s0,80(sp)
    192c:	e4a6                	sd	s1,72(sp)
    192e:	e0ca                	sd	s2,64(sp)
    1930:	fc4e                	sd	s3,56(sp)
    1932:	f852                	sd	s4,48(sp)
    1934:	f456                	sd	s5,40(sp)
    1936:	f05a                	sd	s6,32(sp)
    1938:	ec5e                	sd	s7,24(sp)
    193a:	1080                	addi	s0,sp,96
    193c:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    193e:	fa840513          	addi	a0,s0,-88
    1942:	00004097          	auipc	ra,0x4
    1946:	2cc080e7          	jalr	716(ra) # 5c0e <pipe>
    194a:	ed25                	bnez	a0,19c2 <pipe1+0x9c>
    194c:	84aa                	mv	s1,a0
  pid = fork();
    194e:	00004097          	auipc	ra,0x4
    1952:	2a8080e7          	jalr	680(ra) # 5bf6 <fork>
    1956:	8a2a                	mv	s4,a0
  if(pid == 0){
    1958:	c159                	beqz	a0,19de <pipe1+0xb8>
  } else if(pid > 0){
    195a:	16a05e63          	blez	a0,1ad6 <pipe1+0x1b0>
    close(fds[1]);
    195e:	fac42503          	lw	a0,-84(s0)
    1962:	00004097          	auipc	ra,0x4
    1966:	2c4080e7          	jalr	708(ra) # 5c26 <close>
    total = 0;
    196a:	8a26                	mv	s4,s1
    cc = 1;
    196c:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    196e:	0000ba97          	auipc	s5,0xb
    1972:	30aa8a93          	addi	s5,s5,778 # cc78 <buf>
      if(cc > sizeof(buf))
    1976:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1978:	864e                	mv	a2,s3
    197a:	85d6                	mv	a1,s5
    197c:	fa842503          	lw	a0,-88(s0)
    1980:	00004097          	auipc	ra,0x4
    1984:	296080e7          	jalr	662(ra) # 5c16 <read>
    1988:	10a05263          	blez	a0,1a8c <pipe1+0x166>
      for(i = 0; i < n; i++){
    198c:	0000b717          	auipc	a4,0xb
    1990:	2ec70713          	addi	a4,a4,748 # cc78 <buf>
    1994:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1998:	00074683          	lbu	a3,0(a4)
    199c:	0ff4f793          	andi	a5,s1,255
    19a0:	2485                	addiw	s1,s1,1
    19a2:	0cf69163          	bne	a3,a5,1a64 <pipe1+0x13e>
      for(i = 0; i < n; i++){
    19a6:	0705                	addi	a4,a4,1
    19a8:	fec498e3          	bne	s1,a2,1998 <pipe1+0x72>
      total += n;
    19ac:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    19b0:	0019979b          	slliw	a5,s3,0x1
    19b4:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    19b8:	013b7363          	bgeu	s6,s3,19be <pipe1+0x98>
        cc = sizeof(buf);
    19bc:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    19be:	84b2                	mv	s1,a2
    19c0:	bf65                	j	1978 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    19c2:	85ca                	mv	a1,s2
    19c4:	00005517          	auipc	a0,0x5
    19c8:	14450513          	addi	a0,a0,324 # 6b08 <malloc+0xad4>
    19cc:	00004097          	auipc	ra,0x4
    19d0:	5aa080e7          	jalr	1450(ra) # 5f76 <printf>
    exit(1);
    19d4:	4505                	li	a0,1
    19d6:	00004097          	auipc	ra,0x4
    19da:	228080e7          	jalr	552(ra) # 5bfe <exit>
    close(fds[0]);
    19de:	fa842503          	lw	a0,-88(s0)
    19e2:	00004097          	auipc	ra,0x4
    19e6:	244080e7          	jalr	580(ra) # 5c26 <close>
    for(n = 0; n < N; n++){
    19ea:	0000bb17          	auipc	s6,0xb
    19ee:	28eb0b13          	addi	s6,s6,654 # cc78 <buf>
    19f2:	416004bb          	negw	s1,s6
    19f6:	0ff4f493          	andi	s1,s1,255
    19fa:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    19fe:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1a00:	6a85                	lui	s5,0x1
    1a02:	42da8a93          	addi	s5,s5,1069 # 142d <copyinstr2+0x93>
{
    1a06:	87da                	mv	a5,s6
        buf[i] = seq++;
    1a08:	0097873b          	addw	a4,a5,s1
    1a0c:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1a10:	0785                	addi	a5,a5,1
    1a12:	fef99be3          	bne	s3,a5,1a08 <pipe1+0xe2>
    1a16:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a1a:	40900613          	li	a2,1033
    1a1e:	85de                	mv	a1,s7
    1a20:	fac42503          	lw	a0,-84(s0)
    1a24:	00004097          	auipc	ra,0x4
    1a28:	1fa080e7          	jalr	506(ra) # 5c1e <write>
    1a2c:	40900793          	li	a5,1033
    1a30:	00f51c63          	bne	a0,a5,1a48 <pipe1+0x122>
    for(n = 0; n < N; n++){
    1a34:	24a5                	addiw	s1,s1,9
    1a36:	0ff4f493          	andi	s1,s1,255
    1a3a:	fd5a16e3          	bne	s4,s5,1a06 <pipe1+0xe0>
    exit(0);
    1a3e:	4501                	li	a0,0
    1a40:	00004097          	auipc	ra,0x4
    1a44:	1be080e7          	jalr	446(ra) # 5bfe <exit>
        printf("%s: pipe1 oops 1\n", s);
    1a48:	85ca                	mv	a1,s2
    1a4a:	00005517          	auipc	a0,0x5
    1a4e:	0d650513          	addi	a0,a0,214 # 6b20 <malloc+0xaec>
    1a52:	00004097          	auipc	ra,0x4
    1a56:	524080e7          	jalr	1316(ra) # 5f76 <printf>
        exit(1);
    1a5a:	4505                	li	a0,1
    1a5c:	00004097          	auipc	ra,0x4
    1a60:	1a2080e7          	jalr	418(ra) # 5bfe <exit>
          printf("%s: pipe1 oops 2\n", s);
    1a64:	85ca                	mv	a1,s2
    1a66:	00005517          	auipc	a0,0x5
    1a6a:	0d250513          	addi	a0,a0,210 # 6b38 <malloc+0xb04>
    1a6e:	00004097          	auipc	ra,0x4
    1a72:	508080e7          	jalr	1288(ra) # 5f76 <printf>
}
    1a76:	60e6                	ld	ra,88(sp)
    1a78:	6446                	ld	s0,80(sp)
    1a7a:	64a6                	ld	s1,72(sp)
    1a7c:	6906                	ld	s2,64(sp)
    1a7e:	79e2                	ld	s3,56(sp)
    1a80:	7a42                	ld	s4,48(sp)
    1a82:	7aa2                	ld	s5,40(sp)
    1a84:	7b02                	ld	s6,32(sp)
    1a86:	6be2                	ld	s7,24(sp)
    1a88:	6125                	addi	sp,sp,96
    1a8a:	8082                	ret
    if(total != N * SZ){
    1a8c:	6785                	lui	a5,0x1
    1a8e:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr2+0x93>
    1a92:	02fa0063          	beq	s4,a5,1ab2 <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1a96:	85d2                	mv	a1,s4
    1a98:	00005517          	auipc	a0,0x5
    1a9c:	0b850513          	addi	a0,a0,184 # 6b50 <malloc+0xb1c>
    1aa0:	00004097          	auipc	ra,0x4
    1aa4:	4d6080e7          	jalr	1238(ra) # 5f76 <printf>
      exit(1);
    1aa8:	4505                	li	a0,1
    1aaa:	00004097          	auipc	ra,0x4
    1aae:	154080e7          	jalr	340(ra) # 5bfe <exit>
    close(fds[0]);
    1ab2:	fa842503          	lw	a0,-88(s0)
    1ab6:	00004097          	auipc	ra,0x4
    1aba:	170080e7          	jalr	368(ra) # 5c26 <close>
    wait(&xstatus);
    1abe:	fa440513          	addi	a0,s0,-92
    1ac2:	00004097          	auipc	ra,0x4
    1ac6:	144080e7          	jalr	324(ra) # 5c06 <wait>
    exit(xstatus);
    1aca:	fa442503          	lw	a0,-92(s0)
    1ace:	00004097          	auipc	ra,0x4
    1ad2:	130080e7          	jalr	304(ra) # 5bfe <exit>
    printf("%s: fork() failed\n", s);
    1ad6:	85ca                	mv	a1,s2
    1ad8:	00005517          	auipc	a0,0x5
    1adc:	09850513          	addi	a0,a0,152 # 6b70 <malloc+0xb3c>
    1ae0:	00004097          	auipc	ra,0x4
    1ae4:	496080e7          	jalr	1174(ra) # 5f76 <printf>
    exit(1);
    1ae8:	4505                	li	a0,1
    1aea:	00004097          	auipc	ra,0x4
    1aee:	114080e7          	jalr	276(ra) # 5bfe <exit>

0000000000001af2 <exitwait>:
{
    1af2:	7139                	addi	sp,sp,-64
    1af4:	fc06                	sd	ra,56(sp)
    1af6:	f822                	sd	s0,48(sp)
    1af8:	f426                	sd	s1,40(sp)
    1afa:	f04a                	sd	s2,32(sp)
    1afc:	ec4e                	sd	s3,24(sp)
    1afe:	e852                	sd	s4,16(sp)
    1b00:	0080                	addi	s0,sp,64
    1b02:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1b04:	4901                	li	s2,0
    1b06:	06400993          	li	s3,100
    pid = fork();
    1b0a:	00004097          	auipc	ra,0x4
    1b0e:	0ec080e7          	jalr	236(ra) # 5bf6 <fork>
    1b12:	84aa                	mv	s1,a0
    if(pid < 0){
    1b14:	02054a63          	bltz	a0,1b48 <exitwait+0x56>
    if(pid){
    1b18:	c151                	beqz	a0,1b9c <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1b1a:	fcc40513          	addi	a0,s0,-52
    1b1e:	00004097          	auipc	ra,0x4
    1b22:	0e8080e7          	jalr	232(ra) # 5c06 <wait>
    1b26:	02951f63          	bne	a0,s1,1b64 <exitwait+0x72>
      if(i != xstate) {
    1b2a:	fcc42783          	lw	a5,-52(s0)
    1b2e:	05279963          	bne	a5,s2,1b80 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1b32:	2905                	addiw	s2,s2,1
    1b34:	fd391be3          	bne	s2,s3,1b0a <exitwait+0x18>
}
    1b38:	70e2                	ld	ra,56(sp)
    1b3a:	7442                	ld	s0,48(sp)
    1b3c:	74a2                	ld	s1,40(sp)
    1b3e:	7902                	ld	s2,32(sp)
    1b40:	69e2                	ld	s3,24(sp)
    1b42:	6a42                	ld	s4,16(sp)
    1b44:	6121                	addi	sp,sp,64
    1b46:	8082                	ret
      printf("%s: fork failed\n", s);
    1b48:	85d2                	mv	a1,s4
    1b4a:	00005517          	auipc	a0,0x5
    1b4e:	eb650513          	addi	a0,a0,-330 # 6a00 <malloc+0x9cc>
    1b52:	00004097          	auipc	ra,0x4
    1b56:	424080e7          	jalr	1060(ra) # 5f76 <printf>
      exit(1);
    1b5a:	4505                	li	a0,1
    1b5c:	00004097          	auipc	ra,0x4
    1b60:	0a2080e7          	jalr	162(ra) # 5bfe <exit>
        printf("%s: wait wrong pid\n", s);
    1b64:	85d2                	mv	a1,s4
    1b66:	00005517          	auipc	a0,0x5
    1b6a:	02250513          	addi	a0,a0,34 # 6b88 <malloc+0xb54>
    1b6e:	00004097          	auipc	ra,0x4
    1b72:	408080e7          	jalr	1032(ra) # 5f76 <printf>
        exit(1);
    1b76:	4505                	li	a0,1
    1b78:	00004097          	auipc	ra,0x4
    1b7c:	086080e7          	jalr	134(ra) # 5bfe <exit>
        printf("%s: wait wrong exit status\n", s);
    1b80:	85d2                	mv	a1,s4
    1b82:	00005517          	auipc	a0,0x5
    1b86:	01e50513          	addi	a0,a0,30 # 6ba0 <malloc+0xb6c>
    1b8a:	00004097          	auipc	ra,0x4
    1b8e:	3ec080e7          	jalr	1004(ra) # 5f76 <printf>
        exit(1);
    1b92:	4505                	li	a0,1
    1b94:	00004097          	auipc	ra,0x4
    1b98:	06a080e7          	jalr	106(ra) # 5bfe <exit>
      exit(i);
    1b9c:	854a                	mv	a0,s2
    1b9e:	00004097          	auipc	ra,0x4
    1ba2:	060080e7          	jalr	96(ra) # 5bfe <exit>

0000000000001ba6 <twochildren>:
{
    1ba6:	1101                	addi	sp,sp,-32
    1ba8:	ec06                	sd	ra,24(sp)
    1baa:	e822                	sd	s0,16(sp)
    1bac:	e426                	sd	s1,8(sp)
    1bae:	e04a                	sd	s2,0(sp)
    1bb0:	1000                	addi	s0,sp,32
    1bb2:	892a                	mv	s2,a0
    1bb4:	3e800493          	li	s1,1000
    int pid1 = fork();
    1bb8:	00004097          	auipc	ra,0x4
    1bbc:	03e080e7          	jalr	62(ra) # 5bf6 <fork>
    if(pid1 < 0){
    1bc0:	02054c63          	bltz	a0,1bf8 <twochildren+0x52>
    if(pid1 == 0){
    1bc4:	c921                	beqz	a0,1c14 <twochildren+0x6e>
      int pid2 = fork();
    1bc6:	00004097          	auipc	ra,0x4
    1bca:	030080e7          	jalr	48(ra) # 5bf6 <fork>
      if(pid2 < 0){
    1bce:	04054763          	bltz	a0,1c1c <twochildren+0x76>
      if(pid2 == 0){
    1bd2:	c13d                	beqz	a0,1c38 <twochildren+0x92>
        wait(0);
    1bd4:	4501                	li	a0,0
    1bd6:	00004097          	auipc	ra,0x4
    1bda:	030080e7          	jalr	48(ra) # 5c06 <wait>
        wait(0);
    1bde:	4501                	li	a0,0
    1be0:	00004097          	auipc	ra,0x4
    1be4:	026080e7          	jalr	38(ra) # 5c06 <wait>
  for(int i = 0; i < 1000; i++){
    1be8:	34fd                	addiw	s1,s1,-1
    1bea:	f4f9                	bnez	s1,1bb8 <twochildren+0x12>
}
    1bec:	60e2                	ld	ra,24(sp)
    1bee:	6442                	ld	s0,16(sp)
    1bf0:	64a2                	ld	s1,8(sp)
    1bf2:	6902                	ld	s2,0(sp)
    1bf4:	6105                	addi	sp,sp,32
    1bf6:	8082                	ret
      printf("%s: fork failed\n", s);
    1bf8:	85ca                	mv	a1,s2
    1bfa:	00005517          	auipc	a0,0x5
    1bfe:	e0650513          	addi	a0,a0,-506 # 6a00 <malloc+0x9cc>
    1c02:	00004097          	auipc	ra,0x4
    1c06:	374080e7          	jalr	884(ra) # 5f76 <printf>
      exit(1);
    1c0a:	4505                	li	a0,1
    1c0c:	00004097          	auipc	ra,0x4
    1c10:	ff2080e7          	jalr	-14(ra) # 5bfe <exit>
      exit(0);
    1c14:	00004097          	auipc	ra,0x4
    1c18:	fea080e7          	jalr	-22(ra) # 5bfe <exit>
        printf("%s: fork failed\n", s);
    1c1c:	85ca                	mv	a1,s2
    1c1e:	00005517          	auipc	a0,0x5
    1c22:	de250513          	addi	a0,a0,-542 # 6a00 <malloc+0x9cc>
    1c26:	00004097          	auipc	ra,0x4
    1c2a:	350080e7          	jalr	848(ra) # 5f76 <printf>
        exit(1);
    1c2e:	4505                	li	a0,1
    1c30:	00004097          	auipc	ra,0x4
    1c34:	fce080e7          	jalr	-50(ra) # 5bfe <exit>
        exit(0);
    1c38:	00004097          	auipc	ra,0x4
    1c3c:	fc6080e7          	jalr	-58(ra) # 5bfe <exit>

0000000000001c40 <forkfork>:
{
    1c40:	7179                	addi	sp,sp,-48
    1c42:	f406                	sd	ra,40(sp)
    1c44:	f022                	sd	s0,32(sp)
    1c46:	ec26                	sd	s1,24(sp)
    1c48:	1800                	addi	s0,sp,48
    1c4a:	84aa                	mv	s1,a0
    int pid = fork();
    1c4c:	00004097          	auipc	ra,0x4
    1c50:	faa080e7          	jalr	-86(ra) # 5bf6 <fork>
    if(pid < 0){
    1c54:	04054163          	bltz	a0,1c96 <forkfork+0x56>
    if(pid == 0){
    1c58:	cd29                	beqz	a0,1cb2 <forkfork+0x72>
    int pid = fork();
    1c5a:	00004097          	auipc	ra,0x4
    1c5e:	f9c080e7          	jalr	-100(ra) # 5bf6 <fork>
    if(pid < 0){
    1c62:	02054a63          	bltz	a0,1c96 <forkfork+0x56>
    if(pid == 0){
    1c66:	c531                	beqz	a0,1cb2 <forkfork+0x72>
    wait(&xstatus);
    1c68:	fdc40513          	addi	a0,s0,-36
    1c6c:	00004097          	auipc	ra,0x4
    1c70:	f9a080e7          	jalr	-102(ra) # 5c06 <wait>
    if(xstatus != 0) {
    1c74:	fdc42783          	lw	a5,-36(s0)
    1c78:	ebbd                	bnez	a5,1cee <forkfork+0xae>
    wait(&xstatus);
    1c7a:	fdc40513          	addi	a0,s0,-36
    1c7e:	00004097          	auipc	ra,0x4
    1c82:	f88080e7          	jalr	-120(ra) # 5c06 <wait>
    if(xstatus != 0) {
    1c86:	fdc42783          	lw	a5,-36(s0)
    1c8a:	e3b5                	bnez	a5,1cee <forkfork+0xae>
}
    1c8c:	70a2                	ld	ra,40(sp)
    1c8e:	7402                	ld	s0,32(sp)
    1c90:	64e2                	ld	s1,24(sp)
    1c92:	6145                	addi	sp,sp,48
    1c94:	8082                	ret
      printf("%s: fork failed", s);
    1c96:	85a6                	mv	a1,s1
    1c98:	00005517          	auipc	a0,0x5
    1c9c:	f2850513          	addi	a0,a0,-216 # 6bc0 <malloc+0xb8c>
    1ca0:	00004097          	auipc	ra,0x4
    1ca4:	2d6080e7          	jalr	726(ra) # 5f76 <printf>
      exit(1);
    1ca8:	4505                	li	a0,1
    1caa:	00004097          	auipc	ra,0x4
    1cae:	f54080e7          	jalr	-172(ra) # 5bfe <exit>
{
    1cb2:	0c800493          	li	s1,200
        int pid1 = fork();
    1cb6:	00004097          	auipc	ra,0x4
    1cba:	f40080e7          	jalr	-192(ra) # 5bf6 <fork>
        if(pid1 < 0){
    1cbe:	00054f63          	bltz	a0,1cdc <forkfork+0x9c>
        if(pid1 == 0){
    1cc2:	c115                	beqz	a0,1ce6 <forkfork+0xa6>
        wait(0);
    1cc4:	4501                	li	a0,0
    1cc6:	00004097          	auipc	ra,0x4
    1cca:	f40080e7          	jalr	-192(ra) # 5c06 <wait>
      for(int j = 0; j < 200; j++){
    1cce:	34fd                	addiw	s1,s1,-1
    1cd0:	f0fd                	bnez	s1,1cb6 <forkfork+0x76>
      exit(0);
    1cd2:	4501                	li	a0,0
    1cd4:	00004097          	auipc	ra,0x4
    1cd8:	f2a080e7          	jalr	-214(ra) # 5bfe <exit>
          exit(1);
    1cdc:	4505                	li	a0,1
    1cde:	00004097          	auipc	ra,0x4
    1ce2:	f20080e7          	jalr	-224(ra) # 5bfe <exit>
          exit(0);
    1ce6:	00004097          	auipc	ra,0x4
    1cea:	f18080e7          	jalr	-232(ra) # 5bfe <exit>
      printf("%s: fork in child failed", s);
    1cee:	85a6                	mv	a1,s1
    1cf0:	00005517          	auipc	a0,0x5
    1cf4:	ee050513          	addi	a0,a0,-288 # 6bd0 <malloc+0xb9c>
    1cf8:	00004097          	auipc	ra,0x4
    1cfc:	27e080e7          	jalr	638(ra) # 5f76 <printf>
      exit(1);
    1d00:	4505                	li	a0,1
    1d02:	00004097          	auipc	ra,0x4
    1d06:	efc080e7          	jalr	-260(ra) # 5bfe <exit>

0000000000001d0a <reparent2>:
{
    1d0a:	1101                	addi	sp,sp,-32
    1d0c:	ec06                	sd	ra,24(sp)
    1d0e:	e822                	sd	s0,16(sp)
    1d10:	e426                	sd	s1,8(sp)
    1d12:	1000                	addi	s0,sp,32
    1d14:	32000493          	li	s1,800
    int pid1 = fork();
    1d18:	00004097          	auipc	ra,0x4
    1d1c:	ede080e7          	jalr	-290(ra) # 5bf6 <fork>
    if(pid1 < 0){
    1d20:	00054f63          	bltz	a0,1d3e <reparent2+0x34>
    if(pid1 == 0){
    1d24:	c915                	beqz	a0,1d58 <reparent2+0x4e>
    wait(0);
    1d26:	4501                	li	a0,0
    1d28:	00004097          	auipc	ra,0x4
    1d2c:	ede080e7          	jalr	-290(ra) # 5c06 <wait>
  for(int i = 0; i < 800; i++){
    1d30:	34fd                	addiw	s1,s1,-1
    1d32:	f0fd                	bnez	s1,1d18 <reparent2+0xe>
  exit(0);
    1d34:	4501                	li	a0,0
    1d36:	00004097          	auipc	ra,0x4
    1d3a:	ec8080e7          	jalr	-312(ra) # 5bfe <exit>
      printf("fork failed\n");
    1d3e:	00005517          	auipc	a0,0x5
    1d42:	0ca50513          	addi	a0,a0,202 # 6e08 <malloc+0xdd4>
    1d46:	00004097          	auipc	ra,0x4
    1d4a:	230080e7          	jalr	560(ra) # 5f76 <printf>
      exit(1);
    1d4e:	4505                	li	a0,1
    1d50:	00004097          	auipc	ra,0x4
    1d54:	eae080e7          	jalr	-338(ra) # 5bfe <exit>
      fork();
    1d58:	00004097          	auipc	ra,0x4
    1d5c:	e9e080e7          	jalr	-354(ra) # 5bf6 <fork>
      fork();
    1d60:	00004097          	auipc	ra,0x4
    1d64:	e96080e7          	jalr	-362(ra) # 5bf6 <fork>
      exit(0);
    1d68:	4501                	li	a0,0
    1d6a:	00004097          	auipc	ra,0x4
    1d6e:	e94080e7          	jalr	-364(ra) # 5bfe <exit>

0000000000001d72 <createdelete>:
{
    1d72:	7175                	addi	sp,sp,-144
    1d74:	e506                	sd	ra,136(sp)
    1d76:	e122                	sd	s0,128(sp)
    1d78:	fca6                	sd	s1,120(sp)
    1d7a:	f8ca                	sd	s2,112(sp)
    1d7c:	f4ce                	sd	s3,104(sp)
    1d7e:	f0d2                	sd	s4,96(sp)
    1d80:	ecd6                	sd	s5,88(sp)
    1d82:	e8da                	sd	s6,80(sp)
    1d84:	e4de                	sd	s7,72(sp)
    1d86:	e0e2                	sd	s8,64(sp)
    1d88:	fc66                	sd	s9,56(sp)
    1d8a:	0900                	addi	s0,sp,144
    1d8c:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1d8e:	4901                	li	s2,0
    1d90:	4991                	li	s3,4
    pid = fork();
    1d92:	00004097          	auipc	ra,0x4
    1d96:	e64080e7          	jalr	-412(ra) # 5bf6 <fork>
    1d9a:	84aa                	mv	s1,a0
    if(pid < 0){
    1d9c:	02054f63          	bltz	a0,1dda <createdelete+0x68>
    if(pid == 0){
    1da0:	c939                	beqz	a0,1df6 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1da2:	2905                	addiw	s2,s2,1
    1da4:	ff3917e3          	bne	s2,s3,1d92 <createdelete+0x20>
    1da8:	4491                	li	s1,4
    wait(&xstatus);
    1daa:	f7c40513          	addi	a0,s0,-132
    1dae:	00004097          	auipc	ra,0x4
    1db2:	e58080e7          	jalr	-424(ra) # 5c06 <wait>
    if(xstatus != 0)
    1db6:	f7c42903          	lw	s2,-132(s0)
    1dba:	0e091263          	bnez	s2,1e9e <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1dbe:	34fd                	addiw	s1,s1,-1
    1dc0:	f4ed                	bnez	s1,1daa <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1dc2:	f8040123          	sb	zero,-126(s0)
    1dc6:	03000993          	li	s3,48
    1dca:	5a7d                	li	s4,-1
    1dcc:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1dd0:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1dd2:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1dd4:	07400a93          	li	s5,116
    1dd8:	a29d                	j	1f3e <createdelete+0x1cc>
      printf("fork failed\n", s);
    1dda:	85e6                	mv	a1,s9
    1ddc:	00005517          	auipc	a0,0x5
    1de0:	02c50513          	addi	a0,a0,44 # 6e08 <malloc+0xdd4>
    1de4:	00004097          	auipc	ra,0x4
    1de8:	192080e7          	jalr	402(ra) # 5f76 <printf>
      exit(1);
    1dec:	4505                	li	a0,1
    1dee:	00004097          	auipc	ra,0x4
    1df2:	e10080e7          	jalr	-496(ra) # 5bfe <exit>
      name[0] = 'p' + pi;
    1df6:	0709091b          	addiw	s2,s2,112
    1dfa:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1dfe:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1e02:	4951                	li	s2,20
    1e04:	a015                	j	1e28 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1e06:	85e6                	mv	a1,s9
    1e08:	00005517          	auipc	a0,0x5
    1e0c:	c9050513          	addi	a0,a0,-880 # 6a98 <malloc+0xa64>
    1e10:	00004097          	auipc	ra,0x4
    1e14:	166080e7          	jalr	358(ra) # 5f76 <printf>
          exit(1);
    1e18:	4505                	li	a0,1
    1e1a:	00004097          	auipc	ra,0x4
    1e1e:	de4080e7          	jalr	-540(ra) # 5bfe <exit>
      for(i = 0; i < N; i++){
    1e22:	2485                	addiw	s1,s1,1
    1e24:	07248863          	beq	s1,s2,1e94 <createdelete+0x122>
        name[1] = '0' + i;
    1e28:	0304879b          	addiw	a5,s1,48
    1e2c:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1e30:	20200593          	li	a1,514
    1e34:	f8040513          	addi	a0,s0,-128
    1e38:	00004097          	auipc	ra,0x4
    1e3c:	e06080e7          	jalr	-506(ra) # 5c3e <open>
        if(fd < 0){
    1e40:	fc0543e3          	bltz	a0,1e06 <createdelete+0x94>
        close(fd);
    1e44:	00004097          	auipc	ra,0x4
    1e48:	de2080e7          	jalr	-542(ra) # 5c26 <close>
        if(i > 0 && (i % 2 ) == 0){
    1e4c:	fc905be3          	blez	s1,1e22 <createdelete+0xb0>
    1e50:	0014f793          	andi	a5,s1,1
    1e54:	f7f9                	bnez	a5,1e22 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1e56:	01f4d79b          	srliw	a5,s1,0x1f
    1e5a:	9fa5                	addw	a5,a5,s1
    1e5c:	4017d79b          	sraiw	a5,a5,0x1
    1e60:	0307879b          	addiw	a5,a5,48
    1e64:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1e68:	f8040513          	addi	a0,s0,-128
    1e6c:	00004097          	auipc	ra,0x4
    1e70:	de2080e7          	jalr	-542(ra) # 5c4e <unlink>
    1e74:	fa0557e3          	bgez	a0,1e22 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1e78:	85e6                	mv	a1,s9
    1e7a:	00005517          	auipc	a0,0x5
    1e7e:	d7650513          	addi	a0,a0,-650 # 6bf0 <malloc+0xbbc>
    1e82:	00004097          	auipc	ra,0x4
    1e86:	0f4080e7          	jalr	244(ra) # 5f76 <printf>
            exit(1);
    1e8a:	4505                	li	a0,1
    1e8c:	00004097          	auipc	ra,0x4
    1e90:	d72080e7          	jalr	-654(ra) # 5bfe <exit>
      exit(0);
    1e94:	4501                	li	a0,0
    1e96:	00004097          	auipc	ra,0x4
    1e9a:	d68080e7          	jalr	-664(ra) # 5bfe <exit>
      exit(1);
    1e9e:	4505                	li	a0,1
    1ea0:	00004097          	auipc	ra,0x4
    1ea4:	d5e080e7          	jalr	-674(ra) # 5bfe <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1ea8:	f8040613          	addi	a2,s0,-128
    1eac:	85e6                	mv	a1,s9
    1eae:	00005517          	auipc	a0,0x5
    1eb2:	d5a50513          	addi	a0,a0,-678 # 6c08 <malloc+0xbd4>
    1eb6:	00004097          	auipc	ra,0x4
    1eba:	0c0080e7          	jalr	192(ra) # 5f76 <printf>
        exit(1);
    1ebe:	4505                	li	a0,1
    1ec0:	00004097          	auipc	ra,0x4
    1ec4:	d3e080e7          	jalr	-706(ra) # 5bfe <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ec8:	054b7163          	bgeu	s6,s4,1f0a <createdelete+0x198>
      if(fd >= 0)
    1ecc:	02055a63          	bgez	a0,1f00 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1ed0:	2485                	addiw	s1,s1,1
    1ed2:	0ff4f493          	andi	s1,s1,255
    1ed6:	05548c63          	beq	s1,s5,1f2e <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1eda:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1ede:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1ee2:	4581                	li	a1,0
    1ee4:	f8040513          	addi	a0,s0,-128
    1ee8:	00004097          	auipc	ra,0x4
    1eec:	d56080e7          	jalr	-682(ra) # 5c3e <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1ef0:	00090463          	beqz	s2,1ef8 <createdelete+0x186>
    1ef4:	fd2bdae3          	bge	s7,s2,1ec8 <createdelete+0x156>
    1ef8:	fa0548e3          	bltz	a0,1ea8 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1efc:	014b7963          	bgeu	s6,s4,1f0e <createdelete+0x19c>
        close(fd);
    1f00:	00004097          	auipc	ra,0x4
    1f04:	d26080e7          	jalr	-730(ra) # 5c26 <close>
    1f08:	b7e1                	j	1ed0 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f0a:	fc0543e3          	bltz	a0,1ed0 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1f0e:	f8040613          	addi	a2,s0,-128
    1f12:	85e6                	mv	a1,s9
    1f14:	00005517          	auipc	a0,0x5
    1f18:	d1c50513          	addi	a0,a0,-740 # 6c30 <malloc+0xbfc>
    1f1c:	00004097          	auipc	ra,0x4
    1f20:	05a080e7          	jalr	90(ra) # 5f76 <printf>
        exit(1);
    1f24:	4505                	li	a0,1
    1f26:	00004097          	auipc	ra,0x4
    1f2a:	cd8080e7          	jalr	-808(ra) # 5bfe <exit>
  for(i = 0; i < N; i++){
    1f2e:	2905                	addiw	s2,s2,1
    1f30:	2a05                	addiw	s4,s4,1
    1f32:	2985                	addiw	s3,s3,1
    1f34:	0ff9f993          	andi	s3,s3,255
    1f38:	47d1                	li	a5,20
    1f3a:	02f90a63          	beq	s2,a5,1f6e <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1f3e:	84e2                	mv	s1,s8
    1f40:	bf69                	j	1eda <createdelete+0x168>
  for(i = 0; i < N; i++){
    1f42:	2905                	addiw	s2,s2,1
    1f44:	0ff97913          	andi	s2,s2,255
    1f48:	2985                	addiw	s3,s3,1
    1f4a:	0ff9f993          	andi	s3,s3,255
    1f4e:	03490863          	beq	s2,s4,1f7e <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1f52:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1f54:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1f58:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1f5c:	f8040513          	addi	a0,s0,-128
    1f60:	00004097          	auipc	ra,0x4
    1f64:	cee080e7          	jalr	-786(ra) # 5c4e <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1f68:	34fd                	addiw	s1,s1,-1
    1f6a:	f4ed                	bnez	s1,1f54 <createdelete+0x1e2>
    1f6c:	bfd9                	j	1f42 <createdelete+0x1d0>
    1f6e:	03000993          	li	s3,48
    1f72:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1f76:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1f78:	08400a13          	li	s4,132
    1f7c:	bfd9                	j	1f52 <createdelete+0x1e0>
}
    1f7e:	60aa                	ld	ra,136(sp)
    1f80:	640a                	ld	s0,128(sp)
    1f82:	74e6                	ld	s1,120(sp)
    1f84:	7946                	ld	s2,112(sp)
    1f86:	79a6                	ld	s3,104(sp)
    1f88:	7a06                	ld	s4,96(sp)
    1f8a:	6ae6                	ld	s5,88(sp)
    1f8c:	6b46                	ld	s6,80(sp)
    1f8e:	6ba6                	ld	s7,72(sp)
    1f90:	6c06                	ld	s8,64(sp)
    1f92:	7ce2                	ld	s9,56(sp)
    1f94:	6149                	addi	sp,sp,144
    1f96:	8082                	ret

0000000000001f98 <linkunlink>:
{
    1f98:	711d                	addi	sp,sp,-96
    1f9a:	ec86                	sd	ra,88(sp)
    1f9c:	e8a2                	sd	s0,80(sp)
    1f9e:	e4a6                	sd	s1,72(sp)
    1fa0:	e0ca                	sd	s2,64(sp)
    1fa2:	fc4e                	sd	s3,56(sp)
    1fa4:	f852                	sd	s4,48(sp)
    1fa6:	f456                	sd	s5,40(sp)
    1fa8:	f05a                	sd	s6,32(sp)
    1faa:	ec5e                	sd	s7,24(sp)
    1fac:	e862                	sd	s8,16(sp)
    1fae:	e466                	sd	s9,8(sp)
    1fb0:	1080                	addi	s0,sp,96
    1fb2:	84aa                	mv	s1,a0
  unlink("x");
    1fb4:	00004517          	auipc	a0,0x4
    1fb8:	23450513          	addi	a0,a0,564 # 61e8 <malloc+0x1b4>
    1fbc:	00004097          	auipc	ra,0x4
    1fc0:	c92080e7          	jalr	-878(ra) # 5c4e <unlink>
  pid = fork();
    1fc4:	00004097          	auipc	ra,0x4
    1fc8:	c32080e7          	jalr	-974(ra) # 5bf6 <fork>
  if(pid < 0){
    1fcc:	02054b63          	bltz	a0,2002 <linkunlink+0x6a>
    1fd0:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1fd2:	4c85                	li	s9,1
    1fd4:	e119                	bnez	a0,1fda <linkunlink+0x42>
    1fd6:	06100c93          	li	s9,97
    1fda:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1fde:	41c659b7          	lui	s3,0x41c65
    1fe2:	e6d9899b          	addiw	s3,s3,-403
    1fe6:	690d                	lui	s2,0x3
    1fe8:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1fec:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1fee:	4b05                	li	s6,1
      unlink("x");
    1ff0:	00004a97          	auipc	s5,0x4
    1ff4:	1f8a8a93          	addi	s5,s5,504 # 61e8 <malloc+0x1b4>
      link("cat", "x");
    1ff8:	00005b97          	auipc	s7,0x5
    1ffc:	c60b8b93          	addi	s7,s7,-928 # 6c58 <malloc+0xc24>
    2000:	a091                	j	2044 <linkunlink+0xac>
    printf("%s: fork failed\n", s);
    2002:	85a6                	mv	a1,s1
    2004:	00005517          	auipc	a0,0x5
    2008:	9fc50513          	addi	a0,a0,-1540 # 6a00 <malloc+0x9cc>
    200c:	00004097          	auipc	ra,0x4
    2010:	f6a080e7          	jalr	-150(ra) # 5f76 <printf>
    exit(1);
    2014:	4505                	li	a0,1
    2016:	00004097          	auipc	ra,0x4
    201a:	be8080e7          	jalr	-1048(ra) # 5bfe <exit>
      close(open("x", O_RDWR | O_CREATE));
    201e:	20200593          	li	a1,514
    2022:	8556                	mv	a0,s5
    2024:	00004097          	auipc	ra,0x4
    2028:	c1a080e7          	jalr	-998(ra) # 5c3e <open>
    202c:	00004097          	auipc	ra,0x4
    2030:	bfa080e7          	jalr	-1030(ra) # 5c26 <close>
    2034:	a031                	j	2040 <linkunlink+0xa8>
      unlink("x");
    2036:	8556                	mv	a0,s5
    2038:	00004097          	auipc	ra,0x4
    203c:	c16080e7          	jalr	-1002(ra) # 5c4e <unlink>
  for(i = 0; i < 100; i++){
    2040:	34fd                	addiw	s1,s1,-1
    2042:	c09d                	beqz	s1,2068 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    2044:	033c87bb          	mulw	a5,s9,s3
    2048:	012787bb          	addw	a5,a5,s2
    204c:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    2050:	0347f7bb          	remuw	a5,a5,s4
    2054:	d7e9                	beqz	a5,201e <linkunlink+0x86>
    } else if((x % 3) == 1){
    2056:	ff6790e3          	bne	a5,s6,2036 <linkunlink+0x9e>
      link("cat", "x");
    205a:	85d6                	mv	a1,s5
    205c:	855e                	mv	a0,s7
    205e:	00004097          	auipc	ra,0x4
    2062:	c00080e7          	jalr	-1024(ra) # 5c5e <link>
    2066:	bfe9                	j	2040 <linkunlink+0xa8>
  if(pid)
    2068:	020c0463          	beqz	s8,2090 <linkunlink+0xf8>
    wait(0);
    206c:	4501                	li	a0,0
    206e:	00004097          	auipc	ra,0x4
    2072:	b98080e7          	jalr	-1128(ra) # 5c06 <wait>
}
    2076:	60e6                	ld	ra,88(sp)
    2078:	6446                	ld	s0,80(sp)
    207a:	64a6                	ld	s1,72(sp)
    207c:	6906                	ld	s2,64(sp)
    207e:	79e2                	ld	s3,56(sp)
    2080:	7a42                	ld	s4,48(sp)
    2082:	7aa2                	ld	s5,40(sp)
    2084:	7b02                	ld	s6,32(sp)
    2086:	6be2                	ld	s7,24(sp)
    2088:	6c42                	ld	s8,16(sp)
    208a:	6ca2                	ld	s9,8(sp)
    208c:	6125                	addi	sp,sp,96
    208e:	8082                	ret
    exit(0);
    2090:	4501                	li	a0,0
    2092:	00004097          	auipc	ra,0x4
    2096:	b6c080e7          	jalr	-1172(ra) # 5bfe <exit>

000000000000209a <forktest>:
{
    209a:	7179                	addi	sp,sp,-48
    209c:	f406                	sd	ra,40(sp)
    209e:	f022                	sd	s0,32(sp)
    20a0:	ec26                	sd	s1,24(sp)
    20a2:	e84a                	sd	s2,16(sp)
    20a4:	e44e                	sd	s3,8(sp)
    20a6:	1800                	addi	s0,sp,48
    20a8:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    20aa:	4481                	li	s1,0
    20ac:	3e800913          	li	s2,1000
    pid = fork();
    20b0:	00004097          	auipc	ra,0x4
    20b4:	b46080e7          	jalr	-1210(ra) # 5bf6 <fork>
    if(pid < 0)
    20b8:	02054863          	bltz	a0,20e8 <forktest+0x4e>
    if(pid == 0)
    20bc:	c115                	beqz	a0,20e0 <forktest+0x46>
  for(n=0; n<N; n++){
    20be:	2485                	addiw	s1,s1,1
    20c0:	ff2498e3          	bne	s1,s2,20b0 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    20c4:	85ce                	mv	a1,s3
    20c6:	00005517          	auipc	a0,0x5
    20ca:	bb250513          	addi	a0,a0,-1102 # 6c78 <malloc+0xc44>
    20ce:	00004097          	auipc	ra,0x4
    20d2:	ea8080e7          	jalr	-344(ra) # 5f76 <printf>
    exit(1);
    20d6:	4505                	li	a0,1
    20d8:	00004097          	auipc	ra,0x4
    20dc:	b26080e7          	jalr	-1242(ra) # 5bfe <exit>
      exit(0);
    20e0:	00004097          	auipc	ra,0x4
    20e4:	b1e080e7          	jalr	-1250(ra) # 5bfe <exit>
  if (n == 0) {
    20e8:	cc9d                	beqz	s1,2126 <forktest+0x8c>
  if(n == N){
    20ea:	3e800793          	li	a5,1000
    20ee:	fcf48be3          	beq	s1,a5,20c4 <forktest+0x2a>
  for(; n > 0; n--){
    20f2:	00905b63          	blez	s1,2108 <forktest+0x6e>
    if(wait(0) < 0){
    20f6:	4501                	li	a0,0
    20f8:	00004097          	auipc	ra,0x4
    20fc:	b0e080e7          	jalr	-1266(ra) # 5c06 <wait>
    2100:	04054163          	bltz	a0,2142 <forktest+0xa8>
  for(; n > 0; n--){
    2104:	34fd                	addiw	s1,s1,-1
    2106:	f8e5                	bnez	s1,20f6 <forktest+0x5c>
  if(wait(0) != -1){
    2108:	4501                	li	a0,0
    210a:	00004097          	auipc	ra,0x4
    210e:	afc080e7          	jalr	-1284(ra) # 5c06 <wait>
    2112:	57fd                	li	a5,-1
    2114:	04f51563          	bne	a0,a5,215e <forktest+0xc4>
}
    2118:	70a2                	ld	ra,40(sp)
    211a:	7402                	ld	s0,32(sp)
    211c:	64e2                	ld	s1,24(sp)
    211e:	6942                	ld	s2,16(sp)
    2120:	69a2                	ld	s3,8(sp)
    2122:	6145                	addi	sp,sp,48
    2124:	8082                	ret
    printf("%s: no fork at all!\n", s);
    2126:	85ce                	mv	a1,s3
    2128:	00005517          	auipc	a0,0x5
    212c:	b3850513          	addi	a0,a0,-1224 # 6c60 <malloc+0xc2c>
    2130:	00004097          	auipc	ra,0x4
    2134:	e46080e7          	jalr	-442(ra) # 5f76 <printf>
    exit(1);
    2138:	4505                	li	a0,1
    213a:	00004097          	auipc	ra,0x4
    213e:	ac4080e7          	jalr	-1340(ra) # 5bfe <exit>
      printf("%s: wait stopped early\n", s);
    2142:	85ce                	mv	a1,s3
    2144:	00005517          	auipc	a0,0x5
    2148:	b5c50513          	addi	a0,a0,-1188 # 6ca0 <malloc+0xc6c>
    214c:	00004097          	auipc	ra,0x4
    2150:	e2a080e7          	jalr	-470(ra) # 5f76 <printf>
      exit(1);
    2154:	4505                	li	a0,1
    2156:	00004097          	auipc	ra,0x4
    215a:	aa8080e7          	jalr	-1368(ra) # 5bfe <exit>
    printf("%s: wait got too many\n", s);
    215e:	85ce                	mv	a1,s3
    2160:	00005517          	auipc	a0,0x5
    2164:	b5850513          	addi	a0,a0,-1192 # 6cb8 <malloc+0xc84>
    2168:	00004097          	auipc	ra,0x4
    216c:	e0e080e7          	jalr	-498(ra) # 5f76 <printf>
    exit(1);
    2170:	4505                	li	a0,1
    2172:	00004097          	auipc	ra,0x4
    2176:	a8c080e7          	jalr	-1396(ra) # 5bfe <exit>

000000000000217a <kernmem>:
{
    217a:	715d                	addi	sp,sp,-80
    217c:	e486                	sd	ra,72(sp)
    217e:	e0a2                	sd	s0,64(sp)
    2180:	fc26                	sd	s1,56(sp)
    2182:	f84a                	sd	s2,48(sp)
    2184:	f44e                	sd	s3,40(sp)
    2186:	f052                	sd	s4,32(sp)
    2188:	ec56                	sd	s5,24(sp)
    218a:	0880                	addi	s0,sp,80
    218c:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    218e:	4485                	li	s1,1
    2190:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    2192:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2194:	69b1                	lui	s3,0xc
    2196:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1de8>
    219a:	1003d937          	lui	s2,0x1003d
    219e:	090e                	slli	s2,s2,0x3
    21a0:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d808>
    pid = fork();
    21a4:	00004097          	auipc	ra,0x4
    21a8:	a52080e7          	jalr	-1454(ra) # 5bf6 <fork>
    if(pid < 0){
    21ac:	02054963          	bltz	a0,21de <kernmem+0x64>
    if(pid == 0){
    21b0:	c529                	beqz	a0,21fa <kernmem+0x80>
    wait(&xstatus);
    21b2:	fbc40513          	addi	a0,s0,-68
    21b6:	00004097          	auipc	ra,0x4
    21ba:	a50080e7          	jalr	-1456(ra) # 5c06 <wait>
    if(xstatus != -1)  // did kernel kill child?
    21be:	fbc42783          	lw	a5,-68(s0)
    21c2:	05579d63          	bne	a5,s5,221c <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21c6:	94ce                	add	s1,s1,s3
    21c8:	fd249ee3          	bne	s1,s2,21a4 <kernmem+0x2a>
}
    21cc:	60a6                	ld	ra,72(sp)
    21ce:	6406                	ld	s0,64(sp)
    21d0:	74e2                	ld	s1,56(sp)
    21d2:	7942                	ld	s2,48(sp)
    21d4:	79a2                	ld	s3,40(sp)
    21d6:	7a02                	ld	s4,32(sp)
    21d8:	6ae2                	ld	s5,24(sp)
    21da:	6161                	addi	sp,sp,80
    21dc:	8082                	ret
      printf("%s: fork failed\n", s);
    21de:	85d2                	mv	a1,s4
    21e0:	00005517          	auipc	a0,0x5
    21e4:	82050513          	addi	a0,a0,-2016 # 6a00 <malloc+0x9cc>
    21e8:	00004097          	auipc	ra,0x4
    21ec:	d8e080e7          	jalr	-626(ra) # 5f76 <printf>
      exit(1);
    21f0:	4505                	li	a0,1
    21f2:	00004097          	auipc	ra,0x4
    21f6:	a0c080e7          	jalr	-1524(ra) # 5bfe <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    21fa:	0004c683          	lbu	a3,0(s1)
    21fe:	8626                	mv	a2,s1
    2200:	85d2                	mv	a1,s4
    2202:	00005517          	auipc	a0,0x5
    2206:	ace50513          	addi	a0,a0,-1330 # 6cd0 <malloc+0xc9c>
    220a:	00004097          	auipc	ra,0x4
    220e:	d6c080e7          	jalr	-660(ra) # 5f76 <printf>
      exit(1);
    2212:	4505                	li	a0,1
    2214:	00004097          	auipc	ra,0x4
    2218:	9ea080e7          	jalr	-1558(ra) # 5bfe <exit>
      exit(1);
    221c:	4505                	li	a0,1
    221e:	00004097          	auipc	ra,0x4
    2222:	9e0080e7          	jalr	-1568(ra) # 5bfe <exit>

0000000000002226 <MAXVAplus>:
{
    2226:	7179                	addi	sp,sp,-48
    2228:	f406                	sd	ra,40(sp)
    222a:	f022                	sd	s0,32(sp)
    222c:	ec26                	sd	s1,24(sp)
    222e:	e84a                	sd	s2,16(sp)
    2230:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    2232:	4785                	li	a5,1
    2234:	179a                	slli	a5,a5,0x26
    2236:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    223a:	fd843783          	ld	a5,-40(s0)
    223e:	cf85                	beqz	a5,2276 <MAXVAplus+0x50>
    2240:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    2242:	54fd                	li	s1,-1
    pid = fork();
    2244:	00004097          	auipc	ra,0x4
    2248:	9b2080e7          	jalr	-1614(ra) # 5bf6 <fork>
    if(pid < 0){
    224c:	02054b63          	bltz	a0,2282 <MAXVAplus+0x5c>
    if(pid == 0){
    2250:	c539                	beqz	a0,229e <MAXVAplus+0x78>
    wait(&xstatus);
    2252:	fd440513          	addi	a0,s0,-44
    2256:	00004097          	auipc	ra,0x4
    225a:	9b0080e7          	jalr	-1616(ra) # 5c06 <wait>
    if(xstatus != -1)  // did kernel kill child?
    225e:	fd442783          	lw	a5,-44(s0)
    2262:	06979463          	bne	a5,s1,22ca <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    2266:	fd843783          	ld	a5,-40(s0)
    226a:	0786                	slli	a5,a5,0x1
    226c:	fcf43c23          	sd	a5,-40(s0)
    2270:	fd843783          	ld	a5,-40(s0)
    2274:	fbe1                	bnez	a5,2244 <MAXVAplus+0x1e>
}
    2276:	70a2                	ld	ra,40(sp)
    2278:	7402                	ld	s0,32(sp)
    227a:	64e2                	ld	s1,24(sp)
    227c:	6942                	ld	s2,16(sp)
    227e:	6145                	addi	sp,sp,48
    2280:	8082                	ret
      printf("%s: fork failed\n", s);
    2282:	85ca                	mv	a1,s2
    2284:	00004517          	auipc	a0,0x4
    2288:	77c50513          	addi	a0,a0,1916 # 6a00 <malloc+0x9cc>
    228c:	00004097          	auipc	ra,0x4
    2290:	cea080e7          	jalr	-790(ra) # 5f76 <printf>
      exit(1);
    2294:	4505                	li	a0,1
    2296:	00004097          	auipc	ra,0x4
    229a:	968080e7          	jalr	-1688(ra) # 5bfe <exit>
      *(char*)a = 99;
    229e:	fd843783          	ld	a5,-40(s0)
    22a2:	06300713          	li	a4,99
    22a6:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    22aa:	fd843603          	ld	a2,-40(s0)
    22ae:	85ca                	mv	a1,s2
    22b0:	00005517          	auipc	a0,0x5
    22b4:	a4050513          	addi	a0,a0,-1472 # 6cf0 <malloc+0xcbc>
    22b8:	00004097          	auipc	ra,0x4
    22bc:	cbe080e7          	jalr	-834(ra) # 5f76 <printf>
      exit(1);
    22c0:	4505                	li	a0,1
    22c2:	00004097          	auipc	ra,0x4
    22c6:	93c080e7          	jalr	-1732(ra) # 5bfe <exit>
      exit(1);
    22ca:	4505                	li	a0,1
    22cc:	00004097          	auipc	ra,0x4
    22d0:	932080e7          	jalr	-1742(ra) # 5bfe <exit>

00000000000022d4 <bigargtest>:
{
    22d4:	7179                	addi	sp,sp,-48
    22d6:	f406                	sd	ra,40(sp)
    22d8:	f022                	sd	s0,32(sp)
    22da:	ec26                	sd	s1,24(sp)
    22dc:	1800                	addi	s0,sp,48
    22de:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    22e0:	00005517          	auipc	a0,0x5
    22e4:	a2850513          	addi	a0,a0,-1496 # 6d08 <malloc+0xcd4>
    22e8:	00004097          	auipc	ra,0x4
    22ec:	966080e7          	jalr	-1690(ra) # 5c4e <unlink>
  pid = fork();
    22f0:	00004097          	auipc	ra,0x4
    22f4:	906080e7          	jalr	-1786(ra) # 5bf6 <fork>
  if(pid == 0){
    22f8:	c121                	beqz	a0,2338 <bigargtest+0x64>
  } else if(pid < 0){
    22fa:	0a054063          	bltz	a0,239a <bigargtest+0xc6>
  wait(&xstatus);
    22fe:	fdc40513          	addi	a0,s0,-36
    2302:	00004097          	auipc	ra,0x4
    2306:	904080e7          	jalr	-1788(ra) # 5c06 <wait>
  if(xstatus != 0)
    230a:	fdc42503          	lw	a0,-36(s0)
    230e:	e545                	bnez	a0,23b6 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    2310:	4581                	li	a1,0
    2312:	00005517          	auipc	a0,0x5
    2316:	9f650513          	addi	a0,a0,-1546 # 6d08 <malloc+0xcd4>
    231a:	00004097          	auipc	ra,0x4
    231e:	924080e7          	jalr	-1756(ra) # 5c3e <open>
  if(fd < 0){
    2322:	08054e63          	bltz	a0,23be <bigargtest+0xea>
  close(fd);
    2326:	00004097          	auipc	ra,0x4
    232a:	900080e7          	jalr	-1792(ra) # 5c26 <close>
}
    232e:	70a2                	ld	ra,40(sp)
    2330:	7402                	ld	s0,32(sp)
    2332:	64e2                	ld	s1,24(sp)
    2334:	6145                	addi	sp,sp,48
    2336:	8082                	ret
    2338:	00007797          	auipc	a5,0x7
    233c:	12878793          	addi	a5,a5,296 # 9460 <args.1814>
    2340:	00007697          	auipc	a3,0x7
    2344:	21868693          	addi	a3,a3,536 # 9558 <args.1814+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2348:	00005717          	auipc	a4,0x5
    234c:	9d070713          	addi	a4,a4,-1584 # 6d18 <malloc+0xce4>
    2350:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    2352:	07a1                	addi	a5,a5,8
    2354:	fed79ee3          	bne	a5,a3,2350 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    2358:	00007597          	auipc	a1,0x7
    235c:	10858593          	addi	a1,a1,264 # 9460 <args.1814>
    2360:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2364:	00004517          	auipc	a0,0x4
    2368:	e1450513          	addi	a0,a0,-492 # 6178 <malloc+0x144>
    236c:	00004097          	auipc	ra,0x4
    2370:	8ca080e7          	jalr	-1846(ra) # 5c36 <exec>
    fd = open("bigarg-ok", O_CREATE);
    2374:	20000593          	li	a1,512
    2378:	00005517          	auipc	a0,0x5
    237c:	99050513          	addi	a0,a0,-1648 # 6d08 <malloc+0xcd4>
    2380:	00004097          	auipc	ra,0x4
    2384:	8be080e7          	jalr	-1858(ra) # 5c3e <open>
    close(fd);
    2388:	00004097          	auipc	ra,0x4
    238c:	89e080e7          	jalr	-1890(ra) # 5c26 <close>
    exit(0);
    2390:	4501                	li	a0,0
    2392:	00004097          	auipc	ra,0x4
    2396:	86c080e7          	jalr	-1940(ra) # 5bfe <exit>
    printf("%s: bigargtest: fork failed\n", s);
    239a:	85a6                	mv	a1,s1
    239c:	00005517          	auipc	a0,0x5
    23a0:	a5c50513          	addi	a0,a0,-1444 # 6df8 <malloc+0xdc4>
    23a4:	00004097          	auipc	ra,0x4
    23a8:	bd2080e7          	jalr	-1070(ra) # 5f76 <printf>
    exit(1);
    23ac:	4505                	li	a0,1
    23ae:	00004097          	auipc	ra,0x4
    23b2:	850080e7          	jalr	-1968(ra) # 5bfe <exit>
    exit(xstatus);
    23b6:	00004097          	auipc	ra,0x4
    23ba:	848080e7          	jalr	-1976(ra) # 5bfe <exit>
    printf("%s: bigarg test failed!\n", s);
    23be:	85a6                	mv	a1,s1
    23c0:	00005517          	auipc	a0,0x5
    23c4:	a5850513          	addi	a0,a0,-1448 # 6e18 <malloc+0xde4>
    23c8:	00004097          	auipc	ra,0x4
    23cc:	bae080e7          	jalr	-1106(ra) # 5f76 <printf>
    exit(1);
    23d0:	4505                	li	a0,1
    23d2:	00004097          	auipc	ra,0x4
    23d6:	82c080e7          	jalr	-2004(ra) # 5bfe <exit>

00000000000023da <stacktest>:
{
    23da:	7179                	addi	sp,sp,-48
    23dc:	f406                	sd	ra,40(sp)
    23de:	f022                	sd	s0,32(sp)
    23e0:	ec26                	sd	s1,24(sp)
    23e2:	1800                	addi	s0,sp,48
    23e4:	84aa                	mv	s1,a0
  pid = fork();
    23e6:	00004097          	auipc	ra,0x4
    23ea:	810080e7          	jalr	-2032(ra) # 5bf6 <fork>
  if(pid == 0) {
    23ee:	c115                	beqz	a0,2412 <stacktest+0x38>
  } else if(pid < 0){
    23f0:	04054463          	bltz	a0,2438 <stacktest+0x5e>
  wait(&xstatus);
    23f4:	fdc40513          	addi	a0,s0,-36
    23f8:	00004097          	auipc	ra,0x4
    23fc:	80e080e7          	jalr	-2034(ra) # 5c06 <wait>
  if(xstatus == -1)  // kernel killed child?
    2400:	fdc42503          	lw	a0,-36(s0)
    2404:	57fd                	li	a5,-1
    2406:	04f50763          	beq	a0,a5,2454 <stacktest+0x7a>
    exit(xstatus);
    240a:	00003097          	auipc	ra,0x3
    240e:	7f4080e7          	jalr	2036(ra) # 5bfe <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2412:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2414:	77fd                	lui	a5,0xfffff
    2416:	97ba                	add	a5,a5,a4
    2418:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef388>
    241c:	85a6                	mv	a1,s1
    241e:	00005517          	auipc	a0,0x5
    2422:	a1a50513          	addi	a0,a0,-1510 # 6e38 <malloc+0xe04>
    2426:	00004097          	auipc	ra,0x4
    242a:	b50080e7          	jalr	-1200(ra) # 5f76 <printf>
    exit(1);
    242e:	4505                	li	a0,1
    2430:	00003097          	auipc	ra,0x3
    2434:	7ce080e7          	jalr	1998(ra) # 5bfe <exit>
    printf("%s: fork failed\n", s);
    2438:	85a6                	mv	a1,s1
    243a:	00004517          	auipc	a0,0x4
    243e:	5c650513          	addi	a0,a0,1478 # 6a00 <malloc+0x9cc>
    2442:	00004097          	auipc	ra,0x4
    2446:	b34080e7          	jalr	-1228(ra) # 5f76 <printf>
    exit(1);
    244a:	4505                	li	a0,1
    244c:	00003097          	auipc	ra,0x3
    2450:	7b2080e7          	jalr	1970(ra) # 5bfe <exit>
    exit(0);
    2454:	4501                	li	a0,0
    2456:	00003097          	auipc	ra,0x3
    245a:	7a8080e7          	jalr	1960(ra) # 5bfe <exit>

000000000000245e <textwrite>:
{
    245e:	7179                	addi	sp,sp,-48
    2460:	f406                	sd	ra,40(sp)
    2462:	f022                	sd	s0,32(sp)
    2464:	ec26                	sd	s1,24(sp)
    2466:	1800                	addi	s0,sp,48
    2468:	84aa                	mv	s1,a0
  pid = fork();
    246a:	00003097          	auipc	ra,0x3
    246e:	78c080e7          	jalr	1932(ra) # 5bf6 <fork>
  if(pid == 0) {
    2472:	c115                	beqz	a0,2496 <textwrite+0x38>
  } else if(pid < 0){
    2474:	02054963          	bltz	a0,24a6 <textwrite+0x48>
  wait(&xstatus);
    2478:	fdc40513          	addi	a0,s0,-36
    247c:	00003097          	auipc	ra,0x3
    2480:	78a080e7          	jalr	1930(ra) # 5c06 <wait>
  if(xstatus == -1)  // kernel killed child?
    2484:	fdc42503          	lw	a0,-36(s0)
    2488:	57fd                	li	a5,-1
    248a:	02f50c63          	beq	a0,a5,24c2 <textwrite+0x64>
    exit(xstatus);
    248e:	00003097          	auipc	ra,0x3
    2492:	770080e7          	jalr	1904(ra) # 5bfe <exit>
    *addr = 10;
    2496:	47a9                	li	a5,10
    2498:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    249c:	4505                	li	a0,1
    249e:	00003097          	auipc	ra,0x3
    24a2:	760080e7          	jalr	1888(ra) # 5bfe <exit>
    printf("%s: fork failed\n", s);
    24a6:	85a6                	mv	a1,s1
    24a8:	00004517          	auipc	a0,0x4
    24ac:	55850513          	addi	a0,a0,1368 # 6a00 <malloc+0x9cc>
    24b0:	00004097          	auipc	ra,0x4
    24b4:	ac6080e7          	jalr	-1338(ra) # 5f76 <printf>
    exit(1);
    24b8:	4505                	li	a0,1
    24ba:	00003097          	auipc	ra,0x3
    24be:	744080e7          	jalr	1860(ra) # 5bfe <exit>
    exit(0);
    24c2:	4501                	li	a0,0
    24c4:	00003097          	auipc	ra,0x3
    24c8:	73a080e7          	jalr	1850(ra) # 5bfe <exit>

00000000000024cc <manywrites>:
{
    24cc:	711d                	addi	sp,sp,-96
    24ce:	ec86                	sd	ra,88(sp)
    24d0:	e8a2                	sd	s0,80(sp)
    24d2:	e4a6                	sd	s1,72(sp)
    24d4:	e0ca                	sd	s2,64(sp)
    24d6:	fc4e                	sd	s3,56(sp)
    24d8:	f852                	sd	s4,48(sp)
    24da:	f456                	sd	s5,40(sp)
    24dc:	f05a                	sd	s6,32(sp)
    24de:	ec5e                	sd	s7,24(sp)
    24e0:	1080                	addi	s0,sp,96
    24e2:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    24e4:	4901                	li	s2,0
    24e6:	4991                	li	s3,4
    int pid = fork();
    24e8:	00003097          	auipc	ra,0x3
    24ec:	70e080e7          	jalr	1806(ra) # 5bf6 <fork>
    24f0:	84aa                	mv	s1,a0
    if(pid < 0){
    24f2:	02054963          	bltz	a0,2524 <manywrites+0x58>
    if(pid == 0){
    24f6:	c521                	beqz	a0,253e <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    24f8:	2905                	addiw	s2,s2,1
    24fa:	ff3917e3          	bne	s2,s3,24e8 <manywrites+0x1c>
    24fe:	4491                	li	s1,4
    int st = 0;
    2500:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    2504:	fa840513          	addi	a0,s0,-88
    2508:	00003097          	auipc	ra,0x3
    250c:	6fe080e7          	jalr	1790(ra) # 5c06 <wait>
    if(st != 0)
    2510:	fa842503          	lw	a0,-88(s0)
    2514:	ed6d                	bnez	a0,260e <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    2516:	34fd                	addiw	s1,s1,-1
    2518:	f4e5                	bnez	s1,2500 <manywrites+0x34>
  exit(0);
    251a:	4501                	li	a0,0
    251c:	00003097          	auipc	ra,0x3
    2520:	6e2080e7          	jalr	1762(ra) # 5bfe <exit>
      printf("fork failed\n");
    2524:	00005517          	auipc	a0,0x5
    2528:	8e450513          	addi	a0,a0,-1820 # 6e08 <malloc+0xdd4>
    252c:	00004097          	auipc	ra,0x4
    2530:	a4a080e7          	jalr	-1462(ra) # 5f76 <printf>
      exit(1);
    2534:	4505                	li	a0,1
    2536:	00003097          	auipc	ra,0x3
    253a:	6c8080e7          	jalr	1736(ra) # 5bfe <exit>
      name[0] = 'b';
    253e:	06200793          	li	a5,98
    2542:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    2546:	0619079b          	addiw	a5,s2,97
    254a:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    254e:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    2552:	fa840513          	addi	a0,s0,-88
    2556:	00003097          	auipc	ra,0x3
    255a:	6f8080e7          	jalr	1784(ra) # 5c4e <unlink>
    255e:	4b79                	li	s6,30
          int cc = write(fd, buf, sz);
    2560:	0000ab97          	auipc	s7,0xa
    2564:	718b8b93          	addi	s7,s7,1816 # cc78 <buf>
        for(int i = 0; i < ci+1; i++){
    2568:	8a26                	mv	s4,s1
    256a:	02094e63          	bltz	s2,25a6 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    256e:	20200593          	li	a1,514
    2572:	fa840513          	addi	a0,s0,-88
    2576:	00003097          	auipc	ra,0x3
    257a:	6c8080e7          	jalr	1736(ra) # 5c3e <open>
    257e:	89aa                	mv	s3,a0
          if(fd < 0){
    2580:	04054763          	bltz	a0,25ce <manywrites+0x102>
          int cc = write(fd, buf, sz);
    2584:	660d                	lui	a2,0x3
    2586:	85de                	mv	a1,s7
    2588:	00003097          	auipc	ra,0x3
    258c:	696080e7          	jalr	1686(ra) # 5c1e <write>
          if(cc != sz){
    2590:	678d                	lui	a5,0x3
    2592:	04f51e63          	bne	a0,a5,25ee <manywrites+0x122>
          close(fd);
    2596:	854e                	mv	a0,s3
    2598:	00003097          	auipc	ra,0x3
    259c:	68e080e7          	jalr	1678(ra) # 5c26 <close>
        for(int i = 0; i < ci+1; i++){
    25a0:	2a05                	addiw	s4,s4,1
    25a2:	fd4956e3          	bge	s2,s4,256e <manywrites+0xa2>
        unlink(name);
    25a6:	fa840513          	addi	a0,s0,-88
    25aa:	00003097          	auipc	ra,0x3
    25ae:	6a4080e7          	jalr	1700(ra) # 5c4e <unlink>
      for(int iters = 0; iters < howmany; iters++){
    25b2:	3b7d                	addiw	s6,s6,-1
    25b4:	fa0b1ae3          	bnez	s6,2568 <manywrites+0x9c>
      unlink(name);
    25b8:	fa840513          	addi	a0,s0,-88
    25bc:	00003097          	auipc	ra,0x3
    25c0:	692080e7          	jalr	1682(ra) # 5c4e <unlink>
      exit(0);
    25c4:	4501                	li	a0,0
    25c6:	00003097          	auipc	ra,0x3
    25ca:	638080e7          	jalr	1592(ra) # 5bfe <exit>
            printf("%s: cannot create %s\n", s, name);
    25ce:	fa840613          	addi	a2,s0,-88
    25d2:	85d6                	mv	a1,s5
    25d4:	00005517          	auipc	a0,0x5
    25d8:	88c50513          	addi	a0,a0,-1908 # 6e60 <malloc+0xe2c>
    25dc:	00004097          	auipc	ra,0x4
    25e0:	99a080e7          	jalr	-1638(ra) # 5f76 <printf>
            exit(1);
    25e4:	4505                	li	a0,1
    25e6:	00003097          	auipc	ra,0x3
    25ea:	618080e7          	jalr	1560(ra) # 5bfe <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    25ee:	86aa                	mv	a3,a0
    25f0:	660d                	lui	a2,0x3
    25f2:	85d6                	mv	a1,s5
    25f4:	00004517          	auipc	a0,0x4
    25f8:	c5450513          	addi	a0,a0,-940 # 6248 <malloc+0x214>
    25fc:	00004097          	auipc	ra,0x4
    2600:	97a080e7          	jalr	-1670(ra) # 5f76 <printf>
            exit(1);
    2604:	4505                	li	a0,1
    2606:	00003097          	auipc	ra,0x3
    260a:	5f8080e7          	jalr	1528(ra) # 5bfe <exit>
      exit(st);
    260e:	00003097          	auipc	ra,0x3
    2612:	5f0080e7          	jalr	1520(ra) # 5bfe <exit>

0000000000002616 <copyinstr3>:
{
    2616:	7179                	addi	sp,sp,-48
    2618:	f406                	sd	ra,40(sp)
    261a:	f022                	sd	s0,32(sp)
    261c:	ec26                	sd	s1,24(sp)
    261e:	1800                	addi	s0,sp,48
  sbrk(8192);
    2620:	6509                	lui	a0,0x2
    2622:	00003097          	auipc	ra,0x3
    2626:	664080e7          	jalr	1636(ra) # 5c86 <sbrk>
  uint64 top = (uint64) sbrk(0);
    262a:	4501                	li	a0,0
    262c:	00003097          	auipc	ra,0x3
    2630:	65a080e7          	jalr	1626(ra) # 5c86 <sbrk>
  if((top % PGSIZE) != 0){
    2634:	03451793          	slli	a5,a0,0x34
    2638:	e3c9                	bnez	a5,26ba <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    263a:	4501                	li	a0,0
    263c:	00003097          	auipc	ra,0x3
    2640:	64a080e7          	jalr	1610(ra) # 5c86 <sbrk>
  if(top % PGSIZE){
    2644:	03451793          	slli	a5,a0,0x34
    2648:	e3d9                	bnez	a5,26ce <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    264a:	fff50493          	addi	s1,a0,-1 # 1fff <linkunlink+0x67>
  *b = 'x';
    264e:	07800793          	li	a5,120
    2652:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2656:	8526                	mv	a0,s1
    2658:	00003097          	auipc	ra,0x3
    265c:	5f6080e7          	jalr	1526(ra) # 5c4e <unlink>
  if(ret != -1){
    2660:	57fd                	li	a5,-1
    2662:	08f51363          	bne	a0,a5,26e8 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2666:	20100593          	li	a1,513
    266a:	8526                	mv	a0,s1
    266c:	00003097          	auipc	ra,0x3
    2670:	5d2080e7          	jalr	1490(ra) # 5c3e <open>
  if(fd != -1){
    2674:	57fd                	li	a5,-1
    2676:	08f51863          	bne	a0,a5,2706 <copyinstr3+0xf0>
  ret = link(b, b);
    267a:	85a6                	mv	a1,s1
    267c:	8526                	mv	a0,s1
    267e:	00003097          	auipc	ra,0x3
    2682:	5e0080e7          	jalr	1504(ra) # 5c5e <link>
  if(ret != -1){
    2686:	57fd                	li	a5,-1
    2688:	08f51e63          	bne	a0,a5,2724 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    268c:	00005797          	auipc	a5,0x5
    2690:	4cc78793          	addi	a5,a5,1228 # 7b58 <malloc+0x1b24>
    2694:	fcf43823          	sd	a5,-48(s0)
    2698:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    269c:	fd040593          	addi	a1,s0,-48
    26a0:	8526                	mv	a0,s1
    26a2:	00003097          	auipc	ra,0x3
    26a6:	594080e7          	jalr	1428(ra) # 5c36 <exec>
  if(ret != -1){
    26aa:	57fd                	li	a5,-1
    26ac:	08f51c63          	bne	a0,a5,2744 <copyinstr3+0x12e>
}
    26b0:	70a2                	ld	ra,40(sp)
    26b2:	7402                	ld	s0,32(sp)
    26b4:	64e2                	ld	s1,24(sp)
    26b6:	6145                	addi	sp,sp,48
    26b8:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    26ba:	0347d513          	srli	a0,a5,0x34
    26be:	6785                	lui	a5,0x1
    26c0:	40a7853b          	subw	a0,a5,a0
    26c4:	00003097          	auipc	ra,0x3
    26c8:	5c2080e7          	jalr	1474(ra) # 5c86 <sbrk>
    26cc:	b7bd                	j	263a <copyinstr3+0x24>
    printf("oops\n");
    26ce:	00004517          	auipc	a0,0x4
    26d2:	7aa50513          	addi	a0,a0,1962 # 6e78 <malloc+0xe44>
    26d6:	00004097          	auipc	ra,0x4
    26da:	8a0080e7          	jalr	-1888(ra) # 5f76 <printf>
    exit(1);
    26de:	4505                	li	a0,1
    26e0:	00003097          	auipc	ra,0x3
    26e4:	51e080e7          	jalr	1310(ra) # 5bfe <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    26e8:	862a                	mv	a2,a0
    26ea:	85a6                	mv	a1,s1
    26ec:	00004517          	auipc	a0,0x4
    26f0:	23450513          	addi	a0,a0,564 # 6920 <malloc+0x8ec>
    26f4:	00004097          	auipc	ra,0x4
    26f8:	882080e7          	jalr	-1918(ra) # 5f76 <printf>
    exit(1);
    26fc:	4505                	li	a0,1
    26fe:	00003097          	auipc	ra,0x3
    2702:	500080e7          	jalr	1280(ra) # 5bfe <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2706:	862a                	mv	a2,a0
    2708:	85a6                	mv	a1,s1
    270a:	00004517          	auipc	a0,0x4
    270e:	23650513          	addi	a0,a0,566 # 6940 <malloc+0x90c>
    2712:	00004097          	auipc	ra,0x4
    2716:	864080e7          	jalr	-1948(ra) # 5f76 <printf>
    exit(1);
    271a:	4505                	li	a0,1
    271c:	00003097          	auipc	ra,0x3
    2720:	4e2080e7          	jalr	1250(ra) # 5bfe <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2724:	86aa                	mv	a3,a0
    2726:	8626                	mv	a2,s1
    2728:	85a6                	mv	a1,s1
    272a:	00004517          	auipc	a0,0x4
    272e:	23650513          	addi	a0,a0,566 # 6960 <malloc+0x92c>
    2732:	00004097          	auipc	ra,0x4
    2736:	844080e7          	jalr	-1980(ra) # 5f76 <printf>
    exit(1);
    273a:	4505                	li	a0,1
    273c:	00003097          	auipc	ra,0x3
    2740:	4c2080e7          	jalr	1218(ra) # 5bfe <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2744:	567d                	li	a2,-1
    2746:	85a6                	mv	a1,s1
    2748:	00004517          	auipc	a0,0x4
    274c:	24050513          	addi	a0,a0,576 # 6988 <malloc+0x954>
    2750:	00004097          	auipc	ra,0x4
    2754:	826080e7          	jalr	-2010(ra) # 5f76 <printf>
    exit(1);
    2758:	4505                	li	a0,1
    275a:	00003097          	auipc	ra,0x3
    275e:	4a4080e7          	jalr	1188(ra) # 5bfe <exit>

0000000000002762 <rwsbrk>:
{
    2762:	1101                	addi	sp,sp,-32
    2764:	ec06                	sd	ra,24(sp)
    2766:	e822                	sd	s0,16(sp)
    2768:	e426                	sd	s1,8(sp)
    276a:	e04a                	sd	s2,0(sp)
    276c:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    276e:	6509                	lui	a0,0x2
    2770:	00003097          	auipc	ra,0x3
    2774:	516080e7          	jalr	1302(ra) # 5c86 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2778:	57fd                	li	a5,-1
    277a:	06f50363          	beq	a0,a5,27e0 <rwsbrk+0x7e>
    277e:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2780:	7579                	lui	a0,0xffffe
    2782:	00003097          	auipc	ra,0x3
    2786:	504080e7          	jalr	1284(ra) # 5c86 <sbrk>
    278a:	57fd                	li	a5,-1
    278c:	06f50763          	beq	a0,a5,27fa <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2790:	20100593          	li	a1,513
    2794:	00004517          	auipc	a0,0x4
    2798:	72450513          	addi	a0,a0,1828 # 6eb8 <malloc+0xe84>
    279c:	00003097          	auipc	ra,0x3
    27a0:	4a2080e7          	jalr	1186(ra) # 5c3e <open>
    27a4:	892a                	mv	s2,a0
  if(fd < 0){
    27a6:	06054763          	bltz	a0,2814 <rwsbrk+0xb2>
  n = write(fd, (void*)(a+4096), 1024);
    27aa:	6505                	lui	a0,0x1
    27ac:	94aa                	add	s1,s1,a0
    27ae:	40000613          	li	a2,1024
    27b2:	85a6                	mv	a1,s1
    27b4:	854a                	mv	a0,s2
    27b6:	00003097          	auipc	ra,0x3
    27ba:	468080e7          	jalr	1128(ra) # 5c1e <write>
    27be:	862a                	mv	a2,a0
  if(n >= 0){
    27c0:	06054763          	bltz	a0,282e <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    27c4:	85a6                	mv	a1,s1
    27c6:	00004517          	auipc	a0,0x4
    27ca:	71250513          	addi	a0,a0,1810 # 6ed8 <malloc+0xea4>
    27ce:	00003097          	auipc	ra,0x3
    27d2:	7a8080e7          	jalr	1960(ra) # 5f76 <printf>
    exit(1);
    27d6:	4505                	li	a0,1
    27d8:	00003097          	auipc	ra,0x3
    27dc:	426080e7          	jalr	1062(ra) # 5bfe <exit>
    printf("sbrk(rwsbrk) failed\n");
    27e0:	00004517          	auipc	a0,0x4
    27e4:	6a050513          	addi	a0,a0,1696 # 6e80 <malloc+0xe4c>
    27e8:	00003097          	auipc	ra,0x3
    27ec:	78e080e7          	jalr	1934(ra) # 5f76 <printf>
    exit(1);
    27f0:	4505                	li	a0,1
    27f2:	00003097          	auipc	ra,0x3
    27f6:	40c080e7          	jalr	1036(ra) # 5bfe <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    27fa:	00004517          	auipc	a0,0x4
    27fe:	69e50513          	addi	a0,a0,1694 # 6e98 <malloc+0xe64>
    2802:	00003097          	auipc	ra,0x3
    2806:	774080e7          	jalr	1908(ra) # 5f76 <printf>
    exit(1);
    280a:	4505                	li	a0,1
    280c:	00003097          	auipc	ra,0x3
    2810:	3f2080e7          	jalr	1010(ra) # 5bfe <exit>
    printf("open(rwsbrk) failed\n");
    2814:	00004517          	auipc	a0,0x4
    2818:	6ac50513          	addi	a0,a0,1708 # 6ec0 <malloc+0xe8c>
    281c:	00003097          	auipc	ra,0x3
    2820:	75a080e7          	jalr	1882(ra) # 5f76 <printf>
    exit(1);
    2824:	4505                	li	a0,1
    2826:	00003097          	auipc	ra,0x3
    282a:	3d8080e7          	jalr	984(ra) # 5bfe <exit>
  close(fd);
    282e:	854a                	mv	a0,s2
    2830:	00003097          	auipc	ra,0x3
    2834:	3f6080e7          	jalr	1014(ra) # 5c26 <close>
  unlink("rwsbrk");
    2838:	00004517          	auipc	a0,0x4
    283c:	68050513          	addi	a0,a0,1664 # 6eb8 <malloc+0xe84>
    2840:	00003097          	auipc	ra,0x3
    2844:	40e080e7          	jalr	1038(ra) # 5c4e <unlink>
  fd = open("README", O_RDONLY);
    2848:	4581                	li	a1,0
    284a:	00004517          	auipc	a0,0x4
    284e:	b0650513          	addi	a0,a0,-1274 # 6350 <malloc+0x31c>
    2852:	00003097          	auipc	ra,0x3
    2856:	3ec080e7          	jalr	1004(ra) # 5c3e <open>
    285a:	892a                	mv	s2,a0
  if(fd < 0){
    285c:	02054963          	bltz	a0,288e <rwsbrk+0x12c>
  n = read(fd, (void*)(a+4096), 10);
    2860:	4629                	li	a2,10
    2862:	85a6                	mv	a1,s1
    2864:	00003097          	auipc	ra,0x3
    2868:	3b2080e7          	jalr	946(ra) # 5c16 <read>
    286c:	862a                	mv	a2,a0
  if(n >= 0){
    286e:	02054d63          	bltz	a0,28a8 <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2872:	85a6                	mv	a1,s1
    2874:	00004517          	auipc	a0,0x4
    2878:	69450513          	addi	a0,a0,1684 # 6f08 <malloc+0xed4>
    287c:	00003097          	auipc	ra,0x3
    2880:	6fa080e7          	jalr	1786(ra) # 5f76 <printf>
    exit(1);
    2884:	4505                	li	a0,1
    2886:	00003097          	auipc	ra,0x3
    288a:	378080e7          	jalr	888(ra) # 5bfe <exit>
    printf("open(rwsbrk) failed\n");
    288e:	00004517          	auipc	a0,0x4
    2892:	63250513          	addi	a0,a0,1586 # 6ec0 <malloc+0xe8c>
    2896:	00003097          	auipc	ra,0x3
    289a:	6e0080e7          	jalr	1760(ra) # 5f76 <printf>
    exit(1);
    289e:	4505                	li	a0,1
    28a0:	00003097          	auipc	ra,0x3
    28a4:	35e080e7          	jalr	862(ra) # 5bfe <exit>
  close(fd);
    28a8:	854a                	mv	a0,s2
    28aa:	00003097          	auipc	ra,0x3
    28ae:	37c080e7          	jalr	892(ra) # 5c26 <close>
  exit(0);
    28b2:	4501                	li	a0,0
    28b4:	00003097          	auipc	ra,0x3
    28b8:	34a080e7          	jalr	842(ra) # 5bfe <exit>

00000000000028bc <sbrkbasic>:
{
    28bc:	715d                	addi	sp,sp,-80
    28be:	e486                	sd	ra,72(sp)
    28c0:	e0a2                	sd	s0,64(sp)
    28c2:	fc26                	sd	s1,56(sp)
    28c4:	f84a                	sd	s2,48(sp)
    28c6:	f44e                	sd	s3,40(sp)
    28c8:	f052                	sd	s4,32(sp)
    28ca:	ec56                	sd	s5,24(sp)
    28cc:	0880                	addi	s0,sp,80
    28ce:	8a2a                	mv	s4,a0
  pid = fork();
    28d0:	00003097          	auipc	ra,0x3
    28d4:	326080e7          	jalr	806(ra) # 5bf6 <fork>
  if(pid < 0){
    28d8:	02054c63          	bltz	a0,2910 <sbrkbasic+0x54>
  if(pid == 0){
    28dc:	ed21                	bnez	a0,2934 <sbrkbasic+0x78>
    a = sbrk(TOOMUCH);
    28de:	40000537          	lui	a0,0x40000
    28e2:	00003097          	auipc	ra,0x3
    28e6:	3a4080e7          	jalr	932(ra) # 5c86 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    28ea:	57fd                	li	a5,-1
    28ec:	02f50f63          	beq	a0,a5,292a <sbrkbasic+0x6e>
    for(b = a; b < a+TOOMUCH; b += 4096){
    28f0:	400007b7          	lui	a5,0x40000
    28f4:	97aa                	add	a5,a5,a0
      *b = 99;
    28f6:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    28fa:	6705                	lui	a4,0x1
      *b = 99;
    28fc:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2900:	953a                	add	a0,a0,a4
    2902:	fef51de3          	bne	a0,a5,28fc <sbrkbasic+0x40>
    exit(1);
    2906:	4505                	li	a0,1
    2908:	00003097          	auipc	ra,0x3
    290c:	2f6080e7          	jalr	758(ra) # 5bfe <exit>
    printf("fork failed in sbrkbasic\n");
    2910:	00004517          	auipc	a0,0x4
    2914:	62050513          	addi	a0,a0,1568 # 6f30 <malloc+0xefc>
    2918:	00003097          	auipc	ra,0x3
    291c:	65e080e7          	jalr	1630(ra) # 5f76 <printf>
    exit(1);
    2920:	4505                	li	a0,1
    2922:	00003097          	auipc	ra,0x3
    2926:	2dc080e7          	jalr	732(ra) # 5bfe <exit>
      exit(0);
    292a:	4501                	li	a0,0
    292c:	00003097          	auipc	ra,0x3
    2930:	2d2080e7          	jalr	722(ra) # 5bfe <exit>
  wait(&xstatus);
    2934:	fbc40513          	addi	a0,s0,-68
    2938:	00003097          	auipc	ra,0x3
    293c:	2ce080e7          	jalr	718(ra) # 5c06 <wait>
  if(xstatus == 1){
    2940:	fbc42703          	lw	a4,-68(s0)
    2944:	4785                	li	a5,1
    2946:	00f70e63          	beq	a4,a5,2962 <sbrkbasic+0xa6>
  a = sbrk(0);
    294a:	4501                	li	a0,0
    294c:	00003097          	auipc	ra,0x3
    2950:	33a080e7          	jalr	826(ra) # 5c86 <sbrk>
    2954:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2956:	4901                	li	s2,0
    *b = 1;
    2958:	4a85                	li	s5,1
  for(i = 0; i < 5000; i++){
    295a:	6985                	lui	s3,0x1
    295c:	38898993          	addi	s3,s3,904 # 1388 <badarg+0x34>
    2960:	a005                	j	2980 <sbrkbasic+0xc4>
    printf("%s: too much memory allocated!\n", s);
    2962:	85d2                	mv	a1,s4
    2964:	00004517          	auipc	a0,0x4
    2968:	5ec50513          	addi	a0,a0,1516 # 6f50 <malloc+0xf1c>
    296c:	00003097          	auipc	ra,0x3
    2970:	60a080e7          	jalr	1546(ra) # 5f76 <printf>
    exit(1);
    2974:	4505                	li	a0,1
    2976:	00003097          	auipc	ra,0x3
    297a:	288080e7          	jalr	648(ra) # 5bfe <exit>
    a = b + 1;
    297e:	84be                	mv	s1,a5
    b = sbrk(1);
    2980:	4505                	li	a0,1
    2982:	00003097          	auipc	ra,0x3
    2986:	304080e7          	jalr	772(ra) # 5c86 <sbrk>
    if(b != a){
    298a:	04951b63          	bne	a0,s1,29e0 <sbrkbasic+0x124>
    *b = 1;
    298e:	01548023          	sb	s5,0(s1)
    a = b + 1;
    2992:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2996:	2905                	addiw	s2,s2,1
    2998:	ff3913e3          	bne	s2,s3,297e <sbrkbasic+0xc2>
  pid = fork();
    299c:	00003097          	auipc	ra,0x3
    29a0:	25a080e7          	jalr	602(ra) # 5bf6 <fork>
    29a4:	892a                	mv	s2,a0
  if(pid < 0){
    29a6:	04054e63          	bltz	a0,2a02 <sbrkbasic+0x146>
  c = sbrk(1);
    29aa:	4505                	li	a0,1
    29ac:	00003097          	auipc	ra,0x3
    29b0:	2da080e7          	jalr	730(ra) # 5c86 <sbrk>
  c = sbrk(1);
    29b4:	4505                	li	a0,1
    29b6:	00003097          	auipc	ra,0x3
    29ba:	2d0080e7          	jalr	720(ra) # 5c86 <sbrk>
  if(c != a + 1){
    29be:	0489                	addi	s1,s1,2
    29c0:	04a48f63          	beq	s1,a0,2a1e <sbrkbasic+0x162>
    printf("%s: sbrk test failed post-fork\n", s);
    29c4:	85d2                	mv	a1,s4
    29c6:	00004517          	auipc	a0,0x4
    29ca:	5ea50513          	addi	a0,a0,1514 # 6fb0 <malloc+0xf7c>
    29ce:	00003097          	auipc	ra,0x3
    29d2:	5a8080e7          	jalr	1448(ra) # 5f76 <printf>
    exit(1);
    29d6:	4505                	li	a0,1
    29d8:	00003097          	auipc	ra,0x3
    29dc:	226080e7          	jalr	550(ra) # 5bfe <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    29e0:	872a                	mv	a4,a0
    29e2:	86a6                	mv	a3,s1
    29e4:	864a                	mv	a2,s2
    29e6:	85d2                	mv	a1,s4
    29e8:	00004517          	auipc	a0,0x4
    29ec:	58850513          	addi	a0,a0,1416 # 6f70 <malloc+0xf3c>
    29f0:	00003097          	auipc	ra,0x3
    29f4:	586080e7          	jalr	1414(ra) # 5f76 <printf>
      exit(1);
    29f8:	4505                	li	a0,1
    29fa:	00003097          	auipc	ra,0x3
    29fe:	204080e7          	jalr	516(ra) # 5bfe <exit>
    printf("%s: sbrk test fork failed\n", s);
    2a02:	85d2                	mv	a1,s4
    2a04:	00004517          	auipc	a0,0x4
    2a08:	58c50513          	addi	a0,a0,1420 # 6f90 <malloc+0xf5c>
    2a0c:	00003097          	auipc	ra,0x3
    2a10:	56a080e7          	jalr	1386(ra) # 5f76 <printf>
    exit(1);
    2a14:	4505                	li	a0,1
    2a16:	00003097          	auipc	ra,0x3
    2a1a:	1e8080e7          	jalr	488(ra) # 5bfe <exit>
  if(pid == 0)
    2a1e:	00091763          	bnez	s2,2a2c <sbrkbasic+0x170>
    exit(0);
    2a22:	4501                	li	a0,0
    2a24:	00003097          	auipc	ra,0x3
    2a28:	1da080e7          	jalr	474(ra) # 5bfe <exit>
  wait(&xstatus);
    2a2c:	fbc40513          	addi	a0,s0,-68
    2a30:	00003097          	auipc	ra,0x3
    2a34:	1d6080e7          	jalr	470(ra) # 5c06 <wait>
  exit(xstatus);
    2a38:	fbc42503          	lw	a0,-68(s0)
    2a3c:	00003097          	auipc	ra,0x3
    2a40:	1c2080e7          	jalr	450(ra) # 5bfe <exit>

0000000000002a44 <sbrkmuch>:
{
    2a44:	7179                	addi	sp,sp,-48
    2a46:	f406                	sd	ra,40(sp)
    2a48:	f022                	sd	s0,32(sp)
    2a4a:	ec26                	sd	s1,24(sp)
    2a4c:	e84a                	sd	s2,16(sp)
    2a4e:	e44e                	sd	s3,8(sp)
    2a50:	e052                	sd	s4,0(sp)
    2a52:	1800                	addi	s0,sp,48
    2a54:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2a56:	4501                	li	a0,0
    2a58:	00003097          	auipc	ra,0x3
    2a5c:	22e080e7          	jalr	558(ra) # 5c86 <sbrk>
    2a60:	892a                	mv	s2,a0
  a = sbrk(0);
    2a62:	4501                	li	a0,0
    2a64:	00003097          	auipc	ra,0x3
    2a68:	222080e7          	jalr	546(ra) # 5c86 <sbrk>
    2a6c:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2a6e:	06400537          	lui	a0,0x6400
    2a72:	9d05                	subw	a0,a0,s1
    2a74:	00003097          	auipc	ra,0x3
    2a78:	212080e7          	jalr	530(ra) # 5c86 <sbrk>
  if (p != a) {
    2a7c:	0ca49863          	bne	s1,a0,2b4c <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2a80:	4501                	li	a0,0
    2a82:	00003097          	auipc	ra,0x3
    2a86:	204080e7          	jalr	516(ra) # 5c86 <sbrk>
    2a8a:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2a8c:	00a4f963          	bgeu	s1,a0,2a9e <sbrkmuch+0x5a>
    *pp = 1;
    2a90:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2a92:	6705                	lui	a4,0x1
    *pp = 1;
    2a94:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2a98:	94ba                	add	s1,s1,a4
    2a9a:	fef4ede3          	bltu	s1,a5,2a94 <sbrkmuch+0x50>
  *lastaddr = 99;
    2a9e:	064007b7          	lui	a5,0x6400
    2aa2:	06300713          	li	a4,99
    2aa6:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0387>
  a = sbrk(0);
    2aaa:	4501                	li	a0,0
    2aac:	00003097          	auipc	ra,0x3
    2ab0:	1da080e7          	jalr	474(ra) # 5c86 <sbrk>
    2ab4:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2ab6:	757d                	lui	a0,0xfffff
    2ab8:	00003097          	auipc	ra,0x3
    2abc:	1ce080e7          	jalr	462(ra) # 5c86 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2ac0:	57fd                	li	a5,-1
    2ac2:	0af50363          	beq	a0,a5,2b68 <sbrkmuch+0x124>
  c = sbrk(0);
    2ac6:	4501                	li	a0,0
    2ac8:	00003097          	auipc	ra,0x3
    2acc:	1be080e7          	jalr	446(ra) # 5c86 <sbrk>
  if(c != a - PGSIZE){
    2ad0:	77fd                	lui	a5,0xfffff
    2ad2:	97a6                	add	a5,a5,s1
    2ad4:	0af51863          	bne	a0,a5,2b84 <sbrkmuch+0x140>
  a = sbrk(0);
    2ad8:	4501                	li	a0,0
    2ada:	00003097          	auipc	ra,0x3
    2ade:	1ac080e7          	jalr	428(ra) # 5c86 <sbrk>
    2ae2:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2ae4:	6505                	lui	a0,0x1
    2ae6:	00003097          	auipc	ra,0x3
    2aea:	1a0080e7          	jalr	416(ra) # 5c86 <sbrk>
    2aee:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2af0:	0aa49a63          	bne	s1,a0,2ba4 <sbrkmuch+0x160>
    2af4:	4501                	li	a0,0
    2af6:	00003097          	auipc	ra,0x3
    2afa:	190080e7          	jalr	400(ra) # 5c86 <sbrk>
    2afe:	6785                	lui	a5,0x1
    2b00:	97a6                	add	a5,a5,s1
    2b02:	0af51163          	bne	a0,a5,2ba4 <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2b06:	064007b7          	lui	a5,0x6400
    2b0a:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0387>
    2b0e:	06300793          	li	a5,99
    2b12:	0af70963          	beq	a4,a5,2bc4 <sbrkmuch+0x180>
  a = sbrk(0);
    2b16:	4501                	li	a0,0
    2b18:	00003097          	auipc	ra,0x3
    2b1c:	16e080e7          	jalr	366(ra) # 5c86 <sbrk>
    2b20:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2b22:	4501                	li	a0,0
    2b24:	00003097          	auipc	ra,0x3
    2b28:	162080e7          	jalr	354(ra) # 5c86 <sbrk>
    2b2c:	40a9053b          	subw	a0,s2,a0
    2b30:	00003097          	auipc	ra,0x3
    2b34:	156080e7          	jalr	342(ra) # 5c86 <sbrk>
  if(c != a){
    2b38:	0aa49463          	bne	s1,a0,2be0 <sbrkmuch+0x19c>
}
    2b3c:	70a2                	ld	ra,40(sp)
    2b3e:	7402                	ld	s0,32(sp)
    2b40:	64e2                	ld	s1,24(sp)
    2b42:	6942                	ld	s2,16(sp)
    2b44:	69a2                	ld	s3,8(sp)
    2b46:	6a02                	ld	s4,0(sp)
    2b48:	6145                	addi	sp,sp,48
    2b4a:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2b4c:	85ce                	mv	a1,s3
    2b4e:	00004517          	auipc	a0,0x4
    2b52:	48250513          	addi	a0,a0,1154 # 6fd0 <malloc+0xf9c>
    2b56:	00003097          	auipc	ra,0x3
    2b5a:	420080e7          	jalr	1056(ra) # 5f76 <printf>
    exit(1);
    2b5e:	4505                	li	a0,1
    2b60:	00003097          	auipc	ra,0x3
    2b64:	09e080e7          	jalr	158(ra) # 5bfe <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2b68:	85ce                	mv	a1,s3
    2b6a:	00004517          	auipc	a0,0x4
    2b6e:	4ae50513          	addi	a0,a0,1198 # 7018 <malloc+0xfe4>
    2b72:	00003097          	auipc	ra,0x3
    2b76:	404080e7          	jalr	1028(ra) # 5f76 <printf>
    exit(1);
    2b7a:	4505                	li	a0,1
    2b7c:	00003097          	auipc	ra,0x3
    2b80:	082080e7          	jalr	130(ra) # 5bfe <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2b84:	86aa                	mv	a3,a0
    2b86:	8626                	mv	a2,s1
    2b88:	85ce                	mv	a1,s3
    2b8a:	00004517          	auipc	a0,0x4
    2b8e:	4ae50513          	addi	a0,a0,1198 # 7038 <malloc+0x1004>
    2b92:	00003097          	auipc	ra,0x3
    2b96:	3e4080e7          	jalr	996(ra) # 5f76 <printf>
    exit(1);
    2b9a:	4505                	li	a0,1
    2b9c:	00003097          	auipc	ra,0x3
    2ba0:	062080e7          	jalr	98(ra) # 5bfe <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2ba4:	86d2                	mv	a3,s4
    2ba6:	8626                	mv	a2,s1
    2ba8:	85ce                	mv	a1,s3
    2baa:	00004517          	auipc	a0,0x4
    2bae:	4ce50513          	addi	a0,a0,1230 # 7078 <malloc+0x1044>
    2bb2:	00003097          	auipc	ra,0x3
    2bb6:	3c4080e7          	jalr	964(ra) # 5f76 <printf>
    exit(1);
    2bba:	4505                	li	a0,1
    2bbc:	00003097          	auipc	ra,0x3
    2bc0:	042080e7          	jalr	66(ra) # 5bfe <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2bc4:	85ce                	mv	a1,s3
    2bc6:	00004517          	auipc	a0,0x4
    2bca:	4e250513          	addi	a0,a0,1250 # 70a8 <malloc+0x1074>
    2bce:	00003097          	auipc	ra,0x3
    2bd2:	3a8080e7          	jalr	936(ra) # 5f76 <printf>
    exit(1);
    2bd6:	4505                	li	a0,1
    2bd8:	00003097          	auipc	ra,0x3
    2bdc:	026080e7          	jalr	38(ra) # 5bfe <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2be0:	86aa                	mv	a3,a0
    2be2:	8626                	mv	a2,s1
    2be4:	85ce                	mv	a1,s3
    2be6:	00004517          	auipc	a0,0x4
    2bea:	4fa50513          	addi	a0,a0,1274 # 70e0 <malloc+0x10ac>
    2bee:	00003097          	auipc	ra,0x3
    2bf2:	388080e7          	jalr	904(ra) # 5f76 <printf>
    exit(1);
    2bf6:	4505                	li	a0,1
    2bf8:	00003097          	auipc	ra,0x3
    2bfc:	006080e7          	jalr	6(ra) # 5bfe <exit>

0000000000002c00 <sbrkarg>:
{
    2c00:	7179                	addi	sp,sp,-48
    2c02:	f406                	sd	ra,40(sp)
    2c04:	f022                	sd	s0,32(sp)
    2c06:	ec26                	sd	s1,24(sp)
    2c08:	e84a                	sd	s2,16(sp)
    2c0a:	e44e                	sd	s3,8(sp)
    2c0c:	1800                	addi	s0,sp,48
    2c0e:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2c10:	6505                	lui	a0,0x1
    2c12:	00003097          	auipc	ra,0x3
    2c16:	074080e7          	jalr	116(ra) # 5c86 <sbrk>
    2c1a:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2c1c:	20100593          	li	a1,513
    2c20:	00004517          	auipc	a0,0x4
    2c24:	4e850513          	addi	a0,a0,1256 # 7108 <malloc+0x10d4>
    2c28:	00003097          	auipc	ra,0x3
    2c2c:	016080e7          	jalr	22(ra) # 5c3e <open>
    2c30:	84aa                	mv	s1,a0
  unlink("sbrk");
    2c32:	00004517          	auipc	a0,0x4
    2c36:	4d650513          	addi	a0,a0,1238 # 7108 <malloc+0x10d4>
    2c3a:	00003097          	auipc	ra,0x3
    2c3e:	014080e7          	jalr	20(ra) # 5c4e <unlink>
  if(fd < 0)  {
    2c42:	0404c163          	bltz	s1,2c84 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2c46:	6605                	lui	a2,0x1
    2c48:	85ca                	mv	a1,s2
    2c4a:	8526                	mv	a0,s1
    2c4c:	00003097          	auipc	ra,0x3
    2c50:	fd2080e7          	jalr	-46(ra) # 5c1e <write>
    2c54:	04054663          	bltz	a0,2ca0 <sbrkarg+0xa0>
  close(fd);
    2c58:	8526                	mv	a0,s1
    2c5a:	00003097          	auipc	ra,0x3
    2c5e:	fcc080e7          	jalr	-52(ra) # 5c26 <close>
  a = sbrk(PGSIZE);
    2c62:	6505                	lui	a0,0x1
    2c64:	00003097          	auipc	ra,0x3
    2c68:	022080e7          	jalr	34(ra) # 5c86 <sbrk>
  if(pipe((int *) a) != 0){
    2c6c:	00003097          	auipc	ra,0x3
    2c70:	fa2080e7          	jalr	-94(ra) # 5c0e <pipe>
    2c74:	e521                	bnez	a0,2cbc <sbrkarg+0xbc>
}
    2c76:	70a2                	ld	ra,40(sp)
    2c78:	7402                	ld	s0,32(sp)
    2c7a:	64e2                	ld	s1,24(sp)
    2c7c:	6942                	ld	s2,16(sp)
    2c7e:	69a2                	ld	s3,8(sp)
    2c80:	6145                	addi	sp,sp,48
    2c82:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2c84:	85ce                	mv	a1,s3
    2c86:	00004517          	auipc	a0,0x4
    2c8a:	48a50513          	addi	a0,a0,1162 # 7110 <malloc+0x10dc>
    2c8e:	00003097          	auipc	ra,0x3
    2c92:	2e8080e7          	jalr	744(ra) # 5f76 <printf>
    exit(1);
    2c96:	4505                	li	a0,1
    2c98:	00003097          	auipc	ra,0x3
    2c9c:	f66080e7          	jalr	-154(ra) # 5bfe <exit>
    printf("%s: write sbrk failed\n", s);
    2ca0:	85ce                	mv	a1,s3
    2ca2:	00004517          	auipc	a0,0x4
    2ca6:	48650513          	addi	a0,a0,1158 # 7128 <malloc+0x10f4>
    2caa:	00003097          	auipc	ra,0x3
    2cae:	2cc080e7          	jalr	716(ra) # 5f76 <printf>
    exit(1);
    2cb2:	4505                	li	a0,1
    2cb4:	00003097          	auipc	ra,0x3
    2cb8:	f4a080e7          	jalr	-182(ra) # 5bfe <exit>
    printf("%s: pipe() failed\n", s);
    2cbc:	85ce                	mv	a1,s3
    2cbe:	00004517          	auipc	a0,0x4
    2cc2:	e4a50513          	addi	a0,a0,-438 # 6b08 <malloc+0xad4>
    2cc6:	00003097          	auipc	ra,0x3
    2cca:	2b0080e7          	jalr	688(ra) # 5f76 <printf>
    exit(1);
    2cce:	4505                	li	a0,1
    2cd0:	00003097          	auipc	ra,0x3
    2cd4:	f2e080e7          	jalr	-210(ra) # 5bfe <exit>

0000000000002cd8 <argptest>:
{
    2cd8:	1101                	addi	sp,sp,-32
    2cda:	ec06                	sd	ra,24(sp)
    2cdc:	e822                	sd	s0,16(sp)
    2cde:	e426                	sd	s1,8(sp)
    2ce0:	e04a                	sd	s2,0(sp)
    2ce2:	1000                	addi	s0,sp,32
    2ce4:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2ce6:	4581                	li	a1,0
    2ce8:	00004517          	auipc	a0,0x4
    2cec:	45850513          	addi	a0,a0,1112 # 7140 <malloc+0x110c>
    2cf0:	00003097          	auipc	ra,0x3
    2cf4:	f4e080e7          	jalr	-178(ra) # 5c3e <open>
  if (fd < 0) {
    2cf8:	02054b63          	bltz	a0,2d2e <argptest+0x56>
    2cfc:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2cfe:	4501                	li	a0,0
    2d00:	00003097          	auipc	ra,0x3
    2d04:	f86080e7          	jalr	-122(ra) # 5c86 <sbrk>
    2d08:	567d                	li	a2,-1
    2d0a:	fff50593          	addi	a1,a0,-1
    2d0e:	8526                	mv	a0,s1
    2d10:	00003097          	auipc	ra,0x3
    2d14:	f06080e7          	jalr	-250(ra) # 5c16 <read>
  close(fd);
    2d18:	8526                	mv	a0,s1
    2d1a:	00003097          	auipc	ra,0x3
    2d1e:	f0c080e7          	jalr	-244(ra) # 5c26 <close>
}
    2d22:	60e2                	ld	ra,24(sp)
    2d24:	6442                	ld	s0,16(sp)
    2d26:	64a2                	ld	s1,8(sp)
    2d28:	6902                	ld	s2,0(sp)
    2d2a:	6105                	addi	sp,sp,32
    2d2c:	8082                	ret
    printf("%s: open failed\n", s);
    2d2e:	85ca                	mv	a1,s2
    2d30:	00004517          	auipc	a0,0x4
    2d34:	ce850513          	addi	a0,a0,-792 # 6a18 <malloc+0x9e4>
    2d38:	00003097          	auipc	ra,0x3
    2d3c:	23e080e7          	jalr	574(ra) # 5f76 <printf>
    exit(1);
    2d40:	4505                	li	a0,1
    2d42:	00003097          	auipc	ra,0x3
    2d46:	ebc080e7          	jalr	-324(ra) # 5bfe <exit>

0000000000002d4a <sbrkbugs>:
{
    2d4a:	1141                	addi	sp,sp,-16
    2d4c:	e406                	sd	ra,8(sp)
    2d4e:	e022                	sd	s0,0(sp)
    2d50:	0800                	addi	s0,sp,16
  int pid = fork();
    2d52:	00003097          	auipc	ra,0x3
    2d56:	ea4080e7          	jalr	-348(ra) # 5bf6 <fork>
  if(pid < 0){
    2d5a:	02054263          	bltz	a0,2d7e <sbrkbugs+0x34>
  if(pid == 0){
    2d5e:	ed0d                	bnez	a0,2d98 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2d60:	00003097          	auipc	ra,0x3
    2d64:	f26080e7          	jalr	-218(ra) # 5c86 <sbrk>
    sbrk(-sz);
    2d68:	40a0053b          	negw	a0,a0
    2d6c:	00003097          	auipc	ra,0x3
    2d70:	f1a080e7          	jalr	-230(ra) # 5c86 <sbrk>
    exit(0);
    2d74:	4501                	li	a0,0
    2d76:	00003097          	auipc	ra,0x3
    2d7a:	e88080e7          	jalr	-376(ra) # 5bfe <exit>
    printf("fork failed\n");
    2d7e:	00004517          	auipc	a0,0x4
    2d82:	08a50513          	addi	a0,a0,138 # 6e08 <malloc+0xdd4>
    2d86:	00003097          	auipc	ra,0x3
    2d8a:	1f0080e7          	jalr	496(ra) # 5f76 <printf>
    exit(1);
    2d8e:	4505                	li	a0,1
    2d90:	00003097          	auipc	ra,0x3
    2d94:	e6e080e7          	jalr	-402(ra) # 5bfe <exit>
  wait(0);
    2d98:	4501                	li	a0,0
    2d9a:	00003097          	auipc	ra,0x3
    2d9e:	e6c080e7          	jalr	-404(ra) # 5c06 <wait>
  pid = fork();
    2da2:	00003097          	auipc	ra,0x3
    2da6:	e54080e7          	jalr	-428(ra) # 5bf6 <fork>
  if(pid < 0){
    2daa:	02054563          	bltz	a0,2dd4 <sbrkbugs+0x8a>
  if(pid == 0){
    2dae:	e121                	bnez	a0,2dee <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2db0:	00003097          	auipc	ra,0x3
    2db4:	ed6080e7          	jalr	-298(ra) # 5c86 <sbrk>
    sbrk(-(sz - 3500));
    2db8:	6785                	lui	a5,0x1
    2dba:	dac7879b          	addiw	a5,a5,-596
    2dbe:	40a7853b          	subw	a0,a5,a0
    2dc2:	00003097          	auipc	ra,0x3
    2dc6:	ec4080e7          	jalr	-316(ra) # 5c86 <sbrk>
    exit(0);
    2dca:	4501                	li	a0,0
    2dcc:	00003097          	auipc	ra,0x3
    2dd0:	e32080e7          	jalr	-462(ra) # 5bfe <exit>
    printf("fork failed\n");
    2dd4:	00004517          	auipc	a0,0x4
    2dd8:	03450513          	addi	a0,a0,52 # 6e08 <malloc+0xdd4>
    2ddc:	00003097          	auipc	ra,0x3
    2de0:	19a080e7          	jalr	410(ra) # 5f76 <printf>
    exit(1);
    2de4:	4505                	li	a0,1
    2de6:	00003097          	auipc	ra,0x3
    2dea:	e18080e7          	jalr	-488(ra) # 5bfe <exit>
  wait(0);
    2dee:	4501                	li	a0,0
    2df0:	00003097          	auipc	ra,0x3
    2df4:	e16080e7          	jalr	-490(ra) # 5c06 <wait>
  pid = fork();
    2df8:	00003097          	auipc	ra,0x3
    2dfc:	dfe080e7          	jalr	-514(ra) # 5bf6 <fork>
  if(pid < 0){
    2e00:	02054a63          	bltz	a0,2e34 <sbrkbugs+0xea>
  if(pid == 0){
    2e04:	e529                	bnez	a0,2e4e <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2e06:	00003097          	auipc	ra,0x3
    2e0a:	e80080e7          	jalr	-384(ra) # 5c86 <sbrk>
    2e0e:	67ad                	lui	a5,0xb
    2e10:	8007879b          	addiw	a5,a5,-2048
    2e14:	40a7853b          	subw	a0,a5,a0
    2e18:	00003097          	auipc	ra,0x3
    2e1c:	e6e080e7          	jalr	-402(ra) # 5c86 <sbrk>
    sbrk(-10);
    2e20:	5559                	li	a0,-10
    2e22:	00003097          	auipc	ra,0x3
    2e26:	e64080e7          	jalr	-412(ra) # 5c86 <sbrk>
    exit(0);
    2e2a:	4501                	li	a0,0
    2e2c:	00003097          	auipc	ra,0x3
    2e30:	dd2080e7          	jalr	-558(ra) # 5bfe <exit>
    printf("fork failed\n");
    2e34:	00004517          	auipc	a0,0x4
    2e38:	fd450513          	addi	a0,a0,-44 # 6e08 <malloc+0xdd4>
    2e3c:	00003097          	auipc	ra,0x3
    2e40:	13a080e7          	jalr	314(ra) # 5f76 <printf>
    exit(1);
    2e44:	4505                	li	a0,1
    2e46:	00003097          	auipc	ra,0x3
    2e4a:	db8080e7          	jalr	-584(ra) # 5bfe <exit>
  wait(0);
    2e4e:	4501                	li	a0,0
    2e50:	00003097          	auipc	ra,0x3
    2e54:	db6080e7          	jalr	-586(ra) # 5c06 <wait>
  exit(0);
    2e58:	4501                	li	a0,0
    2e5a:	00003097          	auipc	ra,0x3
    2e5e:	da4080e7          	jalr	-604(ra) # 5bfe <exit>

0000000000002e62 <sbrklast>:
{
    2e62:	7179                	addi	sp,sp,-48
    2e64:	f406                	sd	ra,40(sp)
    2e66:	f022                	sd	s0,32(sp)
    2e68:	ec26                	sd	s1,24(sp)
    2e6a:	e84a                	sd	s2,16(sp)
    2e6c:	e44e                	sd	s3,8(sp)
    2e6e:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2e70:	4501                	li	a0,0
    2e72:	00003097          	auipc	ra,0x3
    2e76:	e14080e7          	jalr	-492(ra) # 5c86 <sbrk>
  if((top % 4096) != 0)
    2e7a:	03451793          	slli	a5,a0,0x34
    2e7e:	efc1                	bnez	a5,2f16 <sbrklast+0xb4>
  sbrk(4096);
    2e80:	6505                	lui	a0,0x1
    2e82:	00003097          	auipc	ra,0x3
    2e86:	e04080e7          	jalr	-508(ra) # 5c86 <sbrk>
  sbrk(10);
    2e8a:	4529                	li	a0,10
    2e8c:	00003097          	auipc	ra,0x3
    2e90:	dfa080e7          	jalr	-518(ra) # 5c86 <sbrk>
  sbrk(-20);
    2e94:	5531                	li	a0,-20
    2e96:	00003097          	auipc	ra,0x3
    2e9a:	df0080e7          	jalr	-528(ra) # 5c86 <sbrk>
  top = (uint64) sbrk(0);
    2e9e:	4501                	li	a0,0
    2ea0:	00003097          	auipc	ra,0x3
    2ea4:	de6080e7          	jalr	-538(ra) # 5c86 <sbrk>
    2ea8:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2eaa:	fc050913          	addi	s2,a0,-64 # fc0 <linktest+0xc2>
  p[0] = 'x';
    2eae:	07800793          	li	a5,120
    2eb2:	fcf50023          	sb	a5,-64(a0)
  p[1] = '\0';
    2eb6:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2eba:	20200593          	li	a1,514
    2ebe:	854a                	mv	a0,s2
    2ec0:	00003097          	auipc	ra,0x3
    2ec4:	d7e080e7          	jalr	-642(ra) # 5c3e <open>
    2ec8:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2eca:	4605                	li	a2,1
    2ecc:	85ca                	mv	a1,s2
    2ece:	00003097          	auipc	ra,0x3
    2ed2:	d50080e7          	jalr	-688(ra) # 5c1e <write>
  close(fd);
    2ed6:	854e                	mv	a0,s3
    2ed8:	00003097          	auipc	ra,0x3
    2edc:	d4e080e7          	jalr	-690(ra) # 5c26 <close>
  fd = open(p, O_RDWR);
    2ee0:	4589                	li	a1,2
    2ee2:	854a                	mv	a0,s2
    2ee4:	00003097          	auipc	ra,0x3
    2ee8:	d5a080e7          	jalr	-678(ra) # 5c3e <open>
  p[0] = '\0';
    2eec:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2ef0:	4605                	li	a2,1
    2ef2:	85ca                	mv	a1,s2
    2ef4:	00003097          	auipc	ra,0x3
    2ef8:	d22080e7          	jalr	-734(ra) # 5c16 <read>
  if(p[0] != 'x')
    2efc:	fc04c703          	lbu	a4,-64(s1)
    2f00:	07800793          	li	a5,120
    2f04:	02f71363          	bne	a4,a5,2f2a <sbrklast+0xc8>
}
    2f08:	70a2                	ld	ra,40(sp)
    2f0a:	7402                	ld	s0,32(sp)
    2f0c:	64e2                	ld	s1,24(sp)
    2f0e:	6942                	ld	s2,16(sp)
    2f10:	69a2                	ld	s3,8(sp)
    2f12:	6145                	addi	sp,sp,48
    2f14:	8082                	ret
    sbrk(4096 - (top % 4096));
    2f16:	0347d513          	srli	a0,a5,0x34
    2f1a:	6785                	lui	a5,0x1
    2f1c:	40a7853b          	subw	a0,a5,a0
    2f20:	00003097          	auipc	ra,0x3
    2f24:	d66080e7          	jalr	-666(ra) # 5c86 <sbrk>
    2f28:	bfa1                	j	2e80 <sbrklast+0x1e>
    exit(1);
    2f2a:	4505                	li	a0,1
    2f2c:	00003097          	auipc	ra,0x3
    2f30:	cd2080e7          	jalr	-814(ra) # 5bfe <exit>

0000000000002f34 <sbrk8000>:
{
    2f34:	1141                	addi	sp,sp,-16
    2f36:	e406                	sd	ra,8(sp)
    2f38:	e022                	sd	s0,0(sp)
    2f3a:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2f3c:	80000537          	lui	a0,0x80000
    2f40:	0511                	addi	a0,a0,4
    2f42:	00003097          	auipc	ra,0x3
    2f46:	d44080e7          	jalr	-700(ra) # 5c86 <sbrk>
  volatile char *top = sbrk(0);
    2f4a:	4501                	li	a0,0
    2f4c:	00003097          	auipc	ra,0x3
    2f50:	d3a080e7          	jalr	-710(ra) # 5c86 <sbrk>
  *(top-1) = *(top-1) + 1;
    2f54:	fff54783          	lbu	a5,-1(a0) # ffffffff7fffffff <base+0xffffffff7fff0387>
    2f58:	0785                	addi	a5,a5,1
    2f5a:	0ff7f793          	andi	a5,a5,255
    2f5e:	fef50fa3          	sb	a5,-1(a0)
}
    2f62:	60a2                	ld	ra,8(sp)
    2f64:	6402                	ld	s0,0(sp)
    2f66:	0141                	addi	sp,sp,16
    2f68:	8082                	ret

0000000000002f6a <execout>:
{
    2f6a:	715d                	addi	sp,sp,-80
    2f6c:	e486                	sd	ra,72(sp)
    2f6e:	e0a2                	sd	s0,64(sp)
    2f70:	fc26                	sd	s1,56(sp)
    2f72:	f84a                	sd	s2,48(sp)
    2f74:	f44e                	sd	s3,40(sp)
    2f76:	f052                	sd	s4,32(sp)
    2f78:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2f7a:	4901                	li	s2,0
    2f7c:	49bd                	li	s3,15
    int pid = fork();
    2f7e:	00003097          	auipc	ra,0x3
    2f82:	c78080e7          	jalr	-904(ra) # 5bf6 <fork>
    2f86:	84aa                	mv	s1,a0
    if(pid < 0){
    2f88:	02054063          	bltz	a0,2fa8 <execout+0x3e>
    } else if(pid == 0){
    2f8c:	c91d                	beqz	a0,2fc2 <execout+0x58>
      wait((int*)0);
    2f8e:	4501                	li	a0,0
    2f90:	00003097          	auipc	ra,0x3
    2f94:	c76080e7          	jalr	-906(ra) # 5c06 <wait>
  for(int avail = 0; avail < 15; avail++){
    2f98:	2905                	addiw	s2,s2,1
    2f9a:	ff3912e3          	bne	s2,s3,2f7e <execout+0x14>
  exit(0);
    2f9e:	4501                	li	a0,0
    2fa0:	00003097          	auipc	ra,0x3
    2fa4:	c5e080e7          	jalr	-930(ra) # 5bfe <exit>
      printf("fork failed\n");
    2fa8:	00004517          	auipc	a0,0x4
    2fac:	e6050513          	addi	a0,a0,-416 # 6e08 <malloc+0xdd4>
    2fb0:	00003097          	auipc	ra,0x3
    2fb4:	fc6080e7          	jalr	-58(ra) # 5f76 <printf>
      exit(1);
    2fb8:	4505                	li	a0,1
    2fba:	00003097          	auipc	ra,0x3
    2fbe:	c44080e7          	jalr	-956(ra) # 5bfe <exit>
        if(a == 0xffffffffffffffffLL)
    2fc2:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2fc4:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2fc6:	6505                	lui	a0,0x1
    2fc8:	00003097          	auipc	ra,0x3
    2fcc:	cbe080e7          	jalr	-834(ra) # 5c86 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2fd0:	01350763          	beq	a0,s3,2fde <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2fd4:	6785                	lui	a5,0x1
    2fd6:	953e                	add	a0,a0,a5
    2fd8:	ff450fa3          	sb	s4,-1(a0) # fff <linktest+0x101>
      while(1){
    2fdc:	b7ed                	j	2fc6 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2fde:	01205a63          	blez	s2,2ff2 <execout+0x88>
        sbrk(-4096);
    2fe2:	757d                	lui	a0,0xfffff
    2fe4:	00003097          	auipc	ra,0x3
    2fe8:	ca2080e7          	jalr	-862(ra) # 5c86 <sbrk>
      for(int i = 0; i < avail; i++)
    2fec:	2485                	addiw	s1,s1,1
    2fee:	ff249ae3          	bne	s1,s2,2fe2 <execout+0x78>
      close(1);
    2ff2:	4505                	li	a0,1
    2ff4:	00003097          	auipc	ra,0x3
    2ff8:	c32080e7          	jalr	-974(ra) # 5c26 <close>
      char *args[] = { "echo", "x", 0 };
    2ffc:	00003517          	auipc	a0,0x3
    3000:	17c50513          	addi	a0,a0,380 # 6178 <malloc+0x144>
    3004:	faa43c23          	sd	a0,-72(s0)
    3008:	00003797          	auipc	a5,0x3
    300c:	1e078793          	addi	a5,a5,480 # 61e8 <malloc+0x1b4>
    3010:	fcf43023          	sd	a5,-64(s0)
    3014:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    3018:	fb840593          	addi	a1,s0,-72
    301c:	00003097          	auipc	ra,0x3
    3020:	c1a080e7          	jalr	-998(ra) # 5c36 <exec>
      exit(0);
    3024:	4501                	li	a0,0
    3026:	00003097          	auipc	ra,0x3
    302a:	bd8080e7          	jalr	-1064(ra) # 5bfe <exit>

000000000000302e <fourteen>:
{
    302e:	1101                	addi	sp,sp,-32
    3030:	ec06                	sd	ra,24(sp)
    3032:	e822                	sd	s0,16(sp)
    3034:	e426                	sd	s1,8(sp)
    3036:	1000                	addi	s0,sp,32
    3038:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    303a:	00004517          	auipc	a0,0x4
    303e:	2de50513          	addi	a0,a0,734 # 7318 <malloc+0x12e4>
    3042:	00003097          	auipc	ra,0x3
    3046:	c24080e7          	jalr	-988(ra) # 5c66 <mkdir>
    304a:	e165                	bnez	a0,312a <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    304c:	00004517          	auipc	a0,0x4
    3050:	12450513          	addi	a0,a0,292 # 7170 <malloc+0x113c>
    3054:	00003097          	auipc	ra,0x3
    3058:	c12080e7          	jalr	-1006(ra) # 5c66 <mkdir>
    305c:	e56d                	bnez	a0,3146 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    305e:	20000593          	li	a1,512
    3062:	00004517          	auipc	a0,0x4
    3066:	16650513          	addi	a0,a0,358 # 71c8 <malloc+0x1194>
    306a:	00003097          	auipc	ra,0x3
    306e:	bd4080e7          	jalr	-1068(ra) # 5c3e <open>
  if(fd < 0){
    3072:	0e054863          	bltz	a0,3162 <fourteen+0x134>
  close(fd);
    3076:	00003097          	auipc	ra,0x3
    307a:	bb0080e7          	jalr	-1104(ra) # 5c26 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    307e:	4581                	li	a1,0
    3080:	00004517          	auipc	a0,0x4
    3084:	1c050513          	addi	a0,a0,448 # 7240 <malloc+0x120c>
    3088:	00003097          	auipc	ra,0x3
    308c:	bb6080e7          	jalr	-1098(ra) # 5c3e <open>
  if(fd < 0){
    3090:	0e054763          	bltz	a0,317e <fourteen+0x150>
  close(fd);
    3094:	00003097          	auipc	ra,0x3
    3098:	b92080e7          	jalr	-1134(ra) # 5c26 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    309c:	00004517          	auipc	a0,0x4
    30a0:	21450513          	addi	a0,a0,532 # 72b0 <malloc+0x127c>
    30a4:	00003097          	auipc	ra,0x3
    30a8:	bc2080e7          	jalr	-1086(ra) # 5c66 <mkdir>
    30ac:	c57d                	beqz	a0,319a <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    30ae:	00004517          	auipc	a0,0x4
    30b2:	25a50513          	addi	a0,a0,602 # 7308 <malloc+0x12d4>
    30b6:	00003097          	auipc	ra,0x3
    30ba:	bb0080e7          	jalr	-1104(ra) # 5c66 <mkdir>
    30be:	cd65                	beqz	a0,31b6 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    30c0:	00004517          	auipc	a0,0x4
    30c4:	24850513          	addi	a0,a0,584 # 7308 <malloc+0x12d4>
    30c8:	00003097          	auipc	ra,0x3
    30cc:	b86080e7          	jalr	-1146(ra) # 5c4e <unlink>
  unlink("12345678901234/12345678901234");
    30d0:	00004517          	auipc	a0,0x4
    30d4:	1e050513          	addi	a0,a0,480 # 72b0 <malloc+0x127c>
    30d8:	00003097          	auipc	ra,0x3
    30dc:	b76080e7          	jalr	-1162(ra) # 5c4e <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    30e0:	00004517          	auipc	a0,0x4
    30e4:	16050513          	addi	a0,a0,352 # 7240 <malloc+0x120c>
    30e8:	00003097          	auipc	ra,0x3
    30ec:	b66080e7          	jalr	-1178(ra) # 5c4e <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    30f0:	00004517          	auipc	a0,0x4
    30f4:	0d850513          	addi	a0,a0,216 # 71c8 <malloc+0x1194>
    30f8:	00003097          	auipc	ra,0x3
    30fc:	b56080e7          	jalr	-1194(ra) # 5c4e <unlink>
  unlink("12345678901234/123456789012345");
    3100:	00004517          	auipc	a0,0x4
    3104:	07050513          	addi	a0,a0,112 # 7170 <malloc+0x113c>
    3108:	00003097          	auipc	ra,0x3
    310c:	b46080e7          	jalr	-1210(ra) # 5c4e <unlink>
  unlink("12345678901234");
    3110:	00004517          	auipc	a0,0x4
    3114:	20850513          	addi	a0,a0,520 # 7318 <malloc+0x12e4>
    3118:	00003097          	auipc	ra,0x3
    311c:	b36080e7          	jalr	-1226(ra) # 5c4e <unlink>
}
    3120:	60e2                	ld	ra,24(sp)
    3122:	6442                	ld	s0,16(sp)
    3124:	64a2                	ld	s1,8(sp)
    3126:	6105                	addi	sp,sp,32
    3128:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    312a:	85a6                	mv	a1,s1
    312c:	00004517          	auipc	a0,0x4
    3130:	01c50513          	addi	a0,a0,28 # 7148 <malloc+0x1114>
    3134:	00003097          	auipc	ra,0x3
    3138:	e42080e7          	jalr	-446(ra) # 5f76 <printf>
    exit(1);
    313c:	4505                	li	a0,1
    313e:	00003097          	auipc	ra,0x3
    3142:	ac0080e7          	jalr	-1344(ra) # 5bfe <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    3146:	85a6                	mv	a1,s1
    3148:	00004517          	auipc	a0,0x4
    314c:	04850513          	addi	a0,a0,72 # 7190 <malloc+0x115c>
    3150:	00003097          	auipc	ra,0x3
    3154:	e26080e7          	jalr	-474(ra) # 5f76 <printf>
    exit(1);
    3158:	4505                	li	a0,1
    315a:	00003097          	auipc	ra,0x3
    315e:	aa4080e7          	jalr	-1372(ra) # 5bfe <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    3162:	85a6                	mv	a1,s1
    3164:	00004517          	auipc	a0,0x4
    3168:	09450513          	addi	a0,a0,148 # 71f8 <malloc+0x11c4>
    316c:	00003097          	auipc	ra,0x3
    3170:	e0a080e7          	jalr	-502(ra) # 5f76 <printf>
    exit(1);
    3174:	4505                	li	a0,1
    3176:	00003097          	auipc	ra,0x3
    317a:	a88080e7          	jalr	-1400(ra) # 5bfe <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    317e:	85a6                	mv	a1,s1
    3180:	00004517          	auipc	a0,0x4
    3184:	0f050513          	addi	a0,a0,240 # 7270 <malloc+0x123c>
    3188:	00003097          	auipc	ra,0x3
    318c:	dee080e7          	jalr	-530(ra) # 5f76 <printf>
    exit(1);
    3190:	4505                	li	a0,1
    3192:	00003097          	auipc	ra,0x3
    3196:	a6c080e7          	jalr	-1428(ra) # 5bfe <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    319a:	85a6                	mv	a1,s1
    319c:	00004517          	auipc	a0,0x4
    31a0:	13450513          	addi	a0,a0,308 # 72d0 <malloc+0x129c>
    31a4:	00003097          	auipc	ra,0x3
    31a8:	dd2080e7          	jalr	-558(ra) # 5f76 <printf>
    exit(1);
    31ac:	4505                	li	a0,1
    31ae:	00003097          	auipc	ra,0x3
    31b2:	a50080e7          	jalr	-1456(ra) # 5bfe <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    31b6:	85a6                	mv	a1,s1
    31b8:	00004517          	auipc	a0,0x4
    31bc:	17050513          	addi	a0,a0,368 # 7328 <malloc+0x12f4>
    31c0:	00003097          	auipc	ra,0x3
    31c4:	db6080e7          	jalr	-586(ra) # 5f76 <printf>
    exit(1);
    31c8:	4505                	li	a0,1
    31ca:	00003097          	auipc	ra,0x3
    31ce:	a34080e7          	jalr	-1484(ra) # 5bfe <exit>

00000000000031d2 <diskfull>:
{
    31d2:	b8010113          	addi	sp,sp,-1152
    31d6:	46113c23          	sd	ra,1144(sp)
    31da:	46813823          	sd	s0,1136(sp)
    31de:	46913423          	sd	s1,1128(sp)
    31e2:	47213023          	sd	s2,1120(sp)
    31e6:	45313c23          	sd	s3,1112(sp)
    31ea:	45413823          	sd	s4,1104(sp)
    31ee:	45513423          	sd	s5,1096(sp)
    31f2:	45613023          	sd	s6,1088(sp)
    31f6:	43713c23          	sd	s7,1080(sp)
    31fa:	43813823          	sd	s8,1072(sp)
    31fe:	43913423          	sd	s9,1064(sp)
    3202:	48010413          	addi	s0,sp,1152
    3206:	8caa                	mv	s9,a0
  unlink("diskfulldir");
    3208:	00004517          	auipc	a0,0x4
    320c:	15850513          	addi	a0,a0,344 # 7360 <malloc+0x132c>
    3210:	00003097          	auipc	ra,0x3
    3214:	a3e080e7          	jalr	-1474(ra) # 5c4e <unlink>
    3218:	03000993          	li	s3,48
    name[0] = 'b';
    321c:	06200b13          	li	s6,98
    name[1] = 'i';
    3220:	06900a93          	li	s5,105
    name[2] = 'g';
    3224:	06700a13          	li	s4,103
    3228:	10c00b93          	li	s7,268
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    322c:	07f00c13          	li	s8,127
    3230:	a269                	j	33ba <diskfull+0x1e8>
      printf("%s: could not create file %s\n", s, name);
    3232:	b8040613          	addi	a2,s0,-1152
    3236:	85e6                	mv	a1,s9
    3238:	00004517          	auipc	a0,0x4
    323c:	13850513          	addi	a0,a0,312 # 7370 <malloc+0x133c>
    3240:	00003097          	auipc	ra,0x3
    3244:	d36080e7          	jalr	-714(ra) # 5f76 <printf>
      break;
    3248:	a819                	j	325e <diskfull+0x8c>
        close(fd);
    324a:	854a                	mv	a0,s2
    324c:	00003097          	auipc	ra,0x3
    3250:	9da080e7          	jalr	-1574(ra) # 5c26 <close>
    close(fd);
    3254:	854a                	mv	a0,s2
    3256:	00003097          	auipc	ra,0x3
    325a:	9d0080e7          	jalr	-1584(ra) # 5c26 <close>
  for(int i = 0; i < nzz; i++){
    325e:	4481                	li	s1,0
    name[0] = 'z';
    3260:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3264:	08000993          	li	s3,128
    name[0] = 'z';
    3268:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    326c:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    3270:	41f4d79b          	sraiw	a5,s1,0x1f
    3274:	01b7d71b          	srliw	a4,a5,0x1b
    3278:	009707bb          	addw	a5,a4,s1
    327c:	4057d69b          	sraiw	a3,a5,0x5
    3280:	0306869b          	addiw	a3,a3,48
    3284:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    3288:	8bfd                	andi	a5,a5,31
    328a:	9f99                	subw	a5,a5,a4
    328c:	0307879b          	addiw	a5,a5,48
    3290:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    3294:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    3298:	ba040513          	addi	a0,s0,-1120
    329c:	00003097          	auipc	ra,0x3
    32a0:	9b2080e7          	jalr	-1614(ra) # 5c4e <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    32a4:	60200593          	li	a1,1538
    32a8:	ba040513          	addi	a0,s0,-1120
    32ac:	00003097          	auipc	ra,0x3
    32b0:	992080e7          	jalr	-1646(ra) # 5c3e <open>
    if(fd < 0)
    32b4:	00054963          	bltz	a0,32c6 <diskfull+0xf4>
    close(fd);
    32b8:	00003097          	auipc	ra,0x3
    32bc:	96e080e7          	jalr	-1682(ra) # 5c26 <close>
  for(int i = 0; i < nzz; i++){
    32c0:	2485                	addiw	s1,s1,1
    32c2:	fb3493e3          	bne	s1,s3,3268 <diskfull+0x96>
  if(mkdir("diskfulldir") == 0)
    32c6:	00004517          	auipc	a0,0x4
    32ca:	09a50513          	addi	a0,a0,154 # 7360 <malloc+0x132c>
    32ce:	00003097          	auipc	ra,0x3
    32d2:	998080e7          	jalr	-1640(ra) # 5c66 <mkdir>
    32d6:	12050e63          	beqz	a0,3412 <diskfull+0x240>
  unlink("diskfulldir");
    32da:	00004517          	auipc	a0,0x4
    32de:	08650513          	addi	a0,a0,134 # 7360 <malloc+0x132c>
    32e2:	00003097          	auipc	ra,0x3
    32e6:	96c080e7          	jalr	-1684(ra) # 5c4e <unlink>
  for(int i = 0; i < nzz; i++){
    32ea:	4481                	li	s1,0
    name[0] = 'z';
    32ec:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    32f0:	08000993          	li	s3,128
    name[0] = 'z';
    32f4:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    32f8:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    32fc:	41f4d79b          	sraiw	a5,s1,0x1f
    3300:	01b7d71b          	srliw	a4,a5,0x1b
    3304:	009707bb          	addw	a5,a4,s1
    3308:	4057d69b          	sraiw	a3,a5,0x5
    330c:	0306869b          	addiw	a3,a3,48
    3310:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    3314:	8bfd                	andi	a5,a5,31
    3316:	9f99                	subw	a5,a5,a4
    3318:	0307879b          	addiw	a5,a5,48
    331c:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    3320:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    3324:	ba040513          	addi	a0,s0,-1120
    3328:	00003097          	auipc	ra,0x3
    332c:	926080e7          	jalr	-1754(ra) # 5c4e <unlink>
  for(int i = 0; i < nzz; i++){
    3330:	2485                	addiw	s1,s1,1
    3332:	fd3491e3          	bne	s1,s3,32f4 <diskfull+0x122>
    3336:	03000493          	li	s1,48
    name[0] = 'b';
    333a:	06200a93          	li	s5,98
    name[1] = 'i';
    333e:	06900a13          	li	s4,105
    name[2] = 'g';
    3342:	06700993          	li	s3,103
  for(int i = 0; '0' + i < 0177; i++){
    3346:	07f00913          	li	s2,127
    name[0] = 'b';
    334a:	bb540023          	sb	s5,-1120(s0)
    name[1] = 'i';
    334e:	bb4400a3          	sb	s4,-1119(s0)
    name[2] = 'g';
    3352:	bb340123          	sb	s3,-1118(s0)
    name[3] = '0' + i;
    3356:	ba9401a3          	sb	s1,-1117(s0)
    name[4] = '\0';
    335a:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    335e:	ba040513          	addi	a0,s0,-1120
    3362:	00003097          	auipc	ra,0x3
    3366:	8ec080e7          	jalr	-1812(ra) # 5c4e <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    336a:	2485                	addiw	s1,s1,1
    336c:	0ff4f493          	andi	s1,s1,255
    3370:	fd249de3          	bne	s1,s2,334a <diskfull+0x178>
}
    3374:	47813083          	ld	ra,1144(sp)
    3378:	47013403          	ld	s0,1136(sp)
    337c:	46813483          	ld	s1,1128(sp)
    3380:	46013903          	ld	s2,1120(sp)
    3384:	45813983          	ld	s3,1112(sp)
    3388:	45013a03          	ld	s4,1104(sp)
    338c:	44813a83          	ld	s5,1096(sp)
    3390:	44013b03          	ld	s6,1088(sp)
    3394:	43813b83          	ld	s7,1080(sp)
    3398:	43013c03          	ld	s8,1072(sp)
    339c:	42813c83          	ld	s9,1064(sp)
    33a0:	48010113          	addi	sp,sp,1152
    33a4:	8082                	ret
    close(fd);
    33a6:	854a                	mv	a0,s2
    33a8:	00003097          	auipc	ra,0x3
    33ac:	87e080e7          	jalr	-1922(ra) # 5c26 <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    33b0:	2985                	addiw	s3,s3,1
    33b2:	0ff9f993          	andi	s3,s3,255
    33b6:	eb8984e3          	beq	s3,s8,325e <diskfull+0x8c>
    name[0] = 'b';
    33ba:	b9640023          	sb	s6,-1152(s0)
    name[1] = 'i';
    33be:	b95400a3          	sb	s5,-1151(s0)
    name[2] = 'g';
    33c2:	b9440123          	sb	s4,-1150(s0)
    name[3] = '0' + fi;
    33c6:	b93401a3          	sb	s3,-1149(s0)
    name[4] = '\0';
    33ca:	b8040223          	sb	zero,-1148(s0)
    unlink(name);
    33ce:	b8040513          	addi	a0,s0,-1152
    33d2:	00003097          	auipc	ra,0x3
    33d6:	87c080e7          	jalr	-1924(ra) # 5c4e <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    33da:	60200593          	li	a1,1538
    33de:	b8040513          	addi	a0,s0,-1152
    33e2:	00003097          	auipc	ra,0x3
    33e6:	85c080e7          	jalr	-1956(ra) # 5c3e <open>
    33ea:	892a                	mv	s2,a0
    if(fd < 0){
    33ec:	e40543e3          	bltz	a0,3232 <diskfull+0x60>
    33f0:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    33f2:	40000613          	li	a2,1024
    33f6:	ba040593          	addi	a1,s0,-1120
    33fa:	854a                	mv	a0,s2
    33fc:	00003097          	auipc	ra,0x3
    3400:	822080e7          	jalr	-2014(ra) # 5c1e <write>
    3404:	40000793          	li	a5,1024
    3408:	e4f511e3          	bne	a0,a5,324a <diskfull+0x78>
    for(int i = 0; i < MAXFILE; i++){
    340c:	34fd                	addiw	s1,s1,-1
    340e:	f0f5                	bnez	s1,33f2 <diskfull+0x220>
    3410:	bf59                	j	33a6 <diskfull+0x1d4>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    3412:	00004517          	auipc	a0,0x4
    3416:	f7e50513          	addi	a0,a0,-130 # 7390 <malloc+0x135c>
    341a:	00003097          	auipc	ra,0x3
    341e:	b5c080e7          	jalr	-1188(ra) # 5f76 <printf>
    3422:	bd65                	j	32da <diskfull+0x108>

0000000000003424 <iputtest>:
{
    3424:	1101                	addi	sp,sp,-32
    3426:	ec06                	sd	ra,24(sp)
    3428:	e822                	sd	s0,16(sp)
    342a:	e426                	sd	s1,8(sp)
    342c:	1000                	addi	s0,sp,32
    342e:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    3430:	00004517          	auipc	a0,0x4
    3434:	f9050513          	addi	a0,a0,-112 # 73c0 <malloc+0x138c>
    3438:	00003097          	auipc	ra,0x3
    343c:	82e080e7          	jalr	-2002(ra) # 5c66 <mkdir>
    3440:	04054563          	bltz	a0,348a <iputtest+0x66>
  if(chdir("iputdir") < 0){
    3444:	00004517          	auipc	a0,0x4
    3448:	f7c50513          	addi	a0,a0,-132 # 73c0 <malloc+0x138c>
    344c:	00003097          	auipc	ra,0x3
    3450:	822080e7          	jalr	-2014(ra) # 5c6e <chdir>
    3454:	04054963          	bltz	a0,34a6 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    3458:	00004517          	auipc	a0,0x4
    345c:	fa850513          	addi	a0,a0,-88 # 7400 <malloc+0x13cc>
    3460:	00002097          	auipc	ra,0x2
    3464:	7ee080e7          	jalr	2030(ra) # 5c4e <unlink>
    3468:	04054d63          	bltz	a0,34c2 <iputtest+0x9e>
  if(chdir("/") < 0){
    346c:	00004517          	auipc	a0,0x4
    3470:	fc450513          	addi	a0,a0,-60 # 7430 <malloc+0x13fc>
    3474:	00002097          	auipc	ra,0x2
    3478:	7fa080e7          	jalr	2042(ra) # 5c6e <chdir>
    347c:	06054163          	bltz	a0,34de <iputtest+0xba>
}
    3480:	60e2                	ld	ra,24(sp)
    3482:	6442                	ld	s0,16(sp)
    3484:	64a2                	ld	s1,8(sp)
    3486:	6105                	addi	sp,sp,32
    3488:	8082                	ret
    printf("%s: mkdir failed\n", s);
    348a:	85a6                	mv	a1,s1
    348c:	00004517          	auipc	a0,0x4
    3490:	f3c50513          	addi	a0,a0,-196 # 73c8 <malloc+0x1394>
    3494:	00003097          	auipc	ra,0x3
    3498:	ae2080e7          	jalr	-1310(ra) # 5f76 <printf>
    exit(1);
    349c:	4505                	li	a0,1
    349e:	00002097          	auipc	ra,0x2
    34a2:	760080e7          	jalr	1888(ra) # 5bfe <exit>
    printf("%s: chdir iputdir failed\n", s);
    34a6:	85a6                	mv	a1,s1
    34a8:	00004517          	auipc	a0,0x4
    34ac:	f3850513          	addi	a0,a0,-200 # 73e0 <malloc+0x13ac>
    34b0:	00003097          	auipc	ra,0x3
    34b4:	ac6080e7          	jalr	-1338(ra) # 5f76 <printf>
    exit(1);
    34b8:	4505                	li	a0,1
    34ba:	00002097          	auipc	ra,0x2
    34be:	744080e7          	jalr	1860(ra) # 5bfe <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    34c2:	85a6                	mv	a1,s1
    34c4:	00004517          	auipc	a0,0x4
    34c8:	f4c50513          	addi	a0,a0,-180 # 7410 <malloc+0x13dc>
    34cc:	00003097          	auipc	ra,0x3
    34d0:	aaa080e7          	jalr	-1366(ra) # 5f76 <printf>
    exit(1);
    34d4:	4505                	li	a0,1
    34d6:	00002097          	auipc	ra,0x2
    34da:	728080e7          	jalr	1832(ra) # 5bfe <exit>
    printf("%s: chdir / failed\n", s);
    34de:	85a6                	mv	a1,s1
    34e0:	00004517          	auipc	a0,0x4
    34e4:	f5850513          	addi	a0,a0,-168 # 7438 <malloc+0x1404>
    34e8:	00003097          	auipc	ra,0x3
    34ec:	a8e080e7          	jalr	-1394(ra) # 5f76 <printf>
    exit(1);
    34f0:	4505                	li	a0,1
    34f2:	00002097          	auipc	ra,0x2
    34f6:	70c080e7          	jalr	1804(ra) # 5bfe <exit>

00000000000034fa <exitiputtest>:
{
    34fa:	7179                	addi	sp,sp,-48
    34fc:	f406                	sd	ra,40(sp)
    34fe:	f022                	sd	s0,32(sp)
    3500:	ec26                	sd	s1,24(sp)
    3502:	1800                	addi	s0,sp,48
    3504:	84aa                	mv	s1,a0
  pid = fork();
    3506:	00002097          	auipc	ra,0x2
    350a:	6f0080e7          	jalr	1776(ra) # 5bf6 <fork>
  if(pid < 0){
    350e:	04054663          	bltz	a0,355a <exitiputtest+0x60>
  if(pid == 0){
    3512:	ed45                	bnez	a0,35ca <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    3514:	00004517          	auipc	a0,0x4
    3518:	eac50513          	addi	a0,a0,-340 # 73c0 <malloc+0x138c>
    351c:	00002097          	auipc	ra,0x2
    3520:	74a080e7          	jalr	1866(ra) # 5c66 <mkdir>
    3524:	04054963          	bltz	a0,3576 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    3528:	00004517          	auipc	a0,0x4
    352c:	e9850513          	addi	a0,a0,-360 # 73c0 <malloc+0x138c>
    3530:	00002097          	auipc	ra,0x2
    3534:	73e080e7          	jalr	1854(ra) # 5c6e <chdir>
    3538:	04054d63          	bltz	a0,3592 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    353c:	00004517          	auipc	a0,0x4
    3540:	ec450513          	addi	a0,a0,-316 # 7400 <malloc+0x13cc>
    3544:	00002097          	auipc	ra,0x2
    3548:	70a080e7          	jalr	1802(ra) # 5c4e <unlink>
    354c:	06054163          	bltz	a0,35ae <exitiputtest+0xb4>
    exit(0);
    3550:	4501                	li	a0,0
    3552:	00002097          	auipc	ra,0x2
    3556:	6ac080e7          	jalr	1708(ra) # 5bfe <exit>
    printf("%s: fork failed\n", s);
    355a:	85a6                	mv	a1,s1
    355c:	00003517          	auipc	a0,0x3
    3560:	4a450513          	addi	a0,a0,1188 # 6a00 <malloc+0x9cc>
    3564:	00003097          	auipc	ra,0x3
    3568:	a12080e7          	jalr	-1518(ra) # 5f76 <printf>
    exit(1);
    356c:	4505                	li	a0,1
    356e:	00002097          	auipc	ra,0x2
    3572:	690080e7          	jalr	1680(ra) # 5bfe <exit>
      printf("%s: mkdir failed\n", s);
    3576:	85a6                	mv	a1,s1
    3578:	00004517          	auipc	a0,0x4
    357c:	e5050513          	addi	a0,a0,-432 # 73c8 <malloc+0x1394>
    3580:	00003097          	auipc	ra,0x3
    3584:	9f6080e7          	jalr	-1546(ra) # 5f76 <printf>
      exit(1);
    3588:	4505                	li	a0,1
    358a:	00002097          	auipc	ra,0x2
    358e:	674080e7          	jalr	1652(ra) # 5bfe <exit>
      printf("%s: child chdir failed\n", s);
    3592:	85a6                	mv	a1,s1
    3594:	00004517          	auipc	a0,0x4
    3598:	ebc50513          	addi	a0,a0,-324 # 7450 <malloc+0x141c>
    359c:	00003097          	auipc	ra,0x3
    35a0:	9da080e7          	jalr	-1574(ra) # 5f76 <printf>
      exit(1);
    35a4:	4505                	li	a0,1
    35a6:	00002097          	auipc	ra,0x2
    35aa:	658080e7          	jalr	1624(ra) # 5bfe <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    35ae:	85a6                	mv	a1,s1
    35b0:	00004517          	auipc	a0,0x4
    35b4:	e6050513          	addi	a0,a0,-416 # 7410 <malloc+0x13dc>
    35b8:	00003097          	auipc	ra,0x3
    35bc:	9be080e7          	jalr	-1602(ra) # 5f76 <printf>
      exit(1);
    35c0:	4505                	li	a0,1
    35c2:	00002097          	auipc	ra,0x2
    35c6:	63c080e7          	jalr	1596(ra) # 5bfe <exit>
  wait(&xstatus);
    35ca:	fdc40513          	addi	a0,s0,-36
    35ce:	00002097          	auipc	ra,0x2
    35d2:	638080e7          	jalr	1592(ra) # 5c06 <wait>
  exit(xstatus);
    35d6:	fdc42503          	lw	a0,-36(s0)
    35da:	00002097          	auipc	ra,0x2
    35de:	624080e7          	jalr	1572(ra) # 5bfe <exit>

00000000000035e2 <dirtest>:
{
    35e2:	1101                	addi	sp,sp,-32
    35e4:	ec06                	sd	ra,24(sp)
    35e6:	e822                	sd	s0,16(sp)
    35e8:	e426                	sd	s1,8(sp)
    35ea:	1000                	addi	s0,sp,32
    35ec:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    35ee:	00004517          	auipc	a0,0x4
    35f2:	e7a50513          	addi	a0,a0,-390 # 7468 <malloc+0x1434>
    35f6:	00002097          	auipc	ra,0x2
    35fa:	670080e7          	jalr	1648(ra) # 5c66 <mkdir>
    35fe:	04054563          	bltz	a0,3648 <dirtest+0x66>
  if(chdir("dir0") < 0){
    3602:	00004517          	auipc	a0,0x4
    3606:	e6650513          	addi	a0,a0,-410 # 7468 <malloc+0x1434>
    360a:	00002097          	auipc	ra,0x2
    360e:	664080e7          	jalr	1636(ra) # 5c6e <chdir>
    3612:	04054963          	bltz	a0,3664 <dirtest+0x82>
  if(chdir("..") < 0){
    3616:	00004517          	auipc	a0,0x4
    361a:	e7250513          	addi	a0,a0,-398 # 7488 <malloc+0x1454>
    361e:	00002097          	auipc	ra,0x2
    3622:	650080e7          	jalr	1616(ra) # 5c6e <chdir>
    3626:	04054d63          	bltz	a0,3680 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    362a:	00004517          	auipc	a0,0x4
    362e:	e3e50513          	addi	a0,a0,-450 # 7468 <malloc+0x1434>
    3632:	00002097          	auipc	ra,0x2
    3636:	61c080e7          	jalr	1564(ra) # 5c4e <unlink>
    363a:	06054163          	bltz	a0,369c <dirtest+0xba>
}
    363e:	60e2                	ld	ra,24(sp)
    3640:	6442                	ld	s0,16(sp)
    3642:	64a2                	ld	s1,8(sp)
    3644:	6105                	addi	sp,sp,32
    3646:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3648:	85a6                	mv	a1,s1
    364a:	00004517          	auipc	a0,0x4
    364e:	d7e50513          	addi	a0,a0,-642 # 73c8 <malloc+0x1394>
    3652:	00003097          	auipc	ra,0x3
    3656:	924080e7          	jalr	-1756(ra) # 5f76 <printf>
    exit(1);
    365a:	4505                	li	a0,1
    365c:	00002097          	auipc	ra,0x2
    3660:	5a2080e7          	jalr	1442(ra) # 5bfe <exit>
    printf("%s: chdir dir0 failed\n", s);
    3664:	85a6                	mv	a1,s1
    3666:	00004517          	auipc	a0,0x4
    366a:	e0a50513          	addi	a0,a0,-502 # 7470 <malloc+0x143c>
    366e:	00003097          	auipc	ra,0x3
    3672:	908080e7          	jalr	-1784(ra) # 5f76 <printf>
    exit(1);
    3676:	4505                	li	a0,1
    3678:	00002097          	auipc	ra,0x2
    367c:	586080e7          	jalr	1414(ra) # 5bfe <exit>
    printf("%s: chdir .. failed\n", s);
    3680:	85a6                	mv	a1,s1
    3682:	00004517          	auipc	a0,0x4
    3686:	e0e50513          	addi	a0,a0,-498 # 7490 <malloc+0x145c>
    368a:	00003097          	auipc	ra,0x3
    368e:	8ec080e7          	jalr	-1812(ra) # 5f76 <printf>
    exit(1);
    3692:	4505                	li	a0,1
    3694:	00002097          	auipc	ra,0x2
    3698:	56a080e7          	jalr	1386(ra) # 5bfe <exit>
    printf("%s: unlink dir0 failed\n", s);
    369c:	85a6                	mv	a1,s1
    369e:	00004517          	auipc	a0,0x4
    36a2:	e0a50513          	addi	a0,a0,-502 # 74a8 <malloc+0x1474>
    36a6:	00003097          	auipc	ra,0x3
    36aa:	8d0080e7          	jalr	-1840(ra) # 5f76 <printf>
    exit(1);
    36ae:	4505                	li	a0,1
    36b0:	00002097          	auipc	ra,0x2
    36b4:	54e080e7          	jalr	1358(ra) # 5bfe <exit>

00000000000036b8 <subdir>:
{
    36b8:	1101                	addi	sp,sp,-32
    36ba:	ec06                	sd	ra,24(sp)
    36bc:	e822                	sd	s0,16(sp)
    36be:	e426                	sd	s1,8(sp)
    36c0:	e04a                	sd	s2,0(sp)
    36c2:	1000                	addi	s0,sp,32
    36c4:	892a                	mv	s2,a0
  unlink("ff");
    36c6:	00004517          	auipc	a0,0x4
    36ca:	f2a50513          	addi	a0,a0,-214 # 75f0 <malloc+0x15bc>
    36ce:	00002097          	auipc	ra,0x2
    36d2:	580080e7          	jalr	1408(ra) # 5c4e <unlink>
  if(mkdir("dd") != 0){
    36d6:	00004517          	auipc	a0,0x4
    36da:	dea50513          	addi	a0,a0,-534 # 74c0 <malloc+0x148c>
    36de:	00002097          	auipc	ra,0x2
    36e2:	588080e7          	jalr	1416(ra) # 5c66 <mkdir>
    36e6:	38051663          	bnez	a0,3a72 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    36ea:	20200593          	li	a1,514
    36ee:	00004517          	auipc	a0,0x4
    36f2:	df250513          	addi	a0,a0,-526 # 74e0 <malloc+0x14ac>
    36f6:	00002097          	auipc	ra,0x2
    36fa:	548080e7          	jalr	1352(ra) # 5c3e <open>
    36fe:	84aa                	mv	s1,a0
  if(fd < 0){
    3700:	38054763          	bltz	a0,3a8e <subdir+0x3d6>
  write(fd, "ff", 2);
    3704:	4609                	li	a2,2
    3706:	00004597          	auipc	a1,0x4
    370a:	eea58593          	addi	a1,a1,-278 # 75f0 <malloc+0x15bc>
    370e:	00002097          	auipc	ra,0x2
    3712:	510080e7          	jalr	1296(ra) # 5c1e <write>
  close(fd);
    3716:	8526                	mv	a0,s1
    3718:	00002097          	auipc	ra,0x2
    371c:	50e080e7          	jalr	1294(ra) # 5c26 <close>
  if(unlink("dd") >= 0){
    3720:	00004517          	auipc	a0,0x4
    3724:	da050513          	addi	a0,a0,-608 # 74c0 <malloc+0x148c>
    3728:	00002097          	auipc	ra,0x2
    372c:	526080e7          	jalr	1318(ra) # 5c4e <unlink>
    3730:	36055d63          	bgez	a0,3aaa <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    3734:	00004517          	auipc	a0,0x4
    3738:	e0450513          	addi	a0,a0,-508 # 7538 <malloc+0x1504>
    373c:	00002097          	auipc	ra,0x2
    3740:	52a080e7          	jalr	1322(ra) # 5c66 <mkdir>
    3744:	38051163          	bnez	a0,3ac6 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3748:	20200593          	li	a1,514
    374c:	00004517          	auipc	a0,0x4
    3750:	e1450513          	addi	a0,a0,-492 # 7560 <malloc+0x152c>
    3754:	00002097          	auipc	ra,0x2
    3758:	4ea080e7          	jalr	1258(ra) # 5c3e <open>
    375c:	84aa                	mv	s1,a0
  if(fd < 0){
    375e:	38054263          	bltz	a0,3ae2 <subdir+0x42a>
  write(fd, "FF", 2);
    3762:	4609                	li	a2,2
    3764:	00004597          	auipc	a1,0x4
    3768:	e2c58593          	addi	a1,a1,-468 # 7590 <malloc+0x155c>
    376c:	00002097          	auipc	ra,0x2
    3770:	4b2080e7          	jalr	1202(ra) # 5c1e <write>
  close(fd);
    3774:	8526                	mv	a0,s1
    3776:	00002097          	auipc	ra,0x2
    377a:	4b0080e7          	jalr	1200(ra) # 5c26 <close>
  fd = open("dd/dd/../ff", 0);
    377e:	4581                	li	a1,0
    3780:	00004517          	auipc	a0,0x4
    3784:	e1850513          	addi	a0,a0,-488 # 7598 <malloc+0x1564>
    3788:	00002097          	auipc	ra,0x2
    378c:	4b6080e7          	jalr	1206(ra) # 5c3e <open>
    3790:	84aa                	mv	s1,a0
  if(fd < 0){
    3792:	36054663          	bltz	a0,3afe <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3796:	660d                	lui	a2,0x3
    3798:	00009597          	auipc	a1,0x9
    379c:	4e058593          	addi	a1,a1,1248 # cc78 <buf>
    37a0:	00002097          	auipc	ra,0x2
    37a4:	476080e7          	jalr	1142(ra) # 5c16 <read>
  if(cc != 2 || buf[0] != 'f'){
    37a8:	4789                	li	a5,2
    37aa:	36f51863          	bne	a0,a5,3b1a <subdir+0x462>
    37ae:	00009717          	auipc	a4,0x9
    37b2:	4ca74703          	lbu	a4,1226(a4) # cc78 <buf>
    37b6:	06600793          	li	a5,102
    37ba:	36f71063          	bne	a4,a5,3b1a <subdir+0x462>
  close(fd);
    37be:	8526                	mv	a0,s1
    37c0:	00002097          	auipc	ra,0x2
    37c4:	466080e7          	jalr	1126(ra) # 5c26 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    37c8:	00004597          	auipc	a1,0x4
    37cc:	e2058593          	addi	a1,a1,-480 # 75e8 <malloc+0x15b4>
    37d0:	00004517          	auipc	a0,0x4
    37d4:	d9050513          	addi	a0,a0,-624 # 7560 <malloc+0x152c>
    37d8:	00002097          	auipc	ra,0x2
    37dc:	486080e7          	jalr	1158(ra) # 5c5e <link>
    37e0:	34051b63          	bnez	a0,3b36 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    37e4:	00004517          	auipc	a0,0x4
    37e8:	d7c50513          	addi	a0,a0,-644 # 7560 <malloc+0x152c>
    37ec:	00002097          	auipc	ra,0x2
    37f0:	462080e7          	jalr	1122(ra) # 5c4e <unlink>
    37f4:	34051f63          	bnez	a0,3b52 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    37f8:	4581                	li	a1,0
    37fa:	00004517          	auipc	a0,0x4
    37fe:	d6650513          	addi	a0,a0,-666 # 7560 <malloc+0x152c>
    3802:	00002097          	auipc	ra,0x2
    3806:	43c080e7          	jalr	1084(ra) # 5c3e <open>
    380a:	36055263          	bgez	a0,3b6e <subdir+0x4b6>
  if(chdir("dd") != 0){
    380e:	00004517          	auipc	a0,0x4
    3812:	cb250513          	addi	a0,a0,-846 # 74c0 <malloc+0x148c>
    3816:	00002097          	auipc	ra,0x2
    381a:	458080e7          	jalr	1112(ra) # 5c6e <chdir>
    381e:	36051663          	bnez	a0,3b8a <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    3822:	00004517          	auipc	a0,0x4
    3826:	e5e50513          	addi	a0,a0,-418 # 7680 <malloc+0x164c>
    382a:	00002097          	auipc	ra,0x2
    382e:	444080e7          	jalr	1092(ra) # 5c6e <chdir>
    3832:	36051a63          	bnez	a0,3ba6 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    3836:	00004517          	auipc	a0,0x4
    383a:	e7a50513          	addi	a0,a0,-390 # 76b0 <malloc+0x167c>
    383e:	00002097          	auipc	ra,0x2
    3842:	430080e7          	jalr	1072(ra) # 5c6e <chdir>
    3846:	36051e63          	bnez	a0,3bc2 <subdir+0x50a>
  if(chdir("./..") != 0){
    384a:	00004517          	auipc	a0,0x4
    384e:	e9650513          	addi	a0,a0,-362 # 76e0 <malloc+0x16ac>
    3852:	00002097          	auipc	ra,0x2
    3856:	41c080e7          	jalr	1052(ra) # 5c6e <chdir>
    385a:	38051263          	bnez	a0,3bde <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    385e:	4581                	li	a1,0
    3860:	00004517          	auipc	a0,0x4
    3864:	d8850513          	addi	a0,a0,-632 # 75e8 <malloc+0x15b4>
    3868:	00002097          	auipc	ra,0x2
    386c:	3d6080e7          	jalr	982(ra) # 5c3e <open>
    3870:	84aa                	mv	s1,a0
  if(fd < 0){
    3872:	38054463          	bltz	a0,3bfa <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    3876:	660d                	lui	a2,0x3
    3878:	00009597          	auipc	a1,0x9
    387c:	40058593          	addi	a1,a1,1024 # cc78 <buf>
    3880:	00002097          	auipc	ra,0x2
    3884:	396080e7          	jalr	918(ra) # 5c16 <read>
    3888:	4789                	li	a5,2
    388a:	38f51663          	bne	a0,a5,3c16 <subdir+0x55e>
  close(fd);
    388e:	8526                	mv	a0,s1
    3890:	00002097          	auipc	ra,0x2
    3894:	396080e7          	jalr	918(ra) # 5c26 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3898:	4581                	li	a1,0
    389a:	00004517          	auipc	a0,0x4
    389e:	cc650513          	addi	a0,a0,-826 # 7560 <malloc+0x152c>
    38a2:	00002097          	auipc	ra,0x2
    38a6:	39c080e7          	jalr	924(ra) # 5c3e <open>
    38aa:	38055463          	bgez	a0,3c32 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    38ae:	20200593          	li	a1,514
    38b2:	00004517          	auipc	a0,0x4
    38b6:	ebe50513          	addi	a0,a0,-322 # 7770 <malloc+0x173c>
    38ba:	00002097          	auipc	ra,0x2
    38be:	384080e7          	jalr	900(ra) # 5c3e <open>
    38c2:	38055663          	bgez	a0,3c4e <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    38c6:	20200593          	li	a1,514
    38ca:	00004517          	auipc	a0,0x4
    38ce:	ed650513          	addi	a0,a0,-298 # 77a0 <malloc+0x176c>
    38d2:	00002097          	auipc	ra,0x2
    38d6:	36c080e7          	jalr	876(ra) # 5c3e <open>
    38da:	38055863          	bgez	a0,3c6a <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    38de:	20000593          	li	a1,512
    38e2:	00004517          	auipc	a0,0x4
    38e6:	bde50513          	addi	a0,a0,-1058 # 74c0 <malloc+0x148c>
    38ea:	00002097          	auipc	ra,0x2
    38ee:	354080e7          	jalr	852(ra) # 5c3e <open>
    38f2:	38055a63          	bgez	a0,3c86 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    38f6:	4589                	li	a1,2
    38f8:	00004517          	auipc	a0,0x4
    38fc:	bc850513          	addi	a0,a0,-1080 # 74c0 <malloc+0x148c>
    3900:	00002097          	auipc	ra,0x2
    3904:	33e080e7          	jalr	830(ra) # 5c3e <open>
    3908:	38055d63          	bgez	a0,3ca2 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    390c:	4585                	li	a1,1
    390e:	00004517          	auipc	a0,0x4
    3912:	bb250513          	addi	a0,a0,-1102 # 74c0 <malloc+0x148c>
    3916:	00002097          	auipc	ra,0x2
    391a:	328080e7          	jalr	808(ra) # 5c3e <open>
    391e:	3a055063          	bgez	a0,3cbe <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3922:	00004597          	auipc	a1,0x4
    3926:	f0e58593          	addi	a1,a1,-242 # 7830 <malloc+0x17fc>
    392a:	00004517          	auipc	a0,0x4
    392e:	e4650513          	addi	a0,a0,-442 # 7770 <malloc+0x173c>
    3932:	00002097          	auipc	ra,0x2
    3936:	32c080e7          	jalr	812(ra) # 5c5e <link>
    393a:	3a050063          	beqz	a0,3cda <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    393e:	00004597          	auipc	a1,0x4
    3942:	ef258593          	addi	a1,a1,-270 # 7830 <malloc+0x17fc>
    3946:	00004517          	auipc	a0,0x4
    394a:	e5a50513          	addi	a0,a0,-422 # 77a0 <malloc+0x176c>
    394e:	00002097          	auipc	ra,0x2
    3952:	310080e7          	jalr	784(ra) # 5c5e <link>
    3956:	3a050063          	beqz	a0,3cf6 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    395a:	00004597          	auipc	a1,0x4
    395e:	c8e58593          	addi	a1,a1,-882 # 75e8 <malloc+0x15b4>
    3962:	00004517          	auipc	a0,0x4
    3966:	b7e50513          	addi	a0,a0,-1154 # 74e0 <malloc+0x14ac>
    396a:	00002097          	auipc	ra,0x2
    396e:	2f4080e7          	jalr	756(ra) # 5c5e <link>
    3972:	3a050063          	beqz	a0,3d12 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3976:	00004517          	auipc	a0,0x4
    397a:	dfa50513          	addi	a0,a0,-518 # 7770 <malloc+0x173c>
    397e:	00002097          	auipc	ra,0x2
    3982:	2e8080e7          	jalr	744(ra) # 5c66 <mkdir>
    3986:	3a050463          	beqz	a0,3d2e <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    398a:	00004517          	auipc	a0,0x4
    398e:	e1650513          	addi	a0,a0,-490 # 77a0 <malloc+0x176c>
    3992:	00002097          	auipc	ra,0x2
    3996:	2d4080e7          	jalr	724(ra) # 5c66 <mkdir>
    399a:	3a050863          	beqz	a0,3d4a <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    399e:	00004517          	auipc	a0,0x4
    39a2:	c4a50513          	addi	a0,a0,-950 # 75e8 <malloc+0x15b4>
    39a6:	00002097          	auipc	ra,0x2
    39aa:	2c0080e7          	jalr	704(ra) # 5c66 <mkdir>
    39ae:	3a050c63          	beqz	a0,3d66 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    39b2:	00004517          	auipc	a0,0x4
    39b6:	dee50513          	addi	a0,a0,-530 # 77a0 <malloc+0x176c>
    39ba:	00002097          	auipc	ra,0x2
    39be:	294080e7          	jalr	660(ra) # 5c4e <unlink>
    39c2:	3c050063          	beqz	a0,3d82 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    39c6:	00004517          	auipc	a0,0x4
    39ca:	daa50513          	addi	a0,a0,-598 # 7770 <malloc+0x173c>
    39ce:	00002097          	auipc	ra,0x2
    39d2:	280080e7          	jalr	640(ra) # 5c4e <unlink>
    39d6:	3c050463          	beqz	a0,3d9e <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    39da:	00004517          	auipc	a0,0x4
    39de:	b0650513          	addi	a0,a0,-1274 # 74e0 <malloc+0x14ac>
    39e2:	00002097          	auipc	ra,0x2
    39e6:	28c080e7          	jalr	652(ra) # 5c6e <chdir>
    39ea:	3c050863          	beqz	a0,3dba <subdir+0x702>
  if(chdir("dd/xx") == 0){
    39ee:	00004517          	auipc	a0,0x4
    39f2:	f9250513          	addi	a0,a0,-110 # 7980 <malloc+0x194c>
    39f6:	00002097          	auipc	ra,0x2
    39fa:	278080e7          	jalr	632(ra) # 5c6e <chdir>
    39fe:	3c050c63          	beqz	a0,3dd6 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3a02:	00004517          	auipc	a0,0x4
    3a06:	be650513          	addi	a0,a0,-1050 # 75e8 <malloc+0x15b4>
    3a0a:	00002097          	auipc	ra,0x2
    3a0e:	244080e7          	jalr	580(ra) # 5c4e <unlink>
    3a12:	3e051063          	bnez	a0,3df2 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3a16:	00004517          	auipc	a0,0x4
    3a1a:	aca50513          	addi	a0,a0,-1334 # 74e0 <malloc+0x14ac>
    3a1e:	00002097          	auipc	ra,0x2
    3a22:	230080e7          	jalr	560(ra) # 5c4e <unlink>
    3a26:	3e051463          	bnez	a0,3e0e <subdir+0x756>
  if(unlink("dd") == 0){
    3a2a:	00004517          	auipc	a0,0x4
    3a2e:	a9650513          	addi	a0,a0,-1386 # 74c0 <malloc+0x148c>
    3a32:	00002097          	auipc	ra,0x2
    3a36:	21c080e7          	jalr	540(ra) # 5c4e <unlink>
    3a3a:	3e050863          	beqz	a0,3e2a <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3a3e:	00004517          	auipc	a0,0x4
    3a42:	fb250513          	addi	a0,a0,-78 # 79f0 <malloc+0x19bc>
    3a46:	00002097          	auipc	ra,0x2
    3a4a:	208080e7          	jalr	520(ra) # 5c4e <unlink>
    3a4e:	3e054c63          	bltz	a0,3e46 <subdir+0x78e>
  if(unlink("dd") < 0){
    3a52:	00004517          	auipc	a0,0x4
    3a56:	a6e50513          	addi	a0,a0,-1426 # 74c0 <malloc+0x148c>
    3a5a:	00002097          	auipc	ra,0x2
    3a5e:	1f4080e7          	jalr	500(ra) # 5c4e <unlink>
    3a62:	40054063          	bltz	a0,3e62 <subdir+0x7aa>
}
    3a66:	60e2                	ld	ra,24(sp)
    3a68:	6442                	ld	s0,16(sp)
    3a6a:	64a2                	ld	s1,8(sp)
    3a6c:	6902                	ld	s2,0(sp)
    3a6e:	6105                	addi	sp,sp,32
    3a70:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3a72:	85ca                	mv	a1,s2
    3a74:	00004517          	auipc	a0,0x4
    3a78:	a5450513          	addi	a0,a0,-1452 # 74c8 <malloc+0x1494>
    3a7c:	00002097          	auipc	ra,0x2
    3a80:	4fa080e7          	jalr	1274(ra) # 5f76 <printf>
    exit(1);
    3a84:	4505                	li	a0,1
    3a86:	00002097          	auipc	ra,0x2
    3a8a:	178080e7          	jalr	376(ra) # 5bfe <exit>
    printf("%s: create dd/ff failed\n", s);
    3a8e:	85ca                	mv	a1,s2
    3a90:	00004517          	auipc	a0,0x4
    3a94:	a5850513          	addi	a0,a0,-1448 # 74e8 <malloc+0x14b4>
    3a98:	00002097          	auipc	ra,0x2
    3a9c:	4de080e7          	jalr	1246(ra) # 5f76 <printf>
    exit(1);
    3aa0:	4505                	li	a0,1
    3aa2:	00002097          	auipc	ra,0x2
    3aa6:	15c080e7          	jalr	348(ra) # 5bfe <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3aaa:	85ca                	mv	a1,s2
    3aac:	00004517          	auipc	a0,0x4
    3ab0:	a5c50513          	addi	a0,a0,-1444 # 7508 <malloc+0x14d4>
    3ab4:	00002097          	auipc	ra,0x2
    3ab8:	4c2080e7          	jalr	1218(ra) # 5f76 <printf>
    exit(1);
    3abc:	4505                	li	a0,1
    3abe:	00002097          	auipc	ra,0x2
    3ac2:	140080e7          	jalr	320(ra) # 5bfe <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3ac6:	85ca                	mv	a1,s2
    3ac8:	00004517          	auipc	a0,0x4
    3acc:	a7850513          	addi	a0,a0,-1416 # 7540 <malloc+0x150c>
    3ad0:	00002097          	auipc	ra,0x2
    3ad4:	4a6080e7          	jalr	1190(ra) # 5f76 <printf>
    exit(1);
    3ad8:	4505                	li	a0,1
    3ada:	00002097          	auipc	ra,0x2
    3ade:	124080e7          	jalr	292(ra) # 5bfe <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3ae2:	85ca                	mv	a1,s2
    3ae4:	00004517          	auipc	a0,0x4
    3ae8:	a8c50513          	addi	a0,a0,-1396 # 7570 <malloc+0x153c>
    3aec:	00002097          	auipc	ra,0x2
    3af0:	48a080e7          	jalr	1162(ra) # 5f76 <printf>
    exit(1);
    3af4:	4505                	li	a0,1
    3af6:	00002097          	auipc	ra,0x2
    3afa:	108080e7          	jalr	264(ra) # 5bfe <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3afe:	85ca                	mv	a1,s2
    3b00:	00004517          	auipc	a0,0x4
    3b04:	aa850513          	addi	a0,a0,-1368 # 75a8 <malloc+0x1574>
    3b08:	00002097          	auipc	ra,0x2
    3b0c:	46e080e7          	jalr	1134(ra) # 5f76 <printf>
    exit(1);
    3b10:	4505                	li	a0,1
    3b12:	00002097          	auipc	ra,0x2
    3b16:	0ec080e7          	jalr	236(ra) # 5bfe <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3b1a:	85ca                	mv	a1,s2
    3b1c:	00004517          	auipc	a0,0x4
    3b20:	aac50513          	addi	a0,a0,-1364 # 75c8 <malloc+0x1594>
    3b24:	00002097          	auipc	ra,0x2
    3b28:	452080e7          	jalr	1106(ra) # 5f76 <printf>
    exit(1);
    3b2c:	4505                	li	a0,1
    3b2e:	00002097          	auipc	ra,0x2
    3b32:	0d0080e7          	jalr	208(ra) # 5bfe <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3b36:	85ca                	mv	a1,s2
    3b38:	00004517          	auipc	a0,0x4
    3b3c:	ac050513          	addi	a0,a0,-1344 # 75f8 <malloc+0x15c4>
    3b40:	00002097          	auipc	ra,0x2
    3b44:	436080e7          	jalr	1078(ra) # 5f76 <printf>
    exit(1);
    3b48:	4505                	li	a0,1
    3b4a:	00002097          	auipc	ra,0x2
    3b4e:	0b4080e7          	jalr	180(ra) # 5bfe <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3b52:	85ca                	mv	a1,s2
    3b54:	00004517          	auipc	a0,0x4
    3b58:	acc50513          	addi	a0,a0,-1332 # 7620 <malloc+0x15ec>
    3b5c:	00002097          	auipc	ra,0x2
    3b60:	41a080e7          	jalr	1050(ra) # 5f76 <printf>
    exit(1);
    3b64:	4505                	li	a0,1
    3b66:	00002097          	auipc	ra,0x2
    3b6a:	098080e7          	jalr	152(ra) # 5bfe <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3b6e:	85ca                	mv	a1,s2
    3b70:	00004517          	auipc	a0,0x4
    3b74:	ad050513          	addi	a0,a0,-1328 # 7640 <malloc+0x160c>
    3b78:	00002097          	auipc	ra,0x2
    3b7c:	3fe080e7          	jalr	1022(ra) # 5f76 <printf>
    exit(1);
    3b80:	4505                	li	a0,1
    3b82:	00002097          	auipc	ra,0x2
    3b86:	07c080e7          	jalr	124(ra) # 5bfe <exit>
    printf("%s: chdir dd failed\n", s);
    3b8a:	85ca                	mv	a1,s2
    3b8c:	00004517          	auipc	a0,0x4
    3b90:	adc50513          	addi	a0,a0,-1316 # 7668 <malloc+0x1634>
    3b94:	00002097          	auipc	ra,0x2
    3b98:	3e2080e7          	jalr	994(ra) # 5f76 <printf>
    exit(1);
    3b9c:	4505                	li	a0,1
    3b9e:	00002097          	auipc	ra,0x2
    3ba2:	060080e7          	jalr	96(ra) # 5bfe <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3ba6:	85ca                	mv	a1,s2
    3ba8:	00004517          	auipc	a0,0x4
    3bac:	ae850513          	addi	a0,a0,-1304 # 7690 <malloc+0x165c>
    3bb0:	00002097          	auipc	ra,0x2
    3bb4:	3c6080e7          	jalr	966(ra) # 5f76 <printf>
    exit(1);
    3bb8:	4505                	li	a0,1
    3bba:	00002097          	auipc	ra,0x2
    3bbe:	044080e7          	jalr	68(ra) # 5bfe <exit>
    printf("chdir dd/../../dd failed\n", s);
    3bc2:	85ca                	mv	a1,s2
    3bc4:	00004517          	auipc	a0,0x4
    3bc8:	afc50513          	addi	a0,a0,-1284 # 76c0 <malloc+0x168c>
    3bcc:	00002097          	auipc	ra,0x2
    3bd0:	3aa080e7          	jalr	938(ra) # 5f76 <printf>
    exit(1);
    3bd4:	4505                	li	a0,1
    3bd6:	00002097          	auipc	ra,0x2
    3bda:	028080e7          	jalr	40(ra) # 5bfe <exit>
    printf("%s: chdir ./.. failed\n", s);
    3bde:	85ca                	mv	a1,s2
    3be0:	00004517          	auipc	a0,0x4
    3be4:	b0850513          	addi	a0,a0,-1272 # 76e8 <malloc+0x16b4>
    3be8:	00002097          	auipc	ra,0x2
    3bec:	38e080e7          	jalr	910(ra) # 5f76 <printf>
    exit(1);
    3bf0:	4505                	li	a0,1
    3bf2:	00002097          	auipc	ra,0x2
    3bf6:	00c080e7          	jalr	12(ra) # 5bfe <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3bfa:	85ca                	mv	a1,s2
    3bfc:	00004517          	auipc	a0,0x4
    3c00:	b0450513          	addi	a0,a0,-1276 # 7700 <malloc+0x16cc>
    3c04:	00002097          	auipc	ra,0x2
    3c08:	372080e7          	jalr	882(ra) # 5f76 <printf>
    exit(1);
    3c0c:	4505                	li	a0,1
    3c0e:	00002097          	auipc	ra,0x2
    3c12:	ff0080e7          	jalr	-16(ra) # 5bfe <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3c16:	85ca                	mv	a1,s2
    3c18:	00004517          	auipc	a0,0x4
    3c1c:	b0850513          	addi	a0,a0,-1272 # 7720 <malloc+0x16ec>
    3c20:	00002097          	auipc	ra,0x2
    3c24:	356080e7          	jalr	854(ra) # 5f76 <printf>
    exit(1);
    3c28:	4505                	li	a0,1
    3c2a:	00002097          	auipc	ra,0x2
    3c2e:	fd4080e7          	jalr	-44(ra) # 5bfe <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3c32:	85ca                	mv	a1,s2
    3c34:	00004517          	auipc	a0,0x4
    3c38:	b0c50513          	addi	a0,a0,-1268 # 7740 <malloc+0x170c>
    3c3c:	00002097          	auipc	ra,0x2
    3c40:	33a080e7          	jalr	826(ra) # 5f76 <printf>
    exit(1);
    3c44:	4505                	li	a0,1
    3c46:	00002097          	auipc	ra,0x2
    3c4a:	fb8080e7          	jalr	-72(ra) # 5bfe <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3c4e:	85ca                	mv	a1,s2
    3c50:	00004517          	auipc	a0,0x4
    3c54:	b3050513          	addi	a0,a0,-1232 # 7780 <malloc+0x174c>
    3c58:	00002097          	auipc	ra,0x2
    3c5c:	31e080e7          	jalr	798(ra) # 5f76 <printf>
    exit(1);
    3c60:	4505                	li	a0,1
    3c62:	00002097          	auipc	ra,0x2
    3c66:	f9c080e7          	jalr	-100(ra) # 5bfe <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3c6a:	85ca                	mv	a1,s2
    3c6c:	00004517          	auipc	a0,0x4
    3c70:	b4450513          	addi	a0,a0,-1212 # 77b0 <malloc+0x177c>
    3c74:	00002097          	auipc	ra,0x2
    3c78:	302080e7          	jalr	770(ra) # 5f76 <printf>
    exit(1);
    3c7c:	4505                	li	a0,1
    3c7e:	00002097          	auipc	ra,0x2
    3c82:	f80080e7          	jalr	-128(ra) # 5bfe <exit>
    printf("%s: create dd succeeded!\n", s);
    3c86:	85ca                	mv	a1,s2
    3c88:	00004517          	auipc	a0,0x4
    3c8c:	b4850513          	addi	a0,a0,-1208 # 77d0 <malloc+0x179c>
    3c90:	00002097          	auipc	ra,0x2
    3c94:	2e6080e7          	jalr	742(ra) # 5f76 <printf>
    exit(1);
    3c98:	4505                	li	a0,1
    3c9a:	00002097          	auipc	ra,0x2
    3c9e:	f64080e7          	jalr	-156(ra) # 5bfe <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3ca2:	85ca                	mv	a1,s2
    3ca4:	00004517          	auipc	a0,0x4
    3ca8:	b4c50513          	addi	a0,a0,-1204 # 77f0 <malloc+0x17bc>
    3cac:	00002097          	auipc	ra,0x2
    3cb0:	2ca080e7          	jalr	714(ra) # 5f76 <printf>
    exit(1);
    3cb4:	4505                	li	a0,1
    3cb6:	00002097          	auipc	ra,0x2
    3cba:	f48080e7          	jalr	-184(ra) # 5bfe <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3cbe:	85ca                	mv	a1,s2
    3cc0:	00004517          	auipc	a0,0x4
    3cc4:	b5050513          	addi	a0,a0,-1200 # 7810 <malloc+0x17dc>
    3cc8:	00002097          	auipc	ra,0x2
    3ccc:	2ae080e7          	jalr	686(ra) # 5f76 <printf>
    exit(1);
    3cd0:	4505                	li	a0,1
    3cd2:	00002097          	auipc	ra,0x2
    3cd6:	f2c080e7          	jalr	-212(ra) # 5bfe <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3cda:	85ca                	mv	a1,s2
    3cdc:	00004517          	auipc	a0,0x4
    3ce0:	b6450513          	addi	a0,a0,-1180 # 7840 <malloc+0x180c>
    3ce4:	00002097          	auipc	ra,0x2
    3ce8:	292080e7          	jalr	658(ra) # 5f76 <printf>
    exit(1);
    3cec:	4505                	li	a0,1
    3cee:	00002097          	auipc	ra,0x2
    3cf2:	f10080e7          	jalr	-240(ra) # 5bfe <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3cf6:	85ca                	mv	a1,s2
    3cf8:	00004517          	auipc	a0,0x4
    3cfc:	b7050513          	addi	a0,a0,-1168 # 7868 <malloc+0x1834>
    3d00:	00002097          	auipc	ra,0x2
    3d04:	276080e7          	jalr	630(ra) # 5f76 <printf>
    exit(1);
    3d08:	4505                	li	a0,1
    3d0a:	00002097          	auipc	ra,0x2
    3d0e:	ef4080e7          	jalr	-268(ra) # 5bfe <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3d12:	85ca                	mv	a1,s2
    3d14:	00004517          	auipc	a0,0x4
    3d18:	b7c50513          	addi	a0,a0,-1156 # 7890 <malloc+0x185c>
    3d1c:	00002097          	auipc	ra,0x2
    3d20:	25a080e7          	jalr	602(ra) # 5f76 <printf>
    exit(1);
    3d24:	4505                	li	a0,1
    3d26:	00002097          	auipc	ra,0x2
    3d2a:	ed8080e7          	jalr	-296(ra) # 5bfe <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3d2e:	85ca                	mv	a1,s2
    3d30:	00004517          	auipc	a0,0x4
    3d34:	b8850513          	addi	a0,a0,-1144 # 78b8 <malloc+0x1884>
    3d38:	00002097          	auipc	ra,0x2
    3d3c:	23e080e7          	jalr	574(ra) # 5f76 <printf>
    exit(1);
    3d40:	4505                	li	a0,1
    3d42:	00002097          	auipc	ra,0x2
    3d46:	ebc080e7          	jalr	-324(ra) # 5bfe <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3d4a:	85ca                	mv	a1,s2
    3d4c:	00004517          	auipc	a0,0x4
    3d50:	b8c50513          	addi	a0,a0,-1140 # 78d8 <malloc+0x18a4>
    3d54:	00002097          	auipc	ra,0x2
    3d58:	222080e7          	jalr	546(ra) # 5f76 <printf>
    exit(1);
    3d5c:	4505                	li	a0,1
    3d5e:	00002097          	auipc	ra,0x2
    3d62:	ea0080e7          	jalr	-352(ra) # 5bfe <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3d66:	85ca                	mv	a1,s2
    3d68:	00004517          	auipc	a0,0x4
    3d6c:	b9050513          	addi	a0,a0,-1136 # 78f8 <malloc+0x18c4>
    3d70:	00002097          	auipc	ra,0x2
    3d74:	206080e7          	jalr	518(ra) # 5f76 <printf>
    exit(1);
    3d78:	4505                	li	a0,1
    3d7a:	00002097          	auipc	ra,0x2
    3d7e:	e84080e7          	jalr	-380(ra) # 5bfe <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3d82:	85ca                	mv	a1,s2
    3d84:	00004517          	auipc	a0,0x4
    3d88:	b9c50513          	addi	a0,a0,-1124 # 7920 <malloc+0x18ec>
    3d8c:	00002097          	auipc	ra,0x2
    3d90:	1ea080e7          	jalr	490(ra) # 5f76 <printf>
    exit(1);
    3d94:	4505                	li	a0,1
    3d96:	00002097          	auipc	ra,0x2
    3d9a:	e68080e7          	jalr	-408(ra) # 5bfe <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3d9e:	85ca                	mv	a1,s2
    3da0:	00004517          	auipc	a0,0x4
    3da4:	ba050513          	addi	a0,a0,-1120 # 7940 <malloc+0x190c>
    3da8:	00002097          	auipc	ra,0x2
    3dac:	1ce080e7          	jalr	462(ra) # 5f76 <printf>
    exit(1);
    3db0:	4505                	li	a0,1
    3db2:	00002097          	auipc	ra,0x2
    3db6:	e4c080e7          	jalr	-436(ra) # 5bfe <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3dba:	85ca                	mv	a1,s2
    3dbc:	00004517          	auipc	a0,0x4
    3dc0:	ba450513          	addi	a0,a0,-1116 # 7960 <malloc+0x192c>
    3dc4:	00002097          	auipc	ra,0x2
    3dc8:	1b2080e7          	jalr	434(ra) # 5f76 <printf>
    exit(1);
    3dcc:	4505                	li	a0,1
    3dce:	00002097          	auipc	ra,0x2
    3dd2:	e30080e7          	jalr	-464(ra) # 5bfe <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3dd6:	85ca                	mv	a1,s2
    3dd8:	00004517          	auipc	a0,0x4
    3ddc:	bb050513          	addi	a0,a0,-1104 # 7988 <malloc+0x1954>
    3de0:	00002097          	auipc	ra,0x2
    3de4:	196080e7          	jalr	406(ra) # 5f76 <printf>
    exit(1);
    3de8:	4505                	li	a0,1
    3dea:	00002097          	auipc	ra,0x2
    3dee:	e14080e7          	jalr	-492(ra) # 5bfe <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3df2:	85ca                	mv	a1,s2
    3df4:	00004517          	auipc	a0,0x4
    3df8:	82c50513          	addi	a0,a0,-2004 # 7620 <malloc+0x15ec>
    3dfc:	00002097          	auipc	ra,0x2
    3e00:	17a080e7          	jalr	378(ra) # 5f76 <printf>
    exit(1);
    3e04:	4505                	li	a0,1
    3e06:	00002097          	auipc	ra,0x2
    3e0a:	df8080e7          	jalr	-520(ra) # 5bfe <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3e0e:	85ca                	mv	a1,s2
    3e10:	00004517          	auipc	a0,0x4
    3e14:	b9850513          	addi	a0,a0,-1128 # 79a8 <malloc+0x1974>
    3e18:	00002097          	auipc	ra,0x2
    3e1c:	15e080e7          	jalr	350(ra) # 5f76 <printf>
    exit(1);
    3e20:	4505                	li	a0,1
    3e22:	00002097          	auipc	ra,0x2
    3e26:	ddc080e7          	jalr	-548(ra) # 5bfe <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3e2a:	85ca                	mv	a1,s2
    3e2c:	00004517          	auipc	a0,0x4
    3e30:	b9c50513          	addi	a0,a0,-1124 # 79c8 <malloc+0x1994>
    3e34:	00002097          	auipc	ra,0x2
    3e38:	142080e7          	jalr	322(ra) # 5f76 <printf>
    exit(1);
    3e3c:	4505                	li	a0,1
    3e3e:	00002097          	auipc	ra,0x2
    3e42:	dc0080e7          	jalr	-576(ra) # 5bfe <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3e46:	85ca                	mv	a1,s2
    3e48:	00004517          	auipc	a0,0x4
    3e4c:	bb050513          	addi	a0,a0,-1104 # 79f8 <malloc+0x19c4>
    3e50:	00002097          	auipc	ra,0x2
    3e54:	126080e7          	jalr	294(ra) # 5f76 <printf>
    exit(1);
    3e58:	4505                	li	a0,1
    3e5a:	00002097          	auipc	ra,0x2
    3e5e:	da4080e7          	jalr	-604(ra) # 5bfe <exit>
    printf("%s: unlink dd failed\n", s);
    3e62:	85ca                	mv	a1,s2
    3e64:	00004517          	auipc	a0,0x4
    3e68:	bb450513          	addi	a0,a0,-1100 # 7a18 <malloc+0x19e4>
    3e6c:	00002097          	auipc	ra,0x2
    3e70:	10a080e7          	jalr	266(ra) # 5f76 <printf>
    exit(1);
    3e74:	4505                	li	a0,1
    3e76:	00002097          	auipc	ra,0x2
    3e7a:	d88080e7          	jalr	-632(ra) # 5bfe <exit>

0000000000003e7e <rmdot>:
{
    3e7e:	1101                	addi	sp,sp,-32
    3e80:	ec06                	sd	ra,24(sp)
    3e82:	e822                	sd	s0,16(sp)
    3e84:	e426                	sd	s1,8(sp)
    3e86:	1000                	addi	s0,sp,32
    3e88:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3e8a:	00004517          	auipc	a0,0x4
    3e8e:	ba650513          	addi	a0,a0,-1114 # 7a30 <malloc+0x19fc>
    3e92:	00002097          	auipc	ra,0x2
    3e96:	dd4080e7          	jalr	-556(ra) # 5c66 <mkdir>
    3e9a:	e549                	bnez	a0,3f24 <rmdot+0xa6>
  if(chdir("dots") != 0){
    3e9c:	00004517          	auipc	a0,0x4
    3ea0:	b9450513          	addi	a0,a0,-1132 # 7a30 <malloc+0x19fc>
    3ea4:	00002097          	auipc	ra,0x2
    3ea8:	dca080e7          	jalr	-566(ra) # 5c6e <chdir>
    3eac:	e951                	bnez	a0,3f40 <rmdot+0xc2>
  if(unlink(".") == 0){
    3eae:	00003517          	auipc	a0,0x3
    3eb2:	9b250513          	addi	a0,a0,-1614 # 6860 <malloc+0x82c>
    3eb6:	00002097          	auipc	ra,0x2
    3eba:	d98080e7          	jalr	-616(ra) # 5c4e <unlink>
    3ebe:	cd59                	beqz	a0,3f5c <rmdot+0xde>
  if(unlink("..") == 0){
    3ec0:	00003517          	auipc	a0,0x3
    3ec4:	5c850513          	addi	a0,a0,1480 # 7488 <malloc+0x1454>
    3ec8:	00002097          	auipc	ra,0x2
    3ecc:	d86080e7          	jalr	-634(ra) # 5c4e <unlink>
    3ed0:	c545                	beqz	a0,3f78 <rmdot+0xfa>
  if(chdir("/") != 0){
    3ed2:	00003517          	auipc	a0,0x3
    3ed6:	55e50513          	addi	a0,a0,1374 # 7430 <malloc+0x13fc>
    3eda:	00002097          	auipc	ra,0x2
    3ede:	d94080e7          	jalr	-620(ra) # 5c6e <chdir>
    3ee2:	e94d                	bnez	a0,3f94 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3ee4:	00004517          	auipc	a0,0x4
    3ee8:	bb450513          	addi	a0,a0,-1100 # 7a98 <malloc+0x1a64>
    3eec:	00002097          	auipc	ra,0x2
    3ef0:	d62080e7          	jalr	-670(ra) # 5c4e <unlink>
    3ef4:	cd55                	beqz	a0,3fb0 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3ef6:	00004517          	auipc	a0,0x4
    3efa:	bca50513          	addi	a0,a0,-1078 # 7ac0 <malloc+0x1a8c>
    3efe:	00002097          	auipc	ra,0x2
    3f02:	d50080e7          	jalr	-688(ra) # 5c4e <unlink>
    3f06:	c179                	beqz	a0,3fcc <rmdot+0x14e>
  if(unlink("dots") != 0){
    3f08:	00004517          	auipc	a0,0x4
    3f0c:	b2850513          	addi	a0,a0,-1240 # 7a30 <malloc+0x19fc>
    3f10:	00002097          	auipc	ra,0x2
    3f14:	d3e080e7          	jalr	-706(ra) # 5c4e <unlink>
    3f18:	e961                	bnez	a0,3fe8 <rmdot+0x16a>
}
    3f1a:	60e2                	ld	ra,24(sp)
    3f1c:	6442                	ld	s0,16(sp)
    3f1e:	64a2                	ld	s1,8(sp)
    3f20:	6105                	addi	sp,sp,32
    3f22:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3f24:	85a6                	mv	a1,s1
    3f26:	00004517          	auipc	a0,0x4
    3f2a:	b1250513          	addi	a0,a0,-1262 # 7a38 <malloc+0x1a04>
    3f2e:	00002097          	auipc	ra,0x2
    3f32:	048080e7          	jalr	72(ra) # 5f76 <printf>
    exit(1);
    3f36:	4505                	li	a0,1
    3f38:	00002097          	auipc	ra,0x2
    3f3c:	cc6080e7          	jalr	-826(ra) # 5bfe <exit>
    printf("%s: chdir dots failed\n", s);
    3f40:	85a6                	mv	a1,s1
    3f42:	00004517          	auipc	a0,0x4
    3f46:	b0e50513          	addi	a0,a0,-1266 # 7a50 <malloc+0x1a1c>
    3f4a:	00002097          	auipc	ra,0x2
    3f4e:	02c080e7          	jalr	44(ra) # 5f76 <printf>
    exit(1);
    3f52:	4505                	li	a0,1
    3f54:	00002097          	auipc	ra,0x2
    3f58:	caa080e7          	jalr	-854(ra) # 5bfe <exit>
    printf("%s: rm . worked!\n", s);
    3f5c:	85a6                	mv	a1,s1
    3f5e:	00004517          	auipc	a0,0x4
    3f62:	b0a50513          	addi	a0,a0,-1270 # 7a68 <malloc+0x1a34>
    3f66:	00002097          	auipc	ra,0x2
    3f6a:	010080e7          	jalr	16(ra) # 5f76 <printf>
    exit(1);
    3f6e:	4505                	li	a0,1
    3f70:	00002097          	auipc	ra,0x2
    3f74:	c8e080e7          	jalr	-882(ra) # 5bfe <exit>
    printf("%s: rm .. worked!\n", s);
    3f78:	85a6                	mv	a1,s1
    3f7a:	00004517          	auipc	a0,0x4
    3f7e:	b0650513          	addi	a0,a0,-1274 # 7a80 <malloc+0x1a4c>
    3f82:	00002097          	auipc	ra,0x2
    3f86:	ff4080e7          	jalr	-12(ra) # 5f76 <printf>
    exit(1);
    3f8a:	4505                	li	a0,1
    3f8c:	00002097          	auipc	ra,0x2
    3f90:	c72080e7          	jalr	-910(ra) # 5bfe <exit>
    printf("%s: chdir / failed\n", s);
    3f94:	85a6                	mv	a1,s1
    3f96:	00003517          	auipc	a0,0x3
    3f9a:	4a250513          	addi	a0,a0,1186 # 7438 <malloc+0x1404>
    3f9e:	00002097          	auipc	ra,0x2
    3fa2:	fd8080e7          	jalr	-40(ra) # 5f76 <printf>
    exit(1);
    3fa6:	4505                	li	a0,1
    3fa8:	00002097          	auipc	ra,0x2
    3fac:	c56080e7          	jalr	-938(ra) # 5bfe <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3fb0:	85a6                	mv	a1,s1
    3fb2:	00004517          	auipc	a0,0x4
    3fb6:	aee50513          	addi	a0,a0,-1298 # 7aa0 <malloc+0x1a6c>
    3fba:	00002097          	auipc	ra,0x2
    3fbe:	fbc080e7          	jalr	-68(ra) # 5f76 <printf>
    exit(1);
    3fc2:	4505                	li	a0,1
    3fc4:	00002097          	auipc	ra,0x2
    3fc8:	c3a080e7          	jalr	-966(ra) # 5bfe <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3fcc:	85a6                	mv	a1,s1
    3fce:	00004517          	auipc	a0,0x4
    3fd2:	afa50513          	addi	a0,a0,-1286 # 7ac8 <malloc+0x1a94>
    3fd6:	00002097          	auipc	ra,0x2
    3fda:	fa0080e7          	jalr	-96(ra) # 5f76 <printf>
    exit(1);
    3fde:	4505                	li	a0,1
    3fe0:	00002097          	auipc	ra,0x2
    3fe4:	c1e080e7          	jalr	-994(ra) # 5bfe <exit>
    printf("%s: unlink dots failed!\n", s);
    3fe8:	85a6                	mv	a1,s1
    3fea:	00004517          	auipc	a0,0x4
    3fee:	afe50513          	addi	a0,a0,-1282 # 7ae8 <malloc+0x1ab4>
    3ff2:	00002097          	auipc	ra,0x2
    3ff6:	f84080e7          	jalr	-124(ra) # 5f76 <printf>
    exit(1);
    3ffa:	4505                	li	a0,1
    3ffc:	00002097          	auipc	ra,0x2
    4000:	c02080e7          	jalr	-1022(ra) # 5bfe <exit>

0000000000004004 <dirfile>:
{
    4004:	1101                	addi	sp,sp,-32
    4006:	ec06                	sd	ra,24(sp)
    4008:	e822                	sd	s0,16(sp)
    400a:	e426                	sd	s1,8(sp)
    400c:	e04a                	sd	s2,0(sp)
    400e:	1000                	addi	s0,sp,32
    4010:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    4012:	20000593          	li	a1,512
    4016:	00004517          	auipc	a0,0x4
    401a:	af250513          	addi	a0,a0,-1294 # 7b08 <malloc+0x1ad4>
    401e:	00002097          	auipc	ra,0x2
    4022:	c20080e7          	jalr	-992(ra) # 5c3e <open>
  if(fd < 0){
    4026:	0e054d63          	bltz	a0,4120 <dirfile+0x11c>
  close(fd);
    402a:	00002097          	auipc	ra,0x2
    402e:	bfc080e7          	jalr	-1028(ra) # 5c26 <close>
  if(chdir("dirfile") == 0){
    4032:	00004517          	auipc	a0,0x4
    4036:	ad650513          	addi	a0,a0,-1322 # 7b08 <malloc+0x1ad4>
    403a:	00002097          	auipc	ra,0x2
    403e:	c34080e7          	jalr	-972(ra) # 5c6e <chdir>
    4042:	cd6d                	beqz	a0,413c <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    4044:	4581                	li	a1,0
    4046:	00004517          	auipc	a0,0x4
    404a:	b0a50513          	addi	a0,a0,-1270 # 7b50 <malloc+0x1b1c>
    404e:	00002097          	auipc	ra,0x2
    4052:	bf0080e7          	jalr	-1040(ra) # 5c3e <open>
  if(fd >= 0){
    4056:	10055163          	bgez	a0,4158 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    405a:	20000593          	li	a1,512
    405e:	00004517          	auipc	a0,0x4
    4062:	af250513          	addi	a0,a0,-1294 # 7b50 <malloc+0x1b1c>
    4066:	00002097          	auipc	ra,0x2
    406a:	bd8080e7          	jalr	-1064(ra) # 5c3e <open>
  if(fd >= 0){
    406e:	10055363          	bgez	a0,4174 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    4072:	00004517          	auipc	a0,0x4
    4076:	ade50513          	addi	a0,a0,-1314 # 7b50 <malloc+0x1b1c>
    407a:	00002097          	auipc	ra,0x2
    407e:	bec080e7          	jalr	-1044(ra) # 5c66 <mkdir>
    4082:	10050763          	beqz	a0,4190 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    4086:	00004517          	auipc	a0,0x4
    408a:	aca50513          	addi	a0,a0,-1334 # 7b50 <malloc+0x1b1c>
    408e:	00002097          	auipc	ra,0x2
    4092:	bc0080e7          	jalr	-1088(ra) # 5c4e <unlink>
    4096:	10050b63          	beqz	a0,41ac <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    409a:	00004597          	auipc	a1,0x4
    409e:	ab658593          	addi	a1,a1,-1354 # 7b50 <malloc+0x1b1c>
    40a2:	00002517          	auipc	a0,0x2
    40a6:	2ae50513          	addi	a0,a0,686 # 6350 <malloc+0x31c>
    40aa:	00002097          	auipc	ra,0x2
    40ae:	bb4080e7          	jalr	-1100(ra) # 5c5e <link>
    40b2:	10050b63          	beqz	a0,41c8 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    40b6:	00004517          	auipc	a0,0x4
    40ba:	a5250513          	addi	a0,a0,-1454 # 7b08 <malloc+0x1ad4>
    40be:	00002097          	auipc	ra,0x2
    40c2:	b90080e7          	jalr	-1136(ra) # 5c4e <unlink>
    40c6:	10051f63          	bnez	a0,41e4 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    40ca:	4589                	li	a1,2
    40cc:	00002517          	auipc	a0,0x2
    40d0:	79450513          	addi	a0,a0,1940 # 6860 <malloc+0x82c>
    40d4:	00002097          	auipc	ra,0x2
    40d8:	b6a080e7          	jalr	-1174(ra) # 5c3e <open>
  if(fd >= 0){
    40dc:	12055263          	bgez	a0,4200 <dirfile+0x1fc>
  fd = open(".", 0);
    40e0:	4581                	li	a1,0
    40e2:	00002517          	auipc	a0,0x2
    40e6:	77e50513          	addi	a0,a0,1918 # 6860 <malloc+0x82c>
    40ea:	00002097          	auipc	ra,0x2
    40ee:	b54080e7          	jalr	-1196(ra) # 5c3e <open>
    40f2:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    40f4:	4605                	li	a2,1
    40f6:	00002597          	auipc	a1,0x2
    40fa:	0f258593          	addi	a1,a1,242 # 61e8 <malloc+0x1b4>
    40fe:	00002097          	auipc	ra,0x2
    4102:	b20080e7          	jalr	-1248(ra) # 5c1e <write>
    4106:	10a04b63          	bgtz	a0,421c <dirfile+0x218>
  close(fd);
    410a:	8526                	mv	a0,s1
    410c:	00002097          	auipc	ra,0x2
    4110:	b1a080e7          	jalr	-1254(ra) # 5c26 <close>
}
    4114:	60e2                	ld	ra,24(sp)
    4116:	6442                	ld	s0,16(sp)
    4118:	64a2                	ld	s1,8(sp)
    411a:	6902                	ld	s2,0(sp)
    411c:	6105                	addi	sp,sp,32
    411e:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    4120:	85ca                	mv	a1,s2
    4122:	00004517          	auipc	a0,0x4
    4126:	9ee50513          	addi	a0,a0,-1554 # 7b10 <malloc+0x1adc>
    412a:	00002097          	auipc	ra,0x2
    412e:	e4c080e7          	jalr	-436(ra) # 5f76 <printf>
    exit(1);
    4132:	4505                	li	a0,1
    4134:	00002097          	auipc	ra,0x2
    4138:	aca080e7          	jalr	-1334(ra) # 5bfe <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    413c:	85ca                	mv	a1,s2
    413e:	00004517          	auipc	a0,0x4
    4142:	9f250513          	addi	a0,a0,-1550 # 7b30 <malloc+0x1afc>
    4146:	00002097          	auipc	ra,0x2
    414a:	e30080e7          	jalr	-464(ra) # 5f76 <printf>
    exit(1);
    414e:	4505                	li	a0,1
    4150:	00002097          	auipc	ra,0x2
    4154:	aae080e7          	jalr	-1362(ra) # 5bfe <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4158:	85ca                	mv	a1,s2
    415a:	00004517          	auipc	a0,0x4
    415e:	a0650513          	addi	a0,a0,-1530 # 7b60 <malloc+0x1b2c>
    4162:	00002097          	auipc	ra,0x2
    4166:	e14080e7          	jalr	-492(ra) # 5f76 <printf>
    exit(1);
    416a:	4505                	li	a0,1
    416c:	00002097          	auipc	ra,0x2
    4170:	a92080e7          	jalr	-1390(ra) # 5bfe <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4174:	85ca                	mv	a1,s2
    4176:	00004517          	auipc	a0,0x4
    417a:	9ea50513          	addi	a0,a0,-1558 # 7b60 <malloc+0x1b2c>
    417e:	00002097          	auipc	ra,0x2
    4182:	df8080e7          	jalr	-520(ra) # 5f76 <printf>
    exit(1);
    4186:	4505                	li	a0,1
    4188:	00002097          	auipc	ra,0x2
    418c:	a76080e7          	jalr	-1418(ra) # 5bfe <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4190:	85ca                	mv	a1,s2
    4192:	00004517          	auipc	a0,0x4
    4196:	9f650513          	addi	a0,a0,-1546 # 7b88 <malloc+0x1b54>
    419a:	00002097          	auipc	ra,0x2
    419e:	ddc080e7          	jalr	-548(ra) # 5f76 <printf>
    exit(1);
    41a2:	4505                	li	a0,1
    41a4:	00002097          	auipc	ra,0x2
    41a8:	a5a080e7          	jalr	-1446(ra) # 5bfe <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    41ac:	85ca                	mv	a1,s2
    41ae:	00004517          	auipc	a0,0x4
    41b2:	a0250513          	addi	a0,a0,-1534 # 7bb0 <malloc+0x1b7c>
    41b6:	00002097          	auipc	ra,0x2
    41ba:	dc0080e7          	jalr	-576(ra) # 5f76 <printf>
    exit(1);
    41be:	4505                	li	a0,1
    41c0:	00002097          	auipc	ra,0x2
    41c4:	a3e080e7          	jalr	-1474(ra) # 5bfe <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    41c8:	85ca                	mv	a1,s2
    41ca:	00004517          	auipc	a0,0x4
    41ce:	a0e50513          	addi	a0,a0,-1522 # 7bd8 <malloc+0x1ba4>
    41d2:	00002097          	auipc	ra,0x2
    41d6:	da4080e7          	jalr	-604(ra) # 5f76 <printf>
    exit(1);
    41da:	4505                	li	a0,1
    41dc:	00002097          	auipc	ra,0x2
    41e0:	a22080e7          	jalr	-1502(ra) # 5bfe <exit>
    printf("%s: unlink dirfile failed!\n", s);
    41e4:	85ca                	mv	a1,s2
    41e6:	00004517          	auipc	a0,0x4
    41ea:	a1a50513          	addi	a0,a0,-1510 # 7c00 <malloc+0x1bcc>
    41ee:	00002097          	auipc	ra,0x2
    41f2:	d88080e7          	jalr	-632(ra) # 5f76 <printf>
    exit(1);
    41f6:	4505                	li	a0,1
    41f8:	00002097          	auipc	ra,0x2
    41fc:	a06080e7          	jalr	-1530(ra) # 5bfe <exit>
    printf("%s: open . for writing succeeded!\n", s);
    4200:	85ca                	mv	a1,s2
    4202:	00004517          	auipc	a0,0x4
    4206:	a1e50513          	addi	a0,a0,-1506 # 7c20 <malloc+0x1bec>
    420a:	00002097          	auipc	ra,0x2
    420e:	d6c080e7          	jalr	-660(ra) # 5f76 <printf>
    exit(1);
    4212:	4505                	li	a0,1
    4214:	00002097          	auipc	ra,0x2
    4218:	9ea080e7          	jalr	-1558(ra) # 5bfe <exit>
    printf("%s: write . succeeded!\n", s);
    421c:	85ca                	mv	a1,s2
    421e:	00004517          	auipc	a0,0x4
    4222:	a2a50513          	addi	a0,a0,-1494 # 7c48 <malloc+0x1c14>
    4226:	00002097          	auipc	ra,0x2
    422a:	d50080e7          	jalr	-688(ra) # 5f76 <printf>
    exit(1);
    422e:	4505                	li	a0,1
    4230:	00002097          	auipc	ra,0x2
    4234:	9ce080e7          	jalr	-1586(ra) # 5bfe <exit>

0000000000004238 <iref>:
{
    4238:	7139                	addi	sp,sp,-64
    423a:	fc06                	sd	ra,56(sp)
    423c:	f822                	sd	s0,48(sp)
    423e:	f426                	sd	s1,40(sp)
    4240:	f04a                	sd	s2,32(sp)
    4242:	ec4e                	sd	s3,24(sp)
    4244:	e852                	sd	s4,16(sp)
    4246:	e456                	sd	s5,8(sp)
    4248:	e05a                	sd	s6,0(sp)
    424a:	0080                	addi	s0,sp,64
    424c:	8b2a                	mv	s6,a0
    424e:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    4252:	00004a17          	auipc	s4,0x4
    4256:	a0ea0a13          	addi	s4,s4,-1522 # 7c60 <malloc+0x1c2c>
    mkdir("");
    425a:	00003497          	auipc	s1,0x3
    425e:	50e48493          	addi	s1,s1,1294 # 7768 <malloc+0x1734>
    link("README", "");
    4262:	00002a97          	auipc	s5,0x2
    4266:	0eea8a93          	addi	s5,s5,238 # 6350 <malloc+0x31c>
    fd = open("xx", O_CREATE);
    426a:	00004997          	auipc	s3,0x4
    426e:	8ee98993          	addi	s3,s3,-1810 # 7b58 <malloc+0x1b24>
    4272:	a891                	j	42c6 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    4274:	85da                	mv	a1,s6
    4276:	00004517          	auipc	a0,0x4
    427a:	9f250513          	addi	a0,a0,-1550 # 7c68 <malloc+0x1c34>
    427e:	00002097          	auipc	ra,0x2
    4282:	cf8080e7          	jalr	-776(ra) # 5f76 <printf>
      exit(1);
    4286:	4505                	li	a0,1
    4288:	00002097          	auipc	ra,0x2
    428c:	976080e7          	jalr	-1674(ra) # 5bfe <exit>
      printf("%s: chdir irefd failed\n", s);
    4290:	85da                	mv	a1,s6
    4292:	00004517          	auipc	a0,0x4
    4296:	9ee50513          	addi	a0,a0,-1554 # 7c80 <malloc+0x1c4c>
    429a:	00002097          	auipc	ra,0x2
    429e:	cdc080e7          	jalr	-804(ra) # 5f76 <printf>
      exit(1);
    42a2:	4505                	li	a0,1
    42a4:	00002097          	auipc	ra,0x2
    42a8:	95a080e7          	jalr	-1702(ra) # 5bfe <exit>
      close(fd);
    42ac:	00002097          	auipc	ra,0x2
    42b0:	97a080e7          	jalr	-1670(ra) # 5c26 <close>
    42b4:	a889                	j	4306 <iref+0xce>
    unlink("xx");
    42b6:	854e                	mv	a0,s3
    42b8:	00002097          	auipc	ra,0x2
    42bc:	996080e7          	jalr	-1642(ra) # 5c4e <unlink>
  for(i = 0; i < NINODE + 1; i++){
    42c0:	397d                	addiw	s2,s2,-1
    42c2:	06090063          	beqz	s2,4322 <iref+0xea>
    if(mkdir("irefd") != 0){
    42c6:	8552                	mv	a0,s4
    42c8:	00002097          	auipc	ra,0x2
    42cc:	99e080e7          	jalr	-1634(ra) # 5c66 <mkdir>
    42d0:	f155                	bnez	a0,4274 <iref+0x3c>
    if(chdir("irefd") != 0){
    42d2:	8552                	mv	a0,s4
    42d4:	00002097          	auipc	ra,0x2
    42d8:	99a080e7          	jalr	-1638(ra) # 5c6e <chdir>
    42dc:	f955                	bnez	a0,4290 <iref+0x58>
    mkdir("");
    42de:	8526                	mv	a0,s1
    42e0:	00002097          	auipc	ra,0x2
    42e4:	986080e7          	jalr	-1658(ra) # 5c66 <mkdir>
    link("README", "");
    42e8:	85a6                	mv	a1,s1
    42ea:	8556                	mv	a0,s5
    42ec:	00002097          	auipc	ra,0x2
    42f0:	972080e7          	jalr	-1678(ra) # 5c5e <link>
    fd = open("", O_CREATE);
    42f4:	20000593          	li	a1,512
    42f8:	8526                	mv	a0,s1
    42fa:	00002097          	auipc	ra,0x2
    42fe:	944080e7          	jalr	-1724(ra) # 5c3e <open>
    if(fd >= 0)
    4302:	fa0555e3          	bgez	a0,42ac <iref+0x74>
    fd = open("xx", O_CREATE);
    4306:	20000593          	li	a1,512
    430a:	854e                	mv	a0,s3
    430c:	00002097          	auipc	ra,0x2
    4310:	932080e7          	jalr	-1742(ra) # 5c3e <open>
    if(fd >= 0)
    4314:	fa0541e3          	bltz	a0,42b6 <iref+0x7e>
      close(fd);
    4318:	00002097          	auipc	ra,0x2
    431c:	90e080e7          	jalr	-1778(ra) # 5c26 <close>
    4320:	bf59                	j	42b6 <iref+0x7e>
    4322:	03300493          	li	s1,51
    chdir("..");
    4326:	00003997          	auipc	s3,0x3
    432a:	16298993          	addi	s3,s3,354 # 7488 <malloc+0x1454>
    unlink("irefd");
    432e:	00004917          	auipc	s2,0x4
    4332:	93290913          	addi	s2,s2,-1742 # 7c60 <malloc+0x1c2c>
    chdir("..");
    4336:	854e                	mv	a0,s3
    4338:	00002097          	auipc	ra,0x2
    433c:	936080e7          	jalr	-1738(ra) # 5c6e <chdir>
    unlink("irefd");
    4340:	854a                	mv	a0,s2
    4342:	00002097          	auipc	ra,0x2
    4346:	90c080e7          	jalr	-1780(ra) # 5c4e <unlink>
  for(i = 0; i < NINODE + 1; i++){
    434a:	34fd                	addiw	s1,s1,-1
    434c:	f4ed                	bnez	s1,4336 <iref+0xfe>
  chdir("/");
    434e:	00003517          	auipc	a0,0x3
    4352:	0e250513          	addi	a0,a0,226 # 7430 <malloc+0x13fc>
    4356:	00002097          	auipc	ra,0x2
    435a:	918080e7          	jalr	-1768(ra) # 5c6e <chdir>
}
    435e:	70e2                	ld	ra,56(sp)
    4360:	7442                	ld	s0,48(sp)
    4362:	74a2                	ld	s1,40(sp)
    4364:	7902                	ld	s2,32(sp)
    4366:	69e2                	ld	s3,24(sp)
    4368:	6a42                	ld	s4,16(sp)
    436a:	6aa2                	ld	s5,8(sp)
    436c:	6b02                	ld	s6,0(sp)
    436e:	6121                	addi	sp,sp,64
    4370:	8082                	ret

0000000000004372 <openiputtest>:
{
    4372:	7179                	addi	sp,sp,-48
    4374:	f406                	sd	ra,40(sp)
    4376:	f022                	sd	s0,32(sp)
    4378:	ec26                	sd	s1,24(sp)
    437a:	1800                	addi	s0,sp,48
    437c:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    437e:	00004517          	auipc	a0,0x4
    4382:	91a50513          	addi	a0,a0,-1766 # 7c98 <malloc+0x1c64>
    4386:	00002097          	auipc	ra,0x2
    438a:	8e0080e7          	jalr	-1824(ra) # 5c66 <mkdir>
    438e:	04054263          	bltz	a0,43d2 <openiputtest+0x60>
  pid = fork();
    4392:	00002097          	auipc	ra,0x2
    4396:	864080e7          	jalr	-1948(ra) # 5bf6 <fork>
  if(pid < 0){
    439a:	04054a63          	bltz	a0,43ee <openiputtest+0x7c>
  if(pid == 0){
    439e:	e93d                	bnez	a0,4414 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    43a0:	4589                	li	a1,2
    43a2:	00004517          	auipc	a0,0x4
    43a6:	8f650513          	addi	a0,a0,-1802 # 7c98 <malloc+0x1c64>
    43aa:	00002097          	auipc	ra,0x2
    43ae:	894080e7          	jalr	-1900(ra) # 5c3e <open>
    if(fd >= 0){
    43b2:	04054c63          	bltz	a0,440a <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    43b6:	85a6                	mv	a1,s1
    43b8:	00004517          	auipc	a0,0x4
    43bc:	90050513          	addi	a0,a0,-1792 # 7cb8 <malloc+0x1c84>
    43c0:	00002097          	auipc	ra,0x2
    43c4:	bb6080e7          	jalr	-1098(ra) # 5f76 <printf>
      exit(1);
    43c8:	4505                	li	a0,1
    43ca:	00002097          	auipc	ra,0x2
    43ce:	834080e7          	jalr	-1996(ra) # 5bfe <exit>
    printf("%s: mkdir oidir failed\n", s);
    43d2:	85a6                	mv	a1,s1
    43d4:	00004517          	auipc	a0,0x4
    43d8:	8cc50513          	addi	a0,a0,-1844 # 7ca0 <malloc+0x1c6c>
    43dc:	00002097          	auipc	ra,0x2
    43e0:	b9a080e7          	jalr	-1126(ra) # 5f76 <printf>
    exit(1);
    43e4:	4505                	li	a0,1
    43e6:	00002097          	auipc	ra,0x2
    43ea:	818080e7          	jalr	-2024(ra) # 5bfe <exit>
    printf("%s: fork failed\n", s);
    43ee:	85a6                	mv	a1,s1
    43f0:	00002517          	auipc	a0,0x2
    43f4:	61050513          	addi	a0,a0,1552 # 6a00 <malloc+0x9cc>
    43f8:	00002097          	auipc	ra,0x2
    43fc:	b7e080e7          	jalr	-1154(ra) # 5f76 <printf>
    exit(1);
    4400:	4505                	li	a0,1
    4402:	00001097          	auipc	ra,0x1
    4406:	7fc080e7          	jalr	2044(ra) # 5bfe <exit>
    exit(0);
    440a:	4501                	li	a0,0
    440c:	00001097          	auipc	ra,0x1
    4410:	7f2080e7          	jalr	2034(ra) # 5bfe <exit>
  sleep(1);
    4414:	4505                	li	a0,1
    4416:	00002097          	auipc	ra,0x2
    441a:	878080e7          	jalr	-1928(ra) # 5c8e <sleep>
  if(unlink("oidir") != 0){
    441e:	00004517          	auipc	a0,0x4
    4422:	87a50513          	addi	a0,a0,-1926 # 7c98 <malloc+0x1c64>
    4426:	00002097          	auipc	ra,0x2
    442a:	828080e7          	jalr	-2008(ra) # 5c4e <unlink>
    442e:	cd19                	beqz	a0,444c <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    4430:	85a6                	mv	a1,s1
    4432:	00002517          	auipc	a0,0x2
    4436:	7be50513          	addi	a0,a0,1982 # 6bf0 <malloc+0xbbc>
    443a:	00002097          	auipc	ra,0x2
    443e:	b3c080e7          	jalr	-1220(ra) # 5f76 <printf>
    exit(1);
    4442:	4505                	li	a0,1
    4444:	00001097          	auipc	ra,0x1
    4448:	7ba080e7          	jalr	1978(ra) # 5bfe <exit>
  wait(&xstatus);
    444c:	fdc40513          	addi	a0,s0,-36
    4450:	00001097          	auipc	ra,0x1
    4454:	7b6080e7          	jalr	1974(ra) # 5c06 <wait>
  exit(xstatus);
    4458:	fdc42503          	lw	a0,-36(s0)
    445c:	00001097          	auipc	ra,0x1
    4460:	7a2080e7          	jalr	1954(ra) # 5bfe <exit>

0000000000004464 <forkforkfork>:
{
    4464:	1101                	addi	sp,sp,-32
    4466:	ec06                	sd	ra,24(sp)
    4468:	e822                	sd	s0,16(sp)
    446a:	e426                	sd	s1,8(sp)
    446c:	1000                	addi	s0,sp,32
    446e:	84aa                	mv	s1,a0
  unlink("stopforking");
    4470:	00004517          	auipc	a0,0x4
    4474:	87050513          	addi	a0,a0,-1936 # 7ce0 <malloc+0x1cac>
    4478:	00001097          	auipc	ra,0x1
    447c:	7d6080e7          	jalr	2006(ra) # 5c4e <unlink>
  int pid = fork();
    4480:	00001097          	auipc	ra,0x1
    4484:	776080e7          	jalr	1910(ra) # 5bf6 <fork>
  if(pid < 0){
    4488:	04054563          	bltz	a0,44d2 <forkforkfork+0x6e>
  if(pid == 0){
    448c:	c12d                	beqz	a0,44ee <forkforkfork+0x8a>
  sleep(20); // two seconds
    448e:	4551                	li	a0,20
    4490:	00001097          	auipc	ra,0x1
    4494:	7fe080e7          	jalr	2046(ra) # 5c8e <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    4498:	20200593          	li	a1,514
    449c:	00004517          	auipc	a0,0x4
    44a0:	84450513          	addi	a0,a0,-1980 # 7ce0 <malloc+0x1cac>
    44a4:	00001097          	auipc	ra,0x1
    44a8:	79a080e7          	jalr	1946(ra) # 5c3e <open>
    44ac:	00001097          	auipc	ra,0x1
    44b0:	77a080e7          	jalr	1914(ra) # 5c26 <close>
  wait(0);
    44b4:	4501                	li	a0,0
    44b6:	00001097          	auipc	ra,0x1
    44ba:	750080e7          	jalr	1872(ra) # 5c06 <wait>
  sleep(10); // one second
    44be:	4529                	li	a0,10
    44c0:	00001097          	auipc	ra,0x1
    44c4:	7ce080e7          	jalr	1998(ra) # 5c8e <sleep>
}
    44c8:	60e2                	ld	ra,24(sp)
    44ca:	6442                	ld	s0,16(sp)
    44cc:	64a2                	ld	s1,8(sp)
    44ce:	6105                	addi	sp,sp,32
    44d0:	8082                	ret
    printf("%s: fork failed", s);
    44d2:	85a6                	mv	a1,s1
    44d4:	00002517          	auipc	a0,0x2
    44d8:	6ec50513          	addi	a0,a0,1772 # 6bc0 <malloc+0xb8c>
    44dc:	00002097          	auipc	ra,0x2
    44e0:	a9a080e7          	jalr	-1382(ra) # 5f76 <printf>
    exit(1);
    44e4:	4505                	li	a0,1
    44e6:	00001097          	auipc	ra,0x1
    44ea:	718080e7          	jalr	1816(ra) # 5bfe <exit>
      int fd = open("stopforking", 0);
    44ee:	00003497          	auipc	s1,0x3
    44f2:	7f248493          	addi	s1,s1,2034 # 7ce0 <malloc+0x1cac>
    44f6:	4581                	li	a1,0
    44f8:	8526                	mv	a0,s1
    44fa:	00001097          	auipc	ra,0x1
    44fe:	744080e7          	jalr	1860(ra) # 5c3e <open>
      if(fd >= 0){
    4502:	02055463          	bgez	a0,452a <forkforkfork+0xc6>
      if(fork() < 0){
    4506:	00001097          	auipc	ra,0x1
    450a:	6f0080e7          	jalr	1776(ra) # 5bf6 <fork>
    450e:	fe0554e3          	bgez	a0,44f6 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    4512:	20200593          	li	a1,514
    4516:	8526                	mv	a0,s1
    4518:	00001097          	auipc	ra,0x1
    451c:	726080e7          	jalr	1830(ra) # 5c3e <open>
    4520:	00001097          	auipc	ra,0x1
    4524:	706080e7          	jalr	1798(ra) # 5c26 <close>
    4528:	b7f9                	j	44f6 <forkforkfork+0x92>
        exit(0);
    452a:	4501                	li	a0,0
    452c:	00001097          	auipc	ra,0x1
    4530:	6d2080e7          	jalr	1746(ra) # 5bfe <exit>

0000000000004534 <killstatus>:
{
    4534:	7139                	addi	sp,sp,-64
    4536:	fc06                	sd	ra,56(sp)
    4538:	f822                	sd	s0,48(sp)
    453a:	f426                	sd	s1,40(sp)
    453c:	f04a                	sd	s2,32(sp)
    453e:	ec4e                	sd	s3,24(sp)
    4540:	e852                	sd	s4,16(sp)
    4542:	0080                	addi	s0,sp,64
    4544:	8a2a                	mv	s4,a0
    4546:	06400913          	li	s2,100
    if(xst != -1) {
    454a:	59fd                	li	s3,-1
    int pid1 = fork();
    454c:	00001097          	auipc	ra,0x1
    4550:	6aa080e7          	jalr	1706(ra) # 5bf6 <fork>
    4554:	84aa                	mv	s1,a0
    if(pid1 < 0){
    4556:	02054f63          	bltz	a0,4594 <killstatus+0x60>
    if(pid1 == 0){
    455a:	c939                	beqz	a0,45b0 <killstatus+0x7c>
    sleep(1);
    455c:	4505                	li	a0,1
    455e:	00001097          	auipc	ra,0x1
    4562:	730080e7          	jalr	1840(ra) # 5c8e <sleep>
    kill(pid1);
    4566:	8526                	mv	a0,s1
    4568:	00001097          	auipc	ra,0x1
    456c:	6c6080e7          	jalr	1734(ra) # 5c2e <kill>
    wait(&xst);
    4570:	fcc40513          	addi	a0,s0,-52
    4574:	00001097          	auipc	ra,0x1
    4578:	692080e7          	jalr	1682(ra) # 5c06 <wait>
    if(xst != -1) {
    457c:	fcc42783          	lw	a5,-52(s0)
    4580:	03379d63          	bne	a5,s3,45ba <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    4584:	397d                	addiw	s2,s2,-1
    4586:	fc0913e3          	bnez	s2,454c <killstatus+0x18>
  exit(0);
    458a:	4501                	li	a0,0
    458c:	00001097          	auipc	ra,0x1
    4590:	672080e7          	jalr	1650(ra) # 5bfe <exit>
      printf("%s: fork failed\n", s);
    4594:	85d2                	mv	a1,s4
    4596:	00002517          	auipc	a0,0x2
    459a:	46a50513          	addi	a0,a0,1130 # 6a00 <malloc+0x9cc>
    459e:	00002097          	auipc	ra,0x2
    45a2:	9d8080e7          	jalr	-1576(ra) # 5f76 <printf>
      exit(1);
    45a6:	4505                	li	a0,1
    45a8:	00001097          	auipc	ra,0x1
    45ac:	656080e7          	jalr	1622(ra) # 5bfe <exit>
        getpid();
    45b0:	00001097          	auipc	ra,0x1
    45b4:	6ce080e7          	jalr	1742(ra) # 5c7e <getpid>
      while(1) {
    45b8:	bfe5                	j	45b0 <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    45ba:	85d2                	mv	a1,s4
    45bc:	00003517          	auipc	a0,0x3
    45c0:	73450513          	addi	a0,a0,1844 # 7cf0 <malloc+0x1cbc>
    45c4:	00002097          	auipc	ra,0x2
    45c8:	9b2080e7          	jalr	-1614(ra) # 5f76 <printf>
       exit(1);
    45cc:	4505                	li	a0,1
    45ce:	00001097          	auipc	ra,0x1
    45d2:	630080e7          	jalr	1584(ra) # 5bfe <exit>

00000000000045d6 <preempt>:
{
    45d6:	7139                	addi	sp,sp,-64
    45d8:	fc06                	sd	ra,56(sp)
    45da:	f822                	sd	s0,48(sp)
    45dc:	f426                	sd	s1,40(sp)
    45de:	f04a                	sd	s2,32(sp)
    45e0:	ec4e                	sd	s3,24(sp)
    45e2:	e852                	sd	s4,16(sp)
    45e4:	0080                	addi	s0,sp,64
    45e6:	84aa                	mv	s1,a0
  pid1 = fork();
    45e8:	00001097          	auipc	ra,0x1
    45ec:	60e080e7          	jalr	1550(ra) # 5bf6 <fork>
  if(pid1 < 0) {
    45f0:	00054563          	bltz	a0,45fa <preempt+0x24>
    45f4:	8a2a                	mv	s4,a0
  if(pid1 == 0)
    45f6:	e105                	bnez	a0,4616 <preempt+0x40>
    for(;;)
    45f8:	a001                	j	45f8 <preempt+0x22>
    printf("%s: fork failed", s);
    45fa:	85a6                	mv	a1,s1
    45fc:	00002517          	auipc	a0,0x2
    4600:	5c450513          	addi	a0,a0,1476 # 6bc0 <malloc+0xb8c>
    4604:	00002097          	auipc	ra,0x2
    4608:	972080e7          	jalr	-1678(ra) # 5f76 <printf>
    exit(1);
    460c:	4505                	li	a0,1
    460e:	00001097          	auipc	ra,0x1
    4612:	5f0080e7          	jalr	1520(ra) # 5bfe <exit>
  pid2 = fork();
    4616:	00001097          	auipc	ra,0x1
    461a:	5e0080e7          	jalr	1504(ra) # 5bf6 <fork>
    461e:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    4620:	00054463          	bltz	a0,4628 <preempt+0x52>
  if(pid2 == 0)
    4624:	e105                	bnez	a0,4644 <preempt+0x6e>
    for(;;)
    4626:	a001                	j	4626 <preempt+0x50>
    printf("%s: fork failed\n", s);
    4628:	85a6                	mv	a1,s1
    462a:	00002517          	auipc	a0,0x2
    462e:	3d650513          	addi	a0,a0,982 # 6a00 <malloc+0x9cc>
    4632:	00002097          	auipc	ra,0x2
    4636:	944080e7          	jalr	-1724(ra) # 5f76 <printf>
    exit(1);
    463a:	4505                	li	a0,1
    463c:	00001097          	auipc	ra,0x1
    4640:	5c2080e7          	jalr	1474(ra) # 5bfe <exit>
  pipe(pfds);
    4644:	fc840513          	addi	a0,s0,-56
    4648:	00001097          	auipc	ra,0x1
    464c:	5c6080e7          	jalr	1478(ra) # 5c0e <pipe>
  pid3 = fork();
    4650:	00001097          	auipc	ra,0x1
    4654:	5a6080e7          	jalr	1446(ra) # 5bf6 <fork>
    4658:	892a                	mv	s2,a0
  if(pid3 < 0) {
    465a:	02054e63          	bltz	a0,4696 <preempt+0xc0>
  if(pid3 == 0){
    465e:	e525                	bnez	a0,46c6 <preempt+0xf0>
    close(pfds[0]);
    4660:	fc842503          	lw	a0,-56(s0)
    4664:	00001097          	auipc	ra,0x1
    4668:	5c2080e7          	jalr	1474(ra) # 5c26 <close>
    if(write(pfds[1], "x", 1) != 1)
    466c:	4605                	li	a2,1
    466e:	00002597          	auipc	a1,0x2
    4672:	b7a58593          	addi	a1,a1,-1158 # 61e8 <malloc+0x1b4>
    4676:	fcc42503          	lw	a0,-52(s0)
    467a:	00001097          	auipc	ra,0x1
    467e:	5a4080e7          	jalr	1444(ra) # 5c1e <write>
    4682:	4785                	li	a5,1
    4684:	02f51763          	bne	a0,a5,46b2 <preempt+0xdc>
    close(pfds[1]);
    4688:	fcc42503          	lw	a0,-52(s0)
    468c:	00001097          	auipc	ra,0x1
    4690:	59a080e7          	jalr	1434(ra) # 5c26 <close>
    for(;;)
    4694:	a001                	j	4694 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    4696:	85a6                	mv	a1,s1
    4698:	00002517          	auipc	a0,0x2
    469c:	36850513          	addi	a0,a0,872 # 6a00 <malloc+0x9cc>
    46a0:	00002097          	auipc	ra,0x2
    46a4:	8d6080e7          	jalr	-1834(ra) # 5f76 <printf>
     exit(1);
    46a8:	4505                	li	a0,1
    46aa:	00001097          	auipc	ra,0x1
    46ae:	554080e7          	jalr	1364(ra) # 5bfe <exit>
      printf("%s: preempt write error", s);
    46b2:	85a6                	mv	a1,s1
    46b4:	00003517          	auipc	a0,0x3
    46b8:	65c50513          	addi	a0,a0,1628 # 7d10 <malloc+0x1cdc>
    46bc:	00002097          	auipc	ra,0x2
    46c0:	8ba080e7          	jalr	-1862(ra) # 5f76 <printf>
    46c4:	b7d1                	j	4688 <preempt+0xb2>
  close(pfds[1]);
    46c6:	fcc42503          	lw	a0,-52(s0)
    46ca:	00001097          	auipc	ra,0x1
    46ce:	55c080e7          	jalr	1372(ra) # 5c26 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    46d2:	660d                	lui	a2,0x3
    46d4:	00008597          	auipc	a1,0x8
    46d8:	5a458593          	addi	a1,a1,1444 # cc78 <buf>
    46dc:	fc842503          	lw	a0,-56(s0)
    46e0:	00001097          	auipc	ra,0x1
    46e4:	536080e7          	jalr	1334(ra) # 5c16 <read>
    46e8:	4785                	li	a5,1
    46ea:	02f50363          	beq	a0,a5,4710 <preempt+0x13a>
    printf("%s: preempt read error", s);
    46ee:	85a6                	mv	a1,s1
    46f0:	00003517          	auipc	a0,0x3
    46f4:	63850513          	addi	a0,a0,1592 # 7d28 <malloc+0x1cf4>
    46f8:	00002097          	auipc	ra,0x2
    46fc:	87e080e7          	jalr	-1922(ra) # 5f76 <printf>
}
    4700:	70e2                	ld	ra,56(sp)
    4702:	7442                	ld	s0,48(sp)
    4704:	74a2                	ld	s1,40(sp)
    4706:	7902                	ld	s2,32(sp)
    4708:	69e2                	ld	s3,24(sp)
    470a:	6a42                	ld	s4,16(sp)
    470c:	6121                	addi	sp,sp,64
    470e:	8082                	ret
  close(pfds[0]);
    4710:	fc842503          	lw	a0,-56(s0)
    4714:	00001097          	auipc	ra,0x1
    4718:	512080e7          	jalr	1298(ra) # 5c26 <close>
  printf("kill... ");
    471c:	00003517          	auipc	a0,0x3
    4720:	62450513          	addi	a0,a0,1572 # 7d40 <malloc+0x1d0c>
    4724:	00002097          	auipc	ra,0x2
    4728:	852080e7          	jalr	-1966(ra) # 5f76 <printf>
  kill(pid1);
    472c:	8552                	mv	a0,s4
    472e:	00001097          	auipc	ra,0x1
    4732:	500080e7          	jalr	1280(ra) # 5c2e <kill>
  kill(pid2);
    4736:	854e                	mv	a0,s3
    4738:	00001097          	auipc	ra,0x1
    473c:	4f6080e7          	jalr	1270(ra) # 5c2e <kill>
  kill(pid3);
    4740:	854a                	mv	a0,s2
    4742:	00001097          	auipc	ra,0x1
    4746:	4ec080e7          	jalr	1260(ra) # 5c2e <kill>
  printf("wait... ");
    474a:	00003517          	auipc	a0,0x3
    474e:	60650513          	addi	a0,a0,1542 # 7d50 <malloc+0x1d1c>
    4752:	00002097          	auipc	ra,0x2
    4756:	824080e7          	jalr	-2012(ra) # 5f76 <printf>
  wait(0);
    475a:	4501                	li	a0,0
    475c:	00001097          	auipc	ra,0x1
    4760:	4aa080e7          	jalr	1194(ra) # 5c06 <wait>
  wait(0);
    4764:	4501                	li	a0,0
    4766:	00001097          	auipc	ra,0x1
    476a:	4a0080e7          	jalr	1184(ra) # 5c06 <wait>
  wait(0);
    476e:	4501                	li	a0,0
    4770:	00001097          	auipc	ra,0x1
    4774:	496080e7          	jalr	1174(ra) # 5c06 <wait>
    4778:	b761                	j	4700 <preempt+0x12a>

000000000000477a <reparent>:
{
    477a:	7179                	addi	sp,sp,-48
    477c:	f406                	sd	ra,40(sp)
    477e:	f022                	sd	s0,32(sp)
    4780:	ec26                	sd	s1,24(sp)
    4782:	e84a                	sd	s2,16(sp)
    4784:	e44e                	sd	s3,8(sp)
    4786:	e052                	sd	s4,0(sp)
    4788:	1800                	addi	s0,sp,48
    478a:	89aa                	mv	s3,a0
  int master_pid = getpid();
    478c:	00001097          	auipc	ra,0x1
    4790:	4f2080e7          	jalr	1266(ra) # 5c7e <getpid>
    4794:	8a2a                	mv	s4,a0
    4796:	0c800913          	li	s2,200
    int pid = fork();
    479a:	00001097          	auipc	ra,0x1
    479e:	45c080e7          	jalr	1116(ra) # 5bf6 <fork>
    47a2:	84aa                	mv	s1,a0
    if(pid < 0){
    47a4:	02054263          	bltz	a0,47c8 <reparent+0x4e>
    if(pid){
    47a8:	cd21                	beqz	a0,4800 <reparent+0x86>
      if(wait(0) != pid){
    47aa:	4501                	li	a0,0
    47ac:	00001097          	auipc	ra,0x1
    47b0:	45a080e7          	jalr	1114(ra) # 5c06 <wait>
    47b4:	02951863          	bne	a0,s1,47e4 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    47b8:	397d                	addiw	s2,s2,-1
    47ba:	fe0910e3          	bnez	s2,479a <reparent+0x20>
  exit(0);
    47be:	4501                	li	a0,0
    47c0:	00001097          	auipc	ra,0x1
    47c4:	43e080e7          	jalr	1086(ra) # 5bfe <exit>
      printf("%s: fork failed\n", s);
    47c8:	85ce                	mv	a1,s3
    47ca:	00002517          	auipc	a0,0x2
    47ce:	23650513          	addi	a0,a0,566 # 6a00 <malloc+0x9cc>
    47d2:	00001097          	auipc	ra,0x1
    47d6:	7a4080e7          	jalr	1956(ra) # 5f76 <printf>
      exit(1);
    47da:	4505                	li	a0,1
    47dc:	00001097          	auipc	ra,0x1
    47e0:	422080e7          	jalr	1058(ra) # 5bfe <exit>
        printf("%s: wait wrong pid\n", s);
    47e4:	85ce                	mv	a1,s3
    47e6:	00002517          	auipc	a0,0x2
    47ea:	3a250513          	addi	a0,a0,930 # 6b88 <malloc+0xb54>
    47ee:	00001097          	auipc	ra,0x1
    47f2:	788080e7          	jalr	1928(ra) # 5f76 <printf>
        exit(1);
    47f6:	4505                	li	a0,1
    47f8:	00001097          	auipc	ra,0x1
    47fc:	406080e7          	jalr	1030(ra) # 5bfe <exit>
      int pid2 = fork();
    4800:	00001097          	auipc	ra,0x1
    4804:	3f6080e7          	jalr	1014(ra) # 5bf6 <fork>
      if(pid2 < 0){
    4808:	00054763          	bltz	a0,4816 <reparent+0x9c>
      exit(0);
    480c:	4501                	li	a0,0
    480e:	00001097          	auipc	ra,0x1
    4812:	3f0080e7          	jalr	1008(ra) # 5bfe <exit>
        kill(master_pid);
    4816:	8552                	mv	a0,s4
    4818:	00001097          	auipc	ra,0x1
    481c:	416080e7          	jalr	1046(ra) # 5c2e <kill>
        exit(1);
    4820:	4505                	li	a0,1
    4822:	00001097          	auipc	ra,0x1
    4826:	3dc080e7          	jalr	988(ra) # 5bfe <exit>

000000000000482a <sbrkfail>:
{
    482a:	7119                	addi	sp,sp,-128
    482c:	fc86                	sd	ra,120(sp)
    482e:	f8a2                	sd	s0,112(sp)
    4830:	f4a6                	sd	s1,104(sp)
    4832:	f0ca                	sd	s2,96(sp)
    4834:	ecce                	sd	s3,88(sp)
    4836:	e8d2                	sd	s4,80(sp)
    4838:	e4d6                	sd	s5,72(sp)
    483a:	0100                	addi	s0,sp,128
    483c:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    483e:	fb040513          	addi	a0,s0,-80
    4842:	00001097          	auipc	ra,0x1
    4846:	3cc080e7          	jalr	972(ra) # 5c0e <pipe>
    484a:	e901                	bnez	a0,485a <sbrkfail+0x30>
    484c:	f8040493          	addi	s1,s0,-128
    4850:	fa840a13          	addi	s4,s0,-88
    4854:	89a6                	mv	s3,s1
    if(pids[i] != -1)
    4856:	5afd                	li	s5,-1
    4858:	a08d                	j	48ba <sbrkfail+0x90>
    printf("%s: pipe() failed\n", s);
    485a:	85ca                	mv	a1,s2
    485c:	00002517          	auipc	a0,0x2
    4860:	2ac50513          	addi	a0,a0,684 # 6b08 <malloc+0xad4>
    4864:	00001097          	auipc	ra,0x1
    4868:	712080e7          	jalr	1810(ra) # 5f76 <printf>
    exit(1);
    486c:	4505                	li	a0,1
    486e:	00001097          	auipc	ra,0x1
    4872:	390080e7          	jalr	912(ra) # 5bfe <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4876:	4501                	li	a0,0
    4878:	00001097          	auipc	ra,0x1
    487c:	40e080e7          	jalr	1038(ra) # 5c86 <sbrk>
    4880:	064007b7          	lui	a5,0x6400
    4884:	40a7853b          	subw	a0,a5,a0
    4888:	00001097          	auipc	ra,0x1
    488c:	3fe080e7          	jalr	1022(ra) # 5c86 <sbrk>
      write(fds[1], "x", 1);
    4890:	4605                	li	a2,1
    4892:	00002597          	auipc	a1,0x2
    4896:	95658593          	addi	a1,a1,-1706 # 61e8 <malloc+0x1b4>
    489a:	fb442503          	lw	a0,-76(s0)
    489e:	00001097          	auipc	ra,0x1
    48a2:	380080e7          	jalr	896(ra) # 5c1e <write>
      for(;;) sleep(1000);
    48a6:	3e800513          	li	a0,1000
    48aa:	00001097          	auipc	ra,0x1
    48ae:	3e4080e7          	jalr	996(ra) # 5c8e <sleep>
    48b2:	bfd5                	j	48a6 <sbrkfail+0x7c>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    48b4:	0991                	addi	s3,s3,4
    48b6:	03498563          	beq	s3,s4,48e0 <sbrkfail+0xb6>
    if((pids[i] = fork()) == 0){
    48ba:	00001097          	auipc	ra,0x1
    48be:	33c080e7          	jalr	828(ra) # 5bf6 <fork>
    48c2:	00a9a023          	sw	a0,0(s3)
    48c6:	d945                	beqz	a0,4876 <sbrkfail+0x4c>
    if(pids[i] != -1)
    48c8:	ff5506e3          	beq	a0,s5,48b4 <sbrkfail+0x8a>
      read(fds[0], &scratch, 1);
    48cc:	4605                	li	a2,1
    48ce:	faf40593          	addi	a1,s0,-81
    48d2:	fb042503          	lw	a0,-80(s0)
    48d6:	00001097          	auipc	ra,0x1
    48da:	340080e7          	jalr	832(ra) # 5c16 <read>
    48de:	bfd9                	j	48b4 <sbrkfail+0x8a>
  c = sbrk(PGSIZE);
    48e0:	6505                	lui	a0,0x1
    48e2:	00001097          	auipc	ra,0x1
    48e6:	3a4080e7          	jalr	932(ra) # 5c86 <sbrk>
    48ea:	89aa                	mv	s3,a0
    if(pids[i] == -1)
    48ec:	5afd                	li	s5,-1
    48ee:	a021                	j	48f6 <sbrkfail+0xcc>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    48f0:	0491                	addi	s1,s1,4
    48f2:	01448f63          	beq	s1,s4,4910 <sbrkfail+0xe6>
    if(pids[i] == -1)
    48f6:	4088                	lw	a0,0(s1)
    48f8:	ff550ce3          	beq	a0,s5,48f0 <sbrkfail+0xc6>
    kill(pids[i]);
    48fc:	00001097          	auipc	ra,0x1
    4900:	332080e7          	jalr	818(ra) # 5c2e <kill>
    wait(0);
    4904:	4501                	li	a0,0
    4906:	00001097          	auipc	ra,0x1
    490a:	300080e7          	jalr	768(ra) # 5c06 <wait>
    490e:	b7cd                	j	48f0 <sbrkfail+0xc6>
  if(c == (char*)0xffffffffffffffffL){
    4910:	57fd                	li	a5,-1
    4912:	04f98163          	beq	s3,a5,4954 <sbrkfail+0x12a>
  pid = fork();
    4916:	00001097          	auipc	ra,0x1
    491a:	2e0080e7          	jalr	736(ra) # 5bf6 <fork>
    491e:	84aa                	mv	s1,a0
  if(pid < 0){
    4920:	04054863          	bltz	a0,4970 <sbrkfail+0x146>
  if(pid == 0){
    4924:	c525                	beqz	a0,498c <sbrkfail+0x162>
  wait(&xstatus);
    4926:	fbc40513          	addi	a0,s0,-68
    492a:	00001097          	auipc	ra,0x1
    492e:	2dc080e7          	jalr	732(ra) # 5c06 <wait>
  if(xstatus != -1 && xstatus != 2)
    4932:	fbc42783          	lw	a5,-68(s0)
    4936:	577d                	li	a4,-1
    4938:	00e78563          	beq	a5,a4,4942 <sbrkfail+0x118>
    493c:	4709                	li	a4,2
    493e:	08e79d63          	bne	a5,a4,49d8 <sbrkfail+0x1ae>
}
    4942:	70e6                	ld	ra,120(sp)
    4944:	7446                	ld	s0,112(sp)
    4946:	74a6                	ld	s1,104(sp)
    4948:	7906                	ld	s2,96(sp)
    494a:	69e6                	ld	s3,88(sp)
    494c:	6a46                	ld	s4,80(sp)
    494e:	6aa6                	ld	s5,72(sp)
    4950:	6109                	addi	sp,sp,128
    4952:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    4954:	85ca                	mv	a1,s2
    4956:	00003517          	auipc	a0,0x3
    495a:	40a50513          	addi	a0,a0,1034 # 7d60 <malloc+0x1d2c>
    495e:	00001097          	auipc	ra,0x1
    4962:	618080e7          	jalr	1560(ra) # 5f76 <printf>
    exit(1);
    4966:	4505                	li	a0,1
    4968:	00001097          	auipc	ra,0x1
    496c:	296080e7          	jalr	662(ra) # 5bfe <exit>
    printf("%s: fork failed\n", s);
    4970:	85ca                	mv	a1,s2
    4972:	00002517          	auipc	a0,0x2
    4976:	08e50513          	addi	a0,a0,142 # 6a00 <malloc+0x9cc>
    497a:	00001097          	auipc	ra,0x1
    497e:	5fc080e7          	jalr	1532(ra) # 5f76 <printf>
    exit(1);
    4982:	4505                	li	a0,1
    4984:	00001097          	auipc	ra,0x1
    4988:	27a080e7          	jalr	634(ra) # 5bfe <exit>
    a = sbrk(0);
    498c:	4501                	li	a0,0
    498e:	00001097          	auipc	ra,0x1
    4992:	2f8080e7          	jalr	760(ra) # 5c86 <sbrk>
    4996:	89aa                	mv	s3,a0
    sbrk(10*BIG);
    4998:	3e800537          	lui	a0,0x3e800
    499c:	00001097          	auipc	ra,0x1
    49a0:	2ea080e7          	jalr	746(ra) # 5c86 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    49a4:	874e                	mv	a4,s3
    49a6:	3e8007b7          	lui	a5,0x3e800
    49aa:	97ce                	add	a5,a5,s3
    49ac:	6685                	lui	a3,0x1
      n += *(a+i);
    49ae:	00074603          	lbu	a2,0(a4)
    49b2:	9cb1                	addw	s1,s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    49b4:	9736                	add	a4,a4,a3
    49b6:	fef71ce3          	bne	a4,a5,49ae <sbrkfail+0x184>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    49ba:	8626                	mv	a2,s1
    49bc:	85ca                	mv	a1,s2
    49be:	00003517          	auipc	a0,0x3
    49c2:	3c250513          	addi	a0,a0,962 # 7d80 <malloc+0x1d4c>
    49c6:	00001097          	auipc	ra,0x1
    49ca:	5b0080e7          	jalr	1456(ra) # 5f76 <printf>
    exit(1);
    49ce:	4505                	li	a0,1
    49d0:	00001097          	auipc	ra,0x1
    49d4:	22e080e7          	jalr	558(ra) # 5bfe <exit>
    exit(1);
    49d8:	4505                	li	a0,1
    49da:	00001097          	auipc	ra,0x1
    49de:	224080e7          	jalr	548(ra) # 5bfe <exit>

00000000000049e2 <mem>:
{
    49e2:	7139                	addi	sp,sp,-64
    49e4:	fc06                	sd	ra,56(sp)
    49e6:	f822                	sd	s0,48(sp)
    49e8:	f426                	sd	s1,40(sp)
    49ea:	f04a                	sd	s2,32(sp)
    49ec:	ec4e                	sd	s3,24(sp)
    49ee:	0080                	addi	s0,sp,64
    49f0:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    49f2:	00001097          	auipc	ra,0x1
    49f6:	204080e7          	jalr	516(ra) # 5bf6 <fork>
    m1 = 0;
    49fa:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    49fc:	6909                	lui	s2,0x2
    49fe:	71190913          	addi	s2,s2,1809 # 2711 <copyinstr3+0xfb>
  if((pid = fork()) == 0){
    4a02:	ed39                	bnez	a0,4a60 <mem+0x7e>
    while((m2 = malloc(10001)) != 0){
    4a04:	854a                	mv	a0,s2
    4a06:	00001097          	auipc	ra,0x1
    4a0a:	62e080e7          	jalr	1582(ra) # 6034 <malloc>
    4a0e:	c501                	beqz	a0,4a16 <mem+0x34>
      *(char**)m2 = m1;
    4a10:	e104                	sd	s1,0(a0)
      m1 = m2;
    4a12:	84aa                	mv	s1,a0
    4a14:	bfc5                	j	4a04 <mem+0x22>
    while(m1){
    4a16:	c881                	beqz	s1,4a26 <mem+0x44>
      m2 = *(char**)m1;
    4a18:	8526                	mv	a0,s1
    4a1a:	6084                	ld	s1,0(s1)
      free(m1);
    4a1c:	00001097          	auipc	ra,0x1
    4a20:	590080e7          	jalr	1424(ra) # 5fac <free>
    while(m1){
    4a24:	f8f5                	bnez	s1,4a18 <mem+0x36>
    m1 = malloc(1024*20);
    4a26:	6515                	lui	a0,0x5
    4a28:	00001097          	auipc	ra,0x1
    4a2c:	60c080e7          	jalr	1548(ra) # 6034 <malloc>
    if(m1 == 0){
    4a30:	c911                	beqz	a0,4a44 <mem+0x62>
    free(m1);
    4a32:	00001097          	auipc	ra,0x1
    4a36:	57a080e7          	jalr	1402(ra) # 5fac <free>
    exit(0);
    4a3a:	4501                	li	a0,0
    4a3c:	00001097          	auipc	ra,0x1
    4a40:	1c2080e7          	jalr	450(ra) # 5bfe <exit>
      printf("couldn't allocate mem?!!\n", s);
    4a44:	85ce                	mv	a1,s3
    4a46:	00003517          	auipc	a0,0x3
    4a4a:	36a50513          	addi	a0,a0,874 # 7db0 <malloc+0x1d7c>
    4a4e:	00001097          	auipc	ra,0x1
    4a52:	528080e7          	jalr	1320(ra) # 5f76 <printf>
      exit(1);
    4a56:	4505                	li	a0,1
    4a58:	00001097          	auipc	ra,0x1
    4a5c:	1a6080e7          	jalr	422(ra) # 5bfe <exit>
    wait(&xstatus);
    4a60:	fcc40513          	addi	a0,s0,-52
    4a64:	00001097          	auipc	ra,0x1
    4a68:	1a2080e7          	jalr	418(ra) # 5c06 <wait>
    if(xstatus == -1){
    4a6c:	fcc42503          	lw	a0,-52(s0)
    4a70:	57fd                	li	a5,-1
    4a72:	00f50663          	beq	a0,a5,4a7e <mem+0x9c>
    exit(xstatus);
    4a76:	00001097          	auipc	ra,0x1
    4a7a:	188080e7          	jalr	392(ra) # 5bfe <exit>
      exit(0);
    4a7e:	4501                	li	a0,0
    4a80:	00001097          	auipc	ra,0x1
    4a84:	17e080e7          	jalr	382(ra) # 5bfe <exit>

0000000000004a88 <sharedfd>:
{
    4a88:	7159                	addi	sp,sp,-112
    4a8a:	f486                	sd	ra,104(sp)
    4a8c:	f0a2                	sd	s0,96(sp)
    4a8e:	eca6                	sd	s1,88(sp)
    4a90:	e8ca                	sd	s2,80(sp)
    4a92:	e4ce                	sd	s3,72(sp)
    4a94:	e0d2                	sd	s4,64(sp)
    4a96:	fc56                	sd	s5,56(sp)
    4a98:	f85a                	sd	s6,48(sp)
    4a9a:	f45e                	sd	s7,40(sp)
    4a9c:	1880                	addi	s0,sp,112
    4a9e:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4aa0:	00003517          	auipc	a0,0x3
    4aa4:	33050513          	addi	a0,a0,816 # 7dd0 <malloc+0x1d9c>
    4aa8:	00001097          	auipc	ra,0x1
    4aac:	1a6080e7          	jalr	422(ra) # 5c4e <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4ab0:	20200593          	li	a1,514
    4ab4:	00003517          	auipc	a0,0x3
    4ab8:	31c50513          	addi	a0,a0,796 # 7dd0 <malloc+0x1d9c>
    4abc:	00001097          	auipc	ra,0x1
    4ac0:	182080e7          	jalr	386(ra) # 5c3e <open>
  if(fd < 0){
    4ac4:	04054a63          	bltz	a0,4b18 <sharedfd+0x90>
    4ac8:	892a                	mv	s2,a0
  pid = fork();
    4aca:	00001097          	auipc	ra,0x1
    4ace:	12c080e7          	jalr	300(ra) # 5bf6 <fork>
    4ad2:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4ad4:	06300593          	li	a1,99
    4ad8:	c119                	beqz	a0,4ade <sharedfd+0x56>
    4ada:	07000593          	li	a1,112
    4ade:	4629                	li	a2,10
    4ae0:	fa040513          	addi	a0,s0,-96
    4ae4:	00001097          	auipc	ra,0x1
    4ae8:	f16080e7          	jalr	-234(ra) # 59fa <memset>
    4aec:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4af0:	4629                	li	a2,10
    4af2:	fa040593          	addi	a1,s0,-96
    4af6:	854a                	mv	a0,s2
    4af8:	00001097          	auipc	ra,0x1
    4afc:	126080e7          	jalr	294(ra) # 5c1e <write>
    4b00:	47a9                	li	a5,10
    4b02:	02f51963          	bne	a0,a5,4b34 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    4b06:	34fd                	addiw	s1,s1,-1
    4b08:	f4e5                	bnez	s1,4af0 <sharedfd+0x68>
  if(pid == 0) {
    4b0a:	04099363          	bnez	s3,4b50 <sharedfd+0xc8>
    exit(0);
    4b0e:	4501                	li	a0,0
    4b10:	00001097          	auipc	ra,0x1
    4b14:	0ee080e7          	jalr	238(ra) # 5bfe <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4b18:	85d2                	mv	a1,s4
    4b1a:	00003517          	auipc	a0,0x3
    4b1e:	2c650513          	addi	a0,a0,710 # 7de0 <malloc+0x1dac>
    4b22:	00001097          	auipc	ra,0x1
    4b26:	454080e7          	jalr	1108(ra) # 5f76 <printf>
    exit(1);
    4b2a:	4505                	li	a0,1
    4b2c:	00001097          	auipc	ra,0x1
    4b30:	0d2080e7          	jalr	210(ra) # 5bfe <exit>
      printf("%s: write sharedfd failed\n", s);
    4b34:	85d2                	mv	a1,s4
    4b36:	00003517          	auipc	a0,0x3
    4b3a:	2d250513          	addi	a0,a0,722 # 7e08 <malloc+0x1dd4>
    4b3e:	00001097          	auipc	ra,0x1
    4b42:	438080e7          	jalr	1080(ra) # 5f76 <printf>
      exit(1);
    4b46:	4505                	li	a0,1
    4b48:	00001097          	auipc	ra,0x1
    4b4c:	0b6080e7          	jalr	182(ra) # 5bfe <exit>
    wait(&xstatus);
    4b50:	f9c40513          	addi	a0,s0,-100
    4b54:	00001097          	auipc	ra,0x1
    4b58:	0b2080e7          	jalr	178(ra) # 5c06 <wait>
    if(xstatus != 0)
    4b5c:	f9c42983          	lw	s3,-100(s0)
    4b60:	00098763          	beqz	s3,4b6e <sharedfd+0xe6>
      exit(xstatus);
    4b64:	854e                	mv	a0,s3
    4b66:	00001097          	auipc	ra,0x1
    4b6a:	098080e7          	jalr	152(ra) # 5bfe <exit>
  close(fd);
    4b6e:	854a                	mv	a0,s2
    4b70:	00001097          	auipc	ra,0x1
    4b74:	0b6080e7          	jalr	182(ra) # 5c26 <close>
  fd = open("sharedfd", 0);
    4b78:	4581                	li	a1,0
    4b7a:	00003517          	auipc	a0,0x3
    4b7e:	25650513          	addi	a0,a0,598 # 7dd0 <malloc+0x1d9c>
    4b82:	00001097          	auipc	ra,0x1
    4b86:	0bc080e7          	jalr	188(ra) # 5c3e <open>
    4b8a:	8baa                	mv	s7,a0
  nc = np = 0;
    4b8c:	8ace                	mv	s5,s3
  if(fd < 0){
    4b8e:	02054563          	bltz	a0,4bb8 <sharedfd+0x130>
    4b92:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4b96:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4b9a:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4b9e:	4629                	li	a2,10
    4ba0:	fa040593          	addi	a1,s0,-96
    4ba4:	855e                	mv	a0,s7
    4ba6:	00001097          	auipc	ra,0x1
    4baa:	070080e7          	jalr	112(ra) # 5c16 <read>
    4bae:	02a05f63          	blez	a0,4bec <sharedfd+0x164>
    4bb2:	fa040793          	addi	a5,s0,-96
    4bb6:	a01d                	j	4bdc <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4bb8:	85d2                	mv	a1,s4
    4bba:	00003517          	auipc	a0,0x3
    4bbe:	26e50513          	addi	a0,a0,622 # 7e28 <malloc+0x1df4>
    4bc2:	00001097          	auipc	ra,0x1
    4bc6:	3b4080e7          	jalr	948(ra) # 5f76 <printf>
    exit(1);
    4bca:	4505                	li	a0,1
    4bcc:	00001097          	auipc	ra,0x1
    4bd0:	032080e7          	jalr	50(ra) # 5bfe <exit>
        nc++;
    4bd4:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4bd6:	0785                	addi	a5,a5,1
    4bd8:	fd2783e3          	beq	a5,s2,4b9e <sharedfd+0x116>
      if(buf[i] == 'c')
    4bdc:	0007c703          	lbu	a4,0(a5) # 3e800000 <base+0x3e7f0388>
    4be0:	fe970ae3          	beq	a4,s1,4bd4 <sharedfd+0x14c>
      if(buf[i] == 'p')
    4be4:	ff6719e3          	bne	a4,s6,4bd6 <sharedfd+0x14e>
        np++;
    4be8:	2a85                	addiw	s5,s5,1
    4bea:	b7f5                	j	4bd6 <sharedfd+0x14e>
  close(fd);
    4bec:	855e                	mv	a0,s7
    4bee:	00001097          	auipc	ra,0x1
    4bf2:	038080e7          	jalr	56(ra) # 5c26 <close>
  unlink("sharedfd");
    4bf6:	00003517          	auipc	a0,0x3
    4bfa:	1da50513          	addi	a0,a0,474 # 7dd0 <malloc+0x1d9c>
    4bfe:	00001097          	auipc	ra,0x1
    4c02:	050080e7          	jalr	80(ra) # 5c4e <unlink>
  if(nc == N*SZ && np == N*SZ){
    4c06:	6789                	lui	a5,0x2
    4c08:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0xfa>
    4c0c:	00f99763          	bne	s3,a5,4c1a <sharedfd+0x192>
    4c10:	6789                	lui	a5,0x2
    4c12:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0xfa>
    4c16:	02fa8063          	beq	s5,a5,4c36 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4c1a:	85d2                	mv	a1,s4
    4c1c:	00003517          	auipc	a0,0x3
    4c20:	23450513          	addi	a0,a0,564 # 7e50 <malloc+0x1e1c>
    4c24:	00001097          	auipc	ra,0x1
    4c28:	352080e7          	jalr	850(ra) # 5f76 <printf>
    exit(1);
    4c2c:	4505                	li	a0,1
    4c2e:	00001097          	auipc	ra,0x1
    4c32:	fd0080e7          	jalr	-48(ra) # 5bfe <exit>
    exit(0);
    4c36:	4501                	li	a0,0
    4c38:	00001097          	auipc	ra,0x1
    4c3c:	fc6080e7          	jalr	-58(ra) # 5bfe <exit>

0000000000004c40 <fourfiles>:
{
    4c40:	7171                	addi	sp,sp,-176
    4c42:	f506                	sd	ra,168(sp)
    4c44:	f122                	sd	s0,160(sp)
    4c46:	ed26                	sd	s1,152(sp)
    4c48:	e94a                	sd	s2,144(sp)
    4c4a:	e54e                	sd	s3,136(sp)
    4c4c:	e152                	sd	s4,128(sp)
    4c4e:	fcd6                	sd	s5,120(sp)
    4c50:	f8da                	sd	s6,112(sp)
    4c52:	f4de                	sd	s7,104(sp)
    4c54:	f0e2                	sd	s8,96(sp)
    4c56:	ece6                	sd	s9,88(sp)
    4c58:	e8ea                	sd	s10,80(sp)
    4c5a:	e4ee                	sd	s11,72(sp)
    4c5c:	1900                	addi	s0,sp,176
    4c5e:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c60:	00001797          	auipc	a5,0x1
    4c64:	4c078793          	addi	a5,a5,1216 # 6120 <malloc+0xec>
    4c68:	f6f43823          	sd	a5,-144(s0)
    4c6c:	00001797          	auipc	a5,0x1
    4c70:	4bc78793          	addi	a5,a5,1212 # 6128 <malloc+0xf4>
    4c74:	f6f43c23          	sd	a5,-136(s0)
    4c78:	00001797          	auipc	a5,0x1
    4c7c:	4b878793          	addi	a5,a5,1208 # 6130 <malloc+0xfc>
    4c80:	f8f43023          	sd	a5,-128(s0)
    4c84:	00001797          	auipc	a5,0x1
    4c88:	4b478793          	addi	a5,a5,1204 # 6138 <malloc+0x104>
    4c8c:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4c90:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c94:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4c96:	4481                	li	s1,0
    4c98:	4a11                	li	s4,4
    fname = names[pi];
    4c9a:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4c9e:	854e                	mv	a0,s3
    4ca0:	00001097          	auipc	ra,0x1
    4ca4:	fae080e7          	jalr	-82(ra) # 5c4e <unlink>
    pid = fork();
    4ca8:	00001097          	auipc	ra,0x1
    4cac:	f4e080e7          	jalr	-178(ra) # 5bf6 <fork>
    if(pid < 0){
    4cb0:	04054563          	bltz	a0,4cfa <fourfiles+0xba>
    if(pid == 0){
    4cb4:	c12d                	beqz	a0,4d16 <fourfiles+0xd6>
  for(pi = 0; pi < NCHILD; pi++){
    4cb6:	2485                	addiw	s1,s1,1
    4cb8:	0921                	addi	s2,s2,8
    4cba:	ff4490e3          	bne	s1,s4,4c9a <fourfiles+0x5a>
    4cbe:	4491                	li	s1,4
    wait(&xstatus);
    4cc0:	f6c40513          	addi	a0,s0,-148
    4cc4:	00001097          	auipc	ra,0x1
    4cc8:	f42080e7          	jalr	-190(ra) # 5c06 <wait>
    if(xstatus != 0)
    4ccc:	f6c42503          	lw	a0,-148(s0)
    4cd0:	ed69                	bnez	a0,4daa <fourfiles+0x16a>
  for(pi = 0; pi < NCHILD; pi++){
    4cd2:	34fd                	addiw	s1,s1,-1
    4cd4:	f4f5                	bnez	s1,4cc0 <fourfiles+0x80>
    4cd6:	03000b13          	li	s6,48
    total = 0;
    4cda:	f4a43c23          	sd	a0,-168(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4cde:	00008a17          	auipc	s4,0x8
    4ce2:	f9aa0a13          	addi	s4,s4,-102 # cc78 <buf>
    4ce6:	00008a97          	auipc	s5,0x8
    4cea:	f93a8a93          	addi	s5,s5,-109 # cc79 <buf+0x1>
    if(total != N*SZ){
    4cee:	6d05                	lui	s10,0x1
    4cf0:	770d0d13          	addi	s10,s10,1904 # 1770 <exectest+0x26>
  for(i = 0; i < NCHILD; i++){
    4cf4:	03400d93          	li	s11,52
    4cf8:	a23d                	j	4e26 <fourfiles+0x1e6>
      printf("fork failed\n", s);
    4cfa:	85e6                	mv	a1,s9
    4cfc:	00002517          	auipc	a0,0x2
    4d00:	10c50513          	addi	a0,a0,268 # 6e08 <malloc+0xdd4>
    4d04:	00001097          	auipc	ra,0x1
    4d08:	272080e7          	jalr	626(ra) # 5f76 <printf>
      exit(1);
    4d0c:	4505                	li	a0,1
    4d0e:	00001097          	auipc	ra,0x1
    4d12:	ef0080e7          	jalr	-272(ra) # 5bfe <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4d16:	20200593          	li	a1,514
    4d1a:	854e                	mv	a0,s3
    4d1c:	00001097          	auipc	ra,0x1
    4d20:	f22080e7          	jalr	-222(ra) # 5c3e <open>
    4d24:	892a                	mv	s2,a0
      if(fd < 0){
    4d26:	04054763          	bltz	a0,4d74 <fourfiles+0x134>
      memset(buf, '0'+pi, SZ);
    4d2a:	1f400613          	li	a2,500
    4d2e:	0304859b          	addiw	a1,s1,48
    4d32:	00008517          	auipc	a0,0x8
    4d36:	f4650513          	addi	a0,a0,-186 # cc78 <buf>
    4d3a:	00001097          	auipc	ra,0x1
    4d3e:	cc0080e7          	jalr	-832(ra) # 59fa <memset>
    4d42:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4d44:	00008997          	auipc	s3,0x8
    4d48:	f3498993          	addi	s3,s3,-204 # cc78 <buf>
    4d4c:	1f400613          	li	a2,500
    4d50:	85ce                	mv	a1,s3
    4d52:	854a                	mv	a0,s2
    4d54:	00001097          	auipc	ra,0x1
    4d58:	eca080e7          	jalr	-310(ra) # 5c1e <write>
    4d5c:	85aa                	mv	a1,a0
    4d5e:	1f400793          	li	a5,500
    4d62:	02f51763          	bne	a0,a5,4d90 <fourfiles+0x150>
      for(i = 0; i < N; i++){
    4d66:	34fd                	addiw	s1,s1,-1
    4d68:	f0f5                	bnez	s1,4d4c <fourfiles+0x10c>
      exit(0);
    4d6a:	4501                	li	a0,0
    4d6c:	00001097          	auipc	ra,0x1
    4d70:	e92080e7          	jalr	-366(ra) # 5bfe <exit>
        printf("create failed\n", s);
    4d74:	85e6                	mv	a1,s9
    4d76:	00003517          	auipc	a0,0x3
    4d7a:	0f250513          	addi	a0,a0,242 # 7e68 <malloc+0x1e34>
    4d7e:	00001097          	auipc	ra,0x1
    4d82:	1f8080e7          	jalr	504(ra) # 5f76 <printf>
        exit(1);
    4d86:	4505                	li	a0,1
    4d88:	00001097          	auipc	ra,0x1
    4d8c:	e76080e7          	jalr	-394(ra) # 5bfe <exit>
          printf("write failed %d\n", n);
    4d90:	00003517          	auipc	a0,0x3
    4d94:	0e850513          	addi	a0,a0,232 # 7e78 <malloc+0x1e44>
    4d98:	00001097          	auipc	ra,0x1
    4d9c:	1de080e7          	jalr	478(ra) # 5f76 <printf>
          exit(1);
    4da0:	4505                	li	a0,1
    4da2:	00001097          	auipc	ra,0x1
    4da6:	e5c080e7          	jalr	-420(ra) # 5bfe <exit>
      exit(xstatus);
    4daa:	00001097          	auipc	ra,0x1
    4dae:	e54080e7          	jalr	-428(ra) # 5bfe <exit>
          printf("wrong char\n", s);
    4db2:	85e6                	mv	a1,s9
    4db4:	00003517          	auipc	a0,0x3
    4db8:	0dc50513          	addi	a0,a0,220 # 7e90 <malloc+0x1e5c>
    4dbc:	00001097          	auipc	ra,0x1
    4dc0:	1ba080e7          	jalr	442(ra) # 5f76 <printf>
          exit(1);
    4dc4:	4505                	li	a0,1
    4dc6:	00001097          	auipc	ra,0x1
    4dca:	e38080e7          	jalr	-456(ra) # 5bfe <exit>
      total += n;
    4dce:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4dd2:	660d                	lui	a2,0x3
    4dd4:	85d2                	mv	a1,s4
    4dd6:	854e                	mv	a0,s3
    4dd8:	00001097          	auipc	ra,0x1
    4ddc:	e3e080e7          	jalr	-450(ra) # 5c16 <read>
    4de0:	02a05363          	blez	a0,4e06 <fourfiles+0x1c6>
    4de4:	00008797          	auipc	a5,0x8
    4de8:	e9478793          	addi	a5,a5,-364 # cc78 <buf>
    4dec:	fff5069b          	addiw	a3,a0,-1
    4df0:	1682                	slli	a3,a3,0x20
    4df2:	9281                	srli	a3,a3,0x20
    4df4:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    4df6:	0007c703          	lbu	a4,0(a5)
    4dfa:	fa971ce3          	bne	a4,s1,4db2 <fourfiles+0x172>
      for(j = 0; j < n; j++){
    4dfe:	0785                	addi	a5,a5,1
    4e00:	fed79be3          	bne	a5,a3,4df6 <fourfiles+0x1b6>
    4e04:	b7e9                	j	4dce <fourfiles+0x18e>
    close(fd);
    4e06:	854e                	mv	a0,s3
    4e08:	00001097          	auipc	ra,0x1
    4e0c:	e1e080e7          	jalr	-482(ra) # 5c26 <close>
    if(total != N*SZ){
    4e10:	03a91963          	bne	s2,s10,4e42 <fourfiles+0x202>
    unlink(fname);
    4e14:	8562                	mv	a0,s8
    4e16:	00001097          	auipc	ra,0x1
    4e1a:	e38080e7          	jalr	-456(ra) # 5c4e <unlink>
  for(i = 0; i < NCHILD; i++){
    4e1e:	0ba1                	addi	s7,s7,8
    4e20:	2b05                	addiw	s6,s6,1
    4e22:	03bb0e63          	beq	s6,s11,4e5e <fourfiles+0x21e>
    fname = names[i];
    4e26:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4e2a:	4581                	li	a1,0
    4e2c:	8562                	mv	a0,s8
    4e2e:	00001097          	auipc	ra,0x1
    4e32:	e10080e7          	jalr	-496(ra) # 5c3e <open>
    4e36:	89aa                	mv	s3,a0
    total = 0;
    4e38:	f5843903          	ld	s2,-168(s0)
        if(buf[j] != '0'+i){
    4e3c:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4e40:	bf49                	j	4dd2 <fourfiles+0x192>
      printf("wrong length %d\n", total);
    4e42:	85ca                	mv	a1,s2
    4e44:	00003517          	auipc	a0,0x3
    4e48:	05c50513          	addi	a0,a0,92 # 7ea0 <malloc+0x1e6c>
    4e4c:	00001097          	auipc	ra,0x1
    4e50:	12a080e7          	jalr	298(ra) # 5f76 <printf>
      exit(1);
    4e54:	4505                	li	a0,1
    4e56:	00001097          	auipc	ra,0x1
    4e5a:	da8080e7          	jalr	-600(ra) # 5bfe <exit>
}
    4e5e:	70aa                	ld	ra,168(sp)
    4e60:	740a                	ld	s0,160(sp)
    4e62:	64ea                	ld	s1,152(sp)
    4e64:	694a                	ld	s2,144(sp)
    4e66:	69aa                	ld	s3,136(sp)
    4e68:	6a0a                	ld	s4,128(sp)
    4e6a:	7ae6                	ld	s5,120(sp)
    4e6c:	7b46                	ld	s6,112(sp)
    4e6e:	7ba6                	ld	s7,104(sp)
    4e70:	7c06                	ld	s8,96(sp)
    4e72:	6ce6                	ld	s9,88(sp)
    4e74:	6d46                	ld	s10,80(sp)
    4e76:	6da6                	ld	s11,72(sp)
    4e78:	614d                	addi	sp,sp,176
    4e7a:	8082                	ret

0000000000004e7c <concreate>:
{
    4e7c:	7135                	addi	sp,sp,-160
    4e7e:	ed06                	sd	ra,152(sp)
    4e80:	e922                	sd	s0,144(sp)
    4e82:	e526                	sd	s1,136(sp)
    4e84:	e14a                	sd	s2,128(sp)
    4e86:	fcce                	sd	s3,120(sp)
    4e88:	f8d2                	sd	s4,112(sp)
    4e8a:	f4d6                	sd	s5,104(sp)
    4e8c:	f0da                	sd	s6,96(sp)
    4e8e:	ecde                	sd	s7,88(sp)
    4e90:	1100                	addi	s0,sp,160
    4e92:	89aa                	mv	s3,a0
  file[0] = 'C';
    4e94:	04300793          	li	a5,67
    4e98:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4e9c:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4ea0:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4ea2:	4b0d                	li	s6,3
    4ea4:	4a85                	li	s5,1
      link("C0", file);
    4ea6:	00003b97          	auipc	s7,0x3
    4eaa:	012b8b93          	addi	s7,s7,18 # 7eb8 <malloc+0x1e84>
  for(i = 0; i < N; i++){
    4eae:	02800a13          	li	s4,40
    4eb2:	acc1                	j	5182 <concreate+0x306>
      link("C0", file);
    4eb4:	fa840593          	addi	a1,s0,-88
    4eb8:	855e                	mv	a0,s7
    4eba:	00001097          	auipc	ra,0x1
    4ebe:	da4080e7          	jalr	-604(ra) # 5c5e <link>
    if(pid == 0) {
    4ec2:	a45d                	j	5168 <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    4ec4:	4795                	li	a5,5
    4ec6:	02f9693b          	remw	s2,s2,a5
    4eca:	4785                	li	a5,1
    4ecc:	02f90b63          	beq	s2,a5,4f02 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4ed0:	20200593          	li	a1,514
    4ed4:	fa840513          	addi	a0,s0,-88
    4ed8:	00001097          	auipc	ra,0x1
    4edc:	d66080e7          	jalr	-666(ra) # 5c3e <open>
      if(fd < 0){
    4ee0:	26055b63          	bgez	a0,5156 <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    4ee4:	fa840593          	addi	a1,s0,-88
    4ee8:	00003517          	auipc	a0,0x3
    4eec:	fd850513          	addi	a0,a0,-40 # 7ec0 <malloc+0x1e8c>
    4ef0:	00001097          	auipc	ra,0x1
    4ef4:	086080e7          	jalr	134(ra) # 5f76 <printf>
        exit(1);
    4ef8:	4505                	li	a0,1
    4efa:	00001097          	auipc	ra,0x1
    4efe:	d04080e7          	jalr	-764(ra) # 5bfe <exit>
      link("C0", file);
    4f02:	fa840593          	addi	a1,s0,-88
    4f06:	00003517          	auipc	a0,0x3
    4f0a:	fb250513          	addi	a0,a0,-78 # 7eb8 <malloc+0x1e84>
    4f0e:	00001097          	auipc	ra,0x1
    4f12:	d50080e7          	jalr	-688(ra) # 5c5e <link>
      exit(0);
    4f16:	4501                	li	a0,0
    4f18:	00001097          	auipc	ra,0x1
    4f1c:	ce6080e7          	jalr	-794(ra) # 5bfe <exit>
        exit(1);
    4f20:	4505                	li	a0,1
    4f22:	00001097          	auipc	ra,0x1
    4f26:	cdc080e7          	jalr	-804(ra) # 5bfe <exit>
  memset(fa, 0, sizeof(fa));
    4f2a:	02800613          	li	a2,40
    4f2e:	4581                	li	a1,0
    4f30:	f8040513          	addi	a0,s0,-128
    4f34:	00001097          	auipc	ra,0x1
    4f38:	ac6080e7          	jalr	-1338(ra) # 59fa <memset>
  fd = open(".", 0);
    4f3c:	4581                	li	a1,0
    4f3e:	00002517          	auipc	a0,0x2
    4f42:	92250513          	addi	a0,a0,-1758 # 6860 <malloc+0x82c>
    4f46:	00001097          	auipc	ra,0x1
    4f4a:	cf8080e7          	jalr	-776(ra) # 5c3e <open>
    4f4e:	892a                	mv	s2,a0
  n = 0;
    4f50:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f52:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4f56:	02700b13          	li	s6,39
      fa[i] = 1;
    4f5a:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4f5c:	a03d                	j	4f8a <concreate+0x10e>
        printf("%s: concreate weird file %s\n", s, de.name);
    4f5e:	f7240613          	addi	a2,s0,-142
    4f62:	85ce                	mv	a1,s3
    4f64:	00003517          	auipc	a0,0x3
    4f68:	f7c50513          	addi	a0,a0,-132 # 7ee0 <malloc+0x1eac>
    4f6c:	00001097          	auipc	ra,0x1
    4f70:	00a080e7          	jalr	10(ra) # 5f76 <printf>
        exit(1);
    4f74:	4505                	li	a0,1
    4f76:	00001097          	auipc	ra,0x1
    4f7a:	c88080e7          	jalr	-888(ra) # 5bfe <exit>
      fa[i] = 1;
    4f7e:	fb040793          	addi	a5,s0,-80
    4f82:	973e                	add	a4,a4,a5
    4f84:	fd770823          	sb	s7,-48(a4)
      n++;
    4f88:	2a85                	addiw	s5,s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    4f8a:	4641                	li	a2,16
    4f8c:	f7040593          	addi	a1,s0,-144
    4f90:	854a                	mv	a0,s2
    4f92:	00001097          	auipc	ra,0x1
    4f96:	c84080e7          	jalr	-892(ra) # 5c16 <read>
    4f9a:	04a05a63          	blez	a0,4fee <concreate+0x172>
    if(de.inum == 0)
    4f9e:	f7045783          	lhu	a5,-144(s0)
    4fa2:	d7e5                	beqz	a5,4f8a <concreate+0x10e>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4fa4:	f7244783          	lbu	a5,-142(s0)
    4fa8:	ff4791e3          	bne	a5,s4,4f8a <concreate+0x10e>
    4fac:	f7444783          	lbu	a5,-140(s0)
    4fb0:	ffe9                	bnez	a5,4f8a <concreate+0x10e>
      i = de.name[1] - '0';
    4fb2:	f7344783          	lbu	a5,-141(s0)
    4fb6:	fd07879b          	addiw	a5,a5,-48
    4fba:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4fbe:	faeb60e3          	bltu	s6,a4,4f5e <concreate+0xe2>
      if(fa[i]){
    4fc2:	fb040793          	addi	a5,s0,-80
    4fc6:	97ba                	add	a5,a5,a4
    4fc8:	fd07c783          	lbu	a5,-48(a5)
    4fcc:	dbcd                	beqz	a5,4f7e <concreate+0x102>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4fce:	f7240613          	addi	a2,s0,-142
    4fd2:	85ce                	mv	a1,s3
    4fd4:	00003517          	auipc	a0,0x3
    4fd8:	f2c50513          	addi	a0,a0,-212 # 7f00 <malloc+0x1ecc>
    4fdc:	00001097          	auipc	ra,0x1
    4fe0:	f9a080e7          	jalr	-102(ra) # 5f76 <printf>
        exit(1);
    4fe4:	4505                	li	a0,1
    4fe6:	00001097          	auipc	ra,0x1
    4fea:	c18080e7          	jalr	-1000(ra) # 5bfe <exit>
  close(fd);
    4fee:	854a                	mv	a0,s2
    4ff0:	00001097          	auipc	ra,0x1
    4ff4:	c36080e7          	jalr	-970(ra) # 5c26 <close>
  if(n != N){
    4ff8:	02800793          	li	a5,40
    4ffc:	00fa9763          	bne	s5,a5,500a <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    5000:	4a8d                	li	s5,3
    5002:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    5004:	02800a13          	li	s4,40
    5008:	a8c9                	j	50da <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    500a:	85ce                	mv	a1,s3
    500c:	00003517          	auipc	a0,0x3
    5010:	f1c50513          	addi	a0,a0,-228 # 7f28 <malloc+0x1ef4>
    5014:	00001097          	auipc	ra,0x1
    5018:	f62080e7          	jalr	-158(ra) # 5f76 <printf>
    exit(1);
    501c:	4505                	li	a0,1
    501e:	00001097          	auipc	ra,0x1
    5022:	be0080e7          	jalr	-1056(ra) # 5bfe <exit>
      printf("%s: fork failed\n", s);
    5026:	85ce                	mv	a1,s3
    5028:	00002517          	auipc	a0,0x2
    502c:	9d850513          	addi	a0,a0,-1576 # 6a00 <malloc+0x9cc>
    5030:	00001097          	auipc	ra,0x1
    5034:	f46080e7          	jalr	-186(ra) # 5f76 <printf>
      exit(1);
    5038:	4505                	li	a0,1
    503a:	00001097          	auipc	ra,0x1
    503e:	bc4080e7          	jalr	-1084(ra) # 5bfe <exit>
      close(open(file, 0));
    5042:	4581                	li	a1,0
    5044:	fa840513          	addi	a0,s0,-88
    5048:	00001097          	auipc	ra,0x1
    504c:	bf6080e7          	jalr	-1034(ra) # 5c3e <open>
    5050:	00001097          	auipc	ra,0x1
    5054:	bd6080e7          	jalr	-1066(ra) # 5c26 <close>
      close(open(file, 0));
    5058:	4581                	li	a1,0
    505a:	fa840513          	addi	a0,s0,-88
    505e:	00001097          	auipc	ra,0x1
    5062:	be0080e7          	jalr	-1056(ra) # 5c3e <open>
    5066:	00001097          	auipc	ra,0x1
    506a:	bc0080e7          	jalr	-1088(ra) # 5c26 <close>
      close(open(file, 0));
    506e:	4581                	li	a1,0
    5070:	fa840513          	addi	a0,s0,-88
    5074:	00001097          	auipc	ra,0x1
    5078:	bca080e7          	jalr	-1078(ra) # 5c3e <open>
    507c:	00001097          	auipc	ra,0x1
    5080:	baa080e7          	jalr	-1110(ra) # 5c26 <close>
      close(open(file, 0));
    5084:	4581                	li	a1,0
    5086:	fa840513          	addi	a0,s0,-88
    508a:	00001097          	auipc	ra,0x1
    508e:	bb4080e7          	jalr	-1100(ra) # 5c3e <open>
    5092:	00001097          	auipc	ra,0x1
    5096:	b94080e7          	jalr	-1132(ra) # 5c26 <close>
      close(open(file, 0));
    509a:	4581                	li	a1,0
    509c:	fa840513          	addi	a0,s0,-88
    50a0:	00001097          	auipc	ra,0x1
    50a4:	b9e080e7          	jalr	-1122(ra) # 5c3e <open>
    50a8:	00001097          	auipc	ra,0x1
    50ac:	b7e080e7          	jalr	-1154(ra) # 5c26 <close>
      close(open(file, 0));
    50b0:	4581                	li	a1,0
    50b2:	fa840513          	addi	a0,s0,-88
    50b6:	00001097          	auipc	ra,0x1
    50ba:	b88080e7          	jalr	-1144(ra) # 5c3e <open>
    50be:	00001097          	auipc	ra,0x1
    50c2:	b68080e7          	jalr	-1176(ra) # 5c26 <close>
    if(pid == 0)
    50c6:	08090363          	beqz	s2,514c <concreate+0x2d0>
      wait(0);
    50ca:	4501                	li	a0,0
    50cc:	00001097          	auipc	ra,0x1
    50d0:	b3a080e7          	jalr	-1222(ra) # 5c06 <wait>
  for(i = 0; i < N; i++){
    50d4:	2485                	addiw	s1,s1,1
    50d6:	0f448563          	beq	s1,s4,51c0 <concreate+0x344>
    file[1] = '0' + i;
    50da:	0304879b          	addiw	a5,s1,48
    50de:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    50e2:	00001097          	auipc	ra,0x1
    50e6:	b14080e7          	jalr	-1260(ra) # 5bf6 <fork>
    50ea:	892a                	mv	s2,a0
    if(pid < 0){
    50ec:	f2054de3          	bltz	a0,5026 <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    50f0:	0354e73b          	remw	a4,s1,s5
    50f4:	00a767b3          	or	a5,a4,a0
    50f8:	2781                	sext.w	a5,a5
    50fa:	d7a1                	beqz	a5,5042 <concreate+0x1c6>
    50fc:	01671363          	bne	a4,s6,5102 <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    5100:	f129                	bnez	a0,5042 <concreate+0x1c6>
      unlink(file);
    5102:	fa840513          	addi	a0,s0,-88
    5106:	00001097          	auipc	ra,0x1
    510a:	b48080e7          	jalr	-1208(ra) # 5c4e <unlink>
      unlink(file);
    510e:	fa840513          	addi	a0,s0,-88
    5112:	00001097          	auipc	ra,0x1
    5116:	b3c080e7          	jalr	-1220(ra) # 5c4e <unlink>
      unlink(file);
    511a:	fa840513          	addi	a0,s0,-88
    511e:	00001097          	auipc	ra,0x1
    5122:	b30080e7          	jalr	-1232(ra) # 5c4e <unlink>
      unlink(file);
    5126:	fa840513          	addi	a0,s0,-88
    512a:	00001097          	auipc	ra,0x1
    512e:	b24080e7          	jalr	-1244(ra) # 5c4e <unlink>
      unlink(file);
    5132:	fa840513          	addi	a0,s0,-88
    5136:	00001097          	auipc	ra,0x1
    513a:	b18080e7          	jalr	-1256(ra) # 5c4e <unlink>
      unlink(file);
    513e:	fa840513          	addi	a0,s0,-88
    5142:	00001097          	auipc	ra,0x1
    5146:	b0c080e7          	jalr	-1268(ra) # 5c4e <unlink>
    514a:	bfb5                	j	50c6 <concreate+0x24a>
      exit(0);
    514c:	4501                	li	a0,0
    514e:	00001097          	auipc	ra,0x1
    5152:	ab0080e7          	jalr	-1360(ra) # 5bfe <exit>
      close(fd);
    5156:	00001097          	auipc	ra,0x1
    515a:	ad0080e7          	jalr	-1328(ra) # 5c26 <close>
    if(pid == 0) {
    515e:	bb65                	j	4f16 <concreate+0x9a>
      close(fd);
    5160:	00001097          	auipc	ra,0x1
    5164:	ac6080e7          	jalr	-1338(ra) # 5c26 <close>
      wait(&xstatus);
    5168:	f6c40513          	addi	a0,s0,-148
    516c:	00001097          	auipc	ra,0x1
    5170:	a9a080e7          	jalr	-1382(ra) # 5c06 <wait>
      if(xstatus != 0)
    5174:	f6c42483          	lw	s1,-148(s0)
    5178:	da0494e3          	bnez	s1,4f20 <concreate+0xa4>
  for(i = 0; i < N; i++){
    517c:	2905                	addiw	s2,s2,1
    517e:	db4906e3          	beq	s2,s4,4f2a <concreate+0xae>
    file[1] = '0' + i;
    5182:	0309079b          	addiw	a5,s2,48
    5186:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    518a:	fa840513          	addi	a0,s0,-88
    518e:	00001097          	auipc	ra,0x1
    5192:	ac0080e7          	jalr	-1344(ra) # 5c4e <unlink>
    pid = fork();
    5196:	00001097          	auipc	ra,0x1
    519a:	a60080e7          	jalr	-1440(ra) # 5bf6 <fork>
    if(pid && (i % 3) == 1){
    519e:	d20503e3          	beqz	a0,4ec4 <concreate+0x48>
    51a2:	036967bb          	remw	a5,s2,s6
    51a6:	d15787e3          	beq	a5,s5,4eb4 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    51aa:	20200593          	li	a1,514
    51ae:	fa840513          	addi	a0,s0,-88
    51b2:	00001097          	auipc	ra,0x1
    51b6:	a8c080e7          	jalr	-1396(ra) # 5c3e <open>
      if(fd < 0){
    51ba:	fa0553e3          	bgez	a0,5160 <concreate+0x2e4>
    51be:	b31d                	j	4ee4 <concreate+0x68>
}
    51c0:	60ea                	ld	ra,152(sp)
    51c2:	644a                	ld	s0,144(sp)
    51c4:	64aa                	ld	s1,136(sp)
    51c6:	690a                	ld	s2,128(sp)
    51c8:	79e6                	ld	s3,120(sp)
    51ca:	7a46                	ld	s4,112(sp)
    51cc:	7aa6                	ld	s5,104(sp)
    51ce:	7b06                	ld	s6,96(sp)
    51d0:	6be6                	ld	s7,88(sp)
    51d2:	610d                	addi	sp,sp,160
    51d4:	8082                	ret

00000000000051d6 <bigfile>:
{
    51d6:	7139                	addi	sp,sp,-64
    51d8:	fc06                	sd	ra,56(sp)
    51da:	f822                	sd	s0,48(sp)
    51dc:	f426                	sd	s1,40(sp)
    51de:	f04a                	sd	s2,32(sp)
    51e0:	ec4e                	sd	s3,24(sp)
    51e2:	e852                	sd	s4,16(sp)
    51e4:	e456                	sd	s5,8(sp)
    51e6:	0080                	addi	s0,sp,64
    51e8:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    51ea:	00003517          	auipc	a0,0x3
    51ee:	d7650513          	addi	a0,a0,-650 # 7f60 <malloc+0x1f2c>
    51f2:	00001097          	auipc	ra,0x1
    51f6:	a5c080e7          	jalr	-1444(ra) # 5c4e <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    51fa:	20200593          	li	a1,514
    51fe:	00003517          	auipc	a0,0x3
    5202:	d6250513          	addi	a0,a0,-670 # 7f60 <malloc+0x1f2c>
    5206:	00001097          	auipc	ra,0x1
    520a:	a38080e7          	jalr	-1480(ra) # 5c3e <open>
    520e:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    5210:	4481                	li	s1,0
    memset(buf, i, SZ);
    5212:	00008917          	auipc	s2,0x8
    5216:	a6690913          	addi	s2,s2,-1434 # cc78 <buf>
  for(i = 0; i < N; i++){
    521a:	4a51                	li	s4,20
  if(fd < 0){
    521c:	0a054063          	bltz	a0,52bc <bigfile+0xe6>
    memset(buf, i, SZ);
    5220:	25800613          	li	a2,600
    5224:	85a6                	mv	a1,s1
    5226:	854a                	mv	a0,s2
    5228:	00000097          	auipc	ra,0x0
    522c:	7d2080e7          	jalr	2002(ra) # 59fa <memset>
    if(write(fd, buf, SZ) != SZ){
    5230:	25800613          	li	a2,600
    5234:	85ca                	mv	a1,s2
    5236:	854e                	mv	a0,s3
    5238:	00001097          	auipc	ra,0x1
    523c:	9e6080e7          	jalr	-1562(ra) # 5c1e <write>
    5240:	25800793          	li	a5,600
    5244:	08f51a63          	bne	a0,a5,52d8 <bigfile+0x102>
  for(i = 0; i < N; i++){
    5248:	2485                	addiw	s1,s1,1
    524a:	fd449be3          	bne	s1,s4,5220 <bigfile+0x4a>
  close(fd);
    524e:	854e                	mv	a0,s3
    5250:	00001097          	auipc	ra,0x1
    5254:	9d6080e7          	jalr	-1578(ra) # 5c26 <close>
  fd = open("bigfile.dat", 0);
    5258:	4581                	li	a1,0
    525a:	00003517          	auipc	a0,0x3
    525e:	d0650513          	addi	a0,a0,-762 # 7f60 <malloc+0x1f2c>
    5262:	00001097          	auipc	ra,0x1
    5266:	9dc080e7          	jalr	-1572(ra) # 5c3e <open>
    526a:	8a2a                	mv	s4,a0
  total = 0;
    526c:	4981                	li	s3,0
  for(i = 0; ; i++){
    526e:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    5270:	00008917          	auipc	s2,0x8
    5274:	a0890913          	addi	s2,s2,-1528 # cc78 <buf>
  if(fd < 0){
    5278:	06054e63          	bltz	a0,52f4 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    527c:	12c00613          	li	a2,300
    5280:	85ca                	mv	a1,s2
    5282:	8552                	mv	a0,s4
    5284:	00001097          	auipc	ra,0x1
    5288:	992080e7          	jalr	-1646(ra) # 5c16 <read>
    if(cc < 0){
    528c:	08054263          	bltz	a0,5310 <bigfile+0x13a>
    if(cc == 0)
    5290:	c971                	beqz	a0,5364 <bigfile+0x18e>
    if(cc != SZ/2){
    5292:	12c00793          	li	a5,300
    5296:	08f51b63          	bne	a0,a5,532c <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    529a:	01f4d79b          	srliw	a5,s1,0x1f
    529e:	9fa5                	addw	a5,a5,s1
    52a0:	4017d79b          	sraiw	a5,a5,0x1
    52a4:	00094703          	lbu	a4,0(s2)
    52a8:	0af71063          	bne	a4,a5,5348 <bigfile+0x172>
    52ac:	12b94703          	lbu	a4,299(s2)
    52b0:	08f71c63          	bne	a4,a5,5348 <bigfile+0x172>
    total += cc;
    52b4:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    52b8:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    52ba:	b7c9                	j	527c <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    52bc:	85d6                	mv	a1,s5
    52be:	00003517          	auipc	a0,0x3
    52c2:	cb250513          	addi	a0,a0,-846 # 7f70 <malloc+0x1f3c>
    52c6:	00001097          	auipc	ra,0x1
    52ca:	cb0080e7          	jalr	-848(ra) # 5f76 <printf>
    exit(1);
    52ce:	4505                	li	a0,1
    52d0:	00001097          	auipc	ra,0x1
    52d4:	92e080e7          	jalr	-1746(ra) # 5bfe <exit>
      printf("%s: write bigfile failed\n", s);
    52d8:	85d6                	mv	a1,s5
    52da:	00003517          	auipc	a0,0x3
    52de:	cb650513          	addi	a0,a0,-842 # 7f90 <malloc+0x1f5c>
    52e2:	00001097          	auipc	ra,0x1
    52e6:	c94080e7          	jalr	-876(ra) # 5f76 <printf>
      exit(1);
    52ea:	4505                	li	a0,1
    52ec:	00001097          	auipc	ra,0x1
    52f0:	912080e7          	jalr	-1774(ra) # 5bfe <exit>
    printf("%s: cannot open bigfile\n", s);
    52f4:	85d6                	mv	a1,s5
    52f6:	00003517          	auipc	a0,0x3
    52fa:	cba50513          	addi	a0,a0,-838 # 7fb0 <malloc+0x1f7c>
    52fe:	00001097          	auipc	ra,0x1
    5302:	c78080e7          	jalr	-904(ra) # 5f76 <printf>
    exit(1);
    5306:	4505                	li	a0,1
    5308:	00001097          	auipc	ra,0x1
    530c:	8f6080e7          	jalr	-1802(ra) # 5bfe <exit>
      printf("%s: read bigfile failed\n", s);
    5310:	85d6                	mv	a1,s5
    5312:	00003517          	auipc	a0,0x3
    5316:	cbe50513          	addi	a0,a0,-834 # 7fd0 <malloc+0x1f9c>
    531a:	00001097          	auipc	ra,0x1
    531e:	c5c080e7          	jalr	-932(ra) # 5f76 <printf>
      exit(1);
    5322:	4505                	li	a0,1
    5324:	00001097          	auipc	ra,0x1
    5328:	8da080e7          	jalr	-1830(ra) # 5bfe <exit>
      printf("%s: short read bigfile\n", s);
    532c:	85d6                	mv	a1,s5
    532e:	00003517          	auipc	a0,0x3
    5332:	cc250513          	addi	a0,a0,-830 # 7ff0 <malloc+0x1fbc>
    5336:	00001097          	auipc	ra,0x1
    533a:	c40080e7          	jalr	-960(ra) # 5f76 <printf>
      exit(1);
    533e:	4505                	li	a0,1
    5340:	00001097          	auipc	ra,0x1
    5344:	8be080e7          	jalr	-1858(ra) # 5bfe <exit>
      printf("%s: read bigfile wrong data\n", s);
    5348:	85d6                	mv	a1,s5
    534a:	00003517          	auipc	a0,0x3
    534e:	cbe50513          	addi	a0,a0,-834 # 8008 <malloc+0x1fd4>
    5352:	00001097          	auipc	ra,0x1
    5356:	c24080e7          	jalr	-988(ra) # 5f76 <printf>
      exit(1);
    535a:	4505                	li	a0,1
    535c:	00001097          	auipc	ra,0x1
    5360:	8a2080e7          	jalr	-1886(ra) # 5bfe <exit>
  close(fd);
    5364:	8552                	mv	a0,s4
    5366:	00001097          	auipc	ra,0x1
    536a:	8c0080e7          	jalr	-1856(ra) # 5c26 <close>
  if(total != N*SZ){
    536e:	678d                	lui	a5,0x3
    5370:	ee078793          	addi	a5,a5,-288 # 2ee0 <sbrklast+0x7e>
    5374:	02f99363          	bne	s3,a5,539a <bigfile+0x1c4>
  unlink("bigfile.dat");
    5378:	00003517          	auipc	a0,0x3
    537c:	be850513          	addi	a0,a0,-1048 # 7f60 <malloc+0x1f2c>
    5380:	00001097          	auipc	ra,0x1
    5384:	8ce080e7          	jalr	-1842(ra) # 5c4e <unlink>
}
    5388:	70e2                	ld	ra,56(sp)
    538a:	7442                	ld	s0,48(sp)
    538c:	74a2                	ld	s1,40(sp)
    538e:	7902                	ld	s2,32(sp)
    5390:	69e2                	ld	s3,24(sp)
    5392:	6a42                	ld	s4,16(sp)
    5394:	6aa2                	ld	s5,8(sp)
    5396:	6121                	addi	sp,sp,64
    5398:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    539a:	85d6                	mv	a1,s5
    539c:	00003517          	auipc	a0,0x3
    53a0:	c8c50513          	addi	a0,a0,-884 # 8028 <malloc+0x1ff4>
    53a4:	00001097          	auipc	ra,0x1
    53a8:	bd2080e7          	jalr	-1070(ra) # 5f76 <printf>
    exit(1);
    53ac:	4505                	li	a0,1
    53ae:	00001097          	auipc	ra,0x1
    53b2:	850080e7          	jalr	-1968(ra) # 5bfe <exit>

00000000000053b6 <fsfull>:
{
    53b6:	7171                	addi	sp,sp,-176
    53b8:	f506                	sd	ra,168(sp)
    53ba:	f122                	sd	s0,160(sp)
    53bc:	ed26                	sd	s1,152(sp)
    53be:	e94a                	sd	s2,144(sp)
    53c0:	e54e                	sd	s3,136(sp)
    53c2:	e152                	sd	s4,128(sp)
    53c4:	fcd6                	sd	s5,120(sp)
    53c6:	f8da                	sd	s6,112(sp)
    53c8:	f4de                	sd	s7,104(sp)
    53ca:	f0e2                	sd	s8,96(sp)
    53cc:	ece6                	sd	s9,88(sp)
    53ce:	e8ea                	sd	s10,80(sp)
    53d0:	e4ee                	sd	s11,72(sp)
    53d2:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    53d4:	00003517          	auipc	a0,0x3
    53d8:	c7450513          	addi	a0,a0,-908 # 8048 <malloc+0x2014>
    53dc:	00001097          	auipc	ra,0x1
    53e0:	b9a080e7          	jalr	-1126(ra) # 5f76 <printf>
  for(nfiles = 0; ; nfiles++){
    53e4:	4481                	li	s1,0
    name[0] = 'f';
    53e6:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    53ea:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    53ee:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    53f2:	4b29                	li	s6,10
    printf("writing %s\n", name);
    53f4:	00003c97          	auipc	s9,0x3
    53f8:	c64c8c93          	addi	s9,s9,-924 # 8058 <malloc+0x2024>
    int total = 0;
    53fc:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    53fe:	00008a17          	auipc	s4,0x8
    5402:	87aa0a13          	addi	s4,s4,-1926 # cc78 <buf>
    name[0] = 'f';
    5406:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    540a:	0384c7bb          	divw	a5,s1,s8
    540e:	0307879b          	addiw	a5,a5,48
    5412:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5416:	0384e7bb          	remw	a5,s1,s8
    541a:	0377c7bb          	divw	a5,a5,s7
    541e:	0307879b          	addiw	a5,a5,48
    5422:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5426:	0374e7bb          	remw	a5,s1,s7
    542a:	0367c7bb          	divw	a5,a5,s6
    542e:	0307879b          	addiw	a5,a5,48
    5432:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    5436:	0364e7bb          	remw	a5,s1,s6
    543a:	0307879b          	addiw	a5,a5,48
    543e:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    5442:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    5446:	f5040593          	addi	a1,s0,-176
    544a:	8566                	mv	a0,s9
    544c:	00001097          	auipc	ra,0x1
    5450:	b2a080e7          	jalr	-1238(ra) # 5f76 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    5454:	20200593          	li	a1,514
    5458:	f5040513          	addi	a0,s0,-176
    545c:	00000097          	auipc	ra,0x0
    5460:	7e2080e7          	jalr	2018(ra) # 5c3e <open>
    5464:	892a                	mv	s2,a0
    if(fd < 0){
    5466:	0a055663          	bgez	a0,5512 <fsfull+0x15c>
      printf("open %s failed\n", name);
    546a:	f5040593          	addi	a1,s0,-176
    546e:	00003517          	auipc	a0,0x3
    5472:	bfa50513          	addi	a0,a0,-1030 # 8068 <malloc+0x2034>
    5476:	00001097          	auipc	ra,0x1
    547a:	b00080e7          	jalr	-1280(ra) # 5f76 <printf>
  while(nfiles >= 0){
    547e:	0604c363          	bltz	s1,54e4 <fsfull+0x12e>
    name[0] = 'f';
    5482:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    5486:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    548a:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    548e:	4929                	li	s2,10
  while(nfiles >= 0){
    5490:	5afd                	li	s5,-1
    name[0] = 'f';
    5492:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    5496:	0344c7bb          	divw	a5,s1,s4
    549a:	0307879b          	addiw	a5,a5,48
    549e:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    54a2:	0344e7bb          	remw	a5,s1,s4
    54a6:	0337c7bb          	divw	a5,a5,s3
    54aa:	0307879b          	addiw	a5,a5,48
    54ae:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    54b2:	0334e7bb          	remw	a5,s1,s3
    54b6:	0327c7bb          	divw	a5,a5,s2
    54ba:	0307879b          	addiw	a5,a5,48
    54be:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    54c2:	0324e7bb          	remw	a5,s1,s2
    54c6:	0307879b          	addiw	a5,a5,48
    54ca:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    54ce:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    54d2:	f5040513          	addi	a0,s0,-176
    54d6:	00000097          	auipc	ra,0x0
    54da:	778080e7          	jalr	1912(ra) # 5c4e <unlink>
    nfiles--;
    54de:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    54e0:	fb5499e3          	bne	s1,s5,5492 <fsfull+0xdc>
  printf("fsfull test finished\n");
    54e4:	00003517          	auipc	a0,0x3
    54e8:	ba450513          	addi	a0,a0,-1116 # 8088 <malloc+0x2054>
    54ec:	00001097          	auipc	ra,0x1
    54f0:	a8a080e7          	jalr	-1398(ra) # 5f76 <printf>
}
    54f4:	70aa                	ld	ra,168(sp)
    54f6:	740a                	ld	s0,160(sp)
    54f8:	64ea                	ld	s1,152(sp)
    54fa:	694a                	ld	s2,144(sp)
    54fc:	69aa                	ld	s3,136(sp)
    54fe:	6a0a                	ld	s4,128(sp)
    5500:	7ae6                	ld	s5,120(sp)
    5502:	7b46                	ld	s6,112(sp)
    5504:	7ba6                	ld	s7,104(sp)
    5506:	7c06                	ld	s8,96(sp)
    5508:	6ce6                	ld	s9,88(sp)
    550a:	6d46                	ld	s10,80(sp)
    550c:	6da6                	ld	s11,72(sp)
    550e:	614d                	addi	sp,sp,176
    5510:	8082                	ret
    int total = 0;
    5512:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    5514:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    5518:	40000613          	li	a2,1024
    551c:	85d2                	mv	a1,s4
    551e:	854a                	mv	a0,s2
    5520:	00000097          	auipc	ra,0x0
    5524:	6fe080e7          	jalr	1790(ra) # 5c1e <write>
      if(cc < BSIZE)
    5528:	00aad563          	bge	s5,a0,5532 <fsfull+0x17c>
      total += cc;
    552c:	00a989bb          	addw	s3,s3,a0
    while(1){
    5530:	b7e5                	j	5518 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    5532:	85ce                	mv	a1,s3
    5534:	00003517          	auipc	a0,0x3
    5538:	b4450513          	addi	a0,a0,-1212 # 8078 <malloc+0x2044>
    553c:	00001097          	auipc	ra,0x1
    5540:	a3a080e7          	jalr	-1478(ra) # 5f76 <printf>
    close(fd);
    5544:	854a                	mv	a0,s2
    5546:	00000097          	auipc	ra,0x0
    554a:	6e0080e7          	jalr	1760(ra) # 5c26 <close>
    if(total == 0)
    554e:	f20988e3          	beqz	s3,547e <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    5552:	2485                	addiw	s1,s1,1
    5554:	bd4d                	j	5406 <fsfull+0x50>

0000000000005556 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5556:	7179                	addi	sp,sp,-48
    5558:	f406                	sd	ra,40(sp)
    555a:	f022                	sd	s0,32(sp)
    555c:	ec26                	sd	s1,24(sp)
    555e:	e84a                	sd	s2,16(sp)
    5560:	1800                	addi	s0,sp,48
    5562:	84aa                	mv	s1,a0
    5564:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5566:	00003517          	auipc	a0,0x3
    556a:	b3a50513          	addi	a0,a0,-1222 # 80a0 <malloc+0x206c>
    556e:	00001097          	auipc	ra,0x1
    5572:	a08080e7          	jalr	-1528(ra) # 5f76 <printf>
  if((pid = fork()) < 0) {
    5576:	00000097          	auipc	ra,0x0
    557a:	680080e7          	jalr	1664(ra) # 5bf6 <fork>
    557e:	02054e63          	bltz	a0,55ba <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5582:	c929                	beqz	a0,55d4 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    5584:	fdc40513          	addi	a0,s0,-36
    5588:	00000097          	auipc	ra,0x0
    558c:	67e080e7          	jalr	1662(ra) # 5c06 <wait>
    if(xstatus != 0) 
    5590:	fdc42783          	lw	a5,-36(s0)
    5594:	c7b9                	beqz	a5,55e2 <run+0x8c>
      printf("FAILED\n");
    5596:	00003517          	auipc	a0,0x3
    559a:	b3250513          	addi	a0,a0,-1230 # 80c8 <malloc+0x2094>
    559e:	00001097          	auipc	ra,0x1
    55a2:	9d8080e7          	jalr	-1576(ra) # 5f76 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    55a6:	fdc42503          	lw	a0,-36(s0)
  }
}
    55aa:	00153513          	seqz	a0,a0
    55ae:	70a2                	ld	ra,40(sp)
    55b0:	7402                	ld	s0,32(sp)
    55b2:	64e2                	ld	s1,24(sp)
    55b4:	6942                	ld	s2,16(sp)
    55b6:	6145                	addi	sp,sp,48
    55b8:	8082                	ret
    printf("runtest: fork error\n");
    55ba:	00003517          	auipc	a0,0x3
    55be:	af650513          	addi	a0,a0,-1290 # 80b0 <malloc+0x207c>
    55c2:	00001097          	auipc	ra,0x1
    55c6:	9b4080e7          	jalr	-1612(ra) # 5f76 <printf>
    exit(1);
    55ca:	4505                	li	a0,1
    55cc:	00000097          	auipc	ra,0x0
    55d0:	632080e7          	jalr	1586(ra) # 5bfe <exit>
    f(s);
    55d4:	854a                	mv	a0,s2
    55d6:	9482                	jalr	s1
    exit(0);
    55d8:	4501                	li	a0,0
    55da:	00000097          	auipc	ra,0x0
    55de:	624080e7          	jalr	1572(ra) # 5bfe <exit>
      printf("OK\n");
    55e2:	00003517          	auipc	a0,0x3
    55e6:	aee50513          	addi	a0,a0,-1298 # 80d0 <malloc+0x209c>
    55ea:	00001097          	auipc	ra,0x1
    55ee:	98c080e7          	jalr	-1652(ra) # 5f76 <printf>
    55f2:	bf55                	j	55a6 <run+0x50>

00000000000055f4 <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    55f4:	7179                	addi	sp,sp,-48
    55f6:	f406                	sd	ra,40(sp)
    55f8:	f022                	sd	s0,32(sp)
    55fa:	ec26                	sd	s1,24(sp)
    55fc:	e84a                	sd	s2,16(sp)
    55fe:	e44e                	sd	s3,8(sp)
    5600:	e052                	sd	s4,0(sp)
    5602:	1800                	addi	s0,sp,48
    5604:	84aa                	mv	s1,a0
  for (struct test *t = tests; t->s != 0; t++) {
    5606:	6508                	ld	a0,8(a0)
    5608:	c931                	beqz	a0,565c <runtests+0x68>
    560a:	892e                	mv	s2,a1
    560c:	89b2                	mv	s3,a2
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s)){
        if(continuous != 2){
    560e:	4a09                	li	s4,2
    5610:	a021                	j	5618 <runtests+0x24>
  for (struct test *t = tests; t->s != 0; t++) {
    5612:	04c1                	addi	s1,s1,16
    5614:	6488                	ld	a0,8(s1)
    5616:	c91d                	beqz	a0,564c <runtests+0x58>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    5618:	00090863          	beqz	s2,5628 <runtests+0x34>
    561c:	85ca                	mv	a1,s2
    561e:	00000097          	auipc	ra,0x0
    5622:	386080e7          	jalr	902(ra) # 59a4 <strcmp>
    5626:	f575                	bnez	a0,5612 <runtests+0x1e>
      if(!run(t->f, t->s)){
    5628:	648c                	ld	a1,8(s1)
    562a:	6088                	ld	a0,0(s1)
    562c:	00000097          	auipc	ra,0x0
    5630:	f2a080e7          	jalr	-214(ra) # 5556 <run>
    5634:	fd79                	bnez	a0,5612 <runtests+0x1e>
        if(continuous != 2){
    5636:	fd498ee3          	beq	s3,s4,5612 <runtests+0x1e>
          printf("SOME TESTS FAILED\n");
    563a:	00003517          	auipc	a0,0x3
    563e:	a9e50513          	addi	a0,a0,-1378 # 80d8 <malloc+0x20a4>
    5642:	00001097          	auipc	ra,0x1
    5646:	934080e7          	jalr	-1740(ra) # 5f76 <printf>
          return 1;
    564a:	4505                	li	a0,1
        }
      }
    }
  }
  return 0;
}
    564c:	70a2                	ld	ra,40(sp)
    564e:	7402                	ld	s0,32(sp)
    5650:	64e2                	ld	s1,24(sp)
    5652:	6942                	ld	s2,16(sp)
    5654:	69a2                	ld	s3,8(sp)
    5656:	6a02                	ld	s4,0(sp)
    5658:	6145                	addi	sp,sp,48
    565a:	8082                	ret
  return 0;
    565c:	4501                	li	a0,0
    565e:	b7fd                	j	564c <runtests+0x58>

0000000000005660 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    5660:	7139                	addi	sp,sp,-64
    5662:	fc06                	sd	ra,56(sp)
    5664:	f822                	sd	s0,48(sp)
    5666:	f426                	sd	s1,40(sp)
    5668:	f04a                	sd	s2,32(sp)
    566a:	ec4e                	sd	s3,24(sp)
    566c:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    566e:	fc840513          	addi	a0,s0,-56
    5672:	00000097          	auipc	ra,0x0
    5676:	59c080e7          	jalr	1436(ra) # 5c0e <pipe>
    567a:	06054863          	bltz	a0,56ea <countfree+0x8a>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    567e:	00000097          	auipc	ra,0x0
    5682:	578080e7          	jalr	1400(ra) # 5bf6 <fork>

  if(pid < 0){
    5686:	06054f63          	bltz	a0,5704 <countfree+0xa4>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    568a:	ed59                	bnez	a0,5728 <countfree+0xc8>
    close(fds[0]);
    568c:	fc842503          	lw	a0,-56(s0)
    5690:	00000097          	auipc	ra,0x0
    5694:	596080e7          	jalr	1430(ra) # 5c26 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    5698:	54fd                	li	s1,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    569a:	4985                	li	s3,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    569c:	00001917          	auipc	s2,0x1
    56a0:	b4c90913          	addi	s2,s2,-1204 # 61e8 <malloc+0x1b4>
      uint64 a = (uint64) sbrk(4096);
    56a4:	6505                	lui	a0,0x1
    56a6:	00000097          	auipc	ra,0x0
    56aa:	5e0080e7          	jalr	1504(ra) # 5c86 <sbrk>
      if(a == 0xffffffffffffffff){
    56ae:	06950863          	beq	a0,s1,571e <countfree+0xbe>
      *(char *)(a + 4096 - 1) = 1;
    56b2:	6785                	lui	a5,0x1
    56b4:	953e                	add	a0,a0,a5
    56b6:	ff350fa3          	sb	s3,-1(a0) # fff <linktest+0x101>
      if(write(fds[1], "x", 1) != 1){
    56ba:	4605                	li	a2,1
    56bc:	85ca                	mv	a1,s2
    56be:	fcc42503          	lw	a0,-52(s0)
    56c2:	00000097          	auipc	ra,0x0
    56c6:	55c080e7          	jalr	1372(ra) # 5c1e <write>
    56ca:	4785                	li	a5,1
    56cc:	fcf50ce3          	beq	a0,a5,56a4 <countfree+0x44>
        printf("write() failed in countfree()\n");
    56d0:	00003517          	auipc	a0,0x3
    56d4:	a6050513          	addi	a0,a0,-1440 # 8130 <malloc+0x20fc>
    56d8:	00001097          	auipc	ra,0x1
    56dc:	89e080e7          	jalr	-1890(ra) # 5f76 <printf>
        exit(1);
    56e0:	4505                	li	a0,1
    56e2:	00000097          	auipc	ra,0x0
    56e6:	51c080e7          	jalr	1308(ra) # 5bfe <exit>
    printf("pipe() failed in countfree()\n");
    56ea:	00003517          	auipc	a0,0x3
    56ee:	a0650513          	addi	a0,a0,-1530 # 80f0 <malloc+0x20bc>
    56f2:	00001097          	auipc	ra,0x1
    56f6:	884080e7          	jalr	-1916(ra) # 5f76 <printf>
    exit(1);
    56fa:	4505                	li	a0,1
    56fc:	00000097          	auipc	ra,0x0
    5700:	502080e7          	jalr	1282(ra) # 5bfe <exit>
    printf("fork failed in countfree()\n");
    5704:	00003517          	auipc	a0,0x3
    5708:	a0c50513          	addi	a0,a0,-1524 # 8110 <malloc+0x20dc>
    570c:	00001097          	auipc	ra,0x1
    5710:	86a080e7          	jalr	-1942(ra) # 5f76 <printf>
    exit(1);
    5714:	4505                	li	a0,1
    5716:	00000097          	auipc	ra,0x0
    571a:	4e8080e7          	jalr	1256(ra) # 5bfe <exit>
      }
    }

    exit(0);
    571e:	4501                	li	a0,0
    5720:	00000097          	auipc	ra,0x0
    5724:	4de080e7          	jalr	1246(ra) # 5bfe <exit>
  }

  close(fds[1]);
    5728:	fcc42503          	lw	a0,-52(s0)
    572c:	00000097          	auipc	ra,0x0
    5730:	4fa080e7          	jalr	1274(ra) # 5c26 <close>

  int n = 0;
    5734:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    5736:	4605                	li	a2,1
    5738:	fc740593          	addi	a1,s0,-57
    573c:	fc842503          	lw	a0,-56(s0)
    5740:	00000097          	auipc	ra,0x0
    5744:	4d6080e7          	jalr	1238(ra) # 5c16 <read>
    if(cc < 0){
    5748:	00054563          	bltz	a0,5752 <countfree+0xf2>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    574c:	c105                	beqz	a0,576c <countfree+0x10c>
      break;
    n += 1;
    574e:	2485                	addiw	s1,s1,1
  while(1){
    5750:	b7dd                	j	5736 <countfree+0xd6>
      printf("read() failed in countfree()\n");
    5752:	00003517          	auipc	a0,0x3
    5756:	9fe50513          	addi	a0,a0,-1538 # 8150 <malloc+0x211c>
    575a:	00001097          	auipc	ra,0x1
    575e:	81c080e7          	jalr	-2020(ra) # 5f76 <printf>
      exit(1);
    5762:	4505                	li	a0,1
    5764:	00000097          	auipc	ra,0x0
    5768:	49a080e7          	jalr	1178(ra) # 5bfe <exit>
  }

  close(fds[0]);
    576c:	fc842503          	lw	a0,-56(s0)
    5770:	00000097          	auipc	ra,0x0
    5774:	4b6080e7          	jalr	1206(ra) # 5c26 <close>
  wait((int*)0);
    5778:	4501                	li	a0,0
    577a:	00000097          	auipc	ra,0x0
    577e:	48c080e7          	jalr	1164(ra) # 5c06 <wait>
  
  return n;
}
    5782:	8526                	mv	a0,s1
    5784:	70e2                	ld	ra,56(sp)
    5786:	7442                	ld	s0,48(sp)
    5788:	74a2                	ld	s1,40(sp)
    578a:	7902                	ld	s2,32(sp)
    578c:	69e2                	ld	s3,24(sp)
    578e:	6121                	addi	sp,sp,64
    5790:	8082                	ret

0000000000005792 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    5792:	711d                	addi	sp,sp,-96
    5794:	ec86                	sd	ra,88(sp)
    5796:	e8a2                	sd	s0,80(sp)
    5798:	e4a6                	sd	s1,72(sp)
    579a:	e0ca                	sd	s2,64(sp)
    579c:	fc4e                	sd	s3,56(sp)
    579e:	f852                	sd	s4,48(sp)
    57a0:	f456                	sd	s5,40(sp)
    57a2:	f05a                	sd	s6,32(sp)
    57a4:	ec5e                	sd	s7,24(sp)
    57a6:	e862                	sd	s8,16(sp)
    57a8:	e466                	sd	s9,8(sp)
    57aa:	e06a                	sd	s10,0(sp)
    57ac:	1080                	addi	s0,sp,96
    57ae:	8a2a                	mv	s4,a0
    57b0:	892e                	mv	s2,a1
    57b2:	89b2                	mv	s3,a2
  do {
    printf("usertests starting\n");
    57b4:	00003b97          	auipc	s7,0x3
    57b8:	9bcb8b93          	addi	s7,s7,-1604 # 8170 <malloc+0x213c>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone, continuous)) {
    57bc:	00004b17          	auipc	s6,0x4
    57c0:	854b0b13          	addi	s6,s6,-1964 # 9010 <quicktests>
      if(continuous != 2) {
    57c4:	4a89                	li	s5,2
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    57c6:	00003c97          	auipc	s9,0x3
    57ca:	9e2c8c93          	addi	s9,s9,-1566 # 81a8 <malloc+0x2174>
      if (runtests(slowtests, justone, continuous)) {
    57ce:	00004c17          	auipc	s8,0x4
    57d2:	c12c0c13          	addi	s8,s8,-1006 # 93e0 <slowtests>
        printf("usertests slow tests starting\n");
    57d6:	00003d17          	auipc	s10,0x3
    57da:	9b2d0d13          	addi	s10,s10,-1614 # 8188 <malloc+0x2154>
    57de:	a839                	j	57fc <drivetests+0x6a>
    57e0:	856a                	mv	a0,s10
    57e2:	00000097          	auipc	ra,0x0
    57e6:	794080e7          	jalr	1940(ra) # 5f76 <printf>
    57ea:	a089                	j	582c <drivetests+0x9a>
    if((free1 = countfree()) < free0) {
    57ec:	00000097          	auipc	ra,0x0
    57f0:	e74080e7          	jalr	-396(ra) # 5660 <countfree>
    57f4:	06954463          	blt	a0,s1,585c <drivetests+0xca>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    57f8:	08090163          	beqz	s2,587a <drivetests+0xe8>
    printf("usertests starting\n");
    57fc:	855e                	mv	a0,s7
    57fe:	00000097          	auipc	ra,0x0
    5802:	778080e7          	jalr	1912(ra) # 5f76 <printf>
    int free0 = countfree();
    5806:	00000097          	auipc	ra,0x0
    580a:	e5a080e7          	jalr	-422(ra) # 5660 <countfree>
    580e:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone, continuous)) {
    5810:	864a                	mv	a2,s2
    5812:	85ce                	mv	a1,s3
    5814:	855a                	mv	a0,s6
    5816:	00000097          	auipc	ra,0x0
    581a:	dde080e7          	jalr	-546(ra) # 55f4 <runtests>
    581e:	c119                	beqz	a0,5824 <drivetests+0x92>
      if(continuous != 2) {
    5820:	05591963          	bne	s2,s5,5872 <drivetests+0xe0>
    if(!quick) {
    5824:	fc0a14e3          	bnez	s4,57ec <drivetests+0x5a>
      if (justone == 0)
    5828:	fa098ce3          	beqz	s3,57e0 <drivetests+0x4e>
      if (runtests(slowtests, justone, continuous)) {
    582c:	864a                	mv	a2,s2
    582e:	85ce                	mv	a1,s3
    5830:	8562                	mv	a0,s8
    5832:	00000097          	auipc	ra,0x0
    5836:	dc2080e7          	jalr	-574(ra) # 55f4 <runtests>
    583a:	d94d                	beqz	a0,57ec <drivetests+0x5a>
        if(continuous != 2) {
    583c:	03591d63          	bne	s2,s5,5876 <drivetests+0xe4>
    if((free1 = countfree()) < free0) {
    5840:	00000097          	auipc	ra,0x0
    5844:	e20080e7          	jalr	-480(ra) # 5660 <countfree>
    5848:	fa9558e3          	bge	a0,s1,57f8 <drivetests+0x66>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    584c:	8626                	mv	a2,s1
    584e:	85aa                	mv	a1,a0
    5850:	8566                	mv	a0,s9
    5852:	00000097          	auipc	ra,0x0
    5856:	724080e7          	jalr	1828(ra) # 5f76 <printf>
      if(continuous != 2) {
    585a:	b74d                	j	57fc <drivetests+0x6a>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    585c:	8626                	mv	a2,s1
    585e:	85aa                	mv	a1,a0
    5860:	8566                	mv	a0,s9
    5862:	00000097          	auipc	ra,0x0
    5866:	714080e7          	jalr	1812(ra) # 5f76 <printf>
      if(continuous != 2) {
    586a:	f95909e3          	beq	s2,s5,57fc <drivetests+0x6a>
        return 1;
    586e:	4505                	li	a0,1
    5870:	a031                	j	587c <drivetests+0xea>
        return 1;
    5872:	4505                	li	a0,1
    5874:	a021                	j	587c <drivetests+0xea>
          return 1;
    5876:	4505                	li	a0,1
    5878:	a011                	j	587c <drivetests+0xea>
  return 0;
    587a:	854a                	mv	a0,s2
}
    587c:	60e6                	ld	ra,88(sp)
    587e:	6446                	ld	s0,80(sp)
    5880:	64a6                	ld	s1,72(sp)
    5882:	6906                	ld	s2,64(sp)
    5884:	79e2                	ld	s3,56(sp)
    5886:	7a42                	ld	s4,48(sp)
    5888:	7aa2                	ld	s5,40(sp)
    588a:	7b02                	ld	s6,32(sp)
    588c:	6be2                	ld	s7,24(sp)
    588e:	6c42                	ld	s8,16(sp)
    5890:	6ca2                	ld	s9,8(sp)
    5892:	6d02                	ld	s10,0(sp)
    5894:	6125                	addi	sp,sp,96
    5896:	8082                	ret

0000000000005898 <main>:

int
main(int argc, char *argv[])
{
    5898:	1101                	addi	sp,sp,-32
    589a:	ec06                	sd	ra,24(sp)
    589c:	e822                	sd	s0,16(sp)
    589e:	e426                	sd	s1,8(sp)
    58a0:	e04a                	sd	s2,0(sp)
    58a2:	1000                	addi	s0,sp,32
    58a4:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    58a6:	4789                	li	a5,2
    58a8:	02f50363          	beq	a0,a5,58ce <main+0x36>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    58ac:	4785                	li	a5,1
    58ae:	06a7cd63          	blt	a5,a0,5928 <main+0x90>
  char *justone = 0;
    58b2:	4601                	li	a2,0
  int quick = 0;
    58b4:	4501                	li	a0,0
  int continuous = 0;
    58b6:	4481                	li	s1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    58b8:	85a6                	mv	a1,s1
    58ba:	00000097          	auipc	ra,0x0
    58be:	ed8080e7          	jalr	-296(ra) # 5792 <drivetests>
    58c2:	c949                	beqz	a0,5954 <main+0xbc>
    exit(1);
    58c4:	4505                	li	a0,1
    58c6:	00000097          	auipc	ra,0x0
    58ca:	338080e7          	jalr	824(ra) # 5bfe <exit>
    58ce:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    58d0:	00003597          	auipc	a1,0x3
    58d4:	90858593          	addi	a1,a1,-1784 # 81d8 <malloc+0x21a4>
    58d8:	00893503          	ld	a0,8(s2)
    58dc:	00000097          	auipc	ra,0x0
    58e0:	0c8080e7          	jalr	200(ra) # 59a4 <strcmp>
    58e4:	cd39                	beqz	a0,5942 <main+0xaa>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    58e6:	00003597          	auipc	a1,0x3
    58ea:	94a58593          	addi	a1,a1,-1718 # 8230 <malloc+0x21fc>
    58ee:	00893503          	ld	a0,8(s2)
    58f2:	00000097          	auipc	ra,0x0
    58f6:	0b2080e7          	jalr	178(ra) # 59a4 <strcmp>
    58fa:	c931                	beqz	a0,594e <main+0xb6>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    58fc:	00003597          	auipc	a1,0x3
    5900:	92c58593          	addi	a1,a1,-1748 # 8228 <malloc+0x21f4>
    5904:	00893503          	ld	a0,8(s2)
    5908:	00000097          	auipc	ra,0x0
    590c:	09c080e7          	jalr	156(ra) # 59a4 <strcmp>
    5910:	cd0d                	beqz	a0,594a <main+0xb2>
  } else if(argc == 2 && argv[1][0] != '-'){
    5912:	00893603          	ld	a2,8(s2)
    5916:	00064703          	lbu	a4,0(a2) # 3000 <execout+0x96>
    591a:	02d00793          	li	a5,45
    591e:	00f70563          	beq	a4,a5,5928 <main+0x90>
  int quick = 0;
    5922:	4501                	li	a0,0
  int continuous = 0;
    5924:	4481                	li	s1,0
    5926:	bf49                	j	58b8 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    5928:	00003517          	auipc	a0,0x3
    592c:	8b850513          	addi	a0,a0,-1864 # 81e0 <malloc+0x21ac>
    5930:	00000097          	auipc	ra,0x0
    5934:	646080e7          	jalr	1606(ra) # 5f76 <printf>
    exit(1);
    5938:	4505                	li	a0,1
    593a:	00000097          	auipc	ra,0x0
    593e:	2c4080e7          	jalr	708(ra) # 5bfe <exit>
  int continuous = 0;
    5942:	84aa                	mv	s1,a0
  char *justone = 0;
    5944:	4601                	li	a2,0
    quick = 1;
    5946:	4505                	li	a0,1
    5948:	bf85                	j	58b8 <main+0x20>
  char *justone = 0;
    594a:	4601                	li	a2,0
    594c:	b7b5                	j	58b8 <main+0x20>
    594e:	4601                	li	a2,0
    continuous = 1;
    5950:	4485                	li	s1,1
    5952:	b79d                	j	58b8 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    5954:	00003517          	auipc	a0,0x3
    5958:	8bc50513          	addi	a0,a0,-1860 # 8210 <malloc+0x21dc>
    595c:	00000097          	auipc	ra,0x0
    5960:	61a080e7          	jalr	1562(ra) # 5f76 <printf>
  exit(0);
    5964:	4501                	li	a0,0
    5966:	00000097          	auipc	ra,0x0
    596a:	298080e7          	jalr	664(ra) # 5bfe <exit>

000000000000596e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    596e:	1141                	addi	sp,sp,-16
    5970:	e406                	sd	ra,8(sp)
    5972:	e022                	sd	s0,0(sp)
    5974:	0800                	addi	s0,sp,16
  extern int main();
  main();
    5976:	00000097          	auipc	ra,0x0
    597a:	f22080e7          	jalr	-222(ra) # 5898 <main>
  exit(0);
    597e:	4501                	li	a0,0
    5980:	00000097          	auipc	ra,0x0
    5984:	27e080e7          	jalr	638(ra) # 5bfe <exit>

0000000000005988 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    5988:	1141                	addi	sp,sp,-16
    598a:	e422                	sd	s0,8(sp)
    598c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    598e:	87aa                	mv	a5,a0
    5990:	0585                	addi	a1,a1,1
    5992:	0785                	addi	a5,a5,1
    5994:	fff5c703          	lbu	a4,-1(a1)
    5998:	fee78fa3          	sb	a4,-1(a5) # fff <linktest+0x101>
    599c:	fb75                	bnez	a4,5990 <strcpy+0x8>
    ;
  return os;
}
    599e:	6422                	ld	s0,8(sp)
    59a0:	0141                	addi	sp,sp,16
    59a2:	8082                	ret

00000000000059a4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    59a4:	1141                	addi	sp,sp,-16
    59a6:	e422                	sd	s0,8(sp)
    59a8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    59aa:	00054783          	lbu	a5,0(a0)
    59ae:	cb91                	beqz	a5,59c2 <strcmp+0x1e>
    59b0:	0005c703          	lbu	a4,0(a1)
    59b4:	00f71763          	bne	a4,a5,59c2 <strcmp+0x1e>
    p++, q++;
    59b8:	0505                	addi	a0,a0,1
    59ba:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    59bc:	00054783          	lbu	a5,0(a0)
    59c0:	fbe5                	bnez	a5,59b0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    59c2:	0005c503          	lbu	a0,0(a1)
}
    59c6:	40a7853b          	subw	a0,a5,a0
    59ca:	6422                	ld	s0,8(sp)
    59cc:	0141                	addi	sp,sp,16
    59ce:	8082                	ret

00000000000059d0 <strlen>:

uint
strlen(const char *s)
{
    59d0:	1141                	addi	sp,sp,-16
    59d2:	e422                	sd	s0,8(sp)
    59d4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    59d6:	00054783          	lbu	a5,0(a0)
    59da:	cf91                	beqz	a5,59f6 <strlen+0x26>
    59dc:	0505                	addi	a0,a0,1
    59de:	87aa                	mv	a5,a0
    59e0:	4685                	li	a3,1
    59e2:	9e89                	subw	a3,a3,a0
    59e4:	00f6853b          	addw	a0,a3,a5
    59e8:	0785                	addi	a5,a5,1
    59ea:	fff7c703          	lbu	a4,-1(a5)
    59ee:	fb7d                	bnez	a4,59e4 <strlen+0x14>
    ;
  return n;
}
    59f0:	6422                	ld	s0,8(sp)
    59f2:	0141                	addi	sp,sp,16
    59f4:	8082                	ret
  for(n = 0; s[n]; n++)
    59f6:	4501                	li	a0,0
    59f8:	bfe5                	j	59f0 <strlen+0x20>

00000000000059fa <memset>:

void*
memset(void *dst, int c, uint n)
{
    59fa:	1141                	addi	sp,sp,-16
    59fc:	e422                	sd	s0,8(sp)
    59fe:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5a00:	ce09                	beqz	a2,5a1a <memset+0x20>
    5a02:	87aa                	mv	a5,a0
    5a04:	fff6071b          	addiw	a4,a2,-1
    5a08:	1702                	slli	a4,a4,0x20
    5a0a:	9301                	srli	a4,a4,0x20
    5a0c:	0705                	addi	a4,a4,1
    5a0e:	972a                	add	a4,a4,a0
    cdst[i] = c;
    5a10:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5a14:	0785                	addi	a5,a5,1
    5a16:	fee79de3          	bne	a5,a4,5a10 <memset+0x16>
  }
  return dst;
}
    5a1a:	6422                	ld	s0,8(sp)
    5a1c:	0141                	addi	sp,sp,16
    5a1e:	8082                	ret

0000000000005a20 <strchr>:

char*
strchr(const char *s, char c)
{
    5a20:	1141                	addi	sp,sp,-16
    5a22:	e422                	sd	s0,8(sp)
    5a24:	0800                	addi	s0,sp,16
  for(; *s; s++)
    5a26:	00054783          	lbu	a5,0(a0)
    5a2a:	cb99                	beqz	a5,5a40 <strchr+0x20>
    if(*s == c)
    5a2c:	00f58763          	beq	a1,a5,5a3a <strchr+0x1a>
  for(; *s; s++)
    5a30:	0505                	addi	a0,a0,1
    5a32:	00054783          	lbu	a5,0(a0)
    5a36:	fbfd                	bnez	a5,5a2c <strchr+0xc>
      return (char*)s;
  return 0;
    5a38:	4501                	li	a0,0
}
    5a3a:	6422                	ld	s0,8(sp)
    5a3c:	0141                	addi	sp,sp,16
    5a3e:	8082                	ret
  return 0;
    5a40:	4501                	li	a0,0
    5a42:	bfe5                	j	5a3a <strchr+0x1a>

0000000000005a44 <gets>:

char*
gets(char *buf, int max)
{
    5a44:	711d                	addi	sp,sp,-96
    5a46:	ec86                	sd	ra,88(sp)
    5a48:	e8a2                	sd	s0,80(sp)
    5a4a:	e4a6                	sd	s1,72(sp)
    5a4c:	e0ca                	sd	s2,64(sp)
    5a4e:	fc4e                	sd	s3,56(sp)
    5a50:	f852                	sd	s4,48(sp)
    5a52:	f456                	sd	s5,40(sp)
    5a54:	f05a                	sd	s6,32(sp)
    5a56:	ec5e                	sd	s7,24(sp)
    5a58:	1080                	addi	s0,sp,96
    5a5a:	8baa                	mv	s7,a0
    5a5c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5a5e:	892a                	mv	s2,a0
    5a60:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5a62:	4aa9                	li	s5,10
    5a64:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5a66:	89a6                	mv	s3,s1
    5a68:	2485                	addiw	s1,s1,1
    5a6a:	0344d863          	bge	s1,s4,5a9a <gets+0x56>
    cc = read(0, &c, 1);
    5a6e:	4605                	li	a2,1
    5a70:	faf40593          	addi	a1,s0,-81
    5a74:	4501                	li	a0,0
    5a76:	00000097          	auipc	ra,0x0
    5a7a:	1a0080e7          	jalr	416(ra) # 5c16 <read>
    if(cc < 1)
    5a7e:	00a05e63          	blez	a0,5a9a <gets+0x56>
    buf[i++] = c;
    5a82:	faf44783          	lbu	a5,-81(s0)
    5a86:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5a8a:	01578763          	beq	a5,s5,5a98 <gets+0x54>
    5a8e:	0905                	addi	s2,s2,1
    5a90:	fd679be3          	bne	a5,s6,5a66 <gets+0x22>
  for(i=0; i+1 < max; ){
    5a94:	89a6                	mv	s3,s1
    5a96:	a011                	j	5a9a <gets+0x56>
    5a98:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5a9a:	99de                	add	s3,s3,s7
    5a9c:	00098023          	sb	zero,0(s3)
  return buf;
}
    5aa0:	855e                	mv	a0,s7
    5aa2:	60e6                	ld	ra,88(sp)
    5aa4:	6446                	ld	s0,80(sp)
    5aa6:	64a6                	ld	s1,72(sp)
    5aa8:	6906                	ld	s2,64(sp)
    5aaa:	79e2                	ld	s3,56(sp)
    5aac:	7a42                	ld	s4,48(sp)
    5aae:	7aa2                	ld	s5,40(sp)
    5ab0:	7b02                	ld	s6,32(sp)
    5ab2:	6be2                	ld	s7,24(sp)
    5ab4:	6125                	addi	sp,sp,96
    5ab6:	8082                	ret

0000000000005ab8 <stat>:

int
stat(const char *n, struct stat *st)
{
    5ab8:	1101                	addi	sp,sp,-32
    5aba:	ec06                	sd	ra,24(sp)
    5abc:	e822                	sd	s0,16(sp)
    5abe:	e426                	sd	s1,8(sp)
    5ac0:	e04a                	sd	s2,0(sp)
    5ac2:	1000                	addi	s0,sp,32
    5ac4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5ac6:	4581                	li	a1,0
    5ac8:	00000097          	auipc	ra,0x0
    5acc:	176080e7          	jalr	374(ra) # 5c3e <open>
  if(fd < 0)
    5ad0:	02054563          	bltz	a0,5afa <stat+0x42>
    5ad4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5ad6:	85ca                	mv	a1,s2
    5ad8:	00000097          	auipc	ra,0x0
    5adc:	17e080e7          	jalr	382(ra) # 5c56 <fstat>
    5ae0:	892a                	mv	s2,a0
  close(fd);
    5ae2:	8526                	mv	a0,s1
    5ae4:	00000097          	auipc	ra,0x0
    5ae8:	142080e7          	jalr	322(ra) # 5c26 <close>
  return r;
}
    5aec:	854a                	mv	a0,s2
    5aee:	60e2                	ld	ra,24(sp)
    5af0:	6442                	ld	s0,16(sp)
    5af2:	64a2                	ld	s1,8(sp)
    5af4:	6902                	ld	s2,0(sp)
    5af6:	6105                	addi	sp,sp,32
    5af8:	8082                	ret
    return -1;
    5afa:	597d                	li	s2,-1
    5afc:	bfc5                	j	5aec <stat+0x34>

0000000000005afe <atoi>:

int
atoi(const char *s)
{
    5afe:	1141                	addi	sp,sp,-16
    5b00:	e422                	sd	s0,8(sp)
    5b02:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5b04:	00054603          	lbu	a2,0(a0)
    5b08:	fd06079b          	addiw	a5,a2,-48
    5b0c:	0ff7f793          	andi	a5,a5,255
    5b10:	4725                	li	a4,9
    5b12:	02f76963          	bltu	a4,a5,5b44 <atoi+0x46>
    5b16:	86aa                	mv	a3,a0
  n = 0;
    5b18:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    5b1a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    5b1c:	0685                	addi	a3,a3,1
    5b1e:	0025179b          	slliw	a5,a0,0x2
    5b22:	9fa9                	addw	a5,a5,a0
    5b24:	0017979b          	slliw	a5,a5,0x1
    5b28:	9fb1                	addw	a5,a5,a2
    5b2a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5b2e:	0006c603          	lbu	a2,0(a3) # 1000 <linktest+0x102>
    5b32:	fd06071b          	addiw	a4,a2,-48
    5b36:	0ff77713          	andi	a4,a4,255
    5b3a:	fee5f1e3          	bgeu	a1,a4,5b1c <atoi+0x1e>
  return n;
}
    5b3e:	6422                	ld	s0,8(sp)
    5b40:	0141                	addi	sp,sp,16
    5b42:	8082                	ret
  n = 0;
    5b44:	4501                	li	a0,0
    5b46:	bfe5                	j	5b3e <atoi+0x40>

0000000000005b48 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5b48:	1141                	addi	sp,sp,-16
    5b4a:	e422                	sd	s0,8(sp)
    5b4c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5b4e:	02b57663          	bgeu	a0,a1,5b7a <memmove+0x32>
    while(n-- > 0)
    5b52:	02c05163          	blez	a2,5b74 <memmove+0x2c>
    5b56:	fff6079b          	addiw	a5,a2,-1
    5b5a:	1782                	slli	a5,a5,0x20
    5b5c:	9381                	srli	a5,a5,0x20
    5b5e:	0785                	addi	a5,a5,1
    5b60:	97aa                	add	a5,a5,a0
  dst = vdst;
    5b62:	872a                	mv	a4,a0
      *dst++ = *src++;
    5b64:	0585                	addi	a1,a1,1
    5b66:	0705                	addi	a4,a4,1
    5b68:	fff5c683          	lbu	a3,-1(a1)
    5b6c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5b70:	fee79ae3          	bne	a5,a4,5b64 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5b74:	6422                	ld	s0,8(sp)
    5b76:	0141                	addi	sp,sp,16
    5b78:	8082                	ret
    dst += n;
    5b7a:	00c50733          	add	a4,a0,a2
    src += n;
    5b7e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5b80:	fec05ae3          	blez	a2,5b74 <memmove+0x2c>
    5b84:	fff6079b          	addiw	a5,a2,-1
    5b88:	1782                	slli	a5,a5,0x20
    5b8a:	9381                	srli	a5,a5,0x20
    5b8c:	fff7c793          	not	a5,a5
    5b90:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5b92:	15fd                	addi	a1,a1,-1
    5b94:	177d                	addi	a4,a4,-1
    5b96:	0005c683          	lbu	a3,0(a1)
    5b9a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5b9e:	fee79ae3          	bne	a5,a4,5b92 <memmove+0x4a>
    5ba2:	bfc9                	j	5b74 <memmove+0x2c>

0000000000005ba4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5ba4:	1141                	addi	sp,sp,-16
    5ba6:	e422                	sd	s0,8(sp)
    5ba8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5baa:	ca05                	beqz	a2,5bda <memcmp+0x36>
    5bac:	fff6069b          	addiw	a3,a2,-1
    5bb0:	1682                	slli	a3,a3,0x20
    5bb2:	9281                	srli	a3,a3,0x20
    5bb4:	0685                	addi	a3,a3,1
    5bb6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5bb8:	00054783          	lbu	a5,0(a0)
    5bbc:	0005c703          	lbu	a4,0(a1)
    5bc0:	00e79863          	bne	a5,a4,5bd0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5bc4:	0505                	addi	a0,a0,1
    p2++;
    5bc6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5bc8:	fed518e3          	bne	a0,a3,5bb8 <memcmp+0x14>
  }
  return 0;
    5bcc:	4501                	li	a0,0
    5bce:	a019                	j	5bd4 <memcmp+0x30>
      return *p1 - *p2;
    5bd0:	40e7853b          	subw	a0,a5,a4
}
    5bd4:	6422                	ld	s0,8(sp)
    5bd6:	0141                	addi	sp,sp,16
    5bd8:	8082                	ret
  return 0;
    5bda:	4501                	li	a0,0
    5bdc:	bfe5                	j	5bd4 <memcmp+0x30>

0000000000005bde <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5bde:	1141                	addi	sp,sp,-16
    5be0:	e406                	sd	ra,8(sp)
    5be2:	e022                	sd	s0,0(sp)
    5be4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5be6:	00000097          	auipc	ra,0x0
    5bea:	f62080e7          	jalr	-158(ra) # 5b48 <memmove>
}
    5bee:	60a2                	ld	ra,8(sp)
    5bf0:	6402                	ld	s0,0(sp)
    5bf2:	0141                	addi	sp,sp,16
    5bf4:	8082                	ret

0000000000005bf6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5bf6:	4885                	li	a7,1
 ecall
    5bf8:	00000073          	ecall
 ret
    5bfc:	8082                	ret

0000000000005bfe <exit>:
.global exit
exit:
 li a7, SYS_exit
    5bfe:	4889                	li	a7,2
 ecall
    5c00:	00000073          	ecall
 ret
    5c04:	8082                	ret

0000000000005c06 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5c06:	488d                	li	a7,3
 ecall
    5c08:	00000073          	ecall
 ret
    5c0c:	8082                	ret

0000000000005c0e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5c0e:	4891                	li	a7,4
 ecall
    5c10:	00000073          	ecall
 ret
    5c14:	8082                	ret

0000000000005c16 <read>:
.global read
read:
 li a7, SYS_read
    5c16:	4895                	li	a7,5
 ecall
    5c18:	00000073          	ecall
 ret
    5c1c:	8082                	ret

0000000000005c1e <write>:
.global write
write:
 li a7, SYS_write
    5c1e:	48c1                	li	a7,16
 ecall
    5c20:	00000073          	ecall
 ret
    5c24:	8082                	ret

0000000000005c26 <close>:
.global close
close:
 li a7, SYS_close
    5c26:	48d5                	li	a7,21
 ecall
    5c28:	00000073          	ecall
 ret
    5c2c:	8082                	ret

0000000000005c2e <kill>:
.global kill
kill:
 li a7, SYS_kill
    5c2e:	4899                	li	a7,6
 ecall
    5c30:	00000073          	ecall
 ret
    5c34:	8082                	ret

0000000000005c36 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5c36:	489d                	li	a7,7
 ecall
    5c38:	00000073          	ecall
 ret
    5c3c:	8082                	ret

0000000000005c3e <open>:
.global open
open:
 li a7, SYS_open
    5c3e:	48bd                	li	a7,15
 ecall
    5c40:	00000073          	ecall
 ret
    5c44:	8082                	ret

0000000000005c46 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5c46:	48c5                	li	a7,17
 ecall
    5c48:	00000073          	ecall
 ret
    5c4c:	8082                	ret

0000000000005c4e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5c4e:	48c9                	li	a7,18
 ecall
    5c50:	00000073          	ecall
 ret
    5c54:	8082                	ret

0000000000005c56 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5c56:	48a1                	li	a7,8
 ecall
    5c58:	00000073          	ecall
 ret
    5c5c:	8082                	ret

0000000000005c5e <link>:
.global link
link:
 li a7, SYS_link
    5c5e:	48cd                	li	a7,19
 ecall
    5c60:	00000073          	ecall
 ret
    5c64:	8082                	ret

0000000000005c66 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5c66:	48d1                	li	a7,20
 ecall
    5c68:	00000073          	ecall
 ret
    5c6c:	8082                	ret

0000000000005c6e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5c6e:	48a5                	li	a7,9
 ecall
    5c70:	00000073          	ecall
 ret
    5c74:	8082                	ret

0000000000005c76 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5c76:	48a9                	li	a7,10
 ecall
    5c78:	00000073          	ecall
 ret
    5c7c:	8082                	ret

0000000000005c7e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5c7e:	48ad                	li	a7,11
 ecall
    5c80:	00000073          	ecall
 ret
    5c84:	8082                	ret

0000000000005c86 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5c86:	48b1                	li	a7,12
 ecall
    5c88:	00000073          	ecall
 ret
    5c8c:	8082                	ret

0000000000005c8e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5c8e:	48b5                	li	a7,13
 ecall
    5c90:	00000073          	ecall
 ret
    5c94:	8082                	ret

0000000000005c96 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5c96:	48b9                	li	a7,14
 ecall
    5c98:	00000073          	ecall
 ret
    5c9c:	8082                	ret

0000000000005c9e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5c9e:	1101                	addi	sp,sp,-32
    5ca0:	ec06                	sd	ra,24(sp)
    5ca2:	e822                	sd	s0,16(sp)
    5ca4:	1000                	addi	s0,sp,32
    5ca6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5caa:	4605                	li	a2,1
    5cac:	fef40593          	addi	a1,s0,-17
    5cb0:	00000097          	auipc	ra,0x0
    5cb4:	f6e080e7          	jalr	-146(ra) # 5c1e <write>
}
    5cb8:	60e2                	ld	ra,24(sp)
    5cba:	6442                	ld	s0,16(sp)
    5cbc:	6105                	addi	sp,sp,32
    5cbe:	8082                	ret

0000000000005cc0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5cc0:	7139                	addi	sp,sp,-64
    5cc2:	fc06                	sd	ra,56(sp)
    5cc4:	f822                	sd	s0,48(sp)
    5cc6:	f426                	sd	s1,40(sp)
    5cc8:	f04a                	sd	s2,32(sp)
    5cca:	ec4e                	sd	s3,24(sp)
    5ccc:	0080                	addi	s0,sp,64
    5cce:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5cd0:	c299                	beqz	a3,5cd6 <printint+0x16>
    5cd2:	0805c863          	bltz	a1,5d62 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5cd6:	2581                	sext.w	a1,a1
  neg = 0;
    5cd8:	4881                	li	a7,0
    5cda:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5cde:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5ce0:	2601                	sext.w	a2,a2
    5ce2:	00003517          	auipc	a0,0x3
    5ce6:	8be50513          	addi	a0,a0,-1858 # 85a0 <digits>
    5cea:	883a                	mv	a6,a4
    5cec:	2705                	addiw	a4,a4,1
    5cee:	02c5f7bb          	remuw	a5,a1,a2
    5cf2:	1782                	slli	a5,a5,0x20
    5cf4:	9381                	srli	a5,a5,0x20
    5cf6:	97aa                	add	a5,a5,a0
    5cf8:	0007c783          	lbu	a5,0(a5)
    5cfc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5d00:	0005879b          	sext.w	a5,a1
    5d04:	02c5d5bb          	divuw	a1,a1,a2
    5d08:	0685                	addi	a3,a3,1
    5d0a:	fec7f0e3          	bgeu	a5,a2,5cea <printint+0x2a>
  if(neg)
    5d0e:	00088b63          	beqz	a7,5d24 <printint+0x64>
    buf[i++] = '-';
    5d12:	fd040793          	addi	a5,s0,-48
    5d16:	973e                	add	a4,a4,a5
    5d18:	02d00793          	li	a5,45
    5d1c:	fef70823          	sb	a5,-16(a4)
    5d20:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5d24:	02e05863          	blez	a4,5d54 <printint+0x94>
    5d28:	fc040793          	addi	a5,s0,-64
    5d2c:	00e78933          	add	s2,a5,a4
    5d30:	fff78993          	addi	s3,a5,-1
    5d34:	99ba                	add	s3,s3,a4
    5d36:	377d                	addiw	a4,a4,-1
    5d38:	1702                	slli	a4,a4,0x20
    5d3a:	9301                	srli	a4,a4,0x20
    5d3c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5d40:	fff94583          	lbu	a1,-1(s2)
    5d44:	8526                	mv	a0,s1
    5d46:	00000097          	auipc	ra,0x0
    5d4a:	f58080e7          	jalr	-168(ra) # 5c9e <putc>
  while(--i >= 0)
    5d4e:	197d                	addi	s2,s2,-1
    5d50:	ff3918e3          	bne	s2,s3,5d40 <printint+0x80>
}
    5d54:	70e2                	ld	ra,56(sp)
    5d56:	7442                	ld	s0,48(sp)
    5d58:	74a2                	ld	s1,40(sp)
    5d5a:	7902                	ld	s2,32(sp)
    5d5c:	69e2                	ld	s3,24(sp)
    5d5e:	6121                	addi	sp,sp,64
    5d60:	8082                	ret
    x = -xx;
    5d62:	40b005bb          	negw	a1,a1
    neg = 1;
    5d66:	4885                	li	a7,1
    x = -xx;
    5d68:	bf8d                	j	5cda <printint+0x1a>

0000000000005d6a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5d6a:	7119                	addi	sp,sp,-128
    5d6c:	fc86                	sd	ra,120(sp)
    5d6e:	f8a2                	sd	s0,112(sp)
    5d70:	f4a6                	sd	s1,104(sp)
    5d72:	f0ca                	sd	s2,96(sp)
    5d74:	ecce                	sd	s3,88(sp)
    5d76:	e8d2                	sd	s4,80(sp)
    5d78:	e4d6                	sd	s5,72(sp)
    5d7a:	e0da                	sd	s6,64(sp)
    5d7c:	fc5e                	sd	s7,56(sp)
    5d7e:	f862                	sd	s8,48(sp)
    5d80:	f466                	sd	s9,40(sp)
    5d82:	f06a                	sd	s10,32(sp)
    5d84:	ec6e                	sd	s11,24(sp)
    5d86:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5d88:	0005c903          	lbu	s2,0(a1)
    5d8c:	18090f63          	beqz	s2,5f2a <vprintf+0x1c0>
    5d90:	8aaa                	mv	s5,a0
    5d92:	8b32                	mv	s6,a2
    5d94:	00158493          	addi	s1,a1,1
  state = 0;
    5d98:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5d9a:	02500a13          	li	s4,37
      if(c == 'd'){
    5d9e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    5da2:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    5da6:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5daa:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5dae:	00002b97          	auipc	s7,0x2
    5db2:	7f2b8b93          	addi	s7,s7,2034 # 85a0 <digits>
    5db6:	a839                	j	5dd4 <vprintf+0x6a>
        putc(fd, c);
    5db8:	85ca                	mv	a1,s2
    5dba:	8556                	mv	a0,s5
    5dbc:	00000097          	auipc	ra,0x0
    5dc0:	ee2080e7          	jalr	-286(ra) # 5c9e <putc>
    5dc4:	a019                	j	5dca <vprintf+0x60>
    } else if(state == '%'){
    5dc6:	01498f63          	beq	s3,s4,5de4 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5dca:	0485                	addi	s1,s1,1
    5dcc:	fff4c903          	lbu	s2,-1(s1)
    5dd0:	14090d63          	beqz	s2,5f2a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    5dd4:	0009079b          	sext.w	a5,s2
    if(state == 0){
    5dd8:	fe0997e3          	bnez	s3,5dc6 <vprintf+0x5c>
      if(c == '%'){
    5ddc:	fd479ee3          	bne	a5,s4,5db8 <vprintf+0x4e>
        state = '%';
    5de0:	89be                	mv	s3,a5
    5de2:	b7e5                	j	5dca <vprintf+0x60>
      if(c == 'd'){
    5de4:	05878063          	beq	a5,s8,5e24 <vprintf+0xba>
      } else if(c == 'l') {
    5de8:	05978c63          	beq	a5,s9,5e40 <vprintf+0xd6>
      } else if(c == 'x') {
    5dec:	07a78863          	beq	a5,s10,5e5c <vprintf+0xf2>
      } else if(c == 'p') {
    5df0:	09b78463          	beq	a5,s11,5e78 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    5df4:	07300713          	li	a4,115
    5df8:	0ce78663          	beq	a5,a4,5ec4 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    5dfc:	06300713          	li	a4,99
    5e00:	0ee78e63          	beq	a5,a4,5efc <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    5e04:	11478863          	beq	a5,s4,5f14 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    5e08:	85d2                	mv	a1,s4
    5e0a:	8556                	mv	a0,s5
    5e0c:	00000097          	auipc	ra,0x0
    5e10:	e92080e7          	jalr	-366(ra) # 5c9e <putc>
        putc(fd, c);
    5e14:	85ca                	mv	a1,s2
    5e16:	8556                	mv	a0,s5
    5e18:	00000097          	auipc	ra,0x0
    5e1c:	e86080e7          	jalr	-378(ra) # 5c9e <putc>
      }
      state = 0;
    5e20:	4981                	li	s3,0
    5e22:	b765                	j	5dca <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    5e24:	008b0913          	addi	s2,s6,8
    5e28:	4685                	li	a3,1
    5e2a:	4629                	li	a2,10
    5e2c:	000b2583          	lw	a1,0(s6)
    5e30:	8556                	mv	a0,s5
    5e32:	00000097          	auipc	ra,0x0
    5e36:	e8e080e7          	jalr	-370(ra) # 5cc0 <printint>
    5e3a:	8b4a                	mv	s6,s2
      state = 0;
    5e3c:	4981                	li	s3,0
    5e3e:	b771                	j	5dca <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5e40:	008b0913          	addi	s2,s6,8
    5e44:	4681                	li	a3,0
    5e46:	4629                	li	a2,10
    5e48:	000b2583          	lw	a1,0(s6)
    5e4c:	8556                	mv	a0,s5
    5e4e:	00000097          	auipc	ra,0x0
    5e52:	e72080e7          	jalr	-398(ra) # 5cc0 <printint>
    5e56:	8b4a                	mv	s6,s2
      state = 0;
    5e58:	4981                	li	s3,0
    5e5a:	bf85                	j	5dca <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5e5c:	008b0913          	addi	s2,s6,8
    5e60:	4681                	li	a3,0
    5e62:	4641                	li	a2,16
    5e64:	000b2583          	lw	a1,0(s6)
    5e68:	8556                	mv	a0,s5
    5e6a:	00000097          	auipc	ra,0x0
    5e6e:	e56080e7          	jalr	-426(ra) # 5cc0 <printint>
    5e72:	8b4a                	mv	s6,s2
      state = 0;
    5e74:	4981                	li	s3,0
    5e76:	bf91                	j	5dca <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5e78:	008b0793          	addi	a5,s6,8
    5e7c:	f8f43423          	sd	a5,-120(s0)
    5e80:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5e84:	03000593          	li	a1,48
    5e88:	8556                	mv	a0,s5
    5e8a:	00000097          	auipc	ra,0x0
    5e8e:	e14080e7          	jalr	-492(ra) # 5c9e <putc>
  putc(fd, 'x');
    5e92:	85ea                	mv	a1,s10
    5e94:	8556                	mv	a0,s5
    5e96:	00000097          	auipc	ra,0x0
    5e9a:	e08080e7          	jalr	-504(ra) # 5c9e <putc>
    5e9e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5ea0:	03c9d793          	srli	a5,s3,0x3c
    5ea4:	97de                	add	a5,a5,s7
    5ea6:	0007c583          	lbu	a1,0(a5)
    5eaa:	8556                	mv	a0,s5
    5eac:	00000097          	auipc	ra,0x0
    5eb0:	df2080e7          	jalr	-526(ra) # 5c9e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5eb4:	0992                	slli	s3,s3,0x4
    5eb6:	397d                	addiw	s2,s2,-1
    5eb8:	fe0914e3          	bnez	s2,5ea0 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5ebc:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5ec0:	4981                	li	s3,0
    5ec2:	b721                	j	5dca <vprintf+0x60>
        s = va_arg(ap, char*);
    5ec4:	008b0993          	addi	s3,s6,8
    5ec8:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    5ecc:	02090163          	beqz	s2,5eee <vprintf+0x184>
        while(*s != 0){
    5ed0:	00094583          	lbu	a1,0(s2)
    5ed4:	c9a1                	beqz	a1,5f24 <vprintf+0x1ba>
          putc(fd, *s);
    5ed6:	8556                	mv	a0,s5
    5ed8:	00000097          	auipc	ra,0x0
    5edc:	dc6080e7          	jalr	-570(ra) # 5c9e <putc>
          s++;
    5ee0:	0905                	addi	s2,s2,1
        while(*s != 0){
    5ee2:	00094583          	lbu	a1,0(s2)
    5ee6:	f9e5                	bnez	a1,5ed6 <vprintf+0x16c>
        s = va_arg(ap, char*);
    5ee8:	8b4e                	mv	s6,s3
      state = 0;
    5eea:	4981                	li	s3,0
    5eec:	bdf9                	j	5dca <vprintf+0x60>
          s = "(null)";
    5eee:	00002917          	auipc	s2,0x2
    5ef2:	6aa90913          	addi	s2,s2,1706 # 8598 <malloc+0x2564>
        while(*s != 0){
    5ef6:	02800593          	li	a1,40
    5efa:	bff1                	j	5ed6 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    5efc:	008b0913          	addi	s2,s6,8
    5f00:	000b4583          	lbu	a1,0(s6)
    5f04:	8556                	mv	a0,s5
    5f06:	00000097          	auipc	ra,0x0
    5f0a:	d98080e7          	jalr	-616(ra) # 5c9e <putc>
    5f0e:	8b4a                	mv	s6,s2
      state = 0;
    5f10:	4981                	li	s3,0
    5f12:	bd65                	j	5dca <vprintf+0x60>
        putc(fd, c);
    5f14:	85d2                	mv	a1,s4
    5f16:	8556                	mv	a0,s5
    5f18:	00000097          	auipc	ra,0x0
    5f1c:	d86080e7          	jalr	-634(ra) # 5c9e <putc>
      state = 0;
    5f20:	4981                	li	s3,0
    5f22:	b565                	j	5dca <vprintf+0x60>
        s = va_arg(ap, char*);
    5f24:	8b4e                	mv	s6,s3
      state = 0;
    5f26:	4981                	li	s3,0
    5f28:	b54d                	j	5dca <vprintf+0x60>
    }
  }
}
    5f2a:	70e6                	ld	ra,120(sp)
    5f2c:	7446                	ld	s0,112(sp)
    5f2e:	74a6                	ld	s1,104(sp)
    5f30:	7906                	ld	s2,96(sp)
    5f32:	69e6                	ld	s3,88(sp)
    5f34:	6a46                	ld	s4,80(sp)
    5f36:	6aa6                	ld	s5,72(sp)
    5f38:	6b06                	ld	s6,64(sp)
    5f3a:	7be2                	ld	s7,56(sp)
    5f3c:	7c42                	ld	s8,48(sp)
    5f3e:	7ca2                	ld	s9,40(sp)
    5f40:	7d02                	ld	s10,32(sp)
    5f42:	6de2                	ld	s11,24(sp)
    5f44:	6109                	addi	sp,sp,128
    5f46:	8082                	ret

0000000000005f48 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5f48:	715d                	addi	sp,sp,-80
    5f4a:	ec06                	sd	ra,24(sp)
    5f4c:	e822                	sd	s0,16(sp)
    5f4e:	1000                	addi	s0,sp,32
    5f50:	e010                	sd	a2,0(s0)
    5f52:	e414                	sd	a3,8(s0)
    5f54:	e818                	sd	a4,16(s0)
    5f56:	ec1c                	sd	a5,24(s0)
    5f58:	03043023          	sd	a6,32(s0)
    5f5c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5f60:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5f64:	8622                	mv	a2,s0
    5f66:	00000097          	auipc	ra,0x0
    5f6a:	e04080e7          	jalr	-508(ra) # 5d6a <vprintf>
}
    5f6e:	60e2                	ld	ra,24(sp)
    5f70:	6442                	ld	s0,16(sp)
    5f72:	6161                	addi	sp,sp,80
    5f74:	8082                	ret

0000000000005f76 <printf>:

void
printf(const char *fmt, ...)
{
    5f76:	711d                	addi	sp,sp,-96
    5f78:	ec06                	sd	ra,24(sp)
    5f7a:	e822                	sd	s0,16(sp)
    5f7c:	1000                	addi	s0,sp,32
    5f7e:	e40c                	sd	a1,8(s0)
    5f80:	e810                	sd	a2,16(s0)
    5f82:	ec14                	sd	a3,24(s0)
    5f84:	f018                	sd	a4,32(s0)
    5f86:	f41c                	sd	a5,40(s0)
    5f88:	03043823          	sd	a6,48(s0)
    5f8c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5f90:	00840613          	addi	a2,s0,8
    5f94:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5f98:	85aa                	mv	a1,a0
    5f9a:	4505                	li	a0,1
    5f9c:	00000097          	auipc	ra,0x0
    5fa0:	dce080e7          	jalr	-562(ra) # 5d6a <vprintf>
}
    5fa4:	60e2                	ld	ra,24(sp)
    5fa6:	6442                	ld	s0,16(sp)
    5fa8:	6125                	addi	sp,sp,96
    5faa:	8082                	ret

0000000000005fac <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5fac:	1141                	addi	sp,sp,-16
    5fae:	e422                	sd	s0,8(sp)
    5fb0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5fb2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5fb6:	00003797          	auipc	a5,0x3
    5fba:	49a7b783          	ld	a5,1178(a5) # 9450 <freep>
    5fbe:	a805                	j	5fee <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5fc0:	4618                	lw	a4,8(a2)
    5fc2:	9db9                	addw	a1,a1,a4
    5fc4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5fc8:	6398                	ld	a4,0(a5)
    5fca:	6318                	ld	a4,0(a4)
    5fcc:	fee53823          	sd	a4,-16(a0)
    5fd0:	a091                	j	6014 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5fd2:	ff852703          	lw	a4,-8(a0)
    5fd6:	9e39                	addw	a2,a2,a4
    5fd8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5fda:	ff053703          	ld	a4,-16(a0)
    5fde:	e398                	sd	a4,0(a5)
    5fe0:	a099                	j	6026 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5fe2:	6398                	ld	a4,0(a5)
    5fe4:	00e7e463          	bltu	a5,a4,5fec <free+0x40>
    5fe8:	00e6ea63          	bltu	a3,a4,5ffc <free+0x50>
{
    5fec:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5fee:	fed7fae3          	bgeu	a5,a3,5fe2 <free+0x36>
    5ff2:	6398                	ld	a4,0(a5)
    5ff4:	00e6e463          	bltu	a3,a4,5ffc <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5ff8:	fee7eae3          	bltu	a5,a4,5fec <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    5ffc:	ff852583          	lw	a1,-8(a0)
    6000:	6390                	ld	a2,0(a5)
    6002:	02059713          	slli	a4,a1,0x20
    6006:	9301                	srli	a4,a4,0x20
    6008:	0712                	slli	a4,a4,0x4
    600a:	9736                	add	a4,a4,a3
    600c:	fae60ae3          	beq	a2,a4,5fc0 <free+0x14>
    bp->s.ptr = p->s.ptr;
    6010:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    6014:	4790                	lw	a2,8(a5)
    6016:	02061713          	slli	a4,a2,0x20
    601a:	9301                	srli	a4,a4,0x20
    601c:	0712                	slli	a4,a4,0x4
    601e:	973e                	add	a4,a4,a5
    6020:	fae689e3          	beq	a3,a4,5fd2 <free+0x26>
  } else
    p->s.ptr = bp;
    6024:	e394                	sd	a3,0(a5)
  freep = p;
    6026:	00003717          	auipc	a4,0x3
    602a:	42f73523          	sd	a5,1066(a4) # 9450 <freep>
}
    602e:	6422                	ld	s0,8(sp)
    6030:	0141                	addi	sp,sp,16
    6032:	8082                	ret

0000000000006034 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    6034:	7139                	addi	sp,sp,-64
    6036:	fc06                	sd	ra,56(sp)
    6038:	f822                	sd	s0,48(sp)
    603a:	f426                	sd	s1,40(sp)
    603c:	f04a                	sd	s2,32(sp)
    603e:	ec4e                	sd	s3,24(sp)
    6040:	e852                	sd	s4,16(sp)
    6042:	e456                	sd	s5,8(sp)
    6044:	e05a                	sd	s6,0(sp)
    6046:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    6048:	02051493          	slli	s1,a0,0x20
    604c:	9081                	srli	s1,s1,0x20
    604e:	04bd                	addi	s1,s1,15
    6050:	8091                	srli	s1,s1,0x4
    6052:	0014899b          	addiw	s3,s1,1
    6056:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    6058:	00003517          	auipc	a0,0x3
    605c:	3f853503          	ld	a0,1016(a0) # 9450 <freep>
    6060:	c515                	beqz	a0,608c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6062:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6064:	4798                	lw	a4,8(a5)
    6066:	02977f63          	bgeu	a4,s1,60a4 <malloc+0x70>
    606a:	8a4e                	mv	s4,s3
    606c:	0009871b          	sext.w	a4,s3
    6070:	6685                	lui	a3,0x1
    6072:	00d77363          	bgeu	a4,a3,6078 <malloc+0x44>
    6076:	6a05                	lui	s4,0x1
    6078:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    607c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    6080:	00003917          	auipc	s2,0x3
    6084:	3d090913          	addi	s2,s2,976 # 9450 <freep>
  if(p == (char*)-1)
    6088:	5afd                	li	s5,-1
    608a:	a88d                	j	60fc <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    608c:	0000a797          	auipc	a5,0xa
    6090:	bec78793          	addi	a5,a5,-1044 # fc78 <base>
    6094:	00003717          	auipc	a4,0x3
    6098:	3af73e23          	sd	a5,956(a4) # 9450 <freep>
    609c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    609e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    60a2:	b7e1                	j	606a <malloc+0x36>
      if(p->s.size == nunits)
    60a4:	02e48b63          	beq	s1,a4,60da <malloc+0xa6>
        p->s.size -= nunits;
    60a8:	4137073b          	subw	a4,a4,s3
    60ac:	c798                	sw	a4,8(a5)
        p += p->s.size;
    60ae:	1702                	slli	a4,a4,0x20
    60b0:	9301                	srli	a4,a4,0x20
    60b2:	0712                	slli	a4,a4,0x4
    60b4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    60b6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    60ba:	00003717          	auipc	a4,0x3
    60be:	38a73b23          	sd	a0,918(a4) # 9450 <freep>
      return (void*)(p + 1);
    60c2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    60c6:	70e2                	ld	ra,56(sp)
    60c8:	7442                	ld	s0,48(sp)
    60ca:	74a2                	ld	s1,40(sp)
    60cc:	7902                	ld	s2,32(sp)
    60ce:	69e2                	ld	s3,24(sp)
    60d0:	6a42                	ld	s4,16(sp)
    60d2:	6aa2                	ld	s5,8(sp)
    60d4:	6b02                	ld	s6,0(sp)
    60d6:	6121                	addi	sp,sp,64
    60d8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    60da:	6398                	ld	a4,0(a5)
    60dc:	e118                	sd	a4,0(a0)
    60de:	bff1                	j	60ba <malloc+0x86>
  hp->s.size = nu;
    60e0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    60e4:	0541                	addi	a0,a0,16
    60e6:	00000097          	auipc	ra,0x0
    60ea:	ec6080e7          	jalr	-314(ra) # 5fac <free>
  return freep;
    60ee:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    60f2:	d971                	beqz	a0,60c6 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    60f4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    60f6:	4798                	lw	a4,8(a5)
    60f8:	fa9776e3          	bgeu	a4,s1,60a4 <malloc+0x70>
    if(p == freep)
    60fc:	00093703          	ld	a4,0(s2)
    6100:	853e                	mv	a0,a5
    6102:	fef719e3          	bne	a4,a5,60f4 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    6106:	8552                	mv	a0,s4
    6108:	00000097          	auipc	ra,0x0
    610c:	b7e080e7          	jalr	-1154(ra) # 5c86 <sbrk>
  if(p == (char*)-1)
    6110:	fd5518e3          	bne	a0,s5,60e0 <malloc+0xac>
        return 0;
    6114:	4501                	li	a0,0
    6116:	bf45                	j	60c6 <malloc+0x92>
