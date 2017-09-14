if [ -z ${CI+x} ]; then

    echo "************************ Local build *******************"

else

    echo "************************ TRAVIS CI BUILD *******************"

fi


# Get miniconda
if [ "$(uname)" == "Darwin" ]; then

    curl https://repo.continuum.io/miniconda/Miniconda2-latest-MacOSX-x86_64.sh -o ~/miniconda.sh

else
    
    wget -q https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O ~/miniconda.sh
    
fi

rm -rf $HOME/miniconda_fermi_externals_dev_build

bash ~/miniconda.sh -b -p $HOME/miniconda_fermi_externals_dev_build
export PATH="$HOME/miniconda_fermi_externals_dev_build/bin:$PATH"

conda install -y conda-build
conda install -y anaconda-client
conda update -y conda conda-build anaconda-client

# Activate environment
source $HOME/miniconda_fermi_externals_dev_build/bin/activate

if [ -z ${CI+x} ]; then
    
    # Local build
    
    # Use this if you want to upload to the channel

    conda config --set anaconda_upload yes

    conda build -c ${MY_CONDA_CHANNEL} ${MY_CONDA_PACKAGE}

else

    # We are in Travis CI
    
    echo "TRAVIS BUILD: redirecting log, and showing it only on failure"

    conda config --set anaconda_upload no
    
    if python log_regulator.py 100 build.log conda build --no-anaconda-upload ${MY_CONDA_PACKAGE} ; then

        echo "Build finished successfully!"
    
    else

        echo "Building errored"
    
        echo "Last 200 lines of log:"
        
        cat build.log | tail -200
        
        exit -1

    fi
    
fi


