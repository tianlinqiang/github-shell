#!/bin/bash

sum=0;
files=(/var/log/*.log)

for i in $(seq 0 $((${#files[*]}-1)));do 
    if (($i%2==0));then 
        sum=$((sum+`wc -l ${files[$i]}|cut -d" " -f1`))
    fi
done
echo ${files[9]}
echo $sum
