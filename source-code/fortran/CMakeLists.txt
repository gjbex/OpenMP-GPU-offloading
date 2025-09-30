cmake_minimum_required(VERSION 3.20)

project(gpu_offloading VERSION 1.0 LANGUAGES Fortran)

set(CMAKE_Fortran_STANDARD 08)
set(CMAKE_Fortran_EXTENSIONS OFF)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_executable(vector_product_cpu.exe vector_product_cpu.f90)
target_compile_options(vector_product_cpu.exe PRIVATE -mp)
target_link_options(vector_product_cpu.exe PRIVATE -fopenmp)

add_executable(vector_product_gpu.exe vector_product_gpu.f90)
target_compile_options(vector_product_gpu.exe PRIVATE -mp=gpu) 
target_link_options(vector_product_gpu.exe PRIVATE -mp=gpu) 

add_executable(device_allocation_gpu.exe device_allocation_gpu.f90)
target_compile_options(device_allocation_gpu.exe PRIVATE -mp=gpu) 
target_link_options(device_allocation_gpu.exe PRIVATE -mp=gpu) 

add_executable(hello_world_gpu.exe hello_world_gpu.f90)
target_compile_options(hello_world_gpu.exe PRIVATE -mp=gpu) 
target_link_options(hello_world_gpu.exe PRIVATE -mp=gpu) 

add_executable(julia_omp_gpu.exe julia_omp_gpu.f90)
target_compile_options(julia_omp_gpu.exe PRIVATE -mp=gpu)
target_link_options(julia_omp_gpu.exe PRIVATE -mp=gpu)

add_executable(julia_omp_target_declare.exe
    julia_omp_target_declare.f90
    julia_gpu_kernels.f90)
target_compile_options(julia_omp_target_declare.exe PRIVATE -mp=gpu)
target_link_options(julia_omp_target_declare.exe PRIVATE -mp=gpu)

add_executable(structured_data_region_gpu.exe structured_data_region_gpu.f90)
target_compile_options(structured_data_region_gpu.exe PRIVATE -mp=gpu)
target_link_options(structured_data_region_gpu.exe PRIVATE -mp=gpu)
