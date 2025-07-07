%{
#include <stdio.h>
%}

%%

M{0,3}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3}) {
    printf("Valid Roman numeral: %s\n", yytext);
}
[a-zA-Z]+ { printf("Invalid Roman numeral: %s\n", yytext); }
[ \t\n]+  { /* Ignore whitespace */ }
.         { printf("Unknown character: %s\n", yytext); }

%%

int yywrap(){
	return 1;
}

int main() {
    printf("Enter Roman numerals:\n");
    yylex();
    return 0;
}