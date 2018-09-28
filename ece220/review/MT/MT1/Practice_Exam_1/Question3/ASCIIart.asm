;Load ASCII art character, stored at memory address x5000 (IMAGEADDR)
;The first two numbers are the width (number of columns) and the height (number
;of rows) in the ASCII art image
;The memory addresses starting at x5002 are ASCII characters. The first N
;characters are the first row of the image, the second N characters are the
;second row of the image, etc.
;each row should end with a newline character

.ORIG x3000
;YOUR CODE GOES HERE

  AND R1, R1, #0
  AND R2, R2, #0
  LDI R2, IMAGEADDR_M
  LD R3, IMAGEADDR_C

MORELINES
  LDI R1, IMAGEADDR
MOREBIT
  LDR R0, R3, #0
  OUT
  ADD R3, R3, #1
  ADD R1, R1, #-1
  BRp MOREBIT
NL
  LD R0, NEWLINE
  OUT
  ADD R2, R2, #-1
  BRp MORELINES

DONE
  HALT


NEWLINE .FILL x000A
IMAGEADDR .FILL x5000 ; address of image
IMAGEADDR_M .FILL x5001
IMAGEADDR_C .FILL x5002
.END
