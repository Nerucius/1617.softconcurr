#include <iostream>
#include <omp.h>

using namespace std;

int main(void)
{
  int n = 10;

#pragma omp parallel shared(n) 
  {

    if (omp_get_thread_num() > 0)
    {
#pragma omp for  // no valid ja que no s'executa per a tots els fils
      for(int i = 0; i < n; i++) {
	cout << "Fil " << omp_get_thread_num() << " a i = " << i << endl;
      } // Fi de la construccio for
    }

    cout << "Fi de la tasca pel fil " << omp_get_thread_num() << endl;

  } // Fi de la construccio paral·lela


  return 0;
}
