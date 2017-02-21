#include <iostream>
#include <omp.h>

using namespace std;

int global;

int main(void)
{
  int local;
  cout << "Inici" << endl;

#pragma omp parallel private(local) shared(global)
  {
    int tid = omp_get_thread_num();
    local = tid + 1;
    cout << "Soc el fil numero " << tid << endl;

    if (tid == 1) {
      cout << "El fil 1 fa una cosa diferent" << endl;
    }

    cout << "Local te el valor " << local << endl; 
  } // Fi de la regio paral·lela

  cout << "Fi de la construccio" << endl;
  return 0;
}
