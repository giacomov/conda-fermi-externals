# Get miniconda
if [ "$(uname)" == "Darwin" ]; then

    curl https://repo.continuum.io/miniconda/Miniconda2-latest-MacOSX-x86_64.sh -o ~/miniconda.sh

else
    
    wget -q https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O ~/miniconda.sh
    yum install -y zip
    
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
cp /conda-fermi-externals/*.tar* $HOME/miniconda_fermi_externals_dev_build/conda-bld/src_cache

if [ -z ${CI+x} ]; then

    # We are in Travis CI

    conda config --set anaconda_upload no

    conda build ${MY_CONDA_PACKAGE}

else

    # Use this if you want to upload to the channel

    conda config --set anaconda_upload yes

    conda build -c ${MY_CONDA_CHANNEL} ${MY_CONDA_PACKAGE}

fi


