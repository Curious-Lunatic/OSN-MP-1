
user/_forphan:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char buf[BUFSZ];

int
main(int argc, char **argv)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64
  int fd = 0;
  char *s = argv[0];
   a:	6184                	ld	s1,0(a1)
  struct stat st;
  char *ff = "file0";

  if ((fd = open(ff, O_CREATE | O_WRONLY)) < 0) {
   c:	20100593          	li	a1,513
  10:	00001517          	auipc	a0,0x1
  14:	98050513          	addi	a0,a0,-1664 # 990 <malloc+0xf2>
  18:	3a4000ef          	jal	3bc <open>
  1c:	04054463          	bltz	a0,64 <main+0x64>
    printf("%s: open failed\n", s);
    exit(1);
  }
  if (fstat(fd, &st) < 0) {
  20:	fc840593          	addi	a1,s0,-56
  24:	3b0000ef          	jal	3d4 <fstat>
  28:	04054863          	bltz	a0,78 <main+0x78>
    fprintf(2, "%s: cannot stat %s\n", s, "ff");
    exit(1);
  }
  if (unlink(ff) < 0) {
  2c:	00001517          	auipc	a0,0x1
  30:	96450513          	addi	a0,a0,-1692 # 990 <malloc+0xf2>
  34:	398000ef          	jal	3cc <unlink>
  38:	04054f63          	bltz	a0,96 <main+0x96>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  if (open(ff, O_RDONLY) != -1) {
  3c:	4581                	li	a1,0
  3e:	00001517          	auipc	a0,0x1
  42:	95250513          	addi	a0,a0,-1710 # 990 <malloc+0xf2>
  46:	376000ef          	jal	3bc <open>
  4a:	57fd                	li	a5,-1
  4c:	04f50f63          	beq	a0,a5,aa <main+0xaa>
    printf("%s: open successed\n", s);
  50:	85a6                	mv	a1,s1
  52:	00001517          	auipc	a0,0x1
  56:	99e50513          	addi	a0,a0,-1634 # 9f0 <malloc+0x152>
  5a:	788000ef          	jal	7e2 <printf>
    exit(1);
  5e:	4505                	li	a0,1
  60:	31c000ef          	jal	37c <exit>
    printf("%s: open failed\n", s);
  64:	85a6                	mv	a1,s1
  66:	00001517          	auipc	a0,0x1
  6a:	93a50513          	addi	a0,a0,-1734 # 9a0 <malloc+0x102>
  6e:	774000ef          	jal	7e2 <printf>
    exit(1);
  72:	4505                	li	a0,1
  74:	308000ef          	jal	37c <exit>
    fprintf(2, "%s: cannot stat %s\n", s, "ff");
  78:	00001697          	auipc	a3,0x1
  7c:	94068693          	addi	a3,a3,-1728 # 9b8 <malloc+0x11a>
  80:	8626                	mv	a2,s1
  82:	00001597          	auipc	a1,0x1
  86:	93e58593          	addi	a1,a1,-1730 # 9c0 <malloc+0x122>
  8a:	4509                	li	a0,2
  8c:	72c000ef          	jal	7b8 <fprintf>
    exit(1);
  90:	4505                	li	a0,1
  92:	2ea000ef          	jal	37c <exit>
    printf("%s: unlink failed\n", s);
  96:	85a6                	mv	a1,s1
  98:	00001517          	auipc	a0,0x1
  9c:	94050513          	addi	a0,a0,-1728 # 9d8 <malloc+0x13a>
  a0:	742000ef          	jal	7e2 <printf>
    exit(1);
  a4:	4505                	li	a0,1
  a6:	2d6000ef          	jal	37c <exit>
  }
  printf("wait for kill and reclaim %d\n", st.ino);
  aa:	fcc42583          	lw	a1,-52(s0)
  ae:	00001517          	auipc	a0,0x1
  b2:	95a50513          	addi	a0,a0,-1702 # a08 <malloc+0x16a>
  b6:	72c000ef          	jal	7e2 <printf>
  // sit around until killed
  for (;;)
    pause(1000);
  ba:	3e800493          	li	s1,1000
  be:	8526                	mv	a0,s1
  c0:	34c000ef          	jal	40c <pause>
  for (;;)
  c4:	bfed                	j	be <main+0xbe>

00000000000000c6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e406                	sd	ra,8(sp)
  ca:	e022                	sd	s0,0(sp)
  cc:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  ce:	f33ff0ef          	jal	0 <main>
  exit(r);
  d2:	2aa000ef          	jal	37c <exit>

00000000000000d6 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e406                	sd	ra,8(sp)
  da:	e022                	sd	s0,0(sp)
  dc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  de:	87aa                	mv	a5,a0
  e0:	0585                	addi	a1,a1,1
  e2:	0785                	addi	a5,a5,1
  e4:	fff5c703          	lbu	a4,-1(a1)
  e8:	fee78fa3          	sb	a4,-1(a5)
  ec:	fb75                	bnez	a4,e0 <strcpy+0xa>
    ;
  return os;
}
  ee:	60a2                	ld	ra,8(sp)
  f0:	6402                	ld	s0,0(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret

00000000000000f6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  fe:	00054783          	lbu	a5,0(a0)
 102:	cb91                	beqz	a5,116 <strcmp+0x20>
 104:	0005c703          	lbu	a4,0(a1)
 108:	00f71763          	bne	a4,a5,116 <strcmp+0x20>
    p++, q++;
 10c:	0505                	addi	a0,a0,1
 10e:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 110:	00054783          	lbu	a5,0(a0)
 114:	fbe5                	bnez	a5,104 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 116:	0005c503          	lbu	a0,0(a1)
}
 11a:	40a7853b          	subw	a0,a5,a0
 11e:	60a2                	ld	ra,8(sp)
 120:	6402                	ld	s0,0(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <strlen>:

uint
strlen(const char *s)
{
 126:	1141                	addi	sp,sp,-16
 128:	e406                	sd	ra,8(sp)
 12a:	e022                	sd	s0,0(sp)
 12c:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cf91                	beqz	a5,14e <strlen+0x28>
 134:	00150793          	addi	a5,a0,1
 138:	86be                	mv	a3,a5
 13a:	0785                	addi	a5,a5,1
 13c:	fff7c703          	lbu	a4,-1(a5)
 140:	ff65                	bnez	a4,138 <strlen+0x12>
 142:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 146:	60a2                	ld	ra,8(sp)
 148:	6402                	ld	s0,0(sp)
 14a:	0141                	addi	sp,sp,16
 14c:	8082                	ret
  for (n = 0; s[n]; n++)
 14e:	4501                	li	a0,0
 150:	bfdd                	j	146 <strlen+0x20>

0000000000000152 <memset>:

void *
memset(void *dst, int c, uint n)
{
 152:	1141                	addi	sp,sp,-16
 154:	e406                	sd	ra,8(sp)
 156:	e022                	sd	s0,0(sp)
 158:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 15a:	ca19                	beqz	a2,170 <memset+0x1e>
 15c:	87aa                	mv	a5,a0
 15e:	1602                	slli	a2,a2,0x20
 160:	9201                	srli	a2,a2,0x20
 162:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 166:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 16a:	0785                	addi	a5,a5,1
 16c:	fee79de3          	bne	a5,a4,166 <memset+0x14>
  }
  return dst;
}
 170:	60a2                	ld	ra,8(sp)
 172:	6402                	ld	s0,0(sp)
 174:	0141                	addi	sp,sp,16
 176:	8082                	ret

0000000000000178 <strchr>:

char *
strchr(const char *s, char c)
{
 178:	1141                	addi	sp,sp,-16
 17a:	e406                	sd	ra,8(sp)
 17c:	e022                	sd	s0,0(sp)
 17e:	0800                	addi	s0,sp,16
  for (; *s; s++)
 180:	00054783          	lbu	a5,0(a0)
 184:	c799                	beqz	a5,192 <strchr+0x1a>
    if (*s == c)
 186:	00f58763          	beq	a1,a5,194 <strchr+0x1c>
  for (; *s; s++)
 18a:	0505                	addi	a0,a0,1
 18c:	00054783          	lbu	a5,0(a0)
 190:	fbfd                	bnez	a5,186 <strchr+0xe>
      return (char *)s;
  return 0;
 192:	4501                	li	a0,0
}
 194:	60a2                	ld	ra,8(sp)
 196:	6402                	ld	s0,0(sp)
 198:	0141                	addi	sp,sp,16
 19a:	8082                	ret

000000000000019c <gets>:

char *
gets(char *buf, int max)
{
 19c:	711d                	addi	sp,sp,-96
 19e:	ec86                	sd	ra,88(sp)
 1a0:	e8a2                	sd	s0,80(sp)
 1a2:	e4a6                	sd	s1,72(sp)
 1a4:	e0ca                	sd	s2,64(sp)
 1a6:	fc4e                	sd	s3,56(sp)
 1a8:	f852                	sd	s4,48(sp)
 1aa:	f456                	sd	s5,40(sp)
 1ac:	f05a                	sd	s6,32(sp)
 1ae:	ec5e                	sd	s7,24(sp)
 1b0:	e862                	sd	s8,16(sp)
 1b2:	1080                	addi	s0,sp,96
 1b4:	8baa                	mv	s7,a0
 1b6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1b8:	892a                	mv	s2,a0
 1ba:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1bc:	faf40b13          	addi	s6,s0,-81
 1c0:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 1c2:	8c26                	mv	s8,s1
 1c4:	0014899b          	addiw	s3,s1,1
 1c8:	84ce                	mv	s1,s3
 1ca:	0349d863          	bge	s3,s4,1fa <gets+0x5e>
    cc = read(0, &c, 1);
 1ce:	8656                	mv	a2,s5
 1d0:	85da                	mv	a1,s6
 1d2:	4501                	li	a0,0
 1d4:	1c0000ef          	jal	394 <read>
    if (cc < 1)
 1d8:	02a05163          	blez	a0,1fa <gets+0x5e>
      break;
    buf[i++] = c;
 1dc:	faf44783          	lbu	a5,-81(s0)
 1e0:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 1e4:	0905                	addi	s2,s2,1
 1e6:	ff678713          	addi	a4,a5,-10
 1ea:	00173713          	seqz	a4,a4
 1ee:	17cd                	addi	a5,a5,-13
 1f0:	0017b793          	seqz	a5,a5
 1f4:	8fd9                	or	a5,a5,a4
 1f6:	d7f1                	beqz	a5,1c2 <gets+0x26>
    buf[i++] = c;
 1f8:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1fa:	9c5e                	add	s8,s8,s7
 1fc:	000c0023          	sb	zero,0(s8)
  return buf;
}
 200:	855e                	mv	a0,s7
 202:	60e6                	ld	ra,88(sp)
 204:	6446                	ld	s0,80(sp)
 206:	64a6                	ld	s1,72(sp)
 208:	6906                	ld	s2,64(sp)
 20a:	79e2                	ld	s3,56(sp)
 20c:	7a42                	ld	s4,48(sp)
 20e:	7aa2                	ld	s5,40(sp)
 210:	7b02                	ld	s6,32(sp)
 212:	6be2                	ld	s7,24(sp)
 214:	6c42                	ld	s8,16(sp)
 216:	6125                	addi	sp,sp,96
 218:	8082                	ret

000000000000021a <stat>:

int
stat(const char *n, struct stat *st)
{
 21a:	1101                	addi	sp,sp,-32
 21c:	ec06                	sd	ra,24(sp)
 21e:	e822                	sd	s0,16(sp)
 220:	e04a                	sd	s2,0(sp)
 222:	1000                	addi	s0,sp,32
 224:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 226:	4581                	li	a1,0
 228:	194000ef          	jal	3bc <open>
  if (fd < 0)
 22c:	02054263          	bltz	a0,250 <stat+0x36>
 230:	e426                	sd	s1,8(sp)
 232:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 234:	85ca                	mv	a1,s2
 236:	19e000ef          	jal	3d4 <fstat>
 23a:	892a                	mv	s2,a0
  close(fd);
 23c:	8526                	mv	a0,s1
 23e:	166000ef          	jal	3a4 <close>
  return r;
 242:	64a2                	ld	s1,8(sp)
}
 244:	854a                	mv	a0,s2
 246:	60e2                	ld	ra,24(sp)
 248:	6442                	ld	s0,16(sp)
 24a:	6902                	ld	s2,0(sp)
 24c:	6105                	addi	sp,sp,32
 24e:	8082                	ret
    return -1;
 250:	57fd                	li	a5,-1
 252:	893e                	mv	s2,a5
 254:	bfc5                	j	244 <stat+0x2a>

0000000000000256 <atoi>:

int
atoi(const char *s)
{
 256:	1141                	addi	sp,sp,-16
 258:	e406                	sd	ra,8(sp)
 25a:	e022                	sd	s0,0(sp)
 25c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 25e:	00054683          	lbu	a3,0(a0)
 262:	fd06879b          	addiw	a5,a3,-48
 266:	0ff7f793          	zext.b	a5,a5
 26a:	4625                	li	a2,9
 26c:	02f66963          	bltu	a2,a5,29e <atoi+0x48>
 270:	872a                	mv	a4,a0
  n = 0;
 272:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 274:	0705                	addi	a4,a4,1
 276:	0025179b          	slliw	a5,a0,0x2
 27a:	9fa9                	addw	a5,a5,a0
 27c:	0017979b          	slliw	a5,a5,0x1
 280:	9fb5                	addw	a5,a5,a3
 282:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 286:	00074683          	lbu	a3,0(a4)
 28a:	fd06879b          	addiw	a5,a3,-48
 28e:	0ff7f793          	zext.b	a5,a5
 292:	fef671e3          	bgeu	a2,a5,274 <atoi+0x1e>
  return n;
}
 296:	60a2                	ld	ra,8(sp)
 298:	6402                	ld	s0,0(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
  n = 0;
 29e:	4501                	li	a0,0
 2a0:	bfdd                	j	296 <atoi+0x40>

00000000000002a2 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e406                	sd	ra,8(sp)
 2a6:	e022                	sd	s0,0(sp)
 2a8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2aa:	02b57563          	bgeu	a0,a1,2d4 <memmove+0x32>
    while (n-- > 0)
 2ae:	00c05f63          	blez	a2,2cc <memmove+0x2a>
 2b2:	1602                	slli	a2,a2,0x20
 2b4:	9201                	srli	a2,a2,0x20
 2b6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ba:	872a                	mv	a4,a0
      *dst++ = *src++;
 2bc:	0585                	addi	a1,a1,1
 2be:	0705                	addi	a4,a4,1
 2c0:	fff5c683          	lbu	a3,-1(a1)
 2c4:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2c8:	fee79ae3          	bne	a5,a4,2bc <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2cc:	60a2                	ld	ra,8(sp)
 2ce:	6402                	ld	s0,0(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret
    while (n-- > 0)
 2d4:	fec05ce3          	blez	a2,2cc <memmove+0x2a>
    dst += n;
 2d8:	00c50733          	add	a4,a0,a2
    src += n;
 2dc:	95b2                	add	a1,a1,a2
 2de:	fff6079b          	addiw	a5,a2,-1
 2e2:	1782                	slli	a5,a5,0x20
 2e4:	9381                	srli	a5,a5,0x20
 2e6:	fff7c793          	not	a5,a5
 2ea:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ec:	15fd                	addi	a1,a1,-1
 2ee:	177d                	addi	a4,a4,-1
 2f0:	0005c683          	lbu	a3,0(a1)
 2f4:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 2f8:	fef71ae3          	bne	a4,a5,2ec <memmove+0x4a>
 2fc:	bfc1                	j	2cc <memmove+0x2a>

00000000000002fe <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e406                	sd	ra,8(sp)
 302:	e022                	sd	s0,0(sp)
 304:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 306:	ce19                	beqz	a2,324 <memcmp+0x26>
 308:	1602                	slli	a2,a2,0x20
 30a:	9201                	srli	a2,a2,0x20
 30c:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 310:	00054783          	lbu	a5,0(a0)
 314:	0005c703          	lbu	a4,0(a1)
 318:	00e79b63          	bne	a5,a4,32e <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 31c:	0505                	addi	a0,a0,1
    p2++;
 31e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 320:	fed518e3          	bne	a0,a3,310 <memcmp+0x12>
  }
  return 0;
 324:	4501                	li	a0,0
}
 326:	60a2                	ld	ra,8(sp)
 328:	6402                	ld	s0,0(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret
      return *p1 - *p2;
 32e:	40e7853b          	subw	a0,a5,a4
 332:	bfd5                	j	326 <memcmp+0x28>

0000000000000334 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 334:	1141                	addi	sp,sp,-16
 336:	e406                	sd	ra,8(sp)
 338:	e022                	sd	s0,0(sp)
 33a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 33c:	f67ff0ef          	jal	2a2 <memmove>
}
 340:	60a2                	ld	ra,8(sp)
 342:	6402                	ld	s0,0(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret

0000000000000348 <sbrk>:

char *
sbrk(int n)
{
 348:	1141                	addi	sp,sp,-16
 34a:	e406                	sd	ra,8(sp)
 34c:	e022                	sd	s0,0(sp)
 34e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 350:	4585                	li	a1,1
 352:	0b2000ef          	jal	404 <sys_sbrk>
}
 356:	60a2                	ld	ra,8(sp)
 358:	6402                	ld	s0,0(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret

000000000000035e <sbrklazy>:

char *
sbrklazy(int n)
{
 35e:	1141                	addi	sp,sp,-16
 360:	e406                	sd	ra,8(sp)
 362:	e022                	sd	s0,0(sp)
 364:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 366:	4589                	li	a1,2
 368:	09c000ef          	jal	404 <sys_sbrk>
}
 36c:	60a2                	ld	ra,8(sp)
 36e:	6402                	ld	s0,0(sp)
 370:	0141                	addi	sp,sp,16
 372:	8082                	ret

0000000000000374 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 374:	4885                	li	a7,1
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <exit>:
.global exit
exit:
 li a7, SYS_exit
 37c:	4889                	li	a7,2
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <wait>:
.global wait
wait:
 li a7, SYS_wait
 384:	488d                	li	a7,3
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 38c:	4891                	li	a7,4
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <read>:
.global read
read:
 li a7, SYS_read
 394:	4895                	li	a7,5
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <write>:
.global write
write:
 li a7, SYS_write
 39c:	48c1                	li	a7,16
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <close>:
.global close
close:
 li a7, SYS_close
 3a4:	48d5                	li	a7,21
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ac:	4899                	li	a7,6
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b4:	489d                	li	a7,7
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <open>:
.global open
open:
 li a7, SYS_open
 3bc:	48bd                	li	a7,15
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c4:	48c5                	li	a7,17
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3cc:	48c9                	li	a7,18
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d4:	48a1                	li	a7,8
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <link>:
.global link
link:
 li a7, SYS_link
 3dc:	48cd                	li	a7,19
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e4:	48d1                	li	a7,20
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ec:	48a5                	li	a7,9
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f4:	48a9                	li	a7,10
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3fc:	48ad                	li	a7,11
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 404:	48b1                	li	a7,12
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <pause>:
.global pause
pause:
 li a7, SYS_pause
 40c:	48b5                	li	a7,13
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 414:	48b9                	li	a7,14
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <sync>:
.global sync
sync:
 li a7, SYS_sync
 41c:	48d9                	li	a7,22
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 424:	48dd                	li	a7,23
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 42c:	1101                	addi	sp,sp,-32
 42e:	ec06                	sd	ra,24(sp)
 430:	e822                	sd	s0,16(sp)
 432:	1000                	addi	s0,sp,32
 434:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 438:	4605                	li	a2,1
 43a:	fef40593          	addi	a1,s0,-17
 43e:	f5fff0ef          	jal	39c <write>
}
 442:	60e2                	ld	ra,24(sp)
 444:	6442                	ld	s0,16(sp)
 446:	6105                	addi	sp,sp,32
 448:	8082                	ret

000000000000044a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 44a:	715d                	addi	sp,sp,-80
 44c:	e486                	sd	ra,72(sp)
 44e:	e0a2                	sd	s0,64(sp)
 450:	f84a                	sd	s2,48(sp)
 452:	f44e                	sd	s3,40(sp)
 454:	0880                	addi	s0,sp,80
 456:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 458:	00d036b3          	snez	a3,a3
 45c:	03f5d793          	srli	a5,a1,0x3f
 460:	8efd                	and	a3,a3,a5
  neg = 0;
 462:	4301                	li	t1,0
  if (sgn && xx < 0) {
 464:	c681                	beqz	a3,46c <printint+0x22>
    neg = 1;
    x = -xx;
 466:	40b005b3          	neg	a1,a1
    neg = 1;
 46a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 46c:	fb840993          	addi	s3,s0,-72
  neg = 0;
 470:	86ce                	mv	a3,s3
  i = 0;
 472:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 474:	00000817          	auipc	a6,0x0
 478:	5bc80813          	addi	a6,a6,1468 # a30 <digits>
 47c:	88ba                	mv	a7,a4
 47e:	0017051b          	addiw	a0,a4,1
 482:	872a                	mv	a4,a0
 484:	02c5f7b3          	remu	a5,a1,a2
 488:	97c2                	add	a5,a5,a6
 48a:	0007c783          	lbu	a5,0(a5)
 48e:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 492:	87ae                	mv	a5,a1
 494:	02c5d5b3          	divu	a1,a1,a2
 498:	0685                	addi	a3,a3,1
 49a:	fec7f1e3          	bgeu	a5,a2,47c <printint+0x32>
  if (neg)
 49e:	00030b63          	beqz	t1,4b4 <printint+0x6a>
    buf[i++] = '-';
 4a2:	fd040793          	addi	a5,s0,-48
 4a6:	953e                	add	a0,a0,a5
 4a8:	02d00793          	li	a5,45
 4ac:	fef50423          	sb	a5,-24(a0)
 4b0:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 4b4:	02e05563          	blez	a4,4de <printint+0x94>
 4b8:	fc26                	sd	s1,56(sp)
 4ba:	377d                	addiw	a4,a4,-1
 4bc:	00e984b3          	add	s1,s3,a4
 4c0:	19fd                	addi	s3,s3,-1
 4c2:	99ba                	add	s3,s3,a4
 4c4:	1702                	slli	a4,a4,0x20
 4c6:	9301                	srli	a4,a4,0x20
 4c8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4cc:	0004c583          	lbu	a1,0(s1)
 4d0:	854a                	mv	a0,s2
 4d2:	f5bff0ef          	jal	42c <putc>
  while (--i >= 0)
 4d6:	14fd                	addi	s1,s1,-1
 4d8:	ff349ae3          	bne	s1,s3,4cc <printint+0x82>
 4dc:	74e2                	ld	s1,56(sp)
}
 4de:	60a6                	ld	ra,72(sp)
 4e0:	6406                	ld	s0,64(sp)
 4e2:	7942                	ld	s2,48(sp)
 4e4:	79a2                	ld	s3,40(sp)
 4e6:	6161                	addi	sp,sp,80
 4e8:	8082                	ret

00000000000004ea <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ea:	711d                	addi	sp,sp,-96
 4ec:	ec86                	sd	ra,88(sp)
 4ee:	e8a2                	sd	s0,80(sp)
 4f0:	e4a6                	sd	s1,72(sp)
 4f2:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4f4:	0005c483          	lbu	s1,0(a1)
 4f8:	2a048063          	beqz	s1,798 <vprintf+0x2ae>
 4fc:	e0ca                	sd	s2,64(sp)
 4fe:	fc4e                	sd	s3,56(sp)
 500:	f852                	sd	s4,48(sp)
 502:	f456                	sd	s5,40(sp)
 504:	f05a                	sd	s6,32(sp)
 506:	ec5e                	sd	s7,24(sp)
 508:	e862                	sd	s8,16(sp)
 50a:	8b2a                	mv	s6,a0
 50c:	8a2e                	mv	s4,a1
 50e:	8bb2                	mv	s7,a2
  state = 0;
 510:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 512:	4901                	li	s2,0
 514:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 516:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 51a:	06400c13          	li	s8,100
 51e:	a00d                	j	540 <vprintf+0x56>
        putc(fd, c0);
 520:	85a6                	mv	a1,s1
 522:	855a                	mv	a0,s6
 524:	f09ff0ef          	jal	42c <putc>
 528:	a019                	j	52e <vprintf+0x44>
    } else if (state == '%') {
 52a:	03598363          	beq	s3,s5,550 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 52e:	0019079b          	addiw	a5,s2,1
 532:	893e                	mv	s2,a5
 534:	873e                	mv	a4,a5
 536:	97d2                	add	a5,a5,s4
 538:	0007c483          	lbu	s1,0(a5)
 53c:	24048763          	beqz	s1,78a <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 540:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 544:	fe0993e3          	bnez	s3,52a <vprintf+0x40>
      if (c0 == '%') {
 548:	fd579ce3          	bne	a5,s5,520 <vprintf+0x36>
        state = '%';
 54c:	89be                	mv	s3,a5
 54e:	b7c5                	j	52e <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 550:	00ea06b3          	add	a3,s4,a4
 554:	0016c603          	lbu	a2,1(a3)
      if (c1)
 558:	24060563          	beqz	a2,7a2 <vprintf+0x2b8>
      if (c0 == 'd') {
 55c:	0b878763          	beq	a5,s8,60a <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 560:	f9478693          	addi	a3,a5,-108
 564:	0016b693          	seqz	a3,a3
 568:	f9c60593          	addi	a1,a2,-100
 56c:	0015b593          	seqz	a1,a1
 570:	8df5                	and	a1,a1,a3
 572:	e9c5                	bnez	a1,622 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 574:	9752                	add	a4,a4,s4
 576:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 57a:	f9460713          	addi	a4,a2,-108
 57e:	00173713          	seqz	a4,a4
 582:	8f75                	and	a4,a4,a3
 584:	f9c50593          	addi	a1,a0,-100
 588:	0015b593          	seqz	a1,a1
 58c:	8df9                	and	a1,a1,a4
 58e:	e5dd                	bnez	a1,63c <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 590:	07500593          	li	a1,117
 594:	0cb78163          	beq	a5,a1,656 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 598:	f8b60593          	addi	a1,a2,-117
 59c:	0015b593          	seqz	a1,a1
 5a0:	8df5                	and	a1,a1,a3
 5a2:	e5f1                	bnez	a1,66e <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 5a4:	f8b50593          	addi	a1,a0,-117
 5a8:	0015b593          	seqz	a1,a1
 5ac:	8df9                	and	a1,a1,a4
 5ae:	ede9                	bnez	a1,688 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 5b0:	07800593          	li	a1,120
 5b4:	0eb78763          	beq	a5,a1,6a2 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 5b8:	f8860613          	addi	a2,a2,-120
 5bc:	00163613          	seqz	a2,a2
 5c0:	8ef1                	and	a3,a3,a2
 5c2:	0e069c63          	bnez	a3,6ba <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 5c6:	f8850513          	addi	a0,a0,-120
 5ca:	00153513          	seqz	a0,a0
 5ce:	8f69                	and	a4,a4,a0
 5d0:	10071263          	bnez	a4,6d4 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 5d4:	07000713          	li	a4,112
 5d8:	10e78a63          	beq	a5,a4,6ec <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 5dc:	06300713          	li	a4,99
 5e0:	14e78a63          	beq	a5,a4,734 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 5e4:	07300713          	li	a4,115
 5e8:	16e78063          	beq	a5,a4,748 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 5ec:	02500713          	li	a4,37
 5f0:	18e78863          	beq	a5,a4,780 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f4:	02500593          	li	a1,37
 5f8:	855a                	mv	a0,s6
 5fa:	e33ff0ef          	jal	42c <putc>
        putc(fd, c0);
 5fe:	85a6                	mv	a1,s1
 600:	855a                	mv	a0,s6
 602:	e2bff0ef          	jal	42c <putc>
      }

      state = 0;
 606:	4981                	li	s3,0
 608:	b71d                	j	52e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 60a:	008b8493          	addi	s1,s7,8
 60e:	4685                	li	a3,1
 610:	4629                	li	a2,10
 612:	000ba583          	lw	a1,0(s7)
 616:	855a                	mv	a0,s6
 618:	e33ff0ef          	jal	44a <printint>
 61c:	8ba6                	mv	s7,s1
      state = 0;
 61e:	4981                	li	s3,0
 620:	b739                	j	52e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 622:	008b8493          	addi	s1,s7,8
 626:	4685                	li	a3,1
 628:	4629                	li	a2,10
 62a:	000bb583          	ld	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	e1bff0ef          	jal	44a <printint>
        i += 1;
 634:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 636:	8ba6                	mv	s7,s1
      state = 0;
 638:	4981                	li	s3,0
 63a:	bdd5                	j	52e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 63c:	008b8493          	addi	s1,s7,8
 640:	4685                	li	a3,1
 642:	4629                	li	a2,10
 644:	000bb583          	ld	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	e01ff0ef          	jal	44a <printint>
        i += 2;
 64e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 650:	8ba6                	mv	s7,s1
      state = 0;
 652:	4981                	li	s3,0
        i += 2;
 654:	bde9                	j	52e <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 656:	008b8493          	addi	s1,s7,8
 65a:	4681                	li	a3,0
 65c:	4629                	li	a2,10
 65e:	000be583          	lwu	a1,0(s7)
 662:	855a                	mv	a0,s6
 664:	de7ff0ef          	jal	44a <printint>
 668:	8ba6                	mv	s7,s1
      state = 0;
 66a:	4981                	li	s3,0
 66c:	b5c9                	j	52e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 66e:	008b8493          	addi	s1,s7,8
 672:	4681                	li	a3,0
 674:	4629                	li	a2,10
 676:	000bb583          	ld	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	dcfff0ef          	jal	44a <printint>
        i += 1;
 680:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 682:	8ba6                	mv	s7,s1
      state = 0;
 684:	4981                	li	s3,0
 686:	b565                	j	52e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 688:	008b8493          	addi	s1,s7,8
 68c:	4681                	li	a3,0
 68e:	4629                	li	a2,10
 690:	000bb583          	ld	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	db5ff0ef          	jal	44a <printint>
        i += 2;
 69a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 69c:	8ba6                	mv	s7,s1
      state = 0;
 69e:	4981                	li	s3,0
        i += 2;
 6a0:	b579                	j	52e <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6a2:	008b8493          	addi	s1,s7,8
 6a6:	4681                	li	a3,0
 6a8:	4641                	li	a2,16
 6aa:	000be583          	lwu	a1,0(s7)
 6ae:	855a                	mv	a0,s6
 6b0:	d9bff0ef          	jal	44a <printint>
 6b4:	8ba6                	mv	s7,s1
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	bd9d                	j	52e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ba:	008b8493          	addi	s1,s7,8
 6be:	4681                	li	a3,0
 6c0:	4641                	li	a2,16
 6c2:	000bb583          	ld	a1,0(s7)
 6c6:	855a                	mv	a0,s6
 6c8:	d83ff0ef          	jal	44a <printint>
        i += 1;
 6cc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ce:	8ba6                	mv	s7,s1
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	bdb1                	j	52e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d4:	008b8493          	addi	s1,s7,8
 6d8:	4641                	li	a2,16
 6da:	000bb583          	ld	a1,0(s7)
 6de:	855a                	mv	a0,s6
 6e0:	d6bff0ef          	jal	44a <printint>
        i += 2;
 6e4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e6:	8ba6                	mv	s7,s1
      state = 0;
 6e8:	4981                	li	s3,0
        i += 2;
 6ea:	b591                	j	52e <vprintf+0x44>
 6ec:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6ee:	008b8793          	addi	a5,s7,8
 6f2:	8cbe                	mv	s9,a5
 6f4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6f8:	03000593          	li	a1,48
 6fc:	855a                	mv	a0,s6
 6fe:	d2fff0ef          	jal	42c <putc>
  putc(fd, 'x');
 702:	07800593          	li	a1,120
 706:	855a                	mv	a0,s6
 708:	d25ff0ef          	jal	42c <putc>
 70c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 70e:	00000b97          	auipc	s7,0x0
 712:	322b8b93          	addi	s7,s7,802 # a30 <digits>
 716:	03c9d793          	srli	a5,s3,0x3c
 71a:	97de                	add	a5,a5,s7
 71c:	0007c583          	lbu	a1,0(a5)
 720:	855a                	mv	a0,s6
 722:	d0bff0ef          	jal	42c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 726:	0992                	slli	s3,s3,0x4
 728:	34fd                	addiw	s1,s1,-1
 72a:	f4f5                	bnez	s1,716 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 72c:	8be6                	mv	s7,s9
      state = 0;
 72e:	4981                	li	s3,0
 730:	6ca2                	ld	s9,8(sp)
 732:	bbf5                	j	52e <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 734:	008b8493          	addi	s1,s7,8
 738:	000bc583          	lbu	a1,0(s7)
 73c:	855a                	mv	a0,s6
 73e:	cefff0ef          	jal	42c <putc>
 742:	8ba6                	mv	s7,s1
      state = 0;
 744:	4981                	li	s3,0
 746:	b3e5                	j	52e <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 748:	008b8993          	addi	s3,s7,8
 74c:	000bb483          	ld	s1,0(s7)
 750:	cc91                	beqz	s1,76c <vprintf+0x282>
        for (; *s; s++)
 752:	0004c583          	lbu	a1,0(s1)
 756:	c195                	beqz	a1,77a <vprintf+0x290>
          putc(fd, *s);
 758:	855a                	mv	a0,s6
 75a:	cd3ff0ef          	jal	42c <putc>
        for (; *s; s++)
 75e:	0485                	addi	s1,s1,1
 760:	0004c583          	lbu	a1,0(s1)
 764:	f9f5                	bnez	a1,758 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 766:	8bce                	mv	s7,s3
      state = 0;
 768:	4981                	li	s3,0
 76a:	b3d1                	j	52e <vprintf+0x44>
          s = "(null)";
 76c:	00000497          	auipc	s1,0x0
 770:	2bc48493          	addi	s1,s1,700 # a28 <malloc+0x18a>
        for (; *s; s++)
 774:	02800593          	li	a1,40
 778:	b7c5                	j	758 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 77a:	8bce                	mv	s7,s3
      state = 0;
 77c:	4981                	li	s3,0
 77e:	bb45                	j	52e <vprintf+0x44>
        putc(fd, '%');
 780:	85be                	mv	a1,a5
 782:	855a                	mv	a0,s6
 784:	ca9ff0ef          	jal	42c <putc>
 788:	bdbd                	j	606 <vprintf+0x11c>
 78a:	6906                	ld	s2,64(sp)
 78c:	79e2                	ld	s3,56(sp)
 78e:	7a42                	ld	s4,48(sp)
 790:	7aa2                	ld	s5,40(sp)
 792:	7b02                	ld	s6,32(sp)
 794:	6be2                	ld	s7,24(sp)
 796:	6c42                	ld	s8,16(sp)
    }
  }
}
 798:	60e6                	ld	ra,88(sp)
 79a:	6446                	ld	s0,80(sp)
 79c:	64a6                	ld	s1,72(sp)
 79e:	6125                	addi	sp,sp,96
 7a0:	8082                	ret
      if (c0 == 'd') {
 7a2:	06400713          	li	a4,100
 7a6:	e6e782e3          	beq	a5,a4,60a <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 7aa:	f9478693          	addi	a3,a5,-108
 7ae:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7b2:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 7b4:	4701                	li	a4,0
 7b6:	bbe9                	j	590 <vprintf+0xa6>

00000000000007b8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7b8:	715d                	addi	sp,sp,-80
 7ba:	ec06                	sd	ra,24(sp)
 7bc:	e822                	sd	s0,16(sp)
 7be:	1000                	addi	s0,sp,32
 7c0:	e010                	sd	a2,0(s0)
 7c2:	e414                	sd	a3,8(s0)
 7c4:	e818                	sd	a4,16(s0)
 7c6:	ec1c                	sd	a5,24(s0)
 7c8:	03043023          	sd	a6,32(s0)
 7cc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7d0:	8622                	mv	a2,s0
 7d2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d6:	d15ff0ef          	jal	4ea <vprintf>
}
 7da:	60e2                	ld	ra,24(sp)
 7dc:	6442                	ld	s0,16(sp)
 7de:	6161                	addi	sp,sp,80
 7e0:	8082                	ret

00000000000007e2 <printf>:

void
printf(const char *fmt, ...)
{
 7e2:	711d                	addi	sp,sp,-96
 7e4:	ec06                	sd	ra,24(sp)
 7e6:	e822                	sd	s0,16(sp)
 7e8:	1000                	addi	s0,sp,32
 7ea:	e40c                	sd	a1,8(s0)
 7ec:	e810                	sd	a2,16(s0)
 7ee:	ec14                	sd	a3,24(s0)
 7f0:	f018                	sd	a4,32(s0)
 7f2:	f41c                	sd	a5,40(s0)
 7f4:	03043823          	sd	a6,48(s0)
 7f8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7fc:	00840613          	addi	a2,s0,8
 800:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 804:	85aa                	mv	a1,a0
 806:	4505                	li	a0,1
 808:	ce3ff0ef          	jal	4ea <vprintf>
}
 80c:	60e2                	ld	ra,24(sp)
 80e:	6442                	ld	s0,16(sp)
 810:	6125                	addi	sp,sp,96
 812:	8082                	ret

0000000000000814 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 814:	1141                	addi	sp,sp,-16
 816:	e406                	sd	ra,8(sp)
 818:	e022                	sd	s0,0(sp)
 81a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 81c:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 820:	00000797          	auipc	a5,0x0
 824:	7e07b783          	ld	a5,2016(a5) # 1000 <freep>
 828:	a095                	j	88c <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 82a:	ff852583          	lw	a1,-8(a0)
 82e:	6390                	ld	a2,0(a5)
 830:	02059813          	slli	a6,a1,0x20
 834:	01c85693          	srli	a3,a6,0x1c
 838:	96ba                	add	a3,a3,a4
 83a:	02d60563          	beq	a2,a3,864 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 83e:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 842:	4790                	lw	a2,8(a5)
 844:	02061593          	slli	a1,a2,0x20
 848:	01c5d693          	srli	a3,a1,0x1c
 84c:	96be                	add	a3,a3,a5
 84e:	02d70263          	beq	a4,a3,872 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 852:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 854:	00000717          	auipc	a4,0x0
 858:	7af73623          	sd	a5,1964(a4) # 1000 <freep>
}
 85c:	60a2                	ld	ra,8(sp)
 85e:	6402                	ld	s0,0(sp)
 860:	0141                	addi	sp,sp,16
 862:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 864:	4614                	lw	a3,8(a2)
 866:	9ead                	addw	a3,a3,a1
 868:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 86c:	6394                	ld	a3,0(a5)
 86e:	6290                	ld	a2,0(a3)
 870:	b7f9                	j	83e <free+0x2a>
    p->s.size += bp->s.size;
 872:	ff852703          	lw	a4,-8(a0)
 876:	9f31                	addw	a4,a4,a2
 878:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 87a:	ff053703          	ld	a4,-16(a0)
 87e:	bfd1                	j	852 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 880:	6394                	ld	a3,0(a5)
 882:	00d7e463          	bltu	a5,a3,88a <free+0x76>
 886:	fad762e3          	bltu	a4,a3,82a <free+0x16>
 88a:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88c:	fee7fae3          	bgeu	a5,a4,880 <free+0x6c>
 890:	6394                	ld	a3,0(a5)
 892:	f8d76ce3          	bltu	a4,a3,82a <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 896:	f8d7fae3          	bgeu	a5,a3,82a <free+0x16>
 89a:	87b6                	mv	a5,a3
 89c:	bfc5                	j	88c <free+0x78>

000000000000089e <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 89e:	7139                	addi	sp,sp,-64
 8a0:	fc06                	sd	ra,56(sp)
 8a2:	f822                	sd	s0,48(sp)
 8a4:	f04a                	sd	s2,32(sp)
 8a6:	ec4e                	sd	s3,24(sp)
 8a8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8aa:	02051993          	slli	s3,a0,0x20
 8ae:	0209d993          	srli	s3,s3,0x20
 8b2:	09bd                	addi	s3,s3,15
 8b4:	0049d993          	srli	s3,s3,0x4
 8b8:	2985                	addiw	s3,s3,1
 8ba:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 8bc:	00000517          	auipc	a0,0x0
 8c0:	74453503          	ld	a0,1860(a0) # 1000 <freep>
 8c4:	c905                	beqz	a0,8f4 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8c6:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8c8:	4798                	lw	a4,8(a5)
 8ca:	09377663          	bgeu	a4,s3,956 <malloc+0xb8>
 8ce:	f426                	sd	s1,40(sp)
 8d0:	e852                	sd	s4,16(sp)
 8d2:	e456                	sd	s5,8(sp)
 8d4:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8d6:	8a4e                	mv	s4,s3
 8d8:	6705                	lui	a4,0x1
 8da:	00e9f363          	bgeu	s3,a4,8e0 <malloc+0x42>
 8de:	6a05                	lui	s4,0x1
 8e0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8e4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8e8:	00000497          	auipc	s1,0x0
 8ec:	71848493          	addi	s1,s1,1816 # 1000 <freep>
  if (p == SBRK_ERROR)
 8f0:	5afd                	li	s5,-1
 8f2:	a83d                	j	930 <malloc+0x92>
 8f4:	f426                	sd	s1,40(sp)
 8f6:	e852                	sd	s4,16(sp)
 8f8:	e456                	sd	s5,8(sp)
 8fa:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8fc:	00001797          	auipc	a5,0x1
 900:	90c78793          	addi	a5,a5,-1780 # 1208 <base>
 904:	00000717          	auipc	a4,0x0
 908:	6ef73e23          	sd	a5,1788(a4) # 1000 <freep>
 90c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 90e:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 912:	b7d1                	j	8d6 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 914:	6398                	ld	a4,0(a5)
 916:	e118                	sd	a4,0(a0)
 918:	a899                	j	96e <malloc+0xd0>
  hp->s.size = nu;
 91a:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 91e:	0541                	addi	a0,a0,16
 920:	ef5ff0ef          	jal	814 <free>
  return freep;
 924:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 926:	c125                	beqz	a0,986 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 928:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 92a:	4798                	lw	a4,8(a5)
 92c:	03277163          	bgeu	a4,s2,94e <malloc+0xb0>
    if (p == freep)
 930:	6098                	ld	a4,0(s1)
 932:	853e                	mv	a0,a5
 934:	fef71ae3          	bne	a4,a5,928 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 938:	8552                	mv	a0,s4
 93a:	a0fff0ef          	jal	348 <sbrk>
  if (p == SBRK_ERROR)
 93e:	fd551ee3          	bne	a0,s5,91a <malloc+0x7c>
        return 0;
 942:	4501                	li	a0,0
 944:	74a2                	ld	s1,40(sp)
 946:	6a42                	ld	s4,16(sp)
 948:	6aa2                	ld	s5,8(sp)
 94a:	6b02                	ld	s6,0(sp)
 94c:	a03d                	j	97a <malloc+0xdc>
 94e:	74a2                	ld	s1,40(sp)
 950:	6a42                	ld	s4,16(sp)
 952:	6aa2                	ld	s5,8(sp)
 954:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 956:	fae90fe3          	beq	s2,a4,914 <malloc+0x76>
        p->s.size -= nunits;
 95a:	4137073b          	subw	a4,a4,s3
 95e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 960:	02071693          	slli	a3,a4,0x20
 964:	01c6d713          	srli	a4,a3,0x1c
 968:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 96a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 96e:	00000717          	auipc	a4,0x0
 972:	68a73923          	sd	a0,1682(a4) # 1000 <freep>
      return (void *)(p + 1);
 976:	01078513          	addi	a0,a5,16
  }
}
 97a:	70e2                	ld	ra,56(sp)
 97c:	7442                	ld	s0,48(sp)
 97e:	7902                	ld	s2,32(sp)
 980:	69e2                	ld	s3,24(sp)
 982:	6121                	addi	sp,sp,64
 984:	8082                	ret
 986:	74a2                	ld	s1,40(sp)
 988:	6a42                	ld	s4,16(sp)
 98a:	6aa2                	ld	s5,8(sp)
 98c:	6b02                	ld	s6,0(sp)
 98e:	b7f5                	j	97a <malloc+0xdc>
