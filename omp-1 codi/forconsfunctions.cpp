#include <iostream>
#include <omp.h>

using namespace std;

void function()
{
  int n = 10, i;
  
#pragma omp for
    for(i = 0; i < n; i++) {
      cout << "Fil " << omp_get_thread_num() << " a i = " << i << endl;
    } // Fi de la construccio for
}

int main(void)
{
#pragma omp parallel 
  {
   function();
   cout << "Fi de la tasca pel fil " << omp_get_thread_num() << endl;
  } // Fi de la construccio paral·lela

  return 0;
}
