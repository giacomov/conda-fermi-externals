#!/bin/bash

export CFLAGS='-I${PREFIX}/include -O2 -Wall --pedantic -Wno-comment -Wno-long-long -g  -ffloat-store -fPIC'
export CXXFLAGS='-I${PREFIX}/include -O2 -Wall --pedantic -Wno-comment -Wno-long-long -g  -ffloat-store -fPIC'
export CPPFLAGS="-I${PREFIX}/include"
export LDFLAGS="-L${PREFIX}/lib"

cd heacore/BUILD_DIR

# Fix versions of CCfits and cfitsio
# Get defined versions
export OLD_CCFITS_VERS=`./hd_scanenv ./hd_config_info CCFITS_VERS`
export OLD_CFITSIO_VERS=`./hd_scanenv ./hd_config_info CFITSIO_VERS`

# Change them to an empty string, so that the linking will happen on the lib*.so file
# instead of lib*[version].so file (which might not match)
sed -i "s/CCFITS_VERS=${OLD_CCFITS_VERS}/CCFITS_VERS=''/g" hd_config_info
sed -i "s/CFITSIO_VERS=${OLD_CFITSIO_VERS}/CFITSIO_VERS=''/g" hd_config_info

autoconf -i

./configure --prefix=${PREFIX} --exec_prefix=${PREFIX} --with-components="lynx ape heaio heautils ahlog heainit ahgen ahfits heaapp mpfit ast heasp hoops st_stream" LDFLAGS="-Wl,-rpath,${PREFIX}/lib"

./hmake HD_EXEC_PFX=${PREFIX} HD_TOP_EXEC_PFX=${PREFIX}
./hmake install HD_EXEC_PFX=${PREFIX} HD_TOP_EXEC_PFX=${PREFIX}

cd $PREFIX
ls
rm -rf BUILD_DIR
