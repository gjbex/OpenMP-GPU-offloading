program vector_product_gpu

use OMP_lib
use iso_c_binding

implicit none

integer, parameter :: n = 10000 
integer, parameter :: m = 2048000


type(c_ptr) :: A_dev_ptr, B_dev_ptr, C_dev_ptr
real(c_double), pointer :: vecA(:), vecB(:), vecC(:)

integer(c_size_t) :: dbl_bytes
integer(c_int) :: dev

double precision, parameter :: r = 0.2d0
double precision :: sumv

integer :: ii, jj

dbl_bytes = c_sizeof(real(1.d0,kind=c_double))
dev = omp_get_default_device()

A_dev_ptr = omp_target_alloc(m*dbl_bytes, dev)
B_dev_ptr = omp_target_alloc(m*dbl_bytes, dev)
C_dev_ptr = omp_target_alloc(m*dbl_bytes, dev)

call c_f_pointer(A_dev_ptr, vecA, [m])
call c_f_pointer(B_dev_ptr, vecB, [m])
call c_f_pointer(C_dev_ptr, vecC, [m])

!$OMP target teams loop is_device_ptr(vecA, vecB, vecC)
do ii = 1, m
  vecA(ii) = r*ii
  vecB(ii) = 2.1d0
  vecC(ii) = 0.d0
end do
!$OMP end target teams loop

!$OMP target teams loop is_device_ptr(vecA, vecB, vecC)
do ii = 1, m 
  do jj = 1, n
    vecC(ii) = vecC(ii) + vecA(ii)*vecB(ii)
  end do
end do
!$OMP end target teams loop

sumv = 0.d0

!$OMP target teams loop reduction(+:sumv) is_device_ptr(vecA, vecB, vecC)
do ii = 1, m
  sumv = sumv + vecC(ii)
end do
!$OMP end target teams loop

write(*,*) "The sum is: ", sumv

end program vector_product_gpu
