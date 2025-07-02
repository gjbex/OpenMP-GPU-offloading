#include <stdio.h>
#include <stdlib.h>
#ifdef _OPENMP
#include <omp.h>
#endif

int main(int argc, char *argv[]) {
    // handle command line arguments
    const int n = argc > 1 ? atoi(argv[1]) : 1000;
    const int nr_iters = argc > 2 ? atoi(argv[2]) : 10;

    // create array a
    float *a = (float *) malloc(n*n*sizeof(float));
    if (!a) {
        fprintf(stderr, "malloc failed\n");
        return 1;
    }

    // map array a to device
#pragma omp target enter data map(to:a[0:n*n])

    // initialize array a on device
#pragma omp target teams distribute parallel for
    for (int i = 0; i < n; i++) {
        a[i*n + i] = 0.0f;
    } 

    // allocate memory on the device for array b
    float *b = (float *) omp_target_alloc(n*n*sizeof(float), omp_get_default_device());
    if (!b) {
        fprintf(stderr, "omp_target_alloc failed\n");
        return 1;
    }

    // initialize values of array b
#pragma omp target teams distribute parallel for is_device_ptr(b)
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            b[i*n + j] = ((float) (i*n + j))/(n*n);
        }
    }

    // compute value of array a on device
    for (int iter = 0; iter < nr_iters; iter++) {
#pragma omp target teams distribute parallel for is_device_ptr(b)
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                a[i*n + j] += b[i*n + j];
            }
        }
    }

    // free array be on device
    omp_target_free(b, omp_get_default_device());

    // retrieve array a from device
#pragma omp target exit data map(from:a[0:n*n])

    // compute the sum of the array elements and print result
    float sum = 0.0f;
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            sum += a[i*n + j];
        }
    }
    printf("sum = %f\n", sum);

    // free array a
    free(a);

    return 0;
}
