#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <iostream>

#include <omp.h>

using namespace cv;
using namespace std;

int main( int argc, char** argv )
{
  if( argc != 2)
  {
    cout <<" Usage: forcons imageToWrite" << endl;
    return -1;
  }

  Mat image(200,200,CV_8UC1);

  uint8_t* pixelPtr = (uint8_t*) image.data;
 
#pragma omp parallel num_threads(4)
  {
    int tid = omp_get_thread_num();

#pragma omp for
    for(int i = 0; i < image.rows; i++)
    {
      for(int j = 0; j < image.cols; j++)
      {
	pixelPtr[i*image.cols+j] = tid;
      }
    }
  }

  imwrite(argv[1], image);

  return 0;
}
