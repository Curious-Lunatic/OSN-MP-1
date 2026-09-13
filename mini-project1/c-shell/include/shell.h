#ifndef shell_h
#define shell_h
#include<dirent.h>
#include<fcntl.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#include<errno.h>
#include<sys/socket.h>
#include<sys/select.h>
#include<sys/types.h>
#include<sys/msg.h>
#include<sysexits.h>
#include<sys/wait.h>
#include<sys/select.h>
#include<sys/stat.h>
#include<signal.h>
#include<time.h>
#include<pwd.h>
#define maxinput 1024 // given 
#define maxjobs 256
#define maxjob_process 16
void printing(const char* shome);
void printing(const char *shome);
int hopping(char **args, int acount, const char *shome);
void revealing(char **args, int acount, const char *shome, const char *previous);
void peeking(char **args, int acount);
void locating(char **args, int acount);
typedef struct{
    char *argv[100];
    int argcount;
    char *in_files[20];
    int incount;
    struct{
        char *file;
        int append;
    } out_files[20];
    int outcount;
} commands;
char* resolving(const char *name, const char **stripped);
typedef enum{ job_running, job_stopped } jobstate;
typedef struct{
    int job_number;
    pid_t pgid;
    pid_t pids[maxjob_process];
    char names[maxjob_process][256];
    int nproc;
    char command[512];
    jobstate state;
    int background;
    int active;
} jobb;
extern jobb jobs[maxjobs];
extern int job_count;
extern int next_job;
extern volatile sig_atomic_t fg_running;
extern pid_t shell_pgid;
void install_sigchild (void);
void flush_pending_bg_msg(void);
int register_job(pid_t pgid, pid_t *pids, char **names, int nproc, const char *command, int background);
jobb* find_job_by_number(int num);
jobb* find_job_containing_pid(pid_t pid);
void reap_finished(void);
void send_sighup_to_all_jobs(void);
void activities(void);
void resuming(char **args, int acount);
void pinging(char **args, int acount);
#endif