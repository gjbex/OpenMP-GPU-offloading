program julia_omp_gpu
use OMP_lib
use ISO_FORTRAN_ENV

implicit none

integer, parameter :: n = 100
integer, parameter :: max_iters = 255
complex, parameter :: C = (-0.8d0, 0.156d0)

double precision, parameter :: minv = -1.8d0
double precision, parameter :: maxv = 1.8d0

double precision :: re, im
double precision :: delta

complex :: Z
integer :: countv(n*n)

integer :: dev_nr
integer :: idx
integer :: ii, jj

!> Check external device
dev_nr = omp_get_default_device()
write(error_unit,*) "Using device ", dev_nr

!>  Main calculation
delta = (maxv - minv)/n
!$OMP target teams distribute parallel do map(tofrom: countv(1:n*n))
do ii = 1, n 
  re = minv + (ii-1)*delta 
  do jj = 1, n
    im = minv + (jj-1)*delta
    idx = (ii-1)*n + jj
    countv(idx) = 0
    Z = cmplx(re, im)
    do while ( (cabs(Z) .le. dsqrt(4.d0)) .and. (countv(idx) .lt. max_iters))
      countv(idx) = countv(idx) + 1
      Z = Z*Z + C
    end do
  end do
end do
!$OMP end target teams distribute parallel do 

!> Print Julia set image
do ii = 1, n
  do jj = 1, n
    write(*,"(I3)",advance="no") countv((ii-1)*n + jj)
  end do
  write(*,*)
end do

end program julia_omp_gpu
