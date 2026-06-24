# TODO

## OpenMP GPU offloading slide gaps

The shared GPU programming deck in `/home/gjb/Projects/GPU-programming`
already introduces the host/device model, GPU hardware, SIMT execution,
memory hierarchy, bandwidth, synchronization, occupancy, coalescing, and the
general GPU performance model.  The OpenMP offloading slides should therefore
focus on the OpenMP-specific bridge from CPU OpenMP to GPU execution.

- [ ] Add a CPU OpenMP to OpenMP offload mental-model slide.
      Connect `parallel for` on CPUs to `target teams loop` and
      `target teams distribute parallel for` on GPUs, and relate OpenMP teams
      and team threads to the GPU hierarchy introduced in the shared deck.

- [ ] Add a directive-selection slide for common loop offload patterns.
      Clarify when to start with `target teams loop`, when
      `target teams distribute parallel for` is useful, and why CPU OpenMP
      scheduling intuition does not directly carry over.

- [ ] Add a build, run, and verify workflow slide.
      Include compiler-specific offload flags, device discovery with
      `omp_get_num_devices()`, fallback checks with `omp_is_initial_device()`,
      and a minimal way to confirm that code actually ran on the GPU.

- [ ] Add an OpenMP loop-transformation slide.
      Cover `collapse`, nested loops, loop order, array-section shape, and the
      connection between OpenMP loop structure and the coalescing/access-pattern
      material from the shared GPU deck.

- [ ] Add a target reduction slide.
      Use `source-code/c/vector_product_3_gpu.c` as the concrete example and
      explain what is familiar from CPU OpenMP and what changes on the target.

- [ ] Add a data-mapping failure-modes slide.
      Cover accidental remapping, stale host/device data, `target update`,
      `alloc` versus `to`, `is_device_ptr`, and data lifetime across multiple
      target regions.  Use `source-code/c/heat_gpu.c` as a practical anchor.

- [ ] Add a debugging and validation workflow slide.
      Recommend small test cases, CPU/GPU result comparison, incremental
      directive changes, detection of host fallback, and isolating mapping
      bugs before optimizing.

- [ ] Add an OpenMP implementation-portability slide.
      Summarize the practical differences across GCC, Clang, NVHPC, and Intel
      runtimes, partial OpenMP 5.x support, and clauses/features that need
      compiler-specific checking.

- [ ] Add speaker-note references back to the shared GPU deck.
      Point back to the exact prerequisite topics when discussing teams,
      memory movement, loop mapping, synchronization, and performance tuning.
