#include "declarations.h"
void
t1(float *restrict A, float *restrict B) {
    for (int nl = 0; nl < 1000000; nl ++) {
      #pragma clang loop vectorize_width(4) interleave_count(2) distribute(disable)
        for (int i = 0; i < LEN1; i += 2) {
            A[i + 1] = (A[i] + B[i]) / (A[i] + B[i] + 1.);
        }
        B[0] ++;
    }
}


// A[1] = (A[0] + B[0]) / (A[0] + B[0] + 1.);
// A[3] = (A[2] + B[2]) / (A[2] + B[2] + 1.);
//
// ...
// B[0]
