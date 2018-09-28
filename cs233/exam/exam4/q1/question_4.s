# run with:
#     QtSpim -file main.s question_4.s

# void swap_pairs(int *array, int length) {
#     length = length & ~1;
#
#     for (int i = 0; i < length; i += 2) {
#         int temp = array[i];
#         array[i] = array[i + 1];
#         array[i + 1] = temp;
#     }
# }
.globl swap_pairs
swap_pairs:
  sub $sp, $sp, 4
  sw $ra, 0($sp)

  li $t0, 1
  nor $t0, $t0, $t0 # $t0 <- ~1
  and $a1, $a1, $t0 # length = length & ~1

  li $t0, 0  # $t0 < 0  ;   $t0 i!
sp_for:
  bge $t0, $a1, sp_done

  mul  $t9, $t0, 4      # $t9 *
  add $t9, $a0, $t9
  lw $t1, 0($t9)  # $t1 <- temp = array[i];  $t1 temp!
  lw $t2, 4($t9)  # $t1 <- temp = array[i];
  sw $t2, 0($t9)
  sw $t1, 4($t9)

  add $t0, $t0, 2
  j sp_for
sp_done:
  lw $ra, 0($sp)
  add $sp, $sp, 4
  jr $ra
