.text

## bool is_connected(unsigned int pos1, unsigned int pos2,
##                   unsigned int* origins) {
##     return get_origin(pos1, origins) == get_origin(pos2, origins);
## }

.globl is_connected
is_connected:
	sub	$sp, $sp, 16
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)

	move	$s1, $a1
	move	$s2, $a2

	move	$a1, $a2
	jal	get_origin
	move	$s0, $v0

	move	$a0, $s1
	move	$a1, $s2
	jal	get_origin
	move	$t0, $v0

	li	$v0, 0
	bne	$s0, $t0, is_connected_return
	li	$v0, 1
is_connected_return:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	add	$sp, $sp, 16
	jr	$ra
