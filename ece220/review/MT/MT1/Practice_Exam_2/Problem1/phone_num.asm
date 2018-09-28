.ORIG x3000
  LD R2, SADD
GO
START_GETC
  LDI R1, KBSR
  BRzp START_GETC
  LDI R0, KBDR
  LD R1, EQ ; check if "enter"
  NOT R1, R1
  ADD R1, R1, #1
  ADD R1, R0, R1
  BRz CHECK
START_OUT
    LDI R1, DSR
    BRzp START_OUT
    STI R0, DDR
  STR R0, R2, #0
  ADD R2, R2, #1
  BRnzp GO

CHECK
  LD R1, SADD_MAX ;check the number of chars
  NOT R1, R1
  ADD R1, R1, #1
  ADD R1, R2, R1
  BRnp INVALID

MOREBIT
  LDR R3, R2, #-1 ;check if char are numbers
  LD R1, NUM0
  NOT R1, R1
  ADD R1, R1, #1
  ADD R1, R3, R1
  BRn INVALID  ;if <"0",not valid
  LD R1, NUM9
  NOT R1, R1
  ADD R1, R1, #1
  ADD R1, R3, R1
  BRp INVALID ;if >"9", not valid
  ADD R2, R2, #-1
  LD R1, SADD ;check if R2 is x5000
  NOT R1, R1
  ADD R1, R1, #1
  ADD R1, R2, R1
  BRz VALID
  BRnzp MOREBIT

INVALID
  LEA R0, INV_MSG
  PUTS
  BRnzp DONE

VALID
  LEA R0, VAL_MSG
  PUTS
  BRnzp DONE

DONE
  HALT

KBSR    .FILL xFE00
KBDR    .FILL xFE02
DSR     .FILL xFE04
DDR     .FILL xFE06
INV_MSG .STRINGZ "Invalid Phone Number."
VAL_MSG .STRINGZ "Valid Phone Number."
ENTER .FILL x000D
EQ .FILL x003D
NUM0 .FILL x0030
NUM9 .FILL x0039
SADD .FILL x5000
SADD_MAX .FILL x500A

.END
