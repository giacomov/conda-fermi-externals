# Get miniconda
if [ "$(uname)" == "Darwin" ]; then

    curl https://repo.continuum.io/miniconda/Miniconda2-latest-MacOSX-x86_64.sh -o ~/miniconda.sh

else
    
    wget -q https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O ~/miniconda.sh
    
fi

bash ~/miniconda.sh -b -p $HOME/miniconda
export PATH="$HOME/miniconda/bin:$PATH"

conda install -y conda-build
conda install -y anaconda-client
conda update -y conda conda-build anaconda-client

# Activate environment
source /root/miniconda/bin/activate

# Copy .tar if any
mkdir -p /root/miniconda/conda-bld/src_cache
cp /conda-fermi-externals/*.tar* /root/miniconda/conda-bld/src_cache

if [ -z ${CI+x} ]; then

    # We are in Travis CI

    conda config --set anaconda_upload no

    conda build ${MY_CONDA_PACKAGE}

else

    # Use this if you want to upload to the channel

    conda config --set anaconda_upload yes

    conda build -c ${MY_CONDA_CHANNEL} ${MY_CONDA_PACKAGE}

fi


