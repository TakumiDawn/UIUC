#include "declarations.h"

// void
// t6(float *restrict A, float *restrict R) {
//     for (int nl = 0; nl < ntimes; nl ++) {
//         A[0] = 0;
//         for (int i = 0; i < (LEN6 - 3); i ++) {
//             R[i + 1] = A[i] + (float) 2.0;
//             A[i] = R[i + 2] + (float) 1.0;
//         }
//     }
// }
void
t6(float *restrict A, float *restrict R) {
    for (int nl = 0; nl < ntimes; nl ++) {
        A[0] = 0;
        #pragma clang loop vectorize_width(4) interleave_count(4) distribute(disable)
        for (int i = 0; i < (LEN6 - 3); i ++) {
            R[i + 1] = A[i] + (float) 2.0;
        }
      #pragma clang loop vectorize_width(4) interleave_count(4) distribute(disable)
        for (int i = 0; i < (LEN6 - 3); i ++) {
            A[i] = R[i + 2] + (float) 1.0;
        }
    }
}

//
// R[1] = A[0] + (float) 2.0;
// A[0] = R[2] + (float) 1.0;
// R[2] = A[1] + (float) 2.0;
// A[1] = R[3] + (float) 1.0;
