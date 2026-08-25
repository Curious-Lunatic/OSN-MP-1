    #include "../include/shell.h"
    int cmp_names(const void *a, const void *b) {
        return strcmp(*(const char **)a, *(const char **)b);
    }
    void reveal_dir(const char *path, int hidden, int rec) {
        DIR *dir = opendir(path);
        if (!dir) {
            printf("reveal: no such directory\n");
            return;
        }
        struct dirent *entry;
        char *entries[5000];
        int count = 0;
        while ((entry = readdir(dir)) != NULL && count < 5000) {
            entries[count] = malloc(strlen(entry->d_name) + 1);
            strcpy(entries[count], entry->d_name);
            count++;
        }
        closedir(dir);
        qsort(entries, count, sizeof(char *), cmp_names);
        if (rec) {
            printf("%s:\n", path);
        }
        for (int i = 0; i < count; i++) {
            if (strcmp(entries[i], ".") == 0 || strcmp(entries[i], "..") == 0) {
                continue;
            }
            if (!hidden && entries[i][0] == '.') {
                continue;
            }
            printf("%s\n", entries[i]);
        }
        if (rec) {
            for (int i = 0; i < count; i++) {
                if (strcmp(entries[i], ".") == 0 || strcmp(entries[i], "..") == 0 || (!hidden && entries[i][0] == '.')) {
                    continue;
                }

                char full_path[4096];
                snprintf(full_path, sizeof(full_path), "%s/%s", path, entries[i]);

                struct stat statbuf;
                if (stat(full_path, &statbuf) == 0 && S_ISDIR(statbuf.st_mode)) {
                    printf("\n");
                    reveal_dir(full_path, hidden, rec);
                }
            }
        }
        for (int i = 0; i < count; i++) {
            free(entries[i]);
        }
    }

    void revealing(char **args, int acount, const char *shome, const char *previous) {
        int show_hidden = 0, recursive = 0;
        char target[5000] = ".";
        int target_set = 0;
        for (int i=0; i<acount; i++) {
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
        reveal_dir(target, show_hidden, recursive);
    }