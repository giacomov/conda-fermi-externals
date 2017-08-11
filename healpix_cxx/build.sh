cd src/cxx

autoconf

export CFLAGS="-fPIC"
export CXXFLAGS="-fPIC"
export CPPFLAGS="-I${PREFIX}/include -fPIC"
export LDFLAGS="-L${PREFIX}/lib"
export CPATH="${PREFIX}/include"

./configure --prefix=$PREFIX --enable-noisy-make

make

# Now make the shared libraries
cd auto/lib

for lib in *.a
do

    ar -x $lib
        
    gcc -L${PREFIX}/lib -lcfitsio -shared *.o -o ${lib%%.*}.so
    
    rm -rf *.o

done

# Finally install them
cd ..

cp -r lib/* ${PREFIX}/lib
mkdir ${PREFIX}/include/healpix_cxx
cp -r include/* ${PREFIX}/include/healpix_cxx
cp -r bin/* ${PREFIX}/bin

