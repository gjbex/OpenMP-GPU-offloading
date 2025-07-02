program vector_product_cpu

    use, intrinsic :: iso_fortran_env, only: dp => real64, sp => real32
    implicit none

    integer, parameter :: rk = sp
    integer :: m = 2048000
    integer :: n = 10000 
    real(kind=rk), dimension(:), allocatable :: vecA, vecB, vecC
    real(kind=rk), parameter :: r = 0.2_rk
    real(kind=rk) :: sum_value
    integer :: i, j

    call cl_arguments(m, n)
    ! Allocate arrays
    allocate(vecA(m), vecB(m), vecC(m))

    vecA = [ (r*i, i = 1, m) ]
    vecB = 2.0_rk
    vecC = 0.0_rk

    !$OMP parallel do private(j) shared(vecA, vecB, vecC, n) default(none)
    do i = 1, size(vecC)
        do j = 1, n
            vecC(i) = vecC(i) + vecA(i)*vecB(i)
        end do
    end do
    !$OMP end parallel do

    sum_value = sum(vecC)

    write(*,*) "The sum is: ", sum_value

    ! Deallocate arrays
    deallocate(vecA, vecB, vecC)

contains

    integer function get_value(i)
        implicit none
        integer, value :: i
        character(len=1024) :: buffer

        call get_command_argument(i, buffer)
        read (buffer, *) get_value
    end function get_value

    subroutine cl_arguments(m, n)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        integer, intent(out) :: m, n
        integer, parameter :: m_default = 2048000, n_default = 10000

        select case(command_argument_count())
            case(0)
                m = m_default
                n = n_default
            case(1)
                m = get_value(1)
                n = n_default
            case(2)
                m = get_value(1)
                n = get_value(2)
            case default
                write (error_unit, '(A)') 'call as device_allocation_gpu [ M [ nr_iterations ] ]'
                stop 1
        end select
    end subroutine cl_arguments

end program vector_product_cpu
