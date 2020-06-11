#!/bin/bash

declare -i estal=0
declare -i listen=0
declare -i other=0

for i in `netstat -tan|grep "^tcp\>"|awk '{print $NF}'`;do
    if [ $i == "ESTABLISHED" ];then
        let estal++
    elif [ $i == "LISTEN" ];then
        let listen++
    else 
        let other++
    fi
done

echo "ESTABLISHED: $estal"
echo "LISTEN: $listen"
echo "OUnkown: $other"
