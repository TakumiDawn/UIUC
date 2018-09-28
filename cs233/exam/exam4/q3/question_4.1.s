# run with QtSpim -file main.s question_4.s

# int find_minimum_index(int *array, int length) {
#     int min = array[0];
#     int min_index = 0;
#
#     for (int i = 1; i < length; i++) {
#         if (array[i] < min) {
#             min = array[i];
#             min_index = i;
#         }
#     }
#
#     return min_index;
# }
.globl find_minimum_index
find_minimum_index:
  sub $sp, $sp, 4
	sw $ra, 0($sp)

	lw $t0, 0($a0)  # $t0 min
	li $t1, 0       # $t1 min_index

	li $t2, 1      # $t2 i
fmi_for:
  bge $t2, $a1, fmi_done
  mul $t3, $t2, 4
	add $t3, $t3, $a0
	lw $t4, 0($t3)  # t4 array[i]
	bge $t4, $t0, fmi_for_if_end
	move $t0, $t4
	move $t1, $t2
fmi_for_if_end:
	add $t2, $t2, 1
	j fmi_for

fmi_done:
  move $v0, $t1
  lw $ra, 0($sp)
  add $sp, $sp, 4
	j	$ra
