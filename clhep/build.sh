#!/bin/bash

cd CLHEP
autoreconf -i
./configure --prefix=${PREFIX}
make
make install

