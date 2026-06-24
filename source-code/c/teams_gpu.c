#include <omp.h>
#include <stdio.h>
#include <stdlib.h>

void print_number_teams_threads(char *message) {
    const int num_teams = omp_get_num_teams();
    const int team_num = omp_get_team_num();
    const int num_threads = omp_get_num_threads();
    printf("%s: number of teams: %d, team number: %d, number of threads: %d\n",
            message, num_teams, team_num, num_threads);
}

int main(int argc, char **argv) {
    printf("host device: %d\n", omp_is_initial_device());
    printf("nr.devices: %d, default devide: %d\n",
            omp_get_num_devices(), omp_get_default_device());
    const int max_num_teams = argc > 1 ? atoi(argv[1]) : 1;
    const int max_num_threads = argc > 2 ? atoi(argv[2]) : 1;
    if (argc > 1) {
        printf("Using %d teams and %d thread limit\n", max_num_teams,
                max_num_threads);
#pragma omp target teams num_teams(max_num_teams) thread_limit(max_num_threads)
        {
            print_number_teams_threads("Outside parallel region");
#pragma omp parallel
            {
#pragma omp single
                {
                    print_number_teams_threads("Inside parallel region");
                }
            }
        }
    } else {
        printf("Using default number of teams and thread limit\n");
#pragma omp target teams
        {
            print_number_teams_threads("Outside parallel region");
#pragma omp parallel
            {
#pragma omp single
                {
                    print_number_teams_threads("Inside parallel region");
                }
            }
        }
    }
    return 0;
}
