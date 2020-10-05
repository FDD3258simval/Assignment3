#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[]){
	
   int rank, size, i, provided;
   
   MPI_Init_thread(&argc,&argv, MPI_THREAD_SINGLE, &provided);

   MPI_Comm_rank(MPI_COMM_WORLD,&rank);
   MPI_Comm_size(MPI_COMM_WORLD,&size);

   printf("Hello World form rank %d form %d processes!\n",rank,size);

   MPI_Finalize();
}
