# Compiler and Flags
CXX = g++
NVCC = nvcc
CXXFLAGS = -std=c++11 -O3
NVCCFLAGS = -std=c++11 -O3

# Include directories
INCLUDES = -I.

# Object files
OBJS = main.o csr_matrix.o cpu_matrix_multiply.o gpu_matrix_multiply.o

# Executable
TARGET = matrix_multiply

# Default target
all: $(TARGET)

# Link the object files into the executable
$(TARGET): $(OBJS)
	$(NVCC) $(NVCCFLAGS) $(OBJS) -o $(TARGET)

# Compile the main.cpp file
main.o: main.cpp csr_matrix.h cpu_matrix_multiply.h
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c main.cpp

# Compile the csr_matrix.cpp file
csr_matrix.o: csr_matrix.cpp csr_matrix.h
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c csr_matrix.cpp

# Compile the cpu_matrix_multiply.cpp file
cpu_matrix_multiply.o: cpu_matrix_multiply.cpp cpu_matrix_multiply.h csr_matrix.h
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c cpu_matrix_multiply.cpp

# Compile the gpu_matrix_multiply.cu file
gpu_matrix_multiply.o: gpu_matrix_multiply.cu csr_matrix.h
	$(NVCC) $(NVCCFLAGS) $(INCLUDES) -c gpu_matrix_multiply.cu

# Clean target: removes all object files and the executable
clean:
	rm -f $(OBJS) $(TARGET)

# Phony targets to avoid filename conflicts
.PHONY: all clean
