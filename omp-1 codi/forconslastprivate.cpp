#include <iostream>
#include <omp.h>

using namespace std;

int main(void)
{
  int n = 10, i, a;

#pragma omp parallel for lastprivate(a)
  for(i = 0; i < n; i++) {
      a = i + 1;
      cout << "Fil " << omp_get_thread_num() << ", a = " << a << endl;
    } 
   
  cout << "El valor d'a es " << a << endl;

  return 0;
}
