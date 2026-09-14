
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
}

// matchstar: search for c*re at beginning of text
int
matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do { // a * matches zero or more instances
    if (matchhere(re, text))
      return 1;
  } while (*text != '\0' && (*text++ == c || c == '.'));
  16:	fd250a13          	addi	s4,a0,-46
  1a:	001a3a13          	seqz	s4,s4
    if (matchhere(re, text))
  1e:	85a6                	mv	a1,s1
  20:	854e                	mv	a0,s3
  22:	030000ef          	jal	52 <matchhere>
  26:	ed09                	bnez	a0,40 <matchstar+0x40>
  } while (*text != '\0' && (*text++ == c || c == '.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb99                	beqz	a5,42 <matchstar+0x42>
  2e:	0485                	addi	s1,s1,1
  30:	412787b3          	sub	a5,a5,s2
  34:	0017b793          	seqz	a5,a5
  38:	00fa67b3          	or	a5,s4,a5
  3c:	f3ed                	bnez	a5,1e <matchstar+0x1e>
  3e:	a011                	j	42 <matchstar+0x42>
      return 1;
  40:	4505                	li	a0,1
  return 0;
}
  42:	70a2                	ld	ra,40(sp)
  44:	7402                	ld	s0,32(sp)
  46:	64e2                	ld	s1,24(sp)
  48:	6942                	ld	s2,16(sp)
  4a:	69a2                	ld	s3,8(sp)
  4c:	6a02                	ld	s4,0(sp)
  4e:	6145                	addi	sp,sp,48
  50:	8082                	ret

0000000000000052 <matchhere>:
  if (re[0] == '\0')
  52:	00054703          	lbu	a4,0(a0)
  56:	c735                	beqz	a4,c2 <matchhere+0x70>
{
  58:	1141                	addi	sp,sp,-16
  5a:	e406                	sd	ra,8(sp)
  5c:	e022                	sd	s0,0(sp)
  5e:	0800                	addi	s0,sp,16
  if (re[1] == '*')
  60:	00154783          	lbu	a5,1(a0)
  64:	02a00693          	li	a3,42
  68:	02d78c63          	beq	a5,a3,a0 <matchhere+0x4e>
  if (re[0] == '$' && re[1] == '\0')
  6c:	0017b793          	seqz	a5,a5
  70:	fdc70693          	addi	a3,a4,-36
  74:	0016b693          	seqz	a3,a3
  78:	8ff5                	and	a5,a5,a3
  7a:	eb95                	bnez	a5,ae <matchhere+0x5c>
  if (*text != '\0' && (re[0] == '.' || re[0] == *text))
  7c:	0005c783          	lbu	a5,0(a1)
  80:	cb99                	beqz	a5,96 <matchhere+0x44>
  82:	40f707b3          	sub	a5,a4,a5
  86:	0017b793          	seqz	a5,a5
  8a:	fd270713          	addi	a4,a4,-46
  8e:	00173713          	seqz	a4,a4
  92:	8fd9                	or	a5,a5,a4
  94:	e395                	bnez	a5,b8 <matchhere+0x66>
  return 0;
  96:	4501                	li	a0,0
}
  98:	60a2                	ld	ra,8(sp)
  9a:	6402                	ld	s0,0(sp)
  9c:	0141                	addi	sp,sp,16
  9e:	8082                	ret
    return matchstar(re[0], re + 2, text);
  a0:	862e                	mv	a2,a1
  a2:	00250593          	addi	a1,a0,2
  a6:	853a                	mv	a0,a4
  a8:	f59ff0ef          	jal	0 <matchstar>
  ac:	b7f5                	j	98 <matchhere+0x46>
    return *text == '\0';
  ae:	0005c503          	lbu	a0,0(a1)
  b2:	00153513          	seqz	a0,a0
  b6:	b7cd                	j	98 <matchhere+0x46>
    return matchhere(re + 1, text + 1);
  b8:	0585                	addi	a1,a1,1
  ba:	0505                	addi	a0,a0,1
  bc:	f97ff0ef          	jal	52 <matchhere>
  c0:	bfe1                	j	98 <matchhere+0x46>
    return 1;
  c2:	4505                	li	a0,1
}
  c4:	8082                	ret

00000000000000c6 <match>:
{
  c6:	1101                	addi	sp,sp,-32
  c8:	ec06                	sd	ra,24(sp)
  ca:	e822                	sd	s0,16(sp)
  cc:	e426                	sd	s1,8(sp)
  ce:	e04a                	sd	s2,0(sp)
  d0:	1000                	addi	s0,sp,32
  d2:	892a                	mv	s2,a0
  d4:	84ae                	mv	s1,a1
  if (re[0] == '^')
  d6:	00054703          	lbu	a4,0(a0)
  da:	05e00793          	li	a5,94
  de:	00f70c63          	beq	a4,a5,f6 <match+0x30>
    if (matchhere(re, text))
  e2:	85a6                	mv	a1,s1
  e4:	854a                	mv	a0,s2
  e6:	f6dff0ef          	jal	52 <matchhere>
  ea:	e911                	bnez	a0,fe <match+0x38>
  } while (*text++ != '\0');
  ec:	0485                	addi	s1,s1,1
  ee:	fff4c783          	lbu	a5,-1(s1)
  f2:	fbe5                	bnez	a5,e2 <match+0x1c>
  f4:	a031                	j	100 <match+0x3a>
    return matchhere(re + 1, text);
  f6:	0505                	addi	a0,a0,1
  f8:	f5bff0ef          	jal	52 <matchhere>
  fc:	a011                	j	100 <match+0x3a>
      return 1;
  fe:	4505                	li	a0,1
}
 100:	60e2                	ld	ra,24(sp)
 102:	6442                	ld	s0,16(sp)
 104:	64a2                	ld	s1,8(sp)
 106:	6902                	ld	s2,0(sp)
 108:	6105                	addi	sp,sp,32
 10a:	8082                	ret

000000000000010c <grep>:
{
 10c:	711d                	addi	sp,sp,-96
 10e:	ec86                	sd	ra,88(sp)
 110:	e8a2                	sd	s0,80(sp)
 112:	e4a6                	sd	s1,72(sp)
 114:	e0ca                	sd	s2,64(sp)
 116:	fc4e                	sd	s3,56(sp)
 118:	f852                	sd	s4,48(sp)
 11a:	f456                	sd	s5,40(sp)
 11c:	f05a                	sd	s6,32(sp)
 11e:	ec5e                	sd	s7,24(sp)
 120:	e862                	sd	s8,16(sp)
 122:	e466                	sd	s9,8(sp)
 124:	e06a                	sd	s10,0(sp)
 126:	1080                	addi	s0,sp,96
 128:	8aaa                	mv	s5,a0
 12a:	8cae                	mv	s9,a1
  m = 0;
 12c:	4b01                	li	s6,0
  while ((n = read(fd, buf + m, sizeof(buf) - m - 1)) > 0) {
 12e:	3ff00d13          	li	s10,1023
 132:	00002b97          	auipc	s7,0x2
 136:	edeb8b93          	addi	s7,s7,-290 # 2010 <buf>
    while ((q = strchr(p, '\n')) != 0) {
 13a:	49a9                	li	s3,10
        write(1, p, q + 1 - p);
 13c:	4c05                	li	s8,1
  while ((n = read(fd, buf + m, sizeof(buf) - m - 1)) > 0) {
 13e:	a82d                	j	178 <grep+0x6c>
      p = q + 1;
 140:	00148913          	addi	s2,s1,1
    while ((q = strchr(p, '\n')) != 0) {
 144:	85ce                	mv	a1,s3
 146:	854a                	mv	a0,s2
 148:	1da000ef          	jal	322 <strchr>
 14c:	84aa                	mv	s1,a0
 14e:	c11d                	beqz	a0,174 <grep+0x68>
      *q = 0;
 150:	00048023          	sb	zero,0(s1)
      if (match(pattern, p)) {
 154:	85ca                	mv	a1,s2
 156:	8556                	mv	a0,s5
 158:	f6fff0ef          	jal	c6 <match>
 15c:	d175                	beqz	a0,140 <grep+0x34>
        *q = '\n';
 15e:	01348023          	sb	s3,0(s1)
        write(1, p, q + 1 - p);
 162:	00148613          	addi	a2,s1,1
 166:	4126063b          	subw	a2,a2,s2
 16a:	85ca                	mv	a1,s2
 16c:	8562                	mv	a0,s8
 16e:	3d8000ef          	jal	546 <write>
 172:	b7f9                	j	140 <grep+0x34>
    if (m > 0) {
 174:	03604463          	bgtz	s6,19c <grep+0x90>
  while ((n = read(fd, buf + m, sizeof(buf) - m - 1)) > 0) {
 178:	416d063b          	subw	a2,s10,s6
 17c:	016b85b3          	add	a1,s7,s6
 180:	8566                	mv	a0,s9
 182:	3bc000ef          	jal	53e <read>
 186:	02a05c63          	blez	a0,1be <grep+0xb2>
    m += n;
 18a:	00ab0a3b          	addw	s4,s6,a0
 18e:	8b52                	mv	s6,s4
    buf[m] = '\0';
 190:	014b87b3          	add	a5,s7,s4
 194:	00078023          	sb	zero,0(a5)
    p = buf;
 198:	895e                	mv	s2,s7
    while ((q = strchr(p, '\n')) != 0) {
 19a:	b76d                	j	144 <grep+0x38>
      m -= p - buf;
 19c:	00002797          	auipc	a5,0x2
 1a0:	e7478793          	addi	a5,a5,-396 # 2010 <buf>
 1a4:	40f907b3          	sub	a5,s2,a5
 1a8:	40fa063b          	subw	a2,s4,a5
 1ac:	8b32                	mv	s6,a2
      memmove(buf, p, m);
 1ae:	85ca                	mv	a1,s2
 1b0:	00002517          	auipc	a0,0x2
 1b4:	e6050513          	addi	a0,a0,-416 # 2010 <buf>
 1b8:	294000ef          	jal	44c <memmove>
 1bc:	bf75                	j	178 <grep+0x6c>
}
 1be:	60e6                	ld	ra,88(sp)
 1c0:	6446                	ld	s0,80(sp)
 1c2:	64a6                	ld	s1,72(sp)
 1c4:	6906                	ld	s2,64(sp)
 1c6:	79e2                	ld	s3,56(sp)
 1c8:	7a42                	ld	s4,48(sp)
 1ca:	7aa2                	ld	s5,40(sp)
 1cc:	7b02                	ld	s6,32(sp)
 1ce:	6be2                	ld	s7,24(sp)
 1d0:	6c42                	ld	s8,16(sp)
 1d2:	6ca2                	ld	s9,8(sp)
 1d4:	6d02                	ld	s10,0(sp)
 1d6:	6125                	addi	sp,sp,96
 1d8:	8082                	ret

00000000000001da <main>:
{
 1da:	7179                	addi	sp,sp,-48
 1dc:	f406                	sd	ra,40(sp)
 1de:	f022                	sd	s0,32(sp)
 1e0:	ec26                	sd	s1,24(sp)
 1e2:	e84a                	sd	s2,16(sp)
 1e4:	e44e                	sd	s3,8(sp)
 1e6:	e052                	sd	s4,0(sp)
 1e8:	1800                	addi	s0,sp,48
  if (argc <= 1) {
 1ea:	4785                	li	a5,1
 1ec:	04a7d663          	bge	a5,a0,238 <main+0x5e>
  pattern = argv[1];
 1f0:	0085ba03          	ld	s4,8(a1)
  if (argc <= 2) {
 1f4:	4789                	li	a5,2
 1f6:	04a7db63          	bge	a5,a0,24c <main+0x72>
 1fa:	01058913          	addi	s2,a1,16
 1fe:	ffd5099b          	addiw	s3,a0,-3
 202:	02099793          	slli	a5,s3,0x20
 206:	01d7d993          	srli	s3,a5,0x1d
 20a:	05e1                	addi	a1,a1,24
 20c:	99ae                	add	s3,s3,a1
    if ((fd = open(argv[i], O_RDONLY)) < 0) {
 20e:	4581                	li	a1,0
 210:	00093503          	ld	a0,0(s2)
 214:	352000ef          	jal	566 <open>
 218:	84aa                	mv	s1,a0
 21a:	04054063          	bltz	a0,25a <main+0x80>
    grep(pattern, fd);
 21e:	85aa                	mv	a1,a0
 220:	8552                	mv	a0,s4
 222:	eebff0ef          	jal	10c <grep>
    close(fd);
 226:	8526                	mv	a0,s1
 228:	326000ef          	jal	54e <close>
  for (i = 2; i < argc; i++) {
 22c:	0921                	addi	s2,s2,8
 22e:	ff3910e3          	bne	s2,s3,20e <main+0x34>
  exit(0);
 232:	4501                	li	a0,0
 234:	2f2000ef          	jal	526 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 238:	00001597          	auipc	a1,0x1
 23c:	90858593          	addi	a1,a1,-1784 # b40 <malloc+0xf8>
 240:	4509                	li	a0,2
 242:	720000ef          	jal	962 <fprintf>
    exit(1);
 246:	4505                	li	a0,1
 248:	2de000ef          	jal	526 <exit>
    grep(pattern, 0);
 24c:	4581                	li	a1,0
 24e:	8552                	mv	a0,s4
 250:	ebdff0ef          	jal	10c <grep>
    exit(0);
 254:	4501                	li	a0,0
 256:	2d0000ef          	jal	526 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 25a:	00093583          	ld	a1,0(s2)
 25e:	00001517          	auipc	a0,0x1
 262:	90250513          	addi	a0,a0,-1790 # b60 <malloc+0x118>
 266:	726000ef          	jal	98c <printf>
      exit(1);
 26a:	4505                	li	a0,1
 26c:	2ba000ef          	jal	526 <exit>

0000000000000270 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 270:	1141                	addi	sp,sp,-16
 272:	e406                	sd	ra,8(sp)
 274:	e022                	sd	s0,0(sp)
 276:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 278:	f63ff0ef          	jal	1da <main>
  exit(r);
 27c:	2aa000ef          	jal	526 <exit>

0000000000000280 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 280:	1141                	addi	sp,sp,-16
 282:	e406                	sd	ra,8(sp)
 284:	e022                	sd	s0,0(sp)
 286:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 288:	87aa                	mv	a5,a0
 28a:	0585                	addi	a1,a1,1
 28c:	0785                	addi	a5,a5,1
 28e:	fff5c703          	lbu	a4,-1(a1)
 292:	fee78fa3          	sb	a4,-1(a5)
 296:	fb75                	bnez	a4,28a <strcpy+0xa>
    ;
  return os;
}
 298:	60a2                	ld	ra,8(sp)
 29a:	6402                	ld	s0,0(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret

00000000000002a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e406                	sd	ra,8(sp)
 2a4:	e022                	sd	s0,0(sp)
 2a6:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 2a8:	00054783          	lbu	a5,0(a0)
 2ac:	cb91                	beqz	a5,2c0 <strcmp+0x20>
 2ae:	0005c703          	lbu	a4,0(a1)
 2b2:	00f71763          	bne	a4,a5,2c0 <strcmp+0x20>
    p++, q++;
 2b6:	0505                	addi	a0,a0,1
 2b8:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 2ba:	00054783          	lbu	a5,0(a0)
 2be:	fbe5                	bnez	a5,2ae <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2c0:	0005c503          	lbu	a0,0(a1)
}
 2c4:	40a7853b          	subw	a0,a5,a0
 2c8:	60a2                	ld	ra,8(sp)
 2ca:	6402                	ld	s0,0(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret

00000000000002d0 <strlen>:

uint
strlen(const char *s)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e406                	sd	ra,8(sp)
 2d4:	e022                	sd	s0,0(sp)
 2d6:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 2d8:	00054783          	lbu	a5,0(a0)
 2dc:	cf91                	beqz	a5,2f8 <strlen+0x28>
 2de:	00150793          	addi	a5,a0,1
 2e2:	86be                	mv	a3,a5
 2e4:	0785                	addi	a5,a5,1
 2e6:	fff7c703          	lbu	a4,-1(a5)
 2ea:	ff65                	bnez	a4,2e2 <strlen+0x12>
 2ec:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 2f0:	60a2                	ld	ra,8(sp)
 2f2:	6402                	ld	s0,0(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret
  for (n = 0; s[n]; n++)
 2f8:	4501                	li	a0,0
 2fa:	bfdd                	j	2f0 <strlen+0x20>

00000000000002fc <memset>:

void *
memset(void *dst, int c, uint n)
{
 2fc:	1141                	addi	sp,sp,-16
 2fe:	e406                	sd	ra,8(sp)
 300:	e022                	sd	s0,0(sp)
 302:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 304:	ca19                	beqz	a2,31a <memset+0x1e>
 306:	87aa                	mv	a5,a0
 308:	1602                	slli	a2,a2,0x20
 30a:	9201                	srli	a2,a2,0x20
 30c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 310:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 314:	0785                	addi	a5,a5,1
 316:	fee79de3          	bne	a5,a4,310 <memset+0x14>
  }
  return dst;
}
 31a:	60a2                	ld	ra,8(sp)
 31c:	6402                	ld	s0,0(sp)
 31e:	0141                	addi	sp,sp,16
 320:	8082                	ret

0000000000000322 <strchr>:

char *
strchr(const char *s, char c)
{
 322:	1141                	addi	sp,sp,-16
 324:	e406                	sd	ra,8(sp)
 326:	e022                	sd	s0,0(sp)
 328:	0800                	addi	s0,sp,16
  for (; *s; s++)
 32a:	00054783          	lbu	a5,0(a0)
 32e:	c799                	beqz	a5,33c <strchr+0x1a>
    if (*s == c)
 330:	00f58763          	beq	a1,a5,33e <strchr+0x1c>
  for (; *s; s++)
 334:	0505                	addi	a0,a0,1
 336:	00054783          	lbu	a5,0(a0)
 33a:	fbfd                	bnez	a5,330 <strchr+0xe>
      return (char *)s;
  return 0;
 33c:	4501                	li	a0,0
}
 33e:	60a2                	ld	ra,8(sp)
 340:	6402                	ld	s0,0(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret

0000000000000346 <gets>:

char *
gets(char *buf, int max)
{
 346:	711d                	addi	sp,sp,-96
 348:	ec86                	sd	ra,88(sp)
 34a:	e8a2                	sd	s0,80(sp)
 34c:	e4a6                	sd	s1,72(sp)
 34e:	e0ca                	sd	s2,64(sp)
 350:	fc4e                	sd	s3,56(sp)
 352:	f852                	sd	s4,48(sp)
 354:	f456                	sd	s5,40(sp)
 356:	f05a                	sd	s6,32(sp)
 358:	ec5e                	sd	s7,24(sp)
 35a:	e862                	sd	s8,16(sp)
 35c:	1080                	addi	s0,sp,96
 35e:	8baa                	mv	s7,a0
 360:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 362:	892a                	mv	s2,a0
 364:	4481                	li	s1,0
    cc = read(0, &c, 1);
 366:	faf40b13          	addi	s6,s0,-81
 36a:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 36c:	8c26                	mv	s8,s1
 36e:	0014899b          	addiw	s3,s1,1
 372:	84ce                	mv	s1,s3
 374:	0349d863          	bge	s3,s4,3a4 <gets+0x5e>
    cc = read(0, &c, 1);
 378:	8656                	mv	a2,s5
 37a:	85da                	mv	a1,s6
 37c:	4501                	li	a0,0
 37e:	1c0000ef          	jal	53e <read>
    if (cc < 1)
 382:	02a05163          	blez	a0,3a4 <gets+0x5e>
      break;
    buf[i++] = c;
 386:	faf44783          	lbu	a5,-81(s0)
 38a:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 38e:	0905                	addi	s2,s2,1
 390:	ff678713          	addi	a4,a5,-10
 394:	00173713          	seqz	a4,a4
 398:	17cd                	addi	a5,a5,-13
 39a:	0017b793          	seqz	a5,a5
 39e:	8fd9                	or	a5,a5,a4
 3a0:	d7f1                	beqz	a5,36c <gets+0x26>
    buf[i++] = c;
 3a2:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 3a4:	9c5e                	add	s8,s8,s7
 3a6:	000c0023          	sb	zero,0(s8)
  return buf;
}
 3aa:	855e                	mv	a0,s7
 3ac:	60e6                	ld	ra,88(sp)
 3ae:	6446                	ld	s0,80(sp)
 3b0:	64a6                	ld	s1,72(sp)
 3b2:	6906                	ld	s2,64(sp)
 3b4:	79e2                	ld	s3,56(sp)
 3b6:	7a42                	ld	s4,48(sp)
 3b8:	7aa2                	ld	s5,40(sp)
 3ba:	7b02                	ld	s6,32(sp)
 3bc:	6be2                	ld	s7,24(sp)
 3be:	6c42                	ld	s8,16(sp)
 3c0:	6125                	addi	sp,sp,96
 3c2:	8082                	ret

00000000000003c4 <stat>:

int
stat(const char *n, struct stat *st)
{
 3c4:	1101                	addi	sp,sp,-32
 3c6:	ec06                	sd	ra,24(sp)
 3c8:	e822                	sd	s0,16(sp)
 3ca:	e04a                	sd	s2,0(sp)
 3cc:	1000                	addi	s0,sp,32
 3ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3d0:	4581                	li	a1,0
 3d2:	194000ef          	jal	566 <open>
  if (fd < 0)
 3d6:	02054263          	bltz	a0,3fa <stat+0x36>
 3da:	e426                	sd	s1,8(sp)
 3dc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3de:	85ca                	mv	a1,s2
 3e0:	19e000ef          	jal	57e <fstat>
 3e4:	892a                	mv	s2,a0
  close(fd);
 3e6:	8526                	mv	a0,s1
 3e8:	166000ef          	jal	54e <close>
  return r;
 3ec:	64a2                	ld	s1,8(sp)
}
 3ee:	854a                	mv	a0,s2
 3f0:	60e2                	ld	ra,24(sp)
 3f2:	6442                	ld	s0,16(sp)
 3f4:	6902                	ld	s2,0(sp)
 3f6:	6105                	addi	sp,sp,32
 3f8:	8082                	ret
    return -1;
 3fa:	57fd                	li	a5,-1
 3fc:	893e                	mv	s2,a5
 3fe:	bfc5                	j	3ee <stat+0x2a>

0000000000000400 <atoi>:

int
atoi(const char *s)
{
 400:	1141                	addi	sp,sp,-16
 402:	e406                	sd	ra,8(sp)
 404:	e022                	sd	s0,0(sp)
 406:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 408:	00054683          	lbu	a3,0(a0)
 40c:	fd06879b          	addiw	a5,a3,-48
 410:	0ff7f793          	zext.b	a5,a5
 414:	4625                	li	a2,9
 416:	02f66963          	bltu	a2,a5,448 <atoi+0x48>
 41a:	872a                	mv	a4,a0
  n = 0;
 41c:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 41e:	0705                	addi	a4,a4,1
 420:	0025179b          	slliw	a5,a0,0x2
 424:	9fa9                	addw	a5,a5,a0
 426:	0017979b          	slliw	a5,a5,0x1
 42a:	9fb5                	addw	a5,a5,a3
 42c:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 430:	00074683          	lbu	a3,0(a4)
 434:	fd06879b          	addiw	a5,a3,-48
 438:	0ff7f793          	zext.b	a5,a5
 43c:	fef671e3          	bgeu	a2,a5,41e <atoi+0x1e>
  return n;
}
 440:	60a2                	ld	ra,8(sp)
 442:	6402                	ld	s0,0(sp)
 444:	0141                	addi	sp,sp,16
 446:	8082                	ret
  n = 0;
 448:	4501                	li	a0,0
 44a:	bfdd                	j	440 <atoi+0x40>

000000000000044c <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 44c:	1141                	addi	sp,sp,-16
 44e:	e406                	sd	ra,8(sp)
 450:	e022                	sd	s0,0(sp)
 452:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 454:	02b57563          	bgeu	a0,a1,47e <memmove+0x32>
    while (n-- > 0)
 458:	00c05f63          	blez	a2,476 <memmove+0x2a>
 45c:	1602                	slli	a2,a2,0x20
 45e:	9201                	srli	a2,a2,0x20
 460:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 464:	872a                	mv	a4,a0
      *dst++ = *src++;
 466:	0585                	addi	a1,a1,1
 468:	0705                	addi	a4,a4,1
 46a:	fff5c683          	lbu	a3,-1(a1)
 46e:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 472:	fee79ae3          	bne	a5,a4,466 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 476:	60a2                	ld	ra,8(sp)
 478:	6402                	ld	s0,0(sp)
 47a:	0141                	addi	sp,sp,16
 47c:	8082                	ret
    while (n-- > 0)
 47e:	fec05ce3          	blez	a2,476 <memmove+0x2a>
    dst += n;
 482:	00c50733          	add	a4,a0,a2
    src += n;
 486:	95b2                	add	a1,a1,a2
 488:	fff6079b          	addiw	a5,a2,-1
 48c:	1782                	slli	a5,a5,0x20
 48e:	9381                	srli	a5,a5,0x20
 490:	fff7c793          	not	a5,a5
 494:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 496:	15fd                	addi	a1,a1,-1
 498:	177d                	addi	a4,a4,-1
 49a:	0005c683          	lbu	a3,0(a1)
 49e:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 4a2:	fef71ae3          	bne	a4,a5,496 <memmove+0x4a>
 4a6:	bfc1                	j	476 <memmove+0x2a>

00000000000004a8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4a8:	1141                	addi	sp,sp,-16
 4aa:	e406                	sd	ra,8(sp)
 4ac:	e022                	sd	s0,0(sp)
 4ae:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4b0:	ce19                	beqz	a2,4ce <memcmp+0x26>
 4b2:	1602                	slli	a2,a2,0x20
 4b4:	9201                	srli	a2,a2,0x20
 4b6:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 4ba:	00054783          	lbu	a5,0(a0)
 4be:	0005c703          	lbu	a4,0(a1)
 4c2:	00e79b63          	bne	a5,a4,4d8 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 4c6:	0505                	addi	a0,a0,1
    p2++;
 4c8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4ca:	fed518e3          	bne	a0,a3,4ba <memcmp+0x12>
  }
  return 0;
 4ce:	4501                	li	a0,0
}
 4d0:	60a2                	ld	ra,8(sp)
 4d2:	6402                	ld	s0,0(sp)
 4d4:	0141                	addi	sp,sp,16
 4d6:	8082                	ret
      return *p1 - *p2;
 4d8:	40e7853b          	subw	a0,a5,a4
 4dc:	bfd5                	j	4d0 <memcmp+0x28>

00000000000004de <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4de:	1141                	addi	sp,sp,-16
 4e0:	e406                	sd	ra,8(sp)
 4e2:	e022                	sd	s0,0(sp)
 4e4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4e6:	f67ff0ef          	jal	44c <memmove>
}
 4ea:	60a2                	ld	ra,8(sp)
 4ec:	6402                	ld	s0,0(sp)
 4ee:	0141                	addi	sp,sp,16
 4f0:	8082                	ret

00000000000004f2 <sbrk>:

char *
sbrk(int n)
{
 4f2:	1141                	addi	sp,sp,-16
 4f4:	e406                	sd	ra,8(sp)
 4f6:	e022                	sd	s0,0(sp)
 4f8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4fa:	4585                	li	a1,1
 4fc:	0b2000ef          	jal	5ae <sys_sbrk>
}
 500:	60a2                	ld	ra,8(sp)
 502:	6402                	ld	s0,0(sp)
 504:	0141                	addi	sp,sp,16
 506:	8082                	ret

0000000000000508 <sbrklazy>:

char *
sbrklazy(int n)
{
 508:	1141                	addi	sp,sp,-16
 50a:	e406                	sd	ra,8(sp)
 50c:	e022                	sd	s0,0(sp)
 50e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 510:	4589                	li	a1,2
 512:	09c000ef          	jal	5ae <sys_sbrk>
}
 516:	60a2                	ld	ra,8(sp)
 518:	6402                	ld	s0,0(sp)
 51a:	0141                	addi	sp,sp,16
 51c:	8082                	ret

000000000000051e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 51e:	4885                	li	a7,1
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <exit>:
.global exit
exit:
 li a7, SYS_exit
 526:	4889                	li	a7,2
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <wait>:
.global wait
wait:
 li a7, SYS_wait
 52e:	488d                	li	a7,3
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 536:	4891                	li	a7,4
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <read>:
.global read
read:
 li a7, SYS_read
 53e:	4895                	li	a7,5
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <write>:
.global write
write:
 li a7, SYS_write
 546:	48c1                	li	a7,16
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <close>:
.global close
close:
 li a7, SYS_close
 54e:	48d5                	li	a7,21
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <kill>:
.global kill
kill:
 li a7, SYS_kill
 556:	4899                	li	a7,6
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <exec>:
.global exec
exec:
 li a7, SYS_exec
 55e:	489d                	li	a7,7
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <open>:
.global open
open:
 li a7, SYS_open
 566:	48bd                	li	a7,15
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 56e:	48c5                	li	a7,17
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 576:	48c9                	li	a7,18
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 57e:	48a1                	li	a7,8
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <link>:
.global link
link:
 li a7, SYS_link
 586:	48cd                	li	a7,19
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 58e:	48d1                	li	a7,20
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 596:	48a5                	li	a7,9
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <dup>:
.global dup
dup:
 li a7, SYS_dup
 59e:	48a9                	li	a7,10
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5a6:	48ad                	li	a7,11
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 5ae:	48b1                	li	a7,12
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <pause>:
.global pause
pause:
 li a7, SYS_pause
 5b6:	48b5                	li	a7,13
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5be:	48b9                	li	a7,14
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <sync>:
.global sync
sync:
 li a7, SYS_sync
 5c6:	48d9                	li	a7,22
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5ce:	48dd                	li	a7,23
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5d6:	1101                	addi	sp,sp,-32
 5d8:	ec06                	sd	ra,24(sp)
 5da:	e822                	sd	s0,16(sp)
 5dc:	1000                	addi	s0,sp,32
 5de:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5e2:	4605                	li	a2,1
 5e4:	fef40593          	addi	a1,s0,-17
 5e8:	f5fff0ef          	jal	546 <write>
}
 5ec:	60e2                	ld	ra,24(sp)
 5ee:	6442                	ld	s0,16(sp)
 5f0:	6105                	addi	sp,sp,32
 5f2:	8082                	ret

00000000000005f4 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5f4:	715d                	addi	sp,sp,-80
 5f6:	e486                	sd	ra,72(sp)
 5f8:	e0a2                	sd	s0,64(sp)
 5fa:	f84a                	sd	s2,48(sp)
 5fc:	f44e                	sd	s3,40(sp)
 5fe:	0880                	addi	s0,sp,80
 600:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 602:	00d036b3          	snez	a3,a3
 606:	03f5d793          	srli	a5,a1,0x3f
 60a:	8efd                	and	a3,a3,a5
  neg = 0;
 60c:	4301                	li	t1,0
  if (sgn && xx < 0) {
 60e:	c681                	beqz	a3,616 <printint+0x22>
    neg = 1;
    x = -xx;
 610:	40b005b3          	neg	a1,a1
    neg = 1;
 614:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 616:	fb840993          	addi	s3,s0,-72
  neg = 0;
 61a:	86ce                	mv	a3,s3
  i = 0;
 61c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 61e:	00000817          	auipc	a6,0x0
 622:	56280813          	addi	a6,a6,1378 # b80 <digits>
 626:	88ba                	mv	a7,a4
 628:	0017051b          	addiw	a0,a4,1
 62c:	872a                	mv	a4,a0
 62e:	02c5f7b3          	remu	a5,a1,a2
 632:	97c2                	add	a5,a5,a6
 634:	0007c783          	lbu	a5,0(a5)
 638:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 63c:	87ae                	mv	a5,a1
 63e:	02c5d5b3          	divu	a1,a1,a2
 642:	0685                	addi	a3,a3,1
 644:	fec7f1e3          	bgeu	a5,a2,626 <printint+0x32>
  if (neg)
 648:	00030b63          	beqz	t1,65e <printint+0x6a>
    buf[i++] = '-';
 64c:	fd040793          	addi	a5,s0,-48
 650:	953e                	add	a0,a0,a5
 652:	02d00793          	li	a5,45
 656:	fef50423          	sb	a5,-24(a0)
 65a:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 65e:	02e05563          	blez	a4,688 <printint+0x94>
 662:	fc26                	sd	s1,56(sp)
 664:	377d                	addiw	a4,a4,-1
 666:	00e984b3          	add	s1,s3,a4
 66a:	19fd                	addi	s3,s3,-1
 66c:	99ba                	add	s3,s3,a4
 66e:	1702                	slli	a4,a4,0x20
 670:	9301                	srli	a4,a4,0x20
 672:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 676:	0004c583          	lbu	a1,0(s1)
 67a:	854a                	mv	a0,s2
 67c:	f5bff0ef          	jal	5d6 <putc>
  while (--i >= 0)
 680:	14fd                	addi	s1,s1,-1
 682:	ff349ae3          	bne	s1,s3,676 <printint+0x82>
 686:	74e2                	ld	s1,56(sp)
}
 688:	60a6                	ld	ra,72(sp)
 68a:	6406                	ld	s0,64(sp)
 68c:	7942                	ld	s2,48(sp)
 68e:	79a2                	ld	s3,40(sp)
 690:	6161                	addi	sp,sp,80
 692:	8082                	ret

0000000000000694 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 694:	711d                	addi	sp,sp,-96
 696:	ec86                	sd	ra,88(sp)
 698:	e8a2                	sd	s0,80(sp)
 69a:	e4a6                	sd	s1,72(sp)
 69c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 69e:	0005c483          	lbu	s1,0(a1)
 6a2:	2a048063          	beqz	s1,942 <vprintf+0x2ae>
 6a6:	e0ca                	sd	s2,64(sp)
 6a8:	fc4e                	sd	s3,56(sp)
 6aa:	f852                	sd	s4,48(sp)
 6ac:	f456                	sd	s5,40(sp)
 6ae:	f05a                	sd	s6,32(sp)
 6b0:	ec5e                	sd	s7,24(sp)
 6b2:	e862                	sd	s8,16(sp)
 6b4:	8b2a                	mv	s6,a0
 6b6:	8a2e                	mv	s4,a1
 6b8:	8bb2                	mv	s7,a2
  state = 0;
 6ba:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 6bc:	4901                	li	s2,0
 6be:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 6c0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 6c4:	06400c13          	li	s8,100
 6c8:	a00d                	j	6ea <vprintf+0x56>
        putc(fd, c0);
 6ca:	85a6                	mv	a1,s1
 6cc:	855a                	mv	a0,s6
 6ce:	f09ff0ef          	jal	5d6 <putc>
 6d2:	a019                	j	6d8 <vprintf+0x44>
    } else if (state == '%') {
 6d4:	03598363          	beq	s3,s5,6fa <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 6d8:	0019079b          	addiw	a5,s2,1
 6dc:	893e                	mv	s2,a5
 6de:	873e                	mv	a4,a5
 6e0:	97d2                	add	a5,a5,s4
 6e2:	0007c483          	lbu	s1,0(a5)
 6e6:	24048763          	beqz	s1,934 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 6ea:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 6ee:	fe0993e3          	bnez	s3,6d4 <vprintf+0x40>
      if (c0 == '%') {
 6f2:	fd579ce3          	bne	a5,s5,6ca <vprintf+0x36>
        state = '%';
 6f6:	89be                	mv	s3,a5
 6f8:	b7c5                	j	6d8 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 6fa:	00ea06b3          	add	a3,s4,a4
 6fe:	0016c603          	lbu	a2,1(a3)
      if (c1)
 702:	24060563          	beqz	a2,94c <vprintf+0x2b8>
      if (c0 == 'd') {
 706:	0b878763          	beq	a5,s8,7b4 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 70a:	f9478693          	addi	a3,a5,-108
 70e:	0016b693          	seqz	a3,a3
 712:	f9c60593          	addi	a1,a2,-100
 716:	0015b593          	seqz	a1,a1
 71a:	8df5                	and	a1,a1,a3
 71c:	e9c5                	bnez	a1,7cc <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 71e:	9752                	add	a4,a4,s4
 720:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 724:	f9460713          	addi	a4,a2,-108
 728:	00173713          	seqz	a4,a4
 72c:	8f75                	and	a4,a4,a3
 72e:	f9c50593          	addi	a1,a0,-100
 732:	0015b593          	seqz	a1,a1
 736:	8df9                	and	a1,a1,a4
 738:	e5dd                	bnez	a1,7e6 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 73a:	07500593          	li	a1,117
 73e:	0cb78163          	beq	a5,a1,800 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 742:	f8b60593          	addi	a1,a2,-117
 746:	0015b593          	seqz	a1,a1
 74a:	8df5                	and	a1,a1,a3
 74c:	e5f1                	bnez	a1,818 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 74e:	f8b50593          	addi	a1,a0,-117
 752:	0015b593          	seqz	a1,a1
 756:	8df9                	and	a1,a1,a4
 758:	ede9                	bnez	a1,832 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 75a:	07800593          	li	a1,120
 75e:	0eb78763          	beq	a5,a1,84c <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 762:	f8860613          	addi	a2,a2,-120
 766:	00163613          	seqz	a2,a2
 76a:	8ef1                	and	a3,a3,a2
 76c:	0e069c63          	bnez	a3,864 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 770:	f8850513          	addi	a0,a0,-120
 774:	00153513          	seqz	a0,a0
 778:	8f69                	and	a4,a4,a0
 77a:	10071263          	bnez	a4,87e <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 77e:	07000713          	li	a4,112
 782:	10e78a63          	beq	a5,a4,896 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 786:	06300713          	li	a4,99
 78a:	14e78a63          	beq	a5,a4,8de <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 78e:	07300713          	li	a4,115
 792:	16e78063          	beq	a5,a4,8f2 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 796:	02500713          	li	a4,37
 79a:	18e78863          	beq	a5,a4,92a <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 79e:	02500593          	li	a1,37
 7a2:	855a                	mv	a0,s6
 7a4:	e33ff0ef          	jal	5d6 <putc>
        putc(fd, c0);
 7a8:	85a6                	mv	a1,s1
 7aa:	855a                	mv	a0,s6
 7ac:	e2bff0ef          	jal	5d6 <putc>
      }

      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	b71d                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 7b4:	008b8493          	addi	s1,s7,8
 7b8:	4685                	li	a3,1
 7ba:	4629                	li	a2,10
 7bc:	000ba583          	lw	a1,0(s7)
 7c0:	855a                	mv	a0,s6
 7c2:	e33ff0ef          	jal	5f4 <printint>
 7c6:	8ba6                	mv	s7,s1
      state = 0;
 7c8:	4981                	li	s3,0
 7ca:	b739                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7cc:	008b8493          	addi	s1,s7,8
 7d0:	4685                	li	a3,1
 7d2:	4629                	li	a2,10
 7d4:	000bb583          	ld	a1,0(s7)
 7d8:	855a                	mv	a0,s6
 7da:	e1bff0ef          	jal	5f4 <printint>
        i += 1;
 7de:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7e0:	8ba6                	mv	s7,s1
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	bdd5                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7e6:	008b8493          	addi	s1,s7,8
 7ea:	4685                	li	a3,1
 7ec:	4629                	li	a2,10
 7ee:	000bb583          	ld	a1,0(s7)
 7f2:	855a                	mv	a0,s6
 7f4:	e01ff0ef          	jal	5f4 <printint>
        i += 2;
 7f8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7fa:	8ba6                	mv	s7,s1
      state = 0;
 7fc:	4981                	li	s3,0
        i += 2;
 7fe:	bde9                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 800:	008b8493          	addi	s1,s7,8
 804:	4681                	li	a3,0
 806:	4629                	li	a2,10
 808:	000be583          	lwu	a1,0(s7)
 80c:	855a                	mv	a0,s6
 80e:	de7ff0ef          	jal	5f4 <printint>
 812:	8ba6                	mv	s7,s1
      state = 0;
 814:	4981                	li	s3,0
 816:	b5c9                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 818:	008b8493          	addi	s1,s7,8
 81c:	4681                	li	a3,0
 81e:	4629                	li	a2,10
 820:	000bb583          	ld	a1,0(s7)
 824:	855a                	mv	a0,s6
 826:	dcfff0ef          	jal	5f4 <printint>
        i += 1;
 82a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 82c:	8ba6                	mv	s7,s1
      state = 0;
 82e:	4981                	li	s3,0
 830:	b565                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 832:	008b8493          	addi	s1,s7,8
 836:	4681                	li	a3,0
 838:	4629                	li	a2,10
 83a:	000bb583          	ld	a1,0(s7)
 83e:	855a                	mv	a0,s6
 840:	db5ff0ef          	jal	5f4 <printint>
        i += 2;
 844:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 846:	8ba6                	mv	s7,s1
      state = 0;
 848:	4981                	li	s3,0
        i += 2;
 84a:	b579                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 84c:	008b8493          	addi	s1,s7,8
 850:	4681                	li	a3,0
 852:	4641                	li	a2,16
 854:	000be583          	lwu	a1,0(s7)
 858:	855a                	mv	a0,s6
 85a:	d9bff0ef          	jal	5f4 <printint>
 85e:	8ba6                	mv	s7,s1
      state = 0;
 860:	4981                	li	s3,0
 862:	bd9d                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 864:	008b8493          	addi	s1,s7,8
 868:	4681                	li	a3,0
 86a:	4641                	li	a2,16
 86c:	000bb583          	ld	a1,0(s7)
 870:	855a                	mv	a0,s6
 872:	d83ff0ef          	jal	5f4 <printint>
        i += 1;
 876:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 878:	8ba6                	mv	s7,s1
      state = 0;
 87a:	4981                	li	s3,0
 87c:	bdb1                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 87e:	008b8493          	addi	s1,s7,8
 882:	4641                	li	a2,16
 884:	000bb583          	ld	a1,0(s7)
 888:	855a                	mv	a0,s6
 88a:	d6bff0ef          	jal	5f4 <printint>
        i += 2;
 88e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 890:	8ba6                	mv	s7,s1
      state = 0;
 892:	4981                	li	s3,0
        i += 2;
 894:	b591                	j	6d8 <vprintf+0x44>
 896:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 898:	008b8793          	addi	a5,s7,8
 89c:	8cbe                	mv	s9,a5
 89e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8a2:	03000593          	li	a1,48
 8a6:	855a                	mv	a0,s6
 8a8:	d2fff0ef          	jal	5d6 <putc>
  putc(fd, 'x');
 8ac:	07800593          	li	a1,120
 8b0:	855a                	mv	a0,s6
 8b2:	d25ff0ef          	jal	5d6 <putc>
 8b6:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8b8:	00000b97          	auipc	s7,0x0
 8bc:	2c8b8b93          	addi	s7,s7,712 # b80 <digits>
 8c0:	03c9d793          	srli	a5,s3,0x3c
 8c4:	97de                	add	a5,a5,s7
 8c6:	0007c583          	lbu	a1,0(a5)
 8ca:	855a                	mv	a0,s6
 8cc:	d0bff0ef          	jal	5d6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8d0:	0992                	slli	s3,s3,0x4
 8d2:	34fd                	addiw	s1,s1,-1
 8d4:	f4f5                	bnez	s1,8c0 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 8d6:	8be6                	mv	s7,s9
      state = 0;
 8d8:	4981                	li	s3,0
 8da:	6ca2                	ld	s9,8(sp)
 8dc:	bbf5                	j	6d8 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 8de:	008b8493          	addi	s1,s7,8
 8e2:	000bc583          	lbu	a1,0(s7)
 8e6:	855a                	mv	a0,s6
 8e8:	cefff0ef          	jal	5d6 <putc>
 8ec:	8ba6                	mv	s7,s1
      state = 0;
 8ee:	4981                	li	s3,0
 8f0:	b3e5                	j	6d8 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 8f2:	008b8993          	addi	s3,s7,8
 8f6:	000bb483          	ld	s1,0(s7)
 8fa:	cc91                	beqz	s1,916 <vprintf+0x282>
        for (; *s; s++)
 8fc:	0004c583          	lbu	a1,0(s1)
 900:	c195                	beqz	a1,924 <vprintf+0x290>
          putc(fd, *s);
 902:	855a                	mv	a0,s6
 904:	cd3ff0ef          	jal	5d6 <putc>
        for (; *s; s++)
 908:	0485                	addi	s1,s1,1
 90a:	0004c583          	lbu	a1,0(s1)
 90e:	f9f5                	bnez	a1,902 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 910:	8bce                	mv	s7,s3
      state = 0;
 912:	4981                	li	s3,0
 914:	b3d1                	j	6d8 <vprintf+0x44>
          s = "(null)";
 916:	00000497          	auipc	s1,0x0
 91a:	26248493          	addi	s1,s1,610 # b78 <malloc+0x130>
        for (; *s; s++)
 91e:	02800593          	li	a1,40
 922:	b7c5                	j	902 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 924:	8bce                	mv	s7,s3
      state = 0;
 926:	4981                	li	s3,0
 928:	bb45                	j	6d8 <vprintf+0x44>
        putc(fd, '%');
 92a:	85be                	mv	a1,a5
 92c:	855a                	mv	a0,s6
 92e:	ca9ff0ef          	jal	5d6 <putc>
 932:	bdbd                	j	7b0 <vprintf+0x11c>
 934:	6906                	ld	s2,64(sp)
 936:	79e2                	ld	s3,56(sp)
 938:	7a42                	ld	s4,48(sp)
 93a:	7aa2                	ld	s5,40(sp)
 93c:	7b02                	ld	s6,32(sp)
 93e:	6be2                	ld	s7,24(sp)
 940:	6c42                	ld	s8,16(sp)
    }
  }
}
 942:	60e6                	ld	ra,88(sp)
 944:	6446                	ld	s0,80(sp)
 946:	64a6                	ld	s1,72(sp)
 948:	6125                	addi	sp,sp,96
 94a:	8082                	ret
      if (c0 == 'd') {
 94c:	06400713          	li	a4,100
 950:	e6e782e3          	beq	a5,a4,7b4 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 954:	f9478693          	addi	a3,a5,-108
 958:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 95c:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 95e:	4701                	li	a4,0
 960:	bbe9                	j	73a <vprintf+0xa6>

0000000000000962 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 962:	715d                	addi	sp,sp,-80
 964:	ec06                	sd	ra,24(sp)
 966:	e822                	sd	s0,16(sp)
 968:	1000                	addi	s0,sp,32
 96a:	e010                	sd	a2,0(s0)
 96c:	e414                	sd	a3,8(s0)
 96e:	e818                	sd	a4,16(s0)
 970:	ec1c                	sd	a5,24(s0)
 972:	03043023          	sd	a6,32(s0)
 976:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 97a:	8622                	mv	a2,s0
 97c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 980:	d15ff0ef          	jal	694 <vprintf>
}
 984:	60e2                	ld	ra,24(sp)
 986:	6442                	ld	s0,16(sp)
 988:	6161                	addi	sp,sp,80
 98a:	8082                	ret

000000000000098c <printf>:

void
printf(const char *fmt, ...)
{
 98c:	711d                	addi	sp,sp,-96
 98e:	ec06                	sd	ra,24(sp)
 990:	e822                	sd	s0,16(sp)
 992:	1000                	addi	s0,sp,32
 994:	e40c                	sd	a1,8(s0)
 996:	e810                	sd	a2,16(s0)
 998:	ec14                	sd	a3,24(s0)
 99a:	f018                	sd	a4,32(s0)
 99c:	f41c                	sd	a5,40(s0)
 99e:	03043823          	sd	a6,48(s0)
 9a2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9a6:	00840613          	addi	a2,s0,8
 9aa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9ae:	85aa                	mv	a1,a0
 9b0:	4505                	li	a0,1
 9b2:	ce3ff0ef          	jal	694 <vprintf>
}
 9b6:	60e2                	ld	ra,24(sp)
 9b8:	6442                	ld	s0,16(sp)
 9ba:	6125                	addi	sp,sp,96
 9bc:	8082                	ret

00000000000009be <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9be:	1141                	addi	sp,sp,-16
 9c0:	e406                	sd	ra,8(sp)
 9c2:	e022                	sd	s0,0(sp)
 9c4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 9c6:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ca:	00001797          	auipc	a5,0x1
 9ce:	6367b783          	ld	a5,1590(a5) # 2000 <freep>
 9d2:	a095                	j	a36 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 9d4:	ff852583          	lw	a1,-8(a0)
 9d8:	6390                	ld	a2,0(a5)
 9da:	02059813          	slli	a6,a1,0x20
 9de:	01c85693          	srli	a3,a6,0x1c
 9e2:	96ba                	add	a3,a3,a4
 9e4:	02d60563          	beq	a2,a3,a0e <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 9e8:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 9ec:	4790                	lw	a2,8(a5)
 9ee:	02061593          	slli	a1,a2,0x20
 9f2:	01c5d693          	srli	a3,a1,0x1c
 9f6:	96be                	add	a3,a3,a5
 9f8:	02d70263          	beq	a4,a3,a1c <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 9fc:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9fe:	00001717          	auipc	a4,0x1
 a02:	60f73123          	sd	a5,1538(a4) # 2000 <freep>
}
 a06:	60a2                	ld	ra,8(sp)
 a08:	6402                	ld	s0,0(sp)
 a0a:	0141                	addi	sp,sp,16
 a0c:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 a0e:	4614                	lw	a3,8(a2)
 a10:	9ead                	addw	a3,a3,a1
 a12:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a16:	6394                	ld	a3,0(a5)
 a18:	6290                	ld	a2,0(a3)
 a1a:	b7f9                	j	9e8 <free+0x2a>
    p->s.size += bp->s.size;
 a1c:	ff852703          	lw	a4,-8(a0)
 a20:	9f31                	addw	a4,a4,a2
 a22:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a24:	ff053703          	ld	a4,-16(a0)
 a28:	bfd1                	j	9fc <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a2a:	6394                	ld	a3,0(a5)
 a2c:	00d7e463          	bltu	a5,a3,a34 <free+0x76>
 a30:	fad762e3          	bltu	a4,a3,9d4 <free+0x16>
 a34:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a36:	fee7fae3          	bgeu	a5,a4,a2a <free+0x6c>
 a3a:	6394                	ld	a3,0(a5)
 a3c:	f8d76ce3          	bltu	a4,a3,9d4 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a40:	f8d7fae3          	bgeu	a5,a3,9d4 <free+0x16>
 a44:	87b6                	mv	a5,a3
 a46:	bfc5                	j	a36 <free+0x78>

0000000000000a48 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 a48:	7139                	addi	sp,sp,-64
 a4a:	fc06                	sd	ra,56(sp)
 a4c:	f822                	sd	s0,48(sp)
 a4e:	f04a                	sd	s2,32(sp)
 a50:	ec4e                	sd	s3,24(sp)
 a52:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 a54:	02051993          	slli	s3,a0,0x20
 a58:	0209d993          	srli	s3,s3,0x20
 a5c:	09bd                	addi	s3,s3,15
 a5e:	0049d993          	srli	s3,s3,0x4
 a62:	2985                	addiw	s3,s3,1
 a64:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 a66:	00001517          	auipc	a0,0x1
 a6a:	59a53503          	ld	a0,1434(a0) # 2000 <freep>
 a6e:	c905                	beqz	a0,a9e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 a70:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 a72:	4798                	lw	a4,8(a5)
 a74:	09377663          	bgeu	a4,s3,b00 <malloc+0xb8>
 a78:	f426                	sd	s1,40(sp)
 a7a:	e852                	sd	s4,16(sp)
 a7c:	e456                	sd	s5,8(sp)
 a7e:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 a80:	8a4e                	mv	s4,s3
 a82:	6705                	lui	a4,0x1
 a84:	00e9f363          	bgeu	s3,a4,a8a <malloc+0x42>
 a88:	6a05                	lui	s4,0x1
 a8a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a8e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 a92:	00001497          	auipc	s1,0x1
 a96:	56e48493          	addi	s1,s1,1390 # 2000 <freep>
  if (p == SBRK_ERROR)
 a9a:	5afd                	li	s5,-1
 a9c:	a83d                	j	ada <malloc+0x92>
 a9e:	f426                	sd	s1,40(sp)
 aa0:	e852                	sd	s4,16(sp)
 aa2:	e456                	sd	s5,8(sp)
 aa4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 aa6:	00002797          	auipc	a5,0x2
 aaa:	96a78793          	addi	a5,a5,-1686 # 2410 <base>
 aae:	00001717          	auipc	a4,0x1
 ab2:	54f73923          	sd	a5,1362(a4) # 2000 <freep>
 ab6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ab8:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 abc:	b7d1                	j	a80 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 abe:	6398                	ld	a4,0(a5)
 ac0:	e118                	sd	a4,0(a0)
 ac2:	a899                	j	b18 <malloc+0xd0>
  hp->s.size = nu;
 ac4:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 ac8:	0541                	addi	a0,a0,16
 aca:	ef5ff0ef          	jal	9be <free>
  return freep;
 ace:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 ad0:	c125                	beqz	a0,b30 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 ad2:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 ad4:	4798                	lw	a4,8(a5)
 ad6:	03277163          	bgeu	a4,s2,af8 <malloc+0xb0>
    if (p == freep)
 ada:	6098                	ld	a4,0(s1)
 adc:	853e                	mv	a0,a5
 ade:	fef71ae3          	bne	a4,a5,ad2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 ae2:	8552                	mv	a0,s4
 ae4:	a0fff0ef          	jal	4f2 <sbrk>
  if (p == SBRK_ERROR)
 ae8:	fd551ee3          	bne	a0,s5,ac4 <malloc+0x7c>
        return 0;
 aec:	4501                	li	a0,0
 aee:	74a2                	ld	s1,40(sp)
 af0:	6a42                	ld	s4,16(sp)
 af2:	6aa2                	ld	s5,8(sp)
 af4:	6b02                	ld	s6,0(sp)
 af6:	a03d                	j	b24 <malloc+0xdc>
 af8:	74a2                	ld	s1,40(sp)
 afa:	6a42                	ld	s4,16(sp)
 afc:	6aa2                	ld	s5,8(sp)
 afe:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 b00:	fae90fe3          	beq	s2,a4,abe <malloc+0x76>
        p->s.size -= nunits;
 b04:	4137073b          	subw	a4,a4,s3
 b08:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b0a:	02071693          	slli	a3,a4,0x20
 b0e:	01c6d713          	srli	a4,a3,0x1c
 b12:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b14:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b18:	00001717          	auipc	a4,0x1
 b1c:	4ea73423          	sd	a0,1256(a4) # 2000 <freep>
      return (void *)(p + 1);
 b20:	01078513          	addi	a0,a5,16
  }
}
 b24:	70e2                	ld	ra,56(sp)
 b26:	7442                	ld	s0,48(sp)
 b28:	7902                	ld	s2,32(sp)
 b2a:	69e2                	ld	s3,24(sp)
 b2c:	6121                	addi	sp,sp,64
 b2e:	8082                	ret
 b30:	74a2                	ld	s1,40(sp)
 b32:	6a42                	ld	s4,16(sp)
 b34:	6aa2                	ld	s5,8(sp)
 b36:	6b02                	ld	s6,0(sp)
 b38:	b7f5                	j	b24 <malloc+0xdc>
