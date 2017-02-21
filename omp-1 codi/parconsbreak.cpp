#include <iostream>
#include <omp.h>

using namespace std;

int main(void)
{
  cout << "Inici" << endl;

  while (1)
  {
#pragma omp parallel
    {
      cout << "Soc el fil numero " << omp_get_thread_num() << endl;

      if (omp_get_thread_num() == 0)
	break; // Break en una regio paral·lela

      cout << "Torno a ser el fil " << omp_get_thread_num() << endl; 
    } // Fi de la regio paral·lela

    cout << "Fi de la construccio" << endl;
  }
  return 0;
}
