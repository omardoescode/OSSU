//   n = R0
//   i = 1
//   sum = 0
// LOOP: 
// 	if i > n goto STOP
// 	sum = sum + i
// 	i = i + 1
// 	goto LOOP
// STOP:
// 	R1 = sum

  @R0
  D=M
  @n
  M=D // n = R0
  @i
  M=1 // i = 1
  @sum
  M=0 // sum = 0

(LOOP)
  
  @i
  D=M
  @n
  D=D-M
  @STOP
  D;JGT  // if i > n goto stop

  @sum
  D=M
  @i
  D=D+M
  @sum
  M=D // sum = sum + i
  @i
  M=M+1 // i = i + 1
  @LOOP
  0;JMP
 
(STOP)
  @sum
  D=M
  @R1
  M=D // RAM[1] = sum

(END)
  @END
  0;JMP
