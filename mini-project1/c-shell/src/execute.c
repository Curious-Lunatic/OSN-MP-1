#include"../include/lexer.h"
#include"../include/shell.h"
extern char previous[5000];
int setup_in(commands *cmd ){
    for (int i=0; i<cmd->incount; i++){
        if(access(cmd->in_files[i],F_OK )!=0){
            printf("cshell: no such fil or directory\n");
            return -1;
        }
    }
    int pfd[2];
    pipe(pfd);
    if(fork()==0){
        close(pfd[0]);
        char buf[5000];
        for(int i=0; i<cmd->incount;i++){
            int fd = open(cmd->in_files[i],O_RDONLY);
            int a;
            while((a=read(fd,buf,sizeof(buf)))>0){
                wrtie(pfd[1], buf, a);
            }
            close(fd);
        }
    exit(0);
    }
close(pfd[1]);
return pfd[0];
}

int setup_out(commands *cmd){
    int pfd[2];
    pipe(pfd);
    if(fork() == 0){
        close(pfd[1]);
        int fds[20];
        for(int i=0; i<cmd->outcount; i++){
            int flags = O_WRONLY | O_CREAT | (cmd->out_files[i].append ? O_APPEND : O_TRUNC);
            fds[i] = open(cmd->out_files[i].file, flags, 0644);
            if(fds[i] < 0){
                printf("cshell: unable to create file for writing\n");
                exit(1);
            }
        }
        char buf[5000];
        int b;
        while((b = read(pfd[0], buf, sizeof(buf))) > 0){
            for(int i=0; i<cmd->outcount; i++) write(fds[i], buf, b);
        }
        for(int i=0; i<cmd->outcount; i++) close(fds[i]);
        exit(0);
    }
    close(pfd[0]);
    return pfd[1];
}