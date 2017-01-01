CC	   = gcc
CXX    = g++
RM	   = rm
ECHO	 = echo

DEFINES= -DS2_LIST -DS2_SET -DS2_DEBUG

CFLAGS = -Wall -g -I./ -I./dynamiC $(DEFINES) #-Os
OBJLIB = libS2.so

SRC  = $(wildcard vm*.c)
OBJ  = $(patsubst %.c,%.o,$(SRC))

DYN_SRC = $(wildcard dynamiC/*.c)
DYN_OBJ = $(patsubst %.c,%.o,$(DYN_SRC))

EXE	 = main.out
MAIN = main.c

.PHONY: all test clean

all:
		$(CC) $(CFLAGS) $(DYN_SRC) $(SRC) $(MAIN) -o $(EXE)

lib: $(OBJ) $(DYN_OBJ)
		$(CC) $(CFLAGS) -shared $(DYN_OBJ) $(OBJ) -o $(OBJLIB)

%.o: %.c
		$(CC) $(CFLAGS) -c -fpic -o $@ $<

valgrind:
		valgrind --leak-check=full --track-origins=yes -v ./$(EXE)

run: all
		./$(EXE)

clean:
		$(RM) -f *.out *.o *.so
		cd src; $(RM) -f *.out *.o *.so

doc:
		doxygen

test: lib
		cd test; make
