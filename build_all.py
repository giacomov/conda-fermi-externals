#!/usr/bin/env python

import argparse
import subprocess
import logging
import os
import subprocess
from sys import platform


logging.basicConfig(level=logging.DEBUG, format='%(asctime)s %(name)s %(message)s')

log = logging.getLogger(__file__)

if __name__ == "__main__":
    
    parser = argparse.ArgumentParser(prog=__file__)

    # args for doTimeResolvedLike
    parser.add_argument('-c', '--channel', required=True, type=str, help="Channel to be used to upload builds")
    parser.add_argument('-i', '--container', required=False, type=str, help="Container to use for building", default='quay.io/pypa/manylinux1_x86_64')
    
    args = parser.parse_args()
    
    recipe_directory = os.path.dirname(os.path.abspath(__file__))
    
    # Find packages to build
    packages = []
    
    for ff in os.listdir(recipe_directory):
                    
        if os.path.isdir(ff):
            
            # Check that a recipe exists
            if os.path.exists(os.path.join(ff, "meta.yaml")):
                
                packages.append(os.path.basename(ff))
                
                log.info("Found package %s" % packages[-1])
    
    log.info("Found %s packages" % len(packages))
    
    assert len(packages) > 0, "No package found"
    
    all_packages_string = " ".join(packages)
    
    if platform == "linux" or platform == "linux2":
        
        if 'CI' in os.environ:
            
            cmd_line = '''docker run -v %s:/conda-fermi-externals --rm -it -e CI='yes' -e MY_CONDA_PACKAGE='%s' -e MY_CONDA_CHANNEL=%s  %s bash -c "cd /conda-fermi-externals ; source build_inside_container.sh"'''
            
        else:
            
            cmd_line = '''docker run -v %s:/conda-fermi-externals --rm -it -e MY_CONDA_PACKAGE='%s' -e MY_CONDA_CHANNEL=%s  %s bash -c "cd /conda-fermi-externals ; source build_inside_container.sh"'''

        cmd_line = cmd_line % (recipe_directory, all_packages_string, args.channel, args.container)
    
    else:
        
        # OS X. Use system
        
        os.environ['MY_CONDA_PACKAGE'] = all_packages_string
        os.environ['MY_CONDA_CHANNEL'] = args.channel
        
        cmd_line = """source build_inside_container.sh"""

    
    log.info("About to run:")
    log.info(cmd_line)
    
    subprocess.check_call(cmd_line, shell=True)
