module gpu_kernels

implicit none

integer :: ii, jj
integer, parameter :: max_iters = 255

!> Statement to declare module subroutines on target as kernels 
!$OMP declare target
contains

!> Subroutine to initialise Z
subroutine init_z(Z, n)

implicit none

integer, intent(in) :: n
complex, intent(out) :: Z(n*n)

double precision, parameter :: minv = -1.8d0
double precision, parameter :: maxv = 1.8d0

double precision :: re, im
double precision :: delta

integer :: idx

delta = (maxv - minv)/n

!$OMP target teams distribute parallel do
do ii = 1, n
  re = minv + (ii-1)*delta
  do jj = 1, n
    im = minv + (jj-1)*delta
    idx = (ii-1)*n + jj
    Z(idx) = cmplx(re, im)
  end do
end do
!$OMP end target teams distribute parallel do 

end subroutine init_z

!> Subroutine to iterate Z
subroutine iterate_z(Z, countv, n, C)

implicit none

integer, intent(in) :: n
complex, intent(inout) :: Z(n*n)
integer, intent(out) :: countv(n*n)
complex, intent(in) :: C

integer :: idx

!> Loop over grid
!$OMP target teams distribute parallel do
do ii = 1, n
  do jj = 1, n
    idx = (ii-1)*n + jj
    countv(idx) = 0
    do while ( (cabs(Z(idx)) .le. dsqrt(4.d0)) .and. (countv(idx) .lt. max_iters))
      countv(idx) = countv(idx) + 1
      Z(idx) = Z(idx)*Z(idx) + C
    end do
  end do
end do
!$OMP end target teams distribute parallel do 

end subroutine iterate_z

end module gpu_kernels


program julia_omp_gpu
use OMP_lib
use ISO_FORTRAN_ENV
use gpu_kernels, only: init_z, iterate_z

implicit none

integer, parameter :: n = 100
integer, parameter :: max_iters = 255
complex, parameter :: C = (-0.8d0, 0.156d0)

complex :: Z(n*n)
integer :: countv(n*n)

integer :: dev_nr
integer :: ii, jj

dev_nr = omp_get_default_device()
write(error_unit,*) "Using device ", dev_nr

!> Get data from target device, allocate Z on device
!$OMP target data map(from: countv(1:n*n)) map(alloc : Z(1:n*n))
call init_z(Z, N)
call iterate_z(Z, countv, n, C)
!$OMP end target data

!> print
do ii = 1, n
  do jj = 1, n
    write(*,"(I3)",advance="no") countv((ii-1)*n + jj)
  end do
  write(*,*)
end do

end program julia_omp_gpu

