# OSN Mini-Project 1
#### Name : Soubhagya Ranjan Biswal
#### Roll Number : 2025117010
#### Late Days Used : 1
---
## Table of Contents
- [1. Folder Structure](#1-folder-structure)
- [2. How to Build and Run](#2-how-to-build-and-run)
  - [2.1 C-Shell](#21-c-shell)
  - [2.2 xv6 Schedulers](#22-xv6-schedulers)
  - [2.3 Performance Comparison & Plotting](#23-performance-comparison--plotting)
- [3. C-Shell Implementation Details](#3-c-shell-implementation-details)
  - [Features Implemented](#features-implemented)
  - [Design Choices](#design-choices)
  - [Assumptions](#assumptions)
- [4. xv6 Schedulers Implementation Details](#4-xv6-schedulers-implementation-details)
  - [Key Changes in xv6](#key-changes-in-xv6)
  - [MLFQ Scheduling Rules](#mlfq-scheduling-rules)
  - [Performance Comparison Summary](#performance-comparison-summary)
- [5. Error Handling & Edge Cases](#5-error-handling--edge-cases)

---

## 1. Folder Structure

```
mini-project1/
├── c-shell/
│   ├── src/
│   ├── include/
│   └── Makefile
├── xv6/
│   ├── user/
│   ├── mkfs/
│   ├── kernel/
│   ├── Makefile
│   └── report.md    # Or report.pdf
├── AI-usage.pdf
└── README.md
```
---

## 2. How to Build and Run

### 2.1 C-Shell

#### Compilation
The shell uses standard POSIX compile flags (`-std=c23`, `-D_POSIX_C_SOURCE=200809L`, `-D_XOPEN_SOURCE=700`, `-Wall`, `-Wextra`, `-Werror`, `-fno-asm`).

```bash
cd c-shell
make all
```

This generates the executable `shell.out` inside the `c-shell/` directory.

#### Running
```bash
./shell.out
```

To clean build artifacts:
```bash
make clean
```

---

### 2.2 xv6 Schedulers

xv6 can be compiled with different scheduling algorithms using the `SCHEDULER` flag. If no flag is given, it defaults to Round-Robin (RR).

#### 1. Default Round-Robin (RR)
```bash
cd xv6
make clean
make qemu CPUS=1
```

#### 2. Multi-Level Feedback Queue (MLFQ)
```bash
cd xv6
make clean
make qemu SCHEDULER=MLFQ CPUS=1
```

To enable debug logging for timeline graph generation:
```bash
make clean
make qemu SCHEDULER=MLFQ MLFQ_DEBUG=1 CPUS=1
```

#### 3. First-Come-First-Served (FIFO)
```bash
cd xv6
make clean
make qemu SCHEDULER=FIFO CPUS=1
```

To exit QEMU at any time, press `Ctrl+A` then `X`.

---

### 2.3 Performance Comparison & Plotting

Inside the running xv6 QEMU instance, run the scheduler test suite:
```bash
$ schedulertest
```

#### Generating the MLFQ Timeline Plot
Save the QEMU output to a file (e.g., `mlfq.txt`) and run:
```bash
python3 plot_mlfq.py mlfq.txt <your_iiit_username>
```
This produces `mlfq_timeline.png` with your username watermark.

#### Comparing Schedulers
Collect log outputs from test runs of RR, FIFO, and MLFQ into `rr.txt`, `fifo.txt`, and `mlfq.txt`, then run:
```bash
python3 compare_schedulers.py rr.txt fifo.txt mlfq.txt
```

---

## 3. C-Shell Implementation Details

### Features Implemented

#### Part A: Shell Input & Parsing
* **A1: Prompt:** Formatted as `<username@hostname:currentpath>`. If the current directory is within the shell's starting directory, it is replaced with `~`.
* **A2: User Input:** Reads complete input lines up to 1024 characters.
* **A3: Lexer & Parser:** Implemented via finite-state automata following the project grammar.
  * Correctly groups fragments into words (`WORD -> fragment+`).
  * Handles single quotes (`'...'` verbatim), double quotes (`"..."` with `\"` and `\\` escaping), and backslash escapes outside quotes.
  * Rejects unclosed quotes, trailing backslashes, and invalid operator sequences (`| ;`, `& ;`, etc.) by printing `cshell: invalid syntax`.

#### Part B: Shell Intrinsics
* **B1: `hop`:** Changes directory supporting `~`, `.`, `..`, `-`, and relative/absolute paths.
  * Features a **persistent frecency algorithm** saved to `.frecency` in the shell home folder. If a path cannot be found directly, the shell hops to the highest-ranking directory matching the target name as a substring.
  * Updates frecency only for actual hops (ignoring no-ops like `.`).
  * Sequential arguments are executed one by one; execution halts at the first invalid target.
* **B2: `reveal`:** Lists directory contents in lexicographical ASCII order.
  * Flags: `-a` (includes hidden files, excludes `.` and `..`), `-t` (recursively traverses subdirectories, appending `/` to directory names).
  * Multiple flag groups (such as `-ta`, `-t -a`) are fully supported.
  * Directory names containing spaces are enclosed in single quotes.
* **B3: `peek`:** Prints file contents or standard input (`-`).
  * Flags: `-n` (numbers non-empty lines continuously across files), `-r` (reverses lines in each file before concatenation).
  * Combined `-nr` preserves the original line numbers while displaying them in reverse order.
* **B4: `locate`:** Searches for executable files first in the current working directory, then across every directory in `$PATH`.
  * Outputs all matching paths or reports `locate: command not found (<name>)`.

#### Part C: Redirection and Pipes
* **C1: Execution:** Executes binaries via path or `$PATH`. If prefixed with `%`, the shell skips the current directory and searches `$PATH` directly.
* **C2: Input Redirection (`<`):** Supports multiple input redirections (e.g., `cat < f1 < f2`), concatenating the contents of all files in order into standard input.
* **C3: Output Redirection (`>` and `>>`):** Supports multiple output redirections (e.g., `echo hi > out1 >> out2`). All target files receive the exact output produced.
* **C4: Pipelines (`|`):** Connects commands via standard UNIX pipes (`pipe()`, `dup2()`). Closes unused ends across parent and child processes. Builtin commands run properly inside pipelines without altering the parent shell state.

#### Part D: Sequential & Background Execution
* **D1: Sequential Execution (`;`):** Executes command groups in sequence. Stops immediately if any command cannot be started (command not found).
* **D2: Background Execution (`&`):** Launches jobs without waiting. Prints `[job_number] pid` before command output.
  * Automatically reaps background processes using a non-blocking `SIGCHLD` handler (`waitpid(-1, &status, WNOHANG)`).
  * Reports exit messages (`exited normally` or `exited abnormally`) immediately or deferred after any running foreground task finishes.

#### Part E: Exotic Intrinsics & Job Control
* **E1: `activities`:** Displays all currently active jobs grouped by process group (PGID), with individual PIDs, command names, and states (`Running` or `Stopped`).
* **E2: Terminal Control:**
  * Shell ignores `SIGTTOU` and installs signal handlers for `SIGINT` (Ctrl+C) and `SIGTSTP` (Ctrl+Z) so it never crashes.
  * Uses `tcsetpgrp()` to grant foreground process groups terminal access, reclaiming control upon termination or suspension.
  * On Ctrl+D at an empty prompt, the shell warns if there are stopped jobs (`cshell: there are stopped jobs`). If pressed a second consecutive time, it terminates after sending `SIGHUP` to all child process groups.
* **E3: `resume`:** Resumes jobs using `SIGCONT`:
  * `resume %job_number fg [--timeout <seconds>]`: Brings job to foreground. If a timeout is specified and expires, sends `SIGTERM` and reclaims the terminal.
  * `resume %job_number bg`: Resumes job in background.
* **E4: `ping`:** Sends signals to tracked processes or process groups (`ping <target> <sig>`). Validates non-negative signal numbers, computes `sig % 64`, and checks that the target was spawned by the shell.

#### Part F: Process Inspection & Tracing
* **F1: `spy`:** Inspects open file descriptors, current working directory, executable binary, and memory-mapped files from `/proc/[pid]/`. Identifies object types (`REG`, `DIR`, `CHR`, `FIFO`).
* **F2: `snoop`:** Uses Linux `ptrace` to intercept system call entries and exits. Calculates total call count and elapsed time using a monotonic clock, outputting a sorted summary table.

---

### Design Choices

1. **Finite State Automaton (FSA) for Lexing and Parsing:**
   Rather than using complex external parser generators, the shell uses regular state machines for both tokenization and grammar verification. This ensures strict compliance with POSIX rules and gives fine control over maximal munch and escape characters.
2. **Persistent Frecency Storage:**
   The frecency table is maintained in `$HOME_SHELL/.frecency`. Each entry stores the directory path, visit frequency, and the timestamp of the last visit. The scoring prioritizes visit frequency with recency breaking ties, allowing fast lookups for frequently used directories.
3. **Multi-File Redirection via Staging Descriptors:**
   To satisfy multiple input redirections (`< f1 < f2`), input files are read sequentially into a staging stream supplied to the child's `STDIN_FILENO`. For multiple output redirections (`> f1 >> f2`), output is captured and cloned into all destinations, ensuring all specified files receive the output without race conditions.
4. **Process Group Isolation:**
   Each pipeline is placed into its own dedicated process group via `setpgid()` immediately upon creation. This prevents signals meant for foreground child processes (like Ctrl+C or Ctrl+Z) from corrupting background tasks or the shell itself.

---

### Assumptions

1. **Maximum Input Length:** The command line input is assumed not to exceed 1024 characters per the assignment specification.
2. **Path Separators:** Substring matching for frecency searches within valid directory paths on the local filesystem.
3. **Peek Memory Buffering:** For `peek -r`, lines are buffered in fixed-size blocks and reversed in memory before display to preserve exact ordering and line numbers across both regular files and stdin pipelines.
4. **System Architecture for Snoop:** `snoop` inspects `orig_rax` on x86_64 Linux systems to read system call registers.

---

## 4. xv6 Schedulers Implementation Details

### Key Changes in xv6

1. **`Makefile`**:
   - Added conditional compilation for the `SCHEDULER` flag (`RR`, `FIFO`, `MLFQ`).
   - Automatically defines `-DMLFQ` or `-DFIFO`, defaulting to standard Round-Robin if `SCHEDULER` is omitted.
2. **`kernel/proc.h`**:
   - Added tracking metrics to `struct proc`:
     - `creation_time`: Tick count at process creation.
     - `first_run_time`: Tick count when the process first acquires the CPU (used for response time).
     - `end_time`: Tick count when the process exits.
     - `cpu_ticks`: Total CPU burst ticks accumulated.
     - `queue`: Current MLFQ priority level (0 to 3).
     - `ticks_used`: Ticks consumed in the current time slice.
3. **`kernel/proc.c`**:
   - **`allocproc()`**: Initializes `creation_time = ticks`, `first_run_time = -1`, `queue = 0`, and `ticks_used = 0`.
   - **`scheduler()`**:
     - Implements priority-level scanning for MLFQ: queues 0 through 3 are evaluated in order.
     - Within each queue, runnable processes are picked round-robin using a per-queue index `mlfq_last[q]`.
     - Priority boosting runs every 48 ticks via `mlfq_boost()`, returning all active processes to Queue 0.
   - **`sleep()`**:
     - Resets `ticks_used = 0` while keeping `queue` intact, ensuring processes yielding voluntarily for I/O retain their priority level.
   - **`procdump()`**:
     - Extended to print PID, STATE, NAME, current QUEUE, TICKS_USED, CPU_TICKS, and timestamps upon Ctrl+P.
4. **`kernel/trap.c`**:
   - On timer interrupts (`which_dev == 2`), calls `mlfq_timer_tick()`, increments tick counts, demotes processes upon slice completion, and calls `yield()` when preemption is required.

---

### MLFQ Scheduling Rules

* **4 Queues:**
  * Queue 0: Highest priority.
  * Queue 3: Lowest priority (scheduled Round-Robin).
* **Strict Priority:** The scheduler always executes tasks from the highest non-empty queue.
* **Preemption:** If a process arrives in a higher-priority queue, the running process is preempted at the next timer tick.
* **Voluntary Yield:** If a process blocks on I/O, it leaves the queue and returns to the tail of the same queue with its slice reset upon waking.
* **Anti-Starvation Boost:** Every 48 ticks, all processes are promoted to Queue 0 to prevent starvation of CPU-heavy jobs.

---

### Performance Comparison Summary

The three schedulers were evaluated on an identical workload using `schedulertest`:

| Scheduler | Avg Turnaround Time (ticks) | Avg Waiting Time (ticks) | Avg Response Time (ticks) |
| :--- | :---: | :---: | :---: |
| **Round-Robin (RR)** | 71.83 | 50.33 | 1.67 |
| **FIFO** | 132.17 | 110.67 | 73.17 |
| **MLFQ** | 69.33 | 47.50 | 1.67 |

#### Observations:
* **FIFO** suffers heavily from the convoy effect: short processes arriving behind a long CPU-bound process must wait for it to finish, driving average waiting and response times up significantly.
* **Round-Robin (RR)** guarantees fairness and rapid initial response time (1.67 ticks), but incurs higher waiting times as CPU-bound tasks continuously interleave with short tasks.
* **MLFQ** achieves the best overall balance: interactive and short processes complete quickly in higher priority queues, while long CPU-bound processes are pushed to lower queues, yielding the lowest turnaround (69.33 ticks) and waiting time (47.50 ticks).

---

## 5. Error Handling & Edge Cases

* **Invalid Syntax:** Any malformed command or invalid flag consistently outputs the exact required error string (e.g. `cshell: invalid syntax`, `reveal: invalid syntax`, `locate: invalid syntax`, `ping: invalid syntax`).
* **Non-existent Binaries:** Unrecognized commands output `cshell: command not found (<name>)`. In pipelines, other valid stages continue running.
* **Zombie Reaping:** All terminated background processes are cleaned up promptly by `waitpid` inside the `SIGCHLD` handler to prevent zombie accumulation.
* **Safe Terminal Signals:** Shell handles `SIGINT` and `SIGTSTP` gracefully, preventing accidental terminal hangs or premature termination.
