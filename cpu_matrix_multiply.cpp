// cpu_matrix_multiply.cpp
#include "cpu_matrix_multiply.h"
#include <cassert>

std::vector<float> cpuMatrixMultiply(const CSRMatrix& A, const CSRMatrix& B) {
    assert(A.cols == B.rows);
    std::vector<float> C(A.rows * B.cols, 0.0f);

    for (int i = 0; i < A.rows; ++i) {
        for (int j = A.rowPtr[i]; j < A.rowPtr[i + 1]; ++j) {
            int colA = A.colInd[j];
            float valA = A.values[j];
            for (int k = B.rowPtr[colA]; k < B.rowPtr[colA + 1]; ++k) {
                int colB = B.colInd[k];
                float valB = B.values[k];
                C[i * B.cols + colB] += valA * valB;
            }
        }
    }

    return C;
}
