#include <stdio.h>
#include  <omp.h>

#define N 512
#define NUM_TEAMS 4

void reset_arrays(int *team_array, int *thread_array) {
    for (int i = 0; i < N; i++) {
        team_array[i] = -1;
        thread_array[i] = -1;
    }
}

int main() {
    int team_array[N];
    int thread_array[N];
    reset_arrays(team_array, thread_array);

#pragma omp target teams num_teams(NUM_TEAMS) thread_limit(128) map(tofrom: team_array[0:N], thread_array[0:N])
    {
#pragma omp distribute
        for (int i = 0; i < N; i++) {
            team_array[i] = omp_get_team_num();
            thread_array[i] = omp_get_thread_num();
        }
    }

    printf("Results 'distribute'\n");
    for (int i = 0; i < N; i++) {
        printf("team_array[%3d] = %d, thread_array[%3d] = %d\n", i, team_array[i], i, thread_array[i]);
    }
    reset_arrays(team_array, thread_array);

#pragma omp target teams num_teams(NUM_TEAMS) thread_limit(128) map(tofrom: team_array[0:N], thread_array[0:N])
    {
#pragma omp distribute parallel for
        for (int i = 0; i < N; i++) {
            team_array[i] = omp_get_team_num();
            thread_array[i] = omp_get_thread_num();
        }
    }

    printf("-------------------------------------------------\n");

    printf("Results 'distribute parallel for'\n");
    for (int i = 0; i < N; i++) {
        printf("team_array[%3d] = %d, thread_array[%3d] = %d\n", i, team_array[i], i, thread_array[i]);
    }
    reset_arrays(team_array, thread_array);

#pragma omp target teams num_teams(NUM_TEAMS) thread_limit(128) map(tofrom: team_array[0:N], thread_array[0:N])
    {
#pragma omp parallel for
        for (int i = 0; i < N; i++) {
            team_array[i] = omp_get_team_num();
            thread_array[i] = omp_get_thread_num();
        }
    }

    printf("-------------------------------------------------\n");

    printf("Results 'parallel for (race condition)'\n");
    for (int i = 0; i < N; i++) {
        printf("team_array[%3d] = %d, thread_array[%3d] = %d\n", i, team_array[i], i, thread_array[i]);
    }
    reset_arrays(team_array, thread_array);

    int visited[NUM_TEAMS*N] = {0};
#pragma omp target teams num_teams(NUM_TEAMS) thread_limit(128) map(tofrom: visited[0:NUM_TEAMS*N])
    {
#pragma omp parallel for
        for (int i = 0; i < N; i++) {
            visited[omp_get_team_num()*N + i] = 1;
        }
    }

    printf("-------------------------------------------------\n");

    printf("Results 'parallel for' per-team coverage; no output means every team executed every iteration\n");
    for (int i = 0; i < NUM_TEAMS; i++) {
        for (int j = 0; j < N; j++) {
            if (visited[i*N + j] != 1) {
                printf("Error: visited[%d][%d] = %d\n", i, j, visited[i*N + j]);
            }
        }
    }

    return 0;
}
