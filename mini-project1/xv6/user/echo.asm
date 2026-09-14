
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	e05a                	sd	s6,0(sp)
  12:	0080                	addi	s0,sp,64
  int i;

  for (i = 1; i < argc; i++) {
  14:	4785                	li	a5,1
  16:	06a7d063          	bge	a5,a0,76 <main+0x76>
  1a:	00858493          	addi	s1,a1,8
  1e:	3579                	addiw	a0,a0,-2
  20:	02051793          	slli	a5,a0,0x20
  24:	01d7d513          	srli	a0,a5,0x1d
  28:	00a48ab3          	add	s5,s1,a0
  2c:	05c1                	addi	a1,a1,16
  2e:	00a58a33          	add	s4,a1,a0
    write(1, argv[i], strlen(argv[i]));
  32:	4985                	li	s3,1
    if (i + 1 < argc) {
      write(1, " ", 1);
  34:	00001b17          	auipc	s6,0x1
  38:	91cb0b13          	addi	s6,s6,-1764 # 950 <malloc+0xfc>
  3c:	a809                	j	4e <main+0x4e>
  3e:	864e                	mv	a2,s3
  40:	85da                	mv	a1,s6
  42:	854e                	mv	a0,s3
  44:	30e000ef          	jal	352 <write>
  for (i = 1; i < argc; i++) {
  48:	04a1                	addi	s1,s1,8
  4a:	03448663          	beq	s1,s4,76 <main+0x76>
    write(1, argv[i], strlen(argv[i]));
  4e:	0004b903          	ld	s2,0(s1)
  52:	854a                	mv	a0,s2
  54:	088000ef          	jal	dc <strlen>
  58:	862a                	mv	a2,a0
  5a:	85ca                	mv	a1,s2
  5c:	854e                	mv	a0,s3
  5e:	2f4000ef          	jal	352 <write>
    if (i + 1 < argc) {
  62:	fd549ee3          	bne	s1,s5,3e <main+0x3e>
    } else {
      write(1, "\n", 1);
  66:	4605                	li	a2,1
  68:	00001597          	auipc	a1,0x1
  6c:	8f058593          	addi	a1,a1,-1808 # 958 <malloc+0x104>
  70:	8532                	mv	a0,a2
  72:	2e0000ef          	jal	352 <write>
    }
  }
  exit(0);
  76:	4501                	li	a0,0
  78:	2ba000ef          	jal	332 <exit>

000000000000007c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  7c:	1141                	addi	sp,sp,-16
  7e:	e406                	sd	ra,8(sp)
  80:	e022                	sd	s0,0(sp)
  82:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  84:	f7dff0ef          	jal	0 <main>
  exit(r);
  88:	2aa000ef          	jal	332 <exit>

000000000000008c <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e406                	sd	ra,8(sp)
  90:	e022                	sd	s0,0(sp)
  92:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  94:	87aa                	mv	a5,a0
  96:	0585                	addi	a1,a1,1
  98:	0785                	addi	a5,a5,1
  9a:	fff5c703          	lbu	a4,-1(a1)
  9e:	fee78fa3          	sb	a4,-1(a5)
  a2:	fb75                	bnez	a4,96 <strcpy+0xa>
    ;
  return os;
}
  a4:	60a2                	ld	ra,8(sp)
  a6:	6402                	ld	s0,0(sp)
  a8:	0141                	addi	sp,sp,16
  aa:	8082                	ret

00000000000000ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e406                	sd	ra,8(sp)
  b0:	e022                	sd	s0,0(sp)
  b2:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  b4:	00054783          	lbu	a5,0(a0)
  b8:	cb91                	beqz	a5,cc <strcmp+0x20>
  ba:	0005c703          	lbu	a4,0(a1)
  be:	00f71763          	bne	a4,a5,cc <strcmp+0x20>
    p++, q++;
  c2:	0505                	addi	a0,a0,1
  c4:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	fbe5                	bnez	a5,ba <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  cc:	0005c503          	lbu	a0,0(a1)
}
  d0:	40a7853b          	subw	a0,a5,a0
  d4:	60a2                	ld	ra,8(sp)
  d6:	6402                	ld	s0,0(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret

00000000000000dc <strlen>:

uint
strlen(const char *s)
{
  dc:	1141                	addi	sp,sp,-16
  de:	e406                	sd	ra,8(sp)
  e0:	e022                	sd	s0,0(sp)
  e2:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  e4:	00054783          	lbu	a5,0(a0)
  e8:	cf91                	beqz	a5,104 <strlen+0x28>
  ea:	00150793          	addi	a5,a0,1
  ee:	86be                	mv	a3,a5
  f0:	0785                	addi	a5,a5,1
  f2:	fff7c703          	lbu	a4,-1(a5)
  f6:	ff65                	bnez	a4,ee <strlen+0x12>
  f8:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  fc:	60a2                	ld	ra,8(sp)
  fe:	6402                	ld	s0,0(sp)
 100:	0141                	addi	sp,sp,16
 102:	8082                	ret
  for (n = 0; s[n]; n++)
 104:	4501                	li	a0,0
 106:	bfdd                	j	fc <strlen+0x20>

0000000000000108 <memset>:

void *
memset(void *dst, int c, uint n)
{
 108:	1141                	addi	sp,sp,-16
 10a:	e406                	sd	ra,8(sp)
 10c:	e022                	sd	s0,0(sp)
 10e:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 110:	ca19                	beqz	a2,126 <memset+0x1e>
 112:	87aa                	mv	a5,a0
 114:	1602                	slli	a2,a2,0x20
 116:	9201                	srli	a2,a2,0x20
 118:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 11c:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 120:	0785                	addi	a5,a5,1
 122:	fee79de3          	bne	a5,a4,11c <memset+0x14>
  }
  return dst;
}
 126:	60a2                	ld	ra,8(sp)
 128:	6402                	ld	s0,0(sp)
 12a:	0141                	addi	sp,sp,16
 12c:	8082                	ret

000000000000012e <strchr>:

char *
strchr(const char *s, char c)
{
 12e:	1141                	addi	sp,sp,-16
 130:	e406                	sd	ra,8(sp)
 132:	e022                	sd	s0,0(sp)
 134:	0800                	addi	s0,sp,16
  for (; *s; s++)
 136:	00054783          	lbu	a5,0(a0)
 13a:	c799                	beqz	a5,148 <strchr+0x1a>
    if (*s == c)
 13c:	00f58763          	beq	a1,a5,14a <strchr+0x1c>
  for (; *s; s++)
 140:	0505                	addi	a0,a0,1
 142:	00054783          	lbu	a5,0(a0)
 146:	fbfd                	bnez	a5,13c <strchr+0xe>
      return (char *)s;
  return 0;
 148:	4501                	li	a0,0
}
 14a:	60a2                	ld	ra,8(sp)
 14c:	6402                	ld	s0,0(sp)
 14e:	0141                	addi	sp,sp,16
 150:	8082                	ret

0000000000000152 <gets>:

char *
gets(char *buf, int max)
{
 152:	711d                	addi	sp,sp,-96
 154:	ec86                	sd	ra,88(sp)
 156:	e8a2                	sd	s0,80(sp)
 158:	e4a6                	sd	s1,72(sp)
 15a:	e0ca                	sd	s2,64(sp)
 15c:	fc4e                	sd	s3,56(sp)
 15e:	f852                	sd	s4,48(sp)
 160:	f456                	sd	s5,40(sp)
 162:	f05a                	sd	s6,32(sp)
 164:	ec5e                	sd	s7,24(sp)
 166:	e862                	sd	s8,16(sp)
 168:	1080                	addi	s0,sp,96
 16a:	8baa                	mv	s7,a0
 16c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 16e:	892a                	mv	s2,a0
 170:	4481                	li	s1,0
    cc = read(0, &c, 1);
 172:	faf40b13          	addi	s6,s0,-81
 176:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 178:	8c26                	mv	s8,s1
 17a:	0014899b          	addiw	s3,s1,1
 17e:	84ce                	mv	s1,s3
 180:	0349d863          	bge	s3,s4,1b0 <gets+0x5e>
    cc = read(0, &c, 1);
 184:	8656                	mv	a2,s5
 186:	85da                	mv	a1,s6
 188:	4501                	li	a0,0
 18a:	1c0000ef          	jal	34a <read>
    if (cc < 1)
 18e:	02a05163          	blez	a0,1b0 <gets+0x5e>
      break;
    buf[i++] = c;
 192:	faf44783          	lbu	a5,-81(s0)
 196:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 19a:	0905                	addi	s2,s2,1
 19c:	ff678713          	addi	a4,a5,-10
 1a0:	00173713          	seqz	a4,a4
 1a4:	17cd                	addi	a5,a5,-13
 1a6:	0017b793          	seqz	a5,a5
 1aa:	8fd9                	or	a5,a5,a4
 1ac:	d7f1                	beqz	a5,178 <gets+0x26>
    buf[i++] = c;
 1ae:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1b0:	9c5e                	add	s8,s8,s7
 1b2:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1b6:	855e                	mv	a0,s7
 1b8:	60e6                	ld	ra,88(sp)
 1ba:	6446                	ld	s0,80(sp)
 1bc:	64a6                	ld	s1,72(sp)
 1be:	6906                	ld	s2,64(sp)
 1c0:	79e2                	ld	s3,56(sp)
 1c2:	7a42                	ld	s4,48(sp)
 1c4:	7aa2                	ld	s5,40(sp)
 1c6:	7b02                	ld	s6,32(sp)
 1c8:	6be2                	ld	s7,24(sp)
 1ca:	6c42                	ld	s8,16(sp)
 1cc:	6125                	addi	sp,sp,96
 1ce:	8082                	ret

00000000000001d0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d0:	1101                	addi	sp,sp,-32
 1d2:	ec06                	sd	ra,24(sp)
 1d4:	e822                	sd	s0,16(sp)
 1d6:	e04a                	sd	s2,0(sp)
 1d8:	1000                	addi	s0,sp,32
 1da:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1dc:	4581                	li	a1,0
 1de:	194000ef          	jal	372 <open>
  if (fd < 0)
 1e2:	02054263          	bltz	a0,206 <stat+0x36>
 1e6:	e426                	sd	s1,8(sp)
 1e8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ea:	85ca                	mv	a1,s2
 1ec:	19e000ef          	jal	38a <fstat>
 1f0:	892a                	mv	s2,a0
  close(fd);
 1f2:	8526                	mv	a0,s1
 1f4:	166000ef          	jal	35a <close>
  return r;
 1f8:	64a2                	ld	s1,8(sp)
}
 1fa:	854a                	mv	a0,s2
 1fc:	60e2                	ld	ra,24(sp)
 1fe:	6442                	ld	s0,16(sp)
 200:	6902                	ld	s2,0(sp)
 202:	6105                	addi	sp,sp,32
 204:	8082                	ret
    return -1;
 206:	57fd                	li	a5,-1
 208:	893e                	mv	s2,a5
 20a:	bfc5                	j	1fa <stat+0x2a>

000000000000020c <atoi>:

int
atoi(const char *s)
{
 20c:	1141                	addi	sp,sp,-16
 20e:	e406                	sd	ra,8(sp)
 210:	e022                	sd	s0,0(sp)
 212:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 214:	00054683          	lbu	a3,0(a0)
 218:	fd06879b          	addiw	a5,a3,-48
 21c:	0ff7f793          	zext.b	a5,a5
 220:	4625                	li	a2,9
 222:	02f66963          	bltu	a2,a5,254 <atoi+0x48>
 226:	872a                	mv	a4,a0
  n = 0;
 228:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 22a:	0705                	addi	a4,a4,1
 22c:	0025179b          	slliw	a5,a0,0x2
 230:	9fa9                	addw	a5,a5,a0
 232:	0017979b          	slliw	a5,a5,0x1
 236:	9fb5                	addw	a5,a5,a3
 238:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 23c:	00074683          	lbu	a3,0(a4)
 240:	fd06879b          	addiw	a5,a3,-48
 244:	0ff7f793          	zext.b	a5,a5
 248:	fef671e3          	bgeu	a2,a5,22a <atoi+0x1e>
  return n;
}
 24c:	60a2                	ld	ra,8(sp)
 24e:	6402                	ld	s0,0(sp)
 250:	0141                	addi	sp,sp,16
 252:	8082                	ret
  n = 0;
 254:	4501                	li	a0,0
 256:	bfdd                	j	24c <atoi+0x40>

0000000000000258 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 258:	1141                	addi	sp,sp,-16
 25a:	e406                	sd	ra,8(sp)
 25c:	e022                	sd	s0,0(sp)
 25e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 260:	02b57563          	bgeu	a0,a1,28a <memmove+0x32>
    while (n-- > 0)
 264:	00c05f63          	blez	a2,282 <memmove+0x2a>
 268:	1602                	slli	a2,a2,0x20
 26a:	9201                	srli	a2,a2,0x20
 26c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 270:	872a                	mv	a4,a0
      *dst++ = *src++;
 272:	0585                	addi	a1,a1,1
 274:	0705                	addi	a4,a4,1
 276:	fff5c683          	lbu	a3,-1(a1)
 27a:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 27e:	fee79ae3          	bne	a5,a4,272 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 282:	60a2                	ld	ra,8(sp)
 284:	6402                	ld	s0,0(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret
    while (n-- > 0)
 28a:	fec05ce3          	blez	a2,282 <memmove+0x2a>
    dst += n;
 28e:	00c50733          	add	a4,a0,a2
    src += n;
 292:	95b2                	add	a1,a1,a2
 294:	fff6079b          	addiw	a5,a2,-1
 298:	1782                	slli	a5,a5,0x20
 29a:	9381                	srli	a5,a5,0x20
 29c:	fff7c793          	not	a5,a5
 2a0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2a2:	15fd                	addi	a1,a1,-1
 2a4:	177d                	addi	a4,a4,-1
 2a6:	0005c683          	lbu	a3,0(a1)
 2aa:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 2ae:	fef71ae3          	bne	a4,a5,2a2 <memmove+0x4a>
 2b2:	bfc1                	j	282 <memmove+0x2a>

00000000000002b4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e406                	sd	ra,8(sp)
 2b8:	e022                	sd	s0,0(sp)
 2ba:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2bc:	ce19                	beqz	a2,2da <memcmp+0x26>
 2be:	1602                	slli	a2,a2,0x20
 2c0:	9201                	srli	a2,a2,0x20
 2c2:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2c6:	00054783          	lbu	a5,0(a0)
 2ca:	0005c703          	lbu	a4,0(a1)
 2ce:	00e79b63          	bne	a5,a4,2e4 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 2d2:	0505                	addi	a0,a0,1
    p2++;
 2d4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d6:	fed518e3          	bne	a0,a3,2c6 <memcmp+0x12>
  }
  return 0;
 2da:	4501                	li	a0,0
}
 2dc:	60a2                	ld	ra,8(sp)
 2de:	6402                	ld	s0,0(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret
      return *p1 - *p2;
 2e4:	40e7853b          	subw	a0,a5,a4
 2e8:	bfd5                	j	2dc <memcmp+0x28>

00000000000002ea <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f2:	f67ff0ef          	jal	258 <memmove>
}
 2f6:	60a2                	ld	ra,8(sp)
 2f8:	6402                	ld	s0,0(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret

00000000000002fe <sbrk>:

char *
sbrk(int n)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e406                	sd	ra,8(sp)
 302:	e022                	sd	s0,0(sp)
 304:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 306:	4585                	li	a1,1
 308:	0b2000ef          	jal	3ba <sys_sbrk>
}
 30c:	60a2                	ld	ra,8(sp)
 30e:	6402                	ld	s0,0(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret

0000000000000314 <sbrklazy>:

char *
sbrklazy(int n)
{
 314:	1141                	addi	sp,sp,-16
 316:	e406                	sd	ra,8(sp)
 318:	e022                	sd	s0,0(sp)
 31a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 31c:	4589                	li	a1,2
 31e:	09c000ef          	jal	3ba <sys_sbrk>
}
 322:	60a2                	ld	ra,8(sp)
 324:	6402                	ld	s0,0(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret

000000000000032a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 32a:	4885                	li	a7,1
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <exit>:
.global exit
exit:
 li a7, SYS_exit
 332:	4889                	li	a7,2
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <wait>:
.global wait
wait:
 li a7, SYS_wait
 33a:	488d                	li	a7,3
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 342:	4891                	li	a7,4
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <read>:
.global read
read:
 li a7, SYS_read
 34a:	4895                	li	a7,5
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <write>:
.global write
write:
 li a7, SYS_write
 352:	48c1                	li	a7,16
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <close>:
.global close
close:
 li a7, SYS_close
 35a:	48d5                	li	a7,21
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <kill>:
.global kill
kill:
 li a7, SYS_kill
 362:	4899                	li	a7,6
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <exec>:
.global exec
exec:
 li a7, SYS_exec
 36a:	489d                	li	a7,7
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <open>:
.global open
open:
 li a7, SYS_open
 372:	48bd                	li	a7,15
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 37a:	48c5                	li	a7,17
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 382:	48c9                	li	a7,18
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 38a:	48a1                	li	a7,8
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <link>:
.global link
link:
 li a7, SYS_link
 392:	48cd                	li	a7,19
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 39a:	48d1                	li	a7,20
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3a2:	48a5                	li	a7,9
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <dup>:
.global dup
dup:
 li a7, SYS_dup
 3aa:	48a9                	li	a7,10
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3b2:	48ad                	li	a7,11
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3ba:	48b1                	li	a7,12
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3c2:	48b5                	li	a7,13
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ca:	48b9                	li	a7,14
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <sync>:
.global sync
sync:
 li a7, SYS_sync
 3d2:	48d9                	li	a7,22
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3da:	48dd                	li	a7,23
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e2:	1101                	addi	sp,sp,-32
 3e4:	ec06                	sd	ra,24(sp)
 3e6:	e822                	sd	s0,16(sp)
 3e8:	1000                	addi	s0,sp,32
 3ea:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ee:	4605                	li	a2,1
 3f0:	fef40593          	addi	a1,s0,-17
 3f4:	f5fff0ef          	jal	352 <write>
}
 3f8:	60e2                	ld	ra,24(sp)
 3fa:	6442                	ld	s0,16(sp)
 3fc:	6105                	addi	sp,sp,32
 3fe:	8082                	ret

0000000000000400 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 400:	715d                	addi	sp,sp,-80
 402:	e486                	sd	ra,72(sp)
 404:	e0a2                	sd	s0,64(sp)
 406:	f84a                	sd	s2,48(sp)
 408:	f44e                	sd	s3,40(sp)
 40a:	0880                	addi	s0,sp,80
 40c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 40e:	00d036b3          	snez	a3,a3
 412:	03f5d793          	srli	a5,a1,0x3f
 416:	8efd                	and	a3,a3,a5
  neg = 0;
 418:	4301                	li	t1,0
  if (sgn && xx < 0) {
 41a:	c681                	beqz	a3,422 <printint+0x22>
    neg = 1;
    x = -xx;
 41c:	40b005b3          	neg	a1,a1
    neg = 1;
 420:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 422:	fb840993          	addi	s3,s0,-72
  neg = 0;
 426:	86ce                	mv	a3,s3
  i = 0;
 428:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 42a:	00000817          	auipc	a6,0x0
 42e:	53e80813          	addi	a6,a6,1342 # 968 <digits>
 432:	88ba                	mv	a7,a4
 434:	0017051b          	addiw	a0,a4,1
 438:	872a                	mv	a4,a0
 43a:	02c5f7b3          	remu	a5,a1,a2
 43e:	97c2                	add	a5,a5,a6
 440:	0007c783          	lbu	a5,0(a5)
 444:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 448:	87ae                	mv	a5,a1
 44a:	02c5d5b3          	divu	a1,a1,a2
 44e:	0685                	addi	a3,a3,1
 450:	fec7f1e3          	bgeu	a5,a2,432 <printint+0x32>
  if (neg)
 454:	00030b63          	beqz	t1,46a <printint+0x6a>
    buf[i++] = '-';
 458:	fd040793          	addi	a5,s0,-48
 45c:	953e                	add	a0,a0,a5
 45e:	02d00793          	li	a5,45
 462:	fef50423          	sb	a5,-24(a0)
 466:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 46a:	02e05563          	blez	a4,494 <printint+0x94>
 46e:	fc26                	sd	s1,56(sp)
 470:	377d                	addiw	a4,a4,-1
 472:	00e984b3          	add	s1,s3,a4
 476:	19fd                	addi	s3,s3,-1
 478:	99ba                	add	s3,s3,a4
 47a:	1702                	slli	a4,a4,0x20
 47c:	9301                	srli	a4,a4,0x20
 47e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 482:	0004c583          	lbu	a1,0(s1)
 486:	854a                	mv	a0,s2
 488:	f5bff0ef          	jal	3e2 <putc>
  while (--i >= 0)
 48c:	14fd                	addi	s1,s1,-1
 48e:	ff349ae3          	bne	s1,s3,482 <printint+0x82>
 492:	74e2                	ld	s1,56(sp)
}
 494:	60a6                	ld	ra,72(sp)
 496:	6406                	ld	s0,64(sp)
 498:	7942                	ld	s2,48(sp)
 49a:	79a2                	ld	s3,40(sp)
 49c:	6161                	addi	sp,sp,80
 49e:	8082                	ret

00000000000004a0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4a0:	711d                	addi	sp,sp,-96
 4a2:	ec86                	sd	ra,88(sp)
 4a4:	e8a2                	sd	s0,80(sp)
 4a6:	e4a6                	sd	s1,72(sp)
 4a8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4aa:	0005c483          	lbu	s1,0(a1)
 4ae:	2a048063          	beqz	s1,74e <vprintf+0x2ae>
 4b2:	e0ca                	sd	s2,64(sp)
 4b4:	fc4e                	sd	s3,56(sp)
 4b6:	f852                	sd	s4,48(sp)
 4b8:	f456                	sd	s5,40(sp)
 4ba:	f05a                	sd	s6,32(sp)
 4bc:	ec5e                	sd	s7,24(sp)
 4be:	e862                	sd	s8,16(sp)
 4c0:	8b2a                	mv	s6,a0
 4c2:	8a2e                	mv	s4,a1
 4c4:	8bb2                	mv	s7,a2
  state = 0;
 4c6:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 4c8:	4901                	li	s2,0
 4ca:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 4cc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4d0:	06400c13          	li	s8,100
 4d4:	a00d                	j	4f6 <vprintf+0x56>
        putc(fd, c0);
 4d6:	85a6                	mv	a1,s1
 4d8:	855a                	mv	a0,s6
 4da:	f09ff0ef          	jal	3e2 <putc>
 4de:	a019                	j	4e4 <vprintf+0x44>
    } else if (state == '%') {
 4e0:	03598363          	beq	s3,s5,506 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 4e4:	0019079b          	addiw	a5,s2,1
 4e8:	893e                	mv	s2,a5
 4ea:	873e                	mv	a4,a5
 4ec:	97d2                	add	a5,a5,s4
 4ee:	0007c483          	lbu	s1,0(a5)
 4f2:	24048763          	beqz	s1,740 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 4f6:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4fa:	fe0993e3          	bnez	s3,4e0 <vprintf+0x40>
      if (c0 == '%') {
 4fe:	fd579ce3          	bne	a5,s5,4d6 <vprintf+0x36>
        state = '%';
 502:	89be                	mv	s3,a5
 504:	b7c5                	j	4e4 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 506:	00ea06b3          	add	a3,s4,a4
 50a:	0016c603          	lbu	a2,1(a3)
      if (c1)
 50e:	24060563          	beqz	a2,758 <vprintf+0x2b8>
      if (c0 == 'd') {
 512:	0b878763          	beq	a5,s8,5c0 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 516:	f9478693          	addi	a3,a5,-108
 51a:	0016b693          	seqz	a3,a3
 51e:	f9c60593          	addi	a1,a2,-100
 522:	0015b593          	seqz	a1,a1
 526:	8df5                	and	a1,a1,a3
 528:	e9c5                	bnez	a1,5d8 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 52a:	9752                	add	a4,a4,s4
 52c:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 530:	f9460713          	addi	a4,a2,-108
 534:	00173713          	seqz	a4,a4
 538:	8f75                	and	a4,a4,a3
 53a:	f9c50593          	addi	a1,a0,-100
 53e:	0015b593          	seqz	a1,a1
 542:	8df9                	and	a1,a1,a4
 544:	e5dd                	bnez	a1,5f2 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 546:	07500593          	li	a1,117
 54a:	0cb78163          	beq	a5,a1,60c <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 54e:	f8b60593          	addi	a1,a2,-117
 552:	0015b593          	seqz	a1,a1
 556:	8df5                	and	a1,a1,a3
 558:	e5f1                	bnez	a1,624 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 55a:	f8b50593          	addi	a1,a0,-117
 55e:	0015b593          	seqz	a1,a1
 562:	8df9                	and	a1,a1,a4
 564:	ede9                	bnez	a1,63e <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 566:	07800593          	li	a1,120
 56a:	0eb78763          	beq	a5,a1,658 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 56e:	f8860613          	addi	a2,a2,-120
 572:	00163613          	seqz	a2,a2
 576:	8ef1                	and	a3,a3,a2
 578:	0e069c63          	bnez	a3,670 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 57c:	f8850513          	addi	a0,a0,-120
 580:	00153513          	seqz	a0,a0
 584:	8f69                	and	a4,a4,a0
 586:	10071263          	bnez	a4,68a <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 58a:	07000713          	li	a4,112
 58e:	10e78a63          	beq	a5,a4,6a2 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 592:	06300713          	li	a4,99
 596:	14e78a63          	beq	a5,a4,6ea <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 59a:	07300713          	li	a4,115
 59e:	16e78063          	beq	a5,a4,6fe <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 5a2:	02500713          	li	a4,37
 5a6:	18e78863          	beq	a5,a4,736 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5aa:	02500593          	li	a1,37
 5ae:	855a                	mv	a0,s6
 5b0:	e33ff0ef          	jal	3e2 <putc>
        putc(fd, c0);
 5b4:	85a6                	mv	a1,s1
 5b6:	855a                	mv	a0,s6
 5b8:	e2bff0ef          	jal	3e2 <putc>
      }

      state = 0;
 5bc:	4981                	li	s3,0
 5be:	b71d                	j	4e4 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5c0:	008b8493          	addi	s1,s7,8
 5c4:	4685                	li	a3,1
 5c6:	4629                	li	a2,10
 5c8:	000ba583          	lw	a1,0(s7)
 5cc:	855a                	mv	a0,s6
 5ce:	e33ff0ef          	jal	400 <printint>
 5d2:	8ba6                	mv	s7,s1
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	b739                	j	4e4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d8:	008b8493          	addi	s1,s7,8
 5dc:	4685                	li	a3,1
 5de:	4629                	li	a2,10
 5e0:	000bb583          	ld	a1,0(s7)
 5e4:	855a                	mv	a0,s6
 5e6:	e1bff0ef          	jal	400 <printint>
        i += 1;
 5ea:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ec:	8ba6                	mv	s7,s1
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	bdd5                	j	4e4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f2:	008b8493          	addi	s1,s7,8
 5f6:	4685                	li	a3,1
 5f8:	4629                	li	a2,10
 5fa:	000bb583          	ld	a1,0(s7)
 5fe:	855a                	mv	a0,s6
 600:	e01ff0ef          	jal	400 <printint>
        i += 2;
 604:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 606:	8ba6                	mv	s7,s1
      state = 0;
 608:	4981                	li	s3,0
        i += 2;
 60a:	bde9                	j	4e4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 60c:	008b8493          	addi	s1,s7,8
 610:	4681                	li	a3,0
 612:	4629                	li	a2,10
 614:	000be583          	lwu	a1,0(s7)
 618:	855a                	mv	a0,s6
 61a:	de7ff0ef          	jal	400 <printint>
 61e:	8ba6                	mv	s7,s1
      state = 0;
 620:	4981                	li	s3,0
 622:	b5c9                	j	4e4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 624:	008b8493          	addi	s1,s7,8
 628:	4681                	li	a3,0
 62a:	4629                	li	a2,10
 62c:	000bb583          	ld	a1,0(s7)
 630:	855a                	mv	a0,s6
 632:	dcfff0ef          	jal	400 <printint>
        i += 1;
 636:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 638:	8ba6                	mv	s7,s1
      state = 0;
 63a:	4981                	li	s3,0
 63c:	b565                	j	4e4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63e:	008b8493          	addi	s1,s7,8
 642:	4681                	li	a3,0
 644:	4629                	li	a2,10
 646:	000bb583          	ld	a1,0(s7)
 64a:	855a                	mv	a0,s6
 64c:	db5ff0ef          	jal	400 <printint>
        i += 2;
 650:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 652:	8ba6                	mv	s7,s1
      state = 0;
 654:	4981                	li	s3,0
        i += 2;
 656:	b579                	j	4e4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 658:	008b8493          	addi	s1,s7,8
 65c:	4681                	li	a3,0
 65e:	4641                	li	a2,16
 660:	000be583          	lwu	a1,0(s7)
 664:	855a                	mv	a0,s6
 666:	d9bff0ef          	jal	400 <printint>
 66a:	8ba6                	mv	s7,s1
      state = 0;
 66c:	4981                	li	s3,0
 66e:	bd9d                	j	4e4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 670:	008b8493          	addi	s1,s7,8
 674:	4681                	li	a3,0
 676:	4641                	li	a2,16
 678:	000bb583          	ld	a1,0(s7)
 67c:	855a                	mv	a0,s6
 67e:	d83ff0ef          	jal	400 <printint>
        i += 1;
 682:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 684:	8ba6                	mv	s7,s1
      state = 0;
 686:	4981                	li	s3,0
 688:	bdb1                	j	4e4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 68a:	008b8493          	addi	s1,s7,8
 68e:	4641                	li	a2,16
 690:	000bb583          	ld	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	d6bff0ef          	jal	400 <printint>
        i += 2;
 69a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 69c:	8ba6                	mv	s7,s1
      state = 0;
 69e:	4981                	li	s3,0
        i += 2;
 6a0:	b591                	j	4e4 <vprintf+0x44>
 6a2:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6a4:	008b8793          	addi	a5,s7,8
 6a8:	8cbe                	mv	s9,a5
 6aa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ae:	03000593          	li	a1,48
 6b2:	855a                	mv	a0,s6
 6b4:	d2fff0ef          	jal	3e2 <putc>
  putc(fd, 'x');
 6b8:	07800593          	li	a1,120
 6bc:	855a                	mv	a0,s6
 6be:	d25ff0ef          	jal	3e2 <putc>
 6c2:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c4:	00000b97          	auipc	s7,0x0
 6c8:	2a4b8b93          	addi	s7,s7,676 # 968 <digits>
 6cc:	03c9d793          	srli	a5,s3,0x3c
 6d0:	97de                	add	a5,a5,s7
 6d2:	0007c583          	lbu	a1,0(a5)
 6d6:	855a                	mv	a0,s6
 6d8:	d0bff0ef          	jal	3e2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6dc:	0992                	slli	s3,s3,0x4
 6de:	34fd                	addiw	s1,s1,-1
 6e0:	f4f5                	bnez	s1,6cc <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 6e2:	8be6                	mv	s7,s9
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	6ca2                	ld	s9,8(sp)
 6e8:	bbf5                	j	4e4 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6ea:	008b8493          	addi	s1,s7,8
 6ee:	000bc583          	lbu	a1,0(s7)
 6f2:	855a                	mv	a0,s6
 6f4:	cefff0ef          	jal	3e2 <putc>
 6f8:	8ba6                	mv	s7,s1
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	b3e5                	j	4e4 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6fe:	008b8993          	addi	s3,s7,8
 702:	000bb483          	ld	s1,0(s7)
 706:	cc91                	beqz	s1,722 <vprintf+0x282>
        for (; *s; s++)
 708:	0004c583          	lbu	a1,0(s1)
 70c:	c195                	beqz	a1,730 <vprintf+0x290>
          putc(fd, *s);
 70e:	855a                	mv	a0,s6
 710:	cd3ff0ef          	jal	3e2 <putc>
        for (; *s; s++)
 714:	0485                	addi	s1,s1,1
 716:	0004c583          	lbu	a1,0(s1)
 71a:	f9f5                	bnez	a1,70e <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 71c:	8bce                	mv	s7,s3
      state = 0;
 71e:	4981                	li	s3,0
 720:	b3d1                	j	4e4 <vprintf+0x44>
          s = "(null)";
 722:	00000497          	auipc	s1,0x0
 726:	23e48493          	addi	s1,s1,574 # 960 <malloc+0x10c>
        for (; *s; s++)
 72a:	02800593          	li	a1,40
 72e:	b7c5                	j	70e <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 730:	8bce                	mv	s7,s3
      state = 0;
 732:	4981                	li	s3,0
 734:	bb45                	j	4e4 <vprintf+0x44>
        putc(fd, '%');
 736:	85be                	mv	a1,a5
 738:	855a                	mv	a0,s6
 73a:	ca9ff0ef          	jal	3e2 <putc>
 73e:	bdbd                	j	5bc <vprintf+0x11c>
 740:	6906                	ld	s2,64(sp)
 742:	79e2                	ld	s3,56(sp)
 744:	7a42                	ld	s4,48(sp)
 746:	7aa2                	ld	s5,40(sp)
 748:	7b02                	ld	s6,32(sp)
 74a:	6be2                	ld	s7,24(sp)
 74c:	6c42                	ld	s8,16(sp)
    }
  }
}
 74e:	60e6                	ld	ra,88(sp)
 750:	6446                	ld	s0,80(sp)
 752:	64a6                	ld	s1,72(sp)
 754:	6125                	addi	sp,sp,96
 756:	8082                	ret
      if (c0 == 'd') {
 758:	06400713          	li	a4,100
 75c:	e6e782e3          	beq	a5,a4,5c0 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 760:	f9478693          	addi	a3,a5,-108
 764:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 768:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 76a:	4701                	li	a4,0
 76c:	bbe9                	j	546 <vprintf+0xa6>

000000000000076e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 76e:	715d                	addi	sp,sp,-80
 770:	ec06                	sd	ra,24(sp)
 772:	e822                	sd	s0,16(sp)
 774:	1000                	addi	s0,sp,32
 776:	e010                	sd	a2,0(s0)
 778:	e414                	sd	a3,8(s0)
 77a:	e818                	sd	a4,16(s0)
 77c:	ec1c                	sd	a5,24(s0)
 77e:	03043023          	sd	a6,32(s0)
 782:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 786:	8622                	mv	a2,s0
 788:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 78c:	d15ff0ef          	jal	4a0 <vprintf>
}
 790:	60e2                	ld	ra,24(sp)
 792:	6442                	ld	s0,16(sp)
 794:	6161                	addi	sp,sp,80
 796:	8082                	ret

0000000000000798 <printf>:

void
printf(const char *fmt, ...)
{
 798:	711d                	addi	sp,sp,-96
 79a:	ec06                	sd	ra,24(sp)
 79c:	e822                	sd	s0,16(sp)
 79e:	1000                	addi	s0,sp,32
 7a0:	e40c                	sd	a1,8(s0)
 7a2:	e810                	sd	a2,16(s0)
 7a4:	ec14                	sd	a3,24(s0)
 7a6:	f018                	sd	a4,32(s0)
 7a8:	f41c                	sd	a5,40(s0)
 7aa:	03043823          	sd	a6,48(s0)
 7ae:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7b2:	00840613          	addi	a2,s0,8
 7b6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ba:	85aa                	mv	a1,a0
 7bc:	4505                	li	a0,1
 7be:	ce3ff0ef          	jal	4a0 <vprintf>
}
 7c2:	60e2                	ld	ra,24(sp)
 7c4:	6442                	ld	s0,16(sp)
 7c6:	6125                	addi	sp,sp,96
 7c8:	8082                	ret

00000000000007ca <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ca:	1141                	addi	sp,sp,-16
 7cc:	e406                	sd	ra,8(sp)
 7ce:	e022                	sd	s0,0(sp)
 7d0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7d2:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d6:	00001797          	auipc	a5,0x1
 7da:	82a7b783          	ld	a5,-2006(a5) # 1000 <freep>
 7de:	a095                	j	842 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 7e0:	ff852583          	lw	a1,-8(a0)
 7e4:	6390                	ld	a2,0(a5)
 7e6:	02059813          	slli	a6,a1,0x20
 7ea:	01c85693          	srli	a3,a6,0x1c
 7ee:	96ba                	add	a3,a3,a4
 7f0:	02d60563          	beq	a2,a3,81a <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7f4:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 7f8:	4790                	lw	a2,8(a5)
 7fa:	02061593          	slli	a1,a2,0x20
 7fe:	01c5d693          	srli	a3,a1,0x1c
 802:	96be                	add	a3,a3,a5
 804:	02d70263          	beq	a4,a3,828 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 808:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 80a:	00000717          	auipc	a4,0x0
 80e:	7ef73b23          	sd	a5,2038(a4) # 1000 <freep>
}
 812:	60a2                	ld	ra,8(sp)
 814:	6402                	ld	s0,0(sp)
 816:	0141                	addi	sp,sp,16
 818:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 81a:	4614                	lw	a3,8(a2)
 81c:	9ead                	addw	a3,a3,a1
 81e:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 822:	6394                	ld	a3,0(a5)
 824:	6290                	ld	a2,0(a3)
 826:	b7f9                	j	7f4 <free+0x2a>
    p->s.size += bp->s.size;
 828:	ff852703          	lw	a4,-8(a0)
 82c:	9f31                	addw	a4,a4,a2
 82e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 830:	ff053703          	ld	a4,-16(a0)
 834:	bfd1                	j	808 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 836:	6394                	ld	a3,0(a5)
 838:	00d7e463          	bltu	a5,a3,840 <free+0x76>
 83c:	fad762e3          	bltu	a4,a3,7e0 <free+0x16>
 840:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 842:	fee7fae3          	bgeu	a5,a4,836 <free+0x6c>
 846:	6394                	ld	a3,0(a5)
 848:	f8d76ce3          	bltu	a4,a3,7e0 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84c:	f8d7fae3          	bgeu	a5,a3,7e0 <free+0x16>
 850:	87b6                	mv	a5,a3
 852:	bfc5                	j	842 <free+0x78>

0000000000000854 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 854:	7139                	addi	sp,sp,-64
 856:	fc06                	sd	ra,56(sp)
 858:	f822                	sd	s0,48(sp)
 85a:	f04a                	sd	s2,32(sp)
 85c:	ec4e                	sd	s3,24(sp)
 85e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 860:	02051993          	slli	s3,a0,0x20
 864:	0209d993          	srli	s3,s3,0x20
 868:	09bd                	addi	s3,s3,15
 86a:	0049d993          	srli	s3,s3,0x4
 86e:	2985                	addiw	s3,s3,1
 870:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 872:	00000517          	auipc	a0,0x0
 876:	78e53503          	ld	a0,1934(a0) # 1000 <freep>
 87a:	c905                	beqz	a0,8aa <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 87c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 87e:	4798                	lw	a4,8(a5)
 880:	09377663          	bgeu	a4,s3,90c <malloc+0xb8>
 884:	f426                	sd	s1,40(sp)
 886:	e852                	sd	s4,16(sp)
 888:	e456                	sd	s5,8(sp)
 88a:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 88c:	8a4e                	mv	s4,s3
 88e:	6705                	lui	a4,0x1
 890:	00e9f363          	bgeu	s3,a4,896 <malloc+0x42>
 894:	6a05                	lui	s4,0x1
 896:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 89a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 89e:	00000497          	auipc	s1,0x0
 8a2:	76248493          	addi	s1,s1,1890 # 1000 <freep>
  if (p == SBRK_ERROR)
 8a6:	5afd                	li	s5,-1
 8a8:	a83d                	j	8e6 <malloc+0x92>
 8aa:	f426                	sd	s1,40(sp)
 8ac:	e852                	sd	s4,16(sp)
 8ae:	e456                	sd	s5,8(sp)
 8b0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8b2:	00000797          	auipc	a5,0x0
 8b6:	75e78793          	addi	a5,a5,1886 # 1010 <base>
 8ba:	00000717          	auipc	a4,0x0
 8be:	74f73323          	sd	a5,1862(a4) # 1000 <freep>
 8c2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8c4:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8c8:	b7d1                	j	88c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8ca:	6398                	ld	a4,0(a5)
 8cc:	e118                	sd	a4,0(a0)
 8ce:	a899                	j	924 <malloc+0xd0>
  hp->s.size = nu;
 8d0:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8d4:	0541                	addi	a0,a0,16
 8d6:	ef5ff0ef          	jal	7ca <free>
  return freep;
 8da:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8dc:	c125                	beqz	a0,93c <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8de:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8e0:	4798                	lw	a4,8(a5)
 8e2:	03277163          	bgeu	a4,s2,904 <malloc+0xb0>
    if (p == freep)
 8e6:	6098                	ld	a4,0(s1)
 8e8:	853e                	mv	a0,a5
 8ea:	fef71ae3          	bne	a4,a5,8de <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8ee:	8552                	mv	a0,s4
 8f0:	a0fff0ef          	jal	2fe <sbrk>
  if (p == SBRK_ERROR)
 8f4:	fd551ee3          	bne	a0,s5,8d0 <malloc+0x7c>
        return 0;
 8f8:	4501                	li	a0,0
 8fa:	74a2                	ld	s1,40(sp)
 8fc:	6a42                	ld	s4,16(sp)
 8fe:	6aa2                	ld	s5,8(sp)
 900:	6b02                	ld	s6,0(sp)
 902:	a03d                	j	930 <malloc+0xdc>
 904:	74a2                	ld	s1,40(sp)
 906:	6a42                	ld	s4,16(sp)
 908:	6aa2                	ld	s5,8(sp)
 90a:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 90c:	fae90fe3          	beq	s2,a4,8ca <malloc+0x76>
        p->s.size -= nunits;
 910:	4137073b          	subw	a4,a4,s3
 914:	c798                	sw	a4,8(a5)
        p += p->s.size;
 916:	02071693          	slli	a3,a4,0x20
 91a:	01c6d713          	srli	a4,a3,0x1c
 91e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 920:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 924:	00000717          	auipc	a4,0x0
 928:	6ca73e23          	sd	a0,1756(a4) # 1000 <freep>
      return (void *)(p + 1);
 92c:	01078513          	addi	a0,a5,16
  }
}
 930:	70e2                	ld	ra,56(sp)
 932:	7442                	ld	s0,48(sp)
 934:	7902                	ld	s2,32(sp)
 936:	69e2                	ld	s3,24(sp)
 938:	6121                	addi	sp,sp,64
 93a:	8082                	ret
 93c:	74a2                	ld	s1,40(sp)
 93e:	6a42                	ld	s4,16(sp)
 940:	6aa2                	ld	s5,8(sp)
 942:	6b02                	ld	s6,0(sp)
 944:	b7f5                	j	930 <malloc+0xdc>
