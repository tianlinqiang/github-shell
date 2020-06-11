#/bin/bash

for filename in `ls`
do
  if test -d $filename;then
    echo "$filename is dir..."
  else
    a=$(ls -l $filename | awk '{print $5}')
    if test $a -eq 0;then
        echo "$filename size is $a"
        rm  $filename
        echo "$filename is deleted"
    fi
  fi
done
