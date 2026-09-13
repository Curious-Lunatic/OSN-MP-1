#include"../include/shell.h"
#include"../include/lexer.h"
static const char* syscall_name(long num){
    switch(num){
        case 0: return "read";
        case 1: return "write";
        case 2: return "open";
        case 3: return "close";
        case 4: return "stat";
        case 5: return "fstat";
        case 6: return "lstat";
        case 8: return "lseek";
        case 9: return "mmap";
        case 10: return "mprotect";
        case 11: return "munmap";
        case 12: return "brk";
        case 13: return "rt_sigaction";
        case 14: return "rt_sigprocmask";
        case 16: return "ioctl";
        case 17: return "pread64";
        case 18: return "pwrite64";
        case 21: return "access";
        case 22: return "pipe";
        case 32: return "dup";
        case 33: return "dup2";
        case 35: return "nanosleep";
        case 39: return "getpid";
        case 41: return "socket";
        case 42: return "connect";
        case 56: return "clone";
        case 57: return "fork";
        case 58: return "vfork";
        case 59: return "execve";
        case 60: return "exit";
        case 61: return "wait4";
        case 62: return "kill";
        case 63: return "uname";
        case 72: return "fcntl";
        case 78: return "getdents";
        case 79: return "getcwd";
        case 80: return "chdir";
        case 82: return "rename";
        case 83: return "mkdir";
        case 84: return "rmdir";
        case 85: return "creat";
        case 86: return "link";
        case 87: return "unlink";
        case 89: return "readlink";
        case 90: return "chmod";
        case 92: return "chown";
        case 97: return "getrlimit";
        case 102: return "getuid";
        case 104: return "getgid";
        case 105: return "setuid";
        case 106: return "setgid";
        case 107: return "geteuid";
        case 108: return "getegid";
        case 110: return "getppid";
        case 137: return "statfs";
        case 157: return "prctl";
        case 158: return "arch_prctl";
        case 186: return "gettid";
        case 202: return "futex";
        case 217: return "getdents64";
        case 218: return "set_tid_address";
        case 228: return "clock_gettime";
        case 231: return "exit_group";
        case 257: return "openat";
        case 262: return "newfstatat";
        case 273: return "set_robust_list";
        case 302: return "prlimit64";
        case 318: return "getrandom";
        default: return NULL;
    }
}

typedef struct{
    long num;
    long count;
    double total_time;
    int first_seen;
} snoop_stat;

static int cmp_stats(const void *a, const void *b){
    const snoop_stat *sa = a, *sb = b;
    if(sb->count != sa->count) return (int)(sb->count - sa->count);
    return sa->first_seen - sb->first_seen;
}

static double now_seconds(void){
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec + ts.tv_nsec / 1e9;
}

void snooping(char **args, int acount){
    pid_t pid;

    if(acount >= 1 && strcmp(args[0], "-p") == 0){
        if(acount < 2){
            printf("snoop: no such process\n");
            return;
        }
        char *end;
        long v = strtol(args[1], &end, 10);
        if(*end != '\0'){
            printf("snoop: no such process\n");
            return;
        }
        pid = (pid_t)v;
        char procdir[64];
        snprintf(procdir, sizeof(procdir), "/proc/%d", (int)pid);
        if(access(procdir, F_OK) != 0){
            printf("snoop: no such process\n");
            return;
        }
        if(ptrace(PTRACE_ATTACH, pid, NULL, NULL) < 0){
            printf("snoop: no such process\n");
            return;
        }
        int status;
        waitpid(pid, &status, 0);
    } else {
        if(acount < 1){
            printf("snoop: command not found\n");
            return;
        }
        const char *stripped;
        char *path = resolving(args[0], &stripped);
        if(!path){
            printf("snoop: command not found\n");
            return;
        }
        char pathcopy[5000];
        strncpy(pathcopy, path, 4999);
        pathcopy[4999] = '\0';

        pid = fork();
        if(pid == 0){
            ptrace(PTRACE_TRACEME, 0, NULL, NULL);
            execv(pathcopy, args);
            _exit(127);
        }
        int status;
        waitpid(pid, &status, 0);
    }

    ptrace(PTRACE_SETOPTIONS, pid, NULL, PTRACE_O_TRACESYSGOOD);

    snoop_stat stats[512];
    int stat_count = 0;
    int order = 0;
    int in_syscall = 0;
    long current_num = -1;
    double entry_time = 0;
    int sig_to_forward = 0;

    while(1){
        ptrace(PTRACE_SYSCALL, pid, NULL, (long)sig_to_forward);
        int status;
        waitpid(pid, &status, 0);
        sig_to_forward = 0;

        if(WIFEXITED(status) || WIFSIGNALED(status)) break;

        if(WIFSTOPPED(status)){
            int sig = WSTOPSIG(status);
            if(sig == (SIGTRAP | 0x80)){
                struct user_regs_struct regs;
                ptrace(PTRACE_GETREGS, pid, NULL, &regs);
                long num = regs.orig_rax;

                if(!in_syscall){
                    current_num = num;
                    entry_time = now_seconds();
                    in_syscall = 1;
                } else {
                    double dt = now_seconds() - entry_time;
                    int idx = -1;
                    for(int i = 0; i < stat_count; i++){
                        if(stats[i].num == current_num){ idx = i; break; }
                    }
                    if(idx < 0 && stat_count < 512){
                        idx = stat_count++;
                        stats[idx].num = current_num;
                        stats[idx].count = 0;
                        stats[idx].total_time = 0;
                        stats[idx].first_seen = order++;
                    }
                    if(idx >= 0){
                        stats[idx].count++;
                        stats[idx].total_time += dt;
                    }
                    in_syscall = 0;
                }
            } else {
                sig_to_forward = sig;
            }
        }
    }

    qsort(stats, stat_count, sizeof(snoop_stat), cmp_stats);

    printf("syscall\t\tcalls\ttime\n");
    for(int i = 0; i < stat_count; i++){
        const char *name = syscall_name(stats[i].num);
        char fallback[32];
        if(!name){
            snprintf(fallback, sizeof(fallback), "syscall_%ld", stats[i].num);
            name = fallback;
        }
        printf("%-16s%ld\t%.3fs\n", name, stats[i].count, stats[i].total_time);
    }
}