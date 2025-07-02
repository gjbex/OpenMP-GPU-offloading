cmake_minimum_required(VERSION 3.20)

project(gpu_offloading VERSION 1.0 LANGUAGES Fortran)

set(CMAKE_Fortran_STANDARD 08)
set(CMAKE_Fortran_EXTENSIONS OFF)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_executable(vector_product_cpu.exe vector_product_cpu.f90)
target_compile_options(vector_product_cpu.exe PRIVATE -fopenmp)
target_link_options(vector_product_cpu.exe PRIVATE -fopenmp)

add_executable(vector_product_gpu.exe vector_product_gpu.f90)
target_compile_options(vector_product_gpu.exe PRIVATE -fopenmp) 
target_link_options(vector_product_gpu.exe PRIVATE -fopenmp) 
