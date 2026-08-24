#include "../include/shell.h"
void printing(const char *shome){
    char cwd[5000];
    char hostname[500];
    const char* username;
    struct passwd *pwd = getpwuid(getuid());
    if(pwd){
        username = pwd->pw_name;
    }
    else{
        username = "unknown";
    }
    if(gethostname(hostname, sizeof(hostname))){
        strcpy(hostname,"unknown");
    }
    if(getcwd(cwd,sizeof(cwd))==NULL){
        return;
    }
    size_t homelength = strlen(shome); // using an unsigned integar
    if(strncmp(cwd, shome, homelength) ==0 && (cwd[homelength]=='\0' || cwd[homelength] == '/')){
        printf("<%s@%s>:~%s ", username, hostname, cwd+homelength); // not a string dumbass
    }
    else{
      printf("<%s@%s:%s> ", username, hostname, cwd);
    }
    fflush(stdout);
}