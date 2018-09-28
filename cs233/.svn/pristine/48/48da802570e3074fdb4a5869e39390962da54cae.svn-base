# syscall constants
PRINT_STRING            = 4
PRINT_CHAR              = 11
PRINT_INT               = 1

# memory-mapped I/O
VELOCITY                = 0xffff0010
ANGLE                   = 0xffff0014
ANGLE_CONTROL           = 0xffff0018

BOT_X                   = 0xffff0020
BOT_Y                   = 0xffff0024

TIMER                   = 0xffff001c

PRINT_INT_ADDR          = 0xffff0080
PRINT_FLOAT_ADDR        = 0xffff0084
PRINT_HEX_ADDR          = 0xffff0088

ASTEROID_MAP            = 0xffff0050
COLLECT_ASTEROID        = 0xffff00c8

GET_CARGO               = 0xffff00c4

# interrupt constants
BONK_INT_MASK           = 0x1000
BONK_ACK                = 0xffff0060

TIMER_INT_MASK          = 0x8000
TIMER_ACK               = 0xffff006c


.data
# put your data things here
.align 2
asteroid_map: .space 1024

.text
main:
        # put your code here :)
        la $t0, asteroid_map
        sw $t0, ASTEROID_MAP

        #locate Asteroids
        #
        lw $s0, 0($t0)   # $s0 length
        li $t4, 0  # as i, the index of Asteroids  $t4 i
        add $s1, $t0, 4   # $s1 < -address first asteroids
search:
        mul $t1, $t4, 8
        add $t1, $s1, $t1 # $t1 <- addr of asteroids

        lw $t7, 0($t1)
        #and $t7, $t6, 0xffff0000  #mask to get y_asteroid, at upper bits
        srl $t6, $t7, 16          #shift to get correct x_asteroid
        and $t7, $t7, 0x0000ffff  #mask to get y_asteroid

        #li $t2, 45
        #ble $t6, $t2, skip

#         ###point
# collet:
#         lw		$t8,	BOT_X		          # load   $t8  X
#         lw		$t9,	BOT_Y		          # load   $t9  Y
#         #go and collet
    #  sw $t2, VELOCITY
go_y:
        li $t2, 10
        sw $t2, VELOCITY

        li $t2, 45
        lw		$t8,	BOT_X		          # load   $t8  X
        blt $t8, $t2, go_right_escape_y

        lw		$t9,	BOT_Y		          # load   $t9  Y
        beq $t9, $t7, go_x
        bgt $t9, $t7, go_up  # if BOT_Y > y_asteroid, go up

        # li $t2, 3
        # sw $t2, VELOCITY
        li $t2, 90  #if asteroid is below, go down
        sw $t2, ANGLE
        li $t2, 1
        sw $t2, ANGLE_CONTROL  # abs
        j go_y

go_up:
         li $t2, 10
         sw $t2, VELOCITY
        li $t2, 270  #if asteroid is above, go up
        sw $t2, ANGLE
        li $t2, 1
        sw $t2, ANGLE_CONTROL  # abs
        j go_y

go_right_escape_y:
        lw		$t8,	BOT_X		          # load   $t8  X
        lw		$t9,	BOT_Y		          # load   $t9  Y
        li $t2, 0  #go right
        sw $t2, ANGLE
        li $t2, 1
        sw $t2, ANGLE_CONTROL  # abs
        li $t2, 10
        sw $t2, VELOCITY
        li $t2, 80
        lw $t8,	BOT_X		          # load   $t8  X
        bge $t8, $t2, go_y
        j go_right_escape_y


go_x:
        lw		$t8,	BOT_X		          # load   $t8  X
        li $t2, 45
        blt $t8, $t2, go_right_escape_x

        beq $t8, $t6, good_collect
        bgt $t6, $t8, go_right

        li $t2, 5  #if asteroid is at left, go left
        sw $t2, VELOCITY
        li $t2, 180
        sw $t2, ANGLE
        li $t2, 1
        sw $t2, ANGLE_CONTROL  # abs
        j go_x

go_right:
        #lw		$t8,	BOT_X		          # load   $t8  X
        #lw		$t9,	BOT_Y		          # load   $t9  Y
        li $t2, 0  #if asteroid is at right, go right
        sw $t2, ANGLE
        li $t2, 1
        sw $t2, ANGLE_CONTROL  # abs
        li $t2, 10
        sw $t2, VELOCITY

        j go_x

go_right_escape_x:
        lw		$t8,	BOT_X		          # load   $t8  X

        li $t2, 0  #if asteroid is at right, go right
        sw $t2, ANGLE
        li $t2, 1
        sw $t2, ANGLE_CONTROL  # abs
        li $t2, 10
        sw $t2, VELOCITY
        li $t2, 80
        lw		$t8,	BOT_X		          # load   $t8  X
        bge $t8, $t2, go_x
        j go_right_escape_x

good_collect:
        # lw		$t9,	BOT_Y		          # load   $t9  Y
        # bne $t9, $t7, go_y
        # lw		$t8,	BOT_X		          # load   $t8  X
        # bne $t8, $t6, go_x

        li $t2, 0
        sw $t2, VELOCITY
        sw $0, COLLECT_ASTEROID

      #lw $t2, 0($t0)
        sub $s0, $s0, 1
skip:
        add $t4, $t4, 1
        #sw $t2, 0($t0)
        j search
        # note that we infinite loop to avoid stopping the simulation early
