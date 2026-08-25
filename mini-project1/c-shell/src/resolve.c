#include"../include/lexer.h"
#include"../include/shell.h"

char* resolving(const char *name){
    static char res[5000];
    if(strchr(name, '/') != NULL){
        if(access(name, X_OK) == 0){
            strcpy(res, name);
            return res;
        }
        return NULL;
    }
    int skipp=0;
    const char* searchname = name;
    if(name[0] == '%'){
        skipp = 1;
        searchname = name+1;
    }
    if(!skipp){
        char cwd[5000];
        if(getcwd(cwd, sizeof(cwd)) != NULL){
        snprintf(res, sizeof(res), "%s/%s", cwd, searchname);
        if(access(res, X_OK) == 0) return res;
        }
    }
    char *pather = getenv("PATH");
    if(pather){
        char *path_copy = strdup(pather);
        char *dir = strtok(path_copy, ":");
        while(dir!=NULL){
            snprintf(res, sizeof(res), "%s/%s", dir, searchname);
            if(access(res, X_OK) == 0){
                free(path_copy);
                return res;
            }
        dir = strtok(NULL, ":");
        }
    free(path_copy);
    }
return NULL;
}