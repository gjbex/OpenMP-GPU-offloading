program device_allocation_gpu

use, intrinsic :: omp_lib, only : omp_get_default_device, omp_target_alloc
use, intrinsic :: iso_c_binding, only : c_double, c_float, c_ptr, c_int, c_size_t, c_sizeof, c_f_pointer
use, intrinsic :: iso_fortran_env, only : REAL64, REAL32

implicit none

integer, parameter :: rk = REAL64
integer, parameter :: c_rk = c_double
integer, parameter :: n = 1000
integer, parameter :: nr_iters = 10
type(c_ptr) :: b_dev_ptr
real(kind=c_rk), dimension(:), pointer :: b
integer(kind=c_size_t) :: dbl_bytes
integer(kind=c_int) :: dev
real(kind=rk), dimension(n, n) :: a
real(kind=rk) :: total
integer :: i, j, iter

! Get device
dev = omp_get_default_device()

! Move array a to target device
!$OMP target enter data map(to: a(n, n))

! Initialise a on target device, note: not required, only for demonstration
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

call c_f_pointer(b_dev_ptr, b, [n*n])

! Initialise b on target device
!$OMP target teams distribute parallel do is_device_ptr(b) default(none) private(j) shared(b, n)
do i = 1, n
  do j = 1, n
    b((i-1)*n + j) = 1.0_rk*((i-1)*n + (j-1))/(n*n)
  end do
end do
!$OMP end target teams distribute parallel do

! Main loop, on target device
do iter = 1, nr_iters
  !$OMP target teams distribute parallel do is_device_ptr(b) default(none) private(j) shared(a, b, n)
  do i = 1, n
    do j = 1,n
      a(i, j)  = b((i-1)*n + j)
    end do
  end do
  !$OMP end target teams distribute parallel do
end do

! Extract data from target
!$OMP target exit data map(from: a(n, n))

! Free device memory
call omp_target_free(b_dev_ptr, dev)

! Show resullt
print '(A10 E25.15)', 'sum = ', sum(a)

! Compute and show expected result
total = 0.0_rk
do i = 1, n
  do j = 1, n
    total = 1.0_rk*((i-1)*n + (j-1))/(n*n)
  end do
end do
print '(A10 E25.15)', 'expected = ', total

end program device_allocation_gpu
