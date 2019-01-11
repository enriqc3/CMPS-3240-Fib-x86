# See https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html
# for a full explanation of automatic variables in makefiles.

COMPILER=gcc
FLAGS=-Wall -O0

all: fact fact.s

# Compile fact.c into a binary
fact:	fact.c
	$(COMPILER) $(FLAGS) -o $@.out $@.c

fact.s:	fact.c
	$(COMPILER) $(FLAGS) -o $@ -S $<

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
