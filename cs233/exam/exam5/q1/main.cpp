// compile with g++ -Wall -O0 main.cpp -o find_maximum_node
// and run with ./find_maximum_node

#include <cstdlib>
#include <stdio.h>

struct node_t {
    node_t *children[4];
    int data;
};
node_t *create_int_quad_tree(int seed, int depth) {
    if (depth == 0) {
        return NULL;
    }

    srand(seed);

    node_t *root = new node_t;
    root->data = rand() % 100;

    int delta = rand() % 100;
    
    for (int i = 0; i < 4; i++) {
        root->children[i] = create_int_quad_tree(seed + delta + i, depth - 1);
    }

    return root;
}



node_t *find_maximum_node(node_t *node) {
    node_t *max = node;
    for (int i = 0; i < 4; i++) {
        if (node->children[i] != NULL) {
            node_t *max_of_child = find_maximum_node(node->children[i]);
            if (max_of_child->data > max->data) {
                max = max_of_child;
            }
        }
    }
    return max;
}
int main() {
    node_t *test0 = create_int_quad_tree(36, 2);
    node_t *test0_out = find_maximum_node(test0);
    printf("%d \n", test0_out->data);
    node_t *test1 = create_int_quad_tree(503, 3);
    node_t *test1_out = find_maximum_node(test1);
    printf("%d \n", test1_out->data);
    return 0;
}