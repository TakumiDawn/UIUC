;This calculator can calculate add, subtract, multiply, divide
;and power in postfix format.
;
;Table of Registers
;R0: Store input
;R1: Store value that is to be compared with input
;R2:
;R3: Store intermediate operand
;R4: Store intermediate operand
;R5:
;R6:
;R7:

.ORIG x3000

NEXTCHAR

          GETC ;       Get an input
          OUT ;        Echo it back to screen
          LD R1,EQUAL
          NOT R1,R1
          ADD R1,R1,#1
          ADD R1,R1,R0 ;    Check if it is a "=", if so, branch to DONE
          BRz DONE



          LD R1,SPACE ;     Check if it is a " ", if so, get another input
          NOT R1,R1
          ADD R1,R1,#1
          ADD R1,R1,R0
          BRz NEXTCHAR
          JSR EVALUATE  ;If the input is neither "=" nor " ", branch to EVALUATE


DONE

          LD R3,STACK_TOP
          LD R4,STACK_START ;     Compare STACK_TOP and STACK_START.
          ADD R4,R4,#-1
          NOT R4,R4
          ADD R4,R4,#1
          ADD R4,R4,R3
          BRnp BADINPUT ;  If there is a underflow or there are more than one
          JSR PRINT_HEX ; numbers in the stack, output "Invalid Expression"

          HALT

EQUAL     .FILL x003D
SPACE     .FILL x0020


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R3  -value to print in hexadecimal
PRINT_HEX


          LDI R5,STACK_START ; If there is only one number in the stack after
          AND R3,R3,#0       ;all evaluations, print the result
          ADD R3,R3,R5       ; onto screen in hexadecimal format


              AND R6,R6,#0
OUTERLOOP     ADD R7,R6,#-4
              BRz DONEPRINT

PRINTABIT     AND R4,R4,#0
              AND R5,R5,#0
MOREBIT       ADD R4,R4,R4
              ADD R3,R3,#0
              BRzp POSITIVE
              ADD R4,R4,#1
POSITIVE      ADD R3,R3,R3
              ADD R5,R5,#1
              ADD R7,R5,#-4
              BRnp MOREBIT
              ADD R0,R4,#0
              ADD R7,R0,#-10
              BRn NUMBER
              LD R7,CONSTANT2
              ADD R0,R0,R7
              OUT
              BRnzp CHECK
NUMBER        LD R7,CONSTANT1
              ADD R0,R0,R7
              OUT
CHECK         ADD R6,R6,#1
              BRnzp OUTERLOOP

DONEPRINT     HALT

CONSTANT1     .FILL #48
CONSTANT2     .FILL #55


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R0 - character input from keyboard
;R6 - current numerical output
;
;
EVALUATE

          ST R7,EVALUATE_SAVER7
          LD R1,PLUS_S ; Compare the input and "+". If they are equal,
          NOT R1,R1    ; branch to PLUS and perform an addition.
          ADD R1,R1,#1
          ADD R1,R1,R0
          BRnp NOTPLUS ; If the input is not a plus, continue to compare
          JSR POP
          AND R4,R4,#0 ; Pop two numbers from stack to prepare for the operation
          ADD R4,R4,R0
          JSR POP
          AND R3,R3,#0
          ADD R3,R3,R0
					ADD R5,R5,#0
					BRp BADINPUT ; if there is an underflow, output "Invalid Expression"
          JSR PLUS
          BR NEXTCHAR ; When the operation is over, get another input
NOTPLUS
          LD R1,SUBTRACT_S ;  Compare the input and "-". If they are equal, branch to MIN and perform an subtraction.
          NOT R1,R1
          ADD R1,R1,#1
          ADD R1,R1,R0
          BRnp NOTSUBTRACT ;   If the input is not a min, continue to compare
					JSR POP
          AND R4,R4,#0
          ADD R4,R4,R0
          JSR POP    ;             Pop two numbers from stack to prepare for the operation
          AND R3,R3,#0
          ADD R3,R3,R0
					ADD R5,R5,#0
					BRp BADINPUT ; if there is an underflow, output "Invalid Expression"
          JSR MIN
          BR NEXTCHAR
NOTSUBTRACT
          LD R1,MULTIPLY_S ;  Compare the input and "*". If they are equal, branch to MUL and perform an multiplication.
          NOT R1,R1
          ADD R1,R1,#1
          ADD R1,R1,R0
          BRnp NOTMULTIPLY ;   If the input is not a mul, continue to compare
					JSR POP ;  Pop two numbers from stack to prepare for the operation
          AND R4,R4,#0
          ADD R4,R4,R0
          JSR POP
          AND R3,R3,#0
          ADD R3,R3,R0
					ADD R5,R5,#0
					BRp BADINPUT ; if there is an underflow, output "Invalid Expression"
          JSR MUL
          BR NEXTCHAR
NOTMULTIPLY
          LD R1,DIVIDE_S  ;  Compare the input and "/". If they are equal, branch to DIV and perform an division.
          NOT R1,R1
          ADD R1,R1,#1
          ADD R1,R1,R0
          BRnp NOTDIVIDE  ;   If the input is not a div, continue to compare
					JSR POP ;  Pop two numbers from stack to prepare for the operation
          AND R4,R4,#0
          ADD R4,R4,R0
          JSR POP
          AND R3,R3,#0
          ADD R3,R3,R0
					ADD R5,R5,#0
					BRp BADINPUT  ; if there is an underflow, output "Invalid Expression"
          JSR DIV
          BR NEXTCHAR
NOTDIVIDE
          LD R1,POWER_S  ;  Compare the input and "^". If they are equal, branch to EXP and perform an power calculation.
          NOT R1,R1
          ADD R1,R1,#1
          ADD R1,R1,R0
          BRnp NOTPOWER  ;  If the input is not a exp, continue to compare
					JSR POP   ;  Pop two numbers from stack to prepare for the operation
          AND R4,R4,#0
          ADD R4,R4,R0
          JSR POP
          AND R3,R3,#0
          ADD R3,R3,R0
					ADD R5,R5,#0
					BRp BADINPUT  ; if there is an underflow, output "Invalid Expression"
          JSR EXP
          BR NEXTCHAR
NOTPOWER
          LD R1,ZEROHEX ; Compare the input with "0" and "9" to see whether it is a number.
          NOT R1,R1   ;      If the input is a number, push it into the stack.
          ADD R1,R1,#1  ;   If the unput is not a number, output "Invalid Expression"
          ADD R1,R1,R0
          BRn BADINPUT

          LD R1,NINEHEX
          NOT R1,R1
          ADD R1,R1,#1
          ADD R1,R1,R0
          BRp BADINPUT
          LD R1,ZEROHEX
          NOT R1,R1
          ADD R1,R1,#1
          ADD R0,R1,R0


          JSR PUSH
          BR NEXTCHAR  ;    When finish the push, get another input




BADINPUT

          LEA R0,BADSTRING   ; The subroutine for printing "Invalid expression"
          PUTS
          HALT

          LD R7,EVALUATE_SAVER7
          RET

EVALUATE_SAVER7          .BLKW #1
PLUS_S                   .FILL x002B
SUBTRACT_S               .FILL x002D
MULTIPLY_S               .FILL x002A
DIVIDE_S                 .FILL x002F
POWER_S                  .FILL x005E
ZEROHEX                  .FILL x0030
NINEHEX                  .FILL x0039
BADSTRING                .STRINGZ "Invalid Expression"
STACK_START	.FILL x4000	;
STACK_TOP	.FILL x4000	;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
PLUS
;your code goes here

          ST R7,PLUS_SAVER7

          ADD R0,R3,R4
          JSR PUSH   ;       Do the addition operation and push the result into the stack

          LD R7,PLUS_SAVER7
          RET

PLUS_SAVER7             .BLKW #1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
MIN

          ST R7,MIN_SAVER7

          NOT R4,R4
          ADD R4,R4,#1
          ADD R0,R3,R4   ; Do the subtraction and push the result into the stack
          JSR PUSH

          LD R7,MIN_SAVER7
          RET

MIN_SAVER7             .BLKW #1

;your code goes here

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
MUL
;your code goes here

    ST R4,MUL_SAVER4
    ST R7,MUL_SAVER7
		ADD R4,R4,#0
		BRz CONT_MUL_Z
		AND R0, R0, #0
		ADD R3, R3, #0  ;check the value of R3, multiply accordingly
		BRz CONT_MUL_Z
		BRp CONT_MUL_P

		NOT R4, R4   ; if R3 is negative
		ADD R4, R4, #1
CONT_MUL_N
		ADD R0, R4, R0
		ADD R3, R3, #1
		BRn CONT_MUL_N
		BRz MUL_PUSH

CONT_MUL_P        ; if R3 is positive
		 ADD R0, R4, R0
		 ADD R3, R3, #-1
		 BRp CONT_MUL_P
		 BRz MUL_PUSH

CONT_MUL_Z ;if either R3 or R4 is zero
			AND R0, R0, #0

MUL_PUSH ; push the result to stack
			JSR PUSH

      LD R7,MUL_SAVER7
      LD R4,MUL_SAVER4
      RET

MUL_SAVER7             .BLKW #1
MUL_SAVER4             .BLKW #1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0


DIV
  ST R7,DIV_SAVER7
  AND R5,R5,#0
  ADD R3,R3,#0
  BRzp DIV_FISRT
  ADD R5,R5,#1
  NOT R3,R3
  ADD R3,R3,#1

DIV_FISRT
  ADD R4,R4,#0
  BRzp DIV_SECOND
  ADD R5,R5,#-1
  NOT R4,R4
  ADD R4,R4,#1


DIV_SECOND     ; Check if the quotient is positive or negative.
  NOT R4,R4
  ADD R4,R4,#1
  AND R0, R0, #0
CONT_DIV
  ADD R0, R0, #1
  ADD R3,R3,R4
  BRp CONT_DIV
  BRz DIV_EXA
  ADD R0, R0, #-1
;If the quotient is negative, negate the 2' compliment and add 1.

DIV_EXA
   ADD R5,R5,#0
   BRz DIV_PUSH
   NOT R0,R0
   ADD R0,R0,#1

DIV_PUSH

  JSR PUSH
  LD R7,DIV_SAVER7
  RET

DIV_SAVER7      .BLKW #1


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
EXP
;your code goes here


          ST R7,EXP_SAVER7
          AND R6,R6,#0
          ADD R6,R4,#0   ;Set R6 as counter,counting number of iterations needed
          ADD R4,R3,#0
          ADD R6,R6,#-1
POWERAGAIN
          ADD R6,R6,#0
          BRz DONEEXP
          ADD R6,R6,#-1
          JSR MUL
          JSR POP
          AND R3,R3,#0
          ADD R3,R0,#0
          BR POWERAGAIN  ; Continue to iterate when R6 is positive.
DONEEXP   JSR PUSH
          LD R7,EXP_SAVER7


          RET

EXP_SAVER7             .BLKW #1


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
	ADD R5, R5, #1		;
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

.END
