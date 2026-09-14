
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  if (argc != 3) {
   8:	478d                	li	a5,3
   a:	00f50d63          	beq	a0,a5,24 <main+0x24>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	91058593          	addi	a1,a1,-1776 # 920 <malloc+0xfa>
  18:	4509                	li	a0,2
  1a:	726000ef          	jal	740 <fprintf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	2e4000ef          	jal	304 <exit>
  24:	e426                	sd	s1,8(sp)
  26:	84ae                	mv	s1,a1
  }
  if (link(argv[1], argv[2]) < 0)
  28:	698c                	ld	a1,16(a1)
  2a:	6488                	ld	a0,8(s1)
  2c:	338000ef          	jal	364 <link>
  30:	00054563          	bltz	a0,3a <main+0x3a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  34:	4501                	li	a0,0
  36:	2ce000ef          	jal	304 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  3a:	6894                	ld	a3,16(s1)
  3c:	6490                	ld	a2,8(s1)
  3e:	00001597          	auipc	a1,0x1
  42:	8fa58593          	addi	a1,a1,-1798 # 938 <malloc+0x112>
  46:	4509                	li	a0,2
  48:	6f8000ef          	jal	740 <fprintf>
  4c:	b7e5                	j	34 <main+0x34>

000000000000004e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  4e:	1141                	addi	sp,sp,-16
  50:	e406                	sd	ra,8(sp)
  52:	e022                	sd	s0,0(sp)
  54:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  56:	fabff0ef          	jal	0 <main>
  exit(r);
  5a:	2aa000ef          	jal	304 <exit>

000000000000005e <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  5e:	1141                	addi	sp,sp,-16
  60:	e406                	sd	ra,8(sp)
  62:	e022                	sd	s0,0(sp)
  64:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  66:	87aa                	mv	a5,a0
  68:	0585                	addi	a1,a1,1
  6a:	0785                	addi	a5,a5,1
  6c:	fff5c703          	lbu	a4,-1(a1)
  70:	fee78fa3          	sb	a4,-1(a5)
  74:	fb75                	bnez	a4,68 <strcpy+0xa>
    ;
  return os;
}
  76:	60a2                	ld	ra,8(sp)
  78:	6402                	ld	s0,0(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cb91                	beqz	a5,9e <strcmp+0x20>
  8c:	0005c703          	lbu	a4,0(a1)
  90:	00f71763          	bne	a4,a5,9e <strcmp+0x20>
    p++, q++;
  94:	0505                	addi	a0,a0,1
  96:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  98:	00054783          	lbu	a5,0(a0)
  9c:	fbe5                	bnez	a5,8c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  9e:	0005c503          	lbu	a0,0(a1)
}
  a2:	40a7853b          	subw	a0,a5,a0
  a6:	60a2                	ld	ra,8(sp)
  a8:	6402                	ld	s0,0(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strlen>:

uint
strlen(const char *s)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e406                	sd	ra,8(sp)
  b2:	e022                	sd	s0,0(sp)
  b4:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cf91                	beqz	a5,d6 <strlen+0x28>
  bc:	00150793          	addi	a5,a0,1
  c0:	86be                	mv	a3,a5
  c2:	0785                	addi	a5,a5,1
  c4:	fff7c703          	lbu	a4,-1(a5)
  c8:	ff65                	bnez	a4,c0 <strlen+0x12>
  ca:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  ce:	60a2                	ld	ra,8(sp)
  d0:	6402                	ld	s0,0(sp)
  d2:	0141                	addi	sp,sp,16
  d4:	8082                	ret
  for (n = 0; s[n]; n++)
  d6:	4501                	li	a0,0
  d8:	bfdd                	j	ce <strlen+0x20>

00000000000000da <memset>:

void *
memset(void *dst, int c, uint n)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e406                	sd	ra,8(sp)
  de:	e022                	sd	s0,0(sp)
  e0:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  e2:	ca19                	beqz	a2,f8 <memset+0x1e>
  e4:	87aa                	mv	a5,a0
  e6:	1602                	slli	a2,a2,0x20
  e8:	9201                	srli	a2,a2,0x20
  ea:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ee:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  f2:	0785                	addi	a5,a5,1
  f4:	fee79de3          	bne	a5,a4,ee <memset+0x14>
  }
  return dst;
}
  f8:	60a2                	ld	ra,8(sp)
  fa:	6402                	ld	s0,0(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret

0000000000000100 <strchr>:

char *
strchr(const char *s, char c)
{
 100:	1141                	addi	sp,sp,-16
 102:	e406                	sd	ra,8(sp)
 104:	e022                	sd	s0,0(sp)
 106:	0800                	addi	s0,sp,16
  for (; *s; s++)
 108:	00054783          	lbu	a5,0(a0)
 10c:	c799                	beqz	a5,11a <strchr+0x1a>
    if (*s == c)
 10e:	00f58763          	beq	a1,a5,11c <strchr+0x1c>
  for (; *s; s++)
 112:	0505                	addi	a0,a0,1
 114:	00054783          	lbu	a5,0(a0)
 118:	fbfd                	bnez	a5,10e <strchr+0xe>
      return (char *)s;
  return 0;
 11a:	4501                	li	a0,0
}
 11c:	60a2                	ld	ra,8(sp)
 11e:	6402                	ld	s0,0(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret

0000000000000124 <gets>:

char *
gets(char *buf, int max)
{
 124:	711d                	addi	sp,sp,-96
 126:	ec86                	sd	ra,88(sp)
 128:	e8a2                	sd	s0,80(sp)
 12a:	e4a6                	sd	s1,72(sp)
 12c:	e0ca                	sd	s2,64(sp)
 12e:	fc4e                	sd	s3,56(sp)
 130:	f852                	sd	s4,48(sp)
 132:	f456                	sd	s5,40(sp)
 134:	f05a                	sd	s6,32(sp)
 136:	ec5e                	sd	s7,24(sp)
 138:	e862                	sd	s8,16(sp)
 13a:	1080                	addi	s0,sp,96
 13c:	8baa                	mv	s7,a0
 13e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 140:	892a                	mv	s2,a0
 142:	4481                	li	s1,0
    cc = read(0, &c, 1);
 144:	faf40b13          	addi	s6,s0,-81
 148:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 14a:	8c26                	mv	s8,s1
 14c:	0014899b          	addiw	s3,s1,1
 150:	84ce                	mv	s1,s3
 152:	0349d863          	bge	s3,s4,182 <gets+0x5e>
    cc = read(0, &c, 1);
 156:	8656                	mv	a2,s5
 158:	85da                	mv	a1,s6
 15a:	4501                	li	a0,0
 15c:	1c0000ef          	jal	31c <read>
    if (cc < 1)
 160:	02a05163          	blez	a0,182 <gets+0x5e>
      break;
    buf[i++] = c;
 164:	faf44783          	lbu	a5,-81(s0)
 168:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 16c:	0905                	addi	s2,s2,1
 16e:	ff678713          	addi	a4,a5,-10
 172:	00173713          	seqz	a4,a4
 176:	17cd                	addi	a5,a5,-13
 178:	0017b793          	seqz	a5,a5
 17c:	8fd9                	or	a5,a5,a4
 17e:	d7f1                	beqz	a5,14a <gets+0x26>
    buf[i++] = c;
 180:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 182:	9c5e                	add	s8,s8,s7
 184:	000c0023          	sb	zero,0(s8)
  return buf;
}
 188:	855e                	mv	a0,s7
 18a:	60e6                	ld	ra,88(sp)
 18c:	6446                	ld	s0,80(sp)
 18e:	64a6                	ld	s1,72(sp)
 190:	6906                	ld	s2,64(sp)
 192:	79e2                	ld	s3,56(sp)
 194:	7a42                	ld	s4,48(sp)
 196:	7aa2                	ld	s5,40(sp)
 198:	7b02                	ld	s6,32(sp)
 19a:	6be2                	ld	s7,24(sp)
 19c:	6c42                	ld	s8,16(sp)
 19e:	6125                	addi	sp,sp,96
 1a0:	8082                	ret

00000000000001a2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a2:	1101                	addi	sp,sp,-32
 1a4:	ec06                	sd	ra,24(sp)
 1a6:	e822                	sd	s0,16(sp)
 1a8:	e04a                	sd	s2,0(sp)
 1aa:	1000                	addi	s0,sp,32
 1ac:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ae:	4581                	li	a1,0
 1b0:	194000ef          	jal	344 <open>
  if (fd < 0)
 1b4:	02054263          	bltz	a0,1d8 <stat+0x36>
 1b8:	e426                	sd	s1,8(sp)
 1ba:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1bc:	85ca                	mv	a1,s2
 1be:	19e000ef          	jal	35c <fstat>
 1c2:	892a                	mv	s2,a0
  close(fd);
 1c4:	8526                	mv	a0,s1
 1c6:	166000ef          	jal	32c <close>
  return r;
 1ca:	64a2                	ld	s1,8(sp)
}
 1cc:	854a                	mv	a0,s2
 1ce:	60e2                	ld	ra,24(sp)
 1d0:	6442                	ld	s0,16(sp)
 1d2:	6902                	ld	s2,0(sp)
 1d4:	6105                	addi	sp,sp,32
 1d6:	8082                	ret
    return -1;
 1d8:	57fd                	li	a5,-1
 1da:	893e                	mv	s2,a5
 1dc:	bfc5                	j	1cc <stat+0x2a>

00000000000001de <atoi>:

int
atoi(const char *s)
{
 1de:	1141                	addi	sp,sp,-16
 1e0:	e406                	sd	ra,8(sp)
 1e2:	e022                	sd	s0,0(sp)
 1e4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1e6:	00054683          	lbu	a3,0(a0)
 1ea:	fd06879b          	addiw	a5,a3,-48
 1ee:	0ff7f793          	zext.b	a5,a5
 1f2:	4625                	li	a2,9
 1f4:	02f66963          	bltu	a2,a5,226 <atoi+0x48>
 1f8:	872a                	mv	a4,a0
  n = 0;
 1fa:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 1fc:	0705                	addi	a4,a4,1
 1fe:	0025179b          	slliw	a5,a0,0x2
 202:	9fa9                	addw	a5,a5,a0
 204:	0017979b          	slliw	a5,a5,0x1
 208:	9fb5                	addw	a5,a5,a3
 20a:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 20e:	00074683          	lbu	a3,0(a4)
 212:	fd06879b          	addiw	a5,a3,-48
 216:	0ff7f793          	zext.b	a5,a5
 21a:	fef671e3          	bgeu	a2,a5,1fc <atoi+0x1e>
  return n;
}
 21e:	60a2                	ld	ra,8(sp)
 220:	6402                	ld	s0,0(sp)
 222:	0141                	addi	sp,sp,16
 224:	8082                	ret
  n = 0;
 226:	4501                	li	a0,0
 228:	bfdd                	j	21e <atoi+0x40>

000000000000022a <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 22a:	1141                	addi	sp,sp,-16
 22c:	e406                	sd	ra,8(sp)
 22e:	e022                	sd	s0,0(sp)
 230:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 232:	02b57563          	bgeu	a0,a1,25c <memmove+0x32>
    while (n-- > 0)
 236:	00c05f63          	blez	a2,254 <memmove+0x2a>
 23a:	1602                	slli	a2,a2,0x20
 23c:	9201                	srli	a2,a2,0x20
 23e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 242:	872a                	mv	a4,a0
      *dst++ = *src++;
 244:	0585                	addi	a1,a1,1
 246:	0705                	addi	a4,a4,1
 248:	fff5c683          	lbu	a3,-1(a1)
 24c:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 250:	fee79ae3          	bne	a5,a4,244 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 254:	60a2                	ld	ra,8(sp)
 256:	6402                	ld	s0,0(sp)
 258:	0141                	addi	sp,sp,16
 25a:	8082                	ret
    while (n-- > 0)
 25c:	fec05ce3          	blez	a2,254 <memmove+0x2a>
    dst += n;
 260:	00c50733          	add	a4,a0,a2
    src += n;
 264:	95b2                	add	a1,a1,a2
 266:	fff6079b          	addiw	a5,a2,-1
 26a:	1782                	slli	a5,a5,0x20
 26c:	9381                	srli	a5,a5,0x20
 26e:	fff7c793          	not	a5,a5
 272:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 274:	15fd                	addi	a1,a1,-1
 276:	177d                	addi	a4,a4,-1
 278:	0005c683          	lbu	a3,0(a1)
 27c:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 280:	fef71ae3          	bne	a4,a5,274 <memmove+0x4a>
 284:	bfc1                	j	254 <memmove+0x2a>

0000000000000286 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 286:	1141                	addi	sp,sp,-16
 288:	e406                	sd	ra,8(sp)
 28a:	e022                	sd	s0,0(sp)
 28c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 28e:	ce19                	beqz	a2,2ac <memcmp+0x26>
 290:	1602                	slli	a2,a2,0x20
 292:	9201                	srli	a2,a2,0x20
 294:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 298:	00054783          	lbu	a5,0(a0)
 29c:	0005c703          	lbu	a4,0(a1)
 2a0:	00e79b63          	bne	a5,a4,2b6 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 2a4:	0505                	addi	a0,a0,1
    p2++;
 2a6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2a8:	fed518e3          	bne	a0,a3,298 <memcmp+0x12>
  }
  return 0;
 2ac:	4501                	li	a0,0
}
 2ae:	60a2                	ld	ra,8(sp)
 2b0:	6402                	ld	s0,0(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret
      return *p1 - *p2;
 2b6:	40e7853b          	subw	a0,a5,a4
 2ba:	bfd5                	j	2ae <memcmp+0x28>

00000000000002bc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e406                	sd	ra,8(sp)
 2c0:	e022                	sd	s0,0(sp)
 2c2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2c4:	f67ff0ef          	jal	22a <memmove>
}
 2c8:	60a2                	ld	ra,8(sp)
 2ca:	6402                	ld	s0,0(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret

00000000000002d0 <sbrk>:

char *
sbrk(int n)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e406                	sd	ra,8(sp)
 2d4:	e022                	sd	s0,0(sp)
 2d6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2d8:	4585                	li	a1,1
 2da:	0b2000ef          	jal	38c <sys_sbrk>
}
 2de:	60a2                	ld	ra,8(sp)
 2e0:	6402                	ld	s0,0(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret

00000000000002e6 <sbrklazy>:

char *
sbrklazy(int n)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2ee:	4589                	li	a1,2
 2f0:	09c000ef          	jal	38c <sys_sbrk>
}
 2f4:	60a2                	ld	ra,8(sp)
 2f6:	6402                	ld	s0,0(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret

00000000000002fc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2fc:	4885                	li	a7,1
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <exit>:
.global exit
exit:
 li a7, SYS_exit
 304:	4889                	li	a7,2
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <wait>:
.global wait
wait:
 li a7, SYS_wait
 30c:	488d                	li	a7,3
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 314:	4891                	li	a7,4
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <read>:
.global read
read:
 li a7, SYS_read
 31c:	4895                	li	a7,5
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <write>:
.global write
write:
 li a7, SYS_write
 324:	48c1                	li	a7,16
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <close>:
.global close
close:
 li a7, SYS_close
 32c:	48d5                	li	a7,21
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <kill>:
.global kill
kill:
 li a7, SYS_kill
 334:	4899                	li	a7,6
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <exec>:
.global exec
exec:
 li a7, SYS_exec
 33c:	489d                	li	a7,7
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <open>:
.global open
open:
 li a7, SYS_open
 344:	48bd                	li	a7,15
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 34c:	48c5                	li	a7,17
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 354:	48c9                	li	a7,18
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 35c:	48a1                	li	a7,8
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <link>:
.global link
link:
 li a7, SYS_link
 364:	48cd                	li	a7,19
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 36c:	48d1                	li	a7,20
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 374:	48a5                	li	a7,9
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <dup>:
.global dup
dup:
 li a7, SYS_dup
 37c:	48a9                	li	a7,10
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 384:	48ad                	li	a7,11
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 38c:	48b1                	li	a7,12
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <pause>:
.global pause
pause:
 li a7, SYS_pause
 394:	48b5                	li	a7,13
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 39c:	48b9                	li	a7,14
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <sync>:
.global sync
sync:
 li a7, SYS_sync
 3a4:	48d9                	li	a7,22
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3ac:	48dd                	li	a7,23
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b4:	1101                	addi	sp,sp,-32
 3b6:	ec06                	sd	ra,24(sp)
 3b8:	e822                	sd	s0,16(sp)
 3ba:	1000                	addi	s0,sp,32
 3bc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c0:	4605                	li	a2,1
 3c2:	fef40593          	addi	a1,s0,-17
 3c6:	f5fff0ef          	jal	324 <write>
}
 3ca:	60e2                	ld	ra,24(sp)
 3cc:	6442                	ld	s0,16(sp)
 3ce:	6105                	addi	sp,sp,32
 3d0:	8082                	ret

00000000000003d2 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3d2:	715d                	addi	sp,sp,-80
 3d4:	e486                	sd	ra,72(sp)
 3d6:	e0a2                	sd	s0,64(sp)
 3d8:	f84a                	sd	s2,48(sp)
 3da:	f44e                	sd	s3,40(sp)
 3dc:	0880                	addi	s0,sp,80
 3de:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3e0:	00d036b3          	snez	a3,a3
 3e4:	03f5d793          	srli	a5,a1,0x3f
 3e8:	8efd                	and	a3,a3,a5
  neg = 0;
 3ea:	4301                	li	t1,0
  if (sgn && xx < 0) {
 3ec:	c681                	beqz	a3,3f4 <printint+0x22>
    neg = 1;
    x = -xx;
 3ee:	40b005b3          	neg	a1,a1
    neg = 1;
 3f2:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3f4:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3f8:	86ce                	mv	a3,s3
  i = 0;
 3fa:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 3fc:	00000817          	auipc	a6,0x0
 400:	55c80813          	addi	a6,a6,1372 # 958 <digits>
 404:	88ba                	mv	a7,a4
 406:	0017051b          	addiw	a0,a4,1
 40a:	872a                	mv	a4,a0
 40c:	02c5f7b3          	remu	a5,a1,a2
 410:	97c2                	add	a5,a5,a6
 412:	0007c783          	lbu	a5,0(a5)
 416:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 41a:	87ae                	mv	a5,a1
 41c:	02c5d5b3          	divu	a1,a1,a2
 420:	0685                	addi	a3,a3,1
 422:	fec7f1e3          	bgeu	a5,a2,404 <printint+0x32>
  if (neg)
 426:	00030b63          	beqz	t1,43c <printint+0x6a>
    buf[i++] = '-';
 42a:	fd040793          	addi	a5,s0,-48
 42e:	953e                	add	a0,a0,a5
 430:	02d00793          	li	a5,45
 434:	fef50423          	sb	a5,-24(a0)
 438:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 43c:	02e05563          	blez	a4,466 <printint+0x94>
 440:	fc26                	sd	s1,56(sp)
 442:	377d                	addiw	a4,a4,-1
 444:	00e984b3          	add	s1,s3,a4
 448:	19fd                	addi	s3,s3,-1
 44a:	99ba                	add	s3,s3,a4
 44c:	1702                	slli	a4,a4,0x20
 44e:	9301                	srli	a4,a4,0x20
 450:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 454:	0004c583          	lbu	a1,0(s1)
 458:	854a                	mv	a0,s2
 45a:	f5bff0ef          	jal	3b4 <putc>
  while (--i >= 0)
 45e:	14fd                	addi	s1,s1,-1
 460:	ff349ae3          	bne	s1,s3,454 <printint+0x82>
 464:	74e2                	ld	s1,56(sp)
}
 466:	60a6                	ld	ra,72(sp)
 468:	6406                	ld	s0,64(sp)
 46a:	7942                	ld	s2,48(sp)
 46c:	79a2                	ld	s3,40(sp)
 46e:	6161                	addi	sp,sp,80
 470:	8082                	ret

0000000000000472 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 472:	711d                	addi	sp,sp,-96
 474:	ec86                	sd	ra,88(sp)
 476:	e8a2                	sd	s0,80(sp)
 478:	e4a6                	sd	s1,72(sp)
 47a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 47c:	0005c483          	lbu	s1,0(a1)
 480:	2a048063          	beqz	s1,720 <vprintf+0x2ae>
 484:	e0ca                	sd	s2,64(sp)
 486:	fc4e                	sd	s3,56(sp)
 488:	f852                	sd	s4,48(sp)
 48a:	f456                	sd	s5,40(sp)
 48c:	f05a                	sd	s6,32(sp)
 48e:	ec5e                	sd	s7,24(sp)
 490:	e862                	sd	s8,16(sp)
 492:	8b2a                	mv	s6,a0
 494:	8a2e                	mv	s4,a1
 496:	8bb2                	mv	s7,a2
  state = 0;
 498:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 49a:	4901                	li	s2,0
 49c:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 49e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4a2:	06400c13          	li	s8,100
 4a6:	a00d                	j	4c8 <vprintf+0x56>
        putc(fd, c0);
 4a8:	85a6                	mv	a1,s1
 4aa:	855a                	mv	a0,s6
 4ac:	f09ff0ef          	jal	3b4 <putc>
 4b0:	a019                	j	4b6 <vprintf+0x44>
    } else if (state == '%') {
 4b2:	03598363          	beq	s3,s5,4d8 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 4b6:	0019079b          	addiw	a5,s2,1
 4ba:	893e                	mv	s2,a5
 4bc:	873e                	mv	a4,a5
 4be:	97d2                	add	a5,a5,s4
 4c0:	0007c483          	lbu	s1,0(a5)
 4c4:	24048763          	beqz	s1,712 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 4c8:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4cc:	fe0993e3          	bnez	s3,4b2 <vprintf+0x40>
      if (c0 == '%') {
 4d0:	fd579ce3          	bne	a5,s5,4a8 <vprintf+0x36>
        state = '%';
 4d4:	89be                	mv	s3,a5
 4d6:	b7c5                	j	4b6 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 4d8:	00ea06b3          	add	a3,s4,a4
 4dc:	0016c603          	lbu	a2,1(a3)
      if (c1)
 4e0:	24060563          	beqz	a2,72a <vprintf+0x2b8>
      if (c0 == 'd') {
 4e4:	0b878763          	beq	a5,s8,592 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4e8:	f9478693          	addi	a3,a5,-108
 4ec:	0016b693          	seqz	a3,a3
 4f0:	f9c60593          	addi	a1,a2,-100
 4f4:	0015b593          	seqz	a1,a1
 4f8:	8df5                	and	a1,a1,a3
 4fa:	e9c5                	bnez	a1,5aa <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 4fc:	9752                	add	a4,a4,s4
 4fe:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 502:	f9460713          	addi	a4,a2,-108
 506:	00173713          	seqz	a4,a4
 50a:	8f75                	and	a4,a4,a3
 50c:	f9c50593          	addi	a1,a0,-100
 510:	0015b593          	seqz	a1,a1
 514:	8df9                	and	a1,a1,a4
 516:	e5dd                	bnez	a1,5c4 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 518:	07500593          	li	a1,117
 51c:	0cb78163          	beq	a5,a1,5de <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 520:	f8b60593          	addi	a1,a2,-117
 524:	0015b593          	seqz	a1,a1
 528:	8df5                	and	a1,a1,a3
 52a:	e5f1                	bnez	a1,5f6 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 52c:	f8b50593          	addi	a1,a0,-117
 530:	0015b593          	seqz	a1,a1
 534:	8df9                	and	a1,a1,a4
 536:	ede9                	bnez	a1,610 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 538:	07800593          	li	a1,120
 53c:	0eb78763          	beq	a5,a1,62a <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 540:	f8860613          	addi	a2,a2,-120
 544:	00163613          	seqz	a2,a2
 548:	8ef1                	and	a3,a3,a2
 54a:	0e069c63          	bnez	a3,642 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 54e:	f8850513          	addi	a0,a0,-120
 552:	00153513          	seqz	a0,a0
 556:	8f69                	and	a4,a4,a0
 558:	10071263          	bnez	a4,65c <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 55c:	07000713          	li	a4,112
 560:	10e78a63          	beq	a5,a4,674 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 564:	06300713          	li	a4,99
 568:	14e78a63          	beq	a5,a4,6bc <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 56c:	07300713          	li	a4,115
 570:	16e78063          	beq	a5,a4,6d0 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 574:	02500713          	li	a4,37
 578:	18e78863          	beq	a5,a4,708 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 57c:	02500593          	li	a1,37
 580:	855a                	mv	a0,s6
 582:	e33ff0ef          	jal	3b4 <putc>
        putc(fd, c0);
 586:	85a6                	mv	a1,s1
 588:	855a                	mv	a0,s6
 58a:	e2bff0ef          	jal	3b4 <putc>
      }

      state = 0;
 58e:	4981                	li	s3,0
 590:	b71d                	j	4b6 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 592:	008b8493          	addi	s1,s7,8
 596:	4685                	li	a3,1
 598:	4629                	li	a2,10
 59a:	000ba583          	lw	a1,0(s7)
 59e:	855a                	mv	a0,s6
 5a0:	e33ff0ef          	jal	3d2 <printint>
 5a4:	8ba6                	mv	s7,s1
      state = 0;
 5a6:	4981                	li	s3,0
 5a8:	b739                	j	4b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5aa:	008b8493          	addi	s1,s7,8
 5ae:	4685                	li	a3,1
 5b0:	4629                	li	a2,10
 5b2:	000bb583          	ld	a1,0(s7)
 5b6:	855a                	mv	a0,s6
 5b8:	e1bff0ef          	jal	3d2 <printint>
        i += 1;
 5bc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5be:	8ba6                	mv	s7,s1
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	bdd5                	j	4b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c4:	008b8493          	addi	s1,s7,8
 5c8:	4685                	li	a3,1
 5ca:	4629                	li	a2,10
 5cc:	000bb583          	ld	a1,0(s7)
 5d0:	855a                	mv	a0,s6
 5d2:	e01ff0ef          	jal	3d2 <printint>
        i += 2;
 5d6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d8:	8ba6                	mv	s7,s1
      state = 0;
 5da:	4981                	li	s3,0
        i += 2;
 5dc:	bde9                	j	4b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5de:	008b8493          	addi	s1,s7,8
 5e2:	4681                	li	a3,0
 5e4:	4629                	li	a2,10
 5e6:	000be583          	lwu	a1,0(s7)
 5ea:	855a                	mv	a0,s6
 5ec:	de7ff0ef          	jal	3d2 <printint>
 5f0:	8ba6                	mv	s7,s1
      state = 0;
 5f2:	4981                	li	s3,0
 5f4:	b5c9                	j	4b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f6:	008b8493          	addi	s1,s7,8
 5fa:	4681                	li	a3,0
 5fc:	4629                	li	a2,10
 5fe:	000bb583          	ld	a1,0(s7)
 602:	855a                	mv	a0,s6
 604:	dcfff0ef          	jal	3d2 <printint>
        i += 1;
 608:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 60a:	8ba6                	mv	s7,s1
      state = 0;
 60c:	4981                	li	s3,0
 60e:	b565                	j	4b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 610:	008b8493          	addi	s1,s7,8
 614:	4681                	li	a3,0
 616:	4629                	li	a2,10
 618:	000bb583          	ld	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	db5ff0ef          	jal	3d2 <printint>
        i += 2;
 622:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 624:	8ba6                	mv	s7,s1
      state = 0;
 626:	4981                	li	s3,0
        i += 2;
 628:	b579                	j	4b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 62a:	008b8493          	addi	s1,s7,8
 62e:	4681                	li	a3,0
 630:	4641                	li	a2,16
 632:	000be583          	lwu	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	d9bff0ef          	jal	3d2 <printint>
 63c:	8ba6                	mv	s7,s1
      state = 0;
 63e:	4981                	li	s3,0
 640:	bd9d                	j	4b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 642:	008b8493          	addi	s1,s7,8
 646:	4681                	li	a3,0
 648:	4641                	li	a2,16
 64a:	000bb583          	ld	a1,0(s7)
 64e:	855a                	mv	a0,s6
 650:	d83ff0ef          	jal	3d2 <printint>
        i += 1;
 654:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 656:	8ba6                	mv	s7,s1
      state = 0;
 658:	4981                	li	s3,0
 65a:	bdb1                	j	4b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 65c:	008b8493          	addi	s1,s7,8
 660:	4641                	li	a2,16
 662:	000bb583          	ld	a1,0(s7)
 666:	855a                	mv	a0,s6
 668:	d6bff0ef          	jal	3d2 <printint>
        i += 2;
 66c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 66e:	8ba6                	mv	s7,s1
      state = 0;
 670:	4981                	li	s3,0
        i += 2;
 672:	b591                	j	4b6 <vprintf+0x44>
 674:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 676:	008b8793          	addi	a5,s7,8
 67a:	8cbe                	mv	s9,a5
 67c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 680:	03000593          	li	a1,48
 684:	855a                	mv	a0,s6
 686:	d2fff0ef          	jal	3b4 <putc>
  putc(fd, 'x');
 68a:	07800593          	li	a1,120
 68e:	855a                	mv	a0,s6
 690:	d25ff0ef          	jal	3b4 <putc>
 694:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 696:	00000b97          	auipc	s7,0x0
 69a:	2c2b8b93          	addi	s7,s7,706 # 958 <digits>
 69e:	03c9d793          	srli	a5,s3,0x3c
 6a2:	97de                	add	a5,a5,s7
 6a4:	0007c583          	lbu	a1,0(a5)
 6a8:	855a                	mv	a0,s6
 6aa:	d0bff0ef          	jal	3b4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ae:	0992                	slli	s3,s3,0x4
 6b0:	34fd                	addiw	s1,s1,-1
 6b2:	f4f5                	bnez	s1,69e <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 6b4:	8be6                	mv	s7,s9
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	6ca2                	ld	s9,8(sp)
 6ba:	bbf5                	j	4b6 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6bc:	008b8493          	addi	s1,s7,8
 6c0:	000bc583          	lbu	a1,0(s7)
 6c4:	855a                	mv	a0,s6
 6c6:	cefff0ef          	jal	3b4 <putc>
 6ca:	8ba6                	mv	s7,s1
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	b3e5                	j	4b6 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6d0:	008b8993          	addi	s3,s7,8
 6d4:	000bb483          	ld	s1,0(s7)
 6d8:	cc91                	beqz	s1,6f4 <vprintf+0x282>
        for (; *s; s++)
 6da:	0004c583          	lbu	a1,0(s1)
 6de:	c195                	beqz	a1,702 <vprintf+0x290>
          putc(fd, *s);
 6e0:	855a                	mv	a0,s6
 6e2:	cd3ff0ef          	jal	3b4 <putc>
        for (; *s; s++)
 6e6:	0485                	addi	s1,s1,1
 6e8:	0004c583          	lbu	a1,0(s1)
 6ec:	f9f5                	bnez	a1,6e0 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 6ee:	8bce                	mv	s7,s3
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	b3d1                	j	4b6 <vprintf+0x44>
          s = "(null)";
 6f4:	00000497          	auipc	s1,0x0
 6f8:	25c48493          	addi	s1,s1,604 # 950 <malloc+0x12a>
        for (; *s; s++)
 6fc:	02800593          	li	a1,40
 700:	b7c5                	j	6e0 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 702:	8bce                	mv	s7,s3
      state = 0;
 704:	4981                	li	s3,0
 706:	bb45                	j	4b6 <vprintf+0x44>
        putc(fd, '%');
 708:	85be                	mv	a1,a5
 70a:	855a                	mv	a0,s6
 70c:	ca9ff0ef          	jal	3b4 <putc>
 710:	bdbd                	j	58e <vprintf+0x11c>
 712:	6906                	ld	s2,64(sp)
 714:	79e2                	ld	s3,56(sp)
 716:	7a42                	ld	s4,48(sp)
 718:	7aa2                	ld	s5,40(sp)
 71a:	7b02                	ld	s6,32(sp)
 71c:	6be2                	ld	s7,24(sp)
 71e:	6c42                	ld	s8,16(sp)
    }
  }
}
 720:	60e6                	ld	ra,88(sp)
 722:	6446                	ld	s0,80(sp)
 724:	64a6                	ld	s1,72(sp)
 726:	6125                	addi	sp,sp,96
 728:	8082                	ret
      if (c0 == 'd') {
 72a:	06400713          	li	a4,100
 72e:	e6e782e3          	beq	a5,a4,592 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 732:	f9478693          	addi	a3,a5,-108
 736:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 73a:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 73c:	4701                	li	a4,0
 73e:	bbe9                	j	518 <vprintf+0xa6>

0000000000000740 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 740:	715d                	addi	sp,sp,-80
 742:	ec06                	sd	ra,24(sp)
 744:	e822                	sd	s0,16(sp)
 746:	1000                	addi	s0,sp,32
 748:	e010                	sd	a2,0(s0)
 74a:	e414                	sd	a3,8(s0)
 74c:	e818                	sd	a4,16(s0)
 74e:	ec1c                	sd	a5,24(s0)
 750:	03043023          	sd	a6,32(s0)
 754:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 758:	8622                	mv	a2,s0
 75a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 75e:	d15ff0ef          	jal	472 <vprintf>
}
 762:	60e2                	ld	ra,24(sp)
 764:	6442                	ld	s0,16(sp)
 766:	6161                	addi	sp,sp,80
 768:	8082                	ret

000000000000076a <printf>:

void
printf(const char *fmt, ...)
{
 76a:	711d                	addi	sp,sp,-96
 76c:	ec06                	sd	ra,24(sp)
 76e:	e822                	sd	s0,16(sp)
 770:	1000                	addi	s0,sp,32
 772:	e40c                	sd	a1,8(s0)
 774:	e810                	sd	a2,16(s0)
 776:	ec14                	sd	a3,24(s0)
 778:	f018                	sd	a4,32(s0)
 77a:	f41c                	sd	a5,40(s0)
 77c:	03043823          	sd	a6,48(s0)
 780:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 784:	00840613          	addi	a2,s0,8
 788:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 78c:	85aa                	mv	a1,a0
 78e:	4505                	li	a0,1
 790:	ce3ff0ef          	jal	472 <vprintf>
}
 794:	60e2                	ld	ra,24(sp)
 796:	6442                	ld	s0,16(sp)
 798:	6125                	addi	sp,sp,96
 79a:	8082                	ret

000000000000079c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 79c:	1141                	addi	sp,sp,-16
 79e:	e406                	sd	ra,8(sp)
 7a0:	e022                	sd	s0,0(sp)
 7a2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7a4:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a8:	00001797          	auipc	a5,0x1
 7ac:	8587b783          	ld	a5,-1960(a5) # 1000 <freep>
 7b0:	a095                	j	814 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 7b2:	ff852583          	lw	a1,-8(a0)
 7b6:	6390                	ld	a2,0(a5)
 7b8:	02059813          	slli	a6,a1,0x20
 7bc:	01c85693          	srli	a3,a6,0x1c
 7c0:	96ba                	add	a3,a3,a4
 7c2:	02d60563          	beq	a2,a3,7ec <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7c6:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 7ca:	4790                	lw	a2,8(a5)
 7cc:	02061593          	slli	a1,a2,0x20
 7d0:	01c5d693          	srli	a3,a1,0x1c
 7d4:	96be                	add	a3,a3,a5
 7d6:	02d70263          	beq	a4,a3,7fa <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7da:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7dc:	00001717          	auipc	a4,0x1
 7e0:	82f73223          	sd	a5,-2012(a4) # 1000 <freep>
}
 7e4:	60a2                	ld	ra,8(sp)
 7e6:	6402                	ld	s0,0(sp)
 7e8:	0141                	addi	sp,sp,16
 7ea:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7ec:	4614                	lw	a3,8(a2)
 7ee:	9ead                	addw	a3,a3,a1
 7f0:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f4:	6394                	ld	a3,0(a5)
 7f6:	6290                	ld	a2,0(a3)
 7f8:	b7f9                	j	7c6 <free+0x2a>
    p->s.size += bp->s.size;
 7fa:	ff852703          	lw	a4,-8(a0)
 7fe:	9f31                	addw	a4,a4,a2
 800:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 802:	ff053703          	ld	a4,-16(a0)
 806:	bfd1                	j	7da <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 808:	6394                	ld	a3,0(a5)
 80a:	00d7e463          	bltu	a5,a3,812 <free+0x76>
 80e:	fad762e3          	bltu	a4,a3,7b2 <free+0x16>
 812:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 814:	fee7fae3          	bgeu	a5,a4,808 <free+0x6c>
 818:	6394                	ld	a3,0(a5)
 81a:	f8d76ce3          	bltu	a4,a3,7b2 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81e:	f8d7fae3          	bgeu	a5,a3,7b2 <free+0x16>
 822:	87b6                	mv	a5,a3
 824:	bfc5                	j	814 <free+0x78>

0000000000000826 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 826:	7139                	addi	sp,sp,-64
 828:	fc06                	sd	ra,56(sp)
 82a:	f822                	sd	s0,48(sp)
 82c:	f04a                	sd	s2,32(sp)
 82e:	ec4e                	sd	s3,24(sp)
 830:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 832:	02051993          	slli	s3,a0,0x20
 836:	0209d993          	srli	s3,s3,0x20
 83a:	09bd                	addi	s3,s3,15
 83c:	0049d993          	srli	s3,s3,0x4
 840:	2985                	addiw	s3,s3,1
 842:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 844:	00000517          	auipc	a0,0x0
 848:	7bc53503          	ld	a0,1980(a0) # 1000 <freep>
 84c:	c905                	beqz	a0,87c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 84e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 850:	4798                	lw	a4,8(a5)
 852:	09377663          	bgeu	a4,s3,8de <malloc+0xb8>
 856:	f426                	sd	s1,40(sp)
 858:	e852                	sd	s4,16(sp)
 85a:	e456                	sd	s5,8(sp)
 85c:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 85e:	8a4e                	mv	s4,s3
 860:	6705                	lui	a4,0x1
 862:	00e9f363          	bgeu	s3,a4,868 <malloc+0x42>
 866:	6a05                	lui	s4,0x1
 868:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 86c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 870:	00000497          	auipc	s1,0x0
 874:	79048493          	addi	s1,s1,1936 # 1000 <freep>
  if (p == SBRK_ERROR)
 878:	5afd                	li	s5,-1
 87a:	a83d                	j	8b8 <malloc+0x92>
 87c:	f426                	sd	s1,40(sp)
 87e:	e852                	sd	s4,16(sp)
 880:	e456                	sd	s5,8(sp)
 882:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 884:	00000797          	auipc	a5,0x0
 888:	78c78793          	addi	a5,a5,1932 # 1010 <base>
 88c:	00000717          	auipc	a4,0x0
 890:	76f73a23          	sd	a5,1908(a4) # 1000 <freep>
 894:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 896:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 89a:	b7d1                	j	85e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 89c:	6398                	ld	a4,0(a5)
 89e:	e118                	sd	a4,0(a0)
 8a0:	a899                	j	8f6 <malloc+0xd0>
  hp->s.size = nu;
 8a2:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8a6:	0541                	addi	a0,a0,16
 8a8:	ef5ff0ef          	jal	79c <free>
  return freep;
 8ac:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8ae:	c125                	beqz	a0,90e <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8b0:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8b2:	4798                	lw	a4,8(a5)
 8b4:	03277163          	bgeu	a4,s2,8d6 <malloc+0xb0>
    if (p == freep)
 8b8:	6098                	ld	a4,0(s1)
 8ba:	853e                	mv	a0,a5
 8bc:	fef71ae3          	bne	a4,a5,8b0 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8c0:	8552                	mv	a0,s4
 8c2:	a0fff0ef          	jal	2d0 <sbrk>
  if (p == SBRK_ERROR)
 8c6:	fd551ee3          	bne	a0,s5,8a2 <malloc+0x7c>
        return 0;
 8ca:	4501                	li	a0,0
 8cc:	74a2                	ld	s1,40(sp)
 8ce:	6a42                	ld	s4,16(sp)
 8d0:	6aa2                	ld	s5,8(sp)
 8d2:	6b02                	ld	s6,0(sp)
 8d4:	a03d                	j	902 <malloc+0xdc>
 8d6:	74a2                	ld	s1,40(sp)
 8d8:	6a42                	ld	s4,16(sp)
 8da:	6aa2                	ld	s5,8(sp)
 8dc:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8de:	fae90fe3          	beq	s2,a4,89c <malloc+0x76>
        p->s.size -= nunits;
 8e2:	4137073b          	subw	a4,a4,s3
 8e6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8e8:	02071693          	slli	a3,a4,0x20
 8ec:	01c6d713          	srli	a4,a3,0x1c
 8f0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8f2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8f6:	00000717          	auipc	a4,0x0
 8fa:	70a73523          	sd	a0,1802(a4) # 1000 <freep>
      return (void *)(p + 1);
 8fe:	01078513          	addi	a0,a5,16
  }
}
 902:	70e2                	ld	ra,56(sp)
 904:	7442                	ld	s0,48(sp)
 906:	7902                	ld	s2,32(sp)
 908:	69e2                	ld	s3,24(sp)
 90a:	6121                	addi	sp,sp,64
 90c:	8082                	ret
 90e:	74a2                	ld	s1,40(sp)
 910:	6a42                	ld	s4,16(sp)
 912:	6aa2                	ld	s5,8(sp)
 914:	6b02                	ld	s6,0(sp)
 916:	b7f5                	j	902 <malloc+0xdc>
