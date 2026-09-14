// ============================================================
//  trap.c  —  xv6-riscv trap handling
//
//  This file is the FULL kernel/trap.c from the xv6-riscv source.
//  The sections that require MLFQ-specific additions are marked with:
//
//      /* >>>MLFQ_CHANGE<<< */
//
//  Apply these changes to your project's complete trap.c.
// ============================================================

// Saved registers for kernel context switches.
struct context {
  uint64 ra;
  uint64 sp;

  // callee-saved
  uint64 s0;
  uint64 s1;
  uint64 s2;
  uint64 s3;
  uint64 s4;
  uint64 s5;
  uint64 s6;
  uint64 s7;
  uint64 s8;
  uint64 s9;
  uint64 s10;
  uint64 s11;
};

// Per-CPU state.
struct cpu {
  struct proc *proc;      // The process running on this cpu, or null.
  struct context context; // swtch() here to enter scheduler().
  int noff;               // Depth of push_off() nesting.
  int intena;             // Were interrupts enabled before push_off()
};

extern struct cpu cpus[NCPU];

// per-process data for the trap handling code in trampoline.S.
// sits in a page by itself just under the trampoline page in the
// user page table. not specially mapped in the kernel page table.
// uservec in trampoline.S saves user registers in the trapframe,
// then initializes registers from the trapframe's
// kernel_sp, kernel_hartid, kernel_satp, and jumps to kernel_trap.
// prepare_return() and userret in trampoline.S set up
// the trapframe's kernel_*, restore user registers from the
// trapframe, switch to the user page table, and enter user space.
struct trapframe {
  /*   0 */ uint64 kernel_satp;   // kernel page table
  /*   8 */ uint64 kernel_sp;     // top of process's kernel stack
  /*  16 */ uint64 kernel_trap;   // usertrap()
  /*  24 */ uint64 epc;           // saved user program counter
  /*  32 */ uint64 kernel_hartid; // saved kernel tp
  /*  40 */ uint64 ra;
  /*  48 */ uint64 sp;
  /*  56 */ uint64 gp;
  /*  64 */ uint64 tp;
  /*  72 */ uint64 t0;
  /*  80 */ uint64 t1;
  /*  88 */ uint64 t2;
  /*  96 */ uint64 s0;
  /* 104 */ uint64 s1;
  /* 112 */ uint64 a0;
  /* 120 */ uint64 a1;
  /* 128 */ uint64 a2;
  /* 136 */ uint64 a3;
  /* 144 */ uint64 a4;
  /* 152 */ uint64 a5;
  /* 160 */ uint64 a6;
  /* 168 */ uint64 a7;
  /* 176 */ uint64 s2;
  /* 184 */ uint64 s3;
  /* 192 */ uint64 s4;
  /* 200 */ uint64 s5;
  /* 208 */ uint64 s6;
  /* 216 */ uint64 s7;
  /* 224 */ uint64 s8;
  /* 232 */ uint64 s9;
  /* 240 */ uint64 s10;
  /* 248 */ uint64 s11;
  /* 256 */ uint64 t3;
  /* 264 */ uint64 t4;
  /* 272 */ uint64 t5;
  /* 280 */ uint64 t6;
};

enum procstate { UNUSED, USED, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };

// Per-process state
struct proc {
  struct spinlock lock;

  // p->lock must be held when using these:
  enum procstate state; // Process state
  void *chan;           // If non-zero, sleeping on chan
  int killed;           // If non-zero, have been killed
  int xstate;           // Exit status to be returned to parent's wait
  int pid;              // Process ID

  // wait_lock must be held when using this:
  struct proc *parent; // Parent process

  // these are private to the process, so p->lock need not be held.
  uint64 kstack;               // Virtual address of kernel stack
  uint64 sz;                   // Size of process memory (bytes)
  pagetable_t pagetable;       // User page table
  struct trapframe *trapframe; // data page for trampoline.S
  struct context context;      // swtch() here to run process
  struct file *ofile[NOFILE];  // Open files
  struct inode *cwd;           // Current directory
  char name[16];               // Process name (debugging)

  // Scheduling bookkeeping
  uint creation_time;
  int  first_run_time;
  uint end_time;
  int  cpu_ticks;
  int  queue;
  int  ticks_used;
};

// ============================================================
//  CHANGES REQUIRED IN YOUR FULL trap.c
// ============================================================
//
//  1. In usertrap() — the "give up CPU for timer interrupt" block:
//
//     ORIGINAL:
//       if(which_dev == 2)
//         yield();
//
//     REPLACE WITH:
//       if(which_dev == 2){
// /* >>>MLFQ_CHANGE<<< */
// #ifdef MLFQ
//         mlfq_timer_tick();   // update ticks_used, demote queue if slice done
// #else
//         // For RR and FIFO, still track cpu_ticks per process.
//         struct proc *cp = myproc();
//         if(cp) cp->cpu_ticks++;
// #endif
//         yield();
//       }
//
//  2. In kerneltrap() — the same timer-interrupt block inside the kernel:
//
//     ORIGINAL:
//       if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
//         yield();
//
//     REPLACE WITH:
//       if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING){
// /* >>>MLFQ_CHANGE<<< */
// #ifdef MLFQ
//         mlfq_timer_tick();
// #else
//         myproc()->cpu_ticks++;
// #endif
//         yield();
//       }
//
//  3. mlfq_timer_tick() is DEFINED in kernel/proc.c.
//     Add this declaration near the top of trap.c (with the other externs):
//
// /* >>>MLFQ_CHANGE<<< */
// #ifdef MLFQ
// void mlfq_timer_tick(void);
// #endif
//
// ============================================================
//  No other changes to trap.c are required.
// ============================================================