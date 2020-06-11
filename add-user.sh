#!/bin/bash

if [ ! $id -eq 0];then
	echo "Not root"
	exit 1
fi
for i in {1..5};do
    if id user$i;then
	    echo "user$i exits"
	else 
		useradd user$i &>/dev/null
		if [ $? -eq 0 ];then
			echo "user$i"|passwd --stdin user$i &>/dev/null
			echo "user$i add finsh."
		fi
	fi
done
