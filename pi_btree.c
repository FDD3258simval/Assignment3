#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include <mpi.h>

#define SEED     69
#define NUM_ITER 1000000000
#define MOD      2

int main(int argc, char* argv[])
{
    int local_count = 0;
    double x, y, z, pi;
    int rank, size, i, j, iter, work, provided;
	// binary tree comm
	int nlayers, step, dst, src;

    MPI_Init_thread(&argc, &argv, MPI_THREAD_SINGLE, &provided);

    double start_time, stop_time, elapsed_time;
    start_time = MPI_Wtime();

    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Comm_size(MPI_COMM_WORLD,&size);
    
    srand(time(NULL) + 123456789 + rank*SEED); // Important: Multiply SEED by "rank" when you introduce MPI!

    // Split the work !
    if (rank == 0) {   
	work = NUM_ITER - (size-1)*ceil(NUM_ITER/size);
    }
    else {
	work = ceil(NUM_ITER/size);
    }
    //printf("Process %d: work I got: %d\n",rank,work);
    
    // Calculate PI following a Monte Carlo method
    for (int iter = 0; iter < work; iter++)
    {
        // Generate random (X,Y) points
        x = (double)random() / (double)RAND_MAX;
        y = (double)random() / (double)RAND_MAX;
        z = sqrt((x*x) + (y*y));
        
        // Check if point is in unit circle
        if (z <= 1.0)
        {
            local_count++;
        }
    }

    // Communication
	nlayers = floor(log2(size));
	int running_sum = 0;
	// first, consider own contribution
	running_sum += local_count;
	// then gather contributions from other processors
	for (i=0; i < nlayers; i++){			// iterate through all layers
		step = pow(MOD,i);
		for (j=0; j < size; j+=step){		// traverse layer with given step size
			if (rank==j){
				if (j % (2*step) == 0){	    // receiver
					src = j+step;
					MPI_Recv(&local_count,1,MPI_INT,src,0,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
					running_sum += local_count;
					// printf("Layer %3d, rank %3d: Recv from %3d\n",i,j,src);
				} else {					// sender
					dst = j-step;
					MPI_Send(&running_sum,1,MPI_INT,dst,0,MPI_COMM_WORLD);
					// printf("Layer %3d, rank %3d: Sent to   %3d\n",i,j,dst);
				}	// if j % (2*step) == 0
			}		// if rank == j
		}			// traverse layer
	}				// iterate through layers
    
	stop_time = MPI_Wtime();
    elapsed_time = stop_time - start_time;
	
	if (rank==0) {
		// Estimate Pi and display the result
		pi = ((double)running_sum / (double)NUM_ITER) * 4.0;
		printf("%3d processes: pi ~ %f, time: %6.3f\n", size, pi, elapsed_time);
    }

    MPI_Finalize();
    
    return 0;
}

