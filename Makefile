CC = zig cc
NASM = nasm
CFLAGS = -Wall -g3 -gdwarf
ASMFLAGS_LINUX = -f elf64
ASMFLAGS_WINDOWS = -f win64 

# Determine OS-specific settings
ifeq ($(OS), Windows_NT)
    TARGET = parser_test.exe
    ASMFLAGS = $(ASMFLAGS_WINDOWS)
    LDFLAGS =
else
    TARGET = parser_test.out
    ASMFLAGS = $(ASMFLAGS_LINUX)
    LDFLAGS = -no-pie
endif

OBJS = test.o parser.o

all: $(TARGET)

# Link target
$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $^

# Compile C test file
test.o: test.c parser_arith.h
	$(CC) $(CFLAGS) -c $< -o $@

# Assemble NASM file
parser.o: parser.asm
	$(NASM) $(ASMFLAGS) $< -o $@

# Clean build artifacts
clean:
	rm -f $(TARGET) $(OBJS)

.PHONY: all clean
