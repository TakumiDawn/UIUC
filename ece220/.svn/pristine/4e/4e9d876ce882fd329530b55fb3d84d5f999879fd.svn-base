.ORIG x3000


LD R0, ATTACK ; I changed the line of "PUTS" at x0459 from x1220 to x1222
LD R1, PUTSADDR ; thus, it will print two fewer bits to the screen
STR R0,R1, #0

ATTACK .FILL x1222
PUTSADDR .FILL x0459

;the sample program to show the manipulated program
LEA R0,BADSTRING   ; should print '123456'
PUTS               ; PUTS is manipulated, thus only print '3456'

BADSTRING .STRINGZ "123456"

HALT

.END
