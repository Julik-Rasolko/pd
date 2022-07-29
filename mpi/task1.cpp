#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

double func(double x) {
    return 4.0/(1 + x*x);
}

double one_calc(double left, double right) {
    return ((func(left) + func(right)) / 2) * (right - left);
}

int main(int argc, char** argv) {
    int N = atoi(argv[1]);

    MPI_Init(NULL, NULL);

	int world_size;
	MPI_Comm_size(MPI_COMM_WORLD, &world_size);

	int world_rank;
	MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

    if (world_rank == 0) {
        double I0_start = MPI_Wtime();
        double I0 = 0.0;
        for(int i = 0; i < N; ++i) {
            I0 += one_calc((double)i/N, (double)(i + 1)/N);
        }
        printf("I0 = %f\n", I0);
        double I0_time = MPI_Wtime() - I0_start;
        printf("I0 took %f\n", I0_time);

        double I_start = MPI_Wtime();
        double I = 0.0;
        for (int i = 0; i < N / world_size; ++i) {
            double part = one_calc((double)i/N, (double)(i + 1)/N);
            I += part;
        }
        printf("Got %f from process %d\n", I, 0);
        for(int rank = 1; rank < world_size; ++rank) {
            double part_start = (double)rank / world_size;
            MPI_Send(&part_start, 1, MPI_DOUBLE, rank, 0, MPI_COMM_WORLD);
        }
        for(int rank = 1; rank < world_size; ++rank) {
            double part = 0.0;
            MPI_Recv(&part, 1, MPI_DOUBLE, rank, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            I += part;
            printf("Got %f from process %d\n", part, rank);
        }
        printf("I = %f\n", I);
        printf("I - I0 = %f\n", I - I0);
        double I_time = MPI_Wtime() - I_start;
        printf("I took %f\n", I_time);
        printf("Boost: %f\n", I0_time / I_time);

    } else {
        double part_start = 0.0;
        MPI_Recv(&part_start, 1, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        double part = 0.0;
        for (int i = 0; i < N/world_size; ++i) {
            part += one_calc(part_start + (double)i/N, part_start + (double)(i + 1)/N);
        }
        MPI_Send(&part, 1, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD);
    }

    MPI_Finalize();
    return 0;
}