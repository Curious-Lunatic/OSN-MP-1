#include "../include/shell.h"
int cmp_names(const void *a, const void *b) {
    return strcmp(*(const char **)a, *(const char **)b);
}
void reveal_dir(const char *path, const char *prefix, int hidden, int rec) {
    DIR *dir = opendir(path);
    if (!dir) { 
        printf("reveal: no such directory\n"); 
        return; 
    }
    struct dirent *entry;
    char *entries[5000];
    int count = 0;
    
    while ((entry = readdir(dir)) != NULL && count < 5000) {
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) continue;
        if (!hidden && entry->d_name[0] == '.') continue;
        entries[count] = strdup(entry->d_name);
        count++;
    }
    closedir(dir);
    
    qsort(entries, count, sizeof(char *), cmp_names);
    
    for (int i = 0; i < count; i++) {
        char full_path[5100], display_name[5100], quoted_name[5110];
        snprintf(full_path, sizeof(full_path), "%s/%s", path, entries[i]);
        snprintf(display_name, sizeof(display_name), "%s%s", prefix, entries[i]);
        
        if (strchr(display_name, ' ') != NULL) {
            snprintf(quoted_name, sizeof(quoted_name), "'%s'", display_name);
        } else {
            strcpy(quoted_name, display_name);
        }

        struct stat statbuf;
        int is_dir = (lstat(full_path, &statbuf) == 0 && S_ISDIR(statbuf.st_mode));
        
        if (is_dir && rec) {
            printf("%s/\n", quoted_name);
        } else {
            printf("%s\n", quoted_name);
        }
        
        if (is_dir && rec) {
            char new_prefix[5110];
            snprintf(new_prefix, sizeof(new_prefix), "%s/", display_name);
            reveal_dir(full_path, new_prefix, hidden, rec);
        }
    }
    for (int i = 0; i < count; i++) free(entries[i]);
}
void revealing(char **args, int acount, const char *shome, const char *previous) {
    int show_hidden = 0, recursive = 0;
    char target[5000] = ".";
    int target_set = 0;
    
    for (int i = 0; i < acount; i++) {
        if (args[i][0] == '-' && strlen(args[i]) > 1 && !target_set) {
            for (size_t j = 1; j < strlen(args[i]); j++) {
                if (args[i][j] == 'a') show_hidden = 1;
                else if (args[i][j] == 't') recursive = 1;
                else {
                    printf("reveal: invalid syntax\n");
                    return;
                }
            }
        } else {
            if (target_set) {
                printf("reveal: invalid syntax\n");
                return;
            }
            if (strcmp(args[i], "~") == 0) strcpy(target, shome);
            else if (strcmp(args[i], "-") == 0) {
                if (strlen(previous) == 0) {
                    printf("reveal: no such directory\n");
                    return;
                }
                strcpy(target, previous);
            }
            else strcpy(target, args[i]);
            target_set = 1;
        }
    }
    reveal_dir(target, "", show_hidden, recursive);
}