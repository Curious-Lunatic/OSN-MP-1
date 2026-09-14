#include"../include/shell.h"
#include"../include/lexer.h"

static const char* type_from_mode(mode_t mode){
    if(S_ISREG(mode)) return "REG";
    if(S_ISDIR(mode)) return "DIR";
    if(S_ISCHR(mode)) return "CHR";
    if(S_ISBLK(mode)) return "BLK";
    if(S_ISFIFO(mode)) return "FIFO";
    if(S_ISLNK(mode)) return "LNK";
    if(S_ISSOCK(mode)) return "SOCK";
    return "UNKNOWN";
}

static const char* type_of_path(const char *path){
    struct stat sb;
    if(stat(path, &sb) != 0) return "UNKNOWN";
    return type_from_mode(sb.st_mode);
}

static int cmp_fd_names(const void *a, const void *b){
    int na = atoi(*(const char **)a);
    int nb = atoi(*(const char **)b);
    return na - nb;
}

void spying(char **args, int acount){
    if(acount > 1){
        printf("spy: invalid syntax\n");
        return;
    }

    pid_t pid;
    if(acount == 1){
        char *end;
        long v = strtol(args[0], &end, 10);
        if(*end != '\0' || v < 0){
            printf("spy: no such process\n");
            return;
        }
        pid = (pid_t)v;
    } else {
        pid = getpid();
    }
    char procdir[64];
    snprintf(procdir, sizeof(procdir), "/proc/%d", (int)pid);
    if(access(procdir, F_OK) != 0){
        printf("spy: no such process\n");
        return;
    }

     if(kill(pid, 0) == -1 && errno == EPERM){
        printf("spy: permission denied\n");
        return;
    }
    char fddir[80];
    snprintf(fddir, sizeof(fddir), "/proc/%d/fd", (int)pid);
    DIR *test_d = opendir(fddir);
    if(!test_d && errno == EACCES){
        printf("spy: permission denied\n");
        return;
    }
    
    if(test_d) closedir(test_d);
    printf("PID\tFD\tTYPE\tPATH\n");

    char link[128], buf[4096];
    ssize_t n;
    snprintf(link, sizeof(link), "/proc/%d/cwd", (int)pid);
    n = readlink(link, buf, sizeof(buf) - 1);
    if(n > 0){
        buf[n] = '\0';
        printf("%d\tcwd\tDIR\t%s\n", (int)pid, buf);
    }

    // for the  executable text
    snprintf(link, sizeof(link), "/proc/%d/exe", (int)pid);
    n = readlink(link, buf, sizeof(buf) - 1);
    if(n > 0){
        buf[n] = '\0';
        printf("%d\ttxt\t%s\t%s\n", (int)pid, type_of_path(buf), buf);
    }

    // for unique mapped regular files from pid/maps
    snprintf(link, sizeof(link), "/proc/%d/maps", (int)pid);
    FILE *maps = fopen(link, "r");
    if(maps){
        char seen[256][4096];
        int seen_count = 0;
        char line[4200];
        while(fgets(line, sizeof(line), maps)){
            char *path = strrchr(line, ' ');
            if(!path) continue;
            path++;
            path[strcspn(path, "\n")] = '\0';
            if(path[0] != '/') continue;

            int dup = 0;
            for(int i = 0; i < seen_count; i++){
                if(strcmp(seen[i], path) == 0){ dup = 1; break; }
            }
            if(dup) continue;
            if(seen_count < 256){
                strncpy(seen[seen_count], path, 4095);
                seen[seen_count][4095] = '\0';
                seen_count++;
            }
            printf("%d\tmem\t%s\t%s\n", (int)pid, type_of_path(path), path);
        }
        fclose(maps);
    }
    // numeric fds
snprintf(link, sizeof(link), "/proc/%d/fd", (int)pid);
    DIR *d = opendir(link);
    if(d){
        char *names[4096];
        int count = 0;
        struct dirent *entry;
        while((entry = readdir(d)) != NULL && count < 4096){
            if(strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) continue;
            names[count] = strdup(entry->d_name);
            count++;
        }
        closedir(d);
        qsort(names, count, sizeof(char *), cmp_fd_names);

        for(int i = 0; i < count; i++){
            char fdlink[160];
            snprintf(fdlink, sizeof(fdlink), "/proc/%d/fd/%s", (int)pid, names[i]);
            n = readlink(fdlink, buf, sizeof(buf) - 1);
            if(n <= 0){ free(names[i]); continue; }
            buf[n] = '\0';

            struct stat sb;
            const char *type = (stat(fdlink, &sb) == 0) ? type_from_mode(sb.st_mode) : "UNKNOWN";
            if(strcmp(type, "SOCK") == 0){ free(names[i]); continue; }

            printf("%d\t%s\t%s\t%s\n", (int)pid, names[i], type, buf);
            free(names[i]);
        }
    }
}

    