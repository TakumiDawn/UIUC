.text

## bool is_connected(unsigned int pos1, unsigned int pos2,
##                   unsigned int* origins) {
##     return get_origin(pos1, origins) == get_origin(pos2, origins);
## }

.globl is_connected
is_connected:
	# Your code goes here :)
	sub   $sp, $sp, 20
	sw    $ra, 0($sp)
	sw    $s0, 4($sp)
	sw    $s1, 8($sp)
	sw    $s5, 12($sp)
	sw    $s6, 16($sp)

  move  $s5, $a0         # $s5 <- $a0  pos1
	move  $s6, $a1         # $s6 <- $a1  pos2

	move  $a1, $a2         # $a1 <- $a2  (origins)
	jal   get_origin
	move  $s0, $v0         # $s0 <- get_origin(pos1, origins)

  move  $a0, $s6         # $a0 <- $s6  (pos2)
	move  $a1, $a2         # $a1 <- $a2  (origins)
	jal   get_origin
	move  $s1, $v0         # $s1 <- get_origin(pos2, origins)

is_connected_end:
  seq   $v0, $s0, $s1    # $v0 =   ($s0 == $s1) ? 1:0;

	lw    $ra, 0($sp)
	lw    $s0, 4($sp)
	lw    $s1, 8($sp)
	lw    $s5, 12($sp)
	lw    $s6, 16($sp)
	add   $sp, $sp, 20
	jr	$ra
