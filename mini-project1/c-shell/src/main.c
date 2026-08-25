#include "../include/shell.h" // get our shit
#include "../include/lexer.h" // get our other shit
#include <string.h>
#include <stdio.h>
#define maxtok 256
#define maxerinput 5000
extern char previous[5000]; 
int main() {
    char shome[5000];
    char input[maxerinput]; // given 
    
    if (getcwd(shome, sizeof(shome)) == NULL) {
        return 1; // bail out if we can't get home
    }
    
    int running = 1;
    
    while (running) {
        printing(shome);
        
        // fgets > scanf bcs does not break on space
        if (fgets(input, sizeof(input), stdin) == NULL) {
            // failed to read anything so print a new line and break the loop to exit
            printf("\n");
            break;
        }
        
        // terminate the line by finding where \n was 
        input[strcspn(input, "\n")] = '\0';
        
        // if empty just continue looping
        if (strlen(input) == 0) {
            continue;
        }
        
        token tokens[maxtok];
        int token_count = 0;
        
        if (!maketoken(input, tokens, &token_count)) {
            continue; // lexer failed 
        }
        
        if (!parsing(tokens, token_count)) {
            continue; // parser already printed "cshell: invalid syntax"
        }
        
        // execution phase: go through tokens and run the commands
        int i = 0;
        while (i < token_count) {
            char *args[100];
            int acount = 0;
            char *cmd = NULL;
            
            // grab all words until we hit a command delimiter like ; | &
            while (i < token_count && tokens[i].type != token_semi && tokens[i].type != token_pipe && tokens[i].type != token_amp) {
                if (tokens[i].type == token_word) {
                    if (cmd == NULL) {
                        cmd = tokens[i].value; // first word is our command
                    } else {
                        args[acount++] = tokens[i].value; // rest are args
                    }
                }
                i++;
            }            
            if (cmd != NULL) {
                if (strcmp(cmd, "hop") == 0) {
                    hopping(args, acount, shome);
                } 
                else if (strcmp(cmd, "reveal") == 0) {
                    // pass the global previous dir to reveal
                    revealing(args, acount, shome, previous);
                } 
                else if (strcmp(cmd, "exit") == 0) {
                    running = 0; // kill the shell gracefully
                    break;
                }
            }
            if (i < token_count) {
                i++; 
            }
        }
    }    
    return 0;
}