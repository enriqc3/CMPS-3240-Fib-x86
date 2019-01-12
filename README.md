# CMPS-3240-Fibonacci-x86
Implementing control of flow with Fibonacci numbers

## Objectives

* Learn how to implement control of flow in x86

## Prerequisites

* Understand branching in x86
* Understand the concept of the flag register

## Requirements

### General

* An iterative solution to Fibonacci (not recursive)

### Software

This lab requires `gcc`, `make`, and `git`.

### Compatability

| Linux | Mac | Windows |
| :--- | :--- | :--- |
| `odin.cs.csubak.edu`<sup>*</sup> | No | No |

<sup>*</sup>Different OS (kernel versions) and compilers will generate different assembly codes. You must use the departmental server for this lab.

## Background

You should be familiar with the following C commands such as `if`:

```c
if (expr)
    // do stuff
else
    // more stuff
```

and iterative loops:

```c
while (expr) {
   //do something ...
}
```

Today we will learn how to implement these in x86. Jumping consists of two steps:

1. Evaluate the expression `expr`. In x86, this is the `cmp` x86 command. Two arguments are compared to each other. 
2. Based on the result of the expression, go to a specific line in the code. Recall that we can label specific lines in x86 assembly code with an identifier. 

Here is an example in x86: 

```
cmp %eax, %ebx
jg ifblock # Jump if %ebx > %eax
# Else block goes here
ifblock: # Where jg will jump to if the condition is not met
```

`cmp` carries out the comparison, and there are a variety of jumping commands based on the result. Today's lab will use `jg`. If `%ebx > %eax` then the process will jump. Perhaps the most unusual thing about all of this is that the if block is jumped too. The else block are the instructions that immidiately follow the `jg` operation. Note that this code is incomplete because once the else block is complete, the processor will continue into the if block unless commands are inserted to prevent this. Recall that the if and else blocks are supposed to be exclusive (only one or the other should be executed). The `jmp` command can help us here:

```
cmp %eax, %ebx
jg ifblock # Jump if %ebx > %eax
# Else block goes here
# ...
jmp endofblock
ifblock: 
# Where jg will jump to if the condition is not met
# ...
endofblock:
```

We will apply these concepts with today's lab.

# Approach

## Part 1 - Study `fact.s`

The makefile contains targets for `fact.out` and `fact.s`. Make both with:

```shell
$ make all
```

`fact.out` is an executable. You should run it just to see that it works:

```shell
$ fact.out
10! is 3628800
```

then look at `fact.c` to see what the program is meant to do. It generates the result of the mathematical expression 10!. Just to be clear, 10! = 10 * 9 * 8 * ... * 2 * 1. Multiply the number n times n-1 repeatedly until n = 1. Technically, n = 2 is an OK termination point because anything * 1 is just 1.

Now take a look at the `fact.s`. We're just going to look at a small part of it. From the previous lab you should be familiar with the idea that local variables are stored on the stack and do not actually have an identifier when translated into assembly language, that x86 has a right to left assignment, unlike MIPS most commands are two arguments only. x86 code to calculate 10! with a `do`-`while` loop looks like so. First, the literal 10 and a variable to store the result are placed on the stack:

```x86
    movl    $10, -4(%rbp)
    movl    $1, -8(%rbp)
```

The first command places literal 10 into `-4(%rbp)`. The second command places literal 1 into `-8(%rbp)`, which will hold our result. It is initialized to 1. Note that the stack will persist for as long as we're in this scope (`main` in this case), so we will use these positions in the stack to hold our intermediate results. Now for the meat of the code:

```x86
.L2:
    movl    -8(%rbp), %eax
    imull   -4(%rbp), %eax
    movl    %eax, -8(%rbp)
    subl    $1, -4(%rbp)
    cmpl    $1, -4(%rbp)
    jg  .L2
```

Something to note is that, for arithmetic operations such as `movl`, the first argument can be a memory location, but the second argument must be a register. This means that something like:

```x86
   movl -8(%rbp), -8(%rbp) 
```

would be *invalid*. Thus, we have to juggle the intermediate result into a register temporarily. `-8(%rbp)` is placed into `%eax`, then the contents of `-4(%rbp)` are multiplied by whatever contents are in `%eax`. "But wait," you might ask, "where is the result stored into?" The arithmetic commands in x86, unlike MIPS, follow a sort of C-style `+=`, `-=`, `*=`, etc. style. So, the result of `-4(%rbp)` * `%eax` is stored back into `%eax`. Note that the next line `movl %eax, -8(%rbp)` puts the result back into the stack. `subl $1, -4(%rbp)` then decrements the value to be multiplied on the next run of the loop. All of this to realize the following C commands:

```c
    result *= a;
    a--;
```

The last part of this is to have the machine evaluate the C expression `a > 1`, and keep looping as necessary.  Note that we can refactor the expression to `a - 1 > 0`. Unlike MIPS, x86 has two commands to perform a conditional loop. First, the mathematical expression is evaluated. This is the `cmpl $1, -4(%rbp)` command. All x86 commands generally follow this sort of format where `cmp` is called which subtracts the first argument from the second.<sup>1</sup> The results are stored in the register called `%eflags`, a flag register where certain bits explain the result of carrying out the subtration operation. The exact contents of the flag register are beyond the scope of the lab,<sup>2</sup> luckily we don't need to directly interact with it because there are commands that we call to act on the result of the contents of this register. Specifically, we need the machine to jump back up to `.L2` if `a > 1` is true, or to continue along if false. `jg` checks the sign of `cmp` operation (by consulting the flag register) and will jump to the label provided if the second argument is greater than the first. That's all for 10!. Viola, as they say in Franch. 

## Part 2 - Fibonacci

Your task for this lab is to modify the code in fact.s so that it displays the 10th Fibonacci number.

* It should do this iteratively
* You must do this in x86 and not C. Consult the previous disassembly/assembly lab for what the makefile targets should look like to do this.

# Check off

Show your x86 solution for credit.

# References
<sup>1</sup>https://c9x.me/x86/html/file_module_x86_id_35.html
