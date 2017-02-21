#include <iostream>
#include <omp.h>

using namespace std;

int main(void)
{
  int local = 10;
  cout << "Inici" << endl;

#pragma omp parallel firstprivate(local)
  { 
    // variable local inicialitzada a 10
    int tid = omp_get_thread_num();
   
    cout << "Local te el valor " << local << endl; 
  } // Fi de la regio paral·lela

  cout << "Fi de la construccio" << endl;
  return 0;
}
