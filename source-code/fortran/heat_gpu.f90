program heat_gpu
    use, intrinsic :: iso_fortran_env, only : dp => REAL64
    use, intrinsic :: omp_lib 
    implicit none
    integer, parameter :: n = 1000, nr_iters = 100
    real(Kind=dp), dimension(n*n) :: temp, temp_new
    real(kind=dp) :: temp_sum
    integer :: iter, i, j

    !> Move data to device
    !$OMP target enter data map(to:temp(1:n*n)) map(to:temp_new(1:n*n))

    !> Initialise temperature as 0 everywhere
    !$OMP target teams distribute parallel do
    do i = 1, n*n
        temp(i) = 0.0_dp
    end do
    !$OMP end target teams distribute parallel do

    !> Perturb boundaries in the j-direction, set to 1
    !$OMP target teams distribute parallel do
    do i = 1, n
        temp((i - 1)*n + 1) = 1.0_dp
        temp_new((i - 1)*n + 1) = 1.0_dp
        temp((i - 1)*n + n) = 1.0_dp
        temp_new((i - 1)*n + 1) = 1.0_dp
    end do
    !$OMP end target teams distribute parallel do

    !> Perturb boundaries in the i direction, set to 1
    !$OMP target teams distribute parallel do
    do j = 1, n
        temp(0 + j) = 1.0_dp
        temp_new(0 + j) = 1.0_dp
        temp(n - 1 + j) = 1.0_dp
        temp_new(n - 1 + j) = 1.0_dp
    end do
    !$OMP end target teams distribute parallel do

    !> Start time-iteration loop
    do iter = 1, nr_iters
        !> Calculate new grid using stencil average scheme
        !$OMP target teams distribute parallel do
        do i = 2, n - 1
            do j = 2, n - 1
                temp_new((i - 1)*n + j) = 0.25_dp*(temp_new((i - 1)*n + j - 1) &
                                                    + temp_new((i - 1)*n + j + 1) & 
                                                    + temp_new((i - 1 - 1)*n + j) & 
                                                    + temp_new((i- 1 + 1)*n + j))
            end do
        end do
        !$OMP end target teams distribute parallel do

        !> Update old grid
        !$OMP target teams distribute parallel do
        do i = 2, n  -1
            do j = 2, n - 1
                temp((i - 1)*n + j) = temp_new((i - 1)*n + j) 
            end do
        end do
        !$OMP end target teams distribute parallel do

        !> Write output every ... iterations
        if (mod(iter, 10) .eq. 0) then
            !> Get data from device to host
            !$OMP target update from(temp(1:n*n))
            temp_sum = sum(temp)
            print '(A, I0, A, F10.4)', 'iter = ', iter, ', sum = ', temp_sum
        end if
    end do

end program heat_gpu
