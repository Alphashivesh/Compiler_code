%{
#include <stdio.h>
%}

%%
"float"           { printf("double"); } 
.                 { putchar(yytext[0]); } 
\n                { putchar('\n'); } 
%%

int yywrap() {
    return 1;
}

int main() {
    printf("Enter a C program: \n");
    yylex();
    return 0;
}
