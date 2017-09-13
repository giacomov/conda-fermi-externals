#!/bin/bash

# A random command

if python log_regulator.py 100 test.log python output_test.py ; then
    
    echo "Success"

else
    
    tail -10 test.log

fi
