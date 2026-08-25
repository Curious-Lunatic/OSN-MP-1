#include"../include/shell.h"
void searching(const char* dir_path, const char* target){
    DIR *dir = opendir(dir_path);
    if(!dir) return;
    struct dirent *entry;
    while((entry = readdir(dir)) != NULL ){
    if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
            continue;
        }
        char full_path[5000];
        snprintf(full_path, sizeof(full_path), "%s/%s", dir_path, entry->d_name);
        if (strcmp(entry->d_name, target) == 0) {
            if (access(full_path, X_OK) == 0) {
                printf("%s [Executable]\n", full_path);
            } else {
                printf("%s\n", full_path);
            }
        }
        struct stat statbuf;
        if (stat(full_path, &statbuf) == 0 && S_ISDIR(statbuf.st_mode)) {
            search_directory(full_path, target);
        }
    }
    closedir(dir);
}

void locating(char **args, int acount){
    if (acount != 1 ){
        printf("locate: invalid syntax\n");
        return;
    }
    char cwd[5000];
    if (getcwd(cwd, sizeof(cwd)) != NULL) {
        search_directory(cwd, args[0]);
}
}