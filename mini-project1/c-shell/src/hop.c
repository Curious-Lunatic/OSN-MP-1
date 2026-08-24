#include "../include/shell.h"
char previous[5000] ="";
int hopping(char **args, int acount, const char *shome){
    char cwd[5000];
    for(int i=0; i<acount; i++){
        char target[4096];
        getcwd(cwd,sizeof(cwd));
        if (strcmp(args[i],"~")==0){
            strcpy(target, shome);
        }
        else if (strcmp(args[i], "-")==0){
            if(strlen(previous)==0) continue;
        }
        else{
            strcpy(target, args[i]);
        }
        if (chdir(target)==0){
            strcpy(previous,cwd);
        }
        else{
            perror("hop");
            return 0;
        }
    }
return 1;
}