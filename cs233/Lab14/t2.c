#include "declarations.h"

//
//
// void
// t2(float *A, float *B) {
//     for (int nl = 0; nl < 10000000; nl ++) {
//         for (int i = 0; i < LEN2 - 4; i += 5) {
//             A[i] = B[i] * A[i];
//             A[i + 1] = B[i + 1] * A[i + 1];
//             A[i + 2] = B[i + 2] * A[i + 2];
//             A[i + 3] = B[i + 3] * A[i + 3];
//             A[i + 4] = B[i + 4] * A[i + 4];
//         }
//         A[0] ++;
//     }
// }

void
t2(float *A, float *B) {
    for (int nl = 0; nl < 10000000; nl ++) {
      #pragma clang loop vectorize(assume_safety) vectorize_width(4) interleave_count(4) distribute(disable)
        for (int i = 0; i < LEN2; i ++)
        {
            A[i] = B[i] * A[i];
        }
        A[0] ++;
    }
}



//
