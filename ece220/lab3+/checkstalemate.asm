; checkstalemate.asm
;
; Intoductory Paragraph:
;
;

    .ORIG x3C00
; CHECKSTALEMATE
;   Outputs:
;     R0: 1 if the board is filled
;         0 if it isn't
CHECKSTALEMATE
    ; Your code goes here:
	; R1 is used as a col counter
	; R3 is used as the pointer to BD
	; R4 is used as the content of the that address
	ST R1,CSM_SAVE_R1
	ST R3,CSM_SAVE_R3
	
	LD R0,CW_BOARD
	AND R1,R1,#0
	ADD R1,R1,#7
	
KEEP_LOOP_STALL
	ADD R1,R1,#0
	BRz STALLMATE_GG
	ADD R1,R1,#-1
	LDR R4,R3,#0
	BRnp NOTSTALLMATE
	ADD R3,R3,#1
	BR KEEP_LOOP_STALL

    ;AND R0, R0, 0   ; Remove this AND instruction once you begin 
                    ; working on this subroutine!
	


STALLMATE_GG
	AND R0,R0,#0
	ADD R0,R0,#1
	LD R1,CSM_SAVE_R1
	LD R3,CSM_SAVE_R3
	LD R4,CSM_SAVE_R4
    RET



NOTSTALLMATE
	AND R0,R0,#0
	LD R1,CSM_SAVE_R1
	LD R3,CSM_SAVE_R3
	LD R4,CSM_SAVE_R4
	RET
CSM_SAVE_R1	.FILL x0000
CSM_SAVE_R3 .FILL x0000
CSM_SAVE_R4	.FILL x0000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Do not modify below this line ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Indirect references to far away locations
CW_BOARD
    .FILL x6000

; End of assembly file
    .END
