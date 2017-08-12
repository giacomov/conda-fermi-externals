#!/bin/bash

make
make install libdir=${PREFIX}/lib \
  includedir="${PREFIX}/include/f2c" \
  LIBDIR=${PREFIX}/lib \
  INCDIR="${PREFIX}/include/f2c"
