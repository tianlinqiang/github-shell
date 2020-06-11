#!/bin/bash

for i in `ls /etc/rc1.d`;do
    if [[ $i =~ ^S.* ]];then
        echo "$i stop"
    elif [[ $i =~ ^K.* ]];then
        echo "$i start"
    fi
done
