program hello_world
    use :: omp_lib, only : omp_get_num_devices, omp_is_initial_device, omp_get_num_teams, &
                           omp_get_num_threads
    implicit none
    integer :: num_devices
    integer :: nteams
    integer :: nthreads

    ! Get number of devices
    num_devices = omp_get_num_devices()
    print '(A, I0)', 'Number of available devices: ', num_devices

    ! Check wether additional device is found
    ! Note: formatted I/O is not supported on device
    !$OMP target
    if (omp_is_initial_device()) then
        print *, 'Running on host'
    else
        nteams = omp_get_num_teams()
        nthreads = omp_get_num_threads()
        print *, &
            'Running on device with ', nteams, ' teams in total and ', nthreads, &
            ' threads in each team'
    end if
    !$OMP end target

end program hello_world
