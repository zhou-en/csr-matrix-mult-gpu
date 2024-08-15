// cpu_matrix_multiply.h
#ifndef CPU_MATRIX_MULTIPLY_H
#define CPU_MATRIX_MULTIPLY_H

#include "csr_matrix.h"
#include <vector>

std::vector<float> cpuMatrixMultiply(const CSRMatrix& A, const CSRMatrix& B);

#endif // CPU_MATRIX_MULTIPLY_H
