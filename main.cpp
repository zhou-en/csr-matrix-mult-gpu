// main.cpp
#include "csr_matrix.h"
#include "cpu_matrix_multiply.h"
#include <iostream>
#include <chrono>
#include <vector>

float gpuMatrixMultiply(const CSRMatrix& A, const CSRMatrix& B, float* C);

int main() {
    int rows = 10000000;
    int cols = 10000000;
    int nnz = 500000;

    CSRMatrix A = generateRandomSparseMatrix(rows, cols, nnz);
    CSRMatrix B = generateRandomSparseMatrix(cols, rows, nnz);

    auto startCPU = std::chrono::high_resolution_clock::now();
    std::vector<float> C_cpu = cpuMatrixMultiply(A, B);
    auto endCPU = std::chrono::high_resolution_clock::now();

    // auto startGPU = std::chrono::high_resolution_clock::now();
    std::vector<float> C_gpu(A.rows * B.cols);
    float gpuTime = gpuMatrixMultiply(A, B, C_gpu.data());
    // auto endGPU = std::chrono::high_resolution_clock::now();

    // Verify the results
    bool isCorrect = true;
    for (int i = 0; i < C_cpu.size(); ++i) {
        if (abs(C_cpu[i] - C_gpu[i]) > 1e-5) {
            isCorrect = false;
            break;
        }
    }

    std::cout << "Results are " << (isCorrect ? "correct" : "incorrect") << std::endl;

    // Timing
    std::chrono::duration<double> cpuTime = endCPU - startCPU;
    // std::chrono::duration<double> gpuTime = endGPU - startGPU;

    std::cout << "CPU Time: " << cpuTime.count() << " seconds" << std::endl;
    // std::cout << "GPU Time: " << gpuTime.count() << " seconds" << std::endl;
    std::cout << "GPU Time: " << gpuTime << " seconds" << std::endl;

    double speedup = cpuTime.count() / gpuTime;
    std::cout << "Speedup: " << speedup << "x" << std::endl;

    return 0;
}
