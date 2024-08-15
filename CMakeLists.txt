cmake_minimum_required(VERSION 3.29)
project(MatrixMultiplications LANGUAGES CXX CUDA)

set(CMAKE_CUDA_STANDARD 20)

# Specify CUDA architectures
#set(CMAKE_CUDA_ARCHITECTURES "86")

# Find CUDA
#find_package(CUDA REQUIRED)

# Add executable
add_executable(MatrixMultiplications main.cpp csr_matrix.cpp cpu_matrix_multiply.cpp gpu_matrix_multiply.cu)

# Link CUDA libraries
target_link_libraries(MatrixMultiplications ${CUDA_LIBRARIES})

# Include CUDA directories
include_directories(${CUDA_INCLUDE_DIRS})

set_target_properties(MatrixMultiplications PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON)