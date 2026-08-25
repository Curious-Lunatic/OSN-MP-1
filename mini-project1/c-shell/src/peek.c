#include"../include/shell.h"
void peeking(char **args, int acount){
    int nflag=0;
    int rflag=0;
    char target[5000] = "";
    int target_set = 0;
    for(int i=0; i<acount; i++){
        if(args[i][0]=='-' && strlen(args[i])>1 && !target_set){
            for(size_t j = 1; j<strlen(args[i]); j++){
                if(args[i][j]=='n') nflag=1;
                else if (args[i][j]=='r') rflag=1;
                else{
                    printf("peek: invalid syntax\n");
                    return;
                }
        }
            }
        else{
            if(target_set){
                printf("peek: invalid syntax\n");
                return;
            }
        strcpy(target, args[i]);
        target_set = 1;
        }
    }
    int fd = STDIN_FILENO;
    if (target_set && strcmp(target, "-") != 0) {
        fd = open(target, O_RDONLY);
        if (fd < 0) {
            perror("peek");
            return;
        }
    }
    char buf[1024];
    ssize_t bytes;
    int line_num = 1;
    int at_start = 1;
    if (!rflag) {
        while ((bytes = read(fd, buf, sizeof(buf))) > 0) {
            for (ssize_t i = 0; i < bytes; i++) {
                if (at_start && nflag) {
                    if (buf[i] != '\n') {
                        printf("%d ", line_num++);
                    }
                }
                putchar(buf[i]);
                at_start = (buf[i] == '\n');
            }
        }
    } 
    else if (fd != STDIN_FILENO) {
        off_t pos = lseek(fd, 0, SEEK_END);
        while (pos > 0) {
            ssize_t chunk = (pos < (off_t)sizeof(buf)) ? pos : (ssize_t)sizeof(buf);
            pos -= chunk;
            lseek(fd, pos, SEEK_SET);
            read(fd, buf, chunk);
            // printing it backwards
            for (ssize_t i = chunk-1; i>=0; i--) {
                putchar(buf[i]);
            }
        }
    }
    if (fd != STDIN_FILENO) {
        close(fd);
    }
}