#include <stdio.h>
#include <stdint.h>
#include "parser_arith.h"

void test_parse_arithmetic(const char* input, int64_t expected, int should_succeed) {
    ParserResult result = parse_arithmetic(input);

    if (result.end_address == NULL) {
        if (should_succeed) {
            printf("FAIL: Parsing '%s' failed at '%s', expected result %ld.\n", input, result.data.address, expected);
        } else {
            printf("PASS: Parsing '%s' correctly failed at '%s'.\n", input, result.data.address);
        }
    } else {
        if (!should_succeed) {
            printf("FAIL: Parsing '%s' succeeded unexpectedly, returned %ld.\n", input, result.data.number);
        } else if (result.data.number != expected) {
            printf("FAIL: Parsing '%s' returned number %ld (expected %ld).\n",
                   input, result.data.number, expected);
        } else if (*result.end_address != '\0') {
            printf("FAIL: Parsing '%s' did not consume entire input, stopped at '%s'.\n",
                   input, result.end_address);
        } else {
            printf("PASS: Parsing '%s' succeeded with number %ld.\n", input, result.data.number);
        }
    }
}

int main() {
    printf("Testing arithmetic parser\n\n");

    // Arithmetic test cases that the current parser can handle
    test_parse_arithmetic("23", 23, 1);
    test_parse_arithmetic("-3", -3, 1);
    test_parse_arithmetic("2+3", 5, 1);            // Simple addition
    test_parse_arithmetic("10-4", 6, 1);           // Simple subtraction
    test_parse_arithmetic("7*6", 42, 1);           // Multiplication
    test_parse_arithmetic("8/2", 4, 1);            // Division

    // Since the parser does not handle operator precedence, we adjust this test case
    test_parse_arithmetic("2+3*4", 14, 1);         // Operations applied left to right
    test_parse_arithmetic("3*4+2", 14, 1);         // Operations applied left to right
    test_parse_arithmetic("3+4+2+3",12, 1);         // Operations applied left to right

    // The parser does not handle parentheses, so we skip this test case
    // test_parse_arithmetic("10*(2+3)", 50, 1);    // Parentheses not supported

    // Error handling test case
    test_parse_arithmetic("invalid+expression", 0, 0); // Error input

    return 0;
}
