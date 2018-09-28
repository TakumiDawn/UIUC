;Reverse Characters
;n characters are provided to you
;in which n is a positive number stored at x4FFF
;characters stored in sequential memory location
;starting at x5000
;Use the subroutine REVERSE to flip the order

.ORIG x3000

JSR REVERSE
HALT

;REVERSE subroutine:
;reverse the order of n characters starting at x5000
;SWAPMEM subroutine must be called here, not in the main user program
REVERSE
  ST R0, R_SAVER0
  ST R2, R_SAVER2
  ST R1, R_SAVER1
  ST R7, R_SAVER7

  LD R0, CHAR_ADDR ;R0 as beginning addr indicator
  LDI R1, NUM_ADDR
  LDI R3, NUM_ADDR ;as counter
  ADD R1, R0, R1   ;R1 as end addr indicator
  ADD R1, R1, #-1

CONT
  JSR SWAPMEM
  ADD R0, R0, #1
  ADD R1, R1, #-1
  ADD R3, R3, #-2
  BRp CONT

R_DONE
  LD R0, R_SAVER0
  LD R1, R_SAVER1
  LD R2, R_SAVER2
  LD R7, R_SAVER7
  RET


R_SAVER0 .BLKW #1
R_SAVER1 .BLKW #1
R_SAVER2 .BLKW #1
R_SAVER7 .BLKW #1


NUM_ADDR    .FILL x4FFF
CHAR_ADDR   .FILL x5000

;SWAPMEM subroutine:
;address one is in R0, address two in R1
;if mem[R0]=A and mem[R1]=B, then after subroutine call
;   mem[R0]=B and mem[R1]=A
SWAPMEM
  ST R0, S_SAVER0
  ST R2, S_SAVER2
  ST R1, S_SAVER1
  ST R3, S_SAVER3
  ST R7, S_SAVER7

  LDR R2, R0, #0
  LDR R3, R1, #0
  STR R2, R1, #0
  STR R3, R0, #0

S_DONE
  LD R0, S_SAVER0
  LD R1, S_SAVER1
  LD R2, S_SAVER2
  LD R3, S_SAVER3
  LD R7, S_SAVER7
  RET

S_SAVER0 .BLKW #1
S_SAVER1 .BLKW #1
S_SAVER2 .BLKW #1
S_SAVER3 .BLKW #1
S_SAVER7 .BLKW #1



.END
