// csr_matrix.cpp
#include "csr_matrix.h"
#include <random>

CSRMatrix generateRandomSparseMatrix(int rows, int cols, int nnz) {
    CSRMatrix mat;
    mat.rows = rows;
    mat.cols = cols;
    mat.rowPtr.resize(rows + 1, 0);

    std::vector<int> tempColInd;
    std::vector<float> tempValues;

    std::default_random_engine generator;
    std::uniform_int_distribution<int> colDistribution(0, cols - 1);
    std::uniform_real_distribution<float> valDistribution(0.0, 1.0);

    int currentNNZ = 0;
    for (int i = 0; i < rows; ++i) {
        int rowNNZ = nnz / rows;
        mat.rowPtr[i] = currentNNZ;

        for (int j = 0; j < rowNNZ; ++j) {
            int col = colDistribution(generator);
            float val = valDistribution(generator);

            tempColInd.push_back(col);
            tempValues.push_back(val);
            currentNNZ++;
        }
    }

    mat.rowPtr[rows] = currentNNZ;
    mat.colInd = std::move(tempColInd);
    mat.values = std::move(tempValues);

    return mat;
}
