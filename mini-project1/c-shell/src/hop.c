#include "../include/shell.h"
char previous[5000] ="";
void freq_update(const char* shome, const char *path){
    char file_path[5000];
    snprintf(file_path, sizeof(file_path), "%s/.frequency", shome);
    FILE *f = fopen(file_path,"r");
    char lines[1024][5000];
    long freqs[1024];
    long times[1024];
    int count=0, found=0;
    if (f) {
        while (fscanf(f, "%4999s %ld %ld", lines[count], &freqs[count], &times[count]) == 3) {
            if (strcmp(lines[count], path) == 0) {
                freqs[count]++;
                times[count] = (long)time(NULL);
                found = 1;
            }
            count++;
        }
        fclose(f);
    }
    if (!found && count < 1024) {
        strcpy(lines[count], path);
        freqs[count] = 1;
        times[count] = (long)time(NULL);
        count++;
    }
    f = fopen(file_path, "w");
    if (f) {
        for (int i = 0; i < count; i++) {
            fprintf(f, "%s %ld %ld\n", lines[i], freqs[i], times[i]);
        }
        fclose(f);
    }
}
char* get_frecency(const char* shome, const char *target){
    char file_path[5000];
    snprintf(file_path, sizeof(file_path), "%s/.frecency", shome);
    FILE *f = fopen(file_path, "r");
    if (!f) return NULL;
    static char best_path[5000];
    best_path[0] = '\0';
    int best_freq = -1;
    long best_time = -1;
    char path[5000];
    int freq;
    long t;
    while (fscanf(f, "%4999s %d %ld", path, &freq, &t) == 3) {
        if (strstr(path, target) != NULL) {
            struct stat statbuf;
            if (stat(path, &statbuf) == 0 && S_ISDIR(statbuf.st_mode)) {
                if (freq > best_freq || (freq == best_freq && t > best_time)) {
                    best_freq = freq;
                    best_time = t;
                    strcpy(best_path, path);
                }
            }
        }
    }
    fclose(f);
    if (best_freq != -1) return best_path;
    return NULL;
}
int hopping(char **args, int acount, const char *shome){
    char cwd[5000];
    char target[4096];
    if(acount==0){
        args = (char*[]){"~"};
        acount=1;
    }
    for(int i=0; i<acount; i++){
        getcwd(cwd,sizeof(cwd));
        if (strcmp(args[i],"~")==0){
            strcpy(target, shome);
        }
        else if (strcmp(args[i], "-")==0){
            if(strlen(previous)==0) {
                printf("hop: no such directory\n");
                continue;
        }
        strcpy(target, previous);
    }
    else if (strcmp(args[i], ".") == 0){
                continue;
    }
        else{
            strcpy(target, args[i]);
            struct stat statbuffer;
            if (stat(target, &statbuffer) != 0 || !S_ISDIR(statbuffer.st_mode)) {
                char *frec_path = get_frecency(shome, args[i]);
                if (frec_path != NULL) {
                    strcpy(target, frec_path);
                } else {
                    printf("hop: no such directory\n");
                    continue;
                }
            }
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