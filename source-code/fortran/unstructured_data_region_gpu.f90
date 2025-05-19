program unstructured_data_region_gpu

implicit none

integer, parameter :: n = 1000
integer, parameter :: nr_iters = 10

double precision :: a(n*n), b(n*n)
double precision :: sumv
integer :: ii, jj, iter

!$OMP target enter data map(to: a(1:n*n))

!$OMP target teams distribute parallel do
do ii = 1, n
  a((ii-1)*n + ii) = 0.d0
end do
!$OMP end target teams distribute parallel do

do ii = 1,n
  do jj = 1,n
    b((ii-1)*n + jj) = 1.d0*((ii-1)*n + (jj-1))/(n*n)
  end do
end do


!$OMP target enter data map(to: b(1:n*n))

do iter = 1, nr_iters
  !$OMP target teams distribute parallel do
  do ii = 1, n
    do jj = 1,n
      a((ii-1)*n + jj) = a((ii-1)*n + jj) + b((ii-1)*n + jj)
    end do
  end do
  !$OMP end target teams distribute parallel do
end do

!$OMP target exit data map(from: a(1:n*n))

sumv = 0.d0
do ii = 1, n
  do jj = 1, n
    sumv = sumv + a((ii-1)*n + jj)
  end do
end do
write(*,*) "sum = ", sumv

end program unstructured_data_region_gpu
