#!/bin/bash

net='172.21.0'
uphost=0
downhost=0

for i in {1..20};do
  ping -c 1 -w 1 $net.$i  &> /dev/null
  if [ $? -eq 0 ];then
     echo "$net.$i is up"
     let uphost++
  else
     echo "$net.$i is down"
     ((downhost++))
  fi
done

echo "up host num is: $uphost"
echo "down host num is: $downhost"
