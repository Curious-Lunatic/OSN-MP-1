#include "../include/shell.h" // get our shit
#include "../include/lexer.h" // get our other shit
int maketoken(char *input, token *tokens, int *tok_count){
        *tok_count = 0; // for the lexar
        int state = 0; // for the grammer
        char word[1024]; // max given
        int index = 0;
        int content=0; // to see no empty things go 
    for(int i=0; input[i]!='\0'; i++){
        char c = input[i]; // go char by char
        if (state==0){
            if (c=='\\'){
                if(input[i+1]=='\0'){
                    printf("cshell: invalid syntax\n"); // given if there is an invalid command
                    return 0;
                }
            i++;
            word[index++] = input[i];
            }
        else if(c=='\'') {    
        state = 1;
        content=1;
        }
        else if(c=='"'){
        state = 1;
        content=1;        
        }
        else if (c=='\n' || c=='\t' || c==' ' || c=='\r'){
            if(content){
                word[index] = '\0';
                tokens[*tok_count].type = token_word;
                strcpy(tokens[*tok_count].value, word);
                (*tok_count)++;
                index=0;
            }
        }
        else if (c=='|' || c=='&' || c==';' || c=='<' || c=='>'){
            if(content){
                word[index] = '\0';
                tokens[*tok_count].type = token_word;
                strcpy(tokens[*tok_count].value, word);
                (*tok_count)++;
                index=0;
            }
        if (c=='>' && input[i+1] == '>'){
            tokens[(*tok_count)++].type = token_gtgt; // >>
            i++;
        }
        else if (c=='>') tokens[(*tok_count)++].type = token_gt;
        else if (c=='<') tokens[(*tok_count)++].type = token_lt;
        else if (c=='|') tokens[(*tok_count)++].type = token_pipe;
        else if (c=='&') tokens[(*tok_count)++].type = token_amp;
        else if (c==';') tokens[(*tok_count)++].type = token_semi;
        }
        else{
            word[index++]=c;
            content=1;
        }
    }
        else if (state==1){
            if (c=='\'') state = 0;
            else {
                word[index++]=c;
                content=1;
            }
        }
        else if (state==2){
            if (c=='\\' && (input[i+1]=='"' || input[i+1]=='\\')){
                i++;
                word[index++] = input[i];
                content=1;
            }
            else if (c =='"') state =0;
            else {
                word[index++] = c;
                content=1;
            }
            }
        }
     if(content){
                word[index] = '\0';
                tokens[*tok_count].type = token_word;
                strcpy(tokens[*tok_count].value, word);
                (*tok_count)++;
                index=0;
            }
    if(state!=0){
        printf("cshell: invalid syntax\n");
        return 0;
    }  
    return 1; 
}    