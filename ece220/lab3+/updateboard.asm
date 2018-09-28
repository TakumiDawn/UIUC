; updateboard.asm
;
; Intoductory Paragraph:
;
;

    .ORIG x3800
; UPDATEBOARD
;   Inputs:
;     R0: Current player's token. 1 for player 1 and -1 for player 2.
;     R1: Column to make move in [1-7]
;   Outputs:
;     R0: Memory location that is updated if successful
;         0 if move was unsuccessful (column is full)
UPDATEBOARD
    ; Your code goes here:
	; R3 pointer to the BOARD
	; R2 row counter
    ; R4 current status in the BOARD
ST R1,UB_SAVE_R1
ST R3,UB_SAVE_R3
ST R2,UB_SAVE_R2
ST R4,UB_SAVE_R4
	ADD R1,R1,#-1
	AND R2,R2,#0
	ADD R2,R2,#5

	LD R3,UB_BOARD
	
    ADD R3,R3,R1
	LDR R4,R3,#0
	BRnp IS_FULL
	
NEXT_AVAILABLE
	ADD R2,R2,#0
	BRz PUT_IN_THE_LAST
	ADD R3,R3,#7
	LDR R4,R3,#0
	BRnp BEFORE_IS_FINE
	ADD R2,R2,#-1
	BR NEXT_AVAILABLE

IS_FULL
	AND R0,R0,#0
	LD R4,UB_SAVE_R4
	LD R2,UB_SAVE_R2
	LD R3,UB_SAVE_R3
    RET

BEFORE_IS_FINE
	ADD R3,R3,#-7
	STR R0,R3,#0
	ADD R0,R3,#0
	LD R4,UB_SAVE_R4
	LD R2,UB_SAVE_R2
	LD R3,UB_SAVE_R3
	RET

PUT_IN_THE_LAST
	STR R0,R3,#0
	ADD R0,R3,#0
	LD R4,UB_SAVE_R4
	LD R2,UB_SAVE_R2
	LD R3,UB_SAVE_R3
	RET
UB_SAVE_R1 .FILL x0000
UB_SAVE_R4 .FILL x0000
UB_SAVE_R2 .FILL x0000
UB_SAVE_R3 .FILL x0000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Do not modify below this line ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Indirect references to far away locations
UB_BOARD
    .FILL x6000

; End of assembly file
    .END
