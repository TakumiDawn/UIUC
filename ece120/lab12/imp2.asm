.ORIG x3000 ;program starts at location x3000

LD R1, NUMBER ;load R1 with data at memory location specified by NUMBER
LOOP ADD R1, R1, #-1 ;decrement R1 by 1
BRzp LOOP ;branch to LOOP if R1 is zero or positive
ST R1, NUMBER ;store R1 at memory location specified by NUMBER
HALT ;halt program
NUMBER .FILL x0005 ;memory location specified by label NUMBER:(in this case data=x0005)
.END
