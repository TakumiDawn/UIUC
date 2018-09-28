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
	# Your code goes here :)
	sub  $sp, $sp, 28   # store all the reg neened
	sw   $ra, 0($sp)
	sw   $s0, 4($sp)
	sw   $s1, 8($sp)
	sw   $s3, 12($sp)
	sw   $s4, 16($sp)
	sw   $s5, 20($sp)
	sw   $s6, 24($sp)

	move $s5, $a0       # $s5 <- $a0  start_pos
	move $s6, $a1       # $s6 <- $a1  end_pos

	li   $s0, 1         # $s0 = 1 , step_size

	xor  $t2, $a0, $a1  # $t2 <- (start_pos ^ end_pos)
	and  $t2, $t2, 31   # $t2 <- (start_pos ^ end_pos) & 31)
	bne  $0, $t2, inverse
  li   $s0, 32

inverse:
  bleu $a0, $a1, update
	not  $s0, $s0
	add  $s0, $s0, 1    # $s0 <- step_size *= -1     step_size!

update:
  move $a0, $s6       # $a0 <- end_pos
	move $a1, $a2       # $a1 <- canvas
  jal  add_dot

  move $s1, $s5       # $s1 <-  i = start_pos;  i!
add_line_for:
  beq  $s1, $s6, add_line_end
	move $a0, $s1       # $a0 <- i
	move $a1, $a2       # $a1 <- canvas
  jal  add_dot

	move $a0, $s1       # $a0 <- $s1   i
	move $a1, $a3       # $a1 <- $a3  origins
  jal  get_origin
	move $s3, $v0       # $s3 <- $v0  get_origin(i, origins)

	add  $a0, $s1, $s0  # $a0 <- $s1+ $s0   i + step_size
	move $a1, $a3       # $a1 <- $a3  origins
  jal  get_origin
	move $s4, $v0       # $s3 <- $v0  get_origin(i + step_size, origins)

  mulou $s4, $s4, 4
  add   $t1, $s4, $a3
  sw    $s3, 0($t1)

	add   $s1, $s1, $s0   # i += step_size
  j     add_line_for

add_line_end:
  lw $ra, 0($sp)        # restore all the reg neened
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  lw $s3, 12($sp)
  lw $s4, 16($sp)
  lw $s5, 20($sp)
  lw $s6, 24($sp)
  add $sp, $sp, 28
	jr	$ra
