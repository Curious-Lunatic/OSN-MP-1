#ifndef shell_h
#define shell_h
#include<dirent.h>
#include<fcntl.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#include<sys/socket.h>
#include<sys/select.h>
#include<sys/types.h>
#include<sys/msg.h>
#include<sysexits.h>
#include<sys/wait.h>
#include<sys/select.h>
#include<sys/stat.h>
#include<time.h>
#include<pwd.h>
#define maxinput 1024 // given 
void printing(const char* shome);
void printing(const char *shome);
int hopping(char **args, int acount, const char *shome);
void revealing(char **args, int acount, const char *shome, const char *previous);
void peeking(char **args, int acount);
void locating(char **args, int acount);
typedef struct{
    char *argv[100];
    int argcount;
    char *in_files[20];
    int incount;
    struct{
        char *file;
        int append;
    } out_files[20];
    int outcount;
} commands;
char* resolving(const char *name, const char **stripped);
#endif
