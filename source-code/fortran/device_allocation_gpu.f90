program device_allocation_gpu

use OMP_lib
use iso_c_binding

implicit none

integer, parameter :: n = 1000
integer, parameter :: nr_iters = 10

type(c_ptr) :: b_dev_ptr
real(c_double), pointer :: b(:)
integer(c_size_t) :: dbl_bytes
integer(c_int) :: dev
double precision :: a(n*n)

double precision :: sumv
integer :: ii, jj, iter

!> Move a array to target device
!$OMP target enter data map(to: a(1:n*n))

!> Initialise a on target device
!$OMP target teams distribute parallel do
do ii = 1, n
  a((ii-1)*n + ii) = 0.d0
end do
!$OMP end target teams distribute parallel do

!> Allocate b on device
dbl_bytes = c_sizeof(real(1.d0,kind=c_double))
dev = omp_get_default_device()
b_dev_ptr = omp_target_alloc(n*n*dbl_bytes, dev)

call c_f_pointer(b_dev_ptr, b, [n*n])

!> Initialise b on target device
!$OMP target teams distribute parallel do is_device_ptr(b)
do ii = 1,n
  do jj = 1,n
    b((ii-1)*n + jj) = 1.d0*((ii-1)*n + (jj-1))/(n*n)
  end do
end do
!$OMP end target teams distribute parallel do

!> Main loop, on target device
do iter = 1, nr_iters
  !$OMP target teams distribute parallel do is_device_ptr(b)
  do ii = 1, n
    do jj = 1,n
      a((ii-1)*n + jj)  = b((ii-1)*n + jj)
    end do
  end do
  !$OMP end target teams distribute parallel do
end do

!> Extract data from target
!$OMP target exit data map(from: a(1:n*n))

sumv = 0.d0
do ii = 1, n
  do jj = 1, n
    sumv = sumv + a((ii-1)*n + jj)
  end do
end do
write(*,*) "sum = ", sumv

end program device_allocation_gpu
