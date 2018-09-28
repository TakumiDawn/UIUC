; Intoductory Paragraph:
; printboard.asm prints the board.
; R1: pointer of board
; R2: counter of rows
; R3: counter of cols


  .ORIG x3600
PRINTBOARD
	ST R0, PB_SAVER0
  ST R1, PB_SAVER1
	ST R2, PB_SAVER2
	ST R3, PB_SAVER3
	ST R7, PB_SAVER7

	AND R2,R2,#0
	ADD R2,R2,#6
	AND R3,R3,#0
	ADD R3,R3,#7
	LD  R1,PB_BOARD

P_ROW
	ADD R2,R2,#0
	BRz CONT_ROW
	ADD R2,R2,#-1

P_COL
	ADD R3,R3,#0
	BRz CONT_COL
	ADD R3,R3,#-1
	LDR R0,R1,#0
	BRp PRINT_X
	ADD R0,R0,#0
	BRn PRINT_O
	LDI R0,PB_EMPTY_PIECE
	OUT
	BR GO

PRINT_X
	LDI R0,PB_P1_PIECE
	OUT
	BR GO

PRINT_O
	LDI R0,PB_P2_PIECE
	OUT

GO
	ADD R1,R1,#1
	BR P_COL

CONT_COL
	LDI R0,PB_NEWLINE
	OUT
	AND R3,R3,#0
	ADD R3,R3,#7
	BR  P_ROW

CONT_ROW
  LEA R0,PB_PRINT_SPACE
  PUTS

  LD R0,PB_SAVER0
  LD R1,PB_SAVER1
  LD R2,PB_SAVER2
  LD R3,PB_SAVER3
  LD R7,PB_SAVER7
  RET

;;;;;;;;;;;;;;;;;;;;;;
PB_SAVER0 .BLKW #1;
PB_SAVER2 .BLKW #1;
PB_SAVER3 .BLKW #1;
PB_SAVER1 .BLKW #1;
PB_SAVER7 .BLKW #1;
PB_PRINT_SPACE .STRINGZ "\n"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Do not modify below this line ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Indirect references to far away locations
PB_BOARD
    .FILL x6000
PB_ASCII_ZERO
    .FILL x602A
PB_NEWLINE
    .FILL x602B
PB_EMPTY_PIECE
    .FILL x602C
PB_P1_PIECE
    .FILL x602D
PB_P2_PIECE
    .FILL x602E

; End of assembly file
    .END
