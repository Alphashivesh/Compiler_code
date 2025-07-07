/* File: calc.y */
%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void yyerror(const char *s);
int yylex();

int variables[26]; // For storing single-character variable values (a-z)
%}

%union {
    int number;
    char variable;
}

%token <number> NUMBER
%token <variable> VARIABLE
%type <number> expression statement
%left '+' '-'
%left '*' '/'
%right '^'
%nonassoc '='

%%

program:
    program statement ';' { }
    | /* empty */ { }
    ;

statement:
    expression { printf("Result: %d\n", $1); }
    | VARIABLE '=' expression { variables[$1 - 'a'] = $3; printf("%c = %d\n", $1, $3); }
    ;

expression:
    NUMBER { $$ = $1; }
    | VARIABLE { $$ = variables[$1 - 'a']; }
    | expression '+' expression { $$ = $1 + $3; }
    | expression '-' expression { $$ = $1 - $3; }
    | expression '*' expression { $$ = $1 * $3; }
    | expression '/' expression { if ($3 == 0) { yyerror("Division by zero"); exit(1); } else { $$ = $1 / $3; } }
    | expression '^' expression { $$ = pow($1, $3); }
    | '(' expression ')' { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Enter expressions (end each with a semicolon):\n");
    return yyparse();
}
