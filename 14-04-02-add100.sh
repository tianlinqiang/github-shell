#!/bin/bash

num=1
sum=0
while (($num<=100));do
 sum=$(($sum+$num))
 ((num++))
done
echo $sum
echo $num
