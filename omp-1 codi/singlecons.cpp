#include <omp.h>

int main(void)
{
    int a, b[10], n = 10;
    
    #pragma omp parallel shared(a,b) num_threads(4)
    {
         #pragma omp single
	 {
	    a = 15;
	 } // Barrera
        
         #pragma omp for nowait 
         for(int i = 0; i < n; i++)
             b[i] = a; 
         // Hem eliminat la barrera del final del for 
	     
    } // Barrera al final de la regio paral·lela
}
