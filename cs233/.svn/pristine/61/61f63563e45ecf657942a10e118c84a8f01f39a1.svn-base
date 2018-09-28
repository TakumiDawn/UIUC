.text

## unsigned int get_origin(unsigned int pos, unsigned int* origins) {
##     while (pos != origins[pos]) {
##         pos = origins[pos];
##     }
##     return pos;
## }

.globl get_origin
get_origin:
	# Your code goes here :)
	move    $t0, $a0                      # $t0 <- $a0
	mul     $t1, $t0, 4                   # $t1 <- $t0 *4, as pos
  add     $t1, $t1, $a1                 # $t1 <- $t1 + $a1, as the addr of origins[pos]
	lw		  $t2, 0($t1)		                # $t2 <- M[origins[pos]]
	beq     $t2, $t0, get_origin_end
  move    $a0, $t2                      # if pos != M[origins[pos]], pos = M[origins[pos]]
  j       get_origin

get_origin_end:
  move    $v0, $t0                     # if done, $v0 <- $t0 ,  v0 = pos
	jr	    $ra
