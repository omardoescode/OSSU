# Program Compilation
---

![](attachment/4ea0a074667ee9a641e243decc463fe2.png)

We would want our high-level program to run on many devices, but every device has his own processor and therefore his own compiler.

![](attachment/f02618e2e50c7f9ad7e4ba2d05a2596a.png)

An alternative is to "write once, run anywhere". The solution is to no compile down to the machine language. We compile down to VM code (In java, it's called bytecode). Then each device must have his own implementation that takes the VM code to machine language

![](attachment/87f3224ca784288d0af09cbc4fd64a15.png)

We now can separate the process of compilation and VM translation. 

We will create a programming language called Jack. This must run on our PC and the Hack computer. We write a compiler that translates code to VM code. In our pc, it will run on the VM emulator, and on the Hack computer, it will run on the VM translator

![](attachment/e9e54677b8384f15382a2f41b31c8449.png)


This Virtualization idea is the cornerstone of cloud computing and networking, and is here used in the Virtual Machine. This is the idea of [[Alan Turing]], which is how a universal machine or a universal Turing machine can execute the commands of anther machine. 

> [!quote]
> We can only see a short distance ahead, but we can see plenty there that needs to be done.
> -- Alan Turing


# VM Abstraction: the Stack

What do we want our VM code to be like? We want to shorten the gap between high-level program and the machine language to ease the translation process.

We can use the Stack machine abstraction to create this VM code.

## Stack

![](attachment/8a2d7b7ddfd08a66636e37184ac82667.png)

We have `sp` as a pointer to the place the new plate would be pushed.

![](attachment/1fa8ad5d594c4c8b383cfb53f0c667ac.png)

We also have some arithmetic operations as well
1. `add`: pop the top 2 values and add them and push the result
	![](attachment/69edf07d453b960adc67d494047c3095.png)
2. `neg`: pop the top value, negate it, and push the result
	![](attachment/ce8baeddb64250f58782c35da2b23e4b.png)

We can notice that every function can be implemented by popping the data, computing the result and pushing the result. Here are other examples

![](attachment/f849a4da228f3baa9cc5c0f4c80a53da.png)



![](attachment/9683dda98a43212d2b6f6f2482481693.png)

## The stack machine model

It's manipulated by
- Arithmetic / Logical commands
- Memory Segment commands
- Branching commands
- function commands

### Arithmetic / Logical commands

![](attachment/3a7679da634b2854239ff75f389c6012.png)

Any arithmetic or logical expression can be expressed and evaluated by applying some sequence of the above operations on a stack

# VM Abstraction: Memory Segments

We know that are different kinds of variables
1. static variables
2. local variables
3. argument variables

![](attachment/97ab9faf4e45044e14b93eceadb3815c.png)

We want to preserve the difference between these kinds of variables. We will have different segments of memory each dedicated to each kind. 

![](attachment/2cdedee0a016620ffce7ba4737dadd23.png)

Now we have to specify where to push and pop

![](attachment/8020ddafbe63509fd06161c6c567d7f8.png)

But all the variable names have been lost, and they don't recognize them.

We will add a fourth segment for constants, just for consistency and making compilation easier. 

![](attachment/a3ea87c38d0f5b8dfe5113d1728ab0e5.png)

We also have other four segment, because there is much to handle in high level language

![](attachment/0c5b07dc468bed603142bd0c9e30efa4.png)

But we handle all of them the same way

- push: `push segment i`: where segment is one of the 8 segments above and i is a non-negative integer.
- pop: `pop segment i`: where segment is one of the 8 segments above except for the constants segments and i is a non-negative integer.

# Implementing the stack

We need to map the starting point of each memory segment to portions of the RAM.

We need to know Pointer manipulation

## Pointer Manipulation
Notation: 
- `*p`: returns the value at memory location p points at (indirect addressing)
	In hack
	```asm
	@p
	A=M
	D=M
	```
- `p--`: increment the value of p, that is the memory location. Notice that we are treating `p` as a normal variable, but the effect is to point to the next memory location
- `*p = 5`: place 5 at the memory location stored in `p`

![](attachment/29f3b45bf69c3dd3311e5e5ae8c6a24f.png)

## Stack Machine
We first put SP in `RAM[0]` and stack base at `addr = 256`

![](attachment/8a82416ce7ec3ced82057317a094a4a2.png)

Let's write the assembly commands
pseudo Logic for `push constant 17`

```
*SP = 17
SP++
```

At hack
```asm
@17 // D=17
D=A

@SP // *SP=D
A=M
M=D

@SP // SP++
M=M+1
```

## VM translator perspective
It's a program that translates VM code into machine language. Each VM command generates several assembly commands

# Implementation of memory segments

## Implementing `local`

It starts at 1015 which is stored in `LCL`. In principle, it can be everywhere. 

A command like `pop local 2` will be translated to 

```
addr=LCL+2, SP--, *addr = *SP
```

```asm
// SP--
@SP
M=M-1

// addr = LCL+2
@2
D=A

@LCL
D=D+A

@addr
M=D

// *SP
@SP
D=M

// *addr = *SP
@addr
M=D
```

![](attachment/f42cd4960368fe81af7982403e82e51c.png)

Notice that we didn't remove the 5 from the stack, but we decreased the value of SP, which will simply overwrite that 5 when we need that


## Implementing `local`, `argument`, `this`, `that`

When translating the high-level code of some method into VM code, the compiler
- maps the method's local and argument variables onto the local and argument segments
- maps the object fields and the array entries that the method is currently processing onto the `this` and `that` segments

Each segment has its own pointer to the base address of each segment, and therefore the implementation of `local` extends to the remaining 3 segments

![](attachment/e2d5f9a6ead1ed2b3e1878f5ae1eca8f.png)

## Implementing `constant`

This segment is virtual, it doesn't really exist
- `push constant i`: the implementation is just to supply the specified constant `*SP=i, SP++`

## Implementing `static`

They should be seen by all the methods in a program and the solution is to store them in some global space.
We will have the VM translator translate each VM reference `static i` (in file `Foo.vm`) into an assembly reference `Foo.i`

```asm
// file name : Foo.vm
// pop static 5
// D=stack.pop (code omitted)
@Foo.5
M=D

// push static 5
```

So the entries of the static segment will end up being mapped onto `RAM[16]`, `RAM[17]`, ..., `RAM[255]` in the order in which they will appear in the program

## Implementing `temp`
Sometimes the compiler needs some temp variables. We have 8 such temporary variables. They are mapped on RAM locations 5 to 12.

![](attachment/3f0df30f5eca8a5317cfcb9d9927d2ea.png)

## Implementing `pointer`

It generates code that keeps track of the base addresses of the `this` and `that` segments using the `pointer` segment

We can only push and pop 0 and 1 and each other integer is invalid. accessing `pointer 0` means accessing `this` and `pointer 1` means `that`

Implementation: supplies THIS or THAT.

![](attachment/1633d26ce78df8443aa123585a8f74ef.png)

# VM Implementation on the Hack Platform

When you do translate each command, write also a comment above

![](attachment/452c58551423b0d0bf78d93b7ca8d0d7.png)

Our mapping has to be standard

![](attachment/96ffbec9e466a95f9bd03586dbb00cf7.png)


































