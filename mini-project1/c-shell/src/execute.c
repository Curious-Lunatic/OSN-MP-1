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

static int is_shell_only_builtin(const char *cmd){
    return strcmp(cmd, "hop") == 0 || strcmp(cmd, "exit") == 0 ||
           strcmp(cmd, "activities") == 0 || strcmp(cmd, "resume") == 0 ||
           strcmp(cmd, "ping") == 0;
}

int is_builtin(const char *cmd){
    if(!cmd) return 0;
    return (strcmp(cmd, "hop") == 0 || strcmp(cmd, "reveal") == 0 ||
            strcmp(cmd, "peek") == 0 || strcmp(cmd, "locate") == 0 ||
            strcmp(cmd, "exit") == 0 || strcmp(cmd, "activities") == 0 ||
            strcmp(cmd, "resume") == 0 || strcmp(cmd, "ping") == 0);
}

void run_builtin(char **args, int acount, const char *shome){
    if(strcmp(args[0], "hop") == 0) hopping(args + 1, acount - 1, shome);
    else if(strcmp(args[0], "reveal") == 0) revealing(args + 1, acount - 1, shome, previous);
    else if(strcmp(args[0], "peek") == 0) peeking(args + 1, acount - 1);
    else if(strcmp(args[0], "locate") == 0) locating(args + 1, acount - 1);
    else if(strcmp(args[0], "exit") == 0) exit(0);
    else if(strcmp(args[0], "activities") == 0) activities();
    else if(strcmp(args[0], "resume") == 0) resuming(args + 1, acount - 1);
    else if(strcmp(args[0], "ping") == 0) pinging(args + 1, acount - 1);
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
    if(stage_count == 1 && pipeline[0].incount == 0 && pipeline[0].outcount == 0 &&
    is_shell_only_builtin(pipeline[0].argv[0])){{
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

typedef enum{
    TERM_SEMI, TERM_AMP, TERM_END
} terminator;

typedef struct{
    commands pipeline[100];
    int stage_count;
    terminator term;
} segment;

static int presolve(commands *pipeline, int stage_count, char resolved[][5000], const char* stripped[]){
    for (int i=0; i<stage_count; i++){
        if(pipeline[i].argcount == 0 ) continue;
        if(is_builtin(pipeline[i].argv[0])) continue;
        char* path = resolving(pipeline[i].argv[0], &stripped[i]);
        if (!path){
            printf("cshell: command not found (%s)\n", stripped[i]);
            return 0;            
        }
        strncpy(resolved[i], path, 4999);
        resolved[i][4999] = '\0';
    }
return 1;
}

static void build_command_string(commands *pipeline, int stage_count, char *out, size_t outsize){
    out[0] = '\0';
    for(int i = 0; i < stage_count; i++){
        if(i > 0) strncat(out, " | ", outsize - strlen(out) - 1);
        for(int a = 0; a < pipeline[i].argcount; a++){
            if(a > 0) strncat(out, " ", outsize - strlen(out) - 1);
            strncat(out, pipeline[i].argv[a], outsize - strlen(out) - 1);
        }
    }
}

static int run_foreground(commands *pipeline, int stage_count, const char *shome){
    char resolved[100][5000];
    const char *stripped[100];
    if(!presolve(pipeline, stage_count, resolved, stripped)) return 0;
    if(stage_count == 1 && pipeline[0].incount == 0 && pipeline[0].outcount == 0 &&
       (strcmp(pipeline[0].argv[0], "hop") == 0 || strcmp(pipeline[0].argv[0], "exit") == 0)){
        run_builtin(pipeline[0].argv, pipeline[0].argcount, shome);
        return 1;
    }
    int in_fd = build_input_tmp(&pipeline[0]);
    if(in_fd == -2) return 0;
    out_ctx octx;
    if(prepare_output(&pipeline[stage_count - 1], &octx) != 0){
        if(in_fd >= 0) close(in_fd);
        return 0;
    }
    int pipes[100][2];
    for(int i = 0; i < stage_count - 1; i++) pipe(pipes[i]);
    pid_t pids[100];
    pid_t group_pgid = 0;
    fg_running = 1;

    for(int i = 0; i < stage_count; i++){
        if(pipeline[i].argcount == 0) continue;
        pids[i] = fork();
        if(pids[i] == 0){
            setpgid(0, group_pgid);
            signal(SIGINT, SIG_DFL);
            signal(SIGTSTP, SIG_DFL);
            signal(SIGTTOU, SIG_DFL);

            if(i > 0) dup2(pipes[i - 1][0], STDIN_FILENO);
            else if(in_fd >= 0) dup2(in_fd, STDIN_FILENO);

            if(i < stage_count - 1) dup2(pipes[i][1], STDOUT_FILENO);
            else if(octx.tmp_fd >= 0) dup2(octx.tmp_fd, STDOUT_FILENO);

            for(int j = 0; j < stage_count - 1; j++){ close(pipes[j][0]); close(pipes[j][1]); }
            if(in_fd >= 0) close(in_fd);
            if(octx.tmp_fd >= 0) close(octx.tmp_fd);
            for(int j = 0; j < octx.real_count; j++) close(octx.real_fds[j]);

            if(is_builtin(pipeline[i].argv[0])){
                run_builtin(pipeline[i].argv, pipeline[i].argcount, shome);
                exit(0);
            } else {
                execv(resolved[i], pipeline[i].argv);
                fprintf(stderr, "cshell: exec failed for %s: %s\n",
                        pipeline[i].argv[0], strerror(errno));
                exit(127);
            }
        }
        setpgid(pids[i], group_pgid);
        if(i == 0) group_pgid = pids[i];
    }

    for(int i = 0; i < stage_count - 1; i++){ close(pipes[i][0]); close(pipes[i][1]); }
    if(in_fd >= 0) close(in_fd);

    // register the job before waiting, so it can be found or marked mid-wait 
    char *names[100];
    for(int i = 0; i < stage_count; i++) names[i] = pipeline[i].argv[0];
    char command[512];
    build_command_string(pipeline, stage_count, command, sizeof(command));
    int job_num = register_job(group_pgid, pids, names, stage_count, command, 0);
    jobb *j = find_job_by_number(job_num);

    tcsetpgrp(STDIN_FILENO, group_pgid);

    int remaining = stage_count;
    int stopped = 0;
    while(remaining > 0){
        int status;
        pid_t w = waitpid(-group_pgid, &status, WUNTRACED);
        if(w < 0){
            if(errno == EINTR) continue;
            break;
        }
        if(WIFSTOPPED(status)){
            if(j) j->state = job_stopped;
            printf("[%d] + Stopped\t%s\n", job_num, command);
            stopped = 1;
            break;
        } else if(WIFEXITED(status) || WIFSIGNALED(status)){
            remaining--;
        }
    }
    tcsetpgrp(STDIN_FILENO, shell_pgid);
    if(!stopped && j) j->active = 0; 
    fg_running = 0;
    flush_output(&octx);
    flush_pending_bg_msg();
    return 1;
}
   
static void run_background(commands *pipeline, int stage_count, const char *shome){
    char resolved[100][5000];
    const char *stripped[100];
    if(!presolve(pipeline, stage_count, resolved, stripped)) return;
    int in_fd = build_input_tmp(&pipeline[0]);
    if(in_fd == -2) return;
    out_ctx octx;
    if(prepare_output(&pipeline[stage_count - 1], &octx) != 0){
        if(in_fd >= 0) close(in_fd);
        return;
    }
    int pipes[100][2];
    for(int i = 0; i < stage_count - 1; i++) pipe(pipes[i]);
    int gate[2];
    pipe(gate);
    pid_t pids[100];
    pid_t group_pgid = 0;

    for(int i = 0; i < stage_count; i++){
        if(pipeline[i].argcount == 0) continue;
        pids[i] = fork();
        if(pids[i] == 0){
            setpgid(0, group_pgid);
            signal(SIGINT, SIG_DFL);
            signal(SIGTSTP, SIG_DFL);
            signal(SIGTTOU, SIG_DFL);

            if(i == 0){
                close(gate[1]);
                char tmp;
                read(gate[0], &tmp, 1);
                close(gate[0]);
                if(in_fd >= 0){
                    dup2(in_fd, STDIN_FILENO);
                } else {
                    int devnull = open("/dev/null", O_RDONLY);
                    if(devnull >= 0){ dup2(devnull, STDIN_FILENO); close(devnull); }
                }
            } else {
                dup2(pipes[i - 1][0], STDIN_FILENO);
            }

            if(i < stage_count - 1) dup2(pipes[i][1], STDOUT_FILENO);
            else if(octx.tmp_fd >= 0) dup2(octx.tmp_fd, STDOUT_FILENO);

            close(gate[0]); close(gate[1]);
            for(int j = 0; j < stage_count - 1; j++){ close(pipes[j][0]); close(pipes[j][1]); }
            if(in_fd >= 0) close(in_fd);
            if(octx.tmp_fd >= 0) close(octx.tmp_fd);
            for(int j = 0; j < octx.real_count; j++) close(octx.real_fds[j]);

            if(is_builtin(pipeline[i].argv[0])){
                run_builtin(pipeline[i].argv, pipeline[i].argcount, shome);
                exit(0);
            } else {
                execv(resolved[i], pipeline[i].argv);
                exit(127);
            }
        }
        setpgid(pids[i], group_pgid);
        if(i == 0) group_pgid = pids[i];
    }
    char *names[100];
    for(int i = 0; i < stage_count; i++) names[i] = pipeline[i].argv[0];
    char command[512];
    build_command_string(pipeline, stage_count, command, sizeof(command));
    int job_num = register_job(group_pgid, pids, names, stage_count, command, 1);
    printf("[%d] %d\n", job_num, (int)group_pgid);
    fflush(stdout);
    close(gate[0]);
    write(gate[1], "x", 1);
    close(gate[1]);
    for(int i = 0; i < stage_count - 1; i++){ close(pipes[i][0]); close(pipes[i][1]); }
    if(in_fd >= 0) close(in_fd);
    if(octx.tmp_fd >= 0) close(octx.tmp_fd);
    for(int i = 0; i < octx.real_count; i++) close(octx.real_fds[i]);
}

void run_cmd(token *tokens, int tok_count, const char *shome){
    int i = 0;
    while(i < tok_count){
        commands pipeline[100];
        memset(pipeline, 0, sizeof(pipeline));
        int stage_count = 0;
        commands *cur = &pipeline[0];

        while(i < tok_count && tokens[i].type != token_semi && tokens[i].type != token_amp){
            if(tokens[i].type == token_word){
                cur->argv[cur->argcount++] = tokens[i].value;
            } else if(tokens[i].type == token_lt && i + 1 < tok_count){
                cur->in_files[cur->incount++] = tokens[++i].value;
            } else if(tokens[i].type == token_gt && i + 1 < tok_count){
                cur->out_files[cur->outcount].file = tokens[++i].value;
                cur->out_files[cur->outcount++].append = 0;
            } else if(tokens[i].type == token_gtgt && i + 1 < tok_count){
                cur->out_files[cur->outcount].file = tokens[++i].value;
                cur->out_files[cur->outcount++].append = 1;
            } else if(tokens[i].type == token_pipe){
                cur->argv[cur->argcount] = NULL;
                stage_count++;
                cur = &pipeline[stage_count];
            }
            i++;
        }
        cur->argv[cur->argcount] = NULL;
        stage_count++;

        terminator term;
        if(i < tok_count){
            term = (tokens[i].type == token_semi) ? TERM_SEMI : TERM_AMP;
            i++; // skips ';'
        } else {
            term = TERM_END;
        }
        if(stage_count == 0 || pipeline[0].argcount == 0){
            continue; // handles strays
        }
        if(term == TERM_AMP){
            run_background(pipeline, stage_count, shome);
        } else {
            if(!run_foreground(pipeline, stage_count, shome)) break; 
        }
    }
    flush_pending_bg_msg();
}

static volatile sig_atomic_t resume_timed_out = 0;
static void alarm_handler(int sig){ (void)sig; resume_timed_out = 1; }

void resuming(char **args, int acount){
        if(acount < 2 || args[0][0] != '%'){
        printf("resume: invalid syntax\n");
        return;
    }
    char *endptr;
    long jn = strtol(args[0] + 1, &endptr, 10);
    if(*endptr != '\0'){
        printf("resume: invalid syntax\n");
        return;
    }
    jobb *j = find_job_by_number((int)jn);
    if(!j){
        printf("resume: no such job\n");
        return;
    }

    int is_fg = strcmp(args[1], "fg") == 0;
    int is_bg = strcmp(args[1], "bg") == 0;
    if(!is_fg && !is_bg){
        printf("resume: invalid syntax\n");
        return;
    }

    int timeout = 0;
    if(is_fg && acount >= 4 && strcmp(args[2], "--timeout") == 0){
        char *e2;
        timeout = (int)strtol(args[3], &e2, 10);
        if(*e2 != '\0' || timeout <= 0){
            printf("resume: invalid syntax\n");
            return;
        }
    } else if(is_bg && acount > 2){
        printf("resume: invalid syntax\n");
        return;
    } else if(is_fg && acount > 2 && strcmp(args[2], "--timeout") != 0){
        printf("resume: invalid syntax\n");
        return;
    }
    kill(-j->pgid, SIGCONT);
    if(is_bg){
        j->state = job_running;
        printf("[%d] + Running\t%s\n", j->job_number, j->command);
        return;
    }
    printf("%s\n", j->command);
    tcsetpgrp(STDIN_FILENO, j->pgid);
    j->state = job_running;

    resume_timed_out = 0;
    if(timeout > 0){
        struct sigaction sa = {0};
        sa.sa_handler = alarm_handler;
        sigemptyset(&sa.sa_mask);
        sigaction(SIGALRM, &sa, NULL);
        alarm(timeout);
    }

    int remaining = j->nproc;
    while(remaining > 0 && !resume_timed_out){
        int status;
        pid_t w = waitpid(-j->pgid, &status, WUNTRACED);
        if(w < 0){
            if(errno == EINTR) continue;
            break;
        }
        if(WIFSTOPPED(status)){
            j->state = job_stopped;
            break;
        } else if(WIFEXITED(status) || WIFSIGNALED(status)){
            remaining--;
        }
    }

    if(timeout > 0){
        if(resume_timed_out){
            kill(-j->pgid, SIGTERM);
            printf("resume: job timed out\n");
            j->active = 0;
        } else {
            alarm(0);
        }
    } else if(remaining == 0){
        j->active = 0;
    }
    tcsetpgrp(STDIN_FILENO, shell_pgid);
}

void pinging(char **args, int acount){
    if (acount != 2){
        printf("ping: invalid syntax\n");
        return;
    }
    char *e;
    long sig_num = strtol(args[1], &e, 10);
    if(*e != '\0' || sig_num < 0){
        printf("ping: invalid syntax\n");
        return;
    }
    int real_sig = (int)(sig_num % 64);
    const char *target = args[0];
    if(target[0]=='%'){
        long jn = strtol(target + 1, &e, 10);
        if(*e != '\0'){
            printf("ping: no such process found\n");
            return;
        }
        jobb *j = find_job_by_number((int)jn);
        if(!j){
            printf("ping: no such process found\n");
            return;
        }
        kill(-j->pgid, real_sig);
    }
    else{
        long pid = strtol(target, &e, 10);
        if(*e != '\0' || !find_job_containing_pid((pid_t)pid)){
            printf("ping: no such process found\n");
            return;
        }
        kill((pid_t)pid, real_sig);
    }
    printf("Sent signal %s to %s\n", args[1], target);
}