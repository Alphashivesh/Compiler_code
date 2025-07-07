%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

FILE *output_file = NULL;

#define SHIFT_KEY_ENCODE 5
#define SHIFT_KEY_DECODE -5
int shift_key;
%}

%%
[a-z]              { fprintf(output_file, "%c", (((yytext[0] - 'a') + shift_key + 26) % 26) + 'a'); }
[A-Z]              { fprintf(output_file, "%c", (((yytext[0] - 'A') + shift_key + 26) % 26) + 'A'); }
[0-9]              { fprintf(output_file, "%c", (((yytext[0] - '0') + shift_key + 10) % 10) + '0'); }
\n                 { fprintf(output_file, "\n"); }
.                  { fprintf(output_file, "%s", yytext); }
%%

int yywrap() {
    return 1;
}

int main(int argc, char **argv) {
    FILE *input_file = NULL;

    if (argc != 4) {
        fprintf(stderr, "Usage: %s <input file> <output file> <mode: encode/decode>\n", argv[0]);
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

    if (strcmp(argv[3], "encode") == 0) {
        shift_key = SHIFT_KEY_ENCODE;
    } else if (strcmp(argv[3], "decode") == 0) {
        shift_key = SHIFT_KEY_DECODE;
    } else {
        fprintf(stderr, "Error: Invalid mode. Use 'encode' or 'decode'.\n");
        fclose(input_file);
        fclose(output_file);
        return 1;
    }

    yyin = input_file;
    yylex();

    fclose(input_file);
    fclose(output_file);

    printf("Processing complete. Result written to %s\n", argv[2]);
    return 0;
}
