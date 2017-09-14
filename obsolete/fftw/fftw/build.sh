./configure --prefix=$PREFIX --enable-shared --enable-openmp --enable-mpi

make 

make install

# Create a copy of the headers into $PREFIX/include/fftw
# as some packages (like the ST) look for it there
mkdir $PREFIX/include/fftw
cp -v $PREFIX/include/fftw*.h $PREFIX/include/fftw
cp -v $PREFIX/include/fftw*.f* $PREFIX/include/fftw
