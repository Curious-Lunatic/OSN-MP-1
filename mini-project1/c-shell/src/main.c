#include "../include/shell.h" // get our shit
int main(){
    char shome[5000];
    char input[maxinput]; // given 
    if(getcwd(shome, sizeof(shome)) == NULL){
        return 1;
    }
    int running=1;
    while(running){
        printing(shome);
        // fgets > scanf bcs does not break on space
        if (fgets(input, sizeof(input), stdin) == NULL){
            // failed to read anything so print a new line and break the loop to exit
            printf("\n");
            break;
        }
        input[strcspn(input, "\n")]='\0';
        // terminate the line by finding where \n was and continue looping
        if(strlen(input)==0){
            continue;
        }
    }
return 0;
}