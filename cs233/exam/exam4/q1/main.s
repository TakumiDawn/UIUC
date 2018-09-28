# syscall constants
PRINT_INT = 1
PRINT_CHAR = 11
PRINT_STRING = 4

.data
.align 2
test0:	.word	4	35	16	55	55
.align 2
test1:	.word	54	8	72	98	40	58	70	9	73	23	61	50

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



# print int array ########################################################
#
# argument $a0: int array to print
# argument $a1: length of array
# returns       nothing
print_int_array:
    sub     $sp, $sp, 16
    sw      $ra, 0($sp)
    sw      $s0, 4($sp)
    sw      $s1, 8($sp)
    sw      $s2, 12($sp)
    move    $s0, $a0
    move    $s1, $a1
    move    $s2, $0

pia_loop:
    bge     $s2, $s1, pia_end
    mul     $t0, $s2, 4
    add     $t0, $t0, $s0
    lw      $a0, 0($t0)
    jal     print_int_and_space
    add     $s2, $s2, 1
    j       pia_loop
pia_end:
    lw      $ra, 0($sp)
    lw      $s0, 4($sp)
    lw      $s1, 8($sp)
    lw      $s2, 12($sp)
    add     $sp, $sp, 16
    jr      $ra
# main function ########################################################
#
#  this will test 'swap_pairs'
#
#########################################################################
.globl main
main:
    sub     $sp, $sp, 4
    sw      $ra, 0($sp)     # save $ra on stack

    la      $a0, test0
    li      $a1, 5
    jal     swap_pairs
    la      $a0, test0
    la      $a1, 5
    jal     print_int_array
    jal     print_newline
    la      $a0, test1
    li      $a1, 12
    jal     swap_pairs
    la      $a0, test1
    la      $a1, 12
    jal     print_int_array
    jal     print_newline

    lw      $ra, 0($sp)
    add     $sp, $sp, 4
    jr      $ra