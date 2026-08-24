#include "../include/shell.h"
void printing(const char *shome){
    char cwd[5000];
    char hostname[500];
    const char* username;
    struct passwd *pwd = getpwuid(getuid());
    if(pwd){
        username = pwd->pw_name; // get username
    }
    else{
        username = "unknown"; // doesn't have so put an alias
    }
    if(gethostname(hostname, sizeof(hostname))){
        strcpy(hostname,"unknown"); // get the system's hostname [diff than the username as this was given to the system in the start]
    }
    if(getcwd(cwd,sizeof(cwd))==NULL){
        return;
    }
    size_t homelength = strlen(shome); // using an unsigned integar [typo] to find the size oof the shell's directoryu
    if(strncmp(cwd, shome, homelength) ==0 && (cwd[homelength]=='\0' || cwd[homelength] == '/')){
        printf("<%s@%s>:~%s ", username, hostname, cwd+homelength); // not a string dumbass [ai ts ;-;]
    }
    else{
      printf("<%s@%s:%s> ", username, hostname, cwd);
    }
    fflush(stdout); // flush the output
}