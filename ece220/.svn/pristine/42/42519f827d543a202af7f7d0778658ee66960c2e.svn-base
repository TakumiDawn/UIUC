;Intoductory Paragraph:
; updateboard.asm updates the game board.
; R2: pointer of board
; R3: counter of rows
; R4: board status

    .ORIG x3800
; UPDATEBOARD
;   Inputs:
;     R0: Current player's token. 1 for player 1 and -1 for player 2.
;     R1: Column to make move in [1-7]
;   Outputs:
;     R0: Memory location that is updated if successful
;         0 if move was unsuccessful (column is full)

UPDATEBOARD
  ST R1,UB_SAVER1
  ST R2,UB_SAVER2
  ST R3,UB_SAVER3
  ST R4,UB_SAVER4

	ADD R1,R1,#-1
	AND R3,R3,#0
	ADD R3,R3,#5
	LD R2,UB_BOARD
  ADD R2,R2,R1
	LDR R4,R2,#0
	BRnp IF_FUL

SEARCH
	ADD R3,R3,#0
	BRz UB_DONE
	ADD R2,R2,#7
	LDR R4,R2,#0
	BRnp UB_GO
	ADD R3,R3,#-1
	BR SEARCH

IF_FUL
	AND R0,R0,#0
	LD R4,UB_SAVER4
	LD R3,UB_SAVER3
	LD R2,UB_SAVER2
  RET

UB_GO
	ADD R2,R2,#-7
	STR R0,R2,#0
	ADD R0,R2,#0
	LD R2,UB_SAVER2
  LD R3,UB_SAVER3
  LD R4,UB_SAVER4
	RET

UB_DONE
	STR R0,R2,#0
	ADD R0,R2,#0
  LD R2,UB_SAVER2
	LD R3,UB_SAVER3
	LD R4,UB_SAVER4
	RET


;;;;;;;;;;;;;;;;;;;;;;;;
UB_SAVER1 .BLKW #1
UB_SAVER4 .BLKW #1
UB_SAVER3 .BLKW #1
UB_SAVER2 .BLKW #1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Do not modify below this line ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Indirect references to far away locations
UB_BOARD
    .FILL x6000

; End of assembly file
    .END
