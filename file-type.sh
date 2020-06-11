#!/bin/bash

read -p "输入一个文件:" filename

if [ -z $filename ];then
    echo "路径不存在"
    exit 2
fi

if [ ! -e $filename ];then
    echo "文件不存在"
    exit 3
fi

if [ -f $filename ];then
    echo "普通文件"
elif [ -d $filename ];then
    echo "目录文件"
elif [ -L $filename ];then
    echo "链接文件"
else 
    echo "其他文件"
fi
