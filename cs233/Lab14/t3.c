//A
//has data dependencies and was not vectorized
#include "declarations.h"

void
t3(float A[LEN3][LEN3]) {
    for (int nl = 0; nl < 1000; nl ++) {
        for (int i = 1; i < LEN3; i ++) {
            for (int j = 1; j < LEN3; j ++) {
                A[i][j] = A[i - 1][j] + A[i][j - 1];
            }
        }
        A[0][0] ++;
    }
}
//
//
//
// void
// t3(float A[LEN3][LEN3]) {
//     for (int nl = 0; nl < 1000; nl ++) {
//         for (int i = 1; i < LEN3; i ++) {
//             for (int j = 1; j < LEN3; j ++) {
//                 A[i][j] = A[i - 1][j] + A[i][j - 1];
//             }
//         }
//         A[0][0] ++;
//     }
// }
//
// A[1][1] = A[0][1] + A[1][0];
// A[1][2] = A[0][1] + A[1][1];
// A[1][3] = A[0][2] + A[1][3];
//
// A[2][1] = A[1][1] + A[2][0];
