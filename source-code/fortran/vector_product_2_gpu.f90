program vector_product_gpu

implicit none

integer, parameter :: n = 10000 
integer, parameter :: m = 2048000

double precision :: vecA(m), vecB(m), vecC(m)
double precision, parameter :: r = 0.2d0

double precision :: sumv

integer :: ii, jj

!$OMP target data map(to: vecA(1:m), vecB(1:m)) map(tofrom: vecC(1:m))

!$OMP target loop 
do ii = 1, m
  vecA(ii) = r*ii
  vecB(ii) = 2.1d0
  vecC(ii) = 0.d0
end do
!$OMP end target loop

!$OMP target loop 
do ii = 1, m 
  do jj = 1, n
    vecC(ii) = vecC(ii) + vecA(ii)*vecB(ii)
  end do
end do
!$OMP end target loop

sumv = 0.d0
!$OMP target loop reduction(+:sumv)
do ii = 1, m
  sumv = sumv + vecC(ii)
end do
!$OMP end target loop

!$OMP end target data

write(*,*) "The sum is: ", sumv

end program vector_product_gpu
