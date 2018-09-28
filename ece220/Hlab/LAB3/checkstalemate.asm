;Introductory Paragraph:
; checkstalemate.asm
; R1: counter for cols
; R2: pointer of board
; R3: hold address of a value


    .ORIG x3C00
; CHECKSTALEMATE
;   Outputs:
;     R0: 1 if the board is filled
;         0 if it isn't


CHECKSTALEMATE
	ST R1,CSM_SAVER1
	ST R2,CSM_SAVER2
  ST R3,CSM_SAVER3
	ST R7,CSM_SAVER7

	LD R0,CW_BOARD
	AND R1,R1,#0
	ADD R1,R1,#7

KS
	ADD R1,R1,#0
	BRz YES
	ADD R1,R1,#-1
	LDR R3,R2,#0
	BRnp NS
	ADD R2,R2,#1
	BR KS

YES
	AND R0,R0,#0
	ADD R0,R0,#1
	LD R1,CSM_SAVER1
	LD R2,CSM_SAVER2
	LD R3,CSM_SAVER3
  LD R7,CSM_SAVER7
  RET

NS
	AND R0,R0,#0
	LD R1,CSM_SAVER1
	LD R2,CSM_SAVER2
	LD R3,CSM_SAVER3
  LD R7,CSM_SAVER7
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;
CSM_SAVER1	.BLKW #1
CSM_SAVER2  .BLKW #1
CSM_SAVER3	.BLKW #1
CSM_SAVER7	.BLKW #1


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Do not modify below this line ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Indirect references to far away locations
CW_BOARD
    .FILL x6000

; End of assembly file
    .END
