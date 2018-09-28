.ORIG x3000

LD R1, INPUT
JSR FIBON
ST R6, RESULT
HALT

INPUT 	.FILL x0001
RESULT	.BLKW #1

;your code goes here
;INPUT R1, OUTPUT R6
;FL R3, FH R4
FIBON
  ADD R1, R1, #-2
  BRnz ONEANDTWO
  AND R3, R3, #0
  ADD R3, R1, #-11
  ADD R3, R3, #-11
  BRp BAD  ; k is more than 24, then R6=-1

  AND R3, R3, #0
  ADD R3, R3, #1
  AND R4, R4, #0
  ADD R4, R4, #1
  AND R0, R0, #0 ;F_SUM
MORE
  ADD R0, R3, R4
  AND R3, R3, #0
  ADD R3, R4, #0
  AND R4, R4, #0
  ADD R4, R0, #0
  ADD R1, R1, #-1
  BRp MORE
  BRnzp GOOD

ONEANDTWO
  AND R6, R6, #0
  ADD R6, R6, #1
  BRnzp DONE

BAD
  AND R6, R6, #0
  ADD R6, R6, #-1
  BRnzp DONE

GOOD
  AND R6, R6, #0
  ADD R6, R0, #0
  BRnzp DONE

DONE
  RET


.END
