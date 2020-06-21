#!/bin/bash

i=1
j=1
while (( i<=9 ));do
   while (( j<=i ));do
        echo -e -n "${j}X${i}=$((j*i)) \t"
    let j++
    done
    echo 
    let i++
    j=1
done
