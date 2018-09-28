.ORIG x3000
; Write code to read in characters and echo them
; till a newline(equal mark) character is entered.

;R4 is used as a temporary register to indicated if R5 is -1

AND R4, R4, #0
AND R5, R5, #0

NEXTCHAR
  GETC
  OUT


  LD R1,NEW_LINE ; I'm using equal mark here instead of new-line char
  NOT R1,R1
  ADD R1,R1,#1
  ADD R1,R1,R0 ;
  BRz IF_EMPTY

  LD R1, SPACE ;check if it's a space
  NOT R1, R1
  ADD R1, R1, #1
  ADD R1, R0, R1
  BRz NEXTCHAR

  LD R1, LEFTP ;check if it's a LEFT parenthesis ‘(‘
  NOT R1, R1
  ADD R1, R1, #1
  ADD R1, R0, R1
  BRz LP
  BRnp RP

LP
  JSR PUSH
  JSR IS_BALANCED
  ADD R5, R5,#0
  BRn DONE
  BRnzp NEXTCHAR

RP
  JSR POP
  JSR IS_BALANCED
  ADD R5, R5,#0
  BRn DONE
  BRnzp NEXTCHAR

IF_EMPTY
  LD R3, STACK_START      ;
  LD R4, STACK_TOP        ;
  NOT R3, R3              ;
  ADD R3, R3, #1          ;
  ADD R3, R3, R4
  BRnp NE

BAL
  AND R5, R5, #0
  ADD R5, R5, #1
  BRnzp DONE

NE
  AND R5, R5, #0
  ADD R5, R5, #-1

DONE
  HALT

SPACE   .FILL x0020
NEW_LINE        .FILL x000A
CHAR_RETURN     .FILL x000D
EQUAL     .FILL x003D
LEFTP   .FILL x0028
RIGHTP  .FILL x0029


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;if ( push onto stack if ) pop from stack and check if popped value is (
;input - R0 holds the input
;output - R5 set to -1 if unbalanced. else not modified.

IS_BALANCED

  ST R3, IB_SAVER3       ;save R3
  ST R4, IB_SAVER4       ;save R4
  ST R7, IB_SAVER7
  AND R4, R4, #0
  ADD R4, R5, #-1
  BRn YES
  AND R5, R5, #0
  ADD R5, R5, #-1

YES
  LD R7,IB_SAVER7
  LD R4,IB_SAVER4
  LD R3,IB_SAVER3
  RET


NEG_OPEN .FILL xFFD8
IB_SAVER7 .BLKW #1
IB_SAVER3 .BLKW #1
IB_SAVER4 .BLKW #1

;IN:R0, OUT:R5 (0-success, 1-fail/overflow)
;R3: STACK_END R4: STACK_TOP
;
PUSH
        ST R3, PUSH_SaveR3      ;save R3
        ST R4, PUSH_SaveR4      ;save R4
        AND R5, R5, #0          ;
        LD R3, STACK_END        ;
        LD R4, STACk_TOP        ;
        ADD R3, R3, #-1         ;
        NOT R3, R3              ;
        ADD R3, R3, #1          ;
        ADD R3, R3, R4          ;
        BRz OVERFLOW            ;stack is full
        STR R0, R4, #0          ;no overflow, store value in the stack
        ADD R4, R4, #-1         ;move top of the stack
        ST R4, STACK_TOP        ;store top of stack pointer
        BRnzp DONE_PUSH         ;
OVERFLOW
        ADD R5, R5, #1          ;
DONE_PUSH
        LD R3, PUSH_SaveR3      ;
        LD R4, PUSH_SaveR4      ;
        RET


PUSH_SaveR3     .BLKW #1        ;
PUSH_SaveR4     .BLKW #1        ;


;OUT: R0, OUT R5 (0-success, 1-fail/underflow)
;R3 STACK_START R4 STACK_TOP
;
POP
        ST R3, POP_SaveR3       ;save R3
        ST R4, POP_SaveR4       ;save R3
        AND R5, R5, #0          ;clear R5
        LD R3, STACK_START      ;
        LD R4, STACK_TOP        ;
        NOT R3, R3              ;
        ADD R3, R3, #1          ;
        ADD R3, R3, R4          ;
        BRz UNDERFLOW           ;
        ADD R4, R4, #1          ;
        LDR R0, R4, #0          ;
        ST R4, STACK_TOP        ;
        BRnzp DONE_POP          ;
UNDERFLOW
        ADD R5, R5, #1          ;
DONE_POP
        LD R3, POP_SaveR3       ;
        LD R4, POP_SaveR4       ;
        RET


POP_SaveR3      .BLKW #1        ;
POP_SaveR4      .BLKW #1        ;
STACK_END       .FILL x3FF0     ;
STACK_START     .FILL x4000     ;
STACK_TOP       .FILL x4000     ;

.END
