#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

int main(void)
{
#pragma omp parallel num_threads(4)
  {
#pragma omp sections
    {
#pragma omp section
      printf("Seccio 1, fil %d\n", omp_get_thread_num());

#pragma omp section
      {
	printf("Seccio 2, fil %d\n", omp_get_thread_num());
	printf("Seccio 2 bis, fil %d\n", omp_get_thread_num());
      }
    } // Barrera al final de la secció

    printf("Fil %d fora.\n", omp_get_thread_num());
  }

  printf("S'ha acabat!\n");
}
