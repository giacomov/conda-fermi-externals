
case "$(uname)" in
Linux)
LDFLAGS='-m64'
;;
Darwin)
LDFLAGS='-arch x86_64 -m64'

sed -i -e '/codesign/d' ds9/unix/Makefile.in
;;
*)
echo "Unsupported"
exit 1
;;
esac


export LD_LIBRARY_PATH=${PREFIX}/lib:${LD_LIBRARY_PATH}

export CPATH="${PWD}/include:${PREFIX}/include:${PREFIX}/include/libxml2"
export CPPFLAGS="-I./include/"
export LIBS=`xml2-config --libs`
export LIBRARY_PATH=${PREFIX}/lib

unix/configure

cd tclxml
./configure --with-xml2-config=`which xml2-config` --disable-shared

cd ..

make || : 

export LIBS="-ldl -L${PREFIX}/lib -lxml2 -L${PREFIX}/lib -lz -L${PREFIX}/lib -liconv -lm -ldl -lpthread -lieee"

make || :

mkdir lib/Tclxml3.2
cp tclxml/libTclxml3.2.a lib/Tclxml3.2/

cd ds9/unix
export LIBS="-L${PREFIX}/lib -L${PREFIX}/lib -lxml2 -L${PREFIX}/lib -lz -L${PREFIX}/lib -liconv "

./configure
make

cd ../..

mkdir -p $PREFIX/bin
cp -a bin/ds9* bin/x* $PREFIX/bin
