.data
array:	.word	1

# every register starts holding the address of "array"
#
# this is a cheat so that we don't need to implement addi and lui in
# our machine.

.text
main:
	lw	$3, 0($20)	# $3 = 1	(0x1)

	add	$2, $0, $0
	swplus	$2, 0($20)
	add	$2, $2, $3
	swplus	$2, 0($20)
	add	$2, $2, $3
	swplus	$2, 0($20)
	add	$2, $2, $3
	swplus	$2, 0($20)

	lw	$4,  0($21)
	lw	$5,  4($21)
	lw	$6,  8($21)
	lw	$7, 12($21)
