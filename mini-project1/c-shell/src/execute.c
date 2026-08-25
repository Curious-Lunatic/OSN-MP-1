#include"../include/lexer.h"
#include"../include/shell.h"
extern char previous[5000];
static int build_input_tmp(commands *cmd){
    if(cmd->incount == 0) return -1;
    for(int i = 0; i < cmd->incount; i++){
        if(access(cmd->in_files[i], F_OK) != 0){
            printf("cshell: no such file or directory\n");
            return -2;
        }
    }
    char tmp[] = "/tmp/cshell_in_XXXXXX";
    int tfd = mkstemp(tmp);
    if(tfd < 0) return -2;
    unlink(tmp); 
    char buf[8192];
    for(int i = 0; i < cmd->incount; i++){
        int fd = open(cmd->in_files[i], O_RDONLY);
        if(fd < 0) continue; 
        ssize_t n;
        while((n = read(fd, buf, sizeof(buf))) > 0){
            write(tfd, buf, n);
        }
        close(fd);
    }
    lseek(tfd, 0, SEEK_SET);
    return tfd;
}

typedef struct {
    int tmp_fd;        
    int real_fds[20];
    int real_count;
} out_ctx;

static int prepare_output(commands *cmd, out_ctx *ctx){
    ctx->tmp_fd = -1;
    ctx->real_count = 0;
    if(cmd->outcount == 0) return 0;
    for(int i = 0; i < cmd->outcount; i++){
        int flags = O_WRONLY | O_CREAT | (cmd->out_files[i].append ? O_APPEND : O_TRUNC);
        int fd = open(cmd->out_files[i].file, flags, 0644);
        if(fd < 0){
            printf("cshell: unable to create file for writing\n");
            for(int j = 0; j < ctx->real_count; j++) close(ctx->real_fds[j]);
            ctx->real_count = 0;
            return -1;
        }
        ctx->real_fds[ctx->real_count++] = fd;
    }
    char tmp[] = "/tmp/cshell_out_XXXXXX";
    int tfd = mkstemp(tmp);
    if(tfd < 0){
        for(int j = 0; j < ctx->real_count; j++) close(ctx->real_fds[j]);
        ctx->real_count = 0;
        return -1;
    }
    unlink(tmp);
    ctx->tmp_fd = tfd;
    return 0;
}

static void flush_output(out_ctx *ctx){
    if(ctx->tmp_fd < 0) return;
    lseek(ctx->tmp_fd, 0, SEEK_SET);
    char buf[8192];
    ssize_t n;
    while((n = read(ctx->tmp_fd, buf, sizeof(buf))) > 0){
        for(int i = 0; i < ctx->real_count; i++){
            write(ctx->real_fds[i], buf, n);
        }
    }
    close(ctx->tmp_fd);
    for(int i = 0; i < ctx->real_count; i++) close(ctx->real_fds[i]);
}

int is_builtin(const char *cmd){
    if(!cmd) return 0;
    return (strcmp(cmd, "hop") == 0 || strcmp(cmd, "reveal") == 0 ||
            strcmp(cmd, "peek") == 0 || strcmp(cmd, "locate") == 0 ||
            strcmp(cmd, "exit") == 0);
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
    if(stage_count == 0 || pipeline[0].argcount == 0) return; /* empty input */
    if(stage_count == 1 && pipeline[0].argcount > 0 &&
       pipeline[0].incount == 0 && pipeline[0].outcount == 0){
        if(strcmp(pipeline[0].argv[0], "hop") == 0 || strcmp(pipeline[0].argv[0], "exit") == 0){
            run_builtin(pipeline[0].argv, pipeline[0].argcount, shome);
            return;
        }
    }

    int in_fd = build_input_tmp(&pipeline[0]);
    if(in_fd == -2) return; 

    out_ctx octx;
    if(prepare_output(&pipeline[stage_count - 1], &octx) != 0){
        if(in_fd >= 0) close(in_fd);
        return;
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
            } else if(in_fd >= 0){
                dup2(in_fd, STDIN_FILENO);
            }

            if(i < stage_count - 1){
                dup2(pipes[i][1], STDOUT_FILENO);
            } else if(octx.tmp_fd >= 0){
                dup2(octx.tmp_fd, STDOUT_FILENO);
            }

            for(int j = 0; j < stage_count - 1; j++){
                close(pipes[j][0]);
                close(pipes[j][1]);
            }
            if(in_fd >= 0) close(in_fd);
            if(octx.tmp_fd >= 0) close(octx.tmp_fd);
            for(int j = 0; j < octx.real_count; j++) close(octx.real_fds[j]);

            if(is_builtin(pipeline[i].argv[0])){
                run_builtin(pipeline[i].argv, pipeline[i].argcount, shome);
                exit(0);
            } else {
                const char *stripped;
                char *path = resolving(pipeline[i].argv[0], &stripped);
                if(!path){
                    printf("cshell: command not found (%s)\n", stripped);
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
    if(in_fd >= 0) close(in_fd);

    for(int i = 0; i < stage_count; i++){
        if(pipeline[i].argcount > 0) waitpid(pids[i], NULL, 0);
    }
    flush_output(&octx);
}