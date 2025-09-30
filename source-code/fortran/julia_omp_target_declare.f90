program julia_omp_gpu
    use, intrinsic :: omp_lib, only : omp_get_default_device
    use, intrinsic :: iso_fortran_env, only : dp => REAL64, error_unit, output_unit
    use :: gpu_kernels, only: init_z, iterate_z
    implicit none
    integer, parameter :: n = 100, max_iters = 255
    complex(Kind=dp), parameter :: C = (-0.8_dp, 0.156_dp)
    complex(kind=dp), dimension(n*n) :: Z
    integer, dimension(n*n) :: countv
    integer :: i, j, dev_nr

    dev_nr = omp_get_default_device()
    write(error_unit, fmt='(A, I0)') 'Using device ', dev_nr

    !> Get data from target device, allocate Z on device
    !$OMP target data map(from: countv(1:n*n)) map(alloc : Z(1:n*n))
    call init_z(Z, n)
    call iterate_z(Z, countv, n, C)
    !$OMP end target data

    !> print
    do i = 1, n
        do j = 1, n
            write(output_unit, fmt='(I4)', advance='no') countv((i - 1)*n + j)
        end do
        write(output_unit, *)
    end do

end program julia_omp_gpu
