#include "../include/shell.h"
#include "../include/lexer.h"
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
    reap_finished();
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

jobb jobs[maxjobs];
int job_count = 0;
int next_job = 1;
pid_t shell_pgid;

int register_job(pid_t pgid, pid_t *pids, char **names, int nproc, const char *command, int background){
    int num = next_job++;
    jobb *j = &jobs[job_count++];
    j->job_number = num;
    j->pgid = pgid;
    j->nproc = nproc;
    for(int i = 0; i < nproc; i++){
        j->pids[i] = pids[i];
        strncpy(j->names[i], names[i], 255);
        j->names[i][255] = '\0';
    }
    strncpy(j->command, command, 511);
    j->command[511] = '\0';
    j->state = job_running;
    j->background = background;
    j->active = 1;
    return num;
}

jobb* find_job_by_number(int num){
    for(int i = 0; i < job_count; i++)
        if(jobs[i].active && jobs[i].job_number == num) return &jobs[i];
    return NULL;
}

jobb* find_job_containing_pid(pid_t pid){
    for(int i = 0; i < job_count; i++)
        if(jobs[i].active)
            for(int p = 0; p < jobs[i].nproc; p++)
                if(jobs[i].pids[p] == pid) return &jobs[i];
    return NULL;
}

static void remove_pid_from_job(pid_t pid){
    jobb *j = find_job_containing_pid(pid);
    if(!j) return;
    for(int i = 0; i < j->nproc; i++){
        if(j->pids[i] == pid){
            j->pids[i] = j->pids[j->nproc - 1];
            strcpy(j->names[i], j->names[j->nproc - 1]);
            j->nproc--;
            break;
        }
    }
    if(j->nproc == 0) j->active = 0;
}

void reap_finished(void){
    int status;
    pid_t pid;
    while((pid = waitpid(-1, &status, WNOHANG)) > 0){
        if(WIFEXITED(status) || WIFSIGNALED(status)){
            jobb *j = find_job_containing_pid(pid);
            if(j){
                if(j->background) queue_or_print(j->names[0], pid, WIFEXITED(status));
                remove_pid_from_job(pid);
            }
        }
    }
}

void send_sighup_to_all_jobs(void){
    for(int i = 0; i < job_count; i++)
        if(jobs[i].active) kill(-jobs[i].pgid, SIGHUP);
}