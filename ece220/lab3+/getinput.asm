; getinput.asm
;
; Intoductory Paragraph:
;
;

    .ORIG x3400
; GETINPUT
;   Inputs:
;     R0: Current player's token
;   Outputs:
;     R0: Column number chosen by player
GETINPUT
    ; Your code goes here:

    ; You should replace this block with your actual code
    ST R7, GETINPUT_SAVE_R7   
	ST R1, GETINPUT_SAVE_R1
    GETC        ; SAMPLE
	LDI R1,GI_ASCII_ZERO
	NOT R1,R1
	ADD R1,R1,#1
	ADD R0,R1,R0
    LD R7, GETINPUT_SAVE_R7    ; SAMPLE	
	LD R1, GETINPUT_SAVE_R1
    ;BR 1        ; SAMPLE
    ;.BLKW 1     ; SAMPLE
    ; You should replace this block with your actual code

    RET
GETINPUT_SAVE_R1 .FILL x0000
GETINPUT_SAVE_R7 .FILL x0000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Do not modify below this line ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Indirect references to far away locations
GI_ASCII_ZERO
    .FILL x602A
GI_NEWLINE
    .FILL x602B
GI_P1_PROMPT
    .FILL x605A
GI_P2_PROMPT
    .FILL x6072
GI_INVALID_INPUT
    .FILL x608A

; End of assembly file
    .END
