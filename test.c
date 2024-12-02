#include <stdio.h>
#include <stdint.h>
#include "parser_arith.h"

void test_parse_arithmetic(const char* input, int64_t expected, const char* expected_end) {
    ParserResult result = parse_arithmetic(input);

    if (result.end_address == NULL) {
        printf("FAIL: Parsing '%s' failed at '%s'.\n", input, result.data.address);
    } else if (result.data.number != expected || (expected_end != NULL && result.end_address != input + (expected_end - input))) {
        printf("FAIL: Parsing '%s' returned number %ld (expected %ld) and stopped at '%s' (expected '%s').\n",
               input, result.data.number, expected, result.end_address, expected_end);
    } else {
        printf("PASS: Parsing '%s' succeeded with number %ld, stopped at '%s'.\n", input, result.data.number, result.end_address);
    }
    printf("yay\n");

}

int main() {
    printf("hello worlds\n");

    // // Arithmetic test cases
    test_parse_arithmetic("23", 23, "");
    test_parse_arithmetic("-3", -3, "");
    test_parse_arithmetic("2+3", 5, "");            // Simple addition
    test_parse_arithmetic("10-4", 6, "");           // Simple subtraction
    test_parse_arithmetic("7*6", 42, "");           // Multiplication
    test_parse_arithmetic("8/2", 4, "");            // Division
    test_parse_arithmetic("2+3*4", 14, "");         // Mixed operations (respect precedence)
    test_parse_arithmetic("10*(2+3)", 50, "");      // Parentheses
    test_parse_arithmetic("invalid+expression", 0, "invalid+expression"); // Error input

    return 0;
}
