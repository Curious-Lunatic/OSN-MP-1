#include"../include/shell.h"
void check_dir(const char* dir_path, const char* target, int* found){
    char full_path[5000];
    snprintf(full_path, sizeof(full_path), "%s/%s", dir_path, target);
    struct stat statbuf;
    if (stat(full_path, &statbuf) == 0 && S_ISREG(statbuf.st_mode) && access(full_path, X_OK) == 0) {
        printf("%s\n", full_path);
        *found = 1;
    }
}
void locating(char **args, int acount){
    if (acount == 0){
        printf("locate: invalid syntax\n");
        return;
    }
    char cwd[5000];
    if (getcwd(cwd, sizeof(cwd)) == NULL) return;
    char *path_env = getenv("PATH");
    char *path_copy_master;
    if(path_env){
        path_copy_master = strdup(path_env);
    } else {
        path_copy_master = strdup("");
    }
    for(int i = 0; i < acount; i++){
        int found = 0;
        check_dir(cwd, args[i], &found);
        char *path_copy = strdup(path_copy_master);
        char *dir = strtok(path_copy, ":");
        while(dir != NULL){
            check_dir(dir, args[i], &found);
            dir = strtok(NULL, ":");
        }
        free(path_copy);
        if(!found){
            printf("locate: command not found (%s)\n", args[i]);
        }
    }
    free(path_copy_master);
}