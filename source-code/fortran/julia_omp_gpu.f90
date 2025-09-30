program julia_omp_gpu
    use, intrinsic :: omp_lib, only : omp_get_default_device
    use, intrinsic :: iso_fortran_env, only : dp => REAL64, error_unit, output_unit
    implicit none

    integer, parameter :: n = 100, max_iters = 255
    complex(kind=dp), parameter :: C = (-0.8_dp, 0.156_dp)
    real(kind=dp), parameter :: minv = -1.8_dp, maxv = 1.8_dp
    real(kind=dp) :: re, im, delta
    complex(kind=dp) :: Z
    integer, dimension(n*n) :: countv
    integer :: dev_nr
    integer :: idx, i, j

    !> Check external device
    dev_nr = omp_get_default_device()
    write(error_unit, fmt='(A, I0)') "Using device ", dev_nr

    !>  Main calculation
    delta = (maxv - minv)/n
    !$OMP target teams distribute parallel do map(tofrom: countv(1:n*n))
    do i = 1, n 
        re = minv + (i-1)*delta 
        do j = 1, n
            im = minv + (j - 1)*delta
            idx = (i - 1)*n + j
            countv(idx) = 0
            Z = cmplx(re, im, kind=dp)
            do while (abs(Z) <= 2.0_dp .and. countv(idx) < max_iters)
                countv(idx) = countv(idx) + 1
                Z = Z**2 + C
            end do
        end do
    end do
    !$OMP end target teams distribute parallel do 

    !> Print Julia set image
    do i = 1, n
        do j = 1, n
            write(output_unit, fmt='(I4)', advance='no') countv((i - 1)*n + j)
        end do
        write(output_unit, *)
    end do

end program julia_omp_gpu
