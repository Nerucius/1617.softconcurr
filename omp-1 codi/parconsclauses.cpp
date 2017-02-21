#include <iostream>
#include <omp.h>

using namespace std;

int main(void)
{
  int n = 5;

  cout << "Inici" << endl;

#pragma omp parallel num_threads(5) if(n > 4)
  {
    cout << "Soc el fil numero " << omp_get_thread_num() << endl;

    if (omp_get_thread_num() == 1) {
      cout << "El fil 1 fa una cosa diferent" << endl;
    }

    cout << "Torno a ser el fil " << omp_get_thread_num() << endl; 
  } // Fi de la regio paral·lela

  cout << "Fi de la construccio" << endl;
  return 0;
}
