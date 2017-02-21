#include <iostream>
#include <omp.h>

using namespace std;

int n = 10;
int global[10];

void function(int i)
{
#pragma omp ordered
  cout << "b[" << i << "] = " << global[i] << endl;  
}

int main(void)
{
  int i;

#pragma omp parallel 
  {
#pragma omp for ordered nowait schedule(dynamic)
    for(i = 0; i < n; i++) {
      global[i] = i*i;
      function(i);
    } // Fi de la construccio for
  } // Fi de la construccio paral·lela

  return 0;
}
