// compile with g++ -Wall -O0 main.cpp -o swap_pairs
// and run with ./swap_pairs

#include <cstdlib>
#include <stdio.h>


int *create_int_array(int seed, int length) {
    srand(seed);

    int *arr = new int[length];
    for (int i = 0; i < length; i++) {
        arr[i] = rand() % 100;
    }
    return arr;
}
void print_int_array(int *arr, int length) {
    for (int i = 0; i < length; i++) {
        printf("%d ", arr[i]);
    }
}

void swap_pairs(int *array, int length) {
    length = length & ~1;

    for (int i = 0; i < length; i += 2) {
        int temp = array[i];
        array[i] = array[i + 1];
        array[i + 1] = temp;
    }
}
int main() {
    int *test0 = create_int_array(664, 5);
    swap_pairs(test0, 5);
    print_int_array(test0, 5);
    printf("\n");
    int *test1 = create_int_array(218, 12);
    swap_pairs(test1, 12);
    print_int_array(test1, 12);
    printf("\n");
    return 0;
}