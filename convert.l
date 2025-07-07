%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

FILE *output_file = NULL;

int is_vowel(char c) {
    c = tolower(c);
    return c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u';
}
%}

%%
[a-zA-Z]+ {
    if (is_vowel(yytext[0])) {
        fprintf(output_file, "%say ", yytext);
    } else {
        fprintf(output_file, "%s%cay ", yytext + 1, yytext[0]);
    }
}
[ \t\n]+ { fprintf(output_file, "%s", yytext); }
.        { fprintf(output_file, "%s", yytext); }
%%

int yywrap() {
    return 1;
}

int main(int argc, char **argv) {
    FILE *input_file = NULL;

    if (argc != 3) {
        fprintf(stderr, "Usage: %s <input file> <output file>\n", argv[0]);
        return 1;
    }

    input_file = fopen(argv[1], "r");
    if (!input_file) {
        fprintf(stderr, "Error: Cannot open input file %s\n", argv[1]);
        return 1;
    }

    output_file = fopen(argv[2], "w");
    if (!output_file) {
        fprintf(stderr, "Error: Cannot open output file %s\n", argv[2]);
        fclose(input_file);
        return 1;
    }

    yyin = input_file;
    yylex();

    fclose(input_file);
    fclose(output_file);

    printf("Processing complete. Result written to %s\n", argv[2]);
    return 0;
}
