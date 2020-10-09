#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include <mpi.h>

#define SEED     69
#define NUM_ITER 1000000000

int main(int argc, char* argv[])
{
    int local_count = 0;
    double x, y, z, pi;
    int rank, size, i, iter, work, provided;

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
    
    // Gather data on rank 0
    if (rank == 0) {
	     int count_vec[size];
        MPI_Request requests_vec[size-1];
	     int global_count = 0;
	
	     // first, consider rank0 contribution
	     count_vec[0] = local_count;
	     for (i=1; i < size; i++) { // Non-blocking receive (in parallel)
	         MPI_Irecv(&count_vec[i],1,MPI_INT, i, 0, MPI_COMM_WORLD, &requests_vec[i-1]);
	     }
        for (i=1; i < size; i++) { // Wait for each rank
	         MPI_Wait(&requests_vec[i-1], MPI_STATUSES_IGNORE);
	     }
        for (i=0; i < size; i++) { // Sum up the contributions (from rank 0 already considered)
	         global_count += count_vec[i]; 
	     }
	     // Estimate Pi and display the result
	     pi = ((double)global_count / (double)NUM_ITER) * 4.0;
    }
    else { // Non-blocking send from other processes
	     MPI_Send(&local_count,1,MPI_INT, 0, 0, MPI_COMM_WORLD);
    }

    stop_time = MPI_Wtime();
    elapsed_time = stop_time - start_time;

    if (rank == 0) {
	    printf("%3d processes: pi ~ %f, time: %6.3f\n", size, pi, elapsed_time);
    }

    MPI_Finalize();
    
    return 0;
}
