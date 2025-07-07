%{
#include <stdio.h>
#include <string.h>

int roman_to_int(const char *roman);
void int_to_roman(int num, char *result);

int num1 = 0, num2 = 0;
int roman_count = 0;
%}

%%
M{0,3}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3}) {
    if (roman_count == 0) {
        num1 = roman_to_int(yytext); // Convert first Roman numeral to integer
        roman_count++;
    } else {
        num2 = roman_to_int(yytext); // Convert second Roman numeral to integer
        roman_count++;
    }
}
[ \t\n]+    { /* Skip whitespace */ }
.           { printf("Invalid input: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}

int main() {
    char result[100];
    
    printf("Enter two Roman numerals separated by a space: ");
    yylex();

    if (roman_count == 2) {
        int sum = num1 + num2;
        int_to_roman(sum, result); // Convert the sum back to Roman numeral
        printf("Result: %s\n", result);
    } else {
        printf("Error: Please provide exactly two Roman numerals.\n");
    }

    return 0;
}

int roman_to_int(const char *roman) {
    int value = 0, prev = 0;
    while (*roman) {
        int curr;
        switch (*roman) {
            case 'I': curr = 1; break;
            case 'V': curr = 5; break;
            case 'X': curr = 10; break;
            case 'L': curr = 50; break;
            case 'C': curr = 100; break;
            case 'D': curr = 500; break;
            case 'M': curr = 1000; break;
            default: return -1; // Invalid Roman numeral
        }
        value += curr;
        if (curr > prev) value -= 2 * prev; // Handle subtraction rule
        prev = curr;
        roman++;
    }
    return value;
}

void int_to_roman(int num, char *result) {
    struct {
        int value;
        const char *symbol;
    } roman_map[] = {
        {1000, "M"}, {900, "CM"}, {500, "D"}, {400, "CD"},
        {100, "C"}, {90, "XC"}, {50, "L"}, {40, "XL"},
        {10, "X"}, {9, "IX"}, {5, "V"}, {4, "IV"},
        {1, "I"}
    };
    
    result[0] = '\0';
    for (int i = 0; i < 13; i++) {
        while (num >= roman_map[i].value) {
            strcat(result, roman_map[i].symbol);
            num -= roman_map[i].value;
        }
    }
}
