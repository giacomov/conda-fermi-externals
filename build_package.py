#!/usr/bin/env python

import argparse
import subprocess
import logging
import os
import subprocess

logging.basicConfig(level=logging.DEBUG, format='%(asctime)s %(name)s %(message)s')

log = logging.getLogger(__file__)

if __name__ == "__main__":
    
    parser = argparse.ArgumentParser(prog=__file__)

    # args for doTimeResolvedLike
    parser.add_argument('-c', '--channel', required=True, type=str, help="Channel to be used to upload builds")
    parser.add_argument('-p', '--package', required=True, type=str, help="Package to build")
    parser.add_argument('-i', '--container', required=False, type=str, help="Container to use for building", default='quay.io/pypa/manylinux1_x86_64')
    
    args = parser.parse_args()
    
    recipe_directory = os.path.dirname(os.path.abspath(__file__))
    
    assert os.path.exists(os.path.join(recipe_directory, args.package)), "Package %s does not exist in %s" % (args.package, recipe_directory)
    
    cmd_line = '''docker run -v %s:/conda-fermi-externals --rm -it -e MY_CONDA_PACKAGE=%s -e MY_CONDA_CHANNEL=%s  %s bash -c "cd /conda-fermi-externals ; source build_inside_container.sh"'''
    
    cmd_line = cmd_line % (recipe_directory, args.package, args.channel, args.container)
    
    log.info("About to run:")
    log.info(cmd_line)
    
    subprocess.check_call(cmd_line, shell=True)
