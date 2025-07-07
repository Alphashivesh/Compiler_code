/* File: calc.l */
%{
#include "calc.tab.h"

int yywrap() {
    return 1;
}
%}

%%

[0-9]+            { yylval.number = atoi(yytext); return NUMBER; }
[a-zA-Z][a-zA-Z0-9]* { yylval.variable = yytext[0]; return VARIABLE; }
\"+\"              return '+';
\"-\"              return '-';
\"*\"              return '*';
\"/\"              return '/';
\"^\"              return '^';
\"=\"              return '=';
\";\"              return ';';
[ \\t\\n]+         ; // Ignore whitespace
.                 return yytext[0];

%%
