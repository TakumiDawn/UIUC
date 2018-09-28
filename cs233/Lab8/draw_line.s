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
## // Draw a line on canvas from start_pos to end_pos.
## // start_pos will always be smaller than end_pos.
## void draw_line(unsigned int start_pos, unsigned int end_pos,
##                Canvas* canvas) {
##     unsigned int width = canvas->width;
##     unsigned int step_size = 1;
##     // Check if the line is vertical.
##     if (end_pos - start_pos >= width) {
##         step_size = width;
##     }
##     // Update the canvas with the new line.
##     for (int pos = start_pos; pos != end_pos + step_size;
##              pos += step_size) {
##         canvas->canvas[pos / width][pos % width] = canvas->pattern;  // lb ...
##     }
## }

.globl draw_line
draw_line:
        lw $t0, 4($a2)            # $t0 <- canvas->width    ; width!
        li $t1, 1                 # $t1 <- 1   ; step_size!
        subu $t3, $a1, $a0        # $t3 <- end_pos - start_pos
        blt $t3, $t0, dl_pre_for  # if $t3 < $t0 then
        move $t1, $t0             # step_size = width
dl_pre_for:
        move $t3, $a0             # $t3 <- pos = start_pos;      pos!
        addu $t2, $a1, $t1        # $t2 <- end_pos + step_size;  !
        lbu $t4, 8($a2)           # $t4 <- canvas->pattern       pattern!
        lw $t9, 12($a2)           #  $t9 <- canvas->canvas     canvas->canvas!
dl_for:
        beq $t3, $t2, dl_done

        divu $t5, $t3, $t0       #  $t5 <- pos / width;      i
        mul $t5, $t5, 4          #  $t5 <- $t5*4;            i *4  char*
        addu $t8, $t9, $t5       #  $t8 <- $t9 + $t5;   canvas[pos / width]
        lw $t8, 0($t8)           #  $t8 <- M[canvas[pos / width]]

        remu $t6, $t3, $t0       #  $t6 <- pos % width;      j
        addu $t6, $t6, $t8       #  $t6 <- $t6 + $t8;  canvas[pos / width][pos % width]
        sb $t4, 0($t6)           #  M[$t6] <- $t4

        addu $t3, $t3, $t1       # $t3 <- pos += step_size
        j dl_for
dl_done:
        jr      $ra
