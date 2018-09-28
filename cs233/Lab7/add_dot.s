.text

## void add_dot(unsigned int pos, unsigned int* canvas) {
##     unsigned int row = pos >> 5;
##     unsigned int col = 31 - (pos & 31);
##     canvas[row] |= (1 << col);
## }

.globl add_dot
add_dot:

	srl     $t0, $a0 , 5                     # unsigned int row = pos >> 5; $t0 stores row !
	li      $t1, 31                          # $t1 <- 31
  and     $t2, $a0, $t1                    # $t2 <- pos & 31,
	subu    $t2, $t1, $t2                    # $t2 <- 31 - pos&31, as col !
	li      $t3, 1                           # $t3 <- 1
	sll     $t3, $t3, $t2                    # $t3 <-  1<< col
	mul     $t1, $t0, 4                      # $t1 <- 4*row, bc int
	add     $t1, $a1, $t1                    # $t1 <- canvas[row] !
  lw      $t2, 0($t1)		                   #  $t2 <- M[canvas[row]]
	or      $t3, $t2, $t3                    # $t3 <- M[canvas[row]] | 1<< col !
	sw      $t3, 0($t1)                      # M[$t1] <- $t3

	jr	    $ra
