
user/_testfcfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	4911                	li	s2,4
  int i, j;
  for(i = 0; i < 4; i++){
    if(fork() == 0){
   e:	2f0000ef          	jal	2fe <fork>
  12:	84aa                	mv	s1,a0
  14:	cd09                	beqz	a0,2e <main+0x2e>
  for(i = 0; i < 4; i++){
  16:	397d                	addiw	s2,s2,-1
  18:	fe091be3          	bnez	s2,e <main+0xe>
  1c:	4491                	li	s1,4
        printf("pid %d: iteration %d\n", getpid(), j);
      exit(0);
    }
  }
  for(i = 0; i < 4; i++)
    wait(0);
  1e:	4501                	li	a0,0
  20:	2ee000ef          	jal	30e <wait>
  for(i = 0; i < 4; i++)
  24:	34fd                	addiw	s1,s1,-1
  26:	fce5                	bnez	s1,1e <main+0x1e>
  exit(0);
  28:	4501                	li	a0,0
  2a:	2dc000ef          	jal	306 <exit>
      for(j = 0; j < 5; j++)
  2e:	4915                	li	s2,5
        printf("pid %d: iteration %d\n", getpid(), j);
  30:	356000ef          	jal	386 <getpid>
  34:	85aa                	mv	a1,a0
  36:	8626                	mv	a2,s1
  38:	00001517          	auipc	a0,0x1
  3c:	8e850513          	addi	a0,a0,-1816 # 920 <malloc+0xf8>
  40:	72c000ef          	jal	76c <printf>
      for(j = 0; j < 5; j++)
  44:	2485                	addiw	s1,s1,1
  46:	ff2495e3          	bne	s1,s2,30 <main+0x30>
      exit(0);
  4a:	4501                	li	a0,0
  4c:	2ba000ef          	jal	306 <exit>

0000000000000050 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  50:	1141                	addi	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  58:	fa9ff0ef          	jal	0 <main>
  exit(r);
  5c:	2aa000ef          	jal	306 <exit>

0000000000000060 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  60:	1141                	addi	sp,sp,-16
  62:	e406                	sd	ra,8(sp)
  64:	e022                	sd	s0,0(sp)
  66:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  68:	87aa                	mv	a5,a0
  6a:	0585                	addi	a1,a1,1
  6c:	0785                	addi	a5,a5,1
  6e:	fff5c703          	lbu	a4,-1(a1)
  72:	fee78fa3          	sb	a4,-1(a5)
  76:	fb75                	bnez	a4,6a <strcpy+0xa>
    ;
  return os;
}
  78:	60a2                	ld	ra,8(sp)
  7a:	6402                	ld	s0,0(sp)
  7c:	0141                	addi	sp,sp,16
  7e:	8082                	ret

0000000000000080 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80:	1141                	addi	sp,sp,-16
  82:	e406                	sd	ra,8(sp)
  84:	e022                	sd	s0,0(sp)
  86:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  88:	00054783          	lbu	a5,0(a0)
  8c:	cb91                	beqz	a5,a0 <strcmp+0x20>
  8e:	0005c703          	lbu	a4,0(a1)
  92:	00f71763          	bne	a4,a5,a0 <strcmp+0x20>
    p++, q++;
  96:	0505                	addi	a0,a0,1
  98:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  9a:	00054783          	lbu	a5,0(a0)
  9e:	fbe5                	bnez	a5,8e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  a0:	0005c503          	lbu	a0,0(a1)
}
  a4:	40a7853b          	subw	a0,a5,a0
  a8:	60a2                	ld	ra,8(sp)
  aa:	6402                	ld	s0,0(sp)
  ac:	0141                	addi	sp,sp,16
  ae:	8082                	ret

00000000000000b0 <strlen>:

uint
strlen(const char *s)
{
  b0:	1141                	addi	sp,sp,-16
  b2:	e406                	sd	ra,8(sp)
  b4:	e022                	sd	s0,0(sp)
  b6:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  b8:	00054783          	lbu	a5,0(a0)
  bc:	cf91                	beqz	a5,d8 <strlen+0x28>
  be:	00150793          	addi	a5,a0,1
  c2:	86be                	mv	a3,a5
  c4:	0785                	addi	a5,a5,1
  c6:	fff7c703          	lbu	a4,-1(a5)
  ca:	ff65                	bnez	a4,c2 <strlen+0x12>
  cc:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  d0:	60a2                	ld	ra,8(sp)
  d2:	6402                	ld	s0,0(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret
  for (n = 0; s[n]; n++)
  d8:	4501                	li	a0,0
  da:	bfdd                	j	d0 <strlen+0x20>

00000000000000dc <memset>:

void *
memset(void *dst, int c, uint n)
{
  dc:	1141                	addi	sp,sp,-16
  de:	e406                	sd	ra,8(sp)
  e0:	e022                	sd	s0,0(sp)
  e2:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  e4:	ca19                	beqz	a2,fa <memset+0x1e>
  e6:	87aa                	mv	a5,a0
  e8:	1602                	slli	a2,a2,0x20
  ea:	9201                	srli	a2,a2,0x20
  ec:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f0:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  f4:	0785                	addi	a5,a5,1
  f6:	fee79de3          	bne	a5,a4,f0 <memset+0x14>
  }
  return dst;
}
  fa:	60a2                	ld	ra,8(sp)
  fc:	6402                	ld	s0,0(sp)
  fe:	0141                	addi	sp,sp,16
 100:	8082                	ret

0000000000000102 <strchr>:

char *
strchr(const char *s, char c)
{
 102:	1141                	addi	sp,sp,-16
 104:	e406                	sd	ra,8(sp)
 106:	e022                	sd	s0,0(sp)
 108:	0800                	addi	s0,sp,16
  for (; *s; s++)
 10a:	00054783          	lbu	a5,0(a0)
 10e:	c799                	beqz	a5,11c <strchr+0x1a>
    if (*s == c)
 110:	00f58763          	beq	a1,a5,11e <strchr+0x1c>
  for (; *s; s++)
 114:	0505                	addi	a0,a0,1
 116:	00054783          	lbu	a5,0(a0)
 11a:	fbfd                	bnez	a5,110 <strchr+0xe>
      return (char *)s;
  return 0;
 11c:	4501                	li	a0,0
}
 11e:	60a2                	ld	ra,8(sp)
 120:	6402                	ld	s0,0(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <gets>:

char *
gets(char *buf, int max)
{
 126:	711d                	addi	sp,sp,-96
 128:	ec86                	sd	ra,88(sp)
 12a:	e8a2                	sd	s0,80(sp)
 12c:	e4a6                	sd	s1,72(sp)
 12e:	e0ca                	sd	s2,64(sp)
 130:	fc4e                	sd	s3,56(sp)
 132:	f852                	sd	s4,48(sp)
 134:	f456                	sd	s5,40(sp)
 136:	f05a                	sd	s6,32(sp)
 138:	ec5e                	sd	s7,24(sp)
 13a:	e862                	sd	s8,16(sp)
 13c:	1080                	addi	s0,sp,96
 13e:	8baa                	mv	s7,a0
 140:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 142:	892a                	mv	s2,a0
 144:	4481                	li	s1,0
    cc = read(0, &c, 1);
 146:	faf40b13          	addi	s6,s0,-81
 14a:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 14c:	8c26                	mv	s8,s1
 14e:	0014899b          	addiw	s3,s1,1
 152:	84ce                	mv	s1,s3
 154:	0349d863          	bge	s3,s4,184 <gets+0x5e>
    cc = read(0, &c, 1);
 158:	8656                	mv	a2,s5
 15a:	85da                	mv	a1,s6
 15c:	4501                	li	a0,0
 15e:	1c0000ef          	jal	31e <read>
    if (cc < 1)
 162:	02a05163          	blez	a0,184 <gets+0x5e>
      break;
    buf[i++] = c;
 166:	faf44783          	lbu	a5,-81(s0)
 16a:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 16e:	0905                	addi	s2,s2,1
 170:	ff678713          	addi	a4,a5,-10
 174:	00173713          	seqz	a4,a4
 178:	17cd                	addi	a5,a5,-13
 17a:	0017b793          	seqz	a5,a5
 17e:	8fd9                	or	a5,a5,a4
 180:	d7f1                	beqz	a5,14c <gets+0x26>
    buf[i++] = c;
 182:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 184:	9c5e                	add	s8,s8,s7
 186:	000c0023          	sb	zero,0(s8)
  return buf;
}
 18a:	855e                	mv	a0,s7
 18c:	60e6                	ld	ra,88(sp)
 18e:	6446                	ld	s0,80(sp)
 190:	64a6                	ld	s1,72(sp)
 192:	6906                	ld	s2,64(sp)
 194:	79e2                	ld	s3,56(sp)
 196:	7a42                	ld	s4,48(sp)
 198:	7aa2                	ld	s5,40(sp)
 19a:	7b02                	ld	s6,32(sp)
 19c:	6be2                	ld	s7,24(sp)
 19e:	6c42                	ld	s8,16(sp)
 1a0:	6125                	addi	sp,sp,96
 1a2:	8082                	ret

00000000000001a4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a4:	1101                	addi	sp,sp,-32
 1a6:	ec06                	sd	ra,24(sp)
 1a8:	e822                	sd	s0,16(sp)
 1aa:	e04a                	sd	s2,0(sp)
 1ac:	1000                	addi	s0,sp,32
 1ae:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b0:	4581                	li	a1,0
 1b2:	194000ef          	jal	346 <open>
  if (fd < 0)
 1b6:	02054263          	bltz	a0,1da <stat+0x36>
 1ba:	e426                	sd	s1,8(sp)
 1bc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1be:	85ca                	mv	a1,s2
 1c0:	19e000ef          	jal	35e <fstat>
 1c4:	892a                	mv	s2,a0
  close(fd);
 1c6:	8526                	mv	a0,s1
 1c8:	166000ef          	jal	32e <close>
  return r;
 1cc:	64a2                	ld	s1,8(sp)
}
 1ce:	854a                	mv	a0,s2
 1d0:	60e2                	ld	ra,24(sp)
 1d2:	6442                	ld	s0,16(sp)
 1d4:	6902                	ld	s2,0(sp)
 1d6:	6105                	addi	sp,sp,32
 1d8:	8082                	ret
    return -1;
 1da:	57fd                	li	a5,-1
 1dc:	893e                	mv	s2,a5
 1de:	bfc5                	j	1ce <stat+0x2a>

00000000000001e0 <atoi>:

int
atoi(const char *s)
{
 1e0:	1141                	addi	sp,sp,-16
 1e2:	e406                	sd	ra,8(sp)
 1e4:	e022                	sd	s0,0(sp)
 1e6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1e8:	00054683          	lbu	a3,0(a0)
 1ec:	fd06879b          	addiw	a5,a3,-48
 1f0:	0ff7f793          	zext.b	a5,a5
 1f4:	4625                	li	a2,9
 1f6:	02f66963          	bltu	a2,a5,228 <atoi+0x48>
 1fa:	872a                	mv	a4,a0
  n = 0;
 1fc:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 1fe:	0705                	addi	a4,a4,1
 200:	0025179b          	slliw	a5,a0,0x2
 204:	9fa9                	addw	a5,a5,a0
 206:	0017979b          	slliw	a5,a5,0x1
 20a:	9fb5                	addw	a5,a5,a3
 20c:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 210:	00074683          	lbu	a3,0(a4)
 214:	fd06879b          	addiw	a5,a3,-48
 218:	0ff7f793          	zext.b	a5,a5
 21c:	fef671e3          	bgeu	a2,a5,1fe <atoi+0x1e>
  return n;
}
 220:	60a2                	ld	ra,8(sp)
 222:	6402                	ld	s0,0(sp)
 224:	0141                	addi	sp,sp,16
 226:	8082                	ret
  n = 0;
 228:	4501                	li	a0,0
 22a:	bfdd                	j	220 <atoi+0x40>

000000000000022c <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 22c:	1141                	addi	sp,sp,-16
 22e:	e406                	sd	ra,8(sp)
 230:	e022                	sd	s0,0(sp)
 232:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 234:	02b57563          	bgeu	a0,a1,25e <memmove+0x32>
    while (n-- > 0)
 238:	00c05f63          	blez	a2,256 <memmove+0x2a>
 23c:	1602                	slli	a2,a2,0x20
 23e:	9201                	srli	a2,a2,0x20
 240:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 244:	872a                	mv	a4,a0
      *dst++ = *src++;
 246:	0585                	addi	a1,a1,1
 248:	0705                	addi	a4,a4,1
 24a:	fff5c683          	lbu	a3,-1(a1)
 24e:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 252:	fee79ae3          	bne	a5,a4,246 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 256:	60a2                	ld	ra,8(sp)
 258:	6402                	ld	s0,0(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret
    while (n-- > 0)
 25e:	fec05ce3          	blez	a2,256 <memmove+0x2a>
    dst += n;
 262:	00c50733          	add	a4,a0,a2
    src += n;
 266:	95b2                	add	a1,a1,a2
 268:	fff6079b          	addiw	a5,a2,-1
 26c:	1782                	slli	a5,a5,0x20
 26e:	9381                	srli	a5,a5,0x20
 270:	fff7c793          	not	a5,a5
 274:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 276:	15fd                	addi	a1,a1,-1
 278:	177d                	addi	a4,a4,-1
 27a:	0005c683          	lbu	a3,0(a1)
 27e:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 282:	fef71ae3          	bne	a4,a5,276 <memmove+0x4a>
 286:	bfc1                	j	256 <memmove+0x2a>

0000000000000288 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 288:	1141                	addi	sp,sp,-16
 28a:	e406                	sd	ra,8(sp)
 28c:	e022                	sd	s0,0(sp)
 28e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 290:	ce19                	beqz	a2,2ae <memcmp+0x26>
 292:	1602                	slli	a2,a2,0x20
 294:	9201                	srli	a2,a2,0x20
 296:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 29a:	00054783          	lbu	a5,0(a0)
 29e:	0005c703          	lbu	a4,0(a1)
 2a2:	00e79b63          	bne	a5,a4,2b8 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 2a6:	0505                	addi	a0,a0,1
    p2++;
 2a8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2aa:	fed518e3          	bne	a0,a3,29a <memcmp+0x12>
  }
  return 0;
 2ae:	4501                	li	a0,0
}
 2b0:	60a2                	ld	ra,8(sp)
 2b2:	6402                	ld	s0,0(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret
      return *p1 - *p2;
 2b8:	40e7853b          	subw	a0,a5,a4
 2bc:	bfd5                	j	2b0 <memcmp+0x28>

00000000000002be <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2be:	1141                	addi	sp,sp,-16
 2c0:	e406                	sd	ra,8(sp)
 2c2:	e022                	sd	s0,0(sp)
 2c4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2c6:	f67ff0ef          	jal	22c <memmove>
}
 2ca:	60a2                	ld	ra,8(sp)
 2cc:	6402                	ld	s0,0(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret

00000000000002d2 <sbrk>:

char *
sbrk(int n)
{
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e406                	sd	ra,8(sp)
 2d6:	e022                	sd	s0,0(sp)
 2d8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2da:	4585                	li	a1,1
 2dc:	0b2000ef          	jal	38e <sys_sbrk>
}
 2e0:	60a2                	ld	ra,8(sp)
 2e2:	6402                	ld	s0,0(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret

00000000000002e8 <sbrklazy>:

char *
sbrklazy(int n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e406                	sd	ra,8(sp)
 2ec:	e022                	sd	s0,0(sp)
 2ee:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2f0:	4589                	li	a1,2
 2f2:	09c000ef          	jal	38e <sys_sbrk>
}
 2f6:	60a2                	ld	ra,8(sp)
 2f8:	6402                	ld	s0,0(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret

00000000000002fe <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2fe:	4885                	li	a7,1
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <exit>:
.global exit
exit:
 li a7, SYS_exit
 306:	4889                	li	a7,2
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <wait>:
.global wait
wait:
 li a7, SYS_wait
 30e:	488d                	li	a7,3
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 316:	4891                	li	a7,4
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <read>:
.global read
read:
 li a7, SYS_read
 31e:	4895                	li	a7,5
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <write>:
.global write
write:
 li a7, SYS_write
 326:	48c1                	li	a7,16
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <close>:
.global close
close:
 li a7, SYS_close
 32e:	48d5                	li	a7,21
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <kill>:
.global kill
kill:
 li a7, SYS_kill
 336:	4899                	li	a7,6
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <exec>:
.global exec
exec:
 li a7, SYS_exec
 33e:	489d                	li	a7,7
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <open>:
.global open
open:
 li a7, SYS_open
 346:	48bd                	li	a7,15
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 34e:	48c5                	li	a7,17
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 356:	48c9                	li	a7,18
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 35e:	48a1                	li	a7,8
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <link>:
.global link
link:
 li a7, SYS_link
 366:	48cd                	li	a7,19
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 36e:	48d1                	li	a7,20
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 376:	48a5                	li	a7,9
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <dup>:
.global dup
dup:
 li a7, SYS_dup
 37e:	48a9                	li	a7,10
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 386:	48ad                	li	a7,11
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 38e:	48b1                	li	a7,12
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <pause>:
.global pause
pause:
 li a7, SYS_pause
 396:	48b5                	li	a7,13
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 39e:	48b9                	li	a7,14
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <sync>:
.global sync
sync:
 li a7, SYS_sync
 3a6:	48d9                	li	a7,22
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3ae:	48dd                	li	a7,23
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b6:	1101                	addi	sp,sp,-32
 3b8:	ec06                	sd	ra,24(sp)
 3ba:	e822                	sd	s0,16(sp)
 3bc:	1000                	addi	s0,sp,32
 3be:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c2:	4605                	li	a2,1
 3c4:	fef40593          	addi	a1,s0,-17
 3c8:	f5fff0ef          	jal	326 <write>
}
 3cc:	60e2                	ld	ra,24(sp)
 3ce:	6442                	ld	s0,16(sp)
 3d0:	6105                	addi	sp,sp,32
 3d2:	8082                	ret

00000000000003d4 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3d4:	715d                	addi	sp,sp,-80
 3d6:	e486                	sd	ra,72(sp)
 3d8:	e0a2                	sd	s0,64(sp)
 3da:	f84a                	sd	s2,48(sp)
 3dc:	f44e                	sd	s3,40(sp)
 3de:	0880                	addi	s0,sp,80
 3e0:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3e2:	00d036b3          	snez	a3,a3
 3e6:	03f5d793          	srli	a5,a1,0x3f
 3ea:	8efd                	and	a3,a3,a5
  neg = 0;
 3ec:	4301                	li	t1,0
  if (sgn && xx < 0) {
 3ee:	c681                	beqz	a3,3f6 <printint+0x22>
    neg = 1;
    x = -xx;
 3f0:	40b005b3          	neg	a1,a1
    neg = 1;
 3f4:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3f6:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3fa:	86ce                	mv	a3,s3
  i = 0;
 3fc:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 3fe:	00000817          	auipc	a6,0x0
 402:	54280813          	addi	a6,a6,1346 # 940 <digits>
 406:	88ba                	mv	a7,a4
 408:	0017051b          	addiw	a0,a4,1
 40c:	872a                	mv	a4,a0
 40e:	02c5f7b3          	remu	a5,a1,a2
 412:	97c2                	add	a5,a5,a6
 414:	0007c783          	lbu	a5,0(a5)
 418:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 41c:	87ae                	mv	a5,a1
 41e:	02c5d5b3          	divu	a1,a1,a2
 422:	0685                	addi	a3,a3,1
 424:	fec7f1e3          	bgeu	a5,a2,406 <printint+0x32>
  if (neg)
 428:	00030b63          	beqz	t1,43e <printint+0x6a>
    buf[i++] = '-';
 42c:	fd040793          	addi	a5,s0,-48
 430:	953e                	add	a0,a0,a5
 432:	02d00793          	li	a5,45
 436:	fef50423          	sb	a5,-24(a0)
 43a:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 43e:	02e05563          	blez	a4,468 <printint+0x94>
 442:	fc26                	sd	s1,56(sp)
 444:	377d                	addiw	a4,a4,-1
 446:	00e984b3          	add	s1,s3,a4
 44a:	19fd                	addi	s3,s3,-1
 44c:	99ba                	add	s3,s3,a4
 44e:	1702                	slli	a4,a4,0x20
 450:	9301                	srli	a4,a4,0x20
 452:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 456:	0004c583          	lbu	a1,0(s1)
 45a:	854a                	mv	a0,s2
 45c:	f5bff0ef          	jal	3b6 <putc>
  while (--i >= 0)
 460:	14fd                	addi	s1,s1,-1
 462:	ff349ae3          	bne	s1,s3,456 <printint+0x82>
 466:	74e2                	ld	s1,56(sp)
}
 468:	60a6                	ld	ra,72(sp)
 46a:	6406                	ld	s0,64(sp)
 46c:	7942                	ld	s2,48(sp)
 46e:	79a2                	ld	s3,40(sp)
 470:	6161                	addi	sp,sp,80
 472:	8082                	ret

0000000000000474 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 474:	711d                	addi	sp,sp,-96
 476:	ec86                	sd	ra,88(sp)
 478:	e8a2                	sd	s0,80(sp)
 47a:	e4a6                	sd	s1,72(sp)
 47c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 47e:	0005c483          	lbu	s1,0(a1)
 482:	2a048063          	beqz	s1,722 <vprintf+0x2ae>
 486:	e0ca                	sd	s2,64(sp)
 488:	fc4e                	sd	s3,56(sp)
 48a:	f852                	sd	s4,48(sp)
 48c:	f456                	sd	s5,40(sp)
 48e:	f05a                	sd	s6,32(sp)
 490:	ec5e                	sd	s7,24(sp)
 492:	e862                	sd	s8,16(sp)
 494:	8b2a                	mv	s6,a0
 496:	8a2e                	mv	s4,a1
 498:	8bb2                	mv	s7,a2
  state = 0;
 49a:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 49c:	4901                	li	s2,0
 49e:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 4a0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4a4:	06400c13          	li	s8,100
 4a8:	a00d                	j	4ca <vprintf+0x56>
        putc(fd, c0);
 4aa:	85a6                	mv	a1,s1
 4ac:	855a                	mv	a0,s6
 4ae:	f09ff0ef          	jal	3b6 <putc>
 4b2:	a019                	j	4b8 <vprintf+0x44>
    } else if (state == '%') {
 4b4:	03598363          	beq	s3,s5,4da <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 4b8:	0019079b          	addiw	a5,s2,1
 4bc:	893e                	mv	s2,a5
 4be:	873e                	mv	a4,a5
 4c0:	97d2                	add	a5,a5,s4
 4c2:	0007c483          	lbu	s1,0(a5)
 4c6:	24048763          	beqz	s1,714 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 4ca:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4ce:	fe0993e3          	bnez	s3,4b4 <vprintf+0x40>
      if (c0 == '%') {
 4d2:	fd579ce3          	bne	a5,s5,4aa <vprintf+0x36>
        state = '%';
 4d6:	89be                	mv	s3,a5
 4d8:	b7c5                	j	4b8 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 4da:	00ea06b3          	add	a3,s4,a4
 4de:	0016c603          	lbu	a2,1(a3)
      if (c1)
 4e2:	24060563          	beqz	a2,72c <vprintf+0x2b8>
      if (c0 == 'd') {
 4e6:	0b878763          	beq	a5,s8,594 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4ea:	f9478693          	addi	a3,a5,-108
 4ee:	0016b693          	seqz	a3,a3
 4f2:	f9c60593          	addi	a1,a2,-100
 4f6:	0015b593          	seqz	a1,a1
 4fa:	8df5                	and	a1,a1,a3
 4fc:	e9c5                	bnez	a1,5ac <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 4fe:	9752                	add	a4,a4,s4
 500:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 504:	f9460713          	addi	a4,a2,-108
 508:	00173713          	seqz	a4,a4
 50c:	8f75                	and	a4,a4,a3
 50e:	f9c50593          	addi	a1,a0,-100
 512:	0015b593          	seqz	a1,a1
 516:	8df9                	and	a1,a1,a4
 518:	e5dd                	bnez	a1,5c6 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 51a:	07500593          	li	a1,117
 51e:	0cb78163          	beq	a5,a1,5e0 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 522:	f8b60593          	addi	a1,a2,-117
 526:	0015b593          	seqz	a1,a1
 52a:	8df5                	and	a1,a1,a3
 52c:	e5f1                	bnez	a1,5f8 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 52e:	f8b50593          	addi	a1,a0,-117
 532:	0015b593          	seqz	a1,a1
 536:	8df9                	and	a1,a1,a4
 538:	ede9                	bnez	a1,612 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 53a:	07800593          	li	a1,120
 53e:	0eb78763          	beq	a5,a1,62c <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 542:	f8860613          	addi	a2,a2,-120
 546:	00163613          	seqz	a2,a2
 54a:	8ef1                	and	a3,a3,a2
 54c:	0e069c63          	bnez	a3,644 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 550:	f8850513          	addi	a0,a0,-120
 554:	00153513          	seqz	a0,a0
 558:	8f69                	and	a4,a4,a0
 55a:	10071263          	bnez	a4,65e <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 55e:	07000713          	li	a4,112
 562:	10e78a63          	beq	a5,a4,676 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 566:	06300713          	li	a4,99
 56a:	14e78a63          	beq	a5,a4,6be <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 56e:	07300713          	li	a4,115
 572:	16e78063          	beq	a5,a4,6d2 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 576:	02500713          	li	a4,37
 57a:	18e78863          	beq	a5,a4,70a <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 57e:	02500593          	li	a1,37
 582:	855a                	mv	a0,s6
 584:	e33ff0ef          	jal	3b6 <putc>
        putc(fd, c0);
 588:	85a6                	mv	a1,s1
 58a:	855a                	mv	a0,s6
 58c:	e2bff0ef          	jal	3b6 <putc>
      }

      state = 0;
 590:	4981                	li	s3,0
 592:	b71d                	j	4b8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 594:	008b8493          	addi	s1,s7,8
 598:	4685                	li	a3,1
 59a:	4629                	li	a2,10
 59c:	000ba583          	lw	a1,0(s7)
 5a0:	855a                	mv	a0,s6
 5a2:	e33ff0ef          	jal	3d4 <printint>
 5a6:	8ba6                	mv	s7,s1
      state = 0;
 5a8:	4981                	li	s3,0
 5aa:	b739                	j	4b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ac:	008b8493          	addi	s1,s7,8
 5b0:	4685                	li	a3,1
 5b2:	4629                	li	a2,10
 5b4:	000bb583          	ld	a1,0(s7)
 5b8:	855a                	mv	a0,s6
 5ba:	e1bff0ef          	jal	3d4 <printint>
        i += 1;
 5be:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c0:	8ba6                	mv	s7,s1
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	bdd5                	j	4b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c6:	008b8493          	addi	s1,s7,8
 5ca:	4685                	li	a3,1
 5cc:	4629                	li	a2,10
 5ce:	000bb583          	ld	a1,0(s7)
 5d2:	855a                	mv	a0,s6
 5d4:	e01ff0ef          	jal	3d4 <printint>
        i += 2;
 5d8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5da:	8ba6                	mv	s7,s1
      state = 0;
 5dc:	4981                	li	s3,0
        i += 2;
 5de:	bde9                	j	4b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5e0:	008b8493          	addi	s1,s7,8
 5e4:	4681                	li	a3,0
 5e6:	4629                	li	a2,10
 5e8:	000be583          	lwu	a1,0(s7)
 5ec:	855a                	mv	a0,s6
 5ee:	de7ff0ef          	jal	3d4 <printint>
 5f2:	8ba6                	mv	s7,s1
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	b5c9                	j	4b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f8:	008b8493          	addi	s1,s7,8
 5fc:	4681                	li	a3,0
 5fe:	4629                	li	a2,10
 600:	000bb583          	ld	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	dcfff0ef          	jal	3d4 <printint>
        i += 1;
 60a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 60c:	8ba6                	mv	s7,s1
      state = 0;
 60e:	4981                	li	s3,0
 610:	b565                	j	4b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 612:	008b8493          	addi	s1,s7,8
 616:	4681                	li	a3,0
 618:	4629                	li	a2,10
 61a:	000bb583          	ld	a1,0(s7)
 61e:	855a                	mv	a0,s6
 620:	db5ff0ef          	jal	3d4 <printint>
        i += 2;
 624:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 626:	8ba6                	mv	s7,s1
      state = 0;
 628:	4981                	li	s3,0
        i += 2;
 62a:	b579                	j	4b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 62c:	008b8493          	addi	s1,s7,8
 630:	4681                	li	a3,0
 632:	4641                	li	a2,16
 634:	000be583          	lwu	a1,0(s7)
 638:	855a                	mv	a0,s6
 63a:	d9bff0ef          	jal	3d4 <printint>
 63e:	8ba6                	mv	s7,s1
      state = 0;
 640:	4981                	li	s3,0
 642:	bd9d                	j	4b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 644:	008b8493          	addi	s1,s7,8
 648:	4681                	li	a3,0
 64a:	4641                	li	a2,16
 64c:	000bb583          	ld	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	d83ff0ef          	jal	3d4 <printint>
        i += 1;
 656:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 658:	8ba6                	mv	s7,s1
      state = 0;
 65a:	4981                	li	s3,0
 65c:	bdb1                	j	4b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 65e:	008b8493          	addi	s1,s7,8
 662:	4641                	li	a2,16
 664:	000bb583          	ld	a1,0(s7)
 668:	855a                	mv	a0,s6
 66a:	d6bff0ef          	jal	3d4 <printint>
        i += 2;
 66e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 670:	8ba6                	mv	s7,s1
      state = 0;
 672:	4981                	li	s3,0
        i += 2;
 674:	b591                	j	4b8 <vprintf+0x44>
 676:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 678:	008b8793          	addi	a5,s7,8
 67c:	8cbe                	mv	s9,a5
 67e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 682:	03000593          	li	a1,48
 686:	855a                	mv	a0,s6
 688:	d2fff0ef          	jal	3b6 <putc>
  putc(fd, 'x');
 68c:	07800593          	li	a1,120
 690:	855a                	mv	a0,s6
 692:	d25ff0ef          	jal	3b6 <putc>
 696:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 698:	00000b97          	auipc	s7,0x0
 69c:	2a8b8b93          	addi	s7,s7,680 # 940 <digits>
 6a0:	03c9d793          	srli	a5,s3,0x3c
 6a4:	97de                	add	a5,a5,s7
 6a6:	0007c583          	lbu	a1,0(a5)
 6aa:	855a                	mv	a0,s6
 6ac:	d0bff0ef          	jal	3b6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6b0:	0992                	slli	s3,s3,0x4
 6b2:	34fd                	addiw	s1,s1,-1
 6b4:	f4f5                	bnez	s1,6a0 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 6b6:	8be6                	mv	s7,s9
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	6ca2                	ld	s9,8(sp)
 6bc:	bbf5                	j	4b8 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6be:	008b8493          	addi	s1,s7,8
 6c2:	000bc583          	lbu	a1,0(s7)
 6c6:	855a                	mv	a0,s6
 6c8:	cefff0ef          	jal	3b6 <putc>
 6cc:	8ba6                	mv	s7,s1
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	b3e5                	j	4b8 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6d2:	008b8993          	addi	s3,s7,8
 6d6:	000bb483          	ld	s1,0(s7)
 6da:	cc91                	beqz	s1,6f6 <vprintf+0x282>
        for (; *s; s++)
 6dc:	0004c583          	lbu	a1,0(s1)
 6e0:	c195                	beqz	a1,704 <vprintf+0x290>
          putc(fd, *s);
 6e2:	855a                	mv	a0,s6
 6e4:	cd3ff0ef          	jal	3b6 <putc>
        for (; *s; s++)
 6e8:	0485                	addi	s1,s1,1
 6ea:	0004c583          	lbu	a1,0(s1)
 6ee:	f9f5                	bnez	a1,6e2 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 6f0:	8bce                	mv	s7,s3
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	b3d1                	j	4b8 <vprintf+0x44>
          s = "(null)";
 6f6:	00000497          	auipc	s1,0x0
 6fa:	24248493          	addi	s1,s1,578 # 938 <malloc+0x110>
        for (; *s; s++)
 6fe:	02800593          	li	a1,40
 702:	b7c5                	j	6e2 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 704:	8bce                	mv	s7,s3
      state = 0;
 706:	4981                	li	s3,0
 708:	bb45                	j	4b8 <vprintf+0x44>
        putc(fd, '%');
 70a:	85be                	mv	a1,a5
 70c:	855a                	mv	a0,s6
 70e:	ca9ff0ef          	jal	3b6 <putc>
 712:	bdbd                	j	590 <vprintf+0x11c>
 714:	6906                	ld	s2,64(sp)
 716:	79e2                	ld	s3,56(sp)
 718:	7a42                	ld	s4,48(sp)
 71a:	7aa2                	ld	s5,40(sp)
 71c:	7b02                	ld	s6,32(sp)
 71e:	6be2                	ld	s7,24(sp)
 720:	6c42                	ld	s8,16(sp)
    }
  }
}
 722:	60e6                	ld	ra,88(sp)
 724:	6446                	ld	s0,80(sp)
 726:	64a6                	ld	s1,72(sp)
 728:	6125                	addi	sp,sp,96
 72a:	8082                	ret
      if (c0 == 'd') {
 72c:	06400713          	li	a4,100
 730:	e6e782e3          	beq	a5,a4,594 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 734:	f9478693          	addi	a3,a5,-108
 738:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 73c:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 73e:	4701                	li	a4,0
 740:	bbe9                	j	51a <vprintf+0xa6>

0000000000000742 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 742:	715d                	addi	sp,sp,-80
 744:	ec06                	sd	ra,24(sp)
 746:	e822                	sd	s0,16(sp)
 748:	1000                	addi	s0,sp,32
 74a:	e010                	sd	a2,0(s0)
 74c:	e414                	sd	a3,8(s0)
 74e:	e818                	sd	a4,16(s0)
 750:	ec1c                	sd	a5,24(s0)
 752:	03043023          	sd	a6,32(s0)
 756:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 75a:	8622                	mv	a2,s0
 75c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 760:	d15ff0ef          	jal	474 <vprintf>
}
 764:	60e2                	ld	ra,24(sp)
 766:	6442                	ld	s0,16(sp)
 768:	6161                	addi	sp,sp,80
 76a:	8082                	ret

000000000000076c <printf>:

void
printf(const char *fmt, ...)
{
 76c:	711d                	addi	sp,sp,-96
 76e:	ec06                	sd	ra,24(sp)
 770:	e822                	sd	s0,16(sp)
 772:	1000                	addi	s0,sp,32
 774:	e40c                	sd	a1,8(s0)
 776:	e810                	sd	a2,16(s0)
 778:	ec14                	sd	a3,24(s0)
 77a:	f018                	sd	a4,32(s0)
 77c:	f41c                	sd	a5,40(s0)
 77e:	03043823          	sd	a6,48(s0)
 782:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 786:	00840613          	addi	a2,s0,8
 78a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 78e:	85aa                	mv	a1,a0
 790:	4505                	li	a0,1
 792:	ce3ff0ef          	jal	474 <vprintf>
}
 796:	60e2                	ld	ra,24(sp)
 798:	6442                	ld	s0,16(sp)
 79a:	6125                	addi	sp,sp,96
 79c:	8082                	ret

000000000000079e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 79e:	1141                	addi	sp,sp,-16
 7a0:	e406                	sd	ra,8(sp)
 7a2:	e022                	sd	s0,0(sp)
 7a4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7a6:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7aa:	00001797          	auipc	a5,0x1
 7ae:	8567b783          	ld	a5,-1962(a5) # 1000 <freep>
 7b2:	a095                	j	816 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 7b4:	ff852583          	lw	a1,-8(a0)
 7b8:	6390                	ld	a2,0(a5)
 7ba:	02059813          	slli	a6,a1,0x20
 7be:	01c85693          	srli	a3,a6,0x1c
 7c2:	96ba                	add	a3,a3,a4
 7c4:	02d60563          	beq	a2,a3,7ee <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7c8:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 7cc:	4790                	lw	a2,8(a5)
 7ce:	02061593          	slli	a1,a2,0x20
 7d2:	01c5d693          	srli	a3,a1,0x1c
 7d6:	96be                	add	a3,a3,a5
 7d8:	02d70263          	beq	a4,a3,7fc <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7dc:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7de:	00001717          	auipc	a4,0x1
 7e2:	82f73123          	sd	a5,-2014(a4) # 1000 <freep>
}
 7e6:	60a2                	ld	ra,8(sp)
 7e8:	6402                	ld	s0,0(sp)
 7ea:	0141                	addi	sp,sp,16
 7ec:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7ee:	4614                	lw	a3,8(a2)
 7f0:	9ead                	addw	a3,a3,a1
 7f2:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f6:	6394                	ld	a3,0(a5)
 7f8:	6290                	ld	a2,0(a3)
 7fa:	b7f9                	j	7c8 <free+0x2a>
    p->s.size += bp->s.size;
 7fc:	ff852703          	lw	a4,-8(a0)
 800:	9f31                	addw	a4,a4,a2
 802:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 804:	ff053703          	ld	a4,-16(a0)
 808:	bfd1                	j	7dc <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 80a:	6394                	ld	a3,0(a5)
 80c:	00d7e463          	bltu	a5,a3,814 <free+0x76>
 810:	fad762e3          	bltu	a4,a3,7b4 <free+0x16>
 814:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 816:	fee7fae3          	bgeu	a5,a4,80a <free+0x6c>
 81a:	6394                	ld	a3,0(a5)
 81c:	f8d76ce3          	bltu	a4,a3,7b4 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 820:	f8d7fae3          	bgeu	a5,a3,7b4 <free+0x16>
 824:	87b6                	mv	a5,a3
 826:	bfc5                	j	816 <free+0x78>

0000000000000828 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 828:	7139                	addi	sp,sp,-64
 82a:	fc06                	sd	ra,56(sp)
 82c:	f822                	sd	s0,48(sp)
 82e:	f04a                	sd	s2,32(sp)
 830:	ec4e                	sd	s3,24(sp)
 832:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 834:	02051993          	slli	s3,a0,0x20
 838:	0209d993          	srli	s3,s3,0x20
 83c:	09bd                	addi	s3,s3,15
 83e:	0049d993          	srli	s3,s3,0x4
 842:	2985                	addiw	s3,s3,1
 844:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 846:	00000517          	auipc	a0,0x0
 84a:	7ba53503          	ld	a0,1978(a0) # 1000 <freep>
 84e:	c905                	beqz	a0,87e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 850:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 852:	4798                	lw	a4,8(a5)
 854:	09377663          	bgeu	a4,s3,8e0 <malloc+0xb8>
 858:	f426                	sd	s1,40(sp)
 85a:	e852                	sd	s4,16(sp)
 85c:	e456                	sd	s5,8(sp)
 85e:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 860:	8a4e                	mv	s4,s3
 862:	6705                	lui	a4,0x1
 864:	00e9f363          	bgeu	s3,a4,86a <malloc+0x42>
 868:	6a05                	lui	s4,0x1
 86a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 86e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 872:	00000497          	auipc	s1,0x0
 876:	78e48493          	addi	s1,s1,1934 # 1000 <freep>
  if (p == SBRK_ERROR)
 87a:	5afd                	li	s5,-1
 87c:	a83d                	j	8ba <malloc+0x92>
 87e:	f426                	sd	s1,40(sp)
 880:	e852                	sd	s4,16(sp)
 882:	e456                	sd	s5,8(sp)
 884:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 886:	00000797          	auipc	a5,0x0
 88a:	78a78793          	addi	a5,a5,1930 # 1010 <base>
 88e:	00000717          	auipc	a4,0x0
 892:	76f73923          	sd	a5,1906(a4) # 1000 <freep>
 896:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 898:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 89c:	b7d1                	j	860 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 89e:	6398                	ld	a4,0(a5)
 8a0:	e118                	sd	a4,0(a0)
 8a2:	a899                	j	8f8 <malloc+0xd0>
  hp->s.size = nu;
 8a4:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8a8:	0541                	addi	a0,a0,16
 8aa:	ef5ff0ef          	jal	79e <free>
  return freep;
 8ae:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8b0:	c125                	beqz	a0,910 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8b2:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8b4:	4798                	lw	a4,8(a5)
 8b6:	03277163          	bgeu	a4,s2,8d8 <malloc+0xb0>
    if (p == freep)
 8ba:	6098                	ld	a4,0(s1)
 8bc:	853e                	mv	a0,a5
 8be:	fef71ae3          	bne	a4,a5,8b2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8c2:	8552                	mv	a0,s4
 8c4:	a0fff0ef          	jal	2d2 <sbrk>
  if (p == SBRK_ERROR)
 8c8:	fd551ee3          	bne	a0,s5,8a4 <malloc+0x7c>
        return 0;
 8cc:	4501                	li	a0,0
 8ce:	74a2                	ld	s1,40(sp)
 8d0:	6a42                	ld	s4,16(sp)
 8d2:	6aa2                	ld	s5,8(sp)
 8d4:	6b02                	ld	s6,0(sp)
 8d6:	a03d                	j	904 <malloc+0xdc>
 8d8:	74a2                	ld	s1,40(sp)
 8da:	6a42                	ld	s4,16(sp)
 8dc:	6aa2                	ld	s5,8(sp)
 8de:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8e0:	fae90fe3          	beq	s2,a4,89e <malloc+0x76>
        p->s.size -= nunits;
 8e4:	4137073b          	subw	a4,a4,s3
 8e8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ea:	02071693          	slli	a3,a4,0x20
 8ee:	01c6d713          	srli	a4,a3,0x1c
 8f2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8f4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8f8:	00000717          	auipc	a4,0x0
 8fc:	70a73423          	sd	a0,1800(a4) # 1000 <freep>
      return (void *)(p + 1);
 900:	01078513          	addi	a0,a5,16
  }
}
 904:	70e2                	ld	ra,56(sp)
 906:	7442                	ld	s0,48(sp)
 908:	7902                	ld	s2,32(sp)
 90a:	69e2                	ld	s3,24(sp)
 90c:	6121                	addi	sp,sp,64
 90e:	8082                	ret
 910:	74a2                	ld	s1,40(sp)
 912:	6a42                	ld	s4,16(sp)
 914:	6aa2                	ld	s5,8(sp)
 916:	6b02                	ld	s6,0(sp)
 918:	b7f5                	j	904 <malloc+0xdc>
