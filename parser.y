%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int temp_count = 0;

char* new_temp() {
    char* temp = (char*)malloc(10 * sizeof(char));
    sprintf(temp, "t%d", temp_count++);
    return temp;
}

void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
    exit(1);
}

int yylex();
%}

%union {
    char* str;
}

%token <str> IDENTIFIER
%token ASSIGN PLUS MINUS LPAREN RPAREN
%type <str> expr term factor

%%

input:
    IDENTIFIER ASSIGN expr {
        printf("%s = %s\n", $1, $3);
    }
    ;

expr:
    expr PLUS term {
        char* temp = new_temp();
        printf("%s = %s + %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr MINUS term {
        char* temp = new_temp();
        printf("%s = %s - %s\n", temp, $1, $3);
        $$ = temp;
    }
    | term {
        $$ = $1;
    }
    ;

term:
    MINUS factor {
        char* temp = new_temp();
        printf("%s = -%s\n", temp, $2);
        $$ = temp;
    }
    | factor {
        $$ = $1;
    }
    ;

factor:
    IDENTIFIER {
        $$ = strdup($1);
    }
    | LPAREN expr RPAREN {
        $$ = $2;
    }
    ;

%%

int main() {
    printf("Enter a simple assignment expression:\n");
    yyparse();
    return 0;
}
