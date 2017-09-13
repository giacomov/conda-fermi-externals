#!/bin/bash

cd heasoft-6.22/heacore/cfitsio

./configure --prefix=$PREFIX

make
make shared
make utils

make install

# Install additional headers
cp cfortran.h ${PREFIX}/include
cp f77_wrap.h ${PREFIX}/include

