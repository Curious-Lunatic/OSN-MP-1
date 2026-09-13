#include "../include/shell.h"
#include "../include/lexer.h"
#define maxtok 256
#define maxerinput 5000
extern char previous[5000];
static void sigint_handler(int sig){ (void)sig; }
static void sigtstp_handler(int sig){ (void)sig; }
int main() {
    shell_pgid = getpgrp();
    signal(SIGTTOU, SIG_IGN);
    struct sigaction sa_int = {0};
    sa_int.sa_handler = sigint_handler;
    sigemptyset(&sa_int.sa_mask);
    sa_int.sa_flags = SA_RESTART;
    sigaction(SIGINT, &sa_int, NULL);
    struct sigaction sa_tstp = {0};
    sa_tstp.sa_handler = sigtstp_handler;
    sigemptyset(&sa_tstp.sa_mask);
    sa_tstp.sa_flags = SA_RESTART;
    sigaction(SIGTSTP, &sa_tstp, NULL);
    install_sigchild();
    
    char shome[5000];
    char input[maxerinput];
    if (getcwd(shome, sizeof(shome)) == NULL) {
        return 1;
    }
    int running = 1;
    int eof_warned = 0;
    while (running) {
        printing(shome);
        if (fgets(input, sizeof(input), stdin) == NULL) {
            if (feof(stdin)) {
                int any_stopped = 0;
                for(int i = 0; i < job_count; i++)
                    if(jobs[i].active && jobs[i].state == job_stopped) any_stopped = 1;
                if(any_stopped && !eof_warned){
                    printf("\ncshell: there are stopped jobs\n");
                    eof_warned = 1;
                    clearerr(stdin);
                    continue;
                }
            }
            printf("\n");
            break;
        }
        eof_warned = 0;
        input[strcspn(input, "\n")] = '\0';
        if (strlen(input) == 0) continue;

        token tokens[maxtok];
        int token_count = 0;
        if (!maketoken(input, tokens, &token_count)) continue;
        if (!parsing(tokens, token_count)) continue;
        run_cmd(tokens, token_count, shome);
    }
    send_sighup_to_all_jobs();
    return 0;
}