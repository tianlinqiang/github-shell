#!/bin/bash

n=1

for domain in `cat domains_arr.txt`
do
    ip=`ping ${domain} -c 1|sed '1{s/[^(]*(//;s/).*//;q}'`
    echo -e $n "\t" $domain "\t" $ip
    if [ "$ip" != "47.91.149.228" ]
    then
        echo -e $domain"\t"$ip >> chk_fail.txt
    fi
    n=$(($n+1))
done
