# syscall constants
PRINT_STRING            = 4
PRINT_CHAR              = 11
PRINT_INT               = 1

# debug constants
PRINT_INT_ADDR              = 0xffff0080
PRINT_FLOAT_ADDR            = 0xffff0084
PRINT_HEX_ADDR              = 0xffff0088

# spimbot memory-mapped I/O
VELOCITY                    = 0xffff0010
ANGLE                       = 0xffff0014
ANGLE_CONTROL               = 0xffff0018
BOT_X                       = 0xffff0020
BOT_Y                       = 0xffff0024
OTHER_BOT_X                 = 0xffff00a0
OTHER_BOT_Y                 = 0xffff00a4
TIMER                       = 0xffff001c
SCORES_REQUEST              = 0xffff1018

ASTEROID_MAP                = 0xffff0050
COLLECT_ASTEROID            = 0xffff00c8

STATION_LOC                 = 0xffff0054
DROPOFF_ASTEROID            = 0xffff005c

GET_ENERGY                  = 0xffff00c0
GET_CARGO                   = 0xffff00c4

REQUEST_PUZZLE              = 0xffff00d0
SUBMIT_SOLUTION             = 0xffff00d4

THROW_PUZZLE                = 0xffff00e0
UNFREEZE_BOT                = 0xffff00e8
CHECK_OTHER_FROZEN          = 0xffff101c

# interrupt constants
BONK_INT_MASK               = 0x1000
BONK_ACK                    = 0xffff0060

TIMER_INT_MASK              = 0x8000
TIMER_ACK                   = 0xffff006c

REQUEST_PUZZLE_INT_MASK     = 0x800
REQUEST_PUZZLE_ACK          = 0xffff00d8

STATION_ENTER_INT_MASK      = 0x400
STATION_ENTER_ACK           = 0xffff0058

STATION_EXIT_INT_MASK       = 0x2000
STATION_EXIT_ACK            = 0xffff0064

BOT_FREEZE_INT_MASK         = 0x4000
BOT_FREEZE_ACK              = 0xffff00e4


.data
.align 2
asteroid_map: .space 404
puzzle_data: .space 324
op_puzzle_data: .space 324
solution: .space 8

flag_station: .space 4
flag_cargo: .space 4
flag_puzzle: .space 4

three:	.float	3.0
five:	.float	5.0
PI:	.float	3.141592
F180:	.float  180.0


.text
main:
        # Enable interrupts
        li 	$t9,	BONK_INT_MASK
        or	$t9, 	$t9,	TIMER_INT_MASK
        or	$t9, 	$t9,	REQUEST_PUZZLE_INT_MASK
        or	$t9, 	$t9,	STATION_ENTER_INT_MASK
        or	$t9, 	$t9,	STATION_EXIT_INT_MASK
        or	$t9, 	$t9,	BOT_FREEZE_INT_MASK
        or	$t9,	$t9,	1
        mtc0	$t9,	$12

        sw      $zero,  flag_station
        sw      $zero,  flag_cargo
        sw      $zero,  flag_puzzle

        la      $t0,    puzzle_data             # Give the allocated space to REQUEST_PUZZLE
        sw      $t0,    REQUEST_PUZZLE          # to populate with the given structure

        li	$t0,	0			# $t0 = i
infinite:
        # bge	$t0,	$s0,	exit		# go on a loop only when i < length
        li	$t4,	10
        sw	$t4,	VELOCITY

        # Make a branch whether to collect astroids or wait the station
        jal     check_dropoff
        bnez	$v0,	go_to_station		# If both flags are true, then go to station and drop cargo
                                                # If not, pick another astroid
get_astroids:
        la	$s7,	asteroid_map		# Give the allocated space to ASTEROID_MAP
        sw	$s7,	ASTEROID_MAP		# to populate with the given map

        lw	$s0,	0($s7)			# $s0 = astroid_map->length
        add	$s1,	$s7,	4		# $s1 = &astroids[50]

        mul	$t1,	$t0,	8
        add	$t1,	$t1,	$s1		# &astroids[i]
        lw	$t2,	0($t1)			# $t2 = x and y

        srl	$s2,	$t2,	16		# $s2 = a.x
        blt	$s2,	40,	skip		# skip if a.x < 40
        bgt	$s2,	250,	skip		# skip if a.x > 200

        and	$s3,	$t2,	0xffff		# $s3 = a.y
        bgt	$s3,	250,	skip		# skip if a.y > 250

        lw	$s4,	4($t1)			# $s4 = a.points
################################################################################
##### Check y coordinate #####
################################################################################
check_y:
        lw	$t3,	BOT_Y
        bge	$t3,	$s3,	y_greater_loop	# !(SPIMbot.y < a.y)
y_smaller_loop:
        #jal     solve_puzzle
        jal     check_dropoff
        bnez	$v0,	go_to_station

        jal     manage_direction
        li	$t4,	90
        sub     $t4,    $t4,    $v0
        sw	$t4,	ANGLE			# manage_direction: +y
        li	$t4,	1
        sw	$t4,	ANGLE_CONTROL		# CONTROL: abs
        jal	escape				# escape from the supernova
        lw	$t3,	BOT_Y			# SPIMbot.y
        bge	$t3,	$s3,	check_x		# SPIMbot.y = a.y
        #$jal     check_if_opponent_took_asteroid
        #beq     $v0,    1,      skip
        j	y_smaller_loop

y_greater_loop:
        #jal     solve_puzzle
        jal     check_dropoff
        bnez	$v0,	go_to_station

        jal     manage_direction
        li	$t4,	270
        add     $t4,    $t4,    $v0
        sw	$t4,	ANGLE			# DIRECTION: -y
        li	$t4,	1
        sw	$t4,	ANGLE_CONTROL		# CONTROL: abs
        jal	escape				# escape from the supernova
        lw	$t3,	BOT_Y			# SPIMbot.y
        ble	$t3,	$s3,	check_x		# SPIMbot.y = a.y
        #jal     check_if_opponent_took_asteroid
        #beq     $v0,    1,      skip
        j	y_greater_loop
################################################################################
##### Check x coordinate #####
################################################################################
check_x:
        lw	$t2,	BOT_X			# SPIMbot.x
        bge	$t2,	$s2,	x_greater_loop	# !(SPIMbot.x < a.x)
x_smaller_loop:
        #jal     solve_puzzle
        jal     check_dropoff
        bnez	$v0,	go_to_station

        sw	$zero,	ANGLE			# DIRECTION: +x
        li	$t4,	1
        sw	$t4,	ANGLE_CONTROL		# CONTROL: abs
        lw	$t2,	BOT_X			# SPIMbot.x
        bge	$t2,	$s2,	collect		# SPIMbot.x = a.x
        #jal     check_if_opponent_took_asteroid
        #beq     $v0,    1,      skip
        j	x_smaller_loop

x_greater_loop:
        #jal     solve_puzzle
        jal     check_dropoff
        bnez	$v0,	go_to_station

        li	$t4,	180
        sw	$t4,	ANGLE			# DIRECTION: -x
        li	$t4,	1
        sw	$t4,	ANGLE_CONTROL		# CONTROL: abs
        lw	$t2,	BOT_X			# SPIMbot.x
        ble	$t2,	$s2,	collect		# SPIMbot.x = a.x
        #jal     check_if_opponent_took_asteroid
        #beq     $v0,    1,      skip
        j	x_greater_loop
################################################################################
##### Collect astroid and check cargo #####
################################################################################
collect:
        sw	$zero,	COLLECT_ASTEROID	# astroid collected

        lw 	$t5,	GET_CARGO		# get astroids from cargo
        ble	$t5,	200,	skip
        li	$t4,	1
        sw 	$t4,	flag_cargo		# set the flag to 1

        jal     check_dropoff
        bnez	$v0,	go_to_station

        j 	skip
################################################################################
##### Go to the station's location and wait for it to come #####
################################################################################
go_to_station:
        # Make a branch whether to collect astroids or wait the station
        li	$t6,	172			# appoximate station x 281
        li	$t7,	54			# appoximate station y 195
################################################################################
##### Match station y coordinate #####
################################################################################
check_y_:
        lw	$t3,	BOT_Y
        bge	$t3,	$t7,	y_greater_loop_
y_smaller_loop_:
        # jal     solve_puzzle
        jal     manage_direction
        li	$t4,	90
        sub     $t4,    $t4,    $v0
        li	$t4,	90
        sw	$t4,	ANGLE			# DIRECTION: +y
        li	$t4,	1
        sw	$t4,	ANGLE_CONTROL		# CONTROL: abs
        jal	escape				# escape from the supernova
        lw	$t3,	BOT_Y			# SPIMbot.y
        bge	$t3,	54,	drop_or_wait	# SPIMbot.y = s.y
        j	y_smaller_loop_

y_greater_loop_:
        # jal     solve_puzzle
        jal     manage_direction
        li	$t4,	270
        add     $t4,    $t4,    $v0
        li	$t4,	270
        sw	$t4,	ANGLE			# DIRECTION: -y
        li	$t4,	1
        sw	$t4,	ANGLE_CONTROL		# CONTROL: abs
        jal	escape				# escape from the supernova
        lw	$t3,	BOT_Y			# SPIMbot.y
        ble	$t3,	54,	drop_or_wait	# SPIMbot.y = a.y
        j	y_greater_loop_
################################################################################
##### Match station x coordinate #####
################################################################################
drop_or_wait:
      #  jal     solve_puzzle
        lw	$t2,	BOT_X			# SPIMbot.x
        lw	$s6,	STATION_LOC
        srl 	$s5,	$s6,	16		# s.x
        and 	$s6,	$s6,	0xffff		# s.y
        bne 	$t2,	172,	move_right	# b.x = t.x
        bne 	$s5,	172,	move_right	# s.x = t.x
        j 	drop

move_right:
        bge	$t2,	172,	move_left
        sw	$zero,	ANGLE			# DIRECTION: +x
        li	$t4,	1
        sw	$t4,	ANGLE_CONTROL		# CONTROL: abs
        j 	drop_or_wait

move_left:
        li 	$t4,	180
        sw	$t4,	ANGLE			# DIRECTION: +x
        li	$t4,	1
        sw	$t4,	ANGLE_CONTROL		# CONTROL: abs
        j	drop_or_wait
################################################################################
##### Drop astroid at the station #####
################################################################################
drop:
        sw	$zero,	DROPOFF_ASTEROID
        sw 	$zero,	flag_cargo
        j 	infinite
################################################################################
##### Increment i and proceed to next astroid #####
################################################################################
skip:
        jal     check_dropoff
        bnez	$v0,	go_to_station

        add	$t0,	$t0,	1		# i++
        j	infinite
################################################################################
################################################################################
##### HELPER FUNCTIONS #####
################################################################################
################################################################################
.globl escape
escape:
	sub    $sp,  $sp,      12
        sw      $ra, 	0($sp)
        sw 	$t2, 	4($sp)
        sw 	$t4, 	8($sp)

escape_loop:
        lw	$t2,	BOT_X
        bge     $t2,	45,	continue_travel
        sw	$zero,	ANGLE			# DIRECTION: +x
        li	$t4,	1
        sw	$t4,	ANGLE_CONTROL		# CONTROL: abs
        j	escape_loop

continue_travel:
	lw     $ra,    0($sp)
        lw      $t2,    4($sp)
        lw      $t4,    8($sp)
        add     $sp,    $sp,    12
        jr	$ra				# go back and continue
################################################################################
.globl check_dropoff
check_dropoff:
	sub 	$sp, 	$sp,        12
        sw 	$ra,	0($sp)
        sw 	$s5, 	4($sp)
        sw 	$s6,	8($sp)

check_flags:
        lw 	$s5,	flag_station
        lw 	$s6,	flag_cargo
        and 	$v0,	$s5,	$s6
        # lw      $s6,    flag_NotFirstEntry
        # and 	$v0,	$s5,	$s6

end_stack_stuff:
        lw 	$ra,	0($sp)
        lw 	$s5, 	4($sp)
        lw 	$s6, 	8($sp)
        add	$sp,	$sp,   12
        jr      $ra
################################################################################
# .globl solve_puzzle
# solve_puzzle:
# 	sub    $sp,    $sp,    12
#         sw      $ra,    0($sp)
#         sw      $t4,    4($sp)
#         sw      $t5,    8($sp)
#
#         lw      $t5,    GET_ENERGY
#         bge     $t5,    700,    nvm
#         lw      $t5,    flag_puzzle
#         bne     $t5,    1,      nvm
#
#         la      $a1,    puzzle_data
#         add     $a0,    $a1,    16
#         la      $a2,    solution
#
#         jal     count_disjoint_regions
#         la      $t4,    solution
#         add     $t4,    $t4,    4
#
#         lw 	$t5, 	GET_ENERGY
#         ble 	$t5, 	800, 	dont_throw # energy > 1000
#         lw 	$t4, 	CHECK_OTHER_FROZEN
#         beq 	$t4, 	1, 	dont_throw
#         sw 	$0, 	THROW_PUZZLE
# dont_throw:
#         sw      $t4,    SUBMIT_SOLUTION
#
#         sw      $zero,  -4($t4)
#         sw      $zero,  0($t4)
#         li      $t4,    0
#         sw      $t4,    flag_puzzle
# nvm:
#         lw 	$ra, 	0($sp)
#         lw 	$t4, 	4($sp)
#         lw 	$t5, 	8($sp)
#         add 	$sp, 	$sp, 	12
#         jr      $ra
################################################################################
.globl manage_direction
manage_direction:
        sub     $sp,    $sp,    20
        sw      $ra,    0($sp)
        sw      $t2,    4($sp)
        sw      $t4,    8($sp)
        sw      $a0,    12($sp)
        sw      $a1,    16($sp)

        lw      $t2,    BOT_X
        li      $t4,    60
        div     $t2,    $t4
        mflo    $t4
        li      $a0,    5
        sub     $a0,    $a0,    $t4
        jal     euclidean_dist
        move    $a0,    $v0
        li      $a1,    5
        sub     $a1,    $a1,    $t4
        jal     sb_arctan

        move    $v0,    $v0
        lw      $ra,    0($sp)
        lw      $t2,    4($sp)
        lw      $t4,    8($sp)
        lw      $a0,    12($sp)
        lw      $a1,    16($sp)
        add     $sp,    $sp,    20
        jr      $ra
################################################################################
.globl count_disjoint_regions
count_disjoint_regions:
        sub     $sp,    $sp,    60
        sw      $ra,    0($sp)
        sw      $s0,    4($sp)
        sw      $s1,    8($sp)
        sw      $s2,    12($sp)
        sw      $s3,    16($sp)
        sw      $s4,    20($sp)
        sw      $s5,    24($sp)
        sw      $s6,    28($sp)
        sw      $s7,    32($sp)
        sw      $t0,    36($sp)
        sw      $t1,    40($sp)
        sw      $t2,    44($sp)
        sw      $t3,    48($sp)
        sw      $t4,    52($sp)
        sw      $t5,    56($sp)

        move    $s0,    $a0             # s0 = lines
        move    $s1,    $a1             # s1 = canvas
        move    $s2,    $a2             # s2 = solution

        lw      $s4,    0($s0)          # s4 = lines->num_lines
        li      $s5,    0               # s5 = i
        lw      $s6,    4($s0)          # s6 = lines->coords[0]
        lw      $s7,    8($s0)          # s7 = lines->coords[1]
cdr_loop:
        bgeu    $s5,    $s4,    cdr_end
        mul     $t0,    $s5,    4       # t0 = i*4
        add     $t1,    $s6,    $t0     # t1 = &lines->coords[0][i]
        lw      $a0,    0($t1)          # a0 = start_pos = lines->coords[0][i]
        add     $t2,    $s7,    $t0     # t2 = &lines->coords[1][i]
        lw      $a1,    0($t2)          # a1 = end_pos = lines->coords[1][i]
        move    $a2,    $s1
        #jal     draw_line

        li      $t3,    2
        div     $s5,    $t3
        mfhi    $t3                     # t3 = i % 2
        addi    $a0,    $t3,    65      # a0 = 'A' + (i % 2)
        move    $a1,    $s1             # count_disjoint_regions_step('A' + (i % 2), canvas)
        #jal     count_disjoint_regions_step     # v0 = count
        lw      $t3,    4($s2)          # t3 = solution->counts
        mul     $t4,    $s5,    4
        add     $t4,    $t4,    $t3     # t4 = &solution->counts[i]
        sw      $v0,    0($t4)          # solution->counts[i] = count//////////////////////////////
        addi    $s5,    $s5,    1       # i++
        j       cdr_loop

cdr_end:
        lw      $ra,    0($sp)
        lw      $s0,    4($sp)
        lw      $s1,    8($sp)
        lw      $s2,    12($sp)
        lw      $s3,    16($sp)
        lw      $s4,    20($sp)
        lw      $s5,    24($sp)
        lw      $s6,    28($sp)
        lw      $s7,    32($sp)
        lw      $t0,    36($sp)
        lw      $t1,    40($sp)
        lw      $t2,    44($sp)
        lw      $t3,    48($sp)
        lw      $t4,    52($sp)
        lw      $t5,    56($sp)
        add     $sp,    $sp,    60
        jr      $ra
###############################################################################
.globl count_disjoint_regions_step
count_disjoint_regions_step:
        sub     $sp,    $sp,    44
        sw      $ra,    0($sp)
        sw      $s0,    4($sp)
        sw      $s1,    8($sp)
        sw      $s2,    12($sp)
        sw      $s3,    16($sp)
        sw      $s4,    20($sp)
        sw      $s5,    24($sp)
        sw      $s6,    28($sp)
        sw      $s7,    32($sp)
        sw      $t0,    36($sp)
        sw  	$t5,    40($sp)

        move    $s0,    $a0
        move    $s1,    $a1

        li      $s2,    0                       # $s2 = region_count
        li      $s3,    0                       # $s3 = row
        lw      $s4,    0($s1)                  # $s4 = canvas->height
        lw      $s6,    4($s1)                  # $s6 = canvas->width
        lw      $s7,    8($s1)                  # canvas->pattern

cdrs_outer_for_loop:
        bge     $s3,    $s4,    cdrs_outer_end
        li      $s5,    0                       # $s5 = col

cdrs_inner_for_loop:
        bge     $s5,    $s6,    cdrs_inner_end
        lw      $t0,    12($s1)                 # canvas->canvas
        mul     $t5,    $s3,    4               # row * 4
        add     $t5,    $t0,    $t5             # &canvas->canvas[row]
        lw      $t0,    0($t5)                  # canvas->canvas[row]
        add     $t0,    $t0,    $s5             # &canvas->canvas[row][col]
        lbu     $t0,    0($t0)                  # $t0 = canvas->canvas[row][col]
        beq     $t0,    $s7,    cdrs_skip_if    # curr_char != canvas->pattern
        beq     $t0,    $s0,    cdrs_skip_if    # curr_char != canvas->marker
        add     $s2,    $s2,    1               # region_count++
        move    $a0,    $s3
        move    $a1,    $s5
        move    $a2,    $s0
        move    $a3,    $s1
        jal     flood_fill

cdrs_skip_if:
        add     $s5,    $s5,    1               # col++
        j       cdrs_inner_for_loop

cdrs_inner_end:
        add     $s3,    $s3,    1               # row++
        j       cdrs_outer_for_loop

cdrs_outer_end:
        move    $v0,    $s2
        lw      $ra,    0($sp)
        lw      $s0,    4($sp)
        lw      $s1,    8($sp)
        lw      $s2,    12($sp)
        lw      $s3,    16($sp)
        lw      $s4,    20($sp)
        lw      $s5,    24($sp)
        lw      $s6,    28($sp)
        lw      $s7,    32($sp)
        lw      $t0,    36($sp)
        lw 	$t5, 	40($sp)
        add     $sp,    $sp,    44
        jr      $ra
###############################################################################
.globl draw_line
draw_line:
        sub     $sp,    $sp,    44
        sw      $ra,    0($sp)
        sw      $t0,    4($sp)
        sw      $t1,    8($sp)
        sw      $t2,    12($sp)
        sw      $t3,    16($sp)
        sw      $t4,    20($sp)
        sw      $t5,    24($sp)
        sw      $t6,    28($sp)
        sw      $t7,    32($sp)
        sw      $t8,    36($sp)
        sw      $t9,    40($sp)

        lw      $t0,    4($a2)          # t0 = width = canvas->width
        li      $t1,    1               # t1 = step_size = 1
        sub     $t2,    $a1,    $a0     # t2 = end_pos - start_pos
        blt     $t2,    $t0,    dl_cont
        move    $t1,    $t0             # step_size = width;
dl_cont:
        move    $t3,    $a0              # t3 = pos = start_pos
        add     $t4,    $a1,    $t1      # t4 = end_pos + step_size
        lw      $t5,    12($a2)          # t5 = &canvas->canvas
        lbu     $t6,    8($a2)           # t6 = canvas->pattern
dl_loop:
        beq     $t3,    $t4,    dl_end
        div     $t3,    $t0
        mfhi    $t7                     # t7 = pos % width
        mflo    $t8                     # t8 = pos / width
        mul     $t9,    $t8,    4	# t9 = pos/width*4
        add     $t9,    $t9,    $t5     # t9 = &canvas->canvas[pos / width]
        lw      $t9,    0($t9)          # t9 = canvas->canvas[pos / width]
        add     $t9,    $t9,    $t7
        sb      $t6,    0($t9)          # canvas->canvas[pos / width][pos % width] = canvas->pattern
        add     $t3,    $t3,    $t1     # pos += step_size
        j       dl_loop

dl_end:
        lw      $ra,    0($sp)
        lw      $t0,    4($sp)
        lw      $t1,    8($sp)
        lw      $t2,    12($sp)
        lw      $t3,    16($sp)
        lw      $t4,    20($sp)
        lw      $t5,    24($sp)
        lw      $t6,    28($sp)
        lw      $t7,    32($sp)
        lw      $t8,    36($sp)
        lw      $t9,    40($sp)
        add     $sp,    $sp,    44
        jr      $ra
###############################################################################
.globl flood_fill
flood_fill:
        sub     $sp,    $sp,    32
        sw      $ra,    0($sp)
        sw      $s0,    4($sp)
        sw      $s1,    8($sp)
        sw      $s2,    12($sp)
        sw      $s3,    16($sp)
        sw      $s4,    20($sp)
        sw      $s5,    24($sp)
        sw      $s6,    28($sp)

        move    $s0,    $a0                # $s0 = row
        move    $s1,    $a1                # $s1 = col
        move    $s2,    $a2                # $s2 = marker
        move    $s3,    $a3                # $s3 = canvas
        bltz    $s0,    ff_return      # row < 0
        bltz    $s1,    ff_return      # col < 0
        lw      $s4,    0($s3)             # $s4 = canvas->height
        bge     $s0,    $s4,    ff_return     # row >= canvas->height
        lw      $s4,    4($s3)             # $s4 = canvas->width
        bge     $s1,    $s4,    ff_return     # col >= canvas->width

        lw      $s4,    12($s3)            # canvas->canvas
        mul     $s5,    $s0,    4
        add     $s4,    $s5,    $s4           # $s4 = &canvas->canvas[row]
        lw      $s4,    0($s4)             # canvas->canvas[row]
        add     $s5,    $s1,    $s4           # $s5 = &canvas->canvas[row][col]
        lbu     $s4,    0($s5)             # $s4 = curr = canvas->canvas[row][col]
        lbu     $s6,    8($s3)             # $s6 = canvas->pattern
        beq     $s4,    $s6,    ff_return     # curr == canvas->pattern
        beq     $s4,    $s2,    ff_return     # curr == marker

        sb      $s2,    0($s5)             # canvas->canvas[row][col] = marker
        sub     $a0,    $s0,    1             # $a0 = row - 1
      #  jal     flood_fill              # flood_fill(row - 1, col, marker, canvas);
        move    $a0,    $s0
        add     $a1,    $s1,    1
        move    $a2,    $s2
        move    $a3,    $s3
      #  jal     flood_fill              # flood_fill(row, col + 1, marker, canvas);
        add     $a0,    $s0,    1
        move    $a1,    $s1
        move    $a2,    $s2
        move    $a3,    $s3
      #  jal     flood_fill              # flood_fill(row + 1, col, marker, canvas);
        move    $a0,    $s0
        sub     $a1,    $s1,    1
        move    $a2,    $s2
        move    $a3,    $s3
      #  jal     flood_fill              # flood_fill(row, col - 1, marker, canvas);

ff_return:
        lw      $ra,    0($sp)
        lw      $s0,    4($sp)
        lw      $s1,    8($sp)
        lw      $s2,    12($sp)
        lw      $s3,    16($sp)
        lw      $s4,    20($sp)
        lw      $s5,    24($sp)
        lw      $s6,    28($sp)
        add     $sp,    $sp,    32
        jr      $ra
###############################################################################
.globl check_if_opponent_took_asteroid
check_if_opponent_took_asteroid:
        sub $sp,  $sp, 36
        sw 	$ra,  0($sp)
        sw 	$s7,  4($sp)
        sw 	$s1,  28($sp)
        sw 	$s2,  32($sp)
        sw 	$s3,  20($sp)
        sw 	$t0,  8($sp)
        sw 	$t1,  12($sp)
        sw 	$t2,  16($sp)
        sw 	$t4,  24($sp)

read_in_map:
        la	$s7,  asteroid_map		# Give the allocated space to ASTEROID_MAP
        sw	$s7,  ASTEROID_MAP		# to populate with the given map
        add	$s1,	$s7,	4		# $s1 = &astroids[50]
        mul	$t1,	$t0,	8
        add	$t1,	$t1,	$s1		# &astroids[i]
        lw	$t2,	0($t1)			# $t2 = x and y
        srl	$t4,	$t2,	16		# $s2 = a.x
        bne     $t4,    $s2,    skip_current_astroid       # CHECK IF SAME, otherwise find new asteroid
        and     $t4,    $t2,    0xffff 		# bit-wise shift to get y (UPDATED ASTEROID MAP a.y)
        bne     $t4,    $s3,    skip_current_astroid       # checks if Y values match, if not find new asteroid
        li      $v0,    0
        j       end_check

skip_current_astroid:
        li      $v0,    1

end_check:
        lw 	$ra, 	0($sp)
        lw 	$s7, 	4($sp)
        lw 	$s1, 	28($sp)
        lw 	$s2, 	32($sp)
        lw 	$s3, 	20($sp)
        lw 	$t0, 	8($sp)
        lw 	$t1, 	12($sp)
        lw 	$t2, 	16($sp)
        lw 	$t4, 	24($sp)
        add 	$sp, 	$sp, 	36
        jr      $ra
################################################################################
################################################################################
##### HELPER FUNCTIONS(GIVEN) #####
################################################################################
################################################################################
.globl sb_arctan
sb_arctan:
        li	$v0, 0		# angle = 0;

        abs	$t8, $a0	# get absolute values
        abs	$t1, $a1
        ble	$t1, $t8, no_TURN_90

        ## if (abs(y) > abs(x)) { rotate 90 degrees }
        move	$t8, $a1	# int temp = y;
        neg	$a1, $a0	# y = -x;
        move	$a0, $t8	# x = temp;
        li	$v0, 90		# angle = 90;

no_TURN_90:
        bgez	$a0, pos_x 	# skip if (x >= 0)

        ## if (x < 0)
        add	$v0, $v0, 180	# angle += 180;

pos_x:
        mtc1	$a0, $f0
        mtc1	$a1, $f1
        cvt.s.w $f0, $f0	# convert from ints to floats
        cvt.s.w $f1, $f1

        div.s	$f0, $f1, $f0	# float v = (float) y / (float) x;

        mul.s	$f1, $f0, $f0	# v^^2
        mul.s	$f2, $f1, $f0	# v^^3
        l.s	$f3, three	# load 3.0
        div.s 	$f3, $f2, $f3	# v^^3/3
        sub.s	$f6, $f0, $f3	# v - v^^3/3

        mul.s	$f4, $f1, $f2	# v^^5
        l.s	$f5, five	# load 5.0
        div.s 	$f5, $f4, $f5	# v^^5/5
        add.s	$f6, $f6, $f5	# value = v - v^^3/3 + v^^5/5

        l.s	$f8, PI		# load PI
        div.s	$f6, $f6, $f8	# value / PI
        l.s	$f7, F180	# load 180.0
        mul.s	$f6, $f6, $f7	# 180.0 * value / PI

        cvt.w.s $f6, $f6	# convert "delta" back to integer
        mfc1	$t8, $f6
        add	$v0, $v0, $t8	# angle += delta

        jr 	$ra
################################################################################
.globl euclidean_dist
euclidean_dist:
        li      $t8,    10
        mul     $t8,    $t8,    $t8
        mul     $a0,    $a0,    $a0
        sub     $v0,    $t8,    $a0
        mtc1    $v0,    $f0
        cvt.s.w $f0,    $f0
        sqrt.s  $f0,    $f0
        cvt.w.s $f0,    $f0
        mfc1    $v0,    $f0
        jr      $ra
################################################################################
################################################################################
##### INTERRUPTS #####
################################################################################
################################################################################
.kdata				# interrupt handler data (separated just for readability)
chunkIH:	.space 16	# space for two registers
non_intrpt_str:	.asciiz "Non-interrupt exception\n"
unhandled_str:	.asciiz "Unhandled interrupt type\n"
################################################################################
##### Interrupt Handler #####
################################################################################
.ktext 0x80000180
interrupt_handler:
.set noat
        move	$k1, 	$at			# Save $at
.set at
        la	$k0, 	chunkIH
        sw	$a0, 	0($k0)			# Get some free registers
        sw	$a1,	4($k0)			# by storing them to a global variable
        sw	$a2, 	8($k0)
        sw	$a3, 	12($k0)

        mfc0	$k0, 	$13			# Get Cause register
        srl	$a0, 	$k0, 	2
        and	$a0, 	$a0, 	0xf		# ExcCode field
        bnez	$a0, 	non_intrpt
################################################################################
##### Interrupt Dispatch #####
################################################################################
interrupt_dispatch:				# Interrupt:
        mfc0	$k0, 	$13			# Get Cause register, again
        beqz	$k0, 	done			# handled all outstanding interrupts

        and	$a0, 	$k0, 	BONK_INT_MASK	# is there a bonk interrupt?
        bnez	$a0, 	bonk_interrupt
        and	$a0, 	$k0, 	TIMER_INT_MASK	# is there a timer interrupt?
        bnez	$a0, 	timer_interrupt
        and	$a0, 	$k0, 	REQUEST_PUZZLE_INT_MASK # is there a request puzzle interrupt?
        bnez	$a0, 	request_puzzle_interrupt
        and	$a0,	$k0,	STATION_ENTER_INT_MASK	# is the station in map?
        bnez,	$a0,	station_enter_interrupt
        and	$a0,	$k0,	STATION_EXIT_INT_MASK	# is the station gone?
        bnez,	$a0,	station_exit_interrput
        and	$a0,	$k0,	BOT_FREEZE_INT_MASK	# bot freezed?
        bnez,	$a0,	bot_freeze_interrupt

        li	$v0, 	PRINT_STRING		# Unhandled interrupt types
        la	$a0, 	unhandled_str
        syscall
        j	done
################################################################################
##### Bonk Interrupt #####
################################################################################
bonk_interrupt:
        sw	$a1,	BONK_ACK		# acknowledge interrupt

        j       interrupt_dispatch		# see if other interrupts are waiting
################################################################################
##### Timer Interrupt #####
################################################################################
timer_interrupt:
        sw	$a1,	TIMER_ACK		# acknowledge interrupt

        j	interrupt_dispatch		# see if other interrupts are waiting
################################################################################
##### Request Puzzle Interrupt #####
################################################################################
request_puzzle_interrupt:
        sw	$a1,	REQUEST_PUZZLE_ACK	# acknowledge interrupt
        # li      $a1,    0
        # sw      $a1,    0(solution)
        # sw      $a1,    4(solution) ##????
        li      $a1,    1
        sw      $a1, flag_puzzle                # set flag to 1
        j	interrupt_dispatch		# see if other interrupts are waiting
################################################################################
##### Station Enter Interrupt #####
################################################################################
station_enter_interrupt:
        sw 	$a1,	STATION_ENTER_ACK	# acknowledge interrupt
        li	$a1,	1
        sw	$a1,	flag_station		# set flag to 1
        j	interrupt_dispatch		# see if other interrupts are waiting
################################################################################
##### Station Exit Interrupt #####
################################################################################
station_exit_interrput:
        sw 	$a1,	STATION_EXIT_ACK	# acknowledge interrupt
        # li      $a1,    1
        # sw      $a1,    flag_NotFirstEntry
        li	$a1,	0
        sw	$a1,	flag_station		# set flag to 0
        j	interrupt_dispatch		# see if other interrupts are waiting
################################################################################
##### Bot Freeze Interrupt #####
################################################################################
bot_freeze_interrupt:
        la 	$a1,    op_puzzle_data   # acknowlaged with
        sw	$a1,	BOT_FREEZE_ACK		# acknowledge interrupt

        j	interrupt_dispatch		# see if other interrupts are waiting
################################################################################
##### Invalid Interrupt #####
################################################################################
non_intrpt:					# was some non-interrupt
        li	$v0,	PRINT_STRING
        la	$a0,	non_intrpt_str
        syscall					# print out an error message
################################################################################
##### Done Interrupt #####
################################################################################
done:
        la	$k0,	chunkIH
        lw	$a0,	0($k0)			# Restore saved registers
        lw	$a1,	4($k0)
.set noat
        move	$at,	$k1			# Restore $at
.set at
        eret
