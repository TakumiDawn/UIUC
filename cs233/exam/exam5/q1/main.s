# syscall constants
PRINT_INT = 1
PRINT_CHAR = 11
PRINT_STRING = 4

.data
.align 2
test0:	.word	p0x5573407a2ea0	p0x5573407a2ed0	p0x5573407a2f00	p0x5573407a2f30	56
p0x5573407a2ea0:	.word	0	0	0	0	73
p0x5573407a2ed0:	.word	0	0	0	0	30
p0x5573407a2f00:	.word	0	0	0	0	64
p0x5573407a2f30:	.word	0	0	0	0	19
.align 2
test1:	.word	p0x5573407a3fa0	p0x5573407a4090	p0x5573407a4180	p0x5573407a4270	17
p0x5573407a3fa0:	.word	p0x5573407a3fd0	p0x5573407a4000	p0x5573407a4030	p0x5573407a4060	26
p0x5573407a3fd0:	.word	0	0	0	0	80
p0x5573407a4000:	.word	0	0	0	0	72
p0x5573407a4030:	.word	0	0	0	0	56
p0x5573407a4060:	.word	0	0	0	0	75
p0x5573407a4090:	.word	p0x5573407a40c0	p0x5573407a40f0	p0x5573407a4120	p0x5573407a4150	30
p0x5573407a40c0:	.word	0	0	0	0	31
p0x5573407a40f0:	.word	0	0	0	0	16
p0x5573407a4120:	.word	0	0	0	0	12
p0x5573407a4150:	.word	0	0	0	0	50
p0x5573407a4180:	.word	p0x5573407a41b0	p0x5573407a41e0	p0x5573407a4210	p0x5573407a4240	9
p0x5573407a41b0:	.word	0	0	0	0	98
p0x5573407a41e0:	.word	0	0	0	0	10
p0x5573407a4210:	.word	0	0	0	0	16
p0x5573407a4240:	.word	0	0	0	0	86
p0x5573407a4270:	.word	p0x5573407a42a0	p0x5573407a42d0	p0x5573407a4300	p0x5573407a4330	77
p0x5573407a42a0:	.word	0	0	0	0	59
p0x5573407a42d0:	.word	0	0	0	0	79
p0x5573407a4300:	.word	0	0	0	0	49
p0x5573407a4330:	.word	0	0	0	0	63

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
#  this will test 'find_maximum_node'
#
#########################################################################
.globl main
main:
    sub     $sp, $sp, 4
    sw      $ra, 0($sp)     # save $ra on stack

    la      $a0, test0
    jal     find_maximum_node
    lw      $a0, 16($v0)
    jal     print_int_and_space
    jal     print_newline
    la      $a0, test1
    jal     find_maximum_node
    lw      $a0, 16($v0)
    jal     print_int_and_space
    jal     print_newline

    lw      $ra, 0($sp)
    add     $sp, $sp, 4
    jr      $ra