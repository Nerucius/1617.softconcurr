#include <iostream>
#include <omp.h>

using namespace std;

int main(void)
{
  int i, sum = 0, n = 10;

#pragma omp parallel shared(n) reduction(+:sum) \
                               num_threads(4)
  {
#pragma omp for 
    for(i = 0; i < n; i++)
      sum += i * i;

    sum += 5;
  }

  cout << "Valor de la suma: " << sum << endl; 
}
