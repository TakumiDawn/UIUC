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
## // Mark an empty region as visited on the canvas using flood fill algorithm.
## void flood_fill(int row, int col, unsigned char marker, Canvas* canvas) {
##     // Check the current position is valid.
##     if (row < 0 || col < 0 ||
##         row >= canvas->height || col >= canvas->width) {
##         return;
##     }
##     unsigned char curr = canvas->canvas[row][col];
##     if (curr != canvas->pattern && curr != marker) {
##         // Mark the current pos as visited.
##         canvas->canvas[row][col] = marker;
##         // Flood fill four neighbors.
##         flood_fill(row - 1, col, marker, canvas);
##         flood_fill(row, col + 1, marker, canvas);
##         flood_fill(row + 1, col, marker, canvas);
##         flood_fill(row, col - 1, marker, canvas);
##     }
## }

.globl flood_fill
flood_fill:
        sub   $sp, $sp, 12
        sw    $ra, 0($sp)
        sw    $s0, 4($sp)
        sw    $s1, 8($sp)

        move  $s0, $a0                                # $s0 <- $a0       $s0 row!
        move  $s1, $a1                                # $s1 <- $a1       $s1 col!

        blt $s0, $0, ff_done                          # if $s0 (row!) <0 then ff_done
        blt $s1, $0, ff_done                          # if $s1 (col!) <0 then ff_done
        lw $t0, 0($a3)                                # $t0 <- canvas->height
        bge $s0, $t0, ff_done                         # if $s0 (row!) >= canvas->height
        lw $t0, 4($a3)                                # $t0 <- canvas->width
        bge $s1, $t0, ff_done                         # if $s1 (col!) >= canvas->width

        mul $t0, $s0, 4                               #  $t0 <- $s0*4;  char*
        lw $t3, 12($a3)                               # $t3 <- canvas
        add $t0, $t3, $t0                             # $t0 <- $a3 + $t3    canvas[row]
        lw $t0, 0($t0)                                # $t0 <- M[canvas[row]]
        add $t0, $t0, $s1                             # $t0 <- $t0 + $s1           $t0 canvas[row][col]!
        lb $t1, 0($t0)                                # $t1 <- M [ canvas[row][col] ]            $t1 curr!


        beq $t1, $a2, ff_done                         # if $t1 == $a2  curr == marker
        lb $t2, 8($a3)                                # $t2 <- canvas->pattern
        beq $t1, $t2, ff_done                         # $t1 == $t2  curr == pattern
        sb $a2, 0($t0)                                # M[$t0] <- $a2  canvas->canvas[row][col] = marker;

        sub $a0, $s0, 1                               # $a0 <- row-1
        move $a1, $s1                                 # $a1 <- col
        jal flood_fill

        move $a0, $s0                                 # $a0 <- row
        add $a1, $s1, 1                               # $a1 <- col+1
        jal flood_fill

        add $a0, $s0, 1                               # $a0 <- row+1
        move $a1, $s1                                 # $a1 <- col
        jal flood_fill

        move $a0, $s0                                 # $a0 <- row
        sub $a1, $s1, 1                               # $a1 <- col-1
        jal flood_fill

ff_done:
        lw  $ra 0($sp)
        lw  $s0 4($sp)
        lw  $s1 8($sp)
        add $sp $sp 12
        jr  $ra
