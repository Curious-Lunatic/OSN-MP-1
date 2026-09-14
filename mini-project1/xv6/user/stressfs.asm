
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dc010113          	addi	sp,sp,-576
   4:	22113c23          	sd	ra,568(sp)
   8:	22813823          	sd	s0,560(sp)
   c:	22913423          	sd	s1,552(sp)
  10:	23213023          	sd	s2,544(sp)
  14:	21313c23          	sd	s3,536(sp)
  18:	21413823          	sd	s4,528(sp)
  1c:	0480                	addi	s0,sp,576
  int fd, i;
  char path[] = "stressfs0";
  1e:	00001797          	auipc	a5,0x1
  22:	9d278793          	addi	a5,a5,-1582 # 9f0 <malloc+0x130>
  26:	6398                	ld	a4,0(a5)
  28:	fce43023          	sd	a4,-64(s0)
  2c:	0087d783          	lhu	a5,8(a5)
  30:	fcf41423          	sh	a5,-56(s0)
  char data[512];

  printf("stressfs starting\n");
  34:	00001517          	auipc	a0,0x1
  38:	98c50513          	addi	a0,a0,-1652 # 9c0 <malloc+0x100>
  3c:	7c8000ef          	jal	804 <printf>
  memset(data, 'a', sizeof(data));
  40:	20000613          	li	a2,512
  44:	06100593          	li	a1,97
  48:	dc040513          	addi	a0,s0,-576
  4c:	128000ef          	jal	174 <memset>

  for (i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if (fork() > 0)
  54:	342000ef          	jal	396 <fork>
  58:	00a04563          	bgtz	a0,62 <main+0x62>
  for (i = 0; i < 4; i++)
  5c:	2485                	addiw	s1,s1,1
  5e:	ff249be3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  62:	85a6                	mv	a1,s1
  64:	00001517          	auipc	a0,0x1
  68:	97450513          	addi	a0,a0,-1676 # 9d8 <malloc+0x118>
  6c:	798000ef          	jal	804 <printf>

  path[8] += i;
  70:	fc844783          	lbu	a5,-56(s0)
  74:	9fa5                	addw	a5,a5,s1
  76:	fcf40423          	sb	a5,-56(s0)
  fd = open(path, O_CREATE | O_RDWR);
  7a:	20200593          	li	a1,514
  7e:	fc040513          	addi	a0,s0,-64
  82:	35c000ef          	jal	3de <open>
  86:	892a                	mv	s2,a0
  88:	44d1                	li	s1,20
  for (i = 0; i < 20; i++) {
    // printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  8a:	dc040a13          	addi	s4,s0,-576
  8e:	20000993          	li	s3,512
  92:	864e                	mv	a2,s3
  94:	85d2                	mv	a1,s4
  96:	854a                	mv	a0,s2
  98:	326000ef          	jal	3be <write>
  for (i = 0; i < 20; i++) {
  9c:	34fd                	addiw	s1,s1,-1
  9e:	f8f5                	bnez	s1,92 <main+0x92>
  }
  close(fd);
  a0:	854a                	mv	a0,s2
  a2:	324000ef          	jal	3c6 <close>

  printf("read\n");
  a6:	00001517          	auipc	a0,0x1
  aa:	94250513          	addi	a0,a0,-1726 # 9e8 <malloc+0x128>
  ae:	756000ef          	jal	804 <printf>

  fd = open(path, O_RDONLY);
  b2:	4581                	li	a1,0
  b4:	fc040513          	addi	a0,s0,-64
  b8:	326000ef          	jal	3de <open>
  bc:	892a                	mv	s2,a0
  be:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  c0:	dc040a13          	addi	s4,s0,-576
  c4:	20000993          	li	s3,512
  c8:	864e                	mv	a2,s3
  ca:	85d2                	mv	a1,s4
  cc:	854a                	mv	a0,s2
  ce:	2e8000ef          	jal	3b6 <read>
  for (i = 0; i < 20; i++)
  d2:	34fd                	addiw	s1,s1,-1
  d4:	f8f5                	bnez	s1,c8 <main+0xc8>
  close(fd);
  d6:	854a                	mv	a0,s2
  d8:	2ee000ef          	jal	3c6 <close>

  wait(0);
  dc:	4501                	li	a0,0
  de:	2c8000ef          	jal	3a6 <wait>

  exit(0);
  e2:	4501                	li	a0,0
  e4:	2ba000ef          	jal	39e <exit>

00000000000000e8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e406                	sd	ra,8(sp)
  ec:	e022                	sd	s0,0(sp)
  ee:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  f0:	f11ff0ef          	jal	0 <main>
  exit(r);
  f4:	2aa000ef          	jal	39e <exit>

00000000000000f8 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 100:	87aa                	mv	a5,a0
 102:	0585                	addi	a1,a1,1
 104:	0785                	addi	a5,a5,1
 106:	fff5c703          	lbu	a4,-1(a1)
 10a:	fee78fa3          	sb	a4,-1(a5)
 10e:	fb75                	bnez	a4,102 <strcpy+0xa>
    ;
  return os;
}
 110:	60a2                	ld	ra,8(sp)
 112:	6402                	ld	s0,0(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e406                	sd	ra,8(sp)
 11c:	e022                	sd	s0,0(sp)
 11e:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 120:	00054783          	lbu	a5,0(a0)
 124:	cb91                	beqz	a5,138 <strcmp+0x20>
 126:	0005c703          	lbu	a4,0(a1)
 12a:	00f71763          	bne	a4,a5,138 <strcmp+0x20>
    p++, q++;
 12e:	0505                	addi	a0,a0,1
 130:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 132:	00054783          	lbu	a5,0(a0)
 136:	fbe5                	bnez	a5,126 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 138:	0005c503          	lbu	a0,0(a1)
}
 13c:	40a7853b          	subw	a0,a5,a0
 140:	60a2                	ld	ra,8(sp)
 142:	6402                	ld	s0,0(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret

0000000000000148 <strlen>:

uint
strlen(const char *s)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e406                	sd	ra,8(sp)
 14c:	e022                	sd	s0,0(sp)
 14e:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 150:	00054783          	lbu	a5,0(a0)
 154:	cf91                	beqz	a5,170 <strlen+0x28>
 156:	00150793          	addi	a5,a0,1
 15a:	86be                	mv	a3,a5
 15c:	0785                	addi	a5,a5,1
 15e:	fff7c703          	lbu	a4,-1(a5)
 162:	ff65                	bnez	a4,15a <strlen+0x12>
 164:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 168:	60a2                	ld	ra,8(sp)
 16a:	6402                	ld	s0,0(sp)
 16c:	0141                	addi	sp,sp,16
 16e:	8082                	ret
  for (n = 0; s[n]; n++)
 170:	4501                	li	a0,0
 172:	bfdd                	j	168 <strlen+0x20>

0000000000000174 <memset>:

void *
memset(void *dst, int c, uint n)
{
 174:	1141                	addi	sp,sp,-16
 176:	e406                	sd	ra,8(sp)
 178:	e022                	sd	s0,0(sp)
 17a:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 17c:	ca19                	beqz	a2,192 <memset+0x1e>
 17e:	87aa                	mv	a5,a0
 180:	1602                	slli	a2,a2,0x20
 182:	9201                	srli	a2,a2,0x20
 184:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 188:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 18c:	0785                	addi	a5,a5,1
 18e:	fee79de3          	bne	a5,a4,188 <memset+0x14>
  }
  return dst;
}
 192:	60a2                	ld	ra,8(sp)
 194:	6402                	ld	s0,0(sp)
 196:	0141                	addi	sp,sp,16
 198:	8082                	ret

000000000000019a <strchr>:

char *
strchr(const char *s, char c)
{
 19a:	1141                	addi	sp,sp,-16
 19c:	e406                	sd	ra,8(sp)
 19e:	e022                	sd	s0,0(sp)
 1a0:	0800                	addi	s0,sp,16
  for (; *s; s++)
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	c799                	beqz	a5,1b4 <strchr+0x1a>
    if (*s == c)
 1a8:	00f58763          	beq	a1,a5,1b6 <strchr+0x1c>
  for (; *s; s++)
 1ac:	0505                	addi	a0,a0,1
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	fbfd                	bnez	a5,1a8 <strchr+0xe>
      return (char *)s;
  return 0;
 1b4:	4501                	li	a0,0
}
 1b6:	60a2                	ld	ra,8(sp)
 1b8:	6402                	ld	s0,0(sp)
 1ba:	0141                	addi	sp,sp,16
 1bc:	8082                	ret

00000000000001be <gets>:

char *
gets(char *buf, int max)
{
 1be:	711d                	addi	sp,sp,-96
 1c0:	ec86                	sd	ra,88(sp)
 1c2:	e8a2                	sd	s0,80(sp)
 1c4:	e4a6                	sd	s1,72(sp)
 1c6:	e0ca                	sd	s2,64(sp)
 1c8:	fc4e                	sd	s3,56(sp)
 1ca:	f852                	sd	s4,48(sp)
 1cc:	f456                	sd	s5,40(sp)
 1ce:	f05a                	sd	s6,32(sp)
 1d0:	ec5e                	sd	s7,24(sp)
 1d2:	e862                	sd	s8,16(sp)
 1d4:	1080                	addi	s0,sp,96
 1d6:	8baa                	mv	s7,a0
 1d8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1da:	892a                	mv	s2,a0
 1dc:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1de:	faf40b13          	addi	s6,s0,-81
 1e2:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 1e4:	8c26                	mv	s8,s1
 1e6:	0014899b          	addiw	s3,s1,1
 1ea:	84ce                	mv	s1,s3
 1ec:	0349d863          	bge	s3,s4,21c <gets+0x5e>
    cc = read(0, &c, 1);
 1f0:	8656                	mv	a2,s5
 1f2:	85da                	mv	a1,s6
 1f4:	4501                	li	a0,0
 1f6:	1c0000ef          	jal	3b6 <read>
    if (cc < 1)
 1fa:	02a05163          	blez	a0,21c <gets+0x5e>
      break;
    buf[i++] = c;
 1fe:	faf44783          	lbu	a5,-81(s0)
 202:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 206:	0905                	addi	s2,s2,1
 208:	ff678713          	addi	a4,a5,-10
 20c:	00173713          	seqz	a4,a4
 210:	17cd                	addi	a5,a5,-13
 212:	0017b793          	seqz	a5,a5
 216:	8fd9                	or	a5,a5,a4
 218:	d7f1                	beqz	a5,1e4 <gets+0x26>
    buf[i++] = c;
 21a:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 21c:	9c5e                	add	s8,s8,s7
 21e:	000c0023          	sb	zero,0(s8)
  return buf;
}
 222:	855e                	mv	a0,s7
 224:	60e6                	ld	ra,88(sp)
 226:	6446                	ld	s0,80(sp)
 228:	64a6                	ld	s1,72(sp)
 22a:	6906                	ld	s2,64(sp)
 22c:	79e2                	ld	s3,56(sp)
 22e:	7a42                	ld	s4,48(sp)
 230:	7aa2                	ld	s5,40(sp)
 232:	7b02                	ld	s6,32(sp)
 234:	6be2                	ld	s7,24(sp)
 236:	6c42                	ld	s8,16(sp)
 238:	6125                	addi	sp,sp,96
 23a:	8082                	ret

000000000000023c <stat>:

int
stat(const char *n, struct stat *st)
{
 23c:	1101                	addi	sp,sp,-32
 23e:	ec06                	sd	ra,24(sp)
 240:	e822                	sd	s0,16(sp)
 242:	e04a                	sd	s2,0(sp)
 244:	1000                	addi	s0,sp,32
 246:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 248:	4581                	li	a1,0
 24a:	194000ef          	jal	3de <open>
  if (fd < 0)
 24e:	02054263          	bltz	a0,272 <stat+0x36>
 252:	e426                	sd	s1,8(sp)
 254:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 256:	85ca                	mv	a1,s2
 258:	19e000ef          	jal	3f6 <fstat>
 25c:	892a                	mv	s2,a0
  close(fd);
 25e:	8526                	mv	a0,s1
 260:	166000ef          	jal	3c6 <close>
  return r;
 264:	64a2                	ld	s1,8(sp)
}
 266:	854a                	mv	a0,s2
 268:	60e2                	ld	ra,24(sp)
 26a:	6442                	ld	s0,16(sp)
 26c:	6902                	ld	s2,0(sp)
 26e:	6105                	addi	sp,sp,32
 270:	8082                	ret
    return -1;
 272:	57fd                	li	a5,-1
 274:	893e                	mv	s2,a5
 276:	bfc5                	j	266 <stat+0x2a>

0000000000000278 <atoi>:

int
atoi(const char *s)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e406                	sd	ra,8(sp)
 27c:	e022                	sd	s0,0(sp)
 27e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 280:	00054683          	lbu	a3,0(a0)
 284:	fd06879b          	addiw	a5,a3,-48
 288:	0ff7f793          	zext.b	a5,a5
 28c:	4625                	li	a2,9
 28e:	02f66963          	bltu	a2,a5,2c0 <atoi+0x48>
 292:	872a                	mv	a4,a0
  n = 0;
 294:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 296:	0705                	addi	a4,a4,1
 298:	0025179b          	slliw	a5,a0,0x2
 29c:	9fa9                	addw	a5,a5,a0
 29e:	0017979b          	slliw	a5,a5,0x1
 2a2:	9fb5                	addw	a5,a5,a3
 2a4:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 2a8:	00074683          	lbu	a3,0(a4)
 2ac:	fd06879b          	addiw	a5,a3,-48
 2b0:	0ff7f793          	zext.b	a5,a5
 2b4:	fef671e3          	bgeu	a2,a5,296 <atoi+0x1e>
  return n;
}
 2b8:	60a2                	ld	ra,8(sp)
 2ba:	6402                	ld	s0,0(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret
  n = 0;
 2c0:	4501                	li	a0,0
 2c2:	bfdd                	j	2b8 <atoi+0x40>

00000000000002c4 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e406                	sd	ra,8(sp)
 2c8:	e022                	sd	s0,0(sp)
 2ca:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2cc:	02b57563          	bgeu	a0,a1,2f6 <memmove+0x32>
    while (n-- > 0)
 2d0:	00c05f63          	blez	a2,2ee <memmove+0x2a>
 2d4:	1602                	slli	a2,a2,0x20
 2d6:	9201                	srli	a2,a2,0x20
 2d8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2dc:	872a                	mv	a4,a0
      *dst++ = *src++;
 2de:	0585                	addi	a1,a1,1
 2e0:	0705                	addi	a4,a4,1
 2e2:	fff5c683          	lbu	a3,-1(a1)
 2e6:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2ea:	fee79ae3          	bne	a5,a4,2de <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ee:	60a2                	ld	ra,8(sp)
 2f0:	6402                	ld	s0,0(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret
    while (n-- > 0)
 2f6:	fec05ce3          	blez	a2,2ee <memmove+0x2a>
    dst += n;
 2fa:	00c50733          	add	a4,a0,a2
    src += n;
 2fe:	95b2                	add	a1,a1,a2
 300:	fff6079b          	addiw	a5,a2,-1
 304:	1782                	slli	a5,a5,0x20
 306:	9381                	srli	a5,a5,0x20
 308:	fff7c793          	not	a5,a5
 30c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 30e:	15fd                	addi	a1,a1,-1
 310:	177d                	addi	a4,a4,-1
 312:	0005c683          	lbu	a3,0(a1)
 316:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 31a:	fef71ae3          	bne	a4,a5,30e <memmove+0x4a>
 31e:	bfc1                	j	2ee <memmove+0x2a>

0000000000000320 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 320:	1141                	addi	sp,sp,-16
 322:	e406                	sd	ra,8(sp)
 324:	e022                	sd	s0,0(sp)
 326:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 328:	ce19                	beqz	a2,346 <memcmp+0x26>
 32a:	1602                	slli	a2,a2,0x20
 32c:	9201                	srli	a2,a2,0x20
 32e:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 332:	00054783          	lbu	a5,0(a0)
 336:	0005c703          	lbu	a4,0(a1)
 33a:	00e79b63          	bne	a5,a4,350 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 33e:	0505                	addi	a0,a0,1
    p2++;
 340:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 342:	fed518e3          	bne	a0,a3,332 <memcmp+0x12>
  }
  return 0;
 346:	4501                	li	a0,0
}
 348:	60a2                	ld	ra,8(sp)
 34a:	6402                	ld	s0,0(sp)
 34c:	0141                	addi	sp,sp,16
 34e:	8082                	ret
      return *p1 - *p2;
 350:	40e7853b          	subw	a0,a5,a4
 354:	bfd5                	j	348 <memcmp+0x28>

0000000000000356 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 356:	1141                	addi	sp,sp,-16
 358:	e406                	sd	ra,8(sp)
 35a:	e022                	sd	s0,0(sp)
 35c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 35e:	f67ff0ef          	jal	2c4 <memmove>
}
 362:	60a2                	ld	ra,8(sp)
 364:	6402                	ld	s0,0(sp)
 366:	0141                	addi	sp,sp,16
 368:	8082                	ret

000000000000036a <sbrk>:

char *
sbrk(int n)
{
 36a:	1141                	addi	sp,sp,-16
 36c:	e406                	sd	ra,8(sp)
 36e:	e022                	sd	s0,0(sp)
 370:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 372:	4585                	li	a1,1
 374:	0b2000ef          	jal	426 <sys_sbrk>
}
 378:	60a2                	ld	ra,8(sp)
 37a:	6402                	ld	s0,0(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret

0000000000000380 <sbrklazy>:

char *
sbrklazy(int n)
{
 380:	1141                	addi	sp,sp,-16
 382:	e406                	sd	ra,8(sp)
 384:	e022                	sd	s0,0(sp)
 386:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 388:	4589                	li	a1,2
 38a:	09c000ef          	jal	426 <sys_sbrk>
}
 38e:	60a2                	ld	ra,8(sp)
 390:	6402                	ld	s0,0(sp)
 392:	0141                	addi	sp,sp,16
 394:	8082                	ret

0000000000000396 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 396:	4885                	li	a7,1
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <exit>:
.global exit
exit:
 li a7, SYS_exit
 39e:	4889                	li	a7,2
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a6:	488d                	li	a7,3
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ae:	4891                	li	a7,4
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <read>:
.global read
read:
 li a7, SYS_read
 3b6:	4895                	li	a7,5
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <write>:
.global write
write:
 li a7, SYS_write
 3be:	48c1                	li	a7,16
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <close>:
.global close
close:
 li a7, SYS_close
 3c6:	48d5                	li	a7,21
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ce:	4899                	li	a7,6
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d6:	489d                	li	a7,7
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <open>:
.global open
open:
 li a7, SYS_open
 3de:	48bd                	li	a7,15
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3e6:	48c5                	li	a7,17
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ee:	48c9                	li	a7,18
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3f6:	48a1                	li	a7,8
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <link>:
.global link
link:
 li a7, SYS_link
 3fe:	48cd                	li	a7,19
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 406:	48d1                	li	a7,20
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 40e:	48a5                	li	a7,9
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <dup>:
.global dup
dup:
 li a7, SYS_dup
 416:	48a9                	li	a7,10
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 41e:	48ad                	li	a7,11
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 426:	48b1                	li	a7,12
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <pause>:
.global pause
pause:
 li a7, SYS_pause
 42e:	48b5                	li	a7,13
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 436:	48b9                	li	a7,14
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <sync>:
.global sync
sync:
 li a7, SYS_sync
 43e:	48d9                	li	a7,22
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 446:	48dd                	li	a7,23
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 44e:	1101                	addi	sp,sp,-32
 450:	ec06                	sd	ra,24(sp)
 452:	e822                	sd	s0,16(sp)
 454:	1000                	addi	s0,sp,32
 456:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 45a:	4605                	li	a2,1
 45c:	fef40593          	addi	a1,s0,-17
 460:	f5fff0ef          	jal	3be <write>
}
 464:	60e2                	ld	ra,24(sp)
 466:	6442                	ld	s0,16(sp)
 468:	6105                	addi	sp,sp,32
 46a:	8082                	ret

000000000000046c <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 46c:	715d                	addi	sp,sp,-80
 46e:	e486                	sd	ra,72(sp)
 470:	e0a2                	sd	s0,64(sp)
 472:	f84a                	sd	s2,48(sp)
 474:	f44e                	sd	s3,40(sp)
 476:	0880                	addi	s0,sp,80
 478:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 47a:	00d036b3          	snez	a3,a3
 47e:	03f5d793          	srli	a5,a1,0x3f
 482:	8efd                	and	a3,a3,a5
  neg = 0;
 484:	4301                	li	t1,0
  if (sgn && xx < 0) {
 486:	c681                	beqz	a3,48e <printint+0x22>
    neg = 1;
    x = -xx;
 488:	40b005b3          	neg	a1,a1
    neg = 1;
 48c:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 48e:	fb840993          	addi	s3,s0,-72
  neg = 0;
 492:	86ce                	mv	a3,s3
  i = 0;
 494:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 496:	00000817          	auipc	a6,0x0
 49a:	57280813          	addi	a6,a6,1394 # a08 <digits>
 49e:	88ba                	mv	a7,a4
 4a0:	0017051b          	addiw	a0,a4,1
 4a4:	872a                	mv	a4,a0
 4a6:	02c5f7b3          	remu	a5,a1,a2
 4aa:	97c2                	add	a5,a5,a6
 4ac:	0007c783          	lbu	a5,0(a5)
 4b0:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 4b4:	87ae                	mv	a5,a1
 4b6:	02c5d5b3          	divu	a1,a1,a2
 4ba:	0685                	addi	a3,a3,1
 4bc:	fec7f1e3          	bgeu	a5,a2,49e <printint+0x32>
  if (neg)
 4c0:	00030b63          	beqz	t1,4d6 <printint+0x6a>
    buf[i++] = '-';
 4c4:	fd040793          	addi	a5,s0,-48
 4c8:	953e                	add	a0,a0,a5
 4ca:	02d00793          	li	a5,45
 4ce:	fef50423          	sb	a5,-24(a0)
 4d2:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 4d6:	02e05563          	blez	a4,500 <printint+0x94>
 4da:	fc26                	sd	s1,56(sp)
 4dc:	377d                	addiw	a4,a4,-1
 4de:	00e984b3          	add	s1,s3,a4
 4e2:	19fd                	addi	s3,s3,-1
 4e4:	99ba                	add	s3,s3,a4
 4e6:	1702                	slli	a4,a4,0x20
 4e8:	9301                	srli	a4,a4,0x20
 4ea:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ee:	0004c583          	lbu	a1,0(s1)
 4f2:	854a                	mv	a0,s2
 4f4:	f5bff0ef          	jal	44e <putc>
  while (--i >= 0)
 4f8:	14fd                	addi	s1,s1,-1
 4fa:	ff349ae3          	bne	s1,s3,4ee <printint+0x82>
 4fe:	74e2                	ld	s1,56(sp)
}
 500:	60a6                	ld	ra,72(sp)
 502:	6406                	ld	s0,64(sp)
 504:	7942                	ld	s2,48(sp)
 506:	79a2                	ld	s3,40(sp)
 508:	6161                	addi	sp,sp,80
 50a:	8082                	ret

000000000000050c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 50c:	711d                	addi	sp,sp,-96
 50e:	ec86                	sd	ra,88(sp)
 510:	e8a2                	sd	s0,80(sp)
 512:	e4a6                	sd	s1,72(sp)
 514:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 516:	0005c483          	lbu	s1,0(a1)
 51a:	2a048063          	beqz	s1,7ba <vprintf+0x2ae>
 51e:	e0ca                	sd	s2,64(sp)
 520:	fc4e                	sd	s3,56(sp)
 522:	f852                	sd	s4,48(sp)
 524:	f456                	sd	s5,40(sp)
 526:	f05a                	sd	s6,32(sp)
 528:	ec5e                	sd	s7,24(sp)
 52a:	e862                	sd	s8,16(sp)
 52c:	8b2a                	mv	s6,a0
 52e:	8a2e                	mv	s4,a1
 530:	8bb2                	mv	s7,a2
  state = 0;
 532:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 534:	4901                	li	s2,0
 536:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 538:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 53c:	06400c13          	li	s8,100
 540:	a00d                	j	562 <vprintf+0x56>
        putc(fd, c0);
 542:	85a6                	mv	a1,s1
 544:	855a                	mv	a0,s6
 546:	f09ff0ef          	jal	44e <putc>
 54a:	a019                	j	550 <vprintf+0x44>
    } else if (state == '%') {
 54c:	03598363          	beq	s3,s5,572 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 550:	0019079b          	addiw	a5,s2,1
 554:	893e                	mv	s2,a5
 556:	873e                	mv	a4,a5
 558:	97d2                	add	a5,a5,s4
 55a:	0007c483          	lbu	s1,0(a5)
 55e:	24048763          	beqz	s1,7ac <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 562:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 566:	fe0993e3          	bnez	s3,54c <vprintf+0x40>
      if (c0 == '%') {
 56a:	fd579ce3          	bne	a5,s5,542 <vprintf+0x36>
        state = '%';
 56e:	89be                	mv	s3,a5
 570:	b7c5                	j	550 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 572:	00ea06b3          	add	a3,s4,a4
 576:	0016c603          	lbu	a2,1(a3)
      if (c1)
 57a:	24060563          	beqz	a2,7c4 <vprintf+0x2b8>
      if (c0 == 'd') {
 57e:	0b878763          	beq	a5,s8,62c <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 582:	f9478693          	addi	a3,a5,-108
 586:	0016b693          	seqz	a3,a3
 58a:	f9c60593          	addi	a1,a2,-100
 58e:	0015b593          	seqz	a1,a1
 592:	8df5                	and	a1,a1,a3
 594:	e9c5                	bnez	a1,644 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 596:	9752                	add	a4,a4,s4
 598:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 59c:	f9460713          	addi	a4,a2,-108
 5a0:	00173713          	seqz	a4,a4
 5a4:	8f75                	and	a4,a4,a3
 5a6:	f9c50593          	addi	a1,a0,-100
 5aa:	0015b593          	seqz	a1,a1
 5ae:	8df9                	and	a1,a1,a4
 5b0:	e5dd                	bnez	a1,65e <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 5b2:	07500593          	li	a1,117
 5b6:	0cb78163          	beq	a5,a1,678 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 5ba:	f8b60593          	addi	a1,a2,-117
 5be:	0015b593          	seqz	a1,a1
 5c2:	8df5                	and	a1,a1,a3
 5c4:	e5f1                	bnez	a1,690 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 5c6:	f8b50593          	addi	a1,a0,-117
 5ca:	0015b593          	seqz	a1,a1
 5ce:	8df9                	and	a1,a1,a4
 5d0:	ede9                	bnez	a1,6aa <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 5d2:	07800593          	li	a1,120
 5d6:	0eb78763          	beq	a5,a1,6c4 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 5da:	f8860613          	addi	a2,a2,-120
 5de:	00163613          	seqz	a2,a2
 5e2:	8ef1                	and	a3,a3,a2
 5e4:	0e069c63          	bnez	a3,6dc <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 5e8:	f8850513          	addi	a0,a0,-120
 5ec:	00153513          	seqz	a0,a0
 5f0:	8f69                	and	a4,a4,a0
 5f2:	10071263          	bnez	a4,6f6 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 5f6:	07000713          	li	a4,112
 5fa:	10e78a63          	beq	a5,a4,70e <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 5fe:	06300713          	li	a4,99
 602:	14e78a63          	beq	a5,a4,756 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 606:	07300713          	li	a4,115
 60a:	16e78063          	beq	a5,a4,76a <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 60e:	02500713          	li	a4,37
 612:	18e78863          	beq	a5,a4,7a2 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 616:	02500593          	li	a1,37
 61a:	855a                	mv	a0,s6
 61c:	e33ff0ef          	jal	44e <putc>
        putc(fd, c0);
 620:	85a6                	mv	a1,s1
 622:	855a                	mv	a0,s6
 624:	e2bff0ef          	jal	44e <putc>
      }

      state = 0;
 628:	4981                	li	s3,0
 62a:	b71d                	j	550 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 62c:	008b8493          	addi	s1,s7,8
 630:	4685                	li	a3,1
 632:	4629                	li	a2,10
 634:	000ba583          	lw	a1,0(s7)
 638:	855a                	mv	a0,s6
 63a:	e33ff0ef          	jal	46c <printint>
 63e:	8ba6                	mv	s7,s1
      state = 0;
 640:	4981                	li	s3,0
 642:	b739                	j	550 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 644:	008b8493          	addi	s1,s7,8
 648:	4685                	li	a3,1
 64a:	4629                	li	a2,10
 64c:	000bb583          	ld	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	e1bff0ef          	jal	46c <printint>
        i += 1;
 656:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 658:	8ba6                	mv	s7,s1
      state = 0;
 65a:	4981                	li	s3,0
 65c:	bdd5                	j	550 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 65e:	008b8493          	addi	s1,s7,8
 662:	4685                	li	a3,1
 664:	4629                	li	a2,10
 666:	000bb583          	ld	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	e01ff0ef          	jal	46c <printint>
        i += 2;
 670:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 672:	8ba6                	mv	s7,s1
      state = 0;
 674:	4981                	li	s3,0
        i += 2;
 676:	bde9                	j	550 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 678:	008b8493          	addi	s1,s7,8
 67c:	4681                	li	a3,0
 67e:	4629                	li	a2,10
 680:	000be583          	lwu	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	de7ff0ef          	jal	46c <printint>
 68a:	8ba6                	mv	s7,s1
      state = 0;
 68c:	4981                	li	s3,0
 68e:	b5c9                	j	550 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 690:	008b8493          	addi	s1,s7,8
 694:	4681                	li	a3,0
 696:	4629                	li	a2,10
 698:	000bb583          	ld	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	dcfff0ef          	jal	46c <printint>
        i += 1;
 6a2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a4:	8ba6                	mv	s7,s1
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	b565                	j	550 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6aa:	008b8493          	addi	s1,s7,8
 6ae:	4681                	li	a3,0
 6b0:	4629                	li	a2,10
 6b2:	000bb583          	ld	a1,0(s7)
 6b6:	855a                	mv	a0,s6
 6b8:	db5ff0ef          	jal	46c <printint>
        i += 2;
 6bc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6be:	8ba6                	mv	s7,s1
      state = 0;
 6c0:	4981                	li	s3,0
        i += 2;
 6c2:	b579                	j	550 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6c4:	008b8493          	addi	s1,s7,8
 6c8:	4681                	li	a3,0
 6ca:	4641                	li	a2,16
 6cc:	000be583          	lwu	a1,0(s7)
 6d0:	855a                	mv	a0,s6
 6d2:	d9bff0ef          	jal	46c <printint>
 6d6:	8ba6                	mv	s7,s1
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	bd9d                	j	550 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6dc:	008b8493          	addi	s1,s7,8
 6e0:	4681                	li	a3,0
 6e2:	4641                	li	a2,16
 6e4:	000bb583          	ld	a1,0(s7)
 6e8:	855a                	mv	a0,s6
 6ea:	d83ff0ef          	jal	46c <printint>
        i += 1;
 6ee:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f0:	8ba6                	mv	s7,s1
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	bdb1                	j	550 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f6:	008b8493          	addi	s1,s7,8
 6fa:	4641                	li	a2,16
 6fc:	000bb583          	ld	a1,0(s7)
 700:	855a                	mv	a0,s6
 702:	d6bff0ef          	jal	46c <printint>
        i += 2;
 706:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 708:	8ba6                	mv	s7,s1
      state = 0;
 70a:	4981                	li	s3,0
        i += 2;
 70c:	b591                	j	550 <vprintf+0x44>
 70e:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 710:	008b8793          	addi	a5,s7,8
 714:	8cbe                	mv	s9,a5
 716:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 71a:	03000593          	li	a1,48
 71e:	855a                	mv	a0,s6
 720:	d2fff0ef          	jal	44e <putc>
  putc(fd, 'x');
 724:	07800593          	li	a1,120
 728:	855a                	mv	a0,s6
 72a:	d25ff0ef          	jal	44e <putc>
 72e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 730:	00000b97          	auipc	s7,0x0
 734:	2d8b8b93          	addi	s7,s7,728 # a08 <digits>
 738:	03c9d793          	srli	a5,s3,0x3c
 73c:	97de                	add	a5,a5,s7
 73e:	0007c583          	lbu	a1,0(a5)
 742:	855a                	mv	a0,s6
 744:	d0bff0ef          	jal	44e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 748:	0992                	slli	s3,s3,0x4
 74a:	34fd                	addiw	s1,s1,-1
 74c:	f4f5                	bnez	s1,738 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 74e:	8be6                	mv	s7,s9
      state = 0;
 750:	4981                	li	s3,0
 752:	6ca2                	ld	s9,8(sp)
 754:	bbf5                	j	550 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 756:	008b8493          	addi	s1,s7,8
 75a:	000bc583          	lbu	a1,0(s7)
 75e:	855a                	mv	a0,s6
 760:	cefff0ef          	jal	44e <putc>
 764:	8ba6                	mv	s7,s1
      state = 0;
 766:	4981                	li	s3,0
 768:	b3e5                	j	550 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 76a:	008b8993          	addi	s3,s7,8
 76e:	000bb483          	ld	s1,0(s7)
 772:	cc91                	beqz	s1,78e <vprintf+0x282>
        for (; *s; s++)
 774:	0004c583          	lbu	a1,0(s1)
 778:	c195                	beqz	a1,79c <vprintf+0x290>
          putc(fd, *s);
 77a:	855a                	mv	a0,s6
 77c:	cd3ff0ef          	jal	44e <putc>
        for (; *s; s++)
 780:	0485                	addi	s1,s1,1
 782:	0004c583          	lbu	a1,0(s1)
 786:	f9f5                	bnez	a1,77a <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 788:	8bce                	mv	s7,s3
      state = 0;
 78a:	4981                	li	s3,0
 78c:	b3d1                	j	550 <vprintf+0x44>
          s = "(null)";
 78e:	00000497          	auipc	s1,0x0
 792:	27248493          	addi	s1,s1,626 # a00 <malloc+0x140>
        for (; *s; s++)
 796:	02800593          	li	a1,40
 79a:	b7c5                	j	77a <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 79c:	8bce                	mv	s7,s3
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	bb45                	j	550 <vprintf+0x44>
        putc(fd, '%');
 7a2:	85be                	mv	a1,a5
 7a4:	855a                	mv	a0,s6
 7a6:	ca9ff0ef          	jal	44e <putc>
 7aa:	bdbd                	j	628 <vprintf+0x11c>
 7ac:	6906                	ld	s2,64(sp)
 7ae:	79e2                	ld	s3,56(sp)
 7b0:	7a42                	ld	s4,48(sp)
 7b2:	7aa2                	ld	s5,40(sp)
 7b4:	7b02                	ld	s6,32(sp)
 7b6:	6be2                	ld	s7,24(sp)
 7b8:	6c42                	ld	s8,16(sp)
    }
  }
}
 7ba:	60e6                	ld	ra,88(sp)
 7bc:	6446                	ld	s0,80(sp)
 7be:	64a6                	ld	s1,72(sp)
 7c0:	6125                	addi	sp,sp,96
 7c2:	8082                	ret
      if (c0 == 'd') {
 7c4:	06400713          	li	a4,100
 7c8:	e6e782e3          	beq	a5,a4,62c <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 7cc:	f9478693          	addi	a3,a5,-108
 7d0:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7d4:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 7d6:	4701                	li	a4,0
 7d8:	bbe9                	j	5b2 <vprintf+0xa6>

00000000000007da <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7da:	715d                	addi	sp,sp,-80
 7dc:	ec06                	sd	ra,24(sp)
 7de:	e822                	sd	s0,16(sp)
 7e0:	1000                	addi	s0,sp,32
 7e2:	e010                	sd	a2,0(s0)
 7e4:	e414                	sd	a3,8(s0)
 7e6:	e818                	sd	a4,16(s0)
 7e8:	ec1c                	sd	a5,24(s0)
 7ea:	03043023          	sd	a6,32(s0)
 7ee:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7f2:	8622                	mv	a2,s0
 7f4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7f8:	d15ff0ef          	jal	50c <vprintf>
}
 7fc:	60e2                	ld	ra,24(sp)
 7fe:	6442                	ld	s0,16(sp)
 800:	6161                	addi	sp,sp,80
 802:	8082                	ret

0000000000000804 <printf>:

void
printf(const char *fmt, ...)
{
 804:	711d                	addi	sp,sp,-96
 806:	ec06                	sd	ra,24(sp)
 808:	e822                	sd	s0,16(sp)
 80a:	1000                	addi	s0,sp,32
 80c:	e40c                	sd	a1,8(s0)
 80e:	e810                	sd	a2,16(s0)
 810:	ec14                	sd	a3,24(s0)
 812:	f018                	sd	a4,32(s0)
 814:	f41c                	sd	a5,40(s0)
 816:	03043823          	sd	a6,48(s0)
 81a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 81e:	00840613          	addi	a2,s0,8
 822:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 826:	85aa                	mv	a1,a0
 828:	4505                	li	a0,1
 82a:	ce3ff0ef          	jal	50c <vprintf>
}
 82e:	60e2                	ld	ra,24(sp)
 830:	6442                	ld	s0,16(sp)
 832:	6125                	addi	sp,sp,96
 834:	8082                	ret

0000000000000836 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 836:	1141                	addi	sp,sp,-16
 838:	e406                	sd	ra,8(sp)
 83a:	e022                	sd	s0,0(sp)
 83c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 83e:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 842:	00000797          	auipc	a5,0x0
 846:	7be7b783          	ld	a5,1982(a5) # 1000 <freep>
 84a:	a095                	j	8ae <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 84c:	ff852583          	lw	a1,-8(a0)
 850:	6390                	ld	a2,0(a5)
 852:	02059813          	slli	a6,a1,0x20
 856:	01c85693          	srli	a3,a6,0x1c
 85a:	96ba                	add	a3,a3,a4
 85c:	02d60563          	beq	a2,a3,886 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 860:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 864:	4790                	lw	a2,8(a5)
 866:	02061593          	slli	a1,a2,0x20
 86a:	01c5d693          	srli	a3,a1,0x1c
 86e:	96be                	add	a3,a3,a5
 870:	02d70263          	beq	a4,a3,894 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 874:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 876:	00000717          	auipc	a4,0x0
 87a:	78f73523          	sd	a5,1930(a4) # 1000 <freep>
}
 87e:	60a2                	ld	ra,8(sp)
 880:	6402                	ld	s0,0(sp)
 882:	0141                	addi	sp,sp,16
 884:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 886:	4614                	lw	a3,8(a2)
 888:	9ead                	addw	a3,a3,a1
 88a:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 88e:	6394                	ld	a3,0(a5)
 890:	6290                	ld	a2,0(a3)
 892:	b7f9                	j	860 <free+0x2a>
    p->s.size += bp->s.size;
 894:	ff852703          	lw	a4,-8(a0)
 898:	9f31                	addw	a4,a4,a2
 89a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 89c:	ff053703          	ld	a4,-16(a0)
 8a0:	bfd1                	j	874 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a2:	6394                	ld	a3,0(a5)
 8a4:	00d7e463          	bltu	a5,a3,8ac <free+0x76>
 8a8:	fad762e3          	bltu	a4,a3,84c <free+0x16>
 8ac:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ae:	fee7fae3          	bgeu	a5,a4,8a2 <free+0x6c>
 8b2:	6394                	ld	a3,0(a5)
 8b4:	f8d76ce3          	bltu	a4,a3,84c <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b8:	f8d7fae3          	bgeu	a5,a3,84c <free+0x16>
 8bc:	87b6                	mv	a5,a3
 8be:	bfc5                	j	8ae <free+0x78>

00000000000008c0 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 8c0:	7139                	addi	sp,sp,-64
 8c2:	fc06                	sd	ra,56(sp)
 8c4:	f822                	sd	s0,48(sp)
 8c6:	f04a                	sd	s2,32(sp)
 8c8:	ec4e                	sd	s3,24(sp)
 8ca:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8cc:	02051993          	slli	s3,a0,0x20
 8d0:	0209d993          	srli	s3,s3,0x20
 8d4:	09bd                	addi	s3,s3,15
 8d6:	0049d993          	srli	s3,s3,0x4
 8da:	2985                	addiw	s3,s3,1
 8dc:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 8de:	00000517          	auipc	a0,0x0
 8e2:	72253503          	ld	a0,1826(a0) # 1000 <freep>
 8e6:	c905                	beqz	a0,916 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8e8:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8ea:	4798                	lw	a4,8(a5)
 8ec:	09377663          	bgeu	a4,s3,978 <malloc+0xb8>
 8f0:	f426                	sd	s1,40(sp)
 8f2:	e852                	sd	s4,16(sp)
 8f4:	e456                	sd	s5,8(sp)
 8f6:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8f8:	8a4e                	mv	s4,s3
 8fa:	6705                	lui	a4,0x1
 8fc:	00e9f363          	bgeu	s3,a4,902 <malloc+0x42>
 900:	6a05                	lui	s4,0x1
 902:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 906:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 90a:	00000497          	auipc	s1,0x0
 90e:	6f648493          	addi	s1,s1,1782 # 1000 <freep>
  if (p == SBRK_ERROR)
 912:	5afd                	li	s5,-1
 914:	a83d                	j	952 <malloc+0x92>
 916:	f426                	sd	s1,40(sp)
 918:	e852                	sd	s4,16(sp)
 91a:	e456                	sd	s5,8(sp)
 91c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 91e:	00000797          	auipc	a5,0x0
 922:	6f278793          	addi	a5,a5,1778 # 1010 <base>
 926:	00000717          	auipc	a4,0x0
 92a:	6cf73d23          	sd	a5,1754(a4) # 1000 <freep>
 92e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 930:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 934:	b7d1                	j	8f8 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 936:	6398                	ld	a4,0(a5)
 938:	e118                	sd	a4,0(a0)
 93a:	a899                	j	990 <malloc+0xd0>
  hp->s.size = nu;
 93c:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 940:	0541                	addi	a0,a0,16
 942:	ef5ff0ef          	jal	836 <free>
  return freep;
 946:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 948:	c125                	beqz	a0,9a8 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 94a:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 94c:	4798                	lw	a4,8(a5)
 94e:	03277163          	bgeu	a4,s2,970 <malloc+0xb0>
    if (p == freep)
 952:	6098                	ld	a4,0(s1)
 954:	853e                	mv	a0,a5
 956:	fef71ae3          	bne	a4,a5,94a <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 95a:	8552                	mv	a0,s4
 95c:	a0fff0ef          	jal	36a <sbrk>
  if (p == SBRK_ERROR)
 960:	fd551ee3          	bne	a0,s5,93c <malloc+0x7c>
        return 0;
 964:	4501                	li	a0,0
 966:	74a2                	ld	s1,40(sp)
 968:	6a42                	ld	s4,16(sp)
 96a:	6aa2                	ld	s5,8(sp)
 96c:	6b02                	ld	s6,0(sp)
 96e:	a03d                	j	99c <malloc+0xdc>
 970:	74a2                	ld	s1,40(sp)
 972:	6a42                	ld	s4,16(sp)
 974:	6aa2                	ld	s5,8(sp)
 976:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 978:	fae90fe3          	beq	s2,a4,936 <malloc+0x76>
        p->s.size -= nunits;
 97c:	4137073b          	subw	a4,a4,s3
 980:	c798                	sw	a4,8(a5)
        p += p->s.size;
 982:	02071693          	slli	a3,a4,0x20
 986:	01c6d713          	srli	a4,a3,0x1c
 98a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 98c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 990:	00000717          	auipc	a4,0x0
 994:	66a73823          	sd	a0,1648(a4) # 1000 <freep>
      return (void *)(p + 1);
 998:	01078513          	addi	a0,a5,16
  }
}
 99c:	70e2                	ld	ra,56(sp)
 99e:	7442                	ld	s0,48(sp)
 9a0:	7902                	ld	s2,32(sp)
 9a2:	69e2                	ld	s3,24(sp)
 9a4:	6121                	addi	sp,sp,64
 9a6:	8082                	ret
 9a8:	74a2                	ld	s1,40(sp)
 9aa:	6a42                	ld	s4,16(sp)
 9ac:	6aa2                	ld	s5,8(sp)
 9ae:	6b02                	ld	s6,0(sp)
 9b0:	b7f5                	j	99c <malloc+0xdc>
