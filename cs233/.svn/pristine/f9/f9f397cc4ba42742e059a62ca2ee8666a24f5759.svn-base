.text

## struct Lines {
##     unsigned int num_lines;
##     // An int* array of size 2, where first element is an array of start pos
##     // and second element is an array of end pos for each line.
##     // start pos always has a smaller value than end pos.
##     unsigned int* coords[2];
## };
##
## struct Solution {
##     unsigned int length;
##     int* counts;
## };
##
## // Count the number of disjoint empty area after adding each line.
## // Store the count values into the Solution struct.
## void count_disjoint_regions(const Lines* lines, Canvas* canvas,
##                             Solution* solution) {
##     // Iterate through each step.
##     for (unsigned int i = 0; i < lines->num_lines; i++) {
##         unsigned int start_pos = lines->coords[0][i];
##         unsigned int end_pos = lines->coords[1][i];
##         // Draw line on canvas.
##         draw_line(start_pos, end_pos, canvas);
##         // Run flood fill algorithm on the updated canvas.
##         // In each even iteration, fill with marker 'A', otherwise use 'B'.
##         unsigned int count =
##                 count_disjoint_regions_step('A' + (i % 2), canvas);
##         // Update the solution struct. Memory for counts is preallocated.
##         solution->counts[i] = count;
##     }
## }

.globl count_disjoint_regions
count_disjoint_regions:
        sub $sp, $sp, 36
        sw  $ra, 0($sp)
        sw  $s0, 4($sp)
        sw  $s1, 8($sp)
        sw  $s2, 12($sp)
        sw  $s3, 16($sp)
        sw  $s4, 20($sp)
        sw  $s5, 24($sp)
        sw  $s6, 28($sp)
        sw  $s7, 32($sp)

        move $s5, $a0                              # $s5 = lines !
        move $s6, $a1                              #  $s6 = Canvas * canvas
        move $s7, $a2                              #  $s7 = Solution * solution
        li $s0, 0                                  # i= 0        $s0 i !
        lw $s1, 0($s5)                             # $s1 = num_lines
cdr_for:
        bge  $s0, $s1, cdr_done   # if $s0 >=$s1;  i >= lines->num_lines, then done

        lw  $t0, 4($s5)           # $t0 <- lines->coords[0]
        mul $t1, $s0, 4           # $t1 <- $s0*4    i*4
        add $t1, $t1, $t0         #   lines->coords[0][i]
        lw  $a0, 0($t1)           # $a0 <- start_pos = M[lines->coords[0][i]];

        lw  $t0, 8($s5)           # $t0 <- lines->coords[1]
        mul $t1, $s0, 4           # $t1 <- $s0*4    i*4
        add $t1, $t1, $t0         #   lines->coords[1][i];
        lw  $a1, 0($t1)           # $a1 <- end_pos = M[lines->coords[1][i]];
        move $a2, $s6             # $a2 <- $s6 = Canvas * canvas
        jal draw_line

        remu $t3, $s0, 2          # $t3 <- (i % 2)
        li $t5, 'A'
        add $a0, $t3, $t5         # $a0 <- 'A' + (i % 2)
        move $a1, $s6             # count_disjoint_regions_step('A' + (i % 2), canvas);
        jal count_disjoint_regions_step

        lw  $t0, 4($s7)           # $t0 <- solution->counts[0]
        mul $t1, $s0, 4           # $t1 <- $s0*4    i*4
        add $t0, $t1, $t0         # $t0 <- solution->counts[i]
        sw $v0, 0($t0)            # solution->counts[i] = count

        add $s0, $s0, 1           # i++
        j cdr_for

cdr_done:
        lw  $ra, 0($sp)
        lw  $s0, 4($sp)
        lw  $s1, 8($sp)
        lw  $s2, 12($sp)
        lw  $s3, 16($sp)
        lw  $s4, 20($sp)
        lw  $s5, 24($sp)
        lw  $s6, 28($sp)
        lw  $s7, 32($sp)
        add $sp $sp 36
        jr      $ra
