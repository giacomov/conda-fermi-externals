#!/bin/bash

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then

    # Nothing to do
    echo "nothing to do"
    
else
    # Install some custom requirements on Linux
    
    sudo apt-get -qq update
    sudo apt-get install -y zip curl
    
fi

# Now download the .tar file from heasoft so we do not download it 3 times
sudo mkdir -p /conda-fermi-externals
curl "https://heasarc.nasa.gov/cgi-bin/Tools/tarit/tarit.pl?mode=download&arch=src&src_pc_linux_sci=Y&src_other_specify=&general=futils" -o /conda-fermi-externals/heasoft-6.22src.tar.gz
