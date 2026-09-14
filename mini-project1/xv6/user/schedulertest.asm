
user/_schedulertest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <spin>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#define SPIN_COUNT 50000000
static void spin(int iters) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  volatile long x = 0;
   8:	fe043423          	sd	zero,-24(s0)
  long long total_iters = (long long)iters * SPIN_COUNT; 
   c:	02faf7b7          	lui	a5,0x2faf
  10:	08078793          	addi	a5,a5,128 # 2faf080 <base+0x2fae070>
  14:	02f50533          	mul	a0,a0,a5
  for(long long i = 0; i < total_iters; i++)
  18:	00a05b63          	blez	a0,2e <spin+0x2e>
  1c:	4781                	li	a5,0
    x += i;
  1e:	fe843703          	ld	a4,-24(s0)
  22:	973e                	add	a4,a4,a5
  24:	fee43423          	sd	a4,-24(s0)
  for(long long i = 0; i < total_iters; i++)
  28:	0785                	addi	a5,a5,1
  2a:	fea7cae3          	blt	a5,a0,1e <spin+0x1e>
  (void)x;
  2e:	fe843783          	ld	a5,-24(s0)
}
  32:	60e2                	ld	ra,24(sp)
  34:	6442                	ld	s0,16(sp)
  36:	6105                	addi	sp,sp,32
  38:	8082                	ret

000000000000003a <main>:

int
main(void)
{
  3a:	711d                	addi	sp,sp,-96
  3c:	ec86                	sd	ra,88(sp)
  3e:	e8a2                	sd	s0,80(sp)
  40:	e4a6                	sd	s1,72(sp)
  42:	e0ca                	sd	s2,64(sp)
  44:	fc4e                	sd	s3,56(sp)
  46:	f852                	sd	s4,48(sp)
  48:	f456                	sd	s5,40(sp)
  4a:	f05a                	sd	s6,32(sp)
  4c:	1080                	addi	s0,sp,96
  int pids[5];
  uint start = uptime();
  4e:	4a4000ef          	jal	4f2 <uptime>
  52:	8aaa                	mv	s5,a0

  for(int i = 0; i < 5; i++){
  54:	fa840913          	addi	s2,s0,-88
  uint start = uptime();
  58:	8a4a                	mv	s4,s2
  for(int i = 0; i < 5; i++){
  5a:	4981                	li	s3,0
  5c:	4b15                	li	s6,5
    int pid = fork();
  5e:	3f4000ef          	jal	452 <fork>
  62:	84aa                	mv	s1,a0
    if(pid < 0){
  64:	06054e63          	bltz	a0,e0 <main+0xa6>
      printf("fork failed\n");
      exit(1);
    }
    if(pid == 0){
  68:	c549                	beqz	a0,f2 <main+0xb8>
      int cpu_spin_ticks = (child_end - child_start) - sleep_ticks;
      printf("CHILDSTATS,%d,%d,%d,%d\n",
             getpid(), child_start, child_end, cpu_spin_ticks);
      exit(0);
    }
    pids[i] = pid;
  6a:	00aa2023          	sw	a0,0(s4)
  for(int i = 0; i < 5; i++){
  6e:	2985                	addiw	s3,s3,1
  70:	0a11                	addi	s4,s4,4
  72:	ff6996e3          	bne	s3,s6,5e <main+0x24>
  }

  printf("schedulertest: spawned 5 children (pids");
  76:	00001517          	auipc	a0,0x1
  7a:	a2a50513          	addi	a0,a0,-1494 # aa0 <malloc+0x124>
  7e:	043000ef          	jal	8c0 <printf>
  for(int i = 0; i < 5; i++)
  82:	01490993          	addi	s3,s2,20
    printf(" %d", pids[i]);
  86:	00001497          	auipc	s1,0x1
  8a:	a4248493          	addi	s1,s1,-1470 # ac8 <malloc+0x14c>
  8e:	00092583          	lw	a1,0(s2)
  92:	8526                	mv	a0,s1
  94:	02d000ef          	jal	8c0 <printf>
  for(int i = 0; i < 5; i++)
  98:	0911                	addi	s2,s2,4
  9a:	ff299ae3          	bne	s3,s2,8e <main+0x54>
  printf(") start_tick=%d\n", start);
  9e:	85d6                	mv	a1,s5
  a0:	00001517          	auipc	a0,0x1
  a4:	a3050513          	addi	a0,a0,-1488 # ad0 <malloc+0x154>
  a8:	019000ef          	jal	8c0 <printf>
  ac:	4495                	li	s1,5

  for(int i = 0; i < 5; i++)
    wait(0);
  ae:	4501                	li	a0,0
  b0:	3b2000ef          	jal	462 <wait>
  for(int i = 0; i < 5; i++)
  b4:	34fd                	addiw	s1,s1,-1
  b6:	fce5                	bnez	s1,ae <main+0x74>

  uint end = uptime();
  b8:	43a000ef          	jal	4f2 <uptime>
  bc:	85aa                	mv	a1,a0
  printf("schedulertest: all done, end_tick=%d total_ticks=%d\n",
  be:	4155063b          	subw	a2,a0,s5
  c2:	00001517          	auipc	a0,0x1
  c6:	a2650513          	addi	a0,a0,-1498 # ae8 <malloc+0x16c>
  ca:	7f6000ef          	jal	8c0 <printf>
         end, end - start);

  printf("SCHEDTEST_DONE\n");
  ce:	00001517          	auipc	a0,0x1
  d2:	a5250513          	addi	a0,a0,-1454 # b20 <malloc+0x1a4>
  d6:	7ea000ef          	jal	8c0 <printf>
  exit(0);
  da:	4501                	li	a0,0
  dc:	37e000ef          	jal	45a <exit>
      printf("fork failed\n");
  e0:	00001517          	auipc	a0,0x1
  e4:	99050513          	addi	a0,a0,-1648 # a70 <malloc+0xf4>
  e8:	7d8000ef          	jal	8c0 <printf>
      exit(1);
  ec:	4505                	li	a0,1
  ee:	36c000ef          	jal	45a <exit>
      uint child_start = uptime();
  f2:	400000ef          	jal	4f2 <uptime>
  f6:	892a                	mv	s2,a0
      switch(i){
  f8:	4791                	li	a5,4
  fa:	0337e163          	bltu	a5,s3,11c <main+0xe2>
  fe:	00299793          	slli	a5,s3,0x2
 102:	00001717          	auipc	a4,0x1
 106:	a3670713          	addi	a4,a4,-1482 # b38 <malloc+0x1bc>
 10a:	97ba                	add	a5,a5,a4
 10c:	439c                	lw	a5,0(a5)
 10e:	97ba                	add	a5,a5,a4
 110:	8782                	jr	a5
        spin(100);
 112:	06400513          	li	a0,100
 116:	eebff0ef          	jal	0 <spin>
      int sleep_ticks = 0;
 11a:	84ce                	mv	s1,s3
      uint child_end = uptime();
 11c:	3d6000ef          	jal	4f2 <uptime>
 120:	89aa                	mv	s3,a0
      printf("CHILDSTATS,%d,%d,%d,%d\n",
 122:	3b8000ef          	jal	4da <getpid>
 126:	85aa                	mv	a1,a0
      int cpu_spin_ticks = (child_end - child_start) - sleep_ticks;
 128:	4129873b          	subw	a4,s3,s2
      printf("CHILDSTATS,%d,%d,%d,%d\n",
 12c:	9f05                	subw	a4,a4,s1
 12e:	86ce                	mv	a3,s3
 130:	864a                	mv	a2,s2
 132:	00001517          	auipc	a0,0x1
 136:	95650513          	addi	a0,a0,-1706 # a88 <malloc+0x10c>
 13a:	786000ef          	jal	8c0 <printf>
      exit(0);
 13e:	4501                	li	a0,0
 140:	31a000ef          	jal	45a <exit>
        spin(8);
 144:	4521                	li	a0,8
 146:	ebbff0ef          	jal	0 <spin>
        break;
 14a:	bfc9                	j	11c <main+0xe2>
        spin(3); sleep(2); sleep_ticks += 2;
 14c:	450d                	li	a0,3
 14e:	eb3ff0ef          	jal	0 <spin>
 152:	4509                	li	a0,2
 154:	3ae000ef          	jal	502 <sleep>
        spin(3); sleep(2); sleep_ticks += 2;
 158:	450d                	li	a0,3
 15a:	ea7ff0ef          	jal	0 <spin>
 15e:	4509                	li	a0,2
 160:	3a2000ef          	jal	502 <sleep>
        spin(3);
 164:	450d                	li	a0,3
 166:	e9bff0ef          	jal	0 <spin>
        spin(3); sleep(2); sleep_ticks += 2;
 16a:	4491                	li	s1,4
        break;
 16c:	bf45                	j	11c <main+0xe2>
      switch(i){
 16e:	4491                	li	s1,4
          spin(1);
 170:	4a05                	li	s4,1
          sleep(8);
 172:	49a1                	li	s3,8
          spin(1);
 174:	8552                	mv	a0,s4
 176:	e8bff0ef          	jal	0 <spin>
          sleep(8);
 17a:	854e                	mv	a0,s3
 17c:	386000ef          	jal	502 <sleep>
        for(int r = 0; r < 4; r++){
 180:	34fd                	addiw	s1,s1,-1
 182:	f8ed                	bnez	s1,174 <main+0x13a>
 184:	02000493          	li	s1,32
 188:	bf51                	j	11c <main+0xe2>
      switch(i){
 18a:	4499                	li	s1,6
          spin(1);
 18c:	4a05                	li	s4,1
          sleep(5);
 18e:	4995                	li	s3,5
          spin(1);
 190:	8552                	mv	a0,s4
 192:	e6fff0ef          	jal	0 <spin>
          sleep(5);
 196:	854e                	mv	a0,s3
 198:	36a000ef          	jal	502 <sleep>
        for(int r = 0; r < 6; r++){
 19c:	34fd                	addiw	s1,s1,-1
 19e:	f8ed                	bnez	s1,190 <main+0x156>
 1a0:	44f9                	li	s1,30
 1a2:	bfad                	j	11c <main+0xe2>

00000000000001a4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e406                	sd	ra,8(sp)
 1a8:	e022                	sd	s0,0(sp)
 1aa:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 1ac:	e8fff0ef          	jal	3a <main>
  exit(r);
 1b0:	2aa000ef          	jal	45a <exit>

00000000000001b4 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 1b4:	1141                	addi	sp,sp,-16
 1b6:	e406                	sd	ra,8(sp)
 1b8:	e022                	sd	s0,0(sp)
 1ba:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 1bc:	87aa                	mv	a5,a0
 1be:	0585                	addi	a1,a1,1
 1c0:	0785                	addi	a5,a5,1
 1c2:	fff5c703          	lbu	a4,-1(a1)
 1c6:	fee78fa3          	sb	a4,-1(a5)
 1ca:	fb75                	bnez	a4,1be <strcpy+0xa>
    ;
  return os;
}
 1cc:	60a2                	ld	ra,8(sp)
 1ce:	6402                	ld	s0,0(sp)
 1d0:	0141                	addi	sp,sp,16
 1d2:	8082                	ret

00000000000001d4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1d4:	1141                	addi	sp,sp,-16
 1d6:	e406                	sd	ra,8(sp)
 1d8:	e022                	sd	s0,0(sp)
 1da:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 1dc:	00054783          	lbu	a5,0(a0)
 1e0:	cb91                	beqz	a5,1f4 <strcmp+0x20>
 1e2:	0005c703          	lbu	a4,0(a1)
 1e6:	00f71763          	bne	a4,a5,1f4 <strcmp+0x20>
    p++, q++;
 1ea:	0505                	addi	a0,a0,1
 1ec:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 1ee:	00054783          	lbu	a5,0(a0)
 1f2:	fbe5                	bnez	a5,1e2 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 1f4:	0005c503          	lbu	a0,0(a1)
}
 1f8:	40a7853b          	subw	a0,a5,a0
 1fc:	60a2                	ld	ra,8(sp)
 1fe:	6402                	ld	s0,0(sp)
 200:	0141                	addi	sp,sp,16
 202:	8082                	ret

0000000000000204 <strlen>:

uint
strlen(const char *s)
{
 204:	1141                	addi	sp,sp,-16
 206:	e406                	sd	ra,8(sp)
 208:	e022                	sd	s0,0(sp)
 20a:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 20c:	00054783          	lbu	a5,0(a0)
 210:	cf91                	beqz	a5,22c <strlen+0x28>
 212:	00150793          	addi	a5,a0,1
 216:	86be                	mv	a3,a5
 218:	0785                	addi	a5,a5,1
 21a:	fff7c703          	lbu	a4,-1(a5)
 21e:	ff65                	bnez	a4,216 <strlen+0x12>
 220:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 224:	60a2                	ld	ra,8(sp)
 226:	6402                	ld	s0,0(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret
  for (n = 0; s[n]; n++)
 22c:	4501                	li	a0,0
 22e:	bfdd                	j	224 <strlen+0x20>

0000000000000230 <memset>:

void *
memset(void *dst, int c, uint n)
{
 230:	1141                	addi	sp,sp,-16
 232:	e406                	sd	ra,8(sp)
 234:	e022                	sd	s0,0(sp)
 236:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 238:	ca19                	beqz	a2,24e <memset+0x1e>
 23a:	87aa                	mv	a5,a0
 23c:	1602                	slli	a2,a2,0x20
 23e:	9201                	srli	a2,a2,0x20
 240:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 244:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 248:	0785                	addi	a5,a5,1
 24a:	fee79de3          	bne	a5,a4,244 <memset+0x14>
  }
  return dst;
}
 24e:	60a2                	ld	ra,8(sp)
 250:	6402                	ld	s0,0(sp)
 252:	0141                	addi	sp,sp,16
 254:	8082                	ret

0000000000000256 <strchr>:

char *
strchr(const char *s, char c)
{
 256:	1141                	addi	sp,sp,-16
 258:	e406                	sd	ra,8(sp)
 25a:	e022                	sd	s0,0(sp)
 25c:	0800                	addi	s0,sp,16
  for (; *s; s++)
 25e:	00054783          	lbu	a5,0(a0)
 262:	c799                	beqz	a5,270 <strchr+0x1a>
    if (*s == c)
 264:	00f58763          	beq	a1,a5,272 <strchr+0x1c>
  for (; *s; s++)
 268:	0505                	addi	a0,a0,1
 26a:	00054783          	lbu	a5,0(a0)
 26e:	fbfd                	bnez	a5,264 <strchr+0xe>
      return (char *)s;
  return 0;
 270:	4501                	li	a0,0
}
 272:	60a2                	ld	ra,8(sp)
 274:	6402                	ld	s0,0(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret

000000000000027a <gets>:

char *
gets(char *buf, int max)
{
 27a:	711d                	addi	sp,sp,-96
 27c:	ec86                	sd	ra,88(sp)
 27e:	e8a2                	sd	s0,80(sp)
 280:	e4a6                	sd	s1,72(sp)
 282:	e0ca                	sd	s2,64(sp)
 284:	fc4e                	sd	s3,56(sp)
 286:	f852                	sd	s4,48(sp)
 288:	f456                	sd	s5,40(sp)
 28a:	f05a                	sd	s6,32(sp)
 28c:	ec5e                	sd	s7,24(sp)
 28e:	e862                	sd	s8,16(sp)
 290:	1080                	addi	s0,sp,96
 292:	8baa                	mv	s7,a0
 294:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 296:	892a                	mv	s2,a0
 298:	4481                	li	s1,0
    cc = read(0, &c, 1);
 29a:	faf40b13          	addi	s6,s0,-81
 29e:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 2a0:	8c26                	mv	s8,s1
 2a2:	0014899b          	addiw	s3,s1,1
 2a6:	84ce                	mv	s1,s3
 2a8:	0349d863          	bge	s3,s4,2d8 <gets+0x5e>
    cc = read(0, &c, 1);
 2ac:	8656                	mv	a2,s5
 2ae:	85da                	mv	a1,s6
 2b0:	4501                	li	a0,0
 2b2:	1c0000ef          	jal	472 <read>
    if (cc < 1)
 2b6:	02a05163          	blez	a0,2d8 <gets+0x5e>
      break;
    buf[i++] = c;
 2ba:	faf44783          	lbu	a5,-81(s0)
 2be:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 2c2:	0905                	addi	s2,s2,1
 2c4:	ff678713          	addi	a4,a5,-10
 2c8:	00173713          	seqz	a4,a4
 2cc:	17cd                	addi	a5,a5,-13
 2ce:	0017b793          	seqz	a5,a5
 2d2:	8fd9                	or	a5,a5,a4
 2d4:	d7f1                	beqz	a5,2a0 <gets+0x26>
    buf[i++] = c;
 2d6:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 2d8:	9c5e                	add	s8,s8,s7
 2da:	000c0023          	sb	zero,0(s8)
  return buf;
}
 2de:	855e                	mv	a0,s7
 2e0:	60e6                	ld	ra,88(sp)
 2e2:	6446                	ld	s0,80(sp)
 2e4:	64a6                	ld	s1,72(sp)
 2e6:	6906                	ld	s2,64(sp)
 2e8:	79e2                	ld	s3,56(sp)
 2ea:	7a42                	ld	s4,48(sp)
 2ec:	7aa2                	ld	s5,40(sp)
 2ee:	7b02                	ld	s6,32(sp)
 2f0:	6be2                	ld	s7,24(sp)
 2f2:	6c42                	ld	s8,16(sp)
 2f4:	6125                	addi	sp,sp,96
 2f6:	8082                	ret

00000000000002f8 <stat>:

int
stat(const char *n, struct stat *st)
{
 2f8:	1101                	addi	sp,sp,-32
 2fa:	ec06                	sd	ra,24(sp)
 2fc:	e822                	sd	s0,16(sp)
 2fe:	e04a                	sd	s2,0(sp)
 300:	1000                	addi	s0,sp,32
 302:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 304:	4581                	li	a1,0
 306:	194000ef          	jal	49a <open>
  if (fd < 0)
 30a:	02054263          	bltz	a0,32e <stat+0x36>
 30e:	e426                	sd	s1,8(sp)
 310:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 312:	85ca                	mv	a1,s2
 314:	19e000ef          	jal	4b2 <fstat>
 318:	892a                	mv	s2,a0
  close(fd);
 31a:	8526                	mv	a0,s1
 31c:	166000ef          	jal	482 <close>
  return r;
 320:	64a2                	ld	s1,8(sp)
}
 322:	854a                	mv	a0,s2
 324:	60e2                	ld	ra,24(sp)
 326:	6442                	ld	s0,16(sp)
 328:	6902                	ld	s2,0(sp)
 32a:	6105                	addi	sp,sp,32
 32c:	8082                	ret
    return -1;
 32e:	57fd                	li	a5,-1
 330:	893e                	mv	s2,a5
 332:	bfc5                	j	322 <stat+0x2a>

0000000000000334 <atoi>:

int
atoi(const char *s)
{
 334:	1141                	addi	sp,sp,-16
 336:	e406                	sd	ra,8(sp)
 338:	e022                	sd	s0,0(sp)
 33a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 33c:	00054683          	lbu	a3,0(a0)
 340:	fd06879b          	addiw	a5,a3,-48
 344:	0ff7f793          	zext.b	a5,a5
 348:	4625                	li	a2,9
 34a:	02f66963          	bltu	a2,a5,37c <atoi+0x48>
 34e:	872a                	mv	a4,a0
  n = 0;
 350:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 352:	0705                	addi	a4,a4,1
 354:	0025179b          	slliw	a5,a0,0x2
 358:	9fa9                	addw	a5,a5,a0
 35a:	0017979b          	slliw	a5,a5,0x1
 35e:	9fb5                	addw	a5,a5,a3
 360:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 364:	00074683          	lbu	a3,0(a4)
 368:	fd06879b          	addiw	a5,a3,-48
 36c:	0ff7f793          	zext.b	a5,a5
 370:	fef671e3          	bgeu	a2,a5,352 <atoi+0x1e>
  return n;
}
 374:	60a2                	ld	ra,8(sp)
 376:	6402                	ld	s0,0(sp)
 378:	0141                	addi	sp,sp,16
 37a:	8082                	ret
  n = 0;
 37c:	4501                	li	a0,0
 37e:	bfdd                	j	374 <atoi+0x40>

0000000000000380 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 380:	1141                	addi	sp,sp,-16
 382:	e406                	sd	ra,8(sp)
 384:	e022                	sd	s0,0(sp)
 386:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 388:	02b57563          	bgeu	a0,a1,3b2 <memmove+0x32>
    while (n-- > 0)
 38c:	00c05f63          	blez	a2,3aa <memmove+0x2a>
 390:	1602                	slli	a2,a2,0x20
 392:	9201                	srli	a2,a2,0x20
 394:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 398:	872a                	mv	a4,a0
      *dst++ = *src++;
 39a:	0585                	addi	a1,a1,1
 39c:	0705                	addi	a4,a4,1
 39e:	fff5c683          	lbu	a3,-1(a1)
 3a2:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 3a6:	fee79ae3          	bne	a5,a4,39a <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3aa:	60a2                	ld	ra,8(sp)
 3ac:	6402                	ld	s0,0(sp)
 3ae:	0141                	addi	sp,sp,16
 3b0:	8082                	ret
    while (n-- > 0)
 3b2:	fec05ce3          	blez	a2,3aa <memmove+0x2a>
    dst += n;
 3b6:	00c50733          	add	a4,a0,a2
    src += n;
 3ba:	95b2                	add	a1,a1,a2
 3bc:	fff6079b          	addiw	a5,a2,-1
 3c0:	1782                	slli	a5,a5,0x20
 3c2:	9381                	srli	a5,a5,0x20
 3c4:	fff7c793          	not	a5,a5
 3c8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3ca:	15fd                	addi	a1,a1,-1
 3cc:	177d                	addi	a4,a4,-1
 3ce:	0005c683          	lbu	a3,0(a1)
 3d2:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 3d6:	fef71ae3          	bne	a4,a5,3ca <memmove+0x4a>
 3da:	bfc1                	j	3aa <memmove+0x2a>

00000000000003dc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3dc:	1141                	addi	sp,sp,-16
 3de:	e406                	sd	ra,8(sp)
 3e0:	e022                	sd	s0,0(sp)
 3e2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3e4:	ce19                	beqz	a2,402 <memcmp+0x26>
 3e6:	1602                	slli	a2,a2,0x20
 3e8:	9201                	srli	a2,a2,0x20
 3ea:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 3ee:	00054783          	lbu	a5,0(a0)
 3f2:	0005c703          	lbu	a4,0(a1)
 3f6:	00e79b63          	bne	a5,a4,40c <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 3fa:	0505                	addi	a0,a0,1
    p2++;
 3fc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3fe:	fed518e3          	bne	a0,a3,3ee <memcmp+0x12>
  }
  return 0;
 402:	4501                	li	a0,0
}
 404:	60a2                	ld	ra,8(sp)
 406:	6402                	ld	s0,0(sp)
 408:	0141                	addi	sp,sp,16
 40a:	8082                	ret
      return *p1 - *p2;
 40c:	40e7853b          	subw	a0,a5,a4
 410:	bfd5                	j	404 <memcmp+0x28>

0000000000000412 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 412:	1141                	addi	sp,sp,-16
 414:	e406                	sd	ra,8(sp)
 416:	e022                	sd	s0,0(sp)
 418:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 41a:	f67ff0ef          	jal	380 <memmove>
}
 41e:	60a2                	ld	ra,8(sp)
 420:	6402                	ld	s0,0(sp)
 422:	0141                	addi	sp,sp,16
 424:	8082                	ret

0000000000000426 <sbrk>:

char *
sbrk(int n)
{
 426:	1141                	addi	sp,sp,-16
 428:	e406                	sd	ra,8(sp)
 42a:	e022                	sd	s0,0(sp)
 42c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 42e:	4585                	li	a1,1
 430:	0b2000ef          	jal	4e2 <sys_sbrk>
}
 434:	60a2                	ld	ra,8(sp)
 436:	6402                	ld	s0,0(sp)
 438:	0141                	addi	sp,sp,16
 43a:	8082                	ret

000000000000043c <sbrklazy>:

char *
sbrklazy(int n)
{
 43c:	1141                	addi	sp,sp,-16
 43e:	e406                	sd	ra,8(sp)
 440:	e022                	sd	s0,0(sp)
 442:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 444:	4589                	li	a1,2
 446:	09c000ef          	jal	4e2 <sys_sbrk>
}
 44a:	60a2                	ld	ra,8(sp)
 44c:	6402                	ld	s0,0(sp)
 44e:	0141                	addi	sp,sp,16
 450:	8082                	ret

0000000000000452 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 452:	4885                	li	a7,1
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <exit>:
.global exit
exit:
 li a7, SYS_exit
 45a:	4889                	li	a7,2
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <wait>:
.global wait
wait:
 li a7, SYS_wait
 462:	488d                	li	a7,3
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 46a:	4891                	li	a7,4
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <read>:
.global read
read:
 li a7, SYS_read
 472:	4895                	li	a7,5
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <write>:
.global write
write:
 li a7, SYS_write
 47a:	48c1                	li	a7,16
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <close>:
.global close
close:
 li a7, SYS_close
 482:	48d5                	li	a7,21
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <kill>:
.global kill
kill:
 li a7, SYS_kill
 48a:	4899                	li	a7,6
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <exec>:
.global exec
exec:
 li a7, SYS_exec
 492:	489d                	li	a7,7
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <open>:
.global open
open:
 li a7, SYS_open
 49a:	48bd                	li	a7,15
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4a2:	48c5                	li	a7,17
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4aa:	48c9                	li	a7,18
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4b2:	48a1                	li	a7,8
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <link>:
.global link
link:
 li a7, SYS_link
 4ba:	48cd                	li	a7,19
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4c2:	48d1                	li	a7,20
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4ca:	48a5                	li	a7,9
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4d2:	48a9                	li	a7,10
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4da:	48ad                	li	a7,11
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 4e2:	48b1                	li	a7,12
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <pause>:
.global pause
pause:
 li a7, SYS_pause
 4ea:	48b5                	li	a7,13
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4f2:	48b9                	li	a7,14
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <sync>:
.global sync
sync:
 li a7, SYS_sync
 4fa:	48d9                	li	a7,22
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 502:	48dd                	li	a7,23
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 50a:	1101                	addi	sp,sp,-32
 50c:	ec06                	sd	ra,24(sp)
 50e:	e822                	sd	s0,16(sp)
 510:	1000                	addi	s0,sp,32
 512:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 516:	4605                	li	a2,1
 518:	fef40593          	addi	a1,s0,-17
 51c:	f5fff0ef          	jal	47a <write>
}
 520:	60e2                	ld	ra,24(sp)
 522:	6442                	ld	s0,16(sp)
 524:	6105                	addi	sp,sp,32
 526:	8082                	ret

0000000000000528 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 528:	715d                	addi	sp,sp,-80
 52a:	e486                	sd	ra,72(sp)
 52c:	e0a2                	sd	s0,64(sp)
 52e:	f84a                	sd	s2,48(sp)
 530:	f44e                	sd	s3,40(sp)
 532:	0880                	addi	s0,sp,80
 534:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 536:	00d036b3          	snez	a3,a3
 53a:	03f5d793          	srli	a5,a1,0x3f
 53e:	8efd                	and	a3,a3,a5
  neg = 0;
 540:	4301                	li	t1,0
  if (sgn && xx < 0) {
 542:	c681                	beqz	a3,54a <printint+0x22>
    neg = 1;
    x = -xx;
 544:	40b005b3          	neg	a1,a1
    neg = 1;
 548:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 54a:	fb840993          	addi	s3,s0,-72
  neg = 0;
 54e:	86ce                	mv	a3,s3
  i = 0;
 550:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 552:	00000817          	auipc	a6,0x0
 556:	5fe80813          	addi	a6,a6,1534 # b50 <digits>
 55a:	88ba                	mv	a7,a4
 55c:	0017051b          	addiw	a0,a4,1
 560:	872a                	mv	a4,a0
 562:	02c5f7b3          	remu	a5,a1,a2
 566:	97c2                	add	a5,a5,a6
 568:	0007c783          	lbu	a5,0(a5)
 56c:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 570:	87ae                	mv	a5,a1
 572:	02c5d5b3          	divu	a1,a1,a2
 576:	0685                	addi	a3,a3,1
 578:	fec7f1e3          	bgeu	a5,a2,55a <printint+0x32>
  if (neg)
 57c:	00030b63          	beqz	t1,592 <printint+0x6a>
    buf[i++] = '-';
 580:	fd040793          	addi	a5,s0,-48
 584:	953e                	add	a0,a0,a5
 586:	02d00793          	li	a5,45
 58a:	fef50423          	sb	a5,-24(a0)
 58e:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 592:	02e05563          	blez	a4,5bc <printint+0x94>
 596:	fc26                	sd	s1,56(sp)
 598:	377d                	addiw	a4,a4,-1
 59a:	00e984b3          	add	s1,s3,a4
 59e:	19fd                	addi	s3,s3,-1
 5a0:	99ba                	add	s3,s3,a4
 5a2:	1702                	slli	a4,a4,0x20
 5a4:	9301                	srli	a4,a4,0x20
 5a6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5aa:	0004c583          	lbu	a1,0(s1)
 5ae:	854a                	mv	a0,s2
 5b0:	f5bff0ef          	jal	50a <putc>
  while (--i >= 0)
 5b4:	14fd                	addi	s1,s1,-1
 5b6:	ff349ae3          	bne	s1,s3,5aa <printint+0x82>
 5ba:	74e2                	ld	s1,56(sp)
}
 5bc:	60a6                	ld	ra,72(sp)
 5be:	6406                	ld	s0,64(sp)
 5c0:	7942                	ld	s2,48(sp)
 5c2:	79a2                	ld	s3,40(sp)
 5c4:	6161                	addi	sp,sp,80
 5c6:	8082                	ret

00000000000005c8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5c8:	711d                	addi	sp,sp,-96
 5ca:	ec86                	sd	ra,88(sp)
 5cc:	e8a2                	sd	s0,80(sp)
 5ce:	e4a6                	sd	s1,72(sp)
 5d0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 5d2:	0005c483          	lbu	s1,0(a1)
 5d6:	2a048063          	beqz	s1,876 <vprintf+0x2ae>
 5da:	e0ca                	sd	s2,64(sp)
 5dc:	fc4e                	sd	s3,56(sp)
 5de:	f852                	sd	s4,48(sp)
 5e0:	f456                	sd	s5,40(sp)
 5e2:	f05a                	sd	s6,32(sp)
 5e4:	ec5e                	sd	s7,24(sp)
 5e6:	e862                	sd	s8,16(sp)
 5e8:	8b2a                	mv	s6,a0
 5ea:	8a2e                	mv	s4,a1
 5ec:	8bb2                	mv	s7,a2
  state = 0;
 5ee:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 5f0:	4901                	li	s2,0
 5f2:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 5f4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 5f8:	06400c13          	li	s8,100
 5fc:	a00d                	j	61e <vprintf+0x56>
        putc(fd, c0);
 5fe:	85a6                	mv	a1,s1
 600:	855a                	mv	a0,s6
 602:	f09ff0ef          	jal	50a <putc>
 606:	a019                	j	60c <vprintf+0x44>
    } else if (state == '%') {
 608:	03598363          	beq	s3,s5,62e <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 60c:	0019079b          	addiw	a5,s2,1
 610:	893e                	mv	s2,a5
 612:	873e                	mv	a4,a5
 614:	97d2                	add	a5,a5,s4
 616:	0007c483          	lbu	s1,0(a5)
 61a:	24048763          	beqz	s1,868 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 61e:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 622:	fe0993e3          	bnez	s3,608 <vprintf+0x40>
      if (c0 == '%') {
 626:	fd579ce3          	bne	a5,s5,5fe <vprintf+0x36>
        state = '%';
 62a:	89be                	mv	s3,a5
 62c:	b7c5                	j	60c <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 62e:	00ea06b3          	add	a3,s4,a4
 632:	0016c603          	lbu	a2,1(a3)
      if (c1)
 636:	24060563          	beqz	a2,880 <vprintf+0x2b8>
      if (c0 == 'd') {
 63a:	0b878763          	beq	a5,s8,6e8 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 63e:	f9478693          	addi	a3,a5,-108
 642:	0016b693          	seqz	a3,a3
 646:	f9c60593          	addi	a1,a2,-100
 64a:	0015b593          	seqz	a1,a1
 64e:	8df5                	and	a1,a1,a3
 650:	e9c5                	bnez	a1,700 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 652:	9752                	add	a4,a4,s4
 654:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 658:	f9460713          	addi	a4,a2,-108
 65c:	00173713          	seqz	a4,a4
 660:	8f75                	and	a4,a4,a3
 662:	f9c50593          	addi	a1,a0,-100
 666:	0015b593          	seqz	a1,a1
 66a:	8df9                	and	a1,a1,a4
 66c:	e5dd                	bnez	a1,71a <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 66e:	07500593          	li	a1,117
 672:	0cb78163          	beq	a5,a1,734 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 676:	f8b60593          	addi	a1,a2,-117
 67a:	0015b593          	seqz	a1,a1
 67e:	8df5                	and	a1,a1,a3
 680:	e5f1                	bnez	a1,74c <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 682:	f8b50593          	addi	a1,a0,-117
 686:	0015b593          	seqz	a1,a1
 68a:	8df9                	and	a1,a1,a4
 68c:	ede9                	bnez	a1,766 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 68e:	07800593          	li	a1,120
 692:	0eb78763          	beq	a5,a1,780 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 696:	f8860613          	addi	a2,a2,-120
 69a:	00163613          	seqz	a2,a2
 69e:	8ef1                	and	a3,a3,a2
 6a0:	0e069c63          	bnez	a3,798 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 6a4:	f8850513          	addi	a0,a0,-120
 6a8:	00153513          	seqz	a0,a0
 6ac:	8f69                	and	a4,a4,a0
 6ae:	10071263          	bnez	a4,7b2 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 6b2:	07000713          	li	a4,112
 6b6:	10e78a63          	beq	a5,a4,7ca <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 6ba:	06300713          	li	a4,99
 6be:	14e78a63          	beq	a5,a4,812 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 6c2:	07300713          	li	a4,115
 6c6:	16e78063          	beq	a5,a4,826 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 6ca:	02500713          	li	a4,37
 6ce:	18e78863          	beq	a5,a4,85e <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6d2:	02500593          	li	a1,37
 6d6:	855a                	mv	a0,s6
 6d8:	e33ff0ef          	jal	50a <putc>
        putc(fd, c0);
 6dc:	85a6                	mv	a1,s1
 6de:	855a                	mv	a0,s6
 6e0:	e2bff0ef          	jal	50a <putc>
      }

      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	b71d                	j	60c <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 6e8:	008b8493          	addi	s1,s7,8
 6ec:	4685                	li	a3,1
 6ee:	4629                	li	a2,10
 6f0:	000ba583          	lw	a1,0(s7)
 6f4:	855a                	mv	a0,s6
 6f6:	e33ff0ef          	jal	528 <printint>
 6fa:	8ba6                	mv	s7,s1
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	b739                	j	60c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 700:	008b8493          	addi	s1,s7,8
 704:	4685                	li	a3,1
 706:	4629                	li	a2,10
 708:	000bb583          	ld	a1,0(s7)
 70c:	855a                	mv	a0,s6
 70e:	e1bff0ef          	jal	528 <printint>
        i += 1;
 712:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 714:	8ba6                	mv	s7,s1
      state = 0;
 716:	4981                	li	s3,0
 718:	bdd5                	j	60c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 71a:	008b8493          	addi	s1,s7,8
 71e:	4685                	li	a3,1
 720:	4629                	li	a2,10
 722:	000bb583          	ld	a1,0(s7)
 726:	855a                	mv	a0,s6
 728:	e01ff0ef          	jal	528 <printint>
        i += 2;
 72c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 72e:	8ba6                	mv	s7,s1
      state = 0;
 730:	4981                	li	s3,0
        i += 2;
 732:	bde9                	j	60c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 734:	008b8493          	addi	s1,s7,8
 738:	4681                	li	a3,0
 73a:	4629                	li	a2,10
 73c:	000be583          	lwu	a1,0(s7)
 740:	855a                	mv	a0,s6
 742:	de7ff0ef          	jal	528 <printint>
 746:	8ba6                	mv	s7,s1
      state = 0;
 748:	4981                	li	s3,0
 74a:	b5c9                	j	60c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 74c:	008b8493          	addi	s1,s7,8
 750:	4681                	li	a3,0
 752:	4629                	li	a2,10
 754:	000bb583          	ld	a1,0(s7)
 758:	855a                	mv	a0,s6
 75a:	dcfff0ef          	jal	528 <printint>
        i += 1;
 75e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 760:	8ba6                	mv	s7,s1
      state = 0;
 762:	4981                	li	s3,0
 764:	b565                	j	60c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 766:	008b8493          	addi	s1,s7,8
 76a:	4681                	li	a3,0
 76c:	4629                	li	a2,10
 76e:	000bb583          	ld	a1,0(s7)
 772:	855a                	mv	a0,s6
 774:	db5ff0ef          	jal	528 <printint>
        i += 2;
 778:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 77a:	8ba6                	mv	s7,s1
      state = 0;
 77c:	4981                	li	s3,0
        i += 2;
 77e:	b579                	j	60c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 780:	008b8493          	addi	s1,s7,8
 784:	4681                	li	a3,0
 786:	4641                	li	a2,16
 788:	000be583          	lwu	a1,0(s7)
 78c:	855a                	mv	a0,s6
 78e:	d9bff0ef          	jal	528 <printint>
 792:	8ba6                	mv	s7,s1
      state = 0;
 794:	4981                	li	s3,0
 796:	bd9d                	j	60c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 798:	008b8493          	addi	s1,s7,8
 79c:	4681                	li	a3,0
 79e:	4641                	li	a2,16
 7a0:	000bb583          	ld	a1,0(s7)
 7a4:	855a                	mv	a0,s6
 7a6:	d83ff0ef          	jal	528 <printint>
        i += 1;
 7aa:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ac:	8ba6                	mv	s7,s1
      state = 0;
 7ae:	4981                	li	s3,0
 7b0:	bdb1                	j	60c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7b2:	008b8493          	addi	s1,s7,8
 7b6:	4641                	li	a2,16
 7b8:	000bb583          	ld	a1,0(s7)
 7bc:	855a                	mv	a0,s6
 7be:	d6bff0ef          	jal	528 <printint>
        i += 2;
 7c2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7c4:	8ba6                	mv	s7,s1
      state = 0;
 7c6:	4981                	li	s3,0
        i += 2;
 7c8:	b591                	j	60c <vprintf+0x44>
 7ca:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 7cc:	008b8793          	addi	a5,s7,8
 7d0:	8cbe                	mv	s9,a5
 7d2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7d6:	03000593          	li	a1,48
 7da:	855a                	mv	a0,s6
 7dc:	d2fff0ef          	jal	50a <putc>
  putc(fd, 'x');
 7e0:	07800593          	li	a1,120
 7e4:	855a                	mv	a0,s6
 7e6:	d25ff0ef          	jal	50a <putc>
 7ea:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ec:	00000b97          	auipc	s7,0x0
 7f0:	364b8b93          	addi	s7,s7,868 # b50 <digits>
 7f4:	03c9d793          	srli	a5,s3,0x3c
 7f8:	97de                	add	a5,a5,s7
 7fa:	0007c583          	lbu	a1,0(a5)
 7fe:	855a                	mv	a0,s6
 800:	d0bff0ef          	jal	50a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 804:	0992                	slli	s3,s3,0x4
 806:	34fd                	addiw	s1,s1,-1
 808:	f4f5                	bnez	s1,7f4 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 80a:	8be6                	mv	s7,s9
      state = 0;
 80c:	4981                	li	s3,0
 80e:	6ca2                	ld	s9,8(sp)
 810:	bbf5                	j	60c <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 812:	008b8493          	addi	s1,s7,8
 816:	000bc583          	lbu	a1,0(s7)
 81a:	855a                	mv	a0,s6
 81c:	cefff0ef          	jal	50a <putc>
 820:	8ba6                	mv	s7,s1
      state = 0;
 822:	4981                	li	s3,0
 824:	b3e5                	j	60c <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 826:	008b8993          	addi	s3,s7,8
 82a:	000bb483          	ld	s1,0(s7)
 82e:	cc91                	beqz	s1,84a <vprintf+0x282>
        for (; *s; s++)
 830:	0004c583          	lbu	a1,0(s1)
 834:	c195                	beqz	a1,858 <vprintf+0x290>
          putc(fd, *s);
 836:	855a                	mv	a0,s6
 838:	cd3ff0ef          	jal	50a <putc>
        for (; *s; s++)
 83c:	0485                	addi	s1,s1,1
 83e:	0004c583          	lbu	a1,0(s1)
 842:	f9f5                	bnez	a1,836 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 844:	8bce                	mv	s7,s3
      state = 0;
 846:	4981                	li	s3,0
 848:	b3d1                	j	60c <vprintf+0x44>
          s = "(null)";
 84a:	00000497          	auipc	s1,0x0
 84e:	2e648493          	addi	s1,s1,742 # b30 <malloc+0x1b4>
        for (; *s; s++)
 852:	02800593          	li	a1,40
 856:	b7c5                	j	836 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 858:	8bce                	mv	s7,s3
      state = 0;
 85a:	4981                	li	s3,0
 85c:	bb45                	j	60c <vprintf+0x44>
        putc(fd, '%');
 85e:	85be                	mv	a1,a5
 860:	855a                	mv	a0,s6
 862:	ca9ff0ef          	jal	50a <putc>
 866:	bdbd                	j	6e4 <vprintf+0x11c>
 868:	6906                	ld	s2,64(sp)
 86a:	79e2                	ld	s3,56(sp)
 86c:	7a42                	ld	s4,48(sp)
 86e:	7aa2                	ld	s5,40(sp)
 870:	7b02                	ld	s6,32(sp)
 872:	6be2                	ld	s7,24(sp)
 874:	6c42                	ld	s8,16(sp)
    }
  }
}
 876:	60e6                	ld	ra,88(sp)
 878:	6446                	ld	s0,80(sp)
 87a:	64a6                	ld	s1,72(sp)
 87c:	6125                	addi	sp,sp,96
 87e:	8082                	ret
      if (c0 == 'd') {
 880:	06400713          	li	a4,100
 884:	e6e782e3          	beq	a5,a4,6e8 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 888:	f9478693          	addi	a3,a5,-108
 88c:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 890:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 892:	4701                	li	a4,0
 894:	bbe9                	j	66e <vprintf+0xa6>

0000000000000896 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 896:	715d                	addi	sp,sp,-80
 898:	ec06                	sd	ra,24(sp)
 89a:	e822                	sd	s0,16(sp)
 89c:	1000                	addi	s0,sp,32
 89e:	e010                	sd	a2,0(s0)
 8a0:	e414                	sd	a3,8(s0)
 8a2:	e818                	sd	a4,16(s0)
 8a4:	ec1c                	sd	a5,24(s0)
 8a6:	03043023          	sd	a6,32(s0)
 8aa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8ae:	8622                	mv	a2,s0
 8b0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8b4:	d15ff0ef          	jal	5c8 <vprintf>
}
 8b8:	60e2                	ld	ra,24(sp)
 8ba:	6442                	ld	s0,16(sp)
 8bc:	6161                	addi	sp,sp,80
 8be:	8082                	ret

00000000000008c0 <printf>:

void
printf(const char *fmt, ...)
{
 8c0:	711d                	addi	sp,sp,-96
 8c2:	ec06                	sd	ra,24(sp)
 8c4:	e822                	sd	s0,16(sp)
 8c6:	1000                	addi	s0,sp,32
 8c8:	e40c                	sd	a1,8(s0)
 8ca:	e810                	sd	a2,16(s0)
 8cc:	ec14                	sd	a3,24(s0)
 8ce:	f018                	sd	a4,32(s0)
 8d0:	f41c                	sd	a5,40(s0)
 8d2:	03043823          	sd	a6,48(s0)
 8d6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8da:	00840613          	addi	a2,s0,8
 8de:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8e2:	85aa                	mv	a1,a0
 8e4:	4505                	li	a0,1
 8e6:	ce3ff0ef          	jal	5c8 <vprintf>
}
 8ea:	60e2                	ld	ra,24(sp)
 8ec:	6442                	ld	s0,16(sp)
 8ee:	6125                	addi	sp,sp,96
 8f0:	8082                	ret

00000000000008f2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8f2:	1141                	addi	sp,sp,-16
 8f4:	e406                	sd	ra,8(sp)
 8f6:	e022                	sd	s0,0(sp)
 8f8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 8fa:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8fe:	00000797          	auipc	a5,0x0
 902:	7027b783          	ld	a5,1794(a5) # 1000 <freep>
 906:	a095                	j	96a <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 908:	ff852583          	lw	a1,-8(a0)
 90c:	6390                	ld	a2,0(a5)
 90e:	02059813          	slli	a6,a1,0x20
 912:	01c85693          	srli	a3,a6,0x1c
 916:	96ba                	add	a3,a3,a4
 918:	02d60563          	beq	a2,a3,942 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 91c:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 920:	4790                	lw	a2,8(a5)
 922:	02061593          	slli	a1,a2,0x20
 926:	01c5d693          	srli	a3,a1,0x1c
 92a:	96be                	add	a3,a3,a5
 92c:	02d70263          	beq	a4,a3,950 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 930:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 932:	00000717          	auipc	a4,0x0
 936:	6cf73723          	sd	a5,1742(a4) # 1000 <freep>
}
 93a:	60a2                	ld	ra,8(sp)
 93c:	6402                	ld	s0,0(sp)
 93e:	0141                	addi	sp,sp,16
 940:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 942:	4614                	lw	a3,8(a2)
 944:	9ead                	addw	a3,a3,a1
 946:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 94a:	6394                	ld	a3,0(a5)
 94c:	6290                	ld	a2,0(a3)
 94e:	b7f9                	j	91c <free+0x2a>
    p->s.size += bp->s.size;
 950:	ff852703          	lw	a4,-8(a0)
 954:	9f31                	addw	a4,a4,a2
 956:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 958:	ff053703          	ld	a4,-16(a0)
 95c:	bfd1                	j	930 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 95e:	6394                	ld	a3,0(a5)
 960:	00d7e463          	bltu	a5,a3,968 <free+0x76>
 964:	fad762e3          	bltu	a4,a3,908 <free+0x16>
 968:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 96a:	fee7fae3          	bgeu	a5,a4,95e <free+0x6c>
 96e:	6394                	ld	a3,0(a5)
 970:	f8d76ce3          	bltu	a4,a3,908 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 974:	f8d7fae3          	bgeu	a5,a3,908 <free+0x16>
 978:	87b6                	mv	a5,a3
 97a:	bfc5                	j	96a <free+0x78>

000000000000097c <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 97c:	7139                	addi	sp,sp,-64
 97e:	fc06                	sd	ra,56(sp)
 980:	f822                	sd	s0,48(sp)
 982:	f04a                	sd	s2,32(sp)
 984:	ec4e                	sd	s3,24(sp)
 986:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 988:	02051993          	slli	s3,a0,0x20
 98c:	0209d993          	srli	s3,s3,0x20
 990:	09bd                	addi	s3,s3,15
 992:	0049d993          	srli	s3,s3,0x4
 996:	2985                	addiw	s3,s3,1
 998:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 99a:	00000517          	auipc	a0,0x0
 99e:	66653503          	ld	a0,1638(a0) # 1000 <freep>
 9a2:	c905                	beqz	a0,9d2 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 9a4:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 9a6:	4798                	lw	a4,8(a5)
 9a8:	09377663          	bgeu	a4,s3,a34 <malloc+0xb8>
 9ac:	f426                	sd	s1,40(sp)
 9ae:	e852                	sd	s4,16(sp)
 9b0:	e456                	sd	s5,8(sp)
 9b2:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 9b4:	8a4e                	mv	s4,s3
 9b6:	6705                	lui	a4,0x1
 9b8:	00e9f363          	bgeu	s3,a4,9be <malloc+0x42>
 9bc:	6a05                	lui	s4,0x1
 9be:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9c2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 9c6:	00000497          	auipc	s1,0x0
 9ca:	63a48493          	addi	s1,s1,1594 # 1000 <freep>
  if (p == SBRK_ERROR)
 9ce:	5afd                	li	s5,-1
 9d0:	a83d                	j	a0e <malloc+0x92>
 9d2:	f426                	sd	s1,40(sp)
 9d4:	e852                	sd	s4,16(sp)
 9d6:	e456                	sd	s5,8(sp)
 9d8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9da:	00000797          	auipc	a5,0x0
 9de:	63678793          	addi	a5,a5,1590 # 1010 <base>
 9e2:	00000717          	auipc	a4,0x0
 9e6:	60f73f23          	sd	a5,1566(a4) # 1000 <freep>
 9ea:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9ec:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 9f0:	b7d1                	j	9b4 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 9f2:	6398                	ld	a4,0(a5)
 9f4:	e118                	sd	a4,0(a0)
 9f6:	a899                	j	a4c <malloc+0xd0>
  hp->s.size = nu;
 9f8:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 9fc:	0541                	addi	a0,a0,16
 9fe:	ef5ff0ef          	jal	8f2 <free>
  return freep;
 a02:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 a04:	c125                	beqz	a0,a64 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 a06:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 a08:	4798                	lw	a4,8(a5)
 a0a:	03277163          	bgeu	a4,s2,a2c <malloc+0xb0>
    if (p == freep)
 a0e:	6098                	ld	a4,0(s1)
 a10:	853e                	mv	a0,a5
 a12:	fef71ae3          	bne	a4,a5,a06 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a16:	8552                	mv	a0,s4
 a18:	a0fff0ef          	jal	426 <sbrk>
  if (p == SBRK_ERROR)
 a1c:	fd551ee3          	bne	a0,s5,9f8 <malloc+0x7c>
        return 0;
 a20:	4501                	li	a0,0
 a22:	74a2                	ld	s1,40(sp)
 a24:	6a42                	ld	s4,16(sp)
 a26:	6aa2                	ld	s5,8(sp)
 a28:	6b02                	ld	s6,0(sp)
 a2a:	a03d                	j	a58 <malloc+0xdc>
 a2c:	74a2                	ld	s1,40(sp)
 a2e:	6a42                	ld	s4,16(sp)
 a30:	6aa2                	ld	s5,8(sp)
 a32:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 a34:	fae90fe3          	beq	s2,a4,9f2 <malloc+0x76>
        p->s.size -= nunits;
 a38:	4137073b          	subw	a4,a4,s3
 a3c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a3e:	02071693          	slli	a3,a4,0x20
 a42:	01c6d713          	srli	a4,a3,0x1c
 a46:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a48:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a4c:	00000717          	auipc	a4,0x0
 a50:	5aa73a23          	sd	a0,1460(a4) # 1000 <freep>
      return (void *)(p + 1);
 a54:	01078513          	addi	a0,a5,16
  }
}
 a58:	70e2                	ld	ra,56(sp)
 a5a:	7442                	ld	s0,48(sp)
 a5c:	7902                	ld	s2,32(sp)
 a5e:	69e2                	ld	s3,24(sp)
 a60:	6121                	addi	sp,sp,64
 a62:	8082                	ret
 a64:	74a2                	ld	s1,40(sp)
 a66:	6a42                	ld	s4,16(sp)
 a68:	6aa2                	ld	s5,8(sp)
 a6a:	6b02                	ld	s6,0(sp)
 a6c:	b7f5                	j	a58 <malloc+0xdc>
