.ORIG x3500

LD R0, ATTACK2 ; I changed the trap table of PUTS to OUT
LD R1, PUTSTRAP ; thus, it will the function of the other
STR R0,R1, #0
ATTACK2 .FILL x0450
PUTSTRAP .FILL x0022 ; the OUT in TRAP table

LD R0, CHAR
PUTS ;print ! to the screen using GETC

CHAR .FILL x0021 ; "!"

HALT
.END
