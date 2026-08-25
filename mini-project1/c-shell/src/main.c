#include "../include/shell.h" // get our shit
#include "../include/lexer.h" // get our other shit
#define maxtok 256
#define maxerinput 5000 
extern char previous[5000]; 
int main() {
    char shome[5000];
    char input[maxerinput]; 
    
    if (getcwd(shome, sizeof(shome)) == NULL) {
        return 1; 
    }
    
    int running = 1;
    
    while (running) {
        printing(shome);
        
        if (fgets(input, sizeof(input), stdin) == NULL) {
            printf("\n");
            break;
        }
        
        input[strcspn(input, "\n")] = '\0';
        
        if (strlen(input) == 0) {
            continue;
        }
        
        token tokens[maxtok];
        int token_count = 0;
        
        if (!maketoken(input, tokens, &token_count)) {
            continue; 
        }
        
        if (!parsing(tokens, token_count)) {
            continue; 
        }
        
        int i = 0;
        while (i < token_count) {
            char *args[100];
            int acount = 0;
            char *cmd = NULL;
            
            while (i < token_count && tokens[i].type != token_semi && tokens[i].type != token_pipe && tokens[i].type != token_amp) {
                if (tokens[i].type == token_word) {
                    if (cmd == NULL) {
                        cmd = tokens[i].value; 
                    } else {
                        args[acount++] = tokens[i].value; 
                    }
                }
                i++;
            }
            
            if (cmd != NULL) {
                if (strcmp(cmd, "hop") == 0) {
                    hopping(args, acount, shome);
                } 
                else if (strcmp(cmd, "reveal") == 0) {
                    revealing(args, acount, shome, previous);
                } 
                else if (strcmp(cmd, "peek") == 0) {
                    peeking(args, acount);
                }
                else if (strcmp(cmd, "locate") == 0) {
                    locating(args, acount);
                }
                else if (strcmp(cmd, "exit") == 0) {
                    running = 0; 
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