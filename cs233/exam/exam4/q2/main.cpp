// compile with g++ -Wall -O0 main.cpp -o hailstone
// and run with ./hailstone

#include <cstdlib>
#include <stdio.h>


void print_int_array(int *arr, int length) {
    for (int i = 0; i < length; i++) {
        printf("%d ", arr[i]);
    }
}

void hailstone(int *array, int length, int n) {
    for (int i = 0; i < length; i++) {
        array[i] = n;
        if (n == 1) {
            break;
        }
        if ((n & 1) == 0) {
            n = n / 2;
        } else {
            n = (3 * n) + 1;
        }
    }
}
int main() {
    int test0[] = {0,0,0,0,0,0,0,0,0,0};
    hailstone(test0, 10, 13);
    print_int_array(test0, 10);
    printf("\n");
    int test1[] = {0,0,0,0,0,0,0,0};
    hailstone(test1, 8, 8);
    print_int_array(test1, 8);
    printf("\n");
    return 0;
}