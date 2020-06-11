#/bin/bash

read -p "Enther a disk apecial file:" diskfile
[ -z $diskfile ] && echo "No input..." && exit 1

if fdisk -l | grep "^Disk $diskfile" &> /dev/null;then
    fdisk -l $diskfile
else 
    echo "Diskfile is null."
    exit 2
fi
