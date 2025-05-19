program vector_product_gpu

implicit none

integer, parameter :: n = 10000 
integer, parameter :: m = 2048000

double precision :: vecA(m), vecB(m), vecC(m)
double precision, parameter :: r = 0.2d0

double precision :: sumv

integer :: ii, jj

do ii = 1, m
  vecA(ii) = r*ii
  vecB(ii) = 2.1d0
  vecC(ii) = 0.d0
end do

!$OMP target teams loop map(to: vecA(1:m), vecB(1:m)) map(tofrom: vecC(1:m))
do ii = 1, m 
  do jj = 1, n
    vecC(ii) = vecC(ii) + vecA(ii)*vecB(ii)
  end do
end do
!$OMP end target teams loop

sumv = 0.d0
do ii = 1, m
  sumv = sumv + vecC(ii)
end do

write(*,*) "The sum is: ", sumv

end program vector_product_gpu
