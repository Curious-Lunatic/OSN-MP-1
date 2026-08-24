#include"../include/shell.h"
#include"../include/lexer.h"
int parsing(token *tokens, int count){
    if(count==0)return 1;
    int state=0;
    for(int i=0; i<count; i++){
        tokentype t =tokens[i].type;
        if(state==0){
            if(t==token_word){
                state=1;
            }
            else{
                printf("cshell: invalid syntax\n");
                return 0;
            }
        }
        else if (state == 1){
            if(t==token_word){
                state=1;
            }
            else if(t == token_lt || t==token_gt || t==token_gtgt){
                state=2;
            }
            else if(t == token_pipe || t == token_semi){
                state=0;
            }
            else if (t==token_amp){
                state=3;
            }
        }
        else if (state==2){
            if(t==token_word){
                state=1;
            }
            else{
                printf("cshell: invalid syntax\n");
                return 0;
            }
        }
        else if (state==3){
            if(t==token_word){
                state=1;
            }
            else{
                printf("cshell: invalid syntax\n");
                return 0;
            }
        }
    }
    if (state==0){
                printf("cshell: invalid syntax\n");
                return 0; 
    }
    else if (state==2){
                printf("cshell: invalid syntax\n");
                return 0; 
    }
    else{
        return 1;
    }
}