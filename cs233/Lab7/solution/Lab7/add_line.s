.text

## void add_line(unsigned int start_pos, unsigned int end_pos,
##               unsigned int* canvas, unsigned int* origins) {
##     int step_size = 1;
##     // Check if the line is vertical.
##     if (!((start_pos ^ end_pos) & 31)) {
##         step_size = 32;
##     }
##     if (start_pos > end_pos) {
##         step_size *= -1;
##     }
##     // Update the origin map.
##     add_dot(end_pos, canvas);
##     for (int i = start_pos; i != end_pos; i += step_size) {
##         add_dot(i, canvas);
##         origins[get_origin(i + step_size, origins)] = get_origin(i, origins);
##     }
## }

.globl add_line
add_line:
	sub	$sp, $sp, 28
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)
	sw	$s5, 24($sp)

	move	$s0, $a0	# $s0 = i = start_pos
	move	$s1, $a1	# $s1 = end_pos
	move	$s2, $a2	# $s2 = canvas
	move	$s3, $a3	# $s3 = origins
	li	$s4, 1		# $s4 = step_size

	xor	$t0, $s0, $s1
	and	$t0, $t0, 31
	bnez	$t0, cont1
	li	$s4, 32
cont1:
	ble	$s0, $s1, cont2
	mul	$s4, $s4, -1
cont2:
	move	$a0, $s1
	move	$a1, $s2
	jal	add_dot
for:
	beq	$s0, $s1, for_end

	move	$a0, $s0
	move	$a1, $s2
	jal	add_dot

	move	$a0, $s0
	move	$a1, $s3
	jal	get_origin	# $v0 = get_origin(i, origins)
	move	$s5, $v0

	add	$a0, $s0, $s4
	move	$a1, $s3
	jal	get_origin	# v0 = get_origin(i + step_size, origins)
	mul	$t0, $v0, 4
	add	$t0, $s3, $t0	# $t0 = &origins[get_origin(i + step_size, origins)]
	sw	$s5, 0($t0)

	add	$s0, $s0, $s4	# i += step_size
	j	for
for_end:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	lw	$s5, 24($sp)
	add	$sp, $sp, 28
	jr	$ra
