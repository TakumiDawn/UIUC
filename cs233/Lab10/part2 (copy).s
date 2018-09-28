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

STATION_LOC             = 0xffff0054
DROPOFF_ASTEROIDS       = 0xffff005c

GET_CARGO               = 0xffff00c4

# interrupt constants
BONK_INT_MASK           = 0x1000
BONK_ACK                = 0xffff0060

TIMER_INT_MASK          = 0x8000
TIMER_ACK               = 0xffff006c

STATION_ENTER_INT_MASK  = 0x400
STATION_ENTER_ACK       = 0xffff0058

STATION_EXIT_INT_MASK   = 0x2000
STATION_EXIT_ACK        = 0xffff0064


.data
# put your data things here
asteroid_map:
.space 1024
flag_station_in_map:
.space	4  # is 1 when station moves in the map, otherwise 0
.word	0
flag_ready_to_drop:
.space	4  # is 1 when ready to drop asteroids on the station (didn't drop in one station cycle), otherwise 0 (if have dropped)
.word	0

.text
main:
        # enable interrupts
      	li	$t2, TIMER_INT_MASK		# timer interrupt enable bit
      	or	$t2, $t2, BONK_INT_MASK	# bonk interrupt bit
        or  $t2, $t2, STATION_ENTER_INT_MASK
        or  $t2, $t2, STATION_EXIT_INT_MASK
      	or	$t2, $t2, 1		# global interrupt enable
      	mtc0	$t2, $12		# set interrupt mask (Status register)
      	 # # request timer interrupt
      	 # lw	$t0, TIMER		# read current time
      	 # add	$t0, $t0, 2		# add 2 to current time
      	 # sw	$t0, TIMER		# request timer interrupt in 50 cycles

      	sw	$zero, flag_ready_to_drop    # intialize the flag_ready_to_drop to 0
        #li $s6, 0
        sw	$zero, flag_station_in_map   # intialize the flag_station_in_map to 0
        #li $s7, 0

        la $t0, asteroid_map
        sw $t0, ASTEROID_MAP
        lw $s0, 0($t0)   # $s0 length
        li $t4, 0  # as i, the index of Asteroids          $t4  i
        add $s1, $t0, 4   # $s1 < -address first asteroids

should_do_collect_or_drop:
        lw $t3, flag_station_in_map
        lw $t2, flag_ready_to_drop
        and $t5, $t2, $t3
        beq $zero, $t5, go_pick
        j go_station # only if the station is in map and we are ready to drop (didn't drop in one station cycle)


#if both flag = 1, station is in the map and ready, go and dropoff
go_station:
         # lw $t7,STATION_LOC
         # srl $t6, $t7, 16          #shift to get correct x_station
         # and $t7, $t7, 0x0000ffff  #mask to get y_station

        li $t6, 281#121#289   # set this as the place to dropoff  (289, 220)  281 195
        li $t7, 195#143#220
        j go_y_station

go_pick:
        mul $t1, $t4, 8
        add $t1, $s1, $t1 # $t1 <- addr of asteroids

        lw $t7, 0($t1)
        srl $t6, $t7, 16          #shift to get correct x_asteroid
        and $t7, $t7, 0x0000ffff  #mask to get y_asteroid
        j go_y_pick

#start to go to the target point, may be asteroid or station
go_y_pick:
        li $t2, 10
        sw $t2, VELOCITY
        #update location of station
         # lw $s7,STATION_LOC
         # srl $s6, $s7, 16          #shift to get correct x_station
         # and $s7, $s7, 0x0000ffff  #mask to get y_station

        li $t2, 45
        lw		$t8,	BOT_X		          # load   $t8  X
        blt $t8, $t2, go_right_escape_y_pick

        lw		$t9,	BOT_Y		          # load   $t9  Y
        beq $t9, $t7, go_x_pick
        bgt $t9, $t7, go_up_pick  # if BOT_Y > y_asteroid, go up

        li $t2, 90  #if asteroid is below, go down
        sw $t2, ANGLE
        li $t2, 1
        sw $t2, ANGLE_CONTROL  # abs
        j go_y_pick

go_up_pick:
         li $t2, 10
         sw $t2, VELOCITY
        li $t2, 270  #if asteroid is above, go up
        sw $t2, ANGLE
        li $t2, 1
        sw $t2, ANGLE_CONTROL  # abs
        j go_y_pick

go_right_escape_y_pick:
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
        bge $t8, $t2, go_y_pick
        j go_right_escape_y_pick

go_x_pick:
        lw		$t8,	BOT_X		          # load   $t8  X
        li $t2, 45
        blt $t8, $t2, go_right_escape_x_pick

        beq $t8, $t6, should_collect
        bgt $t6, $t8, go_right_pick

        # lw $s7,STATION_LOC
        # srl $s6, $s7, 16          #shift to get correct x_station
        # and $s7, $s7, 0x0000ffff  #mask to get y_station

        li $t2, 5  #if asteroid is at left, go left
        sw $t2, VELOCITY
        li $t2, 180
        sw $t2, ANGLE
        li $t2, 1
        sw $t2, ANGLE_CONTROL  # abs
        j go_x_pick

go_right_pick:
        li $t2, 0  #if asteroid is at right, go right
        sw $t2, ANGLE
        li $t2, 1
        sw $t2, ANGLE_CONTROL  # abs
        li $t2, 10
        sw $t2, VELOCITY
        j go_x_pick

go_right_escape_x_pick:
        li $t2, 0  #if asteroid is at right, go right
        sw $t2, ANGLE
        li $t2, 1
        sw $t2, ANGLE_CONTROL  # abs
        li $t2, 10
        sw $t2, VELOCITY
        li $t2, 80
        lw		$t8,	BOT_X		          # load   $t8  X
        bge $t8, $t2, go_x_pick
        j go_right_escape_x_pick

should_collect:
        li $t2, 0
        sw $t2, VELOCITY
        sw $zero, COLLECT_ASTEROID

        lw $t2, GET_CARGO
        li $t3, 60
        blt $t2, $t3, not_above_60
above_60:
      	li	$t2, 1
      	sw	$t2, flag_ready_to_drop
        #move $s6, $t2
not_above_60:
        sub $s0, $s0, 1
        add $t4, $t4, 1
        j should_do_collect_or_drop


#start to go to the target point, may be asteroid or station
go_y_station:
#li $s3, 404 # for debug
        li $t2, 10
        sw $t2, VELOCITY

        li $t2, 45
        lw	$t8,	BOT_X		          # load   $t8  X
        blt $t8, $t2, go_right_escape_y_station

        #update location of station
         # lw $s7,STATION_LOC
         # srl $s6, $s7, 16          #shift to get correct x_station
         # and $s7, $s7, 0x0000ffff  #mask to get y_station

        lw		$t9,	BOT_Y		          # load   $t9  Y
        beq $t9, $t7, go_x_station
        bgt $t9, $t7, go_up_station  # if BOT_Y > y_asteroid, go up

        li $t2, 90  #if asteroid is below, go down
        sw $t2, ANGLE
        li $t2, 1
        sw $t2, ANGLE_CONTROL  # abs
        j go_y_station

go_up_station:
        li $t2, 10
        sw $t2, VELOCITY
        li $t2, 270  #if asteroid is above, go up
        sw $t2, ANGLE
        li $t2, 1
        sw $t2, ANGLE_CONTROL  # abs
        j go_y_station

go_right_escape_y_station:
        li $t2, 0  #go right
        sw $t2, ANGLE
        li $t2, 1
        sw $t2, ANGLE_CONTROL  # abs
        li $t2, 10
        sw $t2, VELOCITY
        li $t2, 280
        lw $t8,	BOT_X		          # load   $t8  X
        bge $t8, $t2, go_y_station
        j go_right_escape_y_station

go_x_station:
        lw		$t8,	BOT_X		          # load   $t8  X
        li $t2, 45
        blt $t8, $t2, go_right_escape_x_station

        # lw $t7,STATION_LOC
        # srl $t6, $t7, 16          #shift to get correct x_station
        # and $t7, $t7, 0x0000ffff  #mask to get y_station
        #
        #lw		$t8,	BOT_X		          # load   $t8  X
        beq $t8, $t6, should_drop_or_wait
        bgt $t6, $t8, go_right_station

        li $t2, 8  #if asteroid is at left, go left
        sw $t2, VELOCITY
        li $t2, 180
        sw $t2, ANGLE
        li $t2, 1
        sw $t2, ANGLE_CONTROL  # abs
        j go_x_station

go_right_station:
        li $t2, 0  #if asteroid is at right, go right
        sw $t2, ANGLE
        li $t2, 1
        sw $t2, ANGLE_CONTROL  # abs
        li $t2, 7
        sw $t2, VELOCITY
        j go_x_station

go_right_escape_x_station:
        li $t2, 0  #if asteroid is at right, go right
        sw $t2, ANGLE
        li $t2, 1
        sw $t2, ANGLE_CONTROL  # abs
        li $t2, 10
        sw $t2, VELOCITY
        li $t2, 280
        lw		$t8,	BOT_X		          # load   $t8  X
        bge $t8, $t2, go_x_station
        j go_right_escape_x_station

# should_collect_or_drop:
#        lw $t3, flag_station_in_map
#        lw $t2, flag_ready_to_drop
#        and $t2, $t2, $t3
#        beq $zero, $t2, should_collect
#        j should_drop # only if the station is in map and we are ready to drop (didn't drop in one station cycle)


should_drop_or_wait:
        li $t2, 0
        sw $t2, VELOCITY

        lw $s5,STATION_LOC
        srl $s4, $s5, 16          #shift to get correct x_station
        and $s5, $s5, 0x0000ffff  #mask to get y_station
        beq $s4, $t6, check_y
        j should_wait
check_y:
        beq $s5, $t7, should_drop

should_wait:
go_x_wait:
        lw		$t8,	BOT_X		          # load   $t8  X

        # lw $t7,STATION_LOC
        # srl $t6, $t7, 16          #shift to get correct x_station
        # and $t7, $t7, 0x0000ffff  #mask to get y_station
        #
        beq $t8, $t6, should_drop_or_wait
        bgt $t6, $t8, go_right_wait

        li $t2, 1  #if asteroid is at left, go left
        sw $t2, VELOCITY
        li $t2, 180
        sw $t2, ANGLE
        li $t2, 1
        sw $t2, ANGLE_CONTROL  # abs
        j go_x_wait

go_right_wait:
        li $t2, 0  #if asteroid is at right, go right
        sw $t2, ANGLE
        li $t2, 1
        sw $t2, ANGLE_CONTROL  # abs
        li $t2, 1
        sw $t2, VELOCITY
        j go_x_wait

should_drop:
        li $t2, 0
        sw $t2, VELOCITY
        sw $zero, DROPOFF_ASTEROIDS

        sw $zero, flag_ready_to_drop  # if dropped, we don't need to drop again
        #li $s6, 0
        j should_do_collect_or_drop



.kdata				# interrupt handler data (separated just for readability)
chunkIH:	.space 8	# space for two registers
non_intrpt_str:	.asciiz "Non-interrupt exception\n"
unhandled_str:	.asciiz "Unhandled interrupt type\n"


.ktext 0x80000180
interrupt_handler:
.set noat
        	move	$k1, $at		# Save $at
.set at
        	la	$k0, chunkIH
        	sw	$a0, 0($k0)		# Get some free registers
        	sw	$a1, 4($k0)		# by storing them to a global variable

        	mfc0	$k0, $13		# Get Cause register
        	srl	$a0, $k0, 2
        	and	$a0, $a0, 0xf		# ExcCode field
        	bne	$a0, 0, non_intrpt

interrupt_dispatch:			# Interrupt:
        	mfc0	$k0, $13		# Get Cause register, again
        	beq	$k0, 0, done		# handled all outstanding interrupts

        	and	$a0, $k0, BONK_INT_MASK	# is there a bonk interrupt?
        	bne	$a0, 0, bonk_interrupt

        	and	$a0, $k0, TIMER_INT_MASK	# is there a timer interrupt?
        	bne	$a0, 0, timer_interrupt

          and 	$a0, $k0, STATION_ENTER_INT_MASK	# STATION_ENTER interrupt?
          bne 	$a0, 0, station_enter_interrupt
          and 	$a0, $k0, STATION_EXIT_INT_MASK	# STATION_EXIT interrupt?
          bne 	$a0, 0, station_exit_interrupt

        	# add dispatch for other interrupt types here.

        	li	$v0, PRINT_STRING	# Unhandled interrupt types
        	la	$a0, unhandled_str
        	syscall
        	j	done

station_enter_interrupt:
          sw $a1, STATION_ENTER_ACK
          li $a0, 1
          sw $a0, flag_station_in_map
          #li $s7, 1
          j  interrupt_dispatch

station_exit_interrupt:
          sw $a1, STATION_EXIT_ACK
          sw $zero, flag_station_in_map
          #li $s7, 0
          j  interrupt_dispatch

bonk_interrupt:
          sw      $a1, 0xffff0060($zero)   # acknowledge interrupt
          li      $a1, 10                  #  ??
          lw      $a0, 0xffff001c($zero)   # what
          and     $a0, $a0, 1              # does
          bne     $a0, $zero, bonk_skip    # this
          li      $a1, -10                 # code
bonk_skip:                             #  do
          sw      $a1, 0xffff0010($zero)   #  ??
          j       interrupt_dispatch       # see if other interrupts are waiting

timer_interrupt:
        	sw	$a1, TIMER_ACK		# acknowledge interrupt

        	li	$t0, 90			# ???
        	sw	$t0, ANGLE		# ???
        	sw	$zero, ANGLE_CONTROL	# ???

        	lw	$v0, TIMER		# current time
        	add	$v0, $v0, 1000
        	sw	$v0, TIMER		# request timer in 50000 cycles

        	j	interrupt_dispatch	# see if other interrupts are waiting

non_intrpt:				# was some non-interrupt
        	li	$v0, PRINT_STRING
        	la	$a0, non_intrpt_str
        	syscall				# print out an error message
        	# fall through to done

done:
        	la	$k0, chunkIH
        	lw	$a0, 0($k0)		# Restore saved registers
        	lw	$a1, 4($k0)
        .set noat
        	move	$at, $k1		# Restore $at
        .set at
        	eret