# This is the makefile that generates the executable

# Files to compile
FILES_C = main.c red-black-tree.c linked-list.c create-tree.c tree-utils.c

# Exectuable to generate
TARGET = main

# Compilation options
# PERF & DEBUG
# CFLAGS = -Wall -Werror -pg -g
# DEBUG
CFLAGS = -Wall -Werror -g -fopenmp
# Optimize lvl 1
#CFLAGS = -Wall -Werror -O
# Optimize lvl 3
#CFLAGS = -Wall -Werror -O3


# Linker options
LFLAGS = -lm

# There is no need to change the instructions below this
# line. Change if you really know what you are doing.

$(TARGET): $(FILES_O) Makefile
	gcc $(CFLAGS) $(FILES_C) -o $(TARGET) $(LFLAGS)

all: $(TARGET)

clean:
	/bin/rm $(TARGET)
