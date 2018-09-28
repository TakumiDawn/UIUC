# run with QtSpim -file main.s question_4.s

# void find_minimum_index(int * array, int ** A, int length) {
#     for (int i = 0; i < length; i+=2) {
#         array[i]  = *A[i] + 17
#     }
# }
.globl find_minimum_index
find_minimum_index:
  sub $sp, $sp, 4
  sw $ra, 0($sp)

  li $t0, 0  # $t0 i
for:
  bge $t0, $a2, done
  mul $t1, $t0, 4
  add $t2, $t1, $a0   # $t2  array[i]

  lw $t3, 0($a1)

  add $t4, $t1, $t3
  lw $t3, 0 ($t4)  #*A[i]
  add $t3 $t3 17
  sw $t3, 0($t2)

  add $t0, $t0, 2
  j for

done:
  lw $ra, 0($sp)
  add $sp, $sp, 4
  jr $ra
