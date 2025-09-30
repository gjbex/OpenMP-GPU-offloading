module gpu_kernels
    use, intrinsic :: iso_fortran_env, only : dp => REAL64
    implicit none

    integer, parameter :: max_iters = 255

!> Statement to declare module subroutines on target as kernels 

contains

!$OMP declare target

    subroutine init_z(Z, n)
        implicit none
        complex(kind=dp), intent(out) :: Z(n*n)
        integer, intent(in) :: n

        real(kind=dp), parameter :: minv = -1.8d0, maxv = 1.8d0
        real(kind=dp) :: re, im, delta
        integer :: i, j, idx

        delta = (maxv - minv)/n

        !$OMP target teams distribute parallel do
        do i = 1, n
            re = minv + (i - 1)*delta
            do j = 1, n
                im = minv + (j - 1)*delta
                idx = (i - 1)*n + j
                Z(idx) = cmplx(re, im, kind=dp)
            end do
        end do
        !$OMP end target teams distribute parallel do 
    end subroutine init_z

    !> Subroutine to iterate Z
    subroutine iterate_z(Z, countv, n, C)
        implicit none
        integer, intent(in) :: n
        complex(kind=dp), dimension(:), intent(inout) :: Z
        integer, dimension(:), intent(out) :: countv
        complex(kind=dp), intent(in) :: C

        integer :: i, j, idx

        !> Loop over grid
        !$OMP target teams distribute parallel do
        do i = 1, n
            do j = 1, n
                idx = (i - 1)*n + j
                countv(idx) = 0
                do while (abs(Z(idx)) <= 2.0_dp .and. countv(idx) < max_iters)
                    countv(idx) = countv(idx) + 1
                    Z(idx) = Z(idx)**2 + C
                end do
            end do
        end do
        !$OMP end target teams distribute parallel do 

    end subroutine iterate_z

end module gpu_kernels
