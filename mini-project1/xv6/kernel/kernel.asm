
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	42010113          	addi	sp,sp,1056 # 8000a420 <stack0>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	042000ef          	jal	80000058 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    80000024:	30a027f3          	csrr	a5,0x30a
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | MENVCFG_STCE);
    80000028:	577d                	li	a4,-1
    8000002a:	177e                	slli	a4,a4,0x3f
    8000002c:	8fd9                	or	a5,a5,a4

static inline void
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    8000002e:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r"(x));
    80000032:	306027f3          	csrr	a5,mcounteren

  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000036:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r"(x));
    8000003a:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r"(x));
    8000003e:	c01027f3          	rdtime	a5

  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80000042:	000f4737          	lui	a4,0xf4
    80000046:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000004a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    8000004c:	14d79073          	csrw	stimecmp,a5
}
    80000050:	60a2                	ld	ra,8(sp)
    80000052:	6402                	ld	s0,0(sp)
    80000054:	0141                	addi	sp,sp,16
    80000056:	8082                	ret

0000000080000058 <start>:
{
    80000058:	1141                	addi	sp,sp,-16
    8000005a:	e406                	sd	ra,8(sp)
    8000005c:	e022                	sd	s0,0(sp)
    8000005e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80000060:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000064:	7779                	lui	a4,0xffffe
    80000066:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdaaaf>
    8000006a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000006c:	6705                	lui	a4,0x1
    8000006e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80000072:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80000074:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80000078:	00001797          	auipc	a5,0x1
    8000007c:	de878793          	addi	a5,a5,-536 # 80000e60 <main>
    80000080:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80000084:	4781                	li	a5,0
    80000086:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    8000008a:	67c1                	lui	a5,0x10
    8000008c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000008e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    80000092:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    80000096:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    8000009a:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r"(x));
    8000009e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    800000a2:	57fd                	li	a5,-1
    800000a4:	83a9                	srli	a5,a5,0xa
    800000a6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    800000aa:	47bd                	li	a5,15
    800000ac:	3a079073          	csrw	pmpcfg0,a5
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    800000b0:	30a027f3          	csrr	a5,0x30a
  w_menvcfg(r_menvcfg() | MENVCFG_ADUE);
    800000b4:	4705                	li	a4,1
    800000b6:	1776                	slli	a4,a4,0x3d
    800000b8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    800000ba:	30a79073          	csrw	0x30a,a5
  timerinit();
    800000be:	f5fff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800000c2:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c6:	2781                	sext.w	a5,a5
}

static inline void
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r"(x));
    800000c8:	823e                	mv	tp,a5
  asm volatile("mret");
    800000ca:	30200073          	mret
}
    800000ce:	60a2                	ld	ra,8(sp)
    800000d0:	6402                	ld	s0,0(sp)
    800000d2:	0141                	addi	sp,sp,16
    800000d4:	8082                	ret

00000000800000d6 <consolewrite>:
// user write() system calls to the console go here.
// uses sleep() and UART interrupts.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d6:	7119                	addi	sp,sp,-128
    800000d8:	fc86                	sd	ra,120(sp)
    800000da:	f8a2                	sd	s0,112(sp)
    800000dc:	f4a6                	sd	s1,104(sp)
    800000de:	0100                	addi	s0,sp,128
  char buf[32]; // move batches from user space to uart.
  int i = 0;

  while (i < n) {
    800000e0:	06c05b63          	blez	a2,80000156 <consolewrite+0x80>
    800000e4:	f0ca                	sd	s2,96(sp)
    800000e6:	ecce                	sd	s3,88(sp)
    800000e8:	e8d2                	sd	s4,80(sp)
    800000ea:	e4d6                	sd	s5,72(sp)
    800000ec:	e0da                	sd	s6,64(sp)
    800000ee:	fc5e                	sd	s7,56(sp)
    800000f0:	f862                	sd	s8,48(sp)
    800000f2:	f466                	sd	s9,40(sp)
    800000f4:	f06a                	sd	s10,32(sp)
    800000f6:	8b2a                	mv	s6,a0
    800000f8:	8bae                	mv	s7,a1
    800000fa:	8a32                	mv	s4,a2
  int i = 0;
    800000fc:	4481                	li	s1,0
    int nn = sizeof(buf);
    if (nn > n - i)
    800000fe:	02000c93          	li	s9,32
    80000102:	02000d13          	li	s10,32
      nn = n - i;
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    80000106:	f8040a93          	addi	s5,s0,-128
    8000010a:	5c7d                	li	s8,-1
    8000010c:	a025                	j	80000134 <consolewrite+0x5e>
    if (nn > n - i)
    8000010e:	0009099b          	sext.w	s3,s2
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    80000112:	86ce                	mv	a3,s3
    80000114:	01748633          	add	a2,s1,s7
    80000118:	85da                	mv	a1,s6
    8000011a:	8556                	mv	a0,s5
    8000011c:	350020ef          	jal	8000246c <either_copyin>
    80000120:	03850d63          	beq	a0,s8,8000015a <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80000124:	85ce                	mv	a1,s3
    80000126:	8556                	mv	a0,s5
    80000128:	7d6000ef          	jal	800008fe <uartwrite>
    i += nn;
    8000012c:	009904bb          	addw	s1,s2,s1
  while (i < n) {
    80000130:	0144d963          	bge	s1,s4,80000142 <consolewrite+0x6c>
    if (nn > n - i)
    80000134:	409a07bb          	subw	a5,s4,s1
    80000138:	893e                	mv	s2,a5
    8000013a:	fcfcdae3          	bge	s9,a5,8000010e <consolewrite+0x38>
    8000013e:	896a                	mv	s2,s10
    80000140:	b7f9                	j	8000010e <consolewrite+0x38>
    80000142:	7906                	ld	s2,96(sp)
    80000144:	69e6                	ld	s3,88(sp)
    80000146:	6a46                	ld	s4,80(sp)
    80000148:	6aa6                	ld	s5,72(sp)
    8000014a:	6b06                	ld	s6,64(sp)
    8000014c:	7be2                	ld	s7,56(sp)
    8000014e:	7c42                	ld	s8,48(sp)
    80000150:	7ca2                	ld	s9,40(sp)
    80000152:	7d02                	ld	s10,32(sp)
    80000154:	a821                	j	8000016c <consolewrite+0x96>
  int i = 0;
    80000156:	4481                	li	s1,0
    80000158:	a811                	j	8000016c <consolewrite+0x96>
    8000015a:	7906                	ld	s2,96(sp)
    8000015c:	69e6                	ld	s3,88(sp)
    8000015e:	6a46                	ld	s4,80(sp)
    80000160:	6aa6                	ld	s5,72(sp)
    80000162:	6b06                	ld	s6,64(sp)
    80000164:	7be2                	ld	s7,56(sp)
    80000166:	7c42                	ld	s8,48(sp)
    80000168:	7ca2                	ld	s9,40(sp)
    8000016a:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000016c:	8526                	mv	a0,s1
    8000016e:	70e6                	ld	ra,120(sp)
    80000170:	7446                	ld	s0,112(sp)
    80000172:	74a6                	ld	s1,104(sp)
    80000174:	6109                	addi	sp,sp,128
    80000176:	8082                	ret

0000000080000178 <consoleread>:
// user_dst indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000178:	711d                	addi	sp,sp,-96
    8000017a:	ec86                	sd	ra,88(sp)
    8000017c:	e8a2                	sd	s0,80(sp)
    8000017e:	e4a6                	sd	s1,72(sp)
    80000180:	e0ca                	sd	s2,64(sp)
    80000182:	fc4e                	sd	s3,56(sp)
    80000184:	f852                	sd	s4,48(sp)
    80000186:	f05a                	sd	s6,32(sp)
    80000188:	ec5e                	sd	s7,24(sp)
    8000018a:	1080                	addi	s0,sp,96
    8000018c:	8b2a                	mv	s6,a0
    8000018e:	8a2e                	mv	s4,a1
    80000190:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000192:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80000194:	00012517          	auipc	a0,0x12
    80000198:	28c50513          	addi	a0,a0,652 # 80012420 <cons>
    8000019c:	25d000ef          	jal	80000bf8 <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    800001a0:	00012497          	auipc	s1,0x12
    800001a4:	28048493          	addi	s1,s1,640 # 80012420 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep_prepare(&cons.r);
    800001a8:	00012917          	auipc	s2,0x12
    800001ac:	31090913          	addi	s2,s2,784 # 800124b8 <cons+0x98>
  while (n > 0) {
    800001b0:	0d305263          	blez	s3,80000274 <consoleread+0xfc>
    while (cons.r == cons.w) {
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	0af71763          	bne	a4,a5,8000026a <consoleread+0xf2>
      if (killed(myproc())) {
    800001c0:	71e010ef          	jal	800018de <myproc>
    800001c4:	12a020ef          	jal	800022ee <killed>
    800001c8:	e925                	bnez	a0,80000238 <consoleread+0xc0>
      sleep_prepare(&cons.r);
    800001ca:	854a                	mv	a0,s2
    800001cc:	69b010ef          	jal	80002066 <sleep_prepare>
      release(&cons.lock);
    800001d0:	8526                	mv	a0,s1
    800001d2:	2ab000ef          	jal	80000c7c <release>
      sleep();
    800001d6:	6cd010ef          	jal	800020a2 <sleep>
      acquire(&cons.lock);
    800001da:	8526                	mv	a0,s1
    800001dc:	21d000ef          	jal	80000bf8 <acquire>
    while (cons.r == cons.w) {
    800001e0:	0984a783          	lw	a5,152(s1)
    800001e4:	09c4a703          	lw	a4,156(s1)
    800001e8:	fcf70ce3          	beq	a4,a5,800001c0 <consoleread+0x48>
    800001ec:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ee:	00012717          	auipc	a4,0x12
    800001f2:	23270713          	addi	a4,a4,562 # 80012420 <cons>
    800001f6:	0017869b          	addiw	a3,a5,1
    800001fa:	08d72c23          	sw	a3,152(a4)
    800001fe:	07f7f693          	andi	a3,a5,127
    80000202:	9736                	add	a4,a4,a3
    80000204:	01874703          	lbu	a4,24(a4)
    80000208:	00070a9b          	sext.w	s5,a4

    if (c == C('D')) { // end-of-file
    8000020c:	4691                	li	a3,4
    8000020e:	04da8663          	beq	s5,a3,8000025a <consoleread+0xe2>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000212:	fae407a3          	sb	a4,-81(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000216:	4685                	li	a3,1
    80000218:	faf40613          	addi	a2,s0,-81
    8000021c:	85d2                	mv	a1,s4
    8000021e:	855a                	mv	a0,s6
    80000220:	200020ef          	jal	80002420 <either_copyout>
    80000224:	57fd                	li	a5,-1
    80000226:	04f50663          	beq	a0,a5,80000272 <consoleread+0xfa>
      break;

    dst++;
    8000022a:	0a05                	addi	s4,s4,1
    --n;
    8000022c:	39fd                	addiw	s3,s3,-1

    if (c == '\n') {
    8000022e:	47a9                	li	a5,10
    80000230:	04fa8b63          	beq	s5,a5,80000286 <consoleread+0x10e>
    80000234:	7aa2                	ld	s5,40(sp)
    80000236:	bfad                	j	800001b0 <consoleread+0x38>
        release(&cons.lock);
    80000238:	00012517          	auipc	a0,0x12
    8000023c:	1e850513          	addi	a0,a0,488 # 80012420 <cons>
    80000240:	23d000ef          	jal	80000c7c <release>
        return -1;
    80000244:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000246:	60e6                	ld	ra,88(sp)
    80000248:	6446                	ld	s0,80(sp)
    8000024a:	64a6                	ld	s1,72(sp)
    8000024c:	6906                	ld	s2,64(sp)
    8000024e:	79e2                	ld	s3,56(sp)
    80000250:	7a42                	ld	s4,48(sp)
    80000252:	7b02                	ld	s6,32(sp)
    80000254:	6be2                	ld	s7,24(sp)
    80000256:	6125                	addi	sp,sp,96
    80000258:	8082                	ret
      if (n < target) {
    8000025a:	0179fa63          	bgeu	s3,s7,8000026e <consoleread+0xf6>
        cons.r--;
    8000025e:	00012717          	auipc	a4,0x12
    80000262:	24f72d23          	sw	a5,602(a4) # 800124b8 <cons+0x98>
    80000266:	7aa2                	ld	s5,40(sp)
    80000268:	a031                	j	80000274 <consoleread+0xfc>
    8000026a:	f456                	sd	s5,40(sp)
    8000026c:	b749                	j	800001ee <consoleread+0x76>
    8000026e:	7aa2                	ld	s5,40(sp)
    80000270:	a011                	j	80000274 <consoleread+0xfc>
    80000272:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000274:	00012517          	auipc	a0,0x12
    80000278:	1ac50513          	addi	a0,a0,428 # 80012420 <cons>
    8000027c:	201000ef          	jal	80000c7c <release>
  return target - n;
    80000280:	413b853b          	subw	a0,s7,s3
    80000284:	b7c9                	j	80000246 <consoleread+0xce>
    80000286:	7aa2                	ld	s5,40(sp)
    80000288:	b7f5                	j	80000274 <consoleread+0xfc>

000000008000028a <consputc>:
{
    8000028a:	1141                	addi	sp,sp,-16
    8000028c:	e406                	sd	ra,8(sp)
    8000028e:	e022                	sd	s0,0(sp)
    80000290:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80000292:	10000793          	li	a5,256
    80000296:	00f50863          	beq	a0,a5,800002a6 <consputc+0x1c>
    uartputc_sync(c);
    8000029a:	6ea000ef          	jal	80000984 <uartputc_sync>
}
    8000029e:	60a2                	ld	ra,8(sp)
    800002a0:	6402                	ld	s0,0(sp)
    800002a2:	0141                	addi	sp,sp,16
    800002a4:	8082                	ret
    uartputc_sync('\b');
    800002a6:	4521                	li	a0,8
    800002a8:	6dc000ef          	jal	80000984 <uartputc_sync>
    uartputc_sync(' ');
    800002ac:	02000513          	li	a0,32
    800002b0:	6d4000ef          	jal	80000984 <uartputc_sync>
    uartputc_sync('\b');
    800002b4:	4521                	li	a0,8
    800002b6:	6ce000ef          	jal	80000984 <uartputc_sync>
    800002ba:	b7d5                	j	8000029e <consputc+0x14>

00000000800002bc <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002bc:	1101                	addi	sp,sp,-32
    800002be:	ec06                	sd	ra,24(sp)
    800002c0:	e822                	sd	s0,16(sp)
    800002c2:	e426                	sd	s1,8(sp)
    800002c4:	1000                	addi	s0,sp,32
    800002c6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002c8:	00012517          	auipc	a0,0x12
    800002cc:	15850513          	addi	a0,a0,344 # 80012420 <cons>
    800002d0:	129000ef          	jal	80000bf8 <acquire>

  switch (c) {
    800002d4:	47d5                	li	a5,21
    800002d6:	0af48163          	beq	s1,a5,80000378 <consoleintr+0xbc>
    800002da:	0297c563          	blt	a5,s1,80000304 <consoleintr+0x48>
    800002de:	47a1                	li	a5,8
    800002e0:	0ef48663          	beq	s1,a5,800003cc <consoleintr+0x110>
    800002e4:	47c1                	li	a5,16
    800002e6:	10f49763          	bne	s1,a5,800003f4 <consoleintr+0x138>
  case C('P'): // Print process list.
    procdump();
    800002ea:	1ce020ef          	jal	800024b8 <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002ee:	00012517          	auipc	a0,0x12
    800002f2:	13250513          	addi	a0,a0,306 # 80012420 <cons>
    800002f6:	187000ef          	jal	80000c7c <release>
}
    800002fa:	60e2                	ld	ra,24(sp)
    800002fc:	6442                	ld	s0,16(sp)
    800002fe:	64a2                	ld	s1,8(sp)
    80000300:	6105                	addi	sp,sp,32
    80000302:	8082                	ret
  switch (c) {
    80000304:	07f00793          	li	a5,127
    80000308:	0cf48263          	beq	s1,a5,800003cc <consoleintr+0x110>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    8000030c:	00012717          	auipc	a4,0x12
    80000310:	11470713          	addi	a4,a4,276 # 80012420 <cons>
    80000314:	0a072783          	lw	a5,160(a4)
    80000318:	09872703          	lw	a4,152(a4)
    8000031c:	9f99                	subw	a5,a5,a4
    8000031e:	07f00713          	li	a4,127
    80000322:	fcf766e3          	bltu	a4,a5,800002ee <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80000326:	47b5                	li	a5,13
    80000328:	0cf48963          	beq	s1,a5,800003fa <consoleintr+0x13e>
      consputc(c);
    8000032c:	8526                	mv	a0,s1
    8000032e:	f5dff0ef          	jal	8000028a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000332:	00012717          	auipc	a4,0x12
    80000336:	0ee70713          	addi	a4,a4,238 # 80012420 <cons>
    8000033a:	0a072683          	lw	a3,160(a4)
    8000033e:	0016879b          	addiw	a5,a3,1
    80000342:	863e                	mv	a2,a5
    80000344:	0af72023          	sw	a5,160(a4)
    80000348:	07f6f693          	andi	a3,a3,127
    8000034c:	9736                	add	a4,a4,a3
    8000034e:	00970c23          	sb	s1,24(a4)
      if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80000352:	ff648713          	addi	a4,s1,-10
    80000356:	00173713          	seqz	a4,a4
    8000035a:	14f1                	addi	s1,s1,-4
    8000035c:	0014b493          	seqz	s1,s1
    80000360:	8f45                	or	a4,a4,s1
    80000362:	e361                	bnez	a4,80000422 <consoleintr+0x166>
    80000364:	00012717          	auipc	a4,0x12
    80000368:	15472703          	lw	a4,340(a4) # 800124b8 <cons+0x98>
    8000036c:	9f99                	subw	a5,a5,a4
    8000036e:	08000713          	li	a4,128
    80000372:	f6e79ee3          	bne	a5,a4,800002ee <consoleintr+0x32>
    80000376:	a075                	j	80000422 <consoleintr+0x166>
    80000378:	e04a                	sd	s2,0(sp)
    while (cons.e != cons.w &&
    8000037a:	00012717          	auipc	a4,0x12
    8000037e:	0a670713          	addi	a4,a4,166 # 80012420 <cons>
    80000382:	0a072783          	lw	a5,160(a4)
    80000386:	09c72703          	lw	a4,156(a4)
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    8000038a:	00012497          	auipc	s1,0x12
    8000038e:	09648493          	addi	s1,s1,150 # 80012420 <cons>
    while (cons.e != cons.w &&
    80000392:	4929                	li	s2,10
    80000394:	02f70863          	beq	a4,a5,800003c4 <consoleintr+0x108>
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80000398:	37fd                	addiw	a5,a5,-1
    8000039a:	07f7f713          	andi	a4,a5,127
    8000039e:	9726                	add	a4,a4,s1
    while (cons.e != cons.w &&
    800003a0:	01874703          	lbu	a4,24(a4)
    800003a4:	03270263          	beq	a4,s2,800003c8 <consoleintr+0x10c>
      cons.e--;
    800003a8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003ac:	10000513          	li	a0,256
    800003b0:	edbff0ef          	jal	8000028a <consputc>
    while (cons.e != cons.w &&
    800003b4:	0a04a783          	lw	a5,160(s1)
    800003b8:	09c4a703          	lw	a4,156(s1)
    800003bc:	fcf71ee3          	bne	a4,a5,80000398 <consoleintr+0xdc>
    800003c0:	6902                	ld	s2,0(sp)
    800003c2:	b735                	j	800002ee <consoleintr+0x32>
    800003c4:	6902                	ld	s2,0(sp)
    800003c6:	b725                	j	800002ee <consoleintr+0x32>
    800003c8:	6902                	ld	s2,0(sp)
    800003ca:	b715                	j	800002ee <consoleintr+0x32>
    if (cons.e != cons.w) {
    800003cc:	00012717          	auipc	a4,0x12
    800003d0:	05470713          	addi	a4,a4,84 # 80012420 <cons>
    800003d4:	0a072783          	lw	a5,160(a4)
    800003d8:	09c72703          	lw	a4,156(a4)
    800003dc:	f0f709e3          	beq	a4,a5,800002ee <consoleintr+0x32>
      cons.e--;
    800003e0:	37fd                	addiw	a5,a5,-1
    800003e2:	00012717          	auipc	a4,0x12
    800003e6:	0cf72f23          	sw	a5,222(a4) # 800124c0 <cons+0xa0>
      consputc(BACKSPACE);
    800003ea:	10000513          	li	a0,256
    800003ee:	e9dff0ef          	jal	8000028a <consputc>
    800003f2:	bdf5                	j	800002ee <consoleintr+0x32>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    800003f4:	ee048de3          	beqz	s1,800002ee <consoleintr+0x32>
    800003f8:	bf11                	j	8000030c <consoleintr+0x50>
      consputc(c);
    800003fa:	4529                	li	a0,10
    800003fc:	e8fff0ef          	jal	8000028a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000400:	00012797          	auipc	a5,0x12
    80000404:	02078793          	addi	a5,a5,32 # 80012420 <cons>
    80000408:	0a07a703          	lw	a4,160(a5)
    8000040c:	0017069b          	addiw	a3,a4,1
    80000410:	8636                	mv	a2,a3
    80000412:	0ad7a023          	sw	a3,160(a5)
    80000416:	07f77713          	andi	a4,a4,127
    8000041a:	97ba                	add	a5,a5,a4
    8000041c:	4729                	li	a4,10
    8000041e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000422:	00012797          	auipc	a5,0x12
    80000426:	08c7ad23          	sw	a2,154(a5) # 800124bc <cons+0x9c>
        wakeup(&cons.r);
    8000042a:	00012517          	auipc	a0,0x12
    8000042e:	08e50513          	addi	a0,a0,142 # 800124b8 <cons+0x98>
    80000432:	4a5010ef          	jal	800020d6 <wakeup>
    80000436:	bd65                	j	800002ee <consoleintr+0x32>

0000000080000438 <consoleinit>:

void
consoleinit(void)
{
    80000438:	1141                	addi	sp,sp,-16
    8000043a:	e406                	sd	ra,8(sp)
    8000043c:	e022                	sd	s0,0(sp)
    8000043e:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000440:	00007597          	auipc	a1,0x7
    80000444:	bc058593          	addi	a1,a1,-1088 # 80007000 <etext>
    80000448:	00012517          	auipc	a0,0x12
    8000044c:	fd850513          	addi	a0,a0,-40 # 80012420 <cons>
    80000450:	728000ef          	jal	80000b78 <initlock>

  uartinit();
    80000454:	454000ef          	jal	800008a8 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000458:	00022797          	auipc	a5,0x22
    8000045c:	76078793          	addi	a5,a5,1888 # 80022bb8 <devsw>
    80000460:	00000717          	auipc	a4,0x0
    80000464:	d1870713          	addi	a4,a4,-744 # 80000178 <consoleread>
    80000468:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000046a:	00000717          	auipc	a4,0x0
    8000046e:	c6c70713          	addi	a4,a4,-916 # 800000d6 <consolewrite>
    80000472:	ef98                	sd	a4,24(a5)
}
    80000474:	60a2                	ld	ra,8(sp)
    80000476:	6402                	ld	s0,0(sp)
    80000478:	0141                	addi	sp,sp,16
    8000047a:	8082                	ret

000000008000047c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000047c:	7139                	addi	sp,sp,-64
    8000047e:	fc06                	sd	ra,56(sp)
    80000480:	f822                	sd	s0,48(sp)
    80000482:	f04a                	sd	s2,32(sp)
    80000484:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if (sign && (sign = (xx < 0)))
    80000486:	c219                	beqz	a2,8000048c <printint+0x10>
    80000488:	08054063          	bltz	a0,80000508 <printint+0x8c>
    x = -xx;
  else
    x = xx;
    8000048c:	4301                	li	t1,0

  i = 0;
    8000048e:	fc840913          	addi	s2,s0,-56
    x = xx;
    80000492:	86ca                	mv	a3,s2
  i = 0;
    80000494:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80000496:	00007817          	auipc	a6,0x7
    8000049a:	3b280813          	addi	a6,a6,946 # 80007848 <digits>
    8000049e:	88ba                	mv	a7,a4
    800004a0:	0017061b          	addiw	a2,a4,1
    800004a4:	8732                	mv	a4,a2
    800004a6:	02b577b3          	remu	a5,a0,a1
    800004aa:	97c2                	add	a5,a5,a6
    800004ac:	0007c783          	lbu	a5,0(a5)
    800004b0:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    800004b4:	87aa                	mv	a5,a0
    800004b6:	02b55533          	divu	a0,a0,a1
    800004ba:	0685                	addi	a3,a3,1
    800004bc:	feb7f1e3          	bgeu	a5,a1,8000049e <printint+0x22>

  if (sign)
    800004c0:	00030b63          	beqz	t1,800004d6 <printint+0x5a>
    buf[i++] = '-';
    800004c4:	fe040793          	addi	a5,s0,-32
    800004c8:	963e                	add	a2,a2,a5
    800004ca:	02d00793          	li	a5,45
    800004ce:	fef60423          	sb	a5,-24(a2)
    800004d2:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
    800004d6:	02e05463          	blez	a4,800004fe <printint+0x82>
    800004da:	f426                	sd	s1,40(sp)
    800004dc:	377d                	addiw	a4,a4,-1
    800004de:	00e904b3          	add	s1,s2,a4
    800004e2:	197d                	addi	s2,s2,-1
    800004e4:	993a                	add	s2,s2,a4
    800004e6:	1702                	slli	a4,a4,0x20
    800004e8:	9301                	srli	a4,a4,0x20
    800004ea:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800004ee:	0004c503          	lbu	a0,0(s1)
    800004f2:	d99ff0ef          	jal	8000028a <consputc>
  while (--i >= 0)
    800004f6:	14fd                	addi	s1,s1,-1
    800004f8:	ff249be3          	bne	s1,s2,800004ee <printint+0x72>
    800004fc:	74a2                	ld	s1,40(sp)
}
    800004fe:	70e2                	ld	ra,56(sp)
    80000500:	7442                	ld	s0,48(sp)
    80000502:	7902                	ld	s2,32(sp)
    80000504:	6121                	addi	sp,sp,64
    80000506:	8082                	ret
    x = -xx;
    80000508:	40a00533          	neg	a0,a0
  if (sign && (sign = (xx < 0)))
    8000050c:	4305                	li	t1,1
    x = -xx;
    8000050e:	b741                	j	8000048e <printint+0x12>

0000000080000510 <printk>:
}

// Print to the console.
int
printk(char *fmt, ...)
{
    80000510:	7131                	addi	sp,sp,-192
    80000512:	fc86                	sd	ra,120(sp)
    80000514:	f8a2                	sd	s0,112(sp)
    80000516:	f4a6                	sd	s1,104(sp)
    80000518:	0100                	addi	s0,sp,128
    8000051a:	84aa                	mv	s1,a0
    8000051c:	e40c                	sd	a1,8(s0)
    8000051e:	e810                	sd	a2,16(s0)
    80000520:	ec14                	sd	a3,24(s0)
    80000522:	f018                	sd	a4,32(s0)
    80000524:	f41c                	sd	a5,40(s0)
    80000526:	03043823          	sd	a6,48(s0)
    8000052a:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if (panicking == 0)
    8000052e:	0000a797          	auipc	a5,0xa
    80000532:	ec67a783          	lw	a5,-314(a5) # 8000a3f4 <panicking>
    80000536:	cf9d                	beqz	a5,80000574 <printk+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000538:	00840793          	addi	a5,s0,8
    8000053c:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    80000540:	0004c503          	lbu	a0,0(s1)
    80000544:	22050363          	beqz	a0,8000076a <printk+0x25a>
    80000548:	f0ca                	sd	s2,96(sp)
    8000054a:	ecce                	sd	s3,88(sp)
    8000054c:	e8d2                	sd	s4,80(sp)
    8000054e:	e4d6                	sd	s5,72(sp)
    80000550:	e0da                	sd	s6,64(sp)
    80000552:	fc5e                	sd	s7,56(sp)
    80000554:	f862                	sd	s8,48(sp)
    80000556:	f06a                	sd	s10,32(sp)
    80000558:	ec6e                	sd	s11,24(sp)
    8000055a:	4a01                	li	s4,0
    if (cx != '%') {
    8000055c:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if (c0 == 'u') {
    80000560:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if (c0 == 'x') {
    80000564:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if (c0 == 'p') {
    80000568:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    8000056c:	4b29                	li	s6,10
    if (c0 == 'd') {
    8000056e:	06400b93          	li	s7,100
    80000572:	a015                	j	80000596 <printk+0x86>
    acquire(&pr.lock);
    80000574:	00012517          	auipc	a0,0x12
    80000578:	f5450513          	addi	a0,a0,-172 # 800124c8 <pr>
    8000057c:	67c000ef          	jal	80000bf8 <acquire>
    80000580:	bf65                	j	80000538 <printk+0x28>
      consputc(cx);
    80000582:	d09ff0ef          	jal	8000028a <consputc>
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    80000586:	001a079b          	addiw	a5,s4,1
    8000058a:	8a3e                	mv	s4,a5
    8000058c:	97a6                	add	a5,a5,s1
    8000058e:	0007c503          	lbu	a0,0(a5)
    80000592:	1c050363          	beqz	a0,80000758 <printk+0x248>
    if (cx != '%') {
    80000596:	ff3516e3          	bne	a0,s3,80000582 <printk+0x72>
    i++;
    8000059a:	001a091b          	addiw	s2,s4,1
    c0 = fmt[i + 0] & 0xff;
    8000059e:	012487b3          	add	a5,s1,s2
    800005a2:	0007ca83          	lbu	s5,0(a5)
    if (c0)
    800005a6:	200a8763          	beqz	s5,800007b4 <printk+0x2a4>
      c1 = fmt[i + 1] & 0xff;
    800005aa:	0017c703          	lbu	a4,1(a5)
    if (c1)
    800005ae:	1e070a63          	beqz	a4,800007a2 <printk+0x292>
    if (c0 == 'd') {
    800005b2:	037a8963          	beq	s5,s7,800005e4 <printk+0xd4>
    } else if (c0 == 'l' && c1 == 'd') {
    800005b6:	f94a8793          	addi	a5,s5,-108
    800005ba:	0017b793          	seqz	a5,a5
    800005be:	f9c70693          	addi	a3,a4,-100
    800005c2:	0016b693          	seqz	a3,a3
    800005c6:	8efd                	and	a3,a3,a5
    800005c8:	ca9d                	beqz	a3,800005fe <printk+0xee>
      printint(va_arg(ap, uint64), 10, 1);
    800005ca:	f8843783          	ld	a5,-120(s0)
    800005ce:	00878713          	addi	a4,a5,8
    800005d2:	f8e43423          	sd	a4,-120(s0)
    800005d6:	4605                	li	a2,1
    800005d8:	85da                	mv	a1,s6
    800005da:	6388                	ld	a0,0(a5)
    800005dc:	ea1ff0ef          	jal	8000047c <printint>
      i += 1;
    800005e0:	2a09                	addiw	s4,s4,2
    800005e2:	b755                	j	80000586 <printk+0x76>
      printint(va_arg(ap, int), 10, 1);
    800005e4:	f8843783          	ld	a5,-120(s0)
    800005e8:	00878713          	addi	a4,a5,8
    800005ec:	f8e43423          	sd	a4,-120(s0)
    800005f0:	4605                	li	a2,1
    800005f2:	85da                	mv	a1,s6
    800005f4:	4388                	lw	a0,0(a5)
    800005f6:	e87ff0ef          	jal	8000047c <printint>
    i++;
    800005fa:	8a4a                	mv	s4,s2
    800005fc:	b769                	j	80000586 <printk+0x76>
      c2 = fmt[i + 2] & 0xff;
    800005fe:	012486b3          	add	a3,s1,s2
    80000602:	863a                	mv	a2,a4
    80000604:	0026c703          	lbu	a4,2(a3)
    80000608:	aa65                	j	800007c0 <printk+0x2b0>
      printint(va_arg(ap, uint64), 10, 1);
    8000060a:	f8843783          	ld	a5,-120(s0)
    8000060e:	00878713          	addi	a4,a5,8
    80000612:	f8e43423          	sd	a4,-120(s0)
    80000616:	4605                	li	a2,1
    80000618:	45a9                	li	a1,10
    8000061a:	6388                	ld	a0,0(a5)
    8000061c:	e61ff0ef          	jal	8000047c <printint>
      i += 2;
    80000620:	2a0d                	addiw	s4,s4,3
    80000622:	b795                	j	80000586 <printk+0x76>
      printint(va_arg(ap, uint32), 10, 0);
    80000624:	f8843783          	ld	a5,-120(s0)
    80000628:	00878713          	addi	a4,a5,8
    8000062c:	f8e43423          	sd	a4,-120(s0)
    80000630:	4601                	li	a2,0
    80000632:	85da                	mv	a1,s6
    80000634:	0007e503          	lwu	a0,0(a5)
    80000638:	e45ff0ef          	jal	8000047c <printint>
    8000063c:	bf7d                	j	800005fa <printk+0xea>
      printint(va_arg(ap, uint64), 10, 0);
    8000063e:	f8843783          	ld	a5,-120(s0)
    80000642:	00878713          	addi	a4,a5,8
    80000646:	f8e43423          	sd	a4,-120(s0)
    8000064a:	4601                	li	a2,0
    8000064c:	85da                	mv	a1,s6
    8000064e:	6388                	ld	a0,0(a5)
    80000650:	e2dff0ef          	jal	8000047c <printint>
      i += 1;
    80000654:	2a09                	addiw	s4,s4,2
    80000656:	bf05                	j	80000586 <printk+0x76>
      printint(va_arg(ap, uint64), 10, 0);
    80000658:	f8843783          	ld	a5,-120(s0)
    8000065c:	00878713          	addi	a4,a5,8
    80000660:	f8e43423          	sd	a4,-120(s0)
    80000664:	4601                	li	a2,0
    80000666:	45a9                	li	a1,10
    80000668:	6388                	ld	a0,0(a5)
    8000066a:	e13ff0ef          	jal	8000047c <printint>
      i += 2;
    8000066e:	2a0d                	addiw	s4,s4,3
    80000670:	bf19                	j	80000586 <printk+0x76>
      printint(va_arg(ap, uint32), 16, 0);
    80000672:	f8843783          	ld	a5,-120(s0)
    80000676:	00878713          	addi	a4,a5,8
    8000067a:	f8e43423          	sd	a4,-120(s0)
    8000067e:	4601                	li	a2,0
    80000680:	45c1                	li	a1,16
    80000682:	0007e503          	lwu	a0,0(a5)
    80000686:	df7ff0ef          	jal	8000047c <printint>
    8000068a:	bf85                	j	800005fa <printk+0xea>
      printint(va_arg(ap, uint64), 16, 0);
    8000068c:	f8843783          	ld	a5,-120(s0)
    80000690:	00878713          	addi	a4,a5,8
    80000694:	f8e43423          	sd	a4,-120(s0)
    80000698:	4601                	li	a2,0
    8000069a:	45c1                	li	a1,16
    8000069c:	6388                	ld	a0,0(a5)
    8000069e:	ddfff0ef          	jal	8000047c <printint>
      i += 1;
    800006a2:	2a09                	addiw	s4,s4,2
    800006a4:	b5cd                	j	80000586 <printk+0x76>
      printint(va_arg(ap, uint64), 16, 0);
    800006a6:	f8843783          	ld	a5,-120(s0)
    800006aa:	00878713          	addi	a4,a5,8
    800006ae:	f8e43423          	sd	a4,-120(s0)
    800006b2:	45c1                	li	a1,16
    800006b4:	6388                	ld	a0,0(a5)
    800006b6:	dc7ff0ef          	jal	8000047c <printint>
      i += 2;
    800006ba:	2a0d                	addiw	s4,s4,3
    800006bc:	b5e9                	j	80000586 <printk+0x76>
    800006be:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    800006c0:	f8843783          	ld	a5,-120(s0)
    800006c4:	00878713          	addi	a4,a5,8
    800006c8:	f8e43423          	sd	a4,-120(s0)
    800006cc:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    800006d0:	03000513          	li	a0,48
    800006d4:	bb7ff0ef          	jal	8000028a <consputc>
  consputc('x');
    800006d8:	07800513          	li	a0,120
    800006dc:	bafff0ef          	jal	8000028a <consputc>
    800006e0:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006e2:	00007c97          	auipc	s9,0x7
    800006e6:	166c8c93          	addi	s9,s9,358 # 80007848 <digits>
    800006ea:	03cad793          	srli	a5,s5,0x3c
    800006ee:	97e6                	add	a5,a5,s9
    800006f0:	0007c503          	lbu	a0,0(a5)
    800006f4:	b97ff0ef          	jal	8000028a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006f8:	0a92                	slli	s5,s5,0x4
    800006fa:	3a7d                	addiw	s4,s4,-1
    800006fc:	fe0a17e3          	bnez	s4,800006ea <printk+0x1da>
    80000700:	7ca2                	ld	s9,40(sp)
    80000702:	bde5                	j	800005fa <printk+0xea>
    } else if (c0 == 'c') {
      consputc(va_arg(ap, uint));
    80000704:	f8843783          	ld	a5,-120(s0)
    80000708:	00878713          	addi	a4,a5,8
    8000070c:	f8e43423          	sd	a4,-120(s0)
    80000710:	4388                	lw	a0,0(a5)
    80000712:	b79ff0ef          	jal	8000028a <consputc>
    80000716:	b5d5                	j	800005fa <printk+0xea>
    } else if (c0 == 's') {
      if ((s = va_arg(ap, char *)) == 0)
    80000718:	f8843783          	ld	a5,-120(s0)
    8000071c:	00878713          	addi	a4,a5,8
    80000720:	f8e43423          	sd	a4,-120(s0)
    80000724:	0007ba03          	ld	s4,0(a5)
    80000728:	000a0d63          	beqz	s4,80000742 <printk+0x232>
        s = "(null)";
      for (; *s; s++)
    8000072c:	000a4503          	lbu	a0,0(s4)
    80000730:	ec0505e3          	beqz	a0,800005fa <printk+0xea>
        consputc(*s);
    80000734:	b57ff0ef          	jal	8000028a <consputc>
      for (; *s; s++)
    80000738:	0a05                	addi	s4,s4,1
    8000073a:	000a4503          	lbu	a0,0(s4)
    8000073e:	f97d                	bnez	a0,80000734 <printk+0x224>
    80000740:	bd6d                	j	800005fa <printk+0xea>
        s = "(null)";
    80000742:	00007a17          	auipc	s4,0x7
    80000746:	8c6a0a13          	addi	s4,s4,-1850 # 80007008 <etext+0x8>
      for (; *s; s++)
    8000074a:	02800513          	li	a0,40
    8000074e:	b7dd                	j	80000734 <printk+0x224>
    } else if (c0 == '%') {
      consputc('%');
    80000750:	8556                	mv	a0,s5
    80000752:	b39ff0ef          	jal	8000028a <consputc>
    80000756:	b555                	j	800005fa <printk+0xea>
    80000758:	7906                	ld	s2,96(sp)
    8000075a:	69e6                	ld	s3,88(sp)
    8000075c:	6a46                	ld	s4,80(sp)
    8000075e:	6aa6                	ld	s5,72(sp)
    80000760:	6b06                	ld	s6,64(sp)
    80000762:	7be2                	ld	s7,56(sp)
    80000764:	7c42                	ld	s8,48(sp)
    80000766:	7d02                	ld	s10,32(sp)
    80000768:	6de2                	ld	s11,24(sp)
      consputc(c0);
    }
  }
  va_end(ap);

  if (panicking == 0)
    8000076a:	0000a797          	auipc	a5,0xa
    8000076e:	c8a7a783          	lw	a5,-886(a5) # 8000a3f4 <panicking>
    80000772:	c38d                	beqz	a5,80000794 <printk+0x284>
    release(&pr.lock);

  return 0;
}
    80000774:	4501                	li	a0,0
    80000776:	70e6                	ld	ra,120(sp)
    80000778:	7446                	ld	s0,112(sp)
    8000077a:	74a6                	ld	s1,104(sp)
    8000077c:	6129                	addi	sp,sp,192
    8000077e:	8082                	ret
    80000780:	7906                	ld	s2,96(sp)
    80000782:	69e6                	ld	s3,88(sp)
    80000784:	6a46                	ld	s4,80(sp)
    80000786:	6aa6                	ld	s5,72(sp)
    80000788:	6b06                	ld	s6,64(sp)
    8000078a:	7be2                	ld	s7,56(sp)
    8000078c:	7c42                	ld	s8,48(sp)
    8000078e:	7d02                	ld	s10,32(sp)
    80000790:	6de2                	ld	s11,24(sp)
    80000792:	bfe1                	j	8000076a <printk+0x25a>
    release(&pr.lock);
    80000794:	00012517          	auipc	a0,0x12
    80000798:	d3450513          	addi	a0,a0,-716 # 800124c8 <pr>
    8000079c:	4e0000ef          	jal	80000c7c <release>
  return 0;
    800007a0:	bfd1                	j	80000774 <printk+0x264>
    if (c0 == 'd') {
    800007a2:	e57a81e3          	beq	s5,s7,800005e4 <printk+0xd4>
    } else if (c0 == 'l' && c1 == 'd') {
    800007a6:	f94a8793          	addi	a5,s5,-108
    800007aa:	0017b793          	seqz	a5,a5
    800007ae:	863a                	mv	a2,a4
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    800007b0:	4681                	li	a3,0
    800007b2:	a01d                	j	800007d8 <printk+0x2c8>
    } else if (c0 == 'l' && c1 == 'd') {
    800007b4:	f94a8793          	addi	a5,s5,-108
    800007b8:	0017b793          	seqz	a5,a5
    c1 = c2 = 0;
    800007bc:	8656                	mv	a2,s5
    800007be:	8756                	mv	a4,s5
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    800007c0:	f9460693          	addi	a3,a2,-108
    800007c4:	0016b693          	seqz	a3,a3
    800007c8:	8efd                	and	a3,a3,a5
    800007ca:	f9c70593          	addi	a1,a4,-100
    800007ce:	0015b593          	seqz	a1,a1
    800007d2:	8df5                	and	a1,a1,a3
    800007d4:	e2059be3          	bnez	a1,8000060a <printk+0xfa>
    } else if (c0 == 'u') {
    800007d8:	e58a86e3          	beq	s5,s8,80000624 <printk+0x114>
    } else if (c0 == 'l' && c1 == 'u') {
    800007dc:	f8b60593          	addi	a1,a2,-117
    800007e0:	0015b593          	seqz	a1,a1
    800007e4:	8dfd                	and	a1,a1,a5
    800007e6:	e4059ce3          	bnez	a1,8000063e <printk+0x12e>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    800007ea:	f8b70593          	addi	a1,a4,-117
    800007ee:	0015b593          	seqz	a1,a1
    800007f2:	8df5                	and	a1,a1,a3
    800007f4:	e60592e3          	bnez	a1,80000658 <printk+0x148>
    } else if (c0 == 'x') {
    800007f8:	e7aa8de3          	beq	s5,s10,80000672 <printk+0x162>
    } else if (c0 == 'l' && c1 == 'x') {
    800007fc:	f8860613          	addi	a2,a2,-120
    80000800:	00163613          	seqz	a2,a2
    80000804:	8e7d                	and	a2,a2,a5
    80000806:	e80613e3          	bnez	a2,8000068c <printk+0x17c>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    8000080a:	f8870713          	addi	a4,a4,-120
    8000080e:	00173713          	seqz	a4,a4
    80000812:	8f75                	and	a4,a4,a3
    80000814:	e80719e3          	bnez	a4,800006a6 <printk+0x196>
    } else if (c0 == 'p') {
    80000818:	ebba83e3          	beq	s5,s11,800006be <printk+0x1ae>
    } else if (c0 == 'c') {
    8000081c:	06300793          	li	a5,99
    80000820:	eefa82e3          	beq	s5,a5,80000704 <printk+0x1f4>
    } else if (c0 == 's') {
    80000824:	07300793          	li	a5,115
    80000828:	eefa88e3          	beq	s5,a5,80000718 <printk+0x208>
    } else if (c0 == '%') {
    8000082c:	02500793          	li	a5,37
    80000830:	f2fa80e3          	beq	s5,a5,80000750 <printk+0x240>
    } else if (c0 == 0) {
    80000834:	f40a86e3          	beqz	s5,80000780 <printk+0x270>
      consputc('%');
    80000838:	02500513          	li	a0,37
    8000083c:	a4fff0ef          	jal	8000028a <consputc>
      consputc(c0);
    80000840:	8556                	mv	a0,s5
    80000842:	a49ff0ef          	jal	8000028a <consputc>
    80000846:	bb55                	j	800005fa <printk+0xea>

0000000080000848 <panic>:

void
panic(char *s)
{
    80000848:	1101                	addi	sp,sp,-32
    8000084a:	ec06                	sd	ra,24(sp)
    8000084c:	e822                	sd	s0,16(sp)
    8000084e:	e426                	sd	s1,8(sp)
    80000850:	e04a                	sd	s2,0(sp)
    80000852:	1000                	addi	s0,sp,32
    80000854:	892a                	mv	s2,a0
  panicking = 1;
    80000856:	4485                	li	s1,1
    80000858:	0000a797          	auipc	a5,0xa
    8000085c:	b897ae23          	sw	s1,-1124(a5) # 8000a3f4 <panicking>
  printk("panic: ");
    80000860:	00006517          	auipc	a0,0x6
    80000864:	7b850513          	addi	a0,a0,1976 # 80007018 <etext+0x18>
    80000868:	ca9ff0ef          	jal	80000510 <printk>
  printk("%s\n", s);
    8000086c:	85ca                	mv	a1,s2
    8000086e:	00006517          	auipc	a0,0x6
    80000872:	7b250513          	addi	a0,a0,1970 # 80007020 <etext+0x20>
    80000876:	c9bff0ef          	jal	80000510 <printk>
  panicked = 1; // freeze uart output from other CPUs
    8000087a:	0000a797          	auipc	a5,0xa
    8000087e:	b697ab23          	sw	s1,-1162(a5) # 8000a3f0 <panicked>
  for (;;)
    80000882:	a001                	j	80000882 <panic+0x3a>

0000000080000884 <printkinit>:
    ;
}

void
printkinit(void)
{
    80000884:	1141                	addi	sp,sp,-16
    80000886:	e406                	sd	ra,8(sp)
    80000888:	e022                	sd	s0,0(sp)
    8000088a:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    8000088c:	00006597          	auipc	a1,0x6
    80000890:	79c58593          	addi	a1,a1,1948 # 80007028 <etext+0x28>
    80000894:	00012517          	auipc	a0,0x12
    80000898:	c3450513          	addi	a0,a0,-972 # 800124c8 <pr>
    8000089c:	2dc000ef          	jal	80000b78 <initlock>
}
    800008a0:	60a2                	ld	ra,8(sp)
    800008a2:	6402                	ld	s0,0(sp)
    800008a4:	0141                	addi	sp,sp,16
    800008a6:	8082                	ret

00000000800008a8 <uartinit>:
extern volatile int panicking; // from printk.c
extern volatile int panicked;  // from printk.c

void
uartinit(void)
{
    800008a8:	1141                	addi	sp,sp,-16
    800008aa:	e406                	sd	ra,8(sp)
    800008ac:	e022                	sd	s0,0(sp)
    800008ae:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800008b0:	100007b7          	lui	a5,0x10000
    800008b4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800008b8:	10000737          	lui	a4,0x10000
    800008bc:	f8000693          	li	a3,-128
    800008c0:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800008c4:	468d                	li	a3,3
    800008c6:	10000637          	lui	a2,0x10000
    800008ca:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800008ce:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800008d2:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800008d6:	8732                	mv	a4,a2
    800008d8:	461d                	li	a2,7
    800008da:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800008de:	00d780a3          	sb	a3,1(a5)

  initsleeplock(&tx_lock, "uart");
    800008e2:	00006597          	auipc	a1,0x6
    800008e6:	74e58593          	addi	a1,a1,1870 # 80007030 <etext+0x30>
    800008ea:	00012517          	auipc	a0,0x12
    800008ee:	bf650513          	addi	a0,a0,-1034 # 800124e0 <tx_lock>
    800008f2:	0e3030ef          	jal	800041d4 <initsleeplock>
}
    800008f6:	60a2                	ld	ra,8(sp)
    800008f8:	6402                	ld	s0,0(sp)
    800008fa:	0141                	addi	sp,sp,16
    800008fc:	8082                	ret

00000000800008fe <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800008fe:	7139                	addi	sp,sp,-64
    80000900:	fc06                	sd	ra,56(sp)
    80000902:	f822                	sd	s0,48(sp)
    80000904:	f04a                	sd	s2,32(sp)
    80000906:	e456                	sd	s5,8(sp)
    80000908:	0080                	addi	s0,sp,64
    8000090a:	8aaa                	mv	s5,a0
    8000090c:	892e                	mv	s2,a1
  acquiresleep(&tx_lock);
    8000090e:	00012517          	auipc	a0,0x12
    80000912:	bd250513          	addi	a0,a0,-1070 # 800124e0 <tx_lock>
    80000916:	0f5030ef          	jal	8000420a <acquiresleep>

  int i = 0;
  while (i < n) {
    8000091a:	05205963          	blez	s2,8000096c <uartwrite+0x6e>
    8000091e:	f426                	sd	s1,40(sp)
    80000920:	ec4e                	sd	s3,24(sp)
    80000922:	e852                	sd	s4,16(sp)
    80000924:	e05a                	sd	s6,0(sp)
  int i = 0;
    80000926:	4481                	li	s1,0
    sleep_prepare(&tx_chan);
    80000928:	0000aa17          	auipc	s4,0xa
    8000092c:	ad0a0a13          	addi	s4,s4,-1328 # 8000a3f8 <tx_chan>
    if (ReadReg(LSR) & LSR_TX_IDLE) {
    80000930:	100009b7          	lui	s3,0x10000
    80000934:	0995                	addi	s3,s3,5 # 10000005 <_entry-0x6ffffffb>
      WriteReg(THR, buf[i]);
    80000936:	10000b37          	lui	s6,0x10000
    8000093a:	a029                	j	80000944 <uartwrite+0x46>
      i += 1;
    } else {
      sleep();
    8000093c:	766010ef          	jal	800020a2 <sleep>
  while (i < n) {
    80000940:	0324d263          	bge	s1,s2,80000964 <uartwrite+0x66>
    sleep_prepare(&tx_chan);
    80000944:	8552                	mv	a0,s4
    80000946:	720010ef          	jal	80002066 <sleep_prepare>
    if (ReadReg(LSR) & LSR_TX_IDLE) {
    8000094a:	0009c783          	lbu	a5,0(s3)
    8000094e:	0207f793          	andi	a5,a5,32
    80000952:	d7ed                	beqz	a5,8000093c <uartwrite+0x3e>
      WriteReg(THR, buf[i]);
    80000954:	009a87b3          	add	a5,s5,s1
    80000958:	0007c783          	lbu	a5,0(a5)
    8000095c:	00fb0023          	sb	a5,0(s6) # 10000000 <_entry-0x70000000>
      i += 1;
    80000960:	2485                	addiw	s1,s1,1
    80000962:	bff9                	j	80000940 <uartwrite+0x42>
    80000964:	74a2                	ld	s1,40(sp)
    80000966:	69e2                	ld	s3,24(sp)
    80000968:	6a42                	ld	s4,16(sp)
    8000096a:	6b02                	ld	s6,0(sp)
    }
  }

  releasesleep(&tx_lock);
    8000096c:	00012517          	auipc	a0,0x12
    80000970:	b7450513          	addi	a0,a0,-1164 # 800124e0 <tx_lock>
    80000974:	0eb030ef          	jal	8000425e <releasesleep>
}
    80000978:	70e2                	ld	ra,56(sp)
    8000097a:	7442                	ld	s0,48(sp)
    8000097c:	7902                	ld	s2,32(sp)
    8000097e:	6aa2                	ld	s5,8(sp)
    80000980:	6121                	addi	sp,sp,64
    80000982:	8082                	ret

0000000080000984 <uartputc_sync>:
// interrupts, for use by kernel printk() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000984:	1101                	addi	sp,sp,-32
    80000986:	ec06                	sd	ra,24(sp)
    80000988:	e822                	sd	s0,16(sp)
    8000098a:	e426                	sd	s1,8(sp)
    8000098c:	1000                	addi	s0,sp,32
    8000098e:	84aa                	mv	s1,a0
  if (panicking == 0)
    80000990:	0000a797          	auipc	a5,0xa
    80000994:	a647a783          	lw	a5,-1436(a5) # 8000a3f4 <panicking>
    80000998:	cb91                	beqz	a5,800009ac <uartputc_sync+0x28>
    push_off();

  if (panicked) {
    8000099a:	0000a797          	auipc	a5,0xa
    8000099e:	a567a783          	lw	a5,-1450(a5) # 8000a3f0 <panicked>
    for (;;)
      ;
  }

  // wait for UART to set Transmit Holding Empty in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800009a2:	10000737          	lui	a4,0x10000
    800009a6:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
  if (panicked) {
    800009a8:	c789                	beqz	a5,800009b2 <uartputc_sync+0x2e>
    for (;;)
    800009aa:	a001                	j	800009aa <uartputc_sync+0x26>
    push_off();
    800009ac:	212000ef          	jal	80000bbe <push_off>
    800009b0:	b7ed                	j	8000099a <uartputc_sync+0x16>
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800009b2:	00074783          	lbu	a5,0(a4)
    800009b6:	0207f793          	andi	a5,a5,32
    800009ba:	dfe5                	beqz	a5,800009b2 <uartputc_sync+0x2e>
    ;
  WriteReg(THR, c);
    800009bc:	100007b7          	lui	a5,0x10000
    800009c0:	00978023          	sb	s1,0(a5) # 10000000 <_entry-0x70000000>

  if (panicking == 0)
    800009c4:	0000a797          	auipc	a5,0xa
    800009c8:	a307a783          	lw	a5,-1488(a5) # 8000a3f4 <panicking>
    800009cc:	c791                	beqz	a5,800009d8 <uartputc_sync+0x54>
    pop_off();
}
    800009ce:	60e2                	ld	ra,24(sp)
    800009d0:	6442                	ld	s0,16(sp)
    800009d2:	64a2                	ld	s1,8(sp)
    800009d4:	6105                	addi	sp,sp,32
    800009d6:	8082                	ret
    pop_off();
    800009d8:	25c000ef          	jal	80000c34 <pop_off>
}
    800009dc:	bfcd                	j	800009ce <uartputc_sync+0x4a>

00000000800009de <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009de:	1101                	addi	sp,sp,-32
    800009e0:	ec06                	sd	ra,24(sp)
    800009e2:	e822                	sd	s0,16(sp)
    800009e4:	e426                	sd	s1,8(sp)
    800009e6:	e04a                	sd	s2,0(sp)
    800009e8:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800009ea:	100007b7          	lui	a5,0x10000
    800009ee:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  if (ReadReg(LSR) & LSR_TX_IDLE) {
    800009f2:	100007b7          	lui	a5,0x10000
    800009f6:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009fa:	0207f793          	andi	a5,a5,32
    800009fe:	ef99                	bnez	a5,80000a1c <uartintr+0x3e>
  if (ReadReg(LSR) & LSR_RX_READY) {
    80000a00:	100004b7          	lui	s1,0x10000
    80000a04:	0495                	addi	s1,s1,5 # 10000005 <_entry-0x6ffffffb>
    return ReadReg(RHR);
    80000a06:	10000937          	lui	s2,0x10000
  if (ReadReg(LSR) & LSR_RX_READY) {
    80000a0a:	0004c783          	lbu	a5,0(s1)
    80000a0e:	8b85                	andi	a5,a5,1
    80000a10:	cf89                	beqz	a5,80000a2a <uartintr+0x4c>
  // read and process incoming characters, if any.
  while (1) {
    int c = uartgetc();
    if (c == -1)
      break;
    consoleintr(c);
    80000a12:	00094503          	lbu	a0,0(s2) # 10000000 <_entry-0x70000000>
    80000a16:	8a7ff0ef          	jal	800002bc <consoleintr>
  while (1) {
    80000a1a:	bfc5                	j	80000a0a <uartintr+0x2c>
    wakeup(&tx_chan);
    80000a1c:	0000a517          	auipc	a0,0xa
    80000a20:	9dc50513          	addi	a0,a0,-1572 # 8000a3f8 <tx_chan>
    80000a24:	6b2010ef          	jal	800020d6 <wakeup>
    80000a28:	bfe1                	j	80000a00 <uartintr+0x22>
  }
}
    80000a2a:	60e2                	ld	ra,24(sp)
    80000a2c:	6442                	ld	s0,16(sp)
    80000a2e:	64a2                	ld	s1,8(sp)
    80000a30:	6902                	ld	s2,0(sp)
    80000a32:	6105                	addi	sp,sp,32
    80000a34:	8082                	ret

0000000080000a36 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a36:	1101                	addi	sp,sp,-32
    80000a38:	ec06                	sd	ra,24(sp)
    80000a3a:	e822                	sd	s0,16(sp)
    80000a3c:	e426                	sd	s1,8(sp)
    80000a3e:	e04a                	sd	s2,0(sp)
    80000a40:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000a42:	00023797          	auipc	a5,0x23
    80000a46:	30e78793          	addi	a5,a5,782 # 80023d50 <end>
    80000a4a:	00f53733          	sltu	a4,a0,a5
    80000a4e:	47c5                	li	a5,17
    80000a50:	07ee                	slli	a5,a5,0x1b
    80000a52:	17fd                	addi	a5,a5,-1
    80000a54:	00a7b7b3          	sltu	a5,a5,a0
    80000a58:	8fd9                	or	a5,a5,a4
    80000a5a:	03451713          	slli	a4,a0,0x34
    80000a5e:	8fd9                	or	a5,a5,a4
    80000a60:	eb9d                	bnez	a5,80000a96 <kfree+0x60>
    80000a62:	84aa                	mv	s1,a0
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a64:	6605                	lui	a2,0x1
    80000a66:	4585                	li	a1,1
    80000a68:	24c000ef          	jal	80000cb4 <memset>

  r = (struct run *)pa;

  acquire(&kmem.lock);
    80000a6c:	00012917          	auipc	s2,0x12
    80000a70:	aa490913          	addi	s2,s2,-1372 # 80012510 <kmem>
    80000a74:	854a                	mv	a0,s2
    80000a76:	182000ef          	jal	80000bf8 <acquire>
  r->next = kmem.freelist;
    80000a7a:	01893783          	ld	a5,24(s2)
    80000a7e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a80:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a84:	854a                	mv	a0,s2
    80000a86:	1f6000ef          	jal	80000c7c <release>
}
    80000a8a:	60e2                	ld	ra,24(sp)
    80000a8c:	6442                	ld	s0,16(sp)
    80000a8e:	64a2                	ld	s1,8(sp)
    80000a90:	6902                	ld	s2,0(sp)
    80000a92:	6105                	addi	sp,sp,32
    80000a94:	8082                	ret
    panic("kfree");
    80000a96:	00006517          	auipc	a0,0x6
    80000a9a:	5a250513          	addi	a0,a0,1442 # 80007038 <etext+0x38>
    80000a9e:	dabff0ef          	jal	80000848 <panic>

0000000080000aa2 <freerange>:
{
    80000aa2:	7179                	addi	sp,sp,-48
    80000aa4:	f406                	sd	ra,40(sp)
    80000aa6:	f022                	sd	s0,32(sp)
    80000aa8:	ec26                	sd	s1,24(sp)
    80000aaa:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    80000aac:	6785                	lui	a5,0x1
    80000aae:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ab2:	00e504b3          	add	s1,a0,a4
    80000ab6:	777d                	lui	a4,0xfffff
    80000ab8:	8cf9                	and	s1,s1,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000aba:	94be                	add	s1,s1,a5
    80000abc:	0295e263          	bltu	a1,s1,80000ae0 <freerange+0x3e>
    80000ac0:	e84a                	sd	s2,16(sp)
    80000ac2:	e44e                	sd	s3,8(sp)
    80000ac4:	e052                	sd	s4,0(sp)
    80000ac6:	892e                	mv	s2,a1
    kfree(p);
    80000ac8:	8a3a                	mv	s4,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000aca:	89be                	mv	s3,a5
    kfree(p);
    80000acc:	01448533          	add	a0,s1,s4
    80000ad0:	f67ff0ef          	jal	80000a36 <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000ad4:	94ce                	add	s1,s1,s3
    80000ad6:	fe997be3          	bgeu	s2,s1,80000acc <freerange+0x2a>
    80000ada:	6942                	ld	s2,16(sp)
    80000adc:	69a2                	ld	s3,8(sp)
    80000ade:	6a02                	ld	s4,0(sp)
}
    80000ae0:	70a2                	ld	ra,40(sp)
    80000ae2:	7402                	ld	s0,32(sp)
    80000ae4:	64e2                	ld	s1,24(sp)
    80000ae6:	6145                	addi	sp,sp,48
    80000ae8:	8082                	ret

0000000080000aea <kinit>:
{
    80000aea:	1141                	addi	sp,sp,-16
    80000aec:	e406                	sd	ra,8(sp)
    80000aee:	e022                	sd	s0,0(sp)
    80000af0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000af2:	00006597          	auipc	a1,0x6
    80000af6:	54e58593          	addi	a1,a1,1358 # 80007040 <etext+0x40>
    80000afa:	00012517          	auipc	a0,0x12
    80000afe:	a1650513          	addi	a0,a0,-1514 # 80012510 <kmem>
    80000b02:	076000ef          	jal	80000b78 <initlock>
  freerange(end, (void *)PHYSTOP);
    80000b06:	45c5                	li	a1,17
    80000b08:	05ee                	slli	a1,a1,0x1b
    80000b0a:	00023517          	auipc	a0,0x23
    80000b0e:	24650513          	addi	a0,a0,582 # 80023d50 <end>
    80000b12:	f91ff0ef          	jal	80000aa2 <freerange>
}
    80000b16:	60a2                	ld	ra,8(sp)
    80000b18:	6402                	ld	s0,0(sp)
    80000b1a:	0141                	addi	sp,sp,16
    80000b1c:	8082                	ret

0000000080000b1e <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b1e:	1101                	addi	sp,sp,-32
    80000b20:	ec06                	sd	ra,24(sp)
    80000b22:	e822                	sd	s0,16(sp)
    80000b24:	e426                	sd	s1,8(sp)
    80000b26:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b28:	00012517          	auipc	a0,0x12
    80000b2c:	9e850513          	addi	a0,a0,-1560 # 80012510 <kmem>
    80000b30:	0c8000ef          	jal	80000bf8 <acquire>
  r = kmem.freelist;
    80000b34:	00012497          	auipc	s1,0x12
    80000b38:	9f44b483          	ld	s1,-1548(s1) # 80012528 <kmem+0x18>
  if (r)
    80000b3c:	c49d                	beqz	s1,80000b6a <kalloc+0x4c>
    kmem.freelist = r->next;
    80000b3e:	609c                	ld	a5,0(s1)
    80000b40:	00012717          	auipc	a4,0x12
    80000b44:	9ef73423          	sd	a5,-1560(a4) # 80012528 <kmem+0x18>
  release(&kmem.lock);
    80000b48:	00012517          	auipc	a0,0x12
    80000b4c:	9c850513          	addi	a0,a0,-1592 # 80012510 <kmem>
    80000b50:	12c000ef          	jal	80000c7c <release>

  if (r)
    memset((char *)r, 5, PGSIZE); // fill with junk
    80000b54:	6605                	lui	a2,0x1
    80000b56:	4595                	li	a1,5
    80000b58:	8526                	mv	a0,s1
    80000b5a:	15a000ef          	jal	80000cb4 <memset>
  return (void *)r;
}
    80000b5e:	8526                	mv	a0,s1
    80000b60:	60e2                	ld	ra,24(sp)
    80000b62:	6442                	ld	s0,16(sp)
    80000b64:	64a2                	ld	s1,8(sp)
    80000b66:	6105                	addi	sp,sp,32
    80000b68:	8082                	ret
  release(&kmem.lock);
    80000b6a:	00012517          	auipc	a0,0x12
    80000b6e:	9a650513          	addi	a0,a0,-1626 # 80012510 <kmem>
    80000b72:	10a000ef          	jal	80000c7c <release>
  if (r)
    80000b76:	b7e5                	j	80000b5e <kalloc+0x40>

0000000080000b78 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b78:	1141                	addi	sp,sp,-16
    80000b7a:	e406                	sd	ra,8(sp)
    80000b7c:	e022                	sd	s0,0(sp)
    80000b7e:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b80:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b82:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b86:	00053823          	sd	zero,16(a0)
}
    80000b8a:	60a2                	ld	ra,8(sp)
    80000b8c:	6402                	ld	s0,0(sp)
    80000b8e:	0141                	addi	sp,sp,16
    80000b90:	8082                	ret

0000000080000b92 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b92:	411c                	lw	a5,0(a0)
    80000b94:	e399                	bnez	a5,80000b9a <holding+0x8>
    80000b96:	4501                	li	a0,0
  return r;
}
    80000b98:	8082                	ret
{
    80000b9a:	1101                	addi	sp,sp,-32
    80000b9c:	ec06                	sd	ra,24(sp)
    80000b9e:	e822                	sd	s0,16(sp)
    80000ba0:	e426                	sd	s1,8(sp)
    80000ba2:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000ba4:	691c                	ld	a5,16(a0)
    80000ba6:	84be                	mv	s1,a5
    80000ba8:	517000ef          	jal	800018be <mycpu>
    80000bac:	40a48533          	sub	a0,s1,a0
    80000bb0:	00153513          	seqz	a0,a0
}
    80000bb4:	60e2                	ld	ra,24(sp)
    80000bb6:	6442                	ld	s0,16(sp)
    80000bb8:	64a2                	ld	s1,8(sp)
    80000bba:	6105                	addi	sp,sp,32
    80000bbc:	8082                	ret

0000000080000bbe <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bbe:	1101                	addi	sp,sp,-32
    80000bc0:	ec06                	sd	ra,24(sp)
    80000bc2:	e822                	sd	s0,16(sp)
    80000bc4:	e426                	sd	s1,8(sp)
    80000bc6:	1000                	addi	s0,sp,32
  __asm__ __volatile__("csrrc %0, sstatus, %1" : "=r"(x) : "rK"(x) : "memory");
    80000bc8:	100177f3          	csrrci	a5,sstatus,2
    80000bcc:	84be                	mv	s1,a5
  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  uint64 flags = rc_sstatus(SSTATUS_SIE);
  int old = !!(flags & SSTATUS_SIE);

  if (mycpu()->noff == 0)
    80000bce:	4f1000ef          	jal	800018be <mycpu>
    80000bd2:	5d3c                	lw	a5,120(a0)
    80000bd4:	cb99                	beqz	a5,80000bea <push_off+0x2c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd6:	4e9000ef          	jal	800018be <mycpu>
    80000bda:	5d3c                	lw	a5,120(a0)
    80000bdc:	2785                	addiw	a5,a5,1
    80000bde:	dd3c                	sw	a5,120(a0)
}
    80000be0:	60e2                	ld	ra,24(sp)
    80000be2:	6442                	ld	s0,16(sp)
    80000be4:	64a2                	ld	s1,8(sp)
    80000be6:	6105                	addi	sp,sp,32
    80000be8:	8082                	ret
    mycpu()->intena = old;
    80000bea:	4d5000ef          	jal	800018be <mycpu>
  int old = !!(flags & SSTATUS_SIE);
    80000bee:	0014d793          	srli	a5,s1,0x1
    80000bf2:	8b85                	andi	a5,a5,1
    mycpu()->intena = old;
    80000bf4:	dd7c                	sw	a5,124(a0)
    80000bf6:	b7c5                	j	80000bd6 <push_off+0x18>

0000000080000bf8 <acquire>:
{
    80000bf8:	1101                	addi	sp,sp,-32
    80000bfa:	ec06                	sd	ra,24(sp)
    80000bfc:	e822                	sd	s0,16(sp)
    80000bfe:	e426                	sd	s1,8(sp)
    80000c00:	1000                	addi	s0,sp,32
    80000c02:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c04:	fbbff0ef          	jal	80000bbe <push_off>
  if (holding(lk))
    80000c08:	8526                	mv	a0,s1
    80000c0a:	f89ff0ef          	jal	80000b92 <holding>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000c0e:	4705                	li	a4,1
  if (holding(lk))
    80000c10:	ed01                	bnez	a0,80000c28 <acquire+0x30>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000c12:	0ce4a7af          	amoswap.w.aq	a5,a4,(s1)
    80000c16:	fff5                	bnez	a5,80000c12 <acquire+0x1a>
  lk->cpu = mycpu();
    80000c18:	4a7000ef          	jal	800018be <mycpu>
    80000c1c:	e888                	sd	a0,16(s1)
}
    80000c1e:	60e2                	ld	ra,24(sp)
    80000c20:	6442                	ld	s0,16(sp)
    80000c22:	64a2                	ld	s1,8(sp)
    80000c24:	6105                	addi	sp,sp,32
    80000c26:	8082                	ret
    panic("acquire");
    80000c28:	00006517          	auipc	a0,0x6
    80000c2c:	42050513          	addi	a0,a0,1056 # 80007048 <etext+0x48>
    80000c30:	c19ff0ef          	jal	80000848 <panic>

0000000080000c34 <pop_off>:

void
pop_off(void)
{
    80000c34:	1141                	addi	sp,sp,-16
    80000c36:	e406                	sd	ra,8(sp)
    80000c38:	e022                	sd	s0,0(sp)
    80000c3a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c3c:	483000ef          	jal	800018be <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000c40:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c44:	8b89                	andi	a5,a5,2
  if (intr_get())
    80000c46:	ef99                	bnez	a5,80000c64 <pop_off+0x30>
    panic("pop_off - interruptible");
  if (c->noff < 1)
    80000c48:	5d3c                	lw	a5,120(a0)
    80000c4a:	02f05363          	blez	a5,80000c70 <pop_off+0x3c>
    panic("pop_off");
  c->noff -= 1;
    80000c4e:	37fd                	addiw	a5,a5,-1
    80000c50:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena)
    80000c52:	e789                	bnez	a5,80000c5c <pop_off+0x28>
    80000c54:	5d7c                	lw	a5,124(a0)
    80000c56:	c399                	beqz	a5,80000c5c <pop_off+0x28>
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80000c58:	10016073          	csrsi	sstatus,2
    intr_on();
}
    80000c5c:	60a2                	ld	ra,8(sp)
    80000c5e:	6402                	ld	s0,0(sp)
    80000c60:	0141                	addi	sp,sp,16
    80000c62:	8082                	ret
    panic("pop_off - interruptible");
    80000c64:	00006517          	auipc	a0,0x6
    80000c68:	3ec50513          	addi	a0,a0,1004 # 80007050 <etext+0x50>
    80000c6c:	bddff0ef          	jal	80000848 <panic>
    panic("pop_off");
    80000c70:	00006517          	auipc	a0,0x6
    80000c74:	3f850513          	addi	a0,a0,1016 # 80007068 <etext+0x68>
    80000c78:	bd1ff0ef          	jal	80000848 <panic>

0000000080000c7c <release>:
{
    80000c7c:	1101                	addi	sp,sp,-32
    80000c7e:	ec06                	sd	ra,24(sp)
    80000c80:	e822                	sd	s0,16(sp)
    80000c82:	e426                	sd	s1,8(sp)
    80000c84:	1000                	addi	s0,sp,32
    80000c86:	84aa                	mv	s1,a0
  if (!holding(lk))
    80000c88:	f0bff0ef          	jal	80000b92 <holding>
    80000c8c:	cd11                	beqz	a0,80000ca8 <release+0x2c>
  lk->cpu = 0;
    80000c8e:	0004b823          	sd	zero,16(s1)
  __atomic_store_n(&lk->locked, 0, __ATOMIC_RELEASE);
    80000c92:	0310000f          	fence	rw,w
    80000c96:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000c9a:	f9bff0ef          	jal	80000c34 <pop_off>
}
    80000c9e:	60e2                	ld	ra,24(sp)
    80000ca0:	6442                	ld	s0,16(sp)
    80000ca2:	64a2                	ld	s1,8(sp)
    80000ca4:	6105                	addi	sp,sp,32
    80000ca6:	8082                	ret
    panic("release");
    80000ca8:	00006517          	auipc	a0,0x6
    80000cac:	3c850513          	addi	a0,a0,968 # 80007070 <etext+0x70>
    80000cb0:	b99ff0ef          	jal	80000848 <panic>

0000000080000cb4 <memset>:
#include "types.h"

void *
memset(void *dst, int c, uint n)
{
    80000cb4:	1141                	addi	sp,sp,-16
    80000cb6:	e406                	sd	ra,8(sp)
    80000cb8:	e022                	sd	s0,0(sp)
    80000cba:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    80000cbc:	ca19                	beqz	a2,80000cd2 <memset+0x1e>
    80000cbe:	87aa                	mv	a5,a0
    80000cc0:	1602                	slli	a2,a2,0x20
    80000cc2:	9201                	srli	a2,a2,0x20
    80000cc4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cc8:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    80000ccc:	0785                	addi	a5,a5,1
    80000cce:	fee79de3          	bne	a5,a4,80000cc8 <memset+0x14>
  }
  return dst;
}
    80000cd2:	60a2                	ld	ra,8(sp)
    80000cd4:	6402                	ld	s0,0(sp)
    80000cd6:	0141                	addi	sp,sp,16
    80000cd8:	8082                	ret

0000000080000cda <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cda:	1141                	addi	sp,sp,-16
    80000cdc:	e406                	sd	ra,8(sp)
    80000cde:	e022                	sd	s0,0(sp)
    80000ce0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    80000ce2:	ce19                	beqz	a2,80000d00 <memcmp+0x26>
    80000ce4:	1602                	slli	a2,a2,0x20
    80000ce6:	9201                	srli	a2,a2,0x20
    80000ce8:	00c506b3          	add	a3,a0,a2
    if (*s1 != *s2)
    80000cec:	00054783          	lbu	a5,0(a0)
    80000cf0:	0005c703          	lbu	a4,0(a1)
    80000cf4:	00e79b63          	bne	a5,a4,80000d0a <memcmp+0x30>
      return *s1 - *s2;
    s1++, s2++;
    80000cf8:	0505                	addi	a0,a0,1
    80000cfa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    80000cfc:	fed518e3          	bne	a0,a3,80000cec <memcmp+0x12>
  }

  return 0;
    80000d00:	4501                	li	a0,0
}
    80000d02:	60a2                	ld	ra,8(sp)
    80000d04:	6402                	ld	s0,0(sp)
    80000d06:	0141                	addi	sp,sp,16
    80000d08:	8082                	ret
      return *s1 - *s2;
    80000d0a:	40e7853b          	subw	a0,a5,a4
    80000d0e:	bfd5                	j	80000d02 <memcmp+0x28>

0000000080000d10 <memmove>:

void *
memmove(void *dst, const void *src, uint n)
{
    80000d10:	1141                	addi	sp,sp,-16
    80000d12:	e406                	sd	ra,8(sp)
    80000d14:	e022                	sd	s0,0(sp)
    80000d16:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0)
    80000d18:	c61d                	beqz	a2,80000d46 <memmove+0x36>
    return dst;

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    80000d1a:	00a5f963          	bgeu	a1,a0,80000d2c <memmove+0x1c>
    80000d1e:	02061693          	slli	a3,a2,0x20
    80000d22:	9281                	srli	a3,a3,0x20
    80000d24:	00d58733          	add	a4,a1,a3
    80000d28:	02e56363          	bltu	a0,a4,80000d4e <memmove+0x3e>
    s += n;
    d += n;
    while (n-- > 0)
      *--d = *--s;
  } else
    while (n-- > 0)
    80000d2c:	1602                	slli	a2,a2,0x20
    80000d2e:	9201                	srli	a2,a2,0x20
    80000d30:	00c587b3          	add	a5,a1,a2
{
    80000d34:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d36:	0585                	addi	a1,a1,1
    80000d38:	0705                	addi	a4,a4,1
    80000d3a:	fff5c683          	lbu	a3,-1(a1)
    80000d3e:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    80000d42:	fef59ae3          	bne	a1,a5,80000d36 <memmove+0x26>

  return dst;
}
    80000d46:	60a2                	ld	ra,8(sp)
    80000d48:	6402                	ld	s0,0(sp)
    80000d4a:	0141                	addi	sp,sp,16
    80000d4c:	8082                	ret
    d += n;
    80000d4e:	96aa                	add	a3,a3,a0
    while (n-- > 0)
    80000d50:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000d54:	1782                	slli	a5,a5,0x20
    80000d56:	9381                	srli	a5,a5,0x20
    80000d58:	fff7c793          	not	a5,a5
    80000d5c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d5e:	177d                	addi	a4,a4,-1
    80000d60:	16fd                	addi	a3,a3,-1
    80000d62:	00074603          	lbu	a2,0(a4)
    80000d66:	00c68023          	sb	a2,0(a3)
    while (n-- > 0)
    80000d6a:	fee79ae3          	bne	a5,a4,80000d5e <memmove+0x4e>
    80000d6e:	bfe1                	j	80000d46 <memmove+0x36>

0000000080000d70 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *
memcpy(void *dst, const void *src, uint n)
{
    80000d70:	1141                	addi	sp,sp,-16
    80000d72:	e406                	sd	ra,8(sp)
    80000d74:	e022                	sd	s0,0(sp)
    80000d76:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d78:	f99ff0ef          	jal	80000d10 <memmove>
}
    80000d7c:	60a2                	ld	ra,8(sp)
    80000d7e:	6402                	ld	s0,0(sp)
    80000d80:	0141                	addi	sp,sp,16
    80000d82:	8082                	ret

0000000080000d84 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d84:	1141                	addi	sp,sp,-16
    80000d86:	e406                	sd	ra,8(sp)
    80000d88:	e022                	sd	s0,0(sp)
    80000d8a:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q)
    80000d8c:	ce01                	beqz	a2,80000da4 <strncmp+0x20>
    80000d8e:	00054783          	lbu	a5,0(a0)
    80000d92:	cb99                	beqz	a5,80000da8 <strncmp+0x24>
    80000d94:	0005c703          	lbu	a4,0(a1)
    80000d98:	00f71863          	bne	a4,a5,80000da8 <strncmp+0x24>
    n--, p++, q++;
    80000d9c:	367d                	addiw	a2,a2,-1
    80000d9e:	0505                	addi	a0,a0,1
    80000da0:	0585                	addi	a1,a1,1
  while (n > 0 && *p && *p == *q)
    80000da2:	f675                	bnez	a2,80000d8e <strncmp+0xa>
  if (n == 0)
    return 0;
    80000da4:	4501                	li	a0,0
    80000da6:	a031                	j	80000db2 <strncmp+0x2e>
  return (uchar)*p - (uchar)*q;
    80000da8:	00054503          	lbu	a0,0(a0)
    80000dac:	0005c783          	lbu	a5,0(a1)
    80000db0:	9d1d                	subw	a0,a0,a5
}
    80000db2:	60a2                	ld	ra,8(sp)
    80000db4:	6402                	ld	s0,0(sp)
    80000db6:	0141                	addi	sp,sp,16
    80000db8:	8082                	ret

0000000080000dba <strncpy>:

char *
strncpy(char *s, const char *t, int n)
{
    80000dba:	1141                	addi	sp,sp,-16
    80000dbc:	e406                	sd	ra,8(sp)
    80000dbe:	e022                	sd	s0,0(sp)
    80000dc0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0)
    80000dc2:	87aa                	mv	a5,a0
    80000dc4:	a011                	j	80000dc8 <strncpy+0xe>
    80000dc6:	8636                	mv	a2,a3
    80000dc8:	02c05763          	blez	a2,80000df6 <strncpy+0x3c>
    80000dcc:	fff6069b          	addiw	a3,a2,-1
    80000dd0:	0785                	addi	a5,a5,1
    80000dd2:	0005c703          	lbu	a4,0(a1)
    80000dd6:	fee78fa3          	sb	a4,-1(a5)
    80000dda:	0585                	addi	a1,a1,1
    80000ddc:	f76d                	bnez	a4,80000dc6 <strncpy+0xc>
    ;
  while (n-- > 0)
    80000dde:	873e                	mv	a4,a5
    80000de0:	00d05b63          	blez	a3,80000df6 <strncpy+0x3c>
    80000de4:	9fb1                	addw	a5,a5,a2
    80000de6:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000de8:	0705                	addi	a4,a4,1
    80000dea:	fe070fa3          	sb	zero,-1(a4)
  while (n-- > 0)
    80000dee:	40e786bb          	subw	a3,a5,a4
    80000df2:	fed04be3          	bgtz	a3,80000de8 <strncpy+0x2e>
  return os;
}
    80000df6:	60a2                	ld	ra,8(sp)
    80000df8:	6402                	ld	s0,0(sp)
    80000dfa:	0141                	addi	sp,sp,16
    80000dfc:	8082                	ret

0000000080000dfe <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *
safestrcpy(char *s, const char *t, int n)
{
    80000dfe:	1141                	addi	sp,sp,-16
    80000e00:	e406                	sd	ra,8(sp)
    80000e02:	e022                	sd	s0,0(sp)
    80000e04:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0)
    80000e06:	02c05363          	blez	a2,80000e2c <safestrcpy+0x2e>
    80000e0a:	fff6069b          	addiw	a3,a2,-1
    80000e0e:	1682                	slli	a3,a3,0x20
    80000e10:	9281                	srli	a3,a3,0x20
    80000e12:	96ae                	add	a3,a3,a1
    80000e14:	87aa                	mv	a5,a0
    return os;
  while (--n > 0 && (*s++ = *t++) != 0)
    80000e16:	00d58963          	beq	a1,a3,80000e28 <safestrcpy+0x2a>
    80000e1a:	0585                	addi	a1,a1,1
    80000e1c:	0785                	addi	a5,a5,1
    80000e1e:	fff5c703          	lbu	a4,-1(a1)
    80000e22:	fee78fa3          	sb	a4,-1(a5)
    80000e26:	fb65                	bnez	a4,80000e16 <safestrcpy+0x18>
    ;
  *s = 0;
    80000e28:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e2c:	60a2                	ld	ra,8(sp)
    80000e2e:	6402                	ld	s0,0(sp)
    80000e30:	0141                	addi	sp,sp,16
    80000e32:	8082                	ret

0000000080000e34 <strlen>:

int
strlen(const char *s)
{
    80000e34:	1141                	addi	sp,sp,-16
    80000e36:	e406                	sd	ra,8(sp)
    80000e38:	e022                	sd	s0,0(sp)
    80000e3a:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    80000e3c:	00054783          	lbu	a5,0(a0)
    80000e40:	cf91                	beqz	a5,80000e5c <strlen+0x28>
    80000e42:	00150793          	addi	a5,a0,1
    80000e46:	86be                	mv	a3,a5
    80000e48:	0785                	addi	a5,a5,1
    80000e4a:	fff7c703          	lbu	a4,-1(a5)
    80000e4e:	ff65                	bnez	a4,80000e46 <strlen+0x12>
    80000e50:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000e54:	60a2                	ld	ra,8(sp)
    80000e56:	6402                	ld	s0,0(sp)
    80000e58:	0141                	addi	sp,sp,16
    80000e5a:	8082                	ret
  for (n = 0; s[n]; n++)
    80000e5c:	4501                	li	a0,0
    80000e5e:	bfdd                	j	80000e54 <strlen+0x20>

0000000080000e60 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e60:	1141                	addi	sp,sp,-16
    80000e62:	e406                	sd	ra,8(sp)
    80000e64:	e022                	sd	s0,0(sp)
    80000e66:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80000e68:	243000ef          	jal	800018aa <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();         // first user process

    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
  } else {
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    80000e6c:	00009717          	auipc	a4,0x9
    80000e70:	59070713          	addi	a4,a4,1424 # 8000a3fc <started>
  if (cpuid() == 0) {
    80000e74:	c51d                	beqz	a0,80000ea2 <main+0x42>
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    80000e76:	431c                	lw	a5,0(a4)
    80000e78:	0230000f          	fence	r,rw
    80000e7c:	2781                	sext.w	a5,a5
    80000e7e:	dfe5                	beqz	a5,80000e76 <main+0x16>
      ;

    printk("hart %d starting\n", cpuid());
    80000e80:	22b000ef          	jal	800018aa <cpuid>
    80000e84:	85aa                	mv	a1,a0
    80000e86:	00006517          	auipc	a0,0x6
    80000e8a:	20a50513          	addi	a0,a0,522 # 80007090 <etext+0x90>
    80000e8e:	e82ff0ef          	jal	80000510 <printk>
    kvminithart();  // turn on paging
    80000e92:	082000ef          	jal	80000f14 <kvminithart>
    trapinithart(); // install kernel trap vector
    80000e96:	772010ef          	jal	80002608 <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    80000e9a:	15f040ef          	jal	800057f8 <plicinithart>
  }

  scheduler();
    80000e9e:	741000ef          	jal	80001dde <scheduler>
    consoleinit();
    80000ea2:	d96ff0ef          	jal	80000438 <consoleinit>
    printkinit();
    80000ea6:	9dfff0ef          	jal	80000884 <printkinit>
    printk("\n");
    80000eaa:	00006517          	auipc	a0,0x6
    80000eae:	46e50513          	addi	a0,a0,1134 # 80007318 <etext+0x318>
    80000eb2:	e5eff0ef          	jal	80000510 <printk>
    printk("xv6 kernel is booting\n");
    80000eb6:	00006517          	auipc	a0,0x6
    80000eba:	1c250513          	addi	a0,a0,450 # 80007078 <etext+0x78>
    80000ebe:	e52ff0ef          	jal	80000510 <printk>
    printk("\n");
    80000ec2:	00006517          	auipc	a0,0x6
    80000ec6:	45650513          	addi	a0,a0,1110 # 80007318 <etext+0x318>
    80000eca:	e46ff0ef          	jal	80000510 <printk>
    kinit();            // physical page allocator
    80000ece:	c1dff0ef          	jal	80000aea <kinit>
    kvminit();          // create kernel page table
    80000ed2:	2c2000ef          	jal	80001194 <kvminit>
    kvminithart();      // turn on paging
    80000ed6:	03e000ef          	jal	80000f14 <kvminithart>
    procinit();         // process table
    80000eda:	10d000ef          	jal	800017e6 <procinit>
    trapinit();         // trap vectors
    80000ede:	706010ef          	jal	800025e4 <trapinit>
    trapinithart();     // install kernel trap vector
    80000ee2:	726010ef          	jal	80002608 <trapinithart>
    plicinit();         // set up interrupt controller
    80000ee6:	0f9040ef          	jal	800057de <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    80000eea:	10f040ef          	jal	800057f8 <plicinithart>
    binit();            // buffer cache
    80000eee:	66d010ef          	jal	80002d5a <binit>
    iinit();            // inode table
    80000ef2:	3c6020ef          	jal	800032b8 <iinit>
    fileinit();         // file table
    80000ef6:	3ea030ef          	jal	800042e0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000efa:	1ef040ef          	jal	800058e8 <virtio_disk_init>
    userinit();         // first user process
    80000efe:	53f000ef          	jal	80001c3c <userinit>
    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
    80000f02:	00009797          	auipc	a5,0x9
    80000f06:	4fa78793          	addi	a5,a5,1274 # 8000a3fc <started>
    80000f0a:	4705                	li	a4,1
    80000f0c:	0310000f          	fence	rw,w
    80000f10:	c398                	sw	a4,0(a5)
    80000f12:	b771                	j	80000e9e <main+0x3e>

0000000080000f14 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000f14:	1141                	addi	sp,sp,-16
    80000f16:	e406                	sd	ra,8(sp)
    80000f18:	e022                	sd	s0,0(sp)
    80000f1a:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero" ::: "memory");
    80000f1c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f20:	00009797          	auipc	a5,0x9
    80000f24:	4e07b783          	ld	a5,1248(a5) # 8000a400 <kernel_pagetable>
    80000f28:	83b1                	srli	a5,a5,0xc
    80000f2a:	577d                	li	a4,-1
    80000f2c:	177e                	slli	a4,a4,0x3f
    80000f2e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80000f30:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero" ::: "memory");
    80000f34:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f38:	60a2                	ld	ra,8(sp)
    80000f3a:	6402                	ld	s0,0(sp)
    80000f3c:	0141                	addi	sp,sp,16
    80000f3e:	8082                	ret

0000000080000f40 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f40:	7139                	addi	sp,sp,-64
    80000f42:	fc06                	sd	ra,56(sp)
    80000f44:	f822                	sd	s0,48(sp)
    80000f46:	f426                	sd	s1,40(sp)
    80000f48:	f04a                	sd	s2,32(sp)
    80000f4a:	ec4e                	sd	s3,24(sp)
    80000f4c:	e852                	sd	s4,16(sp)
    80000f4e:	e456                	sd	s5,8(sp)
    80000f50:	e05a                	sd	s6,0(sp)
    80000f52:	0080                	addi	s0,sp,64
    80000f54:	84aa                	mv	s1,a0
    80000f56:	89ae                	mv	s3,a1
    80000f58:	8b32                	mv	s6,a2
  if (va >= MAXVA)
    80000f5a:	57fd                	li	a5,-1
    80000f5c:	83e9                	srli	a5,a5,0x1a
    80000f5e:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--) {
    80000f60:	4ab1                	li	s5,12
  if (va >= MAXVA)
    80000f62:	06b7e363          	bltu	a5,a1,80000fc8 <walk+0x88>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f66:	0149d933          	srl	s2,s3,s4
    80000f6a:	1ff97913          	andi	s2,s2,511
    80000f6e:	090e                	slli	s2,s2,0x3
    80000f70:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    80000f72:	00093483          	ld	s1,0(s2)
    80000f76:	0014f793          	andi	a5,s1,1
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f7a:	80a9                	srli	s1,s1,0xa
    80000f7c:	04b2                	slli	s1,s1,0xc
    if (*pte & PTE_V) {
    80000f7e:	e395                	bnez	a5,80000fa2 <walk+0x62>
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80000f80:	040b0a63          	beqz	s6,80000fd4 <walk+0x94>
    80000f84:	b9bff0ef          	jal	80000b1e <kalloc>
    80000f88:	84aa                	mv	s1,a0
    80000f8a:	c50d                	beqz	a0,80000fb4 <walk+0x74>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f8c:	6605                	lui	a2,0x1
    80000f8e:	4581                	li	a1,0
    80000f90:	d25ff0ef          	jal	80000cb4 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f94:	00c4d793          	srli	a5,s1,0xc
    80000f98:	07aa                	slli	a5,a5,0xa
    80000f9a:	0017e793          	ori	a5,a5,1
    80000f9e:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    80000fa2:	3a5d                	addiw	s4,s4,-9
    80000fa4:	fd5a11e3          	bne	s4,s5,80000f66 <walk+0x26>
    }
  }
  return &pagetable[PX(0, va)];
    80000fa8:	00c9d513          	srli	a0,s3,0xc
    80000fac:	1ff57513          	andi	a0,a0,511
    80000fb0:	050e                	slli	a0,a0,0x3
    80000fb2:	9526                	add	a0,a0,s1
}
    80000fb4:	70e2                	ld	ra,56(sp)
    80000fb6:	7442                	ld	s0,48(sp)
    80000fb8:	74a2                	ld	s1,40(sp)
    80000fba:	7902                	ld	s2,32(sp)
    80000fbc:	69e2                	ld	s3,24(sp)
    80000fbe:	6a42                	ld	s4,16(sp)
    80000fc0:	6aa2                	ld	s5,8(sp)
    80000fc2:	6b02                	ld	s6,0(sp)
    80000fc4:	6121                	addi	sp,sp,64
    80000fc6:	8082                	ret
    panic("walk");
    80000fc8:	00006517          	auipc	a0,0x6
    80000fcc:	0e050513          	addi	a0,a0,224 # 800070a8 <etext+0xa8>
    80000fd0:	879ff0ef          	jal	80000848 <panic>
        return 0;
    80000fd4:	4501                	li	a0,0
    80000fd6:	bff9                	j	80000fb4 <walk+0x74>

0000000080000fd8 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    80000fd8:	57fd                	li	a5,-1
    80000fda:	83e9                	srli	a5,a5,0x1a
    80000fdc:	00b7f463          	bgeu	a5,a1,80000fe4 <walkaddr+0xc>
    return 0;
    80000fe0:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fe2:	8082                	ret
{
    80000fe4:	1141                	addi	sp,sp,-16
    80000fe6:	e406                	sd	ra,8(sp)
    80000fe8:	e022                	sd	s0,0(sp)
    80000fea:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000fec:	4601                	li	a2,0
    80000fee:	f53ff0ef          	jal	80000f40 <walk>
  if (pte == 0)
    80000ff2:	c519                	beqz	a0,80001000 <walkaddr+0x28>
  if ((*pte & PTE_V) == 0)
    80000ff4:	6108                	ld	a0,0(a0)
  if ((*pte & PTE_U) == 0)
    80000ff6:	01157713          	andi	a4,a0,17
    80000ffa:	47c5                	li	a5,17
    80000ffc:	00f70763          	beq	a4,a5,8000100a <walkaddr+0x32>
    return 0;
    80001000:	4501                	li	a0,0
}
    80001002:	60a2                	ld	ra,8(sp)
    80001004:	6402                	ld	s0,0(sp)
    80001006:	0141                	addi	sp,sp,16
    80001008:	8082                	ret
  pa = PTE2PA(*pte);
    8000100a:	8129                	srli	a0,a0,0xa
    8000100c:	0532                	slli	a0,a0,0xc
  return pa;
    8000100e:	bfd5                	j	80001002 <walkaddr+0x2a>

0000000080001010 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001010:	715d                	addi	sp,sp,-80
    80001012:	e486                	sd	ra,72(sp)
    80001014:	e0a2                	sd	s0,64(sp)
    80001016:	fc26                	sd	s1,56(sp)
    80001018:	f84a                	sd	s2,48(sp)
    8000101a:	f44e                	sd	s3,40(sp)
    8000101c:	f052                	sd	s4,32(sp)
    8000101e:	ec56                	sd	s5,24(sp)
    80001020:	e85a                	sd	s6,16(sp)
    80001022:	e45e                	sd	s7,8(sp)
    80001024:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    80001026:	03459793          	slli	a5,a1,0x34
    8000102a:	e7b1                	bnez	a5,80001076 <mappages+0x66>
    8000102c:	8a2a                	mv	s4,a0
    8000102e:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if ((size % PGSIZE) != 0)
    80001030:	03461793          	slli	a5,a2,0x34
    80001034:	e7b9                	bnez	a5,80001082 <mappages+0x72>
    panic("mappages: size not aligned");

  if (size == 0)
    80001036:	ce21                	beqz	a2,8000108e <mappages+0x7e>
    panic("mappages: size");

  a = va;
  last = va + size - PGSIZE;
    80001038:	77fd                	lui	a5,0xfffff
    8000103a:	963e                	add	a2,a2,a5
    8000103c:	00b60933          	add	s2,a2,a1
  a = va;
    80001040:	84ae                	mv	s1,a1
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001042:	4b05                	li	s6,1
    80001044:	40b689b3          	sub	s3,a3,a1
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    80001048:	6b85                	lui	s7,0x1
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000104a:	865a                	mv	a2,s6
    8000104c:	85a6                	mv	a1,s1
    8000104e:	8552                	mv	a0,s4
    80001050:	ef1ff0ef          	jal	80000f40 <walk>
    80001054:	c929                	beqz	a0,800010a6 <mappages+0x96>
    if (*pte & PTE_V)
    80001056:	611c                	ld	a5,0(a0)
    80001058:	8b85                	andi	a5,a5,1
    8000105a:	e3a1                	bnez	a5,8000109a <mappages+0x8a>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000105c:	013487b3          	add	a5,s1,s3
    80001060:	83b1                	srli	a5,a5,0xc
    80001062:	07aa                	slli	a5,a5,0xa
    80001064:	0157e7b3          	or	a5,a5,s5
    80001068:	0017e793          	ori	a5,a5,1
    8000106c:	e11c                	sd	a5,0(a0)
    if (a == last)
    8000106e:	05248863          	beq	s1,s2,800010be <mappages+0xae>
    a += PGSIZE;
    80001072:	94de                	add	s1,s1,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001074:	bfd9                	j	8000104a <mappages+0x3a>
    panic("mappages: va not aligned");
    80001076:	00006517          	auipc	a0,0x6
    8000107a:	03a50513          	addi	a0,a0,58 # 800070b0 <etext+0xb0>
    8000107e:	fcaff0ef          	jal	80000848 <panic>
    panic("mappages: size not aligned");
    80001082:	00006517          	auipc	a0,0x6
    80001086:	04e50513          	addi	a0,a0,78 # 800070d0 <etext+0xd0>
    8000108a:	fbeff0ef          	jal	80000848 <panic>
    panic("mappages: size");
    8000108e:	00006517          	auipc	a0,0x6
    80001092:	06250513          	addi	a0,a0,98 # 800070f0 <etext+0xf0>
    80001096:	fb2ff0ef          	jal	80000848 <panic>
      panic("mappages: remap");
    8000109a:	00006517          	auipc	a0,0x6
    8000109e:	06650513          	addi	a0,a0,102 # 80007100 <etext+0x100>
    800010a2:	fa6ff0ef          	jal	80000848 <panic>
      return -1;
    800010a6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010a8:	60a6                	ld	ra,72(sp)
    800010aa:	6406                	ld	s0,64(sp)
    800010ac:	74e2                	ld	s1,56(sp)
    800010ae:	7942                	ld	s2,48(sp)
    800010b0:	79a2                	ld	s3,40(sp)
    800010b2:	7a02                	ld	s4,32(sp)
    800010b4:	6ae2                	ld	s5,24(sp)
    800010b6:	6b42                	ld	s6,16(sp)
    800010b8:	6ba2                	ld	s7,8(sp)
    800010ba:	6161                	addi	sp,sp,80
    800010bc:	8082                	ret
  return 0;
    800010be:	4501                	li	a0,0
    800010c0:	b7e5                	j	800010a8 <mappages+0x98>

00000000800010c2 <kvmmap>:
{
    800010c2:	1141                	addi	sp,sp,-16
    800010c4:	e406                	sd	ra,8(sp)
    800010c6:	e022                	sd	s0,0(sp)
    800010c8:	0800                	addi	s0,sp,16
    800010ca:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010cc:	86b2                	mv	a3,a2
    800010ce:	863e                	mv	a2,a5
    800010d0:	f41ff0ef          	jal	80001010 <mappages>
    800010d4:	e509                	bnez	a0,800010de <kvmmap+0x1c>
}
    800010d6:	60a2                	ld	ra,8(sp)
    800010d8:	6402                	ld	s0,0(sp)
    800010da:	0141                	addi	sp,sp,16
    800010dc:	8082                	ret
    panic("kvmmap");
    800010de:	00006517          	auipc	a0,0x6
    800010e2:	03250513          	addi	a0,a0,50 # 80007110 <etext+0x110>
    800010e6:	f62ff0ef          	jal	80000848 <panic>

00000000800010ea <kvmmake>:
{
    800010ea:	1101                	addi	sp,sp,-32
    800010ec:	ec06                	sd	ra,24(sp)
    800010ee:	e822                	sd	s0,16(sp)
    800010f0:	e426                	sd	s1,8(sp)
    800010f2:	e04a                	sd	s2,0(sp)
    800010f4:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    800010f6:	a29ff0ef          	jal	80000b1e <kalloc>
    800010fa:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800010fc:	6605                	lui	a2,0x1
    800010fe:	4581                	li	a1,0
    80001100:	bb5ff0ef          	jal	80000cb4 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001104:	4719                	li	a4,6
    80001106:	6685                	lui	a3,0x1
    80001108:	10000637          	lui	a2,0x10000
    8000110c:	85b2                	mv	a1,a2
    8000110e:	8526                	mv	a0,s1
    80001110:	fb3ff0ef          	jal	800010c2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001114:	4719                	li	a4,6
    80001116:	6685                	lui	a3,0x1
    80001118:	10001637          	lui	a2,0x10001
    8000111c:	85b2                	mv	a1,a2
    8000111e:	8526                	mv	a0,s1
    80001120:	fa3ff0ef          	jal	800010c2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001124:	4719                	li	a4,6
    80001126:	040006b7          	lui	a3,0x4000
    8000112a:	0c000637          	lui	a2,0xc000
    8000112e:	85b2                	mv	a1,a2
    80001130:	8526                	mv	a0,s1
    80001132:	f91ff0ef          	jal	800010c2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    80001136:	00006917          	auipc	s2,0x6
    8000113a:	eca90913          	addi	s2,s2,-310 # 80007000 <etext>
    8000113e:	4729                	li	a4,10
    80001140:	800006b7          	lui	a3,0x80000
    80001144:	96ca                	add	a3,a3,s2
    80001146:	4605                	li	a2,1
    80001148:	067e                	slli	a2,a2,0x1f
    8000114a:	85b2                	mv	a1,a2
    8000114c:	8526                	mv	a0,s1
    8000114e:	f75ff0ef          	jal	800010c2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    80001152:	4719                	li	a4,6
    80001154:	46c5                	li	a3,17
    80001156:	06ee                	slli	a3,a3,0x1b
    80001158:	412686b3          	sub	a3,a3,s2
    8000115c:	864a                	mv	a2,s2
    8000115e:	85ca                	mv	a1,s2
    80001160:	8526                	mv	a0,s1
    80001162:	f61ff0ef          	jal	800010c2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001166:	4729                	li	a4,10
    80001168:	6685                	lui	a3,0x1
    8000116a:	00005617          	auipc	a2,0x5
    8000116e:	e9660613          	addi	a2,a2,-362 # 80006000 <_trampoline>
    80001172:	040005b7          	lui	a1,0x4000
    80001176:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001178:	05b2                	slli	a1,a1,0xc
    8000117a:	8526                	mv	a0,s1
    8000117c:	f47ff0ef          	jal	800010c2 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001180:	8526                	mv	a0,s1
    80001182:	5e0000ef          	jal	80001762 <proc_mapstacks>
}
    80001186:	8526                	mv	a0,s1
    80001188:	60e2                	ld	ra,24(sp)
    8000118a:	6442                	ld	s0,16(sp)
    8000118c:	64a2                	ld	s1,8(sp)
    8000118e:	6902                	ld	s2,0(sp)
    80001190:	6105                	addi	sp,sp,32
    80001192:	8082                	ret

0000000080001194 <kvminit>:
{
    80001194:	1141                	addi	sp,sp,-16
    80001196:	e406                	sd	ra,8(sp)
    80001198:	e022                	sd	s0,0(sp)
    8000119a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000119c:	f4fff0ef          	jal	800010ea <kvmmake>
    800011a0:	00009797          	auipc	a5,0x9
    800011a4:	26a7b023          	sd	a0,608(a5) # 8000a400 <kernel_pagetable>
}
    800011a8:	60a2                	ld	ra,8(sp)
    800011aa:	6402                	ld	s0,0(sp)
    800011ac:	0141                	addi	sp,sp,16
    800011ae:	8082                	ret

00000000800011b0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800011b0:	1101                	addi	sp,sp,-32
    800011b2:	ec06                	sd	ra,24(sp)
    800011b4:	e822                	sd	s0,16(sp)
    800011b6:	e426                	sd	s1,8(sp)
    800011b8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800011ba:	965ff0ef          	jal	80000b1e <kalloc>
    800011be:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800011c0:	c509                	beqz	a0,800011ca <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800011c2:	6605                	lui	a2,0x1
    800011c4:	4581                	li	a1,0
    800011c6:	aefff0ef          	jal	80000cb4 <memset>
  return pagetable;
}
    800011ca:	8526                	mv	a0,s1
    800011cc:	60e2                	ld	ra,24(sp)
    800011ce:	6442                	ld	s0,16(sp)
    800011d0:	64a2                	ld	s1,8(sp)
    800011d2:	6105                	addi	sp,sp,32
    800011d4:	8082                	ret

00000000800011d6 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011d6:	7139                	addi	sp,sp,-64
    800011d8:	fc06                	sd	ra,56(sp)
    800011da:	f822                	sd	s0,48(sp)
    800011dc:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    800011de:	03459793          	slli	a5,a1,0x34
    800011e2:	e38d                	bnez	a5,80001204 <uvmunmap+0x2e>
    800011e4:	f04a                	sd	s2,32(sp)
    800011e6:	ec4e                	sd	s3,24(sp)
    800011e8:	e852                	sd	s4,16(sp)
    800011ea:	e456                	sd	s5,8(sp)
    800011ec:	e05a                	sd	s6,0(sp)
    800011ee:	8a2a                	mv	s4,a0
    800011f0:	892e                	mv	s2,a1
    800011f2:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    800011f4:	0632                	slli	a2,a2,0xc
    800011f6:	00b609b3          	add	s3,a2,a1
    800011fa:	6b05                	lui	s6,0x1
    800011fc:	0535f963          	bgeu	a1,s3,8000124e <uvmunmap+0x78>
    80001200:	f426                	sd	s1,40(sp)
    80001202:	a015                	j	80001226 <uvmunmap+0x50>
    80001204:	f426                	sd	s1,40(sp)
    80001206:	f04a                	sd	s2,32(sp)
    80001208:	ec4e                	sd	s3,24(sp)
    8000120a:	e852                	sd	s4,16(sp)
    8000120c:	e456                	sd	s5,8(sp)
    8000120e:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    80001210:	00006517          	auipc	a0,0x6
    80001214:	f0850513          	addi	a0,a0,-248 # 80007118 <etext+0x118>
    80001218:	e30ff0ef          	jal	80000848 <panic>
      continue;
    if (do_free) {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    8000121c:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80001220:	995a                	add	s2,s2,s6
    80001222:	03397563          	bgeu	s2,s3,8000124c <uvmunmap+0x76>
    if ((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    80001226:	4601                	li	a2,0
    80001228:	85ca                	mv	a1,s2
    8000122a:	8552                	mv	a0,s4
    8000122c:	d15ff0ef          	jal	80000f40 <walk>
    80001230:	84aa                	mv	s1,a0
    80001232:	d57d                	beqz	a0,80001220 <uvmunmap+0x4a>
    if ((*pte & PTE_V) == 0) // has physical page been allocated?
    80001234:	611c                	ld	a5,0(a0)
    80001236:	0017f713          	andi	a4,a5,1
    8000123a:	d37d                	beqz	a4,80001220 <uvmunmap+0x4a>
    if (do_free) {
    8000123c:	fe0a80e3          	beqz	s5,8000121c <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    80001240:	83a9                	srli	a5,a5,0xa
      kfree((void *)pa);
    80001242:	00c79513          	slli	a0,a5,0xc
    80001246:	ff0ff0ef          	jal	80000a36 <kfree>
    8000124a:	bfc9                	j	8000121c <uvmunmap+0x46>
    8000124c:	74a2                	ld	s1,40(sp)
    8000124e:	7902                	ld	s2,32(sp)
    80001250:	69e2                	ld	s3,24(sp)
    80001252:	6a42                	ld	s4,16(sp)
    80001254:	6aa2                	ld	s5,8(sp)
    80001256:	6b02                	ld	s6,0(sp)
  }
}
    80001258:	70e2                	ld	ra,56(sp)
    8000125a:	7442                	ld	s0,48(sp)
    8000125c:	6121                	addi	sp,sp,64
    8000125e:	8082                	ret

0000000080001260 <uvmdealloc>:
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
  if (newsz >= oldsz)
    80001260:	04b67163          	bgeu	a2,a1,800012a2 <uvmdealloc+0x42>
{
    80001264:	1101                	addi	sp,sp,-32
    80001266:	ec06                	sd	ra,24(sp)
    80001268:	e822                	sd	s0,16(sp)
    8000126a:	e426                	sd	s1,8(sp)
    8000126c:	1000                	addi	s0,sp,32
    8000126e:	84b2                	mv	s1,a2
    return oldsz;

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    80001270:	6785                	lui	a5,0x1
    80001272:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001274:	00f60733          	add	a4,a2,a5
    80001278:	76fd                	lui	a3,0xfffff
    8000127a:	8f75                	and	a4,a4,a3
    8000127c:	97ae                	add	a5,a5,a1
    8000127e:	8ff5                	and	a5,a5,a3
    80001280:	00f76863          	bltu	a4,a5,80001290 <uvmdealloc+0x30>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
    80001284:	8526                	mv	a0,s1
}
    80001286:	60e2                	ld	ra,24(sp)
    80001288:	6442                	ld	s0,16(sp)
    8000128a:	64a2                	ld	s1,8(sp)
    8000128c:	6105                	addi	sp,sp,32
    8000128e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001290:	8f99                	sub	a5,a5,a4
    80001292:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001294:	4685                	li	a3,1
    80001296:	0007861b          	sext.w	a2,a5
    8000129a:	85ba                	mv	a1,a4
    8000129c:	f3bff0ef          	jal	800011d6 <uvmunmap>
    800012a0:	b7d5                	j	80001284 <uvmdealloc+0x24>
    return oldsz;
    800012a2:	852e                	mv	a0,a1
}
    800012a4:	8082                	ret

00000000800012a6 <uvmalloc>:
  if (newsz < oldsz)
    800012a6:	08b66e63          	bltu	a2,a1,80001342 <uvmalloc+0x9c>
{
    800012aa:	715d                	addi	sp,sp,-80
    800012ac:	e486                	sd	ra,72(sp)
    800012ae:	e0a2                	sd	s0,64(sp)
    800012b0:	f052                	sd	s4,32(sp)
    800012b2:	ec56                	sd	s5,24(sp)
    800012b4:	e45e                	sd	s7,8(sp)
    800012b6:	0880                	addi	s0,sp,80
    800012b8:	8aaa                	mv	s5,a0
    800012ba:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800012bc:	6785                	lui	a5,0x1
    800012be:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012c0:	95be                	add	a1,a1,a5
    800012c2:	77fd                	lui	a5,0xfffff
    800012c4:	8fed                	and	a5,a5,a1
    800012c6:	8bbe                	mv	s7,a5
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800012c8:	04c7f163          	bgeu	a5,a2,8000130a <uvmalloc+0x64>
    800012cc:	fc26                	sd	s1,56(sp)
    800012ce:	f84a                	sd	s2,48(sp)
    800012d0:	f44e                	sd	s3,40(sp)
    800012d2:	e85a                	sd	s6,16(sp)
    800012d4:	893e                	mv	s2,a5
    memset(mem, 0, PGSIZE);
    800012d6:	6985                	lui	s3,0x1
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800012d8:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800012dc:	843ff0ef          	jal	80000b1e <kalloc>
    800012e0:	84aa                	mv	s1,a0
    if (mem == 0) {
    800012e2:	c515                	beqz	a0,8000130e <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    800012e4:	864e                	mv	a2,s3
    800012e6:	4581                	li	a1,0
    800012e8:	9cdff0ef          	jal	80000cb4 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800012ec:	875a                	mv	a4,s6
    800012ee:	86a6                	mv	a3,s1
    800012f0:	864e                	mv	a2,s3
    800012f2:	85ca                	mv	a1,s2
    800012f4:	8556                	mv	a0,s5
    800012f6:	d1bff0ef          	jal	80001010 <mappages>
    800012fa:	e91d                	bnez	a0,80001330 <uvmalloc+0x8a>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800012fc:	994e                	add	s2,s2,s3
    800012fe:	fd496fe3          	bltu	s2,s4,800012dc <uvmalloc+0x36>
    80001302:	74e2                	ld	s1,56(sp)
    80001304:	7942                	ld	s2,48(sp)
    80001306:	79a2                	ld	s3,40(sp)
    80001308:	6b42                	ld	s6,16(sp)
  return newsz;
    8000130a:	8552                	mv	a0,s4
    8000130c:	a819                	j	80001322 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    8000130e:	865e                	mv	a2,s7
    80001310:	85ca                	mv	a1,s2
    80001312:	8556                	mv	a0,s5
    80001314:	f4dff0ef          	jal	80001260 <uvmdealloc>
      return 0;
    80001318:	4501                	li	a0,0
    8000131a:	74e2                	ld	s1,56(sp)
    8000131c:	7942                	ld	s2,48(sp)
    8000131e:	79a2                	ld	s3,40(sp)
    80001320:	6b42                	ld	s6,16(sp)
}
    80001322:	60a6                	ld	ra,72(sp)
    80001324:	6406                	ld	s0,64(sp)
    80001326:	7a02                	ld	s4,32(sp)
    80001328:	6ae2                	ld	s5,24(sp)
    8000132a:	6ba2                	ld	s7,8(sp)
    8000132c:	6161                	addi	sp,sp,80
    8000132e:	8082                	ret
      kfree(mem);
    80001330:	8526                	mv	a0,s1
    80001332:	f04ff0ef          	jal	80000a36 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001336:	865e                	mv	a2,s7
    80001338:	85ca                	mv	a1,s2
    8000133a:	8556                	mv	a0,s5
    8000133c:	f25ff0ef          	jal	80001260 <uvmdealloc>
      return 0;
    80001340:	bfe1                	j	80001318 <uvmalloc+0x72>
    return oldsz;
    80001342:	852e                	mv	a0,a1
}
    80001344:	8082                	ret

0000000080001346 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001346:	7179                	addi	sp,sp,-48
    80001348:	f406                	sd	ra,40(sp)
    8000134a:	f022                	sd	s0,32(sp)
    8000134c:	ec26                	sd	s1,24(sp)
    8000134e:	e84a                	sd	s2,16(sp)
    80001350:	e44e                	sd	s3,8(sp)
    80001352:	1800                	addi	s0,sp,48
    80001354:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    80001356:	84aa                	mv	s1,a0
    80001358:	6905                	lui	s2,0x1
    8000135a:	992a                	add	s2,s2,a0
    8000135c:	a811                	j	80001370 <freewalk+0x2a>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if (pte & PTE_V) {
      panic("freewalk: leaf");
    8000135e:	00006517          	auipc	a0,0x6
    80001362:	dd250513          	addi	a0,a0,-558 # 80007130 <etext+0x130>
    80001366:	ce2ff0ef          	jal	80000848 <panic>
  for (int i = 0; i < 512; i++) {
    8000136a:	04a1                	addi	s1,s1,8
    8000136c:	03248163          	beq	s1,s2,8000138e <freewalk+0x48>
    pte_t pte = pagetable[i];
    80001370:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80001372:	0017f713          	andi	a4,a5,1
    80001376:	db75                	beqz	a4,8000136a <freewalk+0x24>
    80001378:	00e7f713          	andi	a4,a5,14
    8000137c:	f36d                	bnez	a4,8000135e <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    8000137e:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001380:	00c79513          	slli	a0,a5,0xc
    80001384:	fc3ff0ef          	jal	80001346 <freewalk>
      pagetable[i] = 0;
    80001388:	0004b023          	sd	zero,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    8000138c:	bff9                	j	8000136a <freewalk+0x24>
    }
  }
  kfree((void *)pagetable);
    8000138e:	854e                	mv	a0,s3
    80001390:	ea6ff0ef          	jal	80000a36 <kfree>
}
    80001394:	70a2                	ld	ra,40(sp)
    80001396:	7402                	ld	s0,32(sp)
    80001398:	64e2                	ld	s1,24(sp)
    8000139a:	6942                	ld	s2,16(sp)
    8000139c:	69a2                	ld	s3,8(sp)
    8000139e:	6145                	addi	sp,sp,48
    800013a0:	8082                	ret

00000000800013a2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800013a2:	1101                	addi	sp,sp,-32
    800013a4:	ec06                	sd	ra,24(sp)
    800013a6:	e822                	sd	s0,16(sp)
    800013a8:	e426                	sd	s1,8(sp)
    800013aa:	1000                	addi	s0,sp,32
    800013ac:	84aa                	mv	s1,a0
  if (sz > 0)
    800013ae:	e989                	bnez	a1,800013c0 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    800013b0:	8526                	mv	a0,s1
    800013b2:	f95ff0ef          	jal	80001346 <freewalk>
}
    800013b6:	60e2                	ld	ra,24(sp)
    800013b8:	6442                	ld	s0,16(sp)
    800013ba:	64a2                	ld	s1,8(sp)
    800013bc:	6105                	addi	sp,sp,32
    800013be:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800013c0:	6785                	lui	a5,0x1
    800013c2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013c4:	95be                	add	a1,a1,a5
    800013c6:	4685                	li	a3,1
    800013c8:	00c5d613          	srli	a2,a1,0xc
    800013cc:	4581                	li	a1,0
    800013ce:	e09ff0ef          	jal	800011d6 <uvmunmap>
    800013d2:	bff9                	j	800013b0 <uvmfree+0xe>

00000000800013d4 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE) {
    800013d4:	ca59                	beqz	a2,8000146a <uvmcopy+0x96>
{
    800013d6:	715d                	addi	sp,sp,-80
    800013d8:	e486                	sd	ra,72(sp)
    800013da:	e0a2                	sd	s0,64(sp)
    800013dc:	fc26                	sd	s1,56(sp)
    800013de:	f84a                	sd	s2,48(sp)
    800013e0:	f44e                	sd	s3,40(sp)
    800013e2:	f052                	sd	s4,32(sp)
    800013e4:	ec56                	sd	s5,24(sp)
    800013e6:	e85a                	sd	s6,16(sp)
    800013e8:	e45e                	sd	s7,8(sp)
    800013ea:	0880                	addi	s0,sp,80
    800013ec:	8b2a                	mv	s6,a0
    800013ee:	8bae                	mv	s7,a1
    800013f0:	8ab2                	mv	s5,a2
  for (i = 0; i < sz; i += PGSIZE) {
    800013f2:	4481                	li	s1,0
      continue; // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if ((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char *)pa, PGSIZE);
    800013f4:	6a05                	lui	s4,0x1
    800013f6:	a021                	j	800013fe <uvmcopy+0x2a>
  for (i = 0; i < sz; i += PGSIZE) {
    800013f8:	94d2                	add	s1,s1,s4
    800013fa:	0554fc63          	bgeu	s1,s5,80001452 <uvmcopy+0x7e>
    if ((pte = walk(old, i, 0)) == 0)
    800013fe:	4601                	li	a2,0
    80001400:	85a6                	mv	a1,s1
    80001402:	855a                	mv	a0,s6
    80001404:	b3dff0ef          	jal	80000f40 <walk>
    80001408:	d965                	beqz	a0,800013f8 <uvmcopy+0x24>
    if ((*pte & PTE_V) == 0)
    8000140a:	00053983          	ld	s3,0(a0)
    8000140e:	0019f793          	andi	a5,s3,1
    80001412:	d3fd                	beqz	a5,800013f8 <uvmcopy+0x24>
    if ((mem = kalloc()) == 0)
    80001414:	f0aff0ef          	jal	80000b1e <kalloc>
    80001418:	892a                	mv	s2,a0
    8000141a:	c11d                	beqz	a0,80001440 <uvmcopy+0x6c>
    pa = PTE2PA(*pte);
    8000141c:	00a9d593          	srli	a1,s3,0xa
    memmove(mem, (char *)pa, PGSIZE);
    80001420:	8652                	mv	a2,s4
    80001422:	05b2                	slli	a1,a1,0xc
    80001424:	8edff0ef          	jal	80000d10 <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    80001428:	3ff9f713          	andi	a4,s3,1023
    8000142c:	86ca                	mv	a3,s2
    8000142e:	8652                	mv	a2,s4
    80001430:	85a6                	mv	a1,s1
    80001432:	855e                	mv	a0,s7
    80001434:	bddff0ef          	jal	80001010 <mappages>
    80001438:	d161                	beqz	a0,800013f8 <uvmcopy+0x24>
      kfree(mem);
    8000143a:	854a                	mv	a0,s2
    8000143c:	dfaff0ef          	jal	80000a36 <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001440:	4685                	li	a3,1
    80001442:	00c4d613          	srli	a2,s1,0xc
    80001446:	4581                	li	a1,0
    80001448:	855e                	mv	a0,s7
    8000144a:	d8dff0ef          	jal	800011d6 <uvmunmap>
  return -1;
    8000144e:	557d                	li	a0,-1
    80001450:	a011                	j	80001454 <uvmcopy+0x80>
  return 0;
    80001452:	4501                	li	a0,0
}
    80001454:	60a6                	ld	ra,72(sp)
    80001456:	6406                	ld	s0,64(sp)
    80001458:	74e2                	ld	s1,56(sp)
    8000145a:	7942                	ld	s2,48(sp)
    8000145c:	79a2                	ld	s3,40(sp)
    8000145e:	7a02                	ld	s4,32(sp)
    80001460:	6ae2                	ld	s5,24(sp)
    80001462:	6b42                	ld	s6,16(sp)
    80001464:	6ba2                	ld	s7,8(sp)
    80001466:	6161                	addi	sp,sp,80
    80001468:	8082                	ret
  return 0;
    8000146a:	4501                	li	a0,0
}
    8000146c:	8082                	ret

000000008000146e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000146e:	1141                	addi	sp,sp,-16
    80001470:	e406                	sd	ra,8(sp)
    80001472:	e022                	sd	s0,0(sp)
    80001474:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80001476:	4601                	li	a2,0
    80001478:	ac9ff0ef          	jal	80000f40 <walk>
  if (pte == 0)
    8000147c:	c901                	beqz	a0,8000148c <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000147e:	611c                	ld	a5,0(a0)
    80001480:	9bbd                	andi	a5,a5,-17
    80001482:	e11c                	sd	a5,0(a0)
}
    80001484:	60a2                	ld	ra,8(sp)
    80001486:	6402                	ld	s0,0(sp)
    80001488:	0141                	addi	sp,sp,16
    8000148a:	8082                	ret
    panic("uvmclear");
    8000148c:	00006517          	auipc	a0,0x6
    80001490:	cb450513          	addi	a0,a0,-844 # 80007140 <etext+0x140>
    80001494:	bb4ff0ef          	jal	80000848 <panic>

0000000080001498 <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    80001498:	1141                	addi	sp,sp,-16
    8000149a:	e406                	sd	ra,8(sp)
    8000149c:	e022                	sd	s0,0(sp)
    8000149e:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    800014a0:	4601                	li	a2,0
    800014a2:	a9fff0ef          	jal	80000f40 <walk>
  if (pte == 0) {
    800014a6:	c119                	beqz	a0,800014ac <ismapped+0x14>
    return 0;
  }
  if (*pte & PTE_V) {
    800014a8:	6108                	ld	a0,0(a0)
    800014aa:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    800014ac:	60a2                	ld	ra,8(sp)
    800014ae:	6402                	ld	s0,0(sp)
    800014b0:	0141                	addi	sp,sp,16
    800014b2:	8082                	ret

00000000800014b4 <vmfault>:
{
    800014b4:	7179                	addi	sp,sp,-48
    800014b6:	f406                	sd	ra,40(sp)
    800014b8:	f022                	sd	s0,32(sp)
    800014ba:	e052                	sd	s4,0(sp)
    800014bc:	1800                	addi	s0,sp,48
  if (va >= psz)
    800014be:	00b66d63          	bltu	a2,a1,800014d8 <vmfault+0x24>
    return 0;
    800014c2:	4a01                	li	s4,0
}
    800014c4:	8552                	mv	a0,s4
    800014c6:	70a2                	ld	ra,40(sp)
    800014c8:	7402                	ld	s0,32(sp)
    800014ca:	6a02                	ld	s4,0(sp)
    800014cc:	6145                	addi	sp,sp,48
    800014ce:	8082                	ret
    800014d0:	64e2                	ld	s1,24(sp)
    800014d2:	6942                	ld	s2,16(sp)
    800014d4:	69a2                	ld	s3,8(sp)
    800014d6:	b7f5                	j	800014c2 <vmfault+0xe>
    800014d8:	e84a                	sd	s2,16(sp)
    800014da:	e44e                	sd	s3,8(sp)
  va = PGROUNDDOWN(va);
    800014dc:	77fd                	lui	a5,0xfffff
    800014de:	00f67933          	and	s2,a2,a5
  if (ismapped(pagetable, va)) {
    800014e2:	85ca                	mv	a1,s2
    800014e4:	89aa                	mv	s3,a0
    800014e6:	fb3ff0ef          	jal	80001498 <ismapped>
    800014ea:	c501                	beqz	a0,800014f2 <vmfault+0x3e>
    800014ec:	6942                	ld	s2,16(sp)
    800014ee:	69a2                	ld	s3,8(sp)
    800014f0:	bfc9                	j	800014c2 <vmfault+0xe>
    800014f2:	ec26                	sd	s1,24(sp)
  mem = (uint64)kalloc();
    800014f4:	e2aff0ef          	jal	80000b1e <kalloc>
    800014f8:	84aa                	mv	s1,a0
  if (mem == 0)
    800014fa:	d979                	beqz	a0,800014d0 <vmfault+0x1c>
  mem = (uint64)kalloc();
    800014fc:	8a2a                	mv	s4,a0
  memset((void *)mem, 0, PGSIZE);
    800014fe:	6605                	lui	a2,0x1
    80001500:	4581                	li	a1,0
    80001502:	fb2ff0ef          	jal	80000cb4 <memset>
  if (mappages(pagetable, va, PGSIZE, mem, PTE_W | PTE_U | PTE_R) != 0) {
    80001506:	4759                	li	a4,22
    80001508:	86a6                	mv	a3,s1
    8000150a:	6605                	lui	a2,0x1
    8000150c:	85ca                	mv	a1,s2
    8000150e:	854e                	mv	a0,s3
    80001510:	b01ff0ef          	jal	80001010 <mappages>
    80001514:	e509                	bnez	a0,8000151e <vmfault+0x6a>
    80001516:	64e2                	ld	s1,24(sp)
    80001518:	6942                	ld	s2,16(sp)
    8000151a:	69a2                	ld	s3,8(sp)
    8000151c:	b765                	j	800014c4 <vmfault+0x10>
    kfree((void *)mem);
    8000151e:	8526                	mv	a0,s1
    80001520:	d16ff0ef          	jal	80000a36 <kfree>
    return 0;
    80001524:	64e2                	ld	s1,24(sp)
    80001526:	6942                	ld	s2,16(sp)
    80001528:	69a2                	ld	s3,8(sp)
    8000152a:	bf61                	j	800014c2 <vmfault+0xe>

000000008000152c <copyout>:
  while (len > 0) {
    8000152c:	cf55                	beqz	a4,800015e8 <copyout+0xbc>
{
    8000152e:	7159                	addi	sp,sp,-112
    80001530:	f486                	sd	ra,104(sp)
    80001532:	f0a2                	sd	s0,96(sp)
    80001534:	eca6                	sd	s1,88(sp)
    80001536:	e8ca                	sd	s2,80(sp)
    80001538:	e4ce                	sd	s3,72(sp)
    8000153a:	e0d2                	sd	s4,64(sp)
    8000153c:	fc56                	sd	s5,56(sp)
    8000153e:	f85a                	sd	s6,48(sp)
    80001540:	f45e                	sd	s7,40(sp)
    80001542:	f062                	sd	s8,32(sp)
    80001544:	ec66                	sd	s9,24(sp)
    80001546:	e86a                	sd	s10,16(sp)
    80001548:	e46e                	sd	s11,8(sp)
    8000154a:	1880                	addi	s0,sp,112
    8000154c:	8baa                	mv	s7,a0
    8000154e:	8dae                	mv	s11,a1
    80001550:	84b2                	mv	s1,a2
    80001552:	8b36                	mv	s6,a3
    80001554:	8aba                	mv	s5,a4
    va0 = PGROUNDDOWN(dstva);
    80001556:	7d7d                	lui	s10,0xfffff
    if (va0 >= MAXVA)
    80001558:	5cfd                	li	s9,-1
    8000155a:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    8000155e:	6c05                	lui	s8,0x1
    80001560:	a089                	j	800015a2 <copyout+0x76>
      return -1;
    80001562:	557d                	li	a0,-1
}
    80001564:	70a6                	ld	ra,104(sp)
    80001566:	7406                	ld	s0,96(sp)
    80001568:	64e6                	ld	s1,88(sp)
    8000156a:	6946                	ld	s2,80(sp)
    8000156c:	69a6                	ld	s3,72(sp)
    8000156e:	6a06                	ld	s4,64(sp)
    80001570:	7ae2                	ld	s5,56(sp)
    80001572:	7b42                	ld	s6,48(sp)
    80001574:	7ba2                	ld	s7,40(sp)
    80001576:	7c02                	ld	s8,32(sp)
    80001578:	6ce2                	ld	s9,24(sp)
    8000157a:	6d42                	ld	s10,16(sp)
    8000157c:	6da2                	ld	s11,8(sp)
    8000157e:	6165                	addi	sp,sp,112
    80001580:	8082                	ret
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001582:	03449513          	slli	a0,s1,0x34
    80001586:	9151                	srli	a0,a0,0x34
    80001588:	0009061b          	sext.w	a2,s2
    8000158c:	85da                	mv	a1,s6
    8000158e:	954e                	add	a0,a0,s3
    80001590:	f80ff0ef          	jal	80000d10 <memmove>
    len -= n;
    80001594:	412a8ab3          	sub	s5,s5,s2
    src += n;
    80001598:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    8000159a:	018a04b3          	add	s1,s4,s8
  while (len > 0) {
    8000159e:	040a8363          	beqz	s5,800015e4 <copyout+0xb8>
    va0 = PGROUNDDOWN(dstva);
    800015a2:	01a4fa33          	and	s4,s1,s10
    if (va0 >= MAXVA)
    800015a6:	fb4ceee3          	bltu	s9,s4,80001562 <copyout+0x36>
    pa0 = walkaddr(pagetable, va0);
    800015aa:	85d2                	mv	a1,s4
    800015ac:	855e                	mv	a0,s7
    800015ae:	a2bff0ef          	jal	80000fd8 <walkaddr>
    800015b2:	89aa                	mv	s3,a0
    if (pa0 == 0) {
    800015b4:	e909                	bnez	a0,800015c6 <copyout+0x9a>
      if ((pa0 = vmfault(pagetable, psz, va0, 0)) == 0) {
    800015b6:	4681                	li	a3,0
    800015b8:	8652                	mv	a2,s4
    800015ba:	85ee                	mv	a1,s11
    800015bc:	855e                	mv	a0,s7
    800015be:	ef7ff0ef          	jal	800014b4 <vmfault>
    800015c2:	89aa                	mv	s3,a0
    800015c4:	dd59                	beqz	a0,80001562 <copyout+0x36>
    pte = walk(pagetable, va0, 0);
    800015c6:	4601                	li	a2,0
    800015c8:	85d2                	mv	a1,s4
    800015ca:	855e                	mv	a0,s7
    800015cc:	975ff0ef          	jal	80000f40 <walk>
    if ((*pte & PTE_W) == 0)
    800015d0:	611c                	ld	a5,0(a0)
    800015d2:	8b91                	andi	a5,a5,4
    800015d4:	d7d9                	beqz	a5,80001562 <copyout+0x36>
    n = PGSIZE - (dstva - va0);
    800015d6:	409a0933          	sub	s2,s4,s1
    800015da:	9962                	add	s2,s2,s8
    if (n > len)
    800015dc:	fb2af3e3          	bgeu	s5,s2,80001582 <copyout+0x56>
    800015e0:	8956                	mv	s2,s5
    800015e2:	b745                	j	80001582 <copyout+0x56>
  return 0;
    800015e4:	4501                	li	a0,0
    800015e6:	bfbd                	j	80001564 <copyout+0x38>
    800015e8:	4501                	li	a0,0
}
    800015ea:	8082                	ret

00000000800015ec <copyin>:
  while (len > 0) {
    800015ec:	cf49                	beqz	a4,80001686 <copyin+0x9a>
{
    800015ee:	711d                	addi	sp,sp,-96
    800015f0:	ec86                	sd	ra,88(sp)
    800015f2:	e8a2                	sd	s0,80(sp)
    800015f4:	e4a6                	sd	s1,72(sp)
    800015f6:	e0ca                	sd	s2,64(sp)
    800015f8:	fc4e                	sd	s3,56(sp)
    800015fa:	f852                	sd	s4,48(sp)
    800015fc:	f456                	sd	s5,40(sp)
    800015fe:	f05a                	sd	s6,32(sp)
    80001600:	ec5e                	sd	s7,24(sp)
    80001602:	e862                	sd	s8,16(sp)
    80001604:	e466                	sd	s9,8(sp)
    80001606:	e06a                	sd	s10,0(sp)
    80001608:	1080                	addi	s0,sp,96
    8000160a:	8baa                	mv	s7,a0
    8000160c:	8cae                	mv	s9,a1
    8000160e:	8ab2                	mv	s5,a2
    80001610:	84b6                	mv	s1,a3
    80001612:	89ba                	mv	s3,a4
    va0 = PGROUNDDOWN(srcva);
    80001614:	7c7d                	lui	s8,0xfffff
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    80001616:	4d05                	li	s10,1
    n = PGSIZE - (srcva - va0);
    80001618:	6b05                	lui	s6,0x1
    8000161a:	a03d                	j	80001648 <copyin+0x5c>
    8000161c:	409a0933          	sub	s2,s4,s1
    80001620:	995a                	add	s2,s2,s6
    if (n > len)
    80001622:	0129f363          	bgeu	s3,s2,80001628 <copyin+0x3c>
    80001626:	894e                	mv	s2,s3
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001628:	03449593          	slli	a1,s1,0x34
    8000162c:	91d1                	srli	a1,a1,0x34
    8000162e:	0009061b          	sext.w	a2,s2
    80001632:	95aa                	add	a1,a1,a0
    80001634:	8556                	mv	a0,s5
    80001636:	edaff0ef          	jal	80000d10 <memmove>
    len -= n;
    8000163a:	412989b3          	sub	s3,s3,s2
    dst += n;
    8000163e:	9aca                	add	s5,s5,s2
    srcva = va0 + PGSIZE;
    80001640:	016a04b3          	add	s1,s4,s6
  while (len > 0) {
    80001644:	02098263          	beqz	s3,80001668 <copyin+0x7c>
    va0 = PGROUNDDOWN(srcva);
    80001648:	0184fa33          	and	s4,s1,s8
    pa0 = walkaddr(pagetable, va0);
    8000164c:	85d2                	mv	a1,s4
    8000164e:	855e                	mv	a0,s7
    80001650:	989ff0ef          	jal	80000fd8 <walkaddr>
    if (pa0 == 0) {
    80001654:	f561                	bnez	a0,8000161c <copyin+0x30>
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    80001656:	86ea                	mv	a3,s10
    80001658:	8652                	mv	a2,s4
    8000165a:	85e6                	mv	a1,s9
    8000165c:	855e                	mv	a0,s7
    8000165e:	e57ff0ef          	jal	800014b4 <vmfault>
    80001662:	fd4d                	bnez	a0,8000161c <copyin+0x30>
        return -1;
    80001664:	557d                	li	a0,-1
    80001666:	a011                	j	8000166a <copyin+0x7e>
  return 0;
    80001668:	4501                	li	a0,0
}
    8000166a:	60e6                	ld	ra,88(sp)
    8000166c:	6446                	ld	s0,80(sp)
    8000166e:	64a6                	ld	s1,72(sp)
    80001670:	6906                	ld	s2,64(sp)
    80001672:	79e2                	ld	s3,56(sp)
    80001674:	7a42                	ld	s4,48(sp)
    80001676:	7aa2                	ld	s5,40(sp)
    80001678:	7b02                	ld	s6,32(sp)
    8000167a:	6be2                	ld	s7,24(sp)
    8000167c:	6c42                	ld	s8,16(sp)
    8000167e:	6ca2                	ld	s9,8(sp)
    80001680:	6d02                	ld	s10,0(sp)
    80001682:	6125                	addi	sp,sp,96
    80001684:	8082                	ret
  return 0;
    80001686:	4501                	li	a0,0
}
    80001688:	8082                	ret

000000008000168a <copyinstr>:
  while (got_null == 0 && max > 0) {
    8000168a:	c771                	beqz	a4,80001756 <copyinstr+0xcc>
{
    8000168c:	711d                	addi	sp,sp,-96
    8000168e:	ec86                	sd	ra,88(sp)
    80001690:	e8a2                	sd	s0,80(sp)
    80001692:	e4a6                	sd	s1,72(sp)
    80001694:	e0ca                	sd	s2,64(sp)
    80001696:	fc4e                	sd	s3,56(sp)
    80001698:	f852                	sd	s4,48(sp)
    8000169a:	f456                	sd	s5,40(sp)
    8000169c:	f05a                	sd	s6,32(sp)
    8000169e:	ec5e                	sd	s7,24(sp)
    800016a0:	e862                	sd	s8,16(sp)
    800016a2:	e466                	sd	s9,8(sp)
    800016a4:	1080                	addi	s0,sp,96
    800016a6:	8b2a                	mv	s6,a0
    800016a8:	8c2e                	mv	s8,a1
    800016aa:	8932                	mv	s2,a2
    800016ac:	84b6                	mv	s1,a3
    800016ae:	8a3a                	mv	s4,a4
    va0 = PGROUNDDOWN(srcva);
    800016b0:	7bfd                	lui	s7,0xfffff
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    800016b2:	4c85                	li	s9,1
    n = PGSIZE - (srcva - va0);
    800016b4:	6a85                	lui	s5,0x1
    800016b6:	a881                	j	80001706 <copyinstr+0x7c>
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    800016b8:	86e6                	mv	a3,s9
    800016ba:	864e                	mv	a2,s3
    800016bc:	85e2                	mv	a1,s8
    800016be:	855a                	mv	a0,s6
    800016c0:	df5ff0ef          	jal	800014b4 <vmfault>
    800016c4:	e921                	bnez	a0,80001714 <copyinstr+0x8a>
        return -1;
    800016c6:	557d                	li	a0,-1
    800016c8:	a801                	j	800016d8 <copyinstr+0x4e>
        *dst = '\0';
    800016ca:	00078023          	sb	zero,0(a5) # fffffffffffff000 <end+0xffffffff7ffdb2b0>
        got_null = 1;
    800016ce:	4785                	li	a5,1
  if (got_null) {
    800016d0:	0017c793          	xori	a5,a5,1
    800016d4:	40f0053b          	negw	a0,a5
}
    800016d8:	60e6                	ld	ra,88(sp)
    800016da:	6446                	ld	s0,80(sp)
    800016dc:	64a6                	ld	s1,72(sp)
    800016de:	6906                	ld	s2,64(sp)
    800016e0:	79e2                	ld	s3,56(sp)
    800016e2:	7a42                	ld	s4,48(sp)
    800016e4:	7aa2                	ld	s5,40(sp)
    800016e6:	7b02                	ld	s6,32(sp)
    800016e8:	6be2                	ld	s7,24(sp)
    800016ea:	6c42                	ld	s8,16(sp)
    800016ec:	6ca2                	ld	s9,8(sp)
    800016ee:	6125                	addi	sp,sp,96
    800016f0:	8082                	ret
    800016f2:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800016f6:	974a                	add	a4,a4,s2
      --max;
    800016f8:	40a70a33          	sub	s4,a4,a0
    srcva = va0 + PGSIZE;
    800016fc:	015984b3          	add	s1,s3,s5
  while (got_null == 0 && max > 0) {
    80001700:	04e50563          	beq	a0,a4,8000174a <copyinstr+0xc0>
{
    80001704:	893e                	mv	s2,a5
    va0 = PGROUNDDOWN(srcva);
    80001706:	0174f9b3          	and	s3,s1,s7
    pa0 = walkaddr(pagetable, va0);
    8000170a:	85ce                	mv	a1,s3
    8000170c:	855a                	mv	a0,s6
    8000170e:	8cbff0ef          	jal	80000fd8 <walkaddr>
    if (pa0 == 0) {
    80001712:	d15d                	beqz	a0,800016b8 <copyinstr+0x2e>
    n = PGSIZE - (srcva - va0);
    80001714:	40998633          	sub	a2,s3,s1
    80001718:	9656                	add	a2,a2,s5
    if (n > max)
    8000171a:	00ca7363          	bgeu	s4,a2,80001720 <copyinstr+0x96>
    8000171e:	8652                	mv	a2,s4
    while (n > 0) {
    80001720:	c61d                	beqz	a2,8000174e <copyinstr+0xc4>
    char *p = (char *)(pa0 + (srcva - va0));
    80001722:	03449593          	slli	a1,s1,0x34
    80001726:	91d1                	srli	a1,a1,0x34
    80001728:	95aa                	add	a1,a1,a0
    8000172a:	87ca                	mv	a5,s2
      if (*p == '\0') {
    8000172c:	412585b3          	sub	a1,a1,s2
    while (n > 0) {
    80001730:	964a                	add	a2,a2,s2
    80001732:	853e                	mv	a0,a5
      if (*p == '\0') {
    80001734:	00f58733          	add	a4,a1,a5
    80001738:	00074683          	lbu	a3,0(a4)
    8000173c:	d6d9                	beqz	a3,800016ca <copyinstr+0x40>
        *dst = *p;
    8000173e:	00d78023          	sb	a3,0(a5)
      dst++;
    80001742:	0785                	addi	a5,a5,1
    while (n > 0) {
    80001744:	fec797e3          	bne	a5,a2,80001732 <copyinstr+0xa8>
    80001748:	b76d                	j	800016f2 <copyinstr+0x68>
    srcva = va0 + PGSIZE;
    8000174a:	4781                	li	a5,0
    8000174c:	b751                	j	800016d0 <copyinstr+0x46>
    8000174e:	6485                	lui	s1,0x1
    80001750:	94ce                	add	s1,s1,s3
    80001752:	87ca                	mv	a5,s2
    80001754:	bf45                	j	80001704 <copyinstr+0x7a>
    80001756:	4781                	li	a5,0
  if (got_null) {
    80001758:	0017c793          	xori	a5,a5,1
    8000175c:	40f0053b          	negw	a0,a5
}
    80001760:	8082                	ret

0000000080001762 <proc_mapstacks>:
//  Core process-management functions
// ============================================================

void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001762:	715d                	addi	sp,sp,-80
    80001764:	e486                	sd	ra,72(sp)
    80001766:	e0a2                	sd	s0,64(sp)
    80001768:	fc26                	sd	s1,56(sp)
    8000176a:	f84a                	sd	s2,48(sp)
    8000176c:	f44e                	sd	s3,40(sp)
    8000176e:	f052                	sd	s4,32(sp)
    80001770:	ec56                	sd	s5,24(sp)
    80001772:	e85a                	sd	s6,16(sp)
    80001774:	e45e                	sd	s7,8(sp)
    80001776:	0880                	addi	s0,sp,80
    80001778:	8a2a                	mv	s4,a0
    8000177a:	4481                	li	s1,0
  struct proc *p;
  for(p = proc; p < &proc[NPROC]; p++){
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    8000177c:	aaaab7b7          	lui	a5,0xaaaab
    80001780:	aab78793          	addi	a5,a5,-1365 # ffffffffaaaaaaab <end+0xffffffff2aa86d5b>
    80001784:	02079993          	slli	s3,a5,0x20
    80001788:	99be                	add	s3,s3,a5
    8000178a:	04000937          	lui	s2,0x4000
    8000178e:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001790:	0932                	slli	s2,s2,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001792:	4b99                	li	s7,6
    80001794:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++){
    80001796:	6a99                	lui	s5,0x6
    char *pa = kalloc();
    80001798:	b86ff0ef          	jal	80000b1e <kalloc>
    8000179c:	862a                	mv	a2,a0
    if(pa == 0)
    8000179e:	cd15                	beqz	a0,800017da <proc_mapstacks+0x78>
    uint64 va = KSTACK((int)(p - proc));
    800017a0:	4074d593          	srai	a1,s1,0x7
    800017a4:	033585b3          	mul	a1,a1,s3
    800017a8:	05b6                	slli	a1,a1,0xd
    800017aa:	6789                	lui	a5,0x2
    800017ac:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017ae:	875e                	mv	a4,s7
    800017b0:	86da                	mv	a3,s6
    800017b2:	40b905b3          	sub	a1,s2,a1
    800017b6:	8552                	mv	a0,s4
    800017b8:	90bff0ef          	jal	800010c2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++){
    800017bc:	18048493          	addi	s1,s1,384 # 1180 <_entry-0x7fffee80>
    800017c0:	fd549ce3          	bne	s1,s5,80001798 <proc_mapstacks+0x36>
  }
}
    800017c4:	60a6                	ld	ra,72(sp)
    800017c6:	6406                	ld	s0,64(sp)
    800017c8:	74e2                	ld	s1,56(sp)
    800017ca:	7942                	ld	s2,48(sp)
    800017cc:	79a2                	ld	s3,40(sp)
    800017ce:	7a02                	ld	s4,32(sp)
    800017d0:	6ae2                	ld	s5,24(sp)
    800017d2:	6b42                	ld	s6,16(sp)
    800017d4:	6ba2                	ld	s7,8(sp)
    800017d6:	6161                	addi	sp,sp,80
    800017d8:	8082                	ret
      panic("kalloc");
    800017da:	00006517          	auipc	a0,0x6
    800017de:	97650513          	addi	a0,a0,-1674 # 80007150 <etext+0x150>
    800017e2:	866ff0ef          	jal	80000848 <panic>

00000000800017e6 <procinit>:

void
procinit(void)
{
    800017e6:	7139                	addi	sp,sp,-64
    800017e8:	fc06                	sd	ra,56(sp)
    800017ea:	f822                	sd	s0,48(sp)
    800017ec:	f426                	sd	s1,40(sp)
    800017ee:	f04a                	sd	s2,32(sp)
    800017f0:	ec4e                	sd	s3,24(sp)
    800017f2:	e852                	sd	s4,16(sp)
    800017f4:	e456                	sd	s5,8(sp)
    800017f6:	e05a                	sd	s6,0(sp)
    800017f8:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    800017fa:	00006597          	auipc	a1,0x6
    800017fe:	95e58593          	addi	a1,a1,-1698 # 80007158 <etext+0x158>
    80001802:	00011517          	auipc	a0,0x11
    80001806:	d2e50513          	addi	a0,a0,-722 # 80012530 <pid_lock>
    8000180a:	b6eff0ef          	jal	80000b78 <initlock>
  initlock(&wait_lock, "wait_lock");
    8000180e:	00006597          	auipc	a1,0x6
    80001812:	95258593          	addi	a1,a1,-1710 # 80007160 <etext+0x160>
    80001816:	00011517          	auipc	a0,0x11
    8000181a:	d3250513          	addi	a0,a0,-718 # 80012548 <wait_lock>
    8000181e:	b5aff0ef          	jal	80000b78 <initlock>
    80001822:	4901                	li	s2,0
  for(p = proc; p < &proc[NPROC]; p++){
    80001824:	00011497          	auipc	s1,0x11
    80001828:	14c48493          	addi	s1,s1,332 # 80012970 <proc>
    initlock(&p->lock, "proc");
    8000182c:	00006a97          	auipc	s5,0x6
    80001830:	944a8a93          	addi	s5,s5,-1724 # 80007170 <etext+0x170>
    p->state  = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80001834:	aaaab7b7          	lui	a5,0xaaaab
    80001838:	aab78793          	addi	a5,a5,-1365 # ffffffffaaaaaaab <end+0xffffffff2aa86d5b>
    8000183c:	02079a13          	slli	s4,a5,0x20
    80001840:	9a3e                	add	s4,s4,a5
    80001842:	040009b7          	lui	s3,0x4000
    80001846:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001848:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++){
    8000184a:	00017b17          	auipc	s6,0x17
    8000184e:	126b0b13          	addi	s6,s6,294 # 80018970 <tickslock>
    initlock(&p->lock, "proc");
    80001852:	85d6                	mv	a1,s5
    80001854:	8526                	mv	a0,s1
    80001856:	b22ff0ef          	jal	80000b78 <initlock>
    p->state  = UNUSED;
    8000185a:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    8000185e:	40795793          	srai	a5,s2,0x7
    80001862:	034787b3          	mul	a5,a5,s4
    80001866:	07b6                	slli	a5,a5,0xd
    80001868:	6709                	lui	a4,0x2
    8000186a:	9fb9                	addw	a5,a5,a4
    8000186c:	40f987b3          	sub	a5,s3,a5
    80001870:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++){
    80001872:	18048493          	addi	s1,s1,384
    80001876:	18090913          	addi	s2,s2,384
    8000187a:	fd649ce3          	bne	s1,s6,80001852 <procinit+0x6c>
  }

#ifdef MLFQ
  for(int i = 0; i < NMLFQ; i++)
    mlfq_last[i] = 0;
    8000187e:	00011797          	auipc	a5,0x11
    80001882:	cb278793          	addi	a5,a5,-846 # 80012530 <pid_lock>
    80001886:	0207a823          	sw	zero,48(a5)
    8000188a:	0207aa23          	sw	zero,52(a5)
    8000188e:	0207ac23          	sw	zero,56(a5)
    80001892:	0207ae23          	sw	zero,60(a5)
#endif
}
    80001896:	70e2                	ld	ra,56(sp)
    80001898:	7442                	ld	s0,48(sp)
    8000189a:	74a2                	ld	s1,40(sp)
    8000189c:	7902                	ld	s2,32(sp)
    8000189e:	69e2                	ld	s3,24(sp)
    800018a0:	6a42                	ld	s4,16(sp)
    800018a2:	6aa2                	ld	s5,8(sp)
    800018a4:	6b02                	ld	s6,0(sp)
    800018a6:	6121                	addi	sp,sp,64
    800018a8:	8082                	ret

00000000800018aa <cpuid>:

int
cpuid()
{
    800018aa:	1141                	addi	sp,sp,-16
    800018ac:	e406                	sd	ra,8(sp)
    800018ae:	e022                	sd	s0,0(sp)
    800018b0:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    800018b2:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018b4:	2501                	sext.w	a0,a0
    800018b6:	60a2                	ld	ra,8(sp)
    800018b8:	6402                	ld	s0,0(sp)
    800018ba:	0141                	addi	sp,sp,16
    800018bc:	8082                	ret

00000000800018be <mycpu>:

struct cpu *
mycpu(void)
{
    800018be:	1141                	addi	sp,sp,-16
    800018c0:	e406                	sd	ra,8(sp)
    800018c2:	e022                	sd	s0,0(sp)
    800018c4:	0800                	addi	s0,sp,16
    800018c6:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018c8:	2781                	sext.w	a5,a5
    800018ca:	079e                	slli	a5,a5,0x7
  return c;
}
    800018cc:	00011517          	auipc	a0,0x11
    800018d0:	ca450513          	addi	a0,a0,-860 # 80012570 <cpus>
    800018d4:	953e                	add	a0,a0,a5
    800018d6:	60a2                	ld	ra,8(sp)
    800018d8:	6402                	ld	s0,0(sp)
    800018da:	0141                	addi	sp,sp,16
    800018dc:	8082                	ret

00000000800018de <myproc>:

struct proc *
myproc(void)
{
    800018de:	1101                	addi	sp,sp,-32
    800018e0:	ec06                	sd	ra,24(sp)
    800018e2:	e822                	sd	s0,16(sp)
    800018e4:	e426                	sd	s1,8(sp)
    800018e6:	1000                	addi	s0,sp,32
  push_off();
    800018e8:	ad6ff0ef          	jal	80000bbe <push_off>
    800018ec:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800018ee:	2781                	sext.w	a5,a5
    800018f0:	079e                	slli	a5,a5,0x7
    800018f2:	00011717          	auipc	a4,0x11
    800018f6:	c3e70713          	addi	a4,a4,-962 # 80012530 <pid_lock>
    800018fa:	97ba                	add	a5,a5,a4
    800018fc:	63bc                	ld	a5,64(a5)
    800018fe:	84be                	mv	s1,a5
  pop_off();
    80001900:	b34ff0ef          	jal	80000c34 <pop_off>
  return p;
}
    80001904:	8526                	mv	a0,s1
    80001906:	60e2                	ld	ra,24(sp)
    80001908:	6442                	ld	s0,16(sp)
    8000190a:	64a2                	ld	s1,8(sp)
    8000190c:	6105                	addi	sp,sp,32
    8000190e:	8082                	ret

0000000080001910 <mlfq_timer_tick>:
{
    80001910:	1141                	addi	sp,sp,-16
    80001912:	e406                	sd	ra,8(sp)
    80001914:	e022                	sd	s0,0(sp)
    80001916:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001918:	fc7ff0ef          	jal	800018de <myproc>
  if(p == 0)
    8000191c:	cd21                	beqz	a0,80001974 <mlfq_timer_tick+0x64>
  p->cpu_ticks++;
    8000191e:	17452783          	lw	a5,372(a0)
    80001922:	2785                	addiw	a5,a5,1
    80001924:	16f52a23          	sw	a5,372(a0)
  p->ticks_used++;
    80001928:	17c52783          	lw	a5,380(a0)
    8000192c:	2785                	addiw	a5,a5,1
    8000192e:	16f52e23          	sw	a5,380(a0)
  if(p->ticks_used >= mlfq_slice[p->queue]){
    80001932:	17852683          	lw	a3,376(a0)
    80001936:	00269613          	slli	a2,a3,0x2
    8000193a:	00006717          	auipc	a4,0x6
    8000193e:	f2670713          	addi	a4,a4,-218 # 80007860 <mlfq_slice>
    80001942:	9732                	add	a4,a4,a2
    80001944:	4318                	lw	a4,0(a4)
    80001946:	00e7ca63          	blt	a5,a4,8000195a <mlfq_timer_tick+0x4a>
    if(p->queue < NMLFQ - 1)
    8000194a:	4789                	li	a5,2
    8000194c:	00d7c563          	blt	a5,a3,80001956 <mlfq_timer_tick+0x46>
      p->queue++;
    80001950:	2685                	addiw	a3,a3,1 # fffffffffffff001 <end+0xffffffff7ffdb2b1>
    80001952:	16d52c23          	sw	a3,376(a0)
    p->ticks_used = 0;
    80001956:	16052e23          	sw	zero,380(a0)
  printk("MLFQLOG,%d,%d,%d\n", ticks, p->pid, p->queue);
    8000195a:	17852683          	lw	a3,376(a0)
    8000195e:	5910                	lw	a2,48(a0)
    80001960:	00009597          	auipc	a1,0x9
    80001964:	ab05a583          	lw	a1,-1360(a1) # 8000a410 <ticks>
    80001968:	00006517          	auipc	a0,0x6
    8000196c:	81050513          	addi	a0,a0,-2032 # 80007178 <etext+0x178>
    80001970:	ba1fe0ef          	jal	80000510 <printk>
}
    80001974:	60a2                	ld	ra,8(sp)
    80001976:	6402                	ld	s0,0(sp)
    80001978:	0141                	addi	sp,sp,16
    8000197a:	8082                	ret

000000008000197c <forkret>:
  release(&p->lock);
}

void
forkret(void)
{
    8000197c:	7179                	addi	sp,sp,-48
    8000197e:	f406                	sd	ra,40(sp)
    80001980:	f022                	sd	s0,32(sp)
    80001982:	ec26                	sd	s1,24(sp)
    80001984:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80001986:	f59ff0ef          	jal	800018de <myproc>
    8000198a:	84aa                	mv	s1,a0

  release(&p->lock);
    8000198c:	af0ff0ef          	jal	80000c7c <release>

  if(__atomic_load_n(&first, __ATOMIC_ACQUIRE)){
    80001990:	00009797          	auipc	a5,0x9
    80001994:	a5078793          	addi	a5,a5,-1456 # 8000a3e0 <first.1>
    80001998:	439c                	lw	a5,0(a5)
    8000199a:	0230000f          	fence	r,rw
    8000199e:	2781                	sext.w	a5,a5
    800019a0:	c3a1                	beqz	a5,800019e0 <forkret+0x64>
    fsinit(ROOTDEV);
    800019a2:	4505                	li	a0,1
    800019a4:	619010ef          	jal	800037bc <fsinit>
    __atomic_store_n(&first, 0, __ATOMIC_RELEASE);
    800019a8:	00009797          	auipc	a5,0x9
    800019ac:	a3878793          	addi	a5,a5,-1480 # 8000a3e0 <first.1>
    800019b0:	0310000f          	fence	rw,w
    800019b4:	0007a023          	sw	zero,0(a5)

    p->trapframe->a0 = kexec("/init", (char *[]){"/init", 0});
    800019b8:	00005797          	auipc	a5,0x5
    800019bc:	7d878793          	addi	a5,a5,2008 # 80007190 <etext+0x190>
    800019c0:	fcf43823          	sd	a5,-48(s0)
    800019c4:	fc043c23          	sd	zero,-40(s0)
    800019c8:	fd040593          	addi	a1,s0,-48
    800019cc:	853e                	mv	a0,a5
    800019ce:	066030ef          	jal	80004a34 <kexec>
    800019d2:	6cbc                	ld	a5,88(s1)
    800019d4:	fba8                	sd	a0,112(a5)
    if(p->trapframe->a0 == -1){
    800019d6:	6cbc                	ld	a5,88(s1)
    800019d8:	7bb8                	ld	a4,112(a5)
    800019da:	57fd                	li	a5,-1
    800019dc:	02f70d63          	beq	a4,a5,80001a16 <forkret+0x9a>
      panic("exec");
    }
  }

  prepare_return();
    800019e0:	445000ef          	jal	80002624 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    800019e4:	68a8                	ld	a0,80(s1)
    800019e6:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800019e8:	04000737          	lui	a4,0x4000
    800019ec:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800019ee:	0732                	slli	a4,a4,0xc
    800019f0:	00004797          	auipc	a5,0x4
    800019f4:	6ac78793          	addi	a5,a5,1708 # 8000609c <userret>
    800019f8:	00004697          	auipc	a3,0x4
    800019fc:	60868693          	addi	a3,a3,1544 # 80006000 <_trampoline>
    80001a00:	8f95                	sub	a5,a5,a3
    80001a02:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001a04:	577d                	li	a4,-1
    80001a06:	177e                	slli	a4,a4,0x3f
    80001a08:	8d59                	or	a0,a0,a4
    80001a0a:	9782                	jalr	a5
}
    80001a0c:	70a2                	ld	ra,40(sp)
    80001a0e:	7402                	ld	s0,32(sp)
    80001a10:	64e2                	ld	s1,24(sp)
    80001a12:	6145                	addi	sp,sp,48
    80001a14:	8082                	ret
      panic("exec");
    80001a16:	00005517          	auipc	a0,0x5
    80001a1a:	78250513          	addi	a0,a0,1922 # 80007198 <etext+0x198>
    80001a1e:	e2bfe0ef          	jal	80000848 <panic>

0000000080001a22 <allocpid>:
{
    80001a22:	1101                	addi	sp,sp,-32
    80001a24:	ec06                	sd	ra,24(sp)
    80001a26:	e822                	sd	s0,16(sp)
    80001a28:	e426                	sd	s1,8(sp)
    80001a2a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a2c:	00011517          	auipc	a0,0x11
    80001a30:	b0450513          	addi	a0,a0,-1276 # 80012530 <pid_lock>
    80001a34:	9c4ff0ef          	jal	80000bf8 <acquire>
  pid = nextpid;
    80001a38:	00009797          	auipc	a5,0x9
    80001a3c:	9ac78793          	addi	a5,a5,-1620 # 8000a3e4 <nextpid>
    80001a40:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a42:	0014871b          	addiw	a4,s1,1
    80001a46:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a48:	00011517          	auipc	a0,0x11
    80001a4c:	ae850513          	addi	a0,a0,-1304 # 80012530 <pid_lock>
    80001a50:	a2cff0ef          	jal	80000c7c <release>
}
    80001a54:	8526                	mv	a0,s1
    80001a56:	60e2                	ld	ra,24(sp)
    80001a58:	6442                	ld	s0,16(sp)
    80001a5a:	64a2                	ld	s1,8(sp)
    80001a5c:	6105                	addi	sp,sp,32
    80001a5e:	8082                	ret

0000000080001a60 <proc_pagetable>:
{
    80001a60:	1101                	addi	sp,sp,-32
    80001a62:	ec06                	sd	ra,24(sp)
    80001a64:	e822                	sd	s0,16(sp)
    80001a66:	e426                	sd	s1,8(sp)
    80001a68:	e04a                	sd	s2,0(sp)
    80001a6a:	1000                	addi	s0,sp,32
    80001a6c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a6e:	f42ff0ef          	jal	800011b0 <uvmcreate>
    80001a72:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001a74:	cd05                	beqz	a0,80001aac <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80001a76:	4729                	li	a4,10
    80001a78:	00004697          	auipc	a3,0x4
    80001a7c:	58868693          	addi	a3,a3,1416 # 80006000 <_trampoline>
    80001a80:	6605                	lui	a2,0x1
    80001a82:	040005b7          	lui	a1,0x4000
    80001a86:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a88:	05b2                	slli	a1,a1,0xc
    80001a8a:	d86ff0ef          	jal	80001010 <mappages>
    80001a8e:	02054663          	bltz	a0,80001aba <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80001a92:	4719                	li	a4,6
    80001a94:	05893683          	ld	a3,88(s2)
    80001a98:	6605                	lui	a2,0x1
    80001a9a:	020005b7          	lui	a1,0x2000
    80001a9e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001aa0:	05b6                	slli	a1,a1,0xd
    80001aa2:	8526                	mv	a0,s1
    80001aa4:	d6cff0ef          	jal	80001010 <mappages>
    80001aa8:	00054f63          	bltz	a0,80001ac6 <proc_pagetable+0x66>
}
    80001aac:	8526                	mv	a0,s1
    80001aae:	60e2                	ld	ra,24(sp)
    80001ab0:	6442                	ld	s0,16(sp)
    80001ab2:	64a2                	ld	s1,8(sp)
    80001ab4:	6902                	ld	s2,0(sp)
    80001ab6:	6105                	addi	sp,sp,32
    80001ab8:	8082                	ret
    uvmfree(pagetable, 0);
    80001aba:	4581                	li	a1,0
    80001abc:	8526                	mv	a0,s1
    80001abe:	8e5ff0ef          	jal	800013a2 <uvmfree>
    return 0;
    80001ac2:	4481                	li	s1,0
    80001ac4:	b7e5                	j	80001aac <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ac6:	4681                	li	a3,0
    80001ac8:	4605                	li	a2,1
    80001aca:	040005b7          	lui	a1,0x4000
    80001ace:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ad0:	05b2                	slli	a1,a1,0xc
    80001ad2:	8526                	mv	a0,s1
    80001ad4:	f02ff0ef          	jal	800011d6 <uvmunmap>
    uvmfree(pagetable, 0);
    80001ad8:	4581                	li	a1,0
    80001ada:	8526                	mv	a0,s1
    80001adc:	8c7ff0ef          	jal	800013a2 <uvmfree>
    return 0;
    80001ae0:	b7cd                	j	80001ac2 <proc_pagetable+0x62>

0000000080001ae2 <proc_freepagetable>:
{
    80001ae2:	1101                	addi	sp,sp,-32
    80001ae4:	ec06                	sd	ra,24(sp)
    80001ae6:	e822                	sd	s0,16(sp)
    80001ae8:	e426                	sd	s1,8(sp)
    80001aea:	e04a                	sd	s2,0(sp)
    80001aec:	1000                	addi	s0,sp,32
    80001aee:	84aa                	mv	s1,a0
    80001af0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001af2:	4681                	li	a3,0
    80001af4:	4605                	li	a2,1
    80001af6:	040005b7          	lui	a1,0x4000
    80001afa:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001afc:	05b2                	slli	a1,a1,0xc
    80001afe:	ed8ff0ef          	jal	800011d6 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b02:	4681                	li	a3,0
    80001b04:	4605                	li	a2,1
    80001b06:	020005b7          	lui	a1,0x2000
    80001b0a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b0c:	05b6                	slli	a1,a1,0xd
    80001b0e:	8526                	mv	a0,s1
    80001b10:	ec6ff0ef          	jal	800011d6 <uvmunmap>
  uvmfree(pagetable, sz);
    80001b14:	85ca                	mv	a1,s2
    80001b16:	8526                	mv	a0,s1
    80001b18:	88bff0ef          	jal	800013a2 <uvmfree>
}
    80001b1c:	60e2                	ld	ra,24(sp)
    80001b1e:	6442                	ld	s0,16(sp)
    80001b20:	64a2                	ld	s1,8(sp)
    80001b22:	6902                	ld	s2,0(sp)
    80001b24:	6105                	addi	sp,sp,32
    80001b26:	8082                	ret

0000000080001b28 <freeproc>:
{
    80001b28:	1101                	addi	sp,sp,-32
    80001b2a:	ec06                	sd	ra,24(sp)
    80001b2c:	e822                	sd	s0,16(sp)
    80001b2e:	e426                	sd	s1,8(sp)
    80001b30:	1000                	addi	s0,sp,32
    80001b32:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b34:	6d28                	ld	a0,88(a0)
    80001b36:	c119                	beqz	a0,80001b3c <freeproc+0x14>
    kfree((void *)p->trapframe);
    80001b38:	efffe0ef          	jal	80000a36 <kfree>
  p->trapframe = 0;
    80001b3c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001b40:	68a8                	ld	a0,80(s1)
    80001b42:	c501                	beqz	a0,80001b4a <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001b44:	64ac                	ld	a1,72(s1)
    80001b46:	f9dff0ef          	jal	80001ae2 <proc_freepagetable>
  p->pagetable = 0;
    80001b4a:	0404b823          	sd	zero,80(s1)
  p->sz        = 0;
    80001b4e:	0404b423          	sd	zero,72(s1)
  p->pid       = 0;
    80001b52:	0204a823          	sw	zero,48(s1)
  p->name[0]   = 0;
    80001b56:	14048c23          	sb	zero,344(s1)
  p->chan      = 0;
    80001b5a:	0204b023          	sd	zero,32(s1)
  p->killed    = 0;
    80001b5e:	0204a423          	sw	zero,40(s1)
  p->xstate    = 0;
    80001b62:	0204a623          	sw	zero,44(s1)
  p->state     = UNUSED;
    80001b66:	0004ac23          	sw	zero,24(s1)
}
    80001b6a:	60e2                	ld	ra,24(sp)
    80001b6c:	6442                	ld	s0,16(sp)
    80001b6e:	64a2                	ld	s1,8(sp)
    80001b70:	6105                	addi	sp,sp,32
    80001b72:	8082                	ret

0000000080001b74 <allocproc>:
{
    80001b74:	1101                	addi	sp,sp,-32
    80001b76:	ec06                	sd	ra,24(sp)
    80001b78:	e822                	sd	s0,16(sp)
    80001b7a:	e426                	sd	s1,8(sp)
    80001b7c:	e04a                	sd	s2,0(sp)
    80001b7e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++){
    80001b80:	00011497          	auipc	s1,0x11
    80001b84:	df048493          	addi	s1,s1,-528 # 80012970 <proc>
    80001b88:	00017917          	auipc	s2,0x17
    80001b8c:	de890913          	addi	s2,s2,-536 # 80018970 <tickslock>
    acquire(&p->lock);
    80001b90:	8526                	mv	a0,s1
    80001b92:	866ff0ef          	jal	80000bf8 <acquire>
    if(p->state == UNUSED){
    80001b96:	4c9c                	lw	a5,24(s1)
    80001b98:	cb91                	beqz	a5,80001bac <allocproc+0x38>
      release(&p->lock);
    80001b9a:	8526                	mv	a0,s1
    80001b9c:	8e0ff0ef          	jal	80000c7c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ba0:	18048493          	addi	s1,s1,384
    80001ba4:	ff2496e3          	bne	s1,s2,80001b90 <allocproc+0x1c>
  return 0;
    80001ba8:	4481                	li	s1,0
    80001baa:	a095                	j	80001c0e <allocproc+0x9a>
  p->pid   = allocpid();
    80001bac:	e77ff0ef          	jal	80001a22 <allocpid>
    80001bb0:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001bb2:	4785                	li	a5,1
    80001bb4:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001bb6:	f69fe0ef          	jal	80000b1e <kalloc>
    80001bba:	892a                	mv	s2,a0
    80001bbc:	eca8                	sd	a0,88(s1)
    80001bbe:	cd39                	beqz	a0,80001c1c <allocproc+0xa8>
  p->pagetable = proc_pagetable(p);
    80001bc0:	8526                	mv	a0,s1
    80001bc2:	e9fff0ef          	jal	80001a60 <proc_pagetable>
    80001bc6:	892a                	mv	s2,a0
    80001bc8:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001bca:	c12d                	beqz	a0,80001c2c <allocproc+0xb8>
  memset(&p->context, 0, sizeof(p->context));
    80001bcc:	07000613          	li	a2,112
    80001bd0:	4581                	li	a1,0
    80001bd2:	06048513          	addi	a0,s1,96
    80001bd6:	8deff0ef          	jal	80000cb4 <memset>
  p->context.ra = (uint64)forkret;
    80001bda:	00000797          	auipc	a5,0x0
    80001bde:	da278793          	addi	a5,a5,-606 # 8000197c <forkret>
    80001be2:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001be4:	60bc                	ld	a5,64(s1)
    80001be6:	6705                	lui	a4,0x1
    80001be8:	97ba                	add	a5,a5,a4
    80001bea:	f4bc                	sd	a5,104(s1)
  p->creation_time  = ticks;
    80001bec:	00009797          	auipc	a5,0x9
    80001bf0:	8247a783          	lw	a5,-2012(a5) # 8000a410 <ticks>
    80001bf4:	16f4a423          	sw	a5,360(s1)
  p->first_run_time = -1;
    80001bf8:	57fd                	li	a5,-1
    80001bfa:	16f4a623          	sw	a5,364(s1)
  p->end_time       = 0;
    80001bfe:	1604a823          	sw	zero,368(s1)
  p->cpu_ticks      = 0;
    80001c02:	1604aa23          	sw	zero,372(s1)
  p->queue      = 0;
    80001c06:	1604ac23          	sw	zero,376(s1)
  p->ticks_used = 0;
    80001c0a:	1604ae23          	sw	zero,380(s1)
}
    80001c0e:	8526                	mv	a0,s1
    80001c10:	60e2                	ld	ra,24(sp)
    80001c12:	6442                	ld	s0,16(sp)
    80001c14:	64a2                	ld	s1,8(sp)
    80001c16:	6902                	ld	s2,0(sp)
    80001c18:	6105                	addi	sp,sp,32
    80001c1a:	8082                	ret
    freeproc(p);
    80001c1c:	8526                	mv	a0,s1
    80001c1e:	f0bff0ef          	jal	80001b28 <freeproc>
    release(&p->lock);
    80001c22:	8526                	mv	a0,s1
    80001c24:	858ff0ef          	jal	80000c7c <release>
    return 0;
    80001c28:	84ca                	mv	s1,s2
    80001c2a:	b7d5                	j	80001c0e <allocproc+0x9a>
    freeproc(p);
    80001c2c:	8526                	mv	a0,s1
    80001c2e:	efbff0ef          	jal	80001b28 <freeproc>
    release(&p->lock);
    80001c32:	8526                	mv	a0,s1
    80001c34:	848ff0ef          	jal	80000c7c <release>
    return 0;
    80001c38:	84ca                	mv	s1,s2
    80001c3a:	bfd1                	j	80001c0e <allocproc+0x9a>

0000000080001c3c <userinit>:
{
    80001c3c:	1101                	addi	sp,sp,-32
    80001c3e:	ec06                	sd	ra,24(sp)
    80001c40:	e822                	sd	s0,16(sp)
    80001c42:	e426                	sd	s1,8(sp)
    80001c44:	1000                	addi	s0,sp,32
  p = allocproc();
    80001c46:	f2fff0ef          	jal	80001b74 <allocproc>
    80001c4a:	84aa                	mv	s1,a0
  initproc = p;
    80001c4c:	00008797          	auipc	a5,0x8
    80001c50:	7aa7be23          	sd	a0,1980(a5) # 8000a408 <initproc>
  p->cwd   = namei("/");
    80001c54:	00005517          	auipc	a0,0x5
    80001c58:	54c50513          	addi	a0,a0,1356 # 800071a0 <etext+0x1a0>
    80001c5c:	0b8020ef          	jal	80003d14 <namei>
    80001c60:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001c64:	478d                	li	a5,3
    80001c66:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001c68:	8526                	mv	a0,s1
    80001c6a:	812ff0ef          	jal	80000c7c <release>
}
    80001c6e:	60e2                	ld	ra,24(sp)
    80001c70:	6442                	ld	s0,16(sp)
    80001c72:	64a2                	ld	s1,8(sp)
    80001c74:	6105                	addi	sp,sp,32
    80001c76:	8082                	ret

0000000080001c78 <growproc>:
{
    80001c78:	1101                	addi	sp,sp,-32
    80001c7a:	ec06                	sd	ra,24(sp)
    80001c7c:	e822                	sd	s0,16(sp)
    80001c7e:	e426                	sd	s1,8(sp)
    80001c80:	e04a                	sd	s2,0(sp)
    80001c82:	1000                	addi	s0,sp,32
    80001c84:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c86:	c59ff0ef          	jal	800018de <myproc>
    80001c8a:	892a                	mv	s2,a0
  sz = p->sz;
    80001c8c:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001c8e:	02905b63          	blez	s1,80001cc4 <growproc+0x4c>
    if(sz + n > TRAPFRAME){
    80001c92:	00b48633          	add	a2,s1,a1
    80001c96:	020007b7          	lui	a5,0x2000
    80001c9a:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001c9c:	07b6                	slli	a5,a5,0xd
    80001c9e:	02c7e163          	bltu	a5,a2,80001cc0 <growproc+0x48>
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0){
    80001ca2:	4691                	li	a3,4
    80001ca4:	6928                	ld	a0,80(a0)
    80001ca6:	e00ff0ef          	jal	800012a6 <uvmalloc>
    80001caa:	85aa                	mv	a1,a0
    80001cac:	c911                	beqz	a0,80001cc0 <growproc+0x48>
  p->sz = sz;
    80001cae:	04b93423          	sd	a1,72(s2)
  return 0;
    80001cb2:	4501                	li	a0,0
}
    80001cb4:	60e2                	ld	ra,24(sp)
    80001cb6:	6442                	ld	s0,16(sp)
    80001cb8:	64a2                	ld	s1,8(sp)
    80001cba:	6902                	ld	s2,0(sp)
    80001cbc:	6105                	addi	sp,sp,32
    80001cbe:	8082                	ret
      return -1;
    80001cc0:	557d                	li	a0,-1
    80001cc2:	bfcd                	j	80001cb4 <growproc+0x3c>
  } else if(n < 0){
    80001cc4:	fe04d5e3          	bgez	s1,80001cae <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001cc8:	00b48633          	add	a2,s1,a1
    80001ccc:	6928                	ld	a0,80(a0)
    80001cce:	d92ff0ef          	jal	80001260 <uvmdealloc>
    80001cd2:	85aa                	mv	a1,a0
    80001cd4:	bfe9                	j	80001cae <growproc+0x36>

0000000080001cd6 <kfork>:
{
    80001cd6:	7139                	addi	sp,sp,-64
    80001cd8:	fc06                	sd	ra,56(sp)
    80001cda:	f822                	sd	s0,48(sp)
    80001cdc:	f426                	sd	s1,40(sp)
    80001cde:	e456                	sd	s5,8(sp)
    80001ce0:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001ce2:	bfdff0ef          	jal	800018de <myproc>
    80001ce6:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001ce8:	e8dff0ef          	jal	80001b74 <allocproc>
    80001cec:	c92d                	beqz	a0,80001d5e <kfork+0x88>
    80001cee:	e852                	sd	s4,16(sp)
    80001cf0:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001cf2:	048ab603          	ld	a2,72(s5)
    80001cf6:	692c                	ld	a1,80(a0)
    80001cf8:	050ab503          	ld	a0,80(s5)
    80001cfc:	ed8ff0ef          	jal	800013d4 <uvmcopy>
    80001d00:	04054863          	bltz	a0,80001d50 <kfork+0x7a>
    80001d04:	f04a                	sd	s2,32(sp)
    80001d06:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001d08:	048ab783          	ld	a5,72(s5)
    80001d0c:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001d10:	058ab683          	ld	a3,88(s5)
    80001d14:	87b6                	mv	a5,a3
    80001d16:	058a3703          	ld	a4,88(s4)
    80001d1a:	12068693          	addi	a3,a3,288
    80001d1e:	6388                	ld	a0,0(a5)
    80001d20:	678c                	ld	a1,8(a5)
    80001d22:	6b90                	ld	a2,16(a5)
    80001d24:	e308                	sd	a0,0(a4)
    80001d26:	e70c                	sd	a1,8(a4)
    80001d28:	eb10                	sd	a2,16(a4)
    80001d2a:	6f90                	ld	a2,24(a5)
    80001d2c:	ef10                	sd	a2,24(a4)
    80001d2e:	02078793          	addi	a5,a5,32
    80001d32:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001d36:	fed794e3          	bne	a5,a3,80001d1e <kfork+0x48>
  np->trapframe->a0 = 0;
    80001d3a:	058a3783          	ld	a5,88(s4)
    80001d3e:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001d42:	0d0a8493          	addi	s1,s5,208
    80001d46:	0d0a0913          	addi	s2,s4,208
    80001d4a:	150a8993          	addi	s3,s5,336
    80001d4e:	a831                	j	80001d6a <kfork+0x94>
    freeproc(np);
    80001d50:	8552                	mv	a0,s4
    80001d52:	dd7ff0ef          	jal	80001b28 <freeproc>
    release(&np->lock);
    80001d56:	8552                	mv	a0,s4
    80001d58:	f25fe0ef          	jal	80000c7c <release>
    return -1;
    80001d5c:	6a42                	ld	s4,16(sp)
    return -1;
    80001d5e:	54fd                	li	s1,-1
    80001d60:	a885                	j	80001dd0 <kfork+0xfa>
  for(i = 0; i < NOFILE; i++)
    80001d62:	04a1                	addi	s1,s1,8
    80001d64:	0921                	addi	s2,s2,8
    80001d66:	01348963          	beq	s1,s3,80001d78 <kfork+0xa2>
    if(p->ofile[i])
    80001d6a:	6088                	ld	a0,0(s1)
    80001d6c:	d97d                	beqz	a0,80001d62 <kfork+0x8c>
      np->ofile[i] = filedup(p->ofile[i]);
    80001d6e:	5f4020ef          	jal	80004362 <filedup>
    80001d72:	00a93023          	sd	a0,0(s2)
    80001d76:	b7f5                	j	80001d62 <kfork+0x8c>
  np->cwd = idup(p->cwd);
    80001d78:	150ab503          	ld	a0,336(s5)
    80001d7c:	6ce010ef          	jal	8000344a <idup>
    80001d80:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001d84:	4641                	li	a2,16
    80001d86:	158a8593          	addi	a1,s5,344
    80001d8a:	158a0513          	addi	a0,s4,344
    80001d8e:	870ff0ef          	jal	80000dfe <safestrcpy>
  pid = np->pid;
    80001d92:	030a2483          	lw	s1,48(s4)
  release(&np->lock);
    80001d96:	8552                	mv	a0,s4
    80001d98:	ee5fe0ef          	jal	80000c7c <release>
  acquire(&wait_lock);
    80001d9c:	00010517          	auipc	a0,0x10
    80001da0:	7ac50513          	addi	a0,a0,1964 # 80012548 <wait_lock>
    80001da4:	e55fe0ef          	jal	80000bf8 <acquire>
  np->parent = p;
    80001da8:	035a3c23          	sd	s5,56(s4)
  acquire(&np->lock);
    80001dac:	8552                	mv	a0,s4
    80001dae:	e4bfe0ef          	jal	80000bf8 <acquire>
  release(&wait_lock);
    80001db2:	00010517          	auipc	a0,0x10
    80001db6:	79650513          	addi	a0,a0,1942 # 80012548 <wait_lock>
    80001dba:	ec3fe0ef          	jal	80000c7c <release>
  np->state = RUNNABLE;
    80001dbe:	478d                	li	a5,3
    80001dc0:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001dc4:	8552                	mv	a0,s4
    80001dc6:	eb7fe0ef          	jal	80000c7c <release>
    80001dca:	7902                	ld	s2,32(sp)
    80001dcc:	69e2                	ld	s3,24(sp)
    80001dce:	6a42                	ld	s4,16(sp)
}
    80001dd0:	8526                	mv	a0,s1
    80001dd2:	70e2                	ld	ra,56(sp)
    80001dd4:	7442                	ld	s0,48(sp)
    80001dd6:	74a2                	ld	s1,40(sp)
    80001dd8:	6aa2                	ld	s5,8(sp)
    80001dda:	6121                	addi	sp,sp,64
    80001ddc:	8082                	ret

0000000080001dde <scheduler>:
{
    80001dde:	7175                	addi	sp,sp,-144
    80001de0:	e506                	sd	ra,136(sp)
    80001de2:	e122                	sd	s0,128(sp)
    80001de4:	fca6                	sd	s1,120(sp)
    80001de6:	f8ca                	sd	s2,112(sp)
    80001de8:	f4ce                	sd	s3,104(sp)
    80001dea:	f0d2                	sd	s4,96(sp)
    80001dec:	ecd6                	sd	s5,88(sp)
    80001dee:	e8da                	sd	s6,80(sp)
    80001df0:	e4de                	sd	s7,72(sp)
    80001df2:	e0e2                	sd	s8,64(sp)
    80001df4:	fc66                	sd	s9,56(sp)
    80001df6:	f86a                	sd	s10,48(sp)
    80001df8:	f46e                	sd	s11,40(sp)
    80001dfa:	0900                	addi	s0,sp,144
    80001dfc:	8792                	mv	a5,tp
  int id = r_tp();
    80001dfe:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001e00:	00779693          	slli	a3,a5,0x7
    80001e04:	00010717          	auipc	a4,0x10
    80001e08:	72c70713          	addi	a4,a4,1836 # 80012530 <pid_lock>
    80001e0c:	9736                	add	a4,a4,a3
    80001e0e:	04073023          	sd	zero,64(a4)
        swtch(&c->context, &chosen->context);
    80001e12:	00010717          	auipc	a4,0x10
    80001e16:	76670713          	addi	a4,a4,1894 # 80012578 <cpus+0x8>
    80001e1a:	9736                	add	a4,a4,a3
    80001e1c:	f8e43423          	sd	a4,-120(s0)
    uint last_boost_tick = 0;
    80001e20:	f6043c23          	sd	zero,-136(s0)
      uint cur = ticks;
    80001e24:	00008c97          	auipc	s9,0x8
    80001e28:	5ecc8c93          	addi	s9,s9,1516 # 8000a410 <ticks>
          p = &proc[idx];
    80001e2c:	00011a17          	auipc	s4,0x11
    80001e30:	b44a0a13          	addi	s4,s4,-1212 # 80012970 <proc>
            mlfq_last[q] = idx;
    80001e34:	00010d97          	auipc	s11,0x10
    80001e38:	6fcd8d93          	addi	s11,s11,1788 # 80012530 <pid_lock>
        c->proc       = chosen;
    80001e3c:	00dd87b3          	add	a5,s11,a3
    80001e40:	f8f43023          	sd	a5,-128(s0)
    80001e44:	a0ed                	j	80001f2e <scheduler+0x150>
  for(p = proc; p < &proc[NPROC]; p++){
    80001e46:	00011497          	auipc	s1,0x11
    80001e4a:	b2a48493          	addi	s1,s1,-1238 # 80012970 <proc>
      printk("MLFQLOG,%d,%d,0\n", ticks, p->pid);
    80001e4e:	00005a97          	auipc	s5,0x5
    80001e52:	35aa8a93          	addi	s5,s5,858 # 800071a8 <etext+0x1a8>
  for(p = proc; p < &proc[NPROC]; p++){
    80001e56:	00017917          	auipc	s2,0x17
    80001e5a:	b1a90913          	addi	s2,s2,-1254 # 80018970 <tickslock>
    80001e5e:	a801                	j	80001e6e <scheduler+0x90>
    release(&p->lock);
    80001e60:	8526                	mv	a0,s1
    80001e62:	e1bfe0ef          	jal	80000c7c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001e66:	18048493          	addi	s1,s1,384
    80001e6a:	03248863          	beq	s1,s2,80001e9a <scheduler+0xbc>
    acquire(&p->lock);
    80001e6e:	8526                	mv	a0,s1
    80001e70:	d89fe0ef          	jal	80000bf8 <acquire>
    if(p->state != UNUSED && p->state != ZOMBIE){
    80001e74:	4c9c                	lw	a5,24(s1)
    80001e76:	00f03733          	snez	a4,a5
    80001e7a:	17ed                	addi	a5,a5,-5
    80001e7c:	00f037b3          	snez	a5,a5
    80001e80:	8ff9                	and	a5,a5,a4
    80001e82:	dff9                	beqz	a5,80001e60 <scheduler+0x82>
      p->queue      = 0;
    80001e84:	1604ac23          	sw	zero,376(s1)
      p->ticks_used = 0;
    80001e88:	1604ae23          	sw	zero,380(s1)
      printk("MLFQLOG,%d,%d,0\n", ticks, p->pid);
    80001e8c:	5890                	lw	a2,48(s1)
    80001e8e:	000ca583          	lw	a1,0(s9)
    80001e92:	8556                	mv	a0,s5
    80001e94:	e7cfe0ef          	jal	80000510 <printk>
    80001e98:	b7e1                	j	80001e60 <scheduler+0x82>
  printk("MLFQBOOST,%d\n", ticks);
    80001e9a:	000ca583          	lw	a1,0(s9)
    80001e9e:	00005517          	auipc	a0,0x5
    80001ea2:	32250513          	addi	a0,a0,802 # 800071c0 <etext+0x1c0>
    80001ea6:	e6afe0ef          	jal	80000510 <printk>
        last_boost_tick = cur;
    80001eaa:	f7343c23          	sd	s3,-136(s0)
    80001eae:	a871                	j	80001f4a <scheduler+0x16c>
          release(&p->lock);
    80001eb0:	8526                	mv	a0,s1
    80001eb2:	dcbfe0ef          	jal	80000c7c <release>
        for(int i = 1; i <= NPROC; i++){
    80001eb6:	2985                	addiw	s3,s3,1
    80001eb8:	0b598163          	beq	s3,s5,80001f5a <scheduler+0x17c>
          int idx = (start + i) % NPROC;
    80001ebc:	41f9d79b          	sraiw	a5,s3,0x1f
    80001ec0:	01a7d79b          	srliw	a5,a5,0x1a
    80001ec4:	0137893b          	addw	s2,a5,s3
    80001ec8:	03f97913          	andi	s2,s2,63
    80001ecc:	40f9093b          	subw	s2,s2,a5
          p = &proc[idx];
    80001ed0:	00191493          	slli	s1,s2,0x1
    80001ed4:	94ca                	add	s1,s1,s2
    80001ed6:	049e                	slli	s1,s1,0x7
    80001ed8:	94d2                	add	s1,s1,s4
          acquire(&p->lock);
    80001eda:	8526                	mv	a0,s1
    80001edc:	d1dfe0ef          	jal	80000bf8 <acquire>
          if(p->state == RUNNABLE && p->queue == q){
    80001ee0:	4c9c                	lw	a5,24(s1)
    80001ee2:	fd6797e3          	bne	a5,s6,80001eb0 <scheduler+0xd2>
    80001ee6:	1784a783          	lw	a5,376(s1)
    80001eea:	fd7793e3          	bne	a5,s7,80001eb0 <scheduler+0xd2>
            mlfq_last[q] = idx;
    80001eee:	0b8a                	slli	s7,s7,0x2
    80001ef0:	9bee                	add	s7,s7,s11
    80001ef2:	032ba823          	sw	s2,48(s7) # fffffffffffff030 <end+0xffffffff7ffdb2e0>
        if(chosen->first_run_time == -1)
    80001ef6:	16c4a703          	lw	a4,364(s1)
    80001efa:	57fd                	li	a5,-1
    80001efc:	06f70a63          	beq	a4,a5,80001f70 <scheduler+0x192>
        chosen->state = RUNNING;
    80001f00:	4791                	li	a5,4
    80001f02:	cc9c                	sw	a5,24(s1)
        c->proc       = chosen;
    80001f04:	f8043903          	ld	s2,-128(s0)
    80001f08:	04993023          	sd	s1,64(s2)
        swtch(&c->context, &chosen->context);
    80001f0c:	06048593          	addi	a1,s1,96
    80001f10:	f8843503          	ld	a0,-120(s0)
    80001f14:	666000ef          	jal	8000257a <swtch>
    80001f18:	8792                	mv	a5,tp
        mycpu()->intena = 0;
    80001f1a:	2781                	sext.w	a5,a5
    80001f1c:	079e                	slli	a5,a5,0x7
    80001f1e:	97ee                	add	a5,a5,s11
    80001f20:	0a07ae23          	sw	zero,188(a5)
        c->proc = 0;
    80001f24:	04093023          	sd	zero,64(s2)
        release(&chosen->lock);
    80001f28:	8526                	mv	a0,s1
    80001f2a:	d53fe0ef          	jal	80000c7c <release>
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80001f2e:	10016073          	csrsi	sstatus,2
      uint cur = ticks;
    80001f32:	000ca983          	lw	s3,0(s9)
      if(cur != 0 && cur - last_boost_tick >= BOOST_TICKS){
    80001f36:	00098a63          	beqz	s3,80001f4a <scheduler+0x16c>
    80001f3a:	f7843783          	ld	a5,-136(s0)
    80001f3e:	40f987bb          	subw	a5,s3,a5
    80001f42:	02f00713          	li	a4,47
    80001f46:	f0f760e3          	bltu	a4,a5,80001e46 <scheduler+0x68>
      for(int q = 0; q < NMLFQ && chosen == 0; q++){
    80001f4a:	00010c17          	auipc	s8,0x10
    80001f4e:	616c0c13          	addi	s8,s8,1558 # 80012560 <mlfq_last>
    80001f52:	4b81                	li	s7,0
          if(p->state == RUNNABLE && p->queue == q){
    80001f54:	4b0d                	li	s6,3
      for(int q = 0; q < NMLFQ && chosen == 0; q++){
    80001f56:	4d11                	li	s10,4
    80001f58:	a029                	j	80001f62 <scheduler+0x184>
    80001f5a:	2b85                	addiw	s7,s7,1
    80001f5c:	0c11                	addi	s8,s8,4
    80001f5e:	01ab8e63          	beq	s7,s10,80001f7a <scheduler+0x19c>
        for(int i = 1; i <= NPROC; i++){
    80001f62:	000c2a83          	lw	s5,0(s8)
    80001f66:	001a899b          	addiw	s3,s5,1
    80001f6a:	041a8a9b          	addiw	s5,s5,65
    80001f6e:	b7b9                	j	80001ebc <scheduler+0xde>
          chosen->first_run_time = ticks;
    80001f70:	000ca783          	lw	a5,0(s9)
    80001f74:	16f4a623          	sw	a5,364(s1)
    80001f78:	b761                	j	80001f00 <scheduler+0x122>
        asm volatile("wfi");
    80001f7a:	10500073          	wfi
    80001f7e:	bf45                	j	80001f2e <scheduler+0x150>

0000000080001f80 <sched>:
{
    80001f80:	7179                	addi	sp,sp,-48
    80001f82:	f406                	sd	ra,40(sp)
    80001f84:	f022                	sd	s0,32(sp)
    80001f86:	ec26                	sd	s1,24(sp)
    80001f88:	e84a                	sd	s2,16(sp)
    80001f8a:	e44e                	sd	s3,8(sp)
    80001f8c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001f8e:	951ff0ef          	jal	800018de <myproc>
    80001f92:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001f94:	bfffe0ef          	jal	80000b92 <holding>
    80001f98:	c92d                	beqz	a0,8000200a <sched+0x8a>
  asm volatile("mv %0, tp" : "=r"(x));
    80001f9a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001f9c:	2781                	sext.w	a5,a5
    80001f9e:	079e                	slli	a5,a5,0x7
    80001fa0:	00010717          	auipc	a4,0x10
    80001fa4:	59070713          	addi	a4,a4,1424 # 80012530 <pid_lock>
    80001fa8:	97ba                	add	a5,a5,a4
    80001faa:	0b87a703          	lw	a4,184(a5)
    80001fae:	4785                	li	a5,1
    80001fb0:	06f71363          	bne	a4,a5,80002016 <sched+0x96>
  if(p->state == RUNNING)
    80001fb4:	4c98                	lw	a4,24(s1)
    80001fb6:	4791                	li	a5,4
    80001fb8:	06f70563          	beq	a4,a5,80002022 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001fbc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001fc0:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001fc2:	e7b5                	bnez	a5,8000202e <sched+0xae>
  asm volatile("mv %0, tp" : "=r"(x));
    80001fc4:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001fc6:	00010917          	auipc	s2,0x10
    80001fca:	56a90913          	addi	s2,s2,1386 # 80012530 <pid_lock>
    80001fce:	2781                	sext.w	a5,a5
    80001fd0:	079e                	slli	a5,a5,0x7
    80001fd2:	97ca                	add	a5,a5,s2
    80001fd4:	0bc7a983          	lw	s3,188(a5)
    80001fd8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001fda:	2781                	sext.w	a5,a5
    80001fdc:	079e                	slli	a5,a5,0x7
    80001fde:	00010597          	auipc	a1,0x10
    80001fe2:	59a58593          	addi	a1,a1,1434 # 80012578 <cpus+0x8>
    80001fe6:	95be                	add	a1,a1,a5
    80001fe8:	06048513          	addi	a0,s1,96
    80001fec:	58e000ef          	jal	8000257a <swtch>
    80001ff0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001ff2:	2781                	sext.w	a5,a5
    80001ff4:	079e                	slli	a5,a5,0x7
    80001ff6:	993e                	add	s2,s2,a5
    80001ff8:	0b392e23          	sw	s3,188(s2)
}
    80001ffc:	70a2                	ld	ra,40(sp)
    80001ffe:	7402                	ld	s0,32(sp)
    80002000:	64e2                	ld	s1,24(sp)
    80002002:	6942                	ld	s2,16(sp)
    80002004:	69a2                	ld	s3,8(sp)
    80002006:	6145                	addi	sp,sp,48
    80002008:	8082                	ret
    panic("sched p->lock");
    8000200a:	00005517          	auipc	a0,0x5
    8000200e:	1c650513          	addi	a0,a0,454 # 800071d0 <etext+0x1d0>
    80002012:	837fe0ef          	jal	80000848 <panic>
    panic("sched locks");
    80002016:	00005517          	auipc	a0,0x5
    8000201a:	1ca50513          	addi	a0,a0,458 # 800071e0 <etext+0x1e0>
    8000201e:	82bfe0ef          	jal	80000848 <panic>
    panic("sched RUNNING");
    80002022:	00005517          	auipc	a0,0x5
    80002026:	1ce50513          	addi	a0,a0,462 # 800071f0 <etext+0x1f0>
    8000202a:	81ffe0ef          	jal	80000848 <panic>
    panic("sched interruptible");
    8000202e:	00005517          	auipc	a0,0x5
    80002032:	1d250513          	addi	a0,a0,466 # 80007200 <etext+0x200>
    80002036:	813fe0ef          	jal	80000848 <panic>

000000008000203a <yield>:
{
    8000203a:	1101                	addi	sp,sp,-32
    8000203c:	ec06                	sd	ra,24(sp)
    8000203e:	e822                	sd	s0,16(sp)
    80002040:	e426                	sd	s1,8(sp)
    80002042:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002044:	89bff0ef          	jal	800018de <myproc>
    80002048:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000204a:	baffe0ef          	jal	80000bf8 <acquire>
  p->state = RUNNABLE;
    8000204e:	478d                	li	a5,3
    80002050:	cc9c                	sw	a5,24(s1)
  sched();
    80002052:	f2fff0ef          	jal	80001f80 <sched>
  release(&p->lock);
    80002056:	8526                	mv	a0,s1
    80002058:	c25fe0ef          	jal	80000c7c <release>
}
    8000205c:	60e2                	ld	ra,24(sp)
    8000205e:	6442                	ld	s0,16(sp)
    80002060:	64a2                	ld	s1,8(sp)
    80002062:	6105                	addi	sp,sp,32
    80002064:	8082                	ret

0000000080002066 <sleep_prepare>:

void
sleep_prepare(void *chan)
{
    80002066:	1101                	addi	sp,sp,-32
    80002068:	ec06                	sd	ra,24(sp)
    8000206a:	e822                	sd	s0,16(sp)
    8000206c:	e426                	sd	s1,8(sp)
    8000206e:	e04a                	sd	s2,0(sp)
    80002070:	1000                	addi	s0,sp,32
    80002072:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002074:	86bff0ef          	jal	800018de <myproc>
    80002078:	892a                	mv	s2,a0

  acquire(&p->lock);
    8000207a:	b7ffe0ef          	jal	80000bf8 <acquire>
  if(chan == 0)
    8000207e:	cc81                	beqz	s1,80002096 <sleep_prepare+0x30>
    panic("sleep_prepare: zero chan");
  p->chan = chan;
    80002080:	02993023          	sd	s1,32(s2)
  release(&p->lock);
    80002084:	854a                	mv	a0,s2
    80002086:	bf7fe0ef          	jal	80000c7c <release>
}
    8000208a:	60e2                	ld	ra,24(sp)
    8000208c:	6442                	ld	s0,16(sp)
    8000208e:	64a2                	ld	s1,8(sp)
    80002090:	6902                	ld	s2,0(sp)
    80002092:	6105                	addi	sp,sp,32
    80002094:	8082                	ret
    panic("sleep_prepare: zero chan");
    80002096:	00005517          	auipc	a0,0x5
    8000209a:	18250513          	addi	a0,a0,386 # 80007218 <etext+0x218>
    8000209e:	faafe0ef          	jal	80000848 <panic>

00000000800020a2 <sleep>:

void
sleep(void)
{
    800020a2:	1101                	addi	sp,sp,-32
    800020a4:	ec06                	sd	ra,24(sp)
    800020a6:	e822                	sd	s0,16(sp)
    800020a8:	e426                	sd	s1,8(sp)
    800020aa:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800020ac:	833ff0ef          	jal	800018de <myproc>
    800020b0:	84aa                	mv	s1,a0

  acquire(&p->lock);
    800020b2:	b47fe0ef          	jal	80000bf8 <acquire>
  if(p->chan != 0){
    800020b6:	709c                	ld	a5,32(s1)
    800020b8:	c799                	beqz	a5,800020c6 <sleep+0x24>
#ifdef MLFQ
    p->ticks_used = 0;
    800020ba:	1604ae23          	sw	zero,380(s1)
#endif
    p->state = SLEEPING;
    800020be:	4789                	li	a5,2
    800020c0:	cc9c                	sw	a5,24(s1)
    sched();
    800020c2:	ebfff0ef          	jal	80001f80 <sched>
  }
  release(&p->lock);
    800020c6:	8526                	mv	a0,s1
    800020c8:	bb5fe0ef          	jal	80000c7c <release>
}
    800020cc:	60e2                	ld	ra,24(sp)
    800020ce:	6442                	ld	s0,16(sp)
    800020d0:	64a2                	ld	s1,8(sp)
    800020d2:	6105                	addi	sp,sp,32
    800020d4:	8082                	ret

00000000800020d6 <wakeup>:

void
wakeup(void *chan)
{
    800020d6:	7139                	addi	sp,sp,-64
    800020d8:	fc06                	sd	ra,56(sp)
    800020da:	f822                	sd	s0,48(sp)
    800020dc:	f426                	sd	s1,40(sp)
    800020de:	f04a                	sd	s2,32(sp)
    800020e0:	ec4e                	sd	s3,24(sp)
    800020e2:	e852                	sd	s4,16(sp)
    800020e4:	e456                	sd	s5,8(sp)
    800020e6:	0080                	addi	s0,sp,64
    800020e8:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800020ea:	00011497          	auipc	s1,0x11
    800020ee:	88648493          	addi	s1,s1,-1914 # 80012970 <proc>
    acquire(&p->lock);
    if(p->chan == chan){
      p->chan = 0;
      if(p->state == SLEEPING){
    800020f2:	4a09                	li	s4,2
        p->state = RUNNABLE;
    800020f4:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++){
    800020f6:	00017997          	auipc	s3,0x17
    800020fa:	87a98993          	addi	s3,s3,-1926 # 80018970 <tickslock>
    800020fe:	a801                	j	8000210e <wakeup+0x38>
      }
    }
    release(&p->lock);
    80002100:	8526                	mv	a0,s1
    80002102:	b7bfe0ef          	jal	80000c7c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002106:	18048493          	addi	s1,s1,384
    8000210a:	03348063          	beq	s1,s3,8000212a <wakeup+0x54>
    acquire(&p->lock);
    8000210e:	8526                	mv	a0,s1
    80002110:	ae9fe0ef          	jal	80000bf8 <acquire>
    if(p->chan == chan){
    80002114:	709c                	ld	a5,32(s1)
    80002116:	ff2795e3          	bne	a5,s2,80002100 <wakeup+0x2a>
      p->chan = 0;
    8000211a:	0204b023          	sd	zero,32(s1)
      if(p->state == SLEEPING){
    8000211e:	4c9c                	lw	a5,24(s1)
    80002120:	ff4790e3          	bne	a5,s4,80002100 <wakeup+0x2a>
        p->state = RUNNABLE;
    80002124:	0154ac23          	sw	s5,24(s1)
    80002128:	bfe1                	j	80002100 <wakeup+0x2a>
  }
}
    8000212a:	70e2                	ld	ra,56(sp)
    8000212c:	7442                	ld	s0,48(sp)
    8000212e:	74a2                	ld	s1,40(sp)
    80002130:	7902                	ld	s2,32(sp)
    80002132:	69e2                	ld	s3,24(sp)
    80002134:	6a42                	ld	s4,16(sp)
    80002136:	6aa2                	ld	s5,8(sp)
    80002138:	6121                	addi	sp,sp,64
    8000213a:	8082                	ret

000000008000213c <reparent>:
{
    8000213c:	7179                	addi	sp,sp,-48
    8000213e:	f406                	sd	ra,40(sp)
    80002140:	f022                	sd	s0,32(sp)
    80002142:	ec26                	sd	s1,24(sp)
    80002144:	e84a                	sd	s2,16(sp)
    80002146:	e44e                	sd	s3,8(sp)
    80002148:	e052                	sd	s4,0(sp)
    8000214a:	1800                	addi	s0,sp,48
    8000214c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000214e:	00011497          	auipc	s1,0x11
    80002152:	82248493          	addi	s1,s1,-2014 # 80012970 <proc>
      pp->parent = initproc;
    80002156:	00008a17          	auipc	s4,0x8
    8000215a:	2b2a0a13          	addi	s4,s4,690 # 8000a408 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000215e:	00017997          	auipc	s3,0x17
    80002162:	81298993          	addi	s3,s3,-2030 # 80018970 <tickslock>
    80002166:	a029                	j	80002170 <reparent+0x34>
    80002168:	18048493          	addi	s1,s1,384
    8000216c:	01348b63          	beq	s1,s3,80002182 <reparent+0x46>
    if(pp->parent == p){
    80002170:	7c9c                	ld	a5,56(s1)
    80002172:	ff279be3          	bne	a5,s2,80002168 <reparent+0x2c>
      pp->parent = initproc;
    80002176:	000a3503          	ld	a0,0(s4)
    8000217a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000217c:	f5bff0ef          	jal	800020d6 <wakeup>
    80002180:	b7e5                	j	80002168 <reparent+0x2c>
}
    80002182:	70a2                	ld	ra,40(sp)
    80002184:	7402                	ld	s0,32(sp)
    80002186:	64e2                	ld	s1,24(sp)
    80002188:	6942                	ld	s2,16(sp)
    8000218a:	69a2                	ld	s3,8(sp)
    8000218c:	6a02                	ld	s4,0(sp)
    8000218e:	6145                	addi	sp,sp,48
    80002190:	8082                	ret

0000000080002192 <kexit>:
{
    80002192:	7179                	addi	sp,sp,-48
    80002194:	f406                	sd	ra,40(sp)
    80002196:	f022                	sd	s0,32(sp)
    80002198:	ec26                	sd	s1,24(sp)
    8000219a:	e84a                	sd	s2,16(sp)
    8000219c:	e44e                	sd	s3,8(sp)
    8000219e:	e052                	sd	s4,0(sp)
    800021a0:	1800                	addi	s0,sp,48
    800021a2:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800021a4:	f3aff0ef          	jal	800018de <myproc>
    800021a8:	892a                	mv	s2,a0
  if(p == initproc)
    800021aa:	00008797          	auipc	a5,0x8
    800021ae:	25e7b783          	ld	a5,606(a5) # 8000a408 <initproc>
    800021b2:	0d050493          	addi	s1,a0,208
    800021b6:	15050993          	addi	s3,a0,336
    800021ba:	00a79b63          	bne	a5,a0,800021d0 <kexit+0x3e>
    panic("init exiting");
    800021be:	00005517          	auipc	a0,0x5
    800021c2:	07a50513          	addi	a0,a0,122 # 80007238 <etext+0x238>
    800021c6:	e82fe0ef          	jal	80000848 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800021ca:	04a1                	addi	s1,s1,8
    800021cc:	01348963          	beq	s1,s3,800021de <kexit+0x4c>
    if(p->ofile[fd]){
    800021d0:	6088                	ld	a0,0(s1)
    800021d2:	dd65                	beqz	a0,800021ca <kexit+0x38>
      fileclose(f);
    800021d4:	1d4020ef          	jal	800043a8 <fileclose>
      p->ofile[fd] = 0;
    800021d8:	0004b023          	sd	zero,0(s1)
    800021dc:	b7fd                	j	800021ca <kexit+0x38>
  begin_op();
    800021de:	515010ef          	jal	80003ef2 <begin_op>
  iput(p->cwd);
    800021e2:	15093503          	ld	a0,336(s2)
    800021e6:	41c010ef          	jal	80003602 <iput>
  end_op();
    800021ea:	595010ef          	jal	80003f7e <end_op>
  p->cwd = 0;
    800021ee:	14093823          	sd	zero,336(s2)
  acquire(&wait_lock);
    800021f2:	00010517          	auipc	a0,0x10
    800021f6:	35650513          	addi	a0,a0,854 # 80012548 <wait_lock>
    800021fa:	9fffe0ef          	jal	80000bf8 <acquire>
  reparent(p);
    800021fe:	854a                	mv	a0,s2
    80002200:	f3dff0ef          	jal	8000213c <reparent>
  wakeup(p->parent);
    80002204:	03893503          	ld	a0,56(s2)
    80002208:	ecfff0ef          	jal	800020d6 <wakeup>
  acquire(&p->lock);
    8000220c:	854a                	mv	a0,s2
    8000220e:	9ebfe0ef          	jal	80000bf8 <acquire>
  p->xstate   = status;
    80002212:	03492623          	sw	s4,44(s2)
  p->end_time = ticks;
    80002216:	00008797          	auipc	a5,0x8
    8000221a:	1fa7a783          	lw	a5,506(a5) # 8000a410 <ticks>
    8000221e:	16f92823          	sw	a5,368(s2)
  printk("PROCSTATS,%d,%s,%d,%d,%d,%d\n",
    80002222:	17492803          	lw	a6,372(s2)
    80002226:	16c92703          	lw	a4,364(s2)
    8000222a:	16892683          	lw	a3,360(s2)
    8000222e:	15890613          	addi	a2,s2,344
    80002232:	03092583          	lw	a1,48(s2)
    80002236:	00005517          	auipc	a0,0x5
    8000223a:	01250513          	addi	a0,a0,18 # 80007248 <etext+0x248>
    8000223e:	ad2fe0ef          	jal	80000510 <printk>
  p->state = ZOMBIE;
    80002242:	4795                	li	a5,5
    80002244:	00f92c23          	sw	a5,24(s2)
  release(&wait_lock);
    80002248:	00010517          	auipc	a0,0x10
    8000224c:	30050513          	addi	a0,a0,768 # 80012548 <wait_lock>
    80002250:	a2dfe0ef          	jal	80000c7c <release>
  sched();
    80002254:	d2dff0ef          	jal	80001f80 <sched>
  panic("zombie exit");
    80002258:	00005517          	auipc	a0,0x5
    8000225c:	01050513          	addi	a0,a0,16 # 80007268 <etext+0x268>
    80002260:	de8fe0ef          	jal	80000848 <panic>

0000000080002264 <kkill>:

int
kkill(int pid)
{
    80002264:	7179                	addi	sp,sp,-48
    80002266:	f406                	sd	ra,40(sp)
    80002268:	f022                	sd	s0,32(sp)
    8000226a:	ec26                	sd	s1,24(sp)
    8000226c:	e84a                	sd	s2,16(sp)
    8000226e:	e44e                	sd	s3,8(sp)
    80002270:	1800                	addi	s0,sp,48
    80002272:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002274:	00010497          	auipc	s1,0x10
    80002278:	6fc48493          	addi	s1,s1,1788 # 80012970 <proc>
    8000227c:	00016997          	auipc	s3,0x16
    80002280:	6f498993          	addi	s3,s3,1780 # 80018970 <tickslock>
    acquire(&p->lock);
    80002284:	8526                	mv	a0,s1
    80002286:	973fe0ef          	jal	80000bf8 <acquire>
    if(p->pid == pid){
    8000228a:	589c                	lw	a5,48(s1)
    8000228c:	01278b63          	beq	a5,s2,800022a2 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002290:	8526                	mv	a0,s1
    80002292:	9ebfe0ef          	jal	80000c7c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002296:	18048493          	addi	s1,s1,384
    8000229a:	ff3495e3          	bne	s1,s3,80002284 <kkill+0x20>
  }
  return -1;
    8000229e:	557d                	li	a0,-1
    800022a0:	a819                	j	800022b6 <kkill+0x52>
      p->killed = 1;
    800022a2:	4785                	li	a5,1
    800022a4:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800022a6:	4c98                	lw	a4,24(s1)
    800022a8:	4789                	li	a5,2
    800022aa:	00f70d63          	beq	a4,a5,800022c4 <kkill+0x60>
      release(&p->lock);
    800022ae:	8526                	mv	a0,s1
    800022b0:	9cdfe0ef          	jal	80000c7c <release>
      return 0;
    800022b4:	4501                	li	a0,0
}
    800022b6:	70a2                	ld	ra,40(sp)
    800022b8:	7402                	ld	s0,32(sp)
    800022ba:	64e2                	ld	s1,24(sp)
    800022bc:	6942                	ld	s2,16(sp)
    800022be:	69a2                	ld	s3,8(sp)
    800022c0:	6145                	addi	sp,sp,48
    800022c2:	8082                	ret
        p->state = RUNNABLE;
    800022c4:	478d                	li	a5,3
    800022c6:	cc9c                	sw	a5,24(s1)
    800022c8:	b7dd                	j	800022ae <kkill+0x4a>

00000000800022ca <setkilled>:

void
setkilled(struct proc *p)
{
    800022ca:	1101                	addi	sp,sp,-32
    800022cc:	ec06                	sd	ra,24(sp)
    800022ce:	e822                	sd	s0,16(sp)
    800022d0:	e426                	sd	s1,8(sp)
    800022d2:	1000                	addi	s0,sp,32
    800022d4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800022d6:	923fe0ef          	jal	80000bf8 <acquire>
  p->killed = 1;
    800022da:	4785                	li	a5,1
    800022dc:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800022de:	8526                	mv	a0,s1
    800022e0:	99dfe0ef          	jal	80000c7c <release>
}
    800022e4:	60e2                	ld	ra,24(sp)
    800022e6:	6442                	ld	s0,16(sp)
    800022e8:	64a2                	ld	s1,8(sp)
    800022ea:	6105                	addi	sp,sp,32
    800022ec:	8082                	ret

00000000800022ee <killed>:

int
killed(struct proc *p)
{
    800022ee:	1101                	addi	sp,sp,-32
    800022f0:	ec06                	sd	ra,24(sp)
    800022f2:	e822                	sd	s0,16(sp)
    800022f4:	e426                	sd	s1,8(sp)
    800022f6:	e04a                	sd	s2,0(sp)
    800022f8:	1000                	addi	s0,sp,32
    800022fa:	84aa                	mv	s1,a0
  int k;
  acquire(&p->lock);
    800022fc:	8fdfe0ef          	jal	80000bf8 <acquire>
  k = p->killed;
    80002300:	549c                	lw	a5,40(s1)
    80002302:	893e                	mv	s2,a5
  release(&p->lock);
    80002304:	8526                	mv	a0,s1
    80002306:	977fe0ef          	jal	80000c7c <release>
  return k;
}
    8000230a:	854a                	mv	a0,s2
    8000230c:	60e2                	ld	ra,24(sp)
    8000230e:	6442                	ld	s0,16(sp)
    80002310:	64a2                	ld	s1,8(sp)
    80002312:	6902                	ld	s2,0(sp)
    80002314:	6105                	addi	sp,sp,32
    80002316:	8082                	ret

0000000080002318 <kwait>:
{
    80002318:	715d                	addi	sp,sp,-80
    8000231a:	e486                	sd	ra,72(sp)
    8000231c:	e0a2                	sd	s0,64(sp)
    8000231e:	fc26                	sd	s1,56(sp)
    80002320:	f84a                	sd	s2,48(sp)
    80002322:	f44e                	sd	s3,40(sp)
    80002324:	f052                	sd	s4,32(sp)
    80002326:	ec56                	sd	s5,24(sp)
    80002328:	e85a                	sd	s6,16(sp)
    8000232a:	e45e                	sd	s7,8(sp)
    8000232c:	0880                	addi	s0,sp,80
    8000232e:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80002330:	daeff0ef          	jal	800018de <myproc>
    80002334:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002336:	00010517          	auipc	a0,0x10
    8000233a:	21250513          	addi	a0,a0,530 # 80012548 <wait_lock>
    8000233e:	8bbfe0ef          	jal	80000bf8 <acquire>
        if(pp->state == ZOMBIE){
    80002342:	4a15                	li	s4,5
        havekids = 1;
    80002344:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002346:	00016997          	auipc	s3,0x16
    8000234a:	62a98993          	addi	s3,s3,1578 # 80018970 <tickslock>
    release(&wait_lock);
    8000234e:	00010b17          	auipc	s6,0x10
    80002352:	1fab0b13          	addi	s6,s6,506 # 80012548 <wait_lock>
    80002356:	a07d                	j	80002404 <kwait+0xec>
          pid = pp->pid;
    80002358:	0304a983          	lw	s3,48(s1)
          if(addr != 0 &&
    8000235c:	000b8e63          	beqz	s7,80002378 <kwait+0x60>
             copyout(p->pagetable, p->sz, addr, (char *)&pp->xstate,
    80002360:	4711                	li	a4,4
    80002362:	02c48693          	addi	a3,s1,44
    80002366:	865e                	mv	a2,s7
    80002368:	04893583          	ld	a1,72(s2)
    8000236c:	05093503          	ld	a0,80(s2)
    80002370:	9bcff0ef          	jal	8000152c <copyout>
          if(addr != 0 &&
    80002374:	02054c63          	bltz	a0,800023ac <kwait+0x94>
          pp->parent = 0;
    80002378:	0204bc23          	sd	zero,56(s1)
          freeproc(pp);
    8000237c:	8526                	mv	a0,s1
    8000237e:	faaff0ef          	jal	80001b28 <freeproc>
          release(&pp->lock);
    80002382:	8526                	mv	a0,s1
    80002384:	8f9fe0ef          	jal	80000c7c <release>
          release(&wait_lock);
    80002388:	00010517          	auipc	a0,0x10
    8000238c:	1c050513          	addi	a0,a0,448 # 80012548 <wait_lock>
    80002390:	8edfe0ef          	jal	80000c7c <release>
}
    80002394:	854e                	mv	a0,s3
    80002396:	60a6                	ld	ra,72(sp)
    80002398:	6406                	ld	s0,64(sp)
    8000239a:	74e2                	ld	s1,56(sp)
    8000239c:	7942                	ld	s2,48(sp)
    8000239e:	79a2                	ld	s3,40(sp)
    800023a0:	7a02                	ld	s4,32(sp)
    800023a2:	6ae2                	ld	s5,24(sp)
    800023a4:	6b42                	ld	s6,16(sp)
    800023a6:	6ba2                	ld	s7,8(sp)
    800023a8:	6161                	addi	sp,sp,80
    800023aa:	8082                	ret
            release(&pp->lock);
    800023ac:	8526                	mv	a0,s1
    800023ae:	8cffe0ef          	jal	80000c7c <release>
            release(&wait_lock);
    800023b2:	00010517          	auipc	a0,0x10
    800023b6:	19650513          	addi	a0,a0,406 # 80012548 <wait_lock>
    800023ba:	8c3fe0ef          	jal	80000c7c <release>
            return -1;
    800023be:	a8b9                	j	8000241c <kwait+0x104>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800023c0:	18048493          	addi	s1,s1,384
    800023c4:	03348063          	beq	s1,s3,800023e4 <kwait+0xcc>
      if(pp->parent == p){
    800023c8:	7c9c                	ld	a5,56(s1)
    800023ca:	ff279be3          	bne	a5,s2,800023c0 <kwait+0xa8>
        acquire(&pp->lock);
    800023ce:	8526                	mv	a0,s1
    800023d0:	829fe0ef          	jal	80000bf8 <acquire>
        if(pp->state == ZOMBIE){
    800023d4:	4c9c                	lw	a5,24(s1)
    800023d6:	f94781e3          	beq	a5,s4,80002358 <kwait+0x40>
        release(&pp->lock);
    800023da:	8526                	mv	a0,s1
    800023dc:	8a1fe0ef          	jal	80000c7c <release>
        havekids = 1;
    800023e0:	8756                	mv	a4,s5
    800023e2:	bff9                	j	800023c0 <kwait+0xa8>
    if(!havekids || killed(p)){
    800023e4:	c715                	beqz	a4,80002410 <kwait+0xf8>
    800023e6:	854a                	mv	a0,s2
    800023e8:	f07ff0ef          	jal	800022ee <killed>
    800023ec:	e115                	bnez	a0,80002410 <kwait+0xf8>
    sleep_prepare(p);
    800023ee:	854a                	mv	a0,s2
    800023f0:	c77ff0ef          	jal	80002066 <sleep_prepare>
    release(&wait_lock);
    800023f4:	855a                	mv	a0,s6
    800023f6:	887fe0ef          	jal	80000c7c <release>
    sleep();
    800023fa:	ca9ff0ef          	jal	800020a2 <sleep>
    acquire(&wait_lock);
    800023fe:	855a                	mv	a0,s6
    80002400:	ff8fe0ef          	jal	80000bf8 <acquire>
    havekids = 0;
    80002404:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002406:	00010497          	auipc	s1,0x10
    8000240a:	56a48493          	addi	s1,s1,1386 # 80012970 <proc>
    8000240e:	bf6d                	j	800023c8 <kwait+0xb0>
      release(&wait_lock);
    80002410:	00010517          	auipc	a0,0x10
    80002414:	13850513          	addi	a0,a0,312 # 80012548 <wait_lock>
    80002418:	865fe0ef          	jal	80000c7c <release>
            return -1;
    8000241c:	59fd                	li	s3,-1
    8000241e:	bf9d                	j	80002394 <kwait+0x7c>

0000000080002420 <either_copyout>:

int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002420:	7179                	addi	sp,sp,-48
    80002422:	f406                	sd	ra,40(sp)
    80002424:	f022                	sd	s0,32(sp)
    80002426:	ec26                	sd	s1,24(sp)
    80002428:	e84a                	sd	s2,16(sp)
    8000242a:	e44e                	sd	s3,8(sp)
    8000242c:	e052                	sd	s4,0(sp)
    8000242e:	1800                	addi	s0,sp,48
    80002430:	84aa                	mv	s1,a0
    80002432:	8a2e                	mv	s4,a1
    80002434:	89b2                	mv	s3,a2
    80002436:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002438:	ca6ff0ef          	jal	800018de <myproc>
  if(user_dst){
    8000243c:	c085                	beqz	s1,8000245c <either_copyout+0x3c>
    return copyout(p->pagetable, p->sz, dst, src, len);
    8000243e:	874a                	mv	a4,s2
    80002440:	86ce                	mv	a3,s3
    80002442:	8652                	mv	a2,s4
    80002444:	652c                	ld	a1,72(a0)
    80002446:	6928                	ld	a0,80(a0)
    80002448:	8e4ff0ef          	jal	8000152c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000244c:	70a2                	ld	ra,40(sp)
    8000244e:	7402                	ld	s0,32(sp)
    80002450:	64e2                	ld	s1,24(sp)
    80002452:	6942                	ld	s2,16(sp)
    80002454:	69a2                	ld	s3,8(sp)
    80002456:	6a02                	ld	s4,0(sp)
    80002458:	6145                	addi	sp,sp,48
    8000245a:	8082                	ret
    memmove((char *)dst, src, len);
    8000245c:	0009061b          	sext.w	a2,s2
    80002460:	85ce                	mv	a1,s3
    80002462:	8552                	mv	a0,s4
    80002464:	8adfe0ef          	jal	80000d10 <memmove>
    return 0;
    80002468:	8526                	mv	a0,s1
    8000246a:	b7cd                	j	8000244c <either_copyout+0x2c>

000000008000246c <either_copyin>:

int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000246c:	7179                	addi	sp,sp,-48
    8000246e:	f406                	sd	ra,40(sp)
    80002470:	f022                	sd	s0,32(sp)
    80002472:	ec26                	sd	s1,24(sp)
    80002474:	e84a                	sd	s2,16(sp)
    80002476:	e44e                	sd	s3,8(sp)
    80002478:	e052                	sd	s4,0(sp)
    8000247a:	1800                	addi	s0,sp,48
    8000247c:	8a2a                	mv	s4,a0
    8000247e:	84ae                	mv	s1,a1
    80002480:	89b2                	mv	s3,a2
    80002482:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002484:	c5aff0ef          	jal	800018de <myproc>
  if(user_src){
    80002488:	c085                	beqz	s1,800024a8 <either_copyin+0x3c>
    return copyin(p->pagetable, p->sz, dst, src, len);
    8000248a:	874a                	mv	a4,s2
    8000248c:	86ce                	mv	a3,s3
    8000248e:	8652                	mv	a2,s4
    80002490:	652c                	ld	a1,72(a0)
    80002492:	6928                	ld	a0,80(a0)
    80002494:	958ff0ef          	jal	800015ec <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80002498:	70a2                	ld	ra,40(sp)
    8000249a:	7402                	ld	s0,32(sp)
    8000249c:	64e2                	ld	s1,24(sp)
    8000249e:	6942                	ld	s2,16(sp)
    800024a0:	69a2                	ld	s3,8(sp)
    800024a2:	6a02                	ld	s4,0(sp)
    800024a4:	6145                	addi	sp,sp,48
    800024a6:	8082                	ret
    memmove(dst, (char *)src, len);
    800024a8:	0009061b          	sext.w	a2,s2
    800024ac:	85ce                	mv	a1,s3
    800024ae:	8552                	mv	a0,s4
    800024b0:	861fe0ef          	jal	80000d10 <memmove>
    return 0;
    800024b4:	8526                	mv	a0,s1
    800024b6:	b7cd                	j	80002498 <either_copyin+0x2c>

00000000800024b8 <procdump>:

void
procdump(void)
{
    800024b8:	715d                	addi	sp,sp,-80
    800024ba:	e486                	sd	ra,72(sp)
    800024bc:	e0a2                	sd	s0,64(sp)
    800024be:	fc26                	sd	s1,56(sp)
    800024c0:	f84a                	sd	s2,48(sp)
    800024c2:	f44e                	sd	s3,40(sp)
    800024c4:	f052                	sd	s4,32(sp)
    800024c6:	ec56                	sd	s5,24(sp)
    800024c8:	e85a                	sd	s6,16(sp)
    800024ca:	0880                	addi	s0,sp,80
    [ZOMBIE]   = "zombie "
  };
  struct proc *p;
  char *state;

  printk("\n");
    800024cc:	00005517          	auipc	a0,0x5
    800024d0:	e4c50513          	addi	a0,a0,-436 # 80007318 <etext+0x318>
    800024d4:	83cfe0ef          	jal	80000510 <printk>

#ifdef MLFQ
  printk("PID  STATE    NAME            Q  TICK_USED  CPU_TICKS  CREATED  FIRST_RUN\n");
    800024d8:	00005517          	auipc	a0,0x5
    800024dc:	da850513          	addi	a0,a0,-600 # 80007280 <etext+0x280>
    800024e0:	830fe0ef          	jal	80000510 <printk>
  printk("----+--------+---------------+-+----------+---------+---------+---------\n");
    800024e4:	00005517          	auipc	a0,0x5
    800024e8:	dec50513          	addi	a0,a0,-532 # 800072d0 <etext+0x2d0>
    800024ec:	824fe0ef          	jal	80000510 <printk>
  for(p = proc; p < &proc[NPROC]; p++){
    800024f0:	00010497          	auipc	s1,0x10
    800024f4:	5d848493          	addi	s1,s1,1496 # 80012ac8 <proc+0x158>
    800024f8:	00016917          	auipc	s2,0x16
    800024fc:	5d090913          	addi	s2,s2,1488 # 80018ac8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002500:	4a95                	li	s5,5
      state = states[p->state];
    else
      state = "???    ";
    80002502:	00005a17          	auipc	s4,0x5
    80002506:	d76a0a13          	addi	s4,s4,-650 # 80007278 <etext+0x278>
    printk("%-4d %-8s %-15s %d  %-10d %-9d %-9d %-9d\n",
    8000250a:	00005997          	auipc	s3,0x5
    8000250e:	e1698993          	addi	s3,s3,-490 # 80007320 <etext+0x320>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002512:	00005b17          	auipc	s6,0x5
    80002516:	34eb0b13          	addi	s6,s6,846 # 80007860 <mlfq_slice>
    8000251a:	a015                	j	8000253e <procdump+0x86>
    printk("%-4d %-8s %-15s %d  %-10d %-9d %-9d %-9d\n",
    8000251c:	4adc                	lw	a5,20(a3)
    8000251e:	e03e                	sd	a5,0(sp)
    80002520:	0106a883          	lw	a7,16(a3)
    80002524:	01c6a803          	lw	a6,28(a3)
    80002528:	52dc                	lw	a5,36(a3)
    8000252a:	5298                	lw	a4,32(a3)
    8000252c:	ed86a583          	lw	a1,-296(a3)
    80002530:	854e                	mv	a0,s3
    80002532:	fdffd0ef          	jal	80000510 <printk>
  for(p = proc; p < &proc[NPROC]; p++){
    80002536:	18048493          	addi	s1,s1,384
    8000253a:	03248063          	beq	s1,s2,8000255a <procdump+0xa2>
    if(p->state == UNUSED)
    8000253e:	86a6                	mv	a3,s1
    80002540:	ec04a783          	lw	a5,-320(s1)
    80002544:	dbed                	beqz	a5,80002536 <procdump+0x7e>
      state = "???    ";
    80002546:	8652                	mv	a2,s4
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002548:	fcfaeae3          	bltu	s5,a5,8000251c <procdump+0x64>
    8000254c:	02079713          	slli	a4,a5,0x20
    80002550:	01d75793          	srli	a5,a4,0x1d
    80002554:	97da                	add	a5,a5,s6
    80002556:	6b90                	ld	a2,16(a5)
      state = states[p->state];
    80002558:	b7d1                	j	8000251c <procdump+0x64>
           p->creation_time, p->first_run_time,
           p->end_time, p->cpu_ticks);
  }
#endif

  printk("\n");
    8000255a:	00005517          	auipc	a0,0x5
    8000255e:	dbe50513          	addi	a0,a0,-578 # 80007318 <etext+0x318>
    80002562:	faffd0ef          	jal	80000510 <printk>
    80002566:	60a6                	ld	ra,72(sp)
    80002568:	6406                	ld	s0,64(sp)
    8000256a:	74e2                	ld	s1,56(sp)
    8000256c:	7942                	ld	s2,48(sp)
    8000256e:	79a2                	ld	s3,40(sp)
    80002570:	7a02                	ld	s4,32(sp)
    80002572:	6ae2                	ld	s5,24(sp)
    80002574:	6b42                	ld	s6,16(sp)
    80002576:	6161                	addi	sp,sp,80
    80002578:	8082                	ret

000000008000257a <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    8000257a:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    8000257e:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80002582:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80002584:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80002586:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    8000258a:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    8000258e:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80002592:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80002596:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    8000259a:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    8000259e:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    800025a2:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    800025a6:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    800025aa:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    800025ae:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    800025b2:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    800025b6:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    800025b8:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    800025ba:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    800025be:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    800025c2:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    800025c6:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    800025ca:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    800025ce:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    800025d2:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    800025d6:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    800025da:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    800025de:	0685bd83          	ld	s11,104(a1)
        
        ret
    800025e2:	8082                	ret

00000000800025e4 <trapinit>:
#ifdef MLFQ
void mlfq_timer_tick(void);
#endif
void
trapinit(void)
{
    800025e4:	1141                	addi	sp,sp,-16
    800025e6:	e406                	sd	ra,8(sp)
    800025e8:	e022                	sd	s0,0(sp)
    800025ea:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800025ec:	00005597          	auipc	a1,0x5
    800025f0:	d9458593          	addi	a1,a1,-620 # 80007380 <etext+0x380>
    800025f4:	00016517          	auipc	a0,0x16
    800025f8:	37c50513          	addi	a0,a0,892 # 80018970 <tickslock>
    800025fc:	d7cfe0ef          	jal	80000b78 <initlock>
}
    80002600:	60a2                	ld	ra,8(sp)
    80002602:	6402                	ld	s0,0(sp)
    80002604:	0141                	addi	sp,sp,16
    80002606:	8082                	ret

0000000080002608 <trapinithart>:
void
trapinithart(void)
{
    80002608:	1141                	addi	sp,sp,-16
    8000260a:	e406                	sd	ra,8(sp)
    8000260c:	e022                	sd	s0,0(sp)
    8000260e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002610:	00003797          	auipc	a5,0x3
    80002614:	17078793          	addi	a5,a5,368 # 80005780 <kernelvec>
    80002618:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000261c:	60a2                	ld	ra,8(sp)
    8000261e:	6402                	ld	s0,0(sp)
    80002620:	0141                	addi	sp,sp,16
    80002622:	8082                	ret

0000000080002624 <prepare_return>:
  // return to trampoline.S; satp value in a0.
  return satp;
}
// set up trapframe and control registers for a return to user space

void prepare_return(void) {
    80002624:	1141                	addi	sp,sp,-16
    80002626:	e406                	sd	ra,8(sp)
    80002628:	e022                	sd	s0,0(sp)
    8000262a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000262c:	ab2ff0ef          	jal	800018de <myproc>
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    80002630:	10017073          	csrci	sstatus,2
  // we're about to switch the destination of traps from
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();
  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002634:	04000737          	lui	a4,0x4000
    80002638:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    8000263a:	0732                	slli	a4,a4,0xc
    8000263c:	00004797          	auipc	a5,0x4
    80002640:	9c478793          	addi	a5,a5,-1596 # 80006000 <_trampoline>
    80002644:	00004697          	auipc	a3,0x4
    80002648:	9bc68693          	addi	a3,a3,-1604 # 80006000 <_trampoline>
    8000264c:	8f95                	sub	a5,a5,a3
    8000264e:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002650:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);
  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002654:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80002656:	18002773          	csrr	a4,satp
    8000265a:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000265c:	6d38                	ld	a4,88(a0)
    8000265e:	613c                	ld	a5,64(a0)
    80002660:	6685                	lui	a3,0x1
    80002662:	97b6                	add	a5,a5,a3
    80002664:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002666:	6d3c                	ld	a5,88(a0)
    80002668:	00000717          	auipc	a4,0x0
    8000266c:	0f470713          	addi	a4,a4,244 # 8000275c <usertrap>
    80002670:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002672:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80002674:	8712                	mv	a4,tp
    80002676:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002678:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000267c:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002680:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002684:	10079073          	csrw	sstatus,a5
  w_sstatus(x);
  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002688:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    8000268a:	6f9c                	ld	a5,24(a5)
    8000268c:	14179073          	csrw	sepc,a5
}
    80002690:	60a2                	ld	ra,8(sp)
    80002692:	6402                	ld	s0,0(sp)
    80002694:	0141                	addi	sp,sp,16
    80002696:	8082                	ret

0000000080002698 <clockintr>:
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr() {
    80002698:	1141                	addi	sp,sp,-16
    8000269a:	e406                	sd	ra,8(sp)
    8000269c:	e022                	sd	s0,0(sp)
    8000269e:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    800026a0:	a0aff0ef          	jal	800018aa <cpuid>
    800026a4:	cd11                	beqz	a0,800026c0 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r"(x));
    800026a6:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800026aa:	000f4737          	lui	a4,0xf4
    800026ae:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800026b2:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    800026b4:	14d79073          	csrw	stimecmp,a5
}
    800026b8:	60a2                	ld	ra,8(sp)
    800026ba:	6402                	ld	s0,0(sp)
    800026bc:	0141                	addi	sp,sp,16
    800026be:	8082                	ret
    acquire(&tickslock);
    800026c0:	00016517          	auipc	a0,0x16
    800026c4:	2b050513          	addi	a0,a0,688 # 80018970 <tickslock>
    800026c8:	d30fe0ef          	jal	80000bf8 <acquire>
    ticks++;
    800026cc:	00008717          	auipc	a4,0x8
    800026d0:	d4470713          	addi	a4,a4,-700 # 8000a410 <ticks>
    800026d4:	431c                	lw	a5,0(a4)
    800026d6:	2785                	addiw	a5,a5,1
    800026d8:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    800026da:	853a                	mv	a0,a4
    800026dc:	9fbff0ef          	jal	800020d6 <wakeup>
    release(&tickslock);
    800026e0:	00016517          	auipc	a0,0x16
    800026e4:	29050513          	addi	a0,a0,656 # 80018970 <tickslock>
    800026e8:	d94fe0ef          	jal	80000c7c <release>
    800026ec:	bf6d                	j	800026a6 <clockintr+0xe>

00000000800026ee <devintr>:
// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr(){
    800026ee:	1101                	addi	sp,sp,-32
    800026f0:	ec06                	sd	ra,24(sp)
    800026f2:	e822                	sd	s0,16(sp)
    800026f4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    800026f6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();
  if (scause == 0x8000000000000009L) {
    800026fa:	57fd                	li	a5,-1
    800026fc:	17fe                	slli	a5,a5,0x3f
    800026fe:	07a5                	addi	a5,a5,9
    80002700:	00f70c63          	beq	a4,a5,80002718 <devintr+0x2a>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000005L) {
    80002704:	57fd                	li	a5,-1
    80002706:	17fe                	slli	a5,a5,0x3f
    80002708:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8000270a:	4501                	li	a0,0
  } else if (scause == 0x8000000000000005L) {
    8000270c:	04f70463          	beq	a4,a5,80002754 <devintr+0x66>
  }
}
    80002710:	60e2                	ld	ra,24(sp)
    80002712:	6442                	ld	s0,16(sp)
    80002714:	6105                	addi	sp,sp,32
    80002716:	8082                	ret
    80002718:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    8000271a:	112030ef          	jal	8000582c <plic_claim>
    8000271e:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80002720:	47a9                	li	a5,10
    80002722:	02f50363          	beq	a0,a5,80002748 <devintr+0x5a>
    } else if (irq == VIRTIO0_IRQ) {
    80002726:	4785                	li	a5,1
    80002728:	02f50363          	beq	a0,a5,8000274e <devintr+0x60>
    } else if (irq) {
    8000272c:	c919                	beqz	a0,80002742 <devintr+0x54>
      printk("unexpected interrupt irq=%d\n", irq);
    8000272e:	85aa                	mv	a1,a0
    80002730:	00005517          	auipc	a0,0x5
    80002734:	c5850513          	addi	a0,a0,-936 # 80007388 <etext+0x388>
    80002738:	dd9fd0ef          	jal	80000510 <printk>
      plic_complete(irq);
    8000273c:	8526                	mv	a0,s1
    8000273e:	10e030ef          	jal	8000584c <plic_complete>
    return 1;
    80002742:	4505                	li	a0,1
    80002744:	64a2                	ld	s1,8(sp)
    80002746:	b7e9                	j	80002710 <devintr+0x22>
      uartintr();
    80002748:	a96fe0ef          	jal	800009de <uartintr>
    if (irq)
    8000274c:	bfc5                	j	8000273c <devintr+0x4e>
      virtio_disk_intr();
    8000274e:	584030ef          	jal	80005cd2 <virtio_disk_intr>
    if (irq)
    80002752:	b7ed                	j	8000273c <devintr+0x4e>
    clockintr();
    80002754:	f45ff0ef          	jal	80002698 <clockintr>
    return 2;
    80002758:	4509                	li	a0,2
    8000275a:	bf5d                	j	80002710 <devintr+0x22>

000000008000275c <usertrap>:
uint64 usertrap(void) {
    8000275c:	1101                	addi	sp,sp,-32
    8000275e:	ec06                	sd	ra,24(sp)
    80002760:	e822                	sd	s0,16(sp)
    80002762:	e426                	sd	s1,8(sp)
    80002764:	e04a                	sd	s2,0(sp)
    80002766:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002768:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    8000276c:	1007f793          	andi	a5,a5,256
    80002770:	eba5                	bnez	a5,800027e0 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002772:	00003797          	auipc	a5,0x3
    80002776:	00e78793          	addi	a5,a5,14 # 80005780 <kernelvec>
    8000277a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000277e:	960ff0ef          	jal	800018de <myproc>
    80002782:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002784:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002786:	14102773          	csrr	a4,sepc
    8000278a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    8000278c:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80002790:	47a1                	li	a5,8
    80002792:	04f70d63          	beq	a4,a5,800027ec <usertrap+0x90>
  } else if ((which_dev = devintr()) != 0) {
    80002796:	f59ff0ef          	jal	800026ee <devintr>
    8000279a:	892a                	mv	s2,a0
    8000279c:	e54d                	bnez	a0,80002846 <usertrap+0xea>
    8000279e:	14202773          	csrr	a4,scause
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    800027a2:	47bd                	li	a5,15
    800027a4:	08f70463          	beq	a4,a5,8000282c <usertrap+0xd0>
    800027a8:	14202773          	csrr	a4,scause
    800027ac:	47b5                	li	a5,13
    800027ae:	06f70f63          	beq	a4,a5,8000282c <usertrap+0xd0>
    800027b2:	142025f3          	csrr	a1,scause
    printk("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    800027b6:	5890                	lw	a2,48(s1)
    800027b8:	00005517          	auipc	a0,0x5
    800027bc:	c1050513          	addi	a0,a0,-1008 # 800073c8 <etext+0x3c8>
    800027c0:	d51fd0ef          	jal	80000510 <printk>
  asm volatile("csrr %0, sepc" : "=r"(x));
    800027c4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    800027c8:	14302673          	csrr	a2,stval
    printk("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800027cc:	00005517          	auipc	a0,0x5
    800027d0:	c2c50513          	addi	a0,a0,-980 # 800073f8 <etext+0x3f8>
    800027d4:	d3dfd0ef          	jal	80000510 <printk>
    setkilled(p);
    800027d8:	8526                	mv	a0,s1
    800027da:	af1ff0ef          	jal	800022ca <setkilled>
    800027de:	a015                	j	80002802 <usertrap+0xa6>
    panic("usertrap: not from user mode");
    800027e0:	00005517          	auipc	a0,0x5
    800027e4:	bc850513          	addi	a0,a0,-1080 # 800073a8 <etext+0x3a8>
    800027e8:	860fe0ef          	jal	80000848 <panic>
    if (killed(p))
    800027ec:	b03ff0ef          	jal	800022ee <killed>
    800027f0:	e915                	bnez	a0,80002824 <usertrap+0xc8>
    p->trapframe->epc += 4;
    800027f2:	6cb8                	ld	a4,88(s1)
    800027f4:	6f1c                	ld	a5,24(a4)
    800027f6:	0791                	addi	a5,a5,4
    800027f8:	ef1c                	sd	a5,24(a4)
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    800027fa:	10016073          	csrsi	sstatus,2
    syscall();
    800027fe:	248000ef          	jal	80002a46 <syscall>
  if (killed(p))
    80002802:	8526                	mv	a0,s1
    80002804:	aebff0ef          	jal	800022ee <killed>
    80002808:	e521                	bnez	a0,80002850 <usertrap+0xf4>
  prepare_return();
    8000280a:	e1bff0ef          	jal	80002624 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    8000280e:	68a8                	ld	a0,80(s1)
    80002810:	8131                	srli	a0,a0,0xc
    80002812:	57fd                	li	a5,-1
    80002814:	17fe                	slli	a5,a5,0x3f
    80002816:	8d5d                	or	a0,a0,a5
}
    80002818:	60e2                	ld	ra,24(sp)
    8000281a:	6442                	ld	s0,16(sp)
    8000281c:	64a2                	ld	s1,8(sp)
    8000281e:	6902                	ld	s2,0(sp)
    80002820:	6105                	addi	sp,sp,32
    80002822:	8082                	ret
      kexit(-1);
    80002824:	557d                	li	a0,-1
    80002826:	96dff0ef          	jal	80002192 <kexit>
    8000282a:	b7e1                	j	800027f2 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r"(x));
    8000282c:	14302673          	csrr	a2,stval
  asm volatile("csrr %0, scause" : "=r"(x));
    80002830:	142026f3          	csrr	a3,scause
             vmfault(p->pagetable, p->sz, r_stval(),
    80002834:	16cd                	addi	a3,a3,-13 # ff3 <_entry-0x7ffff00d>
    80002836:	0016b693          	seqz	a3,a3
    8000283a:	64ac                	ld	a1,72(s1)
    8000283c:	68a8                	ld	a0,80(s1)
    8000283e:	c77fe0ef          	jal	800014b4 <vmfault>
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    80002842:	f161                	bnez	a0,80002802 <usertrap+0xa6>
    80002844:	b7bd                	j	800027b2 <usertrap+0x56>
  if (killed(p))
    80002846:	8526                	mv	a0,s1
    80002848:	aa7ff0ef          	jal	800022ee <killed>
    8000284c:	c511                	beqz	a0,80002858 <usertrap+0xfc>
    8000284e:	a011                	j	80002852 <usertrap+0xf6>
    80002850:	4901                	li	s2,0
    kexit(-1);
    80002852:	557d                	li	a0,-1
    80002854:	93fff0ef          	jal	80002192 <kexit>
if (which_dev == 2){
    80002858:	4789                	li	a5,2
    8000285a:	faf918e3          	bne	s2,a5,8000280a <usertrap+0xae>
    mlfq_timer_tick();
    8000285e:	8b2ff0ef          	jal	80001910 <mlfq_timer_tick>
    yield();
    80002862:	fd8ff0ef          	jal	8000203a <yield>
    80002866:	b755                	j	8000280a <usertrap+0xae>

0000000080002868 <kerneltrap>:
void kerneltrap() {
    80002868:	7179                	addi	sp,sp,-48
    8000286a:	f406                	sd	ra,40(sp)
    8000286c:	f022                	sd	s0,32(sp)
    8000286e:	ec26                	sd	s1,24(sp)
    80002870:	e84a                	sd	s2,16(sp)
    80002872:	e44e                	sd	s3,8(sp)
    80002874:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002876:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000287a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    8000287e:	142027f3          	csrr	a5,scause
    80002882:	89be                	mv	s3,a5
  if ((sstatus & SSTATUS_SPP) == 0)
    80002884:	1004f793          	andi	a5,s1,256
    80002888:	c795                	beqz	a5,800028b4 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000288a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000288e:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80002890:	eb85                	bnez	a5,800028c0 <kerneltrap+0x58>
  if ((which_dev = devintr()) == 0) {
    80002892:	e5dff0ef          	jal	800026ee <devintr>
    80002896:	c91d                	beqz	a0,800028cc <kerneltrap+0x64>
if (which_dev == 2 && myproc() != 0){
    80002898:	4789                	li	a5,2
    8000289a:	04f50a63          	beq	a0,a5,800028ee <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r"(x));
    8000289e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800028a2:	10049073          	csrw	sstatus,s1
}
    800028a6:	70a2                	ld	ra,40(sp)
    800028a8:	7402                	ld	s0,32(sp)
    800028aa:	64e2                	ld	s1,24(sp)
    800028ac:	6942                	ld	s2,16(sp)
    800028ae:	69a2                	ld	s3,8(sp)
    800028b0:	6145                	addi	sp,sp,48
    800028b2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800028b4:	00005517          	auipc	a0,0x5
    800028b8:	b6c50513          	addi	a0,a0,-1172 # 80007420 <etext+0x420>
    800028bc:	f8dfd0ef          	jal	80000848 <panic>
    panic("kerneltrap: interrupts enabled");
    800028c0:	00005517          	auipc	a0,0x5
    800028c4:	b8850513          	addi	a0,a0,-1144 # 80007448 <etext+0x448>
    800028c8:	f81fd0ef          	jal	80000848 <panic>
  asm volatile("csrr %0, sepc" : "=r"(x));
    800028cc:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    800028d0:	143026f3          	csrr	a3,stval
    printk("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(),
    800028d4:	85ce                	mv	a1,s3
    800028d6:	00005517          	auipc	a0,0x5
    800028da:	b9250513          	addi	a0,a0,-1134 # 80007468 <etext+0x468>
    800028de:	c33fd0ef          	jal	80000510 <printk>
    panic("kerneltrap");
    800028e2:	00005517          	auipc	a0,0x5
    800028e6:	bae50513          	addi	a0,a0,-1106 # 80007490 <etext+0x490>
    800028ea:	f5ffd0ef          	jal	80000848 <panic>
if (which_dev == 2 && myproc() != 0){
    800028ee:	ff1fe0ef          	jal	800018de <myproc>
    800028f2:	d555                	beqz	a0,8000289e <kerneltrap+0x36>
    mlfq_timer_tick();
    800028f4:	81cff0ef          	jal	80001910 <mlfq_timer_tick>
    yield();
    800028f8:	f42ff0ef          	jal	8000203a <yield>
    800028fc:	b74d                	j	8000289e <kerneltrap+0x36>

00000000800028fe <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800028fe:	1101                	addi	sp,sp,-32
    80002900:	ec06                	sd	ra,24(sp)
    80002902:	e822                	sd	s0,16(sp)
    80002904:	e426                	sd	s1,8(sp)
    80002906:	1000                	addi	s0,sp,32
    80002908:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000290a:	fd5fe0ef          	jal	800018de <myproc>
  switch (n) {
    8000290e:	4795                	li	a5,5
    80002910:	0497e163          	bltu	a5,s1,80002952 <argraw+0x54>
    80002914:	048a                	slli	s1,s1,0x2
    80002916:	00005717          	auipc	a4,0x5
    8000291a:	f8a70713          	addi	a4,a4,-118 # 800078a0 <states.0+0x30>
    8000291e:	94ba                	add	s1,s1,a4
    80002920:	409c                	lw	a5,0(s1)
    80002922:	97ba                	add	a5,a5,a4
    80002924:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002926:	6d3c                	ld	a5,88(a0)
    80002928:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000292a:	60e2                	ld	ra,24(sp)
    8000292c:	6442                	ld	s0,16(sp)
    8000292e:	64a2                	ld	s1,8(sp)
    80002930:	6105                	addi	sp,sp,32
    80002932:	8082                	ret
    return p->trapframe->a1;
    80002934:	6d3c                	ld	a5,88(a0)
    80002936:	7fa8                	ld	a0,120(a5)
    80002938:	bfcd                	j	8000292a <argraw+0x2c>
    return p->trapframe->a2;
    8000293a:	6d3c                	ld	a5,88(a0)
    8000293c:	63c8                	ld	a0,128(a5)
    8000293e:	b7f5                	j	8000292a <argraw+0x2c>
    return p->trapframe->a3;
    80002940:	6d3c                	ld	a5,88(a0)
    80002942:	67c8                	ld	a0,136(a5)
    80002944:	b7dd                	j	8000292a <argraw+0x2c>
    return p->trapframe->a4;
    80002946:	6d3c                	ld	a5,88(a0)
    80002948:	6bc8                	ld	a0,144(a5)
    8000294a:	b7c5                	j	8000292a <argraw+0x2c>
    return p->trapframe->a5;
    8000294c:	6d3c                	ld	a5,88(a0)
    8000294e:	6fc8                	ld	a0,152(a5)
    80002950:	bfe9                	j	8000292a <argraw+0x2c>
  panic("argraw");
    80002952:	00005517          	auipc	a0,0x5
    80002956:	b4e50513          	addi	a0,a0,-1202 # 800074a0 <etext+0x4a0>
    8000295a:	eeffd0ef          	jal	80000848 <panic>

000000008000295e <fetchaddr>:
{
    8000295e:	1101                	addi	sp,sp,-32
    80002960:	ec06                	sd	ra,24(sp)
    80002962:	e822                	sd	s0,16(sp)
    80002964:	e426                	sd	s1,8(sp)
    80002966:	e04a                	sd	s2,0(sp)
    80002968:	1000                	addi	s0,sp,32
    8000296a:	84aa                	mv	s1,a0
    8000296c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000296e:	f71fe0ef          	jal	800018de <myproc>
  if (addr >= p->sz ||
    80002972:	652c                	ld	a1,72(a0)
    80002974:	02b4f663          	bgeu	s1,a1,800029a0 <fetchaddr+0x42>
      addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002978:	00848793          	addi	a5,s1,8
  if (addr >= p->sz ||
    8000297c:	02f5e263          	bltu	a1,a5,800029a0 <fetchaddr+0x42>
  if (copyin(p->pagetable, p->sz, (char *)ip, addr, sizeof(*ip)) != 0)
    80002980:	4721                	li	a4,8
    80002982:	86a6                	mv	a3,s1
    80002984:	864a                	mv	a2,s2
    80002986:	6928                	ld	a0,80(a0)
    80002988:	c65fe0ef          	jal	800015ec <copyin>
    8000298c:	00a03533          	snez	a0,a0
    80002990:	40a0053b          	negw	a0,a0
}
    80002994:	60e2                	ld	ra,24(sp)
    80002996:	6442                	ld	s0,16(sp)
    80002998:	64a2                	ld	s1,8(sp)
    8000299a:	6902                	ld	s2,0(sp)
    8000299c:	6105                	addi	sp,sp,32
    8000299e:	8082                	ret
    return -1;
    800029a0:	557d                	li	a0,-1
    800029a2:	bfcd                	j	80002994 <fetchaddr+0x36>

00000000800029a4 <fetchstr>:
{
    800029a4:	7179                	addi	sp,sp,-48
    800029a6:	f406                	sd	ra,40(sp)
    800029a8:	f022                	sd	s0,32(sp)
    800029aa:	ec26                	sd	s1,24(sp)
    800029ac:	e84a                	sd	s2,16(sp)
    800029ae:	e44e                	sd	s3,8(sp)
    800029b0:	1800                	addi	s0,sp,48
    800029b2:	89aa                	mv	s3,a0
    800029b4:	84ae                	mv	s1,a1
    800029b6:	8932                	mv	s2,a2
  struct proc *p = myproc();
    800029b8:	f27fe0ef          	jal	800018de <myproc>
  if (copyinstr(p->pagetable, p->sz, buf, addr, max) < 0)
    800029bc:	874a                	mv	a4,s2
    800029be:	86ce                	mv	a3,s3
    800029c0:	8626                	mv	a2,s1
    800029c2:	652c                	ld	a1,72(a0)
    800029c4:	6928                	ld	a0,80(a0)
    800029c6:	cc5fe0ef          	jal	8000168a <copyinstr>
    800029ca:	00054c63          	bltz	a0,800029e2 <fetchstr+0x3e>
  return strlen(buf);
    800029ce:	8526                	mv	a0,s1
    800029d0:	c64fe0ef          	jal	80000e34 <strlen>
}
    800029d4:	70a2                	ld	ra,40(sp)
    800029d6:	7402                	ld	s0,32(sp)
    800029d8:	64e2                	ld	s1,24(sp)
    800029da:	6942                	ld	s2,16(sp)
    800029dc:	69a2                	ld	s3,8(sp)
    800029de:	6145                	addi	sp,sp,48
    800029e0:	8082                	ret
    return -1;
    800029e2:	557d                	li	a0,-1
    800029e4:	bfc5                	j	800029d4 <fetchstr+0x30>

00000000800029e6 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800029e6:	1101                	addi	sp,sp,-32
    800029e8:	ec06                	sd	ra,24(sp)
    800029ea:	e822                	sd	s0,16(sp)
    800029ec:	e426                	sd	s1,8(sp)
    800029ee:	1000                	addi	s0,sp,32
    800029f0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800029f2:	f0dff0ef          	jal	800028fe <argraw>
    800029f6:	c088                	sw	a0,0(s1)
}
    800029f8:	60e2                	ld	ra,24(sp)
    800029fa:	6442                	ld	s0,16(sp)
    800029fc:	64a2                	ld	s1,8(sp)
    800029fe:	6105                	addi	sp,sp,32
    80002a00:	8082                	ret

0000000080002a02 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002a02:	1101                	addi	sp,sp,-32
    80002a04:	ec06                	sd	ra,24(sp)
    80002a06:	e822                	sd	s0,16(sp)
    80002a08:	e426                	sd	s1,8(sp)
    80002a0a:	1000                	addi	s0,sp,32
    80002a0c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002a0e:	ef1ff0ef          	jal	800028fe <argraw>
    80002a12:	e088                	sd	a0,0(s1)
}
    80002a14:	60e2                	ld	ra,24(sp)
    80002a16:	6442                	ld	s0,16(sp)
    80002a18:	64a2                	ld	s1,8(sp)
    80002a1a:	6105                	addi	sp,sp,32
    80002a1c:	8082                	ret

0000000080002a1e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (not including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002a1e:	1101                	addi	sp,sp,-32
    80002a20:	ec06                	sd	ra,24(sp)
    80002a22:	e822                	sd	s0,16(sp)
    80002a24:	e426                	sd	s1,8(sp)
    80002a26:	e04a                	sd	s2,0(sp)
    80002a28:	1000                	addi	s0,sp,32
    80002a2a:	892e                	mv	s2,a1
    80002a2c:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80002a2e:	ed1ff0ef          	jal	800028fe <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80002a32:	8626                	mv	a2,s1
    80002a34:	85ca                	mv	a1,s2
    80002a36:	f6fff0ef          	jal	800029a4 <fetchstr>
}
    80002a3a:	60e2                	ld	ra,24(sp)
    80002a3c:	6442                	ld	s0,16(sp)
    80002a3e:	64a2                	ld	s1,8(sp)
    80002a40:	6902                	ld	s2,0(sp)
    80002a42:	6105                	addi	sp,sp,32
    80002a44:	8082                	ret

0000000080002a46 <syscall>:
  // clang-format on
};

void
syscall(void)
{
    80002a46:	1101                	addi	sp,sp,-32
    80002a48:	ec06                	sd	ra,24(sp)
    80002a4a:	e822                	sd	s0,16(sp)
    80002a4c:	e426                	sd	s1,8(sp)
    80002a4e:	e04a                	sd	s2,0(sp)
    80002a50:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002a52:	e8dfe0ef          	jal	800018de <myproc>
    80002a56:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002a58:	05853903          	ld	s2,88(a0)
    80002a5c:	0a893783          	ld	a5,168(s2)
    80002a60:	0007869b          	sext.w	a3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002a64:	37fd                	addiw	a5,a5,-1
    80002a66:	4759                	li	a4,22
    80002a68:	00f76f63          	bltu	a4,a5,80002a86 <syscall+0x40>
    80002a6c:	00369713          	slli	a4,a3,0x3
    80002a70:	00005797          	auipc	a5,0x5
    80002a74:	e4878793          	addi	a5,a5,-440 # 800078b8 <syscalls>
    80002a78:	97ba                	add	a5,a5,a4
    80002a7a:	639c                	ld	a5,0(a5)
    80002a7c:	c789                	beqz	a5,80002a86 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002a7e:	9782                	jalr	a5
    80002a80:	06a93823          	sd	a0,112(s2)
    80002a84:	a829                	j	80002a9e <syscall+0x58>
  } else {
    printk("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80002a86:	15848613          	addi	a2,s1,344
    80002a8a:	588c                	lw	a1,48(s1)
    80002a8c:	00005517          	auipc	a0,0x5
    80002a90:	a1c50513          	addi	a0,a0,-1508 # 800074a8 <etext+0x4a8>
    80002a94:	a7dfd0ef          	jal	80000510 <printk>
    p->trapframe->a0 = -1;
    80002a98:	6cbc                	ld	a5,88(s1)
    80002a9a:	577d                	li	a4,-1
    80002a9c:	fbb8                	sd	a4,112(a5)
  }
}
    80002a9e:	60e2                	ld	ra,24(sp)
    80002aa0:	6442                	ld	s0,16(sp)
    80002aa2:	64a2                	ld	s1,8(sp)
    80002aa4:	6902                	ld	s2,0(sp)
    80002aa6:	6105                	addi	sp,sp,32
    80002aa8:	8082                	ret

0000000080002aaa <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80002aaa:	1101                	addi	sp,sp,-32
    80002aac:	ec06                	sd	ra,24(sp)
    80002aae:	e822                	sd	s0,16(sp)
    80002ab0:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002ab2:	fec40593          	addi	a1,s0,-20
    80002ab6:	4501                	li	a0,0
    80002ab8:	f2fff0ef          	jal	800029e6 <argint>
  kexit(n);
    80002abc:	fec42503          	lw	a0,-20(s0)
    80002ac0:	ed2ff0ef          	jal	80002192 <kexit>
  return 0; // not reached
}
    80002ac4:	4501                	li	a0,0
    80002ac6:	60e2                	ld	ra,24(sp)
    80002ac8:	6442                	ld	s0,16(sp)
    80002aca:	6105                	addi	sp,sp,32
    80002acc:	8082                	ret

0000000080002ace <sys_getpid>:

uint64
sys_getpid(void)
{
    80002ace:	1141                	addi	sp,sp,-16
    80002ad0:	e406                	sd	ra,8(sp)
    80002ad2:	e022                	sd	s0,0(sp)
    80002ad4:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002ad6:	e09fe0ef          	jal	800018de <myproc>
}
    80002ada:	5908                	lw	a0,48(a0)
    80002adc:	60a2                	ld	ra,8(sp)
    80002ade:	6402                	ld	s0,0(sp)
    80002ae0:	0141                	addi	sp,sp,16
    80002ae2:	8082                	ret

0000000080002ae4 <sys_fork>:

uint64
sys_fork(void)
{
    80002ae4:	1141                	addi	sp,sp,-16
    80002ae6:	e406                	sd	ra,8(sp)
    80002ae8:	e022                	sd	s0,0(sp)
    80002aea:	0800                	addi	s0,sp,16
  return kfork();
    80002aec:	9eaff0ef          	jal	80001cd6 <kfork>
}
    80002af0:	60a2                	ld	ra,8(sp)
    80002af2:	6402                	ld	s0,0(sp)
    80002af4:	0141                	addi	sp,sp,16
    80002af6:	8082                	ret

0000000080002af8 <sys_wait>:

uint64
sys_wait(void)
{
    80002af8:	1101                	addi	sp,sp,-32
    80002afa:	ec06                	sd	ra,24(sp)
    80002afc:	e822                	sd	s0,16(sp)
    80002afe:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002b00:	fe840593          	addi	a1,s0,-24
    80002b04:	4501                	li	a0,0
    80002b06:	efdff0ef          	jal	80002a02 <argaddr>
  return kwait(p);
    80002b0a:	fe843503          	ld	a0,-24(s0)
    80002b0e:	80bff0ef          	jal	80002318 <kwait>
}
    80002b12:	60e2                	ld	ra,24(sp)
    80002b14:	6442                	ld	s0,16(sp)
    80002b16:	6105                	addi	sp,sp,32
    80002b18:	8082                	ret

0000000080002b1a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002b1a:	7179                	addi	sp,sp,-48
    80002b1c:	f406                	sd	ra,40(sp)
    80002b1e:	f022                	sd	s0,32(sp)
    80002b20:	ec26                	sd	s1,24(sp)
    80002b22:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80002b24:	fd840593          	addi	a1,s0,-40
    80002b28:	4501                	li	a0,0
    80002b2a:	ebdff0ef          	jal	800029e6 <argint>
  argint(1, &t);
    80002b2e:	fdc40593          	addi	a1,s0,-36
    80002b32:	4505                	li	a0,1
    80002b34:	eb3ff0ef          	jal	800029e6 <argint>
  addr = myproc()->sz;
    80002b38:	da7fe0ef          	jal	800018de <myproc>
    80002b3c:	6524                	ld	s1,72(a0)

  if (t == SBRK_EAGER || n < 0) {
    80002b3e:	fdc42703          	lw	a4,-36(s0)
    80002b42:	4785                	li	a5,1
    80002b44:	02f70a63          	beq	a4,a5,80002b78 <sys_sbrk+0x5e>
    80002b48:	fd842783          	lw	a5,-40(s0)
    80002b4c:	0207c663          	bltz	a5,80002b78 <sys_sbrk+0x5e>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if (addr + n < addr)
    80002b50:	00978733          	add	a4,a5,s1
      return -1;
    if (addr + n > TRAPFRAME)
    80002b54:	020007b7          	lui	a5,0x2000
    80002b58:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80002b5a:	07b6                	slli	a5,a5,0xd
    80002b5c:	00e7b7b3          	sltu	a5,a5,a4
    if (addr + n < addr)
    80002b60:	00973733          	sltu	a4,a4,s1
    if (addr + n > TRAPFRAME)
    80002b64:	8fd9                	or	a5,a5,a4
    80002b66:	e79d                	bnez	a5,80002b94 <sys_sbrk+0x7a>
      return -1;
    myproc()->sz += n;
    80002b68:	d77fe0ef          	jal	800018de <myproc>
    80002b6c:	fd842703          	lw	a4,-40(s0)
    80002b70:	653c                	ld	a5,72(a0)
    80002b72:	97ba                	add	a5,a5,a4
    80002b74:	e53c                	sd	a5,72(a0)
    80002b76:	a039                	j	80002b84 <sys_sbrk+0x6a>
    if (growproc(n) < 0) {
    80002b78:	fd842503          	lw	a0,-40(s0)
    80002b7c:	8fcff0ef          	jal	80001c78 <growproc>
    80002b80:	00054863          	bltz	a0,80002b90 <sys_sbrk+0x76>
  }
  return addr;
}
    80002b84:	8526                	mv	a0,s1
    80002b86:	70a2                	ld	ra,40(sp)
    80002b88:	7402                	ld	s0,32(sp)
    80002b8a:	64e2                	ld	s1,24(sp)
    80002b8c:	6145                	addi	sp,sp,48
    80002b8e:	8082                	ret
      return -1;
    80002b90:	54fd                	li	s1,-1
    80002b92:	bfcd                	j	80002b84 <sys_sbrk+0x6a>
      return -1;
    80002b94:	54fd                	li	s1,-1
    80002b96:	b7fd                	j	80002b84 <sys_sbrk+0x6a>

0000000080002b98 <sys_pause>:

uint64
sys_pause(void)
{
    80002b98:	7139                	addi	sp,sp,-64
    80002b9a:	fc06                	sd	ra,56(sp)
    80002b9c:	f822                	sd	s0,48(sp)
    80002b9e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002ba0:	fcc40593          	addi	a1,s0,-52
    80002ba4:	4501                	li	a0,0
    80002ba6:	e41ff0ef          	jal	800029e6 <argint>
  if (n < 0)
    80002baa:	fcc42783          	lw	a5,-52(s0)
    80002bae:	0807c063          	bltz	a5,80002c2e <sys_pause+0x96>
    n = 0;
  acquire(&tickslock);
    80002bb2:	00016517          	auipc	a0,0x16
    80002bb6:	dbe50513          	addi	a0,a0,-578 # 80018970 <tickslock>
    80002bba:	83efe0ef          	jal	80000bf8 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n) {
    80002bbe:	fcc42783          	lw	a5,-52(s0)
    80002bc2:	cbb9                	beqz	a5,80002c18 <sys_pause+0x80>
    80002bc4:	f426                	sd	s1,40(sp)
    80002bc6:	f04a                	sd	s2,32(sp)
    80002bc8:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80002bca:	00008997          	auipc	s3,0x8
    80002bce:	8469a983          	lw	s3,-1978(s3) # 8000a410 <ticks>
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep_prepare(&ticks);
    80002bd2:	00008917          	auipc	s2,0x8
    80002bd6:	83e90913          	addi	s2,s2,-1986 # 8000a410 <ticks>
    release(&tickslock);
    80002bda:	00016497          	auipc	s1,0x16
    80002bde:	d9648493          	addi	s1,s1,-618 # 80018970 <tickslock>
    if (killed(myproc())) {
    80002be2:	cfdfe0ef          	jal	800018de <myproc>
    80002be6:	f08ff0ef          	jal	800022ee <killed>
    80002bea:	e529                	bnez	a0,80002c34 <sys_pause+0x9c>
    sleep_prepare(&ticks);
    80002bec:	854a                	mv	a0,s2
    80002bee:	c78ff0ef          	jal	80002066 <sleep_prepare>
    release(&tickslock);
    80002bf2:	8526                	mv	a0,s1
    80002bf4:	888fe0ef          	jal	80000c7c <release>
    sleep();
    80002bf8:	caaff0ef          	jal	800020a2 <sleep>
    acquire(&tickslock);
    80002bfc:	8526                	mv	a0,s1
    80002bfe:	ffbfd0ef          	jal	80000bf8 <acquire>
  while (ticks - ticks0 < n) {
    80002c02:	00092783          	lw	a5,0(s2)
    80002c06:	413787bb          	subw	a5,a5,s3
    80002c0a:	fcc42703          	lw	a4,-52(s0)
    80002c0e:	fce7eae3          	bltu	a5,a4,80002be2 <sys_pause+0x4a>
    80002c12:	74a2                	ld	s1,40(sp)
    80002c14:	7902                	ld	s2,32(sp)
    80002c16:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002c18:	00016517          	auipc	a0,0x16
    80002c1c:	d5850513          	addi	a0,a0,-680 # 80018970 <tickslock>
    80002c20:	85cfe0ef          	jal	80000c7c <release>
  return 0;
    80002c24:	4501                	li	a0,0
}
    80002c26:	70e2                	ld	ra,56(sp)
    80002c28:	7442                	ld	s0,48(sp)
    80002c2a:	6121                	addi	sp,sp,64
    80002c2c:	8082                	ret
    n = 0;
    80002c2e:	fc042623          	sw	zero,-52(s0)
    80002c32:	b741                	j	80002bb2 <sys_pause+0x1a>
      release(&tickslock);
    80002c34:	00016517          	auipc	a0,0x16
    80002c38:	d3c50513          	addi	a0,a0,-708 # 80018970 <tickslock>
    80002c3c:	840fe0ef          	jal	80000c7c <release>
      return -1;
    80002c40:	557d                	li	a0,-1
    80002c42:	74a2                	ld	s1,40(sp)
    80002c44:	7902                	ld	s2,32(sp)
    80002c46:	69e2                	ld	s3,24(sp)
    80002c48:	bff9                	j	80002c26 <sys_pause+0x8e>

0000000080002c4a <sys_kill>:

uint64
sys_kill(void)
{
    80002c4a:	1101                	addi	sp,sp,-32
    80002c4c:	ec06                	sd	ra,24(sp)
    80002c4e:	e822                	sd	s0,16(sp)
    80002c50:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002c52:	fec40593          	addi	a1,s0,-20
    80002c56:	4501                	li	a0,0
    80002c58:	d8fff0ef          	jal	800029e6 <argint>
  return kkill(pid);
    80002c5c:	fec42503          	lw	a0,-20(s0)
    80002c60:	e04ff0ef          	jal	80002264 <kkill>
}
    80002c64:	60e2                	ld	ra,24(sp)
    80002c66:	6442                	ld	s0,16(sp)
    80002c68:	6105                	addi	sp,sp,32
    80002c6a:	8082                	ret

0000000080002c6c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002c6c:	1101                	addi	sp,sp,-32
    80002c6e:	ec06                	sd	ra,24(sp)
    80002c70:	e822                	sd	s0,16(sp)
    80002c72:	e426                	sd	s1,8(sp)
    80002c74:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002c76:	00016517          	auipc	a0,0x16
    80002c7a:	cfa50513          	addi	a0,a0,-774 # 80018970 <tickslock>
    80002c7e:	f7bfd0ef          	jal	80000bf8 <acquire>
  xticks = ticks;
    80002c82:	00007797          	auipc	a5,0x7
    80002c86:	78e7a783          	lw	a5,1934(a5) # 8000a410 <ticks>
    80002c8a:	84be                	mv	s1,a5
  release(&tickslock);
    80002c8c:	00016517          	auipc	a0,0x16
    80002c90:	ce450513          	addi	a0,a0,-796 # 80018970 <tickslock>
    80002c94:	fe9fd0ef          	jal	80000c7c <release>
  return xticks;
}
    80002c98:	02049513          	slli	a0,s1,0x20
    80002c9c:	9101                	srli	a0,a0,0x20
    80002c9e:	60e2                	ld	ra,24(sp)
    80002ca0:	6442                	ld	s0,16(sp)
    80002ca2:	64a2                	ld	s1,8(sp)
    80002ca4:	6105                	addi	sp,sp,32
    80002ca6:	8082                	ret

0000000080002ca8 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002ca8:	7139                	addi	sp,sp,-64
    80002caa:	fc06                	sd	ra,56(sp)
    80002cac:	f822                	sd	s0,48(sp)
    80002cae:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002cb0:	fcc40593          	addi	a1,s0,-52
    80002cb4:	4501                	li	a0,0
    80002cb6:	d31ff0ef          	jal	800029e6 <argint>
  if (n < 0)
    80002cba:	fcc42783          	lw	a5,-52(s0)
    80002cbe:	0807c063          	bltz	a5,80002d3e <sys_sleep+0x96>
    n = 0;
  acquire(&tickslock);
    80002cc2:	00016517          	auipc	a0,0x16
    80002cc6:	cae50513          	addi	a0,a0,-850 # 80018970 <tickslock>
    80002cca:	f2ffd0ef          	jal	80000bf8 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n) {
    80002cce:	fcc42783          	lw	a5,-52(s0)
    80002cd2:	cbb9                	beqz	a5,80002d28 <sys_sleep+0x80>
    80002cd4:	f426                	sd	s1,40(sp)
    80002cd6:	f04a                	sd	s2,32(sp)
    80002cd8:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80002cda:	00007997          	auipc	s3,0x7
    80002cde:	7369a983          	lw	s3,1846(s3) # 8000a410 <ticks>
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep_prepare(&ticks);
    80002ce2:	00007917          	auipc	s2,0x7
    80002ce6:	72e90913          	addi	s2,s2,1838 # 8000a410 <ticks>
    release(&tickslock);
    80002cea:	00016497          	auipc	s1,0x16
    80002cee:	c8648493          	addi	s1,s1,-890 # 80018970 <tickslock>
    if (killed(myproc())) {
    80002cf2:	bedfe0ef          	jal	800018de <myproc>
    80002cf6:	df8ff0ef          	jal	800022ee <killed>
    80002cfa:	e529                	bnez	a0,80002d44 <sys_sleep+0x9c>
    sleep_prepare(&ticks);
    80002cfc:	854a                	mv	a0,s2
    80002cfe:	b68ff0ef          	jal	80002066 <sleep_prepare>
    release(&tickslock);
    80002d02:	8526                	mv	a0,s1
    80002d04:	f79fd0ef          	jal	80000c7c <release>
    sleep();
    80002d08:	b9aff0ef          	jal	800020a2 <sleep>
    acquire(&tickslock);
    80002d0c:	8526                	mv	a0,s1
    80002d0e:	eebfd0ef          	jal	80000bf8 <acquire>
  while (ticks - ticks0 < n) {
    80002d12:	00092783          	lw	a5,0(s2)
    80002d16:	413787bb          	subw	a5,a5,s3
    80002d1a:	fcc42703          	lw	a4,-52(s0)
    80002d1e:	fce7eae3          	bltu	a5,a4,80002cf2 <sys_sleep+0x4a>
    80002d22:	74a2                	ld	s1,40(sp)
    80002d24:	7902                	ld	s2,32(sp)
    80002d26:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002d28:	00016517          	auipc	a0,0x16
    80002d2c:	c4850513          	addi	a0,a0,-952 # 80018970 <tickslock>
    80002d30:	f4dfd0ef          	jal	80000c7c <release>
  return 0;
    80002d34:	4501                	li	a0,0
    80002d36:	70e2                	ld	ra,56(sp)
    80002d38:	7442                	ld	s0,48(sp)
    80002d3a:	6121                	addi	sp,sp,64
    80002d3c:	8082                	ret
    n = 0;
    80002d3e:	fc042623          	sw	zero,-52(s0)
    80002d42:	b741                	j	80002cc2 <sys_sleep+0x1a>
      release(&tickslock);
    80002d44:	00016517          	auipc	a0,0x16
    80002d48:	c2c50513          	addi	a0,a0,-980 # 80018970 <tickslock>
    80002d4c:	f31fd0ef          	jal	80000c7c <release>
      return -1;
    80002d50:	557d                	li	a0,-1
    80002d52:	74a2                	ld	s1,40(sp)
    80002d54:	7902                	ld	s2,32(sp)
    80002d56:	69e2                	ld	s3,24(sp)
    80002d58:	bff9                	j	80002d36 <sys_sleep+0x8e>

0000000080002d5a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002d5a:	7179                	addi	sp,sp,-48
    80002d5c:	f406                	sd	ra,40(sp)
    80002d5e:	f022                	sd	s0,32(sp)
    80002d60:	ec26                	sd	s1,24(sp)
    80002d62:	e84a                	sd	s2,16(sp)
    80002d64:	e44e                	sd	s3,8(sp)
    80002d66:	e052                	sd	s4,0(sp)
    80002d68:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002d6a:	00004597          	auipc	a1,0x4
    80002d6e:	75e58593          	addi	a1,a1,1886 # 800074c8 <etext+0x4c8>
    80002d72:	00016517          	auipc	a0,0x16
    80002d76:	c1650513          	addi	a0,a0,-1002 # 80018988 <bcache>
    80002d7a:	dfffd0ef          	jal	80000b78 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002d7e:	0001e797          	auipc	a5,0x1e
    80002d82:	c0a78793          	addi	a5,a5,-1014 # 80020988 <bcache+0x8000>
    80002d86:	0001e717          	auipc	a4,0x1e
    80002d8a:	e6a70713          	addi	a4,a4,-406 # 80020bf0 <bcache+0x8268>
    80002d8e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002d92:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002d96:	00016497          	auipc	s1,0x16
    80002d9a:	c0a48493          	addi	s1,s1,-1014 # 800189a0 <bcache+0x18>
    b->next = bcache.head.next;
    80002d9e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002da0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002da2:	00004a17          	auipc	s4,0x4
    80002da6:	72ea0a13          	addi	s4,s4,1838 # 800074d0 <etext+0x4d0>
    b->next = bcache.head.next;
    80002daa:	2b893783          	ld	a5,696(s2)
    80002dae:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002db0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002db4:	85d2                	mv	a1,s4
    80002db6:	01048513          	addi	a0,s1,16
    80002dba:	41a010ef          	jal	800041d4 <initsleeplock>
    bcache.head.next->prev = b;
    80002dbe:	2b893783          	ld	a5,696(s2)
    80002dc2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002dc4:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002dc8:	45848493          	addi	s1,s1,1112
    80002dcc:	fd349fe3          	bne	s1,s3,80002daa <binit+0x50>
  }
}
    80002dd0:	70a2                	ld	ra,40(sp)
    80002dd2:	7402                	ld	s0,32(sp)
    80002dd4:	64e2                	ld	s1,24(sp)
    80002dd6:	6942                	ld	s2,16(sp)
    80002dd8:	69a2                	ld	s3,8(sp)
    80002dda:	6a02                	ld	s4,0(sp)
    80002ddc:	6145                	addi	sp,sp,48
    80002dde:	8082                	ret

0000000080002de0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf *
bread(uint dev, uint blockno)
{
    80002de0:	7179                	addi	sp,sp,-48
    80002de2:	f406                	sd	ra,40(sp)
    80002de4:	f022                	sd	s0,32(sp)
    80002de6:	ec26                	sd	s1,24(sp)
    80002de8:	e84a                	sd	s2,16(sp)
    80002dea:	e44e                	sd	s3,8(sp)
    80002dec:	1800                	addi	s0,sp,48
    80002dee:	892a                	mv	s2,a0
    80002df0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002df2:	00016517          	auipc	a0,0x16
    80002df6:	b9650513          	addi	a0,a0,-1130 # 80018988 <bcache>
    80002dfa:	dfffd0ef          	jal	80000bf8 <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    80002dfe:	0001e497          	auipc	s1,0x1e
    80002e02:	e424b483          	ld	s1,-446(s1) # 80020c40 <bcache+0x82b8>
    80002e06:	0001e797          	auipc	a5,0x1e
    80002e0a:	dea78793          	addi	a5,a5,-534 # 80020bf0 <bcache+0x8268>
    80002e0e:	02f48b63          	beq	s1,a5,80002e44 <bread+0x64>
    80002e12:	873e                	mv	a4,a5
    80002e14:	a021                	j	80002e1c <bread+0x3c>
    80002e16:	68a4                	ld	s1,80(s1)
    80002e18:	02e48663          	beq	s1,a4,80002e44 <bread+0x64>
    if (b->dev == dev && b->blockno == blockno) {
    80002e1c:	449c                	lw	a5,8(s1)
    80002e1e:	ff279ce3          	bne	a5,s2,80002e16 <bread+0x36>
    80002e22:	44dc                	lw	a5,12(s1)
    80002e24:	ff3799e3          	bne	a5,s3,80002e16 <bread+0x36>
      b->refcnt++;
    80002e28:	40bc                	lw	a5,64(s1)
    80002e2a:	2785                	addiw	a5,a5,1
    80002e2c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002e2e:	00016517          	auipc	a0,0x16
    80002e32:	b5a50513          	addi	a0,a0,-1190 # 80018988 <bcache>
    80002e36:	e47fd0ef          	jal	80000c7c <release>
      acquiresleep(&b->lock);
    80002e3a:	01048513          	addi	a0,s1,16
    80002e3e:	3cc010ef          	jal	8000420a <acquiresleep>
      return b;
    80002e42:	a889                	j	80002e94 <bread+0xb4>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002e44:	0001e497          	auipc	s1,0x1e
    80002e48:	df44b483          	ld	s1,-524(s1) # 80020c38 <bcache+0x82b0>
    80002e4c:	0001e797          	auipc	a5,0x1e
    80002e50:	da478793          	addi	a5,a5,-604 # 80020bf0 <bcache+0x8268>
    80002e54:	00f48863          	beq	s1,a5,80002e64 <bread+0x84>
    80002e58:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    80002e5a:	40bc                	lw	a5,64(s1)
    80002e5c:	cb91                	beqz	a5,80002e70 <bread+0x90>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002e5e:	64a4                	ld	s1,72(s1)
    80002e60:	fee49de3          	bne	s1,a4,80002e5a <bread+0x7a>
  panic("bget: no buffers");
    80002e64:	00004517          	auipc	a0,0x4
    80002e68:	67450513          	addi	a0,a0,1652 # 800074d8 <etext+0x4d8>
    80002e6c:	9ddfd0ef          	jal	80000848 <panic>
      b->dev = dev;
    80002e70:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002e74:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002e78:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002e7c:	4785                	li	a5,1
    80002e7e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002e80:	00016517          	auipc	a0,0x16
    80002e84:	b0850513          	addi	a0,a0,-1272 # 80018988 <bcache>
    80002e88:	df5fd0ef          	jal	80000c7c <release>
      acquiresleep(&b->lock);
    80002e8c:	01048513          	addi	a0,s1,16
    80002e90:	37a010ef          	jal	8000420a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    80002e94:	409c                	lw	a5,0(s1)
    80002e96:	cb89                	beqz	a5,80002ea8 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002e98:	8526                	mv	a0,s1
    80002e9a:	70a2                	ld	ra,40(sp)
    80002e9c:	7402                	ld	s0,32(sp)
    80002e9e:	64e2                	ld	s1,24(sp)
    80002ea0:	6942                	ld	s2,16(sp)
    80002ea2:	69a2                	ld	s3,8(sp)
    80002ea4:	6145                	addi	sp,sp,48
    80002ea6:	8082                	ret
    virtio_disk_rw(b, 0);
    80002ea8:	4581                	li	a1,0
    80002eaa:	8526                	mv	a0,s1
    80002eac:	3f7020ef          	jal	80005aa2 <virtio_disk_rw>
    b->valid = 1;
    80002eb0:	4785                	li	a5,1
    80002eb2:	c09c                	sw	a5,0(s1)
  return b;
    80002eb4:	b7d5                	j	80002e98 <bread+0xb8>

0000000080002eb6 <bwrite>:

// Write b's contents to disk.  Must be locked.
// Only the log calls bwrite.
void
bwrite(struct buf *b)
{
    80002eb6:	1101                	addi	sp,sp,-32
    80002eb8:	ec06                	sd	ra,24(sp)
    80002eba:	e822                	sd	s0,16(sp)
    80002ebc:	e426                	sd	s1,8(sp)
    80002ebe:	1000                	addi	s0,sp,32
    80002ec0:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002ec2:	0541                	addi	a0,a0,16
    80002ec4:	3d2010ef          	jal	80004296 <holdingsleep>
    80002ec8:	c911                	beqz	a0,80002edc <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002eca:	4585                	li	a1,1
    80002ecc:	8526                	mv	a0,s1
    80002ece:	3d5020ef          	jal	80005aa2 <virtio_disk_rw>
}
    80002ed2:	60e2                	ld	ra,24(sp)
    80002ed4:	6442                	ld	s0,16(sp)
    80002ed6:	64a2                	ld	s1,8(sp)
    80002ed8:	6105                	addi	sp,sp,32
    80002eda:	8082                	ret
    panic("bwrite");
    80002edc:	00004517          	auipc	a0,0x4
    80002ee0:	61450513          	addi	a0,a0,1556 # 800074f0 <etext+0x4f0>
    80002ee4:	965fd0ef          	jal	80000848 <panic>

0000000080002ee8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002ee8:	1101                	addi	sp,sp,-32
    80002eea:	ec06                	sd	ra,24(sp)
    80002eec:	e822                	sd	s0,16(sp)
    80002eee:	e426                	sd	s1,8(sp)
    80002ef0:	e04a                	sd	s2,0(sp)
    80002ef2:	1000                	addi	s0,sp,32
    80002ef4:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002ef6:	01050913          	addi	s2,a0,16
    80002efa:	854a                	mv	a0,s2
    80002efc:	39a010ef          	jal	80004296 <holdingsleep>
    80002f00:	c125                	beqz	a0,80002f60 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002f02:	854a                	mv	a0,s2
    80002f04:	35a010ef          	jal	8000425e <releasesleep>

  acquire(&bcache.lock);
    80002f08:	00016517          	auipc	a0,0x16
    80002f0c:	a8050513          	addi	a0,a0,-1408 # 80018988 <bcache>
    80002f10:	ce9fd0ef          	jal	80000bf8 <acquire>
  b->refcnt--;
    80002f14:	40bc                	lw	a5,64(s1)
    80002f16:	37fd                	addiw	a5,a5,-1
    80002f18:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002f1a:	e79d                	bnez	a5,80002f48 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002f1c:	68b8                	ld	a4,80(s1)
    80002f1e:	64bc                	ld	a5,72(s1)
    80002f20:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002f22:	68b8                	ld	a4,80(s1)
    80002f24:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002f26:	0001e797          	auipc	a5,0x1e
    80002f2a:	a6278793          	addi	a5,a5,-1438 # 80020988 <bcache+0x8000>
    80002f2e:	2b87b703          	ld	a4,696(a5)
    80002f32:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002f34:	0001e717          	auipc	a4,0x1e
    80002f38:	cbc70713          	addi	a4,a4,-836 # 80020bf0 <bcache+0x8268>
    80002f3c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002f3e:	2b87b703          	ld	a4,696(a5)
    80002f42:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002f44:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80002f48:	00016517          	auipc	a0,0x16
    80002f4c:	a4050513          	addi	a0,a0,-1472 # 80018988 <bcache>
    80002f50:	d2dfd0ef          	jal	80000c7c <release>
}
    80002f54:	60e2                	ld	ra,24(sp)
    80002f56:	6442                	ld	s0,16(sp)
    80002f58:	64a2                	ld	s1,8(sp)
    80002f5a:	6902                	ld	s2,0(sp)
    80002f5c:	6105                	addi	sp,sp,32
    80002f5e:	8082                	ret
    panic("brelse");
    80002f60:	00004517          	auipc	a0,0x4
    80002f64:	59850513          	addi	a0,a0,1432 # 800074f8 <etext+0x4f8>
    80002f68:	8e1fd0ef          	jal	80000848 <panic>

0000000080002f6c <bpin>:

void
bpin(struct buf *b)
{
    80002f6c:	1101                	addi	sp,sp,-32
    80002f6e:	ec06                	sd	ra,24(sp)
    80002f70:	e822                	sd	s0,16(sp)
    80002f72:	e426                	sd	s1,8(sp)
    80002f74:	1000                	addi	s0,sp,32
    80002f76:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002f78:	00016517          	auipc	a0,0x16
    80002f7c:	a1050513          	addi	a0,a0,-1520 # 80018988 <bcache>
    80002f80:	c79fd0ef          	jal	80000bf8 <acquire>
  b->refcnt++;
    80002f84:	40bc                	lw	a5,64(s1)
    80002f86:	2785                	addiw	a5,a5,1
    80002f88:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002f8a:	00016517          	auipc	a0,0x16
    80002f8e:	9fe50513          	addi	a0,a0,-1538 # 80018988 <bcache>
    80002f92:	cebfd0ef          	jal	80000c7c <release>
}
    80002f96:	60e2                	ld	ra,24(sp)
    80002f98:	6442                	ld	s0,16(sp)
    80002f9a:	64a2                	ld	s1,8(sp)
    80002f9c:	6105                	addi	sp,sp,32
    80002f9e:	8082                	ret

0000000080002fa0 <bunpin>:

void
bunpin(struct buf *b)
{
    80002fa0:	1101                	addi	sp,sp,-32
    80002fa2:	ec06                	sd	ra,24(sp)
    80002fa4:	e822                	sd	s0,16(sp)
    80002fa6:	e426                	sd	s1,8(sp)
    80002fa8:	1000                	addi	s0,sp,32
    80002faa:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002fac:	00016517          	auipc	a0,0x16
    80002fb0:	9dc50513          	addi	a0,a0,-1572 # 80018988 <bcache>
    80002fb4:	c45fd0ef          	jal	80000bf8 <acquire>
  b->refcnt--;
    80002fb8:	40bc                	lw	a5,64(s1)
    80002fba:	37fd                	addiw	a5,a5,-1
    80002fbc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002fbe:	00016517          	auipc	a0,0x16
    80002fc2:	9ca50513          	addi	a0,a0,-1590 # 80018988 <bcache>
    80002fc6:	cb7fd0ef          	jal	80000c7c <release>
}
    80002fca:	60e2                	ld	ra,24(sp)
    80002fcc:	6442                	ld	s0,16(sp)
    80002fce:	64a2                	ld	s1,8(sp)
    80002fd0:	6105                	addi	sp,sp,32
    80002fd2:	8082                	ret

0000000080002fd4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002fd4:	1101                	addi	sp,sp,-32
    80002fd6:	ec06                	sd	ra,24(sp)
    80002fd8:	e822                	sd	s0,16(sp)
    80002fda:	e426                	sd	s1,8(sp)
    80002fdc:	e04a                	sd	s2,0(sp)
    80002fde:	1000                	addi	s0,sp,32
    80002fe0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002fe2:	00d5d79b          	srliw	a5,a1,0xd
    80002fe6:	0001e597          	auipc	a1,0x1e
    80002fea:	07e5a583          	lw	a1,126(a1) # 80021064 <sb+0x1c>
    80002fee:	9dbd                	addw	a1,a1,a5
    80002ff0:	df1ff0ef          	jal	80002de0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002ff4:	0074f713          	andi	a4,s1,7
    80002ff8:	4785                	li	a5,1
    80002ffa:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002ffe:	14ce                	slli	s1,s1,0x33
  if ((bp->data[bi / 8] & m) == 0)
    80003000:	90d9                	srli	s1,s1,0x36
    80003002:	00950733          	add	a4,a0,s1
    80003006:	05874703          	lbu	a4,88(a4)
    8000300a:	00e7f6b3          	and	a3,a5,a4
    8000300e:	c29d                	beqz	a3,80003034 <bfree+0x60>
    80003010:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi / 8] &= ~m;
    80003012:	94aa                	add	s1,s1,a0
    80003014:	fff7c793          	not	a5,a5
    80003018:	8f7d                	and	a4,a4,a5
    8000301a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000301e:	082010ef          	jal	800040a0 <log_write>
  brelse(bp);
    80003022:	854a                	mv	a0,s2
    80003024:	ec5ff0ef          	jal	80002ee8 <brelse>
}
    80003028:	60e2                	ld	ra,24(sp)
    8000302a:	6442                	ld	s0,16(sp)
    8000302c:	64a2                	ld	s1,8(sp)
    8000302e:	6902                	ld	s2,0(sp)
    80003030:	6105                	addi	sp,sp,32
    80003032:	8082                	ret
    panic("freeing free block");
    80003034:	00004517          	auipc	a0,0x4
    80003038:	4cc50513          	addi	a0,a0,1228 # 80007500 <etext+0x500>
    8000303c:	80dfd0ef          	jal	80000848 <panic>

0000000080003040 <balloc>:
{
    80003040:	715d                	addi	sp,sp,-80
    80003042:	e486                	sd	ra,72(sp)
    80003044:	e0a2                	sd	s0,64(sp)
    80003046:	fc26                	sd	s1,56(sp)
    80003048:	0880                	addi	s0,sp,80
  for (b = 0; b < sb.size; b += BPB) {
    8000304a:	0001e797          	auipc	a5,0x1e
    8000304e:	0027a783          	lw	a5,2(a5) # 8002104c <sb+0x4>
    80003052:	0e078263          	beqz	a5,80003136 <balloc+0xf6>
    80003056:	f84a                	sd	s2,48(sp)
    80003058:	f44e                	sd	s3,40(sp)
    8000305a:	f052                	sd	s4,32(sp)
    8000305c:	ec56                	sd	s5,24(sp)
    8000305e:	e85a                	sd	s6,16(sp)
    80003060:	e45e                	sd	s7,8(sp)
    80003062:	e062                	sd	s8,0(sp)
    80003064:	8baa                	mv	s7,a0
    80003066:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003068:	0001eb17          	auipc	s6,0x1e
    8000306c:	fe0b0b13          	addi	s6,s6,-32 # 80021048 <sb>
      m = 1 << (bi % 8);
    80003070:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80003072:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    80003074:	6c09                	lui	s8,0x2
    80003076:	a09d                	j	800030dc <balloc+0x9c>
        bp->data[bi / 8] |= m;           // Mark block in use.
    80003078:	97ca                	add	a5,a5,s2
    8000307a:	8e55                	or	a2,a2,a3
    8000307c:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003080:	854a                	mv	a0,s2
    80003082:	01e010ef          	jal	800040a0 <log_write>
        brelse(bp);
    80003086:	854a                	mv	a0,s2
    80003088:	e61ff0ef          	jal	80002ee8 <brelse>
  bp = bread(dev, bno);
    8000308c:	85a6                	mv	a1,s1
    8000308e:	855e                	mv	a0,s7
    80003090:	d51ff0ef          	jal	80002de0 <bread>
    80003094:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003096:	40000613          	li	a2,1024
    8000309a:	4581                	li	a1,0
    8000309c:	05850513          	addi	a0,a0,88
    800030a0:	c15fd0ef          	jal	80000cb4 <memset>
  log_write(bp);
    800030a4:	854a                	mv	a0,s2
    800030a6:	7fb000ef          	jal	800040a0 <log_write>
  brelse(bp);
    800030aa:	854a                	mv	a0,s2
    800030ac:	e3dff0ef          	jal	80002ee8 <brelse>
        return b + bi;
    800030b0:	7942                	ld	s2,48(sp)
    800030b2:	79a2                	ld	s3,40(sp)
    800030b4:	7a02                	ld	s4,32(sp)
    800030b6:	6ae2                	ld	s5,24(sp)
    800030b8:	6b42                	ld	s6,16(sp)
    800030ba:	6ba2                	ld	s7,8(sp)
    800030bc:	6c02                	ld	s8,0(sp)
}
    800030be:	8526                	mv	a0,s1
    800030c0:	60a6                	ld	ra,72(sp)
    800030c2:	6406                	ld	s0,64(sp)
    800030c4:	74e2                	ld	s1,56(sp)
    800030c6:	6161                	addi	sp,sp,80
    800030c8:	8082                	ret
    brelse(bp);
    800030ca:	854a                	mv	a0,s2
    800030cc:	e1dff0ef          	jal	80002ee8 <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    800030d0:	015c0abb          	addw	s5,s8,s5
    800030d4:	004b2783          	lw	a5,4(s6)
    800030d8:	04faf863          	bgeu	s5,a5,80003128 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    800030dc:	40dad59b          	sraiw	a1,s5,0xd
    800030e0:	01cb2783          	lw	a5,28(s6)
    800030e4:	9dbd                	addw	a1,a1,a5
    800030e6:	855e                	mv	a0,s7
    800030e8:	cf9ff0ef          	jal	80002de0 <bread>
    800030ec:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800030ee:	004b2503          	lw	a0,4(s6)
    800030f2:	84d6                	mv	s1,s5
    800030f4:	4701                	li	a4,0
    800030f6:	fca4fae3          	bgeu	s1,a0,800030ca <balloc+0x8a>
      m = 1 << (bi % 8);
    800030fa:	00777693          	andi	a3,a4,7
    800030fe:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) { // Is block free?
    80003102:	41f7579b          	sraiw	a5,a4,0x1f
    80003106:	01d7d79b          	srliw	a5,a5,0x1d
    8000310a:	9fb9                	addw	a5,a5,a4
    8000310c:	4037d79b          	sraiw	a5,a5,0x3
    80003110:	00f90633          	add	a2,s2,a5
    80003114:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    80003118:	00c6f5b3          	and	a1,a3,a2
    8000311c:	ddb1                	beqz	a1,80003078 <balloc+0x38>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    8000311e:	2705                	addiw	a4,a4,1
    80003120:	2485                	addiw	s1,s1,1
    80003122:	fd471ae3          	bne	a4,s4,800030f6 <balloc+0xb6>
    80003126:	b755                	j	800030ca <balloc+0x8a>
    80003128:	7942                	ld	s2,48(sp)
    8000312a:	79a2                	ld	s3,40(sp)
    8000312c:	7a02                	ld	s4,32(sp)
    8000312e:	6ae2                	ld	s5,24(sp)
    80003130:	6b42                	ld	s6,16(sp)
    80003132:	6ba2                	ld	s7,8(sp)
    80003134:	6c02                	ld	s8,0(sp)
  printk("balloc: out of blocks\n");
    80003136:	00004517          	auipc	a0,0x4
    8000313a:	3e250513          	addi	a0,a0,994 # 80007518 <etext+0x518>
    8000313e:	bd2fd0ef          	jal	80000510 <printk>
  return 0;
    80003142:	4481                	li	s1,0
    80003144:	bfad                	j	800030be <balloc+0x7e>

0000000080003146 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003146:	7179                	addi	sp,sp,-48
    80003148:	f406                	sd	ra,40(sp)
    8000314a:	f022                	sd	s0,32(sp)
    8000314c:	ec26                	sd	s1,24(sp)
    8000314e:	e84a                	sd	s2,16(sp)
    80003150:	e44e                	sd	s3,8(sp)
    80003152:	1800                	addi	s0,sp,48
    80003154:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    80003156:	47ad                	li	a5,11
    80003158:	02b7e363          	bltu	a5,a1,8000317e <bmap+0x38>
    if ((addr = ip->addrs[bn]) == 0) {
    8000315c:	02059793          	slli	a5,a1,0x20
    80003160:	01e7d593          	srli	a1,a5,0x1e
    80003164:	00b509b3          	add	s3,a0,a1
    80003168:	0509a483          	lw	s1,80(s3)
    8000316c:	e0b5                	bnez	s1,800031d0 <bmap+0x8a>
      addr = balloc(ip->dev);
    8000316e:	4108                	lw	a0,0(a0)
    80003170:	ed1ff0ef          	jal	80003040 <balloc>
    80003174:	84aa                	mv	s1,a0
      if (addr == 0)
    80003176:	cd29                	beqz	a0,800031d0 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80003178:	04a9a823          	sw	a0,80(s3)
    8000317c:	a891                	j	800031d0 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000317e:	ff45879b          	addiw	a5,a1,-12
    80003182:	873e                	mv	a4,a5
    80003184:	89be                	mv	s3,a5

  if (bn < NINDIRECT) {
    80003186:	0ff00793          	li	a5,255
    8000318a:	06e7e763          	bltu	a5,a4,800031f8 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    8000318e:	08052483          	lw	s1,128(a0)
    80003192:	e891                	bnez	s1,800031a6 <bmap+0x60>
      addr = balloc(ip->dev);
    80003194:	4108                	lw	a0,0(a0)
    80003196:	eabff0ef          	jal	80003040 <balloc>
    8000319a:	84aa                	mv	s1,a0
      if (addr == 0)
    8000319c:	c915                	beqz	a0,800031d0 <bmap+0x8a>
    8000319e:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800031a0:	08a92023          	sw	a0,128(s2)
    800031a4:	a011                	j	800031a8 <bmap+0x62>
    800031a6:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800031a8:	85a6                	mv	a1,s1
    800031aa:	00092503          	lw	a0,0(s2)
    800031ae:	c33ff0ef          	jal	80002de0 <bread>
    800031b2:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    800031b4:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    800031b8:	02099713          	slli	a4,s3,0x20
    800031bc:	01e75593          	srli	a1,a4,0x1e
    800031c0:	97ae                	add	a5,a5,a1
    800031c2:	89be                	mv	s3,a5
    800031c4:	4384                	lw	s1,0(a5)
    800031c6:	cc89                	beqz	s1,800031e0 <bmap+0x9a>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800031c8:	8552                	mv	a0,s4
    800031ca:	d1fff0ef          	jal	80002ee8 <brelse>
    return addr;
    800031ce:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800031d0:	8526                	mv	a0,s1
    800031d2:	70a2                	ld	ra,40(sp)
    800031d4:	7402                	ld	s0,32(sp)
    800031d6:	64e2                	ld	s1,24(sp)
    800031d8:	6942                	ld	s2,16(sp)
    800031da:	69a2                	ld	s3,8(sp)
    800031dc:	6145                	addi	sp,sp,48
    800031de:	8082                	ret
      addr = balloc(ip->dev);
    800031e0:	00092503          	lw	a0,0(s2)
    800031e4:	e5dff0ef          	jal	80003040 <balloc>
    800031e8:	84aa                	mv	s1,a0
      if (addr) {
    800031ea:	dd79                	beqz	a0,800031c8 <bmap+0x82>
        a[bn] = addr;
    800031ec:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    800031f0:	8552                	mv	a0,s4
    800031f2:	6af000ef          	jal	800040a0 <log_write>
    800031f6:	bfc9                	j	800031c8 <bmap+0x82>
    800031f8:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800031fa:	00004517          	auipc	a0,0x4
    800031fe:	33650513          	addi	a0,a0,822 # 80007530 <etext+0x530>
    80003202:	e46fd0ef          	jal	80000848 <panic>

0000000080003206 <iget>:
{
    80003206:	7179                	addi	sp,sp,-48
    80003208:	f406                	sd	ra,40(sp)
    8000320a:	f022                	sd	s0,32(sp)
    8000320c:	ec26                	sd	s1,24(sp)
    8000320e:	e84a                	sd	s2,16(sp)
    80003210:	e44e                	sd	s3,8(sp)
    80003212:	e052                	sd	s4,0(sp)
    80003214:	1800                	addi	s0,sp,48
    80003216:	89aa                	mv	s3,a0
    80003218:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000321a:	0001e517          	auipc	a0,0x1e
    8000321e:	e4e50513          	addi	a0,a0,-434 # 80021068 <itable>
    80003222:	9d7fd0ef          	jal	80000bf8 <acquire>
  empty = 0;
    80003226:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80003228:	0001e497          	auipc	s1,0x1e
    8000322c:	e5848493          	addi	s1,s1,-424 # 80021080 <itable+0x18>
    80003230:	00020697          	auipc	a3,0x20
    80003234:	8e068693          	addi	a3,a3,-1824 # 80022b10 <log>
    80003238:	a819                	j	8000324e <iget+0x48>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    8000323a:	0017b793          	seqz	a5,a5
    8000323e:	00193713          	seqz	a4,s2
    80003242:	8ff9                	and	a5,a5,a4
    80003244:	eb85                	bnez	a5,80003274 <iget+0x6e>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80003246:	08848493          	addi	s1,s1,136
    8000324a:	02d48763          	beq	s1,a3,80003278 <iget+0x72>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    8000324e:	449c                	lw	a5,8(s1)
    80003250:	fef055e3          	blez	a5,8000323a <iget+0x34>
    80003254:	4098                	lw	a4,0(s1)
    80003256:	ff3718e3          	bne	a4,s3,80003246 <iget+0x40>
    8000325a:	40d8                	lw	a4,4(s1)
    8000325c:	ff4715e3          	bne	a4,s4,80003246 <iget+0x40>
      ip->ref++;
    80003260:	2785                	addiw	a5,a5,1
    80003262:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003264:	0001e517          	auipc	a0,0x1e
    80003268:	e0450513          	addi	a0,a0,-508 # 80021068 <itable>
    8000326c:	a11fd0ef          	jal	80000c7c <release>
      return ip;
    80003270:	8926                	mv	s2,s1
    80003272:	a025                	j	8000329a <iget+0x94>
      empty = ip;
    80003274:	8926                	mv	s2,s1
    80003276:	bfc1                	j	80003246 <iget+0x40>
  if (empty == 0)
    80003278:	02090a63          	beqz	s2,800032ac <iget+0xa6>
  ip->dev = dev;
    8000327c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003280:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003284:	4785                	li	a5,1
    80003286:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000328a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000328e:	0001e517          	auipc	a0,0x1e
    80003292:	dda50513          	addi	a0,a0,-550 # 80021068 <itable>
    80003296:	9e7fd0ef          	jal	80000c7c <release>
}
    8000329a:	854a                	mv	a0,s2
    8000329c:	70a2                	ld	ra,40(sp)
    8000329e:	7402                	ld	s0,32(sp)
    800032a0:	64e2                	ld	s1,24(sp)
    800032a2:	6942                	ld	s2,16(sp)
    800032a4:	69a2                	ld	s3,8(sp)
    800032a6:	6a02                	ld	s4,0(sp)
    800032a8:	6145                	addi	sp,sp,48
    800032aa:	8082                	ret
    panic("iget: no inodes");
    800032ac:	00004517          	auipc	a0,0x4
    800032b0:	29c50513          	addi	a0,a0,668 # 80007548 <etext+0x548>
    800032b4:	d94fd0ef          	jal	80000848 <panic>

00000000800032b8 <iinit>:
{
    800032b8:	7179                	addi	sp,sp,-48
    800032ba:	f406                	sd	ra,40(sp)
    800032bc:	f022                	sd	s0,32(sp)
    800032be:	ec26                	sd	s1,24(sp)
    800032c0:	e84a                	sd	s2,16(sp)
    800032c2:	e44e                	sd	s3,8(sp)
    800032c4:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800032c6:	00004597          	auipc	a1,0x4
    800032ca:	29258593          	addi	a1,a1,658 # 80007558 <etext+0x558>
    800032ce:	0001e517          	auipc	a0,0x1e
    800032d2:	d9a50513          	addi	a0,a0,-614 # 80021068 <itable>
    800032d6:	8a3fd0ef          	jal	80000b78 <initlock>
  for (i = 0; i < NINODE; i++) {
    800032da:	0001e497          	auipc	s1,0x1e
    800032de:	db648493          	addi	s1,s1,-586 # 80021090 <itable+0x28>
    800032e2:	00020997          	auipc	s3,0x20
    800032e6:	83e98993          	addi	s3,s3,-1986 # 80022b20 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800032ea:	00004917          	auipc	s2,0x4
    800032ee:	27690913          	addi	s2,s2,630 # 80007560 <etext+0x560>
    800032f2:	85ca                	mv	a1,s2
    800032f4:	8526                	mv	a0,s1
    800032f6:	6df000ef          	jal	800041d4 <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    800032fa:	08848493          	addi	s1,s1,136
    800032fe:	ff349ae3          	bne	s1,s3,800032f2 <iinit+0x3a>
}
    80003302:	70a2                	ld	ra,40(sp)
    80003304:	7402                	ld	s0,32(sp)
    80003306:	64e2                	ld	s1,24(sp)
    80003308:	6942                	ld	s2,16(sp)
    8000330a:	69a2                	ld	s3,8(sp)
    8000330c:	6145                	addi	sp,sp,48
    8000330e:	8082                	ret

0000000080003310 <ialloc>:
{
    80003310:	7139                	addi	sp,sp,-64
    80003312:	fc06                	sd	ra,56(sp)
    80003314:	f822                	sd	s0,48(sp)
    80003316:	0080                	addi	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++) {
    80003318:	0001e717          	auipc	a4,0x1e
    8000331c:	d3c72703          	lw	a4,-708(a4) # 80021054 <sb+0xc>
    80003320:	4785                	li	a5,1
    80003322:	06e7f063          	bgeu	a5,a4,80003382 <ialloc+0x72>
    80003326:	f426                	sd	s1,40(sp)
    80003328:	f04a                	sd	s2,32(sp)
    8000332a:	ec4e                	sd	s3,24(sp)
    8000332c:	e852                	sd	s4,16(sp)
    8000332e:	e456                	sd	s5,8(sp)
    80003330:	e05a                	sd	s6,0(sp)
    80003332:	8aaa                	mv	s5,a0
    80003334:	8b2e                	mv	s6,a1
    80003336:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003338:	0001ea17          	auipc	s4,0x1e
    8000333c:	d10a0a13          	addi	s4,s4,-752 # 80021048 <sb>
    80003340:	00495593          	srli	a1,s2,0x4
    80003344:	018a2783          	lw	a5,24(s4)
    80003348:	9dbd                	addw	a1,a1,a5
    8000334a:	8556                	mv	a0,s5
    8000334c:	a95ff0ef          	jal	80002de0 <bread>
    80003350:	84aa                	mv	s1,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    80003352:	05850993          	addi	s3,a0,88
    80003356:	00f97793          	andi	a5,s2,15
    8000335a:	079a                	slli	a5,a5,0x6
    8000335c:	99be                	add	s3,s3,a5
    if (dip->type == 0) { // a free inode
    8000335e:	00099783          	lh	a5,0(s3)
    80003362:	cb9d                	beqz	a5,80003398 <ialloc+0x88>
    brelse(bp);
    80003364:	b85ff0ef          	jal	80002ee8 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    80003368:	0905                	addi	s2,s2,1
    8000336a:	00ca2703          	lw	a4,12(s4)
    8000336e:	0009079b          	sext.w	a5,s2
    80003372:	fce7e7e3          	bltu	a5,a4,80003340 <ialloc+0x30>
    80003376:	74a2                	ld	s1,40(sp)
    80003378:	7902                	ld	s2,32(sp)
    8000337a:	69e2                	ld	s3,24(sp)
    8000337c:	6a42                	ld	s4,16(sp)
    8000337e:	6aa2                	ld	s5,8(sp)
    80003380:	6b02                	ld	s6,0(sp)
  printk("ialloc: no inodes\n");
    80003382:	00004517          	auipc	a0,0x4
    80003386:	1e650513          	addi	a0,a0,486 # 80007568 <etext+0x568>
    8000338a:	986fd0ef          	jal	80000510 <printk>
  return 0;
    8000338e:	4501                	li	a0,0
}
    80003390:	70e2                	ld	ra,56(sp)
    80003392:	7442                	ld	s0,48(sp)
    80003394:	6121                	addi	sp,sp,64
    80003396:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003398:	04000613          	li	a2,64
    8000339c:	4581                	li	a1,0
    8000339e:	854e                	mv	a0,s3
    800033a0:	915fd0ef          	jal	80000cb4 <memset>
      dip->type = type;
    800033a4:	01699023          	sh	s6,0(s3)
      log_write(bp); // mark it allocated on the disk
    800033a8:	8526                	mv	a0,s1
    800033aa:	4f7000ef          	jal	800040a0 <log_write>
      brelse(bp);
    800033ae:	8526                	mv	a0,s1
    800033b0:	b39ff0ef          	jal	80002ee8 <brelse>
      return iget(dev, inum);
    800033b4:	0009059b          	sext.w	a1,s2
    800033b8:	8556                	mv	a0,s5
    800033ba:	e4dff0ef          	jal	80003206 <iget>
    800033be:	74a2                	ld	s1,40(sp)
    800033c0:	7902                	ld	s2,32(sp)
    800033c2:	69e2                	ld	s3,24(sp)
    800033c4:	6a42                	ld	s4,16(sp)
    800033c6:	6aa2                	ld	s5,8(sp)
    800033c8:	6b02                	ld	s6,0(sp)
    800033ca:	b7d9                	j	80003390 <ialloc+0x80>

00000000800033cc <iupdate>:
{
    800033cc:	1101                	addi	sp,sp,-32
    800033ce:	ec06                	sd	ra,24(sp)
    800033d0:	e822                	sd	s0,16(sp)
    800033d2:	e426                	sd	s1,8(sp)
    800033d4:	e04a                	sd	s2,0(sp)
    800033d6:	1000                	addi	s0,sp,32
    800033d8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800033da:	415c                	lw	a5,4(a0)
    800033dc:	0047d79b          	srliw	a5,a5,0x4
    800033e0:	0001e597          	auipc	a1,0x1e
    800033e4:	c805a583          	lw	a1,-896(a1) # 80021060 <sb+0x18>
    800033e8:	9dbd                	addw	a1,a1,a5
    800033ea:	4108                	lw	a0,0(a0)
    800033ec:	9f5ff0ef          	jal	80002de0 <bread>
    800033f0:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    800033f2:	05850793          	addi	a5,a0,88
    800033f6:	40d8                	lw	a4,4(s1)
    800033f8:	8b3d                	andi	a4,a4,15
    800033fa:	071a                	slli	a4,a4,0x6
    800033fc:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800033fe:	04449703          	lh	a4,68(s1)
    80003402:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003406:	04649703          	lh	a4,70(s1)
    8000340a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000340e:	04849703          	lh	a4,72(s1)
    80003412:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003416:	04a49703          	lh	a4,74(s1)
    8000341a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000341e:	44f8                	lw	a4,76(s1)
    80003420:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003422:	03400613          	li	a2,52
    80003426:	05048593          	addi	a1,s1,80
    8000342a:	00c78513          	addi	a0,a5,12
    8000342e:	8e3fd0ef          	jal	80000d10 <memmove>
  log_write(bp);
    80003432:	854a                	mv	a0,s2
    80003434:	46d000ef          	jal	800040a0 <log_write>
  brelse(bp);
    80003438:	854a                	mv	a0,s2
    8000343a:	aafff0ef          	jal	80002ee8 <brelse>
}
    8000343e:	60e2                	ld	ra,24(sp)
    80003440:	6442                	ld	s0,16(sp)
    80003442:	64a2                	ld	s1,8(sp)
    80003444:	6902                	ld	s2,0(sp)
    80003446:	6105                	addi	sp,sp,32
    80003448:	8082                	ret

000000008000344a <idup>:
{
    8000344a:	1101                	addi	sp,sp,-32
    8000344c:	ec06                	sd	ra,24(sp)
    8000344e:	e822                	sd	s0,16(sp)
    80003450:	e426                	sd	s1,8(sp)
    80003452:	1000                	addi	s0,sp,32
    80003454:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003456:	0001e517          	auipc	a0,0x1e
    8000345a:	c1250513          	addi	a0,a0,-1006 # 80021068 <itable>
    8000345e:	f9afd0ef          	jal	80000bf8 <acquire>
  ip->ref++;
    80003462:	449c                	lw	a5,8(s1)
    80003464:	2785                	addiw	a5,a5,1
    80003466:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003468:	0001e517          	auipc	a0,0x1e
    8000346c:	c0050513          	addi	a0,a0,-1024 # 80021068 <itable>
    80003470:	80dfd0ef          	jal	80000c7c <release>
}
    80003474:	8526                	mv	a0,s1
    80003476:	60e2                	ld	ra,24(sp)
    80003478:	6442                	ld	s0,16(sp)
    8000347a:	64a2                	ld	s1,8(sp)
    8000347c:	6105                	addi	sp,sp,32
    8000347e:	8082                	ret

0000000080003480 <ilock>:
{
    80003480:	1101                	addi	sp,sp,-32
    80003482:	ec06                	sd	ra,24(sp)
    80003484:	e822                	sd	s0,16(sp)
    80003486:	e426                	sd	s1,8(sp)
    80003488:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1)
    8000348a:	cd19                	beqz	a0,800034a8 <ilock+0x28>
    8000348c:	84aa                	mv	s1,a0
    8000348e:	451c                	lw	a5,8(a0)
    80003490:	00f05c63          	blez	a5,800034a8 <ilock+0x28>
  acquiresleep(&ip->lock);
    80003494:	0541                	addi	a0,a0,16
    80003496:	575000ef          	jal	8000420a <acquiresleep>
  if (ip->valid == 0) {
    8000349a:	40bc                	lw	a5,64(s1)
    8000349c:	cf89                	beqz	a5,800034b6 <ilock+0x36>
}
    8000349e:	60e2                	ld	ra,24(sp)
    800034a0:	6442                	ld	s0,16(sp)
    800034a2:	64a2                	ld	s1,8(sp)
    800034a4:	6105                	addi	sp,sp,32
    800034a6:	8082                	ret
    800034a8:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800034aa:	00004517          	auipc	a0,0x4
    800034ae:	0d650513          	addi	a0,a0,214 # 80007580 <etext+0x580>
    800034b2:	b96fd0ef          	jal	80000848 <panic>
    800034b6:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800034b8:	40dc                	lw	a5,4(s1)
    800034ba:	0047d79b          	srliw	a5,a5,0x4
    800034be:	0001e597          	auipc	a1,0x1e
    800034c2:	ba25a583          	lw	a1,-1118(a1) # 80021060 <sb+0x18>
    800034c6:	9dbd                	addw	a1,a1,a5
    800034c8:	4088                	lw	a0,0(s1)
    800034ca:	917ff0ef          	jal	80002de0 <bread>
    800034ce:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    800034d0:	05850593          	addi	a1,a0,88
    800034d4:	40dc                	lw	a5,4(s1)
    800034d6:	8bbd                	andi	a5,a5,15
    800034d8:	079a                	slli	a5,a5,0x6
    800034da:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800034dc:	00059783          	lh	a5,0(a1)
    800034e0:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800034e4:	00259783          	lh	a5,2(a1)
    800034e8:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800034ec:	00459783          	lh	a5,4(a1)
    800034f0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800034f4:	00659783          	lh	a5,6(a1)
    800034f8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800034fc:	459c                	lw	a5,8(a1)
    800034fe:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003500:	03400613          	li	a2,52
    80003504:	05b1                	addi	a1,a1,12
    80003506:	05048513          	addi	a0,s1,80
    8000350a:	807fd0ef          	jal	80000d10 <memmove>
    brelse(bp);
    8000350e:	854a                	mv	a0,s2
    80003510:	9d9ff0ef          	jal	80002ee8 <brelse>
    ip->valid = 1;
    80003514:	4785                	li	a5,1
    80003516:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0)
    80003518:	04449783          	lh	a5,68(s1)
    8000351c:	c399                	beqz	a5,80003522 <ilock+0xa2>
    8000351e:	6902                	ld	s2,0(sp)
    80003520:	bfbd                	j	8000349e <ilock+0x1e>
      panic("ilock: no type");
    80003522:	00004517          	auipc	a0,0x4
    80003526:	06650513          	addi	a0,a0,102 # 80007588 <etext+0x588>
    8000352a:	b1efd0ef          	jal	80000848 <panic>

000000008000352e <iunlock>:
{
    8000352e:	1101                	addi	sp,sp,-32
    80003530:	ec06                	sd	ra,24(sp)
    80003532:	e822                	sd	s0,16(sp)
    80003534:	e426                	sd	s1,8(sp)
    80003536:	e04a                	sd	s2,0(sp)
    80003538:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000353a:	c505                	beqz	a0,80003562 <iunlock+0x34>
    8000353c:	84aa                	mv	s1,a0
    8000353e:	01050913          	addi	s2,a0,16
    80003542:	854a                	mv	a0,s2
    80003544:	553000ef          	jal	80004296 <holdingsleep>
    80003548:	cd09                	beqz	a0,80003562 <iunlock+0x34>
    8000354a:	449c                	lw	a5,8(s1)
    8000354c:	00f05b63          	blez	a5,80003562 <iunlock+0x34>
  releasesleep(&ip->lock);
    80003550:	854a                	mv	a0,s2
    80003552:	50d000ef          	jal	8000425e <releasesleep>
}
    80003556:	60e2                	ld	ra,24(sp)
    80003558:	6442                	ld	s0,16(sp)
    8000355a:	64a2                	ld	s1,8(sp)
    8000355c:	6902                	ld	s2,0(sp)
    8000355e:	6105                	addi	sp,sp,32
    80003560:	8082                	ret
    panic("iunlock");
    80003562:	00004517          	auipc	a0,0x4
    80003566:	03650513          	addi	a0,a0,54 # 80007598 <etext+0x598>
    8000356a:	adefd0ef          	jal	80000848 <panic>

000000008000356e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000356e:	7179                	addi	sp,sp,-48
    80003570:	f406                	sd	ra,40(sp)
    80003572:	f022                	sd	s0,32(sp)
    80003574:	ec26                	sd	s1,24(sp)
    80003576:	e84a                	sd	s2,16(sp)
    80003578:	e44e                	sd	s3,8(sp)
    8000357a:	1800                	addi	s0,sp,48
    8000357c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    8000357e:	05050493          	addi	s1,a0,80
    80003582:	08050913          	addi	s2,a0,128
    80003586:	a021                	j	8000358e <itrunc+0x20>
    80003588:	0491                	addi	s1,s1,4
    8000358a:	01248b63          	beq	s1,s2,800035a0 <itrunc+0x32>
    if (ip->addrs[i]) {
    8000358e:	408c                	lw	a1,0(s1)
    80003590:	dde5                	beqz	a1,80003588 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003592:	0009a503          	lw	a0,0(s3)
    80003596:	a3fff0ef          	jal	80002fd4 <bfree>
      ip->addrs[i] = 0;
    8000359a:	0004a023          	sw	zero,0(s1)
    8000359e:	b7ed                	j	80003588 <itrunc+0x1a>
    }
  }

  if (ip->addrs[NDIRECT]) {
    800035a0:	0809a583          	lw	a1,128(s3)
    800035a4:	ed89                	bnez	a1,800035be <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800035a6:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800035aa:	854e                	mv	a0,s3
    800035ac:	e21ff0ef          	jal	800033cc <iupdate>
}
    800035b0:	70a2                	ld	ra,40(sp)
    800035b2:	7402                	ld	s0,32(sp)
    800035b4:	64e2                	ld	s1,24(sp)
    800035b6:	6942                	ld	s2,16(sp)
    800035b8:	69a2                	ld	s3,8(sp)
    800035ba:	6145                	addi	sp,sp,48
    800035bc:	8082                	ret
    800035be:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800035c0:	0009a503          	lw	a0,0(s3)
    800035c4:	81dff0ef          	jal	80002de0 <bread>
    800035c8:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    800035ca:	05850493          	addi	s1,a0,88
    800035ce:	45850913          	addi	s2,a0,1112
    800035d2:	a021                	j	800035da <itrunc+0x6c>
    800035d4:	0491                	addi	s1,s1,4
    800035d6:	01248963          	beq	s1,s2,800035e8 <itrunc+0x7a>
      if (a[j])
    800035da:	408c                	lw	a1,0(s1)
    800035dc:	dde5                	beqz	a1,800035d4 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800035de:	0009a503          	lw	a0,0(s3)
    800035e2:	9f3ff0ef          	jal	80002fd4 <bfree>
    800035e6:	b7fd                	j	800035d4 <itrunc+0x66>
    brelse(bp);
    800035e8:	8552                	mv	a0,s4
    800035ea:	8ffff0ef          	jal	80002ee8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800035ee:	0809a583          	lw	a1,128(s3)
    800035f2:	0009a503          	lw	a0,0(s3)
    800035f6:	9dfff0ef          	jal	80002fd4 <bfree>
    ip->addrs[NDIRECT] = 0;
    800035fa:	0809a023          	sw	zero,128(s3)
    800035fe:	6a02                	ld	s4,0(sp)
    80003600:	b75d                	j	800035a6 <itrunc+0x38>

0000000080003602 <iput>:
{
    80003602:	7179                	addi	sp,sp,-48
    80003604:	f406                	sd	ra,40(sp)
    80003606:	f022                	sd	s0,32(sp)
    80003608:	ec26                	sd	s1,24(sp)
    8000360a:	1800                	addi	s0,sp,48
    8000360c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000360e:	0001e517          	auipc	a0,0x1e
    80003612:	a5a50513          	addi	a0,a0,-1446 # 80021068 <itable>
    80003616:	de2fd0ef          	jal	80000bf8 <acquire>
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    8000361a:	449c                	lw	a5,8(s1)
    8000361c:	4705                	li	a4,1
    8000361e:	00e78f63          	beq	a5,a4,8000363c <iput+0x3a>
  ip->ref--;
    80003622:	37fd                	addiw	a5,a5,-1
    80003624:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003626:	0001e517          	auipc	a0,0x1e
    8000362a:	a4250513          	addi	a0,a0,-1470 # 80021068 <itable>
    8000362e:	e4efd0ef          	jal	80000c7c <release>
}
    80003632:	70a2                	ld	ra,40(sp)
    80003634:	7402                	ld	s0,32(sp)
    80003636:	64e2                	ld	s1,24(sp)
    80003638:	6145                	addi	sp,sp,48
    8000363a:	8082                	ret
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    8000363c:	40b8                	lw	a4,64(s1)
    8000363e:	d375                	beqz	a4,80003622 <iput+0x20>
    80003640:	e84a                	sd	s2,16(sp)
    80003642:	e052                	sd	s4,0(sp)
  uint dev = ip->dev, inum = ip->inum;
    80003644:	0004aa03          	lw	s4,0(s1)
    80003648:	0044a903          	lw	s2,4(s1)
  if (last) {
    8000364c:	04a49703          	lh	a4,74(s1)
    80003650:	ef3d                	bnez	a4,800036ce <iput+0xcc>
    80003652:	e44e                	sd	s3,8(sp)
    acquiresleep(&ip->lock);
    80003654:	01048793          	addi	a5,s1,16
    80003658:	89be                	mv	s3,a5
    8000365a:	853e                	mv	a0,a5
    8000365c:	3af000ef          	jal	8000420a <acquiresleep>
    release(&itable.lock);
    80003660:	0001e517          	auipc	a0,0x1e
    80003664:	a0850513          	addi	a0,a0,-1528 # 80021068 <itable>
    80003668:	e14fd0ef          	jal	80000c7c <release>
    itrunc(ip); // free the data blocks (type stays nonzero on disk)
    8000366c:	8526                	mv	a0,s1
    8000366e:	f01ff0ef          	jal	8000356e <itrunc>
    ip->valid = 0;
    80003672:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003676:	854e                	mv	a0,s3
    80003678:	3e7000ef          	jal	8000425e <releasesleep>
    acquire(&itable.lock);
    8000367c:	0001e517          	auipc	a0,0x1e
    80003680:	9ec50513          	addi	a0,a0,-1556 # 80021068 <itable>
    80003684:	d74fd0ef          	jal	80000bf8 <acquire>
  ip->ref--;
    80003688:	449c                	lw	a5,8(s1)
    8000368a:	37fd                	addiw	a5,a5,-1
    8000368c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000368e:	0001e517          	auipc	a0,0x1e
    80003692:	9da50513          	addi	a0,a0,-1574 # 80021068 <itable>
    80003696:	de6fd0ef          	jal	80000c7c <release>
  struct buf *bp = bread(dev, IBLOCK(inum, sb));
    8000369a:	0049579b          	srliw	a5,s2,0x4
    8000369e:	0001e597          	auipc	a1,0x1e
    800036a2:	9c25a583          	lw	a1,-1598(a1) # 80021060 <sb+0x18>
    800036a6:	9dbd                	addw	a1,a1,a5
    800036a8:	8552                	mv	a0,s4
    800036aa:	f36ff0ef          	jal	80002de0 <bread>
    800036ae:	84aa                	mv	s1,a0
  struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    800036b0:	00f97793          	andi	a5,s2,15
  dip->type = 0;
    800036b4:	079a                	slli	a5,a5,0x6
    800036b6:	97aa                	add	a5,a5,a0
    800036b8:	04079c23          	sh	zero,88(a5)
  log_write(bp);
    800036bc:	1e5000ef          	jal	800040a0 <log_write>
  brelse(bp);
    800036c0:	8526                	mv	a0,s1
    800036c2:	827ff0ef          	jal	80002ee8 <brelse>
}
    800036c6:	6942                	ld	s2,16(sp)
    800036c8:	69a2                	ld	s3,8(sp)
    800036ca:	6a02                	ld	s4,0(sp)
    800036cc:	b79d                	j	80003632 <iput+0x30>
    800036ce:	6942                	ld	s2,16(sp)
    800036d0:	6a02                	ld	s4,0(sp)
    800036d2:	bf81                	j	80003622 <iput+0x20>

00000000800036d4 <iunlockput>:
{
    800036d4:	1101                	addi	sp,sp,-32
    800036d6:	ec06                	sd	ra,24(sp)
    800036d8:	e822                	sd	s0,16(sp)
    800036da:	e426                	sd	s1,8(sp)
    800036dc:	1000                	addi	s0,sp,32
    800036de:	84aa                	mv	s1,a0
  iunlock(ip);
    800036e0:	e4fff0ef          	jal	8000352e <iunlock>
  iput(ip);
    800036e4:	8526                	mv	a0,s1
    800036e6:	f1dff0ef          	jal	80003602 <iput>
}
    800036ea:	60e2                	ld	ra,24(sp)
    800036ec:	6442                	ld	s0,16(sp)
    800036ee:	64a2                	ld	s1,8(sp)
    800036f0:	6105                	addi	sp,sp,32
    800036f2:	8082                	ret

00000000800036f4 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800036f4:	0001e717          	auipc	a4,0x1e
    800036f8:	96072703          	lw	a4,-1696(a4) # 80021054 <sb+0xc>
    800036fc:	4785                	li	a5,1
    800036fe:	0ae7fe63          	bgeu	a5,a4,800037ba <ireclaim+0xc6>
{
    80003702:	7139                	addi	sp,sp,-64
    80003704:	fc06                	sd	ra,56(sp)
    80003706:	f822                	sd	s0,48(sp)
    80003708:	f426                	sd	s1,40(sp)
    8000370a:	f04a                	sd	s2,32(sp)
    8000370c:	ec4e                	sd	s3,24(sp)
    8000370e:	e852                	sd	s4,16(sp)
    80003710:	e456                	sd	s5,8(sp)
    80003712:	e05a                	sd	s6,0(sp)
    80003714:	0080                	addi	s0,sp,64
    80003716:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003718:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    8000371a:	0001ea17          	auipc	s4,0x1e
    8000371e:	92ea0a13          	addi	s4,s4,-1746 # 80021048 <sb>
      printk("ireclaim: orphaned inode %d\n", inum);
    80003722:	00004b17          	auipc	s6,0x4
    80003726:	e7eb0b13          	addi	s6,s6,-386 # 800075a0 <etext+0x5a0>
    8000372a:	a099                	j	80003770 <ireclaim+0x7c>
    8000372c:	85ce                	mv	a1,s3
    8000372e:	855a                	mv	a0,s6
    80003730:	de1fc0ef          	jal	80000510 <printk>
      ip = iget(dev, inum);
    80003734:	85ce                	mv	a1,s3
    80003736:	8556                	mv	a0,s5
    80003738:	acfff0ef          	jal	80003206 <iget>
    8000373c:	89aa                	mv	s3,a0
    brelse(bp);
    8000373e:	854a                	mv	a0,s2
    80003740:	fa8ff0ef          	jal	80002ee8 <brelse>
    if (ip) {
    80003744:	00098f63          	beqz	s3,80003762 <ireclaim+0x6e>
      begin_op();
    80003748:	7aa000ef          	jal	80003ef2 <begin_op>
      ilock(ip);
    8000374c:	854e                	mv	a0,s3
    8000374e:	d33ff0ef          	jal	80003480 <ilock>
      iunlock(ip);
    80003752:	854e                	mv	a0,s3
    80003754:	ddbff0ef          	jal	8000352e <iunlock>
      iput(ip);
    80003758:	854e                	mv	a0,s3
    8000375a:	ea9ff0ef          	jal	80003602 <iput>
      end_op();
    8000375e:	021000ef          	jal	80003f7e <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003762:	0485                	addi	s1,s1,1
    80003764:	00ca2703          	lw	a4,12(s4)
    80003768:	0004879b          	sext.w	a5,s1
    8000376c:	02e7fd63          	bgeu	a5,a4,800037a6 <ireclaim+0xb2>
    80003770:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003774:	0044d593          	srli	a1,s1,0x4
    80003778:	018a2783          	lw	a5,24(s4)
    8000377c:	9dbd                	addw	a1,a1,a5
    8000377e:	8556                	mv	a0,s5
    80003780:	e60ff0ef          	jal	80002de0 <bread>
    80003784:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80003786:	05850793          	addi	a5,a0,88
    8000378a:	00f9f713          	andi	a4,s3,15
    8000378e:	071a                	slli	a4,a4,0x6
    80003790:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) { // is an orphaned inode
    80003792:	00079703          	lh	a4,0(a5)
    80003796:	c701                	beqz	a4,8000379e <ireclaim+0xaa>
    80003798:	00679783          	lh	a5,6(a5)
    8000379c:	dbc1                	beqz	a5,8000372c <ireclaim+0x38>
    brelse(bp);
    8000379e:	854a                	mv	a0,s2
    800037a0:	f48ff0ef          	jal	80002ee8 <brelse>
    if (ip) {
    800037a4:	bf7d                	j	80003762 <ireclaim+0x6e>
}
    800037a6:	70e2                	ld	ra,56(sp)
    800037a8:	7442                	ld	s0,48(sp)
    800037aa:	74a2                	ld	s1,40(sp)
    800037ac:	7902                	ld	s2,32(sp)
    800037ae:	69e2                	ld	s3,24(sp)
    800037b0:	6a42                	ld	s4,16(sp)
    800037b2:	6aa2                	ld	s5,8(sp)
    800037b4:	6b02                	ld	s6,0(sp)
    800037b6:	6121                	addi	sp,sp,64
    800037b8:	8082                	ret
    800037ba:	8082                	ret

00000000800037bc <fsinit>:
{
    800037bc:	1101                	addi	sp,sp,-32
    800037be:	ec06                	sd	ra,24(sp)
    800037c0:	e822                	sd	s0,16(sp)
    800037c2:	e426                	sd	s1,8(sp)
    800037c4:	e04a                	sd	s2,0(sp)
    800037c6:	1000                	addi	s0,sp,32
    800037c8:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800037ca:	4585                	li	a1,1
    800037cc:	e14ff0ef          	jal	80002de0 <bread>
    800037d0:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800037d2:	02000613          	li	a2,32
    800037d6:	05850593          	addi	a1,a0,88
    800037da:	0001e517          	auipc	a0,0x1e
    800037de:	86e50513          	addi	a0,a0,-1938 # 80021048 <sb>
    800037e2:	d2efd0ef          	jal	80000d10 <memmove>
  brelse(bp);
    800037e6:	8526                	mv	a0,s1
    800037e8:	f00ff0ef          	jal	80002ee8 <brelse>
  if (sb.magic != FSMAGIC)
    800037ec:	0001e717          	auipc	a4,0x1e
    800037f0:	85c72703          	lw	a4,-1956(a4) # 80021048 <sb>
    800037f4:	102037b7          	lui	a5,0x10203
    800037f8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800037fc:	02f71263          	bne	a4,a5,80003820 <fsinit+0x64>
  initlog(dev, &sb);
    80003800:	0001e597          	auipc	a1,0x1e
    80003804:	84858593          	addi	a1,a1,-1976 # 80021048 <sb>
    80003808:	854a                	mv	a0,s2
    8000380a:	666000ef          	jal	80003e70 <initlog>
  ireclaim(dev);
    8000380e:	854a                	mv	a0,s2
    80003810:	ee5ff0ef          	jal	800036f4 <ireclaim>
}
    80003814:	60e2                	ld	ra,24(sp)
    80003816:	6442                	ld	s0,16(sp)
    80003818:	64a2                	ld	s1,8(sp)
    8000381a:	6902                	ld	s2,0(sp)
    8000381c:	6105                	addi	sp,sp,32
    8000381e:	8082                	ret
    panic("invalid file system");
    80003820:	00004517          	auipc	a0,0x4
    80003824:	da050513          	addi	a0,a0,-608 # 800075c0 <etext+0x5c0>
    80003828:	820fd0ef          	jal	80000848 <panic>

000000008000382c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000382c:	1141                	addi	sp,sp,-16
    8000382e:	e406                	sd	ra,8(sp)
    80003830:	e022                	sd	s0,0(sp)
    80003832:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003834:	411c                	lw	a5,0(a0)
    80003836:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003838:	415c                	lw	a5,4(a0)
    8000383a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000383c:	04451783          	lh	a5,68(a0)
    80003840:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003844:	04a51783          	lh	a5,74(a0)
    80003848:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000384c:	04c56783          	lwu	a5,76(a0)
    80003850:	e99c                	sd	a5,16(a1)
}
    80003852:	60a2                	ld	ra,8(sp)
    80003854:	6402                	ld	s0,0(sp)
    80003856:	0141                	addi	sp,sp,16
    80003858:	8082                	ret

000000008000385a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    8000385a:	457c                	lw	a5,76(a0)
    8000385c:	0ed7e663          	bltu	a5,a3,80003948 <readi+0xee>
{
    80003860:	7159                	addi	sp,sp,-112
    80003862:	f486                	sd	ra,104(sp)
    80003864:	f0a2                	sd	s0,96(sp)
    80003866:	eca6                	sd	s1,88(sp)
    80003868:	e0d2                	sd	s4,64(sp)
    8000386a:	fc56                	sd	s5,56(sp)
    8000386c:	f85a                	sd	s6,48(sp)
    8000386e:	f45e                	sd	s7,40(sp)
    80003870:	1880                	addi	s0,sp,112
    80003872:	8b2a                	mv	s6,a0
    80003874:	8bae                	mv	s7,a1
    80003876:	8a32                	mv	s4,a2
    80003878:	84b6                	mv	s1,a3
    8000387a:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off)
    8000387c:	9f35                	addw	a4,a4,a3
    return 0;
    8000387e:	4501                	li	a0,0
  if (off > ip->size || off + n < off)
    80003880:	0ad76b63          	bltu	a4,a3,80003936 <readi+0xdc>
    80003884:	e4ce                	sd	s3,72(sp)
  if (off + n > ip->size)
    80003886:	00e7f463          	bgeu	a5,a4,8000388e <readi+0x34>
    n = ip->size - off;
    8000388a:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    8000388e:	080a8b63          	beqz	s5,80003924 <readi+0xca>
    80003892:	e8ca                	sd	s2,80(sp)
    80003894:	f062                	sd	s8,32(sp)
    80003896:	ec66                	sd	s9,24(sp)
    80003898:	e86a                	sd	s10,16(sp)
    8000389a:	e46e                	sd	s11,8(sp)
    8000389c:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    8000389e:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800038a2:	5c7d                	li	s8,-1
    800038a4:	a80d                	j	800038d6 <readi+0x7c>
    800038a6:	020d1d93          	slli	s11,s10,0x20
    800038aa:	020ddd93          	srli	s11,s11,0x20
    800038ae:	05890613          	addi	a2,s2,88
    800038b2:	86ee                	mv	a3,s11
    800038b4:	963e                	add	a2,a2,a5
    800038b6:	85d2                	mv	a1,s4
    800038b8:	855e                	mv	a0,s7
    800038ba:	b67fe0ef          	jal	80002420 <either_copyout>
    800038be:	05850363          	beq	a0,s8,80003904 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800038c2:	854a                	mv	a0,s2
    800038c4:	e24ff0ef          	jal	80002ee8 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    800038c8:	013d09bb          	addw	s3,s10,s3
    800038cc:	009d04bb          	addw	s1,s10,s1
    800038d0:	9a6e                	add	s4,s4,s11
    800038d2:	0559f363          	bgeu	s3,s5,80003918 <readi+0xbe>
    uint addr = bmap(ip, off / BSIZE);
    800038d6:	00a4d59b          	srliw	a1,s1,0xa
    800038da:	855a                	mv	a0,s6
    800038dc:	86bff0ef          	jal	80003146 <bmap>
    800038e0:	85aa                	mv	a1,a0
    if (addr == 0)
    800038e2:	c139                	beqz	a0,80003928 <readi+0xce>
    bp = bread(ip->dev, addr);
    800038e4:	000b2503          	lw	a0,0(s6)
    800038e8:	cf8ff0ef          	jal	80002de0 <bread>
    800038ec:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    800038ee:	3ff4f793          	andi	a5,s1,1023
    800038f2:	40fc873b          	subw	a4,s9,a5
    800038f6:	413a86bb          	subw	a3,s5,s3
    800038fa:	8d3a                	mv	s10,a4
    800038fc:	fae6f5e3          	bgeu	a3,a4,800038a6 <readi+0x4c>
    80003900:	8d36                	mv	s10,a3
    80003902:	b755                	j	800038a6 <readi+0x4c>
      brelse(bp);
    80003904:	854a                	mv	a0,s2
    80003906:	de2ff0ef          	jal	80002ee8 <brelse>
      tot = -1;
    8000390a:	59fd                	li	s3,-1
      break;
    8000390c:	6946                	ld	s2,80(sp)
    8000390e:	7c02                	ld	s8,32(sp)
    80003910:	6ce2                	ld	s9,24(sp)
    80003912:	6d42                	ld	s10,16(sp)
    80003914:	6da2                	ld	s11,8(sp)
    80003916:	a831                	j	80003932 <readi+0xd8>
    80003918:	6946                	ld	s2,80(sp)
    8000391a:	7c02                	ld	s8,32(sp)
    8000391c:	6ce2                	ld	s9,24(sp)
    8000391e:	6d42                	ld	s10,16(sp)
    80003920:	6da2                	ld	s11,8(sp)
    80003922:	a801                	j	80003932 <readi+0xd8>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003924:	89d6                	mv	s3,s5
    80003926:	a031                	j	80003932 <readi+0xd8>
    80003928:	6946                	ld	s2,80(sp)
    8000392a:	7c02                	ld	s8,32(sp)
    8000392c:	6ce2                	ld	s9,24(sp)
    8000392e:	6d42                	ld	s10,16(sp)
    80003930:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003932:	854e                	mv	a0,s3
    80003934:	69a6                	ld	s3,72(sp)
}
    80003936:	70a6                	ld	ra,104(sp)
    80003938:	7406                	ld	s0,96(sp)
    8000393a:	64e6                	ld	s1,88(sp)
    8000393c:	6a06                	ld	s4,64(sp)
    8000393e:	7ae2                	ld	s5,56(sp)
    80003940:	7b42                	ld	s6,48(sp)
    80003942:	7ba2                	ld	s7,40(sp)
    80003944:	6165                	addi	sp,sp,112
    80003946:	8082                	ret
    return 0;
    80003948:	4501                	li	a0,0
}
    8000394a:	8082                	ret

000000008000394c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    8000394c:	457c                	lw	a5,76(a0)
    8000394e:	10d7e163          	bltu	a5,a3,80003a50 <writei+0x104>
{
    80003952:	7159                	addi	sp,sp,-112
    80003954:	f486                	sd	ra,104(sp)
    80003956:	f0a2                	sd	s0,96(sp)
    80003958:	e8ca                	sd	s2,80(sp)
    8000395a:	e0d2                	sd	s4,64(sp)
    8000395c:	fc56                	sd	s5,56(sp)
    8000395e:	f85a                	sd	s6,48(sp)
    80003960:	f45e                	sd	s7,40(sp)
    80003962:	1880                	addi	s0,sp,112
    80003964:	8aaa                	mv	s5,a0
    80003966:	8bae                	mv	s7,a1
    80003968:	8a32                	mv	s4,a2
    8000396a:	8936                	mv	s2,a3
    8000396c:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    8000396e:	9f35                	addw	a4,a4,a3
    return -1;
  if (off + n > MAXFILE * BSIZE)
    80003970:	000437b7          	lui	a5,0x43
    80003974:	00e7b7b3          	sltu	a5,a5,a4
  if (off > ip->size || off + n < off)
    80003978:	00d73733          	sltu	a4,a4,a3
  if (off + n > MAXFILE * BSIZE)
    8000397c:	8fd9                	or	a5,a5,a4
    8000397e:	ef91                	bnez	a5,8000399a <writei+0x4e>
    80003980:	e4ce                	sd	s3,72(sp)
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003982:	0a0b0f63          	beqz	s6,80003a40 <writei+0xf4>
    80003986:	eca6                	sd	s1,88(sp)
    80003988:	f062                	sd	s8,32(sp)
    8000398a:	ec66                	sd	s9,24(sp)
    8000398c:	e86a                	sd	s10,16(sp)
    8000398e:	e46e                	sd	s11,8(sp)
    80003990:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003992:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003996:	5c7d                	li	s8,-1
    80003998:	a835                	j	800039d4 <writei+0x88>
    return -1;
    8000399a:	557d                	li	a0,-1
    8000399c:	a849                	j	80003a2e <writei+0xe2>
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000399e:	020d1d93          	slli	s11,s10,0x20
    800039a2:	020ddd93          	srli	s11,s11,0x20
    800039a6:	05848513          	addi	a0,s1,88
    800039aa:	86ee                	mv	a3,s11
    800039ac:	8652                	mv	a2,s4
    800039ae:	85de                	mv	a1,s7
    800039b0:	953e                	add	a0,a0,a5
    800039b2:	abbfe0ef          	jal	8000246c <either_copyin>
    800039b6:	05850663          	beq	a0,s8,80003a02 <writei+0xb6>
      // Might have partially updated the block, so we need to log it.
      log_write(bp);
      brelse(bp);
      break;
    }
    log_write(bp);
    800039ba:	8526                	mv	a0,s1
    800039bc:	6e4000ef          	jal	800040a0 <log_write>
    brelse(bp);
    800039c0:	8526                	mv	a0,s1
    800039c2:	d26ff0ef          	jal	80002ee8 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800039c6:	013d09bb          	addw	s3,s10,s3
    800039ca:	012d093b          	addw	s2,s10,s2
    800039ce:	9a6e                	add	s4,s4,s11
    800039d0:	0369ff63          	bgeu	s3,s6,80003a0e <writei+0xc2>
    uint addr = bmap(ip, off / BSIZE);
    800039d4:	00a9559b          	srliw	a1,s2,0xa
    800039d8:	8556                	mv	a0,s5
    800039da:	f6cff0ef          	jal	80003146 <bmap>
    800039de:	85aa                	mv	a1,a0
    if (addr == 0)
    800039e0:	c51d                	beqz	a0,80003a0e <writei+0xc2>
    bp = bread(ip->dev, addr);
    800039e2:	000aa503          	lw	a0,0(s5)
    800039e6:	bfaff0ef          	jal	80002de0 <bread>
    800039ea:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    800039ec:	3ff97793          	andi	a5,s2,1023
    800039f0:	40fc873b          	subw	a4,s9,a5
    800039f4:	413b06bb          	subw	a3,s6,s3
    800039f8:	8d3a                	mv	s10,a4
    800039fa:	fae6f2e3          	bgeu	a3,a4,8000399e <writei+0x52>
    800039fe:	8d36                	mv	s10,a3
    80003a00:	bf79                	j	8000399e <writei+0x52>
      log_write(bp);
    80003a02:	8526                	mv	a0,s1
    80003a04:	69c000ef          	jal	800040a0 <log_write>
      brelse(bp);
    80003a08:	8526                	mv	a0,s1
    80003a0a:	cdeff0ef          	jal	80002ee8 <brelse>
  }

  if (off > ip->size)
    80003a0e:	04caa783          	lw	a5,76(s5)
    80003a12:	0327f963          	bgeu	a5,s2,80003a44 <writei+0xf8>
    ip->size = off;
    80003a16:	052aa623          	sw	s2,76(s5)
    80003a1a:	64e6                	ld	s1,88(sp)
    80003a1c:	7c02                	ld	s8,32(sp)
    80003a1e:	6ce2                	ld	s9,24(sp)
    80003a20:	6d42                	ld	s10,16(sp)
    80003a22:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003a24:	8556                	mv	a0,s5
    80003a26:	9a7ff0ef          	jal	800033cc <iupdate>

  return tot;
    80003a2a:	854e                	mv	a0,s3
    80003a2c:	69a6                	ld	s3,72(sp)
}
    80003a2e:	70a6                	ld	ra,104(sp)
    80003a30:	7406                	ld	s0,96(sp)
    80003a32:	6946                	ld	s2,80(sp)
    80003a34:	6a06                	ld	s4,64(sp)
    80003a36:	7ae2                	ld	s5,56(sp)
    80003a38:	7b42                	ld	s6,48(sp)
    80003a3a:	7ba2                	ld	s7,40(sp)
    80003a3c:	6165                	addi	sp,sp,112
    80003a3e:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003a40:	89da                	mv	s3,s6
    80003a42:	b7cd                	j	80003a24 <writei+0xd8>
    80003a44:	64e6                	ld	s1,88(sp)
    80003a46:	7c02                	ld	s8,32(sp)
    80003a48:	6ce2                	ld	s9,24(sp)
    80003a4a:	6d42                	ld	s10,16(sp)
    80003a4c:	6da2                	ld	s11,8(sp)
    80003a4e:	bfd9                	j	80003a24 <writei+0xd8>
    return -1;
    80003a50:	557d                	li	a0,-1
}
    80003a52:	8082                	ret

0000000080003a54 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003a54:	1141                	addi	sp,sp,-16
    80003a56:	e406                	sd	ra,8(sp)
    80003a58:	e022                	sd	s0,0(sp)
    80003a5a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003a5c:	4639                	li	a2,14
    80003a5e:	b26fd0ef          	jal	80000d84 <strncmp>
}
    80003a62:	60a2                	ld	ra,8(sp)
    80003a64:	6402                	ld	s0,0(sp)
    80003a66:	0141                	addi	sp,sp,16
    80003a68:	8082                	ret

0000000080003a6a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003a6a:	711d                	addi	sp,sp,-96
    80003a6c:	ec86                	sd	ra,88(sp)
    80003a6e:	e8a2                	sd	s0,80(sp)
    80003a70:	e4a6                	sd	s1,72(sp)
    80003a72:	e0ca                	sd	s2,64(sp)
    80003a74:	fc4e                	sd	s3,56(sp)
    80003a76:	f852                	sd	s4,48(sp)
    80003a78:	f456                	sd	s5,40(sp)
    80003a7a:	f05a                	sd	s6,32(sp)
    80003a7c:	ec5e                	sd	s7,24(sp)
    80003a7e:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
    80003a80:	04451703          	lh	a4,68(a0)
    80003a84:	4785                	li	a5,1
    80003a86:	02f71963          	bne	a4,a5,80003ab8 <dirlookup+0x4e>
    80003a8a:	892a                	mv	s2,a0
    80003a8c:	8aae                	mv	s5,a1
    80003a8e:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003a90:	457c                	lw	a5,76(a0)
    80003a92:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a94:	fa040a13          	addi	s4,s0,-96
    80003a98:	49c1                	li	s3,16
      panic("dirlookup read");
    if (de.inum == 0)
      continue;
    if (namecmp(name, de.name) == 0) {
    80003a9a:	fa240b13          	addi	s6,s0,-94
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003a9e:	ef95                	bnez	a5,80003ada <dirlookup+0x70>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003aa0:	4501                	li	a0,0
}
    80003aa2:	60e6                	ld	ra,88(sp)
    80003aa4:	6446                	ld	s0,80(sp)
    80003aa6:	64a6                	ld	s1,72(sp)
    80003aa8:	6906                	ld	s2,64(sp)
    80003aaa:	79e2                	ld	s3,56(sp)
    80003aac:	7a42                	ld	s4,48(sp)
    80003aae:	7aa2                	ld	s5,40(sp)
    80003ab0:	7b02                	ld	s6,32(sp)
    80003ab2:	6be2                	ld	s7,24(sp)
    80003ab4:	6125                	addi	sp,sp,96
    80003ab6:	8082                	ret
    panic("dirlookup not DIR");
    80003ab8:	00004517          	auipc	a0,0x4
    80003abc:	b2050513          	addi	a0,a0,-1248 # 800075d8 <etext+0x5d8>
    80003ac0:	d89fc0ef          	jal	80000848 <panic>
      panic("dirlookup read");
    80003ac4:	00004517          	auipc	a0,0x4
    80003ac8:	b2c50513          	addi	a0,a0,-1236 # 800075f0 <etext+0x5f0>
    80003acc:	d7dfc0ef          	jal	80000848 <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003ad0:	24c1                	addiw	s1,s1,16
    80003ad2:	04c92783          	lw	a5,76(s2)
    80003ad6:	fcf4f5e3          	bgeu	s1,a5,80003aa0 <dirlookup+0x36>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ada:	874e                	mv	a4,s3
    80003adc:	86a6                	mv	a3,s1
    80003ade:	8652                	mv	a2,s4
    80003ae0:	4581                	li	a1,0
    80003ae2:	854a                	mv	a0,s2
    80003ae4:	d77ff0ef          	jal	8000385a <readi>
    80003ae8:	fd351ee3          	bne	a0,s3,80003ac4 <dirlookup+0x5a>
    if (de.inum == 0)
    80003aec:	fa045783          	lhu	a5,-96(s0)
    80003af0:	d3e5                	beqz	a5,80003ad0 <dirlookup+0x66>
    if (namecmp(name, de.name) == 0) {
    80003af2:	85da                	mv	a1,s6
    80003af4:	8556                	mv	a0,s5
    80003af6:	f5fff0ef          	jal	80003a54 <namecmp>
    80003afa:	f979                	bnez	a0,80003ad0 <dirlookup+0x66>
      if (poff)
    80003afc:	000b8463          	beqz	s7,80003b04 <dirlookup+0x9a>
        *poff = off;
    80003b00:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003b04:	fa045583          	lhu	a1,-96(s0)
    80003b08:	00092503          	lw	a0,0(s2)
    80003b0c:	efaff0ef          	jal	80003206 <iget>
    80003b10:	bf49                	j	80003aa2 <dirlookup+0x38>

0000000080003b12 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    80003b12:	711d                	addi	sp,sp,-96
    80003b14:	ec86                	sd	ra,88(sp)
    80003b16:	e8a2                	sd	s0,80(sp)
    80003b18:	e4a6                	sd	s1,72(sp)
    80003b1a:	e0ca                	sd	s2,64(sp)
    80003b1c:	fc4e                	sd	s3,56(sp)
    80003b1e:	f852                	sd	s4,48(sp)
    80003b20:	f456                	sd	s5,40(sp)
    80003b22:	f05a                	sd	s6,32(sp)
    80003b24:	ec5e                	sd	s7,24(sp)
    80003b26:	e862                	sd	s8,16(sp)
    80003b28:	e466                	sd	s9,8(sp)
    80003b2a:	e06a                	sd	s10,0(sp)
    80003b2c:	1080                	addi	s0,sp,96
    80003b2e:	84aa                	mv	s1,a0
    80003b30:	8b2e                	mv	s6,a1
    80003b32:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    80003b34:	00054703          	lbu	a4,0(a0)
    80003b38:	02f00793          	li	a5,47
    80003b3c:	00f70f63          	beq	a4,a5,80003b5a <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003b40:	d9ffd0ef          	jal	800018de <myproc>
    80003b44:	15053503          	ld	a0,336(a0)
    80003b48:	903ff0ef          	jal	8000344a <idup>
    80003b4c:	8a2a                	mv	s4,a0
  while (*path == '/')
    80003b4e:	02f00993          	li	s3,47
  if (len >= DIRSIZ)
    80003b52:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003b54:	4cb9                	li	s9,14

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    80003b56:	4b85                	li	s7,1
    80003b58:	a075                	j	80003c04 <namex+0xf2>
    ip = iget(ROOTDEV, ROOTINO);
    80003b5a:	4585                	li	a1,1
    80003b5c:	852e                	mv	a0,a1
    80003b5e:	ea8ff0ef          	jal	80003206 <iget>
    80003b62:	8a2a                	mv	s4,a0
    80003b64:	b7ed                	j	80003b4e <namex+0x3c>
      iunlockput(ip);
    80003b66:	8552                	mv	a0,s4
    80003b68:	b6dff0ef          	jal	800036d4 <iunlockput>
      return 0;
    80003b6c:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    80003b6e:	8552                	mv	a0,s4
    80003b70:	60e6                	ld	ra,88(sp)
    80003b72:	6446                	ld	s0,80(sp)
    80003b74:	64a6                	ld	s1,72(sp)
    80003b76:	6906                	ld	s2,64(sp)
    80003b78:	79e2                	ld	s3,56(sp)
    80003b7a:	7a42                	ld	s4,48(sp)
    80003b7c:	7aa2                	ld	s5,40(sp)
    80003b7e:	7b02                	ld	s6,32(sp)
    80003b80:	6be2                	ld	s7,24(sp)
    80003b82:	6c42                	ld	s8,16(sp)
    80003b84:	6ca2                	ld	s9,8(sp)
    80003b86:	6d02                	ld	s10,0(sp)
    80003b88:	6125                	addi	sp,sp,96
    80003b8a:	8082                	ret
      iunlockput(ip);
    80003b8c:	8552                	mv	a0,s4
    80003b8e:	b47ff0ef          	jal	800036d4 <iunlockput>
      return 0;
    80003b92:	bfe9                	j	80003b6c <namex+0x5a>
      iunlock(ip);
    80003b94:	8552                	mv	a0,s4
    80003b96:	999ff0ef          	jal	8000352e <iunlock>
      return ip;
    80003b9a:	bfd1                	j	80003b6e <namex+0x5c>
      iunlockput(ip);
    80003b9c:	8552                	mv	a0,s4
    80003b9e:	b37ff0ef          	jal	800036d4 <iunlockput>
      return 0;
    80003ba2:	8a4a                	mv	s4,s2
    80003ba4:	b7e9                	j	80003b6e <namex+0x5c>
  while (*path != '/' && *path != 0)
    80003ba6:	8926                	mv	s2,s1
  len = path - s;
    80003ba8:	4d01                	li	s10,0
    80003baa:	4601                	li	a2,0
    memmove(name, s, len);
    80003bac:	2601                	sext.w	a2,a2
    80003bae:	85a6                	mv	a1,s1
    80003bb0:	8556                	mv	a0,s5
    80003bb2:	95efd0ef          	jal	80000d10 <memmove>
    name[len] = 0;
    80003bb6:	9d56                	add	s10,s10,s5
    80003bb8:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffdb2b0>
    80003bbc:	84ca                	mv	s1,s2
  while (*path == '/')
    80003bbe:	0004c783          	lbu	a5,0(s1)
    80003bc2:	01379763          	bne	a5,s3,80003bd0 <namex+0xbe>
    path++;
    80003bc6:	0485                	addi	s1,s1,1
  while (*path == '/')
    80003bc8:	0004c783          	lbu	a5,0(s1)
    80003bcc:	ff378de3          	beq	a5,s3,80003bc6 <namex+0xb4>
    ilock(ip);
    80003bd0:	8552                	mv	a0,s4
    80003bd2:	8afff0ef          	jal	80003480 <ilock>
    if (ip->type != T_DIR) {
    80003bd6:	044a1783          	lh	a5,68(s4)
    80003bda:	f97796e3          	bne	a5,s7,80003b66 <namex+0x54>
    if (ip->nlink == 0) {
    80003bde:	04aa1783          	lh	a5,74(s4)
    80003be2:	d7cd                	beqz	a5,80003b8c <namex+0x7a>
    if (nameiparent && *path == '\0') {
    80003be4:	000b0563          	beqz	s6,80003bee <namex+0xdc>
    80003be8:	0004c783          	lbu	a5,0(s1)
    80003bec:	d7c5                	beqz	a5,80003b94 <namex+0x82>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    80003bee:	4601                	li	a2,0
    80003bf0:	85d6                	mv	a1,s5
    80003bf2:	8552                	mv	a0,s4
    80003bf4:	e77ff0ef          	jal	80003a6a <dirlookup>
    80003bf8:	892a                	mv	s2,a0
    80003bfa:	d14d                	beqz	a0,80003b9c <namex+0x8a>
    iunlockput(ip);
    80003bfc:	8552                	mv	a0,s4
    80003bfe:	ad7ff0ef          	jal	800036d4 <iunlockput>
    ip = next;
    80003c02:	8a4a                	mv	s4,s2
  while (*path == '/')
    80003c04:	0004c783          	lbu	a5,0(s1)
    80003c08:	01379763          	bne	a5,s3,80003c16 <namex+0x104>
    path++;
    80003c0c:	0485                	addi	s1,s1,1
  while (*path == '/')
    80003c0e:	0004c783          	lbu	a5,0(s1)
    80003c12:	ff378de3          	beq	a5,s3,80003c0c <namex+0xfa>
  if (*path == 0)
    80003c16:	c7a1                	beqz	a5,80003c5e <namex+0x14c>
  while (*path != '/' && *path != 0)
    80003c18:	0004c703          	lbu	a4,0(s1)
    80003c1c:	fd170793          	addi	a5,a4,-47
    80003c20:	00f037b3          	snez	a5,a5
    80003c24:	00e03733          	snez	a4,a4
    80003c28:	8ff9                	and	a5,a5,a4
    80003c2a:	dfb5                	beqz	a5,80003ba6 <namex+0x94>
    80003c2c:	8926                	mv	s2,s1
    path++;
    80003c2e:	0905                	addi	s2,s2,1
  while (*path != '/' && *path != 0)
    80003c30:	00094703          	lbu	a4,0(s2)
    80003c34:	fd170793          	addi	a5,a4,-47
    80003c38:	00f037b3          	snez	a5,a5
    80003c3c:	00e03733          	snez	a4,a4
    80003c40:	8ff9                	and	a5,a5,a4
    80003c42:	f7f5                	bnez	a5,80003c2e <namex+0x11c>
  len = path - s;
    80003c44:	40990633          	sub	a2,s2,s1
    80003c48:	00060d1b          	sext.w	s10,a2
  if (len >= DIRSIZ)
    80003c4c:	f7ac50e3          	bge	s8,s10,80003bac <namex+0x9a>
    memmove(name, s, DIRSIZ);
    80003c50:	8666                	mv	a2,s9
    80003c52:	85a6                	mv	a1,s1
    80003c54:	8556                	mv	a0,s5
    80003c56:	8bafd0ef          	jal	80000d10 <memmove>
    80003c5a:	84ca                	mv	s1,s2
    80003c5c:	b78d                	j	80003bbe <namex+0xac>
  if (nameiparent) {
    80003c5e:	f00b08e3          	beqz	s6,80003b6e <namex+0x5c>
    iput(ip);
    80003c62:	8552                	mv	a0,s4
    80003c64:	99fff0ef          	jal	80003602 <iput>
    return 0;
    80003c68:	b711                	j	80003b6c <namex+0x5a>

0000000080003c6a <dirlink>:
{
    80003c6a:	715d                	addi	sp,sp,-80
    80003c6c:	e486                	sd	ra,72(sp)
    80003c6e:	e0a2                	sd	s0,64(sp)
    80003c70:	f84a                	sd	s2,48(sp)
    80003c72:	ec56                	sd	s5,24(sp)
    80003c74:	e85a                	sd	s6,16(sp)
    80003c76:	0880                	addi	s0,sp,80
    80003c78:	892a                	mv	s2,a0
    80003c7a:	8aae                	mv	s5,a1
    80003c7c:	8b32                	mv	s6,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80003c7e:	4601                	li	a2,0
    80003c80:	debff0ef          	jal	80003a6a <dirlookup>
    80003c84:	ed1d                	bnez	a0,80003cc2 <dirlink+0x58>
    80003c86:	fc26                	sd	s1,56(sp)
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003c88:	04c92483          	lw	s1,76(s2)
    80003c8c:	c4b9                	beqz	s1,80003cda <dirlink+0x70>
    80003c8e:	f44e                	sd	s3,40(sp)
    80003c90:	f052                	sd	s4,32(sp)
    80003c92:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c94:	fb040a13          	addi	s4,s0,-80
    80003c98:	49c1                	li	s3,16
    80003c9a:	874e                	mv	a4,s3
    80003c9c:	86a6                	mv	a3,s1
    80003c9e:	8652                	mv	a2,s4
    80003ca0:	4581                	li	a1,0
    80003ca2:	854a                	mv	a0,s2
    80003ca4:	bb7ff0ef          	jal	8000385a <readi>
    80003ca8:	03351163          	bne	a0,s3,80003cca <dirlink+0x60>
    if (de.inum == 0)
    80003cac:	fb045783          	lhu	a5,-80(s0)
    80003cb0:	c39d                	beqz	a5,80003cd6 <dirlink+0x6c>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003cb2:	24c1                	addiw	s1,s1,16
    80003cb4:	04c92783          	lw	a5,76(s2)
    80003cb8:	fef4e1e3          	bltu	s1,a5,80003c9a <dirlink+0x30>
    80003cbc:	79a2                	ld	s3,40(sp)
    80003cbe:	7a02                	ld	s4,32(sp)
    80003cc0:	a829                	j	80003cda <dirlink+0x70>
    iput(ip);
    80003cc2:	941ff0ef          	jal	80003602 <iput>
    return -1;
    80003cc6:	557d                	li	a0,-1
    80003cc8:	a83d                	j	80003d06 <dirlink+0x9c>
      panic("dirlink read");
    80003cca:	00004517          	auipc	a0,0x4
    80003cce:	93650513          	addi	a0,a0,-1738 # 80007600 <etext+0x600>
    80003cd2:	b77fc0ef          	jal	80000848 <panic>
    80003cd6:	79a2                	ld	s3,40(sp)
    80003cd8:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003cda:	4639                	li	a2,14
    80003cdc:	85d6                	mv	a1,s5
    80003cde:	fb240513          	addi	a0,s0,-78
    80003ce2:	8d8fd0ef          	jal	80000dba <strncpy>
  de.inum = inum;
    80003ce6:	fb641823          	sh	s6,-80(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003cea:	4741                	li	a4,16
    80003cec:	86a6                	mv	a3,s1
    80003cee:	fb040613          	addi	a2,s0,-80
    80003cf2:	4581                	li	a1,0
    80003cf4:	854a                	mv	a0,s2
    80003cf6:	c57ff0ef          	jal	8000394c <writei>
    80003cfa:	1541                	addi	a0,a0,-16
    80003cfc:	00a03533          	snez	a0,a0
    80003d00:	40a0053b          	negw	a0,a0
    80003d04:	74e2                	ld	s1,56(sp)
}
    80003d06:	60a6                	ld	ra,72(sp)
    80003d08:	6406                	ld	s0,64(sp)
    80003d0a:	7942                	ld	s2,48(sp)
    80003d0c:	6ae2                	ld	s5,24(sp)
    80003d0e:	6b42                	ld	s6,16(sp)
    80003d10:	6161                	addi	sp,sp,80
    80003d12:	8082                	ret

0000000080003d14 <namei>:

struct inode *
namei(char *path)
{
    80003d14:	1101                	addi	sp,sp,-32
    80003d16:	ec06                	sd	ra,24(sp)
    80003d18:	e822                	sd	s0,16(sp)
    80003d1a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003d1c:	fe040613          	addi	a2,s0,-32
    80003d20:	4581                	li	a1,0
    80003d22:	df1ff0ef          	jal	80003b12 <namex>
}
    80003d26:	60e2                	ld	ra,24(sp)
    80003d28:	6442                	ld	s0,16(sp)
    80003d2a:	6105                	addi	sp,sp,32
    80003d2c:	8082                	ret

0000000080003d2e <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    80003d2e:	1141                	addi	sp,sp,-16
    80003d30:	e406                	sd	ra,8(sp)
    80003d32:	e022                	sd	s0,0(sp)
    80003d34:	0800                	addi	s0,sp,16
    80003d36:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003d38:	4585                	li	a1,1
    80003d3a:	dd9ff0ef          	jal	80003b12 <namex>
}
    80003d3e:	60a2                	ld	ra,8(sp)
    80003d40:	6402                	ld	s0,0(sp)
    80003d42:	0141                	addi	sp,sp,16
    80003d44:	8082                	ret

0000000080003d46 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003d46:	1101                	addi	sp,sp,-32
    80003d48:	ec06                	sd	ra,24(sp)
    80003d4a:	e822                	sd	s0,16(sp)
    80003d4c:	e426                	sd	s1,8(sp)
    80003d4e:	e04a                	sd	s2,0(sp)
    80003d50:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003d52:	0001f917          	auipc	s2,0x1f
    80003d56:	dbe90913          	addi	s2,s2,-578 # 80022b10 <log>
    80003d5a:	01892583          	lw	a1,24(s2)
    80003d5e:	02492503          	lw	a0,36(s2)
    80003d62:	87eff0ef          	jal	80002de0 <bread>
    80003d66:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    80003d68:	02c92603          	lw	a2,44(s2)
    80003d6c:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003d6e:	00c05f63          	blez	a2,80003d8c <write_head+0x46>
    80003d72:	0001f717          	auipc	a4,0x1f
    80003d76:	dce70713          	addi	a4,a4,-562 # 80022b40 <log+0x30>
    80003d7a:	87aa                	mv	a5,a0
    80003d7c:	060a                	slli	a2,a2,0x2
    80003d7e:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003d80:	4314                	lw	a3,0(a4)
    80003d82:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003d84:	0711                	addi	a4,a4,4
    80003d86:	0791                	addi	a5,a5,4 # 43004 <_entry-0x7ffbcffc>
    80003d88:	fec79ce3          	bne	a5,a2,80003d80 <write_head+0x3a>
  }
  bwrite(buf);
    80003d8c:	8526                	mv	a0,s1
    80003d8e:	928ff0ef          	jal	80002eb6 <bwrite>
  brelse(buf);
    80003d92:	8526                	mv	a0,s1
    80003d94:	954ff0ef          	jal	80002ee8 <brelse>
}
    80003d98:	60e2                	ld	ra,24(sp)
    80003d9a:	6442                	ld	s0,16(sp)
    80003d9c:	64a2                	ld	s1,8(sp)
    80003d9e:	6902                	ld	s2,0(sp)
    80003da0:	6105                	addi	sp,sp,32
    80003da2:	8082                	ret

0000000080003da4 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003da4:	0001f797          	auipc	a5,0x1f
    80003da8:	d987a783          	lw	a5,-616(a5) # 80022b3c <log+0x2c>
    80003dac:	0cf05163          	blez	a5,80003e6e <install_trans+0xca>
{
    80003db0:	715d                	addi	sp,sp,-80
    80003db2:	e486                	sd	ra,72(sp)
    80003db4:	e0a2                	sd	s0,64(sp)
    80003db6:	fc26                	sd	s1,56(sp)
    80003db8:	f84a                	sd	s2,48(sp)
    80003dba:	f44e                	sd	s3,40(sp)
    80003dbc:	f052                	sd	s4,32(sp)
    80003dbe:	ec56                	sd	s5,24(sp)
    80003dc0:	e85a                	sd	s6,16(sp)
    80003dc2:	e45e                	sd	s7,8(sp)
    80003dc4:	e062                	sd	s8,0(sp)
    80003dc6:	0880                	addi	s0,sp,80
    80003dc8:	8b2a                	mv	s6,a0
    80003dca:	0001fa97          	auipc	s5,0x1f
    80003dce:	d76a8a93          	addi	s5,s5,-650 # 80022b40 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003dd2:	4981                	li	s3,0
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003dd4:	00004c17          	auipc	s8,0x4
    80003dd8:	83cc0c13          	addi	s8,s8,-1988 # 80007610 <etext+0x610>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003ddc:	0001fa17          	auipc	s4,0x1f
    80003de0:	d34a0a13          	addi	s4,s4,-716 # 80022b10 <log>
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003de4:	40000b93          	li	s7,1024
    80003de8:	a025                	j	80003e10 <install_trans+0x6c>
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003dea:	000aa603          	lw	a2,0(s5)
    80003dee:	85ce                	mv	a1,s3
    80003df0:	8562                	mv	a0,s8
    80003df2:	f1efc0ef          	jal	80000510 <printk>
    80003df6:	a839                	j	80003e14 <install_trans+0x70>
    brelse(lbuf);
    80003df8:	854a                	mv	a0,s2
    80003dfa:	8eeff0ef          	jal	80002ee8 <brelse>
    brelse(dbuf);
    80003dfe:	8526                	mv	a0,s1
    80003e00:	8e8ff0ef          	jal	80002ee8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e04:	2985                	addiw	s3,s3,1
    80003e06:	0a91                	addi	s5,s5,4
    80003e08:	02ca2783          	lw	a5,44(s4)
    80003e0c:	04f9d563          	bge	s3,a5,80003e56 <install_trans+0xb2>
    if (recovering) {
    80003e10:	fc0b1de3          	bnez	s6,80003dea <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003e14:	018a2583          	lw	a1,24(s4)
    80003e18:	013585bb          	addw	a1,a1,s3
    80003e1c:	2585                	addiw	a1,a1,1
    80003e1e:	024a2503          	lw	a0,36(s4)
    80003e22:	fbffe0ef          	jal	80002de0 <bread>
    80003e26:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
    80003e28:	000aa583          	lw	a1,0(s5)
    80003e2c:	024a2503          	lw	a0,36(s4)
    80003e30:	fb1fe0ef          	jal	80002de0 <bread>
    80003e34:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003e36:	865e                	mv	a2,s7
    80003e38:	05890593          	addi	a1,s2,88
    80003e3c:	05850513          	addi	a0,a0,88
    80003e40:	ed1fc0ef          	jal	80000d10 <memmove>
    bwrite(dbuf);                           // write dst to disk
    80003e44:	8526                	mv	a0,s1
    80003e46:	870ff0ef          	jal	80002eb6 <bwrite>
    if (recovering == 0)
    80003e4a:	fa0b17e3          	bnez	s6,80003df8 <install_trans+0x54>
      bunpin(dbuf);
    80003e4e:	8526                	mv	a0,s1
    80003e50:	950ff0ef          	jal	80002fa0 <bunpin>
    80003e54:	b755                	j	80003df8 <install_trans+0x54>
}
    80003e56:	60a6                	ld	ra,72(sp)
    80003e58:	6406                	ld	s0,64(sp)
    80003e5a:	74e2                	ld	s1,56(sp)
    80003e5c:	7942                	ld	s2,48(sp)
    80003e5e:	79a2                	ld	s3,40(sp)
    80003e60:	7a02                	ld	s4,32(sp)
    80003e62:	6ae2                	ld	s5,24(sp)
    80003e64:	6b42                	ld	s6,16(sp)
    80003e66:	6ba2                	ld	s7,8(sp)
    80003e68:	6c02                	ld	s8,0(sp)
    80003e6a:	6161                	addi	sp,sp,80
    80003e6c:	8082                	ret
    80003e6e:	8082                	ret

0000000080003e70 <initlog>:
{
    80003e70:	7179                	addi	sp,sp,-48
    80003e72:	f406                	sd	ra,40(sp)
    80003e74:	f022                	sd	s0,32(sp)
    80003e76:	ec26                	sd	s1,24(sp)
    80003e78:	e84a                	sd	s2,16(sp)
    80003e7a:	e44e                	sd	s3,8(sp)
    80003e7c:	1800                	addi	s0,sp,48
    80003e7e:	84aa                	mv	s1,a0
    80003e80:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003e82:	0001f917          	auipc	s2,0x1f
    80003e86:	c8e90913          	addi	s2,s2,-882 # 80022b10 <log>
    80003e8a:	00003597          	auipc	a1,0x3
    80003e8e:	7a658593          	addi	a1,a1,1958 # 80007630 <etext+0x630>
    80003e92:	854a                	mv	a0,s2
    80003e94:	ce5fc0ef          	jal	80000b78 <initlock>
  log.start = sb->logstart;
    80003e98:	0149a583          	lw	a1,20(s3)
    80003e9c:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003ea0:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003ea4:	8526                	mv	a0,s1
    80003ea6:	f3bfe0ef          	jal	80002de0 <bread>
  log.lh.n = lh->n;
    80003eaa:	4d30                	lw	a2,88(a0)
    80003eac:	02c92623          	sw	a2,44(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003eb0:	00c05f63          	blez	a2,80003ece <initlog+0x5e>
    80003eb4:	87aa                	mv	a5,a0
    80003eb6:	0001f717          	auipc	a4,0x1f
    80003eba:	c8a70713          	addi	a4,a4,-886 # 80022b40 <log+0x30>
    80003ebe:	060a                	slli	a2,a2,0x2
    80003ec0:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003ec2:	4ff4                	lw	a3,92(a5)
    80003ec4:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003ec6:	0791                	addi	a5,a5,4
    80003ec8:	0711                	addi	a4,a4,4
    80003eca:	fec79ce3          	bne	a5,a2,80003ec2 <initlog+0x52>
  brelse(buf);
    80003ece:	81aff0ef          	jal	80002ee8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003ed2:	4505                	li	a0,1
    80003ed4:	ed1ff0ef          	jal	80003da4 <install_trans>
  log.lh.n = 0;
    80003ed8:	0001f797          	auipc	a5,0x1f
    80003edc:	c607a223          	sw	zero,-924(a5) # 80022b3c <log+0x2c>
  write_head(); // clear the log
    80003ee0:	e67ff0ef          	jal	80003d46 <write_head>
}
    80003ee4:	70a2                	ld	ra,40(sp)
    80003ee6:	7402                	ld	s0,32(sp)
    80003ee8:	64e2                	ld	s1,24(sp)
    80003eea:	6942                	ld	s2,16(sp)
    80003eec:	69a2                	ld	s3,8(sp)
    80003eee:	6145                	addi	sp,sp,48
    80003ef0:	8082                	ret

0000000080003ef2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003ef2:	1101                	addi	sp,sp,-32
    80003ef4:	ec06                	sd	ra,24(sp)
    80003ef6:	e822                	sd	s0,16(sp)
    80003ef8:	e426                	sd	s1,8(sp)
    80003efa:	e04a                	sd	s2,0(sp)
    80003efc:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003efe:	0001f517          	auipc	a0,0x1f
    80003f02:	c1250513          	addi	a0,a0,-1006 # 80022b10 <log>
    80003f06:	cf3fc0ef          	jal	80000bf8 <acquire>
  while (1) {
    if (log.committing) {
    80003f0a:	0001f497          	auipc	s1,0x1f
    80003f0e:	c0648493          	addi	s1,s1,-1018 # 80022b10 <log>
      sleep_prepare(&log);
      release(&log.lock);
      sleep();
      acquire(&log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80003f12:	4979                	li	s2,30
    80003f14:	a821                	j	80003f2c <begin_op+0x3a>
      sleep_prepare(&log);
    80003f16:	8526                	mv	a0,s1
    80003f18:	94efe0ef          	jal	80002066 <sleep_prepare>
      release(&log.lock);
    80003f1c:	8526                	mv	a0,s1
    80003f1e:	d5ffc0ef          	jal	80000c7c <release>
      sleep();
    80003f22:	980fe0ef          	jal	800020a2 <sleep>
      acquire(&log.lock);
    80003f26:	8526                	mv	a0,s1
    80003f28:	cd1fc0ef          	jal	80000bf8 <acquire>
    if (log.committing) {
    80003f2c:	509c                	lw	a5,32(s1)
    80003f2e:	f7e5                	bnez	a5,80003f16 <begin_op+0x24>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80003f30:	4cd8                	lw	a4,28(s1)
    80003f32:	2705                	addiw	a4,a4,1
    80003f34:	0027179b          	slliw	a5,a4,0x2
    80003f38:	9fb9                	addw	a5,a5,a4
    80003f3a:	0017979b          	slliw	a5,a5,0x1
    80003f3e:	54d4                	lw	a3,44(s1)
    80003f40:	9fb5                	addw	a5,a5,a3
    80003f42:	00f95e63          	bge	s2,a5,80003f5e <begin_op+0x6c>
      // this op might exhaust log space; wait for commit.
      sleep_prepare(&log);
    80003f46:	8526                	mv	a0,s1
    80003f48:	91efe0ef          	jal	80002066 <sleep_prepare>
      release(&log.lock);
    80003f4c:	8526                	mv	a0,s1
    80003f4e:	d2ffc0ef          	jal	80000c7c <release>
      sleep();
    80003f52:	950fe0ef          	jal	800020a2 <sleep>
      acquire(&log.lock);
    80003f56:	8526                	mv	a0,s1
    80003f58:	ca1fc0ef          	jal	80000bf8 <acquire>
    80003f5c:	bfc1                	j	80003f2c <begin_op+0x3a>
    } else {
      log.outstanding += 1;
    80003f5e:	0001f797          	auipc	a5,0x1f
    80003f62:	bce7a723          	sw	a4,-1074(a5) # 80022b2c <log+0x1c>
      release(&log.lock);
    80003f66:	0001f517          	auipc	a0,0x1f
    80003f6a:	baa50513          	addi	a0,a0,-1110 # 80022b10 <log>
    80003f6e:	d0ffc0ef          	jal	80000c7c <release>
      break;
    }
  }
}
    80003f72:	60e2                	ld	ra,24(sp)
    80003f74:	6442                	ld	s0,16(sp)
    80003f76:	64a2                	ld	s1,8(sp)
    80003f78:	6902                	ld	s2,0(sp)
    80003f7a:	6105                	addi	sp,sp,32
    80003f7c:	8082                	ret

0000000080003f7e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003f7e:	7139                	addi	sp,sp,-64
    80003f80:	fc06                	sd	ra,56(sp)
    80003f82:	f822                	sd	s0,48(sp)
    80003f84:	f426                	sd	s1,40(sp)
    80003f86:	f04a                	sd	s2,32(sp)
    80003f88:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003f8a:	0001f497          	auipc	s1,0x1f
    80003f8e:	b8648493          	addi	s1,s1,-1146 # 80022b10 <log>
    80003f92:	8526                	mv	a0,s1
    80003f94:	c65fc0ef          	jal	80000bf8 <acquire>
  log.outstanding -= 1;
    80003f98:	4cdc                	lw	a5,28(s1)
    80003f9a:	37fd                	addiw	a5,a5,-1
    80003f9c:	893e                	mv	s2,a5
    80003f9e:	ccdc                	sw	a5,28(s1)
  if (log.committing)
    80003fa0:	509c                	lw	a5,32(s1)
    80003fa2:	e7b9                	bnez	a5,80003ff0 <end_op+0x72>
    panic("log.committing");
  if (log.outstanding == 0) {
    80003fa4:	04091f63          	bnez	s2,80004002 <end_op+0x84>
    do_commit = 1;
    log.committing = 1;
    80003fa8:	0001f497          	auipc	s1,0x1f
    80003fac:	b6848493          	addi	s1,s1,-1176 # 80022b10 <log>
    80003fb0:	4785                	li	a5,1
    80003fb2:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003fb4:	8526                	mv	a0,s1
    80003fb6:	cc7fc0ef          	jal	80000c7c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003fba:	54dc                	lw	a5,44(s1)
    80003fbc:	06f04063          	bgtz	a5,8000401c <end_op+0x9e>
    acquire(&log.lock);
    80003fc0:	0001f497          	auipc	s1,0x1f
    80003fc4:	b5048493          	addi	s1,s1,-1200 # 80022b10 <log>
    80003fc8:	8526                	mv	a0,s1
    80003fca:	c2ffc0ef          	jal	80000bf8 <acquire>
    log.committing = 0;
    80003fce:	0204a023          	sw	zero,32(s1)
    log.ncommit += 1;
    80003fd2:	549c                	lw	a5,40(s1)
    80003fd4:	2785                	addiw	a5,a5,1
    80003fd6:	d49c                	sw	a5,40(s1)
    wakeup(&log);
    80003fd8:	8526                	mv	a0,s1
    80003fda:	8fcfe0ef          	jal	800020d6 <wakeup>
    release(&log.lock);
    80003fde:	8526                	mv	a0,s1
    80003fe0:	c9dfc0ef          	jal	80000c7c <release>
}
    80003fe4:	70e2                	ld	ra,56(sp)
    80003fe6:	7442                	ld	s0,48(sp)
    80003fe8:	74a2                	ld	s1,40(sp)
    80003fea:	7902                	ld	s2,32(sp)
    80003fec:	6121                	addi	sp,sp,64
    80003fee:	8082                	ret
    80003ff0:	ec4e                	sd	s3,24(sp)
    80003ff2:	e852                	sd	s4,16(sp)
    80003ff4:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003ff6:	00003517          	auipc	a0,0x3
    80003ffa:	64250513          	addi	a0,a0,1602 # 80007638 <etext+0x638>
    80003ffe:	84bfc0ef          	jal	80000848 <panic>
    wakeup(&log);
    80004002:	0001f517          	auipc	a0,0x1f
    80004006:	b0e50513          	addi	a0,a0,-1266 # 80022b10 <log>
    8000400a:	8ccfe0ef          	jal	800020d6 <wakeup>
  release(&log.lock);
    8000400e:	0001f517          	auipc	a0,0x1f
    80004012:	b0250513          	addi	a0,a0,-1278 # 80022b10 <log>
    80004016:	c67fc0ef          	jal	80000c7c <release>
  if (do_commit) {
    8000401a:	b7e9                	j	80003fe4 <end_op+0x66>
    8000401c:	ec4e                	sd	s3,24(sp)
    8000401e:	e852                	sd	s4,16(sp)
    80004020:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004022:	0001fa97          	auipc	s5,0x1f
    80004026:	b1ea8a93          	addi	s5,s5,-1250 # 80022b40 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1); // log block
    8000402a:	0001fa17          	auipc	s4,0x1f
    8000402e:	ae6a0a13          	addi	s4,s4,-1306 # 80022b10 <log>
    80004032:	018a2583          	lw	a1,24(s4)
    80004036:	012585bb          	addw	a1,a1,s2
    8000403a:	2585                	addiw	a1,a1,1
    8000403c:	024a2503          	lw	a0,36(s4)
    80004040:	da1fe0ef          	jal	80002de0 <bread>
    80004044:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004046:	000aa583          	lw	a1,0(s5)
    8000404a:	024a2503          	lw	a0,36(s4)
    8000404e:	d93fe0ef          	jal	80002de0 <bread>
    80004052:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004054:	40000613          	li	a2,1024
    80004058:	05850593          	addi	a1,a0,88
    8000405c:	05848513          	addi	a0,s1,88
    80004060:	cb1fc0ef          	jal	80000d10 <memmove>
    bwrite(to); // write the log
    80004064:	8526                	mv	a0,s1
    80004066:	e51fe0ef          	jal	80002eb6 <bwrite>
    brelse(from);
    8000406a:	854e                	mv	a0,s3
    8000406c:	e7dfe0ef          	jal	80002ee8 <brelse>
    brelse(to);
    80004070:	8526                	mv	a0,s1
    80004072:	e77fe0ef          	jal	80002ee8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004076:	2905                	addiw	s2,s2,1
    80004078:	0a91                	addi	s5,s5,4
    8000407a:	02ca2783          	lw	a5,44(s4)
    8000407e:	faf94ae3          	blt	s2,a5,80004032 <end_op+0xb4>
    write_log();      // Write modified blocks from cache to log
    write_head();     // Write header to disk -- the real commit
    80004082:	cc5ff0ef          	jal	80003d46 <write_head>
    install_trans(0); // Now install writes to home locations
    80004086:	4501                	li	a0,0
    80004088:	d1dff0ef          	jal	80003da4 <install_trans>
    log.lh.n = 0;
    8000408c:	0001f797          	auipc	a5,0x1f
    80004090:	aa07a823          	sw	zero,-1360(a5) # 80022b3c <log+0x2c>
    write_head(); // Erase the transaction from the log
    80004094:	cb3ff0ef          	jal	80003d46 <write_head>
    80004098:	69e2                	ld	s3,24(sp)
    8000409a:	6a42                	ld	s4,16(sp)
    8000409c:	6aa2                	ld	s5,8(sp)
    8000409e:	b70d                	j	80003fc0 <end_op+0x42>

00000000800040a0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800040a0:	1101                	addi	sp,sp,-32
    800040a2:	ec06                	sd	ra,24(sp)
    800040a4:	e822                	sd	s0,16(sp)
    800040a6:	e426                	sd	s1,8(sp)
    800040a8:	1000                	addi	s0,sp,32
    800040aa:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800040ac:	0001f517          	auipc	a0,0x1f
    800040b0:	a6450513          	addi	a0,a0,-1436 # 80022b10 <log>
    800040b4:	b45fc0ef          	jal	80000bf8 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    800040b8:	0001f617          	auipc	a2,0x1f
    800040bc:	a8462603          	lw	a2,-1404(a2) # 80022b3c <log+0x2c>
    800040c0:	47f5                	li	a5,29
    800040c2:	04c7cc63          	blt	a5,a2,8000411a <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800040c6:	0001f797          	auipc	a5,0x1f
    800040ca:	a667a783          	lw	a5,-1434(a5) # 80022b2c <log+0x1c>
    800040ce:	04f05c63          	blez	a5,80004126 <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800040d2:	4781                	li	a5,0
    800040d4:	04c05f63          	blez	a2,80004132 <log_write+0x92>
    if (log.lh.block[i] == b->blockno) // log absorption
    800040d8:	44cc                	lw	a1,12(s1)
    800040da:	0001f717          	auipc	a4,0x1f
    800040de:	a6670713          	addi	a4,a4,-1434 # 80022b40 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800040e2:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno) // log absorption
    800040e4:	4314                	lw	a3,0(a4)
    800040e6:	04b68663          	beq	a3,a1,80004132 <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    800040ea:	2785                	addiw	a5,a5,1
    800040ec:	0711                	addi	a4,a4,4
    800040ee:	fef61be3          	bne	a2,a5,800040e4 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    800040f2:	0621                	addi	a2,a2,8
    800040f4:	060a                	slli	a2,a2,0x2
    800040f6:	0001f797          	auipc	a5,0x1f
    800040fa:	a1a78793          	addi	a5,a5,-1510 # 80022b10 <log>
    800040fe:	97b2                	add	a5,a5,a2
    80004100:	44d8                	lw	a4,12(s1)
    80004102:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) { // Add new block to log?
    bpin(b);
    80004104:	8526                	mv	a0,s1
    80004106:	e67fe0ef          	jal	80002f6c <bpin>
    log.lh.n++;
    8000410a:	0001f717          	auipc	a4,0x1f
    8000410e:	a0670713          	addi	a4,a4,-1530 # 80022b10 <log>
    80004112:	575c                	lw	a5,44(a4)
    80004114:	2785                	addiw	a5,a5,1
    80004116:	d75c                	sw	a5,44(a4)
    80004118:	a80d                	j	8000414a <log_write+0xaa>
    panic("too big a transaction");
    8000411a:	00003517          	auipc	a0,0x3
    8000411e:	52e50513          	addi	a0,a0,1326 # 80007648 <etext+0x648>
    80004122:	f26fc0ef          	jal	80000848 <panic>
    panic("log_write outside of trans");
    80004126:	00003517          	auipc	a0,0x3
    8000412a:	53a50513          	addi	a0,a0,1338 # 80007660 <etext+0x660>
    8000412e:	f1afc0ef          	jal	80000848 <panic>
  log.lh.block[i] = b->blockno;
    80004132:	00878693          	addi	a3,a5,8
    80004136:	068a                	slli	a3,a3,0x2
    80004138:	0001f717          	auipc	a4,0x1f
    8000413c:	9d870713          	addi	a4,a4,-1576 # 80022b10 <log>
    80004140:	9736                	add	a4,a4,a3
    80004142:	44d4                	lw	a3,12(s1)
    80004144:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) { // Add new block to log?
    80004146:	faf60fe3          	beq	a2,a5,80004104 <log_write+0x64>
  }
  release(&log.lock);
    8000414a:	0001f517          	auipc	a0,0x1f
    8000414e:	9c650513          	addi	a0,a0,-1594 # 80022b10 <log>
    80004152:	b2bfc0ef          	jal	80000c7c <release>
}
    80004156:	60e2                	ld	ra,24(sp)
    80004158:	6442                	ld	s0,16(sp)
    8000415a:	64a2                	ld	s1,8(sp)
    8000415c:	6105                	addi	sp,sp,32
    8000415e:	8082                	ret

0000000080004160 <sys_sync>:

uint64
sys_sync(void)
{
    80004160:	1101                	addi	sp,sp,-32
    80004162:	ec06                	sd	ra,24(sp)
    80004164:	e822                	sd	s0,16(sp)
    80004166:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004168:	0001f517          	auipc	a0,0x1f
    8000416c:	9a850513          	addi	a0,a0,-1624 # 80022b10 <log>
    80004170:	a89fc0ef          	jal	80000bf8 <acquire>
  if (log.committing || log.outstanding > 0) {
    80004174:	0001f797          	auipc	a5,0x1f
    80004178:	9bc7a783          	lw	a5,-1604(a5) # 80022b30 <log+0x20>
    8000417c:	e799                	bnez	a5,8000418a <sys_sync+0x2a>
    8000417e:	0001f797          	auipc	a5,0x1f
    80004182:	9ae7a783          	lw	a5,-1618(a5) # 80022b2c <log+0x1c>
    80004186:	02f05c63          	blez	a5,800041be <sys_sync+0x5e>
    8000418a:	e426                	sd	s1,8(sp)
    8000418c:	e04a                	sd	s2,0(sp)
    int n = log.ncommit + 1;
    8000418e:	0001f917          	auipc	s2,0x1f
    80004192:	9aa92903          	lw	s2,-1622(s2) # 80022b38 <log+0x28>
    while (log.ncommit < n) {
      sleep_prepare(&log);
    80004196:	0001f497          	auipc	s1,0x1f
    8000419a:	97a48493          	addi	s1,s1,-1670 # 80022b10 <log>
    8000419e:	8526                	mv	a0,s1
    800041a0:	ec7fd0ef          	jal	80002066 <sleep_prepare>
      release(&log.lock);
    800041a4:	8526                	mv	a0,s1
    800041a6:	ad7fc0ef          	jal	80000c7c <release>
      sleep();
    800041aa:	ef9fd0ef          	jal	800020a2 <sleep>
      acquire(&log.lock);
    800041ae:	8526                	mv	a0,s1
    800041b0:	a49fc0ef          	jal	80000bf8 <acquire>
    while (log.ncommit < n) {
    800041b4:	549c                	lw	a5,40(s1)
    800041b6:	fef954e3          	bge	s2,a5,8000419e <sys_sync+0x3e>
    800041ba:	64a2                	ld	s1,8(sp)
    800041bc:	6902                	ld	s2,0(sp)
    }
  }
  release(&log.lock);
    800041be:	0001f517          	auipc	a0,0x1f
    800041c2:	95250513          	addi	a0,a0,-1710 # 80022b10 <log>
    800041c6:	ab7fc0ef          	jal	80000c7c <release>
  return 0;
}
    800041ca:	4501                	li	a0,0
    800041cc:	60e2                	ld	ra,24(sp)
    800041ce:	6442                	ld	s0,16(sp)
    800041d0:	6105                	addi	sp,sp,32
    800041d2:	8082                	ret

00000000800041d4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800041d4:	1101                	addi	sp,sp,-32
    800041d6:	ec06                	sd	ra,24(sp)
    800041d8:	e822                	sd	s0,16(sp)
    800041da:	e426                	sd	s1,8(sp)
    800041dc:	e04a                	sd	s2,0(sp)
    800041de:	1000                	addi	s0,sp,32
    800041e0:	84aa                	mv	s1,a0
    800041e2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800041e4:	00003597          	auipc	a1,0x3
    800041e8:	49c58593          	addi	a1,a1,1180 # 80007680 <etext+0x680>
    800041ec:	0521                	addi	a0,a0,8
    800041ee:	98bfc0ef          	jal	80000b78 <initlock>
  lk->name = name;
    800041f2:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800041f6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800041fa:	0204a423          	sw	zero,40(s1)
}
    800041fe:	60e2                	ld	ra,24(sp)
    80004200:	6442                	ld	s0,16(sp)
    80004202:	64a2                	ld	s1,8(sp)
    80004204:	6902                	ld	s2,0(sp)
    80004206:	6105                	addi	sp,sp,32
    80004208:	8082                	ret

000000008000420a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000420a:	1101                	addi	sp,sp,-32
    8000420c:	ec06                	sd	ra,24(sp)
    8000420e:	e822                	sd	s0,16(sp)
    80004210:	e426                	sd	s1,8(sp)
    80004212:	e04a                	sd	s2,0(sp)
    80004214:	1000                	addi	s0,sp,32
    80004216:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004218:	00850913          	addi	s2,a0,8
    8000421c:	854a                	mv	a0,s2
    8000421e:	9dbfc0ef          	jal	80000bf8 <acquire>
  while (lk->locked) {
    80004222:	409c                	lw	a5,0(s1)
    80004224:	cf91                	beqz	a5,80004240 <acquiresleep+0x36>
    sleep_prepare(lk);
    80004226:	8526                	mv	a0,s1
    80004228:	e3ffd0ef          	jal	80002066 <sleep_prepare>
    release(&lk->lk);
    8000422c:	854a                	mv	a0,s2
    8000422e:	a4ffc0ef          	jal	80000c7c <release>
    sleep();
    80004232:	e71fd0ef          	jal	800020a2 <sleep>
    acquire(&lk->lk);
    80004236:	854a                	mv	a0,s2
    80004238:	9c1fc0ef          	jal	80000bf8 <acquire>
  while (lk->locked) {
    8000423c:	409c                	lw	a5,0(s1)
    8000423e:	f7e5                	bnez	a5,80004226 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80004240:	4785                	li	a5,1
    80004242:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004244:	e9afd0ef          	jal	800018de <myproc>
    80004248:	591c                	lw	a5,48(a0)
    8000424a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000424c:	854a                	mv	a0,s2
    8000424e:	a2ffc0ef          	jal	80000c7c <release>
}
    80004252:	60e2                	ld	ra,24(sp)
    80004254:	6442                	ld	s0,16(sp)
    80004256:	64a2                	ld	s1,8(sp)
    80004258:	6902                	ld	s2,0(sp)
    8000425a:	6105                	addi	sp,sp,32
    8000425c:	8082                	ret

000000008000425e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000425e:	1101                	addi	sp,sp,-32
    80004260:	ec06                	sd	ra,24(sp)
    80004262:	e822                	sd	s0,16(sp)
    80004264:	e426                	sd	s1,8(sp)
    80004266:	e04a                	sd	s2,0(sp)
    80004268:	1000                	addi	s0,sp,32
    8000426a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000426c:	00850913          	addi	s2,a0,8
    80004270:	854a                	mv	a0,s2
    80004272:	987fc0ef          	jal	80000bf8 <acquire>
  lk->locked = 0;
    80004276:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000427a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000427e:	8526                	mv	a0,s1
    80004280:	e57fd0ef          	jal	800020d6 <wakeup>
  release(&lk->lk);
    80004284:	854a                	mv	a0,s2
    80004286:	9f7fc0ef          	jal	80000c7c <release>
}
    8000428a:	60e2                	ld	ra,24(sp)
    8000428c:	6442                	ld	s0,16(sp)
    8000428e:	64a2                	ld	s1,8(sp)
    80004290:	6902                	ld	s2,0(sp)
    80004292:	6105                	addi	sp,sp,32
    80004294:	8082                	ret

0000000080004296 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004296:	7179                	addi	sp,sp,-48
    80004298:	f406                	sd	ra,40(sp)
    8000429a:	f022                	sd	s0,32(sp)
    8000429c:	ec26                	sd	s1,24(sp)
    8000429e:	e84a                	sd	s2,16(sp)
    800042a0:	1800                	addi	s0,sp,48
    800042a2:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    800042a4:	00850913          	addi	s2,a0,8
    800042a8:	854a                	mv	a0,s2
    800042aa:	94ffc0ef          	jal	80000bf8 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800042ae:	409c                	lw	a5,0(s1)
    800042b0:	ef81                	bnez	a5,800042c8 <holdingsleep+0x32>
    800042b2:	4481                	li	s1,0
  release(&lk->lk);
    800042b4:	854a                	mv	a0,s2
    800042b6:	9c7fc0ef          	jal	80000c7c <release>
  return r;
}
    800042ba:	8526                	mv	a0,s1
    800042bc:	70a2                	ld	ra,40(sp)
    800042be:	7402                	ld	s0,32(sp)
    800042c0:	64e2                	ld	s1,24(sp)
    800042c2:	6942                	ld	s2,16(sp)
    800042c4:	6145                	addi	sp,sp,48
    800042c6:	8082                	ret
    800042c8:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800042ca:	0284a983          	lw	s3,40(s1)
    800042ce:	e10fd0ef          	jal	800018de <myproc>
    800042d2:	5904                	lw	s1,48(a0)
    800042d4:	413484b3          	sub	s1,s1,s3
    800042d8:	0014b493          	seqz	s1,s1
    800042dc:	69a2                	ld	s3,8(sp)
    800042de:	bfd9                	j	800042b4 <holdingsleep+0x1e>

00000000800042e0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800042e0:	1141                	addi	sp,sp,-16
    800042e2:	e406                	sd	ra,8(sp)
    800042e4:	e022                	sd	s0,0(sp)
    800042e6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800042e8:	00003597          	auipc	a1,0x3
    800042ec:	3a858593          	addi	a1,a1,936 # 80007690 <etext+0x690>
    800042f0:	0001f517          	auipc	a0,0x1f
    800042f4:	96850513          	addi	a0,a0,-1688 # 80022c58 <ftable>
    800042f8:	881fc0ef          	jal	80000b78 <initlock>
}
    800042fc:	60a2                	ld	ra,8(sp)
    800042fe:	6402                	ld	s0,0(sp)
    80004300:	0141                	addi	sp,sp,16
    80004302:	8082                	ret

0000000080004304 <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    80004304:	1101                	addi	sp,sp,-32
    80004306:	ec06                	sd	ra,24(sp)
    80004308:	e822                	sd	s0,16(sp)
    8000430a:	e426                	sd	s1,8(sp)
    8000430c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000430e:	0001f517          	auipc	a0,0x1f
    80004312:	94a50513          	addi	a0,a0,-1718 # 80022c58 <ftable>
    80004316:	8e3fc0ef          	jal	80000bf8 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    8000431a:	0001f497          	auipc	s1,0x1f
    8000431e:	95648493          	addi	s1,s1,-1706 # 80022c70 <ftable+0x18>
    80004322:	00020717          	auipc	a4,0x20
    80004326:	8ee70713          	addi	a4,a4,-1810 # 80023c10 <disk>
    if (f->ref == 0) {
    8000432a:	40dc                	lw	a5,4(s1)
    8000432c:	cf89                	beqz	a5,80004346 <filealloc+0x42>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    8000432e:	02848493          	addi	s1,s1,40
    80004332:	fee49ce3          	bne	s1,a4,8000432a <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004336:	0001f517          	auipc	a0,0x1f
    8000433a:	92250513          	addi	a0,a0,-1758 # 80022c58 <ftable>
    8000433e:	93ffc0ef          	jal	80000c7c <release>
  return 0;
    80004342:	4481                	li	s1,0
    80004344:	a809                	j	80004356 <filealloc+0x52>
      f->ref = 1;
    80004346:	4785                	li	a5,1
    80004348:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000434a:	0001f517          	auipc	a0,0x1f
    8000434e:	90e50513          	addi	a0,a0,-1778 # 80022c58 <ftable>
    80004352:	92bfc0ef          	jal	80000c7c <release>
}
    80004356:	8526                	mv	a0,s1
    80004358:	60e2                	ld	ra,24(sp)
    8000435a:	6442                	ld	s0,16(sp)
    8000435c:	64a2                	ld	s1,8(sp)
    8000435e:	6105                	addi	sp,sp,32
    80004360:	8082                	ret

0000000080004362 <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    80004362:	1101                	addi	sp,sp,-32
    80004364:	ec06                	sd	ra,24(sp)
    80004366:	e822                	sd	s0,16(sp)
    80004368:	e426                	sd	s1,8(sp)
    8000436a:	1000                	addi	s0,sp,32
    8000436c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000436e:	0001f517          	auipc	a0,0x1f
    80004372:	8ea50513          	addi	a0,a0,-1814 # 80022c58 <ftable>
    80004376:	883fc0ef          	jal	80000bf8 <acquire>
  if (f->ref < 1)
    8000437a:	40dc                	lw	a5,4(s1)
    8000437c:	02f05063          	blez	a5,8000439c <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80004380:	2785                	addiw	a5,a5,1
    80004382:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004384:	0001f517          	auipc	a0,0x1f
    80004388:	8d450513          	addi	a0,a0,-1836 # 80022c58 <ftable>
    8000438c:	8f1fc0ef          	jal	80000c7c <release>
  return f;
}
    80004390:	8526                	mv	a0,s1
    80004392:	60e2                	ld	ra,24(sp)
    80004394:	6442                	ld	s0,16(sp)
    80004396:	64a2                	ld	s1,8(sp)
    80004398:	6105                	addi	sp,sp,32
    8000439a:	8082                	ret
    panic("filedup");
    8000439c:	00003517          	auipc	a0,0x3
    800043a0:	2fc50513          	addi	a0,a0,764 # 80007698 <etext+0x698>
    800043a4:	ca4fc0ef          	jal	80000848 <panic>

00000000800043a8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800043a8:	7139                	addi	sp,sp,-64
    800043aa:	fc06                	sd	ra,56(sp)
    800043ac:	f822                	sd	s0,48(sp)
    800043ae:	f426                	sd	s1,40(sp)
    800043b0:	0080                	addi	s0,sp,64
    800043b2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800043b4:	0001f517          	auipc	a0,0x1f
    800043b8:	8a450513          	addi	a0,a0,-1884 # 80022c58 <ftable>
    800043bc:	83dfc0ef          	jal	80000bf8 <acquire>
  if (f->ref < 1)
    800043c0:	40dc                	lw	a5,4(s1)
    800043c2:	04f05a63          	blez	a5,80004416 <fileclose+0x6e>
    panic("fileclose");
  if (--f->ref > 0) {
    800043c6:	37fd                	addiw	a5,a5,-1
    800043c8:	c0dc                	sw	a5,4(s1)
    800043ca:	06f04063          	bgtz	a5,8000442a <fileclose+0x82>
    800043ce:	f04a                	sd	s2,32(sp)
    800043d0:	ec4e                	sd	s3,24(sp)
    800043d2:	e852                	sd	s4,16(sp)
    800043d4:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800043d6:	0004a903          	lw	s2,0(s1)
    800043da:	0094c783          	lbu	a5,9(s1)
    800043de:	89be                	mv	s3,a5
    800043e0:	689c                	ld	a5,16(s1)
    800043e2:	8a3e                	mv	s4,a5
    800043e4:	6c9c                	ld	a5,24(s1)
    800043e6:	8abe                	mv	s5,a5
  f->ref = 0;
    800043e8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800043ec:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800043f0:	0001f517          	auipc	a0,0x1f
    800043f4:	86850513          	addi	a0,a0,-1944 # 80022c58 <ftable>
    800043f8:	885fc0ef          	jal	80000c7c <release>

  if (ff.type == FD_PIPE) {
    800043fc:	4785                	li	a5,1
    800043fe:	04f90163          	beq	s2,a5,80004440 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    80004402:	ffe9079b          	addiw	a5,s2,-2
    80004406:	4705                	li	a4,1
    80004408:	04f77563          	bgeu	a4,a5,80004452 <fileclose+0xaa>
    8000440c:	7902                	ld	s2,32(sp)
    8000440e:	69e2                	ld	s3,24(sp)
    80004410:	6a42                	ld	s4,16(sp)
    80004412:	6aa2                	ld	s5,8(sp)
    80004414:	a00d                	j	80004436 <fileclose+0x8e>
    80004416:	f04a                	sd	s2,32(sp)
    80004418:	ec4e                	sd	s3,24(sp)
    8000441a:	e852                	sd	s4,16(sp)
    8000441c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000441e:	00003517          	auipc	a0,0x3
    80004422:	28250513          	addi	a0,a0,642 # 800076a0 <etext+0x6a0>
    80004426:	c22fc0ef          	jal	80000848 <panic>
    release(&ftable.lock);
    8000442a:	0001f517          	auipc	a0,0x1f
    8000442e:	82e50513          	addi	a0,a0,-2002 # 80022c58 <ftable>
    80004432:	84bfc0ef          	jal	80000c7c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004436:	70e2                	ld	ra,56(sp)
    80004438:	7442                	ld	s0,48(sp)
    8000443a:	74a2                	ld	s1,40(sp)
    8000443c:	6121                	addi	sp,sp,64
    8000443e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004440:	85ce                	mv	a1,s3
    80004442:	8552                	mv	a0,s4
    80004444:	348000ef          	jal	8000478c <pipeclose>
    80004448:	7902                	ld	s2,32(sp)
    8000444a:	69e2                	ld	s3,24(sp)
    8000444c:	6a42                	ld	s4,16(sp)
    8000444e:	6aa2                	ld	s5,8(sp)
    80004450:	b7dd                	j	80004436 <fileclose+0x8e>
    begin_op();
    80004452:	aa1ff0ef          	jal	80003ef2 <begin_op>
    iput(ff.ip);
    80004456:	8556                	mv	a0,s5
    80004458:	9aaff0ef          	jal	80003602 <iput>
    end_op();
    8000445c:	b23ff0ef          	jal	80003f7e <end_op>
    80004460:	7902                	ld	s2,32(sp)
    80004462:	69e2                	ld	s3,24(sp)
    80004464:	6a42                	ld	s4,16(sp)
    80004466:	6aa2                	ld	s5,8(sp)
    80004468:	b7f9                	j	80004436 <fileclose+0x8e>

000000008000446a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000446a:	715d                	addi	sp,sp,-80
    8000446c:	e486                	sd	ra,72(sp)
    8000446e:	e0a2                	sd	s0,64(sp)
    80004470:	fc26                	sd	s1,56(sp)
    80004472:	f052                	sd	s4,32(sp)
    80004474:	0880                	addi	s0,sp,80
    80004476:	84aa                	mv	s1,a0
    80004478:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    8000447a:	c64fd0ef          	jal	800018de <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    8000447e:	409c                	lw	a5,0(s1)
    80004480:	37f9                	addiw	a5,a5,-2
    80004482:	4705                	li	a4,1
    80004484:	04f76463          	bltu	a4,a5,800044cc <filestat+0x62>
    80004488:	f84a                	sd	s2,48(sp)
    8000448a:	f44e                	sd	s3,40(sp)
    8000448c:	892a                	mv	s2,a0
    ilock(f->ip);
    8000448e:	6c88                	ld	a0,24(s1)
    80004490:	ff1fe0ef          	jal	80003480 <ilock>
    stati(f->ip, &st);
    80004494:	fb840993          	addi	s3,s0,-72
    80004498:	85ce                	mv	a1,s3
    8000449a:	6c88                	ld	a0,24(s1)
    8000449c:	b90ff0ef          	jal	8000382c <stati>
    iunlock(f->ip);
    800044a0:	6c88                	ld	a0,24(s1)
    800044a2:	88cff0ef          	jal	8000352e <iunlock>
    if (copyout(p->pagetable, p->sz, addr, (char *)&st, sizeof(st)) < 0)
    800044a6:	4761                	li	a4,24
    800044a8:	86ce                	mv	a3,s3
    800044aa:	8652                	mv	a2,s4
    800044ac:	04893583          	ld	a1,72(s2)
    800044b0:	05093503          	ld	a0,80(s2)
    800044b4:	878fd0ef          	jal	8000152c <copyout>
    800044b8:	41f5551b          	sraiw	a0,a0,0x1f
    800044bc:	7942                	ld	s2,48(sp)
    800044be:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800044c0:	60a6                	ld	ra,72(sp)
    800044c2:	6406                	ld	s0,64(sp)
    800044c4:	74e2                	ld	s1,56(sp)
    800044c6:	7a02                	ld	s4,32(sp)
    800044c8:	6161                	addi	sp,sp,80
    800044ca:	8082                	ret
  return -1;
    800044cc:	557d                	li	a0,-1
    800044ce:	bfcd                	j	800044c0 <filestat+0x56>

00000000800044d0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800044d0:	7179                	addi	sp,sp,-48
    800044d2:	f406                	sd	ra,40(sp)
    800044d4:	f022                	sd	s0,32(sp)
    800044d6:	e84a                	sd	s2,16(sp)
    800044d8:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0 || n < 0)
    800044da:	00854783          	lbu	a5,8(a0)
    800044de:	0017b793          	seqz	a5,a5
    800044e2:	01f6571b          	srliw	a4,a2,0x1f
    800044e6:	8fd9                	or	a5,a5,a4
    800044e8:	e3c5                	bnez	a5,80004588 <fileread+0xb8>
    800044ea:	ec26                	sd	s1,24(sp)
    800044ec:	e44e                	sd	s3,8(sp)
    800044ee:	84aa                	mv	s1,a0
    800044f0:	892e                	mv	s2,a1
    800044f2:	89b2                	mv	s3,a2
    return -1;

  if (f->type == FD_PIPE) {
    800044f4:	411c                	lw	a5,0(a0)
    800044f6:	4705                	li	a4,1
    800044f8:	04e78363          	beq	a5,a4,8000453e <fileread+0x6e>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    800044fc:	470d                	li	a4,3
    800044fe:	04e78763          	beq	a5,a4,8000454c <fileread+0x7c>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    80004502:	4709                	li	a4,2
    80004504:	06e79a63          	bne	a5,a4,80004578 <fileread+0xa8>
    ilock(f->ip);
    80004508:	6d08                	ld	a0,24(a0)
    8000450a:	f77fe0ef          	jal	80003480 <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000450e:	874e                	mv	a4,s3
    80004510:	5094                	lw	a3,32(s1)
    80004512:	864a                	mv	a2,s2
    80004514:	4585                	li	a1,1
    80004516:	6c88                	ld	a0,24(s1)
    80004518:	b42ff0ef          	jal	8000385a <readi>
    8000451c:	892a                	mv	s2,a0
    8000451e:	00a05563          	blez	a0,80004528 <fileread+0x58>
      f->off += r;
    80004522:	509c                	lw	a5,32(s1)
    80004524:	9fa9                	addw	a5,a5,a0
    80004526:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004528:	6c88                	ld	a0,24(s1)
    8000452a:	804ff0ef          	jal	8000352e <iunlock>
    8000452e:	64e2                	ld	s1,24(sp)
    80004530:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004532:	854a                	mv	a0,s2
    80004534:	70a2                	ld	ra,40(sp)
    80004536:	7402                	ld	s0,32(sp)
    80004538:	6942                	ld	s2,16(sp)
    8000453a:	6145                	addi	sp,sp,48
    8000453c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000453e:	6908                	ld	a0,16(a0)
    80004540:	3c6000ef          	jal	80004906 <piperead>
    80004544:	892a                	mv	s2,a0
    80004546:	64e2                	ld	s1,24(sp)
    80004548:	69a2                	ld	s3,8(sp)
    8000454a:	b7e5                	j	80004532 <fileread+0x62>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000454c:	02451783          	lh	a5,36(a0)
    80004550:	03079693          	slli	a3,a5,0x30
    80004554:	92c1                	srli	a3,a3,0x30
    80004556:	4725                	li	a4,9
    80004558:	02d76663          	bltu	a4,a3,80004584 <fileread+0xb4>
    8000455c:	0792                	slli	a5,a5,0x4
    8000455e:	0001e717          	auipc	a4,0x1e
    80004562:	65a70713          	addi	a4,a4,1626 # 80022bb8 <devsw>
    80004566:	97ba                	add	a5,a5,a4
    80004568:	639c                	ld	a5,0(a5)
    8000456a:	c395                	beqz	a5,8000458e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    8000456c:	4505                	li	a0,1
    8000456e:	9782                	jalr	a5
    80004570:	892a                	mv	s2,a0
    80004572:	64e2                	ld	s1,24(sp)
    80004574:	69a2                	ld	s3,8(sp)
    80004576:	bf75                	j	80004532 <fileread+0x62>
    panic("fileread");
    80004578:	00003517          	auipc	a0,0x3
    8000457c:	13850513          	addi	a0,a0,312 # 800076b0 <etext+0x6b0>
    80004580:	ac8fc0ef          	jal	80000848 <panic>
    80004584:	64e2                	ld	s1,24(sp)
    80004586:	69a2                	ld	s3,8(sp)
    return -1;
    80004588:	57fd                	li	a5,-1
    8000458a:	893e                	mv	s2,a5
    8000458c:	b75d                	j	80004532 <fileread+0x62>
    8000458e:	64e2                	ld	s1,24(sp)
    80004590:	69a2                	ld	s3,8(sp)
    80004592:	bfdd                	j	80004588 <fileread+0xb8>

0000000080004594 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if (f->writable == 0 || n < 0)
    80004594:	00954783          	lbu	a5,9(a0)
    80004598:	0017b793          	seqz	a5,a5
    8000459c:	01f6571b          	srliw	a4,a2,0x1f
    800045a0:	8fd9                	or	a5,a5,a4
    800045a2:	12079363          	bnez	a5,800046c8 <filewrite+0x134>
{
    800045a6:	711d                	addi	sp,sp,-96
    800045a8:	ec86                	sd	ra,88(sp)
    800045aa:	e8a2                	sd	s0,80(sp)
    800045ac:	e0ca                	sd	s2,64(sp)
    800045ae:	f456                	sd	s5,40(sp)
    800045b0:	f05a                	sd	s6,32(sp)
    800045b2:	1080                	addi	s0,sp,96
    800045b4:	892a                	mv	s2,a0
    800045b6:	8b2e                	mv	s6,a1
    800045b8:	8ab2                	mv	s5,a2
    return -1;

  if (f->type == FD_PIPE) {
    800045ba:	411c                	lw	a5,0(a0)
    800045bc:	4705                	li	a4,1
    800045be:	02e78a63          	beq	a5,a4,800045f2 <filewrite+0x5e>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    800045c2:	470d                	li	a4,3
    800045c4:	02e78b63          	beq	a5,a4,800045fa <filewrite+0x66>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    800045c8:	4709                	li	a4,2
    800045ca:	0ce79763          	bne	a5,a4,80004698 <filewrite+0x104>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    800045ce:	0ec05363          	blez	a2,800046b4 <filewrite+0x120>
    800045d2:	e4a6                	sd	s1,72(sp)
    800045d4:	fc4e                	sd	s3,56(sp)
    800045d6:	f852                	sd	s4,48(sp)
    800045d8:	ec5e                	sd	s7,24(sp)
    800045da:	e862                	sd	s8,16(sp)
    800045dc:	e466                	sd	s9,8(sp)
    int i = 0;
    800045de:	4a01                	li	s4,0
      int n1 = n - i;
      if (n1 > max)
    800045e0:	6b85                	lui	s7,0x1
    800045e2:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800045e6:	6785                	lui	a5,0x1
    800045e8:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    800045ec:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800045ee:	4c05                	li	s8,1
    800045f0:	a8ad                	j	8000466a <filewrite+0xd6>
    ret = pipewrite(f->pipe, addr, n);
    800045f2:	6908                	ld	a0,16(a0)
    800045f4:	1f6000ef          	jal	800047ea <pipewrite>
    800045f8:	a849                	j	8000468a <filewrite+0xf6>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800045fa:	02451783          	lh	a5,36(a0)
    800045fe:	03079693          	slli	a3,a5,0x30
    80004602:	92c1                	srli	a3,a3,0x30
    80004604:	4725                	li	a4,9
    80004606:	0ad76563          	bltu	a4,a3,800046b0 <filewrite+0x11c>
    8000460a:	0792                	slli	a5,a5,0x4
    8000460c:	0001e717          	auipc	a4,0x1e
    80004610:	5ac70713          	addi	a4,a4,1452 # 80022bb8 <devsw>
    80004614:	97ba                	add	a5,a5,a4
    80004616:	679c                	ld	a5,8(a5)
    80004618:	cfc1                	beqz	a5,800046b0 <filewrite+0x11c>
    ret = devsw[f->major].write(1, addr, n);
    8000461a:	4505                	li	a0,1
    8000461c:	9782                	jalr	a5
    8000461e:	a0b5                	j	8000468a <filewrite+0xf6>
      if (n1 > max)
    80004620:	2981                	sext.w	s3,s3
      begin_op();
    80004622:	8d1ff0ef          	jal	80003ef2 <begin_op>
      ilock(f->ip);
    80004626:	01893503          	ld	a0,24(s2)
    8000462a:	e57fe0ef          	jal	80003480 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000462e:	874e                	mv	a4,s3
    80004630:	02092683          	lw	a3,32(s2)
    80004634:	016a0633          	add	a2,s4,s6
    80004638:	85e2                	mv	a1,s8
    8000463a:	01893503          	ld	a0,24(s2)
    8000463e:	b0eff0ef          	jal	8000394c <writei>
    80004642:	84aa                	mv	s1,a0
    80004644:	00a05763          	blez	a0,80004652 <filewrite+0xbe>
        f->off += r;
    80004648:	02092783          	lw	a5,32(s2)
    8000464c:	9fa9                	addw	a5,a5,a0
    8000464e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004652:	01893503          	ld	a0,24(s2)
    80004656:	ed9fe0ef          	jal	8000352e <iunlock>
      end_op();
    8000465a:	925ff0ef          	jal	80003f7e <end_op>

      if (r != n1) {
    8000465e:	00999d63          	bne	s3,s1,80004678 <filewrite+0xe4>
        // error from writei
        break;
      }
      i += r;
    80004662:	01448a3b          	addw	s4,s1,s4
    while (i < n) {
    80004666:	015a5963          	bge	s4,s5,80004678 <filewrite+0xe4>
      int n1 = n - i;
    8000466a:	414a87bb          	subw	a5,s5,s4
    8000466e:	89be                	mv	s3,a5
      if (n1 > max)
    80004670:	fafbd8e3          	bge	s7,a5,80004620 <filewrite+0x8c>
    80004674:	89e6                	mv	s3,s9
    80004676:	b76d                	j	80004620 <filewrite+0x8c>
    }
    ret = (i == n ? n : -1);
    80004678:	054a9063          	bne	s5,s4,800046b8 <filewrite+0x124>
    8000467c:	8556                	mv	a0,s5
    8000467e:	64a6                	ld	s1,72(sp)
    80004680:	79e2                	ld	s3,56(sp)
    80004682:	7a42                	ld	s4,48(sp)
    80004684:	6be2                	ld	s7,24(sp)
    80004686:	6c42                	ld	s8,16(sp)
    80004688:	6ca2                	ld	s9,8(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000468a:	60e6                	ld	ra,88(sp)
    8000468c:	6446                	ld	s0,80(sp)
    8000468e:	6906                	ld	s2,64(sp)
    80004690:	7aa2                	ld	s5,40(sp)
    80004692:	7b02                	ld	s6,32(sp)
    80004694:	6125                	addi	sp,sp,96
    80004696:	8082                	ret
    80004698:	e4a6                	sd	s1,72(sp)
    8000469a:	fc4e                	sd	s3,56(sp)
    8000469c:	f852                	sd	s4,48(sp)
    8000469e:	ec5e                	sd	s7,24(sp)
    800046a0:	e862                	sd	s8,16(sp)
    800046a2:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800046a4:	00003517          	auipc	a0,0x3
    800046a8:	01c50513          	addi	a0,a0,28 # 800076c0 <etext+0x6c0>
    800046ac:	99cfc0ef          	jal	80000848 <panic>
    return -1;
    800046b0:	557d                	li	a0,-1
    800046b2:	bfe1                	j	8000468a <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800046b4:	8532                	mv	a0,a2
    800046b6:	bfd1                	j	8000468a <filewrite+0xf6>
    800046b8:	557d                	li	a0,-1
    800046ba:	64a6                	ld	s1,72(sp)
    800046bc:	79e2                	ld	s3,56(sp)
    800046be:	7a42                	ld	s4,48(sp)
    800046c0:	6be2                	ld	s7,24(sp)
    800046c2:	6c42                	ld	s8,16(sp)
    800046c4:	6ca2                	ld	s9,8(sp)
    800046c6:	b7d1                	j	8000468a <filewrite+0xf6>
    return -1;
    800046c8:	557d                	li	a0,-1
}
    800046ca:	8082                	ret

00000000800046cc <pipealloc>:
  int writeopen; // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800046cc:	7179                	addi	sp,sp,-48
    800046ce:	f406                	sd	ra,40(sp)
    800046d0:	f022                	sd	s0,32(sp)
    800046d2:	ec26                	sd	s1,24(sp)
    800046d4:	e052                	sd	s4,0(sp)
    800046d6:	1800                	addi	s0,sp,48
    800046d8:	84aa                	mv	s1,a0
    800046da:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800046dc:	0005b023          	sd	zero,0(a1)
    800046e0:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800046e4:	c21ff0ef          	jal	80004304 <filealloc>
    800046e8:	e088                	sd	a0,0(s1)
    800046ea:	c549                	beqz	a0,80004774 <pipealloc+0xa8>
    800046ec:	c19ff0ef          	jal	80004304 <filealloc>
    800046f0:	00aa3023          	sd	a0,0(s4)
    800046f4:	cd25                	beqz	a0,8000476c <pipealloc+0xa0>
    800046f6:	e84a                	sd	s2,16(sp)
    goto bad;
  if ((pi = (struct pipe *)kalloc()) == 0)
    800046f8:	c26fc0ef          	jal	80000b1e <kalloc>
    800046fc:	892a                	mv	s2,a0
    800046fe:	c12d                	beqz	a0,80004760 <pipealloc+0x94>
    80004700:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004702:	4985                	li	s3,1
    80004704:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004708:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000470c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004710:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004714:	00003597          	auipc	a1,0x3
    80004718:	fbc58593          	addi	a1,a1,-68 # 800076d0 <etext+0x6d0>
    8000471c:	c5cfc0ef          	jal	80000b78 <initlock>
  (*f0)->type = FD_PIPE;
    80004720:	609c                	ld	a5,0(s1)
    80004722:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004726:	609c                	ld	a5,0(s1)
    80004728:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000472c:	609c                	ld	a5,0(s1)
    8000472e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004732:	609c                	ld	a5,0(s1)
    80004734:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004738:	000a3783          	ld	a5,0(s4)
    8000473c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004740:	000a3783          	ld	a5,0(s4)
    80004744:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004748:	000a3783          	ld	a5,0(s4)
    8000474c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004750:	000a3783          	ld	a5,0(s4)
    80004754:	0127b823          	sd	s2,16(a5)
  return 0;
    80004758:	4501                	li	a0,0
    8000475a:	6942                	ld	s2,16(sp)
    8000475c:	69a2                	ld	s3,8(sp)
    8000475e:	a00d                	j	80004780 <pipealloc+0xb4>

bad:
  if (pi)
    kfree((char *)pi);
  if (*f0)
    80004760:	6088                	ld	a0,0(s1)
    80004762:	c119                	beqz	a0,80004768 <pipealloc+0x9c>
    80004764:	6942                	ld	s2,16(sp)
    80004766:	a029                	j	80004770 <pipealloc+0xa4>
    80004768:	6942                	ld	s2,16(sp)
    8000476a:	a029                	j	80004774 <pipealloc+0xa8>
    8000476c:	6088                	ld	a0,0(s1)
    8000476e:	c901                	beqz	a0,8000477e <pipealloc+0xb2>
    fileclose(*f0);
    80004770:	c39ff0ef          	jal	800043a8 <fileclose>
  if (*f1)
    80004774:	000a3503          	ld	a0,0(s4)
    80004778:	c119                	beqz	a0,8000477e <pipealloc+0xb2>
    fileclose(*f1);
    8000477a:	c2fff0ef          	jal	800043a8 <fileclose>
  return -1;
    8000477e:	557d                	li	a0,-1
}
    80004780:	70a2                	ld	ra,40(sp)
    80004782:	7402                	ld	s0,32(sp)
    80004784:	64e2                	ld	s1,24(sp)
    80004786:	6a02                	ld	s4,0(sp)
    80004788:	6145                	addi	sp,sp,48
    8000478a:	8082                	ret

000000008000478c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000478c:	1101                	addi	sp,sp,-32
    8000478e:	ec06                	sd	ra,24(sp)
    80004790:	e822                	sd	s0,16(sp)
    80004792:	e426                	sd	s1,8(sp)
    80004794:	e04a                	sd	s2,0(sp)
    80004796:	1000                	addi	s0,sp,32
    80004798:	84aa                	mv	s1,a0
    8000479a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000479c:	c5cfc0ef          	jal	80000bf8 <acquire>
  if (writable) {
    800047a0:	02090763          	beqz	s2,800047ce <pipeclose+0x42>
    pi->writeopen = 0;
    800047a4:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800047a8:	21848513          	addi	a0,s1,536
    800047ac:	92bfd0ef          	jal	800020d6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    800047b0:	2204a783          	lw	a5,544(s1)
    800047b4:	e781                	bnez	a5,800047bc <pipeclose+0x30>
    800047b6:	2244a783          	lw	a5,548(s1)
    800047ba:	c38d                	beqz	a5,800047dc <pipeclose+0x50>
    release(&pi->lock);
    kfree((char *)pi);
  } else
    release(&pi->lock);
    800047bc:	8526                	mv	a0,s1
    800047be:	cbefc0ef          	jal	80000c7c <release>
}
    800047c2:	60e2                	ld	ra,24(sp)
    800047c4:	6442                	ld	s0,16(sp)
    800047c6:	64a2                	ld	s1,8(sp)
    800047c8:	6902                	ld	s2,0(sp)
    800047ca:	6105                	addi	sp,sp,32
    800047cc:	8082                	ret
    pi->readopen = 0;
    800047ce:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800047d2:	21c48513          	addi	a0,s1,540
    800047d6:	901fd0ef          	jal	800020d6 <wakeup>
    800047da:	bfd9                	j	800047b0 <pipeclose+0x24>
    release(&pi->lock);
    800047dc:	8526                	mv	a0,s1
    800047de:	c9efc0ef          	jal	80000c7c <release>
    kfree((char *)pi);
    800047e2:	8526                	mv	a0,s1
    800047e4:	a52fc0ef          	jal	80000a36 <kfree>
    800047e8:	bfe9                	j	800047c2 <pipeclose+0x36>

00000000800047ea <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800047ea:	7159                	addi	sp,sp,-112
    800047ec:	f486                	sd	ra,104(sp)
    800047ee:	f0a2                	sd	s0,96(sp)
    800047f0:	eca6                	sd	s1,88(sp)
    800047f2:	e8ca                	sd	s2,80(sp)
    800047f4:	e4ce                	sd	s3,72(sp)
    800047f6:	e0d2                	sd	s4,64(sp)
    800047f8:	fc56                	sd	s5,56(sp)
    800047fa:	1880                	addi	s0,sp,112
    800047fc:	84aa                	mv	s1,a0
    800047fe:	8aae                	mv	s5,a1
    80004800:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004802:	8dcfd0ef          	jal	800018de <myproc>
    80004806:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004808:	8526                	mv	a0,s1
    8000480a:	beefc0ef          	jal	80000bf8 <acquire>
  while (i < n) {
    8000480e:	0f405a63          	blez	s4,80004902 <pipewrite+0x118>
    80004812:	f85a                	sd	s6,48(sp)
    80004814:	f45e                	sd	s7,40(sp)
    80004816:	f062                	sd	s8,32(sp)
    80004818:	ec66                	sd	s9,24(sp)
    8000481a:	e86a                	sd	s10,16(sp)
  int i = 0;
    8000481c:	4901                	li	s2,0
      release(&pi->lock);
      sleep();
      acquire(&pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    8000481e:	f9f40c13          	addi	s8,s0,-97
    80004822:	4b85                	li	s7,1
    80004824:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004826:	21848d13          	addi	s10,s1,536
      sleep_prepare(&pi->nwrite);
    8000482a:	21c48c93          	addi	s9,s1,540
    8000482e:	a0a1                	j	80004876 <pipewrite+0x8c>
      release(&pi->lock);
    80004830:	8526                	mv	a0,s1
    80004832:	c4afc0ef          	jal	80000c7c <release>
      return -1;
    80004836:	597d                	li	s2,-1
    80004838:	7b42                	ld	s6,48(sp)
    8000483a:	7ba2                	ld	s7,40(sp)
    8000483c:	7c02                	ld	s8,32(sp)
    8000483e:	6ce2                	ld	s9,24(sp)
    80004840:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004842:	854a                	mv	a0,s2
    80004844:	70a6                	ld	ra,104(sp)
    80004846:	7406                	ld	s0,96(sp)
    80004848:	64e6                	ld	s1,88(sp)
    8000484a:	6946                	ld	s2,80(sp)
    8000484c:	69a6                	ld	s3,72(sp)
    8000484e:	6a06                	ld	s4,64(sp)
    80004850:	7ae2                	ld	s5,56(sp)
    80004852:	6165                	addi	sp,sp,112
    80004854:	8082                	ret
      wakeup(&pi->nread);
    80004856:	856a                	mv	a0,s10
    80004858:	87ffd0ef          	jal	800020d6 <wakeup>
      sleep_prepare(&pi->nwrite);
    8000485c:	8566                	mv	a0,s9
    8000485e:	809fd0ef          	jal	80002066 <sleep_prepare>
      release(&pi->lock);
    80004862:	8526                	mv	a0,s1
    80004864:	c18fc0ef          	jal	80000c7c <release>
      sleep();
    80004868:	83bfd0ef          	jal	800020a2 <sleep>
      acquire(&pi->lock);
    8000486c:	8526                	mv	a0,s1
    8000486e:	b8afc0ef          	jal	80000bf8 <acquire>
  while (i < n) {
    80004872:	07495b63          	bge	s2,s4,800048e8 <pipewrite+0xfe>
    if (pi->readopen == 0 || killed(pr)) {
    80004876:	2204a783          	lw	a5,544(s1)
    8000487a:	dbdd                	beqz	a5,80004830 <pipewrite+0x46>
    8000487c:	854e                	mv	a0,s3
    8000487e:	a71fd0ef          	jal	800022ee <killed>
    80004882:	f55d                	bnez	a0,80004830 <pipewrite+0x46>
    if (pi->nwrite == pi->nread + PIPESIZE) { //DOC: pipewrite-full
    80004884:	2184a783          	lw	a5,536(s1)
    80004888:	21c4a703          	lw	a4,540(s1)
    8000488c:	2007879b          	addiw	a5,a5,512
    80004890:	fcf703e3          	beq	a4,a5,80004856 <pipewrite+0x6c>
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    80004894:	875e                	mv	a4,s7
    80004896:	015906b3          	add	a3,s2,s5
    8000489a:	8662                	mv	a2,s8
    8000489c:	0489b583          	ld	a1,72(s3)
    800048a0:	0509b503          	ld	a0,80(s3)
    800048a4:	d49fc0ef          	jal	800015ec <copyin>
    800048a8:	03650163          	beq	a0,s6,800048ca <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800048ac:	21c4a783          	lw	a5,540(s1)
    800048b0:	0017871b          	addiw	a4,a5,1
    800048b4:	20e4ae23          	sw	a4,540(s1)
    800048b8:	1ff7f793          	andi	a5,a5,511
    800048bc:	97a6                	add	a5,a5,s1
    800048be:	f9f44703          	lbu	a4,-97(s0)
    800048c2:	00e78c23          	sb	a4,24(a5)
      i++;
    800048c6:	2905                	addiw	s2,s2,1
    800048c8:	b76d                	j	80004872 <pipewrite+0x88>
        if (i == 0)
    800048ca:	00090863          	beqz	s2,800048da <pipewrite+0xf0>
    800048ce:	7b42                	ld	s6,48(sp)
    800048d0:	7ba2                	ld	s7,40(sp)
    800048d2:	7c02                	ld	s8,32(sp)
    800048d4:	6ce2                	ld	s9,24(sp)
    800048d6:	6d42                	ld	s10,16(sp)
    800048d8:	a829                	j	800048f2 <pipewrite+0x108>
          i = -1;
    800048da:	892a                	mv	s2,a0
        break;
    800048dc:	7b42                	ld	s6,48(sp)
    800048de:	7ba2                	ld	s7,40(sp)
    800048e0:	7c02                	ld	s8,32(sp)
    800048e2:	6ce2                	ld	s9,24(sp)
    800048e4:	6d42                	ld	s10,16(sp)
    800048e6:	a031                	j	800048f2 <pipewrite+0x108>
    800048e8:	7b42                	ld	s6,48(sp)
    800048ea:	7ba2                	ld	s7,40(sp)
    800048ec:	7c02                	ld	s8,32(sp)
    800048ee:	6ce2                	ld	s9,24(sp)
    800048f0:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    800048f2:	21848513          	addi	a0,s1,536
    800048f6:	fe0fd0ef          	jal	800020d6 <wakeup>
  release(&pi->lock);
    800048fa:	8526                	mv	a0,s1
    800048fc:	b80fc0ef          	jal	80000c7c <release>
  return i;
    80004900:	b789                	j	80004842 <pipewrite+0x58>
  int i = 0;
    80004902:	4901                	li	s2,0
    80004904:	b7fd                	j	800048f2 <pipewrite+0x108>

0000000080004906 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004906:	711d                	addi	sp,sp,-96
    80004908:	ec86                	sd	ra,88(sp)
    8000490a:	e8a2                	sd	s0,80(sp)
    8000490c:	e4a6                	sd	s1,72(sp)
    8000490e:	e0ca                	sd	s2,64(sp)
    80004910:	fc4e                	sd	s3,56(sp)
    80004912:	f852                	sd	s4,48(sp)
    80004914:	f456                	sd	s5,40(sp)
    80004916:	1080                	addi	s0,sp,96
    80004918:	84aa                	mv	s1,a0
    8000491a:	89ae                	mv	s3,a1
    8000491c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000491e:	fc1fc0ef          	jal	800018de <myproc>
    80004922:	892a                	mv	s2,a0
  char ch;

  acquire(&pi->lock);
    80004924:	8526                	mv	a0,s1
    80004926:	ad2fc0ef          	jal	80000bf8 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    8000492a:	2184a703          	lw	a4,536(s1)
    8000492e:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    80004932:	21848a13          	addi	s4,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    80004936:	02f71a63          	bne	a4,a5,8000496a <piperead+0x64>
    8000493a:	2244a783          	lw	a5,548(s1)
    8000493e:	c795                	beqz	a5,8000496a <piperead+0x64>
    if (killed(pr)) {
    80004940:	854a                	mv	a0,s2
    80004942:	9adfd0ef          	jal	800022ee <killed>
    80004946:	e149                	bnez	a0,800049c8 <piperead+0xc2>
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    80004948:	8552                	mv	a0,s4
    8000494a:	f1cfd0ef          	jal	80002066 <sleep_prepare>
    release(&pi->lock);
    8000494e:	8526                	mv	a0,s1
    80004950:	b2cfc0ef          	jal	80000c7c <release>
    sleep();
    80004954:	f4efd0ef          	jal	800020a2 <sleep>
    acquire(&pi->lock);
    80004958:	8526                	mv	a0,s1
    8000495a:	a9efc0ef          	jal	80000bf8 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    8000495e:	2184a703          	lw	a4,536(s1)
    80004962:	21c4a783          	lw	a5,540(s1)
    80004966:	fcf70ae3          	beq	a4,a5,8000493a <piperead+0x34>
  }
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    8000496a:	07505a63          	blez	s5,800049de <piperead+0xd8>
    8000496e:	f05a                	sd	s6,32(sp)
    80004970:	ec5e                	sd	s7,24(sp)
    80004972:	e862                	sd	s8,16(sp)
    80004974:	4a01                	li	s4,0
    if (pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    80004976:	faf40c13          	addi	s8,s0,-81
    8000497a:	4b85                	li	s7,1
    8000497c:	5b7d                	li	s6,-1
    if (pi->nread == pi->nwrite)
    8000497e:	2184a783          	lw	a5,536(s1)
    80004982:	21c4a703          	lw	a4,540(s1)
    80004986:	06f70363          	beq	a4,a5,800049ec <piperead+0xe6>
    ch = pi->data[pi->nread % PIPESIZE];
    8000498a:	1ff7f793          	andi	a5,a5,511
    8000498e:	97a6                	add	a5,a5,s1
    80004990:	0187c783          	lbu	a5,24(a5)
    80004994:	faf407a3          	sb	a5,-81(s0)
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    80004998:	875e                	mv	a4,s7
    8000499a:	86e2                	mv	a3,s8
    8000499c:	864e                	mv	a2,s3
    8000499e:	04893583          	ld	a1,72(s2)
    800049a2:	05093503          	ld	a0,80(s2)
    800049a6:	b87fc0ef          	jal	8000152c <copyout>
    800049aa:	03650463          	beq	a0,s6,800049d2 <piperead+0xcc>
      if (i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    800049ae:	2184a783          	lw	a5,536(s1)
    800049b2:	2785                	addiw	a5,a5,1
    800049b4:	20f4ac23          	sw	a5,536(s1)
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    800049b8:	2a05                	addiw	s4,s4,1
    800049ba:	0985                	addi	s3,s3,1
    800049bc:	fd4a91e3          	bne	s5,s4,8000497e <piperead+0x78>
    800049c0:	7b02                	ld	s6,32(sp)
    800049c2:	6be2                	ld	s7,24(sp)
    800049c4:	6c42                	ld	s8,16(sp)
    800049c6:	a035                	j	800049f2 <piperead+0xec>
      release(&pi->lock);
    800049c8:	8526                	mv	a0,s1
    800049ca:	ab2fc0ef          	jal	80000c7c <release>
      return -1;
    800049ce:	5a7d                	li	s4,-1
    800049d0:	a805                	j	80004a00 <piperead+0xfa>
      if (i == 0)
    800049d2:	000a0863          	beqz	s4,800049e2 <piperead+0xdc>
    800049d6:	7b02                	ld	s6,32(sp)
    800049d8:	6be2                	ld	s7,24(sp)
    800049da:	6c42                	ld	s8,16(sp)
    800049dc:	a819                	j	800049f2 <piperead+0xec>
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    800049de:	4a01                	li	s4,0
    800049e0:	a809                	j	800049f2 <piperead+0xec>
        i = -1;
    800049e2:	8a2a                	mv	s4,a0
    800049e4:	7b02                	ld	s6,32(sp)
    800049e6:	6be2                	ld	s7,24(sp)
    800049e8:	6c42                	ld	s8,16(sp)
    800049ea:	a021                	j	800049f2 <piperead+0xec>
    800049ec:	7b02                	ld	s6,32(sp)
    800049ee:	6be2                	ld	s7,24(sp)
    800049f0:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nwrite); //DOC: piperead-wakeup
    800049f2:	21c48513          	addi	a0,s1,540
    800049f6:	ee0fd0ef          	jal	800020d6 <wakeup>
  release(&pi->lock);
    800049fa:	8526                	mv	a0,s1
    800049fc:	a80fc0ef          	jal	80000c7c <release>
  return i;
}
    80004a00:	8552                	mv	a0,s4
    80004a02:	60e6                	ld	ra,88(sp)
    80004a04:	6446                	ld	s0,80(sp)
    80004a06:	64a6                	ld	s1,72(sp)
    80004a08:	6906                	ld	s2,64(sp)
    80004a0a:	79e2                	ld	s3,56(sp)
    80004a0c:	7a42                	ld	s4,48(sp)
    80004a0e:	7aa2                	ld	s5,40(sp)
    80004a10:	6125                	addi	sp,sp,96
    80004a12:	8082                	ret

0000000080004a14 <flags2perm>:
static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int
flags2perm(int flags)
{
    80004a14:	1141                	addi	sp,sp,-16
    80004a16:	e406                	sd	ra,8(sp)
    80004a18:	e022                	sd	s0,0(sp)
    80004a1a:	0800                	addi	s0,sp,16
    80004a1c:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1)
    80004a1e:	0035151b          	slliw	a0,a0,0x3
    80004a22:	8921                	andi	a0,a0,8
    perm = PTE_X;
  if (flags & 0x2)
    80004a24:	8b89                	andi	a5,a5,2
    80004a26:	c399                	beqz	a5,80004a2c <flags2perm+0x18>
    perm |= PTE_W;
    80004a28:	00456513          	ori	a0,a0,4
  return perm;
}
    80004a2c:	60a2                	ld	ra,8(sp)
    80004a2e:	6402                	ld	s0,0(sp)
    80004a30:	0141                	addi	sp,sp,16
    80004a32:	8082                	ret

0000000080004a34 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80004a34:	df010113          	addi	sp,sp,-528
    80004a38:	20113423          	sd	ra,520(sp)
    80004a3c:	20813023          	sd	s0,512(sp)
    80004a40:	ffa6                	sd	s1,504(sp)
    80004a42:	fbca                	sd	s2,496(sp)
    80004a44:	0c00                	addi	s0,sp,528
    80004a46:	892a                	mv	s2,a0
    80004a48:	e0a43023          	sd	a0,-512(s0)
    80004a4c:	deb43c23          	sd	a1,-520(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004a50:	e8ffc0ef          	jal	800018de <myproc>
    80004a54:	84aa                	mv	s1,a0

  begin_op();
    80004a56:	c9cff0ef          	jal	80003ef2 <begin_op>

  // Open the executable file.
  if ((ip = namei(path)) == 0) {
    80004a5a:	854a                	mv	a0,s2
    80004a5c:	ab8ff0ef          	jal	80003d14 <namei>
    80004a60:	c931                	beqz	a0,80004ab4 <kexec+0x80>
    80004a62:	f3d2                	sd	s4,480(sp)
    80004a64:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004a66:	a1bfe0ef          	jal	80003480 <ilock>

  // Read the ELF header.
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004a6a:	04000713          	li	a4,64
    80004a6e:	4681                	li	a3,0
    80004a70:	e5040613          	addi	a2,s0,-432
    80004a74:	4581                	li	a1,0
    80004a76:	8552                	mv	a0,s4
    80004a78:	de3fe0ef          	jal	8000385a <readi>
    80004a7c:	04000793          	li	a5,64
    80004a80:	00f51a63          	bne	a0,a5,80004a94 <kexec+0x60>
    goto bad;

  // Is this really an ELF file?
  if (elf.magic != ELF_MAGIC)
    80004a84:	e5042703          	lw	a4,-432(s0)
    80004a88:	464c47b7          	lui	a5,0x464c4
    80004a8c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004a90:	02f70563          	beq	a4,a5,80004aba <kexec+0x86>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    80004a94:	8552                	mv	a0,s4
    80004a96:	c3ffe0ef          	jal	800036d4 <iunlockput>
    end_op();
    80004a9a:	ce4ff0ef          	jal	80003f7e <end_op>
    80004a9e:	7a1e                	ld	s4,480(sp)
    return -1;
    80004aa0:	557d                	li	a0,-1
  }
  return -1;
}
    80004aa2:	20813083          	ld	ra,520(sp)
    80004aa6:	20013403          	ld	s0,512(sp)
    80004aaa:	74fe                	ld	s1,504(sp)
    80004aac:	795e                	ld	s2,496(sp)
    80004aae:	21010113          	addi	sp,sp,528
    80004ab2:	8082                	ret
    end_op();
    80004ab4:	ccaff0ef          	jal	80003f7e <end_op>
    return -1;
    80004ab8:	b7e5                	j	80004aa0 <kexec+0x6c>
    80004aba:	ebda                	sd	s6,464(sp)
  if ((pagetable = proc_pagetable(p)) == 0)
    80004abc:	8526                	mv	a0,s1
    80004abe:	fa3fc0ef          	jal	80001a60 <proc_pagetable>
    80004ac2:	8b2a                	mv	s6,a0
    80004ac4:	26050263          	beqz	a0,80004d28 <kexec+0x2f4>
    80004ac8:	f7ce                	sd	s3,488(sp)
    80004aca:	efd6                	sd	s5,472(sp)
    80004acc:	e7de                	sd	s7,456(sp)
    80004ace:	e3e2                	sd	s8,448(sp)
    80004ad0:	ff66                	sd	s9,440(sp)
    80004ad2:	fb6a                	sd	s10,432(sp)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004ad4:	e8845783          	lhu	a5,-376(s0)
    80004ad8:	12078763          	beqz	a5,80004c06 <kexec+0x1d2>
    80004adc:	f76e                	sd	s11,424(sp)
    80004ade:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004ae2:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004ae4:	4d01                	li	s10,0
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004ae6:	03800d93          	li	s11,56

  for (i = 0; i < sz; i += PGSIZE) {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    if (sz - i < PGSIZE)
    80004aea:	6c85                	lui	s9,0x1
    80004aec:	6a85                	lui	s5,0x1
    80004aee:	a085                	j	80004b4e <kexec+0x11a>
      panic("loadseg: address should exist");
    80004af0:	00003517          	auipc	a0,0x3
    80004af4:	be850513          	addi	a0,a0,-1048 # 800076d8 <etext+0x6d8>
    80004af8:	d51fb0ef          	jal	80000848 <panic>
    if (sz - i < PGSIZE)
    80004afc:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    80004afe:	874a                	mv	a4,s2
    80004b00:	009b86bb          	addw	a3,s7,s1
    80004b04:	4581                	li	a1,0
    80004b06:	8552                	mv	a0,s4
    80004b08:	d53fe0ef          	jal	8000385a <readi>
    80004b0c:	22a91263          	bne	s2,a0,80004d30 <kexec+0x2fc>
  for (i = 0; i < sz; i += PGSIZE) {
    80004b10:	009a84bb          	addw	s1,s5,s1
    80004b14:	0334f263          	bgeu	s1,s3,80004b38 <kexec+0x104>
    pa = walkaddr(pagetable, va + i);
    80004b18:	02049593          	slli	a1,s1,0x20
    80004b1c:	9181                	srli	a1,a1,0x20
    80004b1e:	95e2                	add	a1,a1,s8
    80004b20:	855a                	mv	a0,s6
    80004b22:	cb6fc0ef          	jal	80000fd8 <walkaddr>
    80004b26:	862a                	mv	a2,a0
    if (pa == 0)
    80004b28:	d561                	beqz	a0,80004af0 <kexec+0xbc>
    if (sz - i < PGSIZE)
    80004b2a:	409987bb          	subw	a5,s3,s1
    80004b2e:	893e                	mv	s2,a5
    80004b30:	fcfcf6e3          	bgeu	s9,a5,80004afc <kexec+0xc8>
    80004b34:	8956                	mv	s2,s5
    80004b36:	b7d9                	j	80004afc <kexec+0xc8>
    sz = sz1;
    80004b38:	df043903          	ld	s2,-528(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004b3c:	2d05                	addiw	s10,s10,1
    80004b3e:	e0843783          	ld	a5,-504(s0)
    80004b42:	0387869b          	addiw	a3,a5,56
    80004b46:	e8845783          	lhu	a5,-376(s0)
    80004b4a:	06fd5863          	bge	s10,a5,80004bba <kexec+0x186>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004b4e:	e0d43423          	sd	a3,-504(s0)
    80004b52:	876e                	mv	a4,s11
    80004b54:	e1840613          	addi	a2,s0,-488
    80004b58:	4581                	li	a1,0
    80004b5a:	8552                	mv	a0,s4
    80004b5c:	cfffe0ef          	jal	8000385a <readi>
    80004b60:	1db51663          	bne	a0,s11,80004d2c <kexec+0x2f8>
    if (ph.type != ELF_PROG_LOAD)
    80004b64:	e1842783          	lw	a5,-488(s0)
    80004b68:	4705                	li	a4,1
    80004b6a:	fce799e3          	bne	a5,a4,80004b3c <kexec+0x108>
    if (ph.memsz < ph.filesz)
    80004b6e:	e4043483          	ld	s1,-448(s0)
    80004b72:	e3843783          	ld	a5,-456(s0)
    80004b76:	1af4eb63          	bltu	s1,a5,80004d2c <kexec+0x2f8>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    80004b7a:	e2843783          	ld	a5,-472(s0)
    80004b7e:	94be                	add	s1,s1,a5
    80004b80:	1af4e663          	bltu	s1,a5,80004d2c <kexec+0x2f8>
    if (ph.vaddr % PGSIZE != 0)
    80004b84:	17d2                	slli	a5,a5,0x34
    80004b86:	1a079363          	bnez	a5,80004d2c <kexec+0x2f8>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    80004b8a:	e1c42503          	lw	a0,-484(s0)
    80004b8e:	e87ff0ef          	jal	80004a14 <flags2perm>
    80004b92:	86aa                	mv	a3,a0
    80004b94:	8626                	mv	a2,s1
    80004b96:	85ca                	mv	a1,s2
    80004b98:	855a                	mv	a0,s6
    80004b9a:	f0cfc0ef          	jal	800012a6 <uvmalloc>
    80004b9e:	dea43823          	sd	a0,-528(s0)
    80004ba2:	18050563          	beqz	a0,80004d2c <kexec+0x2f8>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004ba6:	e3842983          	lw	s3,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80004baa:	f80987e3          	beqz	s3,80004b38 <kexec+0x104>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004bae:	e2843c03          	ld	s8,-472(s0)
    80004bb2:	e2042b83          	lw	s7,-480(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80004bb6:	4481                	li	s1,0
    80004bb8:	b785                	j	80004b18 <kexec+0xe4>
    80004bba:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004bbc:	8552                	mv	a0,s4
    80004bbe:	b17fe0ef          	jal	800036d4 <iunlockput>
  end_op();
    80004bc2:	bbcff0ef          	jal	80003f7e <end_op>
  p = myproc();
    80004bc6:	d19fc0ef          	jal	800018de <myproc>
    80004bca:	89aa                	mv	s3,a0
  uint64 oldsz = p->sz;
    80004bcc:	04853a03          	ld	s4,72(a0)
  sz = PGROUNDUP(sz);
    80004bd0:	6485                	lui	s1,0x1
    80004bd2:	14fd                	addi	s1,s1,-1 # fff <_entry-0x7ffff001>
    80004bd4:	94ca                	add	s1,s1,s2
    80004bd6:	77fd                	lui	a5,0xfffff
    80004bd8:	8cfd                	and	s1,s1,a5
  if ((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK + 1) * PGSIZE, PTE_W)) ==
    80004bda:	4691                	li	a3,4
    80004bdc:	6609                	lui	a2,0x2
    80004bde:	9626                	add	a2,a2,s1
    80004be0:	85a6                	mv	a1,s1
    80004be2:	855a                	mv	a0,s6
    80004be4:	ec2fc0ef          	jal	800012a6 <uvmalloc>
    80004be8:	8aaa                	mv	s5,a0
    80004bea:	e105                	bnez	a0,80004c0a <kexec+0x1d6>
    proc_freepagetable(pagetable, sz);
    80004bec:	85a6                	mv	a1,s1
    80004bee:	855a                	mv	a0,s6
    80004bf0:	ef3fc0ef          	jal	80001ae2 <proc_freepagetable>
  if (ip) {
    80004bf4:	79be                	ld	s3,488(sp)
    80004bf6:	7a1e                	ld	s4,480(sp)
    80004bf8:	6afe                	ld	s5,472(sp)
    80004bfa:	6b5e                	ld	s6,464(sp)
    80004bfc:	6bbe                	ld	s7,456(sp)
    80004bfe:	6c1e                	ld	s8,448(sp)
    80004c00:	7cfa                	ld	s9,440(sp)
    80004c02:	7d5a                	ld	s10,432(sp)
    80004c04:	bd71                	j	80004aa0 <kexec+0x6c>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004c06:	4901                	li	s2,0
    80004c08:	bf55                	j	80004bbc <kexec+0x188>
  uvmclear(pagetable, sz - (USERSTACK + 1) * PGSIZE);
    80004c0a:	75f9                	lui	a1,0xffffe
    80004c0c:	95aa                	add	a1,a1,a0
    80004c0e:	855a                	mv	a0,s6
    80004c10:	85ffc0ef          	jal	8000146e <uvmclear>
  stackbase = sp - USERSTACK * PGSIZE;
    80004c14:	7bfd                	lui	s7,0xfffff
    80004c16:	9bd6                	add	s7,s7,s5
  for (argc = 0; argv[argc]; argc++) {
    80004c18:	df843783          	ld	a5,-520(s0)
    80004c1c:	6388                	ld	a0,0(a5)
    80004c1e:	cd3d                	beqz	a0,80004c9c <kexec+0x268>
  sp = sz;
    80004c20:	8c56                	mv	s8,s5
  for (argc = 0; argv[argc]; argc++) {
    80004c22:	4481                	li	s1,0
    ustack[argc] = sp;
    80004c24:	e9040913          	addi	s2,s0,-368
    sp -= strlen(argv[argc]) + 1;
    80004c28:	a0cfc0ef          	jal	80000e34 <strlen>
    80004c2c:	0015079b          	addiw	a5,a0,1
    80004c30:	40fc07b3          	sub	a5,s8,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004c34:	ff07fc13          	andi	s8,a5,-16
    if (sp < stackbase)
    80004c38:	077c6063          	bltu	s8,s7,80004c98 <kexec+0x264>
    if (copyout(pagetable, sz, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004c3c:	df843d03          	ld	s10,-520(s0)
    80004c40:	000d3c83          	ld	s9,0(s10)
    80004c44:	8566                	mv	a0,s9
    80004c46:	9eefc0ef          	jal	80000e34 <strlen>
    80004c4a:	0015071b          	addiw	a4,a0,1
    80004c4e:	86e6                	mv	a3,s9
    80004c50:	8662                	mv	a2,s8
    80004c52:	85d6                	mv	a1,s5
    80004c54:	855a                	mv	a0,s6
    80004c56:	8d7fc0ef          	jal	8000152c <copyout>
    80004c5a:	02054f63          	bltz	a0,80004c98 <kexec+0x264>
    ustack[argc] = sp;
    80004c5e:	00349793          	slli	a5,s1,0x3
    80004c62:	97ca                	add	a5,a5,s2
    80004c64:	0187b023          	sd	s8,0(a5) # fffffffffffff000 <end+0xffffffff7ffdb2b0>
  for (argc = 0; argv[argc]; argc++) {
    80004c68:	0485                	addi	s1,s1,1
    80004c6a:	008d0793          	addi	a5,s10,8
    80004c6e:	def43c23          	sd	a5,-520(s0)
    80004c72:	008d3503          	ld	a0,8(s10)
    80004c76:	f94d                	bnez	a0,80004c28 <kexec+0x1f4>
  ustack[argc] = 0;
    80004c78:	00349793          	slli	a5,s1,0x3
    80004c7c:	f9040713          	addi	a4,s0,-112
    80004c80:	97ba                	add	a5,a5,a4
    80004c82:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    80004c86:	00148713          	addi	a4,s1,1
    80004c8a:	070e                	slli	a4,a4,0x3
    80004c8c:	40ec0933          	sub	s2,s8,a4
  sp -= sp % 16;
    80004c90:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase)
    80004c94:	01797763          	bgeu	s2,s7,80004ca2 <kexec+0x26e>
  sz = sz1;
    80004c98:	84d6                	mv	s1,s5
    80004c9a:	bf89                	j	80004bec <kexec+0x1b8>
  sp = sz;
    80004c9c:	8c56                	mv	s8,s5
  for (argc = 0; argv[argc]; argc++) {
    80004c9e:	4481                	li	s1,0
    80004ca0:	bfe1                	j	80004c78 <kexec+0x244>
  if (copyout(pagetable, sz, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) <
    80004ca2:	e9040693          	addi	a3,s0,-368
    80004ca6:	864a                	mv	a2,s2
    80004ca8:	85d6                	mv	a1,s5
    80004caa:	855a                	mv	a0,s6
    80004cac:	881fc0ef          	jal	8000152c <copyout>
    80004cb0:	fe0544e3          	bltz	a0,80004c98 <kexec+0x264>
  p->trapframe->a1 = sp;
    80004cb4:	0589b783          	ld	a5,88(s3)
    80004cb8:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    80004cbc:	e0043783          	ld	a5,-512(s0)
    80004cc0:	0007c703          	lbu	a4,0(a5)
    80004cc4:	cf11                	beqz	a4,80004ce0 <kexec+0x2ac>
    80004cc6:	0785                	addi	a5,a5,1
    if (*s == '/')
    80004cc8:	02f00693          	li	a3,47
    80004ccc:	a029                	j	80004cd6 <kexec+0x2a2>
  for (last = s = path; *s; s++)
    80004cce:	0785                	addi	a5,a5,1
    80004cd0:	fff7c703          	lbu	a4,-1(a5)
    80004cd4:	c711                	beqz	a4,80004ce0 <kexec+0x2ac>
    if (*s == '/')
    80004cd6:	fed71ce3          	bne	a4,a3,80004cce <kexec+0x29a>
      last = s + 1;
    80004cda:	e0f43023          	sd	a5,-512(s0)
    80004cde:	bfc5                	j	80004cce <kexec+0x29a>
  safestrcpy(p->name, last, sizeof(p->name));
    80004ce0:	4641                	li	a2,16
    80004ce2:	e0043583          	ld	a1,-512(s0)
    80004ce6:	15898513          	addi	a0,s3,344
    80004cea:	914fc0ef          	jal	80000dfe <safestrcpy>
  oldpagetable = p->pagetable;
    80004cee:	0509b503          	ld	a0,80(s3)
  p->pagetable = pagetable;
    80004cf2:	0569b823          	sd	s6,80(s3)
  p->sz = sz;
    80004cf6:	0559b423          	sd	s5,72(s3)
  p->trapframe->epc = elf.entry; // initial program counter = ulib.c:start()
    80004cfa:	0589b783          	ld	a5,88(s3)
    80004cfe:	e6843703          	ld	a4,-408(s0)
    80004d02:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    80004d04:	0589b783          	ld	a5,88(s3)
    80004d08:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004d0c:	85d2                	mv	a1,s4
    80004d0e:	dd5fc0ef          	jal	80001ae2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004d12:	0004851b          	sext.w	a0,s1
    80004d16:	79be                	ld	s3,488(sp)
    80004d18:	7a1e                	ld	s4,480(sp)
    80004d1a:	6afe                	ld	s5,472(sp)
    80004d1c:	6b5e                	ld	s6,464(sp)
    80004d1e:	6bbe                	ld	s7,456(sp)
    80004d20:	6c1e                	ld	s8,448(sp)
    80004d22:	7cfa                	ld	s9,440(sp)
    80004d24:	7d5a                	ld	s10,432(sp)
    80004d26:	bbb5                	j	80004aa2 <kexec+0x6e>
    80004d28:	6b5e                	ld	s6,464(sp)
    80004d2a:	b3ad                	j	80004a94 <kexec+0x60>
    return -1;
    80004d2c:	df243823          	sd	s2,-528(s0)
    proc_freepagetable(pagetable, sz);
    80004d30:	df043583          	ld	a1,-528(s0)
    80004d34:	855a                	mv	a0,s6
    80004d36:	dadfc0ef          	jal	80001ae2 <proc_freepagetable>
  if (ip) {
    80004d3a:	79be                	ld	s3,488(sp)
    80004d3c:	6afe                	ld	s5,472(sp)
    80004d3e:	6b5e                	ld	s6,464(sp)
    80004d40:	6bbe                	ld	s7,456(sp)
    80004d42:	6c1e                	ld	s8,448(sp)
    80004d44:	7cfa                	ld	s9,440(sp)
    80004d46:	7d5a                	ld	s10,432(sp)
    80004d48:	7dba                	ld	s11,424(sp)
    80004d4a:	b3a9                	j	80004a94 <kexec+0x60>

0000000080004d4c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004d4c:	7179                	addi	sp,sp,-48
    80004d4e:	f406                	sd	ra,40(sp)
    80004d50:	f022                	sd	s0,32(sp)
    80004d52:	ec26                	sd	s1,24(sp)
    80004d54:	e84a                	sd	s2,16(sp)
    80004d56:	1800                	addi	s0,sp,48
    80004d58:	892e                	mv	s2,a1
    80004d5a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004d5c:	fdc40593          	addi	a1,s0,-36
    80004d60:	c87fd0ef          	jal	800029e6 <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004d64:	fdc42703          	lw	a4,-36(s0)
    80004d68:	47bd                	li	a5,15
    80004d6a:	02e7e963          	bltu	a5,a4,80004d9c <argfd+0x50>
    80004d6e:	b71fc0ef          	jal	800018de <myproc>
    80004d72:	fdc42703          	lw	a4,-36(s0)
    80004d76:	01a70793          	addi	a5,a4,26
    80004d7a:	078e                	slli	a5,a5,0x3
    80004d7c:	953e                	add	a0,a0,a5
    80004d7e:	611c                	ld	a5,0(a0)
    80004d80:	cf91                	beqz	a5,80004d9c <argfd+0x50>
    return -1;
  if (pfd)
    80004d82:	00090463          	beqz	s2,80004d8a <argfd+0x3e>
    *pfd = fd;
    80004d86:	00e92023          	sw	a4,0(s2)
  if (pf)
    80004d8a:	c091                	beqz	s1,80004d8e <argfd+0x42>
    *pf = f;
    80004d8c:	e09c                	sd	a5,0(s1)
  return 0;
    80004d8e:	4501                	li	a0,0
}
    80004d90:	70a2                	ld	ra,40(sp)
    80004d92:	7402                	ld	s0,32(sp)
    80004d94:	64e2                	ld	s1,24(sp)
    80004d96:	6942                	ld	s2,16(sp)
    80004d98:	6145                	addi	sp,sp,48
    80004d9a:	8082                	ret
    return -1;
    80004d9c:	557d                	li	a0,-1
    80004d9e:	bfcd                	j	80004d90 <argfd+0x44>

0000000080004da0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004da0:	1101                	addi	sp,sp,-32
    80004da2:	ec06                	sd	ra,24(sp)
    80004da4:	e822                	sd	s0,16(sp)
    80004da6:	e426                	sd	s1,8(sp)
    80004da8:	1000                	addi	s0,sp,32
    80004daa:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004dac:	b33fc0ef          	jal	800018de <myproc>
    80004db0:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    80004db2:	0d050793          	addi	a5,a0,208
    80004db6:	4501                	li	a0,0
    80004db8:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    80004dba:	6398                	ld	a4,0(a5)
    80004dbc:	cb19                	beqz	a4,80004dd2 <fdalloc+0x32>
  for (fd = 0; fd < NOFILE; fd++) {
    80004dbe:	2505                	addiw	a0,a0,1
    80004dc0:	07a1                	addi	a5,a5,8
    80004dc2:	fed51ce3          	bne	a0,a3,80004dba <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004dc6:	557d                	li	a0,-1
}
    80004dc8:	60e2                	ld	ra,24(sp)
    80004dca:	6442                	ld	s0,16(sp)
    80004dcc:	64a2                	ld	s1,8(sp)
    80004dce:	6105                	addi	sp,sp,32
    80004dd0:	8082                	ret
      p->ofile[fd] = f;
    80004dd2:	01a50793          	addi	a5,a0,26
    80004dd6:	078e                	slli	a5,a5,0x3
    80004dd8:	963e                	add	a2,a2,a5
    80004dda:	e204                	sd	s1,0(a2)
      return fd;
    80004ddc:	b7f5                	j	80004dc8 <fdalloc+0x28>

0000000080004dde <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    80004dde:	715d                	addi	sp,sp,-80
    80004de0:	e486                	sd	ra,72(sp)
    80004de2:	e0a2                	sd	s0,64(sp)
    80004de4:	fc26                	sd	s1,56(sp)
    80004de6:	f84a                	sd	s2,48(sp)
    80004de8:	f44e                	sd	s3,40(sp)
    80004dea:	ec56                	sd	s5,24(sp)
    80004dec:	e85a                	sd	s6,16(sp)
    80004dee:	0880                	addi	s0,sp,80
    80004df0:	89ae                	mv	s3,a1
    80004df2:	8ab2                	mv	s5,a2
    80004df4:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    80004df6:	fb040593          	addi	a1,s0,-80
    80004dfa:	f35fe0ef          	jal	80003d2e <nameiparent>
    80004dfe:	84aa                	mv	s1,a0
    return 0;
    80004e00:	892a                	mv	s2,a0
  if ((dp = nameiparent(path, name)) == 0)
    80004e02:	cd31                	beqz	a0,80004e5e <create+0x80>

  ilock(dp);
    80004e04:	e7cfe0ef          	jal	80003480 <ilock>

  if (dp->nlink == 0) {
    80004e08:	04a49783          	lh	a5,74(s1)
    80004e0c:	c3bd                	beqz	a5,80004e72 <create+0x94>
    iunlockput(dp);
    return 0;
  }

  // a new directory's ".." would push dp->nlink past its maximum
  if (type == T_DIR && dp->nlink >= NLINK_MAX) {
    80004e0e:	7761                	lui	a4,0xffff8
    80004e10:	0705                	addi	a4,a4,1 # ffffffffffff8001 <end+0xffffffff7ffd42b1>
    80004e12:	97ba                	add	a5,a5,a4
    80004e14:	0017b793          	seqz	a5,a5
    80004e18:	fff98713          	addi	a4,s3,-1
    80004e1c:	00173713          	seqz	a4,a4
    80004e20:	8ff9                	and	a5,a5,a4
    80004e22:	efa1                	bnez	a5,80004e7a <create+0x9c>
    iunlockput(dp);
    return 0;
  }

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80004e24:	4601                	li	a2,0
    80004e26:	fb040593          	addi	a1,s0,-80
    80004e2a:	8526                	mv	a0,s1
    80004e2c:	c3ffe0ef          	jal	80003a6a <dirlookup>
    80004e30:	892a                	mv	s2,a0
    80004e32:	c921                	beqz	a0,80004e82 <create+0xa4>
    iunlockput(dp);
    80004e34:	8526                	mv	a0,s1
    80004e36:	89ffe0ef          	jal	800036d4 <iunlockput>
    ilock(ip);
    80004e3a:	854a                	mv	a0,s2
    80004e3c:	e44fe0ef          	jal	80003480 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004e40:	4789                	li	a5,2
    80004e42:	00f99a63          	bne	s3,a5,80004e56 <create+0x78>
    80004e46:	04495783          	lhu	a5,68(s2)
    80004e4a:	37f9                	addiw	a5,a5,-2
    80004e4c:	17c2                	slli	a5,a5,0x30
    80004e4e:	93c1                	srli	a5,a5,0x30
    80004e50:	4705                	li	a4,1
    80004e52:	00f77663          	bgeu	a4,a5,80004e5e <create+0x80>
      return ip;
    iunlockput(ip);
    80004e56:	854a                	mv	a0,s2
    80004e58:	87dfe0ef          	jal	800036d4 <iunlockput>
    return 0;
    80004e5c:	4901                	li	s2,0
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004e5e:	854a                	mv	a0,s2
    80004e60:	60a6                	ld	ra,72(sp)
    80004e62:	6406                	ld	s0,64(sp)
    80004e64:	74e2                	ld	s1,56(sp)
    80004e66:	7942                	ld	s2,48(sp)
    80004e68:	79a2                	ld	s3,40(sp)
    80004e6a:	6ae2                	ld	s5,24(sp)
    80004e6c:	6b42                	ld	s6,16(sp)
    80004e6e:	6161                	addi	sp,sp,80
    80004e70:	8082                	ret
    iunlockput(dp);
    80004e72:	8526                	mv	a0,s1
    80004e74:	861fe0ef          	jal	800036d4 <iunlockput>
    return 0;
    80004e78:	b7d5                	j	80004e5c <create+0x7e>
    iunlockput(dp);
    80004e7a:	8526                	mv	a0,s1
    80004e7c:	859fe0ef          	jal	800036d4 <iunlockput>
    return 0;
    80004e80:	bff1                	j	80004e5c <create+0x7e>
    80004e82:	f052                	sd	s4,32(sp)
  if ((ip = ialloc(dp->dev, type)) == 0) {
    80004e84:	85ce                	mv	a1,s3
    80004e86:	4088                	lw	a0,0(s1)
    80004e88:	c88fe0ef          	jal	80003310 <ialloc>
    80004e8c:	8a2a                	mv	s4,a0
    80004e8e:	cd1d                	beqz	a0,80004ecc <create+0xee>
  ilock(ip);
    80004e90:	df0fe0ef          	jal	80003480 <ilock>
  ip->major = major;
    80004e94:	055a1323          	sh	s5,70(s4)
  ip->minor = minor;
    80004e98:	056a1423          	sh	s6,72(s4)
  ip->nlink = 1;
    80004e9c:	4705                	li	a4,1
    80004e9e:	04ea1523          	sh	a4,74(s4)
  iupdate(ip);
    80004ea2:	8552                	mv	a0,s4
    80004ea4:	d28fe0ef          	jal	800033cc <iupdate>
  if (type == T_DIR) { // Create . and .. entries.
    80004ea8:	4785                	li	a5,1
    80004eaa:	02f98563          	beq	s3,a5,80004ed4 <create+0xf6>
  if (dirlink(dp, name, ip->inum) < 0)
    80004eae:	004a2603          	lw	a2,4(s4)
    80004eb2:	fb040593          	addi	a1,s0,-80
    80004eb6:	8526                	mv	a0,s1
    80004eb8:	db3fe0ef          	jal	80003c6a <dirlink>
    80004ebc:	06054363          	bltz	a0,80004f22 <create+0x144>
  iunlockput(dp);
    80004ec0:	8526                	mv	a0,s1
    80004ec2:	813fe0ef          	jal	800036d4 <iunlockput>
    return 0;
    80004ec6:	8952                	mv	s2,s4
    80004ec8:	7a02                	ld	s4,32(sp)
    80004eca:	bf51                	j	80004e5e <create+0x80>
    iunlockput(dp);
    80004ecc:	8526                	mv	a0,s1
    80004ece:	807fe0ef          	jal	800036d4 <iunlockput>
    return 0;
    80004ed2:	bfd5                	j	80004ec6 <create+0xe8>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004ed4:	004a2603          	lw	a2,4(s4)
    80004ed8:	00003597          	auipc	a1,0x3
    80004edc:	82058593          	addi	a1,a1,-2016 # 800076f8 <etext+0x6f8>
    80004ee0:	8552                	mv	a0,s4
    80004ee2:	d89fe0ef          	jal	80003c6a <dirlink>
    80004ee6:	02054e63          	bltz	a0,80004f22 <create+0x144>
    80004eea:	40d0                	lw	a2,4(s1)
    80004eec:	00003597          	auipc	a1,0x3
    80004ef0:	81458593          	addi	a1,a1,-2028 # 80007700 <etext+0x700>
    80004ef4:	8552                	mv	a0,s4
    80004ef6:	d75fe0ef          	jal	80003c6a <dirlink>
    80004efa:	02054463          	bltz	a0,80004f22 <create+0x144>
  if (dirlink(dp, name, ip->inum) < 0)
    80004efe:	004a2603          	lw	a2,4(s4)
    80004f02:	fb040593          	addi	a1,s0,-80
    80004f06:	8526                	mv	a0,s1
    80004f08:	d63fe0ef          	jal	80003c6a <dirlink>
    80004f0c:	00054b63          	bltz	a0,80004f22 <create+0x144>
    dp->nlink++; // for ".."
    80004f10:	04a4d783          	lhu	a5,74(s1)
    80004f14:	2785                	addiw	a5,a5,1
    80004f16:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004f1a:	8526                	mv	a0,s1
    80004f1c:	cb0fe0ef          	jal	800033cc <iupdate>
    80004f20:	b745                	j	80004ec0 <create+0xe2>
  ip->nlink = 0;
    80004f22:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004f26:	8552                	mv	a0,s4
    80004f28:	ca4fe0ef          	jal	800033cc <iupdate>
  iunlockput(ip);
    80004f2c:	8552                	mv	a0,s4
    80004f2e:	fa6fe0ef          	jal	800036d4 <iunlockput>
  iunlockput(dp);
    80004f32:	8526                	mv	a0,s1
    80004f34:	fa0fe0ef          	jal	800036d4 <iunlockput>
  return 0;
    80004f38:	7a02                	ld	s4,32(sp)
    80004f3a:	b715                	j	80004e5e <create+0x80>

0000000080004f3c <sys_dup>:
{
    80004f3c:	7179                	addi	sp,sp,-48
    80004f3e:	f406                	sd	ra,40(sp)
    80004f40:	f022                	sd	s0,32(sp)
    80004f42:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    80004f44:	fd840613          	addi	a2,s0,-40
    80004f48:	4581                	li	a1,0
    80004f4a:	4501                	li	a0,0
    80004f4c:	e01ff0ef          	jal	80004d4c <argfd>
    80004f50:	02054863          	bltz	a0,80004f80 <sys_dup+0x44>
    80004f54:	ec26                	sd	s1,24(sp)
    80004f56:	e84a                	sd	s2,16(sp)
  if ((fd = fdalloc(f)) < 0)
    80004f58:	fd843483          	ld	s1,-40(s0)
    80004f5c:	8526                	mv	a0,s1
    80004f5e:	e43ff0ef          	jal	80004da0 <fdalloc>
    80004f62:	892a                	mv	s2,a0
    80004f64:	00054c63          	bltz	a0,80004f7c <sys_dup+0x40>
  filedup(f);
    80004f68:	8526                	mv	a0,s1
    80004f6a:	bf8ff0ef          	jal	80004362 <filedup>
  return fd;
    80004f6e:	854a                	mv	a0,s2
    80004f70:	64e2                	ld	s1,24(sp)
    80004f72:	6942                	ld	s2,16(sp)
}
    80004f74:	70a2                	ld	ra,40(sp)
    80004f76:	7402                	ld	s0,32(sp)
    80004f78:	6145                	addi	sp,sp,48
    80004f7a:	8082                	ret
    80004f7c:	64e2                	ld	s1,24(sp)
    80004f7e:	6942                	ld	s2,16(sp)
    return -1;
    80004f80:	557d                	li	a0,-1
    80004f82:	bfcd                	j	80004f74 <sys_dup+0x38>

0000000080004f84 <sys_read>:
{
    80004f84:	7179                	addi	sp,sp,-48
    80004f86:	f406                	sd	ra,40(sp)
    80004f88:	f022                	sd	s0,32(sp)
    80004f8a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004f8c:	fd840593          	addi	a1,s0,-40
    80004f90:	4505                	li	a0,1
    80004f92:	a71fd0ef          	jal	80002a02 <argaddr>
  argint(2, &n);
    80004f96:	fe440593          	addi	a1,s0,-28
    80004f9a:	4509                	li	a0,2
    80004f9c:	a4bfd0ef          	jal	800029e6 <argint>
  if (argfd(0, 0, &f) < 0)
    80004fa0:	fe840613          	addi	a2,s0,-24
    80004fa4:	4581                	li	a1,0
    80004fa6:	4501                	li	a0,0
    80004fa8:	da5ff0ef          	jal	80004d4c <argfd>
    80004fac:	87aa                	mv	a5,a0
    return -1;
    80004fae:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004fb0:	0007ca63          	bltz	a5,80004fc4 <sys_read+0x40>
  return fileread(f, p, n);
    80004fb4:	fe442603          	lw	a2,-28(s0)
    80004fb8:	fd843583          	ld	a1,-40(s0)
    80004fbc:	fe843503          	ld	a0,-24(s0)
    80004fc0:	d10ff0ef          	jal	800044d0 <fileread>
}
    80004fc4:	70a2                	ld	ra,40(sp)
    80004fc6:	7402                	ld	s0,32(sp)
    80004fc8:	6145                	addi	sp,sp,48
    80004fca:	8082                	ret

0000000080004fcc <sys_write>:
{
    80004fcc:	7179                	addi	sp,sp,-48
    80004fce:	f406                	sd	ra,40(sp)
    80004fd0:	f022                	sd	s0,32(sp)
    80004fd2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004fd4:	fd840593          	addi	a1,s0,-40
    80004fd8:	4505                	li	a0,1
    80004fda:	a29fd0ef          	jal	80002a02 <argaddr>
  argint(2, &n);
    80004fde:	fe440593          	addi	a1,s0,-28
    80004fe2:	4509                	li	a0,2
    80004fe4:	a03fd0ef          	jal	800029e6 <argint>
  if (argfd(0, 0, &f) < 0)
    80004fe8:	fe840613          	addi	a2,s0,-24
    80004fec:	4581                	li	a1,0
    80004fee:	4501                	li	a0,0
    80004ff0:	d5dff0ef          	jal	80004d4c <argfd>
    80004ff4:	87aa                	mv	a5,a0
    return -1;
    80004ff6:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004ff8:	0007ca63          	bltz	a5,8000500c <sys_write+0x40>
  return filewrite(f, p, n);
    80004ffc:	fe442603          	lw	a2,-28(s0)
    80005000:	fd843583          	ld	a1,-40(s0)
    80005004:	fe843503          	ld	a0,-24(s0)
    80005008:	d8cff0ef          	jal	80004594 <filewrite>
}
    8000500c:	70a2                	ld	ra,40(sp)
    8000500e:	7402                	ld	s0,32(sp)
    80005010:	6145                	addi	sp,sp,48
    80005012:	8082                	ret

0000000080005014 <sys_close>:
{
    80005014:	1101                	addi	sp,sp,-32
    80005016:	ec06                	sd	ra,24(sp)
    80005018:	e822                	sd	s0,16(sp)
    8000501a:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    8000501c:	fe040613          	addi	a2,s0,-32
    80005020:	fec40593          	addi	a1,s0,-20
    80005024:	4501                	li	a0,0
    80005026:	d27ff0ef          	jal	80004d4c <argfd>
    return -1;
    8000502a:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    8000502c:	02054063          	bltz	a0,8000504c <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80005030:	8affc0ef          	jal	800018de <myproc>
    80005034:	fec42783          	lw	a5,-20(s0)
    80005038:	07e9                	addi	a5,a5,26
    8000503a:	078e                	slli	a5,a5,0x3
    8000503c:	953e                	add	a0,a0,a5
    8000503e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005042:	fe043503          	ld	a0,-32(s0)
    80005046:	b62ff0ef          	jal	800043a8 <fileclose>
  return 0;
    8000504a:	4781                	li	a5,0
}
    8000504c:	853e                	mv	a0,a5
    8000504e:	60e2                	ld	ra,24(sp)
    80005050:	6442                	ld	s0,16(sp)
    80005052:	6105                	addi	sp,sp,32
    80005054:	8082                	ret

0000000080005056 <sys_fstat>:
{
    80005056:	1101                	addi	sp,sp,-32
    80005058:	ec06                	sd	ra,24(sp)
    8000505a:	e822                	sd	s0,16(sp)
    8000505c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000505e:	fe040593          	addi	a1,s0,-32
    80005062:	4505                	li	a0,1
    80005064:	99ffd0ef          	jal	80002a02 <argaddr>
  if (argfd(0, 0, &f) < 0)
    80005068:	fe840613          	addi	a2,s0,-24
    8000506c:	4581                	li	a1,0
    8000506e:	4501                	li	a0,0
    80005070:	cddff0ef          	jal	80004d4c <argfd>
    80005074:	87aa                	mv	a5,a0
    return -1;
    80005076:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80005078:	0007c863          	bltz	a5,80005088 <sys_fstat+0x32>
  return filestat(f, st);
    8000507c:	fe043583          	ld	a1,-32(s0)
    80005080:	fe843503          	ld	a0,-24(s0)
    80005084:	be6ff0ef          	jal	8000446a <filestat>
}
    80005088:	60e2                	ld	ra,24(sp)
    8000508a:	6442                	ld	s0,16(sp)
    8000508c:	6105                	addi	sp,sp,32
    8000508e:	8082                	ret

0000000080005090 <sys_link>:
{
    80005090:	7169                	addi	sp,sp,-304
    80005092:	f606                	sd	ra,296(sp)
    80005094:	f222                	sd	s0,288(sp)
    80005096:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005098:	08000613          	li	a2,128
    8000509c:	ed040593          	addi	a1,s0,-304
    800050a0:	4501                	li	a0,0
    800050a2:	97dfd0ef          	jal	80002a1e <argstr>
    800050a6:	0e054c63          	bltz	a0,8000519e <sys_link+0x10e>
    800050aa:	08000613          	li	a2,128
    800050ae:	f5040593          	addi	a1,s0,-176
    800050b2:	4505                	li	a0,1
    800050b4:	96bfd0ef          	jal	80002a1e <argstr>
    800050b8:	0e054363          	bltz	a0,8000519e <sys_link+0x10e>
    800050bc:	ee26                	sd	s1,280(sp)
  begin_op();
    800050be:	e35fe0ef          	jal	80003ef2 <begin_op>
  if ((ip = namei(old)) == 0) {
    800050c2:	ed040513          	addi	a0,s0,-304
    800050c6:	c4ffe0ef          	jal	80003d14 <namei>
    800050ca:	84aa                	mv	s1,a0
    800050cc:	cd35                	beqz	a0,80005148 <sys_link+0xb8>
  ilock(ip);
    800050ce:	bb2fe0ef          	jal	80003480 <ilock>
  if (ip->type == T_DIR) {
    800050d2:	04449703          	lh	a4,68(s1)
    800050d6:	4785                	li	a5,1
    800050d8:	06f70c63          	beq	a4,a5,80005150 <sys_link+0xc0>
  if (ip->nlink >= NLINK_MAX) {
    800050dc:	04a49783          	lh	a5,74(s1)
    800050e0:	6721                	lui	a4,0x8
    800050e2:	177d                	addi	a4,a4,-1 # 7fff <_entry-0x7fff8001>
    800050e4:	06e78d63          	beq	a5,a4,8000515e <sys_link+0xce>
    800050e8:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800050ea:	2785                	addiw	a5,a5,1
    800050ec:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800050f0:	8526                	mv	a0,s1
    800050f2:	adafe0ef          	jal	800033cc <iupdate>
  iunlock(ip);
    800050f6:	8526                	mv	a0,s1
    800050f8:	c36fe0ef          	jal	8000352e <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    800050fc:	fd040593          	addi	a1,s0,-48
    80005100:	f5040513          	addi	a0,s0,-176
    80005104:	c2bfe0ef          	jal	80003d2e <nameiparent>
    80005108:	892a                	mv	s2,a0
    8000510a:	c925                	beqz	a0,8000517a <sys_link+0xea>
  ilock(dp);
    8000510c:	b74fe0ef          	jal	80003480 <ilock>
  if (dp->nlink == 0) {
    80005110:	04a91783          	lh	a5,74(s2)
    80005114:	cfa1                	beqz	a5,8000516c <sys_link+0xdc>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    80005116:	854a                	mv	a0,s2
    80005118:	00092703          	lw	a4,0(s2)
    8000511c:	409c                	lw	a5,0(s1)
    8000511e:	04f71b63          	bne	a4,a5,80005174 <sys_link+0xe4>
    80005122:	40d0                	lw	a2,4(s1)
    80005124:	fd040593          	addi	a1,s0,-48
    80005128:	b43fe0ef          	jal	80003c6a <dirlink>
    8000512c:	04054463          	bltz	a0,80005174 <sys_link+0xe4>
  iunlockput(dp);
    80005130:	854a                	mv	a0,s2
    80005132:	da2fe0ef          	jal	800036d4 <iunlockput>
  iput(ip);
    80005136:	8526                	mv	a0,s1
    80005138:	ccafe0ef          	jal	80003602 <iput>
  end_op();
    8000513c:	e43fe0ef          	jal	80003f7e <end_op>
  return 0;
    80005140:	4501                	li	a0,0
    80005142:	64f2                	ld	s1,280(sp)
    80005144:	6952                	ld	s2,272(sp)
    80005146:	a8a9                	j	800051a0 <sys_link+0x110>
    end_op();
    80005148:	e37fe0ef          	jal	80003f7e <end_op>
    return -1;
    8000514c:	64f2                	ld	s1,280(sp)
    8000514e:	a881                	j	8000519e <sys_link+0x10e>
    iunlockput(ip);
    80005150:	8526                	mv	a0,s1
    80005152:	d82fe0ef          	jal	800036d4 <iunlockput>
    end_op();
    80005156:	e29fe0ef          	jal	80003f7e <end_op>
    return -1;
    8000515a:	64f2                	ld	s1,280(sp)
    8000515c:	a089                	j	8000519e <sys_link+0x10e>
    iunlockput(ip);
    8000515e:	8526                	mv	a0,s1
    80005160:	d74fe0ef          	jal	800036d4 <iunlockput>
    end_op();
    80005164:	e1bfe0ef          	jal	80003f7e <end_op>
    return -1;
    80005168:	64f2                	ld	s1,280(sp)
    8000516a:	a815                	j	8000519e <sys_link+0x10e>
    iunlockput(dp);
    8000516c:	854a                	mv	a0,s2
    8000516e:	d66fe0ef          	jal	800036d4 <iunlockput>
    goto bad;
    80005172:	a021                	j	8000517a <sys_link+0xea>
    iunlockput(dp);
    80005174:	854a                	mv	a0,s2
    80005176:	d5efe0ef          	jal	800036d4 <iunlockput>
  ilock(ip);
    8000517a:	8526                	mv	a0,s1
    8000517c:	b04fe0ef          	jal	80003480 <ilock>
  ip->nlink--;
    80005180:	04a4d783          	lhu	a5,74(s1)
    80005184:	37fd                	addiw	a5,a5,-1
    80005186:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000518a:	8526                	mv	a0,s1
    8000518c:	a40fe0ef          	jal	800033cc <iupdate>
  iunlockput(ip);
    80005190:	8526                	mv	a0,s1
    80005192:	d42fe0ef          	jal	800036d4 <iunlockput>
  end_op();
    80005196:	de9fe0ef          	jal	80003f7e <end_op>
  return -1;
    8000519a:	64f2                	ld	s1,280(sp)
    8000519c:	6952                	ld	s2,272(sp)
    return -1;
    8000519e:	557d                	li	a0,-1
}
    800051a0:	70b2                	ld	ra,296(sp)
    800051a2:	7412                	ld	s0,288(sp)
    800051a4:	6155                	addi	sp,sp,304
    800051a6:	8082                	ret

00000000800051a8 <sys_unlink>:
{
    800051a8:	7151                	addi	sp,sp,-240
    800051aa:	f586                	sd	ra,232(sp)
    800051ac:	f1a2                	sd	s0,224(sp)
    800051ae:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    800051b0:	08000613          	li	a2,128
    800051b4:	f3040593          	addi	a1,s0,-208
    800051b8:	4501                	li	a0,0
    800051ba:	865fd0ef          	jal	80002a1e <argstr>
    800051be:	14054763          	bltz	a0,8000530c <sys_unlink+0x164>
    800051c2:	eda6                	sd	s1,216(sp)
  begin_op();
    800051c4:	d2ffe0ef          	jal	80003ef2 <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    800051c8:	fb040593          	addi	a1,s0,-80
    800051cc:	f3040513          	addi	a0,s0,-208
    800051d0:	b5ffe0ef          	jal	80003d2e <nameiparent>
    800051d4:	84aa                	mv	s1,a0
    800051d6:	c955                	beqz	a0,8000528a <sys_unlink+0xe2>
  ilock(dp);
    800051d8:	aa8fe0ef          	jal	80003480 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800051dc:	00002597          	auipc	a1,0x2
    800051e0:	51c58593          	addi	a1,a1,1308 # 800076f8 <etext+0x6f8>
    800051e4:	fb040513          	addi	a0,s0,-80
    800051e8:	86dfe0ef          	jal	80003a54 <namecmp>
    800051ec:	10050a63          	beqz	a0,80005300 <sys_unlink+0x158>
    800051f0:	00002597          	auipc	a1,0x2
    800051f4:	51058593          	addi	a1,a1,1296 # 80007700 <etext+0x700>
    800051f8:	fb040513          	addi	a0,s0,-80
    800051fc:	859fe0ef          	jal	80003a54 <namecmp>
    80005200:	10050063          	beqz	a0,80005300 <sys_unlink+0x158>
    80005204:	e9ca                	sd	s2,208(sp)
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80005206:	f2c40613          	addi	a2,s0,-212
    8000520a:	fb040593          	addi	a1,s0,-80
    8000520e:	8526                	mv	a0,s1
    80005210:	85bfe0ef          	jal	80003a6a <dirlookup>
    80005214:	892a                	mv	s2,a0
    80005216:	0e050463          	beqz	a0,800052fe <sys_unlink+0x156>
    8000521a:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    8000521c:	a64fe0ef          	jal	80003480 <ilock>
  if (ip->nlink < 1)
    80005220:	04a91783          	lh	a5,74(s2)
    80005224:	06f05763          	blez	a5,80005292 <sys_unlink+0xea>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    80005228:	04491703          	lh	a4,68(s2)
    8000522c:	4785                	li	a5,1
    8000522e:	06f70863          	beq	a4,a5,8000529e <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80005232:	fc040993          	addi	s3,s0,-64
    80005236:	4641                	li	a2,16
    80005238:	4581                	li	a1,0
    8000523a:	854e                	mv	a0,s3
    8000523c:	a79fb0ef          	jal	80000cb4 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005240:	4741                	li	a4,16
    80005242:	f2c42683          	lw	a3,-212(s0)
    80005246:	864e                	mv	a2,s3
    80005248:	4581                	li	a1,0
    8000524a:	8526                	mv	a0,s1
    8000524c:	f00fe0ef          	jal	8000394c <writei>
    80005250:	47c1                	li	a5,16
    80005252:	08f51763          	bne	a0,a5,800052e0 <sys_unlink+0x138>
  if (ip->type == T_DIR) {
    80005256:	04491703          	lh	a4,68(s2)
    8000525a:	4785                	li	a5,1
    8000525c:	08f70863          	beq	a4,a5,800052ec <sys_unlink+0x144>
  iunlockput(dp);
    80005260:	8526                	mv	a0,s1
    80005262:	c72fe0ef          	jal	800036d4 <iunlockput>
  ip->nlink--;
    80005266:	04a95783          	lhu	a5,74(s2)
    8000526a:	37fd                	addiw	a5,a5,-1
    8000526c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005270:	854a                	mv	a0,s2
    80005272:	95afe0ef          	jal	800033cc <iupdate>
  iunlockput(ip);
    80005276:	854a                	mv	a0,s2
    80005278:	c5cfe0ef          	jal	800036d4 <iunlockput>
  end_op();
    8000527c:	d03fe0ef          	jal	80003f7e <end_op>
  return 0;
    80005280:	4501                	li	a0,0
    80005282:	64ee                	ld	s1,216(sp)
    80005284:	694e                	ld	s2,208(sp)
    80005286:	69ae                	ld	s3,200(sp)
    80005288:	a059                	j	8000530e <sys_unlink+0x166>
    end_op();
    8000528a:	cf5fe0ef          	jal	80003f7e <end_op>
    return -1;
    8000528e:	64ee                	ld	s1,216(sp)
    80005290:	a8b5                	j	8000530c <sys_unlink+0x164>
    panic("unlink: nlink < 1");
    80005292:	00002517          	auipc	a0,0x2
    80005296:	47650513          	addi	a0,a0,1142 # 80007708 <etext+0x708>
    8000529a:	daefb0ef          	jal	80000848 <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    8000529e:	04c92703          	lw	a4,76(s2)
    800052a2:	02000793          	li	a5,32
    800052a6:	f8e7f6e3          	bgeu	a5,a4,80005232 <sys_unlink+0x8a>
    800052aa:	89be                	mv	s3,a5
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800052ac:	4741                	li	a4,16
    800052ae:	86ce                	mv	a3,s3
    800052b0:	f1840613          	addi	a2,s0,-232
    800052b4:	4581                	li	a1,0
    800052b6:	854a                	mv	a0,s2
    800052b8:	da2fe0ef          	jal	8000385a <readi>
    800052bc:	47c1                	li	a5,16
    800052be:	00f51b63          	bne	a0,a5,800052d4 <sys_unlink+0x12c>
    if (de.inum != 0)
    800052c2:	f1845783          	lhu	a5,-232(s0)
    800052c6:	eba1                	bnez	a5,80005316 <sys_unlink+0x16e>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    800052c8:	29c1                	addiw	s3,s3,16
    800052ca:	04c92783          	lw	a5,76(s2)
    800052ce:	fcf9efe3          	bltu	s3,a5,800052ac <sys_unlink+0x104>
    800052d2:	b785                	j	80005232 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800052d4:	00002517          	auipc	a0,0x2
    800052d8:	44c50513          	addi	a0,a0,1100 # 80007720 <etext+0x720>
    800052dc:	d6cfb0ef          	jal	80000848 <panic>
    panic("unlink: writei");
    800052e0:	00002517          	auipc	a0,0x2
    800052e4:	45850513          	addi	a0,a0,1112 # 80007738 <etext+0x738>
    800052e8:	d60fb0ef          	jal	80000848 <panic>
    dp->nlink--;
    800052ec:	04a4d783          	lhu	a5,74(s1)
    800052f0:	37fd                	addiw	a5,a5,-1
    800052f2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800052f6:	8526                	mv	a0,s1
    800052f8:	8d4fe0ef          	jal	800033cc <iupdate>
    800052fc:	b795                	j	80005260 <sys_unlink+0xb8>
    800052fe:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005300:	8526                	mv	a0,s1
    80005302:	bd2fe0ef          	jal	800036d4 <iunlockput>
  end_op();
    80005306:	c79fe0ef          	jal	80003f7e <end_op>
  return -1;
    8000530a:	64ee                	ld	s1,216(sp)
    return -1;
    8000530c:	557d                	li	a0,-1
}
    8000530e:	70ae                	ld	ra,232(sp)
    80005310:	740e                	ld	s0,224(sp)
    80005312:	616d                	addi	sp,sp,240
    80005314:	8082                	ret
    iunlockput(ip);
    80005316:	854a                	mv	a0,s2
    80005318:	bbcfe0ef          	jal	800036d4 <iunlockput>
    goto bad;
    8000531c:	694e                	ld	s2,208(sp)
    8000531e:	69ae                	ld	s3,200(sp)
    80005320:	b7c5                	j	80005300 <sys_unlink+0x158>

0000000080005322 <sys_open>:

uint64
sys_open(void)
{
    80005322:	7131                	addi	sp,sp,-192
    80005324:	fd06                	sd	ra,184(sp)
    80005326:	f922                	sd	s0,176(sp)
    80005328:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000532a:	f4c40593          	addi	a1,s0,-180
    8000532e:	4505                	li	a0,1
    80005330:	eb6fd0ef          	jal	800029e6 <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80005334:	08000613          	li	a2,128
    80005338:	f5040593          	addi	a1,s0,-176
    8000533c:	4501                	li	a0,0
    8000533e:	ee0fd0ef          	jal	80002a1e <argstr>
    80005342:	10054563          	bltz	a0,8000544c <sys_open+0x12a>
    80005346:	f526                	sd	s1,168(sp)
    return -1;

  begin_op();
    80005348:	babfe0ef          	jal	80003ef2 <begin_op>

  if (omode & O_CREATE) {
    8000534c:	f4c42783          	lw	a5,-180(s0)
    80005350:	2007f793          	andi	a5,a5,512
    80005354:	cfd9                	beqz	a5,800053f2 <sys_open+0xd0>
    ip = create(path, T_FILE, 0, 0);
    80005356:	4681                	li	a3,0
    80005358:	4601                	li	a2,0
    8000535a:	4589                	li	a1,2
    8000535c:	f5040513          	addi	a0,s0,-176
    80005360:	a7fff0ef          	jal	80004dde <create>
    80005364:	84aa                	mv	s1,a0
    if (ip == 0) {
    80005366:	c151                	beqz	a0,800053ea <sys_open+0xc8>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    80005368:	04449703          	lh	a4,68(s1)
    8000536c:	478d                	li	a5,3
    8000536e:	00f71763          	bne	a4,a5,8000537c <sys_open+0x5a>
    80005372:	0464d703          	lhu	a4,70(s1)
    80005376:	47a5                	li	a5,9
    80005378:	0ae7e863          	bltu	a5,a4,80005428 <sys_open+0x106>
    8000537c:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    8000537e:	f87fe0ef          	jal	80004304 <filealloc>
    80005382:	892a                	mv	s2,a0
    80005384:	cd4d                	beqz	a0,8000543e <sys_open+0x11c>
    80005386:	ed4e                	sd	s3,152(sp)
    80005388:	a19ff0ef          	jal	80004da0 <fdalloc>
    8000538c:	89aa                	mv	s3,a0
    8000538e:	0a054463          	bltz	a0,80005436 <sys_open+0x114>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    80005392:	04449703          	lh	a4,68(s1)
    80005396:	478d                	li	a5,3
    80005398:	0af70f63          	beq	a4,a5,80005456 <sys_open+0x134>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000539c:	4789                	li	a5,2
    8000539e:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800053a2:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800053a6:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800053aa:	f4c42783          	lw	a5,-180(s0)
    800053ae:	0017f713          	andi	a4,a5,1
    800053b2:	00174713          	xori	a4,a4,1
    800053b6:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800053ba:	0037f713          	andi	a4,a5,3
    800053be:	00e03733          	snez	a4,a4
    800053c2:	00e904a3          	sb	a4,9(s2)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    800053c6:	4007f793          	andi	a5,a5,1024
    800053ca:	c791                	beqz	a5,800053d6 <sys_open+0xb4>
    800053cc:	04449703          	lh	a4,68(s1)
    800053d0:	4789                	li	a5,2
    800053d2:	08f70963          	beq	a4,a5,80005464 <sys_open+0x142>
    itrunc(ip);
  }

  iunlock(ip);
    800053d6:	8526                	mv	a0,s1
    800053d8:	956fe0ef          	jal	8000352e <iunlock>
  end_op();
    800053dc:	ba3fe0ef          	jal	80003f7e <end_op>

  return fd;
    800053e0:	854e                	mv	a0,s3
    800053e2:	74aa                	ld	s1,168(sp)
    800053e4:	790a                	ld	s2,160(sp)
    800053e6:	69ea                	ld	s3,152(sp)
    800053e8:	a09d                	j	8000544e <sys_open+0x12c>
      end_op();
    800053ea:	b95fe0ef          	jal	80003f7e <end_op>
      return -1;
    800053ee:	74aa                	ld	s1,168(sp)
    800053f0:	a8b1                	j	8000544c <sys_open+0x12a>
    if ((ip = namei(path)) == 0) {
    800053f2:	f5040513          	addi	a0,s0,-176
    800053f6:	91ffe0ef          	jal	80003d14 <namei>
    800053fa:	84aa                	mv	s1,a0
    800053fc:	c115                	beqz	a0,80005420 <sys_open+0xfe>
    ilock(ip);
    800053fe:	882fe0ef          	jal	80003480 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    80005402:	04449703          	lh	a4,68(s1)
    80005406:	4785                	li	a5,1
    80005408:	f6f710e3          	bne	a4,a5,80005368 <sys_open+0x46>
    8000540c:	f4c42783          	lw	a5,-180(s0)
    80005410:	d7b5                	beqz	a5,8000537c <sys_open+0x5a>
      iunlockput(ip);
    80005412:	8526                	mv	a0,s1
    80005414:	ac0fe0ef          	jal	800036d4 <iunlockput>
      end_op();
    80005418:	b67fe0ef          	jal	80003f7e <end_op>
      return -1;
    8000541c:	74aa                	ld	s1,168(sp)
    8000541e:	a03d                	j	8000544c <sys_open+0x12a>
      end_op();
    80005420:	b5ffe0ef          	jal	80003f7e <end_op>
      return -1;
    80005424:	74aa                	ld	s1,168(sp)
    80005426:	a01d                	j	8000544c <sys_open+0x12a>
    iunlockput(ip);
    80005428:	8526                	mv	a0,s1
    8000542a:	aaafe0ef          	jal	800036d4 <iunlockput>
    end_op();
    8000542e:	b51fe0ef          	jal	80003f7e <end_op>
    return -1;
    80005432:	74aa                	ld	s1,168(sp)
    80005434:	a821                	j	8000544c <sys_open+0x12a>
      fileclose(f);
    80005436:	854a                	mv	a0,s2
    80005438:	f71fe0ef          	jal	800043a8 <fileclose>
    8000543c:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000543e:	8526                	mv	a0,s1
    80005440:	a94fe0ef          	jal	800036d4 <iunlockput>
    end_op();
    80005444:	b3bfe0ef          	jal	80003f7e <end_op>
    return -1;
    80005448:	74aa                	ld	s1,168(sp)
    8000544a:	790a                	ld	s2,160(sp)
    return -1;
    8000544c:	557d                	li	a0,-1
}
    8000544e:	70ea                	ld	ra,184(sp)
    80005450:	744a                	ld	s0,176(sp)
    80005452:	6129                	addi	sp,sp,192
    80005454:	8082                	ret
    f->type = FD_DEVICE;
    80005456:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    8000545a:	04649783          	lh	a5,70(s1)
    8000545e:	02f91223          	sh	a5,36(s2)
    80005462:	b791                	j	800053a6 <sys_open+0x84>
    itrunc(ip);
    80005464:	8526                	mv	a0,s1
    80005466:	908fe0ef          	jal	8000356e <itrunc>
    8000546a:	b7b5                	j	800053d6 <sys_open+0xb4>

000000008000546c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000546c:	7175                	addi	sp,sp,-144
    8000546e:	e506                	sd	ra,136(sp)
    80005470:	e122                	sd	s0,128(sp)
    80005472:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005474:	a7ffe0ef          	jal	80003ef2 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80005478:	08000613          	li	a2,128
    8000547c:	f7040593          	addi	a1,s0,-144
    80005480:	4501                	li	a0,0
    80005482:	d9cfd0ef          	jal	80002a1e <argstr>
    80005486:	02054363          	bltz	a0,800054ac <sys_mkdir+0x40>
    8000548a:	4681                	li	a3,0
    8000548c:	4601                	li	a2,0
    8000548e:	4585                	li	a1,1
    80005490:	f7040513          	addi	a0,s0,-144
    80005494:	94bff0ef          	jal	80004dde <create>
    80005498:	c911                	beqz	a0,800054ac <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000549a:	a3afe0ef          	jal	800036d4 <iunlockput>
  end_op();
    8000549e:	ae1fe0ef          	jal	80003f7e <end_op>
  return 0;
    800054a2:	4501                	li	a0,0
}
    800054a4:	60aa                	ld	ra,136(sp)
    800054a6:	640a                	ld	s0,128(sp)
    800054a8:	6149                	addi	sp,sp,144
    800054aa:	8082                	ret
    end_op();
    800054ac:	ad3fe0ef          	jal	80003f7e <end_op>
    return -1;
    800054b0:	557d                	li	a0,-1
    800054b2:	bfcd                	j	800054a4 <sys_mkdir+0x38>

00000000800054b4 <sys_mknod>:

uint64
sys_mknod(void)
{
    800054b4:	7135                	addi	sp,sp,-160
    800054b6:	ed06                	sd	ra,152(sp)
    800054b8:	e922                	sd	s0,144(sp)
    800054ba:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800054bc:	a37fe0ef          	jal	80003ef2 <begin_op>
  argint(1, &major);
    800054c0:	f6c40593          	addi	a1,s0,-148
    800054c4:	4505                	li	a0,1
    800054c6:	d20fd0ef          	jal	800029e6 <argint>
  argint(2, &minor);
    800054ca:	f6840593          	addi	a1,s0,-152
    800054ce:	4509                	li	a0,2
    800054d0:	d16fd0ef          	jal	800029e6 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    800054d4:	08000613          	li	a2,128
    800054d8:	f7040593          	addi	a1,s0,-144
    800054dc:	4501                	li	a0,0
    800054de:	d40fd0ef          	jal	80002a1e <argstr>
    800054e2:	02054563          	bltz	a0,8000550c <sys_mknod+0x58>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    800054e6:	f6841683          	lh	a3,-152(s0)
    800054ea:	f6c41603          	lh	a2,-148(s0)
    800054ee:	458d                	li	a1,3
    800054f0:	f7040513          	addi	a0,s0,-144
    800054f4:	8ebff0ef          	jal	80004dde <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    800054f8:	c911                	beqz	a0,8000550c <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800054fa:	9dafe0ef          	jal	800036d4 <iunlockput>
  end_op();
    800054fe:	a81fe0ef          	jal	80003f7e <end_op>
  return 0;
    80005502:	4501                	li	a0,0
}
    80005504:	60ea                	ld	ra,152(sp)
    80005506:	644a                	ld	s0,144(sp)
    80005508:	610d                	addi	sp,sp,160
    8000550a:	8082                	ret
    end_op();
    8000550c:	a73fe0ef          	jal	80003f7e <end_op>
    return -1;
    80005510:	557d                	li	a0,-1
    80005512:	bfcd                	j	80005504 <sys_mknod+0x50>

0000000080005514 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005514:	7135                	addi	sp,sp,-160
    80005516:	ed06                	sd	ra,152(sp)
    80005518:	e922                	sd	s0,144(sp)
    8000551a:	e14a                	sd	s2,128(sp)
    8000551c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000551e:	bc0fc0ef          	jal	800018de <myproc>
    80005522:	892a                	mv	s2,a0

  begin_op();
    80005524:	9cffe0ef          	jal	80003ef2 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80005528:	08000613          	li	a2,128
    8000552c:	f6040593          	addi	a1,s0,-160
    80005530:	4501                	li	a0,0
    80005532:	cecfd0ef          	jal	80002a1e <argstr>
    80005536:	02054f63          	bltz	a0,80005574 <sys_chdir+0x60>
    8000553a:	e526                	sd	s1,136(sp)
    8000553c:	f6040513          	addi	a0,s0,-160
    80005540:	fd4fe0ef          	jal	80003d14 <namei>
    80005544:	84aa                	mv	s1,a0
    80005546:	c515                	beqz	a0,80005572 <sys_chdir+0x5e>
    end_op();
    return -1;
  }
  ilock(ip);
    80005548:	f39fd0ef          	jal	80003480 <ilock>
  if (ip->type != T_DIR) {
    8000554c:	04449703          	lh	a4,68(s1)
    80005550:	4785                	li	a5,1
    80005552:	02f71963          	bne	a4,a5,80005584 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005556:	8526                	mv	a0,s1
    80005558:	fd7fd0ef          	jal	8000352e <iunlock>
  iput(p->cwd);
    8000555c:	15093503          	ld	a0,336(s2)
    80005560:	8a2fe0ef          	jal	80003602 <iput>
  end_op();
    80005564:	a1bfe0ef          	jal	80003f7e <end_op>
  p->cwd = ip;
    80005568:	14993823          	sd	s1,336(s2)
  return 0;
    8000556c:	4501                	li	a0,0
    8000556e:	64aa                	ld	s1,136(sp)
    80005570:	a029                	j	8000557a <sys_chdir+0x66>
    80005572:	64aa                	ld	s1,136(sp)
    end_op();
    80005574:	a0bfe0ef          	jal	80003f7e <end_op>
    return -1;
    80005578:	557d                	li	a0,-1
}
    8000557a:	60ea                	ld	ra,152(sp)
    8000557c:	644a                	ld	s0,144(sp)
    8000557e:	690a                	ld	s2,128(sp)
    80005580:	610d                	addi	sp,sp,160
    80005582:	8082                	ret
    iunlockput(ip);
    80005584:	8526                	mv	a0,s1
    80005586:	94efe0ef          	jal	800036d4 <iunlockput>
    end_op();
    8000558a:	9f5fe0ef          	jal	80003f7e <end_op>
    return -1;
    8000558e:	64aa                	ld	s1,136(sp)
    80005590:	b7e5                	j	80005578 <sys_chdir+0x64>

0000000080005592 <sys_exec>:

uint64
sys_exec(void)
{
    80005592:	7105                	addi	sp,sp,-480
    80005594:	ef86                	sd	ra,472(sp)
    80005596:	eba2                	sd	s0,464(sp)
    80005598:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000559a:	e2840593          	addi	a1,s0,-472
    8000559e:	4505                	li	a0,1
    800055a0:	c62fd0ef          	jal	80002a02 <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    800055a4:	08000613          	li	a2,128
    800055a8:	f3040593          	addi	a1,s0,-208
    800055ac:	4501                	li	a0,0
    800055ae:	c70fd0ef          	jal	80002a1e <argstr>
    800055b2:	0c054e63          	bltz	a0,8000568e <sys_exec+0xfc>
    800055b6:	e7a6                	sd	s1,456(sp)
    800055b8:	e3ca                	sd	s2,448(sp)
    800055ba:	ff4e                	sd	s3,440(sp)
    800055bc:	fb52                	sd	s4,432(sp)
    800055be:	f756                	sd	s5,424(sp)
    800055c0:	f35a                	sd	s6,416(sp)
    800055c2:	ef5e                	sd	s7,408(sp)
    return -1;
  }
  memset(argv, 0, sizeof(argv));
    800055c4:	e3040a13          	addi	s4,s0,-464
    800055c8:	10000613          	li	a2,256
    800055cc:	4581                	li	a1,0
    800055ce:	8552                	mv	a0,s4
    800055d0:	ee4fb0ef          	jal	80000cb4 <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    800055d4:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800055d6:	89d2                	mv	s3,s4
    800055d8:	4901                	li	s2,0
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    800055da:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if (argv[i] == 0)
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    800055de:	6b05                	lui	s6,0x1
    if (i >= NELEM(argv)) {
    800055e0:	02000b93          	li	s7,32
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    800055e4:	00391513          	slli	a0,s2,0x3
    800055e8:	85d6                	mv	a1,s5
    800055ea:	e2843783          	ld	a5,-472(s0)
    800055ee:	953e                	add	a0,a0,a5
    800055f0:	b6efd0ef          	jal	8000295e <fetchaddr>
    800055f4:	02054663          	bltz	a0,80005620 <sys_exec+0x8e>
    if (uarg == 0) {
    800055f8:	e2043783          	ld	a5,-480(s0)
    800055fc:	c3b9                	beqz	a5,80005642 <sys_exec+0xb0>
    argv[i] = kalloc();
    800055fe:	d20fb0ef          	jal	80000b1e <kalloc>
    80005602:	85aa                	mv	a1,a0
    80005604:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    80005608:	cd01                	beqz	a0,80005620 <sys_exec+0x8e>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000560a:	865a                	mv	a2,s6
    8000560c:	e2043503          	ld	a0,-480(s0)
    80005610:	b94fd0ef          	jal	800029a4 <fetchstr>
    80005614:	00054663          	bltz	a0,80005620 <sys_exec+0x8e>
    if (i >= NELEM(argv)) {
    80005618:	0905                	addi	s2,s2,1
    8000561a:	09a1                	addi	s3,s3,8
    8000561c:	fd7914e3          	bne	s2,s7,800055e4 <sys_exec+0x52>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005620:	100a0a13          	addi	s4,s4,256
    80005624:	6088                	ld	a0,0(s1)
    80005626:	cd29                	beqz	a0,80005680 <sys_exec+0xee>
    kfree(argv[i]);
    80005628:	c0efb0ef          	jal	80000a36 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000562c:	04a1                	addi	s1,s1,8
    8000562e:	ff449be3          	bne	s1,s4,80005624 <sys_exec+0x92>
    80005632:	64be                	ld	s1,456(sp)
    80005634:	691e                	ld	s2,448(sp)
    80005636:	79fa                	ld	s3,440(sp)
    80005638:	7a5a                	ld	s4,432(sp)
    8000563a:	7aba                	ld	s5,424(sp)
    8000563c:	7b1a                	ld	s6,416(sp)
    8000563e:	6bfa                	ld	s7,408(sp)
    80005640:	a0b9                	j	8000568e <sys_exec+0xfc>
      argv[i] = 0;
    80005642:	0009079b          	sext.w	a5,s2
    80005646:	e3040593          	addi	a1,s0,-464
    8000564a:	078e                	slli	a5,a5,0x3
    8000564c:	97ae                	add	a5,a5,a1
    8000564e:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80005652:	f3040513          	addi	a0,s0,-208
    80005656:	bdeff0ef          	jal	80004a34 <kexec>
    8000565a:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000565c:	100a0a13          	addi	s4,s4,256
    80005660:	6088                	ld	a0,0(s1)
    80005662:	c511                	beqz	a0,8000566e <sys_exec+0xdc>
    kfree(argv[i]);
    80005664:	bd2fb0ef          	jal	80000a36 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005668:	04a1                	addi	s1,s1,8
    8000566a:	ff449be3          	bne	s1,s4,80005660 <sys_exec+0xce>
  return ret;
    8000566e:	854a                	mv	a0,s2
    80005670:	64be                	ld	s1,456(sp)
    80005672:	691e                	ld	s2,448(sp)
    80005674:	79fa                	ld	s3,440(sp)
    80005676:	7a5a                	ld	s4,432(sp)
    80005678:	7aba                	ld	s5,424(sp)
    8000567a:	7b1a                	ld	s6,416(sp)
    8000567c:	6bfa                	ld	s7,408(sp)
    8000567e:	a809                	j	80005690 <sys_exec+0xfe>
    80005680:	64be                	ld	s1,456(sp)
    80005682:	691e                	ld	s2,448(sp)
    80005684:	79fa                	ld	s3,440(sp)
    80005686:	7a5a                	ld	s4,432(sp)
    80005688:	7aba                	ld	s5,424(sp)
    8000568a:	7b1a                	ld	s6,416(sp)
    8000568c:	6bfa                	ld	s7,408(sp)
    return -1;
    8000568e:	557d                	li	a0,-1
  return -1;
}
    80005690:	60fe                	ld	ra,472(sp)
    80005692:	645e                	ld	s0,464(sp)
    80005694:	613d                	addi	sp,sp,480
    80005696:	8082                	ret

0000000080005698 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005698:	7139                	addi	sp,sp,-64
    8000569a:	fc06                	sd	ra,56(sp)
    8000569c:	f822                	sd	s0,48(sp)
    8000569e:	f426                	sd	s1,40(sp)
    800056a0:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800056a2:	a3cfc0ef          	jal	800018de <myproc>
    800056a6:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800056a8:	fd840593          	addi	a1,s0,-40
    800056ac:	4501                	li	a0,0
    800056ae:	b54fd0ef          	jal	80002a02 <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    800056b2:	fc840593          	addi	a1,s0,-56
    800056b6:	fd040513          	addi	a0,s0,-48
    800056ba:	812ff0ef          	jal	800046cc <pipealloc>
    800056be:	0a054663          	bltz	a0,8000576a <sys_pipe+0xd2>
    return -1;
  fd0 = -1;
    800056c2:	57fd                	li	a5,-1
    800056c4:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    800056c8:	fd043503          	ld	a0,-48(s0)
    800056cc:	ed4ff0ef          	jal	80004da0 <fdalloc>
    800056d0:	fca42223          	sw	a0,-60(s0)
    800056d4:	08054363          	bltz	a0,8000575a <sys_pipe+0xc2>
    800056d8:	fc843503          	ld	a0,-56(s0)
    800056dc:	ec4ff0ef          	jal	80004da0 <fdalloc>
    800056e0:	fca42023          	sw	a0,-64(s0)
    800056e4:	06054263          	bltz	a0,80005748 <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800056e8:	4711                	li	a4,4
    800056ea:	fc440693          	addi	a3,s0,-60
    800056ee:	fd843603          	ld	a2,-40(s0)
    800056f2:	64ac                	ld	a1,72(s1)
    800056f4:	68a8                	ld	a0,80(s1)
    800056f6:	e37fb0ef          	jal	8000152c <copyout>
    800056fa:	02054063          	bltz	a0,8000571a <sys_pipe+0x82>
      copyout(p->pagetable, p->sz, fdarray + sizeof(fd0), (char *)&fd1,
    800056fe:	4711                	li	a4,4
    80005700:	fc040693          	addi	a3,s0,-64
    80005704:	fd843603          	ld	a2,-40(s0)
    80005708:	963a                	add	a2,a2,a4
    8000570a:	64ac                	ld	a1,72(s1)
    8000570c:	68a8                	ld	a0,80(s1)
    8000570e:	e1ffb0ef          	jal	8000152c <copyout>
    80005712:	87aa                	mv	a5,a0
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005714:	4501                	li	a0,0
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005716:	0407db63          	bgez	a5,8000576c <sys_pipe+0xd4>
    p->ofile[fd0] = 0;
    8000571a:	fc442783          	lw	a5,-60(s0)
    8000571e:	07e9                	addi	a5,a5,26
    80005720:	078e                	slli	a5,a5,0x3
    80005722:	97a6                	add	a5,a5,s1
    80005724:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005728:	fc042783          	lw	a5,-64(s0)
    8000572c:	07e9                	addi	a5,a5,26
    8000572e:	078e                	slli	a5,a5,0x3
    80005730:	94be                	add	s1,s1,a5
    80005732:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005736:	fd043503          	ld	a0,-48(s0)
    8000573a:	c6ffe0ef          	jal	800043a8 <fileclose>
    fileclose(wf);
    8000573e:	fc843503          	ld	a0,-56(s0)
    80005742:	c67fe0ef          	jal	800043a8 <fileclose>
    return -1;
    80005746:	a015                	j	8000576a <sys_pipe+0xd2>
    if (fd0 >= 0)
    80005748:	fc442783          	lw	a5,-60(s0)
    8000574c:	0007c763          	bltz	a5,8000575a <sys_pipe+0xc2>
      p->ofile[fd0] = 0;
    80005750:	07e9                	addi	a5,a5,26
    80005752:	078e                	slli	a5,a5,0x3
    80005754:	97a6                	add	a5,a5,s1
    80005756:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000575a:	fd043503          	ld	a0,-48(s0)
    8000575e:	c4bfe0ef          	jal	800043a8 <fileclose>
    fileclose(wf);
    80005762:	fc843503          	ld	a0,-56(s0)
    80005766:	c43fe0ef          	jal	800043a8 <fileclose>
    return -1;
    8000576a:	557d                	li	a0,-1
}
    8000576c:	70e2                	ld	ra,56(sp)
    8000576e:	7442                	ld	s0,48(sp)
    80005770:	74a2                	ld	s1,40(sp)
    80005772:	6121                	addi	sp,sp,64
    80005774:	8082                	ret
	...

0000000080005780 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005780:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005782:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005784:	e80e                	sd	gp,16(sp)
        # sd tp, 24(sp)
        sd t0, 32(sp)
    80005786:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80005788:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000578a:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000578c:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    8000578e:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005790:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005792:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005794:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005796:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80005798:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000579a:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000579c:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    8000579e:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    800057a0:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    800057a2:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    800057a4:	8c4fd0ef          	jal	80002868 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    800057a8:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    800057aa:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    800057ac:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    800057ae:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    800057b0:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    800057b2:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    800057b4:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    800057b6:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    800057b8:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    800057ba:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    800057bc:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    800057be:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    800057c0:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    800057c2:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    800057c4:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    800057c6:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    800057c8:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    800057ca:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    800057cc:	10200073          	sret
    800057d0:	0001                	nop
    800057d2:	00000013          	nop
    800057d6:	00000013          	nop
    800057da:	00000013          	nop

00000000800057de <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800057de:	1141                	addi	sp,sp,-16
    800057e0:	e406                	sd	ra,8(sp)
    800057e2:	e022                	sd	s0,0(sp)
    800057e4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32 *)(PLIC + UART0_IRQ * 4) = 1;
    800057e6:	0c000737          	lui	a4,0xc000
    800057ea:	4785                	li	a5,1
    800057ec:	d71c                	sw	a5,40(a4)
  *(uint32 *)(PLIC + VIRTIO0_IRQ * 4) = 1;
    800057ee:	c35c                	sw	a5,4(a4)
}
    800057f0:	60a2                	ld	ra,8(sp)
    800057f2:	6402                	ld	s0,0(sp)
    800057f4:	0141                	addi	sp,sp,16
    800057f6:	8082                	ret

00000000800057f8 <plicinithart>:

void
plicinithart(void)
{
    800057f8:	1141                	addi	sp,sp,-16
    800057fa:	e406                	sd	ra,8(sp)
    800057fc:	e022                	sd	s0,0(sp)
    800057fe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005800:	8aafc0ef          	jal	800018aa <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32 *)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005804:	0085171b          	slliw	a4,a0,0x8
    80005808:	0c0027b7          	lui	a5,0xc002
    8000580c:	97ba                	add	a5,a5,a4
    8000580e:	40200713          	li	a4,1026
    80005812:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32 *)PLIC_SPRIORITY(hart) = 0;
    80005816:	00d5151b          	slliw	a0,a0,0xd
    8000581a:	0c2017b7          	lui	a5,0xc201
    8000581e:	97aa                	add	a5,a5,a0
    80005820:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005824:	60a2                	ld	ra,8(sp)
    80005826:	6402                	ld	s0,0(sp)
    80005828:	0141                	addi	sp,sp,16
    8000582a:	8082                	ret

000000008000582c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000582c:	1141                	addi	sp,sp,-16
    8000582e:	e406                	sd	ra,8(sp)
    80005830:	e022                	sd	s0,0(sp)
    80005832:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005834:	876fc0ef          	jal	800018aa <cpuid>
  int irq = *(uint32 *)PLIC_SCLAIM(hart);
    80005838:	00d5151b          	slliw	a0,a0,0xd
    8000583c:	0c2017b7          	lui	a5,0xc201
    80005840:	97aa                	add	a5,a5,a0
  return irq;
}
    80005842:	43c8                	lw	a0,4(a5)
    80005844:	60a2                	ld	ra,8(sp)
    80005846:	6402                	ld	s0,0(sp)
    80005848:	0141                	addi	sp,sp,16
    8000584a:	8082                	ret

000000008000584c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000584c:	1101                	addi	sp,sp,-32
    8000584e:	ec06                	sd	ra,24(sp)
    80005850:	e822                	sd	s0,16(sp)
    80005852:	e426                	sd	s1,8(sp)
    80005854:	1000                	addi	s0,sp,32
    80005856:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005858:	852fc0ef          	jal	800018aa <cpuid>
  *(uint32 *)PLIC_SCLAIM(hart) = irq;
    8000585c:	00d5179b          	slliw	a5,a0,0xd
    80005860:	0c201737          	lui	a4,0xc201
    80005864:	97ba                	add	a5,a5,a4
    80005866:	c3c4                	sw	s1,4(a5)
}
    80005868:	60e2                	ld	ra,24(sp)
    8000586a:	6442                	ld	s0,16(sp)
    8000586c:	64a2                	ld	s1,8(sp)
    8000586e:	6105                	addi	sp,sp,32
    80005870:	8082                	ret

0000000080005872 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005872:	1141                	addi	sp,sp,-16
    80005874:	e406                	sd	ra,8(sp)
    80005876:	e022                	sd	s0,0(sp)
    80005878:	0800                	addi	s0,sp,16
  if (i >= NUM)
    8000587a:	479d                	li	a5,7
    8000587c:	04a7ca63          	blt	a5,a0,800058d0 <free_desc+0x5e>
    panic("free_desc 1");
  if (disk.free[i])
    80005880:	0001e797          	auipc	a5,0x1e
    80005884:	39078793          	addi	a5,a5,912 # 80023c10 <disk>
    80005888:	97aa                	add	a5,a5,a0
    8000588a:	0187c783          	lbu	a5,24(a5)
    8000588e:	e7b9                	bnez	a5,800058dc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005890:	00451693          	slli	a3,a0,0x4
    80005894:	0001e797          	auipc	a5,0x1e
    80005898:	37c78793          	addi	a5,a5,892 # 80023c10 <disk>
    8000589c:	6398                	ld	a4,0(a5)
    8000589e:	9736                	add	a4,a4,a3
    800058a0:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    800058a4:	6398                	ld	a4,0(a5)
    800058a6:	9736                	add	a4,a4,a3
    800058a8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800058ac:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800058b0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800058b4:	97aa                	add	a5,a5,a0
    800058b6:	4705                	li	a4,1
    800058b8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800058bc:	0001e517          	auipc	a0,0x1e
    800058c0:	36c50513          	addi	a0,a0,876 # 80023c28 <disk+0x18>
    800058c4:	813fc0ef          	jal	800020d6 <wakeup>
}
    800058c8:	60a2                	ld	ra,8(sp)
    800058ca:	6402                	ld	s0,0(sp)
    800058cc:	0141                	addi	sp,sp,16
    800058ce:	8082                	ret
    panic("free_desc 1");
    800058d0:	00002517          	auipc	a0,0x2
    800058d4:	e7850513          	addi	a0,a0,-392 # 80007748 <etext+0x748>
    800058d8:	f71fa0ef          	jal	80000848 <panic>
    panic("free_desc 2");
    800058dc:	00002517          	auipc	a0,0x2
    800058e0:	e7c50513          	addi	a0,a0,-388 # 80007758 <etext+0x758>
    800058e4:	f65fa0ef          	jal	80000848 <panic>

00000000800058e8 <virtio_disk_init>:
{
    800058e8:	1101                	addi	sp,sp,-32
    800058ea:	ec06                	sd	ra,24(sp)
    800058ec:	e822                	sd	s0,16(sp)
    800058ee:	e426                	sd	s1,8(sp)
    800058f0:	e04a                	sd	s2,0(sp)
    800058f2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800058f4:	00002597          	auipc	a1,0x2
    800058f8:	e7458593          	addi	a1,a1,-396 # 80007768 <etext+0x768>
    800058fc:	0001e517          	auipc	a0,0x1e
    80005900:	43c50513          	addi	a0,a0,1084 # 80023d38 <disk+0x128>
    80005904:	a74fb0ef          	jal	80000b78 <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005908:	100017b7          	lui	a5,0x10001
    8000590c:	4398                	lw	a4,0(a5)
    8000590e:	747277b7          	lui	a5,0x74727
    80005912:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005916:	14f71263          	bne	a4,a5,80005a5a <virtio_disk_init+0x172>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000591a:	100017b7          	lui	a5,0x10001
    8000591e:	43d8                	lw	a4,4(a5)
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005920:	4789                	li	a5,2
    80005922:	12f71c63          	bne	a4,a5,80005a5a <virtio_disk_init+0x172>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005926:	100017b7          	lui	a5,0x10001
    8000592a:	4798                	lw	a4,8(a5)
    8000592c:	4789                	li	a5,2
    8000592e:	12f71663          	bne	a4,a5,80005a5a <virtio_disk_init+0x172>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80005932:	100017b7          	lui	a5,0x10001
    80005936:	47d8                	lw	a4,12(a5)
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005938:	554d47b7          	lui	a5,0x554d4
    8000593c:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005940:	10f71d63          	bne	a4,a5,80005a5a <virtio_disk_init+0x172>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005944:	100017b7          	lui	a5,0x10001
    80005948:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000594c:	4705                	li	a4,1
    8000594e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005950:	470d                	li	a4,3
    80005952:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005954:	10001737          	lui	a4,0x10001
    80005958:	4b18                	lw	a4,16(a4)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000595a:	c7ffe6b7          	lui	a3,0xc7ffe
    8000595e:	55f68693          	addi	a3,a3,1375 # ffffffffc7ffe55f <end+0xffffffff47fda80f>
    80005962:	8f75                	and	a4,a4,a3
    80005964:	100016b7          	lui	a3,0x10001
    80005968:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000596a:	472d                	li	a4,11
    8000596c:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    8000596e:	0707a903          	lw	s2,112(a5)
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005972:	00897793          	andi	a5,s2,8
    80005976:	0e078863          	beqz	a5,80005a66 <virtio_disk_init+0x17e>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000597a:	100017b7          	lui	a5,0x10001
    8000597e:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    80005982:	43fc                	lw	a5,68(a5)
    80005984:	0e079763          	bnez	a5,80005a72 <virtio_disk_init+0x18a>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005988:	100017b7          	lui	a5,0x10001
    8000598c:	5bdc                	lw	a5,52(a5)
  if (max == 0)
    8000598e:	0e078863          	beqz	a5,80005a7e <virtio_disk_init+0x196>
  if (max < NUM)
    80005992:	471d                	li	a4,7
    80005994:	0ef77b63          	bgeu	a4,a5,80005a8a <virtio_disk_init+0x1a2>
  disk.desc = kalloc();
    80005998:	986fb0ef          	jal	80000b1e <kalloc>
    8000599c:	0001e497          	auipc	s1,0x1e
    800059a0:	27448493          	addi	s1,s1,628 # 80023c10 <disk>
    800059a4:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800059a6:	978fb0ef          	jal	80000b1e <kalloc>
    800059aa:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800059ac:	972fb0ef          	jal	80000b1e <kalloc>
    800059b0:	87aa                	mv	a5,a0
    800059b2:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used)
    800059b4:	6088                	ld	a0,0(s1)
    800059b6:	0e050063          	beqz	a0,80005a96 <virtio_disk_init+0x1ae>
    800059ba:	0001e717          	auipc	a4,0x1e
    800059be:	25e73703          	ld	a4,606(a4) # 80023c18 <disk+0x8>
    800059c2:	00173713          	seqz	a4,a4
    800059c6:	0017b793          	seqz	a5,a5
    800059ca:	8fd9                	or	a5,a5,a4
    800059cc:	e7e9                	bnez	a5,80005a96 <virtio_disk_init+0x1ae>
  memset(disk.desc, 0, PGSIZE);
    800059ce:	6605                	lui	a2,0x1
    800059d0:	4581                	li	a1,0
    800059d2:	ae2fb0ef          	jal	80000cb4 <memset>
  memset(disk.avail, 0, PGSIZE);
    800059d6:	0001e497          	auipc	s1,0x1e
    800059da:	23a48493          	addi	s1,s1,570 # 80023c10 <disk>
    800059de:	6605                	lui	a2,0x1
    800059e0:	4581                	li	a1,0
    800059e2:	6488                	ld	a0,8(s1)
    800059e4:	ad0fb0ef          	jal	80000cb4 <memset>
  memset(disk.used, 0, PGSIZE);
    800059e8:	6605                	lui	a2,0x1
    800059ea:	4581                	li	a1,0
    800059ec:	6888                	ld	a0,16(s1)
    800059ee:	ac6fb0ef          	jal	80000cb4 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800059f2:	100017b7          	lui	a5,0x10001
    800059f6:	4721                	li	a4,8
    800059f8:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800059fa:	4098                	lw	a4,0(s1)
    800059fc:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005a00:	40d8                	lw	a4,4(s1)
    80005a02:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005a06:	649c                	ld	a5,8(s1)
    80005a08:	10001737          	lui	a4,0x10001
    80005a0c:	08f72823          	sw	a5,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005a10:	9781                	srai	a5,a5,0x20
    80005a12:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005a16:	689c                	ld	a5,16(s1)
    80005a18:	0af72023          	sw	a5,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005a1c:	9781                	srai	a5,a5,0x20
    80005a1e:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005a22:	4785                	li	a5,1
    80005a24:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005a26:	00f48c23          	sb	a5,24(s1)
    80005a2a:	00f48ca3          	sb	a5,25(s1)
    80005a2e:	00f48d23          	sb	a5,26(s1)
    80005a32:	00f48da3          	sb	a5,27(s1)
    80005a36:	00f48e23          	sb	a5,28(s1)
    80005a3a:	00f48ea3          	sb	a5,29(s1)
    80005a3e:	00f48f23          	sb	a5,30(s1)
    80005a42:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005a46:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a4a:	07272823          	sw	s2,112(a4)
}
    80005a4e:	60e2                	ld	ra,24(sp)
    80005a50:	6442                	ld	s0,16(sp)
    80005a52:	64a2                	ld	s1,8(sp)
    80005a54:	6902                	ld	s2,0(sp)
    80005a56:	6105                	addi	sp,sp,32
    80005a58:	8082                	ret
    panic("could not find virtio disk");
    80005a5a:	00002517          	auipc	a0,0x2
    80005a5e:	d1e50513          	addi	a0,a0,-738 # 80007778 <etext+0x778>
    80005a62:	de7fa0ef          	jal	80000848 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005a66:	00002517          	auipc	a0,0x2
    80005a6a:	d3250513          	addi	a0,a0,-718 # 80007798 <etext+0x798>
    80005a6e:	ddbfa0ef          	jal	80000848 <panic>
    panic("virtio disk should not be ready");
    80005a72:	00002517          	auipc	a0,0x2
    80005a76:	d4650513          	addi	a0,a0,-698 # 800077b8 <etext+0x7b8>
    80005a7a:	dcffa0ef          	jal	80000848 <panic>
    panic("virtio disk has no queue 0");
    80005a7e:	00002517          	auipc	a0,0x2
    80005a82:	d5a50513          	addi	a0,a0,-678 # 800077d8 <etext+0x7d8>
    80005a86:	dc3fa0ef          	jal	80000848 <panic>
    panic("virtio disk max queue too short");
    80005a8a:	00002517          	auipc	a0,0x2
    80005a8e:	d6e50513          	addi	a0,a0,-658 # 800077f8 <etext+0x7f8>
    80005a92:	db7fa0ef          	jal	80000848 <panic>
    panic("virtio disk kalloc");
    80005a96:	00002517          	auipc	a0,0x2
    80005a9a:	d8250513          	addi	a0,a0,-638 # 80007818 <etext+0x818>
    80005a9e:	dabfa0ef          	jal	80000848 <panic>

0000000080005aa2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005aa2:	711d                	addi	sp,sp,-96
    80005aa4:	ec86                	sd	ra,88(sp)
    80005aa6:	e8a2                	sd	s0,80(sp)
    80005aa8:	e4a6                	sd	s1,72(sp)
    80005aaa:	e0ca                	sd	s2,64(sp)
    80005aac:	fc4e                	sd	s3,56(sp)
    80005aae:	f852                	sd	s4,48(sp)
    80005ab0:	f456                	sd	s5,40(sp)
    80005ab2:	f05a                	sd	s6,32(sp)
    80005ab4:	ec5e                	sd	s7,24(sp)
    80005ab6:	e862                	sd	s8,16(sp)
    80005ab8:	1080                	addi	s0,sp,96
    80005aba:	89aa                	mv	s3,a0
    80005abc:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005abe:	00c52b83          	lw	s7,12(a0)
    80005ac2:	001b9b9b          	slliw	s7,s7,0x1
    80005ac6:	1b82                	slli	s7,s7,0x20
    80005ac8:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80005acc:	0001e517          	auipc	a0,0x1e
    80005ad0:	26c50513          	addi	a0,a0,620 # 80023d38 <disk+0x128>
    80005ad4:	924fb0ef          	jal	80000bf8 <acquire>
  for (int i = 0; i < NUM; i++) {
    80005ad8:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005ada:	0001ea97          	auipc	s5,0x1e
    80005ade:	136a8a93          	addi	s5,s5,310 # 80023c10 <disk>
  for (int i = 0; i < 3; i++) {
    80005ae2:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80005ae4:	5c7d                	li	s8,-1
    80005ae6:	a8a5                	j	80005b5e <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    80005ae8:	00fa8733          	add	a4,s5,a5
    80005aec:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005af0:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    80005af2:	0207c563          	bltz	a5,80005b1c <virtio_disk_rw+0x7a>
  for (int i = 0; i < 3; i++) {
    80005af6:	2905                	addiw	s2,s2,1
    80005af8:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005afa:	07490663          	beq	s2,s4,80005b66 <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80005afe:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    80005b00:	0001e717          	auipc	a4,0x1e
    80005b04:	11070713          	addi	a4,a4,272 # 80023c10 <disk>
    80005b08:	4781                	li	a5,0
    if (disk.free[i]) {
    80005b0a:	01874683          	lbu	a3,24(a4)
    80005b0e:	fee9                	bnez	a3,80005ae8 <virtio_disk_rw+0x46>
  for (int i = 0; i < NUM; i++) {
    80005b10:	2785                	addiw	a5,a5,1
    80005b12:	0705                	addi	a4,a4,1
    80005b14:	fe979be3          	bne	a5,s1,80005b0a <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80005b18:	0185a023          	sw	s8,0(a1)
      for (int j = 0; j < i; j++)
    80005b1c:	01205d63          	blez	s2,80005b36 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005b20:	fa042503          	lw	a0,-96(s0)
    80005b24:	d4fff0ef          	jal	80005872 <free_desc>
      for (int j = 0; j < i; j++)
    80005b28:	4785                	li	a5,1
    80005b2a:	0127d663          	bge	a5,s2,80005b36 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005b2e:	fa442503          	lw	a0,-92(s0)
    80005b32:	d41ff0ef          	jal	80005872 <free_desc>
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep_prepare(&disk.free[0]);
    80005b36:	0001e517          	auipc	a0,0x1e
    80005b3a:	0f250513          	addi	a0,a0,242 # 80023c28 <disk+0x18>
    80005b3e:	d28fc0ef          	jal	80002066 <sleep_prepare>
    release(&disk.vdisk_lock);
    80005b42:	0001e517          	auipc	a0,0x1e
    80005b46:	1f650513          	addi	a0,a0,502 # 80023d38 <disk+0x128>
    80005b4a:	932fb0ef          	jal	80000c7c <release>
    sleep();
    80005b4e:	d54fc0ef          	jal	800020a2 <sleep>
    acquire(&disk.vdisk_lock);
    80005b52:	0001e517          	auipc	a0,0x1e
    80005b56:	1e650513          	addi	a0,a0,486 # 80023d38 <disk+0x128>
    80005b5a:	89efb0ef          	jal	80000bf8 <acquire>
  for (int i = 0; i < 3; i++) {
    80005b5e:	fa040613          	addi	a2,s0,-96
    80005b62:	4901                	li	s2,0
    80005b64:	bf69                	j	80005afe <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005b66:	fa042503          	lw	a0,-96(s0)
    80005b6a:	00451693          	slli	a3,a0,0x4

  if (write)
    80005b6e:	0001e797          	auipc	a5,0x1e
    80005b72:	0a278793          	addi	a5,a5,162 # 80023c10 <disk>
    80005b76:	00451713          	slli	a4,a0,0x4
    80005b7a:	0a070713          	addi	a4,a4,160
    80005b7e:	973e                	add	a4,a4,a5
    80005b80:	01603633          	snez	a2,s6
    80005b84:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005b86:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005b8a:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64)buf0;
    80005b8e:	6398                	ld	a4,0(a5)
    80005b90:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005b92:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80005b96:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    80005b98:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005b9a:	6390                	ld	a2,0(a5)
    80005b9c:	00d605b3          	add	a1,a2,a3
    80005ba0:	4741                	li	a4,16
    80005ba2:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005ba4:	4805                	li	a6,1
    80005ba6:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005baa:	fa442703          	lw	a4,-92(s0)
    80005bae:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64)b->data;
    80005bb2:	0712                	slli	a4,a4,0x4
    80005bb4:	963a                	add	a2,a2,a4
    80005bb6:	05898593          	addi	a1,s3,88
    80005bba:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005bbc:	0007b883          	ld	a7,0(a5)
    80005bc0:	9746                	add	a4,a4,a7
    80005bc2:	40000613          	li	a2,1024
    80005bc6:	c710                	sw	a2,8(a4)
  if (write)
    80005bc8:	001b3613          	seqz	a2,s6
    80005bcc:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005bd0:	01066633          	or	a2,a2,a6
    80005bd4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005bd8:	fa842583          	lw	a1,-88(s0)
    80005bdc:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005be0:	00250613          	addi	a2,a0,2
    80005be4:	0612                	slli	a2,a2,0x4
    80005be6:	963e                	add	a2,a2,a5
    80005be8:	577d                	li	a4,-1
    80005bea:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    80005bee:	0592                	slli	a1,a1,0x4
    80005bf0:	98ae                	add	a7,a7,a1
    80005bf2:	03068713          	addi	a4,a3,48
    80005bf6:	973e                	add	a4,a4,a5
    80005bf8:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005bfc:	6398                	ld	a4,0(a5)
    80005bfe:	972e                	add	a4,a4,a1
    80005c00:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005c04:	4689                	li	a3,2
    80005c06:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005c0a:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005c0e:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80005c12:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005c16:	6794                	ld	a3,8(a5)
    80005c18:	0026d703          	lhu	a4,2(a3)
    80005c1c:	8b1d                	andi	a4,a4,7
    80005c1e:	0706                	slli	a4,a4,0x1
    80005c20:	96ba                	add	a3,a3,a4
    80005c22:	00a69223          	sh	a0,4(a3)

// fence for memory-mapped IO
static inline void
io_fence()
{
  asm volatile("fence iorw, iorw" ::: "memory");
    80005c26:	0ff0000f          	fence

  io_fence();

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005c2a:	6798                	ld	a4,8(a5)
    80005c2c:	00275783          	lhu	a5,2(a4)
    80005c30:	2785                	addiw	a5,a5,1
    80005c32:	00f71123          	sh	a5,2(a4)
    80005c36:	0ff0000f          	fence

  io_fence();

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005c3a:	100017b7          	lui	a5,0x10001
    80005c3e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    80005c42:	0049a783          	lw	a5,4(s3)
    80005c46:	03079663          	bne	a5,a6,80005c72 <virtio_disk_rw+0x1d0>
    sleep_prepare(b);
    release(&disk.vdisk_lock);
    80005c4a:	0001e497          	auipc	s1,0x1e
    80005c4e:	0ee48493          	addi	s1,s1,238 # 80023d38 <disk+0x128>
  while (b->disk == 1) {
    80005c52:	893e                	mv	s2,a5
    sleep_prepare(b);
    80005c54:	854e                	mv	a0,s3
    80005c56:	c10fc0ef          	jal	80002066 <sleep_prepare>
    release(&disk.vdisk_lock);
    80005c5a:	8526                	mv	a0,s1
    80005c5c:	820fb0ef          	jal	80000c7c <release>
    sleep();
    80005c60:	c42fc0ef          	jal	800020a2 <sleep>
    acquire(&disk.vdisk_lock);
    80005c64:	8526                	mv	a0,s1
    80005c66:	f93fa0ef          	jal	80000bf8 <acquire>
  while (b->disk == 1) {
    80005c6a:	0049a783          	lw	a5,4(s3)
    80005c6e:	ff2783e3          	beq	a5,s2,80005c54 <virtio_disk_rw+0x1b2>
  }

  disk.info[idx[0]].b = 0;
    80005c72:	fa042903          	lw	s2,-96(s0)
    80005c76:	00290713          	addi	a4,s2,2
    80005c7a:	0712                	slli	a4,a4,0x4
    80005c7c:	0001e797          	auipc	a5,0x1e
    80005c80:	f9478793          	addi	a5,a5,-108 # 80023c10 <disk>
    80005c84:	97ba                	add	a5,a5,a4
    80005c86:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005c8a:	0001e997          	auipc	s3,0x1e
    80005c8e:	f8698993          	addi	s3,s3,-122 # 80023c10 <disk>
    80005c92:	00491713          	slli	a4,s2,0x4
    80005c96:	0009b783          	ld	a5,0(s3)
    80005c9a:	97ba                	add	a5,a5,a4
    80005c9c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005ca0:	854a                	mv	a0,s2
    80005ca2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005ca6:	bcdff0ef          	jal	80005872 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    80005caa:	8885                	andi	s1,s1,1
    80005cac:	f0fd                	bnez	s1,80005c92 <virtio_disk_rw+0x1f0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005cae:	0001e517          	auipc	a0,0x1e
    80005cb2:	08a50513          	addi	a0,a0,138 # 80023d38 <disk+0x128>
    80005cb6:	fc7fa0ef          	jal	80000c7c <release>
}
    80005cba:	60e6                	ld	ra,88(sp)
    80005cbc:	6446                	ld	s0,80(sp)
    80005cbe:	64a6                	ld	s1,72(sp)
    80005cc0:	6906                	ld	s2,64(sp)
    80005cc2:	79e2                	ld	s3,56(sp)
    80005cc4:	7a42                	ld	s4,48(sp)
    80005cc6:	7aa2                	ld	s5,40(sp)
    80005cc8:	7b02                	ld	s6,32(sp)
    80005cca:	6be2                	ld	s7,24(sp)
    80005ccc:	6c42                	ld	s8,16(sp)
    80005cce:	6125                	addi	sp,sp,96
    80005cd0:	8082                	ret

0000000080005cd2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005cd2:	1101                	addi	sp,sp,-32
    80005cd4:	ec06                	sd	ra,24(sp)
    80005cd6:	e822                	sd	s0,16(sp)
    80005cd8:	e426                	sd	s1,8(sp)
    80005cda:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005cdc:	0001e497          	auipc	s1,0x1e
    80005ce0:	f3448493          	addi	s1,s1,-204 # 80023c10 <disk>
    80005ce4:	0001e517          	auipc	a0,0x1e
    80005ce8:	05450513          	addi	a0,a0,84 # 80023d38 <disk+0x128>
    80005cec:	f0dfa0ef          	jal	80000bf8 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005cf0:	100017b7          	lui	a5,0x10001
    80005cf4:	53bc                	lw	a5,96(a5)
    80005cf6:	8b8d                	andi	a5,a5,3
    80005cf8:	10001737          	lui	a4,0x10001
    80005cfc:	d37c                	sw	a5,100(a4)
    80005cfe:	0ff0000f          	fence
  io_fence();

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    80005d02:	689c                	ld	a5,16(s1)
    80005d04:	0204d703          	lhu	a4,32(s1)
    80005d08:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005d0c:	04f70663          	beq	a4,a5,80005d58 <virtio_disk_intr+0x86>
    80005d10:	0ff0000f          	fence
    io_fence();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005d14:	6898                	ld	a4,16(s1)
    80005d16:	0204d783          	lhu	a5,32(s1)
    80005d1a:	8b9d                	andi	a5,a5,7
    80005d1c:	078e                	slli	a5,a5,0x3
    80005d1e:	97ba                	add	a5,a5,a4
    80005d20:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0)
    80005d22:	00278713          	addi	a4,a5,2
    80005d26:	0712                	slli	a4,a4,0x4
    80005d28:	9726                	add	a4,a4,s1
    80005d2a:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005d2e:	e321                	bnez	a4,80005d6e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005d30:	0789                	addi	a5,a5,2
    80005d32:	0792                	slli	a5,a5,0x4
    80005d34:	97a6                	add	a5,a5,s1
    80005d36:	6788                	ld	a0,8(a5)
    b->disk = 0; // disk is done with buf
    80005d38:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005d3c:	b9afc0ef          	jal	800020d6 <wakeup>

    disk.used_idx += 1;
    80005d40:	0204d783          	lhu	a5,32(s1)
    80005d44:	2785                	addiw	a5,a5,1
    80005d46:	17c2                	slli	a5,a5,0x30
    80005d48:	93c1                	srli	a5,a5,0x30
    80005d4a:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    80005d4e:	6898                	ld	a4,16(s1)
    80005d50:	00275703          	lhu	a4,2(a4)
    80005d54:	faf71ee3          	bne	a4,a5,80005d10 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005d58:	0001e517          	auipc	a0,0x1e
    80005d5c:	fe050513          	addi	a0,a0,-32 # 80023d38 <disk+0x128>
    80005d60:	f1dfa0ef          	jal	80000c7c <release>
}
    80005d64:	60e2                	ld	ra,24(sp)
    80005d66:	6442                	ld	s0,16(sp)
    80005d68:	64a2                	ld	s1,8(sp)
    80005d6a:	6105                	addi	sp,sp,32
    80005d6c:	8082                	ret
      panic("virtio_disk_intr status");
    80005d6e:	00002517          	auipc	a0,0x2
    80005d72:	ac250513          	addi	a0,a0,-1342 # 80007830 <etext+0x830>
    80005d76:	ad3fa0ef          	jal	80000848 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	9282                	jalr	t0

000000008000609c <userret>:
    8000609c:	0000100f          	fence.i
    800060a0:	12000073          	sfence.vma
    800060a4:	18051073          	csrw	satp,a0
    800060a8:	12000073          	sfence.vma
    800060ac:	02000537          	lui	a0,0x2000
    800060b0:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060b2:	0536                	slli	a0,a0,0xd
    800060b4:	02853083          	ld	ra,40(a0)
    800060b8:	03053103          	ld	sp,48(a0)
    800060bc:	03853183          	ld	gp,56(a0)
    800060c0:	04053203          	ld	tp,64(a0)
    800060c4:	04853283          	ld	t0,72(a0)
    800060c8:	05053303          	ld	t1,80(a0)
    800060cc:	05853383          	ld	t2,88(a0)
    800060d0:	7120                	ld	s0,96(a0)
    800060d2:	7524                	ld	s1,104(a0)
    800060d4:	7d2c                	ld	a1,120(a0)
    800060d6:	6150                	ld	a2,128(a0)
    800060d8:	6554                	ld	a3,136(a0)
    800060da:	6958                	ld	a4,144(a0)
    800060dc:	6d5c                	ld	a5,152(a0)
    800060de:	0a053803          	ld	a6,160(a0)
    800060e2:	0a853883          	ld	a7,168(a0)
    800060e6:	0b053903          	ld	s2,176(a0)
    800060ea:	0b853983          	ld	s3,184(a0)
    800060ee:	0c053a03          	ld	s4,192(a0)
    800060f2:	0c853a83          	ld	s5,200(a0)
    800060f6:	0d053b03          	ld	s6,208(a0)
    800060fa:	0d853b83          	ld	s7,216(a0)
    800060fe:	0e053c03          	ld	s8,224(a0)
    80006102:	0e853c83          	ld	s9,232(a0)
    80006106:	0f053d03          	ld	s10,240(a0)
    8000610a:	0f853d83          	ld	s11,248(a0)
    8000610e:	10053e03          	ld	t3,256(a0)
    80006112:	10853e83          	ld	t4,264(a0)
    80006116:	11053f03          	ld	t5,272(a0)
    8000611a:	11853f83          	ld	t6,280(a0)
    8000611e:	7928                	ld	a0,112(a0)
    80006120:	10200073          	sret
	...
