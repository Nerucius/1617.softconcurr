#include <iostream>
#include <omp.h>

#include "CImg.h"

using namespace cimg_library;
using namespace std;

int main( int argc, char** argv )
{
  if( argc != 2)
  {
    cout <<" Usage: forcons imageToWrite" << endl;
    return -1;
  }

  CImg<unsigned char> image(200,200,1,1);

#pragma omp parallel num_threads(4)
  {
    int tid = omp_get_thread_num();

#pragma omp for
    for(int y = 0; y < image.height(); y++)
    {
      for(int x = 0; x < image.width(); x++)
      {
	image(x,y) = tid;
      }
    }
  }

  image.save(argv[1]);

  return 0;
}
