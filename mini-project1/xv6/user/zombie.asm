
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if (fork() > 0)
   8:	2c4000ef          	jal	2cc <fork>
   c:	00a04563          	bgtz	a0,16 <main+0x16>
    pause(5); // Let child exit before parent.
  exit(0);
  10:	4501                	li	a0,0
  12:	2c2000ef          	jal	2d4 <exit>
    pause(5); // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	34c000ef          	jal	364 <pause>
  1c:	bfd5                	j	10 <main+0x10>

000000000000001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  26:	fdbff0ef          	jal	0 <main>
  exit(r);
  2a:	2aa000ef          	jal	2d4 <exit>

000000000000002e <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  2e:	1141                	addi	sp,sp,-16
  30:	e406                	sd	ra,8(sp)
  32:	e022                	sd	s0,0(sp)
  34:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  36:	87aa                	mv	a5,a0
  38:	0585                	addi	a1,a1,1
  3a:	0785                	addi	a5,a5,1
  3c:	fff5c703          	lbu	a4,-1(a1)
  40:	fee78fa3          	sb	a4,-1(a5)
  44:	fb75                	bnez	a4,38 <strcpy+0xa>
    ;
  return os;
}
  46:	60a2                	ld	ra,8(sp)
  48:	6402                	ld	s0,0(sp)
  4a:	0141                	addi	sp,sp,16
  4c:	8082                	ret

000000000000004e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4e:	1141                	addi	sp,sp,-16
  50:	e406                	sd	ra,8(sp)
  52:	e022                	sd	s0,0(sp)
  54:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  56:	00054783          	lbu	a5,0(a0)
  5a:	cb91                	beqz	a5,6e <strcmp+0x20>
  5c:	0005c703          	lbu	a4,0(a1)
  60:	00f71763          	bne	a4,a5,6e <strcmp+0x20>
    p++, q++;
  64:	0505                	addi	a0,a0,1
  66:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  68:	00054783          	lbu	a5,0(a0)
  6c:	fbe5                	bnez	a5,5c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  6e:	0005c503          	lbu	a0,0(a1)
}
  72:	40a7853b          	subw	a0,a5,a0
  76:	60a2                	ld	ra,8(sp)
  78:	6402                	ld	s0,0(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strlen>:

uint
strlen(const char *s)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cf91                	beqz	a5,a6 <strlen+0x28>
  8c:	00150793          	addi	a5,a0,1
  90:	86be                	mv	a3,a5
  92:	0785                	addi	a5,a5,1
  94:	fff7c703          	lbu	a4,-1(a5)
  98:	ff65                	bnez	a4,90 <strlen+0x12>
  9a:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  9e:	60a2                	ld	ra,8(sp)
  a0:	6402                	ld	s0,0(sp)
  a2:	0141                	addi	sp,sp,16
  a4:	8082                	ret
  for (n = 0; s[n]; n++)
  a6:	4501                	li	a0,0
  a8:	bfdd                	j	9e <strlen+0x20>

00000000000000aa <memset>:

void *
memset(void *dst, int c, uint n)
{
  aa:	1141                	addi	sp,sp,-16
  ac:	e406                	sd	ra,8(sp)
  ae:	e022                	sd	s0,0(sp)
  b0:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  b2:	ca19                	beqz	a2,c8 <memset+0x1e>
  b4:	87aa                	mv	a5,a0
  b6:	1602                	slli	a2,a2,0x20
  b8:	9201                	srli	a2,a2,0x20
  ba:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  be:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  c2:	0785                	addi	a5,a5,1
  c4:	fee79de3          	bne	a5,a4,be <memset+0x14>
  }
  return dst;
}
  c8:	60a2                	ld	ra,8(sp)
  ca:	6402                	ld	s0,0(sp)
  cc:	0141                	addi	sp,sp,16
  ce:	8082                	ret

00000000000000d0 <strchr>:

char *
strchr(const char *s, char c)
{
  d0:	1141                	addi	sp,sp,-16
  d2:	e406                	sd	ra,8(sp)
  d4:	e022                	sd	s0,0(sp)
  d6:	0800                	addi	s0,sp,16
  for (; *s; s++)
  d8:	00054783          	lbu	a5,0(a0)
  dc:	c799                	beqz	a5,ea <strchr+0x1a>
    if (*s == c)
  de:	00f58763          	beq	a1,a5,ec <strchr+0x1c>
  for (; *s; s++)
  e2:	0505                	addi	a0,a0,1
  e4:	00054783          	lbu	a5,0(a0)
  e8:	fbfd                	bnez	a5,de <strchr+0xe>
      return (char *)s;
  return 0;
  ea:	4501                	li	a0,0
}
  ec:	60a2                	ld	ra,8(sp)
  ee:	6402                	ld	s0,0(sp)
  f0:	0141                	addi	sp,sp,16
  f2:	8082                	ret

00000000000000f4 <gets>:

char *
gets(char *buf, int max)
{
  f4:	711d                	addi	sp,sp,-96
  f6:	ec86                	sd	ra,88(sp)
  f8:	e8a2                	sd	s0,80(sp)
  fa:	e4a6                	sd	s1,72(sp)
  fc:	e0ca                	sd	s2,64(sp)
  fe:	fc4e                	sd	s3,56(sp)
 100:	f852                	sd	s4,48(sp)
 102:	f456                	sd	s5,40(sp)
 104:	f05a                	sd	s6,32(sp)
 106:	ec5e                	sd	s7,24(sp)
 108:	e862                	sd	s8,16(sp)
 10a:	1080                	addi	s0,sp,96
 10c:	8baa                	mv	s7,a0
 10e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 110:	892a                	mv	s2,a0
 112:	4481                	li	s1,0
    cc = read(0, &c, 1);
 114:	faf40b13          	addi	s6,s0,-81
 118:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 11a:	8c26                	mv	s8,s1
 11c:	0014899b          	addiw	s3,s1,1
 120:	84ce                	mv	s1,s3
 122:	0349d863          	bge	s3,s4,152 <gets+0x5e>
    cc = read(0, &c, 1);
 126:	8656                	mv	a2,s5
 128:	85da                	mv	a1,s6
 12a:	4501                	li	a0,0
 12c:	1c0000ef          	jal	2ec <read>
    if (cc < 1)
 130:	02a05163          	blez	a0,152 <gets+0x5e>
      break;
    buf[i++] = c;
 134:	faf44783          	lbu	a5,-81(s0)
 138:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 13c:	0905                	addi	s2,s2,1
 13e:	ff678713          	addi	a4,a5,-10
 142:	00173713          	seqz	a4,a4
 146:	17cd                	addi	a5,a5,-13
 148:	0017b793          	seqz	a5,a5
 14c:	8fd9                	or	a5,a5,a4
 14e:	d7f1                	beqz	a5,11a <gets+0x26>
    buf[i++] = c;
 150:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 152:	9c5e                	add	s8,s8,s7
 154:	000c0023          	sb	zero,0(s8)
  return buf;
}
 158:	855e                	mv	a0,s7
 15a:	60e6                	ld	ra,88(sp)
 15c:	6446                	ld	s0,80(sp)
 15e:	64a6                	ld	s1,72(sp)
 160:	6906                	ld	s2,64(sp)
 162:	79e2                	ld	s3,56(sp)
 164:	7a42                	ld	s4,48(sp)
 166:	7aa2                	ld	s5,40(sp)
 168:	7b02                	ld	s6,32(sp)
 16a:	6be2                	ld	s7,24(sp)
 16c:	6c42                	ld	s8,16(sp)
 16e:	6125                	addi	sp,sp,96
 170:	8082                	ret

0000000000000172 <stat>:

int
stat(const char *n, struct stat *st)
{
 172:	1101                	addi	sp,sp,-32
 174:	ec06                	sd	ra,24(sp)
 176:	e822                	sd	s0,16(sp)
 178:	e04a                	sd	s2,0(sp)
 17a:	1000                	addi	s0,sp,32
 17c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17e:	4581                	li	a1,0
 180:	194000ef          	jal	314 <open>
  if (fd < 0)
 184:	02054263          	bltz	a0,1a8 <stat+0x36>
 188:	e426                	sd	s1,8(sp)
 18a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 18c:	85ca                	mv	a1,s2
 18e:	19e000ef          	jal	32c <fstat>
 192:	892a                	mv	s2,a0
  close(fd);
 194:	8526                	mv	a0,s1
 196:	166000ef          	jal	2fc <close>
  return r;
 19a:	64a2                	ld	s1,8(sp)
}
 19c:	854a                	mv	a0,s2
 19e:	60e2                	ld	ra,24(sp)
 1a0:	6442                	ld	s0,16(sp)
 1a2:	6902                	ld	s2,0(sp)
 1a4:	6105                	addi	sp,sp,32
 1a6:	8082                	ret
    return -1;
 1a8:	57fd                	li	a5,-1
 1aa:	893e                	mv	s2,a5
 1ac:	bfc5                	j	19c <stat+0x2a>

00000000000001ae <atoi>:

int
atoi(const char *s)
{
 1ae:	1141                	addi	sp,sp,-16
 1b0:	e406                	sd	ra,8(sp)
 1b2:	e022                	sd	s0,0(sp)
 1b4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1b6:	00054683          	lbu	a3,0(a0)
 1ba:	fd06879b          	addiw	a5,a3,-48
 1be:	0ff7f793          	zext.b	a5,a5
 1c2:	4625                	li	a2,9
 1c4:	02f66963          	bltu	a2,a5,1f6 <atoi+0x48>
 1c8:	872a                	mv	a4,a0
  n = 0;
 1ca:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 1cc:	0705                	addi	a4,a4,1
 1ce:	0025179b          	slliw	a5,a0,0x2
 1d2:	9fa9                	addw	a5,a5,a0
 1d4:	0017979b          	slliw	a5,a5,0x1
 1d8:	9fb5                	addw	a5,a5,a3
 1da:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 1de:	00074683          	lbu	a3,0(a4)
 1e2:	fd06879b          	addiw	a5,a3,-48
 1e6:	0ff7f793          	zext.b	a5,a5
 1ea:	fef671e3          	bgeu	a2,a5,1cc <atoi+0x1e>
  return n;
}
 1ee:	60a2                	ld	ra,8(sp)
 1f0:	6402                	ld	s0,0(sp)
 1f2:	0141                	addi	sp,sp,16
 1f4:	8082                	ret
  n = 0;
 1f6:	4501                	li	a0,0
 1f8:	bfdd                	j	1ee <atoi+0x40>

00000000000001fa <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 1fa:	1141                	addi	sp,sp,-16
 1fc:	e406                	sd	ra,8(sp)
 1fe:	e022                	sd	s0,0(sp)
 200:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 202:	02b57563          	bgeu	a0,a1,22c <memmove+0x32>
    while (n-- > 0)
 206:	00c05f63          	blez	a2,224 <memmove+0x2a>
 20a:	1602                	slli	a2,a2,0x20
 20c:	9201                	srli	a2,a2,0x20
 20e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 212:	872a                	mv	a4,a0
      *dst++ = *src++;
 214:	0585                	addi	a1,a1,1
 216:	0705                	addi	a4,a4,1
 218:	fff5c683          	lbu	a3,-1(a1)
 21c:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 220:	fee79ae3          	bne	a5,a4,214 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 224:	60a2                	ld	ra,8(sp)
 226:	6402                	ld	s0,0(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret
    while (n-- > 0)
 22c:	fec05ce3          	blez	a2,224 <memmove+0x2a>
    dst += n;
 230:	00c50733          	add	a4,a0,a2
    src += n;
 234:	95b2                	add	a1,a1,a2
 236:	fff6079b          	addiw	a5,a2,-1
 23a:	1782                	slli	a5,a5,0x20
 23c:	9381                	srli	a5,a5,0x20
 23e:	fff7c793          	not	a5,a5
 242:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 244:	15fd                	addi	a1,a1,-1
 246:	177d                	addi	a4,a4,-1
 248:	0005c683          	lbu	a3,0(a1)
 24c:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 250:	fef71ae3          	bne	a4,a5,244 <memmove+0x4a>
 254:	bfc1                	j	224 <memmove+0x2a>

0000000000000256 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 256:	1141                	addi	sp,sp,-16
 258:	e406                	sd	ra,8(sp)
 25a:	e022                	sd	s0,0(sp)
 25c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 25e:	ce19                	beqz	a2,27c <memcmp+0x26>
 260:	1602                	slli	a2,a2,0x20
 262:	9201                	srli	a2,a2,0x20
 264:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 268:	00054783          	lbu	a5,0(a0)
 26c:	0005c703          	lbu	a4,0(a1)
 270:	00e79b63          	bne	a5,a4,286 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 274:	0505                	addi	a0,a0,1
    p2++;
 276:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 278:	fed518e3          	bne	a0,a3,268 <memcmp+0x12>
  }
  return 0;
 27c:	4501                	li	a0,0
}
 27e:	60a2                	ld	ra,8(sp)
 280:	6402                	ld	s0,0(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret
      return *p1 - *p2;
 286:	40e7853b          	subw	a0,a5,a4
 28a:	bfd5                	j	27e <memcmp+0x28>

000000000000028c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e406                	sd	ra,8(sp)
 290:	e022                	sd	s0,0(sp)
 292:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 294:	f67ff0ef          	jal	1fa <memmove>
}
 298:	60a2                	ld	ra,8(sp)
 29a:	6402                	ld	s0,0(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret

00000000000002a0 <sbrk>:

char *
sbrk(int n)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e406                	sd	ra,8(sp)
 2a4:	e022                	sd	s0,0(sp)
 2a6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2a8:	4585                	li	a1,1
 2aa:	0b2000ef          	jal	35c <sys_sbrk>
}
 2ae:	60a2                	ld	ra,8(sp)
 2b0:	6402                	ld	s0,0(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret

00000000000002b6 <sbrklazy>:

char *
sbrklazy(int n)
{
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e406                	sd	ra,8(sp)
 2ba:	e022                	sd	s0,0(sp)
 2bc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2be:	4589                	li	a1,2
 2c0:	09c000ef          	jal	35c <sys_sbrk>
}
 2c4:	60a2                	ld	ra,8(sp)
 2c6:	6402                	ld	s0,0(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret

00000000000002cc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2cc:	4885                	li	a7,1
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2d4:	4889                	li	a7,2
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <wait>:
.global wait
wait:
 li a7, SYS_wait
 2dc:	488d                	li	a7,3
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2e4:	4891                	li	a7,4
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <read>:
.global read
read:
 li a7, SYS_read
 2ec:	4895                	li	a7,5
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <write>:
.global write
write:
 li a7, SYS_write
 2f4:	48c1                	li	a7,16
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <close>:
.global close
close:
 li a7, SYS_close
 2fc:	48d5                	li	a7,21
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <kill>:
.global kill
kill:
 li a7, SYS_kill
 304:	4899                	li	a7,6
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <exec>:
.global exec
exec:
 li a7, SYS_exec
 30c:	489d                	li	a7,7
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <open>:
.global open
open:
 li a7, SYS_open
 314:	48bd                	li	a7,15
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 31c:	48c5                	li	a7,17
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 324:	48c9                	li	a7,18
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 32c:	48a1                	li	a7,8
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <link>:
.global link
link:
 li a7, SYS_link
 334:	48cd                	li	a7,19
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 33c:	48d1                	li	a7,20
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 344:	48a5                	li	a7,9
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <dup>:
.global dup
dup:
 li a7, SYS_dup
 34c:	48a9                	li	a7,10
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 354:	48ad                	li	a7,11
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 35c:	48b1                	li	a7,12
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <pause>:
.global pause
pause:
 li a7, SYS_pause
 364:	48b5                	li	a7,13
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 36c:	48b9                	li	a7,14
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <sync>:
.global sync
sync:
 li a7, SYS_sync
 374:	48d9                	li	a7,22
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 37c:	48dd                	li	a7,23
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 384:	1101                	addi	sp,sp,-32
 386:	ec06                	sd	ra,24(sp)
 388:	e822                	sd	s0,16(sp)
 38a:	1000                	addi	s0,sp,32
 38c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 390:	4605                	li	a2,1
 392:	fef40593          	addi	a1,s0,-17
 396:	f5fff0ef          	jal	2f4 <write>
}
 39a:	60e2                	ld	ra,24(sp)
 39c:	6442                	ld	s0,16(sp)
 39e:	6105                	addi	sp,sp,32
 3a0:	8082                	ret

00000000000003a2 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3a2:	715d                	addi	sp,sp,-80
 3a4:	e486                	sd	ra,72(sp)
 3a6:	e0a2                	sd	s0,64(sp)
 3a8:	f84a                	sd	s2,48(sp)
 3aa:	f44e                	sd	s3,40(sp)
 3ac:	0880                	addi	s0,sp,80
 3ae:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3b0:	00d036b3          	snez	a3,a3
 3b4:	03f5d793          	srli	a5,a1,0x3f
 3b8:	8efd                	and	a3,a3,a5
  neg = 0;
 3ba:	4301                	li	t1,0
  if (sgn && xx < 0) {
 3bc:	c681                	beqz	a3,3c4 <printint+0x22>
    neg = 1;
    x = -xx;
 3be:	40b005b3          	neg	a1,a1
    neg = 1;
 3c2:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3c4:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3c8:	86ce                	mv	a3,s3
  i = 0;
 3ca:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 3cc:	00000817          	auipc	a6,0x0
 3d0:	52c80813          	addi	a6,a6,1324 # 8f8 <digits>
 3d4:	88ba                	mv	a7,a4
 3d6:	0017051b          	addiw	a0,a4,1
 3da:	872a                	mv	a4,a0
 3dc:	02c5f7b3          	remu	a5,a1,a2
 3e0:	97c2                	add	a5,a5,a6
 3e2:	0007c783          	lbu	a5,0(a5)
 3e6:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 3ea:	87ae                	mv	a5,a1
 3ec:	02c5d5b3          	divu	a1,a1,a2
 3f0:	0685                	addi	a3,a3,1
 3f2:	fec7f1e3          	bgeu	a5,a2,3d4 <printint+0x32>
  if (neg)
 3f6:	00030b63          	beqz	t1,40c <printint+0x6a>
    buf[i++] = '-';
 3fa:	fd040793          	addi	a5,s0,-48
 3fe:	953e                	add	a0,a0,a5
 400:	02d00793          	li	a5,45
 404:	fef50423          	sb	a5,-24(a0)
 408:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 40c:	02e05563          	blez	a4,436 <printint+0x94>
 410:	fc26                	sd	s1,56(sp)
 412:	377d                	addiw	a4,a4,-1
 414:	00e984b3          	add	s1,s3,a4
 418:	19fd                	addi	s3,s3,-1
 41a:	99ba                	add	s3,s3,a4
 41c:	1702                	slli	a4,a4,0x20
 41e:	9301                	srli	a4,a4,0x20
 420:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 424:	0004c583          	lbu	a1,0(s1)
 428:	854a                	mv	a0,s2
 42a:	f5bff0ef          	jal	384 <putc>
  while (--i >= 0)
 42e:	14fd                	addi	s1,s1,-1
 430:	ff349ae3          	bne	s1,s3,424 <printint+0x82>
 434:	74e2                	ld	s1,56(sp)
}
 436:	60a6                	ld	ra,72(sp)
 438:	6406                	ld	s0,64(sp)
 43a:	7942                	ld	s2,48(sp)
 43c:	79a2                	ld	s3,40(sp)
 43e:	6161                	addi	sp,sp,80
 440:	8082                	ret

0000000000000442 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 442:	711d                	addi	sp,sp,-96
 444:	ec86                	sd	ra,88(sp)
 446:	e8a2                	sd	s0,80(sp)
 448:	e4a6                	sd	s1,72(sp)
 44a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 44c:	0005c483          	lbu	s1,0(a1)
 450:	2a048063          	beqz	s1,6f0 <vprintf+0x2ae>
 454:	e0ca                	sd	s2,64(sp)
 456:	fc4e                	sd	s3,56(sp)
 458:	f852                	sd	s4,48(sp)
 45a:	f456                	sd	s5,40(sp)
 45c:	f05a                	sd	s6,32(sp)
 45e:	ec5e                	sd	s7,24(sp)
 460:	e862                	sd	s8,16(sp)
 462:	8b2a                	mv	s6,a0
 464:	8a2e                	mv	s4,a1
 466:	8bb2                	mv	s7,a2
  state = 0;
 468:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 46a:	4901                	li	s2,0
 46c:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 46e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 472:	06400c13          	li	s8,100
 476:	a00d                	j	498 <vprintf+0x56>
        putc(fd, c0);
 478:	85a6                	mv	a1,s1
 47a:	855a                	mv	a0,s6
 47c:	f09ff0ef          	jal	384 <putc>
 480:	a019                	j	486 <vprintf+0x44>
    } else if (state == '%') {
 482:	03598363          	beq	s3,s5,4a8 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 486:	0019079b          	addiw	a5,s2,1
 48a:	893e                	mv	s2,a5
 48c:	873e                	mv	a4,a5
 48e:	97d2                	add	a5,a5,s4
 490:	0007c483          	lbu	s1,0(a5)
 494:	24048763          	beqz	s1,6e2 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 498:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 49c:	fe0993e3          	bnez	s3,482 <vprintf+0x40>
      if (c0 == '%') {
 4a0:	fd579ce3          	bne	a5,s5,478 <vprintf+0x36>
        state = '%';
 4a4:	89be                	mv	s3,a5
 4a6:	b7c5                	j	486 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 4a8:	00ea06b3          	add	a3,s4,a4
 4ac:	0016c603          	lbu	a2,1(a3)
      if (c1)
 4b0:	24060563          	beqz	a2,6fa <vprintf+0x2b8>
      if (c0 == 'd') {
 4b4:	0b878763          	beq	a5,s8,562 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4b8:	f9478693          	addi	a3,a5,-108
 4bc:	0016b693          	seqz	a3,a3
 4c0:	f9c60593          	addi	a1,a2,-100
 4c4:	0015b593          	seqz	a1,a1
 4c8:	8df5                	and	a1,a1,a3
 4ca:	e9c5                	bnez	a1,57a <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 4cc:	9752                	add	a4,a4,s4
 4ce:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 4d2:	f9460713          	addi	a4,a2,-108
 4d6:	00173713          	seqz	a4,a4
 4da:	8f75                	and	a4,a4,a3
 4dc:	f9c50593          	addi	a1,a0,-100
 4e0:	0015b593          	seqz	a1,a1
 4e4:	8df9                	and	a1,a1,a4
 4e6:	e5dd                	bnez	a1,594 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 4e8:	07500593          	li	a1,117
 4ec:	0cb78163          	beq	a5,a1,5ae <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 4f0:	f8b60593          	addi	a1,a2,-117
 4f4:	0015b593          	seqz	a1,a1
 4f8:	8df5                	and	a1,a1,a3
 4fa:	e5f1                	bnez	a1,5c6 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 4fc:	f8b50593          	addi	a1,a0,-117
 500:	0015b593          	seqz	a1,a1
 504:	8df9                	and	a1,a1,a4
 506:	ede9                	bnez	a1,5e0 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 508:	07800593          	li	a1,120
 50c:	0eb78763          	beq	a5,a1,5fa <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 510:	f8860613          	addi	a2,a2,-120
 514:	00163613          	seqz	a2,a2
 518:	8ef1                	and	a3,a3,a2
 51a:	0e069c63          	bnez	a3,612 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 51e:	f8850513          	addi	a0,a0,-120
 522:	00153513          	seqz	a0,a0
 526:	8f69                	and	a4,a4,a0
 528:	10071263          	bnez	a4,62c <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 52c:	07000713          	li	a4,112
 530:	10e78a63          	beq	a5,a4,644 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 534:	06300713          	li	a4,99
 538:	14e78a63          	beq	a5,a4,68c <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 53c:	07300713          	li	a4,115
 540:	16e78063          	beq	a5,a4,6a0 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 544:	02500713          	li	a4,37
 548:	18e78863          	beq	a5,a4,6d8 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 54c:	02500593          	li	a1,37
 550:	855a                	mv	a0,s6
 552:	e33ff0ef          	jal	384 <putc>
        putc(fd, c0);
 556:	85a6                	mv	a1,s1
 558:	855a                	mv	a0,s6
 55a:	e2bff0ef          	jal	384 <putc>
      }

      state = 0;
 55e:	4981                	li	s3,0
 560:	b71d                	j	486 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 562:	008b8493          	addi	s1,s7,8
 566:	4685                	li	a3,1
 568:	4629                	li	a2,10
 56a:	000ba583          	lw	a1,0(s7)
 56e:	855a                	mv	a0,s6
 570:	e33ff0ef          	jal	3a2 <printint>
 574:	8ba6                	mv	s7,s1
      state = 0;
 576:	4981                	li	s3,0
 578:	b739                	j	486 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 57a:	008b8493          	addi	s1,s7,8
 57e:	4685                	li	a3,1
 580:	4629                	li	a2,10
 582:	000bb583          	ld	a1,0(s7)
 586:	855a                	mv	a0,s6
 588:	e1bff0ef          	jal	3a2 <printint>
        i += 1;
 58c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 58e:	8ba6                	mv	s7,s1
      state = 0;
 590:	4981                	li	s3,0
 592:	bdd5                	j	486 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 594:	008b8493          	addi	s1,s7,8
 598:	4685                	li	a3,1
 59a:	4629                	li	a2,10
 59c:	000bb583          	ld	a1,0(s7)
 5a0:	855a                	mv	a0,s6
 5a2:	e01ff0ef          	jal	3a2 <printint>
        i += 2;
 5a6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a8:	8ba6                	mv	s7,s1
      state = 0;
 5aa:	4981                	li	s3,0
        i += 2;
 5ac:	bde9                	j	486 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5ae:	008b8493          	addi	s1,s7,8
 5b2:	4681                	li	a3,0
 5b4:	4629                	li	a2,10
 5b6:	000be583          	lwu	a1,0(s7)
 5ba:	855a                	mv	a0,s6
 5bc:	de7ff0ef          	jal	3a2 <printint>
 5c0:	8ba6                	mv	s7,s1
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	b5c9                	j	486 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c6:	008b8493          	addi	s1,s7,8
 5ca:	4681                	li	a3,0
 5cc:	4629                	li	a2,10
 5ce:	000bb583          	ld	a1,0(s7)
 5d2:	855a                	mv	a0,s6
 5d4:	dcfff0ef          	jal	3a2 <printint>
        i += 1;
 5d8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5da:	8ba6                	mv	s7,s1
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	b565                	j	486 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e0:	008b8493          	addi	s1,s7,8
 5e4:	4681                	li	a3,0
 5e6:	4629                	li	a2,10
 5e8:	000bb583          	ld	a1,0(s7)
 5ec:	855a                	mv	a0,s6
 5ee:	db5ff0ef          	jal	3a2 <printint>
        i += 2;
 5f2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f4:	8ba6                	mv	s7,s1
      state = 0;
 5f6:	4981                	li	s3,0
        i += 2;
 5f8:	b579                	j	486 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5fa:	008b8493          	addi	s1,s7,8
 5fe:	4681                	li	a3,0
 600:	4641                	li	a2,16
 602:	000be583          	lwu	a1,0(s7)
 606:	855a                	mv	a0,s6
 608:	d9bff0ef          	jal	3a2 <printint>
 60c:	8ba6                	mv	s7,s1
      state = 0;
 60e:	4981                	li	s3,0
 610:	bd9d                	j	486 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 612:	008b8493          	addi	s1,s7,8
 616:	4681                	li	a3,0
 618:	4641                	li	a2,16
 61a:	000bb583          	ld	a1,0(s7)
 61e:	855a                	mv	a0,s6
 620:	d83ff0ef          	jal	3a2 <printint>
        i += 1;
 624:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 626:	8ba6                	mv	s7,s1
      state = 0;
 628:	4981                	li	s3,0
 62a:	bdb1                	j	486 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 62c:	008b8493          	addi	s1,s7,8
 630:	4641                	li	a2,16
 632:	000bb583          	ld	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	d6bff0ef          	jal	3a2 <printint>
        i += 2;
 63c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 63e:	8ba6                	mv	s7,s1
      state = 0;
 640:	4981                	li	s3,0
        i += 2;
 642:	b591                	j	486 <vprintf+0x44>
 644:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 646:	008b8793          	addi	a5,s7,8
 64a:	8cbe                	mv	s9,a5
 64c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 650:	03000593          	li	a1,48
 654:	855a                	mv	a0,s6
 656:	d2fff0ef          	jal	384 <putc>
  putc(fd, 'x');
 65a:	07800593          	li	a1,120
 65e:	855a                	mv	a0,s6
 660:	d25ff0ef          	jal	384 <putc>
 664:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 666:	00000b97          	auipc	s7,0x0
 66a:	292b8b93          	addi	s7,s7,658 # 8f8 <digits>
 66e:	03c9d793          	srli	a5,s3,0x3c
 672:	97de                	add	a5,a5,s7
 674:	0007c583          	lbu	a1,0(a5)
 678:	855a                	mv	a0,s6
 67a:	d0bff0ef          	jal	384 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 67e:	0992                	slli	s3,s3,0x4
 680:	34fd                	addiw	s1,s1,-1
 682:	f4f5                	bnez	s1,66e <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 684:	8be6                	mv	s7,s9
      state = 0;
 686:	4981                	li	s3,0
 688:	6ca2                	ld	s9,8(sp)
 68a:	bbf5                	j	486 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 68c:	008b8493          	addi	s1,s7,8
 690:	000bc583          	lbu	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	cefff0ef          	jal	384 <putc>
 69a:	8ba6                	mv	s7,s1
      state = 0;
 69c:	4981                	li	s3,0
 69e:	b3e5                	j	486 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6a0:	008b8993          	addi	s3,s7,8
 6a4:	000bb483          	ld	s1,0(s7)
 6a8:	cc91                	beqz	s1,6c4 <vprintf+0x282>
        for (; *s; s++)
 6aa:	0004c583          	lbu	a1,0(s1)
 6ae:	c195                	beqz	a1,6d2 <vprintf+0x290>
          putc(fd, *s);
 6b0:	855a                	mv	a0,s6
 6b2:	cd3ff0ef          	jal	384 <putc>
        for (; *s; s++)
 6b6:	0485                	addi	s1,s1,1
 6b8:	0004c583          	lbu	a1,0(s1)
 6bc:	f9f5                	bnez	a1,6b0 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 6be:	8bce                	mv	s7,s3
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	b3d1                	j	486 <vprintf+0x44>
          s = "(null)";
 6c4:	00000497          	auipc	s1,0x0
 6c8:	22c48493          	addi	s1,s1,556 # 8f0 <malloc+0xfa>
        for (; *s; s++)
 6cc:	02800593          	li	a1,40
 6d0:	b7c5                	j	6b0 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 6d2:	8bce                	mv	s7,s3
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	bb45                	j	486 <vprintf+0x44>
        putc(fd, '%');
 6d8:	85be                	mv	a1,a5
 6da:	855a                	mv	a0,s6
 6dc:	ca9ff0ef          	jal	384 <putc>
 6e0:	bdbd                	j	55e <vprintf+0x11c>
 6e2:	6906                	ld	s2,64(sp)
 6e4:	79e2                	ld	s3,56(sp)
 6e6:	7a42                	ld	s4,48(sp)
 6e8:	7aa2                	ld	s5,40(sp)
 6ea:	7b02                	ld	s6,32(sp)
 6ec:	6be2                	ld	s7,24(sp)
 6ee:	6c42                	ld	s8,16(sp)
    }
  }
}
 6f0:	60e6                	ld	ra,88(sp)
 6f2:	6446                	ld	s0,80(sp)
 6f4:	64a6                	ld	s1,72(sp)
 6f6:	6125                	addi	sp,sp,96
 6f8:	8082                	ret
      if (c0 == 'd') {
 6fa:	06400713          	li	a4,100
 6fe:	e6e782e3          	beq	a5,a4,562 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 702:	f9478693          	addi	a3,a5,-108
 706:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 70a:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 70c:	4701                	li	a4,0
 70e:	bbe9                	j	4e8 <vprintf+0xa6>

0000000000000710 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 710:	715d                	addi	sp,sp,-80
 712:	ec06                	sd	ra,24(sp)
 714:	e822                	sd	s0,16(sp)
 716:	1000                	addi	s0,sp,32
 718:	e010                	sd	a2,0(s0)
 71a:	e414                	sd	a3,8(s0)
 71c:	e818                	sd	a4,16(s0)
 71e:	ec1c                	sd	a5,24(s0)
 720:	03043023          	sd	a6,32(s0)
 724:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 728:	8622                	mv	a2,s0
 72a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 72e:	d15ff0ef          	jal	442 <vprintf>
}
 732:	60e2                	ld	ra,24(sp)
 734:	6442                	ld	s0,16(sp)
 736:	6161                	addi	sp,sp,80
 738:	8082                	ret

000000000000073a <printf>:

void
printf(const char *fmt, ...)
{
 73a:	711d                	addi	sp,sp,-96
 73c:	ec06                	sd	ra,24(sp)
 73e:	e822                	sd	s0,16(sp)
 740:	1000                	addi	s0,sp,32
 742:	e40c                	sd	a1,8(s0)
 744:	e810                	sd	a2,16(s0)
 746:	ec14                	sd	a3,24(s0)
 748:	f018                	sd	a4,32(s0)
 74a:	f41c                	sd	a5,40(s0)
 74c:	03043823          	sd	a6,48(s0)
 750:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 754:	00840613          	addi	a2,s0,8
 758:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 75c:	85aa                	mv	a1,a0
 75e:	4505                	li	a0,1
 760:	ce3ff0ef          	jal	442 <vprintf>
}
 764:	60e2                	ld	ra,24(sp)
 766:	6442                	ld	s0,16(sp)
 768:	6125                	addi	sp,sp,96
 76a:	8082                	ret

000000000000076c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76c:	1141                	addi	sp,sp,-16
 76e:	e406                	sd	ra,8(sp)
 770:	e022                	sd	s0,0(sp)
 772:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 774:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 778:	00001797          	auipc	a5,0x1
 77c:	8887b783          	ld	a5,-1912(a5) # 1000 <freep>
 780:	a095                	j	7e4 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 782:	ff852583          	lw	a1,-8(a0)
 786:	6390                	ld	a2,0(a5)
 788:	02059813          	slli	a6,a1,0x20
 78c:	01c85693          	srli	a3,a6,0x1c
 790:	96ba                	add	a3,a3,a4
 792:	02d60563          	beq	a2,a3,7bc <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 796:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 79a:	4790                	lw	a2,8(a5)
 79c:	02061593          	slli	a1,a2,0x20
 7a0:	01c5d693          	srli	a3,a1,0x1c
 7a4:	96be                	add	a3,a3,a5
 7a6:	02d70263          	beq	a4,a3,7ca <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7aa:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ac:	00001717          	auipc	a4,0x1
 7b0:	84f73a23          	sd	a5,-1964(a4) # 1000 <freep>
}
 7b4:	60a2                	ld	ra,8(sp)
 7b6:	6402                	ld	s0,0(sp)
 7b8:	0141                	addi	sp,sp,16
 7ba:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7bc:	4614                	lw	a3,8(a2)
 7be:	9ead                	addw	a3,a3,a1
 7c0:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c4:	6394                	ld	a3,0(a5)
 7c6:	6290                	ld	a2,0(a3)
 7c8:	b7f9                	j	796 <free+0x2a>
    p->s.size += bp->s.size;
 7ca:	ff852703          	lw	a4,-8(a0)
 7ce:	9f31                	addw	a4,a4,a2
 7d0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7d2:	ff053703          	ld	a4,-16(a0)
 7d6:	bfd1                	j	7aa <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d8:	6394                	ld	a3,0(a5)
 7da:	00d7e463          	bltu	a5,a3,7e2 <free+0x76>
 7de:	fad762e3          	bltu	a4,a3,782 <free+0x16>
 7e2:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e4:	fee7fae3          	bgeu	a5,a4,7d8 <free+0x6c>
 7e8:	6394                	ld	a3,0(a5)
 7ea:	f8d76ce3          	bltu	a4,a3,782 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ee:	f8d7fae3          	bgeu	a5,a3,782 <free+0x16>
 7f2:	87b6                	mv	a5,a3
 7f4:	bfc5                	j	7e4 <free+0x78>

00000000000007f6 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 7f6:	7139                	addi	sp,sp,-64
 7f8:	fc06                	sd	ra,56(sp)
 7fa:	f822                	sd	s0,48(sp)
 7fc:	f04a                	sd	s2,32(sp)
 7fe:	ec4e                	sd	s3,24(sp)
 800:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 802:	02051993          	slli	s3,a0,0x20
 806:	0209d993          	srli	s3,s3,0x20
 80a:	09bd                	addi	s3,s3,15
 80c:	0049d993          	srli	s3,s3,0x4
 810:	2985                	addiw	s3,s3,1
 812:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 814:	00000517          	auipc	a0,0x0
 818:	7ec53503          	ld	a0,2028(a0) # 1000 <freep>
 81c:	c905                	beqz	a0,84c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 81e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 820:	4798                	lw	a4,8(a5)
 822:	09377663          	bgeu	a4,s3,8ae <malloc+0xb8>
 826:	f426                	sd	s1,40(sp)
 828:	e852                	sd	s4,16(sp)
 82a:	e456                	sd	s5,8(sp)
 82c:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 82e:	8a4e                	mv	s4,s3
 830:	6705                	lui	a4,0x1
 832:	00e9f363          	bgeu	s3,a4,838 <malloc+0x42>
 836:	6a05                	lui	s4,0x1
 838:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 83c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 840:	00000497          	auipc	s1,0x0
 844:	7c048493          	addi	s1,s1,1984 # 1000 <freep>
  if (p == SBRK_ERROR)
 848:	5afd                	li	s5,-1
 84a:	a83d                	j	888 <malloc+0x92>
 84c:	f426                	sd	s1,40(sp)
 84e:	e852                	sd	s4,16(sp)
 850:	e456                	sd	s5,8(sp)
 852:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 854:	00000797          	auipc	a5,0x0
 858:	7bc78793          	addi	a5,a5,1980 # 1010 <base>
 85c:	00000717          	auipc	a4,0x0
 860:	7af73223          	sd	a5,1956(a4) # 1000 <freep>
 864:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 866:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 86a:	b7d1                	j	82e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 86c:	6398                	ld	a4,0(a5)
 86e:	e118                	sd	a4,0(a0)
 870:	a899                	j	8c6 <malloc+0xd0>
  hp->s.size = nu;
 872:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 876:	0541                	addi	a0,a0,16
 878:	ef5ff0ef          	jal	76c <free>
  return freep;
 87c:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 87e:	c125                	beqz	a0,8de <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 880:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 882:	4798                	lw	a4,8(a5)
 884:	03277163          	bgeu	a4,s2,8a6 <malloc+0xb0>
    if (p == freep)
 888:	6098                	ld	a4,0(s1)
 88a:	853e                	mv	a0,a5
 88c:	fef71ae3          	bne	a4,a5,880 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 890:	8552                	mv	a0,s4
 892:	a0fff0ef          	jal	2a0 <sbrk>
  if (p == SBRK_ERROR)
 896:	fd551ee3          	bne	a0,s5,872 <malloc+0x7c>
        return 0;
 89a:	4501                	li	a0,0
 89c:	74a2                	ld	s1,40(sp)
 89e:	6a42                	ld	s4,16(sp)
 8a0:	6aa2                	ld	s5,8(sp)
 8a2:	6b02                	ld	s6,0(sp)
 8a4:	a03d                	j	8d2 <malloc+0xdc>
 8a6:	74a2                	ld	s1,40(sp)
 8a8:	6a42                	ld	s4,16(sp)
 8aa:	6aa2                	ld	s5,8(sp)
 8ac:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8ae:	fae90fe3          	beq	s2,a4,86c <malloc+0x76>
        p->s.size -= nunits;
 8b2:	4137073b          	subw	a4,a4,s3
 8b6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8b8:	02071693          	slli	a3,a4,0x20
 8bc:	01c6d713          	srli	a4,a3,0x1c
 8c0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8c2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8c6:	00000717          	auipc	a4,0x0
 8ca:	72a73d23          	sd	a0,1850(a4) # 1000 <freep>
      return (void *)(p + 1);
 8ce:	01078513          	addi	a0,a5,16
  }
}
 8d2:	70e2                	ld	ra,56(sp)
 8d4:	7442                	ld	s0,48(sp)
 8d6:	7902                	ld	s2,32(sp)
 8d8:	69e2                	ld	s3,24(sp)
 8da:	6121                	addi	sp,sp,64
 8dc:	8082                	ret
 8de:	74a2                	ld	s1,40(sp)
 8e0:	6a42                	ld	s4,16(sp)
 8e2:	6aa2                	ld	s5,8(sp)
 8e4:	6b02                	ld	s6,0(sp)
 8e6:	b7f5                	j	8d2 <malloc+0xdc>
