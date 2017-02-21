#include <iostream>
#include <omp.h>

using namespace std;

int main(int argc, char **argv)
{
    int i, sum = 0, offset;
    int a[100];

    #pragma omp parallel private(a, offset) reduction(+:sum)
    {
    #pragma omp single copyprivate(offset)
        {
           offset = 1;
        }
    #pragma omp for
        for (i = 0; i < 100; i++) {
           a[i] = i;
           sum = sum + a[i] + offset;
        }
    }
    cout << sum << endl;
    return 0;
}
