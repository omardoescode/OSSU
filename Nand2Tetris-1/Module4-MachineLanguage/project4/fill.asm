// limit = SCREEN + 8191
// (LISTEN)
// addr = SCREEN
// if KBD is 0 goto BLACK
// clr = 0
// goto FILL
// (BLACK)
// clr = -1
// (FILL)
// if addr > limit goto LISTEN
// RAM[addr] = clr
// addr = addr + 1
// goto FILL

  // limit = SCREEN + 8191
  @SCREEN
  D=A
  @8191
  D=D+A
  @limit
  M=D

(LISTEN)
  // addr = SCREEN
  @SCREEN
  D=A
  @addr
  M=D

  // if KBD is 0 goto BLACK
  @KBD
  D=M
  @BLACK
  D;JEQ

  // clr = -1
  @clr
  M=-1

  // goto FILL
  @FILL
  0;JMP

(BLACK)
  @clr
  M=0

(FILL)
  // if addr > limit goto LISTEN
  @addr
  D=M
  @limit
  D=D-M
  @LISTEN
  D;JEQ

  // RAM[addr]=clr
  @clr
  D=M
  @addr
  A=M
  M=D

  // addr = addr + 1
  @addr
  M=M+1

  @FILL
  0;JMP
