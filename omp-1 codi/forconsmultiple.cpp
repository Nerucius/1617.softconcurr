#include <iostream>
#include <omp.h>

using namespace std;

int main(void)
{
  int n = 10, i;
  int a[10], b[10];

#pragma omp parallel shared(n,a,b) 
  {
#pragma omp for
    for(i = 0; i < n; i++) {
       a[i] = i;
    } // Barrera
    
#pragma omp for
    for(i = 0; i < n; i++) {
       b[i] = 2 * a[i];
    } // Barrera
   
   cout << "Fi de la tasca pel fil " << omp_get_thread_num() << endl;

  } // Fi de la construccio paral·lela

  return 0;
}
