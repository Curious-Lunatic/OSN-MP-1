#include "../include/shell.h"
int main(){
    char shome[5000];
    if(getcwd(shome, sizeof(shome)) == NULL){
        return 1;
    }
    printing(shome);
    printf("\n");
return 0;
}