.text

## struct Canvas {
##     // Height and width of the canvas.
##     unsigned int height;
##     unsigned int width;
##     // The pattern to draw on the canvas.
##     unsigned char pattern;
##     // Each char* is null-terminated and has same length.
##     char** canvas;
## };
##
## // Count the number of disjoint empty area in a given canvas.
## unsigned int count_disjoint_regions_step(unsigned char marker,
##                                          Canvas* canvas) {
##     unsigned int region_count = 0;
##     for (unsigned int row = 0; row < canvas->height; row++) {
##         for (unsigned int col = 0; col < canvas->width; col++) {
##             unsigned char curr_char = canvas->canvas[row][col];
##             if (curr_char != canvas->pattern && curr_char != marker) {
##                 region_count ++;
##                 flood_fill(row, col, marker, canvas);
##             }
##         }
##     }
##     return region_count;
## }

.globl count_disjoint_regions_step
count_disjoint_regions_step:
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


        move $s6, $a0                                                           # $s6  marker!
        move $s7, $a1                                                           # $s7  a1 canvas!
        li $s3, 0                                                               # region_count = 0;    $s3 region_count!

        li $s4, 0                                                               # row = 0  $s4 row!
cdrs_row_for:
        lw $t0, 0($s7)                                                          # $t0 <- canvas->height
        bge  $s4, $t0, cdrs_done                                                # $s4 >= canvas->height   then done

        li $s5, 0                                                               # col = 0   $s5 col!
cdrs_col_for:
        lw $t0, 4($s7)                                                          # $t0 <- canvas->width
        bge  $s5, $t0, cdrs_row_for_done                                        # $s5 >= canvas->width   then go to for_done

        mul $t0, $s4, 4                                                         #  $t0 <- $s4*4;  char*
        lw $t5, 12($s7)                                                         #   $t5 canvas
        add $t0, $t5, $t0                                                       # $t0 <- $t5 + $t0     canvas[row]
        lw $t0, 0($t0)                                                          # $t0 <- M[canvas[row]]
        add $t0, $t0, $s5                                                       # $t0 <- $t0 + $s5  $t0 canvas[row][col]!
        lb  $t1, 0($t0)                                                         # $t1 <- M [ canvas[row][col] ]       $t1 curr_char!

        beq $t1, $s6, cdrs_col_for_done                                         # if $t1 == $a2  curr_char == marker
        lb $t2, 8($s7)                                                          # $t2 <- canvas->pattern
        beq $t1, $t2, cdrs_col_for_done                                         # $t1 == $t2  curr_char == pattern

        add $s3, $s3, 1

        move $a0, $s4
        move $a1, $s5
        move $a2, $s6
        move $a3, $s7
        jal flood_fill

cdrs_col_for_done:
        add $s5, $s5, 1                                                         # $s1++  col++
        j cdrs_col_for

cdrs_row_for_done:
        add $s4, $s4, 1                                                         # $s4++   row++
        j cdrs_row_for

cdrs_done:
        move $v0, $s3
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
