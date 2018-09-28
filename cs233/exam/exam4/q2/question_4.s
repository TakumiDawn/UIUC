# run with:
#     QtSpim -file main.s question_4.s

# void hailstone(int *array, int length, int n) {
#     for (int i = 0; i < length; i++) {
#         array[i] = n;
#         if (n == 1) {
#             break;
#         }
#         if ((n & 1) == 0) {
#             n = n / 2;
#         } else {
#             n = (3 * n) + 1;
#         }
#     }
# }
.globl hailstone
hailstone:
  sub $sp, $sp, 4
  sw $ra, 0($sp)

  li $t0, 0 # $t0 < 0           i!

h_for:
  bge $t0, $a1, h_done
  mul $t1, $t0, 4
  add $t1, $a0, $t1  # $t1 <- array[i]
  sw $a2, 0($t1)  # array[i] = n
  beq $a2, 1, h_done
  and $t1, $a2, 1
  bne $t1, $0, h_not_zero
  div $a2, $a2, 2
  j h_go_for
h_not_zero:
  mul $a2, $a2, 3
  add $a2, $a2, 1
h_go_for:
  add $t0, $t0, 1
  j h_for

h_done:
  lw $ra, 0($sp)
  add $sp, $sp, 4
  jr $ra
