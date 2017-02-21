#include <iostream>
#include <omp.h>

using namespace std;

int main(void)
{
  int n = 10, i, sum = 0;
  int a[10], b[10], c[10];

#pragma omp parallel shared(a,b,c) 
  {
#pragma omp for nowait
    for(i = 0; i < n; i++) 
      a[i] = i;

#pragma omp for
    for(i = 0; i < n; i++)
      b[i] = 2 * a[i];

#pragma omp for nowait reduction(+:sum)
    for(i = 0; i < n; i++)
      sum += a[i] + b[i];
  } // Barrera al final de la regio paral·lela

  return 0;
}
