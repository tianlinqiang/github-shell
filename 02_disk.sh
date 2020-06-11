#/bin/bash

read -p I"nput disk name:" diskname
[ -z $diskname ] && echo "Input diskname is null" && exit 1

if `fdisk -l |grep "^$diskname[1-9]" &> /dev/null` ;then
    fdisk=`fdisk -l|grep "^$diskname[1-9]"| awk '{print $1}'`
    num=`echo $fdisk|wc -w`
    if [[ $num -eq 1 ]]; then
        df -h `echo $fdisk | cut -d' ' -f 1`
    else
        df -h `echo $fdisk | cut -d' ' -f $num `
    fi
else
    echo "Diskname is error."
    exit 2
fi
#for disk in $fdisk;do
#    echo "$disk is df -h..."
#    df -h $disk
#done
