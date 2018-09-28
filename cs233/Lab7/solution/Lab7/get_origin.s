.text

## unsigned int get_origin(unsigned int pos, unsigned int* origins) {
##     while (pos != origins[pos]) {
##         pos = origins[pos];
##     }
##     return pos;
## }

.globl get_origin
get_origin:
	mul	$t0, $a0, 4
	add	$t0, $a1, $t0
	lw	$t0, 0($t0)	# $t0 = origins[pos]
	beq	$a0, $t0, while_end
	move	$a0, $t0	# pos = origins[pos]
	j	get_origin
while_end:
	move	$v0, $a0
	jr	$ra
