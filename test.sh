#!/bin/bash

# A random command

python -c "import time;time.sleep(3);1/1" && exit 0 || exit 10 &

export pid=$!

while ps a | awk '{print $1}' | grep -q "${pid}"; do
    
    echo "Still building"
    
    sleep 1

done

wait $pid

exit_status=$?

echo $exit_status

if [[ $exit_status -eq 0 ]]; then

    echo "good"
    
else

    echo "bad"

fi

