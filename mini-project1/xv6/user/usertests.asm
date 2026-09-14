
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	f852                	sd	s4,48(sp)
       e:	1080                	addi	s0,sp,96
  uint64 addrs[] = {0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
      10:	00008797          	auipc	a5,0x8
      14:	5d078793          	addi	a5,a5,1488 # 85e0 <malloc+0x29e8>
      18:	638c                	ld	a1,0(a5)
      1a:	6790                	ld	a2,8(a5)
      1c:	6b94                	ld	a3,16(a5)
      1e:	6f98                	ld	a4,24(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	739c                	ld	a5,32(a5)
      32:	fcf43423          	sd	a5,-56(s0)
                    0xffffffffffffffff};

  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
      36:	fa840493          	addi	s1,s0,-88
      3a:	fd040a13          	addi	s4,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE | O_WRONLY);
      3e:	20100993          	li	s3,513
      42:	0004b903          	ld	s2,0(s1)
      46:	85ce                	mv	a1,s3
      48:	854a                	mv	a0,s2
      4a:	6cc050ef          	jal	5716 <open>
    if (fd >= 0) {
      4e:	00055d63          	bgez	a0,68 <copyinstr1+0x68>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
      52:	04a1                	addi	s1,s1,8
      54:	ff4497e3          	bne	s1,s4,42 <copyinstr1+0x42>
      printf("open(%p) returned %d, not -1\n", (void *)addr, fd);
      exit(1);
    }
  }
}
      58:	60e6                	ld	ra,88(sp)
      5a:	6446                	ld	s0,80(sp)
      5c:	64a6                	ld	s1,72(sp)
      5e:	6906                	ld	s2,64(sp)
      60:	79e2                	ld	s3,56(sp)
      62:	7a42                	ld	s4,48(sp)
      64:	6125                	addi	sp,sp,96
      66:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void *)addr, fd);
      68:	862a                	mv	a2,a0
      6a:	85ca                	mv	a1,s2
      6c:	00006517          	auipc	a0,0x6
      70:	c8450513          	addi	a0,a0,-892 # 5cf0 <malloc+0xf8>
      74:	2c9050ef          	jal	5b3c <printf>
      exit(1);
      78:	4505                	li	a0,1
      7a:	65c050ef          	jal	56d6 <exit>

000000000000007e <bsstest>:
void
bsstest(char *s)
{
  int i;

  for (i = 0; i < sizeof(uninit); i++) {
      7e:	0000b797          	auipc	a5,0xb
      82:	55a78793          	addi	a5,a5,1370 # b5d8 <uninit>
      86:	0000e697          	auipc	a3,0xe
      8a:	c6268693          	addi	a3,a3,-926 # dce8 <buf>
    if (uninit[i] != '\0') {
      8e:	0007c703          	lbu	a4,0(a5)
      92:	e709                	bnez	a4,9c <bsstest+0x1e>
  for (i = 0; i < sizeof(uninit); i++) {
      94:	0785                	addi	a5,a5,1
      96:	fed79ce3          	bne	a5,a3,8e <bsstest+0x10>
      9a:	8082                	ret
{
      9c:	1141                	addi	sp,sp,-16
      9e:	e406                	sd	ra,8(sp)
      a0:	e022                	sd	s0,0(sp)
      a2:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      a4:	85aa                	mv	a1,a0
      a6:	00006517          	auipc	a0,0x6
      aa:	c6a50513          	addi	a0,a0,-918 # 5d10 <malloc+0x118>
      ae:	28f050ef          	jal	5b3c <printf>
      exit(1);
      b2:	4505                	li	a0,1
      b4:	622050ef          	jal	56d6 <exit>

00000000000000b8 <opentest>:
{
      b8:	1101                	addi	sp,sp,-32
      ba:	ec06                	sd	ra,24(sp)
      bc:	e822                	sd	s0,16(sp)
      be:	e426                	sd	s1,8(sp)
      c0:	1000                	addi	s0,sp,32
      c2:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	c6250513          	addi	a0,a0,-926 # 5d28 <malloc+0x130>
      ce:	648050ef          	jal	5716 <open>
  if (fd < 0) {
      d2:	02054263          	bltz	a0,f6 <opentest+0x3e>
  close(fd);
      d6:	628050ef          	jal	56fe <close>
  fd = open("doesnotexist", 0);
      da:	4581                	li	a1,0
      dc:	00006517          	auipc	a0,0x6
      e0:	c6c50513          	addi	a0,a0,-916 # 5d48 <malloc+0x150>
      e4:	632050ef          	jal	5716 <open>
  if (fd >= 0) {
      e8:	02055163          	bgez	a0,10a <opentest+0x52>
}
      ec:	60e2                	ld	ra,24(sp)
      ee:	6442                	ld	s0,16(sp)
      f0:	64a2                	ld	s1,8(sp)
      f2:	6105                	addi	sp,sp,32
      f4:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f6:	85a6                	mv	a1,s1
      f8:	00006517          	auipc	a0,0x6
      fc:	c3850513          	addi	a0,a0,-968 # 5d30 <malloc+0x138>
     100:	23d050ef          	jal	5b3c <printf>
    exit(1);
     104:	4505                	li	a0,1
     106:	5d0050ef          	jal	56d6 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     10a:	85a6                	mv	a1,s1
     10c:	00006517          	auipc	a0,0x6
     110:	c4c50513          	addi	a0,a0,-948 # 5d58 <malloc+0x160>
     114:	229050ef          	jal	5b3c <printf>
    exit(1);
     118:	4505                	li	a0,1
     11a:	5bc050ef          	jal	56d6 <exit>

000000000000011e <truncate2>:
{
     11e:	7179                	addi	sp,sp,-48
     120:	f406                	sd	ra,40(sp)
     122:	f022                	sd	s0,32(sp)
     124:	ec26                	sd	s1,24(sp)
     126:	e84a                	sd	s2,16(sp)
     128:	e44e                	sd	s3,8(sp)
     12a:	1800                	addi	s0,sp,48
     12c:	89aa                	mv	s3,a0
  unlink("truncfile");
     12e:	00006517          	auipc	a0,0x6
     132:	c5250513          	addi	a0,a0,-942 # 5d80 <malloc+0x188>
     136:	5f0050ef          	jal	5726 <unlink>
  int fd1 = open("truncfile", O_CREATE | O_TRUNC | O_WRONLY);
     13a:	60100593          	li	a1,1537
     13e:	00006517          	auipc	a0,0x6
     142:	c4250513          	addi	a0,a0,-958 # 5d80 <malloc+0x188>
     146:	5d0050ef          	jal	5716 <open>
     14a:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     14c:	4611                	li	a2,4
     14e:	00006597          	auipc	a1,0x6
     152:	c4258593          	addi	a1,a1,-958 # 5d90 <malloc+0x198>
     156:	5a0050ef          	jal	56f6 <write>
  int fd2 = open("truncfile", O_TRUNC | O_WRONLY);
     15a:	40100593          	li	a1,1025
     15e:	00006517          	auipc	a0,0x6
     162:	c2250513          	addi	a0,a0,-990 # 5d80 <malloc+0x188>
     166:	5b0050ef          	jal	5716 <open>
     16a:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     16c:	4605                	li	a2,1
     16e:	00006597          	auipc	a1,0x6
     172:	c2a58593          	addi	a1,a1,-982 # 5d98 <malloc+0x1a0>
     176:	8526                	mv	a0,s1
     178:	57e050ef          	jal	56f6 <write>
  if (n != -1) {
     17c:	57fd                	li	a5,-1
     17e:	02f51563          	bne	a0,a5,1a8 <truncate2+0x8a>
  unlink("truncfile");
     182:	00006517          	auipc	a0,0x6
     186:	bfe50513          	addi	a0,a0,-1026 # 5d80 <malloc+0x188>
     18a:	59c050ef          	jal	5726 <unlink>
  close(fd1);
     18e:	8526                	mv	a0,s1
     190:	56e050ef          	jal	56fe <close>
  close(fd2);
     194:	854a                	mv	a0,s2
     196:	568050ef          	jal	56fe <close>
}
     19a:	70a2                	ld	ra,40(sp)
     19c:	7402                	ld	s0,32(sp)
     19e:	64e2                	ld	s1,24(sp)
     1a0:	6942                	ld	s2,16(sp)
     1a2:	69a2                	ld	s3,8(sp)
     1a4:	6145                	addi	sp,sp,48
     1a6:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a8:	862a                	mv	a2,a0
     1aa:	85ce                	mv	a1,s3
     1ac:	00006517          	auipc	a0,0x6
     1b0:	bf450513          	addi	a0,a0,-1036 # 5da0 <malloc+0x1a8>
     1b4:	189050ef          	jal	5b3c <printf>
    exit(1);
     1b8:	4505                	li	a0,1
     1ba:	51c050ef          	jal	56d6 <exit>

00000000000001be <createtest>:
{
     1be:	7139                	addi	sp,sp,-64
     1c0:	fc06                	sd	ra,56(sp)
     1c2:	f822                	sd	s0,48(sp)
     1c4:	f426                	sd	s1,40(sp)
     1c6:	f04a                	sd	s2,32(sp)
     1c8:	ec4e                	sd	s3,24(sp)
     1ca:	e852                	sd	s4,16(sp)
     1cc:	0080                	addi	s0,sp,64
  name[0] = 'a';
     1ce:	06100793          	li	a5,97
     1d2:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     1d6:	fc040523          	sb	zero,-54(s0)
     1da:	03000493          	li	s1,48
    fd = open(name, O_CREATE | O_RDWR);
     1de:	fc840a13          	addi	s4,s0,-56
     1e2:	20200993          	li	s3,514
  for (i = 0; i < N; i++) {
     1e6:	06400913          	li	s2,100
    name[1] = '0' + i;
     1ea:	fc9404a3          	sb	s1,-55(s0)
    fd = open(name, O_CREATE | O_RDWR);
     1ee:	85ce                	mv	a1,s3
     1f0:	8552                	mv	a0,s4
     1f2:	524050ef          	jal	5716 <open>
    close(fd);
     1f6:	508050ef          	jal	56fe <close>
  for (i = 0; i < N; i++) {
     1fa:	2485                	addiw	s1,s1,1
     1fc:	0ff4f493          	zext.b	s1,s1
     200:	ff2495e3          	bne	s1,s2,1ea <createtest+0x2c>
  name[0] = 'a';
     204:	06100793          	li	a5,97
     208:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     20c:	fc040523          	sb	zero,-54(s0)
     210:	03000493          	li	s1,48
    unlink(name);
     214:	fc840993          	addi	s3,s0,-56
  for (i = 0; i < N; i++) {
     218:	06400913          	li	s2,100
    name[1] = '0' + i;
     21c:	fc9404a3          	sb	s1,-55(s0)
    unlink(name);
     220:	854e                	mv	a0,s3
     222:	504050ef          	jal	5726 <unlink>
  for (i = 0; i < N; i++) {
     226:	2485                	addiw	s1,s1,1
     228:	0ff4f493          	zext.b	s1,s1
     22c:	ff2498e3          	bne	s1,s2,21c <createtest+0x5e>
}
     230:	70e2                	ld	ra,56(sp)
     232:	7442                	ld	s0,48(sp)
     234:	74a2                	ld	s1,40(sp)
     236:	7902                	ld	s2,32(sp)
     238:	69e2                	ld	s3,24(sp)
     23a:	6a42                	ld	s4,16(sp)
     23c:	6121                	addi	sp,sp,64
     23e:	8082                	ret

0000000000000240 <bigwrite>:
{
     240:	711d                	addi	sp,sp,-96
     242:	ec86                	sd	ra,88(sp)
     244:	e8a2                	sd	s0,80(sp)
     246:	e4a6                	sd	s1,72(sp)
     248:	e0ca                	sd	s2,64(sp)
     24a:	fc4e                	sd	s3,56(sp)
     24c:	f852                	sd	s4,48(sp)
     24e:	f456                	sd	s5,40(sp)
     250:	f05a                	sd	s6,32(sp)
     252:	ec5e                	sd	s7,24(sp)
     254:	e862                	sd	s8,16(sp)
     256:	e466                	sd	s9,8(sp)
     258:	1080                	addi	s0,sp,96
     25a:	8caa                	mv	s9,a0
  unlink("bigwrite");
     25c:	00006517          	auipc	a0,0x6
     260:	b6c50513          	addi	a0,a0,-1172 # 5dc8 <malloc+0x1d0>
     264:	4c2050ef          	jal	5726 <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     268:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26c:	20200b93          	li	s7,514
     270:	00006a17          	auipc	s4,0x6
     274:	b58a0a13          	addi	s4,s4,-1192 # 5dc8 <malloc+0x1d0>
    if (fd < 0) {
     278:	4b09                	li	s6,2
      int cc = write(fd, buf, sz);
     27a:	0000e997          	auipc	s3,0xe
     27e:	a6e98993          	addi	s3,s3,-1426 # dce8 <buf>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     282:	6a8d                	lui	s5,0x3
     284:	1c9a8a93          	addi	s5,s5,457 # 31c9 <rmdot+0x55>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     288:	85de                	mv	a1,s7
     28a:	8552                	mv	a0,s4
     28c:	48a050ef          	jal	5716 <open>
     290:	892a                	mv	s2,a0
    if (fd < 0) {
     292:	04054463          	bltz	a0,2da <bigwrite+0x9a>
     296:	8c5a                	mv	s8,s6
      int cc = write(fd, buf, sz);
     298:	8626                	mv	a2,s1
     29a:	85ce                	mv	a1,s3
     29c:	854a                	mv	a0,s2
     29e:	458050ef          	jal	56f6 <write>
      if (cc != sz) {
     2a2:	04951663          	bne	a0,s1,2ee <bigwrite+0xae>
    for (i = 0; i < 2; i++) {
     2a6:	3c7d                	addiw	s8,s8,-1
     2a8:	fe0c18e3          	bnez	s8,298 <bigwrite+0x58>
    close(fd);
     2ac:	854a                	mv	a0,s2
     2ae:	450050ef          	jal	56fe <close>
    unlink("bigwrite");
     2b2:	8552                	mv	a0,s4
     2b4:	472050ef          	jal	5726 <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     2b8:	1d74849b          	addiw	s1,s1,471
     2bc:	fd5496e3          	bne	s1,s5,288 <bigwrite+0x48>
}
     2c0:	60e6                	ld	ra,88(sp)
     2c2:	6446                	ld	s0,80(sp)
     2c4:	64a6                	ld	s1,72(sp)
     2c6:	6906                	ld	s2,64(sp)
     2c8:	79e2                	ld	s3,56(sp)
     2ca:	7a42                	ld	s4,48(sp)
     2cc:	7aa2                	ld	s5,40(sp)
     2ce:	7b02                	ld	s6,32(sp)
     2d0:	6be2                	ld	s7,24(sp)
     2d2:	6c42                	ld	s8,16(sp)
     2d4:	6ca2                	ld	s9,8(sp)
     2d6:	6125                	addi	sp,sp,96
     2d8:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2da:	85e6                	mv	a1,s9
     2dc:	00006517          	auipc	a0,0x6
     2e0:	afc50513          	addi	a0,a0,-1284 # 5dd8 <malloc+0x1e0>
     2e4:	059050ef          	jal	5b3c <printf>
      exit(1);
     2e8:	4505                	li	a0,1
     2ea:	3ec050ef          	jal	56d6 <exit>
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2ee:	86aa                	mv	a3,a0
     2f0:	8626                	mv	a2,s1
     2f2:	85e6                	mv	a1,s9
     2f4:	00006517          	auipc	a0,0x6
     2f8:	b0450513          	addi	a0,a0,-1276 # 5df8 <malloc+0x200>
     2fc:	041050ef          	jal	5b3c <printf>
        exit(1);
     300:	4505                	li	a0,1
     302:	3d4050ef          	jal	56d6 <exit>

0000000000000306 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     306:	7139                	addi	sp,sp,-64
     308:	fc06                	sd	ra,56(sp)
     30a:	f822                	sd	s0,48(sp)
     30c:	f426                	sd	s1,40(sp)
     30e:	f04a                	sd	s2,32(sp)
     310:	ec4e                	sd	s3,24(sp)
     312:	e852                	sd	s4,16(sp)
     314:	e456                	sd	s5,8(sp)
     316:	e05a                	sd	s6,0(sp)
     318:	0080                	addi	s0,sp,64
  int assumed_free = 600;

  unlink("junk");
     31a:	00006517          	auipc	a0,0x6
     31e:	af650513          	addi	a0,a0,-1290 # 5e10 <malloc+0x218>
     322:	404050ef          	jal	5726 <unlink>
     326:	25800913          	li	s2,600
  for (int i = 0; i < assumed_free; i++) {
    int fd = open("junk", O_CREATE | O_WRONLY);
     32a:	20100a93          	li	s5,513
     32e:	00006997          	auipc	s3,0x6
     332:	ae298993          	addi	s3,s3,-1310 # 5e10 <malloc+0x218>
    if (fd < 0) {
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char *)0xffffffffffL, 1);
     336:	4b05                	li	s6,1
     338:	5a7d                	li	s4,-1
     33a:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE | O_WRONLY);
     33e:	85d6                	mv	a1,s5
     340:	854e                	mv	a0,s3
     342:	3d4050ef          	jal	5716 <open>
     346:	84aa                	mv	s1,a0
    if (fd < 0) {
     348:	04054d63          	bltz	a0,3a2 <badwrite+0x9c>
    write(fd, (char *)0xffffffffffL, 1);
     34c:	865a                	mv	a2,s6
     34e:	85d2                	mv	a1,s4
     350:	3a6050ef          	jal	56f6 <write>
    close(fd);
     354:	8526                	mv	a0,s1
     356:	3a8050ef          	jal	56fe <close>
    unlink("junk");
     35a:	854e                	mv	a0,s3
     35c:	3ca050ef          	jal	5726 <unlink>
  for (int i = 0; i < assumed_free; i++) {
     360:	397d                	addiw	s2,s2,-1
     362:	fc091ee3          	bnez	s2,33e <badwrite+0x38>
  }

  int fd = open("junk", O_CREATE | O_WRONLY);
     366:	20100593          	li	a1,513
     36a:	00006517          	auipc	a0,0x6
     36e:	aa650513          	addi	a0,a0,-1370 # 5e10 <malloc+0x218>
     372:	3a4050ef          	jal	5716 <open>
     376:	84aa                	mv	s1,a0
  if (fd < 0) {
     378:	02054e63          	bltz	a0,3b4 <badwrite+0xae>
    printf("open junk failed\n");
    exit(1);
  }
  if (write(fd, "x", 1) != 1) {
     37c:	4605                	li	a2,1
     37e:	00006597          	auipc	a1,0x6
     382:	a1a58593          	addi	a1,a1,-1510 # 5d98 <malloc+0x1a0>
     386:	370050ef          	jal	56f6 <write>
     38a:	4785                	li	a5,1
     38c:	02f50d63          	beq	a0,a5,3c6 <badwrite+0xc0>
    printf("write failed\n");
     390:	00006517          	auipc	a0,0x6
     394:	aa050513          	addi	a0,a0,-1376 # 5e30 <malloc+0x238>
     398:	7a4050ef          	jal	5b3c <printf>
    exit(1);
     39c:	4505                	li	a0,1
     39e:	338050ef          	jal	56d6 <exit>
      printf("open junk failed\n");
     3a2:	00006517          	auipc	a0,0x6
     3a6:	a7650513          	addi	a0,a0,-1418 # 5e18 <malloc+0x220>
     3aa:	792050ef          	jal	5b3c <printf>
      exit(1);
     3ae:	4505                	li	a0,1
     3b0:	326050ef          	jal	56d6 <exit>
    printf("open junk failed\n");
     3b4:	00006517          	auipc	a0,0x6
     3b8:	a6450513          	addi	a0,a0,-1436 # 5e18 <malloc+0x220>
     3bc:	780050ef          	jal	5b3c <printf>
    exit(1);
     3c0:	4505                	li	a0,1
     3c2:	314050ef          	jal	56d6 <exit>
  }
  close(fd);
     3c6:	8526                	mv	a0,s1
     3c8:	336050ef          	jal	56fe <close>
  unlink("junk");
     3cc:	00006517          	auipc	a0,0x6
     3d0:	a4450513          	addi	a0,a0,-1468 # 5e10 <malloc+0x218>
     3d4:	352050ef          	jal	5726 <unlink>

  exit(0);
     3d8:	4501                	li	a0,0
     3da:	2fc050ef          	jal	56d6 <exit>

00000000000003de <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3de:	711d                	addi	sp,sp,-96
     3e0:	ec86                	sd	ra,88(sp)
     3e2:	e8a2                	sd	s0,80(sp)
     3e4:	e4a6                	sd	s1,72(sp)
     3e6:	e0ca                	sd	s2,64(sp)
     3e8:	fc4e                	sd	s3,56(sp)
     3ea:	f852                	sd	s4,48(sp)
     3ec:	f456                	sd	s5,40(sp)
     3ee:	1080                	addi	s0,sp,96
  int nzz = 32 * 32;
  for (int i = 0; i < nzz; i++) {
     3f0:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3f2:	07a00993          	li	s3,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     3f6:	fa040913          	addi	s2,s0,-96
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
     3fa:	60200a13          	li	s4,1538
  for (int i = 0; i < nzz; i++) {
     3fe:	40000a93          	li	s5,1024
    name[0] = 'z';
     402:	fb340023          	sb	s3,-96(s0)
    name[1] = 'z';
     406:	fb3400a3          	sb	s3,-95(s0)
    name[2] = '0' + (i / 32);
     40a:	41f4d71b          	sraiw	a4,s1,0x1f
     40e:	01b7571b          	srliw	a4,a4,0x1b
     412:	009707bb          	addw	a5,a4,s1
     416:	4057d69b          	sraiw	a3,a5,0x5
     41a:	0306869b          	addiw	a3,a3,48
     41e:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     422:	8bfd                	andi	a5,a5,31
     424:	9f99                	subw	a5,a5,a4
     426:	0307879b          	addiw	a5,a5,48
     42a:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     42e:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     432:	854a                	mv	a0,s2
     434:	2f2050ef          	jal	5726 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
     438:	85d2                	mv	a1,s4
     43a:	854a                	mv	a0,s2
     43c:	2da050ef          	jal	5716 <open>
    if (fd < 0) {
     440:	00054763          	bltz	a0,44e <outofinodes+0x70>
      // failure is eventually expected.
      break;
    }
    close(fd);
     444:	2ba050ef          	jal	56fe <close>
  for (int i = 0; i < nzz; i++) {
     448:	2485                	addiw	s1,s1,1
     44a:	fb549ce3          	bne	s1,s5,402 <outofinodes+0x24>
  }

  for (int i = 0; i < nzz; i++) {
     44e:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     450:	07a00913          	li	s2,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     454:	fa040a13          	addi	s4,s0,-96
  for (int i = 0; i < nzz; i++) {
     458:	40000993          	li	s3,1024
    name[0] = 'z';
     45c:	fb240023          	sb	s2,-96(s0)
    name[1] = 'z';
     460:	fb2400a3          	sb	s2,-95(s0)
    name[2] = '0' + (i / 32);
     464:	41f4d71b          	sraiw	a4,s1,0x1f
     468:	01b7571b          	srliw	a4,a4,0x1b
     46c:	009707bb          	addw	a5,a4,s1
     470:	4057d69b          	sraiw	a3,a5,0x5
     474:	0306869b          	addiw	a3,a3,48
     478:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     47c:	8bfd                	andi	a5,a5,31
     47e:	9f99                	subw	a5,a5,a4
     480:	0307879b          	addiw	a5,a5,48
     484:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     488:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     48c:	8552                	mv	a0,s4
     48e:	298050ef          	jal	5726 <unlink>
  for (int i = 0; i < nzz; i++) {
     492:	2485                	addiw	s1,s1,1
     494:	fd3494e3          	bne	s1,s3,45c <outofinodes+0x7e>
  }
}
     498:	60e6                	ld	ra,88(sp)
     49a:	6446                	ld	s0,80(sp)
     49c:	64a6                	ld	s1,72(sp)
     49e:	6906                	ld	s2,64(sp)
     4a0:	79e2                	ld	s3,56(sp)
     4a2:	7a42                	ld	s4,48(sp)
     4a4:	7aa2                	ld	s5,40(sp)
     4a6:	6125                	addi	sp,sp,96
     4a8:	8082                	ret

00000000000004aa <copyin>:
{
     4aa:	7175                	addi	sp,sp,-144
     4ac:	e506                	sd	ra,136(sp)
     4ae:	e122                	sd	s0,128(sp)
     4b0:	fca6                	sd	s1,120(sp)
     4b2:	f8ca                	sd	s2,112(sp)
     4b4:	f4ce                	sd	s3,104(sp)
     4b6:	f0d2                	sd	s4,96(sp)
     4b8:	ecd6                	sd	s5,88(sp)
     4ba:	e8da                	sd	s6,80(sp)
     4bc:	e4de                	sd	s7,72(sp)
     4be:	e0e2                	sd	s8,64(sp)
     4c0:	fc66                	sd	s9,56(sp)
     4c2:	0900                	addi	s0,sp,144
  uint64 addrs[] = {0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     4c4:	00008797          	auipc	a5,0x8
     4c8:	11c78793          	addi	a5,a5,284 # 85e0 <malloc+0x29e8>
     4cc:	638c                	ld	a1,0(a5)
     4ce:	6790                	ld	a2,8(a5)
     4d0:	6b94                	ld	a3,16(a5)
     4d2:	6f98                	ld	a4,24(a5)
     4d4:	f6b43c23          	sd	a1,-136(s0)
     4d8:	f8c43023          	sd	a2,-128(s0)
     4dc:	f8d43423          	sd	a3,-120(s0)
     4e0:	f8e43823          	sd	a4,-112(s0)
     4e4:	739c                	ld	a5,32(a5)
     4e6:	f8f43c23          	sd	a5,-104(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     4ea:	f7840913          	addi	s2,s0,-136
     4ee:	fa040c93          	addi	s9,s0,-96
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     4f2:	20100b13          	li	s6,513
     4f6:	00006a97          	auipc	s5,0x6
     4fa:	94aa8a93          	addi	s5,s5,-1718 # 5e40 <malloc+0x248>
    int n = write(fd, (void *)addr, 8192);
     4fe:	6a09                	lui	s4,0x2
    n = write(1, (char *)addr, 8192);
     500:	4c05                	li	s8,1
    if (pipe(fds) < 0) {
     502:	f7040b93          	addi	s7,s0,-144
    uint64 addr = addrs[ai];
     506:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     50a:	85da                	mv	a1,s6
     50c:	8556                	mv	a0,s5
     50e:	208050ef          	jal	5716 <open>
     512:	84aa                	mv	s1,a0
    if (fd < 0) {
     514:	06054a63          	bltz	a0,588 <copyin+0xde>
    int n = write(fd, (void *)addr, 8192);
     518:	8652                	mv	a2,s4
     51a:	85ce                	mv	a1,s3
     51c:	1da050ef          	jal	56f6 <write>
    if (n >= 0) {
     520:	06055d63          	bgez	a0,59a <copyin+0xf0>
    close(fd);
     524:	8526                	mv	a0,s1
     526:	1d8050ef          	jal	56fe <close>
    unlink("copyin1");
     52a:	8556                	mv	a0,s5
     52c:	1fa050ef          	jal	5726 <unlink>
    n = write(1, (char *)addr, 8192);
     530:	8652                	mv	a2,s4
     532:	85ce                	mv	a1,s3
     534:	8562                	mv	a0,s8
     536:	1c0050ef          	jal	56f6 <write>
    if (n > 0) {
     53a:	06a04b63          	bgtz	a0,5b0 <copyin+0x106>
    if (pipe(fds) < 0) {
     53e:	855e                	mv	a0,s7
     540:	1a6050ef          	jal	56e6 <pipe>
     544:	08054163          	bltz	a0,5c6 <copyin+0x11c>
    n = write(fds[1], (char *)addr, 8192);
     548:	8652                	mv	a2,s4
     54a:	85ce                	mv	a1,s3
     54c:	f7442503          	lw	a0,-140(s0)
     550:	1a6050ef          	jal	56f6 <write>
    if (n > 0) {
     554:	08a04263          	bgtz	a0,5d8 <copyin+0x12e>
    close(fds[0]);
     558:	f7042503          	lw	a0,-144(s0)
     55c:	1a2050ef          	jal	56fe <close>
    close(fds[1]);
     560:	f7442503          	lw	a0,-140(s0)
     564:	19a050ef          	jal	56fe <close>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     568:	0921                	addi	s2,s2,8
     56a:	f9991ee3          	bne	s2,s9,506 <copyin+0x5c>
}
     56e:	60aa                	ld	ra,136(sp)
     570:	640a                	ld	s0,128(sp)
     572:	74e6                	ld	s1,120(sp)
     574:	7946                	ld	s2,112(sp)
     576:	79a6                	ld	s3,104(sp)
     578:	7a06                	ld	s4,96(sp)
     57a:	6ae6                	ld	s5,88(sp)
     57c:	6b46                	ld	s6,80(sp)
     57e:	6ba6                	ld	s7,72(sp)
     580:	6c06                	ld	s8,64(sp)
     582:	7ce2                	ld	s9,56(sp)
     584:	6149                	addi	sp,sp,144
     586:	8082                	ret
      printf("open(copyin1) failed\n");
     588:	00006517          	auipc	a0,0x6
     58c:	8c050513          	addi	a0,a0,-1856 # 5e48 <malloc+0x250>
     590:	5ac050ef          	jal	5b3c <printf>
      exit(1);
     594:	4505                	li	a0,1
     596:	140050ef          	jal	56d6 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void *)addr, n);
     59a:	862a                	mv	a2,a0
     59c:	85ce                	mv	a1,s3
     59e:	00006517          	auipc	a0,0x6
     5a2:	8c250513          	addi	a0,a0,-1854 # 5e60 <malloc+0x268>
     5a6:	596050ef          	jal	5b3c <printf>
      exit(1);
     5aa:	4505                	li	a0,1
     5ac:	12a050ef          	jal	56d6 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void *)addr, n);
     5b0:	862a                	mv	a2,a0
     5b2:	85ce                	mv	a1,s3
     5b4:	00006517          	auipc	a0,0x6
     5b8:	8dc50513          	addi	a0,a0,-1828 # 5e90 <malloc+0x298>
     5bc:	580050ef          	jal	5b3c <printf>
      exit(1);
     5c0:	4505                	li	a0,1
     5c2:	114050ef          	jal	56d6 <exit>
      printf("pipe() failed\n");
     5c6:	00006517          	auipc	a0,0x6
     5ca:	8fa50513          	addi	a0,a0,-1798 # 5ec0 <malloc+0x2c8>
     5ce:	56e050ef          	jal	5b3c <printf>
      exit(1);
     5d2:	4505                	li	a0,1
     5d4:	102050ef          	jal	56d6 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void *)addr,
     5d8:	862a                	mv	a2,a0
     5da:	85ce                	mv	a1,s3
     5dc:	00006517          	auipc	a0,0x6
     5e0:	8f450513          	addi	a0,a0,-1804 # 5ed0 <malloc+0x2d8>
     5e4:	558050ef          	jal	5b3c <printf>
      exit(1);
     5e8:	4505                	li	a0,1
     5ea:	0ec050ef          	jal	56d6 <exit>

00000000000005ee <copyout>:
{
     5ee:	7135                	addi	sp,sp,-160
     5f0:	ed06                	sd	ra,152(sp)
     5f2:	e922                	sd	s0,144(sp)
     5f4:	e526                	sd	s1,136(sp)
     5f6:	e14a                	sd	s2,128(sp)
     5f8:	fcce                	sd	s3,120(sp)
     5fa:	f8d2                	sd	s4,112(sp)
     5fc:	f4d6                	sd	s5,104(sp)
     5fe:	f0da                	sd	s6,96(sp)
     600:	ecde                	sd	s7,88(sp)
     602:	e8e2                	sd	s8,80(sp)
     604:	e4e6                	sd	s9,72(sp)
     606:	1100                	addi	s0,sp,160
  uint64 addrs[] = {0LL,          0x80000000LL, 0x3fffffe000,
     608:	00008797          	auipc	a5,0x8
     60c:	fd878793          	addi	a5,a5,-40 # 85e0 <malloc+0x29e8>
     610:	7788                	ld	a0,40(a5)
     612:	7b8c                	ld	a1,48(a5)
     614:	7f90                	ld	a2,56(a5)
     616:	63b4                	ld	a3,64(a5)
     618:	67b8                	ld	a4,72(a5)
     61a:	f6a43823          	sd	a0,-144(s0)
     61e:	f6b43c23          	sd	a1,-136(s0)
     622:	f8c43023          	sd	a2,-128(s0)
     626:	f8d43423          	sd	a3,-120(s0)
     62a:	f8e43823          	sd	a4,-112(s0)
     62e:	6bbc                	ld	a5,80(a5)
     630:	f8f43c23          	sd	a5,-104(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     634:	f7040913          	addi	s2,s0,-144
     638:	fa040c93          	addi	s9,s0,-96
    int fd = open("README", 0);
     63c:	00006b17          	auipc	s6,0x6
     640:	8c4b0b13          	addi	s6,s6,-1852 # 5f00 <malloc+0x308>
    int n = read(fd, (void *)addr, 8192);
     644:	6a89                	lui	s5,0x2
    if (pipe(fds) < 0) {
     646:	f6840c13          	addi	s8,s0,-152
    n = write(fds[1], "x", 1);
     64a:	4a05                	li	s4,1
     64c:	00005b97          	auipc	s7,0x5
     650:	74cb8b93          	addi	s7,s7,1868 # 5d98 <malloc+0x1a0>
    uint64 addr = addrs[ai];
     654:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     658:	4581                	li	a1,0
     65a:	855a                	mv	a0,s6
     65c:	0ba050ef          	jal	5716 <open>
     660:	84aa                	mv	s1,a0
    if (fd < 0) {
     662:	06054863          	bltz	a0,6d2 <copyout+0xe4>
    int n = read(fd, (void *)addr, 8192);
     666:	8656                	mv	a2,s5
     668:	85ce                	mv	a1,s3
     66a:	084050ef          	jal	56ee <read>
    if (n > 0) {
     66e:	06a04b63          	bgtz	a0,6e4 <copyout+0xf6>
    close(fd);
     672:	8526                	mv	a0,s1
     674:	08a050ef          	jal	56fe <close>
    if (pipe(fds) < 0) {
     678:	8562                	mv	a0,s8
     67a:	06c050ef          	jal	56e6 <pipe>
     67e:	06054e63          	bltz	a0,6fa <copyout+0x10c>
    n = write(fds[1], "x", 1);
     682:	8652                	mv	a2,s4
     684:	85de                	mv	a1,s7
     686:	f6c42503          	lw	a0,-148(s0)
     68a:	06c050ef          	jal	56f6 <write>
    if (n != 1) {
     68e:	07451f63          	bne	a0,s4,70c <copyout+0x11e>
    n = read(fds[0], (void *)addr, 8192);
     692:	8656                	mv	a2,s5
     694:	85ce                	mv	a1,s3
     696:	f6842503          	lw	a0,-152(s0)
     69a:	054050ef          	jal	56ee <read>
    if (n > 0) {
     69e:	08a04063          	bgtz	a0,71e <copyout+0x130>
    close(fds[0]);
     6a2:	f6842503          	lw	a0,-152(s0)
     6a6:	058050ef          	jal	56fe <close>
    close(fds[1]);
     6aa:	f6c42503          	lw	a0,-148(s0)
     6ae:	050050ef          	jal	56fe <close>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     6b2:	0921                	addi	s2,s2,8
     6b4:	fb9910e3          	bne	s2,s9,654 <copyout+0x66>
}
     6b8:	60ea                	ld	ra,152(sp)
     6ba:	644a                	ld	s0,144(sp)
     6bc:	64aa                	ld	s1,136(sp)
     6be:	690a                	ld	s2,128(sp)
     6c0:	79e6                	ld	s3,120(sp)
     6c2:	7a46                	ld	s4,112(sp)
     6c4:	7aa6                	ld	s5,104(sp)
     6c6:	7b06                	ld	s6,96(sp)
     6c8:	6be6                	ld	s7,88(sp)
     6ca:	6c46                	ld	s8,80(sp)
     6cc:	6ca6                	ld	s9,72(sp)
     6ce:	610d                	addi	sp,sp,160
     6d0:	8082                	ret
      printf("open(README) failed\n");
     6d2:	00006517          	auipc	a0,0x6
     6d6:	83650513          	addi	a0,a0,-1994 # 5f08 <malloc+0x310>
     6da:	462050ef          	jal	5b3c <printf>
      exit(1);
     6de:	4505                	li	a0,1
     6e0:	7f7040ef          	jal	56d6 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void *)addr, n);
     6e4:	862a                	mv	a2,a0
     6e6:	85ce                	mv	a1,s3
     6e8:	00006517          	auipc	a0,0x6
     6ec:	83850513          	addi	a0,a0,-1992 # 5f20 <malloc+0x328>
     6f0:	44c050ef          	jal	5b3c <printf>
      exit(1);
     6f4:	4505                	li	a0,1
     6f6:	7e1040ef          	jal	56d6 <exit>
      printf("pipe() failed\n");
     6fa:	00005517          	auipc	a0,0x5
     6fe:	7c650513          	addi	a0,a0,1990 # 5ec0 <malloc+0x2c8>
     702:	43a050ef          	jal	5b3c <printf>
      exit(1);
     706:	4505                	li	a0,1
     708:	7cf040ef          	jal	56d6 <exit>
      printf("pipe write failed\n");
     70c:	00006517          	auipc	a0,0x6
     710:	84450513          	addi	a0,a0,-1980 # 5f50 <malloc+0x358>
     714:	428050ef          	jal	5b3c <printf>
      exit(1);
     718:	4505                	li	a0,1
     71a:	7bd040ef          	jal	56d6 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void *)addr,
     71e:	862a                	mv	a2,a0
     720:	85ce                	mv	a1,s3
     722:	00006517          	auipc	a0,0x6
     726:	84650513          	addi	a0,a0,-1978 # 5f68 <malloc+0x370>
     72a:	412050ef          	jal	5b3c <printf>
      exit(1);
     72e:	4505                	li	a0,1
     730:	7a7040ef          	jal	56d6 <exit>

0000000000000734 <truncate1>:
{
     734:	711d                	addi	sp,sp,-96
     736:	ec86                	sd	ra,88(sp)
     738:	e8a2                	sd	s0,80(sp)
     73a:	e4a6                	sd	s1,72(sp)
     73c:	e0ca                	sd	s2,64(sp)
     73e:	fc4e                	sd	s3,56(sp)
     740:	f852                	sd	s4,48(sp)
     742:	f456                	sd	s5,40(sp)
     744:	1080                	addi	s0,sp,96
     746:	8a2a                	mv	s4,a0
  unlink("truncfile");
     748:	00005517          	auipc	a0,0x5
     74c:	63850513          	addi	a0,a0,1592 # 5d80 <malloc+0x188>
     750:	7d7040ef          	jal	5726 <unlink>
  int fd1 = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
     754:	60100593          	li	a1,1537
     758:	00005517          	auipc	a0,0x5
     75c:	62850513          	addi	a0,a0,1576 # 5d80 <malloc+0x188>
     760:	7b7040ef          	jal	5716 <open>
     764:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     766:	4611                	li	a2,4
     768:	00005597          	auipc	a1,0x5
     76c:	62858593          	addi	a1,a1,1576 # 5d90 <malloc+0x198>
     770:	787040ef          	jal	56f6 <write>
  close(fd1);
     774:	8526                	mv	a0,s1
     776:	789040ef          	jal	56fe <close>
  int fd2 = open("truncfile", O_RDONLY);
     77a:	4581                	li	a1,0
     77c:	00005517          	auipc	a0,0x5
     780:	60450513          	addi	a0,a0,1540 # 5d80 <malloc+0x188>
     784:	793040ef          	jal	5716 <open>
     788:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     78a:	02000613          	li	a2,32
     78e:	fa040593          	addi	a1,s0,-96
     792:	75d040ef          	jal	56ee <read>
  if (n != 4) {
     796:	4791                	li	a5,4
     798:	0af51863          	bne	a0,a5,848 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY | O_TRUNC);
     79c:	40100593          	li	a1,1025
     7a0:	00005517          	auipc	a0,0x5
     7a4:	5e050513          	addi	a0,a0,1504 # 5d80 <malloc+0x188>
     7a8:	76f040ef          	jal	5716 <open>
     7ac:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     7ae:	4581                	li	a1,0
     7b0:	00005517          	auipc	a0,0x5
     7b4:	5d050513          	addi	a0,a0,1488 # 5d80 <malloc+0x188>
     7b8:	75f040ef          	jal	5716 <open>
     7bc:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     7be:	02000613          	li	a2,32
     7c2:	fa040593          	addi	a1,s0,-96
     7c6:	729040ef          	jal	56ee <read>
     7ca:	8aaa                	mv	s5,a0
  if (n != 0) {
     7cc:	e949                	bnez	a0,85e <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     7ce:	02000613          	li	a2,32
     7d2:	fa040593          	addi	a1,s0,-96
     7d6:	8526                	mv	a0,s1
     7d8:	717040ef          	jal	56ee <read>
     7dc:	8aaa                	mv	s5,a0
  if (n != 0) {
     7de:	e155                	bnez	a0,882 <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     7e0:	4619                	li	a2,6
     7e2:	00006597          	auipc	a1,0x6
     7e6:	81658593          	addi	a1,a1,-2026 # 5ff8 <malloc+0x400>
     7ea:	854e                	mv	a0,s3
     7ec:	70b040ef          	jal	56f6 <write>
  n = read(fd3, buf, sizeof(buf));
     7f0:	02000613          	li	a2,32
     7f4:	fa040593          	addi	a1,s0,-96
     7f8:	854a                	mv	a0,s2
     7fa:	6f5040ef          	jal	56ee <read>
  if (n != 6) {
     7fe:	4799                	li	a5,6
     800:	0af51363          	bne	a0,a5,8a6 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     804:	02000613          	li	a2,32
     808:	fa040593          	addi	a1,s0,-96
     80c:	8526                	mv	a0,s1
     80e:	6e1040ef          	jal	56ee <read>
  if (n != 2) {
     812:	4789                	li	a5,2
     814:	0af51463          	bne	a0,a5,8bc <truncate1+0x188>
  unlink("truncfile");
     818:	00005517          	auipc	a0,0x5
     81c:	56850513          	addi	a0,a0,1384 # 5d80 <malloc+0x188>
     820:	707040ef          	jal	5726 <unlink>
  close(fd1);
     824:	854e                	mv	a0,s3
     826:	6d9040ef          	jal	56fe <close>
  close(fd2);
     82a:	8526                	mv	a0,s1
     82c:	6d3040ef          	jal	56fe <close>
  close(fd3);
     830:	854a                	mv	a0,s2
     832:	6cd040ef          	jal	56fe <close>
}
     836:	60e6                	ld	ra,88(sp)
     838:	6446                	ld	s0,80(sp)
     83a:	64a6                	ld	s1,72(sp)
     83c:	6906                	ld	s2,64(sp)
     83e:	79e2                	ld	s3,56(sp)
     840:	7a42                	ld	s4,48(sp)
     842:	7aa2                	ld	s5,40(sp)
     844:	6125                	addi	sp,sp,96
     846:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     848:	862a                	mv	a2,a0
     84a:	85d2                	mv	a1,s4
     84c:	00005517          	auipc	a0,0x5
     850:	74c50513          	addi	a0,a0,1868 # 5f98 <malloc+0x3a0>
     854:	2e8050ef          	jal	5b3c <printf>
    exit(1);
     858:	4505                	li	a0,1
     85a:	67d040ef          	jal	56d6 <exit>
    printf("aaa fd3=%d\n", fd3);
     85e:	85ca                	mv	a1,s2
     860:	00005517          	auipc	a0,0x5
     864:	75850513          	addi	a0,a0,1880 # 5fb8 <malloc+0x3c0>
     868:	2d4050ef          	jal	5b3c <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     86c:	8656                	mv	a2,s5
     86e:	85d2                	mv	a1,s4
     870:	00005517          	auipc	a0,0x5
     874:	75850513          	addi	a0,a0,1880 # 5fc8 <malloc+0x3d0>
     878:	2c4050ef          	jal	5b3c <printf>
    exit(1);
     87c:	4505                	li	a0,1
     87e:	659040ef          	jal	56d6 <exit>
    printf("bbb fd2=%d\n", fd2);
     882:	85a6                	mv	a1,s1
     884:	00005517          	auipc	a0,0x5
     888:	76450513          	addi	a0,a0,1892 # 5fe8 <malloc+0x3f0>
     88c:	2b0050ef          	jal	5b3c <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     890:	8656                	mv	a2,s5
     892:	85d2                	mv	a1,s4
     894:	00005517          	auipc	a0,0x5
     898:	73450513          	addi	a0,a0,1844 # 5fc8 <malloc+0x3d0>
     89c:	2a0050ef          	jal	5b3c <printf>
    exit(1);
     8a0:	4505                	li	a0,1
     8a2:	635040ef          	jal	56d6 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     8a6:	862a                	mv	a2,a0
     8a8:	85d2                	mv	a1,s4
     8aa:	00005517          	auipc	a0,0x5
     8ae:	75650513          	addi	a0,a0,1878 # 6000 <malloc+0x408>
     8b2:	28a050ef          	jal	5b3c <printf>
    exit(1);
     8b6:	4505                	li	a0,1
     8b8:	61f040ef          	jal	56d6 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     8bc:	862a                	mv	a2,a0
     8be:	85d2                	mv	a1,s4
     8c0:	00005517          	auipc	a0,0x5
     8c4:	76050513          	addi	a0,a0,1888 # 6020 <malloc+0x428>
     8c8:	274050ef          	jal	5b3c <printf>
    exit(1);
     8cc:	4505                	li	a0,1
     8ce:	609040ef          	jal	56d6 <exit>

00000000000008d2 <writetest>:
{
     8d2:	715d                	addi	sp,sp,-80
     8d4:	e486                	sd	ra,72(sp)
     8d6:	e0a2                	sd	s0,64(sp)
     8d8:	fc26                	sd	s1,56(sp)
     8da:	f84a                	sd	s2,48(sp)
     8dc:	f44e                	sd	s3,40(sp)
     8de:	f052                	sd	s4,32(sp)
     8e0:	ec56                	sd	s5,24(sp)
     8e2:	e85a                	sd	s6,16(sp)
     8e4:	e45e                	sd	s7,8(sp)
     8e6:	0880                	addi	s0,sp,80
     8e8:	8baa                	mv	s7,a0
  fd = open("small", O_CREATE | O_RDWR);
     8ea:	20200593          	li	a1,514
     8ee:	00005517          	auipc	a0,0x5
     8f2:	75250513          	addi	a0,a0,1874 # 6040 <malloc+0x448>
     8f6:	621040ef          	jal	5716 <open>
  if (fd < 0) {
     8fa:	08054f63          	bltz	a0,998 <writetest+0xc6>
     8fe:	89aa                	mv	s3,a0
     900:	4901                	li	s2,0
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     902:	44a9                	li	s1,10
     904:	00005a17          	auipc	s4,0x5
     908:	764a0a13          	addi	s4,s4,1892 # 6068 <malloc+0x470>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     90c:	00005b17          	auipc	s6,0x5
     910:	794b0b13          	addi	s6,s6,1940 # 60a0 <malloc+0x4a8>
  for (i = 0; i < N; i++) {
     914:	06400a93          	li	s5,100
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     918:	8626                	mv	a2,s1
     91a:	85d2                	mv	a1,s4
     91c:	854e                	mv	a0,s3
     91e:	5d9040ef          	jal	56f6 <write>
     922:	08951563          	bne	a0,s1,9ac <writetest+0xda>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     926:	8626                	mv	a2,s1
     928:	85da                	mv	a1,s6
     92a:	854e                	mv	a0,s3
     92c:	5cb040ef          	jal	56f6 <write>
     930:	08951963          	bne	a0,s1,9c2 <writetest+0xf0>
  for (i = 0; i < N; i++) {
     934:	2905                	addiw	s2,s2,1
     936:	ff5911e3          	bne	s2,s5,918 <writetest+0x46>
  close(fd);
     93a:	854e                	mv	a0,s3
     93c:	5c3040ef          	jal	56fe <close>
  fd = open("small", O_RDONLY);
     940:	4581                	li	a1,0
     942:	00005517          	auipc	a0,0x5
     946:	6fe50513          	addi	a0,a0,1790 # 6040 <malloc+0x448>
     94a:	5cd040ef          	jal	5716 <open>
     94e:	84aa                	mv	s1,a0
  if (fd < 0) {
     950:	08054463          	bltz	a0,9d8 <writetest+0x106>
  i = read(fd, buf, N * SZ * 2);
     954:	7d000613          	li	a2,2000
     958:	0000d597          	auipc	a1,0xd
     95c:	39058593          	addi	a1,a1,912 # dce8 <buf>
     960:	58f040ef          	jal	56ee <read>
  if (i != N * SZ * 2) {
     964:	7d000793          	li	a5,2000
     968:	08f51263          	bne	a0,a5,9ec <writetest+0x11a>
  close(fd);
     96c:	8526                	mv	a0,s1
     96e:	591040ef          	jal	56fe <close>
  if (unlink("small") < 0) {
     972:	00005517          	auipc	a0,0x5
     976:	6ce50513          	addi	a0,a0,1742 # 6040 <malloc+0x448>
     97a:	5ad040ef          	jal	5726 <unlink>
     97e:	08054163          	bltz	a0,a00 <writetest+0x12e>
}
     982:	60a6                	ld	ra,72(sp)
     984:	6406                	ld	s0,64(sp)
     986:	74e2                	ld	s1,56(sp)
     988:	7942                	ld	s2,48(sp)
     98a:	79a2                	ld	s3,40(sp)
     98c:	7a02                	ld	s4,32(sp)
     98e:	6ae2                	ld	s5,24(sp)
     990:	6b42                	ld	s6,16(sp)
     992:	6ba2                	ld	s7,8(sp)
     994:	6161                	addi	sp,sp,80
     996:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     998:	85de                	mv	a1,s7
     99a:	00005517          	auipc	a0,0x5
     99e:	6ae50513          	addi	a0,a0,1710 # 6048 <malloc+0x450>
     9a2:	19a050ef          	jal	5b3c <printf>
    exit(1);
     9a6:	4505                	li	a0,1
     9a8:	52f040ef          	jal	56d6 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     9ac:	864a                	mv	a2,s2
     9ae:	85de                	mv	a1,s7
     9b0:	00005517          	auipc	a0,0x5
     9b4:	6c850513          	addi	a0,a0,1736 # 6078 <malloc+0x480>
     9b8:	184050ef          	jal	5b3c <printf>
      exit(1);
     9bc:	4505                	li	a0,1
     9be:	519040ef          	jal	56d6 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     9c2:	864a                	mv	a2,s2
     9c4:	85de                	mv	a1,s7
     9c6:	00005517          	auipc	a0,0x5
     9ca:	6ea50513          	addi	a0,a0,1770 # 60b0 <malloc+0x4b8>
     9ce:	16e050ef          	jal	5b3c <printf>
      exit(1);
     9d2:	4505                	li	a0,1
     9d4:	503040ef          	jal	56d6 <exit>
    printf("%s: error: open small failed!\n", s);
     9d8:	85de                	mv	a1,s7
     9da:	00005517          	auipc	a0,0x5
     9de:	6fe50513          	addi	a0,a0,1790 # 60d8 <malloc+0x4e0>
     9e2:	15a050ef          	jal	5b3c <printf>
    exit(1);
     9e6:	4505                	li	a0,1
     9e8:	4ef040ef          	jal	56d6 <exit>
    printf("%s: read failed\n", s);
     9ec:	85de                	mv	a1,s7
     9ee:	00005517          	auipc	a0,0x5
     9f2:	70a50513          	addi	a0,a0,1802 # 60f8 <malloc+0x500>
     9f6:	146050ef          	jal	5b3c <printf>
    exit(1);
     9fa:	4505                	li	a0,1
     9fc:	4db040ef          	jal	56d6 <exit>
    printf("%s: unlink small failed\n", s);
     a00:	85de                	mv	a1,s7
     a02:	00005517          	auipc	a0,0x5
     a06:	70e50513          	addi	a0,a0,1806 # 6110 <malloc+0x518>
     a0a:	132050ef          	jal	5b3c <printf>
    exit(1);
     a0e:	4505                	li	a0,1
     a10:	4c7040ef          	jal	56d6 <exit>

0000000000000a14 <writebig>:
{
     a14:	7139                	addi	sp,sp,-64
     a16:	fc06                	sd	ra,56(sp)
     a18:	f822                	sd	s0,48(sp)
     a1a:	f426                	sd	s1,40(sp)
     a1c:	f04a                	sd	s2,32(sp)
     a1e:	ec4e                	sd	s3,24(sp)
     a20:	e852                	sd	s4,16(sp)
     a22:	e456                	sd	s5,8(sp)
     a24:	e05a                	sd	s6,0(sp)
     a26:	0080                	addi	s0,sp,64
     a28:	8b2a                	mv	s6,a0
  fd = open("big", O_CREATE | O_RDWR);
     a2a:	20200593          	li	a1,514
     a2e:	00005517          	auipc	a0,0x5
     a32:	70250513          	addi	a0,a0,1794 # 6130 <malloc+0x538>
     a36:	4e1040ef          	jal	5716 <open>
  if (fd < 0) {
     a3a:	06054a63          	bltz	a0,aae <writebig+0x9a>
     a3e:	8a2a                	mv	s4,a0
     a40:	4481                	li	s1,0
    ((int *)buf)[0] = i;
     a42:	0000d997          	auipc	s3,0xd
     a46:	2a698993          	addi	s3,s3,678 # dce8 <buf>
    if (write(fd, buf, BSIZE) != BSIZE) {
     a4a:	40000913          	li	s2,1024
  for (i = 0; i < MAXFILE; i++) {
     a4e:	10c00a93          	li	s5,268
    ((int *)buf)[0] = i;
     a52:	0099a023          	sw	s1,0(s3)
    if (write(fd, buf, BSIZE) != BSIZE) {
     a56:	864a                	mv	a2,s2
     a58:	85ce                	mv	a1,s3
     a5a:	8552                	mv	a0,s4
     a5c:	49b040ef          	jal	56f6 <write>
     a60:	07251163          	bne	a0,s2,ac2 <writebig+0xae>
  for (i = 0; i < MAXFILE; i++) {
     a64:	2485                	addiw	s1,s1,1
     a66:	ff5496e3          	bne	s1,s5,a52 <writebig+0x3e>
  close(fd);
     a6a:	8552                	mv	a0,s4
     a6c:	493040ef          	jal	56fe <close>
  fd = open("big", O_RDONLY);
     a70:	4581                	li	a1,0
     a72:	00005517          	auipc	a0,0x5
     a76:	6be50513          	addi	a0,a0,1726 # 6130 <malloc+0x538>
     a7a:	49d040ef          	jal	5716 <open>
     a7e:	8a2a                	mv	s4,a0
  n = 0;
     a80:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a82:	40000993          	li	s3,1024
     a86:	0000d917          	auipc	s2,0xd
     a8a:	26290913          	addi	s2,s2,610 # dce8 <buf>
  if (fd < 0) {
     a8e:	04054563          	bltz	a0,ad8 <writebig+0xc4>
    i = read(fd, buf, BSIZE);
     a92:	864e                	mv	a2,s3
     a94:	85ca                	mv	a1,s2
     a96:	8552                	mv	a0,s4
     a98:	457040ef          	jal	56ee <read>
    if (i == 0) {
     a9c:	c921                	beqz	a0,aec <writebig+0xd8>
    } else if (i != BSIZE) {
     a9e:	09351b63          	bne	a0,s3,b34 <writebig+0x120>
    if (((int *)buf)[0] != n) {
     aa2:	00092683          	lw	a3,0(s2)
     aa6:	0a969263          	bne	a3,s1,b4a <writebig+0x136>
    n++;
     aaa:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     aac:	b7dd                	j	a92 <writebig+0x7e>
    printf("%s: error: creat big failed!\n", s);
     aae:	85da                	mv	a1,s6
     ab0:	00005517          	auipc	a0,0x5
     ab4:	68850513          	addi	a0,a0,1672 # 6138 <malloc+0x540>
     ab8:	084050ef          	jal	5b3c <printf>
    exit(1);
     abc:	4505                	li	a0,1
     abe:	419040ef          	jal	56d6 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     ac2:	8626                	mv	a2,s1
     ac4:	85da                	mv	a1,s6
     ac6:	00005517          	auipc	a0,0x5
     aca:	69250513          	addi	a0,a0,1682 # 6158 <malloc+0x560>
     ace:	06e050ef          	jal	5b3c <printf>
      exit(1);
     ad2:	4505                	li	a0,1
     ad4:	403040ef          	jal	56d6 <exit>
    printf("%s: error: open big failed!\n", s);
     ad8:	85da                	mv	a1,s6
     ada:	00005517          	auipc	a0,0x5
     ade:	6a650513          	addi	a0,a0,1702 # 6180 <malloc+0x588>
     ae2:	05a050ef          	jal	5b3c <printf>
    exit(1);
     ae6:	4505                	li	a0,1
     ae8:	3ef040ef          	jal	56d6 <exit>
      if (n != MAXFILE) {
     aec:	10c00793          	li	a5,268
     af0:	02f49763          	bne	s1,a5,b1e <writebig+0x10a>
  close(fd);
     af4:	8552                	mv	a0,s4
     af6:	409040ef          	jal	56fe <close>
  if (unlink("big") < 0) {
     afa:	00005517          	auipc	a0,0x5
     afe:	63650513          	addi	a0,a0,1590 # 6130 <malloc+0x538>
     b02:	425040ef          	jal	5726 <unlink>
     b06:	04054d63          	bltz	a0,b60 <writebig+0x14c>
}
     b0a:	70e2                	ld	ra,56(sp)
     b0c:	7442                	ld	s0,48(sp)
     b0e:	74a2                	ld	s1,40(sp)
     b10:	7902                	ld	s2,32(sp)
     b12:	69e2                	ld	s3,24(sp)
     b14:	6a42                	ld	s4,16(sp)
     b16:	6aa2                	ld	s5,8(sp)
     b18:	6b02                	ld	s6,0(sp)
     b1a:	6121                	addi	sp,sp,64
     b1c:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     b1e:	8626                	mv	a2,s1
     b20:	85da                	mv	a1,s6
     b22:	00005517          	auipc	a0,0x5
     b26:	67e50513          	addi	a0,a0,1662 # 61a0 <malloc+0x5a8>
     b2a:	012050ef          	jal	5b3c <printf>
        exit(1);
     b2e:	4505                	li	a0,1
     b30:	3a7040ef          	jal	56d6 <exit>
      printf("%s: read failed %d\n", s, i);
     b34:	862a                	mv	a2,a0
     b36:	85da                	mv	a1,s6
     b38:	00005517          	auipc	a0,0x5
     b3c:	69050513          	addi	a0,a0,1680 # 61c8 <malloc+0x5d0>
     b40:	7fd040ef          	jal	5b3c <printf>
      exit(1);
     b44:	4505                	li	a0,1
     b46:	391040ef          	jal	56d6 <exit>
      printf("%s: read content of block %d is %d\n", s, n, ((int *)buf)[0]);
     b4a:	8626                	mv	a2,s1
     b4c:	85da                	mv	a1,s6
     b4e:	00005517          	auipc	a0,0x5
     b52:	69250513          	addi	a0,a0,1682 # 61e0 <malloc+0x5e8>
     b56:	7e7040ef          	jal	5b3c <printf>
      exit(1);
     b5a:	4505                	li	a0,1
     b5c:	37b040ef          	jal	56d6 <exit>
    printf("%s: unlink big failed\n", s);
     b60:	85da                	mv	a1,s6
     b62:	00005517          	auipc	a0,0x5
     b66:	6a650513          	addi	a0,a0,1702 # 6208 <malloc+0x610>
     b6a:	7d3040ef          	jal	5b3c <printf>
    exit(1);
     b6e:	4505                	li	a0,1
     b70:	367040ef          	jal	56d6 <exit>

0000000000000b74 <unlinkread>:
{
     b74:	7179                	addi	sp,sp,-48
     b76:	f406                	sd	ra,40(sp)
     b78:	f022                	sd	s0,32(sp)
     b7a:	ec26                	sd	s1,24(sp)
     b7c:	e84a                	sd	s2,16(sp)
     b7e:	e44e                	sd	s3,8(sp)
     b80:	1800                	addi	s0,sp,48
     b82:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b84:	20200593          	li	a1,514
     b88:	00005517          	auipc	a0,0x5
     b8c:	69850513          	addi	a0,a0,1688 # 6220 <malloc+0x628>
     b90:	387040ef          	jal	5716 <open>
  if (fd < 0) {
     b94:	0a054f63          	bltz	a0,c52 <unlinkread+0xde>
     b98:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b9a:	4615                	li	a2,5
     b9c:	00005597          	auipc	a1,0x5
     ba0:	6b458593          	addi	a1,a1,1716 # 6250 <malloc+0x658>
     ba4:	353040ef          	jal	56f6 <write>
  close(fd);
     ba8:	8526                	mv	a0,s1
     baa:	355040ef          	jal	56fe <close>
  fd = open("unlinkread", O_RDWR);
     bae:	4589                	li	a1,2
     bb0:	00005517          	auipc	a0,0x5
     bb4:	67050513          	addi	a0,a0,1648 # 6220 <malloc+0x628>
     bb8:	35f040ef          	jal	5716 <open>
     bbc:	84aa                	mv	s1,a0
  if (fd < 0) {
     bbe:	0a054463          	bltz	a0,c66 <unlinkread+0xf2>
  if (unlink("unlinkread") != 0) {
     bc2:	00005517          	auipc	a0,0x5
     bc6:	65e50513          	addi	a0,a0,1630 # 6220 <malloc+0x628>
     bca:	35d040ef          	jal	5726 <unlink>
     bce:	e555                	bnez	a0,c7a <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd0:	20200593          	li	a1,514
     bd4:	00005517          	auipc	a0,0x5
     bd8:	64c50513          	addi	a0,a0,1612 # 6220 <malloc+0x628>
     bdc:	33b040ef          	jal	5716 <open>
     be0:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be2:	460d                	li	a2,3
     be4:	00005597          	auipc	a1,0x5
     be8:	6b458593          	addi	a1,a1,1716 # 6298 <malloc+0x6a0>
     bec:	30b040ef          	jal	56f6 <write>
  close(fd1);
     bf0:	854a                	mv	a0,s2
     bf2:	30d040ef          	jal	56fe <close>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     bf6:	660d                	lui	a2,0x3
     bf8:	0000d597          	auipc	a1,0xd
     bfc:	0f058593          	addi	a1,a1,240 # dce8 <buf>
     c00:	8526                	mv	a0,s1
     c02:	2ed040ef          	jal	56ee <read>
     c06:	4795                	li	a5,5
     c08:	08f51363          	bne	a0,a5,c8e <unlinkread+0x11a>
  if (buf[0] != 'h') {
     c0c:	0000d717          	auipc	a4,0xd
     c10:	0dc74703          	lbu	a4,220(a4) # dce8 <buf>
     c14:	06800793          	li	a5,104
     c18:	08f71563          	bne	a4,a5,ca2 <unlinkread+0x12e>
  if (write(fd, buf, 10) != 10) {
     c1c:	4629                	li	a2,10
     c1e:	0000d597          	auipc	a1,0xd
     c22:	0ca58593          	addi	a1,a1,202 # dce8 <buf>
     c26:	8526                	mv	a0,s1
     c28:	2cf040ef          	jal	56f6 <write>
     c2c:	47a9                	li	a5,10
     c2e:	08f51463          	bne	a0,a5,cb6 <unlinkread+0x142>
  close(fd);
     c32:	8526                	mv	a0,s1
     c34:	2cb040ef          	jal	56fe <close>
  unlink("unlinkread");
     c38:	00005517          	auipc	a0,0x5
     c3c:	5e850513          	addi	a0,a0,1512 # 6220 <malloc+0x628>
     c40:	2e7040ef          	jal	5726 <unlink>
}
     c44:	70a2                	ld	ra,40(sp)
     c46:	7402                	ld	s0,32(sp)
     c48:	64e2                	ld	s1,24(sp)
     c4a:	6942                	ld	s2,16(sp)
     c4c:	69a2                	ld	s3,8(sp)
     c4e:	6145                	addi	sp,sp,48
     c50:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c52:	85ce                	mv	a1,s3
     c54:	00005517          	auipc	a0,0x5
     c58:	5dc50513          	addi	a0,a0,1500 # 6230 <malloc+0x638>
     c5c:	6e1040ef          	jal	5b3c <printf>
    exit(1);
     c60:	4505                	li	a0,1
     c62:	275040ef          	jal	56d6 <exit>
    printf("%s: open unlinkread failed\n", s);
     c66:	85ce                	mv	a1,s3
     c68:	00005517          	auipc	a0,0x5
     c6c:	5f050513          	addi	a0,a0,1520 # 6258 <malloc+0x660>
     c70:	6cd040ef          	jal	5b3c <printf>
    exit(1);
     c74:	4505                	li	a0,1
     c76:	261040ef          	jal	56d6 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c7a:	85ce                	mv	a1,s3
     c7c:	00005517          	auipc	a0,0x5
     c80:	5fc50513          	addi	a0,a0,1532 # 6278 <malloc+0x680>
     c84:	6b9040ef          	jal	5b3c <printf>
    exit(1);
     c88:	4505                	li	a0,1
     c8a:	24d040ef          	jal	56d6 <exit>
    printf("%s: unlinkread read failed", s);
     c8e:	85ce                	mv	a1,s3
     c90:	00005517          	auipc	a0,0x5
     c94:	61050513          	addi	a0,a0,1552 # 62a0 <malloc+0x6a8>
     c98:	6a5040ef          	jal	5b3c <printf>
    exit(1);
     c9c:	4505                	li	a0,1
     c9e:	239040ef          	jal	56d6 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ca2:	85ce                	mv	a1,s3
     ca4:	00005517          	auipc	a0,0x5
     ca8:	61c50513          	addi	a0,a0,1564 # 62c0 <malloc+0x6c8>
     cac:	691040ef          	jal	5b3c <printf>
    exit(1);
     cb0:	4505                	li	a0,1
     cb2:	225040ef          	jal	56d6 <exit>
    printf("%s: unlinkread write failed\n", s);
     cb6:	85ce                	mv	a1,s3
     cb8:	00005517          	auipc	a0,0x5
     cbc:	62850513          	addi	a0,a0,1576 # 62e0 <malloc+0x6e8>
     cc0:	67d040ef          	jal	5b3c <printf>
    exit(1);
     cc4:	4505                	li	a0,1
     cc6:	211040ef          	jal	56d6 <exit>

0000000000000cca <linktest>:
{
     cca:	1101                	addi	sp,sp,-32
     ccc:	ec06                	sd	ra,24(sp)
     cce:	e822                	sd	s0,16(sp)
     cd0:	e426                	sd	s1,8(sp)
     cd2:	e04a                	sd	s2,0(sp)
     cd4:	1000                	addi	s0,sp,32
     cd6:	892a                	mv	s2,a0
  unlink("lf1");
     cd8:	00005517          	auipc	a0,0x5
     cdc:	62850513          	addi	a0,a0,1576 # 6300 <malloc+0x708>
     ce0:	247040ef          	jal	5726 <unlink>
  unlink("lf2");
     ce4:	00005517          	auipc	a0,0x5
     ce8:	62450513          	addi	a0,a0,1572 # 6308 <malloc+0x710>
     cec:	23b040ef          	jal	5726 <unlink>
  fd = open("lf1", O_CREATE | O_RDWR);
     cf0:	20200593          	li	a1,514
     cf4:	00005517          	auipc	a0,0x5
     cf8:	60c50513          	addi	a0,a0,1548 # 6300 <malloc+0x708>
     cfc:	21b040ef          	jal	5716 <open>
  if (fd < 0) {
     d00:	0c054f63          	bltz	a0,dde <linktest+0x114>
     d04:	84aa                	mv	s1,a0
  if (write(fd, "hello", SZ) != SZ) {
     d06:	4615                	li	a2,5
     d08:	00005597          	auipc	a1,0x5
     d0c:	54858593          	addi	a1,a1,1352 # 6250 <malloc+0x658>
     d10:	1e7040ef          	jal	56f6 <write>
     d14:	4795                	li	a5,5
     d16:	0cf51e63          	bne	a0,a5,df2 <linktest+0x128>
  close(fd);
     d1a:	8526                	mv	a0,s1
     d1c:	1e3040ef          	jal	56fe <close>
  if (link("lf1", "lf2") < 0) {
     d20:	00005597          	auipc	a1,0x5
     d24:	5e858593          	addi	a1,a1,1512 # 6308 <malloc+0x710>
     d28:	00005517          	auipc	a0,0x5
     d2c:	5d850513          	addi	a0,a0,1496 # 6300 <malloc+0x708>
     d30:	207040ef          	jal	5736 <link>
     d34:	0c054963          	bltz	a0,e06 <linktest+0x13c>
  unlink("lf1");
     d38:	00005517          	auipc	a0,0x5
     d3c:	5c850513          	addi	a0,a0,1480 # 6300 <malloc+0x708>
     d40:	1e7040ef          	jal	5726 <unlink>
  if (open("lf1", 0) >= 0) {
     d44:	4581                	li	a1,0
     d46:	00005517          	auipc	a0,0x5
     d4a:	5ba50513          	addi	a0,a0,1466 # 6300 <malloc+0x708>
     d4e:	1c9040ef          	jal	5716 <open>
     d52:	0c055463          	bgez	a0,e1a <linktest+0x150>
  fd = open("lf2", 0);
     d56:	4581                	li	a1,0
     d58:	00005517          	auipc	a0,0x5
     d5c:	5b050513          	addi	a0,a0,1456 # 6308 <malloc+0x710>
     d60:	1b7040ef          	jal	5716 <open>
     d64:	84aa                	mv	s1,a0
  if (fd < 0) {
     d66:	0c054463          	bltz	a0,e2e <linktest+0x164>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     d6a:	660d                	lui	a2,0x3
     d6c:	0000d597          	auipc	a1,0xd
     d70:	f7c58593          	addi	a1,a1,-132 # dce8 <buf>
     d74:	17b040ef          	jal	56ee <read>
     d78:	4795                	li	a5,5
     d7a:	0cf51463          	bne	a0,a5,e42 <linktest+0x178>
  close(fd);
     d7e:	8526                	mv	a0,s1
     d80:	17f040ef          	jal	56fe <close>
  if (link("lf2", "lf2") >= 0) {
     d84:	00005597          	auipc	a1,0x5
     d88:	58458593          	addi	a1,a1,1412 # 6308 <malloc+0x710>
     d8c:	852e                	mv	a0,a1
     d8e:	1a9040ef          	jal	5736 <link>
     d92:	0c055263          	bgez	a0,e56 <linktest+0x18c>
  unlink("lf2");
     d96:	00005517          	auipc	a0,0x5
     d9a:	57250513          	addi	a0,a0,1394 # 6308 <malloc+0x710>
     d9e:	189040ef          	jal	5726 <unlink>
  if (link("lf2", "lf1") >= 0) {
     da2:	00005597          	auipc	a1,0x5
     da6:	55e58593          	addi	a1,a1,1374 # 6300 <malloc+0x708>
     daa:	00005517          	auipc	a0,0x5
     dae:	55e50513          	addi	a0,a0,1374 # 6308 <malloc+0x710>
     db2:	185040ef          	jal	5736 <link>
     db6:	0a055a63          	bgez	a0,e6a <linktest+0x1a0>
  if (link(".", "lf1") >= 0) {
     dba:	00005597          	auipc	a1,0x5
     dbe:	54658593          	addi	a1,a1,1350 # 6300 <malloc+0x708>
     dc2:	00005517          	auipc	a0,0x5
     dc6:	64e50513          	addi	a0,a0,1614 # 6410 <malloc+0x818>
     dca:	16d040ef          	jal	5736 <link>
     dce:	0a055863          	bgez	a0,e7e <linktest+0x1b4>
}
     dd2:	60e2                	ld	ra,24(sp)
     dd4:	6442                	ld	s0,16(sp)
     dd6:	64a2                	ld	s1,8(sp)
     dd8:	6902                	ld	s2,0(sp)
     dda:	6105                	addi	sp,sp,32
     ddc:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     dde:	85ca                	mv	a1,s2
     de0:	00005517          	auipc	a0,0x5
     de4:	53050513          	addi	a0,a0,1328 # 6310 <malloc+0x718>
     de8:	555040ef          	jal	5b3c <printf>
    exit(1);
     dec:	4505                	li	a0,1
     dee:	0e9040ef          	jal	56d6 <exit>
    printf("%s: write lf1 failed\n", s);
     df2:	85ca                	mv	a1,s2
     df4:	00005517          	auipc	a0,0x5
     df8:	53450513          	addi	a0,a0,1332 # 6328 <malloc+0x730>
     dfc:	541040ef          	jal	5b3c <printf>
    exit(1);
     e00:	4505                	li	a0,1
     e02:	0d5040ef          	jal	56d6 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e06:	85ca                	mv	a1,s2
     e08:	00005517          	auipc	a0,0x5
     e0c:	53850513          	addi	a0,a0,1336 # 6340 <malloc+0x748>
     e10:	52d040ef          	jal	5b3c <printf>
    exit(1);
     e14:	4505                	li	a0,1
     e16:	0c1040ef          	jal	56d6 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     e1a:	85ca                	mv	a1,s2
     e1c:	00005517          	auipc	a0,0x5
     e20:	54450513          	addi	a0,a0,1348 # 6360 <malloc+0x768>
     e24:	519040ef          	jal	5b3c <printf>
    exit(1);
     e28:	4505                	li	a0,1
     e2a:	0ad040ef          	jal	56d6 <exit>
    printf("%s: open lf2 failed\n", s);
     e2e:	85ca                	mv	a1,s2
     e30:	00005517          	auipc	a0,0x5
     e34:	56050513          	addi	a0,a0,1376 # 6390 <malloc+0x798>
     e38:	505040ef          	jal	5b3c <printf>
    exit(1);
     e3c:	4505                	li	a0,1
     e3e:	099040ef          	jal	56d6 <exit>
    printf("%s: read lf2 failed\n", s);
     e42:	85ca                	mv	a1,s2
     e44:	00005517          	auipc	a0,0x5
     e48:	56450513          	addi	a0,a0,1380 # 63a8 <malloc+0x7b0>
     e4c:	4f1040ef          	jal	5b3c <printf>
    exit(1);
     e50:	4505                	li	a0,1
     e52:	085040ef          	jal	56d6 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e56:	85ca                	mv	a1,s2
     e58:	00005517          	auipc	a0,0x5
     e5c:	56850513          	addi	a0,a0,1384 # 63c0 <malloc+0x7c8>
     e60:	4dd040ef          	jal	5b3c <printf>
    exit(1);
     e64:	4505                	li	a0,1
     e66:	071040ef          	jal	56d6 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e6a:	85ca                	mv	a1,s2
     e6c:	00005517          	auipc	a0,0x5
     e70:	57c50513          	addi	a0,a0,1404 # 63e8 <malloc+0x7f0>
     e74:	4c9040ef          	jal	5b3c <printf>
    exit(1);
     e78:	4505                	li	a0,1
     e7a:	05d040ef          	jal	56d6 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e7e:	85ca                	mv	a1,s2
     e80:	00005517          	auipc	a0,0x5
     e84:	59850513          	addi	a0,a0,1432 # 6418 <malloc+0x820>
     e88:	4b5040ef          	jal	5b3c <printf>
    exit(1);
     e8c:	4505                	li	a0,1
     e8e:	049040ef          	jal	56d6 <exit>

0000000000000e92 <validatetest>:
{
     e92:	7139                	addi	sp,sp,-64
     e94:	fc06                	sd	ra,56(sp)
     e96:	f822                	sd	s0,48(sp)
     e98:	f426                	sd	s1,40(sp)
     e9a:	f04a                	sd	s2,32(sp)
     e9c:	ec4e                	sd	s3,24(sp)
     e9e:	e852                	sd	s4,16(sp)
     ea0:	e456                	sd	s5,8(sp)
     ea2:	e05a                	sd	s6,0(sp)
     ea4:	0080                	addi	s0,sp,64
     ea6:	8b2a                	mv	s6,a0
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     ea8:	4481                	li	s1,0
    if (link("nosuchfile", (char *)p) != -1) {
     eaa:	00005997          	auipc	s3,0x5
     eae:	58e98993          	addi	s3,s3,1422 # 6438 <malloc+0x840>
     eb2:	597d                	li	s2,-1
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     eb4:	6a85                	lui	s5,0x1
     eb6:	00114a37          	lui	s4,0x114
    if (link("nosuchfile", (char *)p) != -1) {
     eba:	85a6                	mv	a1,s1
     ebc:	854e                	mv	a0,s3
     ebe:	079040ef          	jal	5736 <link>
     ec2:	01251f63          	bne	a0,s2,ee0 <validatetest+0x4e>
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     ec6:	94d6                	add	s1,s1,s5
     ec8:	ff4499e3          	bne	s1,s4,eba <validatetest+0x28>
}
     ecc:	70e2                	ld	ra,56(sp)
     ece:	7442                	ld	s0,48(sp)
     ed0:	74a2                	ld	s1,40(sp)
     ed2:	7902                	ld	s2,32(sp)
     ed4:	69e2                	ld	s3,24(sp)
     ed6:	6a42                	ld	s4,16(sp)
     ed8:	6aa2                	ld	s5,8(sp)
     eda:	6b02                	ld	s6,0(sp)
     edc:	6121                	addi	sp,sp,64
     ede:	8082                	ret
      printf("%s: link should not succeed\n", s);
     ee0:	85da                	mv	a1,s6
     ee2:	00005517          	auipc	a0,0x5
     ee6:	56650513          	addi	a0,a0,1382 # 6448 <malloc+0x850>
     eea:	453040ef          	jal	5b3c <printf>
      exit(1);
     eee:	4505                	li	a0,1
     ef0:	7e6040ef          	jal	56d6 <exit>

0000000000000ef4 <bigdir>:
{
     ef4:	711d                	addi	sp,sp,-96
     ef6:	ec86                	sd	ra,88(sp)
     ef8:	e8a2                	sd	s0,80(sp)
     efa:	e4a6                	sd	s1,72(sp)
     efc:	e0ca                	sd	s2,64(sp)
     efe:	fc4e                	sd	s3,56(sp)
     f00:	f852                	sd	s4,48(sp)
     f02:	f456                	sd	s5,40(sp)
     f04:	f05a                	sd	s6,32(sp)
     f06:	ec5e                	sd	s7,24(sp)
     f08:	1080                	addi	s0,sp,96
     f0a:	8baa                	mv	s7,a0
  unlink("bd");
     f0c:	00005517          	auipc	a0,0x5
     f10:	55c50513          	addi	a0,a0,1372 # 6468 <malloc+0x870>
     f14:	013040ef          	jal	5726 <unlink>
  fd = open("bd", O_CREATE);
     f18:	20000593          	li	a1,512
     f1c:	00005517          	auipc	a0,0x5
     f20:	54c50513          	addi	a0,a0,1356 # 6468 <malloc+0x870>
     f24:	7f2040ef          	jal	5716 <open>
  if (fd < 0) {
     f28:	0c054463          	bltz	a0,ff0 <bigdir+0xfc>
  close(fd);
     f2c:	7d2040ef          	jal	56fe <close>
  for (i = 0; i < N; i++) {
     f30:	4901                	li	s2,0
    name[0] = 'x';
     f32:	07800a93          	li	s5,120
    if (link("bd", name) != 0) {
     f36:	fa040a13          	addi	s4,s0,-96
     f3a:	00005997          	auipc	s3,0x5
     f3e:	52e98993          	addi	s3,s3,1326 # 6468 <malloc+0x870>
  for (i = 0; i < N; i++) {
     f42:	1f400b13          	li	s6,500
    name[0] = 'x';
     f46:	fb540023          	sb	s5,-96(s0)
    name[1] = '0' + (i / 64);
     f4a:	41f9571b          	sraiw	a4,s2,0x1f
     f4e:	01a7571b          	srliw	a4,a4,0x1a
     f52:	012707bb          	addw	a5,a4,s2
     f56:	4067d69b          	sraiw	a3,a5,0x6
     f5a:	0306869b          	addiw	a3,a3,48
     f5e:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     f62:	03f7f793          	andi	a5,a5,63
     f66:	9f99                	subw	a5,a5,a4
     f68:	0307879b          	addiw	a5,a5,48
     f6c:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     f70:	fa0401a3          	sb	zero,-93(s0)
    if (link("bd", name) != 0) {
     f74:	85d2                	mv	a1,s4
     f76:	854e                	mv	a0,s3
     f78:	7be040ef          	jal	5736 <link>
     f7c:	84aa                	mv	s1,a0
     f7e:	e159                	bnez	a0,1004 <bigdir+0x110>
  for (i = 0; i < N; i++) {
     f80:	2905                	addiw	s2,s2,1
     f82:	fd6912e3          	bne	s2,s6,f46 <bigdir+0x52>
  unlink("bd");
     f86:	00005517          	auipc	a0,0x5
     f8a:	4e250513          	addi	a0,a0,1250 # 6468 <malloc+0x870>
     f8e:	798040ef          	jal	5726 <unlink>
    name[0] = 'x';
     f92:	07800993          	li	s3,120
    if (unlink(name) != 0) {
     f96:	fa040913          	addi	s2,s0,-96
  for (i = 0; i < N; i++) {
     f9a:	1f400a13          	li	s4,500
    name[0] = 'x';
     f9e:	fb340023          	sb	s3,-96(s0)
    name[1] = '0' + (i / 64);
     fa2:	41f4d71b          	sraiw	a4,s1,0x1f
     fa6:	01a7571b          	srliw	a4,a4,0x1a
     faa:	009707bb          	addw	a5,a4,s1
     fae:	4067d69b          	sraiw	a3,a5,0x6
     fb2:	0306869b          	addiw	a3,a3,48
     fb6:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     fba:	03f7f793          	andi	a5,a5,63
     fbe:	9f99                	subw	a5,a5,a4
     fc0:	0307879b          	addiw	a5,a5,48
     fc4:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     fc8:	fa0401a3          	sb	zero,-93(s0)
    if (unlink(name) != 0) {
     fcc:	854a                	mv	a0,s2
     fce:	758040ef          	jal	5726 <unlink>
     fd2:	e531                	bnez	a0,101e <bigdir+0x12a>
  for (i = 0; i < N; i++) {
     fd4:	2485                	addiw	s1,s1,1
     fd6:	fd4494e3          	bne	s1,s4,f9e <bigdir+0xaa>
}
     fda:	60e6                	ld	ra,88(sp)
     fdc:	6446                	ld	s0,80(sp)
     fde:	64a6                	ld	s1,72(sp)
     fe0:	6906                	ld	s2,64(sp)
     fe2:	79e2                	ld	s3,56(sp)
     fe4:	7a42                	ld	s4,48(sp)
     fe6:	7aa2                	ld	s5,40(sp)
     fe8:	7b02                	ld	s6,32(sp)
     fea:	6be2                	ld	s7,24(sp)
     fec:	6125                	addi	sp,sp,96
     fee:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     ff0:	85de                	mv	a1,s7
     ff2:	00005517          	auipc	a0,0x5
     ff6:	47e50513          	addi	a0,a0,1150 # 6470 <malloc+0x878>
     ffa:	343040ef          	jal	5b3c <printf>
    exit(1);
     ffe:	4505                	li	a0,1
    1000:	6d6040ef          	jal	56d6 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
    1004:	fa040693          	addi	a3,s0,-96
    1008:	864a                	mv	a2,s2
    100a:	85de                	mv	a1,s7
    100c:	00005517          	auipc	a0,0x5
    1010:	48450513          	addi	a0,a0,1156 # 6490 <malloc+0x898>
    1014:	329040ef          	jal	5b3c <printf>
      exit(1);
    1018:	4505                	li	a0,1
    101a:	6bc040ef          	jal	56d6 <exit>
      printf("%s: bigdir unlink failed", s);
    101e:	85de                	mv	a1,s7
    1020:	00005517          	auipc	a0,0x5
    1024:	49850513          	addi	a0,a0,1176 # 64b8 <malloc+0x8c0>
    1028:	315040ef          	jal	5b3c <printf>
      exit(1);
    102c:	4505                	li	a0,1
    102e:	6a8040ef          	jal	56d6 <exit>

0000000000001032 <pgbug>:
{
    1032:	7179                	addi	sp,sp,-48
    1034:	f406                	sd	ra,40(sp)
    1036:	f022                	sd	s0,32(sp)
    1038:	ec26                	sd	s1,24(sp)
    103a:	1800                	addi	s0,sp,48
  argv[0] = 0;
    103c:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1040:	00009497          	auipc	s1,0x9
    1044:	fc048493          	addi	s1,s1,-64 # a000 <big>
    1048:	fd840593          	addi	a1,s0,-40
    104c:	6088                	ld	a0,0(s1)
    104e:	6c0040ef          	jal	570e <exec>
  pipe(big);
    1052:	6088                	ld	a0,0(s1)
    1054:	692040ef          	jal	56e6 <pipe>
  exit(0);
    1058:	4501                	li	a0,0
    105a:	67c040ef          	jal	56d6 <exit>

000000000000105e <badarg>:
{
    105e:	7139                	addi	sp,sp,-64
    1060:	fc06                	sd	ra,56(sp)
    1062:	f822                	sd	s0,48(sp)
    1064:	f426                	sd	s1,40(sp)
    1066:	f04a                	sd	s2,32(sp)
    1068:	ec4e                	sd	s3,24(sp)
    106a:	e852                	sd	s4,16(sp)
    106c:	0080                	addi	s0,sp,64
    106e:	64b1                	lui	s1,0xc
    1070:	35048493          	addi	s1,s1,848 # c350 <uninit+0xd78>
    argv[0] = (char *)0xffffffff;
    1074:	597d                	li	s2,-1
    1076:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    107a:	fc040a13          	addi	s4,s0,-64
    107e:	00005997          	auipc	s3,0x5
    1082:	caa98993          	addi	s3,s3,-854 # 5d28 <malloc+0x130>
    argv[0] = (char *)0xffffffff;
    1086:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    108a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    108e:	85d2                	mv	a1,s4
    1090:	854e                	mv	a0,s3
    1092:	67c040ef          	jal	570e <exec>
  for (int i = 0; i < 50000; i++) {
    1096:	34fd                	addiw	s1,s1,-1
    1098:	f4fd                	bnez	s1,1086 <badarg+0x28>
  exit(0);
    109a:	4501                	li	a0,0
    109c:	63a040ef          	jal	56d6 <exit>

00000000000010a0 <copyinstr2>:
{
    10a0:	7155                	addi	sp,sp,-208
    10a2:	e586                	sd	ra,200(sp)
    10a4:	e1a2                	sd	s0,192(sp)
    10a6:	0980                	addi	s0,sp,208
  for (int i = 0; i < MAXPATH; i++)
    10a8:	f6840793          	addi	a5,s0,-152
    10ac:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    10b0:	07800713          	li	a4,120
    10b4:	00e78023          	sb	a4,0(a5)
  for (int i = 0; i < MAXPATH; i++)
    10b8:	0785                	addi	a5,a5,1
    10ba:	fed79de3          	bne	a5,a3,10b4 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    10be:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    10c2:	f6840513          	addi	a0,s0,-152
    10c6:	660040ef          	jal	5726 <unlink>
  if (ret != -1) {
    10ca:	57fd                	li	a5,-1
    10cc:	0cf51263          	bne	a0,a5,1190 <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    10d0:	20100593          	li	a1,513
    10d4:	f6840513          	addi	a0,s0,-152
    10d8:	63e040ef          	jal	5716 <open>
  if (fd != -1) {
    10dc:	57fd                	li	a5,-1
    10de:	0cf51563          	bne	a0,a5,11a8 <copyinstr2+0x108>
  ret = link(b, b);
    10e2:	f6840513          	addi	a0,s0,-152
    10e6:	85aa                	mv	a1,a0
    10e8:	64e040ef          	jal	5736 <link>
  if (ret != -1) {
    10ec:	57fd                	li	a5,-1
    10ee:	0cf51963          	bne	a0,a5,11c0 <copyinstr2+0x120>
  char *args[] = {"xx", 0};
    10f2:	00006797          	auipc	a5,0x6
    10f6:	4ae78793          	addi	a5,a5,1198 # 75a0 <malloc+0x19a8>
    10fa:	f4f43c23          	sd	a5,-168(s0)
    10fe:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1102:	f5840593          	addi	a1,s0,-168
    1106:	f6840513          	addi	a0,s0,-152
    110a:	604040ef          	jal	570e <exec>
  if (ret != -1) {
    110e:	57fd                	li	a5,-1
    1110:	0cf51563          	bne	a0,a5,11da <copyinstr2+0x13a>
  int pid = fork();
    1114:	5ba040ef          	jal	56ce <fork>
  if (pid < 0) {
    1118:	0c054d63          	bltz	a0,11f2 <copyinstr2+0x152>
  if (pid == 0) {
    111c:	0e051863          	bnez	a0,120c <copyinstr2+0x16c>
    1120:	00009797          	auipc	a5,0x9
    1124:	4b078793          	addi	a5,a5,1200 # a5d0 <big.0>
    1128:	0000a697          	auipc	a3,0xa
    112c:	4a868693          	addi	a3,a3,1192 # b5d0 <big.0+0x1000>
      big[i] = 'x';
    1130:	07800713          	li	a4,120
    1134:	00e78023          	sb	a4,0(a5)
    for (int i = 0; i < PGSIZE; i++)
    1138:	0785                	addi	a5,a5,1
    113a:	fed79de3          	bne	a5,a3,1134 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    113e:	0000a797          	auipc	a5,0xa
    1142:	48078923          	sb	zero,1170(a5) # b5d0 <big.0+0x1000>
    char *args2[] = {big, big, big, 0};
    1146:	00007797          	auipc	a5,0x7
    114a:	49a78793          	addi	a5,a5,1178 # 85e0 <malloc+0x29e8>
    114e:	6fb0                	ld	a2,88(a5)
    1150:	73b4                	ld	a3,96(a5)
    1152:	77b8                	ld	a4,104(a5)
    1154:	f2c43823          	sd	a2,-208(s0)
    1158:	f2d43c23          	sd	a3,-200(s0)
    115c:	f4e43023          	sd	a4,-192(s0)
    1160:	7bbc                	ld	a5,112(a5)
    1162:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1166:	f3040593          	addi	a1,s0,-208
    116a:	00005517          	auipc	a0,0x5
    116e:	bbe50513          	addi	a0,a0,-1090 # 5d28 <malloc+0x130>
    1172:	59c040ef          	jal	570e <exec>
    if (ret != -1) {
    1176:	57fd                	li	a5,-1
    1178:	08f50663          	beq	a0,a5,1204 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    117c:	85be                	mv	a1,a5
    117e:	00005517          	auipc	a0,0x5
    1182:	3e250513          	addi	a0,a0,994 # 6560 <malloc+0x968>
    1186:	1b7040ef          	jal	5b3c <printf>
      exit(1);
    118a:	4505                	li	a0,1
    118c:	54a040ef          	jal	56d6 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1190:	862a                	mv	a2,a0
    1192:	f6840593          	addi	a1,s0,-152
    1196:	00005517          	auipc	a0,0x5
    119a:	34250513          	addi	a0,a0,834 # 64d8 <malloc+0x8e0>
    119e:	19f040ef          	jal	5b3c <printf>
    exit(1);
    11a2:	4505                	li	a0,1
    11a4:	532040ef          	jal	56d6 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    11a8:	862a                	mv	a2,a0
    11aa:	f6840593          	addi	a1,s0,-152
    11ae:	00005517          	auipc	a0,0x5
    11b2:	34a50513          	addi	a0,a0,842 # 64f8 <malloc+0x900>
    11b6:	187040ef          	jal	5b3c <printf>
    exit(1);
    11ba:	4505                	li	a0,1
    11bc:	51a040ef          	jal	56d6 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    11c0:	f6840593          	addi	a1,s0,-152
    11c4:	86aa                	mv	a3,a0
    11c6:	862e                	mv	a2,a1
    11c8:	00005517          	auipc	a0,0x5
    11cc:	35050513          	addi	a0,a0,848 # 6518 <malloc+0x920>
    11d0:	16d040ef          	jal	5b3c <printf>
    exit(1);
    11d4:	4505                	li	a0,1
    11d6:	500040ef          	jal	56d6 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    11da:	863e                	mv	a2,a5
    11dc:	f6840593          	addi	a1,s0,-152
    11e0:	00005517          	auipc	a0,0x5
    11e4:	36050513          	addi	a0,a0,864 # 6540 <malloc+0x948>
    11e8:	155040ef          	jal	5b3c <printf>
    exit(1);
    11ec:	4505                	li	a0,1
    11ee:	4e8040ef          	jal	56d6 <exit>
    printf("fork failed\n");
    11f2:	00007517          	auipc	a0,0x7
    11f6:	a8650513          	addi	a0,a0,-1402 # 7c78 <malloc+0x2080>
    11fa:	143040ef          	jal	5b3c <printf>
    exit(1);
    11fe:	4505                	li	a0,1
    1200:	4d6040ef          	jal	56d6 <exit>
    exit(747); // OK
    1204:	2eb00513          	li	a0,747
    1208:	4ce040ef          	jal	56d6 <exit>
  int st = 0;
    120c:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1210:	f5440513          	addi	a0,s0,-172
    1214:	4ca040ef          	jal	56de <wait>
  if (st != 747) {
    1218:	f5442703          	lw	a4,-172(s0)
    121c:	2eb00793          	li	a5,747
    1220:	00f71663          	bne	a4,a5,122c <copyinstr2+0x18c>
}
    1224:	60ae                	ld	ra,200(sp)
    1226:	640e                	ld	s0,192(sp)
    1228:	6169                	addi	sp,sp,208
    122a:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    122c:	00005517          	auipc	a0,0x5
    1230:	35c50513          	addi	a0,a0,860 # 6588 <malloc+0x990>
    1234:	109040ef          	jal	5b3c <printf>
    exit(1);
    1238:	4505                	li	a0,1
    123a:	49c040ef          	jal	56d6 <exit>

000000000000123e <truncate3>:
{
    123e:	7175                	addi	sp,sp,-144
    1240:	e506                	sd	ra,136(sp)
    1242:	e122                	sd	s0,128(sp)
    1244:	fc66                	sd	s9,56(sp)
    1246:	0900                	addi	s0,sp,144
    1248:	8caa                	mv	s9,a0
  close(open("truncfile", O_CREATE | O_TRUNC | O_WRONLY));
    124a:	60100593          	li	a1,1537
    124e:	00005517          	auipc	a0,0x5
    1252:	b3250513          	addi	a0,a0,-1230 # 5d80 <malloc+0x188>
    1256:	4c0040ef          	jal	5716 <open>
    125a:	4a4040ef          	jal	56fe <close>
  pid = fork();
    125e:	470040ef          	jal	56ce <fork>
  if (pid < 0) {
    1262:	06054d63          	bltz	a0,12dc <truncate3+0x9e>
  if (pid == 0) {
    1266:	e171                	bnez	a0,132a <truncate3+0xec>
    1268:	fca6                	sd	s1,120(sp)
    126a:	f8ca                	sd	s2,112(sp)
    126c:	f4ce                	sd	s3,104(sp)
    126e:	f0d2                	sd	s4,96(sp)
    1270:	ecd6                	sd	s5,88(sp)
    1272:	e8da                	sd	s6,80(sp)
    1274:	e4de                	sd	s7,72(sp)
    1276:	e0e2                	sd	s8,64(sp)
    1278:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
    127c:	4a85                	li	s5,1
    127e:	00005997          	auipc	s3,0x5
    1282:	b0298993          	addi	s3,s3,-1278 # 5d80 <malloc+0x188>
      int n = write(fd, "1234567890", 10);
    1286:	4a29                	li	s4,10
    1288:	00005b17          	auipc	s6,0x5
    128c:	360b0b13          	addi	s6,s6,864 # 65e8 <malloc+0x9f0>
      read(fd, buf, sizeof(buf));
    1290:	f7840c13          	addi	s8,s0,-136
    1294:	02000b93          	li	s7,32
      int fd = open("truncfile", O_WRONLY);
    1298:	85d6                	mv	a1,s5
    129a:	854e                	mv	a0,s3
    129c:	47a040ef          	jal	5716 <open>
    12a0:	84aa                	mv	s1,a0
      if (fd < 0) {
    12a2:	04054f63          	bltz	a0,1300 <truncate3+0xc2>
      int n = write(fd, "1234567890", 10);
    12a6:	8652                	mv	a2,s4
    12a8:	85da                	mv	a1,s6
    12aa:	44c040ef          	jal	56f6 <write>
      if (n != 10) {
    12ae:	07451363          	bne	a0,s4,1314 <truncate3+0xd6>
      close(fd);
    12b2:	8526                	mv	a0,s1
    12b4:	44a040ef          	jal	56fe <close>
      fd = open("truncfile", O_RDONLY);
    12b8:	4581                	li	a1,0
    12ba:	854e                	mv	a0,s3
    12bc:	45a040ef          	jal	5716 <open>
    12c0:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    12c2:	865e                	mv	a2,s7
    12c4:	85e2                	mv	a1,s8
    12c6:	428040ef          	jal	56ee <read>
      close(fd);
    12ca:	8526                	mv	a0,s1
    12cc:	432040ef          	jal	56fe <close>
    for (int i = 0; i < 100; i++) {
    12d0:	397d                	addiw	s2,s2,-1
    12d2:	fc0913e3          	bnez	s2,1298 <truncate3+0x5a>
    exit(0);
    12d6:	4501                	li	a0,0
    12d8:	3fe040ef          	jal	56d6 <exit>
    12dc:	fca6                	sd	s1,120(sp)
    12de:	f8ca                	sd	s2,112(sp)
    12e0:	f4ce                	sd	s3,104(sp)
    12e2:	f0d2                	sd	s4,96(sp)
    12e4:	ecd6                	sd	s5,88(sp)
    12e6:	e8da                	sd	s6,80(sp)
    12e8:	e4de                	sd	s7,72(sp)
    12ea:	e0e2                	sd	s8,64(sp)
    printf("%s: fork failed\n", s);
    12ec:	85e6                	mv	a1,s9
    12ee:	00005517          	auipc	a0,0x5
    12f2:	2ca50513          	addi	a0,a0,714 # 65b8 <malloc+0x9c0>
    12f6:	047040ef          	jal	5b3c <printf>
    exit(1);
    12fa:	4505                	li	a0,1
    12fc:	3da040ef          	jal	56d6 <exit>
        printf("%s: open failed\n", s);
    1300:	85e6                	mv	a1,s9
    1302:	00005517          	auipc	a0,0x5
    1306:	2ce50513          	addi	a0,a0,718 # 65d0 <malloc+0x9d8>
    130a:	033040ef          	jal	5b3c <printf>
        exit(1);
    130e:	4505                	li	a0,1
    1310:	3c6040ef          	jal	56d6 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1314:	862a                	mv	a2,a0
    1316:	85e6                	mv	a1,s9
    1318:	00005517          	auipc	a0,0x5
    131c:	2e050513          	addi	a0,a0,736 # 65f8 <malloc+0xa00>
    1320:	01d040ef          	jal	5b3c <printf>
        exit(1);
    1324:	4505                	li	a0,1
    1326:	3b0040ef          	jal	56d6 <exit>
    132a:	fca6                	sd	s1,120(sp)
    132c:	f8ca                	sd	s2,112(sp)
    132e:	f4ce                	sd	s3,104(sp)
    1330:	f0d2                	sd	s4,96(sp)
    1332:	ecd6                	sd	s5,88(sp)
    1334:	e8da                	sd	s6,80(sp)
  if (pid == 0) {
    1336:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    133a:	60100a93          	li	s5,1537
    133e:	00005a17          	auipc	s4,0x5
    1342:	a42a0a13          	addi	s4,s4,-1470 # 5d80 <malloc+0x188>
    int n = write(fd, "xxx", 3);
    1346:	498d                	li	s3,3
    1348:	00005b17          	auipc	s6,0x5
    134c:	2d0b0b13          	addi	s6,s6,720 # 6618 <malloc+0xa20>
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    1350:	85d6                	mv	a1,s5
    1352:	8552                	mv	a0,s4
    1354:	3c2040ef          	jal	5716 <open>
    1358:	84aa                	mv	s1,a0
    if (fd < 0) {
    135a:	02054e63          	bltz	a0,1396 <truncate3+0x158>
    int n = write(fd, "xxx", 3);
    135e:	864e                	mv	a2,s3
    1360:	85da                	mv	a1,s6
    1362:	394040ef          	jal	56f6 <write>
    if (n != 3) {
    1366:	05351463          	bne	a0,s3,13ae <truncate3+0x170>
    close(fd);
    136a:	8526                	mv	a0,s1
    136c:	392040ef          	jal	56fe <close>
  for (int i = 0; i < 150; i++) {
    1370:	397d                	addiw	s2,s2,-1
    1372:	fc091fe3          	bnez	s2,1350 <truncate3+0x112>
    1376:	e4de                	sd	s7,72(sp)
    1378:	e0e2                	sd	s8,64(sp)
  wait(&xstatus);
    137a:	f9c40513          	addi	a0,s0,-100
    137e:	360040ef          	jal	56de <wait>
  unlink("truncfile");
    1382:	00005517          	auipc	a0,0x5
    1386:	9fe50513          	addi	a0,a0,-1538 # 5d80 <malloc+0x188>
    138a:	39c040ef          	jal	5726 <unlink>
  exit(xstatus);
    138e:	f9c42503          	lw	a0,-100(s0)
    1392:	344040ef          	jal	56d6 <exit>
    1396:	e4de                	sd	s7,72(sp)
    1398:	e0e2                	sd	s8,64(sp)
      printf("%s: open failed\n", s);
    139a:	85e6                	mv	a1,s9
    139c:	00005517          	auipc	a0,0x5
    13a0:	23450513          	addi	a0,a0,564 # 65d0 <malloc+0x9d8>
    13a4:	798040ef          	jal	5b3c <printf>
      exit(1);
    13a8:	4505                	li	a0,1
    13aa:	32c040ef          	jal	56d6 <exit>
    13ae:	e4de                	sd	s7,72(sp)
    13b0:	e0e2                	sd	s8,64(sp)
      printf("%s: write got %d, expected 3\n", s, n);
    13b2:	862a                	mv	a2,a0
    13b4:	85e6                	mv	a1,s9
    13b6:	00005517          	auipc	a0,0x5
    13ba:	26a50513          	addi	a0,a0,618 # 6620 <malloc+0xa28>
    13be:	77e040ef          	jal	5b3c <printf>
      exit(1);
    13c2:	4505                	li	a0,1
    13c4:	312040ef          	jal	56d6 <exit>

00000000000013c8 <pipe1>:
{
    13c8:	711d                	addi	sp,sp,-96
    13ca:	ec86                	sd	ra,88(sp)
    13cc:	e8a2                	sd	s0,80(sp)
    13ce:	e862                	sd	s8,16(sp)
    13d0:	1080                	addi	s0,sp,96
    13d2:	8c2a                	mv	s8,a0
  if (pipe(fds) != 0) {
    13d4:	fa840513          	addi	a0,s0,-88
    13d8:	30e040ef          	jal	56e6 <pipe>
    13dc:	e925                	bnez	a0,144c <pipe1+0x84>
    13de:	e4a6                	sd	s1,72(sp)
    13e0:	fc4e                	sd	s3,56(sp)
    13e2:	84aa                	mv	s1,a0
  pid = fork();
    13e4:	2ea040ef          	jal	56ce <fork>
    13e8:	89aa                	mv	s3,a0
  if (pid == 0) {
    13ea:	c151                	beqz	a0,146e <pipe1+0xa6>
  } else if (pid > 0) {
    13ec:	16a05063          	blez	a0,154c <pipe1+0x184>
    13f0:	e0ca                	sd	s2,64(sp)
    13f2:	f852                	sd	s4,48(sp)
    close(fds[1]);
    13f4:	fac42503          	lw	a0,-84(s0)
    13f8:	306040ef          	jal	56fe <close>
    total = 0;
    13fc:	89a6                	mv	s3,s1
    cc = 1;
    13fe:	4905                	li	s2,1
    while ((n = read(fds[0], buf, cc)) > 0) {
    1400:	0000da17          	auipc	s4,0xd
    1404:	8e8a0a13          	addi	s4,s4,-1816 # dce8 <buf>
    1408:	864a                	mv	a2,s2
    140a:	85d2                	mv	a1,s4
    140c:	fa842503          	lw	a0,-88(s0)
    1410:	2de040ef          	jal	56ee <read>
    1414:	85aa                	mv	a1,a0
    1416:	0ea05963          	blez	a0,1508 <pipe1+0x140>
    141a:	0000d797          	auipc	a5,0xd
    141e:	8ce78793          	addi	a5,a5,-1842 # dce8 <buf>
    1422:	00b4863b          	addw	a2,s1,a1
        if ((buf[i] & 0xff) != (seq++ & 0xff)) {
    1426:	0007c683          	lbu	a3,0(a5)
    142a:	0ff4f713          	zext.b	a4,s1
    142e:	0ae69d63          	bne	a3,a4,14e8 <pipe1+0x120>
    1432:	2485                	addiw	s1,s1,1
      for (i = 0; i < n; i++) {
    1434:	0785                	addi	a5,a5,1
    1436:	fec498e3          	bne	s1,a2,1426 <pipe1+0x5e>
      total += n;
    143a:	00b989bb          	addw	s3,s3,a1
      cc = cc * 2;
    143e:	0019191b          	slliw	s2,s2,0x1
      if (cc > sizeof(buf))
    1442:	678d                	lui	a5,0x3
    1444:	fd27f2e3          	bgeu	a5,s2,1408 <pipe1+0x40>
        cc = sizeof(buf);
    1448:	893e                	mv	s2,a5
    144a:	bf7d                	j	1408 <pipe1+0x40>
    144c:	e4a6                	sd	s1,72(sp)
    144e:	e0ca                	sd	s2,64(sp)
    1450:	fc4e                	sd	s3,56(sp)
    1452:	f852                	sd	s4,48(sp)
    1454:	f456                	sd	s5,40(sp)
    1456:	f05a                	sd	s6,32(sp)
    1458:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    145a:	85e2                	mv	a1,s8
    145c:	00005517          	auipc	a0,0x5
    1460:	1e450513          	addi	a0,a0,484 # 6640 <malloc+0xa48>
    1464:	6d8040ef          	jal	5b3c <printf>
    exit(1);
    1468:	4505                	li	a0,1
    146a:	26c040ef          	jal	56d6 <exit>
    146e:	e0ca                	sd	s2,64(sp)
    1470:	f852                	sd	s4,48(sp)
    1472:	f456                	sd	s5,40(sp)
    1474:	f05a                	sd	s6,32(sp)
    1476:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1478:	fa842503          	lw	a0,-88(s0)
    147c:	282040ef          	jal	56fe <close>
    for (n = 0; n < N; n++) {
    1480:	0000db17          	auipc	s6,0xd
    1484:	868b0b13          	addi	s6,s6,-1944 # dce8 <buf>
    1488:	416004bb          	negw	s1,s6
    148c:	0ff4f493          	zext.b	s1,s1
    1490:	409b0913          	addi	s2,s6,1033
      if (write(fds[1], buf, SZ) != SZ) {
    1494:	40900a13          	li	s4,1033
    1498:	8bda                	mv	s7,s6
    for (n = 0; n < N; n++) {
    149a:	6a85                	lui	s5,0x1
    149c:	42da8a93          	addi	s5,s5,1069 # 142d <pipe1+0x65>
{
    14a0:	87da                	mv	a5,s6
        buf[i] = seq++;
    14a2:	0097873b          	addw	a4,a5,s1
    14a6:	00e78023          	sb	a4,0(a5) # 3000 <subdir+0x47a>
      for (i = 0; i < SZ; i++)
    14aa:	0785                	addi	a5,a5,1
    14ac:	ff279be3          	bne	a5,s2,14a2 <pipe1+0xda>
      if (write(fds[1], buf, SZ) != SZ) {
    14b0:	8652                	mv	a2,s4
    14b2:	85de                	mv	a1,s7
    14b4:	fac42503          	lw	a0,-84(s0)
    14b8:	23e040ef          	jal	56f6 <write>
    14bc:	01451c63          	bne	a0,s4,14d4 <pipe1+0x10c>
    14c0:	4099899b          	addiw	s3,s3,1033
    for (n = 0; n < N; n++) {
    14c4:	24a5                	addiw	s1,s1,9
    14c6:	0ff4f493          	zext.b	s1,s1
    14ca:	fd599be3          	bne	s3,s5,14a0 <pipe1+0xd8>
    exit(0);
    14ce:	4501                	li	a0,0
    14d0:	206040ef          	jal	56d6 <exit>
        printf("%s: pipe1 oops 1\n", s);
    14d4:	85e2                	mv	a1,s8
    14d6:	00005517          	auipc	a0,0x5
    14da:	18250513          	addi	a0,a0,386 # 6658 <malloc+0xa60>
    14de:	65e040ef          	jal	5b3c <printf>
        exit(1);
    14e2:	4505                	li	a0,1
    14e4:	1f2040ef          	jal	56d6 <exit>
          printf("%s: pipe1 oops 2\n", s);
    14e8:	85e2                	mv	a1,s8
    14ea:	00005517          	auipc	a0,0x5
    14ee:	18650513          	addi	a0,a0,390 # 6670 <malloc+0xa78>
    14f2:	64a040ef          	jal	5b3c <printf>
          return;
    14f6:	64a6                	ld	s1,72(sp)
    14f8:	6906                	ld	s2,64(sp)
    14fa:	79e2                	ld	s3,56(sp)
    14fc:	7a42                	ld	s4,48(sp)
}
    14fe:	60e6                	ld	ra,88(sp)
    1500:	6446                	ld	s0,80(sp)
    1502:	6c42                	ld	s8,16(sp)
    1504:	6125                	addi	sp,sp,96
    1506:	8082                	ret
    if (total != N * SZ) {
    1508:	6785                	lui	a5,0x1
    150a:	42d78793          	addi	a5,a5,1069 # 142d <pipe1+0x65>
    150e:	02f98063          	beq	s3,a5,152e <pipe1+0x166>
    1512:	f456                	sd	s5,40(sp)
    1514:	f05a                	sd	s6,32(sp)
    1516:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    1518:	864e                	mv	a2,s3
    151a:	85e2                	mv	a1,s8
    151c:	00005517          	auipc	a0,0x5
    1520:	16c50513          	addi	a0,a0,364 # 6688 <malloc+0xa90>
    1524:	618040ef          	jal	5b3c <printf>
      exit(1);
    1528:	4505                	li	a0,1
    152a:	1ac040ef          	jal	56d6 <exit>
    152e:	f456                	sd	s5,40(sp)
    1530:	f05a                	sd	s6,32(sp)
    1532:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1534:	fa842503          	lw	a0,-88(s0)
    1538:	1c6040ef          	jal	56fe <close>
    wait(&xstatus);
    153c:	fa440513          	addi	a0,s0,-92
    1540:	19e040ef          	jal	56de <wait>
    exit(xstatus);
    1544:	fa442503          	lw	a0,-92(s0)
    1548:	18e040ef          	jal	56d6 <exit>
    154c:	e0ca                	sd	s2,64(sp)
    154e:	f852                	sd	s4,48(sp)
    1550:	f456                	sd	s5,40(sp)
    1552:	f05a                	sd	s6,32(sp)
    1554:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    1556:	85e2                	mv	a1,s8
    1558:	00005517          	auipc	a0,0x5
    155c:	15050513          	addi	a0,a0,336 # 66a8 <malloc+0xab0>
    1560:	5dc040ef          	jal	5b3c <printf>
    exit(1);
    1564:	4505                	li	a0,1
    1566:	170040ef          	jal	56d6 <exit>

000000000000156a <exitwait>:
{
    156a:	715d                	addi	sp,sp,-80
    156c:	e486                	sd	ra,72(sp)
    156e:	e0a2                	sd	s0,64(sp)
    1570:	fc26                	sd	s1,56(sp)
    1572:	f84a                	sd	s2,48(sp)
    1574:	f44e                	sd	s3,40(sp)
    1576:	f052                	sd	s4,32(sp)
    1578:	ec56                	sd	s5,24(sp)
    157a:	0880                	addi	s0,sp,80
    157c:	8aaa                	mv	s5,a0
  for (i = 0; i < 100; i++) {
    157e:	4901                	li	s2,0
      if (wait(&xstate) != pid) {
    1580:	fbc40993          	addi	s3,s0,-68
  for (i = 0; i < 100; i++) {
    1584:	06400a13          	li	s4,100
    pid = fork();
    1588:	146040ef          	jal	56ce <fork>
    158c:	84aa                	mv	s1,a0
    if (pid < 0) {
    158e:	02054863          	bltz	a0,15be <exitwait+0x54>
    if (pid) {
    1592:	c525                	beqz	a0,15fa <exitwait+0x90>
      if (wait(&xstate) != pid) {
    1594:	854e                	mv	a0,s3
    1596:	148040ef          	jal	56de <wait>
    159a:	02951c63          	bne	a0,s1,15d2 <exitwait+0x68>
      if (i != xstate) {
    159e:	fbc42783          	lw	a5,-68(s0)
    15a2:	05279263          	bne	a5,s2,15e6 <exitwait+0x7c>
  for (i = 0; i < 100; i++) {
    15a6:	2905                	addiw	s2,s2,1
    15a8:	ff4910e3          	bne	s2,s4,1588 <exitwait+0x1e>
}
    15ac:	60a6                	ld	ra,72(sp)
    15ae:	6406                	ld	s0,64(sp)
    15b0:	74e2                	ld	s1,56(sp)
    15b2:	7942                	ld	s2,48(sp)
    15b4:	79a2                	ld	s3,40(sp)
    15b6:	7a02                	ld	s4,32(sp)
    15b8:	6ae2                	ld	s5,24(sp)
    15ba:	6161                	addi	sp,sp,80
    15bc:	8082                	ret
      printf("%s: fork failed\n", s);
    15be:	85d6                	mv	a1,s5
    15c0:	00005517          	auipc	a0,0x5
    15c4:	ff850513          	addi	a0,a0,-8 # 65b8 <malloc+0x9c0>
    15c8:	574040ef          	jal	5b3c <printf>
      exit(1);
    15cc:	4505                	li	a0,1
    15ce:	108040ef          	jal	56d6 <exit>
        printf("%s: wait wrong pid\n", s);
    15d2:	85d6                	mv	a1,s5
    15d4:	00005517          	auipc	a0,0x5
    15d8:	0ec50513          	addi	a0,a0,236 # 66c0 <malloc+0xac8>
    15dc:	560040ef          	jal	5b3c <printf>
        exit(1);
    15e0:	4505                	li	a0,1
    15e2:	0f4040ef          	jal	56d6 <exit>
        printf("%s: wait wrong exit status\n", s);
    15e6:	85d6                	mv	a1,s5
    15e8:	00005517          	auipc	a0,0x5
    15ec:	0f050513          	addi	a0,a0,240 # 66d8 <malloc+0xae0>
    15f0:	54c040ef          	jal	5b3c <printf>
        exit(1);
    15f4:	4505                	li	a0,1
    15f6:	0e0040ef          	jal	56d6 <exit>
      exit(i);
    15fa:	854a                	mv	a0,s2
    15fc:	0da040ef          	jal	56d6 <exit>

0000000000001600 <twochildren>:
{
    1600:	1101                	addi	sp,sp,-32
    1602:	ec06                	sd	ra,24(sp)
    1604:	e822                	sd	s0,16(sp)
    1606:	e426                	sd	s1,8(sp)
    1608:	e04a                	sd	s2,0(sp)
    160a:	1000                	addi	s0,sp,32
    160c:	892a                	mv	s2,a0
    160e:	3e800493          	li	s1,1000
    int pid1 = fork();
    1612:	0bc040ef          	jal	56ce <fork>
    if (pid1 < 0) {
    1616:	02054663          	bltz	a0,1642 <twochildren+0x42>
    if (pid1 == 0) {
    161a:	cd15                	beqz	a0,1656 <twochildren+0x56>
      int pid2 = fork();
    161c:	0b2040ef          	jal	56ce <fork>
      if (pid2 < 0) {
    1620:	02054d63          	bltz	a0,165a <twochildren+0x5a>
      if (pid2 == 0) {
    1624:	c529                	beqz	a0,166e <twochildren+0x6e>
        wait(0);
    1626:	4501                	li	a0,0
    1628:	0b6040ef          	jal	56de <wait>
        wait(0);
    162c:	4501                	li	a0,0
    162e:	0b0040ef          	jal	56de <wait>
  for (int i = 0; i < 1000; i++) {
    1632:	34fd                	addiw	s1,s1,-1
    1634:	fcf9                	bnez	s1,1612 <twochildren+0x12>
}
    1636:	60e2                	ld	ra,24(sp)
    1638:	6442                	ld	s0,16(sp)
    163a:	64a2                	ld	s1,8(sp)
    163c:	6902                	ld	s2,0(sp)
    163e:	6105                	addi	sp,sp,32
    1640:	8082                	ret
      printf("%s: fork failed\n", s);
    1642:	85ca                	mv	a1,s2
    1644:	00005517          	auipc	a0,0x5
    1648:	f7450513          	addi	a0,a0,-140 # 65b8 <malloc+0x9c0>
    164c:	4f0040ef          	jal	5b3c <printf>
      exit(1);
    1650:	4505                	li	a0,1
    1652:	084040ef          	jal	56d6 <exit>
      exit(0);
    1656:	080040ef          	jal	56d6 <exit>
        printf("%s: fork failed\n", s);
    165a:	85ca                	mv	a1,s2
    165c:	00005517          	auipc	a0,0x5
    1660:	f5c50513          	addi	a0,a0,-164 # 65b8 <malloc+0x9c0>
    1664:	4d8040ef          	jal	5b3c <printf>
        exit(1);
    1668:	4505                	li	a0,1
    166a:	06c040ef          	jal	56d6 <exit>
        exit(0);
    166e:	068040ef          	jal	56d6 <exit>

0000000000001672 <forkfork>:
{
    1672:	7179                	addi	sp,sp,-48
    1674:	f406                	sd	ra,40(sp)
    1676:	f022                	sd	s0,32(sp)
    1678:	ec26                	sd	s1,24(sp)
    167a:	1800                	addi	s0,sp,48
    167c:	84aa                	mv	s1,a0
    int pid = fork();
    167e:	050040ef          	jal	56ce <fork>
    if (pid < 0) {
    1682:	02054b63          	bltz	a0,16b8 <forkfork+0x46>
    if (pid == 0) {
    1686:	c139                	beqz	a0,16cc <forkfork+0x5a>
    int pid = fork();
    1688:	046040ef          	jal	56ce <fork>
    if (pid < 0) {
    168c:	02054663          	bltz	a0,16b8 <forkfork+0x46>
    if (pid == 0) {
    1690:	cd15                	beqz	a0,16cc <forkfork+0x5a>
    wait(&xstatus);
    1692:	fdc40513          	addi	a0,s0,-36
    1696:	048040ef          	jal	56de <wait>
    if (xstatus != 0) {
    169a:	fdc42783          	lw	a5,-36(s0)
    169e:	ebb9                	bnez	a5,16f4 <forkfork+0x82>
    wait(&xstatus);
    16a0:	fdc40513          	addi	a0,s0,-36
    16a4:	03a040ef          	jal	56de <wait>
    if (xstatus != 0) {
    16a8:	fdc42783          	lw	a5,-36(s0)
    16ac:	e7a1                	bnez	a5,16f4 <forkfork+0x82>
}
    16ae:	70a2                	ld	ra,40(sp)
    16b0:	7402                	ld	s0,32(sp)
    16b2:	64e2                	ld	s1,24(sp)
    16b4:	6145                	addi	sp,sp,48
    16b6:	8082                	ret
      printf("%s: fork failed", s);
    16b8:	85a6                	mv	a1,s1
    16ba:	00005517          	auipc	a0,0x5
    16be:	03e50513          	addi	a0,a0,62 # 66f8 <malloc+0xb00>
    16c2:	47a040ef          	jal	5b3c <printf>
      exit(1);
    16c6:	4505                	li	a0,1
    16c8:	00e040ef          	jal	56d6 <exit>
{
    16cc:	0c800493          	li	s1,200
        int pid1 = fork();
    16d0:	7ff030ef          	jal	56ce <fork>
        if (pid1 < 0) {
    16d4:	00054b63          	bltz	a0,16ea <forkfork+0x78>
        if (pid1 == 0) {
    16d8:	cd01                	beqz	a0,16f0 <forkfork+0x7e>
        wait(0);
    16da:	4501                	li	a0,0
    16dc:	002040ef          	jal	56de <wait>
      for (int j = 0; j < 200; j++) {
    16e0:	34fd                	addiw	s1,s1,-1
    16e2:	f4fd                	bnez	s1,16d0 <forkfork+0x5e>
      exit(0);
    16e4:	4501                	li	a0,0
    16e6:	7f1030ef          	jal	56d6 <exit>
          exit(1);
    16ea:	4505                	li	a0,1
    16ec:	7eb030ef          	jal	56d6 <exit>
          exit(0);
    16f0:	7e7030ef          	jal	56d6 <exit>
      printf("%s: fork in child failed", s);
    16f4:	85a6                	mv	a1,s1
    16f6:	00005517          	auipc	a0,0x5
    16fa:	01250513          	addi	a0,a0,18 # 6708 <malloc+0xb10>
    16fe:	43e040ef          	jal	5b3c <printf>
      exit(1);
    1702:	4505                	li	a0,1
    1704:	7d3030ef          	jal	56d6 <exit>

0000000000001708 <reparent2>:
{
    1708:	1101                	addi	sp,sp,-32
    170a:	ec06                	sd	ra,24(sp)
    170c:	e822                	sd	s0,16(sp)
    170e:	e426                	sd	s1,8(sp)
    1710:	1000                	addi	s0,sp,32
    1712:	32000493          	li	s1,800
    int pid1 = fork();
    1716:	7b9030ef          	jal	56ce <fork>
    if (pid1 < 0) {
    171a:	00054b63          	bltz	a0,1730 <reparent2+0x28>
    if (pid1 == 0) {
    171e:	c115                	beqz	a0,1742 <reparent2+0x3a>
    wait(0);
    1720:	4501                	li	a0,0
    1722:	7bd030ef          	jal	56de <wait>
  for (int i = 0; i < 800; i++) {
    1726:	34fd                	addiw	s1,s1,-1
    1728:	f4fd                	bnez	s1,1716 <reparent2+0xe>
  exit(0);
    172a:	4501                	li	a0,0
    172c:	7ab030ef          	jal	56d6 <exit>
      printf("fork failed\n");
    1730:	00006517          	auipc	a0,0x6
    1734:	54850513          	addi	a0,a0,1352 # 7c78 <malloc+0x2080>
    1738:	404040ef          	jal	5b3c <printf>
      exit(1);
    173c:	4505                	li	a0,1
    173e:	799030ef          	jal	56d6 <exit>
      fork();
    1742:	78d030ef          	jal	56ce <fork>
      fork();
    1746:	789030ef          	jal	56ce <fork>
      exit(0);
    174a:	4501                	li	a0,0
    174c:	78b030ef          	jal	56d6 <exit>

0000000000001750 <createdelete>:
{
    1750:	7135                	addi	sp,sp,-160
    1752:	ed06                	sd	ra,152(sp)
    1754:	e922                	sd	s0,144(sp)
    1756:	e526                	sd	s1,136(sp)
    1758:	e14a                	sd	s2,128(sp)
    175a:	fcce                	sd	s3,120(sp)
    175c:	f8d2                	sd	s4,112(sp)
    175e:	f4d6                	sd	s5,104(sp)
    1760:	f0da                	sd	s6,96(sp)
    1762:	ecde                	sd	s7,88(sp)
    1764:	e8e2                	sd	s8,80(sp)
    1766:	e4e6                	sd	s9,72(sp)
    1768:	e0ea                	sd	s10,64(sp)
    176a:	fc6e                	sd	s11,56(sp)
    176c:	1100                	addi	s0,sp,160
    176e:	8daa                	mv	s11,a0
  for (pi = 0; pi < NCHILD; pi++) {
    1770:	4901                	li	s2,0
    1772:	4991                	li	s3,4
    pid = fork();
    1774:	75b030ef          	jal	56ce <fork>
    1778:	84aa                	mv	s1,a0
    if (pid < 0) {
    177a:	04054063          	bltz	a0,17ba <createdelete+0x6a>
    if (pid == 0) {
    177e:	c921                	beqz	a0,17ce <createdelete+0x7e>
  for (pi = 0; pi < NCHILD; pi++) {
    1780:	2905                	addiw	s2,s2,1
    1782:	ff3919e3          	bne	s2,s3,1774 <createdelete+0x24>
    1786:	4491                	li	s1,4
    wait(&xstatus);
    1788:	f6c40913          	addi	s2,s0,-148
    178c:	854a                	mv	a0,s2
    178e:	751030ef          	jal	56de <wait>
    if (xstatus != 0)
    1792:	f6c42a83          	lw	s5,-148(s0)
    1796:	0c0a9263          	bnez	s5,185a <createdelete+0x10a>
  for (pi = 0; pi < NCHILD; pi++) {
    179a:	34fd                	addiw	s1,s1,-1
    179c:	f8e5                	bnez	s1,178c <createdelete+0x3c>
  name[0] = name[1] = name[2] = 0;
    179e:	f6040923          	sb	zero,-142(s0)
    17a2:	03000993          	li	s3,48
    17a6:	5a7d                	li	s4,-1
      if ((i == 0 || i >= N / 2) && fd < 0) {
    17a8:	4d25                	li	s10,9
    17aa:	07000c93          	li	s9,112
      fd = open(name, 0);
    17ae:	f7040c13          	addi	s8,s0,-144
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    17b2:	4ba1                	li	s7,8
    for (pi = 0; pi < NCHILD; pi++) {
    17b4:	07400b13          	li	s6,116
    17b8:	aa39                	j	18d6 <createdelete+0x186>
      printf("%s: fork failed\n", s);
    17ba:	85ee                	mv	a1,s11
    17bc:	00005517          	auipc	a0,0x5
    17c0:	dfc50513          	addi	a0,a0,-516 # 65b8 <malloc+0x9c0>
    17c4:	378040ef          	jal	5b3c <printf>
      exit(1);
    17c8:	4505                	li	a0,1
    17ca:	70d030ef          	jal	56d6 <exit>
      name[0] = 'p' + pi;
    17ce:	0709091b          	addiw	s2,s2,112
    17d2:	f7240823          	sb	s2,-144(s0)
      name[2] = '\0';
    17d6:	f6040923          	sb	zero,-142(s0)
        fd = open(name, O_CREATE | O_RDWR);
    17da:	f7040913          	addi	s2,s0,-144
    17de:	20200993          	li	s3,514
      for (i = 0; i < N; i++) {
    17e2:	4a51                	li	s4,20
    17e4:	a815                	j	1818 <createdelete+0xc8>
          printf("%s: create failed\n", s);
    17e6:	85ee                	mv	a1,s11
    17e8:	00005517          	auipc	a0,0x5
    17ec:	f4050513          	addi	a0,a0,-192 # 6728 <malloc+0xb30>
    17f0:	34c040ef          	jal	5b3c <printf>
          exit(1);
    17f4:	4505                	li	a0,1
    17f6:	6e1030ef          	jal	56d6 <exit>
          name[1] = '0' + (i / 2);
    17fa:	01f4d79b          	srliw	a5,s1,0x1f
    17fe:	9fa5                	addw	a5,a5,s1
    1800:	4017d79b          	sraiw	a5,a5,0x1
    1804:	0307879b          	addiw	a5,a5,48
    1808:	f6f408a3          	sb	a5,-143(s0)
          if (unlink(name) < 0) {
    180c:	854a                	mv	a0,s2
    180e:	719030ef          	jal	5726 <unlink>
    1812:	02054a63          	bltz	a0,1846 <createdelete+0xf6>
      for (i = 0; i < N; i++) {
    1816:	2485                	addiw	s1,s1,1
        name[1] = '0' + i;
    1818:	0304879b          	addiw	a5,s1,48
    181c:	f6f408a3          	sb	a5,-143(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1820:	85ce                	mv	a1,s3
    1822:	854a                	mv	a0,s2
    1824:	6f3030ef          	jal	5716 <open>
        if (fd < 0) {
    1828:	fa054fe3          	bltz	a0,17e6 <createdelete+0x96>
        close(fd);
    182c:	6d3030ef          	jal	56fe <close>
        if (i > 0 && (i % 2) == 0) {
    1830:	fe9053e3          	blez	s1,1816 <createdelete+0xc6>
    1834:	0014f793          	andi	a5,s1,1
    1838:	d3e9                	beqz	a5,17fa <createdelete+0xaa>
      for (i = 0; i < N; i++) {
    183a:	2485                	addiw	s1,s1,1
    183c:	fd449ee3          	bne	s1,s4,1818 <createdelete+0xc8>
      exit(0);
    1840:	4501                	li	a0,0
    1842:	695030ef          	jal	56d6 <exit>
            printf("%s: unlink failed\n", s);
    1846:	85ee                	mv	a1,s11
    1848:	00005517          	auipc	a0,0x5
    184c:	ef850513          	addi	a0,a0,-264 # 6740 <malloc+0xb48>
    1850:	2ec040ef          	jal	5b3c <printf>
            exit(1);
    1854:	4505                	li	a0,1
    1856:	681030ef          	jal	56d6 <exit>
      exit(1);
    185a:	4505                	li	a0,1
    185c:	67b030ef          	jal	56d6 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1860:	f7040613          	addi	a2,s0,-144
    1864:	85ee                	mv	a1,s11
    1866:	00005517          	auipc	a0,0x5
    186a:	ef250513          	addi	a0,a0,-270 # 6758 <malloc+0xb60>
    186e:	2ce040ef          	jal	5b3c <printf>
        exit(1);
    1872:	4505                	li	a0,1
    1874:	663030ef          	jal	56d6 <exit>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1878:	02054063          	bltz	a0,1898 <createdelete+0x148>
        printf("%s: oops createdelete %s did exist\n", s, name);
    187c:	f7040613          	addi	a2,s0,-144
    1880:	85ee                	mv	a1,s11
    1882:	00005517          	auipc	a0,0x5
    1886:	efe50513          	addi	a0,a0,-258 # 6780 <malloc+0xb88>
    188a:	2b2040ef          	jal	5b3c <printf>
        exit(1);
    188e:	4505                	li	a0,1
    1890:	647030ef          	jal	56d6 <exit>
        close(fd);
    1894:	66b030ef          	jal	56fe <close>
    for (pi = 0; pi < NCHILD; pi++) {
    1898:	2485                	addiw	s1,s1,1
    189a:	0ff4f493          	zext.b	s1,s1
    189e:	03648463          	beq	s1,s6,18c6 <createdelete+0x176>
      name[0] = 'p' + pi;
    18a2:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    18a6:	f73408a3          	sb	s3,-143(s0)
      fd = open(name, 0);
    18aa:	4581                	li	a1,0
    18ac:	8562                	mv	a0,s8
    18ae:	669030ef          	jal	5716 <open>
      if ((i == 0 || i >= N / 2) && fd < 0) {
    18b2:	01f5579b          	srliw	a5,a0,0x1f
    18b6:	00f977b3          	and	a5,s2,a5
    18ba:	f3dd                	bnez	a5,1860 <createdelete+0x110>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    18bc:	fb4bfee3          	bgeu	s7,s4,1878 <createdelete+0x128>
      if (fd >= 0)
    18c0:	fc054ce3          	bltz	a0,1898 <createdelete+0x148>
    18c4:	bfc1                	j	1894 <createdelete+0x144>
  for (i = 0; i < N; i++) {
    18c6:	2a85                	addiw	s5,s5,1
    18c8:	2a05                	addiw	s4,s4,1
    18ca:	2985                	addiw	s3,s3,1
    18cc:	0ff9f993          	zext.b	s3,s3
    18d0:	47d1                	li	a5,20
    18d2:	00fa8a63          	beq	s5,a5,18e6 <createdelete+0x196>
      if ((i == 0 || i >= N / 2) && fd < 0) {
    18d6:	001ab913          	seqz	s2,s5
    18da:	015d27b3          	slt	a5,s10,s5
    18de:	00f96933          	or	s2,s2,a5
    18e2:	84e6                	mv	s1,s9
    18e4:	bf7d                	j	18a2 <createdelete+0x152>
  for (i = 0; i < N; i++) {
    18e6:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    18ea:	07000b13          	li	s6,112
      unlink(name);
    18ee:	f7040a13          	addi	s4,s0,-144
    for (pi = 0; pi < NCHILD; pi++) {
    18f2:	07400993          	li	s3,116
  for (i = 0; i < N; i++) {
    18f6:	04400a93          	li	s5,68
  name[0] = name[1] = name[2] = 0;
    18fa:	84da                	mv	s1,s6
      name[0] = 'p' + pi;
    18fc:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    1900:	f72408a3          	sb	s2,-143(s0)
      unlink(name);
    1904:	8552                	mv	a0,s4
    1906:	621030ef          	jal	5726 <unlink>
    for (pi = 0; pi < NCHILD; pi++) {
    190a:	2485                	addiw	s1,s1,1
    190c:	0ff4f493          	zext.b	s1,s1
    1910:	ff3496e3          	bne	s1,s3,18fc <createdelete+0x1ac>
  for (i = 0; i < N; i++) {
    1914:	2905                	addiw	s2,s2,1
    1916:	0ff97913          	zext.b	s2,s2
    191a:	ff5910e3          	bne	s2,s5,18fa <createdelete+0x1aa>
}
    191e:	60ea                	ld	ra,152(sp)
    1920:	644a                	ld	s0,144(sp)
    1922:	64aa                	ld	s1,136(sp)
    1924:	690a                	ld	s2,128(sp)
    1926:	79e6                	ld	s3,120(sp)
    1928:	7a46                	ld	s4,112(sp)
    192a:	7aa6                	ld	s5,104(sp)
    192c:	7b06                	ld	s6,96(sp)
    192e:	6be6                	ld	s7,88(sp)
    1930:	6c46                	ld	s8,80(sp)
    1932:	6ca6                	ld	s9,72(sp)
    1934:	6d06                	ld	s10,64(sp)
    1936:	7de2                	ld	s11,56(sp)
    1938:	610d                	addi	sp,sp,160
    193a:	8082                	ret

000000000000193c <linkunlink>:
{
    193c:	711d                	addi	sp,sp,-96
    193e:	ec86                	sd	ra,88(sp)
    1940:	e8a2                	sd	s0,80(sp)
    1942:	e4a6                	sd	s1,72(sp)
    1944:	e0ca                	sd	s2,64(sp)
    1946:	fc4e                	sd	s3,56(sp)
    1948:	f852                	sd	s4,48(sp)
    194a:	f456                	sd	s5,40(sp)
    194c:	f05a                	sd	s6,32(sp)
    194e:	ec5e                	sd	s7,24(sp)
    1950:	e862                	sd	s8,16(sp)
    1952:	e466                	sd	s9,8(sp)
    1954:	e06a                	sd	s10,0(sp)
    1956:	1080                	addi	s0,sp,96
    1958:	84aa                	mv	s1,a0
  unlink("x");
    195a:	00004517          	auipc	a0,0x4
    195e:	43e50513          	addi	a0,a0,1086 # 5d98 <malloc+0x1a0>
    1962:	5c5030ef          	jal	5726 <unlink>
  pid = fork();
    1966:	569030ef          	jal	56ce <fork>
  if (pid < 0) {
    196a:	04054663          	bltz	a0,19b6 <linkunlink+0x7a>
    196e:	8d2a                	mv	s10,a0
  unsigned int x = (pid ? 1 : 97);
    1970:	00153913          	seqz	s2,a0
    1974:	41200933          	neg	s2,s2
    1978:	06097913          	andi	s2,s2,96
    197c:	0905                	addi	s2,s2,1
    197e:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1982:	41c65ab7          	lui	s5,0x41c65
    1986:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x41c54185>
    198a:	6a0d                	lui	s4,0x3
    198c:	039a0a1b          	addiw	s4,s4,57 # 3039 <subdir+0x4b3>
    if ((x % 3) == 0) {
    1990:	000ab9b7          	lui	s3,0xab
    1994:	aab98993          	addi	s3,s3,-1365 # aaaab <base+0x99dc3>
    1998:	09b2                	slli	s3,s3,0xc
    199a:	aab98993          	addi	s3,s3,-1365
    } else if ((x % 3) == 1) {
    199e:	4b85                	li	s7,1
      unlink("x");
    19a0:	00004b17          	auipc	s6,0x4
    19a4:	3f8b0b13          	addi	s6,s6,1016 # 5d98 <malloc+0x1a0>
      link("cat", "x");
    19a8:	00005c97          	auipc	s9,0x5
    19ac:	e00c8c93          	addi	s9,s9,-512 # 67a8 <malloc+0xbb0>
      close(open("x", O_RDWR | O_CREATE));
    19b0:	20200c13          	li	s8,514
    19b4:	a03d                	j	19e2 <linkunlink+0xa6>
    printf("%s: fork failed\n", s);
    19b6:	85a6                	mv	a1,s1
    19b8:	00005517          	auipc	a0,0x5
    19bc:	c0050513          	addi	a0,a0,-1024 # 65b8 <malloc+0x9c0>
    19c0:	17c040ef          	jal	5b3c <printf>
    exit(1);
    19c4:	4505                	li	a0,1
    19c6:	511030ef          	jal	56d6 <exit>
      close(open("x", O_RDWR | O_CREATE));
    19ca:	85e2                	mv	a1,s8
    19cc:	855a                	mv	a0,s6
    19ce:	549030ef          	jal	5716 <open>
    19d2:	52d030ef          	jal	56fe <close>
    19d6:	a021                	j	19de <linkunlink+0xa2>
      unlink("x");
    19d8:	855a                	mv	a0,s6
    19da:	54d030ef          	jal	5726 <unlink>
  for (i = 0; i < 100; i++) {
    19de:	34fd                	addiw	s1,s1,-1
    19e0:	c885                	beqz	s1,1a10 <linkunlink+0xd4>
    x = x * 1103515245 + 12345;
    19e2:	035907bb          	mulw	a5,s2,s5
    19e6:	00fa07bb          	addw	a5,s4,a5
    19ea:	893e                	mv	s2,a5
    if ((x % 3) == 0) {
    19ec:	02079713          	slli	a4,a5,0x20
    19f0:	9301                	srli	a4,a4,0x20
    19f2:	03370733          	mul	a4,a4,s3
    19f6:	9305                	srli	a4,a4,0x21
    19f8:	0017169b          	slliw	a3,a4,0x1
    19fc:	9f35                	addw	a4,a4,a3
    19fe:	9f99                	subw	a5,a5,a4
    1a00:	d7e9                	beqz	a5,19ca <linkunlink+0x8e>
    } else if ((x % 3) == 1) {
    1a02:	fd779be3          	bne	a5,s7,19d8 <linkunlink+0x9c>
      link("cat", "x");
    1a06:	85da                	mv	a1,s6
    1a08:	8566                	mv	a0,s9
    1a0a:	52d030ef          	jal	5736 <link>
    1a0e:	bfc1                	j	19de <linkunlink+0xa2>
  if (pid)
    1a10:	020d0363          	beqz	s10,1a36 <linkunlink+0xfa>
    wait(0);
    1a14:	4501                	li	a0,0
    1a16:	4c9030ef          	jal	56de <wait>
}
    1a1a:	60e6                	ld	ra,88(sp)
    1a1c:	6446                	ld	s0,80(sp)
    1a1e:	64a6                	ld	s1,72(sp)
    1a20:	6906                	ld	s2,64(sp)
    1a22:	79e2                	ld	s3,56(sp)
    1a24:	7a42                	ld	s4,48(sp)
    1a26:	7aa2                	ld	s5,40(sp)
    1a28:	7b02                	ld	s6,32(sp)
    1a2a:	6be2                	ld	s7,24(sp)
    1a2c:	6c42                	ld	s8,16(sp)
    1a2e:	6ca2                	ld	s9,8(sp)
    1a30:	6d02                	ld	s10,0(sp)
    1a32:	6125                	addi	sp,sp,96
    1a34:	8082                	ret
    exit(0);
    1a36:	4501                	li	a0,0
    1a38:	49f030ef          	jal	56d6 <exit>

0000000000001a3c <forktest>:
{
    1a3c:	7179                	addi	sp,sp,-48
    1a3e:	f406                	sd	ra,40(sp)
    1a40:	f022                	sd	s0,32(sp)
    1a42:	ec26                	sd	s1,24(sp)
    1a44:	e84a                	sd	s2,16(sp)
    1a46:	e44e                	sd	s3,8(sp)
    1a48:	1800                	addi	s0,sp,48
    1a4a:	89aa                	mv	s3,a0
  for (n = 0; n < N; n++) {
    1a4c:	4481                	li	s1,0
    1a4e:	3e800913          	li	s2,1000
    pid = fork();
    1a52:	47d030ef          	jal	56ce <fork>
    if (pid < 0)
    1a56:	06054063          	bltz	a0,1ab6 <forktest+0x7a>
    if (pid == 0)
    1a5a:	cd11                	beqz	a0,1a76 <forktest+0x3a>
  for (n = 0; n < N; n++) {
    1a5c:	2485                	addiw	s1,s1,1
    1a5e:	ff249ae3          	bne	s1,s2,1a52 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1a62:	85ce                	mv	a1,s3
    1a64:	00005517          	auipc	a0,0x5
    1a68:	d9450513          	addi	a0,a0,-620 # 67f8 <malloc+0xc00>
    1a6c:	0d0040ef          	jal	5b3c <printf>
    exit(1);
    1a70:	4505                	li	a0,1
    1a72:	465030ef          	jal	56d6 <exit>
      exit(0);
    1a76:	461030ef          	jal	56d6 <exit>
    printf("%s: no fork at all!\n", s);
    1a7a:	85ce                	mv	a1,s3
    1a7c:	00005517          	auipc	a0,0x5
    1a80:	d3450513          	addi	a0,a0,-716 # 67b0 <malloc+0xbb8>
    1a84:	0b8040ef          	jal	5b3c <printf>
    exit(1);
    1a88:	4505                	li	a0,1
    1a8a:	44d030ef          	jal	56d6 <exit>
      printf("%s: wait stopped early\n", s);
    1a8e:	85ce                	mv	a1,s3
    1a90:	00005517          	auipc	a0,0x5
    1a94:	d3850513          	addi	a0,a0,-712 # 67c8 <malloc+0xbd0>
    1a98:	0a4040ef          	jal	5b3c <printf>
      exit(1);
    1a9c:	4505                	li	a0,1
    1a9e:	439030ef          	jal	56d6 <exit>
    printf("%s: wait got too many\n", s);
    1aa2:	85ce                	mv	a1,s3
    1aa4:	00005517          	auipc	a0,0x5
    1aa8:	d3c50513          	addi	a0,a0,-708 # 67e0 <malloc+0xbe8>
    1aac:	090040ef          	jal	5b3c <printf>
    exit(1);
    1ab0:	4505                	li	a0,1
    1ab2:	425030ef          	jal	56d6 <exit>
  if (n == 0) {
    1ab6:	d0f1                	beqz	s1,1a7a <forktest+0x3e>
  for (; n > 0; n--) {
    1ab8:	00905963          	blez	s1,1aca <forktest+0x8e>
    if (wait(0) < 0) {
    1abc:	4501                	li	a0,0
    1abe:	421030ef          	jal	56de <wait>
    1ac2:	fc0546e3          	bltz	a0,1a8e <forktest+0x52>
  for (; n > 0; n--) {
    1ac6:	34fd                	addiw	s1,s1,-1
    1ac8:	f8f5                	bnez	s1,1abc <forktest+0x80>
  if (wait(0) != -1) {
    1aca:	4501                	li	a0,0
    1acc:	413030ef          	jal	56de <wait>
    1ad0:	57fd                	li	a5,-1
    1ad2:	fcf518e3          	bne	a0,a5,1aa2 <forktest+0x66>
}
    1ad6:	70a2                	ld	ra,40(sp)
    1ad8:	7402                	ld	s0,32(sp)
    1ada:	64e2                	ld	s1,24(sp)
    1adc:	6942                	ld	s2,16(sp)
    1ade:	69a2                	ld	s3,8(sp)
    1ae0:	6145                	addi	sp,sp,48
    1ae2:	8082                	ret

0000000000001ae4 <kernmem>:
{
    1ae4:	715d                	addi	sp,sp,-80
    1ae6:	e486                	sd	ra,72(sp)
    1ae8:	e0a2                	sd	s0,64(sp)
    1aea:	fc26                	sd	s1,56(sp)
    1aec:	f84a                	sd	s2,48(sp)
    1aee:	f44e                	sd	s3,40(sp)
    1af0:	f052                	sd	s4,32(sp)
    1af2:	ec56                	sd	s5,24(sp)
    1af4:	e85a                	sd	s6,16(sp)
    1af6:	0880                	addi	s0,sp,80
    1af8:	8b2a                	mv	s6,a0
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1afa:	4485                	li	s1,1
    1afc:	04fe                	slli	s1,s1,0x1f
    wait(&xstatus);
    1afe:	fbc40a93          	addi	s5,s0,-68
    if (xstatus != -1) // did kernel kill child?
    1b02:	5a7d                	li	s4,-1
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1b04:	69b1                	lui	s3,0xc
    1b06:	35098993          	addi	s3,s3,848 # c350 <uninit+0xd78>
    1b0a:	1003d937          	lui	s2,0x1003d
    1b0e:	090e                	slli	s2,s2,0x3
    1b10:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002c798>
    pid = fork();
    1b14:	3bb030ef          	jal	56ce <fork>
    if (pid < 0) {
    1b18:	02054763          	bltz	a0,1b46 <kernmem+0x62>
    if (pid == 0) {
    1b1c:	cd1d                	beqz	a0,1b5a <kernmem+0x76>
    wait(&xstatus);
    1b1e:	8556                	mv	a0,s5
    1b20:	3bf030ef          	jal	56de <wait>
    if (xstatus != -1) // did kernel kill child?
    1b24:	fbc42783          	lw	a5,-68(s0)
    1b28:	05479663          	bne	a5,s4,1b74 <kernmem+0x90>
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1b2c:	94ce                	add	s1,s1,s3
    1b2e:	ff2493e3          	bne	s1,s2,1b14 <kernmem+0x30>
}
    1b32:	60a6                	ld	ra,72(sp)
    1b34:	6406                	ld	s0,64(sp)
    1b36:	74e2                	ld	s1,56(sp)
    1b38:	7942                	ld	s2,48(sp)
    1b3a:	79a2                	ld	s3,40(sp)
    1b3c:	7a02                	ld	s4,32(sp)
    1b3e:	6ae2                	ld	s5,24(sp)
    1b40:	6b42                	ld	s6,16(sp)
    1b42:	6161                	addi	sp,sp,80
    1b44:	8082                	ret
      printf("%s: fork failed\n", s);
    1b46:	85da                	mv	a1,s6
    1b48:	00005517          	auipc	a0,0x5
    1b4c:	a7050513          	addi	a0,a0,-1424 # 65b8 <malloc+0x9c0>
    1b50:	7ed030ef          	jal	5b3c <printf>
      exit(1);
    1b54:	4505                	li	a0,1
    1b56:	381030ef          	jal	56d6 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1b5a:	0004c683          	lbu	a3,0(s1)
    1b5e:	8626                	mv	a2,s1
    1b60:	85da                	mv	a1,s6
    1b62:	00005517          	auipc	a0,0x5
    1b66:	cbe50513          	addi	a0,a0,-834 # 6820 <malloc+0xc28>
    1b6a:	7d3030ef          	jal	5b3c <printf>
      exit(1);
    1b6e:	4505                	li	a0,1
    1b70:	367030ef          	jal	56d6 <exit>
      exit(1);
    1b74:	4505                	li	a0,1
    1b76:	361030ef          	jal	56d6 <exit>

0000000000001b7a <MAXVAplus>:
{
    1b7a:	7139                	addi	sp,sp,-64
    1b7c:	fc06                	sd	ra,56(sp)
    1b7e:	f822                	sd	s0,48(sp)
    1b80:	0080                	addi	s0,sp,64
  volatile uint64 a = MAXVA;
    1b82:	4785                	li	a5,1
    1b84:	179a                	slli	a5,a5,0x26
    1b86:	fcf43423          	sd	a5,-56(s0)
  for (; a != 0; a <<= 1) {
    1b8a:	fc843783          	ld	a5,-56(s0)
    1b8e:	cf9d                	beqz	a5,1bcc <MAXVAplus+0x52>
    1b90:	f426                	sd	s1,40(sp)
    1b92:	f04a                	sd	s2,32(sp)
    1b94:	ec4e                	sd	s3,24(sp)
    1b96:	89aa                	mv	s3,a0
    wait(&xstatus);
    1b98:	fc440913          	addi	s2,s0,-60
    if (xstatus != -1) // did kernel kill child?
    1b9c:	54fd                	li	s1,-1
    pid = fork();
    1b9e:	331030ef          	jal	56ce <fork>
    if (pid < 0) {
    1ba2:	02054963          	bltz	a0,1bd4 <MAXVAplus+0x5a>
    if (pid == 0) {
    1ba6:	c129                	beqz	a0,1be8 <MAXVAplus+0x6e>
    wait(&xstatus);
    1ba8:	854a                	mv	a0,s2
    1baa:	335030ef          	jal	56de <wait>
    if (xstatus != -1) // did kernel kill child?
    1bae:	fc442783          	lw	a5,-60(s0)
    1bb2:	04979d63          	bne	a5,s1,1c0c <MAXVAplus+0x92>
  for (; a != 0; a <<= 1) {
    1bb6:	fc843783          	ld	a5,-56(s0)
    1bba:	0786                	slli	a5,a5,0x1
    1bbc:	fcf43423          	sd	a5,-56(s0)
    1bc0:	fc843783          	ld	a5,-56(s0)
    1bc4:	ffe9                	bnez	a5,1b9e <MAXVAplus+0x24>
    1bc6:	74a2                	ld	s1,40(sp)
    1bc8:	7902                	ld	s2,32(sp)
    1bca:	69e2                	ld	s3,24(sp)
}
    1bcc:	70e2                	ld	ra,56(sp)
    1bce:	7442                	ld	s0,48(sp)
    1bd0:	6121                	addi	sp,sp,64
    1bd2:	8082                	ret
      printf("%s: fork failed\n", s);
    1bd4:	85ce                	mv	a1,s3
    1bd6:	00005517          	auipc	a0,0x5
    1bda:	9e250513          	addi	a0,a0,-1566 # 65b8 <malloc+0x9c0>
    1bde:	75f030ef          	jal	5b3c <printf>
      exit(1);
    1be2:	4505                	li	a0,1
    1be4:	2f3030ef          	jal	56d6 <exit>
      *(char *)a = 99;
    1be8:	fc843783          	ld	a5,-56(s0)
    1bec:	06300713          	li	a4,99
    1bf0:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void *)a);
    1bf4:	fc843603          	ld	a2,-56(s0)
    1bf8:	85ce                	mv	a1,s3
    1bfa:	00005517          	auipc	a0,0x5
    1bfe:	c4650513          	addi	a0,a0,-954 # 6840 <malloc+0xc48>
    1c02:	73b030ef          	jal	5b3c <printf>
      exit(1);
    1c06:	4505                	li	a0,1
    1c08:	2cf030ef          	jal	56d6 <exit>
      exit(1);
    1c0c:	4505                	li	a0,1
    1c0e:	2c9030ef          	jal	56d6 <exit>

0000000000001c12 <stacktest>:
{
    1c12:	7179                	addi	sp,sp,-48
    1c14:	f406                	sd	ra,40(sp)
    1c16:	f022                	sd	s0,32(sp)
    1c18:	ec26                	sd	s1,24(sp)
    1c1a:	1800                	addi	s0,sp,48
    1c1c:	84aa                	mv	s1,a0
  pid = fork();
    1c1e:	2b1030ef          	jal	56ce <fork>
  if (pid == 0) {
    1c22:	cd11                	beqz	a0,1c3e <stacktest+0x2c>
  } else if (pid < 0) {
    1c24:	02054c63          	bltz	a0,1c5c <stacktest+0x4a>
  wait(&xstatus);
    1c28:	fdc40513          	addi	a0,s0,-36
    1c2c:	2b3030ef          	jal	56de <wait>
  if (xstatus == -1) // kernel killed child?
    1c30:	fdc42503          	lw	a0,-36(s0)
    1c34:	57fd                	li	a5,-1
    1c36:	02f50d63          	beq	a0,a5,1c70 <stacktest+0x5e>
    exit(xstatus);
    1c3a:	29d030ef          	jal	56d6 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r"(x));
    1c3e:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1c40:	77fd                	lui	a5,0xfffff
    1c42:	97ba                	add	a5,a5,a4
    1c44:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffee318>
    1c48:	85a6                	mv	a1,s1
    1c4a:	00005517          	auipc	a0,0x5
    1c4e:	c0e50513          	addi	a0,a0,-1010 # 6858 <malloc+0xc60>
    1c52:	6eb030ef          	jal	5b3c <printf>
    exit(1);
    1c56:	4505                	li	a0,1
    1c58:	27f030ef          	jal	56d6 <exit>
    printf("%s: fork failed\n", s);
    1c5c:	85a6                	mv	a1,s1
    1c5e:	00005517          	auipc	a0,0x5
    1c62:	95a50513          	addi	a0,a0,-1702 # 65b8 <malloc+0x9c0>
    1c66:	6d7030ef          	jal	5b3c <printf>
    exit(1);
    1c6a:	4505                	li	a0,1
    1c6c:	26b030ef          	jal	56d6 <exit>
    exit(0);
    1c70:	4501                	li	a0,0
    1c72:	265030ef          	jal	56d6 <exit>

0000000000001c76 <nowrite>:
{
    1c76:	7159                	addi	sp,sp,-112
    1c78:	f486                	sd	ra,104(sp)
    1c7a:	f0a2                	sd	s0,96(sp)
    1c7c:	eca6                	sd	s1,88(sp)
    1c7e:	e8ca                	sd	s2,80(sp)
    1c80:	e4ce                	sd	s3,72(sp)
    1c82:	e0d2                	sd	s4,64(sp)
    1c84:	1880                	addi	s0,sp,112
    1c86:	8a2a                	mv	s4,a0
  uint64 addrs[] = {0,
    1c88:	00007797          	auipc	a5,0x7
    1c8c:	95878793          	addi	a5,a5,-1704 # 85e0 <malloc+0x29e8>
    1c90:	7788                	ld	a0,40(a5)
    1c92:	7b8c                	ld	a1,48(a5)
    1c94:	7f90                	ld	a2,56(a5)
    1c96:	63b4                	ld	a3,64(a5)
    1c98:	67b8                	ld	a4,72(a5)
    1c9a:	f8a43c23          	sd	a0,-104(s0)
    1c9e:	fab43023          	sd	a1,-96(s0)
    1ca2:	fac43423          	sd	a2,-88(s0)
    1ca6:	fad43823          	sd	a3,-80(s0)
    1caa:	fae43c23          	sd	a4,-72(s0)
    1cae:	6bbc                	ld	a5,80(a5)
    1cb0:	fcf43023          	sd	a5,-64(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1cb4:	4481                	li	s1,0
    wait(&xstatus);
    1cb6:	fcc40913          	addi	s2,s0,-52
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1cba:	4999                	li	s3,6
    pid = fork();
    1cbc:	213030ef          	jal	56ce <fork>
    if (pid == 0) {
    1cc0:	cd19                	beqz	a0,1cde <nowrite+0x68>
    } else if (pid < 0) {
    1cc2:	04054063          	bltz	a0,1d02 <nowrite+0x8c>
    wait(&xstatus);
    1cc6:	854a                	mv	a0,s2
    1cc8:	217030ef          	jal	56de <wait>
    if (xstatus == 0) {
    1ccc:	fcc42783          	lw	a5,-52(s0)
    1cd0:	c3b9                	beqz	a5,1d16 <nowrite+0xa0>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1cd2:	2485                	addiw	s1,s1,1
    1cd4:	ff3494e3          	bne	s1,s3,1cbc <nowrite+0x46>
  exit(0);
    1cd8:	4501                	li	a0,0
    1cda:	1fd030ef          	jal	56d6 <exit>
      volatile int *addr = (int *)addrs[ai];
    1cde:	048e                	slli	s1,s1,0x3
    1ce0:	fd040793          	addi	a5,s0,-48
    1ce4:	94be                	add	s1,s1,a5
    1ce6:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1cea:	47a9                	li	a5,10
    1cec:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1cee:	85d2                	mv	a1,s4
    1cf0:	00005517          	auipc	a0,0x5
    1cf4:	b9050513          	addi	a0,a0,-1136 # 6880 <malloc+0xc88>
    1cf8:	645030ef          	jal	5b3c <printf>
      exit(0);
    1cfc:	4501                	li	a0,0
    1cfe:	1d9030ef          	jal	56d6 <exit>
      printf("%s: fork failed\n", s);
    1d02:	85d2                	mv	a1,s4
    1d04:	00005517          	auipc	a0,0x5
    1d08:	8b450513          	addi	a0,a0,-1868 # 65b8 <malloc+0x9c0>
    1d0c:	631030ef          	jal	5b3c <printf>
      exit(1);
    1d10:	4505                	li	a0,1
    1d12:	1c5030ef          	jal	56d6 <exit>
      exit(1);
    1d16:	4505                	li	a0,1
    1d18:	1bf030ef          	jal	56d6 <exit>

0000000000001d1c <manywrites>:
{
    1d1c:	7159                	addi	sp,sp,-112
    1d1e:	f486                	sd	ra,104(sp)
    1d20:	f0a2                	sd	s0,96(sp)
    1d22:	eca6                	sd	s1,88(sp)
    1d24:	e8ca                	sd	s2,80(sp)
    1d26:	e4ce                	sd	s3,72(sp)
    1d28:	ec66                	sd	s9,24(sp)
    1d2a:	1880                	addi	s0,sp,112
    1d2c:	8caa                	mv	s9,a0
  for (int ci = 0; ci < nchildren; ci++) {
    1d2e:	4901                	li	s2,0
    1d30:	4991                	li	s3,4
    int pid = fork();
    1d32:	19d030ef          	jal	56ce <fork>
    1d36:	84aa                	mv	s1,a0
    if (pid < 0) {
    1d38:	02054c63          	bltz	a0,1d70 <manywrites+0x54>
    if (pid == 0) {
    1d3c:	c929                	beqz	a0,1d8e <manywrites+0x72>
  for (int ci = 0; ci < nchildren; ci++) {
    1d3e:	2905                	addiw	s2,s2,1
    1d40:	ff3919e3          	bne	s2,s3,1d32 <manywrites+0x16>
    1d44:	4491                	li	s1,4
    wait(&st);
    1d46:	f9840913          	addi	s2,s0,-104
    int st = 0;
    1d4a:	f8042c23          	sw	zero,-104(s0)
    wait(&st);
    1d4e:	854a                	mv	a0,s2
    1d50:	18f030ef          	jal	56de <wait>
    if (st != 0)
    1d54:	f9842503          	lw	a0,-104(s0)
    1d58:	0e051763          	bnez	a0,1e46 <manywrites+0x12a>
  for (int ci = 0; ci < nchildren; ci++) {
    1d5c:	34fd                	addiw	s1,s1,-1
    1d5e:	f4f5                	bnez	s1,1d4a <manywrites+0x2e>
    1d60:	e0d2                	sd	s4,64(sp)
    1d62:	fc56                	sd	s5,56(sp)
    1d64:	f85a                	sd	s6,48(sp)
    1d66:	f45e                	sd	s7,40(sp)
    1d68:	f062                	sd	s8,32(sp)
    1d6a:	e86a                	sd	s10,16(sp)
  exit(0);
    1d6c:	16b030ef          	jal	56d6 <exit>
    1d70:	e0d2                	sd	s4,64(sp)
    1d72:	fc56                	sd	s5,56(sp)
    1d74:	f85a                	sd	s6,48(sp)
    1d76:	f45e                	sd	s7,40(sp)
    1d78:	f062                	sd	s8,32(sp)
    1d7a:	e86a                	sd	s10,16(sp)
      printf("fork failed\n");
    1d7c:	00006517          	auipc	a0,0x6
    1d80:	efc50513          	addi	a0,a0,-260 # 7c78 <malloc+0x2080>
    1d84:	5b9030ef          	jal	5b3c <printf>
      exit(1);
    1d88:	4505                	li	a0,1
    1d8a:	14d030ef          	jal	56d6 <exit>
    1d8e:	e0d2                	sd	s4,64(sp)
    1d90:	fc56                	sd	s5,56(sp)
    1d92:	f85a                	sd	s6,48(sp)
    1d94:	f45e                	sd	s7,40(sp)
    1d96:	f062                	sd	s8,32(sp)
    1d98:	e86a                	sd	s10,16(sp)
      name[0] = 'b';
    1d9a:	06200793          	li	a5,98
    1d9e:	f8f40c23          	sb	a5,-104(s0)
      name[1] = 'a' + ci;
    1da2:	0619079b          	addiw	a5,s2,97
    1da6:	f8f40ca3          	sb	a5,-103(s0)
      name[2] = '\0';
    1daa:	f8040d23          	sb	zero,-102(s0)
      unlink(name);
    1dae:	f9840513          	addi	a0,s0,-104
    1db2:	175030ef          	jal	5726 <unlink>
    1db6:	47f9                	li	a5,30
    1db8:	8d3e                	mv	s10,a5
          int fd = open(name, O_CREATE | O_RDWR);
    1dba:	f9840b93          	addi	s7,s0,-104
    1dbe:	20200b13          	li	s6,514
          int cc = write(fd, buf, sz);
    1dc2:	6a8d                	lui	s5,0x3
    1dc4:	0000cc17          	auipc	s8,0xc
    1dc8:	f24c0c13          	addi	s8,s8,-220 # dce8 <buf>
        for (int i = 0; i < ci + 1; i++) {
    1dcc:	8a26                	mv	s4,s1
    1dce:	02094563          	bltz	s2,1df8 <manywrites+0xdc>
          int fd = open(name, O_CREATE | O_RDWR);
    1dd2:	85da                	mv	a1,s6
    1dd4:	855e                	mv	a0,s7
    1dd6:	141030ef          	jal	5716 <open>
    1dda:	89aa                	mv	s3,a0
          if (fd < 0) {
    1ddc:	02054d63          	bltz	a0,1e16 <manywrites+0xfa>
          int cc = write(fd, buf, sz);
    1de0:	8656                	mv	a2,s5
    1de2:	85e2                	mv	a1,s8
    1de4:	113030ef          	jal	56f6 <write>
          if (cc != sz) {
    1de8:	05551363          	bne	a0,s5,1e2e <manywrites+0x112>
          close(fd);
    1dec:	854e                	mv	a0,s3
    1dee:	111030ef          	jal	56fe <close>
        for (int i = 0; i < ci + 1; i++) {
    1df2:	2a05                	addiw	s4,s4,1
    1df4:	fd495fe3          	bge	s2,s4,1dd2 <manywrites+0xb6>
        unlink(name);
    1df8:	f9840513          	addi	a0,s0,-104
    1dfc:	12b030ef          	jal	5726 <unlink>
      for (int iters = 0; iters < howmany; iters++) {
    1e00:	fffd079b          	addiw	a5,s10,-1
    1e04:	8d3e                	mv	s10,a5
    1e06:	f3f9                	bnez	a5,1dcc <manywrites+0xb0>
      unlink(name);
    1e08:	f9840513          	addi	a0,s0,-104
    1e0c:	11b030ef          	jal	5726 <unlink>
      exit(0);
    1e10:	4501                	li	a0,0
    1e12:	0c5030ef          	jal	56d6 <exit>
            printf("%s: cannot create %s\n", s, name);
    1e16:	f9840613          	addi	a2,s0,-104
    1e1a:	85e6                	mv	a1,s9
    1e1c:	00005517          	auipc	a0,0x5
    1e20:	a8450513          	addi	a0,a0,-1404 # 68a0 <malloc+0xca8>
    1e24:	519030ef          	jal	5b3c <printf>
            exit(1);
    1e28:	4505                	li	a0,1
    1e2a:	0ad030ef          	jal	56d6 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1e2e:	86aa                	mv	a3,a0
    1e30:	660d                	lui	a2,0x3
    1e32:	85e6                	mv	a1,s9
    1e34:	00004517          	auipc	a0,0x4
    1e38:	fc450513          	addi	a0,a0,-60 # 5df8 <malloc+0x200>
    1e3c:	501030ef          	jal	5b3c <printf>
            exit(1);
    1e40:	4505                	li	a0,1
    1e42:	095030ef          	jal	56d6 <exit>
    1e46:	e0d2                	sd	s4,64(sp)
    1e48:	fc56                	sd	s5,56(sp)
    1e4a:	f85a                	sd	s6,48(sp)
    1e4c:	f45e                	sd	s7,40(sp)
    1e4e:	f062                	sd	s8,32(sp)
    1e50:	e86a                	sd	s10,16(sp)
      exit(st);
    1e52:	085030ef          	jal	56d6 <exit>

0000000000001e56 <copyinstr3>:
{
    1e56:	7179                	addi	sp,sp,-48
    1e58:	f406                	sd	ra,40(sp)
    1e5a:	f022                	sd	s0,32(sp)
    1e5c:	ec26                	sd	s1,24(sp)
    1e5e:	1800                	addi	s0,sp,48
  sbrk(8192);
    1e60:	6509                	lui	a0,0x2
    1e62:	041030ef          	jal	56a2 <sbrk>
  uint64 top = (uint64)sbrk(0);
    1e66:	4501                	li	a0,0
    1e68:	03b030ef          	jal	56a2 <sbrk>
  if ((top % PGSIZE) != 0) {
    1e6c:	03451793          	slli	a5,a0,0x34
    1e70:	e7bd                	bnez	a5,1ede <copyinstr3+0x88>
  top = (uint64)sbrk(0);
    1e72:	4501                	li	a0,0
    1e74:	02f030ef          	jal	56a2 <sbrk>
  if (top % PGSIZE) {
    1e78:	03451793          	slli	a5,a0,0x34
    1e7c:	ebad                	bnez	a5,1eee <copyinstr3+0x98>
  char *b = (char *)(top - 1);
    1e7e:	fff50493          	addi	s1,a0,-1 # 1fff <rwsbrk+0xa5>
  *b = 'x';
    1e82:	07800793          	li	a5,120
    1e86:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1e8a:	8526                	mv	a0,s1
    1e8c:	09b030ef          	jal	5726 <unlink>
  if (ret != -1) {
    1e90:	57fd                	li	a5,-1
    1e92:	06f51763          	bne	a0,a5,1f00 <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    1e96:	20100593          	li	a1,513
    1e9a:	8526                	mv	a0,s1
    1e9c:	07b030ef          	jal	5716 <open>
  if (fd != -1) {
    1ea0:	57fd                	li	a5,-1
    1ea2:	06f51a63          	bne	a0,a5,1f16 <copyinstr3+0xc0>
  ret = link(b, b);
    1ea6:	85a6                	mv	a1,s1
    1ea8:	8526                	mv	a0,s1
    1eaa:	08d030ef          	jal	5736 <link>
  if (ret != -1) {
    1eae:	57fd                	li	a5,-1
    1eb0:	06f51e63          	bne	a0,a5,1f2c <copyinstr3+0xd6>
  char *args[] = {"xx", 0};
    1eb4:	00005797          	auipc	a5,0x5
    1eb8:	6ec78793          	addi	a5,a5,1772 # 75a0 <malloc+0x19a8>
    1ebc:	fcf43823          	sd	a5,-48(s0)
    1ec0:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1ec4:	fd040593          	addi	a1,s0,-48
    1ec8:	8526                	mv	a0,s1
    1eca:	045030ef          	jal	570e <exec>
  if (ret != -1) {
    1ece:	57fd                	li	a5,-1
    1ed0:	06f51a63          	bne	a0,a5,1f44 <copyinstr3+0xee>
}
    1ed4:	70a2                	ld	ra,40(sp)
    1ed6:	7402                	ld	s0,32(sp)
    1ed8:	64e2                	ld	s1,24(sp)
    1eda:	6145                	addi	sp,sp,48
    1edc:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1ede:	0347d513          	srli	a0,a5,0x34
    1ee2:	6785                	lui	a5,0x1
    1ee4:	40a7853b          	subw	a0,a5,a0
    1ee8:	7ba030ef          	jal	56a2 <sbrk>
    1eec:	b759                	j	1e72 <copyinstr3+0x1c>
    printf("oops\n");
    1eee:	00005517          	auipc	a0,0x5
    1ef2:	9ca50513          	addi	a0,a0,-1590 # 68b8 <malloc+0xcc0>
    1ef6:	447030ef          	jal	5b3c <printf>
    exit(1);
    1efa:	4505                	li	a0,1
    1efc:	7da030ef          	jal	56d6 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1f00:	862a                	mv	a2,a0
    1f02:	85a6                	mv	a1,s1
    1f04:	00004517          	auipc	a0,0x4
    1f08:	5d450513          	addi	a0,a0,1492 # 64d8 <malloc+0x8e0>
    1f0c:	431030ef          	jal	5b3c <printf>
    exit(1);
    1f10:	4505                	li	a0,1
    1f12:	7c4030ef          	jal	56d6 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1f16:	862a                	mv	a2,a0
    1f18:	85a6                	mv	a1,s1
    1f1a:	00004517          	auipc	a0,0x4
    1f1e:	5de50513          	addi	a0,a0,1502 # 64f8 <malloc+0x900>
    1f22:	41b030ef          	jal	5b3c <printf>
    exit(1);
    1f26:	4505                	li	a0,1
    1f28:	7ae030ef          	jal	56d6 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1f2c:	86aa                	mv	a3,a0
    1f2e:	8626                	mv	a2,s1
    1f30:	85a6                	mv	a1,s1
    1f32:	00004517          	auipc	a0,0x4
    1f36:	5e650513          	addi	a0,a0,1510 # 6518 <malloc+0x920>
    1f3a:	403030ef          	jal	5b3c <printf>
    exit(1);
    1f3e:	4505                	li	a0,1
    1f40:	796030ef          	jal	56d6 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1f44:	863e                	mv	a2,a5
    1f46:	85a6                	mv	a1,s1
    1f48:	00004517          	auipc	a0,0x4
    1f4c:	5f850513          	addi	a0,a0,1528 # 6540 <malloc+0x948>
    1f50:	3ed030ef          	jal	5b3c <printf>
    exit(1);
    1f54:	4505                	li	a0,1
    1f56:	780030ef          	jal	56d6 <exit>

0000000000001f5a <rwsbrk>:
{
    1f5a:	1101                	addi	sp,sp,-32
    1f5c:	ec06                	sd	ra,24(sp)
    1f5e:	e822                	sd	s0,16(sp)
    1f60:	1000                	addi	s0,sp,32
  uint64 a = (uint64)sbrk(8192);
    1f62:	6509                	lui	a0,0x2
    1f64:	73e030ef          	jal	56a2 <sbrk>
  if (a == (uint64)SBRK_ERROR) {
    1f68:	57fd                	li	a5,-1
    1f6a:	04f50a63          	beq	a0,a5,1fbe <rwsbrk+0x64>
    1f6e:	e426                	sd	s1,8(sp)
    1f70:	84aa                	mv	s1,a0
  if (sbrk(-8192) == SBRK_ERROR) {
    1f72:	7579                	lui	a0,0xffffe
    1f74:	72e030ef          	jal	56a2 <sbrk>
    1f78:	57fd                	li	a5,-1
    1f7a:	04f50d63          	beq	a0,a5,1fd4 <rwsbrk+0x7a>
    1f7e:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE | O_WRONLY);
    1f80:	20100593          	li	a1,513
    1f84:	00005517          	auipc	a0,0x5
    1f88:	97450513          	addi	a0,a0,-1676 # 68f8 <malloc+0xd00>
    1f8c:	78a030ef          	jal	5716 <open>
    1f90:	892a                	mv	s2,a0
  if (fd < 0) {
    1f92:	04054b63          	bltz	a0,1fe8 <rwsbrk+0x8e>
  n = write(fd, (void *)(a + PGSIZE), 1024);
    1f96:	6785                	lui	a5,0x1
    1f98:	94be                	add	s1,s1,a5
    1f9a:	40000613          	li	a2,1024
    1f9e:	85a6                	mv	a1,s1
    1fa0:	756030ef          	jal	56f6 <write>
    1fa4:	862a                	mv	a2,a0
  if (n >= 0) {
    1fa6:	04054a63          	bltz	a0,1ffa <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void *)a + PGSIZE, n);
    1faa:	85a6                	mv	a1,s1
    1fac:	00005517          	auipc	a0,0x5
    1fb0:	96c50513          	addi	a0,a0,-1684 # 6918 <malloc+0xd20>
    1fb4:	389030ef          	jal	5b3c <printf>
    exit(1);
    1fb8:	4505                	li	a0,1
    1fba:	71c030ef          	jal	56d6 <exit>
    1fbe:	e426                	sd	s1,8(sp)
    1fc0:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    1fc2:	00005517          	auipc	a0,0x5
    1fc6:	8fe50513          	addi	a0,a0,-1794 # 68c0 <malloc+0xcc8>
    1fca:	373030ef          	jal	5b3c <printf>
    exit(1);
    1fce:	4505                	li	a0,1
    1fd0:	706030ef          	jal	56d6 <exit>
    1fd4:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    1fd6:	00005517          	auipc	a0,0x5
    1fda:	90250513          	addi	a0,a0,-1790 # 68d8 <malloc+0xce0>
    1fde:	35f030ef          	jal	5b3c <printf>
    exit(1);
    1fe2:	4505                	li	a0,1
    1fe4:	6f2030ef          	jal	56d6 <exit>
    printf("open(rwsbrk) failed\n");
    1fe8:	00005517          	auipc	a0,0x5
    1fec:	91850513          	addi	a0,a0,-1768 # 6900 <malloc+0xd08>
    1ff0:	34d030ef          	jal	5b3c <printf>
    exit(1);
    1ff4:	4505                	li	a0,1
    1ff6:	6e0030ef          	jal	56d6 <exit>
  close(fd);
    1ffa:	854a                	mv	a0,s2
    1ffc:	702030ef          	jal	56fe <close>
  unlink("rwsbrk");
    2000:	00005517          	auipc	a0,0x5
    2004:	8f850513          	addi	a0,a0,-1800 # 68f8 <malloc+0xd00>
    2008:	71e030ef          	jal	5726 <unlink>
  fd = open("README", O_RDONLY);
    200c:	4581                	li	a1,0
    200e:	00004517          	auipc	a0,0x4
    2012:	ef250513          	addi	a0,a0,-270 # 5f00 <malloc+0x308>
    2016:	700030ef          	jal	5716 <open>
    201a:	892a                	mv	s2,a0
  if (fd < 0) {
    201c:	02054363          	bltz	a0,2042 <rwsbrk+0xe8>
  n = read(fd, (void *)(a + PGSIZE), 10);
    2020:	4629                	li	a2,10
    2022:	85a6                	mv	a1,s1
    2024:	6ca030ef          	jal	56ee <read>
    2028:	862a                	mv	a2,a0
  if (n >= 0) {
    202a:	02054563          	bltz	a0,2054 <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void *)a + PGSIZE, n);
    202e:	85a6                	mv	a1,s1
    2030:	00005517          	auipc	a0,0x5
    2034:	91850513          	addi	a0,a0,-1768 # 6948 <malloc+0xd50>
    2038:	305030ef          	jal	5b3c <printf>
    exit(1);
    203c:	4505                	li	a0,1
    203e:	698030ef          	jal	56d6 <exit>
    printf("open(README) failed\n");
    2042:	00004517          	auipc	a0,0x4
    2046:	ec650513          	addi	a0,a0,-314 # 5f08 <malloc+0x310>
    204a:	2f3030ef          	jal	5b3c <printf>
    exit(1);
    204e:	4505                	li	a0,1
    2050:	686030ef          	jal	56d6 <exit>
  close(fd);
    2054:	854a                	mv	a0,s2
    2056:	6a8030ef          	jal	56fe <close>
  exit(0);
    205a:	4501                	li	a0,0
    205c:	67a030ef          	jal	56d6 <exit>

0000000000002060 <sbrkbasic>:
{
    2060:	715d                	addi	sp,sp,-80
    2062:	e486                	sd	ra,72(sp)
    2064:	e0a2                	sd	s0,64(sp)
    2066:	ec56                	sd	s5,24(sp)
    2068:	0880                	addi	s0,sp,80
    206a:	8aaa                	mv	s5,a0
  pid = fork();
    206c:	662030ef          	jal	56ce <fork>
  if (pid < 0) {
    2070:	02054c63          	bltz	a0,20a8 <sbrkbasic+0x48>
  if (pid == 0) {
    2074:	ed31                	bnez	a0,20d0 <sbrkbasic+0x70>
    a = sbrk(TOOMUCH);
    2076:	40000537          	lui	a0,0x40000
    207a:	628030ef          	jal	56a2 <sbrk>
    if (a == (char *)SBRK_ERROR) {
    207e:	57fd                	li	a5,-1
    2080:	04f50163          	beq	a0,a5,20c2 <sbrkbasic+0x62>
    2084:	fc26                	sd	s1,56(sp)
    2086:	f84a                	sd	s2,48(sp)
    2088:	f44e                	sd	s3,40(sp)
    208a:	f052                	sd	s4,32(sp)
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    208c:	400007b7          	lui	a5,0x40000
    2090:	97aa                	add	a5,a5,a0
      *b = 99;
    2092:	06300693          	li	a3,99
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    2096:	6705                	lui	a4,0x1
      *b = 99;
    2098:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3ffef318>
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    209c:	953a                	add	a0,a0,a4
    209e:	fef51de3          	bne	a0,a5,2098 <sbrkbasic+0x38>
    exit(1);
    20a2:	4505                	li	a0,1
    20a4:	632030ef          	jal	56d6 <exit>
    20a8:	fc26                	sd	s1,56(sp)
    20aa:	f84a                	sd	s2,48(sp)
    20ac:	f44e                	sd	s3,40(sp)
    20ae:	f052                	sd	s4,32(sp)
    printf("fork failed in sbrkbasic\n");
    20b0:	00005517          	auipc	a0,0x5
    20b4:	8c050513          	addi	a0,a0,-1856 # 6970 <malloc+0xd78>
    20b8:	285030ef          	jal	5b3c <printf>
    exit(1);
    20bc:	4505                	li	a0,1
    20be:	618030ef          	jal	56d6 <exit>
    20c2:	fc26                	sd	s1,56(sp)
    20c4:	f84a                	sd	s2,48(sp)
    20c6:	f44e                	sd	s3,40(sp)
    20c8:	f052                	sd	s4,32(sp)
      exit(0);
    20ca:	4501                	li	a0,0
    20cc:	60a030ef          	jal	56d6 <exit>
  wait(&xstatus);
    20d0:	fbc40513          	addi	a0,s0,-68
    20d4:	60a030ef          	jal	56de <wait>
  if (xstatus == 1) {
    20d8:	fbc42703          	lw	a4,-68(s0)
    20dc:	4785                	li	a5,1
    20de:	02f70063          	beq	a4,a5,20fe <sbrkbasic+0x9e>
    20e2:	fc26                	sd	s1,56(sp)
    20e4:	f84a                	sd	s2,48(sp)
    20e6:	f44e                	sd	s3,40(sp)
    20e8:	f052                	sd	s4,32(sp)
  a = sbrk(0);
    20ea:	4501                	li	a0,0
    20ec:	5b6030ef          	jal	56a2 <sbrk>
    20f0:	84aa                	mv	s1,a0
  for (i = 0; i < 5000; i++) {
    20f2:	4901                	li	s2,0
    b = sbrk(1);
    20f4:	4985                	li	s3,1
  for (i = 0; i < 5000; i++) {
    20f6:	6a05                	lui	s4,0x1
    20f8:	388a0a13          	addi	s4,s4,904 # 1388 <truncate3+0x14a>
    20fc:	a005                	j	211c <sbrkbasic+0xbc>
    20fe:	fc26                	sd	s1,56(sp)
    2100:	f84a                	sd	s2,48(sp)
    2102:	f44e                	sd	s3,40(sp)
    2104:	f052                	sd	s4,32(sp)
    printf("%s: too much memory allocated!\n", s);
    2106:	85d6                	mv	a1,s5
    2108:	00005517          	auipc	a0,0x5
    210c:	88850513          	addi	a0,a0,-1912 # 6990 <malloc+0xd98>
    2110:	22d030ef          	jal	5b3c <printf>
    exit(1);
    2114:	4505                	li	a0,1
    2116:	5c0030ef          	jal	56d6 <exit>
  for (i = 0; i < 5000; i++) {
    211a:	84be                	mv	s1,a5
    b = sbrk(1);
    211c:	854e                	mv	a0,s3
    211e:	584030ef          	jal	56a2 <sbrk>
    if (b != a) {
    2122:	04951163          	bne	a0,s1,2164 <sbrkbasic+0x104>
    *b = 1;
    2126:	01348023          	sb	s3,0(s1)
    a = b + 1;
    212a:	00148793          	addi	a5,s1,1
  for (i = 0; i < 5000; i++) {
    212e:	2905                	addiw	s2,s2,1
    2130:	ff4915e3          	bne	s2,s4,211a <sbrkbasic+0xba>
  pid = fork();
    2134:	59a030ef          	jal	56ce <fork>
    2138:	892a                	mv	s2,a0
  if (pid < 0) {
    213a:	04054263          	bltz	a0,217e <sbrkbasic+0x11e>
  c = sbrk(1);
    213e:	4505                	li	a0,1
    2140:	562030ef          	jal	56a2 <sbrk>
  c = sbrk(1);
    2144:	4505                	li	a0,1
    2146:	55c030ef          	jal	56a2 <sbrk>
  if (c != a + 1) {
    214a:	0489                	addi	s1,s1,2
    214c:	04950363          	beq	a0,s1,2192 <sbrkbasic+0x132>
    printf("%s: sbrk test failed post-fork\n", s);
    2150:	85d6                	mv	a1,s5
    2152:	00005517          	auipc	a0,0x5
    2156:	89e50513          	addi	a0,a0,-1890 # 69f0 <malloc+0xdf8>
    215a:	1e3030ef          	jal	5b3c <printf>
    exit(1);
    215e:	4505                	li	a0,1
    2160:	576030ef          	jal	56d6 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    2164:	872a                	mv	a4,a0
    2166:	86a6                	mv	a3,s1
    2168:	864a                	mv	a2,s2
    216a:	85d6                	mv	a1,s5
    216c:	00005517          	auipc	a0,0x5
    2170:	84450513          	addi	a0,a0,-1980 # 69b0 <malloc+0xdb8>
    2174:	1c9030ef          	jal	5b3c <printf>
      exit(1);
    2178:	4505                	li	a0,1
    217a:	55c030ef          	jal	56d6 <exit>
    printf("%s: sbrk test fork failed\n", s);
    217e:	85d6                	mv	a1,s5
    2180:	00005517          	auipc	a0,0x5
    2184:	85050513          	addi	a0,a0,-1968 # 69d0 <malloc+0xdd8>
    2188:	1b5030ef          	jal	5b3c <printf>
    exit(1);
    218c:	4505                	li	a0,1
    218e:	548030ef          	jal	56d6 <exit>
  if (pid == 0)
    2192:	00091563          	bnez	s2,219c <sbrkbasic+0x13c>
    exit(0);
    2196:	4501                	li	a0,0
    2198:	53e030ef          	jal	56d6 <exit>
  wait(&xstatus);
    219c:	fbc40513          	addi	a0,s0,-68
    21a0:	53e030ef          	jal	56de <wait>
  exit(xstatus);
    21a4:	fbc42503          	lw	a0,-68(s0)
    21a8:	52e030ef          	jal	56d6 <exit>

00000000000021ac <sbrkmuch>:
{
    21ac:	7179                	addi	sp,sp,-48
    21ae:	f406                	sd	ra,40(sp)
    21b0:	f022                	sd	s0,32(sp)
    21b2:	ec26                	sd	s1,24(sp)
    21b4:	e84a                	sd	s2,16(sp)
    21b6:	e44e                	sd	s3,8(sp)
    21b8:	e052                	sd	s4,0(sp)
    21ba:	1800                	addi	s0,sp,48
    21bc:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    21be:	4501                	li	a0,0
    21c0:	4e2030ef          	jal	56a2 <sbrk>
    21c4:	892a                	mv	s2,a0
  a = sbrk(0);
    21c6:	4501                	li	a0,0
    21c8:	4da030ef          	jal	56a2 <sbrk>
    21cc:	84aa                	mv	s1,a0
  p = sbrk(amt);
    21ce:	06400537          	lui	a0,0x6400
    21d2:	9d05                	subw	a0,a0,s1
    21d4:	4ce030ef          	jal	56a2 <sbrk>
  if (p != a) {
    21d8:	08a49763          	bne	s1,a0,2266 <sbrkmuch+0xba>
  *lastaddr = 99;
    21dc:	064007b7          	lui	a5,0x6400
    21e0:	06300713          	li	a4,99
    21e4:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63ef317>
  a = sbrk(0);
    21e8:	4501                	li	a0,0
    21ea:	4b8030ef          	jal	56a2 <sbrk>
    21ee:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    21f0:	757d                	lui	a0,0xfffff
    21f2:	4b0030ef          	jal	56a2 <sbrk>
  if (c == (char *)SBRK_ERROR) {
    21f6:	57fd                	li	a5,-1
    21f8:	08f50163          	beq	a0,a5,227a <sbrkmuch+0xce>
  c = sbrk(0);
    21fc:	4501                	li	a0,0
    21fe:	4a4030ef          	jal	56a2 <sbrk>
  if (c != a - PGSIZE) {
    2202:	77fd                	lui	a5,0xfffff
    2204:	97a6                	add	a5,a5,s1
    2206:	08f51463          	bne	a0,a5,228e <sbrkmuch+0xe2>
  a = sbrk(0);
    220a:	4501                	li	a0,0
    220c:	496030ef          	jal	56a2 <sbrk>
    2210:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2212:	6505                	lui	a0,0x1
    2214:	48e030ef          	jal	56a2 <sbrk>
    2218:	8a2a                	mv	s4,a0
  if (c != a || sbrk(0) != a + PGSIZE) {
    221a:	08a49663          	bne	s1,a0,22a6 <sbrkmuch+0xfa>
    221e:	4501                	li	a0,0
    2220:	482030ef          	jal	56a2 <sbrk>
    2224:	6785                	lui	a5,0x1
    2226:	97a6                	add	a5,a5,s1
    2228:	06f51f63          	bne	a0,a5,22a6 <sbrkmuch+0xfa>
  if (*lastaddr == 99) {
    222c:	064007b7          	lui	a5,0x6400
    2230:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63ef317>
    2234:	06300793          	li	a5,99
    2238:	08f70363          	beq	a4,a5,22be <sbrkmuch+0x112>
  a = sbrk(0);
    223c:	4501                	li	a0,0
    223e:	464030ef          	jal	56a2 <sbrk>
    2242:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2244:	4501                	li	a0,0
    2246:	45c030ef          	jal	56a2 <sbrk>
    224a:	40a9053b          	subw	a0,s2,a0
    224e:	454030ef          	jal	56a2 <sbrk>
  if (c != a) {
    2252:	08a49063          	bne	s1,a0,22d2 <sbrkmuch+0x126>
}
    2256:	70a2                	ld	ra,40(sp)
    2258:	7402                	ld	s0,32(sp)
    225a:	64e2                	ld	s1,24(sp)
    225c:	6942                	ld	s2,16(sp)
    225e:	69a2                	ld	s3,8(sp)
    2260:	6a02                	ld	s4,0(sp)
    2262:	6145                	addi	sp,sp,48
    2264:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n",
    2266:	85ce                	mv	a1,s3
    2268:	00004517          	auipc	a0,0x4
    226c:	7a850513          	addi	a0,a0,1960 # 6a10 <malloc+0xe18>
    2270:	0cd030ef          	jal	5b3c <printf>
    exit(1);
    2274:	4505                	li	a0,1
    2276:	460030ef          	jal	56d6 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    227a:	85ce                	mv	a1,s3
    227c:	00004517          	auipc	a0,0x4
    2280:	7dc50513          	addi	a0,a0,2012 # 6a58 <malloc+0xe60>
    2284:	0b9030ef          	jal	5b3c <printf>
    exit(1);
    2288:	4505                	li	a0,1
    228a:	44c030ef          	jal	56d6 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a,
    228e:	86aa                	mv	a3,a0
    2290:	8626                	mv	a2,s1
    2292:	85ce                	mv	a1,s3
    2294:	00004517          	auipc	a0,0x4
    2298:	7e450513          	addi	a0,a0,2020 # 6a78 <malloc+0xe80>
    229c:	0a1030ef          	jal	5b3c <printf>
    exit(1);
    22a0:	4505                	li	a0,1
    22a2:	434030ef          	jal	56d6 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    22a6:	86d2                	mv	a3,s4
    22a8:	8626                	mv	a2,s1
    22aa:	85ce                	mv	a1,s3
    22ac:	00005517          	auipc	a0,0x5
    22b0:	80c50513          	addi	a0,a0,-2036 # 6ab8 <malloc+0xec0>
    22b4:	089030ef          	jal	5b3c <printf>
    exit(1);
    22b8:	4505                	li	a0,1
    22ba:	41c030ef          	jal	56d6 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    22be:	85ce                	mv	a1,s3
    22c0:	00005517          	auipc	a0,0x5
    22c4:	82850513          	addi	a0,a0,-2008 # 6ae8 <malloc+0xef0>
    22c8:	075030ef          	jal	5b3c <printf>
    exit(1);
    22cc:	4505                	li	a0,1
    22ce:	408030ef          	jal	56d6 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    22d2:	86aa                	mv	a3,a0
    22d4:	8626                	mv	a2,s1
    22d6:	85ce                	mv	a1,s3
    22d8:	00005517          	auipc	a0,0x5
    22dc:	84850513          	addi	a0,a0,-1976 # 6b20 <malloc+0xf28>
    22e0:	05d030ef          	jal	5b3c <printf>
    exit(1);
    22e4:	4505                	li	a0,1
    22e6:	3f0030ef          	jal	56d6 <exit>

00000000000022ea <sbrkarg>:
{
    22ea:	7179                	addi	sp,sp,-48
    22ec:	f406                	sd	ra,40(sp)
    22ee:	f022                	sd	s0,32(sp)
    22f0:	ec26                	sd	s1,24(sp)
    22f2:	e84a                	sd	s2,16(sp)
    22f4:	e44e                	sd	s3,8(sp)
    22f6:	1800                	addi	s0,sp,48
    22f8:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    22fa:	6505                	lui	a0,0x1
    22fc:	3a6030ef          	jal	56a2 <sbrk>
    2300:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE | O_WRONLY);
    2302:	20100593          	li	a1,513
    2306:	00005517          	auipc	a0,0x5
    230a:	84250513          	addi	a0,a0,-1982 # 6b48 <malloc+0xf50>
    230e:	408030ef          	jal	5716 <open>
    2312:	84aa                	mv	s1,a0
  unlink("sbrk");
    2314:	00005517          	auipc	a0,0x5
    2318:	83450513          	addi	a0,a0,-1996 # 6b48 <malloc+0xf50>
    231c:	40a030ef          	jal	5726 <unlink>
  if (fd < 0) {
    2320:	0204c963          	bltz	s1,2352 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2324:	6605                	lui	a2,0x1
    2326:	85ca                	mv	a1,s2
    2328:	8526                	mv	a0,s1
    232a:	3cc030ef          	jal	56f6 <write>
    232e:	02054c63          	bltz	a0,2366 <sbrkarg+0x7c>
  close(fd);
    2332:	8526                	mv	a0,s1
    2334:	3ca030ef          	jal	56fe <close>
  a = sbrk(PGSIZE);
    2338:	6505                	lui	a0,0x1
    233a:	368030ef          	jal	56a2 <sbrk>
  if (pipe((int *)a) != 0) {
    233e:	3a8030ef          	jal	56e6 <pipe>
    2342:	ed05                	bnez	a0,237a <sbrkarg+0x90>
}
    2344:	70a2                	ld	ra,40(sp)
    2346:	7402                	ld	s0,32(sp)
    2348:	64e2                	ld	s1,24(sp)
    234a:	6942                	ld	s2,16(sp)
    234c:	69a2                	ld	s3,8(sp)
    234e:	6145                	addi	sp,sp,48
    2350:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2352:	85ce                	mv	a1,s3
    2354:	00004517          	auipc	a0,0x4
    2358:	7fc50513          	addi	a0,a0,2044 # 6b50 <malloc+0xf58>
    235c:	7e0030ef          	jal	5b3c <printf>
    exit(1);
    2360:	4505                	li	a0,1
    2362:	374030ef          	jal	56d6 <exit>
    printf("%s: write sbrk failed\n", s);
    2366:	85ce                	mv	a1,s3
    2368:	00005517          	auipc	a0,0x5
    236c:	80050513          	addi	a0,a0,-2048 # 6b68 <malloc+0xf70>
    2370:	7cc030ef          	jal	5b3c <printf>
    exit(1);
    2374:	4505                	li	a0,1
    2376:	360030ef          	jal	56d6 <exit>
    printf("%s: pipe() failed\n", s);
    237a:	85ce                	mv	a1,s3
    237c:	00004517          	auipc	a0,0x4
    2380:	2c450513          	addi	a0,a0,708 # 6640 <malloc+0xa48>
    2384:	7b8030ef          	jal	5b3c <printf>
    exit(1);
    2388:	4505                	li	a0,1
    238a:	34c030ef          	jal	56d6 <exit>

000000000000238e <argptest>:
{
    238e:	1101                	addi	sp,sp,-32
    2390:	ec06                	sd	ra,24(sp)
    2392:	e822                	sd	s0,16(sp)
    2394:	e426                	sd	s1,8(sp)
    2396:	e04a                	sd	s2,0(sp)
    2398:	1000                	addi	s0,sp,32
    239a:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    239c:	4581                	li	a1,0
    239e:	00004517          	auipc	a0,0x4
    23a2:	7e250513          	addi	a0,a0,2018 # 6b80 <malloc+0xf88>
    23a6:	370030ef          	jal	5716 <open>
  if (fd < 0) {
    23aa:	02054563          	bltz	a0,23d4 <argptest+0x46>
    23ae:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    23b0:	4501                	li	a0,0
    23b2:	2f0030ef          	jal	56a2 <sbrk>
    23b6:	567d                	li	a2,-1
    23b8:	00c505b3          	add	a1,a0,a2
    23bc:	8526                	mv	a0,s1
    23be:	330030ef          	jal	56ee <read>
  close(fd);
    23c2:	8526                	mv	a0,s1
    23c4:	33a030ef          	jal	56fe <close>
}
    23c8:	60e2                	ld	ra,24(sp)
    23ca:	6442                	ld	s0,16(sp)
    23cc:	64a2                	ld	s1,8(sp)
    23ce:	6902                	ld	s2,0(sp)
    23d0:	6105                	addi	sp,sp,32
    23d2:	8082                	ret
    printf("%s: open failed\n", s);
    23d4:	85ca                	mv	a1,s2
    23d6:	00004517          	auipc	a0,0x4
    23da:	1fa50513          	addi	a0,a0,506 # 65d0 <malloc+0x9d8>
    23de:	75e030ef          	jal	5b3c <printf>
    exit(1);
    23e2:	4505                	li	a0,1
    23e4:	2f2030ef          	jal	56d6 <exit>

00000000000023e8 <sbrkbugs>:
{
    23e8:	1141                	addi	sp,sp,-16
    23ea:	e406                	sd	ra,8(sp)
    23ec:	e022                	sd	s0,0(sp)
    23ee:	0800                	addi	s0,sp,16
  int pid = fork();
    23f0:	2de030ef          	jal	56ce <fork>
  if (pid < 0) {
    23f4:	00054c63          	bltz	a0,240c <sbrkbugs+0x24>
  if (pid == 0) {
    23f8:	e11d                	bnez	a0,241e <sbrkbugs+0x36>
    int sz = (uint64)sbrk(0);
    23fa:	2a8030ef          	jal	56a2 <sbrk>
    sbrk(-sz);
    23fe:	40a0053b          	negw	a0,a0
    2402:	2a0030ef          	jal	56a2 <sbrk>
    exit(0);
    2406:	4501                	li	a0,0
    2408:	2ce030ef          	jal	56d6 <exit>
    printf("fork failed\n");
    240c:	00006517          	auipc	a0,0x6
    2410:	86c50513          	addi	a0,a0,-1940 # 7c78 <malloc+0x2080>
    2414:	728030ef          	jal	5b3c <printf>
    exit(1);
    2418:	4505                	li	a0,1
    241a:	2bc030ef          	jal	56d6 <exit>
  wait(0);
    241e:	4501                	li	a0,0
    2420:	2be030ef          	jal	56de <wait>
  pid = fork();
    2424:	2aa030ef          	jal	56ce <fork>
  if (pid < 0) {
    2428:	00054f63          	bltz	a0,2446 <sbrkbugs+0x5e>
  if (pid == 0) {
    242c:	e515                	bnez	a0,2458 <sbrkbugs+0x70>
    int sz = (uint64)sbrk(0);
    242e:	274030ef          	jal	56a2 <sbrk>
    sbrk(-(sz - 3500));
    2432:	6785                	lui	a5,0x1
    2434:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0xe2>
    2438:	40a7853b          	subw	a0,a5,a0
    243c:	266030ef          	jal	56a2 <sbrk>
    exit(0);
    2440:	4501                	li	a0,0
    2442:	294030ef          	jal	56d6 <exit>
    printf("fork failed\n");
    2446:	00006517          	auipc	a0,0x6
    244a:	83250513          	addi	a0,a0,-1998 # 7c78 <malloc+0x2080>
    244e:	6ee030ef          	jal	5b3c <printf>
    exit(1);
    2452:	4505                	li	a0,1
    2454:	282030ef          	jal	56d6 <exit>
  wait(0);
    2458:	4501                	li	a0,0
    245a:	284030ef          	jal	56de <wait>
  pid = fork();
    245e:	270030ef          	jal	56ce <fork>
  if (pid < 0) {
    2462:	02054263          	bltz	a0,2486 <sbrkbugs+0x9e>
  if (pid == 0) {
    2466:	e90d                	bnez	a0,2498 <sbrkbugs+0xb0>
    sbrk((10 * PGSIZE + 2048) - (uint64)sbrk(0));
    2468:	23a030ef          	jal	56a2 <sbrk>
    246c:	67ad                	lui	a5,0xb
    246e:	8007879b          	addiw	a5,a5,-2048 # a800 <big.0+0x230>
    2472:	40a7853b          	subw	a0,a5,a0
    2476:	22c030ef          	jal	56a2 <sbrk>
    sbrk(-10);
    247a:	5559                	li	a0,-10
    247c:	226030ef          	jal	56a2 <sbrk>
    exit(0);
    2480:	4501                	li	a0,0
    2482:	254030ef          	jal	56d6 <exit>
    printf("fork failed\n");
    2486:	00005517          	auipc	a0,0x5
    248a:	7f250513          	addi	a0,a0,2034 # 7c78 <malloc+0x2080>
    248e:	6ae030ef          	jal	5b3c <printf>
    exit(1);
    2492:	4505                	li	a0,1
    2494:	242030ef          	jal	56d6 <exit>
  wait(0);
    2498:	4501                	li	a0,0
    249a:	244030ef          	jal	56de <wait>
  exit(0);
    249e:	4501                	li	a0,0
    24a0:	236030ef          	jal	56d6 <exit>

00000000000024a4 <sbrklast>:
{
    24a4:	7179                	addi	sp,sp,-48
    24a6:	f406                	sd	ra,40(sp)
    24a8:	f022                	sd	s0,32(sp)
    24aa:	ec26                	sd	s1,24(sp)
    24ac:	e84a                	sd	s2,16(sp)
    24ae:	e44e                	sd	s3,8(sp)
    24b0:	e052                	sd	s4,0(sp)
    24b2:	1800                	addi	s0,sp,48
  uint64 top = (uint64)sbrk(0);
    24b4:	4501                	li	a0,0
    24b6:	1ec030ef          	jal	56a2 <sbrk>
  if ((top % PGSIZE) != 0)
    24ba:	03451793          	slli	a5,a0,0x34
    24be:	ebad                	bnez	a5,2530 <sbrklast+0x8c>
  sbrk(PGSIZE);
    24c0:	6505                	lui	a0,0x1
    24c2:	1e0030ef          	jal	56a2 <sbrk>
  sbrk(10);
    24c6:	4529                	li	a0,10
    24c8:	1da030ef          	jal	56a2 <sbrk>
  sbrk(-20);
    24cc:	5531                	li	a0,-20
    24ce:	1d4030ef          	jal	56a2 <sbrk>
  top = (uint64)sbrk(0);
    24d2:	4501                	li	a0,0
    24d4:	1ce030ef          	jal	56a2 <sbrk>
    24d8:	84aa                	mv	s1,a0
  char *p = (char *)(top - 64);
    24da:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0xcc>
  p[0] = 'x';
    24de:	07800993          	li	s3,120
    24e2:	fd350023          	sb	s3,-64(a0)
  p[1] = '\0';
    24e6:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR | O_CREATE);
    24ea:	20200593          	li	a1,514
    24ee:	854a                	mv	a0,s2
    24f0:	226030ef          	jal	5716 <open>
    24f4:	8a2a                	mv	s4,a0
  write(fd, p, 1);
    24f6:	4605                	li	a2,1
    24f8:	85ca                	mv	a1,s2
    24fa:	1fc030ef          	jal	56f6 <write>
  close(fd);
    24fe:	8552                	mv	a0,s4
    2500:	1fe030ef          	jal	56fe <close>
  fd = open(p, O_RDWR);
    2504:	4589                	li	a1,2
    2506:	854a                	mv	a0,s2
    2508:	20e030ef          	jal	5716 <open>
  p[0] = '\0';
    250c:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2510:	4605                	li	a2,1
    2512:	85ca                	mv	a1,s2
    2514:	1da030ef          	jal	56ee <read>
  if (p[0] != 'x')
    2518:	fc04c783          	lbu	a5,-64(s1)
    251c:	03379263          	bne	a5,s3,2540 <sbrklast+0x9c>
}
    2520:	70a2                	ld	ra,40(sp)
    2522:	7402                	ld	s0,32(sp)
    2524:	64e2                	ld	s1,24(sp)
    2526:	6942                	ld	s2,16(sp)
    2528:	69a2                	ld	s3,8(sp)
    252a:	6a02                	ld	s4,0(sp)
    252c:	6145                	addi	sp,sp,48
    252e:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2530:	0347d513          	srli	a0,a5,0x34
    2534:	6785                	lui	a5,0x1
    2536:	40a7853b          	subw	a0,a5,a0
    253a:	168030ef          	jal	56a2 <sbrk>
    253e:	b749                	j	24c0 <sbrklast+0x1c>
    exit(1);
    2540:	4505                	li	a0,1
    2542:	194030ef          	jal	56d6 <exit>

0000000000002546 <sbrk8000>:
{
    2546:	1141                	addi	sp,sp,-16
    2548:	e406                	sd	ra,8(sp)
    254a:	e022                	sd	s0,0(sp)
    254c:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    254e:	80000537          	lui	a0,0x80000
    2552:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7ffef31c>
    2554:	14e030ef          	jal	56a2 <sbrk>
  volatile char *top = sbrk(0);
    2558:	4501                	li	a0,0
    255a:	148030ef          	jal	56a2 <sbrk>
  *(top - 1) = *(top - 1) + 1;
    255e:	fff54783          	lbu	a5,-1(a0)
    2562:	2785                	addiw	a5,a5,1 # 1001 <bigdir+0x10d>
    2564:	fef50fa3          	sb	a5,-1(a0)
}
    2568:	60a2                	ld	ra,8(sp)
    256a:	6402                	ld	s0,0(sp)
    256c:	0141                	addi	sp,sp,16
    256e:	8082                	ret

0000000000002570 <execout>:
{
    2570:	711d                	addi	sp,sp,-96
    2572:	ec86                	sd	ra,88(sp)
    2574:	e8a2                	sd	s0,80(sp)
    2576:	e4a6                	sd	s1,72(sp)
    2578:	e0ca                	sd	s2,64(sp)
    257a:	fc4e                	sd	s3,56(sp)
    257c:	1080                	addi	s0,sp,96
  for (int avail = 0; avail < 15; avail++) {
    257e:	4901                	li	s2,0
    2580:	49bd                	li	s3,15
    int pid = fork();
    2582:	14c030ef          	jal	56ce <fork>
    2586:	84aa                	mv	s1,a0
    if (pid < 0) {
    2588:	00054e63          	bltz	a0,25a4 <execout+0x34>
    } else if (pid == 0) {
    258c:	c51d                	beqz	a0,25ba <execout+0x4a>
      wait((int *)0);
    258e:	4501                	li	a0,0
    2590:	14e030ef          	jal	56de <wait>
  for (int avail = 0; avail < 15; avail++) {
    2594:	2905                	addiw	s2,s2,1
    2596:	ff3916e3          	bne	s2,s3,2582 <execout+0x12>
    259a:	f852                	sd	s4,48(sp)
    259c:	f456                	sd	s5,40(sp)
  exit(0);
    259e:	4501                	li	a0,0
    25a0:	136030ef          	jal	56d6 <exit>
    25a4:	f852                	sd	s4,48(sp)
    25a6:	f456                	sd	s5,40(sp)
      printf("fork failed\n");
    25a8:	00005517          	auipc	a0,0x5
    25ac:	6d050513          	addi	a0,a0,1744 # 7c78 <malloc+0x2080>
    25b0:	58c030ef          	jal	5b3c <printf>
      exit(1);
    25b4:	4505                	li	a0,1
    25b6:	120030ef          	jal	56d6 <exit>
    25ba:	f852                	sd	s4,48(sp)
    25bc:	f456                	sd	s5,40(sp)
        char *a = sbrk(PGSIZE);
    25be:	6985                	lui	s3,0x1
        if (a == SBRK_ERROR)
    25c0:	5a7d                	li	s4,-1
        *(a + PGSIZE - 1) = 1;
    25c2:	4a85                	li	s5,1
        char *a = sbrk(PGSIZE);
    25c4:	854e                	mv	a0,s3
    25c6:	0dc030ef          	jal	56a2 <sbrk>
        if (a == SBRK_ERROR)
    25ca:	01450663          	beq	a0,s4,25d6 <execout+0x66>
        *(a + PGSIZE - 1) = 1;
    25ce:	954e                	add	a0,a0,s3
    25d0:	ff550fa3          	sb	s5,-1(a0)
      while (1) {
    25d4:	bfc5                	j	25c4 <execout+0x54>
        sbrk(-PGSIZE);
    25d6:	79fd                	lui	s3,0xfffff
      for (int i = 0; i < avail; i++)
    25d8:	01205863          	blez	s2,25e8 <execout+0x78>
        sbrk(-PGSIZE);
    25dc:	854e                	mv	a0,s3
    25de:	0c4030ef          	jal	56a2 <sbrk>
      for (int i = 0; i < avail; i++)
    25e2:	2485                	addiw	s1,s1,1
    25e4:	ff249ce3          	bne	s1,s2,25dc <execout+0x6c>
      close(1);
    25e8:	4505                	li	a0,1
    25ea:	114030ef          	jal	56fe <close>
      char *args[] = {"echo", "x", 0};
    25ee:	00003797          	auipc	a5,0x3
    25f2:	73a78793          	addi	a5,a5,1850 # 5d28 <malloc+0x130>
    25f6:	faf43423          	sd	a5,-88(s0)
    25fa:	00003797          	auipc	a5,0x3
    25fe:	79e78793          	addi	a5,a5,1950 # 5d98 <malloc+0x1a0>
    2602:	faf43823          	sd	a5,-80(s0)
    2606:	fa043c23          	sd	zero,-72(s0)
      exec("echo", args);
    260a:	fa840593          	addi	a1,s0,-88
    260e:	00003517          	auipc	a0,0x3
    2612:	71a50513          	addi	a0,a0,1818 # 5d28 <malloc+0x130>
    2616:	0f8030ef          	jal	570e <exec>
      exit(0);
    261a:	4501                	li	a0,0
    261c:	0ba030ef          	jal	56d6 <exit>

0000000000002620 <fourteen>:
{
    2620:	1101                	addi	sp,sp,-32
    2622:	ec06                	sd	ra,24(sp)
    2624:	e822                	sd	s0,16(sp)
    2626:	e426                	sd	s1,8(sp)
    2628:	1000                	addi	s0,sp,32
    262a:	84aa                	mv	s1,a0
  if (mkdir("12345678901234") != 0) {
    262c:	00004517          	auipc	a0,0x4
    2630:	72c50513          	addi	a0,a0,1836 # 6d58 <malloc+0x1160>
    2634:	10a030ef          	jal	573e <mkdir>
    2638:	e555                	bnez	a0,26e4 <fourteen+0xc4>
  if (mkdir("12345678901234/123456789012345") != 0) {
    263a:	00004517          	auipc	a0,0x4
    263e:	57650513          	addi	a0,a0,1398 # 6bb0 <malloc+0xfb8>
    2642:	0fc030ef          	jal	573e <mkdir>
    2646:	e94d                	bnez	a0,26f8 <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2648:	20000593          	li	a1,512
    264c:	00004517          	auipc	a0,0x4
    2650:	5bc50513          	addi	a0,a0,1468 # 6c08 <malloc+0x1010>
    2654:	0c2030ef          	jal	5716 <open>
  if (fd < 0) {
    2658:	0a054a63          	bltz	a0,270c <fourteen+0xec>
  close(fd);
    265c:	0a2030ef          	jal	56fe <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2660:	4581                	li	a1,0
    2662:	00004517          	auipc	a0,0x4
    2666:	61e50513          	addi	a0,a0,1566 # 6c80 <malloc+0x1088>
    266a:	0ac030ef          	jal	5716 <open>
  if (fd < 0) {
    266e:	0a054963          	bltz	a0,2720 <fourteen+0x100>
  close(fd);
    2672:	08c030ef          	jal	56fe <close>
  if (mkdir("12345678901234/12345678901234") == 0) {
    2676:	00004517          	auipc	a0,0x4
    267a:	67a50513          	addi	a0,a0,1658 # 6cf0 <malloc+0x10f8>
    267e:	0c0030ef          	jal	573e <mkdir>
    2682:	c94d                	beqz	a0,2734 <fourteen+0x114>
  if (mkdir("123456789012345/12345678901234") == 0) {
    2684:	00004517          	auipc	a0,0x4
    2688:	6c450513          	addi	a0,a0,1732 # 6d48 <malloc+0x1150>
    268c:	0b2030ef          	jal	573e <mkdir>
    2690:	cd45                	beqz	a0,2748 <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    2692:	00004517          	auipc	a0,0x4
    2696:	6b650513          	addi	a0,a0,1718 # 6d48 <malloc+0x1150>
    269a:	08c030ef          	jal	5726 <unlink>
  unlink("12345678901234/12345678901234");
    269e:	00004517          	auipc	a0,0x4
    26a2:	65250513          	addi	a0,a0,1618 # 6cf0 <malloc+0x10f8>
    26a6:	080030ef          	jal	5726 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    26aa:	00004517          	auipc	a0,0x4
    26ae:	5d650513          	addi	a0,a0,1494 # 6c80 <malloc+0x1088>
    26b2:	074030ef          	jal	5726 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    26b6:	00004517          	auipc	a0,0x4
    26ba:	55250513          	addi	a0,a0,1362 # 6c08 <malloc+0x1010>
    26be:	068030ef          	jal	5726 <unlink>
  unlink("12345678901234/123456789012345");
    26c2:	00004517          	auipc	a0,0x4
    26c6:	4ee50513          	addi	a0,a0,1262 # 6bb0 <malloc+0xfb8>
    26ca:	05c030ef          	jal	5726 <unlink>
  unlink("12345678901234");
    26ce:	00004517          	auipc	a0,0x4
    26d2:	68a50513          	addi	a0,a0,1674 # 6d58 <malloc+0x1160>
    26d6:	050030ef          	jal	5726 <unlink>
}
    26da:	60e2                	ld	ra,24(sp)
    26dc:	6442                	ld	s0,16(sp)
    26de:	64a2                	ld	s1,8(sp)
    26e0:	6105                	addi	sp,sp,32
    26e2:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    26e4:	85a6                	mv	a1,s1
    26e6:	00004517          	auipc	a0,0x4
    26ea:	4a250513          	addi	a0,a0,1186 # 6b88 <malloc+0xf90>
    26ee:	44e030ef          	jal	5b3c <printf>
    exit(1);
    26f2:	4505                	li	a0,1
    26f4:	7e3020ef          	jal	56d6 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    26f8:	85a6                	mv	a1,s1
    26fa:	00004517          	auipc	a0,0x4
    26fe:	4d650513          	addi	a0,a0,1238 # 6bd0 <malloc+0xfd8>
    2702:	43a030ef          	jal	5b3c <printf>
    exit(1);
    2706:	4505                	li	a0,1
    2708:	7cf020ef          	jal	56d6 <exit>
    printf(
    270c:	85a6                	mv	a1,s1
    270e:	00004517          	auipc	a0,0x4
    2712:	52a50513          	addi	a0,a0,1322 # 6c38 <malloc+0x1040>
    2716:	426030ef          	jal	5b3c <printf>
    exit(1);
    271a:	4505                	li	a0,1
    271c:	7bb020ef          	jal	56d6 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2720:	85a6                	mv	a1,s1
    2722:	00004517          	auipc	a0,0x4
    2726:	58e50513          	addi	a0,a0,1422 # 6cb0 <malloc+0x10b8>
    272a:	412030ef          	jal	5b3c <printf>
    exit(1);
    272e:	4505                	li	a0,1
    2730:	7a7020ef          	jal	56d6 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2734:	85a6                	mv	a1,s1
    2736:	00004517          	auipc	a0,0x4
    273a:	5da50513          	addi	a0,a0,1498 # 6d10 <malloc+0x1118>
    273e:	3fe030ef          	jal	5b3c <printf>
    exit(1);
    2742:	4505                	li	a0,1
    2744:	793020ef          	jal	56d6 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2748:	85a6                	mv	a1,s1
    274a:	00004517          	auipc	a0,0x4
    274e:	61e50513          	addi	a0,a0,1566 # 6d68 <malloc+0x1170>
    2752:	3ea030ef          	jal	5b3c <printf>
    exit(1);
    2756:	4505                	li	a0,1
    2758:	77f020ef          	jal	56d6 <exit>

000000000000275c <diskfull>:
{
    275c:	b6010113          	addi	sp,sp,-1184
    2760:	48113c23          	sd	ra,1176(sp)
    2764:	48813823          	sd	s0,1168(sp)
    2768:	48913423          	sd	s1,1160(sp)
    276c:	49213023          	sd	s2,1152(sp)
    2770:	47313c23          	sd	s3,1144(sp)
    2774:	47413823          	sd	s4,1136(sp)
    2778:	47513423          	sd	s5,1128(sp)
    277c:	47613023          	sd	s6,1120(sp)
    2780:	45713c23          	sd	s7,1112(sp)
    2784:	45813823          	sd	s8,1104(sp)
    2788:	45913423          	sd	s9,1096(sp)
    278c:	45a13023          	sd	s10,1088(sp)
    2790:	43b13c23          	sd	s11,1080(sp)
    2794:	4a010413          	addi	s0,sp,1184
    2798:	b6a43423          	sd	a0,-1176(s0)
  unlink("diskfulldir");
    279c:	00004517          	auipc	a0,0x4
    27a0:	60450513          	addi	a0,a0,1540 # 6da0 <malloc+0x11a8>
    27a4:	783020ef          	jal	5726 <unlink>
    27a8:	03000a93          	li	s5,48
    name[0] = 'b';
    27ac:	06200d13          	li	s10,98
    name[1] = 'i';
    27b0:	06900c93          	li	s9,105
    name[2] = 'g';
    27b4:	06700c13          	li	s8,103
    unlink(name);
    27b8:	b7040b13          	addi	s6,s0,-1168
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    27bc:	60200b93          	li	s7,1538
    if (fd < 0) {
    27c0:	10c00d93          	li	s11,268
      if (write(fd, buf, BSIZE) != BSIZE) {
    27c4:	b9040a13          	addi	s4,s0,-1136
    27c8:	aa8d                	j	293a <diskfull+0x1de>
      printf("%s: could not create file %s\n", s, name);
    27ca:	b7040613          	addi	a2,s0,-1168
    27ce:	b6843583          	ld	a1,-1176(s0)
    27d2:	00004517          	auipc	a0,0x4
    27d6:	5de50513          	addi	a0,a0,1502 # 6db0 <malloc+0x11b8>
    27da:	362030ef          	jal	5b3c <printf>
      break;
    27de:	a039                	j	27ec <diskfull+0x90>
        close(fd);
    27e0:	854e                	mv	a0,s3
    27e2:	71d020ef          	jal	56fe <close>
    close(fd);
    27e6:	854e                	mv	a0,s3
    27e8:	717020ef          	jal	56fe <close>
  for (int i = 0; i < nzz; i++) {
    27ec:	4481                	li	s1,0
    name[0] = 'z';
    27ee:	07a00993          	li	s3,122
    unlink(name);
    27f2:	b9040913          	addi	s2,s0,-1136
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    27f6:	60200a13          	li	s4,1538
  for (int i = 0; i < nzz; i++) {
    27fa:	08000a93          	li	s5,128
    name[0] = 'z';
    27fe:	b9340823          	sb	s3,-1136(s0)
    name[1] = 'z';
    2802:	b93408a3          	sb	s3,-1135(s0)
    name[2] = '0' + (i / 32);
    2806:	41f4d71b          	sraiw	a4,s1,0x1f
    280a:	01b7571b          	srliw	a4,a4,0x1b
    280e:	009707bb          	addw	a5,a4,s1
    2812:	4057d69b          	sraiw	a3,a5,0x5
    2816:	0306869b          	addiw	a3,a3,48
    281a:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    281e:	8bfd                	andi	a5,a5,31
    2820:	9f99                	subw	a5,a5,a4
    2822:	0307879b          	addiw	a5,a5,48
    2826:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    282a:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    282e:	854a                	mv	a0,s2
    2830:	6f7020ef          	jal	5726 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    2834:	85d2                	mv	a1,s4
    2836:	854a                	mv	a0,s2
    2838:	6df020ef          	jal	5716 <open>
    if (fd < 0)
    283c:	00054763          	bltz	a0,284a <diskfull+0xee>
    close(fd);
    2840:	6bf020ef          	jal	56fe <close>
  for (int i = 0; i < nzz; i++) {
    2844:	2485                	addiw	s1,s1,1
    2846:	fb549ce3          	bne	s1,s5,27fe <diskfull+0xa2>
  if (mkdir("diskfulldir") == 0)
    284a:	00004517          	auipc	a0,0x4
    284e:	55650513          	addi	a0,a0,1366 # 6da0 <malloc+0x11a8>
    2852:	6ed020ef          	jal	573e <mkdir>
    2856:	12050363          	beqz	a0,297c <diskfull+0x220>
  unlink("diskfulldir");
    285a:	00004517          	auipc	a0,0x4
    285e:	54650513          	addi	a0,a0,1350 # 6da0 <malloc+0x11a8>
    2862:	6c5020ef          	jal	5726 <unlink>
  for (int i = 0; i < nzz; i++) {
    2866:	4481                	li	s1,0
    name[0] = 'z';
    2868:	07a00913          	li	s2,122
    unlink(name);
    286c:	b9040a13          	addi	s4,s0,-1136
  for (int i = 0; i < nzz; i++) {
    2870:	08000993          	li	s3,128
    name[0] = 'z';
    2874:	b9240823          	sb	s2,-1136(s0)
    name[1] = 'z';
    2878:	b92408a3          	sb	s2,-1135(s0)
    name[2] = '0' + (i / 32);
    287c:	41f4d71b          	sraiw	a4,s1,0x1f
    2880:	01b7571b          	srliw	a4,a4,0x1b
    2884:	009707bb          	addw	a5,a4,s1
    2888:	4057d69b          	sraiw	a3,a5,0x5
    288c:	0306869b          	addiw	a3,a3,48
    2890:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    2894:	8bfd                	andi	a5,a5,31
    2896:	9f99                	subw	a5,a5,a4
    2898:	0307879b          	addiw	a5,a5,48
    289c:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    28a0:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    28a4:	8552                	mv	a0,s4
    28a6:	681020ef          	jal	5726 <unlink>
  for (int i = 0; i < nzz; i++) {
    28aa:	2485                	addiw	s1,s1,1
    28ac:	fd3494e3          	bne	s1,s3,2874 <diskfull+0x118>
    28b0:	03000493          	li	s1,48
    name[0] = 'b';
    28b4:	06200b13          	li	s6,98
    name[1] = 'i';
    28b8:	06900a93          	li	s5,105
    name[2] = 'g';
    28bc:	06700a13          	li	s4,103
    unlink(name);
    28c0:	b9040993          	addi	s3,s0,-1136
  for (int i = 0; '0' + i < 0177; i++) {
    28c4:	07f00913          	li	s2,127
    name[0] = 'b';
    28c8:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    28cc:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    28d0:	b9440923          	sb	s4,-1134(s0)
    name[3] = '0' + i;
    28d4:	b89409a3          	sb	s1,-1133(s0)
    name[4] = '\0';
    28d8:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    28dc:	854e                	mv	a0,s3
    28de:	649020ef          	jal	5726 <unlink>
  for (int i = 0; '0' + i < 0177; i++) {
    28e2:	2485                	addiw	s1,s1,1
    28e4:	0ff4f493          	zext.b	s1,s1
    28e8:	ff2490e3          	bne	s1,s2,28c8 <diskfull+0x16c>
}
    28ec:	49813083          	ld	ra,1176(sp)
    28f0:	49013403          	ld	s0,1168(sp)
    28f4:	48813483          	ld	s1,1160(sp)
    28f8:	48013903          	ld	s2,1152(sp)
    28fc:	47813983          	ld	s3,1144(sp)
    2900:	47013a03          	ld	s4,1136(sp)
    2904:	46813a83          	ld	s5,1128(sp)
    2908:	46013b03          	ld	s6,1120(sp)
    290c:	45813b83          	ld	s7,1112(sp)
    2910:	45013c03          	ld	s8,1104(sp)
    2914:	44813c83          	ld	s9,1096(sp)
    2918:	44013d03          	ld	s10,1088(sp)
    291c:	43813d83          	ld	s11,1080(sp)
    2920:	4a010113          	addi	sp,sp,1184
    2924:	8082                	ret
    close(fd);
    2926:	854e                	mv	a0,s3
    2928:	5d7020ef          	jal	56fe <close>
  for (fi = 0; done == 0 && '0' + fi < 0177; fi++) {
    292c:	2a85                	addiw	s5,s5,1 # 3001 <subdir+0x47b>
    292e:	0ffafa93          	zext.b	s5,s5
    2932:	07f00793          	li	a5,127
    2936:	eafa8be3          	beq	s5,a5,27ec <diskfull+0x90>
    name[0] = 'b';
    293a:	b7a40823          	sb	s10,-1168(s0)
    name[1] = 'i';
    293e:	b79408a3          	sb	s9,-1167(s0)
    name[2] = 'g';
    2942:	b7840923          	sb	s8,-1166(s0)
    name[3] = '0' + fi;
    2946:	b75409a3          	sb	s5,-1165(s0)
    name[4] = '\0';
    294a:	b6040a23          	sb	zero,-1164(s0)
    unlink(name);
    294e:	855a                	mv	a0,s6
    2950:	5d7020ef          	jal	5726 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    2954:	85de                	mv	a1,s7
    2956:	855a                	mv	a0,s6
    2958:	5bf020ef          	jal	5716 <open>
    295c:	89aa                	mv	s3,a0
    if (fd < 0) {
    295e:	e60546e3          	bltz	a0,27ca <diskfull+0x6e>
    2962:	84ee                	mv	s1,s11
      if (write(fd, buf, BSIZE) != BSIZE) {
    2964:	40000913          	li	s2,1024
    2968:	864a                	mv	a2,s2
    296a:	85d2                	mv	a1,s4
    296c:	854e                	mv	a0,s3
    296e:	589020ef          	jal	56f6 <write>
    2972:	e72517e3          	bne	a0,s2,27e0 <diskfull+0x84>
    for (int i = 0; i < MAXFILE; i++) {
    2976:	34fd                	addiw	s1,s1,-1
    2978:	f8e5                	bnez	s1,2968 <diskfull+0x20c>
    297a:	b775                	j	2926 <diskfull+0x1ca>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    297c:	b6843583          	ld	a1,-1176(s0)
    2980:	00004517          	auipc	a0,0x4
    2984:	45050513          	addi	a0,a0,1104 # 6dd0 <malloc+0x11d8>
    2988:	1b4030ef          	jal	5b3c <printf>
    298c:	b5f9                	j	285a <diskfull+0xfe>

000000000000298e <iputtest>:
{
    298e:	1101                	addi	sp,sp,-32
    2990:	ec06                	sd	ra,24(sp)
    2992:	e822                	sd	s0,16(sp)
    2994:	e426                	sd	s1,8(sp)
    2996:	1000                	addi	s0,sp,32
    2998:	84aa                	mv	s1,a0
  if (mkdir("iputdir") < 0) {
    299a:	00004517          	auipc	a0,0x4
    299e:	46650513          	addi	a0,a0,1126 # 6e00 <malloc+0x1208>
    29a2:	59d020ef          	jal	573e <mkdir>
    29a6:	02054f63          	bltz	a0,29e4 <iputtest+0x56>
  if (chdir("iputdir") < 0) {
    29aa:	00004517          	auipc	a0,0x4
    29ae:	45650513          	addi	a0,a0,1110 # 6e00 <malloc+0x1208>
    29b2:	595020ef          	jal	5746 <chdir>
    29b6:	04054163          	bltz	a0,29f8 <iputtest+0x6a>
  if (unlink("../iputdir") < 0) {
    29ba:	00004517          	auipc	a0,0x4
    29be:	48650513          	addi	a0,a0,1158 # 6e40 <malloc+0x1248>
    29c2:	565020ef          	jal	5726 <unlink>
    29c6:	04054363          	bltz	a0,2a0c <iputtest+0x7e>
  if (chdir("/") < 0) {
    29ca:	00004517          	auipc	a0,0x4
    29ce:	4a650513          	addi	a0,a0,1190 # 6e70 <malloc+0x1278>
    29d2:	575020ef          	jal	5746 <chdir>
    29d6:	04054563          	bltz	a0,2a20 <iputtest+0x92>
}
    29da:	60e2                	ld	ra,24(sp)
    29dc:	6442                	ld	s0,16(sp)
    29de:	64a2                	ld	s1,8(sp)
    29e0:	6105                	addi	sp,sp,32
    29e2:	8082                	ret
    printf("%s: mkdir failed\n", s);
    29e4:	85a6                	mv	a1,s1
    29e6:	00004517          	auipc	a0,0x4
    29ea:	42250513          	addi	a0,a0,1058 # 6e08 <malloc+0x1210>
    29ee:	14e030ef          	jal	5b3c <printf>
    exit(1);
    29f2:	4505                	li	a0,1
    29f4:	4e3020ef          	jal	56d6 <exit>
    printf("%s: chdir iputdir failed\n", s);
    29f8:	85a6                	mv	a1,s1
    29fa:	00004517          	auipc	a0,0x4
    29fe:	42650513          	addi	a0,a0,1062 # 6e20 <malloc+0x1228>
    2a02:	13a030ef          	jal	5b3c <printf>
    exit(1);
    2a06:	4505                	li	a0,1
    2a08:	4cf020ef          	jal	56d6 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2a0c:	85a6                	mv	a1,s1
    2a0e:	00004517          	auipc	a0,0x4
    2a12:	44250513          	addi	a0,a0,1090 # 6e50 <malloc+0x1258>
    2a16:	126030ef          	jal	5b3c <printf>
    exit(1);
    2a1a:	4505                	li	a0,1
    2a1c:	4bb020ef          	jal	56d6 <exit>
    printf("%s: chdir / failed\n", s);
    2a20:	85a6                	mv	a1,s1
    2a22:	00004517          	auipc	a0,0x4
    2a26:	45650513          	addi	a0,a0,1110 # 6e78 <malloc+0x1280>
    2a2a:	112030ef          	jal	5b3c <printf>
    exit(1);
    2a2e:	4505                	li	a0,1
    2a30:	4a7020ef          	jal	56d6 <exit>

0000000000002a34 <exitiputtest>:
{
    2a34:	7179                	addi	sp,sp,-48
    2a36:	f406                	sd	ra,40(sp)
    2a38:	f022                	sd	s0,32(sp)
    2a3a:	ec26                	sd	s1,24(sp)
    2a3c:	1800                	addi	s0,sp,48
    2a3e:	84aa                	mv	s1,a0
  pid = fork();
    2a40:	48f020ef          	jal	56ce <fork>
  if (pid < 0) {
    2a44:	02054e63          	bltz	a0,2a80 <exitiputtest+0x4c>
  if (pid == 0) {
    2a48:	e541                	bnez	a0,2ad0 <exitiputtest+0x9c>
    if (mkdir("iputdir") < 0) {
    2a4a:	00004517          	auipc	a0,0x4
    2a4e:	3b650513          	addi	a0,a0,950 # 6e00 <malloc+0x1208>
    2a52:	4ed020ef          	jal	573e <mkdir>
    2a56:	02054f63          	bltz	a0,2a94 <exitiputtest+0x60>
    if (chdir("iputdir") < 0) {
    2a5a:	00004517          	auipc	a0,0x4
    2a5e:	3a650513          	addi	a0,a0,934 # 6e00 <malloc+0x1208>
    2a62:	4e5020ef          	jal	5746 <chdir>
    2a66:	04054163          	bltz	a0,2aa8 <exitiputtest+0x74>
    if (unlink("../iputdir") < 0) {
    2a6a:	00004517          	auipc	a0,0x4
    2a6e:	3d650513          	addi	a0,a0,982 # 6e40 <malloc+0x1248>
    2a72:	4b5020ef          	jal	5726 <unlink>
    2a76:	04054363          	bltz	a0,2abc <exitiputtest+0x88>
    exit(0);
    2a7a:	4501                	li	a0,0
    2a7c:	45b020ef          	jal	56d6 <exit>
    printf("%s: fork failed\n", s);
    2a80:	85a6                	mv	a1,s1
    2a82:	00004517          	auipc	a0,0x4
    2a86:	b3650513          	addi	a0,a0,-1226 # 65b8 <malloc+0x9c0>
    2a8a:	0b2030ef          	jal	5b3c <printf>
    exit(1);
    2a8e:	4505                	li	a0,1
    2a90:	447020ef          	jal	56d6 <exit>
      printf("%s: mkdir failed\n", s);
    2a94:	85a6                	mv	a1,s1
    2a96:	00004517          	auipc	a0,0x4
    2a9a:	37250513          	addi	a0,a0,882 # 6e08 <malloc+0x1210>
    2a9e:	09e030ef          	jal	5b3c <printf>
      exit(1);
    2aa2:	4505                	li	a0,1
    2aa4:	433020ef          	jal	56d6 <exit>
      printf("%s: child chdir failed\n", s);
    2aa8:	85a6                	mv	a1,s1
    2aaa:	00004517          	auipc	a0,0x4
    2aae:	3e650513          	addi	a0,a0,998 # 6e90 <malloc+0x1298>
    2ab2:	08a030ef          	jal	5b3c <printf>
      exit(1);
    2ab6:	4505                	li	a0,1
    2ab8:	41f020ef          	jal	56d6 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2abc:	85a6                	mv	a1,s1
    2abe:	00004517          	auipc	a0,0x4
    2ac2:	39250513          	addi	a0,a0,914 # 6e50 <malloc+0x1258>
    2ac6:	076030ef          	jal	5b3c <printf>
      exit(1);
    2aca:	4505                	li	a0,1
    2acc:	40b020ef          	jal	56d6 <exit>
  wait(&xstatus);
    2ad0:	fdc40513          	addi	a0,s0,-36
    2ad4:	40b020ef          	jal	56de <wait>
  exit(xstatus);
    2ad8:	fdc42503          	lw	a0,-36(s0)
    2adc:	3fb020ef          	jal	56d6 <exit>

0000000000002ae0 <dirtest>:
{
    2ae0:	1101                	addi	sp,sp,-32
    2ae2:	ec06                	sd	ra,24(sp)
    2ae4:	e822                	sd	s0,16(sp)
    2ae6:	e426                	sd	s1,8(sp)
    2ae8:	1000                	addi	s0,sp,32
    2aea:	84aa                	mv	s1,a0
  if (mkdir("dir0") < 0) {
    2aec:	00004517          	auipc	a0,0x4
    2af0:	3bc50513          	addi	a0,a0,956 # 6ea8 <malloc+0x12b0>
    2af4:	44b020ef          	jal	573e <mkdir>
    2af8:	02054f63          	bltz	a0,2b36 <dirtest+0x56>
  if (chdir("dir0") < 0) {
    2afc:	00004517          	auipc	a0,0x4
    2b00:	3ac50513          	addi	a0,a0,940 # 6ea8 <malloc+0x12b0>
    2b04:	443020ef          	jal	5746 <chdir>
    2b08:	04054163          	bltz	a0,2b4a <dirtest+0x6a>
  if (chdir("..") < 0) {
    2b0c:	00004517          	auipc	a0,0x4
    2b10:	3bc50513          	addi	a0,a0,956 # 6ec8 <malloc+0x12d0>
    2b14:	433020ef          	jal	5746 <chdir>
    2b18:	04054363          	bltz	a0,2b5e <dirtest+0x7e>
  if (unlink("dir0") < 0) {
    2b1c:	00004517          	auipc	a0,0x4
    2b20:	38c50513          	addi	a0,a0,908 # 6ea8 <malloc+0x12b0>
    2b24:	403020ef          	jal	5726 <unlink>
    2b28:	04054563          	bltz	a0,2b72 <dirtest+0x92>
}
    2b2c:	60e2                	ld	ra,24(sp)
    2b2e:	6442                	ld	s0,16(sp)
    2b30:	64a2                	ld	s1,8(sp)
    2b32:	6105                	addi	sp,sp,32
    2b34:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b36:	85a6                	mv	a1,s1
    2b38:	00004517          	auipc	a0,0x4
    2b3c:	2d050513          	addi	a0,a0,720 # 6e08 <malloc+0x1210>
    2b40:	7fd020ef          	jal	5b3c <printf>
    exit(1);
    2b44:	4505                	li	a0,1
    2b46:	391020ef          	jal	56d6 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2b4a:	85a6                	mv	a1,s1
    2b4c:	00004517          	auipc	a0,0x4
    2b50:	36450513          	addi	a0,a0,868 # 6eb0 <malloc+0x12b8>
    2b54:	7e9020ef          	jal	5b3c <printf>
    exit(1);
    2b58:	4505                	li	a0,1
    2b5a:	37d020ef          	jal	56d6 <exit>
    printf("%s: chdir .. failed\n", s);
    2b5e:	85a6                	mv	a1,s1
    2b60:	00004517          	auipc	a0,0x4
    2b64:	37050513          	addi	a0,a0,880 # 6ed0 <malloc+0x12d8>
    2b68:	7d5020ef          	jal	5b3c <printf>
    exit(1);
    2b6c:	4505                	li	a0,1
    2b6e:	369020ef          	jal	56d6 <exit>
    printf("%s: unlink dir0 failed\n", s);
    2b72:	85a6                	mv	a1,s1
    2b74:	00004517          	auipc	a0,0x4
    2b78:	37450513          	addi	a0,a0,884 # 6ee8 <malloc+0x12f0>
    2b7c:	7c1020ef          	jal	5b3c <printf>
    exit(1);
    2b80:	4505                	li	a0,1
    2b82:	355020ef          	jal	56d6 <exit>

0000000000002b86 <subdir>:
{
    2b86:	1101                	addi	sp,sp,-32
    2b88:	ec06                	sd	ra,24(sp)
    2b8a:	e822                	sd	s0,16(sp)
    2b8c:	e426                	sd	s1,8(sp)
    2b8e:	e04a                	sd	s2,0(sp)
    2b90:	1000                	addi	s0,sp,32
    2b92:	892a                	mv	s2,a0
  unlink("ff");
    2b94:	00004517          	auipc	a0,0x4
    2b98:	49c50513          	addi	a0,a0,1180 # 7030 <malloc+0x1438>
    2b9c:	38b020ef          	jal	5726 <unlink>
  if (mkdir("dd") != 0) {
    2ba0:	00004517          	auipc	a0,0x4
    2ba4:	36050513          	addi	a0,a0,864 # 6f00 <malloc+0x1308>
    2ba8:	397020ef          	jal	573e <mkdir>
    2bac:	2e051263          	bnez	a0,2e90 <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2bb0:	20200593          	li	a1,514
    2bb4:	00004517          	auipc	a0,0x4
    2bb8:	36c50513          	addi	a0,a0,876 # 6f20 <malloc+0x1328>
    2bbc:	35b020ef          	jal	5716 <open>
    2bc0:	84aa                	mv	s1,a0
  if (fd < 0) {
    2bc2:	2e054163          	bltz	a0,2ea4 <subdir+0x31e>
  write(fd, "ff", 2);
    2bc6:	4609                	li	a2,2
    2bc8:	00004597          	auipc	a1,0x4
    2bcc:	46858593          	addi	a1,a1,1128 # 7030 <malloc+0x1438>
    2bd0:	327020ef          	jal	56f6 <write>
  close(fd);
    2bd4:	8526                	mv	a0,s1
    2bd6:	329020ef          	jal	56fe <close>
  if (unlink("dd") >= 0) {
    2bda:	00004517          	auipc	a0,0x4
    2bde:	32650513          	addi	a0,a0,806 # 6f00 <malloc+0x1308>
    2be2:	345020ef          	jal	5726 <unlink>
    2be6:	2c055963          	bgez	a0,2eb8 <subdir+0x332>
  if (mkdir("/dd/dd") != 0) {
    2bea:	00004517          	auipc	a0,0x4
    2bee:	38e50513          	addi	a0,a0,910 # 6f78 <malloc+0x1380>
    2bf2:	34d020ef          	jal	573e <mkdir>
    2bf6:	2c051b63          	bnez	a0,2ecc <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2bfa:	20200593          	li	a1,514
    2bfe:	00004517          	auipc	a0,0x4
    2c02:	3a250513          	addi	a0,a0,930 # 6fa0 <malloc+0x13a8>
    2c06:	311020ef          	jal	5716 <open>
    2c0a:	84aa                	mv	s1,a0
  if (fd < 0) {
    2c0c:	2c054a63          	bltz	a0,2ee0 <subdir+0x35a>
  write(fd, "FF", 2);
    2c10:	4609                	li	a2,2
    2c12:	00004597          	auipc	a1,0x4
    2c16:	3be58593          	addi	a1,a1,958 # 6fd0 <malloc+0x13d8>
    2c1a:	2dd020ef          	jal	56f6 <write>
  close(fd);
    2c1e:	8526                	mv	a0,s1
    2c20:	2df020ef          	jal	56fe <close>
  fd = open("dd/dd/../ff", 0);
    2c24:	4581                	li	a1,0
    2c26:	00004517          	auipc	a0,0x4
    2c2a:	3b250513          	addi	a0,a0,946 # 6fd8 <malloc+0x13e0>
    2c2e:	2e9020ef          	jal	5716 <open>
    2c32:	84aa                	mv	s1,a0
  if (fd < 0) {
    2c34:	2c054063          	bltz	a0,2ef4 <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2c38:	660d                	lui	a2,0x3
    2c3a:	0000b597          	auipc	a1,0xb
    2c3e:	0ae58593          	addi	a1,a1,174 # dce8 <buf>
    2c42:	2ad020ef          	jal	56ee <read>
  if (cc != 2 || buf[0] != 'f') {
    2c46:	4789                	li	a5,2
    2c48:	2cf51063          	bne	a0,a5,2f08 <subdir+0x382>
    2c4c:	0000b717          	auipc	a4,0xb
    2c50:	09c74703          	lbu	a4,156(a4) # dce8 <buf>
    2c54:	06600793          	li	a5,102
    2c58:	2af71863          	bne	a4,a5,2f08 <subdir+0x382>
  close(fd);
    2c5c:	8526                	mv	a0,s1
    2c5e:	2a1020ef          	jal	56fe <close>
  if (link("dd/dd/ff", "dd/dd/ffff") != 0) {
    2c62:	00004597          	auipc	a1,0x4
    2c66:	3c658593          	addi	a1,a1,966 # 7028 <malloc+0x1430>
    2c6a:	00004517          	auipc	a0,0x4
    2c6e:	33650513          	addi	a0,a0,822 # 6fa0 <malloc+0x13a8>
    2c72:	2c5020ef          	jal	5736 <link>
    2c76:	2a051363          	bnez	a0,2f1c <subdir+0x396>
  if (unlink("dd/dd/ff") != 0) {
    2c7a:	00004517          	auipc	a0,0x4
    2c7e:	32650513          	addi	a0,a0,806 # 6fa0 <malloc+0x13a8>
    2c82:	2a5020ef          	jal	5726 <unlink>
    2c86:	2a051563          	bnez	a0,2f30 <subdir+0x3aa>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    2c8a:	4581                	li	a1,0
    2c8c:	00004517          	auipc	a0,0x4
    2c90:	31450513          	addi	a0,a0,788 # 6fa0 <malloc+0x13a8>
    2c94:	283020ef          	jal	5716 <open>
    2c98:	2a055663          	bgez	a0,2f44 <subdir+0x3be>
  if (chdir("dd") != 0) {
    2c9c:	00004517          	auipc	a0,0x4
    2ca0:	26450513          	addi	a0,a0,612 # 6f00 <malloc+0x1308>
    2ca4:	2a3020ef          	jal	5746 <chdir>
    2ca8:	2a051863          	bnez	a0,2f58 <subdir+0x3d2>
  if (chdir("dd/../../dd") != 0) {
    2cac:	00004517          	auipc	a0,0x4
    2cb0:	41450513          	addi	a0,a0,1044 # 70c0 <malloc+0x14c8>
    2cb4:	293020ef          	jal	5746 <chdir>
    2cb8:	2a051a63          	bnez	a0,2f6c <subdir+0x3e6>
  if (chdir("dd/../../../dd") != 0) {
    2cbc:	00004517          	auipc	a0,0x4
    2cc0:	43450513          	addi	a0,a0,1076 # 70f0 <malloc+0x14f8>
    2cc4:	283020ef          	jal	5746 <chdir>
    2cc8:	2a051c63          	bnez	a0,2f80 <subdir+0x3fa>
  if (chdir("./..") != 0) {
    2ccc:	00004517          	auipc	a0,0x4
    2cd0:	45c50513          	addi	a0,a0,1116 # 7128 <malloc+0x1530>
    2cd4:	273020ef          	jal	5746 <chdir>
    2cd8:	2a051e63          	bnez	a0,2f94 <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2cdc:	4581                	li	a1,0
    2cde:	00004517          	auipc	a0,0x4
    2ce2:	34a50513          	addi	a0,a0,842 # 7028 <malloc+0x1430>
    2ce6:	231020ef          	jal	5716 <open>
    2cea:	84aa                	mv	s1,a0
  if (fd < 0) {
    2cec:	2a054e63          	bltz	a0,2fa8 <subdir+0x422>
  if (read(fd, buf, sizeof(buf)) != 2) {
    2cf0:	660d                	lui	a2,0x3
    2cf2:	0000b597          	auipc	a1,0xb
    2cf6:	ff658593          	addi	a1,a1,-10 # dce8 <buf>
    2cfa:	1f5020ef          	jal	56ee <read>
    2cfe:	4789                	li	a5,2
    2d00:	2af51e63          	bne	a0,a5,2fbc <subdir+0x436>
  close(fd);
    2d04:	8526                	mv	a0,s1
    2d06:	1f9020ef          	jal	56fe <close>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    2d0a:	4581                	li	a1,0
    2d0c:	00004517          	auipc	a0,0x4
    2d10:	29450513          	addi	a0,a0,660 # 6fa0 <malloc+0x13a8>
    2d14:	203020ef          	jal	5716 <open>
    2d18:	2a055c63          	bgez	a0,2fd0 <subdir+0x44a>
  if (open("dd/ff/ff", O_CREATE | O_RDWR) >= 0) {
    2d1c:	20200593          	li	a1,514
    2d20:	00004517          	auipc	a0,0x4
    2d24:	49850513          	addi	a0,a0,1176 # 71b8 <malloc+0x15c0>
    2d28:	1ef020ef          	jal	5716 <open>
    2d2c:	2a055c63          	bgez	a0,2fe4 <subdir+0x45e>
  if (open("dd/xx/ff", O_CREATE | O_RDWR) >= 0) {
    2d30:	20200593          	li	a1,514
    2d34:	00004517          	auipc	a0,0x4
    2d38:	4b450513          	addi	a0,a0,1204 # 71e8 <malloc+0x15f0>
    2d3c:	1db020ef          	jal	5716 <open>
    2d40:	2a055c63          	bgez	a0,2ff8 <subdir+0x472>
  if (open("dd", O_CREATE) >= 0) {
    2d44:	20000593          	li	a1,512
    2d48:	00004517          	auipc	a0,0x4
    2d4c:	1b850513          	addi	a0,a0,440 # 6f00 <malloc+0x1308>
    2d50:	1c7020ef          	jal	5716 <open>
    2d54:	2a055c63          	bgez	a0,300c <subdir+0x486>
  if (open("dd", O_RDWR) >= 0) {
    2d58:	4589                	li	a1,2
    2d5a:	00004517          	auipc	a0,0x4
    2d5e:	1a650513          	addi	a0,a0,422 # 6f00 <malloc+0x1308>
    2d62:	1b5020ef          	jal	5716 <open>
    2d66:	2a055d63          	bgez	a0,3020 <subdir+0x49a>
  if (open("dd", O_WRONLY) >= 0) {
    2d6a:	4585                	li	a1,1
    2d6c:	00004517          	auipc	a0,0x4
    2d70:	19450513          	addi	a0,a0,404 # 6f00 <malloc+0x1308>
    2d74:	1a3020ef          	jal	5716 <open>
    2d78:	2a055e63          	bgez	a0,3034 <subdir+0x4ae>
  if (link("dd/ff/ff", "dd/dd/xx") == 0) {
    2d7c:	00004597          	auipc	a1,0x4
    2d80:	4fc58593          	addi	a1,a1,1276 # 7278 <malloc+0x1680>
    2d84:	00004517          	auipc	a0,0x4
    2d88:	43450513          	addi	a0,a0,1076 # 71b8 <malloc+0x15c0>
    2d8c:	1ab020ef          	jal	5736 <link>
    2d90:	2a050c63          	beqz	a0,3048 <subdir+0x4c2>
  if (link("dd/xx/ff", "dd/dd/xx") == 0) {
    2d94:	00004597          	auipc	a1,0x4
    2d98:	4e458593          	addi	a1,a1,1252 # 7278 <malloc+0x1680>
    2d9c:	00004517          	auipc	a0,0x4
    2da0:	44c50513          	addi	a0,a0,1100 # 71e8 <malloc+0x15f0>
    2da4:	193020ef          	jal	5736 <link>
    2da8:	2a050a63          	beqz	a0,305c <subdir+0x4d6>
  if (link("dd/ff", "dd/dd/ffff") == 0) {
    2dac:	00004597          	auipc	a1,0x4
    2db0:	27c58593          	addi	a1,a1,636 # 7028 <malloc+0x1430>
    2db4:	00004517          	auipc	a0,0x4
    2db8:	16c50513          	addi	a0,a0,364 # 6f20 <malloc+0x1328>
    2dbc:	17b020ef          	jal	5736 <link>
    2dc0:	2a050863          	beqz	a0,3070 <subdir+0x4ea>
  if (mkdir("dd/ff/ff") == 0) {
    2dc4:	00004517          	auipc	a0,0x4
    2dc8:	3f450513          	addi	a0,a0,1012 # 71b8 <malloc+0x15c0>
    2dcc:	173020ef          	jal	573e <mkdir>
    2dd0:	2a050a63          	beqz	a0,3084 <subdir+0x4fe>
  if (mkdir("dd/xx/ff") == 0) {
    2dd4:	00004517          	auipc	a0,0x4
    2dd8:	41450513          	addi	a0,a0,1044 # 71e8 <malloc+0x15f0>
    2ddc:	163020ef          	jal	573e <mkdir>
    2de0:	2a050c63          	beqz	a0,3098 <subdir+0x512>
  if (mkdir("dd/dd/ffff") == 0) {
    2de4:	00004517          	auipc	a0,0x4
    2de8:	24450513          	addi	a0,a0,580 # 7028 <malloc+0x1430>
    2dec:	153020ef          	jal	573e <mkdir>
    2df0:	2a050e63          	beqz	a0,30ac <subdir+0x526>
  if (unlink("dd/xx/ff") == 0) {
    2df4:	00004517          	auipc	a0,0x4
    2df8:	3f450513          	addi	a0,a0,1012 # 71e8 <malloc+0x15f0>
    2dfc:	12b020ef          	jal	5726 <unlink>
    2e00:	2c050063          	beqz	a0,30c0 <subdir+0x53a>
  if (unlink("dd/ff/ff") == 0) {
    2e04:	00004517          	auipc	a0,0x4
    2e08:	3b450513          	addi	a0,a0,948 # 71b8 <malloc+0x15c0>
    2e0c:	11b020ef          	jal	5726 <unlink>
    2e10:	2c050263          	beqz	a0,30d4 <subdir+0x54e>
  if (chdir("dd/ff") == 0) {
    2e14:	00004517          	auipc	a0,0x4
    2e18:	10c50513          	addi	a0,a0,268 # 6f20 <malloc+0x1328>
    2e1c:	12b020ef          	jal	5746 <chdir>
    2e20:	2c050463          	beqz	a0,30e8 <subdir+0x562>
  if (chdir("dd/xx") == 0) {
    2e24:	00004517          	auipc	a0,0x4
    2e28:	5a450513          	addi	a0,a0,1444 # 73c8 <malloc+0x17d0>
    2e2c:	11b020ef          	jal	5746 <chdir>
    2e30:	2c050663          	beqz	a0,30fc <subdir+0x576>
  if (unlink("dd/dd/ffff") != 0) {
    2e34:	00004517          	auipc	a0,0x4
    2e38:	1f450513          	addi	a0,a0,500 # 7028 <malloc+0x1430>
    2e3c:	0eb020ef          	jal	5726 <unlink>
    2e40:	2c051863          	bnez	a0,3110 <subdir+0x58a>
  if (unlink("dd/ff") != 0) {
    2e44:	00004517          	auipc	a0,0x4
    2e48:	0dc50513          	addi	a0,a0,220 # 6f20 <malloc+0x1328>
    2e4c:	0db020ef          	jal	5726 <unlink>
    2e50:	2c051a63          	bnez	a0,3124 <subdir+0x59e>
  if (unlink("dd") == 0) {
    2e54:	00004517          	auipc	a0,0x4
    2e58:	0ac50513          	addi	a0,a0,172 # 6f00 <malloc+0x1308>
    2e5c:	0cb020ef          	jal	5726 <unlink>
    2e60:	2c050c63          	beqz	a0,3138 <subdir+0x5b2>
  if (unlink("dd/dd") < 0) {
    2e64:	00004517          	auipc	a0,0x4
    2e68:	5d450513          	addi	a0,a0,1492 # 7438 <malloc+0x1840>
    2e6c:	0bb020ef          	jal	5726 <unlink>
    2e70:	2c054e63          	bltz	a0,314c <subdir+0x5c6>
  if (unlink("dd") < 0) {
    2e74:	00004517          	auipc	a0,0x4
    2e78:	08c50513          	addi	a0,a0,140 # 6f00 <malloc+0x1308>
    2e7c:	0ab020ef          	jal	5726 <unlink>
    2e80:	2e054063          	bltz	a0,3160 <subdir+0x5da>
}
    2e84:	60e2                	ld	ra,24(sp)
    2e86:	6442                	ld	s0,16(sp)
    2e88:	64a2                	ld	s1,8(sp)
    2e8a:	6902                	ld	s2,0(sp)
    2e8c:	6105                	addi	sp,sp,32
    2e8e:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2e90:	85ca                	mv	a1,s2
    2e92:	00004517          	auipc	a0,0x4
    2e96:	07650513          	addi	a0,a0,118 # 6f08 <malloc+0x1310>
    2e9a:	4a3020ef          	jal	5b3c <printf>
    exit(1);
    2e9e:	4505                	li	a0,1
    2ea0:	037020ef          	jal	56d6 <exit>
    printf("%s: create dd/ff failed\n", s);
    2ea4:	85ca                	mv	a1,s2
    2ea6:	00004517          	auipc	a0,0x4
    2eaa:	08250513          	addi	a0,a0,130 # 6f28 <malloc+0x1330>
    2eae:	48f020ef          	jal	5b3c <printf>
    exit(1);
    2eb2:	4505                	li	a0,1
    2eb4:	023020ef          	jal	56d6 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2eb8:	85ca                	mv	a1,s2
    2eba:	00004517          	auipc	a0,0x4
    2ebe:	08e50513          	addi	a0,a0,142 # 6f48 <malloc+0x1350>
    2ec2:	47b020ef          	jal	5b3c <printf>
    exit(1);
    2ec6:	4505                	li	a0,1
    2ec8:	00f020ef          	jal	56d6 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    2ecc:	85ca                	mv	a1,s2
    2ece:	00004517          	auipc	a0,0x4
    2ed2:	0b250513          	addi	a0,a0,178 # 6f80 <malloc+0x1388>
    2ed6:	467020ef          	jal	5b3c <printf>
    exit(1);
    2eda:	4505                	li	a0,1
    2edc:	7fa020ef          	jal	56d6 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2ee0:	85ca                	mv	a1,s2
    2ee2:	00004517          	auipc	a0,0x4
    2ee6:	0ce50513          	addi	a0,a0,206 # 6fb0 <malloc+0x13b8>
    2eea:	453020ef          	jal	5b3c <printf>
    exit(1);
    2eee:	4505                	li	a0,1
    2ef0:	7e6020ef          	jal	56d6 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2ef4:	85ca                	mv	a1,s2
    2ef6:	00004517          	auipc	a0,0x4
    2efa:	0f250513          	addi	a0,a0,242 # 6fe8 <malloc+0x13f0>
    2efe:	43f020ef          	jal	5b3c <printf>
    exit(1);
    2f02:	4505                	li	a0,1
    2f04:	7d2020ef          	jal	56d6 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2f08:	85ca                	mv	a1,s2
    2f0a:	00004517          	auipc	a0,0x4
    2f0e:	0fe50513          	addi	a0,a0,254 # 7008 <malloc+0x1410>
    2f12:	42b020ef          	jal	5b3c <printf>
    exit(1);
    2f16:	4505                	li	a0,1
    2f18:	7be020ef          	jal	56d6 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    2f1c:	85ca                	mv	a1,s2
    2f1e:	00004517          	auipc	a0,0x4
    2f22:	11a50513          	addi	a0,a0,282 # 7038 <malloc+0x1440>
    2f26:	417020ef          	jal	5b3c <printf>
    exit(1);
    2f2a:	4505                	li	a0,1
    2f2c:	7aa020ef          	jal	56d6 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2f30:	85ca                	mv	a1,s2
    2f32:	00004517          	auipc	a0,0x4
    2f36:	12e50513          	addi	a0,a0,302 # 7060 <malloc+0x1468>
    2f3a:	403020ef          	jal	5b3c <printf>
    exit(1);
    2f3e:	4505                	li	a0,1
    2f40:	796020ef          	jal	56d6 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2f44:	85ca                	mv	a1,s2
    2f46:	00004517          	auipc	a0,0x4
    2f4a:	13a50513          	addi	a0,a0,314 # 7080 <malloc+0x1488>
    2f4e:	3ef020ef          	jal	5b3c <printf>
    exit(1);
    2f52:	4505                	li	a0,1
    2f54:	782020ef          	jal	56d6 <exit>
    printf("%s: chdir dd failed\n", s);
    2f58:	85ca                	mv	a1,s2
    2f5a:	00004517          	auipc	a0,0x4
    2f5e:	14e50513          	addi	a0,a0,334 # 70a8 <malloc+0x14b0>
    2f62:	3db020ef          	jal	5b3c <printf>
    exit(1);
    2f66:	4505                	li	a0,1
    2f68:	76e020ef          	jal	56d6 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2f6c:	85ca                	mv	a1,s2
    2f6e:	00004517          	auipc	a0,0x4
    2f72:	16250513          	addi	a0,a0,354 # 70d0 <malloc+0x14d8>
    2f76:	3c7020ef          	jal	5b3c <printf>
    exit(1);
    2f7a:	4505                	li	a0,1
    2f7c:	75a020ef          	jal	56d6 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    2f80:	85ca                	mv	a1,s2
    2f82:	00004517          	auipc	a0,0x4
    2f86:	17e50513          	addi	a0,a0,382 # 7100 <malloc+0x1508>
    2f8a:	3b3020ef          	jal	5b3c <printf>
    exit(1);
    2f8e:	4505                	li	a0,1
    2f90:	746020ef          	jal	56d6 <exit>
    printf("%s: chdir ./.. failed\n", s);
    2f94:	85ca                	mv	a1,s2
    2f96:	00004517          	auipc	a0,0x4
    2f9a:	19a50513          	addi	a0,a0,410 # 7130 <malloc+0x1538>
    2f9e:	39f020ef          	jal	5b3c <printf>
    exit(1);
    2fa2:	4505                	li	a0,1
    2fa4:	732020ef          	jal	56d6 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2fa8:	85ca                	mv	a1,s2
    2faa:	00004517          	auipc	a0,0x4
    2fae:	19e50513          	addi	a0,a0,414 # 7148 <malloc+0x1550>
    2fb2:	38b020ef          	jal	5b3c <printf>
    exit(1);
    2fb6:	4505                	li	a0,1
    2fb8:	71e020ef          	jal	56d6 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2fbc:	85ca                	mv	a1,s2
    2fbe:	00004517          	auipc	a0,0x4
    2fc2:	1aa50513          	addi	a0,a0,426 # 7168 <malloc+0x1570>
    2fc6:	377020ef          	jal	5b3c <printf>
    exit(1);
    2fca:	4505                	li	a0,1
    2fcc:	70a020ef          	jal	56d6 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    2fd0:	85ca                	mv	a1,s2
    2fd2:	00004517          	auipc	a0,0x4
    2fd6:	1b650513          	addi	a0,a0,438 # 7188 <malloc+0x1590>
    2fda:	363020ef          	jal	5b3c <printf>
    exit(1);
    2fde:	4505                	li	a0,1
    2fe0:	6f6020ef          	jal	56d6 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    2fe4:	85ca                	mv	a1,s2
    2fe6:	00004517          	auipc	a0,0x4
    2fea:	1e250513          	addi	a0,a0,482 # 71c8 <malloc+0x15d0>
    2fee:	34f020ef          	jal	5b3c <printf>
    exit(1);
    2ff2:	4505                	li	a0,1
    2ff4:	6e2020ef          	jal	56d6 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    2ff8:	85ca                	mv	a1,s2
    2ffa:	00004517          	auipc	a0,0x4
    2ffe:	1fe50513          	addi	a0,a0,510 # 71f8 <malloc+0x1600>
    3002:	33b020ef          	jal	5b3c <printf>
    exit(1);
    3006:	4505                	li	a0,1
    3008:	6ce020ef          	jal	56d6 <exit>
    printf("%s: create dd succeeded!\n", s);
    300c:	85ca                	mv	a1,s2
    300e:	00004517          	auipc	a0,0x4
    3012:	20a50513          	addi	a0,a0,522 # 7218 <malloc+0x1620>
    3016:	327020ef          	jal	5b3c <printf>
    exit(1);
    301a:	4505                	li	a0,1
    301c:	6ba020ef          	jal	56d6 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3020:	85ca                	mv	a1,s2
    3022:	00004517          	auipc	a0,0x4
    3026:	21650513          	addi	a0,a0,534 # 7238 <malloc+0x1640>
    302a:	313020ef          	jal	5b3c <printf>
    exit(1);
    302e:	4505                	li	a0,1
    3030:	6a6020ef          	jal	56d6 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3034:	85ca                	mv	a1,s2
    3036:	00004517          	auipc	a0,0x4
    303a:	22250513          	addi	a0,a0,546 # 7258 <malloc+0x1660>
    303e:	2ff020ef          	jal	5b3c <printf>
    exit(1);
    3042:	4505                	li	a0,1
    3044:	692020ef          	jal	56d6 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3048:	85ca                	mv	a1,s2
    304a:	00004517          	auipc	a0,0x4
    304e:	23e50513          	addi	a0,a0,574 # 7288 <malloc+0x1690>
    3052:	2eb020ef          	jal	5b3c <printf>
    exit(1);
    3056:	4505                	li	a0,1
    3058:	67e020ef          	jal	56d6 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    305c:	85ca                	mv	a1,s2
    305e:	00004517          	auipc	a0,0x4
    3062:	25250513          	addi	a0,a0,594 # 72b0 <malloc+0x16b8>
    3066:	2d7020ef          	jal	5b3c <printf>
    exit(1);
    306a:	4505                	li	a0,1
    306c:	66a020ef          	jal	56d6 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3070:	85ca                	mv	a1,s2
    3072:	00004517          	auipc	a0,0x4
    3076:	26650513          	addi	a0,a0,614 # 72d8 <malloc+0x16e0>
    307a:	2c3020ef          	jal	5b3c <printf>
    exit(1);
    307e:	4505                	li	a0,1
    3080:	656020ef          	jal	56d6 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3084:	85ca                	mv	a1,s2
    3086:	00004517          	auipc	a0,0x4
    308a:	27a50513          	addi	a0,a0,634 # 7300 <malloc+0x1708>
    308e:	2af020ef          	jal	5b3c <printf>
    exit(1);
    3092:	4505                	li	a0,1
    3094:	642020ef          	jal	56d6 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3098:	85ca                	mv	a1,s2
    309a:	00004517          	auipc	a0,0x4
    309e:	28650513          	addi	a0,a0,646 # 7320 <malloc+0x1728>
    30a2:	29b020ef          	jal	5b3c <printf>
    exit(1);
    30a6:	4505                	li	a0,1
    30a8:	62e020ef          	jal	56d6 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    30ac:	85ca                	mv	a1,s2
    30ae:	00004517          	auipc	a0,0x4
    30b2:	29250513          	addi	a0,a0,658 # 7340 <malloc+0x1748>
    30b6:	287020ef          	jal	5b3c <printf>
    exit(1);
    30ba:	4505                	li	a0,1
    30bc:	61a020ef          	jal	56d6 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    30c0:	85ca                	mv	a1,s2
    30c2:	00004517          	auipc	a0,0x4
    30c6:	2a650513          	addi	a0,a0,678 # 7368 <malloc+0x1770>
    30ca:	273020ef          	jal	5b3c <printf>
    exit(1);
    30ce:	4505                	li	a0,1
    30d0:	606020ef          	jal	56d6 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    30d4:	85ca                	mv	a1,s2
    30d6:	00004517          	auipc	a0,0x4
    30da:	2b250513          	addi	a0,a0,690 # 7388 <malloc+0x1790>
    30de:	25f020ef          	jal	5b3c <printf>
    exit(1);
    30e2:	4505                	li	a0,1
    30e4:	5f2020ef          	jal	56d6 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    30e8:	85ca                	mv	a1,s2
    30ea:	00004517          	auipc	a0,0x4
    30ee:	2be50513          	addi	a0,a0,702 # 73a8 <malloc+0x17b0>
    30f2:	24b020ef          	jal	5b3c <printf>
    exit(1);
    30f6:	4505                	li	a0,1
    30f8:	5de020ef          	jal	56d6 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    30fc:	85ca                	mv	a1,s2
    30fe:	00004517          	auipc	a0,0x4
    3102:	2d250513          	addi	a0,a0,722 # 73d0 <malloc+0x17d8>
    3106:	237020ef          	jal	5b3c <printf>
    exit(1);
    310a:	4505                	li	a0,1
    310c:	5ca020ef          	jal	56d6 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3110:	85ca                	mv	a1,s2
    3112:	00004517          	auipc	a0,0x4
    3116:	f4e50513          	addi	a0,a0,-178 # 7060 <malloc+0x1468>
    311a:	223020ef          	jal	5b3c <printf>
    exit(1);
    311e:	4505                	li	a0,1
    3120:	5b6020ef          	jal	56d6 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3124:	85ca                	mv	a1,s2
    3126:	00004517          	auipc	a0,0x4
    312a:	2ca50513          	addi	a0,a0,714 # 73f0 <malloc+0x17f8>
    312e:	20f020ef          	jal	5b3c <printf>
    exit(1);
    3132:	4505                	li	a0,1
    3134:	5a2020ef          	jal	56d6 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3138:	85ca                	mv	a1,s2
    313a:	00004517          	auipc	a0,0x4
    313e:	2d650513          	addi	a0,a0,726 # 7410 <malloc+0x1818>
    3142:	1fb020ef          	jal	5b3c <printf>
    exit(1);
    3146:	4505                	li	a0,1
    3148:	58e020ef          	jal	56d6 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    314c:	85ca                	mv	a1,s2
    314e:	00004517          	auipc	a0,0x4
    3152:	2f250513          	addi	a0,a0,754 # 7440 <malloc+0x1848>
    3156:	1e7020ef          	jal	5b3c <printf>
    exit(1);
    315a:	4505                	li	a0,1
    315c:	57a020ef          	jal	56d6 <exit>
    printf("%s: unlink dd failed\n", s);
    3160:	85ca                	mv	a1,s2
    3162:	00004517          	auipc	a0,0x4
    3166:	2fe50513          	addi	a0,a0,766 # 7460 <malloc+0x1868>
    316a:	1d3020ef          	jal	5b3c <printf>
    exit(1);
    316e:	4505                	li	a0,1
    3170:	566020ef          	jal	56d6 <exit>

0000000000003174 <rmdot>:
{
    3174:	1101                	addi	sp,sp,-32
    3176:	ec06                	sd	ra,24(sp)
    3178:	e822                	sd	s0,16(sp)
    317a:	e426                	sd	s1,8(sp)
    317c:	1000                	addi	s0,sp,32
    317e:	84aa                	mv	s1,a0
  if (mkdir("dots") != 0) {
    3180:	00004517          	auipc	a0,0x4
    3184:	2f850513          	addi	a0,a0,760 # 7478 <malloc+0x1880>
    3188:	5b6020ef          	jal	573e <mkdir>
    318c:	e53d                	bnez	a0,31fa <rmdot+0x86>
  if (chdir("dots") != 0) {
    318e:	00004517          	auipc	a0,0x4
    3192:	2ea50513          	addi	a0,a0,746 # 7478 <malloc+0x1880>
    3196:	5b0020ef          	jal	5746 <chdir>
    319a:	e935                	bnez	a0,320e <rmdot+0x9a>
  if (unlink(".") == 0) {
    319c:	00003517          	auipc	a0,0x3
    31a0:	27450513          	addi	a0,a0,628 # 6410 <malloc+0x818>
    31a4:	582020ef          	jal	5726 <unlink>
    31a8:	cd2d                	beqz	a0,3222 <rmdot+0xae>
  if (unlink("..") == 0) {
    31aa:	00004517          	auipc	a0,0x4
    31ae:	d1e50513          	addi	a0,a0,-738 # 6ec8 <malloc+0x12d0>
    31b2:	574020ef          	jal	5726 <unlink>
    31b6:	c141                	beqz	a0,3236 <rmdot+0xc2>
  if (chdir("/") != 0) {
    31b8:	00004517          	auipc	a0,0x4
    31bc:	cb850513          	addi	a0,a0,-840 # 6e70 <malloc+0x1278>
    31c0:	586020ef          	jal	5746 <chdir>
    31c4:	e159                	bnez	a0,324a <rmdot+0xd6>
  if (unlink("dots/.") == 0) {
    31c6:	00004517          	auipc	a0,0x4
    31ca:	31a50513          	addi	a0,a0,794 # 74e0 <malloc+0x18e8>
    31ce:	558020ef          	jal	5726 <unlink>
    31d2:	c551                	beqz	a0,325e <rmdot+0xea>
  if (unlink("dots/..") == 0) {
    31d4:	00004517          	auipc	a0,0x4
    31d8:	33450513          	addi	a0,a0,820 # 7508 <malloc+0x1910>
    31dc:	54a020ef          	jal	5726 <unlink>
    31e0:	c949                	beqz	a0,3272 <rmdot+0xfe>
  if (unlink("dots") != 0) {
    31e2:	00004517          	auipc	a0,0x4
    31e6:	29650513          	addi	a0,a0,662 # 7478 <malloc+0x1880>
    31ea:	53c020ef          	jal	5726 <unlink>
    31ee:	ed41                	bnez	a0,3286 <rmdot+0x112>
}
    31f0:	60e2                	ld	ra,24(sp)
    31f2:	6442                	ld	s0,16(sp)
    31f4:	64a2                	ld	s1,8(sp)
    31f6:	6105                	addi	sp,sp,32
    31f8:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    31fa:	85a6                	mv	a1,s1
    31fc:	00004517          	auipc	a0,0x4
    3200:	28450513          	addi	a0,a0,644 # 7480 <malloc+0x1888>
    3204:	139020ef          	jal	5b3c <printf>
    exit(1);
    3208:	4505                	li	a0,1
    320a:	4cc020ef          	jal	56d6 <exit>
    printf("%s: chdir dots failed\n", s);
    320e:	85a6                	mv	a1,s1
    3210:	00004517          	auipc	a0,0x4
    3214:	28850513          	addi	a0,a0,648 # 7498 <malloc+0x18a0>
    3218:	125020ef          	jal	5b3c <printf>
    exit(1);
    321c:	4505                	li	a0,1
    321e:	4b8020ef          	jal	56d6 <exit>
    printf("%s: rm . worked!\n", s);
    3222:	85a6                	mv	a1,s1
    3224:	00004517          	auipc	a0,0x4
    3228:	28c50513          	addi	a0,a0,652 # 74b0 <malloc+0x18b8>
    322c:	111020ef          	jal	5b3c <printf>
    exit(1);
    3230:	4505                	li	a0,1
    3232:	4a4020ef          	jal	56d6 <exit>
    printf("%s: rm .. worked!\n", s);
    3236:	85a6                	mv	a1,s1
    3238:	00004517          	auipc	a0,0x4
    323c:	29050513          	addi	a0,a0,656 # 74c8 <malloc+0x18d0>
    3240:	0fd020ef          	jal	5b3c <printf>
    exit(1);
    3244:	4505                	li	a0,1
    3246:	490020ef          	jal	56d6 <exit>
    printf("%s: chdir / failed\n", s);
    324a:	85a6                	mv	a1,s1
    324c:	00004517          	auipc	a0,0x4
    3250:	c2c50513          	addi	a0,a0,-980 # 6e78 <malloc+0x1280>
    3254:	0e9020ef          	jal	5b3c <printf>
    exit(1);
    3258:	4505                	li	a0,1
    325a:	47c020ef          	jal	56d6 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    325e:	85a6                	mv	a1,s1
    3260:	00004517          	auipc	a0,0x4
    3264:	28850513          	addi	a0,a0,648 # 74e8 <malloc+0x18f0>
    3268:	0d5020ef          	jal	5b3c <printf>
    exit(1);
    326c:	4505                	li	a0,1
    326e:	468020ef          	jal	56d6 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3272:	85a6                	mv	a1,s1
    3274:	00004517          	auipc	a0,0x4
    3278:	29c50513          	addi	a0,a0,668 # 7510 <malloc+0x1918>
    327c:	0c1020ef          	jal	5b3c <printf>
    exit(1);
    3280:	4505                	li	a0,1
    3282:	454020ef          	jal	56d6 <exit>
    printf("%s: unlink dots failed!\n", s);
    3286:	85a6                	mv	a1,s1
    3288:	00004517          	auipc	a0,0x4
    328c:	2a850513          	addi	a0,a0,680 # 7530 <malloc+0x1938>
    3290:	0ad020ef          	jal	5b3c <printf>
    exit(1);
    3294:	4505                	li	a0,1
    3296:	440020ef          	jal	56d6 <exit>

000000000000329a <dirfile>:
{
    329a:	1101                	addi	sp,sp,-32
    329c:	ec06                	sd	ra,24(sp)
    329e:	e822                	sd	s0,16(sp)
    32a0:	e426                	sd	s1,8(sp)
    32a2:	e04a                	sd	s2,0(sp)
    32a4:	1000                	addi	s0,sp,32
    32a6:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    32a8:	20000593          	li	a1,512
    32ac:	00004517          	auipc	a0,0x4
    32b0:	2a450513          	addi	a0,a0,676 # 7550 <malloc+0x1958>
    32b4:	462020ef          	jal	5716 <open>
  if (fd < 0) {
    32b8:	0c054563          	bltz	a0,3382 <dirfile+0xe8>
  close(fd);
    32bc:	442020ef          	jal	56fe <close>
  if (chdir("dirfile") == 0) {
    32c0:	00004517          	auipc	a0,0x4
    32c4:	29050513          	addi	a0,a0,656 # 7550 <malloc+0x1958>
    32c8:	47e020ef          	jal	5746 <chdir>
    32cc:	c569                	beqz	a0,3396 <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    32ce:	4581                	li	a1,0
    32d0:	00004517          	auipc	a0,0x4
    32d4:	2c850513          	addi	a0,a0,712 # 7598 <malloc+0x19a0>
    32d8:	43e020ef          	jal	5716 <open>
  if (fd >= 0) {
    32dc:	0c055763          	bgez	a0,33aa <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    32e0:	20000593          	li	a1,512
    32e4:	00004517          	auipc	a0,0x4
    32e8:	2b450513          	addi	a0,a0,692 # 7598 <malloc+0x19a0>
    32ec:	42a020ef          	jal	5716 <open>
  if (fd >= 0) {
    32f0:	0c055763          	bgez	a0,33be <dirfile+0x124>
  if (mkdir("dirfile/xx") == 0) {
    32f4:	00004517          	auipc	a0,0x4
    32f8:	2a450513          	addi	a0,a0,676 # 7598 <malloc+0x19a0>
    32fc:	442020ef          	jal	573e <mkdir>
    3300:	0c050963          	beqz	a0,33d2 <dirfile+0x138>
  if (unlink("dirfile/xx") == 0) {
    3304:	00004517          	auipc	a0,0x4
    3308:	29450513          	addi	a0,a0,660 # 7598 <malloc+0x19a0>
    330c:	41a020ef          	jal	5726 <unlink>
    3310:	0c050b63          	beqz	a0,33e6 <dirfile+0x14c>
  if (link("README", "dirfile/xx") == 0) {
    3314:	00004597          	auipc	a1,0x4
    3318:	28458593          	addi	a1,a1,644 # 7598 <malloc+0x19a0>
    331c:	00003517          	auipc	a0,0x3
    3320:	be450513          	addi	a0,a0,-1052 # 5f00 <malloc+0x308>
    3324:	412020ef          	jal	5736 <link>
    3328:	0c050963          	beqz	a0,33fa <dirfile+0x160>
  if (unlink("dirfile") != 0) {
    332c:	00004517          	auipc	a0,0x4
    3330:	22450513          	addi	a0,a0,548 # 7550 <malloc+0x1958>
    3334:	3f2020ef          	jal	5726 <unlink>
    3338:	0c051b63          	bnez	a0,340e <dirfile+0x174>
  fd = open(".", O_RDWR);
    333c:	4589                	li	a1,2
    333e:	00003517          	auipc	a0,0x3
    3342:	0d250513          	addi	a0,a0,210 # 6410 <malloc+0x818>
    3346:	3d0020ef          	jal	5716 <open>
  if (fd >= 0) {
    334a:	0c055c63          	bgez	a0,3422 <dirfile+0x188>
  fd = open(".", 0);
    334e:	4581                	li	a1,0
    3350:	00003517          	auipc	a0,0x3
    3354:	0c050513          	addi	a0,a0,192 # 6410 <malloc+0x818>
    3358:	3be020ef          	jal	5716 <open>
    335c:	84aa                	mv	s1,a0
  if (write(fd, "x", 1) > 0) {
    335e:	4605                	li	a2,1
    3360:	00003597          	auipc	a1,0x3
    3364:	a3858593          	addi	a1,a1,-1480 # 5d98 <malloc+0x1a0>
    3368:	38e020ef          	jal	56f6 <write>
    336c:	0ca04563          	bgtz	a0,3436 <dirfile+0x19c>
  close(fd);
    3370:	8526                	mv	a0,s1
    3372:	38c020ef          	jal	56fe <close>
}
    3376:	60e2                	ld	ra,24(sp)
    3378:	6442                	ld	s0,16(sp)
    337a:	64a2                	ld	s1,8(sp)
    337c:	6902                	ld	s2,0(sp)
    337e:	6105                	addi	sp,sp,32
    3380:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3382:	85ca                	mv	a1,s2
    3384:	00004517          	auipc	a0,0x4
    3388:	1d450513          	addi	a0,a0,468 # 7558 <malloc+0x1960>
    338c:	7b0020ef          	jal	5b3c <printf>
    exit(1);
    3390:	4505                	li	a0,1
    3392:	344020ef          	jal	56d6 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3396:	85ca                	mv	a1,s2
    3398:	00004517          	auipc	a0,0x4
    339c:	1e050513          	addi	a0,a0,480 # 7578 <malloc+0x1980>
    33a0:	79c020ef          	jal	5b3c <printf>
    exit(1);
    33a4:	4505                	li	a0,1
    33a6:	330020ef          	jal	56d6 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33aa:	85ca                	mv	a1,s2
    33ac:	00004517          	auipc	a0,0x4
    33b0:	1fc50513          	addi	a0,a0,508 # 75a8 <malloc+0x19b0>
    33b4:	788020ef          	jal	5b3c <printf>
    exit(1);
    33b8:	4505                	li	a0,1
    33ba:	31c020ef          	jal	56d6 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33be:	85ca                	mv	a1,s2
    33c0:	00004517          	auipc	a0,0x4
    33c4:	1e850513          	addi	a0,a0,488 # 75a8 <malloc+0x19b0>
    33c8:	774020ef          	jal	5b3c <printf>
    exit(1);
    33cc:	4505                	li	a0,1
    33ce:	308020ef          	jal	56d6 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    33d2:	85ca                	mv	a1,s2
    33d4:	00004517          	auipc	a0,0x4
    33d8:	1fc50513          	addi	a0,a0,508 # 75d0 <malloc+0x19d8>
    33dc:	760020ef          	jal	5b3c <printf>
    exit(1);
    33e0:	4505                	li	a0,1
    33e2:	2f4020ef          	jal	56d6 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    33e6:	85ca                	mv	a1,s2
    33e8:	00004517          	auipc	a0,0x4
    33ec:	21050513          	addi	a0,a0,528 # 75f8 <malloc+0x1a00>
    33f0:	74c020ef          	jal	5b3c <printf>
    exit(1);
    33f4:	4505                	li	a0,1
    33f6:	2e0020ef          	jal	56d6 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    33fa:	85ca                	mv	a1,s2
    33fc:	00004517          	auipc	a0,0x4
    3400:	22450513          	addi	a0,a0,548 # 7620 <malloc+0x1a28>
    3404:	738020ef          	jal	5b3c <printf>
    exit(1);
    3408:	4505                	li	a0,1
    340a:	2cc020ef          	jal	56d6 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    340e:	85ca                	mv	a1,s2
    3410:	00004517          	auipc	a0,0x4
    3414:	23850513          	addi	a0,a0,568 # 7648 <malloc+0x1a50>
    3418:	724020ef          	jal	5b3c <printf>
    exit(1);
    341c:	4505                	li	a0,1
    341e:	2b8020ef          	jal	56d6 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3422:	85ca                	mv	a1,s2
    3424:	00004517          	auipc	a0,0x4
    3428:	24450513          	addi	a0,a0,580 # 7668 <malloc+0x1a70>
    342c:	710020ef          	jal	5b3c <printf>
    exit(1);
    3430:	4505                	li	a0,1
    3432:	2a4020ef          	jal	56d6 <exit>
    printf("%s: write . succeeded!\n", s);
    3436:	85ca                	mv	a1,s2
    3438:	00004517          	auipc	a0,0x4
    343c:	25850513          	addi	a0,a0,600 # 7690 <malloc+0x1a98>
    3440:	6fc020ef          	jal	5b3c <printf>
    exit(1);
    3444:	4505                	li	a0,1
    3446:	290020ef          	jal	56d6 <exit>

000000000000344a <iref>:
{
    344a:	715d                	addi	sp,sp,-80
    344c:	e486                	sd	ra,72(sp)
    344e:	e0a2                	sd	s0,64(sp)
    3450:	fc26                	sd	s1,56(sp)
    3452:	f84a                	sd	s2,48(sp)
    3454:	f44e                	sd	s3,40(sp)
    3456:	f052                	sd	s4,32(sp)
    3458:	ec56                	sd	s5,24(sp)
    345a:	e85a                	sd	s6,16(sp)
    345c:	e45e                	sd	s7,8(sp)
    345e:	0880                	addi	s0,sp,80
    3460:	8baa                	mv	s7,a0
    3462:	03300913          	li	s2,51
    if (mkdir("irefd") != 0) {
    3466:	00004a97          	auipc	s5,0x4
    346a:	242a8a93          	addi	s5,s5,578 # 76a8 <malloc+0x1ab0>
    mkdir("");
    346e:	00004497          	auipc	s1,0x4
    3472:	d4248493          	addi	s1,s1,-702 # 71b0 <malloc+0x15b8>
    link("README", "");
    3476:	00003b17          	auipc	s6,0x3
    347a:	a8ab0b13          	addi	s6,s6,-1398 # 5f00 <malloc+0x308>
    fd = open("", O_CREATE);
    347e:	20000a13          	li	s4,512
    fd = open("xx", O_CREATE);
    3482:	00004997          	auipc	s3,0x4
    3486:	11e98993          	addi	s3,s3,286 # 75a0 <malloc+0x19a8>
    348a:	a835                	j	34c6 <iref+0x7c>
      printf("%s: mkdir irefd failed\n", s);
    348c:	85de                	mv	a1,s7
    348e:	00004517          	auipc	a0,0x4
    3492:	22250513          	addi	a0,a0,546 # 76b0 <malloc+0x1ab8>
    3496:	6a6020ef          	jal	5b3c <printf>
      exit(1);
    349a:	4505                	li	a0,1
    349c:	23a020ef          	jal	56d6 <exit>
      printf("%s: chdir irefd failed\n", s);
    34a0:	85de                	mv	a1,s7
    34a2:	00004517          	auipc	a0,0x4
    34a6:	22650513          	addi	a0,a0,550 # 76c8 <malloc+0x1ad0>
    34aa:	692020ef          	jal	5b3c <printf>
      exit(1);
    34ae:	4505                	li	a0,1
    34b0:	226020ef          	jal	56d6 <exit>
      close(fd);
    34b4:	24a020ef          	jal	56fe <close>
    34b8:	a825                	j	34f0 <iref+0xa6>
    unlink("xx");
    34ba:	854e                	mv	a0,s3
    34bc:	26a020ef          	jal	5726 <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    34c0:	397d                	addiw	s2,s2,-1
    34c2:	04090063          	beqz	s2,3502 <iref+0xb8>
    if (mkdir("irefd") != 0) {
    34c6:	8556                	mv	a0,s5
    34c8:	276020ef          	jal	573e <mkdir>
    34cc:	f161                	bnez	a0,348c <iref+0x42>
    if (chdir("irefd") != 0) {
    34ce:	8556                	mv	a0,s5
    34d0:	276020ef          	jal	5746 <chdir>
    34d4:	f571                	bnez	a0,34a0 <iref+0x56>
    mkdir("");
    34d6:	8526                	mv	a0,s1
    34d8:	266020ef          	jal	573e <mkdir>
    link("README", "");
    34dc:	85a6                	mv	a1,s1
    34de:	855a                	mv	a0,s6
    34e0:	256020ef          	jal	5736 <link>
    fd = open("", O_CREATE);
    34e4:	85d2                	mv	a1,s4
    34e6:	8526                	mv	a0,s1
    34e8:	22e020ef          	jal	5716 <open>
    if (fd >= 0)
    34ec:	fc0554e3          	bgez	a0,34b4 <iref+0x6a>
    fd = open("xx", O_CREATE);
    34f0:	85d2                	mv	a1,s4
    34f2:	854e                	mv	a0,s3
    34f4:	222020ef          	jal	5716 <open>
    if (fd >= 0)
    34f8:	fc0541e3          	bltz	a0,34ba <iref+0x70>
      close(fd);
    34fc:	202020ef          	jal	56fe <close>
    3500:	bf6d                	j	34ba <iref+0x70>
  for (i = 0; i < NINODE + 1; i++) {
    3502:	03300493          	li	s1,51
    chdir("..");
    3506:	00004997          	auipc	s3,0x4
    350a:	9c298993          	addi	s3,s3,-1598 # 6ec8 <malloc+0x12d0>
    unlink("irefd");
    350e:	00004917          	auipc	s2,0x4
    3512:	19a90913          	addi	s2,s2,410 # 76a8 <malloc+0x1ab0>
    chdir("..");
    3516:	854e                	mv	a0,s3
    3518:	22e020ef          	jal	5746 <chdir>
    unlink("irefd");
    351c:	854a                	mv	a0,s2
    351e:	208020ef          	jal	5726 <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    3522:	34fd                	addiw	s1,s1,-1
    3524:	f8ed                	bnez	s1,3516 <iref+0xcc>
  chdir("/");
    3526:	00004517          	auipc	a0,0x4
    352a:	94a50513          	addi	a0,a0,-1718 # 6e70 <malloc+0x1278>
    352e:	218020ef          	jal	5746 <chdir>
}
    3532:	60a6                	ld	ra,72(sp)
    3534:	6406                	ld	s0,64(sp)
    3536:	74e2                	ld	s1,56(sp)
    3538:	7942                	ld	s2,48(sp)
    353a:	79a2                	ld	s3,40(sp)
    353c:	7a02                	ld	s4,32(sp)
    353e:	6ae2                	ld	s5,24(sp)
    3540:	6b42                	ld	s6,16(sp)
    3542:	6ba2                	ld	s7,8(sp)
    3544:	6161                	addi	sp,sp,80
    3546:	8082                	ret

0000000000003548 <unlinkcwd>:
{
    3548:	1101                	addi	sp,sp,-32
    354a:	ec06                	sd	ra,24(sp)
    354c:	e822                	sd	s0,16(sp)
    354e:	e426                	sd	s1,8(sp)
    3550:	1000                	addi	s0,sp,32
    3552:	84aa                	mv	s1,a0
  if (mkdir("/a") < 0) {
    3554:	00004517          	auipc	a0,0x4
    3558:	18c50513          	addi	a0,a0,396 # 76e0 <malloc+0x1ae8>
    355c:	1e2020ef          	jal	573e <mkdir>
    3560:	06054a63          	bltz	a0,35d4 <unlinkcwd+0x8c>
  if (mkdir("/a/b") < 0) {
    3564:	00004517          	auipc	a0,0x4
    3568:	19c50513          	addi	a0,a0,412 # 7700 <malloc+0x1b08>
    356c:	1d2020ef          	jal	573e <mkdir>
    3570:	06054c63          	bltz	a0,35e8 <unlinkcwd+0xa0>
  if (chdir("/a/b") < 0) {
    3574:	00004517          	auipc	a0,0x4
    3578:	18c50513          	addi	a0,a0,396 # 7700 <malloc+0x1b08>
    357c:	1ca020ef          	jal	5746 <chdir>
    3580:	06054e63          	bltz	a0,35fc <unlinkcwd+0xb4>
  if (unlink("/a/b") < 0) {
    3584:	00004517          	auipc	a0,0x4
    3588:	17c50513          	addi	a0,a0,380 # 7700 <malloc+0x1b08>
    358c:	19a020ef          	jal	5726 <unlink>
    3590:	08054063          	bltz	a0,3610 <unlinkcwd+0xc8>
  if (unlink("/a") < 0) {
    3594:	00004517          	auipc	a0,0x4
    3598:	14c50513          	addi	a0,a0,332 # 76e0 <malloc+0x1ae8>
    359c:	18a020ef          	jal	5726 <unlink>
    35a0:	08054263          	bltz	a0,3624 <unlinkcwd+0xdc>
  if (open("../", O_RDONLY) > 0) {
    35a4:	4581                	li	a1,0
    35a6:	00004517          	auipc	a0,0x4
    35aa:	1c250513          	addi	a0,a0,450 # 7768 <malloc+0x1b70>
    35ae:	168020ef          	jal	5716 <open>
    35b2:	08a04363          	bgtz	a0,3638 <unlinkcwd+0xf0>
  if (open("../c", O_CREATE) > 0) {
    35b6:	20000593          	li	a1,512
    35ba:	00004517          	auipc	a0,0x4
    35be:	1de50513          	addi	a0,a0,478 # 7798 <malloc+0x1ba0>
    35c2:	154020ef          	jal	5716 <open>
    35c6:	08a04163          	bgtz	a0,3648 <unlinkcwd+0x100>
}
    35ca:	60e2                	ld	ra,24(sp)
    35cc:	6442                	ld	s0,16(sp)
    35ce:	64a2                	ld	s1,8(sp)
    35d0:	6105                	addi	sp,sp,32
    35d2:	8082                	ret
    printf("%s: mkdir /a failed\n", s);
    35d4:	85a6                	mv	a1,s1
    35d6:	00004517          	auipc	a0,0x4
    35da:	11250513          	addi	a0,a0,274 # 76e8 <malloc+0x1af0>
    35de:	55e020ef          	jal	5b3c <printf>
    exit(1);
    35e2:	4505                	li	a0,1
    35e4:	0f2020ef          	jal	56d6 <exit>
    printf("%s: mkdir /a/b failed\n", s);
    35e8:	85a6                	mv	a1,s1
    35ea:	00004517          	auipc	a0,0x4
    35ee:	11e50513          	addi	a0,a0,286 # 7708 <malloc+0x1b10>
    35f2:	54a020ef          	jal	5b3c <printf>
    exit(1);
    35f6:	4505                	li	a0,1
    35f8:	0de020ef          	jal	56d6 <exit>
    printf("%s: chdir failed\n", s);
    35fc:	85a6                	mv	a1,s1
    35fe:	00004517          	auipc	a0,0x4
    3602:	12250513          	addi	a0,a0,290 # 7720 <malloc+0x1b28>
    3606:	536020ef          	jal	5b3c <printf>
    exit(1);
    360a:	4505                	li	a0,1
    360c:	0ca020ef          	jal	56d6 <exit>
    printf("%s: unlink /a/b failed\n", s);
    3610:	85a6                	mv	a1,s1
    3612:	00004517          	auipc	a0,0x4
    3616:	12650513          	addi	a0,a0,294 # 7738 <malloc+0x1b40>
    361a:	522020ef          	jal	5b3c <printf>
    exit(1);
    361e:	4505                	li	a0,1
    3620:	0b6020ef          	jal	56d6 <exit>
    printf("%s: unlink /a failed\n", s);
    3624:	85a6                	mv	a1,s1
    3626:	00004517          	auipc	a0,0x4
    362a:	12a50513          	addi	a0,a0,298 # 7750 <malloc+0x1b58>
    362e:	50e020ef          	jal	5b3c <printf>
    exit(1);
    3632:	4505                	li	a0,1
    3634:	0a2020ef          	jal	56d6 <exit>
    printf("%s: open ../ non-existing directory\n", s);
    3638:	85a6                	mv	a1,s1
    363a:	00004517          	auipc	a0,0x4
    363e:	13650513          	addi	a0,a0,310 # 7770 <malloc+0x1b78>
    3642:	4fa020ef          	jal	5b3c <printf>
    3646:	bf85                	j	35b6 <unlinkcwd+0x6e>
    printf("%s: create ../c non-existing file\n", s);
    3648:	85a6                	mv	a1,s1
    364a:	00004517          	auipc	a0,0x4
    364e:	15650513          	addi	a0,a0,342 # 77a0 <malloc+0x1ba8>
    3652:	4ea020ef          	jal	5b3c <printf>
}
    3656:	bf95                	j	35ca <unlinkcwd+0x82>

0000000000003658 <openiputtest>:
{
    3658:	7179                	addi	sp,sp,-48
    365a:	f406                	sd	ra,40(sp)
    365c:	f022                	sd	s0,32(sp)
    365e:	ec26                	sd	s1,24(sp)
    3660:	1800                	addi	s0,sp,48
    3662:	84aa                	mv	s1,a0
  if (mkdir("oidir") < 0) {
    3664:	00004517          	auipc	a0,0x4
    3668:	16450513          	addi	a0,a0,356 # 77c8 <malloc+0x1bd0>
    366c:	0d2020ef          	jal	573e <mkdir>
    3670:	02054a63          	bltz	a0,36a4 <openiputtest+0x4c>
  pid = fork();
    3674:	05a020ef          	jal	56ce <fork>
  if (pid < 0) {
    3678:	04054063          	bltz	a0,36b8 <openiputtest+0x60>
  if (pid == 0) {
    367c:	e939                	bnez	a0,36d2 <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    367e:	4589                	li	a1,2
    3680:	00004517          	auipc	a0,0x4
    3684:	14850513          	addi	a0,a0,328 # 77c8 <malloc+0x1bd0>
    3688:	08e020ef          	jal	5716 <open>
    if (fd >= 0) {
    368c:	04054063          	bltz	a0,36cc <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    3690:	85a6                	mv	a1,s1
    3692:	00004517          	auipc	a0,0x4
    3696:	15650513          	addi	a0,a0,342 # 77e8 <malloc+0x1bf0>
    369a:	4a2020ef          	jal	5b3c <printf>
      exit(1);
    369e:	4505                	li	a0,1
    36a0:	036020ef          	jal	56d6 <exit>
    printf("%s: mkdir oidir failed\n", s);
    36a4:	85a6                	mv	a1,s1
    36a6:	00004517          	auipc	a0,0x4
    36aa:	12a50513          	addi	a0,a0,298 # 77d0 <malloc+0x1bd8>
    36ae:	48e020ef          	jal	5b3c <printf>
    exit(1);
    36b2:	4505                	li	a0,1
    36b4:	022020ef          	jal	56d6 <exit>
    printf("%s: fork failed\n", s);
    36b8:	85a6                	mv	a1,s1
    36ba:	00003517          	auipc	a0,0x3
    36be:	efe50513          	addi	a0,a0,-258 # 65b8 <malloc+0x9c0>
    36c2:	47a020ef          	jal	5b3c <printf>
    exit(1);
    36c6:	4505                	li	a0,1
    36c8:	00e020ef          	jal	56d6 <exit>
    exit(0);
    36cc:	4501                	li	a0,0
    36ce:	008020ef          	jal	56d6 <exit>
  pause(1);
    36d2:	4505                	li	a0,1
    36d4:	092020ef          	jal	5766 <pause>
  if (unlink("oidir") != 0) {
    36d8:	00004517          	auipc	a0,0x4
    36dc:	0f050513          	addi	a0,a0,240 # 77c8 <malloc+0x1bd0>
    36e0:	046020ef          	jal	5726 <unlink>
    36e4:	c919                	beqz	a0,36fa <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    36e6:	85a6                	mv	a1,s1
    36e8:	00003517          	auipc	a0,0x3
    36ec:	05850513          	addi	a0,a0,88 # 6740 <malloc+0xb48>
    36f0:	44c020ef          	jal	5b3c <printf>
    exit(1);
    36f4:	4505                	li	a0,1
    36f6:	7e1010ef          	jal	56d6 <exit>
  wait(&xstatus);
    36fa:	fdc40513          	addi	a0,s0,-36
    36fe:	7e1010ef          	jal	56de <wait>
  exit(xstatus);
    3702:	fdc42503          	lw	a0,-36(s0)
    3706:	7d1010ef          	jal	56d6 <exit>

000000000000370a <forkforkfork>:
{
    370a:	1101                	addi	sp,sp,-32
    370c:	ec06                	sd	ra,24(sp)
    370e:	e822                	sd	s0,16(sp)
    3710:	e426                	sd	s1,8(sp)
    3712:	1000                	addi	s0,sp,32
    3714:	84aa                	mv	s1,a0
  unlink("stopforking");
    3716:	00004517          	auipc	a0,0x4
    371a:	0fa50513          	addi	a0,a0,250 # 7810 <malloc+0x1c18>
    371e:	008020ef          	jal	5726 <unlink>
  int pid = fork();
    3722:	7ad010ef          	jal	56ce <fork>
  if (pid < 0) {
    3726:	02054b63          	bltz	a0,375c <forkforkfork+0x52>
  if (pid == 0) {
    372a:	c125                	beqz	a0,378a <forkforkfork+0x80>
  pause(20); // two seconds
    372c:	4551                	li	a0,20
    372e:	038020ef          	jal	5766 <pause>
  close(open("stopforking", O_CREATE | O_RDWR));
    3732:	20200593          	li	a1,514
    3736:	00004517          	auipc	a0,0x4
    373a:	0da50513          	addi	a0,a0,218 # 7810 <malloc+0x1c18>
    373e:	7d9010ef          	jal	5716 <open>
    3742:	7bd010ef          	jal	56fe <close>
  wait(0);
    3746:	4501                	li	a0,0
    3748:	797010ef          	jal	56de <wait>
  pause(10); // one second
    374c:	4529                	li	a0,10
    374e:	018020ef          	jal	5766 <pause>
}
    3752:	60e2                	ld	ra,24(sp)
    3754:	6442                	ld	s0,16(sp)
    3756:	64a2                	ld	s1,8(sp)
    3758:	6105                	addi	sp,sp,32
    375a:	8082                	ret
    printf("%s: fork failed", s);
    375c:	85a6                	mv	a1,s1
    375e:	00003517          	auipc	a0,0x3
    3762:	f9a50513          	addi	a0,a0,-102 # 66f8 <malloc+0xb00>
    3766:	3d6020ef          	jal	5b3c <printf>
    exit(1);
    376a:	4505                	li	a0,1
    376c:	76b010ef          	jal	56d6 <exit>
        exit(0);
    3770:	4501                	li	a0,0
    3772:	765010ef          	jal	56d6 <exit>
        close(open("stopforking", O_CREATE | O_RDWR));
    3776:	20200593          	li	a1,514
    377a:	00004517          	auipc	a0,0x4
    377e:	09650513          	addi	a0,a0,150 # 7810 <malloc+0x1c18>
    3782:	795010ef          	jal	5716 <open>
    3786:	779010ef          	jal	56fe <close>
      int fd = open("stopforking", 0);
    378a:	4581                	li	a1,0
    378c:	00004517          	auipc	a0,0x4
    3790:	08450513          	addi	a0,a0,132 # 7810 <malloc+0x1c18>
    3794:	783010ef          	jal	5716 <open>
      if (fd >= 0) {
    3798:	fc055ce3          	bgez	a0,3770 <forkforkfork+0x66>
      if (fork() < 0) {
    379c:	733010ef          	jal	56ce <fork>
    37a0:	fe0555e3          	bgez	a0,378a <forkforkfork+0x80>
    37a4:	bfc9                	j	3776 <forkforkfork+0x6c>

00000000000037a6 <exectest>:
{
    37a6:	711d                	addi	sp,sp,-96
    37a8:	ec86                	sd	ra,88(sp)
    37aa:	e8a2                	sd	s0,80(sp)
    37ac:	e0ca                	sd	s2,64(sp)
    37ae:	1080                	addi	s0,sp,96
    37b0:	892a                	mv	s2,a0
  char *echoargv[] = {"echo", "OK", 0};
    37b2:	00002797          	auipc	a5,0x2
    37b6:	57678793          	addi	a5,a5,1398 # 5d28 <malloc+0x130>
    37ba:	faf43823          	sd	a5,-80(s0)
    37be:	00004797          	auipc	a5,0x4
    37c2:	06278793          	addi	a5,a5,98 # 7820 <malloc+0x1c28>
    37c6:	faf43c23          	sd	a5,-72(s0)
    37ca:	fc043023          	sd	zero,-64(s0)
  unlink("echo-ok");
    37ce:	00004517          	auipc	a0,0x4
    37d2:	05a50513          	addi	a0,a0,90 # 7828 <malloc+0x1c30>
    37d6:	751010ef          	jal	5726 <unlink>
  pid = fork();
    37da:	6f5010ef          	jal	56ce <fork>
  if (pid < 0) {
    37de:	04054763          	bltz	a0,382c <exectest+0x86>
    37e2:	e4a6                	sd	s1,72(sp)
    37e4:	fc4e                	sd	s3,56(sp)
    37e6:	84aa                	mv	s1,a0
  if (pid == 0) {
    37e8:	ed49                	bnez	a0,3882 <exectest+0xdc>
    int errfd = dup(1);
    37ea:	4505                	li	a0,1
    37ec:	763010ef          	jal	574e <dup>
    37f0:	89aa                	mv	s3,a0
    if (errfd < 0) {
    37f2:	04054963          	bltz	a0,3844 <exectest+0x9e>
    close(1);
    37f6:	4505                	li	a0,1
    37f8:	707010ef          	jal	56fe <close>
    fd = open("echo-ok", O_CREATE | O_WRONLY);
    37fc:	20100593          	li	a1,513
    3800:	00004517          	auipc	a0,0x4
    3804:	02850513          	addi	a0,a0,40 # 7828 <malloc+0x1c30>
    3808:	70f010ef          	jal	5716 <open>
    if (fd < 0) {
    380c:	04054663          	bltz	a0,3858 <exectest+0xb2>
    if (fd != 1) {
    3810:	4785                	li	a5,1
    3812:	04f50e63          	beq	a0,a5,386e <exectest+0xc8>
      fprintf(errfd, "%s: wrong fd\n", s);
    3816:	864a                	mv	a2,s2
    3818:	00004597          	auipc	a1,0x4
    381c:	02858593          	addi	a1,a1,40 # 7840 <malloc+0x1c48>
    3820:	854e                	mv	a0,s3
    3822:	2f0020ef          	jal	5b12 <fprintf>
      exit(1);
    3826:	4505                	li	a0,1
    3828:	6af010ef          	jal	56d6 <exit>
    382c:	e4a6                	sd	s1,72(sp)
    382e:	fc4e                	sd	s3,56(sp)
    printf("%s: fork failed\n", s);
    3830:	85ca                	mv	a1,s2
    3832:	00003517          	auipc	a0,0x3
    3836:	d8650513          	addi	a0,a0,-634 # 65b8 <malloc+0x9c0>
    383a:	302020ef          	jal	5b3c <printf>
    exit(1);
    383e:	4505                	li	a0,1
    3840:	697010ef          	jal	56d6 <exit>
      printf("%s: dup failed\n", s);
    3844:	85ca                	mv	a1,s2
    3846:	00004517          	auipc	a0,0x4
    384a:	fea50513          	addi	a0,a0,-22 # 7830 <malloc+0x1c38>
    384e:	2ee020ef          	jal	5b3c <printf>
      exit(1);
    3852:	4505                	li	a0,1
    3854:	683010ef          	jal	56d6 <exit>
      fprintf(errfd, "%s: create failed\n", s);
    3858:	864a                	mv	a2,s2
    385a:	00003597          	auipc	a1,0x3
    385e:	ece58593          	addi	a1,a1,-306 # 6728 <malloc+0xb30>
    3862:	854e                	mv	a0,s3
    3864:	2ae020ef          	jal	5b12 <fprintf>
      exit(1);
    3868:	4505                	li	a0,1
    386a:	66d010ef          	jal	56d6 <exit>
    if (exec("echo", echoargv) < 0) {
    386e:	fb040593          	addi	a1,s0,-80
    3872:	00002517          	auipc	a0,0x2
    3876:	4b650513          	addi	a0,a0,1206 # 5d28 <malloc+0x130>
    387a:	695010ef          	jal	570e <exec>
    387e:	02054563          	bltz	a0,38a8 <exectest+0x102>
  if (wait(&xstatus) != pid) {
    3882:	fcc40513          	addi	a0,s0,-52
    3886:	659010ef          	jal	56de <wait>
    388a:	02951a63          	bne	a0,s1,38be <exectest+0x118>
  if (xstatus != 0) {
    388e:	fcc42603          	lw	a2,-52(s0)
    3892:	ce15                	beqz	a2,38ce <exectest+0x128>
    printf("%s: nonzero wait status %d\n", s, xstatus);
    3894:	85ca                	mv	a1,s2
    3896:	00004517          	auipc	a0,0x4
    389a:	fea50513          	addi	a0,a0,-22 # 7880 <malloc+0x1c88>
    389e:	29e020ef          	jal	5b3c <printf>
    exit(1);
    38a2:	4505                	li	a0,1
    38a4:	633010ef          	jal	56d6 <exit>
      fprintf(errfd, "%s: exec echo failed\n", s);
    38a8:	864a                	mv	a2,s2
    38aa:	00004597          	auipc	a1,0x4
    38ae:	fa658593          	addi	a1,a1,-90 # 7850 <malloc+0x1c58>
    38b2:	854e                	mv	a0,s3
    38b4:	25e020ef          	jal	5b12 <fprintf>
      exit(1);
    38b8:	4505                	li	a0,1
    38ba:	61d010ef          	jal	56d6 <exit>
    printf("%s: wait failed!\n", s);
    38be:	85ca                	mv	a1,s2
    38c0:	00004517          	auipc	a0,0x4
    38c4:	fa850513          	addi	a0,a0,-88 # 7868 <malloc+0x1c70>
    38c8:	274020ef          	jal	5b3c <printf>
    38cc:	b7c9                	j	388e <exectest+0xe8>
  fd = open("echo-ok", O_RDONLY);
    38ce:	4581                	li	a1,0
    38d0:	00004517          	auipc	a0,0x4
    38d4:	f5850513          	addi	a0,a0,-168 # 7828 <malloc+0x1c30>
    38d8:	63f010ef          	jal	5716 <open>
  if (fd < 0) {
    38dc:	02054463          	bltz	a0,3904 <exectest+0x15e>
  if (read(fd, buf, 2) != 2) {
    38e0:	4609                	li	a2,2
    38e2:	fa840593          	addi	a1,s0,-88
    38e6:	609010ef          	jal	56ee <read>
    38ea:	4789                	li	a5,2
    38ec:	02f50663          	beq	a0,a5,3918 <exectest+0x172>
    printf("%s: read failed\n", s);
    38f0:	85ca                	mv	a1,s2
    38f2:	00003517          	auipc	a0,0x3
    38f6:	80650513          	addi	a0,a0,-2042 # 60f8 <malloc+0x500>
    38fa:	242020ef          	jal	5b3c <printf>
    exit(1);
    38fe:	4505                	li	a0,1
    3900:	5d7010ef          	jal	56d6 <exit>
    printf("%s: open failed\n", s);
    3904:	85ca                	mv	a1,s2
    3906:	00003517          	auipc	a0,0x3
    390a:	cca50513          	addi	a0,a0,-822 # 65d0 <malloc+0x9d8>
    390e:	22e020ef          	jal	5b3c <printf>
    exit(1);
    3912:	4505                	li	a0,1
    3914:	5c3010ef          	jal	56d6 <exit>
  unlink("echo-ok");
    3918:	00004517          	auipc	a0,0x4
    391c:	f1050513          	addi	a0,a0,-240 # 7828 <malloc+0x1c30>
    3920:	607010ef          	jal	5726 <unlink>
  if (buf[0] == 'O' && buf[1] == 'K')
    3924:	fa844703          	lbu	a4,-88(s0)
    3928:	04f00793          	li	a5,79
    392c:	00f71863          	bne	a4,a5,393c <exectest+0x196>
    3930:	fa944703          	lbu	a4,-87(s0)
    3934:	04b00793          	li	a5,75
    3938:	00f70c63          	beq	a4,a5,3950 <exectest+0x1aa>
    printf("%s: wrong output\n", s);
    393c:	85ca                	mv	a1,s2
    393e:	00004517          	auipc	a0,0x4
    3942:	f6250513          	addi	a0,a0,-158 # 78a0 <malloc+0x1ca8>
    3946:	1f6020ef          	jal	5b3c <printf>
    exit(1);
    394a:	4505                	li	a0,1
    394c:	58b010ef          	jal	56d6 <exit>
    exit(0);
    3950:	4501                	li	a0,0
    3952:	585010ef          	jal	56d6 <exit>

0000000000003956 <killstatus>:
{
    3956:	715d                	addi	sp,sp,-80
    3958:	e486                	sd	ra,72(sp)
    395a:	e0a2                	sd	s0,64(sp)
    395c:	fc26                	sd	s1,56(sp)
    395e:	f84a                	sd	s2,48(sp)
    3960:	f44e                	sd	s3,40(sp)
    3962:	f052                	sd	s4,32(sp)
    3964:	ec56                	sd	s5,24(sp)
    3966:	e85a                	sd	s6,16(sp)
    3968:	0880                	addi	s0,sp,80
    396a:	8b2a                	mv	s6,a0
    396c:	06400913          	li	s2,100
    pause(1);
    3970:	4a85                	li	s5,1
    wait(&xst);
    3972:	fbc40a13          	addi	s4,s0,-68
    if (xst != -1) {
    3976:	59fd                	li	s3,-1
    int pid1 = fork();
    3978:	557010ef          	jal	56ce <fork>
    397c:	84aa                	mv	s1,a0
    if (pid1 < 0) {
    397e:	02054663          	bltz	a0,39aa <killstatus+0x54>
    if (pid1 == 0) {
    3982:	cd15                	beqz	a0,39be <killstatus+0x68>
    pause(1);
    3984:	8556                	mv	a0,s5
    3986:	5e1010ef          	jal	5766 <pause>
    kill(pid1);
    398a:	8526                	mv	a0,s1
    398c:	57b010ef          	jal	5706 <kill>
    wait(&xst);
    3990:	8552                	mv	a0,s4
    3992:	54d010ef          	jal	56de <wait>
    if (xst != -1) {
    3996:	fbc42783          	lw	a5,-68(s0)
    399a:	03379563          	bne	a5,s3,39c4 <killstatus+0x6e>
  for (int i = 0; i < 100; i++) {
    399e:	397d                	addiw	s2,s2,-1
    39a0:	fc091ce3          	bnez	s2,3978 <killstatus+0x22>
  exit(0);
    39a4:	4501                	li	a0,0
    39a6:	531010ef          	jal	56d6 <exit>
      printf("%s: fork failed\n", s);
    39aa:	85da                	mv	a1,s6
    39ac:	00003517          	auipc	a0,0x3
    39b0:	c0c50513          	addi	a0,a0,-1012 # 65b8 <malloc+0x9c0>
    39b4:	188020ef          	jal	5b3c <printf>
      exit(1);
    39b8:	4505                	li	a0,1
    39ba:	51d010ef          	jal	56d6 <exit>
        getpid();
    39be:	599010ef          	jal	5756 <getpid>
      while (1) {
    39c2:	bff5                	j	39be <killstatus+0x68>
      printf("%s: status should be -1\n", s);
    39c4:	85da                	mv	a1,s6
    39c6:	00004517          	auipc	a0,0x4
    39ca:	ef250513          	addi	a0,a0,-270 # 78b8 <malloc+0x1cc0>
    39ce:	16e020ef          	jal	5b3c <printf>
      exit(1);
    39d2:	4505                	li	a0,1
    39d4:	503010ef          	jal	56d6 <exit>

00000000000039d8 <preempt>:
{
    39d8:	7139                	addi	sp,sp,-64
    39da:	fc06                	sd	ra,56(sp)
    39dc:	f822                	sd	s0,48(sp)
    39de:	f426                	sd	s1,40(sp)
    39e0:	f04a                	sd	s2,32(sp)
    39e2:	ec4e                	sd	s3,24(sp)
    39e4:	e852                	sd	s4,16(sp)
    39e6:	0080                	addi	s0,sp,64
    39e8:	892a                	mv	s2,a0
  pid1 = fork();
    39ea:	4e5010ef          	jal	56ce <fork>
  if (pid1 < 0) {
    39ee:	00054563          	bltz	a0,39f8 <preempt+0x20>
    39f2:	84aa                	mv	s1,a0
  if (pid1 == 0)
    39f4:	ed01                	bnez	a0,3a0c <preempt+0x34>
    for (;;)
    39f6:	a001                	j	39f6 <preempt+0x1e>
    printf("%s: fork failed", s);
    39f8:	85ca                	mv	a1,s2
    39fa:	00003517          	auipc	a0,0x3
    39fe:	cfe50513          	addi	a0,a0,-770 # 66f8 <malloc+0xb00>
    3a02:	13a020ef          	jal	5b3c <printf>
    exit(1);
    3a06:	4505                	li	a0,1
    3a08:	4cf010ef          	jal	56d6 <exit>
  pid2 = fork();
    3a0c:	4c3010ef          	jal	56ce <fork>
    3a10:	89aa                	mv	s3,a0
  if (pid2 < 0) {
    3a12:	00054463          	bltz	a0,3a1a <preempt+0x42>
  if (pid2 == 0)
    3a16:	ed01                	bnez	a0,3a2e <preempt+0x56>
    for (;;)
    3a18:	a001                	j	3a18 <preempt+0x40>
    printf("%s: fork failed\n", s);
    3a1a:	85ca                	mv	a1,s2
    3a1c:	00003517          	auipc	a0,0x3
    3a20:	b9c50513          	addi	a0,a0,-1124 # 65b8 <malloc+0x9c0>
    3a24:	118020ef          	jal	5b3c <printf>
    exit(1);
    3a28:	4505                	li	a0,1
    3a2a:	4ad010ef          	jal	56d6 <exit>
  pipe(pfds);
    3a2e:	fc840513          	addi	a0,s0,-56
    3a32:	4b5010ef          	jal	56e6 <pipe>
  pid3 = fork();
    3a36:	499010ef          	jal	56ce <fork>
    3a3a:	8a2a                	mv	s4,a0
  if (pid3 < 0) {
    3a3c:	02054863          	bltz	a0,3a6c <preempt+0x94>
  if (pid3 == 0) {
    3a40:	e921                	bnez	a0,3a90 <preempt+0xb8>
    close(pfds[0]);
    3a42:	fc842503          	lw	a0,-56(s0)
    3a46:	4b9010ef          	jal	56fe <close>
    if (write(pfds[1], "x", 1) != 1)
    3a4a:	4605                	li	a2,1
    3a4c:	00002597          	auipc	a1,0x2
    3a50:	34c58593          	addi	a1,a1,844 # 5d98 <malloc+0x1a0>
    3a54:	fcc42503          	lw	a0,-52(s0)
    3a58:	49f010ef          	jal	56f6 <write>
    3a5c:	4785                	li	a5,1
    3a5e:	02f51163          	bne	a0,a5,3a80 <preempt+0xa8>
    close(pfds[1]);
    3a62:	fcc42503          	lw	a0,-52(s0)
    3a66:	499010ef          	jal	56fe <close>
    for (;;)
    3a6a:	a001                	j	3a6a <preempt+0x92>
    printf("%s: fork failed\n", s);
    3a6c:	85ca                	mv	a1,s2
    3a6e:	00003517          	auipc	a0,0x3
    3a72:	b4a50513          	addi	a0,a0,-1206 # 65b8 <malloc+0x9c0>
    3a76:	0c6020ef          	jal	5b3c <printf>
    exit(1);
    3a7a:	4505                	li	a0,1
    3a7c:	45b010ef          	jal	56d6 <exit>
      printf("%s: preempt write error", s);
    3a80:	85ca                	mv	a1,s2
    3a82:	00004517          	auipc	a0,0x4
    3a86:	e5650513          	addi	a0,a0,-426 # 78d8 <malloc+0x1ce0>
    3a8a:	0b2020ef          	jal	5b3c <printf>
    3a8e:	bfd1                	j	3a62 <preempt+0x8a>
  close(pfds[1]);
    3a90:	fcc42503          	lw	a0,-52(s0)
    3a94:	46b010ef          	jal	56fe <close>
  if (read(pfds[0], buf, sizeof(buf)) != 1) {
    3a98:	660d                	lui	a2,0x3
    3a9a:	0000a597          	auipc	a1,0xa
    3a9e:	24e58593          	addi	a1,a1,590 # dce8 <buf>
    3aa2:	fc842503          	lw	a0,-56(s0)
    3aa6:	449010ef          	jal	56ee <read>
    3aaa:	4785                	li	a5,1
    3aac:	00f50a63          	beq	a0,a5,3ac0 <preempt+0xe8>
    printf("%s: preempt read error", s);
    3ab0:	85ca                	mv	a1,s2
    3ab2:	00004517          	auipc	a0,0x4
    3ab6:	e3e50513          	addi	a0,a0,-450 # 78f0 <malloc+0x1cf8>
    3aba:	082020ef          	jal	5b3c <printf>
    return;
    3abe:	a099                	j	3b04 <preempt+0x12c>
  close(pfds[0]);
    3ac0:	fc842503          	lw	a0,-56(s0)
    3ac4:	43b010ef          	jal	56fe <close>
  printf("kill... ");
    3ac8:	00004517          	auipc	a0,0x4
    3acc:	e4050513          	addi	a0,a0,-448 # 7908 <malloc+0x1d10>
    3ad0:	06c020ef          	jal	5b3c <printf>
  kill(pid1);
    3ad4:	8526                	mv	a0,s1
    3ad6:	431010ef          	jal	5706 <kill>
  kill(pid2);
    3ada:	854e                	mv	a0,s3
    3adc:	42b010ef          	jal	5706 <kill>
  kill(pid3);
    3ae0:	8552                	mv	a0,s4
    3ae2:	425010ef          	jal	5706 <kill>
  printf("wait... ");
    3ae6:	00004517          	auipc	a0,0x4
    3aea:	e3250513          	addi	a0,a0,-462 # 7918 <malloc+0x1d20>
    3aee:	04e020ef          	jal	5b3c <printf>
  wait(0);
    3af2:	4501                	li	a0,0
    3af4:	3eb010ef          	jal	56de <wait>
  wait(0);
    3af8:	4501                	li	a0,0
    3afa:	3e5010ef          	jal	56de <wait>
  wait(0);
    3afe:	4501                	li	a0,0
    3b00:	3df010ef          	jal	56de <wait>
}
    3b04:	70e2                	ld	ra,56(sp)
    3b06:	7442                	ld	s0,48(sp)
    3b08:	74a2                	ld	s1,40(sp)
    3b0a:	7902                	ld	s2,32(sp)
    3b0c:	69e2                	ld	s3,24(sp)
    3b0e:	6a42                	ld	s4,16(sp)
    3b10:	6121                	addi	sp,sp,64
    3b12:	8082                	ret

0000000000003b14 <reparent>:
{
    3b14:	7179                	addi	sp,sp,-48
    3b16:	f406                	sd	ra,40(sp)
    3b18:	f022                	sd	s0,32(sp)
    3b1a:	ec26                	sd	s1,24(sp)
    3b1c:	e84a                	sd	s2,16(sp)
    3b1e:	e44e                	sd	s3,8(sp)
    3b20:	e052                	sd	s4,0(sp)
    3b22:	1800                	addi	s0,sp,48
    3b24:	89aa                	mv	s3,a0
  int master_pid = getpid();
    3b26:	431010ef          	jal	5756 <getpid>
    3b2a:	8a2a                	mv	s4,a0
    3b2c:	0c800913          	li	s2,200
    int pid = fork();
    3b30:	39f010ef          	jal	56ce <fork>
    3b34:	84aa                	mv	s1,a0
    if (pid < 0) {
    3b36:	00054e63          	bltz	a0,3b52 <reparent+0x3e>
    if (pid) {
    3b3a:	c121                	beqz	a0,3b7a <reparent+0x66>
      if (wait(0) != pid) {
    3b3c:	4501                	li	a0,0
    3b3e:	3a1010ef          	jal	56de <wait>
    3b42:	02951263          	bne	a0,s1,3b66 <reparent+0x52>
  for (int i = 0; i < 200; i++) {
    3b46:	397d                	addiw	s2,s2,-1
    3b48:	fe0914e3          	bnez	s2,3b30 <reparent+0x1c>
  exit(0);
    3b4c:	4501                	li	a0,0
    3b4e:	389010ef          	jal	56d6 <exit>
      printf("%s: fork failed\n", s);
    3b52:	85ce                	mv	a1,s3
    3b54:	00003517          	auipc	a0,0x3
    3b58:	a6450513          	addi	a0,a0,-1436 # 65b8 <malloc+0x9c0>
    3b5c:	7e1010ef          	jal	5b3c <printf>
      exit(1);
    3b60:	4505                	li	a0,1
    3b62:	375010ef          	jal	56d6 <exit>
        printf("%s: wait wrong pid\n", s);
    3b66:	85ce                	mv	a1,s3
    3b68:	00003517          	auipc	a0,0x3
    3b6c:	b5850513          	addi	a0,a0,-1192 # 66c0 <malloc+0xac8>
    3b70:	7cd010ef          	jal	5b3c <printf>
        exit(1);
    3b74:	4505                	li	a0,1
    3b76:	361010ef          	jal	56d6 <exit>
      int pid2 = fork();
    3b7a:	355010ef          	jal	56ce <fork>
      if (pid2 < 0) {
    3b7e:	00054563          	bltz	a0,3b88 <reparent+0x74>
      exit(0);
    3b82:	4501                	li	a0,0
    3b84:	353010ef          	jal	56d6 <exit>
        kill(master_pid);
    3b88:	8552                	mv	a0,s4
    3b8a:	37d010ef          	jal	5706 <kill>
        exit(1);
    3b8e:	4505                	li	a0,1
    3b90:	347010ef          	jal	56d6 <exit>

0000000000003b94 <sbrkfail>:
{
    3b94:	7175                	addi	sp,sp,-144
    3b96:	e506                	sd	ra,136(sp)
    3b98:	e122                	sd	s0,128(sp)
    3b9a:	fca6                	sd	s1,120(sp)
    3b9c:	f8ca                	sd	s2,112(sp)
    3b9e:	f4ce                	sd	s3,104(sp)
    3ba0:	f0d2                	sd	s4,96(sp)
    3ba2:	ecd6                	sd	s5,88(sp)
    3ba4:	e8da                	sd	s6,80(sp)
    3ba6:	e4de                	sd	s7,72(sp)
    3ba8:	e0e2                	sd	s8,64(sp)
    3baa:	0900                	addi	s0,sp,144
    3bac:	8c2a                	mv	s8,a0
  if (pipe(fds) != 0) {
    3bae:	fa040513          	addi	a0,s0,-96
    3bb2:	335010ef          	jal	56e6 <pipe>
    3bb6:	ed01                	bnez	a0,3bce <sbrkfail+0x3a>
    3bb8:	8baa                	mv	s7,a0
    3bba:	f7040493          	addi	s1,s0,-144
    3bbe:	f9840993          	addi	s3,s0,-104
    3bc2:	8926                	mv	s2,s1
    if (pids[i] != -1) {
    3bc4:	5a7d                	li	s4,-1
      read(fds[0], &scratch, 1);
    3bc6:	f9f40b13          	addi	s6,s0,-97
    3bca:	4a85                	li	s5,1
    3bcc:	a095                	j	3c30 <sbrkfail+0x9c>
    printf("%s: pipe() failed\n", s);
    3bce:	85e2                	mv	a1,s8
    3bd0:	00003517          	auipc	a0,0x3
    3bd4:	a7050513          	addi	a0,a0,-1424 # 6640 <malloc+0xa48>
    3bd8:	765010ef          	jal	5b3c <printf>
    exit(1);
    3bdc:	4505                	li	a0,1
    3bde:	2f9010ef          	jal	56d6 <exit>
      if (sbrk(BIG - (uint64)sbrk(0)) == (char *)SBRK_ERROR)
    3be2:	2c1010ef          	jal	56a2 <sbrk>
    3be6:	064007b7          	lui	a5,0x6400
    3bea:	40a7853b          	subw	a0,a5,a0
    3bee:	2b5010ef          	jal	56a2 <sbrk>
    3bf2:	57fd                	li	a5,-1
    3bf4:	02f50163          	beq	a0,a5,3c16 <sbrkfail+0x82>
        write(fds[1], "1", 1);
    3bf8:	4605                	li	a2,1
    3bfa:	00004597          	auipc	a1,0x4
    3bfe:	6d658593          	addi	a1,a1,1750 # 82d0 <malloc+0x26d8>
    3c02:	fa442503          	lw	a0,-92(s0)
    3c06:	2f1010ef          	jal	56f6 <write>
        pause(1000);
    3c0a:	3e800493          	li	s1,1000
    3c0e:	8526                	mv	a0,s1
    3c10:	357010ef          	jal	5766 <pause>
      for (;;)
    3c14:	bfed                	j	3c0e <sbrkfail+0x7a>
        write(fds[1], "0", 1);
    3c16:	4605                	li	a2,1
    3c18:	00004597          	auipc	a1,0x4
    3c1c:	d1058593          	addi	a1,a1,-752 # 7928 <malloc+0x1d30>
    3c20:	fa442503          	lw	a0,-92(s0)
    3c24:	2d3010ef          	jal	56f6 <write>
    3c28:	b7cd                	j	3c0a <sbrkfail+0x76>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    3c2a:	0911                	addi	s2,s2,4
    3c2c:	03390a63          	beq	s2,s3,3c60 <sbrkfail+0xcc>
    if ((pids[i] = fork()) == 0) {
    3c30:	29f010ef          	jal	56ce <fork>
    3c34:	00a92023          	sw	a0,0(s2)
    3c38:	d54d                	beqz	a0,3be2 <sbrkfail+0x4e>
    if (pids[i] != -1) {
    3c3a:	ff4508e3          	beq	a0,s4,3c2a <sbrkfail+0x96>
      read(fds[0], &scratch, 1);
    3c3e:	8656                	mv	a2,s5
    3c40:	85da                	mv	a1,s6
    3c42:	fa042503          	lw	a0,-96(s0)
    3c46:	2a9010ef          	jal	56ee <read>
      if (scratch == '0')
    3c4a:	f9f44783          	lbu	a5,-97(s0)
    3c4e:	fd078793          	addi	a5,a5,-48 # 63fffd0 <base+0x63ef2e8>
    3c52:	0017b793          	seqz	a5,a5
    3c56:	00fbe7b3          	or	a5,s7,a5
    3c5a:	00078b9b          	sext.w	s7,a5
    3c5e:	b7f1                	j	3c2a <sbrkfail+0x96>
  if (!failed) {
    3c60:	000b8863          	beqz	s7,3c70 <sbrkfail+0xdc>
  c = sbrk(PGSIZE);
    3c64:	6505                	lui	a0,0x1
    3c66:	23d010ef          	jal	56a2 <sbrk>
    3c6a:	8a2a                	mv	s4,a0
    if (pids[i] == -1)
    3c6c:	597d                	li	s2,-1
    3c6e:	a821                	j	3c86 <sbrkfail+0xf2>
    printf("%s: no allocation failed; allocate more?\n", s);
    3c70:	85e2                	mv	a1,s8
    3c72:	00004517          	auipc	a0,0x4
    3c76:	cbe50513          	addi	a0,a0,-834 # 7930 <malloc+0x1d38>
    3c7a:	6c3010ef          	jal	5b3c <printf>
    3c7e:	b7dd                	j	3c64 <sbrkfail+0xd0>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    3c80:	0491                	addi	s1,s1,4
    3c82:	01348b63          	beq	s1,s3,3c98 <sbrkfail+0x104>
    if (pids[i] == -1)
    3c86:	4088                	lw	a0,0(s1)
    3c88:	ff250ce3          	beq	a0,s2,3c80 <sbrkfail+0xec>
    kill(pids[i]);
    3c8c:	27b010ef          	jal	5706 <kill>
    wait(0);
    3c90:	4501                	li	a0,0
    3c92:	24d010ef          	jal	56de <wait>
    3c96:	b7ed                	j	3c80 <sbrkfail+0xec>
  if (c == (char *)SBRK_ERROR) {
    3c98:	57fd                	li	a5,-1
    3c9a:	02fa0a63          	beq	s4,a5,3cce <sbrkfail+0x13a>
  pid = fork();
    3c9e:	231010ef          	jal	56ce <fork>
  if (pid < 0) {
    3ca2:	04054063          	bltz	a0,3ce2 <sbrkfail+0x14e>
  if (pid == 0) {
    3ca6:	e939                	bnez	a0,3cfc <sbrkfail+0x168>
    a = sbrk(10 * BIG);
    3ca8:	3e800537          	lui	a0,0x3e800
    3cac:	1f7010ef          	jal	56a2 <sbrk>
    if (a == (char *)SBRK_ERROR) {
    3cb0:	57fd                	li	a5,-1
    3cb2:	04f50263          	beq	a0,a5,3cf6 <sbrkfail+0x162>
    printf("%s: allocate a lot of memory succeeded %d\n", s, 10 * BIG);
    3cb6:	3e800637          	lui	a2,0x3e800
    3cba:	85e2                	mv	a1,s8
    3cbc:	00004517          	auipc	a0,0x4
    3cc0:	cc450513          	addi	a0,a0,-828 # 7980 <malloc+0x1d88>
    3cc4:	679010ef          	jal	5b3c <printf>
    exit(1);
    3cc8:	4505                	li	a0,1
    3cca:	20d010ef          	jal	56d6 <exit>
    printf("%s: failed sbrk leaked memory\n", s);
    3cce:	85e2                	mv	a1,s8
    3cd0:	00004517          	auipc	a0,0x4
    3cd4:	c9050513          	addi	a0,a0,-880 # 7960 <malloc+0x1d68>
    3cd8:	665010ef          	jal	5b3c <printf>
    exit(1);
    3cdc:	4505                	li	a0,1
    3cde:	1f9010ef          	jal	56d6 <exit>
    printf("%s: fork failed\n", s);
    3ce2:	85e2                	mv	a1,s8
    3ce4:	00003517          	auipc	a0,0x3
    3ce8:	8d450513          	addi	a0,a0,-1836 # 65b8 <malloc+0x9c0>
    3cec:	651010ef          	jal	5b3c <printf>
    exit(1);
    3cf0:	4505                	li	a0,1
    3cf2:	1e5010ef          	jal	56d6 <exit>
      exit(0);
    3cf6:	4501                	li	a0,0
    3cf8:	1df010ef          	jal	56d6 <exit>
  wait(&xstatus);
    3cfc:	fac40513          	addi	a0,s0,-84
    3d00:	1df010ef          	jal	56de <wait>
  if (xstatus != 0)
    3d04:	fac42783          	lw	a5,-84(s0)
    3d08:	ef89                	bnez	a5,3d22 <sbrkfail+0x18e>
}
    3d0a:	60aa                	ld	ra,136(sp)
    3d0c:	640a                	ld	s0,128(sp)
    3d0e:	74e6                	ld	s1,120(sp)
    3d10:	7946                	ld	s2,112(sp)
    3d12:	79a6                	ld	s3,104(sp)
    3d14:	7a06                	ld	s4,96(sp)
    3d16:	6ae6                	ld	s5,88(sp)
    3d18:	6b46                	ld	s6,80(sp)
    3d1a:	6ba6                	ld	s7,72(sp)
    3d1c:	6c06                	ld	s8,64(sp)
    3d1e:	6149                	addi	sp,sp,144
    3d20:	8082                	ret
    exit(1);
    3d22:	4505                	li	a0,1
    3d24:	1b3010ef          	jal	56d6 <exit>

0000000000003d28 <mem>:
{
    3d28:	7139                	addi	sp,sp,-64
    3d2a:	fc06                	sd	ra,56(sp)
    3d2c:	f822                	sd	s0,48(sp)
    3d2e:	f426                	sd	s1,40(sp)
    3d30:	f04a                	sd	s2,32(sp)
    3d32:	ec4e                	sd	s3,24(sp)
    3d34:	0080                	addi	s0,sp,64
    3d36:	89aa                	mv	s3,a0
  if ((pid = fork()) == 0) {
    3d38:	197010ef          	jal	56ce <fork>
    m1 = 0;
    3d3c:	4481                	li	s1,0
    while ((m2 = malloc(10001)) != 0) {
    3d3e:	6909                	lui	s2,0x2
    3d40:	71190913          	addi	s2,s2,1809 # 2711 <fourteen+0xf1>
  if ((pid = fork()) == 0) {
    3d44:	cd11                	beqz	a0,3d60 <mem+0x38>
    wait(&xstatus);
    3d46:	fcc40513          	addi	a0,s0,-52
    3d4a:	195010ef          	jal	56de <wait>
    if (xstatus == -1) {
    3d4e:	fcc42503          	lw	a0,-52(s0)
    3d52:	57fd                	li	a5,-1
    3d54:	04f50363          	beq	a0,a5,3d9a <mem+0x72>
    exit(xstatus);
    3d58:	17f010ef          	jal	56d6 <exit>
      *(char **)m2 = m1;
    3d5c:	e104                	sd	s1,0(a0)
      m1 = m2;
    3d5e:	84aa                	mv	s1,a0
    while ((m2 = malloc(10001)) != 0) {
    3d60:	854a                	mv	a0,s2
    3d62:	697010ef          	jal	5bf8 <malloc>
    3d66:	f97d                	bnez	a0,3d5c <mem+0x34>
    while (m1) {
    3d68:	c491                	beqz	s1,3d74 <mem+0x4c>
      m2 = *(char **)m1;
    3d6a:	8526                	mv	a0,s1
    3d6c:	6084                	ld	s1,0(s1)
      free(m1);
    3d6e:	601010ef          	jal	5b6e <free>
    while (m1) {
    3d72:	fce5                	bnez	s1,3d6a <mem+0x42>
    m1 = malloc(1024 * 20);
    3d74:	6515                	lui	a0,0x5
    3d76:	683010ef          	jal	5bf8 <malloc>
    if (m1 == 0) {
    3d7a:	c511                	beqz	a0,3d86 <mem+0x5e>
    free(m1);
    3d7c:	5f3010ef          	jal	5b6e <free>
    exit(0);
    3d80:	4501                	li	a0,0
    3d82:	155010ef          	jal	56d6 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3d86:	85ce                	mv	a1,s3
    3d88:	00004517          	auipc	a0,0x4
    3d8c:	c2850513          	addi	a0,a0,-984 # 79b0 <malloc+0x1db8>
    3d90:	5ad010ef          	jal	5b3c <printf>
      exit(1);
    3d94:	4505                	li	a0,1
    3d96:	141010ef          	jal	56d6 <exit>
      exit(0);
    3d9a:	4501                	li	a0,0
    3d9c:	13b010ef          	jal	56d6 <exit>

0000000000003da0 <sharedfd>:
{
    3da0:	7159                	addi	sp,sp,-112
    3da2:	f486                	sd	ra,104(sp)
    3da4:	f0a2                	sd	s0,96(sp)
    3da6:	eca6                	sd	s1,88(sp)
    3da8:	f85a                	sd	s6,48(sp)
    3daa:	1880                	addi	s0,sp,112
    3dac:	84aa                	mv	s1,a0
    3dae:	8b2a                	mv	s6,a0
  unlink("sharedfd");
    3db0:	00004517          	auipc	a0,0x4
    3db4:	c2050513          	addi	a0,a0,-992 # 79d0 <malloc+0x1dd8>
    3db8:	16f010ef          	jal	5726 <unlink>
  fd = open("sharedfd", O_CREATE | O_RDWR);
    3dbc:	20200593          	li	a1,514
    3dc0:	00004517          	auipc	a0,0x4
    3dc4:	c1050513          	addi	a0,a0,-1008 # 79d0 <malloc+0x1dd8>
    3dc8:	14f010ef          	jal	5716 <open>
  if (fd < 0) {
    3dcc:	04054863          	bltz	a0,3e1c <sharedfd+0x7c>
    3dd0:	e8ca                	sd	s2,80(sp)
    3dd2:	e4ce                	sd	s3,72(sp)
    3dd4:	e0d2                	sd	s4,64(sp)
    3dd6:	fc56                	sd	s5,56(sp)
    3dd8:	89aa                	mv	s3,a0
  pid = fork();
    3dda:	0f5010ef          	jal	56ce <fork>
    3dde:	8aaa                	mv	s5,a0
  memset(buf, pid == 0 ? 'c' : 'p', sizeof(buf));
    3de0:	07000593          	li	a1,112
    3de4:	e119                	bnez	a0,3dea <sharedfd+0x4a>
    3de6:	06300593          	li	a1,99
    3dea:	4629                	li	a2,10
    3dec:	fa040513          	addi	a0,s0,-96
    3df0:	6bc010ef          	jal	54ac <memset>
    3df4:	3e800493          	li	s1,1000
    if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
    3df8:	fa040a13          	addi	s4,s0,-96
    3dfc:	4929                	li	s2,10
    3dfe:	864a                	mv	a2,s2
    3e00:	85d2                	mv	a1,s4
    3e02:	854e                	mv	a0,s3
    3e04:	0f3010ef          	jal	56f6 <write>
    3e08:	03251963          	bne	a0,s2,3e3a <sharedfd+0x9a>
  for (i = 0; i < N; i++) {
    3e0c:	34fd                	addiw	s1,s1,-1
    3e0e:	f8e5                	bnez	s1,3dfe <sharedfd+0x5e>
  if (pid == 0) {
    3e10:	040a9063          	bnez	s5,3e50 <sharedfd+0xb0>
    3e14:	f45e                	sd	s7,40(sp)
    exit(0);
    3e16:	4501                	li	a0,0
    3e18:	0bf010ef          	jal	56d6 <exit>
    3e1c:	e8ca                	sd	s2,80(sp)
    3e1e:	e4ce                	sd	s3,72(sp)
    3e20:	e0d2                	sd	s4,64(sp)
    3e22:	fc56                	sd	s5,56(sp)
    3e24:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    3e26:	85a6                	mv	a1,s1
    3e28:	00004517          	auipc	a0,0x4
    3e2c:	bb850513          	addi	a0,a0,-1096 # 79e0 <malloc+0x1de8>
    3e30:	50d010ef          	jal	5b3c <printf>
    exit(1);
    3e34:	4505                	li	a0,1
    3e36:	0a1010ef          	jal	56d6 <exit>
    3e3a:	f45e                	sd	s7,40(sp)
      printf("%s: write sharedfd failed\n", s);
    3e3c:	85da                	mv	a1,s6
    3e3e:	00004517          	auipc	a0,0x4
    3e42:	bca50513          	addi	a0,a0,-1078 # 7a08 <malloc+0x1e10>
    3e46:	4f7010ef          	jal	5b3c <printf>
      exit(1);
    3e4a:	4505                	li	a0,1
    3e4c:	08b010ef          	jal	56d6 <exit>
    wait(&xstatus);
    3e50:	f9c40513          	addi	a0,s0,-100
    3e54:	08b010ef          	jal	56de <wait>
    if (xstatus != 0)
    3e58:	f9c42a03          	lw	s4,-100(s0)
    3e5c:	000a0663          	beqz	s4,3e68 <sharedfd+0xc8>
    3e60:	f45e                	sd	s7,40(sp)
      exit(xstatus);
    3e62:	8552                	mv	a0,s4
    3e64:	073010ef          	jal	56d6 <exit>
    3e68:	f45e                	sd	s7,40(sp)
  close(fd);
    3e6a:	854e                	mv	a0,s3
    3e6c:	093010ef          	jal	56fe <close>
  fd = open("sharedfd", 0);
    3e70:	4581                	li	a1,0
    3e72:	00004517          	auipc	a0,0x4
    3e76:	b5e50513          	addi	a0,a0,-1186 # 79d0 <malloc+0x1dd8>
    3e7a:	09d010ef          	jal	5716 <open>
    3e7e:	8baa                	mv	s7,a0
  nc = np = 0;
    3e80:	89d2                	mv	s3,s4
  if (fd < 0) {
    3e82:	02054363          	bltz	a0,3ea8 <sharedfd+0x108>
    3e86:	faa40913          	addi	s2,s0,-86
      if (buf[i] == 'c')
    3e8a:	06300493          	li	s1,99
      if (buf[i] == 'p')
    3e8e:	07000a93          	li	s5,112
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
    3e92:	4629                	li	a2,10
    3e94:	fa040593          	addi	a1,s0,-96
    3e98:	855e                	mv	a0,s7
    3e9a:	055010ef          	jal	56ee <read>
    3e9e:	02a05b63          	blez	a0,3ed4 <sharedfd+0x134>
    3ea2:	fa040793          	addi	a5,s0,-96
    3ea6:	a839                	j	3ec4 <sharedfd+0x124>
    printf("%s: cannot open sharedfd for reading\n", s);
    3ea8:	85da                	mv	a1,s6
    3eaa:	00004517          	auipc	a0,0x4
    3eae:	b7e50513          	addi	a0,a0,-1154 # 7a28 <malloc+0x1e30>
    3eb2:	48b010ef          	jal	5b3c <printf>
    exit(1);
    3eb6:	4505                	li	a0,1
    3eb8:	01f010ef          	jal	56d6 <exit>
        nc++;
    3ebc:	2a05                	addiw	s4,s4,1
    for (i = 0; i < sizeof(buf); i++) {
    3ebe:	0785                	addi	a5,a5,1
    3ec0:	fd2789e3          	beq	a5,s2,3e92 <sharedfd+0xf2>
      if (buf[i] == 'c')
    3ec4:	0007c703          	lbu	a4,0(a5)
    3ec8:	fe970ae3          	beq	a4,s1,3ebc <sharedfd+0x11c>
      if (buf[i] == 'p')
    3ecc:	ff5719e3          	bne	a4,s5,3ebe <sharedfd+0x11e>
        np++;
    3ed0:	2985                	addiw	s3,s3,1
    3ed2:	b7f5                	j	3ebe <sharedfd+0x11e>
  close(fd);
    3ed4:	855e                	mv	a0,s7
    3ed6:	029010ef          	jal	56fe <close>
  unlink("sharedfd");
    3eda:	00004517          	auipc	a0,0x4
    3ede:	af650513          	addi	a0,a0,-1290 # 79d0 <malloc+0x1dd8>
    3ee2:	045010ef          	jal	5726 <unlink>
  if (nc == N * SZ && np == N * SZ) {
    3ee6:	6789                	lui	a5,0x2
    3ee8:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0xf0>
    3eec:	00fa1763          	bne	s4,a5,3efa <sharedfd+0x15a>
    3ef0:	01499563          	bne	s3,s4,3efa <sharedfd+0x15a>
    exit(0);
    3ef4:	4501                	li	a0,0
    3ef6:	7e0010ef          	jal	56d6 <exit>
    printf("%s: nc/np test fails\n", s);
    3efa:	85da                	mv	a1,s6
    3efc:	00004517          	auipc	a0,0x4
    3f00:	b5450513          	addi	a0,a0,-1196 # 7a50 <malloc+0x1e58>
    3f04:	439010ef          	jal	5b3c <printf>
    exit(1);
    3f08:	4505                	li	a0,1
    3f0a:	7cc010ef          	jal	56d6 <exit>

0000000000003f0e <fourfiles>:
{
    3f0e:	7135                	addi	sp,sp,-160
    3f10:	ed06                	sd	ra,152(sp)
    3f12:	e922                	sd	s0,144(sp)
    3f14:	e526                	sd	s1,136(sp)
    3f16:	e14a                	sd	s2,128(sp)
    3f18:	fcce                	sd	s3,120(sp)
    3f1a:	f8d2                	sd	s4,112(sp)
    3f1c:	f4d6                	sd	s5,104(sp)
    3f1e:	f0da                	sd	s6,96(sp)
    3f20:	ecde                	sd	s7,88(sp)
    3f22:	e8e2                	sd	s8,80(sp)
    3f24:	e4e6                	sd	s9,72(sp)
    3f26:	e0ea                	sd	s10,64(sp)
    3f28:	fc6e                	sd	s11,56(sp)
    3f2a:	1100                	addi	s0,sp,160
    3f2c:	8caa                	mv	s9,a0
  char *names[] = {"f0", "f1", "f2", "f3"};
    3f2e:	00004797          	auipc	a5,0x4
    3f32:	b3a78793          	addi	a5,a5,-1222 # 7a68 <malloc+0x1e70>
    3f36:	f6f43823          	sd	a5,-144(s0)
    3f3a:	00004797          	auipc	a5,0x4
    3f3e:	b3678793          	addi	a5,a5,-1226 # 7a70 <malloc+0x1e78>
    3f42:	f6f43c23          	sd	a5,-136(s0)
    3f46:	00004797          	auipc	a5,0x4
    3f4a:	b3278793          	addi	a5,a5,-1230 # 7a78 <malloc+0x1e80>
    3f4e:	f8f43023          	sd	a5,-128(s0)
    3f52:	00004797          	auipc	a5,0x4
    3f56:	b2e78793          	addi	a5,a5,-1234 # 7a80 <malloc+0x1e88>
    3f5a:	f8f43423          	sd	a5,-120(s0)
  for (pi = 0; pi < NCHILD; pi++) {
    3f5e:	f7040b93          	addi	s7,s0,-144
  char *names[] = {"f0", "f1", "f2", "f3"};
    3f62:	895e                	mv	s2,s7
  for (pi = 0; pi < NCHILD; pi++) {
    3f64:	4481                	li	s1,0
    3f66:	4a11                	li	s4,4
    fname = names[pi];
    3f68:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3f6c:	854e                	mv	a0,s3
    3f6e:	7b8010ef          	jal	5726 <unlink>
    pid = fork();
    3f72:	75c010ef          	jal	56ce <fork>
    if (pid < 0) {
    3f76:	04054063          	bltz	a0,3fb6 <fourfiles+0xa8>
    if (pid == 0) {
    3f7a:	c921                	beqz	a0,3fca <fourfiles+0xbc>
  for (pi = 0; pi < NCHILD; pi++) {
    3f7c:	2485                	addiw	s1,s1,1
    3f7e:	0921                	addi	s2,s2,8
    3f80:	ff4494e3          	bne	s1,s4,3f68 <fourfiles+0x5a>
    3f84:	4491                	li	s1,4
    wait(&xstatus);
    3f86:	f6c40913          	addi	s2,s0,-148
    3f8a:	854a                	mv	a0,s2
    3f8c:	752010ef          	jal	56de <wait>
    if (xstatus != 0)
    3f90:	f6c42b03          	lw	s6,-148(s0)
    3f94:	0a0b1463          	bnez	s6,403c <fourfiles+0x12e>
  for (pi = 0; pi < NCHILD; pi++) {
    3f98:	34fd                	addiw	s1,s1,-1
    3f9a:	f8e5                	bnez	s1,3f8a <fourfiles+0x7c>
    3f9c:	03000493          	li	s1,48
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    3fa0:	6a8d                	lui	s5,0x3
    3fa2:	0000aa17          	auipc	s4,0xa
    3fa6:	d46a0a13          	addi	s4,s4,-698 # dce8 <buf>
    if (total != N * SZ) {
    3faa:	6d05                	lui	s10,0x1
    3fac:	770d0d13          	addi	s10,s10,1904 # 1770 <createdelete+0x20>
  for (i = 0; i < NCHILD; i++) {
    3fb0:	03400d93          	li	s11,52
    3fb4:	a86d                	j	406e <fourfiles+0x160>
      printf("%s: fork failed\n", s);
    3fb6:	85e6                	mv	a1,s9
    3fb8:	00002517          	auipc	a0,0x2
    3fbc:	60050513          	addi	a0,a0,1536 # 65b8 <malloc+0x9c0>
    3fc0:	37d010ef          	jal	5b3c <printf>
      exit(1);
    3fc4:	4505                	li	a0,1
    3fc6:	710010ef          	jal	56d6 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3fca:	20200593          	li	a1,514
    3fce:	854e                	mv	a0,s3
    3fd0:	746010ef          	jal	5716 <open>
    3fd4:	892a                	mv	s2,a0
      if (fd < 0) {
    3fd6:	04054063          	bltz	a0,4016 <fourfiles+0x108>
      memset(buf, '0' + pi, SZ);
    3fda:	1f400613          	li	a2,500
    3fde:	0304859b          	addiw	a1,s1,48
    3fe2:	0000a517          	auipc	a0,0xa
    3fe6:	d0650513          	addi	a0,a0,-762 # dce8 <buf>
    3fea:	4c2010ef          	jal	54ac <memset>
    3fee:	44b1                	li	s1,12
        if ((n = write(fd, buf, SZ)) != SZ) {
    3ff0:	1f400993          	li	s3,500
    3ff4:	0000aa17          	auipc	s4,0xa
    3ff8:	cf4a0a13          	addi	s4,s4,-780 # dce8 <buf>
    3ffc:	864e                	mv	a2,s3
    3ffe:	85d2                	mv	a1,s4
    4000:	854a                	mv	a0,s2
    4002:	6f4010ef          	jal	56f6 <write>
    4006:	85aa                	mv	a1,a0
    4008:	03351163          	bne	a0,s3,402a <fourfiles+0x11c>
      for (i = 0; i < N; i++) {
    400c:	34fd                	addiw	s1,s1,-1
    400e:	f4fd                	bnez	s1,3ffc <fourfiles+0xee>
      exit(0);
    4010:	4501                	li	a0,0
    4012:	6c4010ef          	jal	56d6 <exit>
        printf("%s: create failed\n", s);
    4016:	85e6                	mv	a1,s9
    4018:	00002517          	auipc	a0,0x2
    401c:	71050513          	addi	a0,a0,1808 # 6728 <malloc+0xb30>
    4020:	31d010ef          	jal	5b3c <printf>
        exit(1);
    4024:	4505                	li	a0,1
    4026:	6b0010ef          	jal	56d6 <exit>
          printf("write failed %d\n", n);
    402a:	00004517          	auipc	a0,0x4
    402e:	a5e50513          	addi	a0,a0,-1442 # 7a88 <malloc+0x1e90>
    4032:	30b010ef          	jal	5b3c <printf>
          exit(1);
    4036:	4505                	li	a0,1
    4038:	69e010ef          	jal	56d6 <exit>
      exit(xstatus);
    403c:	855a                	mv	a0,s6
    403e:	698010ef          	jal	56d6 <exit>
          printf("%s: wrong char\n", s);
    4042:	85e6                	mv	a1,s9
    4044:	00004517          	auipc	a0,0x4
    4048:	a5c50513          	addi	a0,a0,-1444 # 7aa0 <malloc+0x1ea8>
    404c:	2f1010ef          	jal	5b3c <printf>
          exit(1);
    4050:	4505                	li	a0,1
    4052:	684010ef          	jal	56d6 <exit>
    close(fd);
    4056:	854e                	mv	a0,s3
    4058:	6a6010ef          	jal	56fe <close>
    if (total != N * SZ) {
    405c:	05a91863          	bne	s2,s10,40ac <fourfiles+0x19e>
    unlink(fname);
    4060:	8562                	mv	a0,s8
    4062:	6c4010ef          	jal	5726 <unlink>
  for (i = 0; i < NCHILD; i++) {
    4066:	0ba1                	addi	s7,s7,8
    4068:	2485                	addiw	s1,s1,1
    406a:	05b48b63          	beq	s1,s11,40c0 <fourfiles+0x1b2>
    fname = names[i];
    406e:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4072:	4581                	li	a1,0
    4074:	8562                	mv	a0,s8
    4076:	6a0010ef          	jal	5716 <open>
    407a:	89aa                	mv	s3,a0
    total = 0;
    407c:	895a                	mv	s2,s6
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    407e:	8656                	mv	a2,s5
    4080:	85d2                	mv	a1,s4
    4082:	854e                	mv	a0,s3
    4084:	66a010ef          	jal	56ee <read>
    4088:	fca057e3          	blez	a0,4056 <fourfiles+0x148>
    408c:	0000a797          	auipc	a5,0xa
    4090:	c5c78793          	addi	a5,a5,-932 # dce8 <buf>
    4094:	00f506b3          	add	a3,a0,a5
        if (buf[j] != '0' + i) {
    4098:	0007c703          	lbu	a4,0(a5)
    409c:	fa9713e3          	bne	a4,s1,4042 <fourfiles+0x134>
      for (j = 0; j < n; j++) {
    40a0:	0785                	addi	a5,a5,1
    40a2:	fed79be3          	bne	a5,a3,4098 <fourfiles+0x18a>
      total += n;
    40a6:	00a9093b          	addw	s2,s2,a0
    40aa:	bfd1                	j	407e <fourfiles+0x170>
      printf("wrong length %d\n", total);
    40ac:	85ca                	mv	a1,s2
    40ae:	00004517          	auipc	a0,0x4
    40b2:	a0250513          	addi	a0,a0,-1534 # 7ab0 <malloc+0x1eb8>
    40b6:	287010ef          	jal	5b3c <printf>
      exit(1);
    40ba:	4505                	li	a0,1
    40bc:	61a010ef          	jal	56d6 <exit>
}
    40c0:	60ea                	ld	ra,152(sp)
    40c2:	644a                	ld	s0,144(sp)
    40c4:	64aa                	ld	s1,136(sp)
    40c6:	690a                	ld	s2,128(sp)
    40c8:	79e6                	ld	s3,120(sp)
    40ca:	7a46                	ld	s4,112(sp)
    40cc:	7aa6                	ld	s5,104(sp)
    40ce:	7b06                	ld	s6,96(sp)
    40d0:	6be6                	ld	s7,88(sp)
    40d2:	6c46                	ld	s8,80(sp)
    40d4:	6ca6                	ld	s9,72(sp)
    40d6:	6d06                	ld	s10,64(sp)
    40d8:	7de2                	ld	s11,56(sp)
    40da:	610d                	addi	sp,sp,160
    40dc:	8082                	ret

00000000000040de <concreate>:
{
    40de:	7171                	addi	sp,sp,-176
    40e0:	f506                	sd	ra,168(sp)
    40e2:	f122                	sd	s0,160(sp)
    40e4:	ed26                	sd	s1,152(sp)
    40e6:	e94a                	sd	s2,144(sp)
    40e8:	e54e                	sd	s3,136(sp)
    40ea:	e152                	sd	s4,128(sp)
    40ec:	fcd6                	sd	s5,120(sp)
    40ee:	f8da                	sd	s6,112(sp)
    40f0:	f4de                	sd	s7,104(sp)
    40f2:	f0e2                	sd	s8,96(sp)
    40f4:	ece6                	sd	s9,88(sp)
    40f6:	e8ea                	sd	s10,80(sp)
    40f8:	1900                	addi	s0,sp,176
    40fa:	8d2a                	mv	s10,a0
  file[0] = 'C';
    40fc:	04300793          	li	a5,67
    4100:	f8f40c23          	sb	a5,-104(s0)
  file[2] = '\0';
    4104:	f8040d23          	sb	zero,-102(s0)
  for (i = 0; i < N; i++) {
    4108:	4901                	li	s2,0
    unlink(file);
    410a:	f9840993          	addi	s3,s0,-104
    if (pid && (i % 3) == 1) {
    410e:	55555b37          	lui	s6,0x55555
    4112:	556b0b13          	addi	s6,s6,1366 # 55555556 <base+0x5554486e>
    4116:	4b85                	li	s7,1
      fd = open(file, O_CREATE | O_RDWR);
    4118:	20200c13          	li	s8,514
      link("C0", file);
    411c:	00004c97          	auipc	s9,0x4
    4120:	9acc8c93          	addi	s9,s9,-1620 # 7ac8 <malloc+0x1ed0>
      wait(&xstatus);
    4124:	f5c40a93          	addi	s5,s0,-164
  for (i = 0; i < N; i++) {
    4128:	02800a13          	li	s4,40
    412c:	a481                	j	436c <concreate+0x28e>
      link("C0", file);
    412e:	85ce                	mv	a1,s3
    4130:	8566                	mv	a0,s9
    4132:	604010ef          	jal	5736 <link>
    if (pid == 0) {
    4136:	a40d                	j	4358 <concreate+0x27a>
    } else if (pid == 0 && (i % 5) == 1) {
    4138:	666667b7          	lui	a5,0x66666
    413c:	66778793          	addi	a5,a5,1639 # 66666667 <base+0x6665597f>
    4140:	02f907b3          	mul	a5,s2,a5
    4144:	9785                	srai	a5,a5,0x21
    4146:	41f9571b          	sraiw	a4,s2,0x1f
    414a:	9f99                	subw	a5,a5,a4
    414c:	0027971b          	slliw	a4,a5,0x2
    4150:	9fb9                	addw	a5,a5,a4
    4152:	40f9093b          	subw	s2,s2,a5
    4156:	4785                	li	a5,1
    4158:	02f90563          	beq	s2,a5,4182 <concreate+0xa4>
      fd = open(file, O_CREATE | O_RDWR);
    415c:	20200593          	li	a1,514
    4160:	f9840513          	addi	a0,s0,-104
    4164:	5b2010ef          	jal	5716 <open>
      if (fd < 0) {
    4168:	1e055363          	bgez	a0,434e <concreate+0x270>
        printf("concreate create %s failed\n", file);
    416c:	f9840593          	addi	a1,s0,-104
    4170:	00004517          	auipc	a0,0x4
    4174:	96050513          	addi	a0,a0,-1696 # 7ad0 <malloc+0x1ed8>
    4178:	1c5010ef          	jal	5b3c <printf>
        exit(1);
    417c:	4505                	li	a0,1
    417e:	558010ef          	jal	56d6 <exit>
      link("C0", file);
    4182:	f9840593          	addi	a1,s0,-104
    4186:	00004517          	auipc	a0,0x4
    418a:	94250513          	addi	a0,a0,-1726 # 7ac8 <malloc+0x1ed0>
    418e:	5a8010ef          	jal	5736 <link>
      exit(0);
    4192:	4501                	li	a0,0
    4194:	542010ef          	jal	56d6 <exit>
        exit(1);
    4198:	4505                	li	a0,1
    419a:	53c010ef          	jal	56d6 <exit>
  memset(fa, 0, sizeof(fa));
    419e:	02800613          	li	a2,40
    41a2:	4581                	li	a1,0
    41a4:	f7040513          	addi	a0,s0,-144
    41a8:	304010ef          	jal	54ac <memset>
  fd = open(".", 0);
    41ac:	4581                	li	a1,0
    41ae:	00002517          	auipc	a0,0x2
    41b2:	26250513          	addi	a0,a0,610 # 6410 <malloc+0x818>
    41b6:	560010ef          	jal	5716 <open>
    41ba:	892a                	mv	s2,a0
  n = 0;
    41bc:	8b26                	mv	s6,s1
  while (read(fd, &de, sizeof(de)) > 0) {
    41be:	f6040a13          	addi	s4,s0,-160
    41c2:	49c1                	li	s3,16
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    41c4:	04300a93          	li	s5,67
      if (i < 0 || i >= sizeof(fa)) {
    41c8:	02700b93          	li	s7,39
      fa[i] = 1;
    41cc:	4c05                	li	s8,1
  while (read(fd, &de, sizeof(de)) > 0) {
    41ce:	864e                	mv	a2,s3
    41d0:	85d2                	mv	a1,s4
    41d2:	854a                	mv	a0,s2
    41d4:	51a010ef          	jal	56ee <read>
    41d8:	06a05763          	blez	a0,4246 <concreate+0x168>
    if (de.inum == 0)
    41dc:	f6045783          	lhu	a5,-160(s0)
    41e0:	d7fd                	beqz	a5,41ce <concreate+0xf0>
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    41e2:	f6244783          	lbu	a5,-158(s0)
    41e6:	ff5794e3          	bne	a5,s5,41ce <concreate+0xf0>
    41ea:	f6444783          	lbu	a5,-156(s0)
    41ee:	f3e5                	bnez	a5,41ce <concreate+0xf0>
      i = de.name[1] - '0';
    41f0:	f6344783          	lbu	a5,-157(s0)
    41f4:	fd07879b          	addiw	a5,a5,-48
      if (i < 0 || i >= sizeof(fa)) {
    41f8:	00fbef63          	bltu	s7,a5,4216 <concreate+0x138>
      if (fa[i]) {
    41fc:	fa040713          	addi	a4,s0,-96
    4200:	973e                	add	a4,a4,a5
    4202:	fd074703          	lbu	a4,-48(a4)
    4206:	e705                	bnez	a4,422e <concreate+0x150>
      fa[i] = 1;
    4208:	fa040713          	addi	a4,s0,-96
    420c:	97ba                	add	a5,a5,a4
    420e:	fd878823          	sb	s8,-48(a5)
      n++;
    4212:	2b05                	addiw	s6,s6,1
    4214:	bf6d                	j	41ce <concreate+0xf0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4216:	f6240613          	addi	a2,s0,-158
    421a:	85ea                	mv	a1,s10
    421c:	00004517          	auipc	a0,0x4
    4220:	8d450513          	addi	a0,a0,-1836 # 7af0 <malloc+0x1ef8>
    4224:	119010ef          	jal	5b3c <printf>
        exit(1);
    4228:	4505                	li	a0,1
    422a:	4ac010ef          	jal	56d6 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    422e:	f6240613          	addi	a2,s0,-158
    4232:	85ea                	mv	a1,s10
    4234:	00004517          	auipc	a0,0x4
    4238:	8dc50513          	addi	a0,a0,-1828 # 7b10 <malloc+0x1f18>
    423c:	101010ef          	jal	5b3c <printf>
        exit(1);
    4240:	4505                	li	a0,1
    4242:	494010ef          	jal	56d6 <exit>
  close(fd);
    4246:	854a                	mv	a0,s2
    4248:	4b6010ef          	jal	56fe <close>
  if (n != N) {
    424c:	02800793          	li	a5,40
    4250:	00fb1a63          	bne	s6,a5,4264 <concreate+0x186>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    4254:	55555a37          	lui	s4,0x55555
    4258:	556a0a13          	addi	s4,s4,1366 # 55555556 <base+0x5554486e>
      close(open(file, 0));
    425c:	f9840993          	addi	s3,s0,-104
  for (i = 0; i < N; i++) {
    4260:	8ada                	mv	s5,s6
    4262:	a049                	j	42e4 <concreate+0x206>
    printf("%s: concreate not enough files in directory listing\n", s);
    4264:	85ea                	mv	a1,s10
    4266:	00004517          	auipc	a0,0x4
    426a:	8d250513          	addi	a0,a0,-1838 # 7b38 <malloc+0x1f40>
    426e:	0cf010ef          	jal	5b3c <printf>
    exit(1);
    4272:	4505                	li	a0,1
    4274:	462010ef          	jal	56d6 <exit>
      printf("%s: fork failed\n", s);
    4278:	85ea                	mv	a1,s10
    427a:	00002517          	auipc	a0,0x2
    427e:	33e50513          	addi	a0,a0,830 # 65b8 <malloc+0x9c0>
    4282:	0bb010ef          	jal	5b3c <printf>
      exit(1);
    4286:	4505                	li	a0,1
    4288:	44e010ef          	jal	56d6 <exit>
      close(open(file, 0));
    428c:	4581                	li	a1,0
    428e:	854e                	mv	a0,s3
    4290:	486010ef          	jal	5716 <open>
    4294:	46a010ef          	jal	56fe <close>
      close(open(file, 0));
    4298:	4581                	li	a1,0
    429a:	854e                	mv	a0,s3
    429c:	47a010ef          	jal	5716 <open>
    42a0:	45e010ef          	jal	56fe <close>
      close(open(file, 0));
    42a4:	4581                	li	a1,0
    42a6:	854e                	mv	a0,s3
    42a8:	46e010ef          	jal	5716 <open>
    42ac:	452010ef          	jal	56fe <close>
      close(open(file, 0));
    42b0:	4581                	li	a1,0
    42b2:	854e                	mv	a0,s3
    42b4:	462010ef          	jal	5716 <open>
    42b8:	446010ef          	jal	56fe <close>
      close(open(file, 0));
    42bc:	4581                	li	a1,0
    42be:	854e                	mv	a0,s3
    42c0:	456010ef          	jal	5716 <open>
    42c4:	43a010ef          	jal	56fe <close>
      close(open(file, 0));
    42c8:	4581                	li	a1,0
    42ca:	854e                	mv	a0,s3
    42cc:	44a010ef          	jal	5716 <open>
    42d0:	42e010ef          	jal	56fe <close>
    if (pid == 0)
    42d4:	06090a63          	beqz	s2,4348 <concreate+0x26a>
      wait(0);
    42d8:	4501                	li	a0,0
    42da:	404010ef          	jal	56de <wait>
  for (i = 0; i < N; i++) {
    42de:	2485                	addiw	s1,s1,1
    42e0:	0d548563          	beq	s1,s5,43aa <concreate+0x2cc>
    file[1] = '0' + i;
    42e4:	0304879b          	addiw	a5,s1,48
    42e8:	f8f40ca3          	sb	a5,-103(s0)
    pid = fork();
    42ec:	3e2010ef          	jal	56ce <fork>
    42f0:	892a                	mv	s2,a0
    if (pid < 0) {
    42f2:	f80543e3          	bltz	a0,4278 <concreate+0x19a>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    42f6:	03448733          	mul	a4,s1,s4
    42fa:	9301                	srli	a4,a4,0x20
    42fc:	41f4d79b          	sraiw	a5,s1,0x1f
    4300:	9f1d                	subw	a4,a4,a5
    4302:	0017179b          	slliw	a5,a4,0x1
    4306:	9fb9                	addw	a5,a5,a4
    4308:	40f487bb          	subw	a5,s1,a5
    430c:	00a7e733          	or	a4,a5,a0
    4310:	2701                	sext.w	a4,a4
    4312:	df2d                	beqz	a4,428c <concreate+0x1ae>
    4314:	00a03733          	snez	a4,a0
    4318:	17fd                	addi	a5,a5,-1
    431a:	0017b793          	seqz	a5,a5
    431e:	8ff9                	and	a5,a5,a4
    4320:	f7b5                	bnez	a5,428c <concreate+0x1ae>
      unlink(file);
    4322:	854e                	mv	a0,s3
    4324:	402010ef          	jal	5726 <unlink>
      unlink(file);
    4328:	854e                	mv	a0,s3
    432a:	3fc010ef          	jal	5726 <unlink>
      unlink(file);
    432e:	854e                	mv	a0,s3
    4330:	3f6010ef          	jal	5726 <unlink>
      unlink(file);
    4334:	854e                	mv	a0,s3
    4336:	3f0010ef          	jal	5726 <unlink>
      unlink(file);
    433a:	854e                	mv	a0,s3
    433c:	3ea010ef          	jal	5726 <unlink>
      unlink(file);
    4340:	854e                	mv	a0,s3
    4342:	3e4010ef          	jal	5726 <unlink>
    4346:	b779                	j	42d4 <concreate+0x1f6>
      exit(0);
    4348:	4501                	li	a0,0
    434a:	38c010ef          	jal	56d6 <exit>
      close(fd);
    434e:	3b0010ef          	jal	56fe <close>
    if (pid == 0) {
    4352:	b581                	j	4192 <concreate+0xb4>
      close(fd);
    4354:	3aa010ef          	jal	56fe <close>
      wait(&xstatus);
    4358:	8556                	mv	a0,s5
    435a:	384010ef          	jal	56de <wait>
      if (xstatus != 0)
    435e:	f5c42483          	lw	s1,-164(s0)
    4362:	e2049be3          	bnez	s1,4198 <concreate+0xba>
  for (i = 0; i < N; i++) {
    4366:	2905                	addiw	s2,s2,1
    4368:	e3490be3          	beq	s2,s4,419e <concreate+0xc0>
    file[1] = '0' + i;
    436c:	0309079b          	addiw	a5,s2,48
    4370:	f8f40ca3          	sb	a5,-103(s0)
    unlink(file);
    4374:	854e                	mv	a0,s3
    4376:	3b0010ef          	jal	5726 <unlink>
    pid = fork();
    437a:	354010ef          	jal	56ce <fork>
    if (pid && (i % 3) == 1) {
    437e:	da050de3          	beqz	a0,4138 <concreate+0x5a>
    4382:	036907b3          	mul	a5,s2,s6
    4386:	9381                	srli	a5,a5,0x20
    4388:	41f9571b          	sraiw	a4,s2,0x1f
    438c:	9f99                	subw	a5,a5,a4
    438e:	0017971b          	slliw	a4,a5,0x1
    4392:	9fb9                	addw	a5,a5,a4
    4394:	40f907bb          	subw	a5,s2,a5
    4398:	d9778be3          	beq	a5,s7,412e <concreate+0x50>
      fd = open(file, O_CREATE | O_RDWR);
    439c:	85e2                	mv	a1,s8
    439e:	854e                	mv	a0,s3
    43a0:	376010ef          	jal	5716 <open>
      if (fd < 0) {
    43a4:	fa0558e3          	bgez	a0,4354 <concreate+0x276>
    43a8:	b3d1                	j	416c <concreate+0x8e>
}
    43aa:	70aa                	ld	ra,168(sp)
    43ac:	740a                	ld	s0,160(sp)
    43ae:	64ea                	ld	s1,152(sp)
    43b0:	694a                	ld	s2,144(sp)
    43b2:	69aa                	ld	s3,136(sp)
    43b4:	6a0a                	ld	s4,128(sp)
    43b6:	7ae6                	ld	s5,120(sp)
    43b8:	7b46                	ld	s6,112(sp)
    43ba:	7ba6                	ld	s7,104(sp)
    43bc:	7c06                	ld	s8,96(sp)
    43be:	6ce6                	ld	s9,88(sp)
    43c0:	6d46                	ld	s10,80(sp)
    43c2:	614d                	addi	sp,sp,176
    43c4:	8082                	ret

00000000000043c6 <bigfile>:
{
    43c6:	7139                	addi	sp,sp,-64
    43c8:	fc06                	sd	ra,56(sp)
    43ca:	f822                	sd	s0,48(sp)
    43cc:	f426                	sd	s1,40(sp)
    43ce:	f04a                	sd	s2,32(sp)
    43d0:	ec4e                	sd	s3,24(sp)
    43d2:	e852                	sd	s4,16(sp)
    43d4:	e456                	sd	s5,8(sp)
    43d6:	e05a                	sd	s6,0(sp)
    43d8:	0080                	addi	s0,sp,64
    43da:	8b2a                	mv	s6,a0
  unlink("bigfile.dat");
    43dc:	00003517          	auipc	a0,0x3
    43e0:	79450513          	addi	a0,a0,1940 # 7b70 <malloc+0x1f78>
    43e4:	342010ef          	jal	5726 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    43e8:	20200593          	li	a1,514
    43ec:	00003517          	auipc	a0,0x3
    43f0:	78450513          	addi	a0,a0,1924 # 7b70 <malloc+0x1f78>
    43f4:	322010ef          	jal	5716 <open>
  if (fd < 0) {
    43f8:	08054a63          	bltz	a0,448c <bigfile+0xc6>
    43fc:	8a2a                	mv	s4,a0
    43fe:	4481                	li	s1,0
    memset(buf, i, SZ);
    4400:	25800913          	li	s2,600
    4404:	0000a997          	auipc	s3,0xa
    4408:	8e498993          	addi	s3,s3,-1820 # dce8 <buf>
  for (i = 0; i < N; i++) {
    440c:	4ad1                	li	s5,20
    memset(buf, i, SZ);
    440e:	864a                	mv	a2,s2
    4410:	85a6                	mv	a1,s1
    4412:	854e                	mv	a0,s3
    4414:	098010ef          	jal	54ac <memset>
    if (write(fd, buf, SZ) != SZ) {
    4418:	864a                	mv	a2,s2
    441a:	85ce                	mv	a1,s3
    441c:	8552                	mv	a0,s4
    441e:	2d8010ef          	jal	56f6 <write>
    4422:	07251f63          	bne	a0,s2,44a0 <bigfile+0xda>
  for (i = 0; i < N; i++) {
    4426:	2485                	addiw	s1,s1,1
    4428:	ff5493e3          	bne	s1,s5,440e <bigfile+0x48>
  close(fd);
    442c:	8552                	mv	a0,s4
    442e:	2d0010ef          	jal	56fe <close>
  fd = open("bigfile.dat", 0);
    4432:	4581                	li	a1,0
    4434:	00003517          	auipc	a0,0x3
    4438:	73c50513          	addi	a0,a0,1852 # 7b70 <malloc+0x1f78>
    443c:	2da010ef          	jal	5716 <open>
    4440:	8aaa                	mv	s5,a0
  total = 0;
    4442:	4a01                	li	s4,0
  for (i = 0;; i++) {
    4444:	4481                	li	s1,0
    cc = read(fd, buf, SZ / 2);
    4446:	12c00993          	li	s3,300
    444a:	0000a917          	auipc	s2,0xa
    444e:	89e90913          	addi	s2,s2,-1890 # dce8 <buf>
  if (fd < 0) {
    4452:	06054163          	bltz	a0,44b4 <bigfile+0xee>
    cc = read(fd, buf, SZ / 2);
    4456:	864e                	mv	a2,s3
    4458:	85ca                	mv	a1,s2
    445a:	8556                	mv	a0,s5
    445c:	292010ef          	jal	56ee <read>
    if (cc < 0) {
    4460:	06054463          	bltz	a0,44c8 <bigfile+0x102>
    if (cc == 0)
    4464:	c145                	beqz	a0,4504 <bigfile+0x13e>
    if (cc != SZ / 2) {
    4466:	07351b63          	bne	a0,s3,44dc <bigfile+0x116>
    if (buf[0] != i / 2 || buf[SZ / 2 - 1] != i / 2) {
    446a:	01f4d79b          	srliw	a5,s1,0x1f
    446e:	9fa5                	addw	a5,a5,s1
    4470:	4017d79b          	sraiw	a5,a5,0x1
    4474:	00094703          	lbu	a4,0(s2)
    4478:	06f71c63          	bne	a4,a5,44f0 <bigfile+0x12a>
    447c:	12b94703          	lbu	a4,299(s2)
    4480:	06f71863          	bne	a4,a5,44f0 <bigfile+0x12a>
    total += cc;
    4484:	12ca0a1b          	addiw	s4,s4,300
  for (i = 0;; i++) {
    4488:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ / 2);
    448a:	b7f1                	j	4456 <bigfile+0x90>
    printf("%s: cannot create bigfile", s);
    448c:	85da                	mv	a1,s6
    448e:	00003517          	auipc	a0,0x3
    4492:	6f250513          	addi	a0,a0,1778 # 7b80 <malloc+0x1f88>
    4496:	6a6010ef          	jal	5b3c <printf>
    exit(1);
    449a:	4505                	li	a0,1
    449c:	23a010ef          	jal	56d6 <exit>
      printf("%s: write bigfile failed\n", s);
    44a0:	85da                	mv	a1,s6
    44a2:	00003517          	auipc	a0,0x3
    44a6:	6fe50513          	addi	a0,a0,1790 # 7ba0 <malloc+0x1fa8>
    44aa:	692010ef          	jal	5b3c <printf>
      exit(1);
    44ae:	4505                	li	a0,1
    44b0:	226010ef          	jal	56d6 <exit>
    printf("%s: cannot open bigfile\n", s);
    44b4:	85da                	mv	a1,s6
    44b6:	00003517          	auipc	a0,0x3
    44ba:	70a50513          	addi	a0,a0,1802 # 7bc0 <malloc+0x1fc8>
    44be:	67e010ef          	jal	5b3c <printf>
    exit(1);
    44c2:	4505                	li	a0,1
    44c4:	212010ef          	jal	56d6 <exit>
      printf("%s: read bigfile failed\n", s);
    44c8:	85da                	mv	a1,s6
    44ca:	00003517          	auipc	a0,0x3
    44ce:	71650513          	addi	a0,a0,1814 # 7be0 <malloc+0x1fe8>
    44d2:	66a010ef          	jal	5b3c <printf>
      exit(1);
    44d6:	4505                	li	a0,1
    44d8:	1fe010ef          	jal	56d6 <exit>
      printf("%s: short read bigfile\n", s);
    44dc:	85da                	mv	a1,s6
    44de:	00003517          	auipc	a0,0x3
    44e2:	72250513          	addi	a0,a0,1826 # 7c00 <malloc+0x2008>
    44e6:	656010ef          	jal	5b3c <printf>
      exit(1);
    44ea:	4505                	li	a0,1
    44ec:	1ea010ef          	jal	56d6 <exit>
      printf("%s: read bigfile wrong data\n", s);
    44f0:	85da                	mv	a1,s6
    44f2:	00003517          	auipc	a0,0x3
    44f6:	72650513          	addi	a0,a0,1830 # 7c18 <malloc+0x2020>
    44fa:	642010ef          	jal	5b3c <printf>
      exit(1);
    44fe:	4505                	li	a0,1
    4500:	1d6010ef          	jal	56d6 <exit>
  close(fd);
    4504:	8556                	mv	a0,s5
    4506:	1f8010ef          	jal	56fe <close>
  if (total != N * SZ) {
    450a:	678d                	lui	a5,0x3
    450c:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x35a>
    4510:	02fa1263          	bne	s4,a5,4534 <bigfile+0x16e>
  unlink("bigfile.dat");
    4514:	00003517          	auipc	a0,0x3
    4518:	65c50513          	addi	a0,a0,1628 # 7b70 <malloc+0x1f78>
    451c:	20a010ef          	jal	5726 <unlink>
}
    4520:	70e2                	ld	ra,56(sp)
    4522:	7442                	ld	s0,48(sp)
    4524:	74a2                	ld	s1,40(sp)
    4526:	7902                	ld	s2,32(sp)
    4528:	69e2                	ld	s3,24(sp)
    452a:	6a42                	ld	s4,16(sp)
    452c:	6aa2                	ld	s5,8(sp)
    452e:	6b02                	ld	s6,0(sp)
    4530:	6121                	addi	sp,sp,64
    4532:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4534:	85da                	mv	a1,s6
    4536:	00003517          	auipc	a0,0x3
    453a:	70250513          	addi	a0,a0,1794 # 7c38 <malloc+0x2040>
    453e:	5fe010ef          	jal	5b3c <printf>
    exit(1);
    4542:	4505                	li	a0,1
    4544:	192010ef          	jal	56d6 <exit>

0000000000004548 <bigargtest>:
{
    4548:	7121                	addi	sp,sp,-448
    454a:	ff06                	sd	ra,440(sp)
    454c:	fb22                	sd	s0,432(sp)
    454e:	f726                	sd	s1,424(sp)
    4550:	0380                	addi	s0,sp,448
    4552:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    4554:	00003517          	auipc	a0,0x3
    4558:	70450513          	addi	a0,a0,1796 # 7c58 <malloc+0x2060>
    455c:	1ca010ef          	jal	5726 <unlink>
  pid = fork();
    4560:	16e010ef          	jal	56ce <fork>
  if (pid == 0) {
    4564:	c915                	beqz	a0,4598 <bigargtest+0x50>
  } else if (pid < 0) {
    4566:	08054c63          	bltz	a0,45fe <bigargtest+0xb6>
  wait(&xstatus);
    456a:	fdc40513          	addi	a0,s0,-36
    456e:	170010ef          	jal	56de <wait>
  if (xstatus != 0)
    4572:	fdc42503          	lw	a0,-36(s0)
    4576:	ed51                	bnez	a0,4612 <bigargtest+0xca>
  fd = open("bigarg-ok", 0);
    4578:	4581                	li	a1,0
    457a:	00003517          	auipc	a0,0x3
    457e:	6de50513          	addi	a0,a0,1758 # 7c58 <malloc+0x2060>
    4582:	194010ef          	jal	5716 <open>
  if (fd < 0) {
    4586:	08054863          	bltz	a0,4616 <bigargtest+0xce>
  close(fd);
    458a:	174010ef          	jal	56fe <close>
}
    458e:	70fa                	ld	ra,440(sp)
    4590:	745a                	ld	s0,432(sp)
    4592:	74ba                	ld	s1,424(sp)
    4594:	6139                	addi	sp,sp,448
    4596:	8082                	ret
    memset(big, ' ', sizeof(big));
    4598:	19000613          	li	a2,400
    459c:	02000593          	li	a1,32
    45a0:	e4840513          	addi	a0,s0,-440
    45a4:	709000ef          	jal	54ac <memset>
    big[sizeof(big) - 1] = '\0';
    45a8:	fc040ba3          	sb	zero,-41(s0)
    for (i = 0; i < MAXARG - 1; i++)
    45ac:	00006797          	auipc	a5,0x6
    45b0:	f2478793          	addi	a5,a5,-220 # a4d0 <args.1>
    45b4:	00006697          	auipc	a3,0x6
    45b8:	01468693          	addi	a3,a3,20 # a5c8 <args.1+0xf8>
      args[i] = big;
    45bc:	e4840713          	addi	a4,s0,-440
    45c0:	e398                	sd	a4,0(a5)
    for (i = 0; i < MAXARG - 1; i++)
    45c2:	07a1                	addi	a5,a5,8
    45c4:	fed79ee3          	bne	a5,a3,45c0 <bigargtest+0x78>
    args[MAXARG - 1] = 0;
    45c8:	00006797          	auipc	a5,0x6
    45cc:	0007b023          	sd	zero,0(a5) # a5c8 <args.1+0xf8>
    exec("echo", args);
    45d0:	00006597          	auipc	a1,0x6
    45d4:	f0058593          	addi	a1,a1,-256 # a4d0 <args.1>
    45d8:	00001517          	auipc	a0,0x1
    45dc:	75050513          	addi	a0,a0,1872 # 5d28 <malloc+0x130>
    45e0:	12e010ef          	jal	570e <exec>
    fd = open("bigarg-ok", O_CREATE);
    45e4:	20000593          	li	a1,512
    45e8:	00003517          	auipc	a0,0x3
    45ec:	67050513          	addi	a0,a0,1648 # 7c58 <malloc+0x2060>
    45f0:	126010ef          	jal	5716 <open>
    close(fd);
    45f4:	10a010ef          	jal	56fe <close>
    exit(0);
    45f8:	4501                	li	a0,0
    45fa:	0dc010ef          	jal	56d6 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    45fe:	85a6                	mv	a1,s1
    4600:	00003517          	auipc	a0,0x3
    4604:	66850513          	addi	a0,a0,1640 # 7c68 <malloc+0x2070>
    4608:	534010ef          	jal	5b3c <printf>
    exit(1);
    460c:	4505                	li	a0,1
    460e:	0c8010ef          	jal	56d6 <exit>
    exit(xstatus);
    4612:	0c4010ef          	jal	56d6 <exit>
    printf("%s: bigarg test failed!\n", s);
    4616:	85a6                	mv	a1,s1
    4618:	00003517          	auipc	a0,0x3
    461c:	67050513          	addi	a0,a0,1648 # 7c88 <malloc+0x2090>
    4620:	51c010ef          	jal	5b3c <printf>
    exit(1);
    4624:	4505                	li	a0,1
    4626:	0b0010ef          	jal	56d6 <exit>

000000000000462a <partial_write>:
{
    462a:	bb010113          	addi	sp,sp,-1104
    462e:	44113423          	sd	ra,1096(sp)
    4632:	44813023          	sd	s0,1088(sp)
    4636:	42913c23          	sd	s1,1080(sp)
    463a:	43213823          	sd	s2,1072(sp)
    463e:	43313423          	sd	s3,1064(sp)
    4642:	43413023          	sd	s4,1056(sp)
    4646:	41513c23          	sd	s5,1048(sp)
    464a:	45010413          	addi	s0,sp,1104
    464e:	8aaa                	mv	s5,a0
  unlink("testfile");
    4650:	00003517          	auipc	a0,0x3
    4654:	65850513          	addi	a0,a0,1624 # 7ca8 <malloc+0x20b0>
    4658:	0ce010ef          	jal	5726 <unlink>
  int fd = open("testfile", O_CREATE | O_RDWR);
    465c:	20200593          	li	a1,514
    4660:	00003517          	auipc	a0,0x3
    4664:	64850513          	addi	a0,a0,1608 # 7ca8 <malloc+0x20b0>
    4668:	0ae010ef          	jal	5716 <open>
  if (fd < 0) {
    466c:	14054f63          	bltz	a0,47ca <partial_write+0x1a0>
    4670:	84aa                	mv	s1,a0
  int cc = write(fd, "A", 1);
    4672:	4605                	li	a2,1
    4674:	00003597          	auipc	a1,0x3
    4678:	66458593          	addi	a1,a1,1636 # 7cd8 <malloc+0x20e0>
    467c:	07a010ef          	jal	56f6 <write>
  if (cc != 1) {
    4680:	4785                	li	a5,1
    4682:	14f51e63          	bne	a0,a5,47de <partial_write+0x1b4>
  close(fd);
    4686:	8526                	mv	a0,s1
    4688:	076010ef          	jal	56fe <close>
  fd = open("testfile", O_RDWR);
    468c:	4589                	li	a1,2
    468e:	00003517          	auipc	a0,0x3
    4692:	61a50513          	addi	a0,a0,1562 # 7ca8 <malloc+0x20b0>
    4696:	080010ef          	jal	5716 <open>
    469a:	84aa                	mv	s1,a0
  if (fd < 0) {
    469c:	14054b63          	bltz	a0,47f2 <partial_write+0x1c8>
  char *p = sbrk(0);
    46a0:	4501                	li	a0,0
    46a2:	000010ef          	jal	56a2 <sbrk>
  sbrk(PGSIZE - ((uint64)p % PGSIZE));
    46a6:	03451793          	slli	a5,a0,0x34
    46aa:	93d1                	srli	a5,a5,0x34
    46ac:	6505                	lui	a0,0x1
    46ae:	9d1d                	subw	a0,a0,a5
    46b0:	7f3000ef          	jal	56a2 <sbrk>
  p = sbrk(0);
    46b4:	4501                	li	a0,0
    46b6:	7ed000ef          	jal	56a2 <sbrk>
  if ((uint64)p % PGSIZE != 0) {
    46ba:	03451793          	slli	a5,a0,0x34
    46be:	14079463          	bnez	a5,4806 <partial_write+0x1dc>
  p[-1] = 'X';
    46c2:	05800793          	li	a5,88
    46c6:	fef50fa3          	sb	a5,-1(a0) # fff <bigdir+0x10b>
  cc = write(fd, p - 1, 2);
    46ca:	4609                	li	a2,2
    46cc:	fff50593          	addi	a1,a0,-1
    46d0:	8526                	mv	a0,s1
    46d2:	024010ef          	jal	56f6 <write>
  if (cc != -1) {
    46d6:	57fd                	li	a5,-1
    46d8:	14f51163          	bne	a0,a5,481a <partial_write+0x1f0>
  close(fd);
    46dc:	8526                	mv	a0,s1
    46de:	020010ef          	jal	56fe <close>
  fd = open("testfile", O_RDONLY);
    46e2:	4581                	li	a1,0
    46e4:	00003517          	auipc	a0,0x3
    46e8:	5c450513          	addi	a0,a0,1476 # 7ca8 <malloc+0x20b0>
    46ec:	02a010ef          	jal	5716 <open>
    46f0:	84aa                	mv	s1,a0
  if (fd < 0) {
    46f2:	12054e63          	bltz	a0,482e <partial_write+0x204>
  cc = read(fd, &b, 1);
    46f6:	4605                	li	a2,1
    46f8:	fbf40593          	addi	a1,s0,-65
    46fc:	7f3000ef          	jal	56ee <read>
  if (cc != 1) {
    4700:	4785                	li	a5,1
    4702:	14f51063          	bne	a0,a5,4842 <partial_write+0x218>
  close(fd);
    4706:	8526                	mv	a0,s1
    4708:	7f7000ef          	jal	56fe <close>
  if (b != 'X') {
    470c:	fbf44603          	lbu	a2,-65(s0)
    4710:	05800793          	li	a5,88
    4714:	14f61163          	bne	a2,a5,4856 <partial_write+0x22c>
  fd = open("bigfile", O_CREATE | O_RDWR);
    4718:	20200593          	li	a1,514
    471c:	00003517          	auipc	a0,0x3
    4720:	68c50513          	addi	a0,a0,1676 # 7da8 <malloc+0x21b0>
    4724:	7f3000ef          	jal	5716 <open>
    4728:	8a2a                	mv	s4,a0
    472a:	04000913          	li	s2,64
    memset(buf, 0, sizeof(buf));
    472e:	bb840993          	addi	s3,s0,-1096
    4732:	40000493          	li	s1,1024
    4736:	8626                	mv	a2,s1
    4738:	4581                	li	a1,0
    473a:	854e                	mv	a0,s3
    473c:	571000ef          	jal	54ac <memset>
    cc = write(fd, buf, sizeof(buf));
    4740:	8626                	mv	a2,s1
    4742:	85ce                	mv	a1,s3
    4744:	8552                	mv	a0,s4
    4746:	7b1000ef          	jal	56f6 <write>
    if (cc != sizeof(buf)) {
    474a:	12951063          	bne	a0,s1,486a <partial_write+0x240>
  for (int i = 0; i < 64; i++) {
    474e:	397d                	addiw	s2,s2,-1
    4750:	fe0913e3          	bnez	s2,4736 <partial_write+0x10c>
  close(fd);
    4754:	8552                	mv	a0,s4
    4756:	7a9000ef          	jal	56fe <close>
  unlink("bigfile");
    475a:	00003517          	auipc	a0,0x3
    475e:	64e50513          	addi	a0,a0,1614 # 7da8 <malloc+0x21b0>
    4762:	7c5000ef          	jal	5726 <unlink>
  fd = open("testfile", O_RDONLY);
    4766:	4581                	li	a1,0
    4768:	00003517          	auipc	a0,0x3
    476c:	54050513          	addi	a0,a0,1344 # 7ca8 <malloc+0x20b0>
    4770:	7a7000ef          	jal	5716 <open>
    4774:	84aa                	mv	s1,a0
  if (fd < 0) {
    4776:	10054463          	bltz	a0,487e <partial_write+0x254>
  cc = read(fd, &b, 1);
    477a:	4605                	li	a2,1
    477c:	fbf40593          	addi	a1,s0,-65
    4780:	76f000ef          	jal	56ee <read>
  if (cc != 1) {
    4784:	4785                	li	a5,1
    4786:	10f51663          	bne	a0,a5,4892 <partial_write+0x268>
  close(fd);
    478a:	8526                	mv	a0,s1
    478c:	773000ef          	jal	56fe <close>
  if (b != 'X') {
    4790:	fbf44603          	lbu	a2,-65(s0)
    4794:	05800793          	li	a5,88
    4798:	10f61763          	bne	a2,a5,48a6 <partial_write+0x27c>
  unlink("testfile");
    479c:	00003517          	auipc	a0,0x3
    47a0:	50c50513          	addi	a0,a0,1292 # 7ca8 <malloc+0x20b0>
    47a4:	783000ef          	jal	5726 <unlink>
}
    47a8:	44813083          	ld	ra,1096(sp)
    47ac:	44013403          	ld	s0,1088(sp)
    47b0:	43813483          	ld	s1,1080(sp)
    47b4:	43013903          	ld	s2,1072(sp)
    47b8:	42813983          	ld	s3,1064(sp)
    47bc:	42013a03          	ld	s4,1056(sp)
    47c0:	41813a83          	ld	s5,1048(sp)
    47c4:	45010113          	addi	sp,sp,1104
    47c8:	8082                	ret
    printf("%s: cannot create testfile\n", s);
    47ca:	85d6                	mv	a1,s5
    47cc:	00003517          	auipc	a0,0x3
    47d0:	4ec50513          	addi	a0,a0,1260 # 7cb8 <malloc+0x20c0>
    47d4:	368010ef          	jal	5b3c <printf>
    exit(1);
    47d8:	4505                	li	a0,1
    47da:	6fd000ef          	jal	56d6 <exit>
    printf("%s: could not write A\n", s);
    47de:	85d6                	mv	a1,s5
    47e0:	00003517          	auipc	a0,0x3
    47e4:	50050513          	addi	a0,a0,1280 # 7ce0 <malloc+0x20e8>
    47e8:	354010ef          	jal	5b3c <printf>
    exit(1);
    47ec:	4505                	li	a0,1
    47ee:	6e9000ef          	jal	56d6 <exit>
    printf("%s: cannot re-open testfile\n", s);
    47f2:	85d6                	mv	a1,s5
    47f4:	00003517          	auipc	a0,0x3
    47f8:	50450513          	addi	a0,a0,1284 # 7cf8 <malloc+0x2100>
    47fc:	340010ef          	jal	5b3c <printf>
    exit(1);
    4800:	4505                	li	a0,1
    4802:	6d5000ef          	jal	56d6 <exit>
    printf("%s: sbrk did not align\n", s);
    4806:	85d6                	mv	a1,s5
    4808:	00003517          	auipc	a0,0x3
    480c:	51050513          	addi	a0,a0,1296 # 7d18 <malloc+0x2120>
    4810:	32c010ef          	jal	5b3c <printf>
    exit(1);
    4814:	4505                	li	a0,1
    4816:	6c1000ef          	jal	56d6 <exit>
    printf("%s: write succeeded, should have failed\n", s);
    481a:	85d6                	mv	a1,s5
    481c:	00003517          	auipc	a0,0x3
    4820:	51450513          	addi	a0,a0,1300 # 7d30 <malloc+0x2138>
    4824:	318010ef          	jal	5b3c <printf>
    exit(1);
    4828:	4505                	li	a0,1
    482a:	6ad000ef          	jal	56d6 <exit>
    printf("%s: cannot re-open testfile\n", s);
    482e:	85d6                	mv	a1,s5
    4830:	00003517          	auipc	a0,0x3
    4834:	4c850513          	addi	a0,a0,1224 # 7cf8 <malloc+0x2100>
    4838:	304010ef          	jal	5b3c <printf>
    exit(1);
    483c:	4505                	li	a0,1
    483e:	699000ef          	jal	56d6 <exit>
    printf("%s: cannot read testfile\n", s);
    4842:	85d6                	mv	a1,s5
    4844:	00003517          	auipc	a0,0x3
    4848:	51c50513          	addi	a0,a0,1308 # 7d60 <malloc+0x2168>
    484c:	2f0010ef          	jal	5b3c <printf>
    exit(1);
    4850:	4505                	li	a0,1
    4852:	685000ef          	jal	56d6 <exit>
    printf("%s: read returned %c, expected X\n", s, b);
    4856:	85d6                	mv	a1,s5
    4858:	00003517          	auipc	a0,0x3
    485c:	52850513          	addi	a0,a0,1320 # 7d80 <malloc+0x2188>
    4860:	2dc010ef          	jal	5b3c <printf>
    exit(1);
    4864:	4505                	li	a0,1
    4866:	671000ef          	jal	56d6 <exit>
      printf("%s: could not write to bigfile\n", s);
    486a:	85d6                	mv	a1,s5
    486c:	00003517          	auipc	a0,0x3
    4870:	54450513          	addi	a0,a0,1348 # 7db0 <malloc+0x21b8>
    4874:	2c8010ef          	jal	5b3c <printf>
      exit(-1);
    4878:	557d                	li	a0,-1
    487a:	65d000ef          	jal	56d6 <exit>
    printf("%s: cannot re-open testfile\n", s);
    487e:	85d6                	mv	a1,s5
    4880:	00003517          	auipc	a0,0x3
    4884:	47850513          	addi	a0,a0,1144 # 7cf8 <malloc+0x2100>
    4888:	2b4010ef          	jal	5b3c <printf>
    exit(1);
    488c:	4505                	li	a0,1
    488e:	649000ef          	jal	56d6 <exit>
    printf("%s: cannot read testfile\n", s);
    4892:	85d6                	mv	a1,s5
    4894:	00003517          	auipc	a0,0x3
    4898:	4cc50513          	addi	a0,a0,1228 # 7d60 <malloc+0x2168>
    489c:	2a0010ef          	jal	5b3c <printf>
    exit(1);
    48a0:	4505                	li	a0,1
    48a2:	635000ef          	jal	56d6 <exit>
    printf("%s: read returned %c, expected X\n", s, b);
    48a6:	85d6                	mv	a1,s5
    48a8:	00003517          	auipc	a0,0x3
    48ac:	4d850513          	addi	a0,a0,1240 # 7d80 <malloc+0x2188>
    48b0:	28c010ef          	jal	5b3c <printf>
    exit(1);
    48b4:	4505                	li	a0,1
    48b6:	621000ef          	jal	56d6 <exit>

00000000000048ba <lazy_alloc>:
{
    48ba:	1141                	addi	sp,sp,-16
    48bc:	e406                	sd	ra,8(sp)
    48be:	e022                	sd	s0,0(sp)
    48c0:	0800                	addi	s0,sp,16
  prev_end = sbrklazy(REGION_SZ);
    48c2:	40000537          	lui	a0,0x40000
    48c6:	5f3000ef          	jal	56b8 <sbrklazy>
  if (prev_end == (char *)SBRK_ERROR) {
    48ca:	57fd                	li	a5,-1
    48cc:	02f50a63          	beq	a0,a5,4900 <lazy_alloc+0x46>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    48d0:	6605                	lui	a2,0x1
    48d2:	962a                	add	a2,a2,a0
    48d4:	400017b7          	lui	a5,0x40001
    48d8:	00f50733          	add	a4,a0,a5
    48dc:	87b2                	mv	a5,a2
    48de:	000406b7          	lui	a3,0x40
    *(char **)i = i;
    48e2:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    48e4:	97b6                	add	a5,a5,a3
    48e6:	fee79ee3          	bne	a5,a4,48e2 <lazy_alloc+0x28>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    48ea:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
    48ee:	621c                	ld	a5,0(a2)
    48f0:	02c79163          	bne	a5,a2,4912 <lazy_alloc+0x58>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    48f4:	9636                	add	a2,a2,a3
    48f6:	fee61ce3          	bne	a2,a4,48ee <lazy_alloc+0x34>
  exit(0);
    48fa:	4501                	li	a0,0
    48fc:	5db000ef          	jal	56d6 <exit>
    printf("sbrklazy() failed\n");
    4900:	00003517          	auipc	a0,0x3
    4904:	4d050513          	addi	a0,a0,1232 # 7dd0 <malloc+0x21d8>
    4908:	234010ef          	jal	5b3c <printf>
    exit(1);
    490c:	4505                	li	a0,1
    490e:	5c9000ef          	jal	56d6 <exit>
      printf("failed to read value from memory\n");
    4912:	00003517          	auipc	a0,0x3
    4916:	4d650513          	addi	a0,a0,1238 # 7de8 <malloc+0x21f0>
    491a:	222010ef          	jal	5b3c <printf>
      exit(1);
    491e:	4505                	li	a0,1
    4920:	5b7000ef          	jal	56d6 <exit>

0000000000004924 <lazy_unmap>:
{
    4924:	7139                	addi	sp,sp,-64
    4926:	fc06                	sd	ra,56(sp)
    4928:	f822                	sd	s0,48(sp)
    492a:	0080                	addi	s0,sp,64
  prev_end = sbrklazy(REGION_SZ);
    492c:	40000537          	lui	a0,0x40000
    4930:	589000ef          	jal	56b8 <sbrklazy>
  if (prev_end == (char *)SBRK_ERROR) {
    4934:	57fd                	li	a5,-1
    4936:	04f50863          	beq	a0,a5,4986 <lazy_unmap+0x62>
    493a:	f426                	sd	s1,40(sp)
    493c:	f04a                	sd	s2,32(sp)
    493e:	ec4e                	sd	s3,24(sp)
    4940:	e852                	sd	s4,16(sp)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    4942:	6905                	lui	s2,0x1
    4944:	992a                	add	s2,s2,a0
    4946:	400017b7          	lui	a5,0x40001
    494a:	00f504b3          	add	s1,a0,a5
    494e:	87ca                	mv	a5,s2
    4950:	01000737          	lui	a4,0x1000
    *(char **)i = i;
    4954:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    4956:	97ba                	add	a5,a5,a4
    4958:	fe979ee3          	bne	a5,s1,4954 <lazy_unmap+0x30>
      wait(&status);
    495c:	fcc40993          	addi	s3,s0,-52
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    4960:	01000a37          	lui	s4,0x1000
    pid = fork();
    4964:	56b000ef          	jal	56ce <fork>
    if (pid < 0) {
    4968:	02054c63          	bltz	a0,49a0 <lazy_unmap+0x7c>
    } else if (pid == 0) {
    496c:	c139                	beqz	a0,49b2 <lazy_unmap+0x8e>
      wait(&status);
    496e:	854e                	mv	a0,s3
    4970:	56f000ef          	jal	56de <wait>
      if (status == 0) {
    4974:	fcc42783          	lw	a5,-52(s0)
    4978:	c7b1                	beqz	a5,49c4 <lazy_unmap+0xa0>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    497a:	9952                	add	s2,s2,s4
    497c:	fe9914e3          	bne	s2,s1,4964 <lazy_unmap+0x40>
  exit(0);
    4980:	4501                	li	a0,0
    4982:	555000ef          	jal	56d6 <exit>
    4986:	f426                	sd	s1,40(sp)
    4988:	f04a                	sd	s2,32(sp)
    498a:	ec4e                	sd	s3,24(sp)
    498c:	e852                	sd	s4,16(sp)
    printf("sbrklazy() failed\n");
    498e:	00003517          	auipc	a0,0x3
    4992:	44250513          	addi	a0,a0,1090 # 7dd0 <malloc+0x21d8>
    4996:	1a6010ef          	jal	5b3c <printf>
    exit(1);
    499a:	4505                	li	a0,1
    499c:	53b000ef          	jal	56d6 <exit>
      printf("error forking\n");
    49a0:	00003517          	auipc	a0,0x3
    49a4:	47050513          	addi	a0,a0,1136 # 7e10 <malloc+0x2218>
    49a8:	194010ef          	jal	5b3c <printf>
      exit(1);
    49ac:	4505                	li	a0,1
    49ae:	529000ef          	jal	56d6 <exit>
      sbrklazy(-1L * REGION_SZ);
    49b2:	c0000537          	lui	a0,0xc0000
    49b6:	503000ef          	jal	56b8 <sbrklazy>
      *(char **)i = i;
    49ba:	01293023          	sd	s2,0(s2) # 1000 <bigdir+0x10c>
      exit(0);
    49be:	4501                	li	a0,0
    49c0:	517000ef          	jal	56d6 <exit>
        printf("memory not unmapped\n");
    49c4:	00003517          	auipc	a0,0x3
    49c8:	45c50513          	addi	a0,a0,1116 # 7e20 <malloc+0x2228>
    49cc:	170010ef          	jal	5b3c <printf>
        exit(1);
    49d0:	4505                	li	a0,1
    49d2:	505000ef          	jal	56d6 <exit>

00000000000049d6 <lazy_copy>:
{
    49d6:	7119                	addi	sp,sp,-128
    49d8:	fc86                	sd	ra,120(sp)
    49da:	f8a2                	sd	s0,112(sp)
    49dc:	f4a6                	sd	s1,104(sp)
    49de:	f0ca                	sd	s2,96(sp)
    49e0:	ecce                	sd	s3,88(sp)
    49e2:	e8d2                	sd	s4,80(sp)
    49e4:	e4d6                	sd	s5,72(sp)
    49e6:	e0da                	sd	s6,64(sp)
    49e8:	fc5e                	sd	s7,56(sp)
    49ea:	0100                	addi	s0,sp,128
    char *p = sbrk(0);
    49ec:	4501                	li	a0,0
    49ee:	4b5000ef          	jal	56a2 <sbrk>
    49f2:	84aa                	mv	s1,a0
    sbrklazy(4 * PGSIZE);
    49f4:	6511                	lui	a0,0x4
    49f6:	4c3000ef          	jal	56b8 <sbrklazy>
    open(p + 8192, 0);
    49fa:	4581                	li	a1,0
    49fc:	6509                	lui	a0,0x2
    49fe:	9526                	add	a0,a0,s1
    4a00:	517000ef          	jal	5716 <open>
    void *xx = sbrk(0);
    4a04:	4501                	li	a0,0
    4a06:	49d000ef          	jal	56a2 <sbrk>
    4a0a:	84aa                	mv	s1,a0
    void *ret = sbrk(-(((uint64)xx) + 1));
    4a0c:	fff54513          	not	a0,a0
    4a10:	2501                	sext.w	a0,a0
    4a12:	491000ef          	jal	56a2 <sbrk>
    if (ret != xx) {
    4a16:	00a48c63          	beq	s1,a0,4a2e <lazy_copy+0x58>
    4a1a:	85aa                	mv	a1,a0
      printf("sbrk(sbrk(0)+1) returned %p, not old sz\n", ret);
    4a1c:	00003517          	auipc	a0,0x3
    4a20:	41c50513          	addi	a0,a0,1052 # 7e38 <malloc+0x2240>
    4a24:	118010ef          	jal	5b3c <printf>
      exit(1);
    4a28:	4505                	li	a0,1
    4a2a:	4ad000ef          	jal	56d6 <exit>
  unsigned long bad[] = {
    4a2e:	00004797          	auipc	a5,0x4
    4a32:	bb278793          	addi	a5,a5,-1102 # 85e0 <malloc+0x29e8>
    4a36:	7fa8                	ld	a0,120(a5)
    4a38:	63cc                	ld	a1,128(a5)
    4a3a:	67d0                	ld	a2,136(a5)
    4a3c:	6bd4                	ld	a3,144(a5)
    4a3e:	6fd8                	ld	a4,152(a5)
    4a40:	f8a43023          	sd	a0,-128(s0)
    4a44:	f8b43423          	sd	a1,-120(s0)
    4a48:	f8c43823          	sd	a2,-112(s0)
    4a4c:	f8d43c23          	sd	a3,-104(s0)
    4a50:	fae43023          	sd	a4,-96(s0)
    4a54:	73dc                	ld	a5,160(a5)
    4a56:	faf43423          	sd	a5,-88(s0)
  for (int i = 0; i < sizeof(bad) / sizeof(bad[0]); i++) {
    4a5a:	f8040913          	addi	s2,s0,-128
    int fd = open("README", 0);
    4a5e:	00001a97          	auipc	s5,0x1
    4a62:	4a2a8a93          	addi	s5,s5,1186 # 5f00 <malloc+0x308>
    if (read(fd, (char *)bad[i], 512) >= 0) {
    4a66:	20000a13          	li	s4,512
    fd = open("junk", O_CREATE | O_RDWR | O_TRUNC);
    4a6a:	60200b93          	li	s7,1538
    4a6e:	00001b17          	auipc	s6,0x1
    4a72:	3a2b0b13          	addi	s6,s6,930 # 5e10 <malloc+0x218>
    int fd = open("README", 0);
    4a76:	4581                	li	a1,0
    4a78:	8556                	mv	a0,s5
    4a7a:	49d000ef          	jal	5716 <open>
    4a7e:	84aa                	mv	s1,a0
    if (fd < 0) {
    4a80:	04054563          	bltz	a0,4aca <lazy_copy+0xf4>
    if (read(fd, (char *)bad[i], 512) >= 0) {
    4a84:	00093983          	ld	s3,0(s2)
    4a88:	8652                	mv	a2,s4
    4a8a:	85ce                	mv	a1,s3
    4a8c:	463000ef          	jal	56ee <read>
    4a90:	04055663          	bgez	a0,4adc <lazy_copy+0x106>
    close(fd);
    4a94:	8526                	mv	a0,s1
    4a96:	469000ef          	jal	56fe <close>
    fd = open("junk", O_CREATE | O_RDWR | O_TRUNC);
    4a9a:	85de                	mv	a1,s7
    4a9c:	855a                	mv	a0,s6
    4a9e:	479000ef          	jal	5716 <open>
    4aa2:	84aa                	mv	s1,a0
    if (fd < 0) {
    4aa4:	04054563          	bltz	a0,4aee <lazy_copy+0x118>
    if (write(fd, (char *)bad[i], 512) >= 0) {
    4aa8:	8652                	mv	a2,s4
    4aaa:	85ce                	mv	a1,s3
    4aac:	44b000ef          	jal	56f6 <write>
    4ab0:	04055863          	bgez	a0,4b00 <lazy_copy+0x12a>
    close(fd);
    4ab4:	8526                	mv	a0,s1
    4ab6:	449000ef          	jal	56fe <close>
  for (int i = 0; i < sizeof(bad) / sizeof(bad[0]); i++) {
    4aba:	0921                	addi	s2,s2,8
    4abc:	fb040793          	addi	a5,s0,-80
    4ac0:	faf91be3          	bne	s2,a5,4a76 <lazy_copy+0xa0>
  exit(0);
    4ac4:	4501                	li	a0,0
    4ac6:	411000ef          	jal	56d6 <exit>
      printf("cannot open README\n");
    4aca:	00003517          	auipc	a0,0x3
    4ace:	39e50513          	addi	a0,a0,926 # 7e68 <malloc+0x2270>
    4ad2:	06a010ef          	jal	5b3c <printf>
      exit(1);
    4ad6:	4505                	li	a0,1
    4ad8:	3ff000ef          	jal	56d6 <exit>
      printf("read succeeded\n");
    4adc:	00003517          	auipc	a0,0x3
    4ae0:	3a450513          	addi	a0,a0,932 # 7e80 <malloc+0x2288>
    4ae4:	058010ef          	jal	5b3c <printf>
      exit(1);
    4ae8:	4505                	li	a0,1
    4aea:	3ed000ef          	jal	56d6 <exit>
      printf("cannot open junk\n");
    4aee:	00003517          	auipc	a0,0x3
    4af2:	3a250513          	addi	a0,a0,930 # 7e90 <malloc+0x2298>
    4af6:	046010ef          	jal	5b3c <printf>
      exit(1);
    4afa:	4505                	li	a0,1
    4afc:	3db000ef          	jal	56d6 <exit>
      printf("write succeeded\n");
    4b00:	00003517          	auipc	a0,0x3
    4b04:	3a850513          	addi	a0,a0,936 # 7ea8 <malloc+0x22b0>
    4b08:	034010ef          	jal	5b3c <printf>
      exit(1);
    4b0c:	4505                	li	a0,1
    4b0e:	3c9000ef          	jal	56d6 <exit>

0000000000004b12 <lazy_sbrk>:
{
    4b12:	7179                	addi	sp,sp,-48
    4b14:	f406                	sd	ra,40(sp)
    4b16:	f022                	sd	s0,32(sp)
    4b18:	ec26                	sd	s1,24(sp)
    4b1a:	e84a                	sd	s2,16(sp)
    4b1c:	e44e                	sd	s3,8(sp)
    4b1e:	1800                	addi	s0,sp,48
  char *p = sbrk(0);
    4b20:	4501                	li	a0,0
    4b22:	381000ef          	jal	56a2 <sbrk>
    4b26:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA - (1 << 30)) {
    4b28:	0ff00793          	li	a5,255
    4b2c:	07fa                	slli	a5,a5,0x1e
    4b2e:	00f57e63          	bgeu	a0,a5,4b4a <lazy_sbrk+0x38>
    p = sbrklazy(1 << 30);
    4b32:	400009b7          	lui	s3,0x40000
  while ((uint64)p < MAXVA - (1 << 30)) {
    4b36:	893e                	mv	s2,a5
    p = sbrklazy(1 << 30);
    4b38:	854e                	mv	a0,s3
    4b3a:	37f000ef          	jal	56b8 <sbrklazy>
    p = sbrklazy(0);
    4b3e:	4501                	li	a0,0
    4b40:	379000ef          	jal	56b8 <sbrklazy>
    4b44:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA - (1 << 30)) {
    4b46:	ff2569e3          	bltu	a0,s2,4b38 <lazy_sbrk+0x26>
  int n = TRAPFRAME - PGSIZE - (uint64)p;
    4b4a:	7975                	lui	s2,0xffffd
    4b4c:	4099093b          	subw	s2,s2,s1
  char *p1 = sbrklazy(n);
    4b50:	854a                	mv	a0,s2
    4b52:	367000ef          	jal	56b8 <sbrklazy>
    4b56:	862a                	mv	a2,a0
  if (p1 < 0 || p1 != p) {
    4b58:	00950d63          	beq	a0,s1,4b72 <lazy_sbrk+0x60>
    printf("sbrklazy(%d) returned %p, not expected %p\n", n, p1, p);
    4b5c:	86a6                	mv	a3,s1
    4b5e:	85ca                	mv	a1,s2
    4b60:	00003517          	auipc	a0,0x3
    4b64:	36050513          	addi	a0,a0,864 # 7ec0 <malloc+0x22c8>
    4b68:	7d5000ef          	jal	5b3c <printf>
    exit(1);
    4b6c:	4505                	li	a0,1
    4b6e:	369000ef          	jal	56d6 <exit>
  p = sbrk(PGSIZE);
    4b72:	6505                	lui	a0,0x1
    4b74:	32f000ef          	jal	56a2 <sbrk>
    4b78:	862a                	mv	a2,a0
  if (p < 0 || (uint64)p != TRAPFRAME - PGSIZE) {
    4b7a:	040007b7          	lui	a5,0x4000
    4b7e:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3fef315>
    4b80:	07b2                	slli	a5,a5,0xc
    4b82:	00f50c63          	beq	a0,a5,4b9a <lazy_sbrk+0x88>
    printf("sbrk(%d) returned %p, not expected TRAPFRAME-PGSIZE\n", PGSIZE, p);
    4b86:	6585                	lui	a1,0x1
    4b88:	00003517          	auipc	a0,0x3
    4b8c:	36850513          	addi	a0,a0,872 # 7ef0 <malloc+0x22f8>
    4b90:	7ad000ef          	jal	5b3c <printf>
    exit(1);
    4b94:	4505                	li	a0,1
    4b96:	341000ef          	jal	56d6 <exit>
  p[0] = 1;
    4b9a:	040007b7          	lui	a5,0x4000
    4b9e:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3fef315>
    4ba0:	07b2                	slli	a5,a5,0xc
    4ba2:	4705                	li	a4,1
    4ba4:	00e78023          	sb	a4,0(a5)
  if (p[1] != 0) {
    4ba8:	0017c783          	lbu	a5,1(a5)
    4bac:	cb91                	beqz	a5,4bc0 <lazy_sbrk+0xae>
    printf("sbrk() returned non-zero-filled memory\n");
    4bae:	00003517          	auipc	a0,0x3
    4bb2:	37a50513          	addi	a0,a0,890 # 7f28 <malloc+0x2330>
    4bb6:	787000ef          	jal	5b3c <printf>
    exit(1);
    4bba:	4505                	li	a0,1
    4bbc:	31b000ef          	jal	56d6 <exit>
  p = sbrk(1);
    4bc0:	4505                	li	a0,1
    4bc2:	2e1000ef          	jal	56a2 <sbrk>
    4bc6:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    4bc8:	57fd                	li	a5,-1
    4bca:	00f50b63          	beq	a0,a5,4be0 <lazy_sbrk+0xce>
    printf("sbrk(1) returned %p, expected error\n", p);
    4bce:	00003517          	auipc	a0,0x3
    4bd2:	38250513          	addi	a0,a0,898 # 7f50 <malloc+0x2358>
    4bd6:	767000ef          	jal	5b3c <printf>
    exit(1);
    4bda:	4505                	li	a0,1
    4bdc:	2fb000ef          	jal	56d6 <exit>
  p = sbrklazy(1);
    4be0:	4505                	li	a0,1
    4be2:	2d7000ef          	jal	56b8 <sbrklazy>
    4be6:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    4be8:	57fd                	li	a5,-1
    4bea:	00f50b63          	beq	a0,a5,4c00 <lazy_sbrk+0xee>
    printf("sbrklazy(1) returned %p, expected error\n", p);
    4bee:	00003517          	auipc	a0,0x3
    4bf2:	38a50513          	addi	a0,a0,906 # 7f78 <malloc+0x2380>
    4bf6:	747000ef          	jal	5b3c <printf>
    exit(1);
    4bfa:	4505                	li	a0,1
    4bfc:	2db000ef          	jal	56d6 <exit>
  exit(0);
    4c00:	4501                	li	a0,0
    4c02:	2d5000ef          	jal	56d6 <exit>

0000000000004c06 <lazy_copyinstr>:
{
    4c06:	7139                	addi	sp,sp,-64
    4c08:	fc06                	sd	ra,56(sp)
    4c0a:	f822                	sd	s0,48(sp)
    4c0c:	f426                	sd	s1,40(sp)
    4c0e:	f04a                	sd	s2,32(sp)
    4c10:	0080                	addi	s0,sp,64
    4c12:	892a                	mv	s2,a0
  char *p = sbrk(0);
    4c14:	4501                	li	a0,0
    4c16:	28d000ef          	jal	56a2 <sbrk>
  sbrk(PGSIZE - ((uint64)p % PGSIZE));
    4c1a:	03451793          	slli	a5,a0,0x34
    4c1e:	93d1                	srli	a5,a5,0x34
    4c20:	6505                	lui	a0,0x1
    4c22:	9d1d                	subw	a0,a0,a5
    4c24:	27f000ef          	jal	56a2 <sbrk>
  p = sbrk(0);
    4c28:	4501                	li	a0,0
    4c2a:	279000ef          	jal	56a2 <sbrk>
  if ((uint64)p % PGSIZE != 0) {
    4c2e:	03451793          	slli	a5,a0,0x34
    4c32:	eba1                	bnez	a5,4c82 <lazy_copyinstr+0x7c>
    4c34:	84aa                	mv	s1,a0
  sbrklazy(2 * PGSIZE);
    4c36:	6509                	lui	a0,0x2
    4c38:	281000ef          	jal	56b8 <sbrklazy>
  p[4095] = '/';
    4c3c:	6505                	lui	a0,0x1
    4c3e:	00a487b3          	add	a5,s1,a0
    4c42:	02f00713          	li	a4,47
    4c46:	fee78fa3          	sb	a4,-1(a5)
  int fd = open(&p[4095], O_RDONLY);
    4c4a:	157d                	addi	a0,a0,-1 # fff <bigdir+0x10b>
    4c4c:	4581                	li	a1,0
    4c4e:	9526                	add	a0,a0,s1
    4c50:	2c7000ef          	jal	5716 <open>
    4c54:	84aa                	mv	s1,a0
  if (fd < 0) {
    4c56:	04054063          	bltz	a0,4c96 <lazy_copyinstr+0x90>
  int r = fstat(fd, &st);
    4c5a:	fc840593          	addi	a1,s0,-56
    4c5e:	2d1000ef          	jal	572e <fstat>
  if (r < 0) {
    4c62:	04054363          	bltz	a0,4ca8 <lazy_copyinstr+0xa2>
  if (st.type != T_DIR) {
    4c66:	fd041703          	lh	a4,-48(s0)
    4c6a:	4785                	li	a5,1
    4c6c:	04f71763          	bne	a4,a5,4cba <lazy_copyinstr+0xb4>
  close(fd);
    4c70:	8526                	mv	a0,s1
    4c72:	28d000ef          	jal	56fe <close>
}
    4c76:	70e2                	ld	ra,56(sp)
    4c78:	7442                	ld	s0,48(sp)
    4c7a:	74a2                	ld	s1,40(sp)
    4c7c:	7902                	ld	s2,32(sp)
    4c7e:	6121                	addi	sp,sp,64
    4c80:	8082                	ret
    printf("%s: sbrk did not align\n", s);
    4c82:	85ca                	mv	a1,s2
    4c84:	00003517          	auipc	a0,0x3
    4c88:	09450513          	addi	a0,a0,148 # 7d18 <malloc+0x2120>
    4c8c:	6b1000ef          	jal	5b3c <printf>
    exit(1);
    4c90:	4505                	li	a0,1
    4c92:	245000ef          	jal	56d6 <exit>
    printf("could not open /");
    4c96:	00003517          	auipc	a0,0x3
    4c9a:	31250513          	addi	a0,a0,786 # 7fa8 <malloc+0x23b0>
    4c9e:	69f000ef          	jal	5b3c <printf>
    exit(1);
    4ca2:	4505                	li	a0,1
    4ca4:	233000ef          	jal	56d6 <exit>
    printf("could not stat /");
    4ca8:	00003517          	auipc	a0,0x3
    4cac:	31850513          	addi	a0,a0,792 # 7fc0 <malloc+0x23c8>
    4cb0:	68d000ef          	jal	5b3c <printf>
    exit(1);
    4cb4:	4505                	li	a0,1
    4cb6:	221000ef          	jal	56d6 <exit>
    printf("/ is not T_DIR");
    4cba:	00003517          	auipc	a0,0x3
    4cbe:	31e50513          	addi	a0,a0,798 # 7fd8 <malloc+0x23e0>
    4cc2:	67b000ef          	jal	5b3c <printf>
    exit(1);
    4cc6:	4505                	li	a0,1
    4cc8:	20f000ef          	jal	56d6 <exit>

0000000000004ccc <fsfull>:
{
    4ccc:	7131                	addi	sp,sp,-192
    4cce:	fd06                	sd	ra,184(sp)
    4cd0:	f922                	sd	s0,176(sp)
    4cd2:	f526                	sd	s1,168(sp)
    4cd4:	f14a                	sd	s2,160(sp)
    4cd6:	ed4e                	sd	s3,152(sp)
    4cd8:	e952                	sd	s4,144(sp)
    4cda:	e556                	sd	s5,136(sp)
    4cdc:	e15a                	sd	s6,128(sp)
    4cde:	fcde                	sd	s7,120(sp)
    4ce0:	f8e2                	sd	s8,112(sp)
    4ce2:	f4e6                	sd	s9,104(sp)
    4ce4:	f0ea                	sd	s10,96(sp)
    4ce6:	ecee                	sd	s11,88(sp)
    4ce8:	0180                	addi	s0,sp,192
  printf("fsfull test\n");
    4cea:	00003517          	auipc	a0,0x3
    4cee:	2fe50513          	addi	a0,a0,766 # 7fe8 <malloc+0x23f0>
    4cf2:	64b000ef          	jal	5b3c <printf>
  int fsblocks = 0;
    4cf6:	4981                	li	s3,0
  for (nfiles = 0;; nfiles++) {
    4cf8:	4481                	li	s1,0
    name[0] = 'f';
    4cfa:	06600d93          	li	s11,102
    name[1] = '0' + nfiles / 1000;
    4cfe:	106257b7          	lui	a5,0x10625
    4d02:	dd378793          	addi	a5,a5,-557 # 10624dd3 <base+0x106140eb>
    4d06:	f4f43423          	sd	a5,-184(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4d0a:	51eb8b37          	lui	s6,0x51eb8
    4d0e:	51fb0b13          	addi	s6,s6,1311 # 51eb851f <base+0x51ea7837>
    name[3] = '0' + (nfiles % 100) / 10;
    4d12:	66666ab7          	lui	s5,0x66666
    4d16:	667a8a93          	addi	s5,s5,1639 # 66666667 <base+0x6665597f>
    printf("writing %s\n", name);
    4d1a:	f5040d13          	addi	s10,s0,-176
    name[0] = 'f';
    4d1e:	f5b40823          	sb	s11,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4d22:	f4843783          	ld	a5,-184(s0)
    4d26:	02f487b3          	mul	a5,s1,a5
    4d2a:	9799                	srai	a5,a5,0x26
    4d2c:	41f4d69b          	sraiw	a3,s1,0x1f
    4d30:	9f95                	subw	a5,a5,a3
    4d32:	0307871b          	addiw	a4,a5,48
    4d36:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4d3a:	3e800713          	li	a4,1000
    4d3e:	02f707bb          	mulw	a5,a4,a5
    4d42:	40f487bb          	subw	a5,s1,a5
    4d46:	03678733          	mul	a4,a5,s6
    4d4a:	9715                	srai	a4,a4,0x25
    4d4c:	41f7d79b          	sraiw	a5,a5,0x1f
    4d50:	40f707bb          	subw	a5,a4,a5
    4d54:	0307879b          	addiw	a5,a5,48
    4d58:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4d5c:	036487b3          	mul	a5,s1,s6
    4d60:	9795                	srai	a5,a5,0x25
    4d62:	9f95                	subw	a5,a5,a3
    4d64:	06400713          	li	a4,100
    4d68:	02f707bb          	mulw	a5,a4,a5
    4d6c:	40f487bb          	subw	a5,s1,a5
    4d70:	03578733          	mul	a4,a5,s5
    4d74:	9709                	srai	a4,a4,0x22
    4d76:	41f7d79b          	sraiw	a5,a5,0x1f
    4d7a:	40f707bb          	subw	a5,a4,a5
    4d7e:	0307879b          	addiw	a5,a5,48
    4d82:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4d86:	03548733          	mul	a4,s1,s5
    4d8a:	9709                	srai	a4,a4,0x22
    4d8c:	9f15                	subw	a4,a4,a3
    4d8e:	0027179b          	slliw	a5,a4,0x2
    4d92:	9fb9                	addw	a5,a5,a4
    4d94:	0017979b          	slliw	a5,a5,0x1
    4d98:	40f487bb          	subw	a5,s1,a5
    4d9c:	0307879b          	addiw	a5,a5,48
    4da0:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4da4:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4da8:	85ea                	mv	a1,s10
    4daa:	00003517          	auipc	a0,0x3
    4dae:	24e50513          	addi	a0,a0,590 # 7ff8 <malloc+0x2400>
    4db2:	58b000ef          	jal	5b3c <printf>
    int fd = open(name, O_CREATE | O_RDWR);
    4db6:	20200593          	li	a1,514
    4dba:	856a                	mv	a0,s10
    4dbc:	15b000ef          	jal	5716 <open>
    4dc0:	892a                	mv	s2,a0
    if (fd < 0) {
    4dc2:	0e055c63          	bgez	a0,4eba <fsfull+0x1ee>
      printf("open %s failed\n", name);
    4dc6:	f5040593          	addi	a1,s0,-176
    4dca:	00003517          	auipc	a0,0x3
    4dce:	23e50513          	addi	a0,a0,574 # 8008 <malloc+0x2410>
    4dd2:	56b000ef          	jal	5b3c <printf>
  while (nfiles >= 0) {
    4dd6:	0a04cc63          	bltz	s1,4e8e <fsfull+0x1c2>
    name[0] = 'f';
    4dda:	06600c93          	li	s9,102
    name[1] = '0' + nfiles / 1000;
    4dde:	10625ab7          	lui	s5,0x10625
    4de2:	dd3a8a93          	addi	s5,s5,-557 # 10624dd3 <base+0x106140eb>
    name[2] = '0' + (nfiles % 1000) / 100;
    4de6:	3e800c13          	li	s8,1000
    4dea:	51eb8a37          	lui	s4,0x51eb8
    4dee:	51fa0a13          	addi	s4,s4,1311 # 51eb851f <base+0x51ea7837>
    name[3] = '0' + (nfiles % 100) / 10;
    4df2:	06400b93          	li	s7,100
    4df6:	66666937          	lui	s2,0x66666
    4dfa:	66790913          	addi	s2,s2,1639 # 66666667 <base+0x6665597f>
    unlink(name);
    4dfe:	f5040b13          	addi	s6,s0,-176
    name[0] = 'f';
    4e02:	f5940823          	sb	s9,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4e06:	035487b3          	mul	a5,s1,s5
    4e0a:	9799                	srai	a5,a5,0x26
    4e0c:	41f4d69b          	sraiw	a3,s1,0x1f
    4e10:	9f95                	subw	a5,a5,a3
    4e12:	0307871b          	addiw	a4,a5,48
    4e16:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4e1a:	02fc07bb          	mulw	a5,s8,a5
    4e1e:	40f487bb          	subw	a5,s1,a5
    4e22:	03478733          	mul	a4,a5,s4
    4e26:	9715                	srai	a4,a4,0x25
    4e28:	41f7d79b          	sraiw	a5,a5,0x1f
    4e2c:	40f707bb          	subw	a5,a4,a5
    4e30:	0307879b          	addiw	a5,a5,48
    4e34:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4e38:	034487b3          	mul	a5,s1,s4
    4e3c:	9795                	srai	a5,a5,0x25
    4e3e:	9f95                	subw	a5,a5,a3
    4e40:	02fb87bb          	mulw	a5,s7,a5
    4e44:	40f487bb          	subw	a5,s1,a5
    4e48:	03278733          	mul	a4,a5,s2
    4e4c:	9709                	srai	a4,a4,0x22
    4e4e:	41f7d79b          	sraiw	a5,a5,0x1f
    4e52:	40f707bb          	subw	a5,a4,a5
    4e56:	0307879b          	addiw	a5,a5,48
    4e5a:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4e5e:	03248733          	mul	a4,s1,s2
    4e62:	9709                	srai	a4,a4,0x22
    4e64:	9f15                	subw	a4,a4,a3
    4e66:	0027179b          	slliw	a5,a4,0x2
    4e6a:	9fb9                	addw	a5,a5,a4
    4e6c:	0017979b          	slliw	a5,a5,0x1
    4e70:	40f487bb          	subw	a5,s1,a5
    4e74:	0307879b          	addiw	a5,a5,48
    4e78:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4e7c:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4e80:	855a                	mv	a0,s6
    4e82:	0a5000ef          	jal	5726 <unlink>
    nfiles--;
    4e86:	34fd                	addiw	s1,s1,-1
  while (nfiles >= 0) {
    4e88:	57fd                	li	a5,-1
    4e8a:	f6f49ce3          	bne	s1,a5,4e02 <fsfull+0x136>
  printf("fsfull test finished, %d blocks\n", fsblocks);
    4e8e:	85ce                	mv	a1,s3
    4e90:	00003517          	auipc	a0,0x3
    4e94:	19850513          	addi	a0,a0,408 # 8028 <malloc+0x2430>
    4e98:	4a5000ef          	jal	5b3c <printf>
}
    4e9c:	70ea                	ld	ra,184(sp)
    4e9e:	744a                	ld	s0,176(sp)
    4ea0:	74aa                	ld	s1,168(sp)
    4ea2:	790a                	ld	s2,160(sp)
    4ea4:	69ea                	ld	s3,152(sp)
    4ea6:	6a4a                	ld	s4,144(sp)
    4ea8:	6aaa                	ld	s5,136(sp)
    4eaa:	6b0a                	ld	s6,128(sp)
    4eac:	7be6                	ld	s7,120(sp)
    4eae:	7c46                	ld	s8,112(sp)
    4eb0:	7ca6                	ld	s9,104(sp)
    4eb2:	7d06                	ld	s10,96(sp)
    4eb4:	6de6                	ld	s11,88(sp)
    4eb6:	6129                	addi	sp,sp,192
    4eb8:	8082                	ret
    int total = 0;
    4eba:	4a01                	li	s4,0
      int cc = write(fd, buf, BSIZE);
    4ebc:	40000c93          	li	s9,1024
    4ec0:	00009c17          	auipc	s8,0x9
    4ec4:	e28c0c13          	addi	s8,s8,-472 # dce8 <buf>
      if (cc < BSIZE)
    4ec8:	3ff00b93          	li	s7,1023
      int cc = write(fd, buf, BSIZE);
    4ecc:	8666                	mv	a2,s9
    4ece:	85e2                	mv	a1,s8
    4ed0:	854a                	mv	a0,s2
    4ed2:	025000ef          	jal	56f6 <write>
      if (cc < BSIZE)
    4ed6:	00abd663          	bge	s7,a0,4ee2 <fsfull+0x216>
      total += cc;
    4eda:	00aa0a3b          	addw	s4,s4,a0
      fsblocks++;
    4ede:	2985                	addiw	s3,s3,1 # 40000001 <base+0x3ffef319>
    while (1) {
    4ee0:	b7f5                	j	4ecc <fsfull+0x200>
    printf("wrote %d bytes\n", total);
    4ee2:	85d2                	mv	a1,s4
    4ee4:	00003517          	auipc	a0,0x3
    4ee8:	13450513          	addi	a0,a0,308 # 8018 <malloc+0x2420>
    4eec:	451000ef          	jal	5b3c <printf>
    close(fd);
    4ef0:	854a                	mv	a0,s2
    4ef2:	00d000ef          	jal	56fe <close>
    if (total == 0)
    4ef6:	ee0a00e3          	beqz	s4,4dd6 <fsfull+0x10a>
  for (nfiles = 0;; nfiles++) {
    4efa:	2485                	addiw	s1,s1,1
    4efc:	b50d                	j	4d1e <fsfull+0x52>

0000000000004efe <linkoverflow>:

void
linkoverflow(char *s)
{
    4efe:	7175                	addi	sp,sp,-144
    4f00:	e506                	sd	ra,136(sp)
    4f02:	e122                	sd	s0,128(sp)
    4f04:	fca6                	sd	s1,120(sp)
    4f06:	f8ca                	sd	s2,112(sp)
    4f08:	f4ce                	sd	s3,104(sp)
    4f0a:	f0d2                	sd	s4,96(sp)
    4f0c:	ecd6                	sd	s5,88(sp)
    4f0e:	e8da                	sd	s6,80(sp)
    4f10:	e4de                	sd	s7,72(sp)
    4f12:	e0e2                	sd	s8,64(sp)
    4f14:	fc66                	sd	s9,56(sp)
    4f16:	f86a                	sd	s10,48(sp)
    4f18:	0900                	addi	s0,sp,144
    4f1a:	8d2a                	mv	s10,a0
  enum { TARGET = 32768 };
  enum { DIRS = 64 };
  struct stat st;
  int i;

  unlink("/lof");
    4f1c:	00003517          	auipc	a0,0x3
    4f20:	13450513          	addi	a0,a0,308 # 8050 <malloc+0x2458>
    4f24:	003000ef          	jal	5726 <unlink>
  int fd = open("/lof", O_CREATE | O_RDWR);
    4f28:	20200593          	li	a1,514
    4f2c:	00003517          	auipc	a0,0x3
    4f30:	12450513          	addi	a0,a0,292 # 8050 <malloc+0x2458>
    4f34:	7e2000ef          	jal	5716 <open>
  if (fd < 0) {
    4f38:	02054863          	bltz	a0,4f68 <linkoverflow+0x6a>
    printf("%s: cannot create /lof\n", s);
    exit(1);
  }
  close(fd);
    4f3c:	7c2000ef          	jal	56fe <close>

  for (i = 0; i < TARGET; i++) {
    4f40:	4901                	li	s2,0
    int d = i % DIRS;
    int f = i / DIRS;

    char pn[16];
    pn[0] = '/';
    4f42:	02f00993          	li	s3,47
    pn[1] = 'd';
    4f46:	06400b93          	li	s7,100
    pn[2] = '_';
    4f4a:	05f00b13          	li	s6,95
    pn[3] = 'a' + (d / 16);
    pn[4] = 'a' + (d % 16);
    pn[5] = '\0';
    if (f == 0 && mkdir(pn) < 0) {
    4f4e:	f7840a13          	addi	s4,s0,-136
      printf("%s: mkdir(%s) failed\n", s, pn);
      exit(1);
    }

    pn[5] = '/';
    pn[6] = 'l';
    4f52:	06c00c93          	li	s9,108
    pn[7] = 'a' + (f / 256);
    pn[8] = 'a' + ((f / 16) % 16);
    pn[9] = 'a' + (f % 16);
    pn[10] = '\0';

    if (link("/lof", pn) < 0) {
    4f56:	00003c17          	auipc	s8,0x3
    4f5a:	0fac0c13          	addi	s8,s8,250 # 8050 <malloc+0x2458>
      }
      printf("%s: link failed after %d links (nlink=%d)\n", s, i, st.nlink);
      exit(1);
    }

    if (i % 100 == 0) {
    4f5e:	51eb8ab7          	lui	s5,0x51eb8
    4f62:	51fa8a93          	addi	s5,s5,1311 # 51eb851f <base+0x51ea7837>
    4f66:	a869                	j	5000 <linkoverflow+0x102>
    printf("%s: cannot create /lof\n", s);
    4f68:	85ea                	mv	a1,s10
    4f6a:	00003517          	auipc	a0,0x3
    4f6e:	0ee50513          	addi	a0,a0,238 # 8058 <malloc+0x2460>
    4f72:	3cb000ef          	jal	5b3c <printf>
    exit(1);
    4f76:	4505                	li	a0,1
    4f78:	75e000ef          	jal	56d6 <exit>
    pn[5] = '/';
    4f7c:	f7340ea3          	sb	s3,-131(s0)
    pn[6] = 'l';
    4f80:	f7940f23          	sb	s9,-130(s0)
    pn[7] = 'a' + (f / 256);
    4f84:	41f9579b          	sraiw	a5,s2,0x1f
    4f88:	0127d79b          	srliw	a5,a5,0x12
    4f8c:	012787bb          	addw	a5,a5,s2
    4f90:	40e7d79b          	sraiw	a5,a5,0xe
    4f94:	0617879b          	addiw	a5,a5,97
    4f98:	f6f40fa3          	sb	a5,-129(s0)
    pn[8] = 'a' + ((f / 16) % 16);
    4f9c:	41f4d71b          	sraiw	a4,s1,0x1f
    4fa0:	01c7571b          	srliw	a4,a4,0x1c
    4fa4:	9cb9                	addw	s1,s1,a4
    4fa6:	4044d79b          	sraiw	a5,s1,0x4
    4faa:	41f7d69b          	sraiw	a3,a5,0x1f
    4fae:	01c6d69b          	srliw	a3,a3,0x1c
    4fb2:	9fb5                	addw	a5,a5,a3
    4fb4:	8bbd                	andi	a5,a5,15
    4fb6:	9f95                	subw	a5,a5,a3
    4fb8:	0617879b          	addiw	a5,a5,97
    4fbc:	f8f40023          	sb	a5,-128(s0)
    pn[9] = 'a' + (f % 16);
    4fc0:	88bd                	andi	s1,s1,15
    4fc2:	9c99                	subw	s1,s1,a4
    4fc4:	0614849b          	addiw	s1,s1,97
    4fc8:	f89400a3          	sb	s1,-127(s0)
    pn[10] = '\0';
    4fcc:	f8040123          	sb	zero,-126(s0)
    if (link("/lof", pn) < 0) {
    4fd0:	85d2                	mv	a1,s4
    4fd2:	8562                	mv	a0,s8
    4fd4:	762000ef          	jal	5736 <link>
    4fd8:	08054a63          	bltz	a0,506c <linkoverflow+0x16e>
    if (i % 100 == 0) {
    4fdc:	03590733          	mul	a4,s2,s5
    4fe0:	9715                	srai	a4,a4,0x25
    4fe2:	41f9579b          	sraiw	a5,s2,0x1f
    4fe6:	9f1d                	subw	a4,a4,a5
    4fe8:	06400793          	li	a5,100
    4fec:	02e787bb          	mulw	a5,a5,a4
    4ff0:	40f907bb          	subw	a5,s2,a5
    4ff4:	10078363          	beqz	a5,50fa <linkoverflow+0x1fc>
  for (i = 0; i < TARGET; i++) {
    4ff8:	2905                	addiw	s2,s2,1
    4ffa:	67a1                	lui	a5,0x8
    4ffc:	08f90863          	beq	s2,a5,508c <linkoverflow+0x18e>
    int d = i % DIRS;
    5000:	41f9571b          	sraiw	a4,s2,0x1f
    5004:	01a7571b          	srliw	a4,a4,0x1a
    5008:	012704bb          	addw	s1,a4,s2
    500c:	03f4f793          	andi	a5,s1,63
    5010:	9f99                	subw	a5,a5,a4
    int f = i / DIRS;
    5012:	4064d49b          	sraiw	s1,s1,0x6
    pn[0] = '/';
    5016:	f7340c23          	sb	s3,-136(s0)
    pn[1] = 'd';
    501a:	f7740ca3          	sb	s7,-135(s0)
    pn[2] = '_';
    501e:	f7640d23          	sb	s6,-134(s0)
    pn[3] = 'a' + (d / 16);
    5022:	41f7d71b          	sraiw	a4,a5,0x1f
    5026:	01c7571b          	srliw	a4,a4,0x1c
    502a:	9fb9                	addw	a5,a5,a4
    502c:	4047d69b          	sraiw	a3,a5,0x4
    5030:	0616869b          	addiw	a3,a3,97 # 40061 <base+0x2f379>
    5034:	f6d40da3          	sb	a3,-133(s0)
    pn[4] = 'a' + (d % 16);
    5038:	8bbd                	andi	a5,a5,15
    503a:	9f99                	subw	a5,a5,a4
    503c:	0617879b          	addiw	a5,a5,97 # 8061 <malloc+0x2469>
    5040:	f6f40e23          	sb	a5,-132(s0)
    pn[5] = '\0';
    5044:	f6040ea3          	sb	zero,-131(s0)
    if (f == 0 && mkdir(pn) < 0) {
    5048:	f895                	bnez	s1,4f7c <linkoverflow+0x7e>
    504a:	8552                	mv	a0,s4
    504c:	6f2000ef          	jal	573e <mkdir>
    5050:	f20556e3          	bgez	a0,4f7c <linkoverflow+0x7e>
      printf("%s: mkdir(%s) failed\n", s, pn);
    5054:	f7840613          	addi	a2,s0,-136
    5058:	85ea                	mv	a1,s10
    505a:	00003517          	auipc	a0,0x3
    505e:	01650513          	addi	a0,a0,22 # 8070 <malloc+0x2478>
    5062:	2db000ef          	jal	5b3c <printf>
      exit(1);
    5066:	4505                	li	a0,1
    5068:	66e000ef          	jal	56d6 <exit>
      if (stat("/lof", &st) < 0) {
    506c:	f8840593          	addi	a1,s0,-120
    5070:	00003517          	auipc	a0,0x3
    5074:	fe050513          	addi	a0,a0,-32 # 8050 <malloc+0x2458>
    5078:	4fc000ef          	jal	5574 <stat>
    507c:	04054a63          	bltz	a0,50d0 <linkoverflow+0x1d2>
      if (st.nlink >= 32767) {
    5080:	f9241683          	lh	a3,-110(s0)
    5084:	67a1                	lui	a5,0x8
    5086:	17fd                	addi	a5,a5,-1 # 7fff <malloc+0x2407>
    5088:	04f69e63          	bne	a3,a5,50e4 <linkoverflow+0x1e6>
      printf("%s: i=%d, pn=%s\n", s, i, pn);
    }
  }

  if (stat("/lof", &st) < 0) {
    508c:	f8840593          	addi	a1,s0,-120
    5090:	00003517          	auipc	a0,0x3
    5094:	fc050513          	addi	a0,a0,-64 # 8050 <malloc+0x2458>
    5098:	4dc000ef          	jal	5574 <stat>
    509c:	06054963          	bltz	a0,510e <linkoverflow+0x210>
    printf("%s: stat(/lof) failed\n", s);
    exit(1);
  }

  unlink("/lof");
    50a0:	00003517          	auipc	a0,0x3
    50a4:	fb050513          	addi	a0,a0,-80 # 8050 <malloc+0x2458>
    50a8:	67e000ef          	jal	5726 <unlink>

  if (st.nlink < 0) {
    50ac:	f9241603          	lh	a2,-110(s0)
    50b0:	06064963          	bltz	a2,5122 <linkoverflow+0x224>
    printf("%s: negative link count: %d\n", s, st.nlink);
    exit(1);
  }
}
    50b4:	60aa                	ld	ra,136(sp)
    50b6:	640a                	ld	s0,128(sp)
    50b8:	74e6                	ld	s1,120(sp)
    50ba:	7946                	ld	s2,112(sp)
    50bc:	79a6                	ld	s3,104(sp)
    50be:	7a06                	ld	s4,96(sp)
    50c0:	6ae6                	ld	s5,88(sp)
    50c2:	6b46                	ld	s6,80(sp)
    50c4:	6ba6                	ld	s7,72(sp)
    50c6:	6c06                	ld	s8,64(sp)
    50c8:	7ce2                	ld	s9,56(sp)
    50ca:	7d42                	ld	s10,48(sp)
    50cc:	6149                	addi	sp,sp,144
    50ce:	8082                	ret
        printf("%s: stat(/lof) failed\n", s);
    50d0:	85ea                	mv	a1,s10
    50d2:	00003517          	auipc	a0,0x3
    50d6:	fb650513          	addi	a0,a0,-74 # 8088 <malloc+0x2490>
    50da:	263000ef          	jal	5b3c <printf>
        exit(1);
    50de:	4505                	li	a0,1
    50e0:	5f6000ef          	jal	56d6 <exit>
      printf("%s: link failed after %d links (nlink=%d)\n", s, i, st.nlink);
    50e4:	864a                	mv	a2,s2
    50e6:	85ea                	mv	a1,s10
    50e8:	00003517          	auipc	a0,0x3
    50ec:	fb850513          	addi	a0,a0,-72 # 80a0 <malloc+0x24a8>
    50f0:	24d000ef          	jal	5b3c <printf>
      exit(1);
    50f4:	4505                	li	a0,1
    50f6:	5e0000ef          	jal	56d6 <exit>
      printf("%s: i=%d, pn=%s\n", s, i, pn);
    50fa:	86d2                	mv	a3,s4
    50fc:	864a                	mv	a2,s2
    50fe:	85ea                	mv	a1,s10
    5100:	00003517          	auipc	a0,0x3
    5104:	fd050513          	addi	a0,a0,-48 # 80d0 <malloc+0x24d8>
    5108:	235000ef          	jal	5b3c <printf>
    510c:	b5f5                	j	4ff8 <linkoverflow+0xfa>
    printf("%s: stat(/lof) failed\n", s);
    510e:	85ea                	mv	a1,s10
    5110:	00003517          	auipc	a0,0x3
    5114:	f7850513          	addi	a0,a0,-136 # 8088 <malloc+0x2490>
    5118:	225000ef          	jal	5b3c <printf>
    exit(1);
    511c:	4505                	li	a0,1
    511e:	5b8000ef          	jal	56d6 <exit>
    printf("%s: negative link count: %d\n", s, st.nlink);
    5122:	85ea                	mv	a1,s10
    5124:	00003517          	auipc	a0,0x3
    5128:	fc450513          	addi	a0,a0,-60 # 80e8 <malloc+0x24f0>
    512c:	211000ef          	jal	5b3c <printf>
    exit(1);
    5130:	4505                	li	a0,1
    5132:	5a4000ef          	jal	56d6 <exit>

0000000000005136 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s)
{
    5136:	7179                	addi	sp,sp,-48
    5138:	f406                	sd	ra,40(sp)
    513a:	f022                	sd	s0,32(sp)
    513c:	ec26                	sd	s1,24(sp)
    513e:	e84a                	sd	s2,16(sp)
    5140:	1800                	addi	s0,sp,48
    5142:	84aa                	mv	s1,a0
    5144:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5146:	00003517          	auipc	a0,0x3
    514a:	fc250513          	addi	a0,a0,-62 # 8108 <malloc+0x2510>
    514e:	1ef000ef          	jal	5b3c <printf>
  if ((pid = fork()) < 0) {
    5152:	57c000ef          	jal	56ce <fork>
    5156:	02054a63          	bltz	a0,518a <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if (pid == 0) {
    515a:	c129                	beqz	a0,519c <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    515c:	fdc40513          	addi	a0,s0,-36
    5160:	57e000ef          	jal	56de <wait>
    if (xstatus != 0)
    5164:	fdc42783          	lw	a5,-36(s0)
    5168:	cf9d                	beqz	a5,51a6 <run+0x70>
      printf("FAILED\n");
    516a:	00003517          	auipc	a0,0x3
    516e:	fc650513          	addi	a0,a0,-58 # 8130 <malloc+0x2538>
    5172:	1cb000ef          	jal	5b3c <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    5176:	fdc42503          	lw	a0,-36(s0)
  }
}
    517a:	00153513          	seqz	a0,a0
    517e:	70a2                	ld	ra,40(sp)
    5180:	7402                	ld	s0,32(sp)
    5182:	64e2                	ld	s1,24(sp)
    5184:	6942                	ld	s2,16(sp)
    5186:	6145                	addi	sp,sp,48
    5188:	8082                	ret
    printf("runtest: fork error\n");
    518a:	00003517          	auipc	a0,0x3
    518e:	f8e50513          	addi	a0,a0,-114 # 8118 <malloc+0x2520>
    5192:	1ab000ef          	jal	5b3c <printf>
    exit(1);
    5196:	4505                	li	a0,1
    5198:	53e000ef          	jal	56d6 <exit>
    f(s);
    519c:	854a                	mv	a0,s2
    519e:	9482                	jalr	s1
    exit(0);
    51a0:	4501                	li	a0,0
    51a2:	534000ef          	jal	56d6 <exit>
      printf("OK\n");
    51a6:	00003517          	auipc	a0,0x3
    51aa:	f9250513          	addi	a0,a0,-110 # 8138 <malloc+0x2540>
    51ae:	18f000ef          	jal	5b3c <printf>
    51b2:	b7d1                	j	5176 <run+0x40>

00000000000051b4 <runtests>:

int
runtests(struct test *tests, char *justone, int continuous)
{
    51b4:	7179                	addi	sp,sp,-48
    51b6:	f406                	sd	ra,40(sp)
    51b8:	f022                	sd	s0,32(sp)
    51ba:	ec26                	sd	s1,24(sp)
    51bc:	e44e                	sd	s3,8(sp)
    51be:	1800                	addi	s0,sp,48
    51c0:	84aa                	mv	s1,a0
  int ntests = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    51c2:	6508                	ld	a0,8(a0)
    51c4:	c125                	beqz	a0,5224 <runtests+0x70>
    51c6:	e84a                	sd	s2,16(sp)
    51c8:	e052                	sd	s4,0(sp)
    51ca:	892e                	mv	s2,a1
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
      ntests++;
      if (!run(t->f, t->s)) {
        if (continuous != 2) {
    51cc:	1679                	addi	a2,a2,-2 # ffe <bigdir+0x10a>
    51ce:	00c03a33          	snez	s4,a2
  int ntests = 0;
    51d2:	4981                	li	s3,0
    51d4:	a831                	j	51f0 <runtests+0x3c>
      if (!run(t->f, t->s)) {
    51d6:	648c                	ld	a1,8(s1)
    51d8:	6088                	ld	a0,0(s1)
    51da:	f5dff0ef          	jal	5136 <run>
    51de:	00153513          	seqz	a0,a0
        if (continuous != 2) {
    51e2:	00aa7533          	and	a0,s4,a0
    51e6:	ed01                	bnez	a0,51fe <runtests+0x4a>
      ntests++;
    51e8:	2985                	addiw	s3,s3,1
  for (struct test *t = tests; t->s != 0; t++) {
    51ea:	04c1                	addi	s1,s1,16
    51ec:	6488                	ld	a0,8(s1)
    51ee:	c115                	beqz	a0,5212 <runtests+0x5e>
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
    51f0:	fe0903e3          	beqz	s2,51d6 <runtests+0x22>
    51f4:	85ca                	mv	a1,s2
    51f6:	25a000ef          	jal	5450 <strcmp>
    51fa:	f965                	bnez	a0,51ea <runtests+0x36>
    51fc:	bfe9                	j	51d6 <runtests+0x22>
          printf("SOME TESTS FAILED\n");
    51fe:	00003517          	auipc	a0,0x3
    5202:	f4250513          	addi	a0,a0,-190 # 8140 <malloc+0x2548>
    5206:	137000ef          	jal	5b3c <printf>
          return -1;
    520a:	59fd                	li	s3,-1
    520c:	6942                	ld	s2,16(sp)
    520e:	6a02                	ld	s4,0(sp)
    5210:	a019                	j	5216 <runtests+0x62>
    5212:	6942                	ld	s2,16(sp)
    5214:	6a02                	ld	s4,0(sp)
        }
      }
    }
  }
  return ntests;
}
    5216:	854e                	mv	a0,s3
    5218:	70a2                	ld	ra,40(sp)
    521a:	7402                	ld	s0,32(sp)
    521c:	64e2                	ld	s1,24(sp)
    521e:	69a2                	ld	s3,8(sp)
    5220:	6145                	addi	sp,sp,48
    5222:	8082                	ret
  return ntests;
    5224:	4981                	li	s3,0
    5226:	bfc5                	j	5216 <runtests+0x62>

0000000000005228 <countfree>:

// use sbrk() to count how many free physical memory pages there are.
int
countfree()
{
    5228:	7179                	addi	sp,sp,-48
    522a:	f406                	sd	ra,40(sp)
    522c:	f022                	sd	s0,32(sp)
    522e:	ec26                	sd	s1,24(sp)
    5230:	e84a                	sd	s2,16(sp)
    5232:	e44e                	sd	s3,8(sp)
    5234:	e052                	sd	s4,0(sp)
    5236:	1800                	addi	s0,sp,48
  int n = 0;
  uint64 sz0 = (uint64)sbrk(0);
    5238:	4501                	li	a0,0
    523a:	468000ef          	jal	56a2 <sbrk>
    523e:	8a2a                	mv	s4,a0
  int n = 0;
    5240:	4481                	li	s1,0
  while (1) {
    char *a = sbrk(PGSIZE);
    5242:	6985                	lui	s3,0x1
    if (a == SBRK_ERROR) {
    5244:	597d                	li	s2,-1
    char *a = sbrk(PGSIZE);
    5246:	854e                	mv	a0,s3
    5248:	45a000ef          	jal	56a2 <sbrk>
    if (a == SBRK_ERROR) {
    524c:	01250463          	beq	a0,s2,5254 <countfree+0x2c>
      break;
    }
    n += 1;
    5250:	2485                	addiw	s1,s1,1
  while (1) {
    5252:	bfd5                	j	5246 <countfree+0x1e>
  }
  sbrk(-((uint64)sbrk(0) - sz0));
    5254:	4501                	li	a0,0
    5256:	44c000ef          	jal	56a2 <sbrk>
    525a:	40aa053b          	subw	a0,s4,a0
    525e:	444000ef          	jal	56a2 <sbrk>
  return n;
}
    5262:	8526                	mv	a0,s1
    5264:	70a2                	ld	ra,40(sp)
    5266:	7402                	ld	s0,32(sp)
    5268:	64e2                	ld	s1,24(sp)
    526a:	6942                	ld	s2,16(sp)
    526c:	69a2                	ld	s3,8(sp)
    526e:	6a02                	ld	s4,0(sp)
    5270:	6145                	addi	sp,sp,48
    5272:	8082                	ret

0000000000005274 <drivetests>:

int
drivetests(int quick, int continuous, char *justone)
{
    5274:	7159                	addi	sp,sp,-112
    5276:	f486                	sd	ra,104(sp)
    5278:	f0a2                	sd	s0,96(sp)
    527a:	eca6                	sd	s1,88(sp)
    527c:	e8ca                	sd	s2,80(sp)
    527e:	e4ce                	sd	s3,72(sp)
    5280:	e0d2                	sd	s4,64(sp)
    5282:	fc56                	sd	s5,56(sp)
    5284:	f85a                	sd	s6,48(sp)
    5286:	f45e                	sd	s7,40(sp)
    5288:	f062                	sd	s8,32(sp)
    528a:	ec66                	sd	s9,24(sp)
    528c:	e86a                	sd	s10,16(sp)
    528e:	e46e                	sd	s11,8(sp)
    5290:	1880                	addi	s0,sp,112
    5292:	8aaa                	mv	s5,a0
    5294:	89ae                	mv	s3,a1
    5296:	8a32                	mv	s4,a2
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
      if (continuous != 2) {
        return 1;
      }
    }
    if (justone != 0 && ntests == 0) {
    5298:	00c03cb3          	snez	s9,a2
    printf("usertests starting\n");
    529c:	00003c17          	auipc	s8,0x3
    52a0:	ebcc0c13          	addi	s8,s8,-324 # 8158 <malloc+0x2560>
    n = runtests(quicktests, justone, continuous);
    52a4:	00005b97          	auipc	s7,0x5
    52a8:	d6cb8b93          	addi	s7,s7,-660 # a010 <quicktests>
      if (continuous != 2) {
    52ac:	4b09                	li	s6,2
      n = runtests(slowtests, justone, continuous);
    52ae:	00005d17          	auipc	s10,0x5
    52b2:	1a2d0d13          	addi	s10,s10,418 # a450 <slowtests>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    52b6:	00003d97          	auipc	s11,0x3
    52ba:	edad8d93          	addi	s11,s11,-294 # 8190 <malloc+0x2598>
    52be:	a80d                	j	52f0 <drivetests+0x7c>
      if (continuous != 2) {
    52c0:	09699563          	bne	s3,s6,534a <drivetests+0xd6>
    int ntests = 0;
    52c4:	4481                	li	s1,0
    52c6:	a099                	j	530c <drivetests+0x98>
        printf("usertests slow tests starting\n");
    52c8:	00003517          	auipc	a0,0x3
    52cc:	ea850513          	addi	a0,a0,-344 # 8170 <malloc+0x2578>
    52d0:	06d000ef          	jal	5b3c <printf>
    52d4:	a081                	j	5314 <drivetests+0xa0>
        if (continuous != 2) {
    52d6:	07699a63          	bne	s3,s6,534a <drivetests+0xd6>
    if ((free1 = countfree()) < free0) {
    52da:	f4fff0ef          	jal	5228 <countfree>
    52de:	05254463          	blt	a0,s2,5326 <drivetests+0xb2>
    if (justone != 0 && ntests == 0) {
    52e2:	0014b493          	seqz	s1,s1
    52e6:	009cf4b3          	and	s1,s9,s1
    52ea:	e8b1                	bnez	s1,533e <drivetests+0xca>
      printf("NO TESTS EXECUTED\n");
      return 1;
    }
  } while (continuous);
    52ec:	06098f63          	beqz	s3,536a <drivetests+0xf6>
    printf("usertests starting\n");
    52f0:	8562                	mv	a0,s8
    52f2:	04b000ef          	jal	5b3c <printf>
    int free0 = countfree();
    52f6:	f33ff0ef          	jal	5228 <countfree>
    52fa:	892a                	mv	s2,a0
    n = runtests(quicktests, justone, continuous);
    52fc:	864e                	mv	a2,s3
    52fe:	85d2                	mv	a1,s4
    5300:	855e                	mv	a0,s7
    5302:	eb3ff0ef          	jal	51b4 <runtests>
    5306:	84aa                	mv	s1,a0
    if (n < 0) {
    5308:	fa054ce3          	bltz	a0,52c0 <drivetests+0x4c>
    if (!quick) {
    530c:	fc0a97e3          	bnez	s5,52da <drivetests+0x66>
      if (justone == 0)
    5310:	fa0a0ce3          	beqz	s4,52c8 <drivetests+0x54>
      n = runtests(slowtests, justone, continuous);
    5314:	864e                	mv	a2,s3
    5316:	85d2                	mv	a1,s4
    5318:	856a                	mv	a0,s10
    531a:	e9bff0ef          	jal	51b4 <runtests>
      if (n < 0) {
    531e:	fa054ce3          	bltz	a0,52d6 <drivetests+0x62>
        ntests += n;
    5322:	9ca9                	addw	s1,s1,a0
    5324:	bf5d                	j	52da <drivetests+0x66>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5326:	864a                	mv	a2,s2
    5328:	85aa                	mv	a1,a0
    532a:	856e                	mv	a0,s11
    532c:	011000ef          	jal	5b3c <printf>
      if (continuous != 2) {
    5330:	01699d63          	bne	s3,s6,534a <drivetests+0xd6>
    if (justone != 0 && ntests == 0) {
    5334:	0014b493          	seqz	s1,s1
    5338:	009cf4b3          	and	s1,s9,s1
    533c:	d8d5                	beqz	s1,52f0 <drivetests+0x7c>
      printf("NO TESTS EXECUTED\n");
    533e:	00003517          	auipc	a0,0x3
    5342:	e8250513          	addi	a0,a0,-382 # 81c0 <malloc+0x25c8>
    5346:	7f6000ef          	jal	5b3c <printf>
        return 1;
    534a:	4505                	li	a0,1
  return 0;
}
    534c:	70a6                	ld	ra,104(sp)
    534e:	7406                	ld	s0,96(sp)
    5350:	64e6                	ld	s1,88(sp)
    5352:	6946                	ld	s2,80(sp)
    5354:	69a6                	ld	s3,72(sp)
    5356:	6a06                	ld	s4,64(sp)
    5358:	7ae2                	ld	s5,56(sp)
    535a:	7b42                	ld	s6,48(sp)
    535c:	7ba2                	ld	s7,40(sp)
    535e:	7c02                	ld	s8,32(sp)
    5360:	6ce2                	ld	s9,24(sp)
    5362:	6d42                	ld	s10,16(sp)
    5364:	6da2                	ld	s11,8(sp)
    5366:	6165                	addi	sp,sp,112
    5368:	8082                	ret
  return 0;
    536a:	854e                	mv	a0,s3
    536c:	b7c5                	j	534c <drivetests+0xd8>

000000000000536e <main>:

int
main(int argc, char *argv[])
{
    536e:	1101                	addi	sp,sp,-32
    5370:	ec06                	sd	ra,24(sp)
    5372:	e822                	sd	s0,16(sp)
    5374:	e426                	sd	s1,8(sp)
    5376:	e04a                	sd	s2,0(sp)
    5378:	1000                	addi	s0,sp,32
    537a:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    537c:	4789                	li	a5,2
    537e:	00f50e63          	beq	a0,a5,539a <main+0x2c>
    continuous = 1;
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    continuous = 2;
  } else if (argc == 2 && argv[1][0] != '-') {
    justone = argv[1];
  } else if (argc > 1) {
    5382:	4785                	li	a5,1
    5384:	06a7c663          	blt	a5,a0,53f0 <main+0x82>
  char *justone = 0;
    5388:	4601                	li	a2,0
  int quick = 0;
    538a:	4501                	li	a0,0
  int continuous = 0;
    538c:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    538e:	ee7ff0ef          	jal	5274 <drivetests>
    5392:	cd35                	beqz	a0,540e <main+0xa0>
    exit(1);
    5394:	4505                	li	a0,1
    5396:	340000ef          	jal	56d6 <exit>
    539a:	892e                	mv	s2,a1
  if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    539c:	00003597          	auipc	a1,0x3
    53a0:	e3c58593          	addi	a1,a1,-452 # 81d8 <malloc+0x25e0>
    53a4:	00893503          	ld	a0,8(s2)
    53a8:	0a8000ef          	jal	5450 <strcmp>
    53ac:	85aa                	mv	a1,a0
    53ae:	e501                	bnez	a0,53b6 <main+0x48>
  char *justone = 0;
    53b0:	4601                	li	a2,0
    quick = 1;
    53b2:	4505                	li	a0,1
    53b4:	bfe9                	j	538e <main+0x20>
  } else if (argc == 2 && strcmp(argv[1], "-c") == 0) {
    53b6:	00003597          	auipc	a1,0x3
    53ba:	e2a58593          	addi	a1,a1,-470 # 81e0 <malloc+0x25e8>
    53be:	00893503          	ld	a0,8(s2)
    53c2:	08e000ef          	jal	5450 <strcmp>
    53c6:	cd15                	beqz	a0,5402 <main+0x94>
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    53c8:	00003597          	auipc	a1,0x3
    53cc:	e6858593          	addi	a1,a1,-408 # 8230 <malloc+0x2638>
    53d0:	00893503          	ld	a0,8(s2)
    53d4:	07c000ef          	jal	5450 <strcmp>
    53d8:	c905                	beqz	a0,5408 <main+0x9a>
  } else if (argc == 2 && argv[1][0] != '-') {
    53da:	00893603          	ld	a2,8(s2)
    53de:	00064703          	lbu	a4,0(a2)
    53e2:	02d00793          	li	a5,45
    53e6:	00f70563          	beq	a4,a5,53f0 <main+0x82>
  int quick = 0;
    53ea:	4501                	li	a0,0
  int continuous = 0;
    53ec:	4581                	li	a1,0
    53ee:	b745                	j	538e <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    53f0:	00003517          	auipc	a0,0x3
    53f4:	df850513          	addi	a0,a0,-520 # 81e8 <malloc+0x25f0>
    53f8:	744000ef          	jal	5b3c <printf>
    exit(1);
    53fc:	4505                	li	a0,1
    53fe:	2d8000ef          	jal	56d6 <exit>
  char *justone = 0;
    5402:	4601                	li	a2,0
    continuous = 1;
    5404:	4585                	li	a1,1
    5406:	b761                	j	538e <main+0x20>
    continuous = 2;
    5408:	85a6                	mv	a1,s1
  char *justone = 0;
    540a:	4601                	li	a2,0
    540c:	b749                	j	538e <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    540e:	00003517          	auipc	a0,0x3
    5412:	e0a50513          	addi	a0,a0,-502 # 8218 <malloc+0x2620>
    5416:	726000ef          	jal	5b3c <printf>
  exit(0);
    541a:	4501                	li	a0,0
    541c:	2ba000ef          	jal	56d6 <exit>

0000000000005420 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
    5420:	1141                	addi	sp,sp,-16
    5422:	e406                	sd	ra,8(sp)
    5424:	e022                	sd	s0,0(sp)
    5426:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
    5428:	f47ff0ef          	jal	536e <main>
  exit(r);
    542c:	2aa000ef          	jal	56d6 <exit>

0000000000005430 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
    5430:	1141                	addi	sp,sp,-16
    5432:	e406                	sd	ra,8(sp)
    5434:	e022                	sd	s0,0(sp)
    5436:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
    5438:	87aa                	mv	a5,a0
    543a:	0585                	addi	a1,a1,1
    543c:	0785                	addi	a5,a5,1
    543e:	fff5c703          	lbu	a4,-1(a1)
    5442:	fee78fa3          	sb	a4,-1(a5)
    5446:	fb75                	bnez	a4,543a <strcpy+0xa>
    ;
  return os;
}
    5448:	60a2                	ld	ra,8(sp)
    544a:	6402                	ld	s0,0(sp)
    544c:	0141                	addi	sp,sp,16
    544e:	8082                	ret

0000000000005450 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5450:	1141                	addi	sp,sp,-16
    5452:	e406                	sd	ra,8(sp)
    5454:	e022                	sd	s0,0(sp)
    5456:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
    5458:	00054783          	lbu	a5,0(a0)
    545c:	cb91                	beqz	a5,5470 <strcmp+0x20>
    545e:	0005c703          	lbu	a4,0(a1)
    5462:	00f71763          	bne	a4,a5,5470 <strcmp+0x20>
    p++, q++;
    5466:	0505                	addi	a0,a0,1
    5468:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
    546a:	00054783          	lbu	a5,0(a0)
    546e:	fbe5                	bnez	a5,545e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
    5470:	0005c503          	lbu	a0,0(a1)
}
    5474:	40a7853b          	subw	a0,a5,a0
    5478:	60a2                	ld	ra,8(sp)
    547a:	6402                	ld	s0,0(sp)
    547c:	0141                	addi	sp,sp,16
    547e:	8082                	ret

0000000000005480 <strlen>:

uint
strlen(const char *s)
{
    5480:	1141                	addi	sp,sp,-16
    5482:	e406                	sd	ra,8(sp)
    5484:	e022                	sd	s0,0(sp)
    5486:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    5488:	00054783          	lbu	a5,0(a0)
    548c:	cf91                	beqz	a5,54a8 <strlen+0x28>
    548e:	00150793          	addi	a5,a0,1
    5492:	86be                	mv	a3,a5
    5494:	0785                	addi	a5,a5,1
    5496:	fff7c703          	lbu	a4,-1(a5)
    549a:	ff65                	bnez	a4,5492 <strlen+0x12>
    549c:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    54a0:	60a2                	ld	ra,8(sp)
    54a2:	6402                	ld	s0,0(sp)
    54a4:	0141                	addi	sp,sp,16
    54a6:	8082                	ret
  for (n = 0; s[n]; n++)
    54a8:	4501                	li	a0,0
    54aa:	bfdd                	j	54a0 <strlen+0x20>

00000000000054ac <memset>:

void *
memset(void *dst, int c, uint n)
{
    54ac:	1141                	addi	sp,sp,-16
    54ae:	e406                	sd	ra,8(sp)
    54b0:	e022                	sd	s0,0(sp)
    54b2:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    54b4:	ca19                	beqz	a2,54ca <memset+0x1e>
    54b6:	87aa                	mv	a5,a0
    54b8:	1602                	slli	a2,a2,0x20
    54ba:	9201                	srli	a2,a2,0x20
    54bc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    54c0:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    54c4:	0785                	addi	a5,a5,1
    54c6:	fee79de3          	bne	a5,a4,54c0 <memset+0x14>
  }
  return dst;
}
    54ca:	60a2                	ld	ra,8(sp)
    54cc:	6402                	ld	s0,0(sp)
    54ce:	0141                	addi	sp,sp,16
    54d0:	8082                	ret

00000000000054d2 <strchr>:

char *
strchr(const char *s, char c)
{
    54d2:	1141                	addi	sp,sp,-16
    54d4:	e406                	sd	ra,8(sp)
    54d6:	e022                	sd	s0,0(sp)
    54d8:	0800                	addi	s0,sp,16
  for (; *s; s++)
    54da:	00054783          	lbu	a5,0(a0)
    54de:	c799                	beqz	a5,54ec <strchr+0x1a>
    if (*s == c)
    54e0:	00f58763          	beq	a1,a5,54ee <strchr+0x1c>
  for (; *s; s++)
    54e4:	0505                	addi	a0,a0,1
    54e6:	00054783          	lbu	a5,0(a0)
    54ea:	fbfd                	bnez	a5,54e0 <strchr+0xe>
      return (char *)s;
  return 0;
    54ec:	4501                	li	a0,0
}
    54ee:	60a2                	ld	ra,8(sp)
    54f0:	6402                	ld	s0,0(sp)
    54f2:	0141                	addi	sp,sp,16
    54f4:	8082                	ret

00000000000054f6 <gets>:

char *
gets(char *buf, int max)
{
    54f6:	711d                	addi	sp,sp,-96
    54f8:	ec86                	sd	ra,88(sp)
    54fa:	e8a2                	sd	s0,80(sp)
    54fc:	e4a6                	sd	s1,72(sp)
    54fe:	e0ca                	sd	s2,64(sp)
    5500:	fc4e                	sd	s3,56(sp)
    5502:	f852                	sd	s4,48(sp)
    5504:	f456                	sd	s5,40(sp)
    5506:	f05a                	sd	s6,32(sp)
    5508:	ec5e                	sd	s7,24(sp)
    550a:	e862                	sd	s8,16(sp)
    550c:	1080                	addi	s0,sp,96
    550e:	8baa                	mv	s7,a0
    5510:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
    5512:	892a                	mv	s2,a0
    5514:	4481                	li	s1,0
    cc = read(0, &c, 1);
    5516:	faf40b13          	addi	s6,s0,-81
    551a:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
    551c:	8c26                	mv	s8,s1
    551e:	0014899b          	addiw	s3,s1,1
    5522:	84ce                	mv	s1,s3
    5524:	0349d863          	bge	s3,s4,5554 <gets+0x5e>
    cc = read(0, &c, 1);
    5528:	8656                	mv	a2,s5
    552a:	85da                	mv	a1,s6
    552c:	4501                	li	a0,0
    552e:	1c0000ef          	jal	56ee <read>
    if (cc < 1)
    5532:	02a05163          	blez	a0,5554 <gets+0x5e>
      break;
    buf[i++] = c;
    5536:	faf44783          	lbu	a5,-81(s0)
    553a:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
    553e:	0905                	addi	s2,s2,1
    5540:	ff678713          	addi	a4,a5,-10
    5544:	00173713          	seqz	a4,a4
    5548:	17cd                	addi	a5,a5,-13
    554a:	0017b793          	seqz	a5,a5
    554e:	8fd9                	or	a5,a5,a4
    5550:	d7f1                	beqz	a5,551c <gets+0x26>
    buf[i++] = c;
    5552:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
    5554:	9c5e                	add	s8,s8,s7
    5556:	000c0023          	sb	zero,0(s8)
  return buf;
}
    555a:	855e                	mv	a0,s7
    555c:	60e6                	ld	ra,88(sp)
    555e:	6446                	ld	s0,80(sp)
    5560:	64a6                	ld	s1,72(sp)
    5562:	6906                	ld	s2,64(sp)
    5564:	79e2                	ld	s3,56(sp)
    5566:	7a42                	ld	s4,48(sp)
    5568:	7aa2                	ld	s5,40(sp)
    556a:	7b02                	ld	s6,32(sp)
    556c:	6be2                	ld	s7,24(sp)
    556e:	6c42                	ld	s8,16(sp)
    5570:	6125                	addi	sp,sp,96
    5572:	8082                	ret

0000000000005574 <stat>:

int
stat(const char *n, struct stat *st)
{
    5574:	1101                	addi	sp,sp,-32
    5576:	ec06                	sd	ra,24(sp)
    5578:	e822                	sd	s0,16(sp)
    557a:	e04a                	sd	s2,0(sp)
    557c:	1000                	addi	s0,sp,32
    557e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5580:	4581                	li	a1,0
    5582:	194000ef          	jal	5716 <open>
  if (fd < 0)
    5586:	02054263          	bltz	a0,55aa <stat+0x36>
    558a:	e426                	sd	s1,8(sp)
    558c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    558e:	85ca                	mv	a1,s2
    5590:	19e000ef          	jal	572e <fstat>
    5594:	892a                	mv	s2,a0
  close(fd);
    5596:	8526                	mv	a0,s1
    5598:	166000ef          	jal	56fe <close>
  return r;
    559c:	64a2                	ld	s1,8(sp)
}
    559e:	854a                	mv	a0,s2
    55a0:	60e2                	ld	ra,24(sp)
    55a2:	6442                	ld	s0,16(sp)
    55a4:	6902                	ld	s2,0(sp)
    55a6:	6105                	addi	sp,sp,32
    55a8:	8082                	ret
    return -1;
    55aa:	57fd                	li	a5,-1
    55ac:	893e                	mv	s2,a5
    55ae:	bfc5                	j	559e <stat+0x2a>

00000000000055b0 <atoi>:

int
atoi(const char *s)
{
    55b0:	1141                	addi	sp,sp,-16
    55b2:	e406                	sd	ra,8(sp)
    55b4:	e022                	sd	s0,0(sp)
    55b6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
    55b8:	00054683          	lbu	a3,0(a0)
    55bc:	fd06879b          	addiw	a5,a3,-48
    55c0:	0ff7f793          	zext.b	a5,a5
    55c4:	4625                	li	a2,9
    55c6:	02f66963          	bltu	a2,a5,55f8 <atoi+0x48>
    55ca:	872a                	mv	a4,a0
  n = 0;
    55cc:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
    55ce:	0705                	addi	a4,a4,1 # 1000001 <base+0xfef319>
    55d0:	0025179b          	slliw	a5,a0,0x2
    55d4:	9fa9                	addw	a5,a5,a0
    55d6:	0017979b          	slliw	a5,a5,0x1
    55da:	9fb5                	addw	a5,a5,a3
    55dc:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
    55e0:	00074683          	lbu	a3,0(a4)
    55e4:	fd06879b          	addiw	a5,a3,-48
    55e8:	0ff7f793          	zext.b	a5,a5
    55ec:	fef671e3          	bgeu	a2,a5,55ce <atoi+0x1e>
  return n;
}
    55f0:	60a2                	ld	ra,8(sp)
    55f2:	6402                	ld	s0,0(sp)
    55f4:	0141                	addi	sp,sp,16
    55f6:	8082                	ret
  n = 0;
    55f8:	4501                	li	a0,0
    55fa:	bfdd                	j	55f0 <atoi+0x40>

00000000000055fc <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
    55fc:	1141                	addi	sp,sp,-16
    55fe:	e406                	sd	ra,8(sp)
    5600:	e022                	sd	s0,0(sp)
    5602:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5604:	02b57563          	bgeu	a0,a1,562e <memmove+0x32>
    while (n-- > 0)
    5608:	00c05f63          	blez	a2,5626 <memmove+0x2a>
    560c:	1602                	slli	a2,a2,0x20
    560e:	9201                	srli	a2,a2,0x20
    5610:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5614:	872a                	mv	a4,a0
      *dst++ = *src++;
    5616:	0585                	addi	a1,a1,1
    5618:	0705                	addi	a4,a4,1
    561a:	fff5c683          	lbu	a3,-1(a1)
    561e:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    5622:	fee79ae3          	bne	a5,a4,5616 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5626:	60a2                	ld	ra,8(sp)
    5628:	6402                	ld	s0,0(sp)
    562a:	0141                	addi	sp,sp,16
    562c:	8082                	ret
    while (n-- > 0)
    562e:	fec05ce3          	blez	a2,5626 <memmove+0x2a>
    dst += n;
    5632:	00c50733          	add	a4,a0,a2
    src += n;
    5636:	95b2                	add	a1,a1,a2
    5638:	fff6079b          	addiw	a5,a2,-1
    563c:	1782                	slli	a5,a5,0x20
    563e:	9381                	srli	a5,a5,0x20
    5640:	fff7c793          	not	a5,a5
    5644:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5646:	15fd                	addi	a1,a1,-1
    5648:	177d                	addi	a4,a4,-1
    564a:	0005c683          	lbu	a3,0(a1)
    564e:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
    5652:	fef71ae3          	bne	a4,a5,5646 <memmove+0x4a>
    5656:	bfc1                	j	5626 <memmove+0x2a>

0000000000005658 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5658:	1141                	addi	sp,sp,-16
    565a:	e406                	sd	ra,8(sp)
    565c:	e022                	sd	s0,0(sp)
    565e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5660:	ce19                	beqz	a2,567e <memcmp+0x26>
    5662:	1602                	slli	a2,a2,0x20
    5664:	9201                	srli	a2,a2,0x20
    5666:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
    566a:	00054783          	lbu	a5,0(a0)
    566e:	0005c703          	lbu	a4,0(a1)
    5672:	00e79b63          	bne	a5,a4,5688 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
    5676:	0505                	addi	a0,a0,1
    p2++;
    5678:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    567a:	fed518e3          	bne	a0,a3,566a <memcmp+0x12>
  }
  return 0;
    567e:	4501                	li	a0,0
}
    5680:	60a2                	ld	ra,8(sp)
    5682:	6402                	ld	s0,0(sp)
    5684:	0141                	addi	sp,sp,16
    5686:	8082                	ret
      return *p1 - *p2;
    5688:	40e7853b          	subw	a0,a5,a4
    568c:	bfd5                	j	5680 <memcmp+0x28>

000000000000568e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    568e:	1141                	addi	sp,sp,-16
    5690:	e406                	sd	ra,8(sp)
    5692:	e022                	sd	s0,0(sp)
    5694:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5696:	f67ff0ef          	jal	55fc <memmove>
}
    569a:	60a2                	ld	ra,8(sp)
    569c:	6402                	ld	s0,0(sp)
    569e:	0141                	addi	sp,sp,16
    56a0:	8082                	ret

00000000000056a2 <sbrk>:

char *
sbrk(int n)
{
    56a2:	1141                	addi	sp,sp,-16
    56a4:	e406                	sd	ra,8(sp)
    56a6:	e022                	sd	s0,0(sp)
    56a8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
    56aa:	4585                	li	a1,1
    56ac:	0b2000ef          	jal	575e <sys_sbrk>
}
    56b0:	60a2                	ld	ra,8(sp)
    56b2:	6402                	ld	s0,0(sp)
    56b4:	0141                	addi	sp,sp,16
    56b6:	8082                	ret

00000000000056b8 <sbrklazy>:

char *
sbrklazy(int n)
{
    56b8:	1141                	addi	sp,sp,-16
    56ba:	e406                	sd	ra,8(sp)
    56bc:	e022                	sd	s0,0(sp)
    56be:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
    56c0:	4589                	li	a1,2
    56c2:	09c000ef          	jal	575e <sys_sbrk>
}
    56c6:	60a2                	ld	ra,8(sp)
    56c8:	6402                	ld	s0,0(sp)
    56ca:	0141                	addi	sp,sp,16
    56cc:	8082                	ret

00000000000056ce <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    56ce:	4885                	li	a7,1
 ecall
    56d0:	00000073          	ecall
 ret
    56d4:	8082                	ret

00000000000056d6 <exit>:
.global exit
exit:
 li a7, SYS_exit
    56d6:	4889                	li	a7,2
 ecall
    56d8:	00000073          	ecall
 ret
    56dc:	8082                	ret

00000000000056de <wait>:
.global wait
wait:
 li a7, SYS_wait
    56de:	488d                	li	a7,3
 ecall
    56e0:	00000073          	ecall
 ret
    56e4:	8082                	ret

00000000000056e6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    56e6:	4891                	li	a7,4
 ecall
    56e8:	00000073          	ecall
 ret
    56ec:	8082                	ret

00000000000056ee <read>:
.global read
read:
 li a7, SYS_read
    56ee:	4895                	li	a7,5
 ecall
    56f0:	00000073          	ecall
 ret
    56f4:	8082                	ret

00000000000056f6 <write>:
.global write
write:
 li a7, SYS_write
    56f6:	48c1                	li	a7,16
 ecall
    56f8:	00000073          	ecall
 ret
    56fc:	8082                	ret

00000000000056fe <close>:
.global close
close:
 li a7, SYS_close
    56fe:	48d5                	li	a7,21
 ecall
    5700:	00000073          	ecall
 ret
    5704:	8082                	ret

0000000000005706 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5706:	4899                	li	a7,6
 ecall
    5708:	00000073          	ecall
 ret
    570c:	8082                	ret

000000000000570e <exec>:
.global exec
exec:
 li a7, SYS_exec
    570e:	489d                	li	a7,7
 ecall
    5710:	00000073          	ecall
 ret
    5714:	8082                	ret

0000000000005716 <open>:
.global open
open:
 li a7, SYS_open
    5716:	48bd                	li	a7,15
 ecall
    5718:	00000073          	ecall
 ret
    571c:	8082                	ret

000000000000571e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    571e:	48c5                	li	a7,17
 ecall
    5720:	00000073          	ecall
 ret
    5724:	8082                	ret

0000000000005726 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5726:	48c9                	li	a7,18
 ecall
    5728:	00000073          	ecall
 ret
    572c:	8082                	ret

000000000000572e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    572e:	48a1                	li	a7,8
 ecall
    5730:	00000073          	ecall
 ret
    5734:	8082                	ret

0000000000005736 <link>:
.global link
link:
 li a7, SYS_link
    5736:	48cd                	li	a7,19
 ecall
    5738:	00000073          	ecall
 ret
    573c:	8082                	ret

000000000000573e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    573e:	48d1                	li	a7,20
 ecall
    5740:	00000073          	ecall
 ret
    5744:	8082                	ret

0000000000005746 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5746:	48a5                	li	a7,9
 ecall
    5748:	00000073          	ecall
 ret
    574c:	8082                	ret

000000000000574e <dup>:
.global dup
dup:
 li a7, SYS_dup
    574e:	48a9                	li	a7,10
 ecall
    5750:	00000073          	ecall
 ret
    5754:	8082                	ret

0000000000005756 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5756:	48ad                	li	a7,11
 ecall
    5758:	00000073          	ecall
 ret
    575c:	8082                	ret

000000000000575e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    575e:	48b1                	li	a7,12
 ecall
    5760:	00000073          	ecall
 ret
    5764:	8082                	ret

0000000000005766 <pause>:
.global pause
pause:
 li a7, SYS_pause
    5766:	48b5                	li	a7,13
 ecall
    5768:	00000073          	ecall
 ret
    576c:	8082                	ret

000000000000576e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    576e:	48b9                	li	a7,14
 ecall
    5770:	00000073          	ecall
 ret
    5774:	8082                	ret

0000000000005776 <sync>:
.global sync
sync:
 li a7, SYS_sync
    5776:	48d9                	li	a7,22
 ecall
    5778:	00000073          	ecall
 ret
    577c:	8082                	ret

000000000000577e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    577e:	48dd                	li	a7,23
 ecall
    5780:	00000073          	ecall
 ret
    5784:	8082                	ret

0000000000005786 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5786:	1101                	addi	sp,sp,-32
    5788:	ec06                	sd	ra,24(sp)
    578a:	e822                	sd	s0,16(sp)
    578c:	1000                	addi	s0,sp,32
    578e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5792:	4605                	li	a2,1
    5794:	fef40593          	addi	a1,s0,-17
    5798:	f5fff0ef          	jal	56f6 <write>
}
    579c:	60e2                	ld	ra,24(sp)
    579e:	6442                	ld	s0,16(sp)
    57a0:	6105                	addi	sp,sp,32
    57a2:	8082                	ret

00000000000057a4 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    57a4:	715d                	addi	sp,sp,-80
    57a6:	e486                	sd	ra,72(sp)
    57a8:	e0a2                	sd	s0,64(sp)
    57aa:	f84a                	sd	s2,48(sp)
    57ac:	f44e                	sd	s3,40(sp)
    57ae:	0880                	addi	s0,sp,80
    57b0:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
    57b2:	00d036b3          	snez	a3,a3
    57b6:	03f5d793          	srli	a5,a1,0x3f
    57ba:	8efd                	and	a3,a3,a5
  neg = 0;
    57bc:	4301                	li	t1,0
  if (sgn && xx < 0) {
    57be:	c681                	beqz	a3,57c6 <printint+0x22>
    neg = 1;
    x = -xx;
    57c0:	40b005b3          	neg	a1,a1
    neg = 1;
    57c4:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    57c6:	fb840993          	addi	s3,s0,-72
  neg = 0;
    57ca:	86ce                	mv	a3,s3
  i = 0;
    57cc:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    57ce:	00003817          	auipc	a6,0x3
    57d2:	eba80813          	addi	a6,a6,-326 # 8688 <digits>
    57d6:	88ba                	mv	a7,a4
    57d8:	0017051b          	addiw	a0,a4,1
    57dc:	872a                	mv	a4,a0
    57de:	02c5f7b3          	remu	a5,a1,a2
    57e2:	97c2                	add	a5,a5,a6
    57e4:	0007c783          	lbu	a5,0(a5)
    57e8:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    57ec:	87ae                	mv	a5,a1
    57ee:	02c5d5b3          	divu	a1,a1,a2
    57f2:	0685                	addi	a3,a3,1
    57f4:	fec7f1e3          	bgeu	a5,a2,57d6 <printint+0x32>
  if (neg)
    57f8:	00030b63          	beqz	t1,580e <printint+0x6a>
    buf[i++] = '-';
    57fc:	fd040793          	addi	a5,s0,-48
    5800:	953e                	add	a0,a0,a5
    5802:	02d00793          	li	a5,45
    5806:	fef50423          	sb	a5,-24(a0)
    580a:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
    580e:	02e05563          	blez	a4,5838 <printint+0x94>
    5812:	fc26                	sd	s1,56(sp)
    5814:	377d                	addiw	a4,a4,-1
    5816:	00e984b3          	add	s1,s3,a4
    581a:	19fd                	addi	s3,s3,-1 # fff <bigdir+0x10b>
    581c:	99ba                	add	s3,s3,a4
    581e:	1702                	slli	a4,a4,0x20
    5820:	9301                	srli	a4,a4,0x20
    5822:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5826:	0004c583          	lbu	a1,0(s1)
    582a:	854a                	mv	a0,s2
    582c:	f5bff0ef          	jal	5786 <putc>
  while (--i >= 0)
    5830:	14fd                	addi	s1,s1,-1
    5832:	ff349ae3          	bne	s1,s3,5826 <printint+0x82>
    5836:	74e2                	ld	s1,56(sp)
}
    5838:	60a6                	ld	ra,72(sp)
    583a:	6406                	ld	s0,64(sp)
    583c:	7942                	ld	s2,48(sp)
    583e:	79a2                	ld	s3,40(sp)
    5840:	6161                	addi	sp,sp,80
    5842:	8082                	ret

0000000000005844 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5844:	711d                	addi	sp,sp,-96
    5846:	ec86                	sd	ra,88(sp)
    5848:	e8a2                	sd	s0,80(sp)
    584a:	e4a6                	sd	s1,72(sp)
    584c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
    584e:	0005c483          	lbu	s1,0(a1)
    5852:	2a048063          	beqz	s1,5af2 <vprintf+0x2ae>
    5856:	e0ca                	sd	s2,64(sp)
    5858:	fc4e                	sd	s3,56(sp)
    585a:	f852                	sd	s4,48(sp)
    585c:	f456                	sd	s5,40(sp)
    585e:	f05a                	sd	s6,32(sp)
    5860:	ec5e                	sd	s7,24(sp)
    5862:	e862                	sd	s8,16(sp)
    5864:	8b2a                	mv	s6,a0
    5866:	8a2e                	mv	s4,a1
    5868:	8bb2                	mv	s7,a2
  state = 0;
    586a:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
    586c:	4901                	li	s2,0
    586e:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
    5870:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
    5874:	06400c13          	li	s8,100
    5878:	a00d                	j	589a <vprintf+0x56>
        putc(fd, c0);
    587a:	85a6                	mv	a1,s1
    587c:	855a                	mv	a0,s6
    587e:	f09ff0ef          	jal	5786 <putc>
    5882:	a019                	j	5888 <vprintf+0x44>
    } else if (state == '%') {
    5884:	03598363          	beq	s3,s5,58aa <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
    5888:	0019079b          	addiw	a5,s2,1
    588c:	893e                	mv	s2,a5
    588e:	873e                	mv	a4,a5
    5890:	97d2                	add	a5,a5,s4
    5892:	0007c483          	lbu	s1,0(a5)
    5896:	24048763          	beqz	s1,5ae4 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
    589a:	0004879b          	sext.w	a5,s1
    if (state == 0) {
    589e:	fe0993e3          	bnez	s3,5884 <vprintf+0x40>
      if (c0 == '%') {
    58a2:	fd579ce3          	bne	a5,s5,587a <vprintf+0x36>
        state = '%';
    58a6:	89be                	mv	s3,a5
    58a8:	b7c5                	j	5888 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
    58aa:	00ea06b3          	add	a3,s4,a4
    58ae:	0016c603          	lbu	a2,1(a3)
      if (c1)
    58b2:	24060563          	beqz	a2,5afc <vprintf+0x2b8>
      if (c0 == 'd') {
    58b6:	0b878763          	beq	a5,s8,5964 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
    58ba:	f9478693          	addi	a3,a5,-108
    58be:	0016b693          	seqz	a3,a3
    58c2:	f9c60593          	addi	a1,a2,-100
    58c6:	0015b593          	seqz	a1,a1
    58ca:	8df5                	and	a1,a1,a3
    58cc:	e9c5                	bnez	a1,597c <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
    58ce:	9752                	add	a4,a4,s4
    58d0:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    58d4:	f9460713          	addi	a4,a2,-108
    58d8:	00173713          	seqz	a4,a4
    58dc:	8f75                	and	a4,a4,a3
    58de:	f9c50593          	addi	a1,a0,-100
    58e2:	0015b593          	seqz	a1,a1
    58e6:	8df9                	and	a1,a1,a4
    58e8:	e5dd                	bnez	a1,5996 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
    58ea:	07500593          	li	a1,117
    58ee:	0cb78163          	beq	a5,a1,59b0 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
    58f2:	f8b60593          	addi	a1,a2,-117
    58f6:	0015b593          	seqz	a1,a1
    58fa:	8df5                	and	a1,a1,a3
    58fc:	e5f1                	bnez	a1,59c8 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    58fe:	f8b50593          	addi	a1,a0,-117
    5902:	0015b593          	seqz	a1,a1
    5906:	8df9                	and	a1,a1,a4
    5908:	ede9                	bnez	a1,59e2 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
    590a:	07800593          	li	a1,120
    590e:	0eb78763          	beq	a5,a1,59fc <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
    5912:	f8860613          	addi	a2,a2,-120
    5916:	00163613          	seqz	a2,a2
    591a:	8ef1                	and	a3,a3,a2
    591c:	0e069c63          	bnez	a3,5a14 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    5920:	f8850513          	addi	a0,a0,-120
    5924:	00153513          	seqz	a0,a0
    5928:	8f69                	and	a4,a4,a0
    592a:	10071263          	bnez	a4,5a2e <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
    592e:	07000713          	li	a4,112
    5932:	10e78a63          	beq	a5,a4,5a46 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
    5936:	06300713          	li	a4,99
    593a:	14e78a63          	beq	a5,a4,5a8e <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
    593e:	07300713          	li	a4,115
    5942:	16e78063          	beq	a5,a4,5aa2 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
    5946:	02500713          	li	a4,37
    594a:	18e78863          	beq	a5,a4,5ada <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    594e:	02500593          	li	a1,37
    5952:	855a                	mv	a0,s6
    5954:	e33ff0ef          	jal	5786 <putc>
        putc(fd, c0);
    5958:	85a6                	mv	a1,s1
    595a:	855a                	mv	a0,s6
    595c:	e2bff0ef          	jal	5786 <putc>
      }

      state = 0;
    5960:	4981                	li	s3,0
    5962:	b71d                	j	5888 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
    5964:	008b8493          	addi	s1,s7,8
    5968:	4685                	li	a3,1
    596a:	4629                	li	a2,10
    596c:	000ba583          	lw	a1,0(s7)
    5970:	855a                	mv	a0,s6
    5972:	e33ff0ef          	jal	57a4 <printint>
    5976:	8ba6                	mv	s7,s1
      state = 0;
    5978:	4981                	li	s3,0
    597a:	b739                	j	5888 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
    597c:	008b8493          	addi	s1,s7,8
    5980:	4685                	li	a3,1
    5982:	4629                	li	a2,10
    5984:	000bb583          	ld	a1,0(s7)
    5988:	855a                	mv	a0,s6
    598a:	e1bff0ef          	jal	57a4 <printint>
        i += 1;
    598e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    5990:	8ba6                	mv	s7,s1
      state = 0;
    5992:	4981                	li	s3,0
    5994:	bdd5                	j	5888 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
    5996:	008b8493          	addi	s1,s7,8
    599a:	4685                	li	a3,1
    599c:	4629                	li	a2,10
    599e:	000bb583          	ld	a1,0(s7)
    59a2:	855a                	mv	a0,s6
    59a4:	e01ff0ef          	jal	57a4 <printint>
        i += 2;
    59a8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    59aa:	8ba6                	mv	s7,s1
      state = 0;
    59ac:	4981                	li	s3,0
        i += 2;
    59ae:	bde9                	j	5888 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
    59b0:	008b8493          	addi	s1,s7,8
    59b4:	4681                	li	a3,0
    59b6:	4629                	li	a2,10
    59b8:	000be583          	lwu	a1,0(s7)
    59bc:	855a                	mv	a0,s6
    59be:	de7ff0ef          	jal	57a4 <printint>
    59c2:	8ba6                	mv	s7,s1
      state = 0;
    59c4:	4981                	li	s3,0
    59c6:	b5c9                	j	5888 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    59c8:	008b8493          	addi	s1,s7,8
    59cc:	4681                	li	a3,0
    59ce:	4629                	li	a2,10
    59d0:	000bb583          	ld	a1,0(s7)
    59d4:	855a                	mv	a0,s6
    59d6:	dcfff0ef          	jal	57a4 <printint>
        i += 1;
    59da:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    59dc:	8ba6                	mv	s7,s1
      state = 0;
    59de:	4981                	li	s3,0
    59e0:	b565                	j	5888 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    59e2:	008b8493          	addi	s1,s7,8
    59e6:	4681                	li	a3,0
    59e8:	4629                	li	a2,10
    59ea:	000bb583          	ld	a1,0(s7)
    59ee:	855a                	mv	a0,s6
    59f0:	db5ff0ef          	jal	57a4 <printint>
        i += 2;
    59f4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    59f6:	8ba6                	mv	s7,s1
      state = 0;
    59f8:	4981                	li	s3,0
        i += 2;
    59fa:	b579                	j	5888 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
    59fc:	008b8493          	addi	s1,s7,8
    5a00:	4681                	li	a3,0
    5a02:	4641                	li	a2,16
    5a04:	000be583          	lwu	a1,0(s7)
    5a08:	855a                	mv	a0,s6
    5a0a:	d9bff0ef          	jal	57a4 <printint>
    5a0e:	8ba6                	mv	s7,s1
      state = 0;
    5a10:	4981                	li	s3,0
    5a12:	bd9d                	j	5888 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    5a14:	008b8493          	addi	s1,s7,8
    5a18:	4681                	li	a3,0
    5a1a:	4641                	li	a2,16
    5a1c:	000bb583          	ld	a1,0(s7)
    5a20:	855a                	mv	a0,s6
    5a22:	d83ff0ef          	jal	57a4 <printint>
        i += 1;
    5a26:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    5a28:	8ba6                	mv	s7,s1
      state = 0;
    5a2a:	4981                	li	s3,0
    5a2c:	bdb1                	j	5888 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    5a2e:	008b8493          	addi	s1,s7,8
    5a32:	4641                	li	a2,16
    5a34:	000bb583          	ld	a1,0(s7)
    5a38:	855a                	mv	a0,s6
    5a3a:	d6bff0ef          	jal	57a4 <printint>
        i += 2;
    5a3e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    5a40:	8ba6                	mv	s7,s1
      state = 0;
    5a42:	4981                	li	s3,0
        i += 2;
    5a44:	b591                	j	5888 <vprintf+0x44>
    5a46:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
    5a48:	008b8793          	addi	a5,s7,8
    5a4c:	8cbe                	mv	s9,a5
    5a4e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5a52:	03000593          	li	a1,48
    5a56:	855a                	mv	a0,s6
    5a58:	d2fff0ef          	jal	5786 <putc>
  putc(fd, 'x');
    5a5c:	07800593          	li	a1,120
    5a60:	855a                	mv	a0,s6
    5a62:	d25ff0ef          	jal	5786 <putc>
    5a66:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5a68:	00003b97          	auipc	s7,0x3
    5a6c:	c20b8b93          	addi	s7,s7,-992 # 8688 <digits>
    5a70:	03c9d793          	srli	a5,s3,0x3c
    5a74:	97de                	add	a5,a5,s7
    5a76:	0007c583          	lbu	a1,0(a5)
    5a7a:	855a                	mv	a0,s6
    5a7c:	d0bff0ef          	jal	5786 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5a80:	0992                	slli	s3,s3,0x4
    5a82:	34fd                	addiw	s1,s1,-1
    5a84:	f4f5                	bnez	s1,5a70 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
    5a86:	8be6                	mv	s7,s9
      state = 0;
    5a88:	4981                	li	s3,0
    5a8a:	6ca2                	ld	s9,8(sp)
    5a8c:	bbf5                	j	5888 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
    5a8e:	008b8493          	addi	s1,s7,8
    5a92:	000bc583          	lbu	a1,0(s7)
    5a96:	855a                	mv	a0,s6
    5a98:	cefff0ef          	jal	5786 <putc>
    5a9c:	8ba6                	mv	s7,s1
      state = 0;
    5a9e:	4981                	li	s3,0
    5aa0:	b3e5                	j	5888 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
    5aa2:	008b8993          	addi	s3,s7,8
    5aa6:	000bb483          	ld	s1,0(s7)
    5aaa:	cc91                	beqz	s1,5ac6 <vprintf+0x282>
        for (; *s; s++)
    5aac:	0004c583          	lbu	a1,0(s1)
    5ab0:	c195                	beqz	a1,5ad4 <vprintf+0x290>
          putc(fd, *s);
    5ab2:	855a                	mv	a0,s6
    5ab4:	cd3ff0ef          	jal	5786 <putc>
        for (; *s; s++)
    5ab8:	0485                	addi	s1,s1,1
    5aba:	0004c583          	lbu	a1,0(s1)
    5abe:	f9f5                	bnez	a1,5ab2 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
    5ac0:	8bce                	mv	s7,s3
      state = 0;
    5ac2:	4981                	li	s3,0
    5ac4:	b3d1                	j	5888 <vprintf+0x44>
          s = "(null)";
    5ac6:	00003497          	auipc	s1,0x3
    5aca:	b1248493          	addi	s1,s1,-1262 # 85d8 <malloc+0x29e0>
        for (; *s; s++)
    5ace:	02800593          	li	a1,40
    5ad2:	b7c5                	j	5ab2 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
    5ad4:	8bce                	mv	s7,s3
      state = 0;
    5ad6:	4981                	li	s3,0
    5ad8:	bb45                	j	5888 <vprintf+0x44>
        putc(fd, '%');
    5ada:	85be                	mv	a1,a5
    5adc:	855a                	mv	a0,s6
    5ade:	ca9ff0ef          	jal	5786 <putc>
    5ae2:	bdbd                	j	5960 <vprintf+0x11c>
    5ae4:	6906                	ld	s2,64(sp)
    5ae6:	79e2                	ld	s3,56(sp)
    5ae8:	7a42                	ld	s4,48(sp)
    5aea:	7aa2                	ld	s5,40(sp)
    5aec:	7b02                	ld	s6,32(sp)
    5aee:	6be2                	ld	s7,24(sp)
    5af0:	6c42                	ld	s8,16(sp)
    }
  }
}
    5af2:	60e6                	ld	ra,88(sp)
    5af4:	6446                	ld	s0,80(sp)
    5af6:	64a6                	ld	s1,72(sp)
    5af8:	6125                	addi	sp,sp,96
    5afa:	8082                	ret
      if (c0 == 'd') {
    5afc:	06400713          	li	a4,100
    5b00:	e6e782e3          	beq	a5,a4,5964 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
    5b04:	f9478693          	addi	a3,a5,-108
    5b08:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
    5b0c:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    5b0e:	4701                	li	a4,0
    5b10:	bbe9                	j	58ea <vprintf+0xa6>

0000000000005b12 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5b12:	715d                	addi	sp,sp,-80
    5b14:	ec06                	sd	ra,24(sp)
    5b16:	e822                	sd	s0,16(sp)
    5b18:	1000                	addi	s0,sp,32
    5b1a:	e010                	sd	a2,0(s0)
    5b1c:	e414                	sd	a3,8(s0)
    5b1e:	e818                	sd	a4,16(s0)
    5b20:	ec1c                	sd	a5,24(s0)
    5b22:	03043023          	sd	a6,32(s0)
    5b26:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5b2a:	8622                	mv	a2,s0
    5b2c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5b30:	d15ff0ef          	jal	5844 <vprintf>
}
    5b34:	60e2                	ld	ra,24(sp)
    5b36:	6442                	ld	s0,16(sp)
    5b38:	6161                	addi	sp,sp,80
    5b3a:	8082                	ret

0000000000005b3c <printf>:

void
printf(const char *fmt, ...)
{
    5b3c:	711d                	addi	sp,sp,-96
    5b3e:	ec06                	sd	ra,24(sp)
    5b40:	e822                	sd	s0,16(sp)
    5b42:	1000                	addi	s0,sp,32
    5b44:	e40c                	sd	a1,8(s0)
    5b46:	e810                	sd	a2,16(s0)
    5b48:	ec14                	sd	a3,24(s0)
    5b4a:	f018                	sd	a4,32(s0)
    5b4c:	f41c                	sd	a5,40(s0)
    5b4e:	03043823          	sd	a6,48(s0)
    5b52:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5b56:	00840613          	addi	a2,s0,8
    5b5a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5b5e:	85aa                	mv	a1,a0
    5b60:	4505                	li	a0,1
    5b62:	ce3ff0ef          	jal	5844 <vprintf>
}
    5b66:	60e2                	ld	ra,24(sp)
    5b68:	6442                	ld	s0,16(sp)
    5b6a:	6125                	addi	sp,sp,96
    5b6c:	8082                	ret

0000000000005b6e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5b6e:	1141                	addi	sp,sp,-16
    5b70:	e406                	sd	ra,8(sp)
    5b72:	e022                	sd	s0,0(sp)
    5b74:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
    5b76:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5b7a:	00005797          	auipc	a5,0x5
    5b7e:	9467b783          	ld	a5,-1722(a5) # a4c0 <freep>
    5b82:	a095                	j	5be6 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    5b84:	ff852583          	lw	a1,-8(a0)
    5b88:	6390                	ld	a2,0(a5)
    5b8a:	02059813          	slli	a6,a1,0x20
    5b8e:	01c85693          	srli	a3,a6,0x1c
    5b92:	96ba                	add	a3,a3,a4
    5b94:	02d60563          	beq	a2,a3,5bbe <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    5b98:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    5b9c:	4790                	lw	a2,8(a5)
    5b9e:	02061593          	slli	a1,a2,0x20
    5ba2:	01c5d693          	srli	a3,a1,0x1c
    5ba6:	96be                	add	a3,a3,a5
    5ba8:	02d70263          	beq	a4,a3,5bcc <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    5bac:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5bae:	00005717          	auipc	a4,0x5
    5bb2:	90f73923          	sd	a5,-1774(a4) # a4c0 <freep>
}
    5bb6:	60a2                	ld	ra,8(sp)
    5bb8:	6402                	ld	s0,0(sp)
    5bba:	0141                	addi	sp,sp,16
    5bbc:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    5bbe:	4614                	lw	a3,8(a2)
    5bc0:	9ead                	addw	a3,a3,a1
    5bc2:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5bc6:	6394                	ld	a3,0(a5)
    5bc8:	6290                	ld	a2,0(a3)
    5bca:	b7f9                	j	5b98 <free+0x2a>
    p->s.size += bp->s.size;
    5bcc:	ff852703          	lw	a4,-8(a0)
    5bd0:	9f31                	addw	a4,a4,a2
    5bd2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5bd4:	ff053703          	ld	a4,-16(a0)
    5bd8:	bfd1                	j	5bac <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5bda:	6394                	ld	a3,0(a5)
    5bdc:	00d7e463          	bltu	a5,a3,5be4 <free+0x76>
    5be0:	fad762e3          	bltu	a4,a3,5b84 <free+0x16>
    5be4:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5be6:	fee7fae3          	bgeu	a5,a4,5bda <free+0x6c>
    5bea:	6394                	ld	a3,0(a5)
    5bec:	f8d76ce3          	bltu	a4,a3,5b84 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5bf0:	f8d7fae3          	bgeu	a5,a3,5b84 <free+0x16>
    5bf4:	87b6                	mv	a5,a3
    5bf6:	bfc5                	j	5be6 <free+0x78>

0000000000005bf8 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
    5bf8:	7139                	addi	sp,sp,-64
    5bfa:	fc06                	sd	ra,56(sp)
    5bfc:	f822                	sd	s0,48(sp)
    5bfe:	f04a                	sd	s2,32(sp)
    5c00:	ec4e                	sd	s3,24(sp)
    5c02:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    5c04:	02051993          	slli	s3,a0,0x20
    5c08:	0209d993          	srli	s3,s3,0x20
    5c0c:	09bd                	addi	s3,s3,15
    5c0e:	0049d993          	srli	s3,s3,0x4
    5c12:	2985                	addiw	s3,s3,1
    5c14:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
    5c16:	00005517          	auipc	a0,0x5
    5c1a:	8aa53503          	ld	a0,-1878(a0) # a4c0 <freep>
    5c1e:	c905                	beqz	a0,5c4e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    5c20:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    5c22:	4798                	lw	a4,8(a5)
    5c24:	09377663          	bgeu	a4,s3,5cb0 <malloc+0xb8>
    5c28:	f426                	sd	s1,40(sp)
    5c2a:	e852                	sd	s4,16(sp)
    5c2c:	e456                	sd	s5,8(sp)
    5c2e:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
    5c30:	8a4e                	mv	s4,s3
    5c32:	6705                	lui	a4,0x1
    5c34:	00e9f363          	bgeu	s3,a4,5c3a <malloc+0x42>
    5c38:	6a05                	lui	s4,0x1
    5c3a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5c3e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
    5c42:	00005497          	auipc	s1,0x5
    5c46:	87e48493          	addi	s1,s1,-1922 # a4c0 <freep>
  if (p == SBRK_ERROR)
    5c4a:	5afd                	li	s5,-1
    5c4c:	a83d                	j	5c8a <malloc+0x92>
    5c4e:	f426                	sd	s1,40(sp)
    5c50:	e852                	sd	s4,16(sp)
    5c52:	e456                	sd	s5,8(sp)
    5c54:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    5c56:	0000b797          	auipc	a5,0xb
    5c5a:	09278793          	addi	a5,a5,146 # 10ce8 <base>
    5c5e:	00005717          	auipc	a4,0x5
    5c62:	86f73123          	sd	a5,-1950(a4) # a4c0 <freep>
    5c66:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5c68:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
    5c6c:	b7d1                	j	5c30 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    5c6e:	6398                	ld	a4,0(a5)
    5c70:	e118                	sd	a4,0(a0)
    5c72:	a899                	j	5cc8 <malloc+0xd0>
  hp->s.size = nu;
    5c74:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
    5c78:	0541                	addi	a0,a0,16
    5c7a:	ef5ff0ef          	jal	5b6e <free>
  return freep;
    5c7e:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
    5c80:	c125                	beqz	a0,5ce0 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    5c82:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    5c84:	4798                	lw	a4,8(a5)
    5c86:	03277163          	bgeu	a4,s2,5ca8 <malloc+0xb0>
    if (p == freep)
    5c8a:	6098                	ld	a4,0(s1)
    5c8c:	853e                	mv	a0,a5
    5c8e:	fef71ae3          	bne	a4,a5,5c82 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    5c92:	8552                	mv	a0,s4
    5c94:	a0fff0ef          	jal	56a2 <sbrk>
  if (p == SBRK_ERROR)
    5c98:	fd551ee3          	bne	a0,s5,5c74 <malloc+0x7c>
        return 0;
    5c9c:	4501                	li	a0,0
    5c9e:	74a2                	ld	s1,40(sp)
    5ca0:	6a42                	ld	s4,16(sp)
    5ca2:	6aa2                	ld	s5,8(sp)
    5ca4:	6b02                	ld	s6,0(sp)
    5ca6:	a03d                	j	5cd4 <malloc+0xdc>
    5ca8:	74a2                	ld	s1,40(sp)
    5caa:	6a42                	ld	s4,16(sp)
    5cac:	6aa2                	ld	s5,8(sp)
    5cae:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
    5cb0:	fae90fe3          	beq	s2,a4,5c6e <malloc+0x76>
        p->s.size -= nunits;
    5cb4:	4137073b          	subw	a4,a4,s3
    5cb8:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5cba:	02071693          	slli	a3,a4,0x20
    5cbe:	01c6d713          	srli	a4,a3,0x1c
    5cc2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5cc4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5cc8:	00004717          	auipc	a4,0x4
    5ccc:	7ea73c23          	sd	a0,2040(a4) # a4c0 <freep>
      return (void *)(p + 1);
    5cd0:	01078513          	addi	a0,a5,16
  }
}
    5cd4:	70e2                	ld	ra,56(sp)
    5cd6:	7442                	ld	s0,48(sp)
    5cd8:	7902                	ld	s2,32(sp)
    5cda:	69e2                	ld	s3,24(sp)
    5cdc:	6121                	addi	sp,sp,64
    5cde:	8082                	ret
    5ce0:	74a2                	ld	s1,40(sp)
    5ce2:	6a42                	ld	s4,16(sp)
    5ce4:	6aa2                	ld	s5,8(sp)
    5ce6:	6b02                	ld	s6,0(sp)
    5ce8:	b7f5                	j	5cd4 <malloc+0xdc>
