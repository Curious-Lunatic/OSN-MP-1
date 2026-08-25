#include"../include/shell.h"
typedef struct{
    char *text;
    int number;
}pline;
static void processing(const char *target, int nflag, int rflag, int* next){
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
        if (sz + (size_t)bytes >= cap) {
            while (sz + (size_t)bytes >= cap) cap *= 2;
            buf = realloc(buf, cap);
        }
        memcpy(buf + sz, chunk, bytes);
        sz += bytes;
    }
    if (!is_stdin) close(fd);
    if (sz == 0) {
        free(buf);
        if (!is_stdin) close(fd);
        return;
    }
    int has_trailing_nl = (buf[sz - 1] == '\n');
    pline *lines = malloc(sizeof(pline) * (sz + 1));
    int lcount = 0;
    size_t start = 0;
    for (size_t i = 0; i < sz; i++) {
        if (buf[i] == '\n') {
            size_t len = i - start;
            lines[lcount].text = malloc(len + 1);
            memcpy(lines[lcount].text, buf + start, len);
            lines[lcount].text[len] = '\0';
            lines[lcount].number = (len == 0) ? 0 : (*next)++;
            lcount++;
            start = i + 1;
        }
    }
    if (start < sz) { 
        size_t len = sz - start;
        lines[lcount].text = malloc(len + 1);
        memcpy(lines[lcount].text, buf + start, len);
        lines[lcount].text[len] = '\0';
        lines[lcount].number = (len == 0) ? 0 : (*next)++;
        lcount++;
    }
    free(buf);
    if (!rflag) {
        for (int i = 0; i < lcount; i++) {
            if (nflag && lines[i].number != 0) printf("%d ", lines[i].number);
            printf("%s", lines[i].text);
            int is_last_output_line = (i == lcount - 1);
            if (!is_last_output_line || has_trailing_nl) printf("\n");
        }
    } else {
        for (int i = lcount - 1; i >= 0; i--) {
            if (nflag && lines[i].number != 0) printf("%d ", lines[i].number);
            printf("%s", lines[i].text);
            int is_last_output_line = (i == 0);
            if (!is_last_output_line || has_trailing_nl) printf("\n");
        }
    } 
    for (int i = 0; i < lcount; i++) free(lines[i].text);
    free(lines);
}

void peeking(char **args, int acount){
    int nflag = 0, rflag = 0;
    int first_file = -1;
 
    for (int i = 0; i < acount; i++) {
        if (args[i][0] == '-' && strlen(args[i]) > 1) {
            int is_flag = 1;
            for (size_t j = 1; j < strlen(args[i]); j++) {
                if (args[i][j] != 'n' && args[i][j] != 'r') {
                    is_flag = 0;
                    break;
                }
            }
            if (!is_flag) {
                printf("peek: invalid syntax\n");
                return;
            }
            if (first_file != -1) {
                printf("peek: invalid syntax\n");
                return;
            }
            for (size_t j = 1; j < strlen(args[i]); j++) {
                if (args[i][j] == 'n') nflag = 1;
                if (args[i][j] == 'r') rflag = 1;
            }
            continue;
        }
        if (first_file == -1) first_file = i;
    }
    int next_num = 1; 
    if (first_file == -1) {
        processing("-", nflag, rflag, &next_num);
    } else {
        for (int i = first_file; i < acount; i++) {
            processing(args[i], nflag, rflag, &next_num);
        }
    }
}