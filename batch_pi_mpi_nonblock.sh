#! /bin/sh

module swap PrgEnv-cray PrgEnv-gnu
cc pi_mpi_nonblock.c -o pi_mpi_nonblock

printf "Running check for pi_mpi:\n"
rm -rf perf_pi_nonblock;
for np in 8 16 32 64 128; do
    printf "  %3i processes:\n" $np
    for i in {1..10}; do
	printf "\tRun %2i ... \n" $i
        srun --exclusive -n $np ./pi_mpi_nonblock >> perf_pi_nonblock;
    done
done
