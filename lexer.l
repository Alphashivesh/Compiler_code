%{
#include "parser.tab.h" // Include the tokens defined by Bison
#include <string.h>

%}

%%
[a-zA-Z][a-zA-Z0-9]*   { yylval.str = strdup(yytext); return IDENTIFIER; }
"="                    { return ASSIGN; }
"+"                    { return PLUS; }
"-"                    { return MINUS; }
"("                    { return LPAREN; }
")"                    { return RPAREN; }
[ \t\n]                { /* Ignore whitespace */ }
.                      { printf("Unexpected character: %c\n", yytext[0]); exit(1); }
%%

int yywrap() {
    return 1;
}
 