
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
  12:	89aa                	mv	s3,a0
  int n;

  while ((n = read(fd, buf, sizeof(buf))) > 0) {
  14:	20000a13          	li	s4,512
  18:	00001917          	auipc	s2,0x1
  1c:	ff890913          	addi	s2,s2,-8 # 1010 <buf>
    if (write(1, buf, n) != n) {
  20:	4a85                	li	s5,1
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
  22:	8652                	mv	a2,s4
  24:	85ca                	mv	a1,s2
  26:	854e                	mv	a0,s3
  28:	39c000ef          	jal	3c4 <read>
  2c:	84aa                	mv	s1,a0
  2e:	02a05363          	blez	a0,54 <cat+0x54>
    if (write(1, buf, n) != n) {
  32:	8626                	mv	a2,s1
  34:	85ca                	mv	a1,s2
  36:	8556                	mv	a0,s5
  38:	394000ef          	jal	3cc <write>
  3c:	fe9503e3          	beq	a0,s1,22 <cat+0x22>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	98058593          	addi	a1,a1,-1664 # 9c0 <malloc+0xf2>
  48:	4509                	li	a0,2
  4a:	79e000ef          	jal	7e8 <fprintf>
      exit(1);
  4e:	4505                	li	a0,1
  50:	35c000ef          	jal	3ac <exit>
    }
  }
  if (n < 0) {
  54:	00054b63          	bltz	a0,6a <cat+0x6a>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  58:	70e2                	ld	ra,56(sp)
  5a:	7442                	ld	s0,48(sp)
  5c:	74a2                	ld	s1,40(sp)
  5e:	7902                	ld	s2,32(sp)
  60:	69e2                	ld	s3,24(sp)
  62:	6a42                	ld	s4,16(sp)
  64:	6aa2                	ld	s5,8(sp)
  66:	6121                	addi	sp,sp,64
  68:	8082                	ret
    fprintf(2, "cat: read error\n");
  6a:	00001597          	auipc	a1,0x1
  6e:	96e58593          	addi	a1,a1,-1682 # 9d8 <malloc+0x10a>
  72:	4509                	li	a0,2
  74:	774000ef          	jal	7e8 <fprintf>
    exit(1);
  78:	4505                	li	a0,1
  7a:	332000ef          	jal	3ac <exit>

000000000000007e <main>:

int
main(int argc, char *argv[])
{
  7e:	7179                	addi	sp,sp,-48
  80:	f406                	sd	ra,40(sp)
  82:	f022                	sd	s0,32(sp)
  84:	1800                	addi	s0,sp,48
  int fd, i;

  if (argc <= 1) {
  86:	4785                	li	a5,1
  88:	04a7d263          	bge	a5,a0,cc <main+0x4e>
  8c:	ec26                	sd	s1,24(sp)
  8e:	e84a                	sd	s2,16(sp)
  90:	e44e                	sd	s3,8(sp)
  92:	00858913          	addi	s2,a1,8
  96:	ffe5099b          	addiw	s3,a0,-2
  9a:	02099793          	slli	a5,s3,0x20
  9e:	01d7d993          	srli	s3,a5,0x1d
  a2:	05c1                	addi	a1,a1,16
  a4:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for (i = 1; i < argc; i++) {
    if ((fd = open(argv[i], O_RDONLY)) < 0) {
  a6:	4581                	li	a1,0
  a8:	00093503          	ld	a0,0(s2)
  ac:	340000ef          	jal	3ec <open>
  b0:	84aa                	mv	s1,a0
  b2:	02054663          	bltz	a0,de <main+0x60>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  b6:	f4bff0ef          	jal	0 <cat>
    close(fd);
  ba:	8526                	mv	a0,s1
  bc:	318000ef          	jal	3d4 <close>
  for (i = 1; i < argc; i++) {
  c0:	0921                	addi	s2,s2,8
  c2:	ff3912e3          	bne	s2,s3,a6 <main+0x28>
  }
  exit(0);
  c6:	4501                	li	a0,0
  c8:	2e4000ef          	jal	3ac <exit>
  cc:	ec26                	sd	s1,24(sp)
  ce:	e84a                	sd	s2,16(sp)
  d0:	e44e                	sd	s3,8(sp)
    cat(0);
  d2:	4501                	li	a0,0
  d4:	f2dff0ef          	jal	0 <cat>
    exit(0);
  d8:	4501                	li	a0,0
  da:	2d2000ef          	jal	3ac <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  de:	00093603          	ld	a2,0(s2)
  e2:	00001597          	auipc	a1,0x1
  e6:	90e58593          	addi	a1,a1,-1778 # 9f0 <malloc+0x122>
  ea:	4509                	li	a0,2
  ec:	6fc000ef          	jal	7e8 <fprintf>
      exit(1);
  f0:	4505                	li	a0,1
  f2:	2ba000ef          	jal	3ac <exit>

00000000000000f6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  fe:	f81ff0ef          	jal	7e <main>
  exit(r);
 102:	2aa000ef          	jal	3ac <exit>

0000000000000106 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 106:	1141                	addi	sp,sp,-16
 108:	e406                	sd	ra,8(sp)
 10a:	e022                	sd	s0,0(sp)
 10c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 10e:	87aa                	mv	a5,a0
 110:	0585                	addi	a1,a1,1
 112:	0785                	addi	a5,a5,1
 114:	fff5c703          	lbu	a4,-1(a1)
 118:	fee78fa3          	sb	a4,-1(a5)
 11c:	fb75                	bnez	a4,110 <strcpy+0xa>
    ;
  return os;
}
 11e:	60a2                	ld	ra,8(sp)
 120:	6402                	ld	s0,0(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 126:	1141                	addi	sp,sp,-16
 128:	e406                	sd	ra,8(sp)
 12a:	e022                	sd	s0,0(sp)
 12c:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cb91                	beqz	a5,146 <strcmp+0x20>
 134:	0005c703          	lbu	a4,0(a1)
 138:	00f71763          	bne	a4,a5,146 <strcmp+0x20>
    p++, q++;
 13c:	0505                	addi	a0,a0,1
 13e:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 140:	00054783          	lbu	a5,0(a0)
 144:	fbe5                	bnez	a5,134 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 146:	0005c503          	lbu	a0,0(a1)
}
 14a:	40a7853b          	subw	a0,a5,a0
 14e:	60a2                	ld	ra,8(sp)
 150:	6402                	ld	s0,0(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret

0000000000000156 <strlen>:

uint
strlen(const char *s)
{
 156:	1141                	addi	sp,sp,-16
 158:	e406                	sd	ra,8(sp)
 15a:	e022                	sd	s0,0(sp)
 15c:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 15e:	00054783          	lbu	a5,0(a0)
 162:	cf91                	beqz	a5,17e <strlen+0x28>
 164:	00150793          	addi	a5,a0,1
 168:	86be                	mv	a3,a5
 16a:	0785                	addi	a5,a5,1
 16c:	fff7c703          	lbu	a4,-1(a5)
 170:	ff65                	bnez	a4,168 <strlen+0x12>
 172:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 176:	60a2                	ld	ra,8(sp)
 178:	6402                	ld	s0,0(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret
  for (n = 0; s[n]; n++)
 17e:	4501                	li	a0,0
 180:	bfdd                	j	176 <strlen+0x20>

0000000000000182 <memset>:

void *
memset(void *dst, int c, uint n)
{
 182:	1141                	addi	sp,sp,-16
 184:	e406                	sd	ra,8(sp)
 186:	e022                	sd	s0,0(sp)
 188:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 18a:	ca19                	beqz	a2,1a0 <memset+0x1e>
 18c:	87aa                	mv	a5,a0
 18e:	1602                	slli	a2,a2,0x20
 190:	9201                	srli	a2,a2,0x20
 192:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 196:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 19a:	0785                	addi	a5,a5,1
 19c:	fee79de3          	bne	a5,a4,196 <memset+0x14>
  }
  return dst;
}
 1a0:	60a2                	ld	ra,8(sp)
 1a2:	6402                	ld	s0,0(sp)
 1a4:	0141                	addi	sp,sp,16
 1a6:	8082                	ret

00000000000001a8 <strchr>:

char *
strchr(const char *s, char c)
{
 1a8:	1141                	addi	sp,sp,-16
 1aa:	e406                	sd	ra,8(sp)
 1ac:	e022                	sd	s0,0(sp)
 1ae:	0800                	addi	s0,sp,16
  for (; *s; s++)
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	c799                	beqz	a5,1c2 <strchr+0x1a>
    if (*s == c)
 1b6:	00f58763          	beq	a1,a5,1c4 <strchr+0x1c>
  for (; *s; s++)
 1ba:	0505                	addi	a0,a0,1
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	fbfd                	bnez	a5,1b6 <strchr+0xe>
      return (char *)s;
  return 0;
 1c2:	4501                	li	a0,0
}
 1c4:	60a2                	ld	ra,8(sp)
 1c6:	6402                	ld	s0,0(sp)
 1c8:	0141                	addi	sp,sp,16
 1ca:	8082                	ret

00000000000001cc <gets>:

char *
gets(char *buf, int max)
{
 1cc:	711d                	addi	sp,sp,-96
 1ce:	ec86                	sd	ra,88(sp)
 1d0:	e8a2                	sd	s0,80(sp)
 1d2:	e4a6                	sd	s1,72(sp)
 1d4:	e0ca                	sd	s2,64(sp)
 1d6:	fc4e                	sd	s3,56(sp)
 1d8:	f852                	sd	s4,48(sp)
 1da:	f456                	sd	s5,40(sp)
 1dc:	f05a                	sd	s6,32(sp)
 1de:	ec5e                	sd	s7,24(sp)
 1e0:	e862                	sd	s8,16(sp)
 1e2:	1080                	addi	s0,sp,96
 1e4:	8baa                	mv	s7,a0
 1e6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1e8:	892a                	mv	s2,a0
 1ea:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1ec:	faf40b13          	addi	s6,s0,-81
 1f0:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 1f2:	8c26                	mv	s8,s1
 1f4:	0014899b          	addiw	s3,s1,1
 1f8:	84ce                	mv	s1,s3
 1fa:	0349d863          	bge	s3,s4,22a <gets+0x5e>
    cc = read(0, &c, 1);
 1fe:	8656                	mv	a2,s5
 200:	85da                	mv	a1,s6
 202:	4501                	li	a0,0
 204:	1c0000ef          	jal	3c4 <read>
    if (cc < 1)
 208:	02a05163          	blez	a0,22a <gets+0x5e>
      break;
    buf[i++] = c;
 20c:	faf44783          	lbu	a5,-81(s0)
 210:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 214:	0905                	addi	s2,s2,1
 216:	ff678713          	addi	a4,a5,-10
 21a:	00173713          	seqz	a4,a4
 21e:	17cd                	addi	a5,a5,-13
 220:	0017b793          	seqz	a5,a5
 224:	8fd9                	or	a5,a5,a4
 226:	d7f1                	beqz	a5,1f2 <gets+0x26>
    buf[i++] = c;
 228:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 22a:	9c5e                	add	s8,s8,s7
 22c:	000c0023          	sb	zero,0(s8)
  return buf;
}
 230:	855e                	mv	a0,s7
 232:	60e6                	ld	ra,88(sp)
 234:	6446                	ld	s0,80(sp)
 236:	64a6                	ld	s1,72(sp)
 238:	6906                	ld	s2,64(sp)
 23a:	79e2                	ld	s3,56(sp)
 23c:	7a42                	ld	s4,48(sp)
 23e:	7aa2                	ld	s5,40(sp)
 240:	7b02                	ld	s6,32(sp)
 242:	6be2                	ld	s7,24(sp)
 244:	6c42                	ld	s8,16(sp)
 246:	6125                	addi	sp,sp,96
 248:	8082                	ret

000000000000024a <stat>:

int
stat(const char *n, struct stat *st)
{
 24a:	1101                	addi	sp,sp,-32
 24c:	ec06                	sd	ra,24(sp)
 24e:	e822                	sd	s0,16(sp)
 250:	e04a                	sd	s2,0(sp)
 252:	1000                	addi	s0,sp,32
 254:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 256:	4581                	li	a1,0
 258:	194000ef          	jal	3ec <open>
  if (fd < 0)
 25c:	02054263          	bltz	a0,280 <stat+0x36>
 260:	e426                	sd	s1,8(sp)
 262:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 264:	85ca                	mv	a1,s2
 266:	19e000ef          	jal	404 <fstat>
 26a:	892a                	mv	s2,a0
  close(fd);
 26c:	8526                	mv	a0,s1
 26e:	166000ef          	jal	3d4 <close>
  return r;
 272:	64a2                	ld	s1,8(sp)
}
 274:	854a                	mv	a0,s2
 276:	60e2                	ld	ra,24(sp)
 278:	6442                	ld	s0,16(sp)
 27a:	6902                	ld	s2,0(sp)
 27c:	6105                	addi	sp,sp,32
 27e:	8082                	ret
    return -1;
 280:	57fd                	li	a5,-1
 282:	893e                	mv	s2,a5
 284:	bfc5                	j	274 <stat+0x2a>

0000000000000286 <atoi>:

int
atoi(const char *s)
{
 286:	1141                	addi	sp,sp,-16
 288:	e406                	sd	ra,8(sp)
 28a:	e022                	sd	s0,0(sp)
 28c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 28e:	00054683          	lbu	a3,0(a0)
 292:	fd06879b          	addiw	a5,a3,-48
 296:	0ff7f793          	zext.b	a5,a5
 29a:	4625                	li	a2,9
 29c:	02f66963          	bltu	a2,a5,2ce <atoi+0x48>
 2a0:	872a                	mv	a4,a0
  n = 0;
 2a2:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 2a4:	0705                	addi	a4,a4,1
 2a6:	0025179b          	slliw	a5,a0,0x2
 2aa:	9fa9                	addw	a5,a5,a0
 2ac:	0017979b          	slliw	a5,a5,0x1
 2b0:	9fb5                	addw	a5,a5,a3
 2b2:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 2b6:	00074683          	lbu	a3,0(a4)
 2ba:	fd06879b          	addiw	a5,a3,-48
 2be:	0ff7f793          	zext.b	a5,a5
 2c2:	fef671e3          	bgeu	a2,a5,2a4 <atoi+0x1e>
  return n;
}
 2c6:	60a2                	ld	ra,8(sp)
 2c8:	6402                	ld	s0,0(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret
  n = 0;
 2ce:	4501                	li	a0,0
 2d0:	bfdd                	j	2c6 <atoi+0x40>

00000000000002d2 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e406                	sd	ra,8(sp)
 2d6:	e022                	sd	s0,0(sp)
 2d8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2da:	02b57563          	bgeu	a0,a1,304 <memmove+0x32>
    while (n-- > 0)
 2de:	00c05f63          	blez	a2,2fc <memmove+0x2a>
 2e2:	1602                	slli	a2,a2,0x20
 2e4:	9201                	srli	a2,a2,0x20
 2e6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ea:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ec:	0585                	addi	a1,a1,1
 2ee:	0705                	addi	a4,a4,1
 2f0:	fff5c683          	lbu	a3,-1(a1)
 2f4:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2f8:	fee79ae3          	bne	a5,a4,2ec <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2fc:	60a2                	ld	ra,8(sp)
 2fe:	6402                	ld	s0,0(sp)
 300:	0141                	addi	sp,sp,16
 302:	8082                	ret
    while (n-- > 0)
 304:	fec05ce3          	blez	a2,2fc <memmove+0x2a>
    dst += n;
 308:	00c50733          	add	a4,a0,a2
    src += n;
 30c:	95b2                	add	a1,a1,a2
 30e:	fff6079b          	addiw	a5,a2,-1
 312:	1782                	slli	a5,a5,0x20
 314:	9381                	srli	a5,a5,0x20
 316:	fff7c793          	not	a5,a5
 31a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 31c:	15fd                	addi	a1,a1,-1
 31e:	177d                	addi	a4,a4,-1
 320:	0005c683          	lbu	a3,0(a1)
 324:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 328:	fef71ae3          	bne	a4,a5,31c <memmove+0x4a>
 32c:	bfc1                	j	2fc <memmove+0x2a>

000000000000032e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 32e:	1141                	addi	sp,sp,-16
 330:	e406                	sd	ra,8(sp)
 332:	e022                	sd	s0,0(sp)
 334:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 336:	ce19                	beqz	a2,354 <memcmp+0x26>
 338:	1602                	slli	a2,a2,0x20
 33a:	9201                	srli	a2,a2,0x20
 33c:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 340:	00054783          	lbu	a5,0(a0)
 344:	0005c703          	lbu	a4,0(a1)
 348:	00e79b63          	bne	a5,a4,35e <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 34c:	0505                	addi	a0,a0,1
    p2++;
 34e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 350:	fed518e3          	bne	a0,a3,340 <memcmp+0x12>
  }
  return 0;
 354:	4501                	li	a0,0
}
 356:	60a2                	ld	ra,8(sp)
 358:	6402                	ld	s0,0(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret
      return *p1 - *p2;
 35e:	40e7853b          	subw	a0,a5,a4
 362:	bfd5                	j	356 <memcmp+0x28>

0000000000000364 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 364:	1141                	addi	sp,sp,-16
 366:	e406                	sd	ra,8(sp)
 368:	e022                	sd	s0,0(sp)
 36a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 36c:	f67ff0ef          	jal	2d2 <memmove>
}
 370:	60a2                	ld	ra,8(sp)
 372:	6402                	ld	s0,0(sp)
 374:	0141                	addi	sp,sp,16
 376:	8082                	ret

0000000000000378 <sbrk>:

char *
sbrk(int n)
{
 378:	1141                	addi	sp,sp,-16
 37a:	e406                	sd	ra,8(sp)
 37c:	e022                	sd	s0,0(sp)
 37e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 380:	4585                	li	a1,1
 382:	0b2000ef          	jal	434 <sys_sbrk>
}
 386:	60a2                	ld	ra,8(sp)
 388:	6402                	ld	s0,0(sp)
 38a:	0141                	addi	sp,sp,16
 38c:	8082                	ret

000000000000038e <sbrklazy>:

char *
sbrklazy(int n)
{
 38e:	1141                	addi	sp,sp,-16
 390:	e406                	sd	ra,8(sp)
 392:	e022                	sd	s0,0(sp)
 394:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 396:	4589                	li	a1,2
 398:	09c000ef          	jal	434 <sys_sbrk>
}
 39c:	60a2                	ld	ra,8(sp)
 39e:	6402                	ld	s0,0(sp)
 3a0:	0141                	addi	sp,sp,16
 3a2:	8082                	ret

00000000000003a4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a4:	4885                	li	a7,1
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ac:	4889                	li	a7,2
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b4:	488d                	li	a7,3
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3bc:	4891                	li	a7,4
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <read>:
.global read
read:
 li a7, SYS_read
 3c4:	4895                	li	a7,5
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <write>:
.global write
write:
 li a7, SYS_write
 3cc:	48c1                	li	a7,16
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <close>:
.global close
close:
 li a7, SYS_close
 3d4:	48d5                	li	a7,21
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <kill>:
.global kill
kill:
 li a7, SYS_kill
 3dc:	4899                	li	a7,6
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e4:	489d                	li	a7,7
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <open>:
.global open
open:
 li a7, SYS_open
 3ec:	48bd                	li	a7,15
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f4:	48c5                	li	a7,17
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3fc:	48c9                	li	a7,18
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 404:	48a1                	li	a7,8
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <link>:
.global link
link:
 li a7, SYS_link
 40c:	48cd                	li	a7,19
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 414:	48d1                	li	a7,20
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 41c:	48a5                	li	a7,9
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <dup>:
.global dup
dup:
 li a7, SYS_dup
 424:	48a9                	li	a7,10
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 42c:	48ad                	li	a7,11
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 434:	48b1                	li	a7,12
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <pause>:
.global pause
pause:
 li a7, SYS_pause
 43c:	48b5                	li	a7,13
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 444:	48b9                	li	a7,14
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <sync>:
.global sync
sync:
 li a7, SYS_sync
 44c:	48d9                	li	a7,22
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 454:	48dd                	li	a7,23
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 45c:	1101                	addi	sp,sp,-32
 45e:	ec06                	sd	ra,24(sp)
 460:	e822                	sd	s0,16(sp)
 462:	1000                	addi	s0,sp,32
 464:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 468:	4605                	li	a2,1
 46a:	fef40593          	addi	a1,s0,-17
 46e:	f5fff0ef          	jal	3cc <write>
}
 472:	60e2                	ld	ra,24(sp)
 474:	6442                	ld	s0,16(sp)
 476:	6105                	addi	sp,sp,32
 478:	8082                	ret

000000000000047a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 47a:	715d                	addi	sp,sp,-80
 47c:	e486                	sd	ra,72(sp)
 47e:	e0a2                	sd	s0,64(sp)
 480:	f84a                	sd	s2,48(sp)
 482:	f44e                	sd	s3,40(sp)
 484:	0880                	addi	s0,sp,80
 486:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 488:	00d036b3          	snez	a3,a3
 48c:	03f5d793          	srli	a5,a1,0x3f
 490:	8efd                	and	a3,a3,a5
  neg = 0;
 492:	4301                	li	t1,0
  if (sgn && xx < 0) {
 494:	c681                	beqz	a3,49c <printint+0x22>
    neg = 1;
    x = -xx;
 496:	40b005b3          	neg	a1,a1
    neg = 1;
 49a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 49c:	fb840993          	addi	s3,s0,-72
  neg = 0;
 4a0:	86ce                	mv	a3,s3
  i = 0;
 4a2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 4a4:	00000817          	auipc	a6,0x0
 4a8:	56c80813          	addi	a6,a6,1388 # a10 <digits>
 4ac:	88ba                	mv	a7,a4
 4ae:	0017051b          	addiw	a0,a4,1
 4b2:	872a                	mv	a4,a0
 4b4:	02c5f7b3          	remu	a5,a1,a2
 4b8:	97c2                	add	a5,a5,a6
 4ba:	0007c783          	lbu	a5,0(a5)
 4be:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 4c2:	87ae                	mv	a5,a1
 4c4:	02c5d5b3          	divu	a1,a1,a2
 4c8:	0685                	addi	a3,a3,1
 4ca:	fec7f1e3          	bgeu	a5,a2,4ac <printint+0x32>
  if (neg)
 4ce:	00030b63          	beqz	t1,4e4 <printint+0x6a>
    buf[i++] = '-';
 4d2:	fd040793          	addi	a5,s0,-48
 4d6:	953e                	add	a0,a0,a5
 4d8:	02d00793          	li	a5,45
 4dc:	fef50423          	sb	a5,-24(a0)
 4e0:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 4e4:	02e05563          	blez	a4,50e <printint+0x94>
 4e8:	fc26                	sd	s1,56(sp)
 4ea:	377d                	addiw	a4,a4,-1
 4ec:	00e984b3          	add	s1,s3,a4
 4f0:	19fd                	addi	s3,s3,-1
 4f2:	99ba                	add	s3,s3,a4
 4f4:	1702                	slli	a4,a4,0x20
 4f6:	9301                	srli	a4,a4,0x20
 4f8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4fc:	0004c583          	lbu	a1,0(s1)
 500:	854a                	mv	a0,s2
 502:	f5bff0ef          	jal	45c <putc>
  while (--i >= 0)
 506:	14fd                	addi	s1,s1,-1
 508:	ff349ae3          	bne	s1,s3,4fc <printint+0x82>
 50c:	74e2                	ld	s1,56(sp)
}
 50e:	60a6                	ld	ra,72(sp)
 510:	6406                	ld	s0,64(sp)
 512:	7942                	ld	s2,48(sp)
 514:	79a2                	ld	s3,40(sp)
 516:	6161                	addi	sp,sp,80
 518:	8082                	ret

000000000000051a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 51a:	711d                	addi	sp,sp,-96
 51c:	ec86                	sd	ra,88(sp)
 51e:	e8a2                	sd	s0,80(sp)
 520:	e4a6                	sd	s1,72(sp)
 522:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 524:	0005c483          	lbu	s1,0(a1)
 528:	2a048063          	beqz	s1,7c8 <vprintf+0x2ae>
 52c:	e0ca                	sd	s2,64(sp)
 52e:	fc4e                	sd	s3,56(sp)
 530:	f852                	sd	s4,48(sp)
 532:	f456                	sd	s5,40(sp)
 534:	f05a                	sd	s6,32(sp)
 536:	ec5e                	sd	s7,24(sp)
 538:	e862                	sd	s8,16(sp)
 53a:	8b2a                	mv	s6,a0
 53c:	8a2e                	mv	s4,a1
 53e:	8bb2                	mv	s7,a2
  state = 0;
 540:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 542:	4901                	li	s2,0
 544:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 546:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 54a:	06400c13          	li	s8,100
 54e:	a00d                	j	570 <vprintf+0x56>
        putc(fd, c0);
 550:	85a6                	mv	a1,s1
 552:	855a                	mv	a0,s6
 554:	f09ff0ef          	jal	45c <putc>
 558:	a019                	j	55e <vprintf+0x44>
    } else if (state == '%') {
 55a:	03598363          	beq	s3,s5,580 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 55e:	0019079b          	addiw	a5,s2,1
 562:	893e                	mv	s2,a5
 564:	873e                	mv	a4,a5
 566:	97d2                	add	a5,a5,s4
 568:	0007c483          	lbu	s1,0(a5)
 56c:	24048763          	beqz	s1,7ba <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 570:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 574:	fe0993e3          	bnez	s3,55a <vprintf+0x40>
      if (c0 == '%') {
 578:	fd579ce3          	bne	a5,s5,550 <vprintf+0x36>
        state = '%';
 57c:	89be                	mv	s3,a5
 57e:	b7c5                	j	55e <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 580:	00ea06b3          	add	a3,s4,a4
 584:	0016c603          	lbu	a2,1(a3)
      if (c1)
 588:	24060563          	beqz	a2,7d2 <vprintf+0x2b8>
      if (c0 == 'd') {
 58c:	0b878763          	beq	a5,s8,63a <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 590:	f9478693          	addi	a3,a5,-108
 594:	0016b693          	seqz	a3,a3
 598:	f9c60593          	addi	a1,a2,-100
 59c:	0015b593          	seqz	a1,a1
 5a0:	8df5                	and	a1,a1,a3
 5a2:	e9c5                	bnez	a1,652 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 5a4:	9752                	add	a4,a4,s4
 5a6:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5aa:	f9460713          	addi	a4,a2,-108
 5ae:	00173713          	seqz	a4,a4
 5b2:	8f75                	and	a4,a4,a3
 5b4:	f9c50593          	addi	a1,a0,-100
 5b8:	0015b593          	seqz	a1,a1
 5bc:	8df9                	and	a1,a1,a4
 5be:	e5dd                	bnez	a1,66c <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 5c0:	07500593          	li	a1,117
 5c4:	0cb78163          	beq	a5,a1,686 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 5c8:	f8b60593          	addi	a1,a2,-117
 5cc:	0015b593          	seqz	a1,a1
 5d0:	8df5                	and	a1,a1,a3
 5d2:	e5f1                	bnez	a1,69e <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 5d4:	f8b50593          	addi	a1,a0,-117
 5d8:	0015b593          	seqz	a1,a1
 5dc:	8df9                	and	a1,a1,a4
 5de:	ede9                	bnez	a1,6b8 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 5e0:	07800593          	li	a1,120
 5e4:	0eb78763          	beq	a5,a1,6d2 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 5e8:	f8860613          	addi	a2,a2,-120
 5ec:	00163613          	seqz	a2,a2
 5f0:	8ef1                	and	a3,a3,a2
 5f2:	0e069c63          	bnez	a3,6ea <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 5f6:	f8850513          	addi	a0,a0,-120
 5fa:	00153513          	seqz	a0,a0
 5fe:	8f69                	and	a4,a4,a0
 600:	10071263          	bnez	a4,704 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 604:	07000713          	li	a4,112
 608:	10e78a63          	beq	a5,a4,71c <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 60c:	06300713          	li	a4,99
 610:	14e78a63          	beq	a5,a4,764 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 614:	07300713          	li	a4,115
 618:	16e78063          	beq	a5,a4,778 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 61c:	02500713          	li	a4,37
 620:	18e78863          	beq	a5,a4,7b0 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 624:	02500593          	li	a1,37
 628:	855a                	mv	a0,s6
 62a:	e33ff0ef          	jal	45c <putc>
        putc(fd, c0);
 62e:	85a6                	mv	a1,s1
 630:	855a                	mv	a0,s6
 632:	e2bff0ef          	jal	45c <putc>
      }

      state = 0;
 636:	4981                	li	s3,0
 638:	b71d                	j	55e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 63a:	008b8493          	addi	s1,s7,8
 63e:	4685                	li	a3,1
 640:	4629                	li	a2,10
 642:	000ba583          	lw	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	e33ff0ef          	jal	47a <printint>
 64c:	8ba6                	mv	s7,s1
      state = 0;
 64e:	4981                	li	s3,0
 650:	b739                	j	55e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 652:	008b8493          	addi	s1,s7,8
 656:	4685                	li	a3,1
 658:	4629                	li	a2,10
 65a:	000bb583          	ld	a1,0(s7)
 65e:	855a                	mv	a0,s6
 660:	e1bff0ef          	jal	47a <printint>
        i += 1;
 664:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 666:	8ba6                	mv	s7,s1
      state = 0;
 668:	4981                	li	s3,0
 66a:	bdd5                	j	55e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 66c:	008b8493          	addi	s1,s7,8
 670:	4685                	li	a3,1
 672:	4629                	li	a2,10
 674:	000bb583          	ld	a1,0(s7)
 678:	855a                	mv	a0,s6
 67a:	e01ff0ef          	jal	47a <printint>
        i += 2;
 67e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 680:	8ba6                	mv	s7,s1
      state = 0;
 682:	4981                	li	s3,0
        i += 2;
 684:	bde9                	j	55e <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 686:	008b8493          	addi	s1,s7,8
 68a:	4681                	li	a3,0
 68c:	4629                	li	a2,10
 68e:	000be583          	lwu	a1,0(s7)
 692:	855a                	mv	a0,s6
 694:	de7ff0ef          	jal	47a <printint>
 698:	8ba6                	mv	s7,s1
      state = 0;
 69a:	4981                	li	s3,0
 69c:	b5c9                	j	55e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 69e:	008b8493          	addi	s1,s7,8
 6a2:	4681                	li	a3,0
 6a4:	4629                	li	a2,10
 6a6:	000bb583          	ld	a1,0(s7)
 6aa:	855a                	mv	a0,s6
 6ac:	dcfff0ef          	jal	47a <printint>
        i += 1;
 6b0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b2:	8ba6                	mv	s7,s1
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	b565                	j	55e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b8:	008b8493          	addi	s1,s7,8
 6bc:	4681                	li	a3,0
 6be:	4629                	li	a2,10
 6c0:	000bb583          	ld	a1,0(s7)
 6c4:	855a                	mv	a0,s6
 6c6:	db5ff0ef          	jal	47a <printint>
        i += 2;
 6ca:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6cc:	8ba6                	mv	s7,s1
      state = 0;
 6ce:	4981                	li	s3,0
        i += 2;
 6d0:	b579                	j	55e <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6d2:	008b8493          	addi	s1,s7,8
 6d6:	4681                	li	a3,0
 6d8:	4641                	li	a2,16
 6da:	000be583          	lwu	a1,0(s7)
 6de:	855a                	mv	a0,s6
 6e0:	d9bff0ef          	jal	47a <printint>
 6e4:	8ba6                	mv	s7,s1
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	bd9d                	j	55e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ea:	008b8493          	addi	s1,s7,8
 6ee:	4681                	li	a3,0
 6f0:	4641                	li	a2,16
 6f2:	000bb583          	ld	a1,0(s7)
 6f6:	855a                	mv	a0,s6
 6f8:	d83ff0ef          	jal	47a <printint>
        i += 1;
 6fc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fe:	8ba6                	mv	s7,s1
      state = 0;
 700:	4981                	li	s3,0
 702:	bdb1                	j	55e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 704:	008b8493          	addi	s1,s7,8
 708:	4641                	li	a2,16
 70a:	000bb583          	ld	a1,0(s7)
 70e:	855a                	mv	a0,s6
 710:	d6bff0ef          	jal	47a <printint>
        i += 2;
 714:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 716:	8ba6                	mv	s7,s1
      state = 0;
 718:	4981                	li	s3,0
        i += 2;
 71a:	b591                	j	55e <vprintf+0x44>
 71c:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 71e:	008b8793          	addi	a5,s7,8
 722:	8cbe                	mv	s9,a5
 724:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 728:	03000593          	li	a1,48
 72c:	855a                	mv	a0,s6
 72e:	d2fff0ef          	jal	45c <putc>
  putc(fd, 'x');
 732:	07800593          	li	a1,120
 736:	855a                	mv	a0,s6
 738:	d25ff0ef          	jal	45c <putc>
 73c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 73e:	00000b97          	auipc	s7,0x0
 742:	2d2b8b93          	addi	s7,s7,722 # a10 <digits>
 746:	03c9d793          	srli	a5,s3,0x3c
 74a:	97de                	add	a5,a5,s7
 74c:	0007c583          	lbu	a1,0(a5)
 750:	855a                	mv	a0,s6
 752:	d0bff0ef          	jal	45c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 756:	0992                	slli	s3,s3,0x4
 758:	34fd                	addiw	s1,s1,-1
 75a:	f4f5                	bnez	s1,746 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 75c:	8be6                	mv	s7,s9
      state = 0;
 75e:	4981                	li	s3,0
 760:	6ca2                	ld	s9,8(sp)
 762:	bbf5                	j	55e <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 764:	008b8493          	addi	s1,s7,8
 768:	000bc583          	lbu	a1,0(s7)
 76c:	855a                	mv	a0,s6
 76e:	cefff0ef          	jal	45c <putc>
 772:	8ba6                	mv	s7,s1
      state = 0;
 774:	4981                	li	s3,0
 776:	b3e5                	j	55e <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 778:	008b8993          	addi	s3,s7,8
 77c:	000bb483          	ld	s1,0(s7)
 780:	cc91                	beqz	s1,79c <vprintf+0x282>
        for (; *s; s++)
 782:	0004c583          	lbu	a1,0(s1)
 786:	c195                	beqz	a1,7aa <vprintf+0x290>
          putc(fd, *s);
 788:	855a                	mv	a0,s6
 78a:	cd3ff0ef          	jal	45c <putc>
        for (; *s; s++)
 78e:	0485                	addi	s1,s1,1
 790:	0004c583          	lbu	a1,0(s1)
 794:	f9f5                	bnez	a1,788 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 796:	8bce                	mv	s7,s3
      state = 0;
 798:	4981                	li	s3,0
 79a:	b3d1                	j	55e <vprintf+0x44>
          s = "(null)";
 79c:	00000497          	auipc	s1,0x0
 7a0:	26c48493          	addi	s1,s1,620 # a08 <malloc+0x13a>
        for (; *s; s++)
 7a4:	02800593          	li	a1,40
 7a8:	b7c5                	j	788 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 7aa:	8bce                	mv	s7,s3
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	bb45                	j	55e <vprintf+0x44>
        putc(fd, '%');
 7b0:	85be                	mv	a1,a5
 7b2:	855a                	mv	a0,s6
 7b4:	ca9ff0ef          	jal	45c <putc>
 7b8:	bdbd                	j	636 <vprintf+0x11c>
 7ba:	6906                	ld	s2,64(sp)
 7bc:	79e2                	ld	s3,56(sp)
 7be:	7a42                	ld	s4,48(sp)
 7c0:	7aa2                	ld	s5,40(sp)
 7c2:	7b02                	ld	s6,32(sp)
 7c4:	6be2                	ld	s7,24(sp)
 7c6:	6c42                	ld	s8,16(sp)
    }
  }
}
 7c8:	60e6                	ld	ra,88(sp)
 7ca:	6446                	ld	s0,80(sp)
 7cc:	64a6                	ld	s1,72(sp)
 7ce:	6125                	addi	sp,sp,96
 7d0:	8082                	ret
      if (c0 == 'd') {
 7d2:	06400713          	li	a4,100
 7d6:	e6e782e3          	beq	a5,a4,63a <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 7da:	f9478693          	addi	a3,a5,-108
 7de:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7e2:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 7e4:	4701                	li	a4,0
 7e6:	bbe9                	j	5c0 <vprintf+0xa6>

00000000000007e8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7e8:	715d                	addi	sp,sp,-80
 7ea:	ec06                	sd	ra,24(sp)
 7ec:	e822                	sd	s0,16(sp)
 7ee:	1000                	addi	s0,sp,32
 7f0:	e010                	sd	a2,0(s0)
 7f2:	e414                	sd	a3,8(s0)
 7f4:	e818                	sd	a4,16(s0)
 7f6:	ec1c                	sd	a5,24(s0)
 7f8:	03043023          	sd	a6,32(s0)
 7fc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 800:	8622                	mv	a2,s0
 802:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 806:	d15ff0ef          	jal	51a <vprintf>
}
 80a:	60e2                	ld	ra,24(sp)
 80c:	6442                	ld	s0,16(sp)
 80e:	6161                	addi	sp,sp,80
 810:	8082                	ret

0000000000000812 <printf>:

void
printf(const char *fmt, ...)
{
 812:	711d                	addi	sp,sp,-96
 814:	ec06                	sd	ra,24(sp)
 816:	e822                	sd	s0,16(sp)
 818:	1000                	addi	s0,sp,32
 81a:	e40c                	sd	a1,8(s0)
 81c:	e810                	sd	a2,16(s0)
 81e:	ec14                	sd	a3,24(s0)
 820:	f018                	sd	a4,32(s0)
 822:	f41c                	sd	a5,40(s0)
 824:	03043823          	sd	a6,48(s0)
 828:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 82c:	00840613          	addi	a2,s0,8
 830:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 834:	85aa                	mv	a1,a0
 836:	4505                	li	a0,1
 838:	ce3ff0ef          	jal	51a <vprintf>
}
 83c:	60e2                	ld	ra,24(sp)
 83e:	6442                	ld	s0,16(sp)
 840:	6125                	addi	sp,sp,96
 842:	8082                	ret

0000000000000844 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 844:	1141                	addi	sp,sp,-16
 846:	e406                	sd	ra,8(sp)
 848:	e022                	sd	s0,0(sp)
 84a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 84c:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 850:	00000797          	auipc	a5,0x0
 854:	7b07b783          	ld	a5,1968(a5) # 1000 <freep>
 858:	a095                	j	8bc <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 85a:	ff852583          	lw	a1,-8(a0)
 85e:	6390                	ld	a2,0(a5)
 860:	02059813          	slli	a6,a1,0x20
 864:	01c85693          	srli	a3,a6,0x1c
 868:	96ba                	add	a3,a3,a4
 86a:	02d60563          	beq	a2,a3,894 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 86e:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 872:	4790                	lw	a2,8(a5)
 874:	02061593          	slli	a1,a2,0x20
 878:	01c5d693          	srli	a3,a1,0x1c
 87c:	96be                	add	a3,a3,a5
 87e:	02d70263          	beq	a4,a3,8a2 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 882:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 884:	00000717          	auipc	a4,0x0
 888:	76f73e23          	sd	a5,1916(a4) # 1000 <freep>
}
 88c:	60a2                	ld	ra,8(sp)
 88e:	6402                	ld	s0,0(sp)
 890:	0141                	addi	sp,sp,16
 892:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 894:	4614                	lw	a3,8(a2)
 896:	9ead                	addw	a3,a3,a1
 898:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 89c:	6394                	ld	a3,0(a5)
 89e:	6290                	ld	a2,0(a3)
 8a0:	b7f9                	j	86e <free+0x2a>
    p->s.size += bp->s.size;
 8a2:	ff852703          	lw	a4,-8(a0)
 8a6:	9f31                	addw	a4,a4,a2
 8a8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8aa:	ff053703          	ld	a4,-16(a0)
 8ae:	bfd1                	j	882 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b0:	6394                	ld	a3,0(a5)
 8b2:	00d7e463          	bltu	a5,a3,8ba <free+0x76>
 8b6:	fad762e3          	bltu	a4,a3,85a <free+0x16>
 8ba:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8bc:	fee7fae3          	bgeu	a5,a4,8b0 <free+0x6c>
 8c0:	6394                	ld	a3,0(a5)
 8c2:	f8d76ce3          	bltu	a4,a3,85a <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c6:	f8d7fae3          	bgeu	a5,a3,85a <free+0x16>
 8ca:	87b6                	mv	a5,a3
 8cc:	bfc5                	j	8bc <free+0x78>

00000000000008ce <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 8ce:	7139                	addi	sp,sp,-64
 8d0:	fc06                	sd	ra,56(sp)
 8d2:	f822                	sd	s0,48(sp)
 8d4:	f04a                	sd	s2,32(sp)
 8d6:	ec4e                	sd	s3,24(sp)
 8d8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8da:	02051993          	slli	s3,a0,0x20
 8de:	0209d993          	srli	s3,s3,0x20
 8e2:	09bd                	addi	s3,s3,15
 8e4:	0049d993          	srli	s3,s3,0x4
 8e8:	2985                	addiw	s3,s3,1
 8ea:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 8ec:	00000517          	auipc	a0,0x0
 8f0:	71453503          	ld	a0,1812(a0) # 1000 <freep>
 8f4:	c905                	beqz	a0,924 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8f6:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8f8:	4798                	lw	a4,8(a5)
 8fa:	09377663          	bgeu	a4,s3,986 <malloc+0xb8>
 8fe:	f426                	sd	s1,40(sp)
 900:	e852                	sd	s4,16(sp)
 902:	e456                	sd	s5,8(sp)
 904:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 906:	8a4e                	mv	s4,s3
 908:	6705                	lui	a4,0x1
 90a:	00e9f363          	bgeu	s3,a4,910 <malloc+0x42>
 90e:	6a05                	lui	s4,0x1
 910:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 914:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 918:	00000497          	auipc	s1,0x0
 91c:	6e848493          	addi	s1,s1,1768 # 1000 <freep>
  if (p == SBRK_ERROR)
 920:	5afd                	li	s5,-1
 922:	a83d                	j	960 <malloc+0x92>
 924:	f426                	sd	s1,40(sp)
 926:	e852                	sd	s4,16(sp)
 928:	e456                	sd	s5,8(sp)
 92a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 92c:	00001797          	auipc	a5,0x1
 930:	8e478793          	addi	a5,a5,-1820 # 1210 <base>
 934:	00000717          	auipc	a4,0x0
 938:	6cf73623          	sd	a5,1740(a4) # 1000 <freep>
 93c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 93e:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 942:	b7d1                	j	906 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 944:	6398                	ld	a4,0(a5)
 946:	e118                	sd	a4,0(a0)
 948:	a899                	j	99e <malloc+0xd0>
  hp->s.size = nu;
 94a:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 94e:	0541                	addi	a0,a0,16
 950:	ef5ff0ef          	jal	844 <free>
  return freep;
 954:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 956:	c125                	beqz	a0,9b6 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 958:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 95a:	4798                	lw	a4,8(a5)
 95c:	03277163          	bgeu	a4,s2,97e <malloc+0xb0>
    if (p == freep)
 960:	6098                	ld	a4,0(s1)
 962:	853e                	mv	a0,a5
 964:	fef71ae3          	bne	a4,a5,958 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 968:	8552                	mv	a0,s4
 96a:	a0fff0ef          	jal	378 <sbrk>
  if (p == SBRK_ERROR)
 96e:	fd551ee3          	bne	a0,s5,94a <malloc+0x7c>
        return 0;
 972:	4501                	li	a0,0
 974:	74a2                	ld	s1,40(sp)
 976:	6a42                	ld	s4,16(sp)
 978:	6aa2                	ld	s5,8(sp)
 97a:	6b02                	ld	s6,0(sp)
 97c:	a03d                	j	9aa <malloc+0xdc>
 97e:	74a2                	ld	s1,40(sp)
 980:	6a42                	ld	s4,16(sp)
 982:	6aa2                	ld	s5,8(sp)
 984:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 986:	fae90fe3          	beq	s2,a4,944 <malloc+0x76>
        p->s.size -= nunits;
 98a:	4137073b          	subw	a4,a4,s3
 98e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 990:	02071693          	slli	a3,a4,0x20
 994:	01c6d713          	srli	a4,a3,0x1c
 998:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 99a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 99e:	00000717          	auipc	a4,0x0
 9a2:	66a73123          	sd	a0,1634(a4) # 1000 <freep>
      return (void *)(p + 1);
 9a6:	01078513          	addi	a0,a5,16
  }
}
 9aa:	70e2                	ld	ra,56(sp)
 9ac:	7442                	ld	s0,48(sp)
 9ae:	7902                	ld	s2,32(sp)
 9b0:	69e2                	ld	s3,24(sp)
 9b2:	6121                	addi	sp,sp,64
 9b4:	8082                	ret
 9b6:	74a2                	ld	s1,40(sp)
 9b8:	6a42                	ld	s4,16(sp)
 9ba:	6aa2                	ld	s5,8(sp)
 9bc:	6b02                	ld	s6,0(sp)
 9be:	b7f5                	j	9aa <malloc+0xdc>
