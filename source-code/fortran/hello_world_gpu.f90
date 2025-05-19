program hello_world

use OMP_lib

implicit none

integer :: num_devices
integer :: nteams
integer :: nthreads

!> Get number of devices
num_devices = omp_get_num_devices()
write(*,*) "Number of available devices", num_devices

!> Check wether additional device is found
!$OMP target
if (omp_is_initial_device()) then
    write(*,*) "Running on host"
else
    nteams = omp_get_num_teams()
    nthreads = omp_get_num_threads()
    write(*,*) "Running on device with ", nteams, " teams in total and ", nthreads, " threads in each team"
end if
!$OMP end target

end program hello_world
