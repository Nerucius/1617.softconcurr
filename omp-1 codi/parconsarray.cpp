#include <iostream>
#include <omp.h>

using namespace std;

int main(void)
{
    int i, a[10], n = 10, tid, *b;
    b = new int[10];
    
    #pragma omp parallel shared(n) private(i,a,b,tid)
    {
	 tid = omp_get_thread_num();

         for(i = 0; i < n; i++)
	 {
             cout << "Fil " << tid << " executa iteracio " << i << endl;
	     a[i] = tid;
	     b[i] = tid;
	 }

	 #pragma omp barrier
             
         cout << "Fil " << tid << " te valor a[0] = " << a[0] 
                                         << ", b[0] = " << b[0] << endl;
    }
    
    cout << "S'ha acabat!" << endl;
}

