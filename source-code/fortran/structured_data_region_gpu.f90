program structured_data_region_gpu
    use, intrinsic :: iso_fortran_env, only : dp => REAL64, output_unit
    implicit none
    integer, parameter :: n = 1000, nr_iters = 10
    real(Kind=dp), dimension(n*n) :: a, b
    real(kind=dp) :: sumv
    integer :: i, j, iter

    !$OMP target data map(tofrom: a(1:n*n))
        !$OMP target teams distribute parallel do
        do i = 1, n*n
            a(i) = 0.0_dp
        end do
        !$OMP end target teams distribute parallel do

        do i = 1,n
            do j = 1,n
                b((i - 1)*n + j) = 1.0_dp*((i - 1)*n + (j - 1))/n**2
            end do
        end do

        !$OMP target data map(to: b(1:n*n))
            do iter = 1, nr_iters
                !$OMP target teams distribute parallel do
                do i = 1, n
                    do j = 1,n
                        a((i - 1)*n + j) = a((i - 1)*n + j) + b((i - 1)*n + j)
                    end do
                end do
                !$OMP end target teams distribute parallel do
            end do
        !$OMP end target data
    !$OMP end target data

    sumv = sum(a)
    write(output_unit, fmt='(A, I0)') "sum = ", sumv

end program structured_data_region_gpu
