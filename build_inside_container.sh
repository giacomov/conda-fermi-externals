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
    yum install -y zip curl
    
fi

rm -rf $HOME/miniconda_fermi_externals_dev_build

bash ~/miniconda.sh -b -p $HOME/miniconda_fermi_externals_dev_build
export PATH="$HOME/miniconda_fermi_externals_dev_build/bin:$PATH"

conda install -y conda-build
conda install -y anaconda-client
conda update -y conda conda-build anaconda-client

# Activate environment
source $HOME/miniconda_fermi_externals_dev_build/bin/activate

# Copy .tar if any
mkdir -p $HOME/miniconda_fermi_externals_dev_build/conda-bld/src_cache

curl -s 'https://heasarc.nasa.gov/cgi-bin/Tools/tarit/tarit.pl?mode=download&arch=src&src_pc_linux_sci=Y&src_other_specify=&general=futils' > $HOME/miniconda_fermi_externals_dev_build/conda-bld/src_cache/heasoft-6.22src.tar.gz

if [ -z ${CI+x} ]; then
    
    # Local build
    
    # Use this if you want to upload to the channel

    conda config --set anaconda_upload yes

    conda build -c ${MY_CONDA_CHANNEL} ${MY_CONDA_PACKAGE}

else

    # We are in Travis CI
    
    echo "TRAVIS BUILD: redirecting log, and showing it only on failure"

    conda config --set anaconda_upload no
    
    conda build --no-anaconda-upload --quiet ${MY_CONDA_PACKAGE} >> build.log 2>&1 && exit 0 || exit 10 &
    
    export pid=$!
    
    while ps a | awk '{print $1}' | grep -q "${pid}"; do
        
        echo "Still building. Last 100 lines:"
        
        cat build.log | tail -100
        
        sleep 120
    
    done
    
    wait $pid

    exit_status=$?

    echo $exit_status

    if [[ $exit_status -eq 0 ]]; then

        echo "Build finished successfully!"
    
    else

        echo "Building errored"
    
        echo "Last 1000 lines of log:"
        
        cat build.log | tail -1000
        
        exit -1

    fi
    
fi


