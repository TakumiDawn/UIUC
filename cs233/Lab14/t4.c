#include "declarations.h"

void
t4(float M1[LEN4][LEN4], float M2[LEN4][LEN4], float M3[LEN4][LEN4]) {
    for (int nl = 0; nl < ntimes / (10 * LEN4); nl ++) {
        for (int i = 0; i < LEN4; i ++) {
            for (int k = 0; k < LEN4; k ++) {
              #pragma clang loop vectorize_width(4) interleave_count(2)
                for (int j = 0; j < LEN4; j ++) {
                    M3[i][j] += M1[i][k] * M2[k][j];
                }
            }
        }
        M3[0][0] ++;
    }
}
//
//
// M3[0][0] += M1[0][0] * M2[0][0];
// M3[0][0] += M1[0][1] * M2[1][0];
// M3[0][0] += M1[0][2] * M2[2][0];
// ..
// M3[0][1] += M1[0][0] * M2[0][1];
// M3[0][1] += M1[0][1] * M2[1][1];
// M3[0][1] += M1[0][2] * M2[2][1];
// ..
// M3[1][0] += M1[1][0] * M2[0][0];
// M3[1][0] += M1[1][1] * M2[1][0];
// M3[1][0] += M1[1][2] * M2[2][0];
