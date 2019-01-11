COMPILER=gcc
FLAGS=-Wall -O0

all: fact 

hello: hello.c
	$(COMPILER) $(FLAGS) -o hello.out hello.c

# This guy is not included in all and will have to be executed manually with 
# 'make hello.asm'. It generates assembly code.
hello.s: hello.c
	$(COMPILER) $(FLAGS) -o hello.s -S hello.c

# This guy reassembles code generated from the above target
assemble: hello.o
	$(COMPILER) hello.o -o hello.out

hello.o: hello.s
	$(COMPILER) $(FLAGS) -c hello.s -o hello.o

clean: 
rm -f *.o *.s *.out
