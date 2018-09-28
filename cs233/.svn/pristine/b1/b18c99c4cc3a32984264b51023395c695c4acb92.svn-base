# add your own tests for the full machine here!
# feel free to take inspiration from all.s and/or lwbr2.s

.data
array:	.word	0x7fffffff	0x80000000 0x30003000 0x40000058
.text
main:
	la	$2, array	# $2  = 0x10010000	testing lui

	lw	$3, 0($2)	# $3  = 0x7fffffff
	lw	$4, 4($2)	# $3  = 0x80000000
	lw	$5, 8($2)	# $3  = 0x30003000
	lw	$6, 12($2)	# $3  = 0x40000058
	slt	$8, $3, $4	  # $8  = 0	  	testing slt overflow
	slt	$9, $4, $3	  # $9  = 1
	
