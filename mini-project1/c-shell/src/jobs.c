#include "../include/shell.h"
#include "../include/lexer.h"
jobb jobs[maxjobs];
int job_count;
int next_job=1;
volatile sig_atomic_t fg_running = 0;
#define max_pending 64
static char pending_msg[max_pending][320];
static volatile sig_atomic_t pending_count = 0;

static void queue_or_print(const char *cmdname, pid_t pid, int normal){
    char buffer[300];
    int len = snprintf(buffer, sizeof(buffer), "%s with pid %d exited %s\n", cmdname, (int)pid, normal ? "normally" : "abnormally");
    if (fg_running){
        if (pending_count<max_pending){
            memcpy(pending_msg[pending_count], buffer, len+1);
            pending_count++;
        }
    }
    else{
        write(STDOUT_FILENO, buffer, len);
    }
}

static void sigchld_handler(int sig){
    (void)sig;
    int saved_errno = errno;
    int status;
    pid_t pid;
    while((pid = waitpid(-1, &status, WNOHANG)) > 0){
        for(int i = 0; i < job_count; i++){
            if(jobs[i].active && jobs[i].pid == pid){
                if(WIFEXITED(status)){
                    queue_or_print(jobs[i].command, pid, 1);
                } else if(WIFSIGNALED(status)){
                    queue_or_print(jobs[i].command, pid, 0);
                }
                jobs[i].active = 0;
                break;
            }
        }
    }
    errno = saved_errno;
}

void install_sigchild (void){
    struct sigaction sa;
    sa.sa_handler = sigchld_handler;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = SA_RESTART; 
    sigaction(SIGCHLD, &sa, NULL);
}


void flush_pending_bg_msg(void){
    sigset_t block,old;
    sigemptyset(&block);
    sigaddset(&block, SIGCHLD);
    sigprocmask(SIG_BLOCK, &block, &old);
    int n= pending_count;
    pending_count = 0;
    sigprocmask(SIG_SETMASK, &old, NULL);
    for(int i=0; i<n; i++){
        write(STDOUT_FILENO, pending_msg[i], strlen(pending_msg[i]));
    }
}

int register_job(pid_t pid, const char* cmdname){
    int num = next_job++;
    if(job_count<maxjobs){
        jobs[job_count].job_number = num;
        jobs[job_count].pid = pid;
        strncpy(jobs[job_count].command, cmdname, sizeof(jobs[job_count].command)-1);
        jobs[job_count].command[sizeof(jobs[job_count].command)-1] = '\0';
        jobs[job_count].active = 1;
        job_count++;
    }
return num;
}