#include "../include/shell.h" // get our shit
#include "../include/lexer.h"
#define maxtok 256
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
    token tokens[maxtok];
    int token_count=0;
        if(!maketoken(input, tokens, &token_count)){
            continue; 
        }
        if(!parsing(tokens, token_count)){
            continue;   // parser already printed "cshell: invalid syntax"
        }
        for(int i=0; i<token_count; i++){
            if(tokens[i].type == token_word)
                printf("WORD(%s) ", tokens[i].value);
            else
                printf("OP(%d) ", tokens[i].type);
        }
        printf("\n");
    }
return 0;
}