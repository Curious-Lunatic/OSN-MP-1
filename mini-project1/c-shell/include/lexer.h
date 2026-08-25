#ifndef lexer_h
#define lexer_h // bruh i only do typos ;-;
typedef enum{
    token_pipe,
    token_amp,
    token_semi,
    token_lt,
    token_gt,
    token_gtgt,
    token_word,
    token_fragment,
    token_dq,
    token_sq
} tokentype;
typedef struct token
{
    tokentype type;
    char value[5000];
}token;
int maketoken(char *input, token *token, int *tok_count);
int parsing(token *tokens, int count);
void executing(token *tokens, int tok_count, const char* shome);
#endif