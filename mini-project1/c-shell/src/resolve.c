#include"../include/lexer.h"
#include"../include/shell.h"

static int is_executable_file(const char *path){
    struct stat sb;
    if(stat(path, &sb) != 0) return 0;
    if(!S_ISREG(sb.st_mode)) return 0;
    return access(path, X_OK) == 0;
}

char* resolving(const char *name, const char **stripped){
    static char res[10100];
    int skipp = 0;
    const char *searchname = name;

    if(name[0] == '%'){
        searchname = name + 1;
        skipp = 1;
    }
    if(stripped){
        *stripped = searchname;
    }

    if(strchr(searchname, '/') != NULL){
        if(is_executable_file(searchname)){
            strcpy(res, searchname);
            return res;
        }
        return NULL;
    }

    if(!skipp){
        char cwd[5000];
        if(getcwd(cwd, sizeof(cwd)) != NULL){
            snprintf(res, sizeof(res), "%s/%s", cwd, searchname);
            if(is_executable_file(res)) return res;
        }
    }

    char *pather = getenv("PATH");
    if(pather){
        char *path_copy = strdup(pather);
        char *dir = strtok(path_copy, ":");
        while(dir != NULL){
            snprintf(res, sizeof(res), "%s/%s", dir, searchname);
            if(is_executable_file(res)){
                free(path_copy);
                return res;
            }
            dir = strtok(NULL, ":");
        }
        free(path_copy);
    }
    return NULL;
}