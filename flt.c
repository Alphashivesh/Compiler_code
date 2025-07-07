#include <stdio.h>

float a = 5.5;
float b = 10.1;

void example(float x) {
    printf("%f\n", x);
}

int main() {
    float result = a + b;
    example(result);
    return 0;
}
