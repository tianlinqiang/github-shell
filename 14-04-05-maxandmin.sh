#!/bin/bash

rand=$RANDOM
echo $rand
max=$rand
min=$rand
i=1

while (( i <= 9));do
    rand=$RANDOM
    echo ${rand}
    if (( rand > max));then
        max=$rand
    fi
    if ((rand<min));then
        min=$rand
    fi
    let i++

done

echo "Max: $max"
echo "Min: $min"

