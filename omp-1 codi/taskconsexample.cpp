#include <unistd.h>
#include <iostream>
#include <omp.h>

using namespace std;

int main(void)
{
  int i = 0;

#pragma omp parallel private(i) num_threads(4)
  {
#pragma omp single 
    {
      for(i = 0; i < 10; i++)
      {
	cout << "Fil " << omp_get_thread_num() << " a iteracio i = " 
					<< i << endl;
#pragma omp task
	{
	  cout << "Fil " << omp_get_thread_num() << " a tasca i = " 
	                               << i << endl;
	  sleep(1);
	}
      }
    } // Barrera  implícita

   cout << "Fil " << i << " despres del single" << endl; 
  } // Barrera implícita

  cout << "Fi" << endl; 
}
