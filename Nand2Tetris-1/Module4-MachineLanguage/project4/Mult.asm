// Mult: R2 = R0 * R1
// R2 = 0
// n = RAM[R1]
// i = 0
// if n > 0 goto POSTIVE
//  n = -n
//  neg = true
//  goto LOOP
// POSITIVE
//  neg = false
// if i == n goto CHECK
// R2 = R2 + R0
// i = i + 1
// goto LOOP
// 
// (CHECK)
//    if not neg goto END
//    R2 = -R2
// (END)

  // RAM[R2] = 0
  @R2
  M=0

  // n = RAM[R1]
  @R1
  D=M
  @n
  M=D
  
  // i = 0
  @i
  M=0

  // if n > 0 goto POSTIVE
  @n
  D=M
  @POSITIVE
  D;JGT

  // n = -n
  @n
  M=-M

  // neg = true
  @neg
  M=1

  // goto LOOP
  @LOOP
  0;JMP

(POSITIVE)
  @neg
  M=0

(LOOP)
  // if i == n goto check
  @i
  D=M
  @n
  D=D-M
  @CHECK
  D;JEQ

  // R2 = R2 + R0
  @R0
  D=M
  @R2
  M=D+M

  // i = i + 1
  @i
  M=M+1

  // goto LOOP
  @LOOP
  0;JMP

(CHECK)
  // if not neg goto END
  @neg
  D=M
  @END
  D;JEQ

  // R2 = -R2
  @R2
  M=-M

(END)
  @END
  0;JMP
