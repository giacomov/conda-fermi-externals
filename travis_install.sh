#!/bin/bash

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then

    # Install gfortran and autoconf
    
    curl https://ayera.dl.sourceforge.net/project/hpc/hpc/g95/gfortran-7.1-bin.tar.gz -o gfortran-7.1-bin.tar.gz
    
    sudo tar xvf gfortran-7.1-bin.tar.gz -C /
    
    brew install autoconf
    
else
    # Install some custom requirements on Linux
    
    sudo apt-get -qq update
    sudo apt-get install -y zip curl
    
fi
