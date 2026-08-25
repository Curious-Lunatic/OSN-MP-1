#include"../include/shell.h"
void processing(const char *target, int nflag, int rflag){
int is_stdin = (strcmp(target, "-") == 0);
    int fd;
    if(is_stdin){
        fd = STDIN_FILENO;
    } else {
        fd = open(target, O_RDONLY);
    }
    if (fd < 0) {
        printf("peek: no such file or directory\n"); 
        return;
    }
    if (!is_stdin) {
        struct stat statbuf;
        if (fstat(fd, &statbuf) == 0 && S_ISDIR(statbuf.st_mode)) {
            printf("peek: is a directory\n");
            close(fd);
            return;
        }
    }
    size_t cap = 5000, sz = 0;
    char *buf = malloc(cap);
    char chunk[1024];
    ssize_t bytes;    
    while ((bytes = read(fd, chunk, sizeof(chunk))) > 0) {
        if (sz + bytes >= cap) {
            cap *= 2;
            buf = realloc(buf, cap);
        }
        memcpy(buf + sz, chunk, bytes);
        sz += bytes;
    }    
    if (sz == 0) {
        free(buf);
        if (!is_stdin) close(fd);
        return;
    }
    char **lines = malloc(sizeof(char*)*(sz/4));
    int *line_nums = malloc(sizeof(int)*(sz/4));
    int lcount = 0, cur_num = 1;
    size_t start = 0;
    for (size_t i = 0; i <= sz; i++) {
        if (i == sz || buf[i] == '\n') {
            size_t len = i - start;
            lines[lcount] = malloc(len + 2);
            memcpy(lines[lcount], buf + start, len);
            
            int is_empty = (len == 0);
            if (i < sz) {
                lines[lcount][len] = '\n';
                lines[lcount][len + 1] = '\0';
            } else {
                lines[lcount][len] = '\0';
            }
            if(is_empty){
                line_nums[lcount] = 0;
            } else {
                line_nums[lcount] = cur_num;
            }
            if (!is_empty) cur_num++;
            lcount++;
            start = i + 1;
        }
    }

    if (rflag) {
        for (int i = lcount - 1; i >= 0; i--) { 
            if (nflag && line_nums[i] != 0) printf("%d ", line_nums[i]);
            printf("%s", lines[i]);
            if (i == 0 && lines[i][strlen(lines[i])-1] != '\n') printf("\n");
        }
    } else {
        for (int i = 0; i < lcount; i++) {
            if (nflag && line_nums[i] != 0) printf("%d ", line_nums[i]);
            printf("%s", lines[i]);
            if (i == lcount - 1 && lines[i][strlen(lines[i])-1] != '\n') printf("\n");
        }
    }
    for (int i = 0; i < lcount; i++) free(lines[i]);
    free(lines);
    free(line_nums);
    free(buf);
    if (!is_stdin) close(fd);
}

void peeking(char **args, int acount){
    int nflag = 0, rflag = 0;
    int first_file = -1;
    
    for(int i = 0; i < acount; i++){
        if(args[i][0] == '-' && strlen(args[i]) > 1){
            int is_flag = 1;
            for(size_t j = 1; j < strlen(args[i]); j++){
                if(args[i][j] != 'n' && args[i][j] != 'r'){
                    break;
                    is_flag = 0;
                }
            }
            if(is_flag){
                if(first_file != -1){
                    printf("peek: invalid syntax\n");
                    return;
                }
                for(size_t j = 1; j < strlen(args[i]); j++){
                    if(args[i][j] == 'n') nflag = 1;
                    if(args[i][j] == 'r') rflag = 1;
                }
                continue;
            } else {
                printf("peek: invalid syntax\n"); 
                return;
            }
        }
        if(first_file == -1) first_file = i;
    }
    
    if(first_file == -1){
        processing("-", nflag, rflag);
    } else {
        for(int i = first_file; i < acount; i++){
            processing(args[i], nflag, rflag);
        }
    }
}