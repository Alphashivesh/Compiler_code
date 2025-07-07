%{
#include <stdio.h>
#include <stdlib.h>

int line_count = 0;
int word_count = 0;
int visible_count = 0;
int total_count = 0;

FILE *output_file = NULL;
%}

%%
\n               { line_count++; }
[ \t]+           { }
[A-Za-z0-9]+     { word_count++; total_count += yyleng; visible_count += yyleng; }
.                { total_count++; visible_count++; }
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

    fprintf(output_file, "Total Lines: %d\n", line_count);
    fprintf(output_file, "Total Words: %d\n", word_count);
    fprintf(output_file, "Total Visible Characters: %d\n", visible_count);
    fprintf(output_file, "Total Characters: %d\n", total_count);

    fclose(input_file);
    fclose(output_file);

    printf("Processing complete. Results written to %s\n", argv[2]);
    return 0;
}
