# Fortran

Fortran examples for OpenMP GPU offloading.


## What is it?

1. `vector_product_gpu.f90`: application that computes a vector product
   on the GPU.
1. `vector_product_cpu.f90`: application that computes a vector product
   on the CPU.
1. `CMAKELists.txt`: CMake file to build the applications.
1. `hello_world_gpu.f90`: application that checks the number of threads
   and teams on the device.
1. `julia_omp_gpu.f90`: application that computes a Julia set on the GPU.
1, `julia_gpu_kernels.f90`: GPU kernels to compute the Julia set.
1. `julia_omp_target_declare.f90`: application that computes a Julia set
   on the GPU using the `declare target` directive.
1. `device_allocation_gpu.f90`: application that demonstrates how to
   allocate memory on the GPU.
1. `structured_data_region_gpu.f90`: application that demonstrates
   the use of the `target` directive with a structured data region.
1. `unstructured_data_region_gpu.f90`: application that demonstrates
   the use of the `target` directive with an unstructured data region.
1. `heat_gpu.f90`: application that solves the heat equation on the GPU and
   illustrates how to update data between device and host.
1. `CMakeLists.txt`: CMake file to build the applications.


## How to build?

If necessary, set the appropriate environment variable to use the NVIDIA
ocmpiler, e.g.,
```bash
$ export CC=nvc
```
