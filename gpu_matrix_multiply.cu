// gpu_matrix_multiply.cu
#include "csr_matrix.h"
#include <cuda_runtime.h>
#include <vector>
#include <iostream>

__global__ void spmv_csr_vector_kernel(int m, const int *rowPtr, const int *colInd, const float *values, const float *x, float *y) {
    int row = blockDim.x * blockIdx.x + threadIdx.x;
    if (row < m) {
        float dot = 0.0f;
        for (int idx = rowPtr[row]; idx < rowPtr[row + 1]; ++idx) {
            dot += values[idx] * x[colInd[idx]];
        }
        y[row] += dot;
    }
}

float gpuMatrixMultiply(const CSRMatrix& A, const CSRMatrix& B, float* C) {

    // Create CUDA events for timing
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    // Start timing GPU code
    cudaEventRecord(start);

    int *d_rowPtr_A, *d_colInd_A, *d_rowPtr_B, *d_colInd_B;
    float *d_values_A, *d_values_B, *d_C;

    cudaMalloc((void**)&d_rowPtr_A, A.rowPtr.size() * sizeof(int));
    cudaMalloc((void**)&d_colInd_A, A.colInd.size() * sizeof(int));
    cudaMalloc((void**)&d_values_A, A.values.size() * sizeof(float));
    cudaMalloc((void**)&d_rowPtr_B, B.rowPtr.size() * sizeof(int));
    cudaMalloc((void**)&d_colInd_B, B.colInd.size() * sizeof(int));
    cudaMalloc((void**)&d_values_B, B.values.size() * sizeof(float));
    cudaMalloc((void**)&d_C, A.rows * B.cols * sizeof(float));

    cudaMemcpy(d_rowPtr_A, A.rowPtr.data(), A.rowPtr.size() * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_colInd_A, A.colInd.data(), A.colInd.size() * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_values_A, A.values.data(), A.values.size() * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_rowPtr_B, B.rowPtr.data(), B.rowPtr.size() * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_colInd_B, B.colInd.data(), B.colInd.size() * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_values_B, B.values.data(), B.values.size() * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemset(d_C, 0, A.rows * B.cols * sizeof(float));

    dim3 blockDim(1024);
    dim3 gridDim((A.rows + blockDim.x - 1) / blockDim.x);

    spmv_csr_vector_kernel<<<gridDim, blockDim>>>(A.rows, d_rowPtr_A, d_colInd_A, d_values_A, d_values_B, d_C);

    cudaMemcpy(C, d_C, A.rows * B.cols * sizeof(float), cudaMemcpyDeviceToHost);

    cudaFree(d_rowPtr_A);
    cudaFree(d_colInd_A);
    cudaFree(d_values_A);
    cudaFree(d_rowPtr_B);
    cudaFree(d_colInd_B);
    cudaFree(d_values_B);
    cudaFree(d_C);

    // Stop timing GPU code
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float elapsedTime;
    cudaEventElapsedTime(&elapsedTime, start, stop);
    std::cout << "CUDA kernel execution time: " << elapsedTime / 1000 << " sec\n";
    return elapsedTime/1000;

}
