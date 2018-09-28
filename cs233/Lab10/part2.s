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
lw $s7,STATION_LOC
srl $s6, $s7, 16          #shift to get correct x_station
and $s7, $s7, 0x0000ffff  #mask to get y_station


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
         lw $s7,STATION_LOC
         srl $s6, $s7, 16          #shift to get correct x_station
         and $s7, $s7, 0x0000ffff  #mask to get y_station

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

        lw $s7,STATION_LOC
        srl $s6, $s7, 16          #shift to get correct x_station
        and $s7, $s7, 0x0000ffff  #mask to get y_station

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
         lw $s7,STATION_LOC
         srl $s6, $s7, 16          #shift to get correct x_station
         and $s7, $s7, 0x0000ffff  #mask to get y_station

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

        lw $s7,STATION_LOC
        srl $s6, $s7, 16          #shift to get correct x_station
        and $s7, $s7, 0x0000ffff  #mask to get y_station

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
lw $s7,STATION_LOC
srl $s6, $s7, 16          #shift to get correct x_station
and $s7, $s7, 0x0000ffff  #mask to get y_station

        li $t2, 0  #if asteroid is at right, go right
        sw $t2, ANGLE
        li $t2, 1
        sw $t2, ANGLE_CONTROL  # abs
        li $t2, 7
        sw $t2, VELOCITY
        j go_x_station

go_right_escape_x_station:
lw $s7,STATION_LOC
srl $s6, $s7, 16          #shift to get correct x_station
and $s7, $s7, 0x0000ffff  #mask to get y_station

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

        lw $s7,STATION_LOC
        srl $s6, $s7, 16          #shift to get correct x_station
        and $s7, $s7, 0x0000ffff  #mask to get y_station

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
lw $s7,STATION_LOC
srl $s6, $s7, 16          #shift to get correct x_station
and $s7, $s7, 0x0000ffff  #mask to get y_station

        li $t2, 0  #if asteroid is at right, go right
        sw $t2, ANGLE
        li $t2, 1
        sw $t2, ANGLE_CONTROL  # abs
        li $t2, 1
        sw $t2, VELOCITY
        j go_x_wait

should_drop:
lw $s7,STATION_LOC
srl $s6, $s7, 16          #shift to get correct x_station
and $s7, $s7, 0x0000ffff  #mask to get y_station

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



          # lw $t8, STATION_LOC # get STATION_LOC
# and $t9, $t8, 0xffff # get y
# srl $t8, $t8, 16 # bit-wise shift to get x (KEEP IN SAME K REGISTER
# # li $v0, 1
# # move $a0, $t8
# # syscall
#
# # bne $t8, 240, loop
# # li $v0, 1
# # move $a0, $t8
# # syscall
#
#
# li $a0, 32
# li $v0, 11  # syscall number for printing character
# syscall
#
#
# # li $v0, 1
# # move $a0, $t9
# # syscall
#
#
# li $v0, 4       # you can call it your way as well with addi
# la $a0, newline       # load address of the string
# syscall

# 
#
# .globl count_disjoint_regions
# count_disjoint_regions:
#         sub $sp, $sp, 36
#         sw  $ra, 0($sp)
#         sw  $s0, 4($sp)
#         sw  $s1, 8($sp)
#         sw  $s2, 12($sp)
#         sw  $s3, 16($sp)
#         sw  $s4, 20($sp)
#         sw  $s5, 24($sp)
#         sw  $s6, 28($sp)
#         sw  $s7, 32($sp)
#
#         move $s5, $a0                              # $s5 = lines !
#         move $s6, $a1                              #  $s6 = Canvas * canvas
#         move $s7, $a2                              #  $s7 = Solution * solution
#         li $s0, 0                                  # i= 0        $s0 i !
#         lw $s1, 0($s5)                             # $s1 = num_lines
# cdr_for:
#         bge  $s0, $s1, cdr_done   # if $s0 >=$s1;  i >= lines->num_lines, then done
#
#         lw  $t0, 4($s5)           # $t0 <- lines->coords[0]
#         mul $t1, $s0, 4           # $t1 <- $s0*4    i*4
#         add $t1, $t1, $t0         #   lines->coords[0][i]
#         lw  $a0, 0($t1)           # $a0 <- start_pos = M[lines->coords[0][i]];
#
#         lw  $t0, 8($s5)           # $t0 <- lines->coords[1]
#         mul $t1, $s0, 4           # $t1 <- $s0*4    i*4
#         add $t1, $t1, $t0         #   lines->coords[1][i];
#         lw  $a1, 0($t1)           # $a1 <- end_pos = M[lines->coords[1][i]];
#         move $a2, $s6             # $a2 <- $s6 = Canvas * canvas
#         jal draw_line
#
#         remu $t3, $s0, 2          # $t3 <- (i % 2)
#         li $t5, 'A'
#         add $a0, $t3, $t5         # $a0 <- 'A' + (i % 2)
#         move $a1, $s6             # count_disjoint_regions_step('A' + (i % 2), canvas);
#         jal count_disjoint_regions_step
#
#         lw  $t0, 4($s7)           # $t0 <- solution->counts[0]
#         mul $t1, $s0, 4           # $t1 <- $s0*4    i*4
#         add $t0, $t1, $t0         # $t0 <- solution->counts[i]
#         sw $v0, 0($t0)            # solution->counts[i] = count
#
#         add $s0, $s0, 1           # i++
#         j cdr_for
#
# cdr_done:
#         lw  $ra, 0($sp)
#         lw  $s0, 4($sp)
#         lw  $s1, 8($sp)
#         lw  $s2, 12($sp)
#         lw  $s3, 16($sp)
#         lw  $s4, 20($sp)
#         lw  $s5, 24($sp)
#         lw  $s6, 28($sp)
#         lw  $s7, 32($sp)
#         add $sp $sp 36
#         jr      $ra
# ################################################################################
# .globl count_disjoint_regions_step
# count_disjoint_regions_step:
#         sub $sp, $sp, 36
#         sw  $ra, 0($sp)
#         sw  $s0, 4($sp)
#         sw  $s1, 8($sp)
#         sw  $s2, 12($sp)
#         sw  $s3, 16($sp)
#         sw  $s4, 20($sp)
#         sw  $s5, 24($sp)
#         sw  $s6, 28($sp)
#         sw  $s7, 32($sp)
#
#
#         move $s6, $a0                                                           # $s6  marker!
#         move $s7, $a1                                                           # $s7  a1 canvas!
#         li $s3, 0                                                               # region_count = 0;    $s3 region_count!
#
#         li $s4, 0                                                               # row = 0  $s4 row!
# cdrs_row_for:
#         lw $t0, 0($s7)                                                          # $t0 <- canvas->height
#         bge  $s4, $t0, cdrs_done                                                # $s4 >= canvas->height   then done
#
#         li $s5, 0                                                               # col = 0   $s5 col!
# cdrs_col_for:
#         lw $t0, 4($s7)                                                          # $t0 <- canvas->width
#         bge  $s5, $t0, cdrs_row_for_done                                        # $s5 >= canvas->width   then go to for_done
#
#         mul $t0, $s4, 4                                                         #  $t0 <- $s4*4;  char*
#         lw $t5, 12($s7)                                                         #   $t5 canvas
#         add $t0, $t5, $t0                                                       # $t0 <- $t5 + $t0     canvas[row]
#         lw $t0, 0($t0)                                                          # $t0 <- M[canvas[row]]
#         add $t0, $t0, $s5                                                       # $t0 <- $t0 + $s5  $t0 canvas[row][col]!
#         lb  $t1, 0($t0)                                                         # $t1 <- M [ canvas[row][col] ]       $t1 curr_char!
#
#         beq $t1, $s6, cdrs_col_for_done                                         # if $t1 == $a2  curr_char == marker
#         lb $t2, 8($s7)                                                          # $t2 <- canvas->pattern
#         beq $t1, $t2, cdrs_col_for_done                                         # $t1 == $t2  curr_char == pattern
#
#         add $s3, $s3, 1
#
#         move $a0, $s4
#         move $a1, $s5
#         move $a2, $s6
#         move $a3, $s7
#         jal flood_fill
#
# cdrs_col_for_done:
#         add $s5, $s5, 1                                                         # $s1++  col++
#         j cdrs_col_for
#
# cdrs_row_for_done:
#         add $s4, $s4, 1                                                         # $s4++   row++
#         j cdrs_row_for
#
# cdrs_done:
#         move $v0, $s3
#         lw  $ra, 0($sp)
#         lw  $s0, 4($sp)
#         lw  $s1, 8($sp)
#         lw  $s2, 12($sp)
#         lw  $s3, 16($sp)
#         lw  $s4, 20($sp)
#         lw  $s5, 24($sp)
#         lw  $s6, 28($sp)
#         lw  $s7, 32($sp)
#         add $sp $sp 36
#         jr      $ra
#
# ################################################################################
# .globl draw_line
# draw_line:
#         lw $t0, 4($a2)            # $t0 <- canvas->width    ; width!
#         li $t1, 1                 # $t1 <- 1   ; step_size!
#         subu $t3, $a1, $a0        # $t3 <- end_pos - start_pos
#         blt $t3, $t0, dl_pre_for  # if $t3 < $t0 then
#         move $t1, $t0             # step_size = width
# dl_pre_for:
#         move $t3, $a0             # $t3 <- pos = start_pos;      pos!
#         addu $t2, $a1, $t1        # $t2 <- end_pos + step_size;  !
#         lbu $t4, 8($a2)           # $t4 <- canvas->pattern       pattern!
#         lw $t9, 12($a2)           #  $t9 <- canvas->canvas     canvas->canvas!
# dl_for:
#         beq $t3, $t2, dl_done
#
#         divu $t5, $t3, $t0       #  $t5 <- pos / width;      i
#         mul $t5, $t5, 4          #  $t5 <- $t5*4;            i *4  char*
#         addu $t8, $t9, $t5       #  $t8 <- $t9 + $t5;   canvas[pos / width]
#         lw $t8, 0($t8)           #  $t8 <- M[canvas[pos / width]]
#
#         remu $t6, $t3, $t0       #  $t6 <- pos % width;      j
#         addu $t6, $t6, $t8       #  $t6 <- $t6 + $t8;  canvas[pos / width][pos % width]
#         sb $t4, 0($t6)           #  M[$t6] <- $t4
#
#         addu $t3, $t3, $t1       # $t3 <- pos += step_size
#         j dl_for
# dl_done:
#         jr      $ra
#
# ################################################################################
# .globl flood_fill
# flood_fill:
#         sub   $sp, $sp, 12
#         sw    $ra, 0($sp)
#         sw    $s0, 4($sp)
#         sw    $s1, 8($sp)
#
#         move  $s0, $a0                                # $s0 <- $a0       $s0 row!
#         move  $s1, $a1                                # $s1 <- $a1       $s1 col!
#
#         blt $s0, $0, ff_done                          # if $s0 (row!) <0 then ff_done
#         blt $s1, $0, ff_done                          # if $s1 (col!) <0 then ff_done
#         lw $t0, 0($a3)                                # $t0 <- canvas->height
#         bge $s0, $t0, ff_done                         # if $s0 (row!) >= canvas->height
#         lw $t0, 4($a3)                                # $t0 <- canvas->width
#         bge $s1, $t0, ff_done                         # if $s1 (col!) >= canvas->width
#
#         mul $t0, $s0, 4                               #  $t0 <- $s0*4;  char*
#         lw $t3, 12($a3)                               # $t3 <- canvas
#         add $t0, $t3, $t0                             # $t0 <- $a3 + $t3    canvas[row]
#         lw $t0, 0($t0)                                # $t0 <- M[canvas[row]]
#         add $t0, $t0, $s1                             # $t0 <- $t0 + $s1           $t0 canvas[row][col]!
#         lb $t1, 0($t0)                                # $t1 <- M [ canvas[row][col] ]            $t1 curr!
#
#
#         beq $t1, $a2, ff_done                         # if $t1 == $a2  curr == marker
#         lb $t2, 8($a3)                                # $t2 <- canvas->pattern
#         beq $t1, $t2, ff_done                         # $t1 == $t2  curr == pattern
#         sb $a2, 0($t0)                                # M[$t0] <- $a2  canvas->canvas[row][col] = marker;
#
#         sub $a0, $s0, 1                               # $a0 <- row-1
#         move $a1, $s1                                 # $a1 <- col
#         jal flood_fill
#
#         move $a0, $s0                                 # $a0 <- row
#         add $a1, $s1, 1                               # $a1 <- col+1
#         jal flood_fill
#
#         add $a0, $s0, 1                               # $a0 <- row+1
#         move $a1, $s1                                 # $a1 <- col
#         jal flood_fill
#
#         move $a0, $s0                                 # $a0 <- row
#         sub $a1, $s1, 1                               # $a1 <- col-1
#         jal flood_fill
#
# ff_done:
#         lw  $ra 0($sp)
#         lw  $s0 4($sp)
#         lw  $s1 8($sp)
#         add $sp $sp 12
#         jr  $ra
