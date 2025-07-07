%{
#include <stdio.h>
#include <stdlib.h>

FILE *output_file = NULL;
%}

%%
"/*"([^*]|\*+[^*/])*\*+\/     { /* Remove block comments */ }
"//".*                        { /* Remove single-line comments */ }
[ \t]+                        { fprintf(output_file, " "); }
\n+                           { fprintf(output_file, "\n"); }
.                             { fprintf(output_file, "%s", yytext); }
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
