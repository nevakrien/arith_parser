#ifndef PARSER_ARITH_H
#define PARSER_ARITH_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

// Union to hold parsed data: either a number or fail address
typedef union {
    int64_t number;
    char* address;
} ParsedData;

// Struct to hold the parser result
typedef struct {
    char* end_address; // Null on fail
    ParsedData data;   //
} ParserResult;

// Function to parse arithmetic expressions
// On failure: `end_address` is NULL, `data.address` holds the error address
// On success: `end_address` points to the first non-digit symbol, and `data.number` holds the parsed value
__attribute__((sysv_abi)) ParserResult parse_arithmetic(const char* input);

#ifdef __cplusplus
}
#endif

#endif // PARSER_ARITH_H
