#!/bin/bash

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then

    # Nothing to do
    echo "nothing to do"
    
else
    # Install some custom requirements on Linux
    
    sudo apt-get -qq update
    sudo apt-get install -y zip
    
fi
