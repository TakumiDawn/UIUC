# run with:
#     QtSpim -file main.s question_5.s

# struct node_t {
#     node_t *children[4];
#     int data;
# };
#
# node_t *find_maximum_node(node_t *node) {
#     node_t *max = node;
#     for (int i = 0; i < 4; i++) {
#         if (node->children[i] != NULL) {
#             node_t *max_of_child = find_maximum_node(node->children[i]);
#             if (max_of_child->data > max->data) {
#                 max = max_of_child;
#             }
#         }
#     }
#     return max;
# }
.globl find_maximum_node
find_maximum_node:
   sub $sp,$sp,16
   sw $ra, 0($sp)
   sw $s0, 4($sp)
   sw $s1, 8($sp)
   sw $s2, 12($sp)

   move $s0, $a0   # $s0 <- node_t *  max !
   move $s2, $a0   # $s2 <-          node!

   li $s1, 0    # $s1  <- 0   i!
fmn_for:
   bge $s1, 4, fmn_done
   mul $t0, $s1, 4  # $t0 <- $s1*4
   add $t0, $s2, $t0  # & node->children[i]
   lw $t0, 0($t0)  # $t0 <- node->children[i]
   beq $t0, $0, fmn_for_if_done

   move $a0, $t0
   jal find_maximum_node  # $v0 <- node_t *max_of_child
   lw $t2, 16($s0) # $t2 <- max->data
   lw $t3, 16($v0) # $t2 <- max_of_child->data
   ble $t3, $t2, fmn_for_if_done
   move $s0, $v0

fmn_for_if_done:
   add $s1, $s1, 1   # i++
   j fmn_for

fmn_done:
   move $v0, $s0
   lw $ra, 0($sp)
   lw $s0, 4($sp)
   lw $s1, 8($sp)
   lw $s2, 12($sp)
   add $sp, $sp, 16
   jr $ra
