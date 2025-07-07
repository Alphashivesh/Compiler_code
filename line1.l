%{
#include <stdio.h>
#include <stdlib.h>

int line_number = 1; // Counter for line numbers
FILE *output_file = NULL; // Output file pointer
%}

%%
^.+\n           { fprintf(output_file, "%d: %s", line_number++, yytext); } // Process non-empty lines with newline
^\n             { fprintf(output_file, "%d:\n", line_number++); }         // Process empty lines
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

    printf("Processing complete. Output written to %s\n", argv[2]);
    return 0;
}
