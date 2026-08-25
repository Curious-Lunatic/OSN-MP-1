#include "../include/shell.h"
#include "../include/lexer.h"
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
        executing(tokens, token_count, shome);
    }
    return 0;
}