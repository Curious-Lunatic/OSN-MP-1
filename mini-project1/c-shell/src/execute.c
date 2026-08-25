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

int is_builtin(const char* cmd){
    if(!cmd){
        return 0;
    }
    return(strcmp(cmd,"hop")==0 || strcmp(cmd,"reveal")==0 ||
    strcmp(cmd,"peek")==0 || strcmp(cmd,"locate")==0 || strcmp(cmd,"exit"));
}

void run_builtin(char **args, int acount, const char *shome){
    if(strcmp(args[0], "hop") == 0) hopping(args + 1, acount - 1, shome);
    else if(strcmp(args[0], "reveal") == 0) revealing(args + 1, acount - 1, shome, previous);
    else if(strcmp(args[0], "peek") == 0) peeking(args + 1, acount - 1);
    else if(strcmp(args[0], "locate") == 0) locating(args + 1, acount - 1);
    else if(strcmp(args[0], "exit") == 0) exit(0);
}

void executing(token *tokens, int tok_count, const char *shome){
    int end_idx = tok_count;
    for(int i = 0; i < tok_count; i++){
        if(tokens[i].type == token_semi || tokens[i].type == token_amp){
            end_idx = i;
            break; 
        }
    }
    commands pipeline[100];
    memset(pipeline, 0, sizeof(pipeline));
    int stage_count = 0;
    commands *cur = &pipeline[0];
    for(int i = 0; i < end_idx; i++){
        if(tokens[i].type == token_word){
            cur->argv[cur->argcount++] = tokens[i].value;
        } else if(tokens[i].type == token_lt && i + 1 < end_idx){
            cur->in_files[cur->incount++] = tokens[++i].value;
        } else if(tokens[i].type == token_gt && i + 1 < end_idx){
            cur->out_files[cur->outcount].file = tokens[++i].value;
            cur->out_files[cur->outcount++].append = 0;
        } else if(tokens[i].type == token_gtgt && i + 1 < end_idx){
            cur->out_files[cur->outcount].file = tokens[++i].value;
            cur->out_files[cur->outcount++].append = 1;
        } else if(tokens[i].type == token_pipe){
            cur->argv[cur->argcount] = NULL;
            stage_count++;
            cur = &pipeline[stage_count];
        }
    }
    cur->argv[cur->argcount] = NULL;
    stage_count++;

    if(stage_count == 1 && cur->argcount > 0){
        if(strcmp(cur->argv[0], "hop") == 0 || strcmp(cur->argv[0], "exit") == 0){
            run_builtin(cur->argv, cur->argcount, shome);
            return;
        }
    }

    int pipes[100][2];
    for(int i = 0; i < stage_count - 1; i++) pipe(pipes[i]);

    pid_t pids[100];
    for(int i = 0; i < stage_count; i++){
        if(pipeline[i].argcount == 0) continue;
        
        pids[i] = fork();
        if(pids[i] == 0){
            if(i > 0){
                dup2(pipes[i - 1][0], STDIN_FILENO);
            } else if(pipeline[i].incount > 0){
                int in_fd = setup_input(&pipeline[i]);
                if(in_fd < 0) exit(1);
                dup2(in_fd, STDIN_FILENO);
                close(in_fd);
            }

            if(i < stage_count - 1){
                dup2(pipes[i][1], STDOUT_FILENO);
            } else if(pipeline[i].outcount > 0){
                int out_fd = setup_output(&pipeline[i]);
                if(out_fd < 0) exit(1);
                dup2(out_fd, STDOUT_FILENO);
                close(out_fd);
            }

            for(int j = 0; j < stage_count - 1; j++){
                close(pipes[j][0]);
                close(pipes[j][1]);
            }

            if(is_builtin(pipeline[i].argv[0])){
                run_builtin(pipeline[i].argv, pipeline[i].argcount
                    , shome);
                exit(0);
            } else {
                char *path = resolve_executable(pipeline[i].argv[0]);
                if(!path){
                    char *err_name = pipeline[i].argv[0];
                    if(err_name[0] == '%') err_name++;
                    printf("cshell: command not found (%s)\n", err_name);
                    exit(127);
                }
                execv(path, pipeline[i].argv);
                exit(127);
            }
        }
    }

    for(int i = 0; i < stage_count - 1; i++){
        close(pipes[i][0]);
        close(pipes[i][1]);
    }

    for(int i = 0; i < stage_count; i++){
        if(pipeline[i].argcount > 0) waitpid(pids[i], NULL, 0);
    }
}