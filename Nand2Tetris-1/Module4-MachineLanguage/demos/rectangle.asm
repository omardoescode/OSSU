// for (int i = 0; i < n; i++) {
//    Draw 16 black pixels at the beginnng of row i
//  }

// addr = SCREEN
// n = RAM[0]
// i = 0
// LOOP
// if i > n goto END
// RAM[addr] = -1 // or 1111... (16 1's)
// addr = addr + 32 // Jump 32 to get to the next row
// i = i + 1
// goto LOOP
// END:
// goto END

  // addr = SCREEN
  @SCREEN
  D=A
  @addr
  M=D

  // n = RAM[0]
  @R0
  D=M
  @n
  M=D

  // i = 0
  @i
  M=0

(LOOP)
  // if i > n goto END
  @i
  D=M
  @n
  D=D-M
  @END
  D;JGT

  // RAM[addr] = -1
  @addr
  A=M
  M=-1
  

  // i = i + 1
  @i
  M=M+1

  // addr = addr + 32
  @32
  D=A
  @addr
  M=D+M


  // goto LOOP
  @LOOP
  0;JMP

(END)
  @END
  0;JMP



