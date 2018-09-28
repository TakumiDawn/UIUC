.text

## void add_dot(unsigned int pos, unsigned int* canvas) {
##     unsigned int row = pos >> 5;
##     unsigned int col = 31 - (pos & 31);
##     canvas[row] |= (1 << col);
## }

.globl add_dot
add_dot:
	srl	$t0, $a0, 5	# row = pos >> 5
	and	$a0, $a0, 31
	li	$t1, 31
	sub	$t1, $t1, $a0	# $t1 = 31 - (pos & 31)
	li	$t2, 1
	sll	$t2, $t2, $t1	# $t2 = 1 << col
	mul	$t0, $t0, 4
	add	$t0, $t0, $a1	# $t0 = &canvas[row]
	lw	$t3, 0($t0)	# $t3 = canvas[row]
	or	$t3, $t3, $t2	# $t3 = canvas[row] | (1 << col)
	sw	$t3, 0($t0)
	jr	$ra
