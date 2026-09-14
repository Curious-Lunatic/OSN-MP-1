
user/_sync:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  sync();
   8:	360000ef          	jal	368 <sync>
  exit(0);
   c:	4501                	li	a0,0
   e:	2ba000ef          	jal	2c8 <exit>

0000000000000012 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  12:	1141                	addi	sp,sp,-16
  14:	e406                	sd	ra,8(sp)
  16:	e022                	sd	s0,0(sp)
  18:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  1a:	fe7ff0ef          	jal	0 <main>
  exit(r);
  1e:	2aa000ef          	jal	2c8 <exit>

0000000000000022 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  22:	1141                	addi	sp,sp,-16
  24:	e406                	sd	ra,8(sp)
  26:	e022                	sd	s0,0(sp)
  28:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  2a:	87aa                	mv	a5,a0
  2c:	0585                	addi	a1,a1,1
  2e:	0785                	addi	a5,a5,1
  30:	fff5c703          	lbu	a4,-1(a1)
  34:	fee78fa3          	sb	a4,-1(a5)
  38:	fb75                	bnez	a4,2c <strcpy+0xa>
    ;
  return os;
}
  3a:	60a2                	ld	ra,8(sp)
  3c:	6402                	ld	s0,0(sp)
  3e:	0141                	addi	sp,sp,16
  40:	8082                	ret

0000000000000042 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  42:	1141                	addi	sp,sp,-16
  44:	e406                	sd	ra,8(sp)
  46:	e022                	sd	s0,0(sp)
  48:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  4a:	00054783          	lbu	a5,0(a0)
  4e:	cb91                	beqz	a5,62 <strcmp+0x20>
  50:	0005c703          	lbu	a4,0(a1)
  54:	00f71763          	bne	a4,a5,62 <strcmp+0x20>
    p++, q++;
  58:	0505                	addi	a0,a0,1
  5a:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  5c:	00054783          	lbu	a5,0(a0)
  60:	fbe5                	bnez	a5,50 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  62:	0005c503          	lbu	a0,0(a1)
}
  66:	40a7853b          	subw	a0,a5,a0
  6a:	60a2                	ld	ra,8(sp)
  6c:	6402                	ld	s0,0(sp)
  6e:	0141                	addi	sp,sp,16
  70:	8082                	ret

0000000000000072 <strlen>:

uint
strlen(const char *s)
{
  72:	1141                	addi	sp,sp,-16
  74:	e406                	sd	ra,8(sp)
  76:	e022                	sd	s0,0(sp)
  78:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  7a:	00054783          	lbu	a5,0(a0)
  7e:	cf91                	beqz	a5,9a <strlen+0x28>
  80:	00150793          	addi	a5,a0,1
  84:	86be                	mv	a3,a5
  86:	0785                	addi	a5,a5,1
  88:	fff7c703          	lbu	a4,-1(a5)
  8c:	ff65                	bnez	a4,84 <strlen+0x12>
  8e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  92:	60a2                	ld	ra,8(sp)
  94:	6402                	ld	s0,0(sp)
  96:	0141                	addi	sp,sp,16
  98:	8082                	ret
  for (n = 0; s[n]; n++)
  9a:	4501                	li	a0,0
  9c:	bfdd                	j	92 <strlen+0x20>

000000000000009e <memset>:

void *
memset(void *dst, int c, uint n)
{
  9e:	1141                	addi	sp,sp,-16
  a0:	e406                	sd	ra,8(sp)
  a2:	e022                	sd	s0,0(sp)
  a4:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  a6:	ca19                	beqz	a2,bc <memset+0x1e>
  a8:	87aa                	mv	a5,a0
  aa:	1602                	slli	a2,a2,0x20
  ac:	9201                	srli	a2,a2,0x20
  ae:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b2:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  b6:	0785                	addi	a5,a5,1
  b8:	fee79de3          	bne	a5,a4,b2 <memset+0x14>
  }
  return dst;
}
  bc:	60a2                	ld	ra,8(sp)
  be:	6402                	ld	s0,0(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strchr>:

char *
strchr(const char *s, char c)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e406                	sd	ra,8(sp)
  c8:	e022                	sd	s0,0(sp)
  ca:	0800                	addi	s0,sp,16
  for (; *s; s++)
  cc:	00054783          	lbu	a5,0(a0)
  d0:	c799                	beqz	a5,de <strchr+0x1a>
    if (*s == c)
  d2:	00f58763          	beq	a1,a5,e0 <strchr+0x1c>
  for (; *s; s++)
  d6:	0505                	addi	a0,a0,1
  d8:	00054783          	lbu	a5,0(a0)
  dc:	fbfd                	bnez	a5,d2 <strchr+0xe>
      return (char *)s;
  return 0;
  de:	4501                	li	a0,0
}
  e0:	60a2                	ld	ra,8(sp)
  e2:	6402                	ld	s0,0(sp)
  e4:	0141                	addi	sp,sp,16
  e6:	8082                	ret

00000000000000e8 <gets>:

char *
gets(char *buf, int max)
{
  e8:	711d                	addi	sp,sp,-96
  ea:	ec86                	sd	ra,88(sp)
  ec:	e8a2                	sd	s0,80(sp)
  ee:	e4a6                	sd	s1,72(sp)
  f0:	e0ca                	sd	s2,64(sp)
  f2:	fc4e                	sd	s3,56(sp)
  f4:	f852                	sd	s4,48(sp)
  f6:	f456                	sd	s5,40(sp)
  f8:	f05a                	sd	s6,32(sp)
  fa:	ec5e                	sd	s7,24(sp)
  fc:	e862                	sd	s8,16(sp)
  fe:	1080                	addi	s0,sp,96
 100:	8baa                	mv	s7,a0
 102:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 104:	892a                	mv	s2,a0
 106:	4481                	li	s1,0
    cc = read(0, &c, 1);
 108:	faf40b13          	addi	s6,s0,-81
 10c:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 10e:	8c26                	mv	s8,s1
 110:	0014899b          	addiw	s3,s1,1
 114:	84ce                	mv	s1,s3
 116:	0349d863          	bge	s3,s4,146 <gets+0x5e>
    cc = read(0, &c, 1);
 11a:	8656                	mv	a2,s5
 11c:	85da                	mv	a1,s6
 11e:	4501                	li	a0,0
 120:	1c0000ef          	jal	2e0 <read>
    if (cc < 1)
 124:	02a05163          	blez	a0,146 <gets+0x5e>
      break;
    buf[i++] = c;
 128:	faf44783          	lbu	a5,-81(s0)
 12c:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 130:	0905                	addi	s2,s2,1
 132:	ff678713          	addi	a4,a5,-10
 136:	00173713          	seqz	a4,a4
 13a:	17cd                	addi	a5,a5,-13
 13c:	0017b793          	seqz	a5,a5
 140:	8fd9                	or	a5,a5,a4
 142:	d7f1                	beqz	a5,10e <gets+0x26>
    buf[i++] = c;
 144:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 146:	9c5e                	add	s8,s8,s7
 148:	000c0023          	sb	zero,0(s8)
  return buf;
}
 14c:	855e                	mv	a0,s7
 14e:	60e6                	ld	ra,88(sp)
 150:	6446                	ld	s0,80(sp)
 152:	64a6                	ld	s1,72(sp)
 154:	6906                	ld	s2,64(sp)
 156:	79e2                	ld	s3,56(sp)
 158:	7a42                	ld	s4,48(sp)
 15a:	7aa2                	ld	s5,40(sp)
 15c:	7b02                	ld	s6,32(sp)
 15e:	6be2                	ld	s7,24(sp)
 160:	6c42                	ld	s8,16(sp)
 162:	6125                	addi	sp,sp,96
 164:	8082                	ret

0000000000000166 <stat>:

int
stat(const char *n, struct stat *st)
{
 166:	1101                	addi	sp,sp,-32
 168:	ec06                	sd	ra,24(sp)
 16a:	e822                	sd	s0,16(sp)
 16c:	e04a                	sd	s2,0(sp)
 16e:	1000                	addi	s0,sp,32
 170:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 172:	4581                	li	a1,0
 174:	194000ef          	jal	308 <open>
  if (fd < 0)
 178:	02054263          	bltz	a0,19c <stat+0x36>
 17c:	e426                	sd	s1,8(sp)
 17e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 180:	85ca                	mv	a1,s2
 182:	19e000ef          	jal	320 <fstat>
 186:	892a                	mv	s2,a0
  close(fd);
 188:	8526                	mv	a0,s1
 18a:	166000ef          	jal	2f0 <close>
  return r;
 18e:	64a2                	ld	s1,8(sp)
}
 190:	854a                	mv	a0,s2
 192:	60e2                	ld	ra,24(sp)
 194:	6442                	ld	s0,16(sp)
 196:	6902                	ld	s2,0(sp)
 198:	6105                	addi	sp,sp,32
 19a:	8082                	ret
    return -1;
 19c:	57fd                	li	a5,-1
 19e:	893e                	mv	s2,a5
 1a0:	bfc5                	j	190 <stat+0x2a>

00000000000001a2 <atoi>:

int
atoi(const char *s)
{
 1a2:	1141                	addi	sp,sp,-16
 1a4:	e406                	sd	ra,8(sp)
 1a6:	e022                	sd	s0,0(sp)
 1a8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1aa:	00054683          	lbu	a3,0(a0)
 1ae:	fd06879b          	addiw	a5,a3,-48
 1b2:	0ff7f793          	zext.b	a5,a5
 1b6:	4625                	li	a2,9
 1b8:	02f66963          	bltu	a2,a5,1ea <atoi+0x48>
 1bc:	872a                	mv	a4,a0
  n = 0;
 1be:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 1c0:	0705                	addi	a4,a4,1
 1c2:	0025179b          	slliw	a5,a0,0x2
 1c6:	9fa9                	addw	a5,a5,a0
 1c8:	0017979b          	slliw	a5,a5,0x1
 1cc:	9fb5                	addw	a5,a5,a3
 1ce:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 1d2:	00074683          	lbu	a3,0(a4)
 1d6:	fd06879b          	addiw	a5,a3,-48
 1da:	0ff7f793          	zext.b	a5,a5
 1de:	fef671e3          	bgeu	a2,a5,1c0 <atoi+0x1e>
  return n;
}
 1e2:	60a2                	ld	ra,8(sp)
 1e4:	6402                	ld	s0,0(sp)
 1e6:	0141                	addi	sp,sp,16
 1e8:	8082                	ret
  n = 0;
 1ea:	4501                	li	a0,0
 1ec:	bfdd                	j	1e2 <atoi+0x40>

00000000000001ee <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 1ee:	1141                	addi	sp,sp,-16
 1f0:	e406                	sd	ra,8(sp)
 1f2:	e022                	sd	s0,0(sp)
 1f4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1f6:	02b57563          	bgeu	a0,a1,220 <memmove+0x32>
    while (n-- > 0)
 1fa:	00c05f63          	blez	a2,218 <memmove+0x2a>
 1fe:	1602                	slli	a2,a2,0x20
 200:	9201                	srli	a2,a2,0x20
 202:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 206:	872a                	mv	a4,a0
      *dst++ = *src++;
 208:	0585                	addi	a1,a1,1
 20a:	0705                	addi	a4,a4,1
 20c:	fff5c683          	lbu	a3,-1(a1)
 210:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 214:	fee79ae3          	bne	a5,a4,208 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 218:	60a2                	ld	ra,8(sp)
 21a:	6402                	ld	s0,0(sp)
 21c:	0141                	addi	sp,sp,16
 21e:	8082                	ret
    while (n-- > 0)
 220:	fec05ce3          	blez	a2,218 <memmove+0x2a>
    dst += n;
 224:	00c50733          	add	a4,a0,a2
    src += n;
 228:	95b2                	add	a1,a1,a2
 22a:	fff6079b          	addiw	a5,a2,-1
 22e:	1782                	slli	a5,a5,0x20
 230:	9381                	srli	a5,a5,0x20
 232:	fff7c793          	not	a5,a5
 236:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 238:	15fd                	addi	a1,a1,-1
 23a:	177d                	addi	a4,a4,-1
 23c:	0005c683          	lbu	a3,0(a1)
 240:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 244:	fef71ae3          	bne	a4,a5,238 <memmove+0x4a>
 248:	bfc1                	j	218 <memmove+0x2a>

000000000000024a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e406                	sd	ra,8(sp)
 24e:	e022                	sd	s0,0(sp)
 250:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 252:	ce19                	beqz	a2,270 <memcmp+0x26>
 254:	1602                	slli	a2,a2,0x20
 256:	9201                	srli	a2,a2,0x20
 258:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 25c:	00054783          	lbu	a5,0(a0)
 260:	0005c703          	lbu	a4,0(a1)
 264:	00e79b63          	bne	a5,a4,27a <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 268:	0505                	addi	a0,a0,1
    p2++;
 26a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 26c:	fed518e3          	bne	a0,a3,25c <memcmp+0x12>
  }
  return 0;
 270:	4501                	li	a0,0
}
 272:	60a2                	ld	ra,8(sp)
 274:	6402                	ld	s0,0(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret
      return *p1 - *p2;
 27a:	40e7853b          	subw	a0,a5,a4
 27e:	bfd5                	j	272 <memcmp+0x28>

0000000000000280 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 280:	1141                	addi	sp,sp,-16
 282:	e406                	sd	ra,8(sp)
 284:	e022                	sd	s0,0(sp)
 286:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 288:	f67ff0ef          	jal	1ee <memmove>
}
 28c:	60a2                	ld	ra,8(sp)
 28e:	6402                	ld	s0,0(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret

0000000000000294 <sbrk>:

char *
sbrk(int n)
{
 294:	1141                	addi	sp,sp,-16
 296:	e406                	sd	ra,8(sp)
 298:	e022                	sd	s0,0(sp)
 29a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 29c:	4585                	li	a1,1
 29e:	0b2000ef          	jal	350 <sys_sbrk>
}
 2a2:	60a2                	ld	ra,8(sp)
 2a4:	6402                	ld	s0,0(sp)
 2a6:	0141                	addi	sp,sp,16
 2a8:	8082                	ret

00000000000002aa <sbrklazy>:

char *
sbrklazy(int n)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e406                	sd	ra,8(sp)
 2ae:	e022                	sd	s0,0(sp)
 2b0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2b2:	4589                	li	a1,2
 2b4:	09c000ef          	jal	350 <sys_sbrk>
}
 2b8:	60a2                	ld	ra,8(sp)
 2ba:	6402                	ld	s0,0(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret

00000000000002c0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2c0:	4885                	li	a7,1
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2c8:	4889                	li	a7,2
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2d0:	488d                	li	a7,3
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2d8:	4891                	li	a7,4
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <read>:
.global read
read:
 li a7, SYS_read
 2e0:	4895                	li	a7,5
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <write>:
.global write
write:
 li a7, SYS_write
 2e8:	48c1                	li	a7,16
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <close>:
.global close
close:
 li a7, SYS_close
 2f0:	48d5                	li	a7,21
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2f8:	4899                	li	a7,6
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <exec>:
.global exec
exec:
 li a7, SYS_exec
 300:	489d                	li	a7,7
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <open>:
.global open
open:
 li a7, SYS_open
 308:	48bd                	li	a7,15
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 310:	48c5                	li	a7,17
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 318:	48c9                	li	a7,18
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 320:	48a1                	li	a7,8
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <link>:
.global link
link:
 li a7, SYS_link
 328:	48cd                	li	a7,19
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 330:	48d1                	li	a7,20
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 338:	48a5                	li	a7,9
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <dup>:
.global dup
dup:
 li a7, SYS_dup
 340:	48a9                	li	a7,10
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 348:	48ad                	li	a7,11
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 350:	48b1                	li	a7,12
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <pause>:
.global pause
pause:
 li a7, SYS_pause
 358:	48b5                	li	a7,13
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 360:	48b9                	li	a7,14
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <sync>:
.global sync
sync:
 li a7, SYS_sync
 368:	48d9                	li	a7,22
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 370:	48dd                	li	a7,23
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 378:	1101                	addi	sp,sp,-32
 37a:	ec06                	sd	ra,24(sp)
 37c:	e822                	sd	s0,16(sp)
 37e:	1000                	addi	s0,sp,32
 380:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 384:	4605                	li	a2,1
 386:	fef40593          	addi	a1,s0,-17
 38a:	f5fff0ef          	jal	2e8 <write>
}
 38e:	60e2                	ld	ra,24(sp)
 390:	6442                	ld	s0,16(sp)
 392:	6105                	addi	sp,sp,32
 394:	8082                	ret

0000000000000396 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 396:	715d                	addi	sp,sp,-80
 398:	e486                	sd	ra,72(sp)
 39a:	e0a2                	sd	s0,64(sp)
 39c:	f84a                	sd	s2,48(sp)
 39e:	f44e                	sd	s3,40(sp)
 3a0:	0880                	addi	s0,sp,80
 3a2:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3a4:	00d036b3          	snez	a3,a3
 3a8:	03f5d793          	srli	a5,a1,0x3f
 3ac:	8efd                	and	a3,a3,a5
  neg = 0;
 3ae:	4301                	li	t1,0
  if (sgn && xx < 0) {
 3b0:	c681                	beqz	a3,3b8 <printint+0x22>
    neg = 1;
    x = -xx;
 3b2:	40b005b3          	neg	a1,a1
    neg = 1;
 3b6:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3b8:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3bc:	86ce                	mv	a3,s3
  i = 0;
 3be:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 3c0:	00000817          	auipc	a6,0x0
 3c4:	52880813          	addi	a6,a6,1320 # 8e8 <digits>
 3c8:	88ba                	mv	a7,a4
 3ca:	0017051b          	addiw	a0,a4,1
 3ce:	872a                	mv	a4,a0
 3d0:	02c5f7b3          	remu	a5,a1,a2
 3d4:	97c2                	add	a5,a5,a6
 3d6:	0007c783          	lbu	a5,0(a5)
 3da:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 3de:	87ae                	mv	a5,a1
 3e0:	02c5d5b3          	divu	a1,a1,a2
 3e4:	0685                	addi	a3,a3,1
 3e6:	fec7f1e3          	bgeu	a5,a2,3c8 <printint+0x32>
  if (neg)
 3ea:	00030b63          	beqz	t1,400 <printint+0x6a>
    buf[i++] = '-';
 3ee:	fd040793          	addi	a5,s0,-48
 3f2:	953e                	add	a0,a0,a5
 3f4:	02d00793          	li	a5,45
 3f8:	fef50423          	sb	a5,-24(a0)
 3fc:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 400:	02e05563          	blez	a4,42a <printint+0x94>
 404:	fc26                	sd	s1,56(sp)
 406:	377d                	addiw	a4,a4,-1
 408:	00e984b3          	add	s1,s3,a4
 40c:	19fd                	addi	s3,s3,-1
 40e:	99ba                	add	s3,s3,a4
 410:	1702                	slli	a4,a4,0x20
 412:	9301                	srli	a4,a4,0x20
 414:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 418:	0004c583          	lbu	a1,0(s1)
 41c:	854a                	mv	a0,s2
 41e:	f5bff0ef          	jal	378 <putc>
  while (--i >= 0)
 422:	14fd                	addi	s1,s1,-1
 424:	ff349ae3          	bne	s1,s3,418 <printint+0x82>
 428:	74e2                	ld	s1,56(sp)
}
 42a:	60a6                	ld	ra,72(sp)
 42c:	6406                	ld	s0,64(sp)
 42e:	7942                	ld	s2,48(sp)
 430:	79a2                	ld	s3,40(sp)
 432:	6161                	addi	sp,sp,80
 434:	8082                	ret

0000000000000436 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 436:	711d                	addi	sp,sp,-96
 438:	ec86                	sd	ra,88(sp)
 43a:	e8a2                	sd	s0,80(sp)
 43c:	e4a6                	sd	s1,72(sp)
 43e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 440:	0005c483          	lbu	s1,0(a1)
 444:	2a048063          	beqz	s1,6e4 <vprintf+0x2ae>
 448:	e0ca                	sd	s2,64(sp)
 44a:	fc4e                	sd	s3,56(sp)
 44c:	f852                	sd	s4,48(sp)
 44e:	f456                	sd	s5,40(sp)
 450:	f05a                	sd	s6,32(sp)
 452:	ec5e                	sd	s7,24(sp)
 454:	e862                	sd	s8,16(sp)
 456:	8b2a                	mv	s6,a0
 458:	8a2e                	mv	s4,a1
 45a:	8bb2                	mv	s7,a2
  state = 0;
 45c:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 45e:	4901                	li	s2,0
 460:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 462:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 466:	06400c13          	li	s8,100
 46a:	a00d                	j	48c <vprintf+0x56>
        putc(fd, c0);
 46c:	85a6                	mv	a1,s1
 46e:	855a                	mv	a0,s6
 470:	f09ff0ef          	jal	378 <putc>
 474:	a019                	j	47a <vprintf+0x44>
    } else if (state == '%') {
 476:	03598363          	beq	s3,s5,49c <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 47a:	0019079b          	addiw	a5,s2,1
 47e:	893e                	mv	s2,a5
 480:	873e                	mv	a4,a5
 482:	97d2                	add	a5,a5,s4
 484:	0007c483          	lbu	s1,0(a5)
 488:	24048763          	beqz	s1,6d6 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 48c:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 490:	fe0993e3          	bnez	s3,476 <vprintf+0x40>
      if (c0 == '%') {
 494:	fd579ce3          	bne	a5,s5,46c <vprintf+0x36>
        state = '%';
 498:	89be                	mv	s3,a5
 49a:	b7c5                	j	47a <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 49c:	00ea06b3          	add	a3,s4,a4
 4a0:	0016c603          	lbu	a2,1(a3)
      if (c1)
 4a4:	24060563          	beqz	a2,6ee <vprintf+0x2b8>
      if (c0 == 'd') {
 4a8:	0b878763          	beq	a5,s8,556 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4ac:	f9478693          	addi	a3,a5,-108
 4b0:	0016b693          	seqz	a3,a3
 4b4:	f9c60593          	addi	a1,a2,-100
 4b8:	0015b593          	seqz	a1,a1
 4bc:	8df5                	and	a1,a1,a3
 4be:	e9c5                	bnez	a1,56e <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 4c0:	9752                	add	a4,a4,s4
 4c2:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 4c6:	f9460713          	addi	a4,a2,-108
 4ca:	00173713          	seqz	a4,a4
 4ce:	8f75                	and	a4,a4,a3
 4d0:	f9c50593          	addi	a1,a0,-100
 4d4:	0015b593          	seqz	a1,a1
 4d8:	8df9                	and	a1,a1,a4
 4da:	e5dd                	bnez	a1,588 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 4dc:	07500593          	li	a1,117
 4e0:	0cb78163          	beq	a5,a1,5a2 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 4e4:	f8b60593          	addi	a1,a2,-117
 4e8:	0015b593          	seqz	a1,a1
 4ec:	8df5                	and	a1,a1,a3
 4ee:	e5f1                	bnez	a1,5ba <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 4f0:	f8b50593          	addi	a1,a0,-117
 4f4:	0015b593          	seqz	a1,a1
 4f8:	8df9                	and	a1,a1,a4
 4fa:	ede9                	bnez	a1,5d4 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 4fc:	07800593          	li	a1,120
 500:	0eb78763          	beq	a5,a1,5ee <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 504:	f8860613          	addi	a2,a2,-120
 508:	00163613          	seqz	a2,a2
 50c:	8ef1                	and	a3,a3,a2
 50e:	0e069c63          	bnez	a3,606 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 512:	f8850513          	addi	a0,a0,-120
 516:	00153513          	seqz	a0,a0
 51a:	8f69                	and	a4,a4,a0
 51c:	10071263          	bnez	a4,620 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 520:	07000713          	li	a4,112
 524:	10e78a63          	beq	a5,a4,638 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 528:	06300713          	li	a4,99
 52c:	14e78a63          	beq	a5,a4,680 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 530:	07300713          	li	a4,115
 534:	16e78063          	beq	a5,a4,694 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 538:	02500713          	li	a4,37
 53c:	18e78863          	beq	a5,a4,6cc <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 540:	02500593          	li	a1,37
 544:	855a                	mv	a0,s6
 546:	e33ff0ef          	jal	378 <putc>
        putc(fd, c0);
 54a:	85a6                	mv	a1,s1
 54c:	855a                	mv	a0,s6
 54e:	e2bff0ef          	jal	378 <putc>
      }

      state = 0;
 552:	4981                	li	s3,0
 554:	b71d                	j	47a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 556:	008b8493          	addi	s1,s7,8
 55a:	4685                	li	a3,1
 55c:	4629                	li	a2,10
 55e:	000ba583          	lw	a1,0(s7)
 562:	855a                	mv	a0,s6
 564:	e33ff0ef          	jal	396 <printint>
 568:	8ba6                	mv	s7,s1
      state = 0;
 56a:	4981                	li	s3,0
 56c:	b739                	j	47a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 56e:	008b8493          	addi	s1,s7,8
 572:	4685                	li	a3,1
 574:	4629                	li	a2,10
 576:	000bb583          	ld	a1,0(s7)
 57a:	855a                	mv	a0,s6
 57c:	e1bff0ef          	jal	396 <printint>
        i += 1;
 580:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 582:	8ba6                	mv	s7,s1
      state = 0;
 584:	4981                	li	s3,0
 586:	bdd5                	j	47a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 588:	008b8493          	addi	s1,s7,8
 58c:	4685                	li	a3,1
 58e:	4629                	li	a2,10
 590:	000bb583          	ld	a1,0(s7)
 594:	855a                	mv	a0,s6
 596:	e01ff0ef          	jal	396 <printint>
        i += 2;
 59a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 59c:	8ba6                	mv	s7,s1
      state = 0;
 59e:	4981                	li	s3,0
        i += 2;
 5a0:	bde9                	j	47a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5a2:	008b8493          	addi	s1,s7,8
 5a6:	4681                	li	a3,0
 5a8:	4629                	li	a2,10
 5aa:	000be583          	lwu	a1,0(s7)
 5ae:	855a                	mv	a0,s6
 5b0:	de7ff0ef          	jal	396 <printint>
 5b4:	8ba6                	mv	s7,s1
      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	b5c9                	j	47a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ba:	008b8493          	addi	s1,s7,8
 5be:	4681                	li	a3,0
 5c0:	4629                	li	a2,10
 5c2:	000bb583          	ld	a1,0(s7)
 5c6:	855a                	mv	a0,s6
 5c8:	dcfff0ef          	jal	396 <printint>
        i += 1;
 5cc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ce:	8ba6                	mv	s7,s1
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	b565                	j	47a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d4:	008b8493          	addi	s1,s7,8
 5d8:	4681                	li	a3,0
 5da:	4629                	li	a2,10
 5dc:	000bb583          	ld	a1,0(s7)
 5e0:	855a                	mv	a0,s6
 5e2:	db5ff0ef          	jal	396 <printint>
        i += 2;
 5e6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e8:	8ba6                	mv	s7,s1
      state = 0;
 5ea:	4981                	li	s3,0
        i += 2;
 5ec:	b579                	j	47a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5ee:	008b8493          	addi	s1,s7,8
 5f2:	4681                	li	a3,0
 5f4:	4641                	li	a2,16
 5f6:	000be583          	lwu	a1,0(s7)
 5fa:	855a                	mv	a0,s6
 5fc:	d9bff0ef          	jal	396 <printint>
 600:	8ba6                	mv	s7,s1
      state = 0;
 602:	4981                	li	s3,0
 604:	bd9d                	j	47a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 606:	008b8493          	addi	s1,s7,8
 60a:	4681                	li	a3,0
 60c:	4641                	li	a2,16
 60e:	000bb583          	ld	a1,0(s7)
 612:	855a                	mv	a0,s6
 614:	d83ff0ef          	jal	396 <printint>
        i += 1;
 618:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 61a:	8ba6                	mv	s7,s1
      state = 0;
 61c:	4981                	li	s3,0
 61e:	bdb1                	j	47a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 620:	008b8493          	addi	s1,s7,8
 624:	4641                	li	a2,16
 626:	000bb583          	ld	a1,0(s7)
 62a:	855a                	mv	a0,s6
 62c:	d6bff0ef          	jal	396 <printint>
        i += 2;
 630:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 632:	8ba6                	mv	s7,s1
      state = 0;
 634:	4981                	li	s3,0
        i += 2;
 636:	b591                	j	47a <vprintf+0x44>
 638:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 63a:	008b8793          	addi	a5,s7,8
 63e:	8cbe                	mv	s9,a5
 640:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 644:	03000593          	li	a1,48
 648:	855a                	mv	a0,s6
 64a:	d2fff0ef          	jal	378 <putc>
  putc(fd, 'x');
 64e:	07800593          	li	a1,120
 652:	855a                	mv	a0,s6
 654:	d25ff0ef          	jal	378 <putc>
 658:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 65a:	00000b97          	auipc	s7,0x0
 65e:	28eb8b93          	addi	s7,s7,654 # 8e8 <digits>
 662:	03c9d793          	srli	a5,s3,0x3c
 666:	97de                	add	a5,a5,s7
 668:	0007c583          	lbu	a1,0(a5)
 66c:	855a                	mv	a0,s6
 66e:	d0bff0ef          	jal	378 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 672:	0992                	slli	s3,s3,0x4
 674:	34fd                	addiw	s1,s1,-1
 676:	f4f5                	bnez	s1,662 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 678:	8be6                	mv	s7,s9
      state = 0;
 67a:	4981                	li	s3,0
 67c:	6ca2                	ld	s9,8(sp)
 67e:	bbf5                	j	47a <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 680:	008b8493          	addi	s1,s7,8
 684:	000bc583          	lbu	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	cefff0ef          	jal	378 <putc>
 68e:	8ba6                	mv	s7,s1
      state = 0;
 690:	4981                	li	s3,0
 692:	b3e5                	j	47a <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 694:	008b8993          	addi	s3,s7,8
 698:	000bb483          	ld	s1,0(s7)
 69c:	cc91                	beqz	s1,6b8 <vprintf+0x282>
        for (; *s; s++)
 69e:	0004c583          	lbu	a1,0(s1)
 6a2:	c195                	beqz	a1,6c6 <vprintf+0x290>
          putc(fd, *s);
 6a4:	855a                	mv	a0,s6
 6a6:	cd3ff0ef          	jal	378 <putc>
        for (; *s; s++)
 6aa:	0485                	addi	s1,s1,1
 6ac:	0004c583          	lbu	a1,0(s1)
 6b0:	f9f5                	bnez	a1,6a4 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 6b2:	8bce                	mv	s7,s3
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	b3d1                	j	47a <vprintf+0x44>
          s = "(null)";
 6b8:	00000497          	auipc	s1,0x0
 6bc:	22848493          	addi	s1,s1,552 # 8e0 <malloc+0xf6>
        for (; *s; s++)
 6c0:	02800593          	li	a1,40
 6c4:	b7c5                	j	6a4 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 6c6:	8bce                	mv	s7,s3
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	bb45                	j	47a <vprintf+0x44>
        putc(fd, '%');
 6cc:	85be                	mv	a1,a5
 6ce:	855a                	mv	a0,s6
 6d0:	ca9ff0ef          	jal	378 <putc>
 6d4:	bdbd                	j	552 <vprintf+0x11c>
 6d6:	6906                	ld	s2,64(sp)
 6d8:	79e2                	ld	s3,56(sp)
 6da:	7a42                	ld	s4,48(sp)
 6dc:	7aa2                	ld	s5,40(sp)
 6de:	7b02                	ld	s6,32(sp)
 6e0:	6be2                	ld	s7,24(sp)
 6e2:	6c42                	ld	s8,16(sp)
    }
  }
}
 6e4:	60e6                	ld	ra,88(sp)
 6e6:	6446                	ld	s0,80(sp)
 6e8:	64a6                	ld	s1,72(sp)
 6ea:	6125                	addi	sp,sp,96
 6ec:	8082                	ret
      if (c0 == 'd') {
 6ee:	06400713          	li	a4,100
 6f2:	e6e782e3          	beq	a5,a4,556 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 6f6:	f9478693          	addi	a3,a5,-108
 6fa:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6fe:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 700:	4701                	li	a4,0
 702:	bbe9                	j	4dc <vprintf+0xa6>

0000000000000704 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 704:	715d                	addi	sp,sp,-80
 706:	ec06                	sd	ra,24(sp)
 708:	e822                	sd	s0,16(sp)
 70a:	1000                	addi	s0,sp,32
 70c:	e010                	sd	a2,0(s0)
 70e:	e414                	sd	a3,8(s0)
 710:	e818                	sd	a4,16(s0)
 712:	ec1c                	sd	a5,24(s0)
 714:	03043023          	sd	a6,32(s0)
 718:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 71c:	8622                	mv	a2,s0
 71e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 722:	d15ff0ef          	jal	436 <vprintf>
}
 726:	60e2                	ld	ra,24(sp)
 728:	6442                	ld	s0,16(sp)
 72a:	6161                	addi	sp,sp,80
 72c:	8082                	ret

000000000000072e <printf>:

void
printf(const char *fmt, ...)
{
 72e:	711d                	addi	sp,sp,-96
 730:	ec06                	sd	ra,24(sp)
 732:	e822                	sd	s0,16(sp)
 734:	1000                	addi	s0,sp,32
 736:	e40c                	sd	a1,8(s0)
 738:	e810                	sd	a2,16(s0)
 73a:	ec14                	sd	a3,24(s0)
 73c:	f018                	sd	a4,32(s0)
 73e:	f41c                	sd	a5,40(s0)
 740:	03043823          	sd	a6,48(s0)
 744:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 748:	00840613          	addi	a2,s0,8
 74c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 750:	85aa                	mv	a1,a0
 752:	4505                	li	a0,1
 754:	ce3ff0ef          	jal	436 <vprintf>
}
 758:	60e2                	ld	ra,24(sp)
 75a:	6442                	ld	s0,16(sp)
 75c:	6125                	addi	sp,sp,96
 75e:	8082                	ret

0000000000000760 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 760:	1141                	addi	sp,sp,-16
 762:	e406                	sd	ra,8(sp)
 764:	e022                	sd	s0,0(sp)
 766:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 768:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76c:	00001797          	auipc	a5,0x1
 770:	8947b783          	ld	a5,-1900(a5) # 1000 <freep>
 774:	a095                	j	7d8 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 776:	ff852583          	lw	a1,-8(a0)
 77a:	6390                	ld	a2,0(a5)
 77c:	02059813          	slli	a6,a1,0x20
 780:	01c85693          	srli	a3,a6,0x1c
 784:	96ba                	add	a3,a3,a4
 786:	02d60563          	beq	a2,a3,7b0 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 78a:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 78e:	4790                	lw	a2,8(a5)
 790:	02061593          	slli	a1,a2,0x20
 794:	01c5d693          	srli	a3,a1,0x1c
 798:	96be                	add	a3,a3,a5
 79a:	02d70263          	beq	a4,a3,7be <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 79e:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7a0:	00001717          	auipc	a4,0x1
 7a4:	86f73023          	sd	a5,-1952(a4) # 1000 <freep>
}
 7a8:	60a2                	ld	ra,8(sp)
 7aa:	6402                	ld	s0,0(sp)
 7ac:	0141                	addi	sp,sp,16
 7ae:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7b0:	4614                	lw	a3,8(a2)
 7b2:	9ead                	addw	a3,a3,a1
 7b4:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b8:	6394                	ld	a3,0(a5)
 7ba:	6290                	ld	a2,0(a3)
 7bc:	b7f9                	j	78a <free+0x2a>
    p->s.size += bp->s.size;
 7be:	ff852703          	lw	a4,-8(a0)
 7c2:	9f31                	addw	a4,a4,a2
 7c4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7c6:	ff053703          	ld	a4,-16(a0)
 7ca:	bfd1                	j	79e <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7cc:	6394                	ld	a3,0(a5)
 7ce:	00d7e463          	bltu	a5,a3,7d6 <free+0x76>
 7d2:	fad762e3          	bltu	a4,a3,776 <free+0x16>
 7d6:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d8:	fee7fae3          	bgeu	a5,a4,7cc <free+0x6c>
 7dc:	6394                	ld	a3,0(a5)
 7de:	f8d76ce3          	bltu	a4,a3,776 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e2:	f8d7fae3          	bgeu	a5,a3,776 <free+0x16>
 7e6:	87b6                	mv	a5,a3
 7e8:	bfc5                	j	7d8 <free+0x78>

00000000000007ea <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 7ea:	7139                	addi	sp,sp,-64
 7ec:	fc06                	sd	ra,56(sp)
 7ee:	f822                	sd	s0,48(sp)
 7f0:	f04a                	sd	s2,32(sp)
 7f2:	ec4e                	sd	s3,24(sp)
 7f4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 7f6:	02051993          	slli	s3,a0,0x20
 7fa:	0209d993          	srli	s3,s3,0x20
 7fe:	09bd                	addi	s3,s3,15
 800:	0049d993          	srli	s3,s3,0x4
 804:	2985                	addiw	s3,s3,1
 806:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 808:	00000517          	auipc	a0,0x0
 80c:	7f853503          	ld	a0,2040(a0) # 1000 <freep>
 810:	c905                	beqz	a0,840 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 812:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 814:	4798                	lw	a4,8(a5)
 816:	09377663          	bgeu	a4,s3,8a2 <malloc+0xb8>
 81a:	f426                	sd	s1,40(sp)
 81c:	e852                	sd	s4,16(sp)
 81e:	e456                	sd	s5,8(sp)
 820:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 822:	8a4e                	mv	s4,s3
 824:	6705                	lui	a4,0x1
 826:	00e9f363          	bgeu	s3,a4,82c <malloc+0x42>
 82a:	6a05                	lui	s4,0x1
 82c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 830:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 834:	00000497          	auipc	s1,0x0
 838:	7cc48493          	addi	s1,s1,1996 # 1000 <freep>
  if (p == SBRK_ERROR)
 83c:	5afd                	li	s5,-1
 83e:	a83d                	j	87c <malloc+0x92>
 840:	f426                	sd	s1,40(sp)
 842:	e852                	sd	s4,16(sp)
 844:	e456                	sd	s5,8(sp)
 846:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 848:	00000797          	auipc	a5,0x0
 84c:	7c878793          	addi	a5,a5,1992 # 1010 <base>
 850:	00000717          	auipc	a4,0x0
 854:	7af73823          	sd	a5,1968(a4) # 1000 <freep>
 858:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 85a:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 85e:	b7d1                	j	822 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 860:	6398                	ld	a4,0(a5)
 862:	e118                	sd	a4,0(a0)
 864:	a899                	j	8ba <malloc+0xd0>
  hp->s.size = nu;
 866:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 86a:	0541                	addi	a0,a0,16
 86c:	ef5ff0ef          	jal	760 <free>
  return freep;
 870:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 872:	c125                	beqz	a0,8d2 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 874:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 876:	4798                	lw	a4,8(a5)
 878:	03277163          	bgeu	a4,s2,89a <malloc+0xb0>
    if (p == freep)
 87c:	6098                	ld	a4,0(s1)
 87e:	853e                	mv	a0,a5
 880:	fef71ae3          	bne	a4,a5,874 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 884:	8552                	mv	a0,s4
 886:	a0fff0ef          	jal	294 <sbrk>
  if (p == SBRK_ERROR)
 88a:	fd551ee3          	bne	a0,s5,866 <malloc+0x7c>
        return 0;
 88e:	4501                	li	a0,0
 890:	74a2                	ld	s1,40(sp)
 892:	6a42                	ld	s4,16(sp)
 894:	6aa2                	ld	s5,8(sp)
 896:	6b02                	ld	s6,0(sp)
 898:	a03d                	j	8c6 <malloc+0xdc>
 89a:	74a2                	ld	s1,40(sp)
 89c:	6a42                	ld	s4,16(sp)
 89e:	6aa2                	ld	s5,8(sp)
 8a0:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8a2:	fae90fe3          	beq	s2,a4,860 <malloc+0x76>
        p->s.size -= nunits;
 8a6:	4137073b          	subw	a4,a4,s3
 8aa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ac:	02071693          	slli	a3,a4,0x20
 8b0:	01c6d713          	srli	a4,a3,0x1c
 8b4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ba:	00000717          	auipc	a4,0x0
 8be:	74a73323          	sd	a0,1862(a4) # 1000 <freep>
      return (void *)(p + 1);
 8c2:	01078513          	addi	a0,a5,16
  }
}
 8c6:	70e2                	ld	ra,56(sp)
 8c8:	7442                	ld	s0,48(sp)
 8ca:	7902                	ld	s2,32(sp)
 8cc:	69e2                	ld	s3,24(sp)
 8ce:	6121                	addi	sp,sp,64
 8d0:	8082                	ret
 8d2:	74a2                	ld	s1,40(sp)
 8d4:	6a42                	ld	s4,16(sp)
 8d6:	6aa2                	ld	s5,8(sp)
 8d8:	6b02                	ld	s6,0(sp)
 8da:	b7f5                	j	8c6 <malloc+0xdc>
