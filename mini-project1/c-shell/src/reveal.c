#include "include/shell.h"
void revealing(char *path, int hidden){
    DIR *directory = opendir(path);
    if(!directory){
        perror("reveal");
        return;
    }
    struct dirent *entry;
    while((entry = readdir(directory))!=NULL){
    if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0){
            continue;
        }
    if (!hidden && entry->d_name[0] == '.'){
            continue;
        }
    printf("%s\n", entry->d_name);
    }
closedir(directory);
}   