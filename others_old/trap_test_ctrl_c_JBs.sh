#!/bin/bash

trap "echo -e '\nScript finished ok - Code 0'" 0 # Get any signal received
trap "echo -e '\nCrtl + C pressed - Code 0'" SIGINT
trap "echo -e '\nCrtl + C pressed - Code 0'" SIGKILL SIGSTOP # Can't work with them

echo "Pid is $$"

count=1
while [ "$count" -lt 10 ]; do
    sleep 5s

    ((count++))
    echo "Count: $count"
done
