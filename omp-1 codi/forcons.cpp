#include <iostream>
#include <omp.h>

using namespace std;

int main(void)
{
  int n = 10, i;

#pragma omp parallel shared(n) private(i)
  {
#pragma omp for
    for(i = 0; i < n; i++) {
      cout << "Fil " << omp_get_thread_num() << " a i = " << i << endl;
    } // Fi de la construccio for
   
   cout << "Fi de la tasca pel fil " << omp_get_thread_num() << endl;

  } // Fi de la construccio paral·lela


  return 0;
}
