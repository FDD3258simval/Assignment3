#! /bin/sh

module swap PrgEnv-cray PrgEnv-gnu
cc pi_btree.c -o pi_btree

printf "Running check for pi_btree:\n"
rm -rf perf_pi_btree;
for np in 8 16 32 64 128; do
    printf "  %3i processes:\n" $np
    for i in {1..10}; do
	printf "\tRun %2i ... \n" $i
        srun -n $np ./pi_btree >> perf_pi_btree;
    done
done
