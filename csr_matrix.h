// csr_matrix.h
#ifndef CSR_MATRIX_H
#define CSR_MATRIX_H

#include <vector>

struct CSRMatrix {
    int rows;
    int cols;
    std::vector<int> rowPtr;
    std::vector<int> colInd;
    std::vector<float> values;
};

CSRMatrix generateRandomSparseMatrix(int rows, int cols, int nnz);

#endif // CSR_MATRIX_H
