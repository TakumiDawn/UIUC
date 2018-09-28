.ORIG x3000

  LD R1, NUM1  ; the Row number is provided in R1
  AND R3, R3, #0
  ADD R3, R1, #0
  AND R4, R4, #0
  ADD R4, R1, #0

MORE
  JSR COEFF
  JSR PUSH
  ADD R4, R4, #-1
  BRzp MORE

DONE_MAIN
  JSR POP
  ADD R3, R0, #0
  JSR PRINT_DECIMAL
  ADD R5, R5, #0
  BRz DONE_MAIN

  HALT

ASCII_ZERO .FILL x30
NUM1 .FILL x0004


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;input:R3-n R4-k
;output: R0-the coeffient

COEFF
  ST R2,COEFF_SAVER2
  ST R3,COEFF_SAVER3
  ST R4,COEFF_SAVER4
  ST R7,COEFF_SAVER7

  AND R2, R2, #0
  NOT R2, R4
  ADD R2, R2, #1 ;-k
  ADD R2, R3, R2 ;n-k
  AND R3, R3, #0
  ADD R3, R2, #0
  JSR FAC
  AND R2, R2, #0
  ADD R2, R0, #0 ;(n-k)! in R2

  AND R3, R3, #0
  ADD R3, R4, #0
  JSR FAC
  AND R4, R4, #0
  ADD R4, R0, #0 ;k! in R4

  AND R3, R3, #0
  ADD R3, R2, #0 ;(n-k)! in R3
  JSR MUL
  AND R4, R4, #0
  ADD R4, R0, #0 ; k!(n-k)! in R4

  LD R3, COEFF_SAVER3 ; n in R3
  JSR FAC
  AND R3, R3, #0
  ADD R3, R0, #0 ;n! in R3

  JSR DIV ; n!/k!(n-k)! in R0


  LD R2,COEFF_SAVER2
  LD R7,COEFF_SAVER7
  LD R4,COEFF_SAVER4
  LD R3,COEFF_SAVER3
  RET

COEFF_SAVER7      .BLKW #1
COEFF_SAVER4      .BLKW #1
COEFF_SAVER3      .BLKW #1
COEFF_SAVER2      .BLKW #1

;Multiply, input R3, R4
;output R0
MUL
  ST R4,MUL_SAVER4
  ST R7,MUL_SAVER7
  ADD R4,R4,#0
  BRz CONT_MUL_Z
  AND R0, R0, #0
  ADD R3, R3, #0 ;check the value of R3, multiply accordingly
  BRz CONT_MUL_Z
  BRp CONT_MUL_P

  NOT R4, R4 ; if R3 is negative
  ADD R4, R4, #1
CONT_MUL_N
	ADD R0, R4, R0
ADD R3, R3, #1
	BRn CONT_MUL_N
	BRz MUL_DONE

CONT_MUL_P ; if R3 is positive
	ADD R0, R4, R0
	ADD R3, R3, #-1
	BRp CONT_MUL_P
	BRz MUL_DONE

CONT_MUL_Z ;if either R3 or R4 is zero
	AND R0, R0, #0

MUL_DONE
  LD R7,MUL_SAVER7
  LD R4,MUL_SAVER4
  RET

MUL_SAVER7             .BLKW #1
MUL_SAVER4             .BLKW #1


;input R3, R4 (R3/R4)
;out R0-quotient, R1-remainder
DIV
	ST R2,DIV_R2
	ST R3,DIV_R3
  ST R7,DIV_R7
	NOT R2,R4
	ADD R2,R2,#1
	AND R0,R0,#0
	ADD R0,R0,#-1
DIV_LOOP
	ADD R0,R0,#1
	ADD R3,R3,R2
	BRzp DIV_LOOP
	ADD R1,R3,R4
	LD R2,DIV_R2
	LD R3,DIV_R3
  LD R7,DIV_R7
	RET

DIV_R2 .BLKW #1
DIV_R3 .BLKW #1
DIV_R7 .BLKW #1

;Factorial, Input R3
;output R0

FAC
  ST R3,FAC_SAVER3
  ST R4,FAC_SAVER4
  ST R7,FAC_SAVER7

  AND R4, R4, #0
  ADD R4, R3, #-1
  BRnz ZorO
CONT_FAC
  JSR MUL
  AND R3, R3, #0
  ADD R3, R0, #0
  ADD R4, R4, #-1
  BRz DONE_FAC
  BRnp CONT_FAC

ZorO
  LD R0, ZandO

DONE_FAC
  LD R3,FAC_SAVER3
  LD R7,FAC_SAVER7
  LD R4,FAC_SAVER4
  RET

FAC_SAVER3 .BLKW #1
FAC_SAVER7 .BLKW #1
FAC_SAVER4 .BLKW #1
ZandO .FILL x0001

;Input: R3
;Output: print the decimal value in R3 to screen

PRINT_DECIMAL
  ST R0,P_SAVER0
  ST R3,P_SAVER3
  ST R4,P_SAVER4
  ST R7,P_SAVER7

GO_DIV
    LD R4, NUM10
    JSR DIV
  	ADD R3, R0, #0
  	ADD R0, R1, #0
    JSR PUSH
    ADD R3, R3, #0
  	BRp GO_DIV

MORE_DIV
    JSR POP
    ADD R5, R5, #0
    BRp DONE_DIV
  	LD R2, ASCII_0
    ADD R0, R0, R2
  	OUT
  	BRnzp MORE_DIV

DONE_DIV
  LD R0,P_SAVER0
  LD R3,P_SAVER3
  LD R7,P_SAVER7
  LD R4,P_SAVER4
  RET

P_SAVER0 .BLKW #1
P_SAVER4 .BLKW #1
P_SAVER3 .BLKW #1
P_SAVER7 .BLKW #1
ASCII_0 .FILL x30
NUM10 .FILL x000A


;IN:R0, OUT:R5 (0-success, 1-fail/overflow)
;R3: STACK_END R4: STACK_TOP
;
PUSH
	ST R3, PUSH_SaveR3	;save R3
	ST R4, PUSH_SaveR4	;save R4
	AND R5, R5, #0		;
	LD R3, STACK_END	;
	LD R4, STACk_TOP	;
	ADD R3, R3, #-1		;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz OVERFLOW		;stack is full
	STR R0, R4, #0		;no overflow, store value in the stack
	ADD R4, R4, #-1		;move top of the stack
	ST R4, STACK_TOP	;store top of stack pointer
	BRnzp DONE_PUSH		;
OVERFLOW
	ADD R5, R5, #1;
DONE_PUSH
	LD R3, PUSH_SaveR3	;
	LD R4, PUSH_SaveR4	;
	RET


PUSH_SaveR3	.BLKW #1	;
PUSH_SaveR4	.BLKW #1	;


;OUT: R0, OUT R5 (0-success, 1-fail/underflow)
;R3 STACK_START R4 STACK_TOP
;
POP
	ST R3, POP_SaveR3	;save R3
	ST R4, POP_SaveR4	;save R3
	AND R5, R5, #0		;clear R5
	LD R3, STACK_START	;
	LD R4, STACK_TOP	;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz UNDERFLOW		;
	ADD R4, R4, #1		;
	LDR R0, R4, #0		;
	ST R4, STACK_TOP	;
	BRnzp DONE_POP		;
UNDERFLOW
	ADD R5, R5, #1		;
DONE_POP
	LD R3, POP_SaveR3	;
	LD R4, POP_SaveR4	;
	RET


POP_SaveR3	.BLKW #1	;
POP_SaveR4	.BLKW #1	;
STACK_END	.FILL x3FF0	;
STACK_START	.FILL x4000	;
STACK_TOP	.FILL x4000	;

.END