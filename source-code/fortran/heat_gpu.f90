program heat_gpu

  use OMP_lib 

  implicit none

  integer, parameter :: n = 1000
  integer, parameter :: nr_iters = 100

  double precision :: temp(n*n), temp_new(n*n)
  double precision :: temp_sum

  integer :: it, ii, jj

  !> Move data to device
  !$OMP target enter data map(to:temp(1:n*n)) map(to:temp_new(1:n*n))

  !> Initialise temperature as 0 everywhere
  !$OMP target teams distribute parallel do
  do ii = 1, n
    do jj = 1, n
      temp((ii-1)*n + jj) = 0.d0
    end do
  end do
  !$OMP end target teams distribute parallel do

  !> Perturb boundaries in the jj-direction, set to 1
  !$OMP target teams distribute parallel do
  do ii = 1, n
    temp((ii-1)*n + 1) = 1.d0
    temp_new((ii-1)*n + 1) = 1.d0

    temp((ii-1)*n + n) = 1.d0
    temp_new((ii-1)*n + 1) = 1.d0
  end do
  !$OMP end target teams distribute parallel do

  !> Perturb boundaries in the ii direction, set to 1
  !$OMP target teams distribute parallel do
  do jj = 1, n
    temp(0 + jj) = 1.d0
    temp_new(0 + jj) = 1.d0

    temp((n-1) + jj) = 1.d0
    temp_new((n-1) + jj) = 1.d0
  end do
  !$OMP end target teams distribute parallel do

  !> Start time-iteration loop
  do it = 1, nr_iters
  
    !> Calculate new grid using stencil average scheme
    !$OMP target teams distribute parallel do
    do ii = 2, n-1
      do jj = 2, n-1
        temp_new((ii-1)*n + jj) = 1.d0/4*(temp_new((ii-1)*n + jj - 1) &
                                        + temp_new((ii-1)*n + jj + 1) & 
                                        + temp_new((ii-1 - 1)*n + jj) & 
                                        + temp_new((ii-1 + 1)*n + jj))
      end do
    end do
    !$OMP end target teams distribute parallel do

    !> Update old grid
    !$OMP target teams distribute parallel do
    do ii = 2, n-1
      do jj = 2, n-1
        temp((ii-1)*n + jj) = temp_new((ii-1)*n + jj) 
      end do
    end do
    !$OMP end target teams distribute parallel do

    !> Write output every ... iterations
    if (modulo(it,10) .eq. 0) then

      !> Get data from device to host
      !$OMP target update from(temp(1:n*n))
      
      temp_sum = 0.d0

      do ii = 1, n
        do jj = 1, n
          temp_sum = temp_sum + temp((ii-1)*n + jj)
        end do
      end do

      write(*,*) "iter = ", it, ", sum = ", temp_sum

    end if

  end do

end program heat_gpu

