# syscall constants
PRINT_INT = 1
PRINT_CHAR = 11
PRINT_STRING = 4

.data
.align 2
test0:	.word	p0x55c0f2241eb0	p0x55c0f2242050	p0x55c0f2241e90
p0x55c0f2241e90:	.word	61
p0x55c0f2241eb0:	.word	p0x55c0f2241ef0	p0x55c0f2241fb0	p0x55c0f2241ed0
p0x55c0f2241ed0:	.word	30
p0x55c0f2241ef0:	.word	p0x55c0f2241f30	p0x55c0f2241f70	p0x55c0f2241f10
p0x55c0f2241f10:	.word	93
p0x55c0f2241f30:	.word	0	0	p0x55c0f2241f50
p0x55c0f2241f50:	.word	11
p0x55c0f2241f70:	.word	0	0	p0x55c0f2241f90
p0x55c0f2241f90:	.word	63
p0x55c0f2241fb0:	.word	p0x55c0f2241ff0	p0x55c0f2242010	p0x55c0f2241fd0
p0x55c0f2241fd0:	.word	72
p0x55c0f2241ff0:	.word	0	0	0
p0x55c0f2242010:	.word	0	0	p0x55c0f2242030
p0x55c0f2242030:	.word	60
p0x55c0f2242050:	.word	p0x55c0f2242090	p0x55c0f2242130	p0x55c0f2242070
p0x55c0f2242070:	.word	80
p0x55c0f2242090:	.word	p0x55c0f22420d0	p0x55c0f22420f0	p0x55c0f22420b0
p0x55c0f22420b0:	.word	64
p0x55c0f22420d0:	.word	0	0	0
p0x55c0f22420f0:	.word	0	0	p0x55c0f2242110
p0x55c0f2242110:	.word	73
p0x55c0f2242130:	.word	p0x55c0f2242170	p0x55c0f22421b0	p0x55c0f2242150
p0x55c0f2242150:	.word	60
p0x55c0f2242170:	.word	0	0	p0x55c0f2242190
p0x55c0f2242190:	.word	61
p0x55c0f22421b0:	.word	0	0	p0x55c0f22421d0
p0x55c0f22421d0:	.word	67
.align 2
test1:	.word	p0x55c0f2243240	p0x55c0f2243280	p0x55c0f2243220
p0x55c0f2243220:	.word	31
p0x55c0f2243240:	.word	0	0	p0x55c0f2243260
p0x55c0f2243260:	.word	91
p0x55c0f2243280:	.word	0	0	p0x55c0f22432a0
p0x55c0f22432a0:	.word	97

null_str: .asciiz "(null) "


.text
# print int and space ##################################################
#
# argument $a0: number to print
# returns       nothing

print_int_and_space:
    li      $v0, PRINT_INT  # load the syscall option for printing ints
    syscall         # print the number

    li      $a0, ' '        # print a blank space
    li      $v0, PRINT_CHAR # load the syscall option for printing chars
    syscall         # print the char
    
    jr      $ra     # return to the calling procedure

# print string ########################################################
#
# argument $a0: string to print
# returns       nothing

print_string:
    li      $v0, PRINT_STRING   # print string command
    syscall                 # string is in $a0
    jr      $ra

# print string and space ###############################################
#
# argument $a0: string to print
# returns       nothing

print_string_and_space:
    li      $v0, PRINT_STRING   # print string command
    syscall                 # string is in $a0
    li      $a0, ' '        # print a blank space
    li      $v0, PRINT_CHAR # load the syscall option for printing chars
    syscall         # print the char
    jr      $ra


# print newline ########################################################
#
# no arguments
# returns       nothing

print_newline:
    li      $a0, '\n'       # print a newline char.
    li      $v0, PRINT_CHAR
    syscall 
    jr      $ra




# main function ########################################################
#
#  this will test 'total_tree'
#
#########################################################################
.globl main
main:
    sub     $sp, $sp, 4
    sw      $ra, 0($sp)     # save $ra on stack

    la      $a0, test0
    jal     total_tree
    move    $a0, $v0
    jal     print_int_and_space
    jal     print_newline
    la      $a0, test1
    jal     total_tree
    move    $a0, $v0
    jal     print_int_and_space
    jal     print_newline

    lw      $ra, 0($sp)
    add     $sp, $sp, 4
    jr      $ra