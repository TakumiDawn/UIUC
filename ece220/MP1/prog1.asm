;
; The code given to you here implements the histogram calculation that
; we developed in class.  In programming studio, we will add code that
; prints a number in hexadecimal to the monitor.
;
; Your assignment for this program is to combine these two pieces of
; code to print the histogram to the monitor.
;
; If you finish your program,
;    ** commit a working version to your repository  **
;    ** (and make a note of the repository version)! **


	.ORIG	x3000		; starting address is x3000


;
; Count the occurrences of each letter (A to Z) in an ASCII string
; terminated by a NUL character.  Lower case and upper case should
; be counted together, and a count also kept of all non-alphabetic
; characters (not counting the terminal NUL).
;
; The string starts at x4000.
;
; The resulting histogram (which will NOT be initialized in advance)
; should be stored starting at x3F00, with the non-alphabetic count
; at x3F00, and the count for each letter in x3F01 (A) through x3F1A (Z).
;
; table of register use in this part of the code
;    R0 holds a pointer to the histogram (x3F00)
;    R1 holds a pointer to the current position in the string
;       and as the loop count during histogram initialization
;    R2 holds the current character being counted
;       and is also used to point to the histogram entry
;    R3 holds the additive inverse of ASCII '@' (xFFC0)
;    R4 holds the difference between ASCII '@' and 'Z' (xFFE6)
;    R5 holds the difference between ASCII '@' and '`' (xFFE0)
;    R6 is used as a temporary register
;

	LD R0,HIST_ADDR      	; point R0 to the start of the histogram

	; fill the histogram with zeroes
	AND R6,R6,#0		; put a zero into R6
	LD R1,NUM_BINS		; initialize loop count to 27
	ADD R2,R0,#0		; copy start of histogram into R2

	; loop to fill histogram starts here
HFLOOP	STR R6,R2,#0		; write a zero into histogram
	ADD R2,R2,#1		; point to next histogram entry
	ADD R1,R1,#-1		; decrement loop count
	BRp HFLOOP		; continue until loop count reaches zero

	; initialize R1, R3, R4, and R5 from memory
	LD R3,NEG_AT		; set R3 to additive inverse of ASCII '@'
	LD R4,AT_MIN_Z		; set R4 to difference between ASCII '@' and 'Z'
	LD R5,AT_MIN_BQ		; set R5 to difference between ASCII '@' and '`'
	LD R1,STR_START		; point R1 to start of string

	; the counting loop starts here
COUNTLOOP
	LDR R2,R1,#0		; read the next character from the string
	BRz PRINT_HIST		; found the end of the string

	ADD R2,R2,R3		; subtract '@' from the character
	BRp AT_LEAST_A		; branch if > '@', i.e., >= 'A'
NON_ALPHA
	LDR R6,R0,#0		; load the non-alpha count
	ADD R6,R6,#1		; add one to it
	STR R6,R0,#0		; store the new non-alpha count
	BRnzp GET_NEXT		; branch to end of conditional structure
AT_LEAST_A
	ADD R6,R2,R4		; compare with 'Z'
	BRp MORE_THAN_Z         ; branch if > 'Z'

; note that we no longer need the current character
; so we can reuse R2 for the pointer to the correct
; histogram entry for incrementing
ALPHA	ADD R2,R2,R0		; point to correct hiat x3F00stogram entry
	LDR R6,R2,#0		; load the count
	ADD R6,R6,#1		; add one to it
	STR R6,R2,#0		; store the new count
	BRnzp GET_NEXT		; branch to end of conditional structure

; subtracting as below yields the original character minus '`'
MORE_THAN_Z
	ADD R2,R2,R5		; subtract '`' - '@' from the character
	BRnz NON_ALPHA		; if <= '`', i.e., < 'a', go increment non-alpha
	ADD R6,R2,R4		; compare with 'z'
	BRnz ALPHA		; if <= 'z', go increment alpha count
	BRnzp NON_ALPHA		; otherwise, go increment non-alpha

GET_NEXT
	ADD R1,R1,#1		; point to next character in string
	BRnzp COUNTLOOP		; go to start of counting loop



PRINT_HIST

;The part of "PRINT_HIST" will print the result of the first half part of this
;program stored at x3F00.

;R0 the hex digit to be printed
;R1 histogram address pointer
;R2 number of iterations
;R3 current data
;R4 is used to calculate the hex digit
;R5 bit counter
;R6 digit counter
;R7 temporary register


  LD  R1, HIST_ADDR ; load address of histogram into R1
  AND R2, R2, #0

OUTERLOOP
  LDR R3, R1, #0; load the number to be printed
  LD R0, CONSTANT5
  ADD R0, R0, R2
  OUT
  LD R0, CONSTANT4
  OUT


  AND R6, R6, #0
ONECHAR
  ADD R7,R6,#-4; check if we have done with one character
  BRz NEXTCHAR

	AND R4, R4, #0
	AND R5, R5, #0
MOREBIT
	ADD R4, R4, R4; left shift R4
	ADD R3, R3, #0
	BRzp ZERO
	ADD R4, R4, #1
ZERO
	ADD R3, R3, R3; left shift R3
	ADD R5, R5, #1; increment bit counter
	ADD R7, R5, #-4; check if we have gone through 4 bits
	BRn MOREBIT

;check if it is a number or letter
  AND R0, R0, #0
  ADD R0, R4, #0
  ADD R7, R0, #-10
  BRn NUMBER
  LD R7, CONSTANT2
  ADD R0, R7, R0
  OUT
  BRnzp CHAR

NUMBER
  LD R7, CONSTANT1
	ADD R0, R7, R0
  OUT

CHAR
  ADD R6, R6, #1
  BRnzp ONECHAR ; go back and check if we have done with one character

NEXTCHAR
  LD R0, CONSTANT3 ;new line
  OUT
  ADD R2, R2, #1 ;increment iteration counter
  ADD R1, R1, #1 ;increment address pointer
  LD R7, CONSTANT6
  ADD R7, R7, R2 ;check if we have gone through all letters
  BRn OUTERLOOP

DONE
  HALT			; done


; the data needed by the program
NUM_BINS	.FILL #27	; 27 loop iterations
NEG_AT		.FILL xFFC0	; the additive inverse of ASCII '@'
AT_MIN_Z	.FILL xFFE6	; the difference between ASCII '@' and 'Z'
AT_MIN_BQ	.FILL xFFE0	; the difference between ASCII '@' and '`'
HIST_ADDR	.FILL x3F00 ; histogram starting address
STR_START	.FILL x4000	; string starting address

CONSTANT1     .FILL #48       ;Offset of numbers in hexadecimal
CONSTANT2     .FILL #55       ;Offset of alphabets in hexadecimal
CONSTANT3     .FILL x000A     ;A new line in hexadecimal
CONSTANT4     .FILL x0020     ;Space in hexadecimal
CONSTANT5     .FILL x0040     ;@ in hexadecimal
CONSTANT6     .FILL #-27      ; number of iteration

; for testing, you can use the lines below to include the string in this
; program...
; STR_START	.FILL STRING	; string starting address
; STRING		.STRINGZ "This is a test of the counting frequency code.  AbCd...WxYz."



	; the directive below tells the assembler that the program is done
	; (so do not write any code below it!)

	.END
