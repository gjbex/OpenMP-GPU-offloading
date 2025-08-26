program device_allocation_gpu

    use, intrinsic :: omp_lib, only : omp_get_default_device, omp_target_alloc, &
                                      omp_target_free
    use, intrinsic :: iso_c_binding, only : c_double, c_float, c_ptr, c_int, &
                                            c_size_t, c_sizeof, c_f_pointer, &
                                            c_associated
    use, intrinsic :: iso_fortran_env, only : REAL64, REAL32, error_unit

    implicit none

    integer, parameter :: rk = REAL64
    integer, parameter :: c_rk = c_double
    integer :: n, nr_iters
    type(c_ptr) :: b_dev_ptr
    real(kind=c_rk), dimension(:), pointer :: b
    integer(kind=c_size_t) :: dbl_bytes
    integer(kind=c_int) :: dev
    real(kind=rk), dimension(:, :), allocatable :: a
    real(kind=rk) :: total
    integer :: i, j, iter, status

    ! Get command line arguments
    call cl_arguments(n, nr_iters)

    ! Allocate array a
    allocate(a(n, n), stat=status)
    if (status /= 0) then
        write (error_unit, '(A, I0, A, I0, A)') &
            'can not allocate ', n, ' by ', n, ' host array'
        stop 2
    end if

    ! Get device
    dev = omp_get_default_device()

    ! Move array a to target device
    !$OMP target enter data map(to: a(1:n, 1:n))

    ! Initialise a on target device
    !$OMP target teams distribute parallel do
    do i = 1, n
        do j = 1, n
            a(i,j) = 0.0_rk
        end do
    end do
    !$OMP end target teams distribute parallel do

    ! Allocate b on device
    dbl_bytes = c_sizeof(real(1.0_rk, kind=c_rk))
    b_dev_ptr = omp_target_alloc(n*n*dbl_bytes, dev)
    if (.not. c_associated(b_dev_ptr)) then
        write (error_unit, '(A, I0, A, I0, A)') 'can not device allocate ', n, '*', n, ' device array'
        stop 2
    end if

    call c_f_pointer(b_dev_ptr, b, [n*n])

    ! Initialise b on target device
    !$OMP target teams distribute parallel do default(none) private(j) shared(b, n)
    do i = 1, n
        do j = 1, n
            b((i-1)*n + j) = ((i-1.0_rk)*n + (j-1.0_rk))/(n*n)
        end do
    end do
    !$OMP end target teams distribute parallel do

    ! Main loop, on target device
    do iter = 1, nr_iters
        !$OMP target teams distribute parallel do default(none) private(j) shared(a, b, n)
        do i = 1, n
            do j = 1,n
                a(i, j) = a(i, j) + b((i-1)*n + j)
            end do
        end do
        !$OMP end target teams distribute parallel do
    end do

    ! Extract data from target
    !$OMP target exit data map(from: a(1:n, 1:n))

    ! Free device memory
    ! call omp_target_free(b_dev_ptr, dev)

    ! Show resullt
    print '(A10 E25.15)', 'sum = ', sum(a)

    ! Deallocate array a
    deallocate(a)

    ! Compute and show expected result
    total = 0.0_rk
    do i = 1, n
        do j = 1, n
            total = total + 1.0_rk*((i-1)*n + (j-1))/(n*n)
        end do
    end do
    print '(A10 E25.15)', 'expected = ', total*nr_iters

    call omp_target_free(b_dev_ptr, dev)

contains

    integer function get_value(i)
        implicit none
        integer, value :: i
        character(len=1024) :: buffer

        call get_command_argument(i, buffer)
        read (buffer, *) get_value
    end function get_value

    subroutine cl_arguments(n, p)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        integer, intent(out) :: n, p
        integer, parameter :: n_default = 1000, p_default = 10

        select case(command_argument_count())
            case(0)
                n = n_default
                p = p_default
            case(1)
                n = get_value(1)
                p = p_default
            case(2)
                n = get_value(1)
                p = get_value(2)
            case default
                write (error_unit, '(A)') 'call as device_allocation_gpu [ N [ nr_iterations ] ]'
                stop 1
        end select
    end subroutine cl_arguments

end program device_allocation_gpu
