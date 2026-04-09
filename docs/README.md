Leveraging the compute power of GPU accelerators for scientific computing is
becoming increasingly important. There are many programming models for GPU
programming, but OpenMP is a vendor-agnostic approach that allows you to write
code that can run on a wide variety of GPU hardware. In this training, we will
cover GPU programming with OpenMP, and how to optimize performance.


## Learning outcomes

When you complete this training you will

  * have a good understanding of the GPU hardware and programming model;
  * be able to write OpenMP code that offloads to the GPU;
  * understand how to optimize performance of OpenMP GPU code;
  * be able to apply this knowledge to your own scientific computing
    applications.


## Schedule

Total duration: 4 hours.

  | Subject                                     | Duration |
  |---------------------------------------------|----------|
  | introduction and motivation                 |  5 min.  |
  | GPU hardware/programming model              | 80 min.  |
  | OpenMP worksharing                          | 25 min.  |
  | coffee break                                | 10 min.  |
  | OpenMP data movements                       | 30 min.  |
  | OpenMP kernels                              | 10 min.  |
  | examples                                    | 60 min.  |
  | wrap up                                     | 10 min.  |


## Training materials

Slides are available in the [GitHub
repository](https://github.com/gjbex/OpenMP-GPU-offloading/) as well as example
code and hands-on material. The slides can be viewed
[online](https://github.com/gjbex/OpenMP-GPU-offloading/docs/slides/openmp_gpu_offloading.html).


## Target audience

This training is for you if you want to do GPU programming in C, C++, or
Fortran and want a vendor-agnostic approach.


## Prerequisites

You will need experience programming in C, C++, or Fortran and be familiar
with the OpenMP programming model.

If you plan to do GPU programming in a Linux or HPC environment you should be
familiar with these as well.

More concretely, participants should already be comfortable with the following:

* writing and reading small to medium programs in C, C++, or Fortran;
* arrays, loops, functions or procedures, and separate compilation at a basic
  level;
* compiling and running programs from the command line;
* basic OpenMP shared-memory concepts such as parallel loops, reductions, and
  the fact that race conditions can occur when threads update shared data;
* working from the shell: navigating directories, editing files, and running
  commands;
* basic HPC concepts such as login nodes, compute nodes, and batch jobs if the
  examples are run on a cluster.

Familiarity with C-style raw pointers helps a lot for the C and C++ examples.
You do not need prior experience with GPU programming, OpenMP target
offloading, device memory management, `target data` regions, or GPU-specific
performance tuning. Those are part of the training itself.

### Quick self-assessment

If you can do most of the tasks below without looking up basic language, OpenMP,
or shell syntax, you are likely ready for this training.

* compile and run a small C, C++, or Fortran program from the command line;
* read a short loop nest over arrays and explain what it computes;
* understand what an OpenMP parallel loop or reduction does at a high level;
* understand at a high level why updating a shared variable from many threads
  can cause incorrect results;
* read a short program that allocates arrays and passes them to a function;
* make a small change to an existing source file and rebuild it;
* understand at a high level that data on a GPU may need to be transferred to
  and from host memory.

If several of these items still feel difficult, the training will probably move
too fast. In that case, it is better to first refresh your base language and
basic OpenMP shared-memory programming.

For following along hands-on, you need
* laptop or desktop with internet access.
* a system set up so you can connect to an HPC system, an account on an HPC
  system (e.g., VSC, CECI, ...), compute credits if that is required to run
  jobs on the HPC system if you want to use an HPC system;


## Level of the Material

For participants who already have programming experience in C, C++, or
Fortran, and basic OpenMP experience, the material in this training is
approximately

* Introductory: 15 %
* Intermediate: 35 %
* Advanced: 50 %

These percentages describe the level of the GPU-offloading and OpenMP topics
covered in the training, not the required entry level in the base programming
language itself.


## Trainer(s)

  * Geert Jan Bex ([geertjan.bex@uhasselt.be](mailto:geertjan.bex@uhasselt.be))
