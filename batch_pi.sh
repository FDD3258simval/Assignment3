#! /bin/sh

module swap PrgEnv-cray PrgEnv-gnu
cc pi_mpi.c -o pi_mpi

printf "Running check for MPI pi:\n"
rm -rf perf_pi;
for np in 8 16 32 64 128; do
    printf "  %3i processes:\n" $np
    for i in {1..10}; do
	printf "\tRun %2i ... \n" $i
        srun -n $np ./pi_mpi >> perf_pi;
    done
done
