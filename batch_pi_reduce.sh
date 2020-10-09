#! /bin/sh

module swap PrgEnv-cray PrgEnv-gnu
cc pi_reduce.c -o pi_reduce

printf "Running check for pi_mpi:\n"
rm -rf perf_pi_reduce;
for np in 8 16 32 64 128; do
    printf "  %3i processes:\n" $np
    for i in {1..10}; do
	printf "\tRun %2i ... \n" $i
        srun -n $np ./pi_reduce >> perf_pi_reduce;
    done
done
