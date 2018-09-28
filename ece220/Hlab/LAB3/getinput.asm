; Introductory Paragraph:
; getinput.asm gets the inputs form the players.
;


    .ORIG x3400
; GETINPUT
;   Inputs:
;     R0: Current player's token
;   Outputs:
;     R0: Column number chosen by player

GETINPUT
    ST R7, GI_SAVER7
    ST R1, GI_SAVER1

    GETC
    LDI R1,GI_ASCII_ZERO
    NOT R1,R1
    ADD R1,R1,#1
    ADD R0,R1,R0
    LD R1, GI_SAVER1
    LD R7, GI_SAVER7
    RET

;;;;;;;;;;;;;;;;;;;;;;;
GI_SAVER1 .BLKW #1
GI_SAVER7 .BLKW #1

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
