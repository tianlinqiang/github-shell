#!/bin/bash

while :
do

logfile=/tmp/`date +%Y-%m-%d`.log

exec >> $logfile
date +"%F %H:%m"

sar -n DEV 1 31| grep Average|grep eth0|awk '{print $2, "\t","input:","\t",$5,"kb/s","\n",$2,"\t","output:","\t",$6,"kb/s"}'
echo "#################"
done
