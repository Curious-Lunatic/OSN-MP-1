
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if (argc < 2) {
   8:	4785                	li	a5,1
   a:	02a7d963          	bge	a5,a0,3c <main+0x3c>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for (i = 1; i < argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	1bc000ef          	jal	1e4 <atoi>
  2c:	30e000ef          	jal	33a <kill>
  for (i = 1; i < argc; i++)
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  36:	4501                	li	a0,0
  38:	2d2000ef          	jal	30a <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
  40:	00001597          	auipc	a1,0x1
  44:	8e058593          	addi	a1,a1,-1824 # 920 <malloc+0xf4>
  48:	4509                	li	a0,2
  4a:	6fc000ef          	jal	746 <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	2ba000ef          	jal	30a <exit>

0000000000000054 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  5c:	fa5ff0ef          	jal	0 <main>
  exit(r);
  60:	2aa000ef          	jal	30a <exit>

0000000000000064 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  64:	1141                	addi	sp,sp,-16
  66:	e406                	sd	ra,8(sp)
  68:	e022                	sd	s0,0(sp)
  6a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  6c:	87aa                	mv	a5,a0
  6e:	0585                	addi	a1,a1,1
  70:	0785                	addi	a5,a5,1
  72:	fff5c703          	lbu	a4,-1(a1)
  76:	fee78fa3          	sb	a4,-1(a5)
  7a:	fb75                	bnez	a4,6e <strcpy+0xa>
    ;
  return os;
}
  7c:	60a2                	ld	ra,8(sp)
  7e:	6402                	ld	s0,0(sp)
  80:	0141                	addi	sp,sp,16
  82:	8082                	ret

0000000000000084 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  84:	1141                	addi	sp,sp,-16
  86:	e406                	sd	ra,8(sp)
  88:	e022                	sd	s0,0(sp)
  8a:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  8c:	00054783          	lbu	a5,0(a0)
  90:	cb91                	beqz	a5,a4 <strcmp+0x20>
  92:	0005c703          	lbu	a4,0(a1)
  96:	00f71763          	bne	a4,a5,a4 <strcmp+0x20>
    p++, q++;
  9a:	0505                	addi	a0,a0,1
  9c:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  9e:	00054783          	lbu	a5,0(a0)
  a2:	fbe5                	bnez	a5,92 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  a4:	0005c503          	lbu	a0,0(a1)
}
  a8:	40a7853b          	subw	a0,a5,a0
  ac:	60a2                	ld	ra,8(sp)
  ae:	6402                	ld	s0,0(sp)
  b0:	0141                	addi	sp,sp,16
  b2:	8082                	ret

00000000000000b4 <strlen>:

uint
strlen(const char *s)
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e406                	sd	ra,8(sp)
  b8:	e022                	sd	s0,0(sp)
  ba:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  bc:	00054783          	lbu	a5,0(a0)
  c0:	cf91                	beqz	a5,dc <strlen+0x28>
  c2:	00150793          	addi	a5,a0,1
  c6:	86be                	mv	a3,a5
  c8:	0785                	addi	a5,a5,1
  ca:	fff7c703          	lbu	a4,-1(a5)
  ce:	ff65                	bnez	a4,c6 <strlen+0x12>
  d0:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  d4:	60a2                	ld	ra,8(sp)
  d6:	6402                	ld	s0,0(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret
  for (n = 0; s[n]; n++)
  dc:	4501                	li	a0,0
  de:	bfdd                	j	d4 <strlen+0x20>

00000000000000e0 <memset>:

void *
memset(void *dst, int c, uint n)
{
  e0:	1141                	addi	sp,sp,-16
  e2:	e406                	sd	ra,8(sp)
  e4:	e022                	sd	s0,0(sp)
  e6:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  e8:	ca19                	beqz	a2,fe <memset+0x1e>
  ea:	87aa                	mv	a5,a0
  ec:	1602                	slli	a2,a2,0x20
  ee:	9201                	srli	a2,a2,0x20
  f0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f4:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  f8:	0785                	addi	a5,a5,1
  fa:	fee79de3          	bne	a5,a4,f4 <memset+0x14>
  }
  return dst;
}
  fe:	60a2                	ld	ra,8(sp)
 100:	6402                	ld	s0,0(sp)
 102:	0141                	addi	sp,sp,16
 104:	8082                	ret

0000000000000106 <strchr>:

char *
strchr(const char *s, char c)
{
 106:	1141                	addi	sp,sp,-16
 108:	e406                	sd	ra,8(sp)
 10a:	e022                	sd	s0,0(sp)
 10c:	0800                	addi	s0,sp,16
  for (; *s; s++)
 10e:	00054783          	lbu	a5,0(a0)
 112:	c799                	beqz	a5,120 <strchr+0x1a>
    if (*s == c)
 114:	00f58763          	beq	a1,a5,122 <strchr+0x1c>
  for (; *s; s++)
 118:	0505                	addi	a0,a0,1
 11a:	00054783          	lbu	a5,0(a0)
 11e:	fbfd                	bnez	a5,114 <strchr+0xe>
      return (char *)s;
  return 0;
 120:	4501                	li	a0,0
}
 122:	60a2                	ld	ra,8(sp)
 124:	6402                	ld	s0,0(sp)
 126:	0141                	addi	sp,sp,16
 128:	8082                	ret

000000000000012a <gets>:

char *
gets(char *buf, int max)
{
 12a:	711d                	addi	sp,sp,-96
 12c:	ec86                	sd	ra,88(sp)
 12e:	e8a2                	sd	s0,80(sp)
 130:	e4a6                	sd	s1,72(sp)
 132:	e0ca                	sd	s2,64(sp)
 134:	fc4e                	sd	s3,56(sp)
 136:	f852                	sd	s4,48(sp)
 138:	f456                	sd	s5,40(sp)
 13a:	f05a                	sd	s6,32(sp)
 13c:	ec5e                	sd	s7,24(sp)
 13e:	e862                	sd	s8,16(sp)
 140:	1080                	addi	s0,sp,96
 142:	8baa                	mv	s7,a0
 144:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 146:	892a                	mv	s2,a0
 148:	4481                	li	s1,0
    cc = read(0, &c, 1);
 14a:	faf40b13          	addi	s6,s0,-81
 14e:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 150:	8c26                	mv	s8,s1
 152:	0014899b          	addiw	s3,s1,1
 156:	84ce                	mv	s1,s3
 158:	0349d863          	bge	s3,s4,188 <gets+0x5e>
    cc = read(0, &c, 1);
 15c:	8656                	mv	a2,s5
 15e:	85da                	mv	a1,s6
 160:	4501                	li	a0,0
 162:	1c0000ef          	jal	322 <read>
    if (cc < 1)
 166:	02a05163          	blez	a0,188 <gets+0x5e>
      break;
    buf[i++] = c;
 16a:	faf44783          	lbu	a5,-81(s0)
 16e:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 172:	0905                	addi	s2,s2,1
 174:	ff678713          	addi	a4,a5,-10
 178:	00173713          	seqz	a4,a4
 17c:	17cd                	addi	a5,a5,-13
 17e:	0017b793          	seqz	a5,a5
 182:	8fd9                	or	a5,a5,a4
 184:	d7f1                	beqz	a5,150 <gets+0x26>
    buf[i++] = c;
 186:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 188:	9c5e                	add	s8,s8,s7
 18a:	000c0023          	sb	zero,0(s8)
  return buf;
}
 18e:	855e                	mv	a0,s7
 190:	60e6                	ld	ra,88(sp)
 192:	6446                	ld	s0,80(sp)
 194:	64a6                	ld	s1,72(sp)
 196:	6906                	ld	s2,64(sp)
 198:	79e2                	ld	s3,56(sp)
 19a:	7a42                	ld	s4,48(sp)
 19c:	7aa2                	ld	s5,40(sp)
 19e:	7b02                	ld	s6,32(sp)
 1a0:	6be2                	ld	s7,24(sp)
 1a2:	6c42                	ld	s8,16(sp)
 1a4:	6125                	addi	sp,sp,96
 1a6:	8082                	ret

00000000000001a8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a8:	1101                	addi	sp,sp,-32
 1aa:	ec06                	sd	ra,24(sp)
 1ac:	e822                	sd	s0,16(sp)
 1ae:	e04a                	sd	s2,0(sp)
 1b0:	1000                	addi	s0,sp,32
 1b2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b4:	4581                	li	a1,0
 1b6:	194000ef          	jal	34a <open>
  if (fd < 0)
 1ba:	02054263          	bltz	a0,1de <stat+0x36>
 1be:	e426                	sd	s1,8(sp)
 1c0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c2:	85ca                	mv	a1,s2
 1c4:	19e000ef          	jal	362 <fstat>
 1c8:	892a                	mv	s2,a0
  close(fd);
 1ca:	8526                	mv	a0,s1
 1cc:	166000ef          	jal	332 <close>
  return r;
 1d0:	64a2                	ld	s1,8(sp)
}
 1d2:	854a                	mv	a0,s2
 1d4:	60e2                	ld	ra,24(sp)
 1d6:	6442                	ld	s0,16(sp)
 1d8:	6902                	ld	s2,0(sp)
 1da:	6105                	addi	sp,sp,32
 1dc:	8082                	ret
    return -1;
 1de:	57fd                	li	a5,-1
 1e0:	893e                	mv	s2,a5
 1e2:	bfc5                	j	1d2 <stat+0x2a>

00000000000001e4 <atoi>:

int
atoi(const char *s)
{
 1e4:	1141                	addi	sp,sp,-16
 1e6:	e406                	sd	ra,8(sp)
 1e8:	e022                	sd	s0,0(sp)
 1ea:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1ec:	00054683          	lbu	a3,0(a0)
 1f0:	fd06879b          	addiw	a5,a3,-48
 1f4:	0ff7f793          	zext.b	a5,a5
 1f8:	4625                	li	a2,9
 1fa:	02f66963          	bltu	a2,a5,22c <atoi+0x48>
 1fe:	872a                	mv	a4,a0
  n = 0;
 200:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 202:	0705                	addi	a4,a4,1
 204:	0025179b          	slliw	a5,a0,0x2
 208:	9fa9                	addw	a5,a5,a0
 20a:	0017979b          	slliw	a5,a5,0x1
 20e:	9fb5                	addw	a5,a5,a3
 210:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 214:	00074683          	lbu	a3,0(a4)
 218:	fd06879b          	addiw	a5,a3,-48
 21c:	0ff7f793          	zext.b	a5,a5
 220:	fef671e3          	bgeu	a2,a5,202 <atoi+0x1e>
  return n;
}
 224:	60a2                	ld	ra,8(sp)
 226:	6402                	ld	s0,0(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret
  n = 0;
 22c:	4501                	li	a0,0
 22e:	bfdd                	j	224 <atoi+0x40>

0000000000000230 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 230:	1141                	addi	sp,sp,-16
 232:	e406                	sd	ra,8(sp)
 234:	e022                	sd	s0,0(sp)
 236:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 238:	02b57563          	bgeu	a0,a1,262 <memmove+0x32>
    while (n-- > 0)
 23c:	00c05f63          	blez	a2,25a <memmove+0x2a>
 240:	1602                	slli	a2,a2,0x20
 242:	9201                	srli	a2,a2,0x20
 244:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 248:	872a                	mv	a4,a0
      *dst++ = *src++;
 24a:	0585                	addi	a1,a1,1
 24c:	0705                	addi	a4,a4,1
 24e:	fff5c683          	lbu	a3,-1(a1)
 252:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 256:	fee79ae3          	bne	a5,a4,24a <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 25a:	60a2                	ld	ra,8(sp)
 25c:	6402                	ld	s0,0(sp)
 25e:	0141                	addi	sp,sp,16
 260:	8082                	ret
    while (n-- > 0)
 262:	fec05ce3          	blez	a2,25a <memmove+0x2a>
    dst += n;
 266:	00c50733          	add	a4,a0,a2
    src += n;
 26a:	95b2                	add	a1,a1,a2
 26c:	fff6079b          	addiw	a5,a2,-1
 270:	1782                	slli	a5,a5,0x20
 272:	9381                	srli	a5,a5,0x20
 274:	fff7c793          	not	a5,a5
 278:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27a:	15fd                	addi	a1,a1,-1
 27c:	177d                	addi	a4,a4,-1
 27e:	0005c683          	lbu	a3,0(a1)
 282:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 286:	fef71ae3          	bne	a4,a5,27a <memmove+0x4a>
 28a:	bfc1                	j	25a <memmove+0x2a>

000000000000028c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e406                	sd	ra,8(sp)
 290:	e022                	sd	s0,0(sp)
 292:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 294:	ce19                	beqz	a2,2b2 <memcmp+0x26>
 296:	1602                	slli	a2,a2,0x20
 298:	9201                	srli	a2,a2,0x20
 29a:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 29e:	00054783          	lbu	a5,0(a0)
 2a2:	0005c703          	lbu	a4,0(a1)
 2a6:	00e79b63          	bne	a5,a4,2bc <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 2aa:	0505                	addi	a0,a0,1
    p2++;
 2ac:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ae:	fed518e3          	bne	a0,a3,29e <memcmp+0x12>
  }
  return 0;
 2b2:	4501                	li	a0,0
}
 2b4:	60a2                	ld	ra,8(sp)
 2b6:	6402                	ld	s0,0(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret
      return *p1 - *p2;
 2bc:	40e7853b          	subw	a0,a5,a4
 2c0:	bfd5                	j	2b4 <memcmp+0x28>

00000000000002c2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e406                	sd	ra,8(sp)
 2c6:	e022                	sd	s0,0(sp)
 2c8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ca:	f67ff0ef          	jal	230 <memmove>
}
 2ce:	60a2                	ld	ra,8(sp)
 2d0:	6402                	ld	s0,0(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret

00000000000002d6 <sbrk>:

char *
sbrk(int n)
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e406                	sd	ra,8(sp)
 2da:	e022                	sd	s0,0(sp)
 2dc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2de:	4585                	li	a1,1
 2e0:	0b2000ef          	jal	392 <sys_sbrk>
}
 2e4:	60a2                	ld	ra,8(sp)
 2e6:	6402                	ld	s0,0(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret

00000000000002ec <sbrklazy>:

char *
sbrklazy(int n)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e406                	sd	ra,8(sp)
 2f0:	e022                	sd	s0,0(sp)
 2f2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2f4:	4589                	li	a1,2
 2f6:	09c000ef          	jal	392 <sys_sbrk>
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret

0000000000000302 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 302:	4885                	li	a7,1
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <exit>:
.global exit
exit:
 li a7, SYS_exit
 30a:	4889                	li	a7,2
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <wait>:
.global wait
wait:
 li a7, SYS_wait
 312:	488d                	li	a7,3
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 31a:	4891                	li	a7,4
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <read>:
.global read
read:
 li a7, SYS_read
 322:	4895                	li	a7,5
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <write>:
.global write
write:
 li a7, SYS_write
 32a:	48c1                	li	a7,16
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <close>:
.global close
close:
 li a7, SYS_close
 332:	48d5                	li	a7,21
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <kill>:
.global kill
kill:
 li a7, SYS_kill
 33a:	4899                	li	a7,6
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <exec>:
.global exec
exec:
 li a7, SYS_exec
 342:	489d                	li	a7,7
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <open>:
.global open
open:
 li a7, SYS_open
 34a:	48bd                	li	a7,15
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 352:	48c5                	li	a7,17
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 35a:	48c9                	li	a7,18
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 362:	48a1                	li	a7,8
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <link>:
.global link
link:
 li a7, SYS_link
 36a:	48cd                	li	a7,19
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 372:	48d1                	li	a7,20
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 37a:	48a5                	li	a7,9
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <dup>:
.global dup
dup:
 li a7, SYS_dup
 382:	48a9                	li	a7,10
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 38a:	48ad                	li	a7,11
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 392:	48b1                	li	a7,12
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <pause>:
.global pause
pause:
 li a7, SYS_pause
 39a:	48b5                	li	a7,13
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a2:	48b9                	li	a7,14
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <sync>:
.global sync
sync:
 li a7, SYS_sync
 3aa:	48d9                	li	a7,22
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3b2:	48dd                	li	a7,23
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ba:	1101                	addi	sp,sp,-32
 3bc:	ec06                	sd	ra,24(sp)
 3be:	e822                	sd	s0,16(sp)
 3c0:	1000                	addi	s0,sp,32
 3c2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c6:	4605                	li	a2,1
 3c8:	fef40593          	addi	a1,s0,-17
 3cc:	f5fff0ef          	jal	32a <write>
}
 3d0:	60e2                	ld	ra,24(sp)
 3d2:	6442                	ld	s0,16(sp)
 3d4:	6105                	addi	sp,sp,32
 3d6:	8082                	ret

00000000000003d8 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3d8:	715d                	addi	sp,sp,-80
 3da:	e486                	sd	ra,72(sp)
 3dc:	e0a2                	sd	s0,64(sp)
 3de:	f84a                	sd	s2,48(sp)
 3e0:	f44e                	sd	s3,40(sp)
 3e2:	0880                	addi	s0,sp,80
 3e4:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3e6:	00d036b3          	snez	a3,a3
 3ea:	03f5d793          	srli	a5,a1,0x3f
 3ee:	8efd                	and	a3,a3,a5
  neg = 0;
 3f0:	4301                	li	t1,0
  if (sgn && xx < 0) {
 3f2:	c681                	beqz	a3,3fa <printint+0x22>
    neg = 1;
    x = -xx;
 3f4:	40b005b3          	neg	a1,a1
    neg = 1;
 3f8:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3fa:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3fe:	86ce                	mv	a3,s3
  i = 0;
 400:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 402:	00000817          	auipc	a6,0x0
 406:	53e80813          	addi	a6,a6,1342 # 940 <digits>
 40a:	88ba                	mv	a7,a4
 40c:	0017051b          	addiw	a0,a4,1
 410:	872a                	mv	a4,a0
 412:	02c5f7b3          	remu	a5,a1,a2
 416:	97c2                	add	a5,a5,a6
 418:	0007c783          	lbu	a5,0(a5)
 41c:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 420:	87ae                	mv	a5,a1
 422:	02c5d5b3          	divu	a1,a1,a2
 426:	0685                	addi	a3,a3,1
 428:	fec7f1e3          	bgeu	a5,a2,40a <printint+0x32>
  if (neg)
 42c:	00030b63          	beqz	t1,442 <printint+0x6a>
    buf[i++] = '-';
 430:	fd040793          	addi	a5,s0,-48
 434:	953e                	add	a0,a0,a5
 436:	02d00793          	li	a5,45
 43a:	fef50423          	sb	a5,-24(a0)
 43e:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 442:	02e05563          	blez	a4,46c <printint+0x94>
 446:	fc26                	sd	s1,56(sp)
 448:	377d                	addiw	a4,a4,-1
 44a:	00e984b3          	add	s1,s3,a4
 44e:	19fd                	addi	s3,s3,-1
 450:	99ba                	add	s3,s3,a4
 452:	1702                	slli	a4,a4,0x20
 454:	9301                	srli	a4,a4,0x20
 456:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 45a:	0004c583          	lbu	a1,0(s1)
 45e:	854a                	mv	a0,s2
 460:	f5bff0ef          	jal	3ba <putc>
  while (--i >= 0)
 464:	14fd                	addi	s1,s1,-1
 466:	ff349ae3          	bne	s1,s3,45a <printint+0x82>
 46a:	74e2                	ld	s1,56(sp)
}
 46c:	60a6                	ld	ra,72(sp)
 46e:	6406                	ld	s0,64(sp)
 470:	7942                	ld	s2,48(sp)
 472:	79a2                	ld	s3,40(sp)
 474:	6161                	addi	sp,sp,80
 476:	8082                	ret

0000000000000478 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 478:	711d                	addi	sp,sp,-96
 47a:	ec86                	sd	ra,88(sp)
 47c:	e8a2                	sd	s0,80(sp)
 47e:	e4a6                	sd	s1,72(sp)
 480:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 482:	0005c483          	lbu	s1,0(a1)
 486:	2a048063          	beqz	s1,726 <vprintf+0x2ae>
 48a:	e0ca                	sd	s2,64(sp)
 48c:	fc4e                	sd	s3,56(sp)
 48e:	f852                	sd	s4,48(sp)
 490:	f456                	sd	s5,40(sp)
 492:	f05a                	sd	s6,32(sp)
 494:	ec5e                	sd	s7,24(sp)
 496:	e862                	sd	s8,16(sp)
 498:	8b2a                	mv	s6,a0
 49a:	8a2e                	mv	s4,a1
 49c:	8bb2                	mv	s7,a2
  state = 0;
 49e:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 4a0:	4901                	li	s2,0
 4a2:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 4a4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4a8:	06400c13          	li	s8,100
 4ac:	a00d                	j	4ce <vprintf+0x56>
        putc(fd, c0);
 4ae:	85a6                	mv	a1,s1
 4b0:	855a                	mv	a0,s6
 4b2:	f09ff0ef          	jal	3ba <putc>
 4b6:	a019                	j	4bc <vprintf+0x44>
    } else if (state == '%') {
 4b8:	03598363          	beq	s3,s5,4de <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 4bc:	0019079b          	addiw	a5,s2,1
 4c0:	893e                	mv	s2,a5
 4c2:	873e                	mv	a4,a5
 4c4:	97d2                	add	a5,a5,s4
 4c6:	0007c483          	lbu	s1,0(a5)
 4ca:	24048763          	beqz	s1,718 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 4ce:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4d2:	fe0993e3          	bnez	s3,4b8 <vprintf+0x40>
      if (c0 == '%') {
 4d6:	fd579ce3          	bne	a5,s5,4ae <vprintf+0x36>
        state = '%';
 4da:	89be                	mv	s3,a5
 4dc:	b7c5                	j	4bc <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 4de:	00ea06b3          	add	a3,s4,a4
 4e2:	0016c603          	lbu	a2,1(a3)
      if (c1)
 4e6:	24060563          	beqz	a2,730 <vprintf+0x2b8>
      if (c0 == 'd') {
 4ea:	0b878763          	beq	a5,s8,598 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4ee:	f9478693          	addi	a3,a5,-108
 4f2:	0016b693          	seqz	a3,a3
 4f6:	f9c60593          	addi	a1,a2,-100
 4fa:	0015b593          	seqz	a1,a1
 4fe:	8df5                	and	a1,a1,a3
 500:	e9c5                	bnez	a1,5b0 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 502:	9752                	add	a4,a4,s4
 504:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 508:	f9460713          	addi	a4,a2,-108
 50c:	00173713          	seqz	a4,a4
 510:	8f75                	and	a4,a4,a3
 512:	f9c50593          	addi	a1,a0,-100
 516:	0015b593          	seqz	a1,a1
 51a:	8df9                	and	a1,a1,a4
 51c:	e5dd                	bnez	a1,5ca <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 51e:	07500593          	li	a1,117
 522:	0cb78163          	beq	a5,a1,5e4 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 526:	f8b60593          	addi	a1,a2,-117
 52a:	0015b593          	seqz	a1,a1
 52e:	8df5                	and	a1,a1,a3
 530:	e5f1                	bnez	a1,5fc <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 532:	f8b50593          	addi	a1,a0,-117
 536:	0015b593          	seqz	a1,a1
 53a:	8df9                	and	a1,a1,a4
 53c:	ede9                	bnez	a1,616 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 53e:	07800593          	li	a1,120
 542:	0eb78763          	beq	a5,a1,630 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 546:	f8860613          	addi	a2,a2,-120
 54a:	00163613          	seqz	a2,a2
 54e:	8ef1                	and	a3,a3,a2
 550:	0e069c63          	bnez	a3,648 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 554:	f8850513          	addi	a0,a0,-120
 558:	00153513          	seqz	a0,a0
 55c:	8f69                	and	a4,a4,a0
 55e:	10071263          	bnez	a4,662 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 562:	07000713          	li	a4,112
 566:	10e78a63          	beq	a5,a4,67a <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 56a:	06300713          	li	a4,99
 56e:	14e78a63          	beq	a5,a4,6c2 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 572:	07300713          	li	a4,115
 576:	16e78063          	beq	a5,a4,6d6 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 57a:	02500713          	li	a4,37
 57e:	18e78863          	beq	a5,a4,70e <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 582:	02500593          	li	a1,37
 586:	855a                	mv	a0,s6
 588:	e33ff0ef          	jal	3ba <putc>
        putc(fd, c0);
 58c:	85a6                	mv	a1,s1
 58e:	855a                	mv	a0,s6
 590:	e2bff0ef          	jal	3ba <putc>
      }

      state = 0;
 594:	4981                	li	s3,0
 596:	b71d                	j	4bc <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 598:	008b8493          	addi	s1,s7,8
 59c:	4685                	li	a3,1
 59e:	4629                	li	a2,10
 5a0:	000ba583          	lw	a1,0(s7)
 5a4:	855a                	mv	a0,s6
 5a6:	e33ff0ef          	jal	3d8 <printint>
 5aa:	8ba6                	mv	s7,s1
      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	b739                	j	4bc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b0:	008b8493          	addi	s1,s7,8
 5b4:	4685                	li	a3,1
 5b6:	4629                	li	a2,10
 5b8:	000bb583          	ld	a1,0(s7)
 5bc:	855a                	mv	a0,s6
 5be:	e1bff0ef          	jal	3d8 <printint>
        i += 1;
 5c2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c4:	8ba6                	mv	s7,s1
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	bdd5                	j	4bc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ca:	008b8493          	addi	s1,s7,8
 5ce:	4685                	li	a3,1
 5d0:	4629                	li	a2,10
 5d2:	000bb583          	ld	a1,0(s7)
 5d6:	855a                	mv	a0,s6
 5d8:	e01ff0ef          	jal	3d8 <printint>
        i += 2;
 5dc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5de:	8ba6                	mv	s7,s1
      state = 0;
 5e0:	4981                	li	s3,0
        i += 2;
 5e2:	bde9                	j	4bc <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5e4:	008b8493          	addi	s1,s7,8
 5e8:	4681                	li	a3,0
 5ea:	4629                	li	a2,10
 5ec:	000be583          	lwu	a1,0(s7)
 5f0:	855a                	mv	a0,s6
 5f2:	de7ff0ef          	jal	3d8 <printint>
 5f6:	8ba6                	mv	s7,s1
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	b5c9                	j	4bc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fc:	008b8493          	addi	s1,s7,8
 600:	4681                	li	a3,0
 602:	4629                	li	a2,10
 604:	000bb583          	ld	a1,0(s7)
 608:	855a                	mv	a0,s6
 60a:	dcfff0ef          	jal	3d8 <printint>
        i += 1;
 60e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 610:	8ba6                	mv	s7,s1
      state = 0;
 612:	4981                	li	s3,0
 614:	b565                	j	4bc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 616:	008b8493          	addi	s1,s7,8
 61a:	4681                	li	a3,0
 61c:	4629                	li	a2,10
 61e:	000bb583          	ld	a1,0(s7)
 622:	855a                	mv	a0,s6
 624:	db5ff0ef          	jal	3d8 <printint>
        i += 2;
 628:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 62a:	8ba6                	mv	s7,s1
      state = 0;
 62c:	4981                	li	s3,0
        i += 2;
 62e:	b579                	j	4bc <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 630:	008b8493          	addi	s1,s7,8
 634:	4681                	li	a3,0
 636:	4641                	li	a2,16
 638:	000be583          	lwu	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	d9bff0ef          	jal	3d8 <printint>
 642:	8ba6                	mv	s7,s1
      state = 0;
 644:	4981                	li	s3,0
 646:	bd9d                	j	4bc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 648:	008b8493          	addi	s1,s7,8
 64c:	4681                	li	a3,0
 64e:	4641                	li	a2,16
 650:	000bb583          	ld	a1,0(s7)
 654:	855a                	mv	a0,s6
 656:	d83ff0ef          	jal	3d8 <printint>
        i += 1;
 65a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 65c:	8ba6                	mv	s7,s1
      state = 0;
 65e:	4981                	li	s3,0
 660:	bdb1                	j	4bc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 662:	008b8493          	addi	s1,s7,8
 666:	4641                	li	a2,16
 668:	000bb583          	ld	a1,0(s7)
 66c:	855a                	mv	a0,s6
 66e:	d6bff0ef          	jal	3d8 <printint>
        i += 2;
 672:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 674:	8ba6                	mv	s7,s1
      state = 0;
 676:	4981                	li	s3,0
        i += 2;
 678:	b591                	j	4bc <vprintf+0x44>
 67a:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 67c:	008b8793          	addi	a5,s7,8
 680:	8cbe                	mv	s9,a5
 682:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 686:	03000593          	li	a1,48
 68a:	855a                	mv	a0,s6
 68c:	d2fff0ef          	jal	3ba <putc>
  putc(fd, 'x');
 690:	07800593          	li	a1,120
 694:	855a                	mv	a0,s6
 696:	d25ff0ef          	jal	3ba <putc>
 69a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 69c:	00000b97          	auipc	s7,0x0
 6a0:	2a4b8b93          	addi	s7,s7,676 # 940 <digits>
 6a4:	03c9d793          	srli	a5,s3,0x3c
 6a8:	97de                	add	a5,a5,s7
 6aa:	0007c583          	lbu	a1,0(a5)
 6ae:	855a                	mv	a0,s6
 6b0:	d0bff0ef          	jal	3ba <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6b4:	0992                	slli	s3,s3,0x4
 6b6:	34fd                	addiw	s1,s1,-1
 6b8:	f4f5                	bnez	s1,6a4 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 6ba:	8be6                	mv	s7,s9
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	6ca2                	ld	s9,8(sp)
 6c0:	bbf5                	j	4bc <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6c2:	008b8493          	addi	s1,s7,8
 6c6:	000bc583          	lbu	a1,0(s7)
 6ca:	855a                	mv	a0,s6
 6cc:	cefff0ef          	jal	3ba <putc>
 6d0:	8ba6                	mv	s7,s1
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	b3e5                	j	4bc <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6d6:	008b8993          	addi	s3,s7,8
 6da:	000bb483          	ld	s1,0(s7)
 6de:	cc91                	beqz	s1,6fa <vprintf+0x282>
        for (; *s; s++)
 6e0:	0004c583          	lbu	a1,0(s1)
 6e4:	c195                	beqz	a1,708 <vprintf+0x290>
          putc(fd, *s);
 6e6:	855a                	mv	a0,s6
 6e8:	cd3ff0ef          	jal	3ba <putc>
        for (; *s; s++)
 6ec:	0485                	addi	s1,s1,1
 6ee:	0004c583          	lbu	a1,0(s1)
 6f2:	f9f5                	bnez	a1,6e6 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 6f4:	8bce                	mv	s7,s3
      state = 0;
 6f6:	4981                	li	s3,0
 6f8:	b3d1                	j	4bc <vprintf+0x44>
          s = "(null)";
 6fa:	00000497          	auipc	s1,0x0
 6fe:	23e48493          	addi	s1,s1,574 # 938 <malloc+0x10c>
        for (; *s; s++)
 702:	02800593          	li	a1,40
 706:	b7c5                	j	6e6 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 708:	8bce                	mv	s7,s3
      state = 0;
 70a:	4981                	li	s3,0
 70c:	bb45                	j	4bc <vprintf+0x44>
        putc(fd, '%');
 70e:	85be                	mv	a1,a5
 710:	855a                	mv	a0,s6
 712:	ca9ff0ef          	jal	3ba <putc>
 716:	bdbd                	j	594 <vprintf+0x11c>
 718:	6906                	ld	s2,64(sp)
 71a:	79e2                	ld	s3,56(sp)
 71c:	7a42                	ld	s4,48(sp)
 71e:	7aa2                	ld	s5,40(sp)
 720:	7b02                	ld	s6,32(sp)
 722:	6be2                	ld	s7,24(sp)
 724:	6c42                	ld	s8,16(sp)
    }
  }
}
 726:	60e6                	ld	ra,88(sp)
 728:	6446                	ld	s0,80(sp)
 72a:	64a6                	ld	s1,72(sp)
 72c:	6125                	addi	sp,sp,96
 72e:	8082                	ret
      if (c0 == 'd') {
 730:	06400713          	li	a4,100
 734:	e6e782e3          	beq	a5,a4,598 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 738:	f9478693          	addi	a3,a5,-108
 73c:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 740:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 742:	4701                	li	a4,0
 744:	bbe9                	j	51e <vprintf+0xa6>

0000000000000746 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 746:	715d                	addi	sp,sp,-80
 748:	ec06                	sd	ra,24(sp)
 74a:	e822                	sd	s0,16(sp)
 74c:	1000                	addi	s0,sp,32
 74e:	e010                	sd	a2,0(s0)
 750:	e414                	sd	a3,8(s0)
 752:	e818                	sd	a4,16(s0)
 754:	ec1c                	sd	a5,24(s0)
 756:	03043023          	sd	a6,32(s0)
 75a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 75e:	8622                	mv	a2,s0
 760:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 764:	d15ff0ef          	jal	478 <vprintf>
}
 768:	60e2                	ld	ra,24(sp)
 76a:	6442                	ld	s0,16(sp)
 76c:	6161                	addi	sp,sp,80
 76e:	8082                	ret

0000000000000770 <printf>:

void
printf(const char *fmt, ...)
{
 770:	711d                	addi	sp,sp,-96
 772:	ec06                	sd	ra,24(sp)
 774:	e822                	sd	s0,16(sp)
 776:	1000                	addi	s0,sp,32
 778:	e40c                	sd	a1,8(s0)
 77a:	e810                	sd	a2,16(s0)
 77c:	ec14                	sd	a3,24(s0)
 77e:	f018                	sd	a4,32(s0)
 780:	f41c                	sd	a5,40(s0)
 782:	03043823          	sd	a6,48(s0)
 786:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 78a:	00840613          	addi	a2,s0,8
 78e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 792:	85aa                	mv	a1,a0
 794:	4505                	li	a0,1
 796:	ce3ff0ef          	jal	478 <vprintf>
}
 79a:	60e2                	ld	ra,24(sp)
 79c:	6442                	ld	s0,16(sp)
 79e:	6125                	addi	sp,sp,96
 7a0:	8082                	ret

00000000000007a2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a2:	1141                	addi	sp,sp,-16
 7a4:	e406                	sd	ra,8(sp)
 7a6:	e022                	sd	s0,0(sp)
 7a8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7aa:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ae:	00001797          	auipc	a5,0x1
 7b2:	8527b783          	ld	a5,-1966(a5) # 1000 <freep>
 7b6:	a095                	j	81a <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 7b8:	ff852583          	lw	a1,-8(a0)
 7bc:	6390                	ld	a2,0(a5)
 7be:	02059813          	slli	a6,a1,0x20
 7c2:	01c85693          	srli	a3,a6,0x1c
 7c6:	96ba                	add	a3,a3,a4
 7c8:	02d60563          	beq	a2,a3,7f2 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7cc:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 7d0:	4790                	lw	a2,8(a5)
 7d2:	02061593          	slli	a1,a2,0x20
 7d6:	01c5d693          	srli	a3,a1,0x1c
 7da:	96be                	add	a3,a3,a5
 7dc:	02d70263          	beq	a4,a3,800 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7e0:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7e2:	00001717          	auipc	a4,0x1
 7e6:	80f73f23          	sd	a5,-2018(a4) # 1000 <freep>
}
 7ea:	60a2                	ld	ra,8(sp)
 7ec:	6402                	ld	s0,0(sp)
 7ee:	0141                	addi	sp,sp,16
 7f0:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7f2:	4614                	lw	a3,8(a2)
 7f4:	9ead                	addw	a3,a3,a1
 7f6:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7fa:	6394                	ld	a3,0(a5)
 7fc:	6290                	ld	a2,0(a3)
 7fe:	b7f9                	j	7cc <free+0x2a>
    p->s.size += bp->s.size;
 800:	ff852703          	lw	a4,-8(a0)
 804:	9f31                	addw	a4,a4,a2
 806:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 808:	ff053703          	ld	a4,-16(a0)
 80c:	bfd1                	j	7e0 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 80e:	6394                	ld	a3,0(a5)
 810:	00d7e463          	bltu	a5,a3,818 <free+0x76>
 814:	fad762e3          	bltu	a4,a3,7b8 <free+0x16>
 818:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81a:	fee7fae3          	bgeu	a5,a4,80e <free+0x6c>
 81e:	6394                	ld	a3,0(a5)
 820:	f8d76ce3          	bltu	a4,a3,7b8 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 824:	f8d7fae3          	bgeu	a5,a3,7b8 <free+0x16>
 828:	87b6                	mv	a5,a3
 82a:	bfc5                	j	81a <free+0x78>

000000000000082c <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 82c:	7139                	addi	sp,sp,-64
 82e:	fc06                	sd	ra,56(sp)
 830:	f822                	sd	s0,48(sp)
 832:	f04a                	sd	s2,32(sp)
 834:	ec4e                	sd	s3,24(sp)
 836:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 838:	02051993          	slli	s3,a0,0x20
 83c:	0209d993          	srli	s3,s3,0x20
 840:	09bd                	addi	s3,s3,15
 842:	0049d993          	srli	s3,s3,0x4
 846:	2985                	addiw	s3,s3,1
 848:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 84a:	00000517          	auipc	a0,0x0
 84e:	7b653503          	ld	a0,1974(a0) # 1000 <freep>
 852:	c905                	beqz	a0,882 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 854:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 856:	4798                	lw	a4,8(a5)
 858:	09377663          	bgeu	a4,s3,8e4 <malloc+0xb8>
 85c:	f426                	sd	s1,40(sp)
 85e:	e852                	sd	s4,16(sp)
 860:	e456                	sd	s5,8(sp)
 862:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 864:	8a4e                	mv	s4,s3
 866:	6705                	lui	a4,0x1
 868:	00e9f363          	bgeu	s3,a4,86e <malloc+0x42>
 86c:	6a05                	lui	s4,0x1
 86e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 872:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 876:	00000497          	auipc	s1,0x0
 87a:	78a48493          	addi	s1,s1,1930 # 1000 <freep>
  if (p == SBRK_ERROR)
 87e:	5afd                	li	s5,-1
 880:	a83d                	j	8be <malloc+0x92>
 882:	f426                	sd	s1,40(sp)
 884:	e852                	sd	s4,16(sp)
 886:	e456                	sd	s5,8(sp)
 888:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 88a:	00000797          	auipc	a5,0x0
 88e:	78678793          	addi	a5,a5,1926 # 1010 <base>
 892:	00000717          	auipc	a4,0x0
 896:	76f73723          	sd	a5,1902(a4) # 1000 <freep>
 89a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 89c:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8a0:	b7d1                	j	864 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8a2:	6398                	ld	a4,0(a5)
 8a4:	e118                	sd	a4,0(a0)
 8a6:	a899                	j	8fc <malloc+0xd0>
  hp->s.size = nu;
 8a8:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8ac:	0541                	addi	a0,a0,16
 8ae:	ef5ff0ef          	jal	7a2 <free>
  return freep;
 8b2:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8b4:	c125                	beqz	a0,914 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8b6:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8b8:	4798                	lw	a4,8(a5)
 8ba:	03277163          	bgeu	a4,s2,8dc <malloc+0xb0>
    if (p == freep)
 8be:	6098                	ld	a4,0(s1)
 8c0:	853e                	mv	a0,a5
 8c2:	fef71ae3          	bne	a4,a5,8b6 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8c6:	8552                	mv	a0,s4
 8c8:	a0fff0ef          	jal	2d6 <sbrk>
  if (p == SBRK_ERROR)
 8cc:	fd551ee3          	bne	a0,s5,8a8 <malloc+0x7c>
        return 0;
 8d0:	4501                	li	a0,0
 8d2:	74a2                	ld	s1,40(sp)
 8d4:	6a42                	ld	s4,16(sp)
 8d6:	6aa2                	ld	s5,8(sp)
 8d8:	6b02                	ld	s6,0(sp)
 8da:	a03d                	j	908 <malloc+0xdc>
 8dc:	74a2                	ld	s1,40(sp)
 8de:	6a42                	ld	s4,16(sp)
 8e0:	6aa2                	ld	s5,8(sp)
 8e2:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8e4:	fae90fe3          	beq	s2,a4,8a2 <malloc+0x76>
        p->s.size -= nunits;
 8e8:	4137073b          	subw	a4,a4,s3
 8ec:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ee:	02071693          	slli	a3,a4,0x20
 8f2:	01c6d713          	srli	a4,a3,0x1c
 8f6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8f8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8fc:	00000717          	auipc	a4,0x0
 900:	70a73223          	sd	a0,1796(a4) # 1000 <freep>
      return (void *)(p + 1);
 904:	01078513          	addi	a0,a5,16
  }
}
 908:	70e2                	ld	ra,56(sp)
 90a:	7442                	ld	s0,48(sp)
 90c:	7902                	ld	s2,32(sp)
 90e:	69e2                	ld	s3,24(sp)
 910:	6121                	addi	sp,sp,64
 912:	8082                	ret
 914:	74a2                	ld	s1,40(sp)
 916:	6a42                	ld	s4,16(sp)
 918:	6aa2                	ld	s5,8(sp)
 91a:	6b02                	ld	s6,0(sp)
 91c:	b7f5                	j	908 <malloc+0xdc>
