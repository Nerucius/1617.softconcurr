#!/bin/sh

g++ forconscimg.cpp -o forconscimg -fopenmp -Wall -W -ansi -pedantic -Dcimg_use_vt100 -I/usr/X11R6/include  -lm -L/usr/X11R6/lib -lpthread -lX11
