#!/bin/bash

n=`wc -l a.txt|awk '{print $1}'`
sum=0

for i in `seq 1 $n`;do
    line=`sed -n "$i"p a.txt`

n_n=`echo $line|sed 's/[^0-9]//g'|wc -L`

echo $n_n
sum=$[$sum+$n_n]
done
echo "sum:$sum"

