#!/bin/bash
Jump="http://10.8.255.200:4366/register"
curl  -s http://169.254.169.254/latest/dynamic/instance-identity/document &> /dev/null
if [ $? -eq 0 ];then
    ### 获取认证的aws账户
    PLATFORM="AWS"
    Account=` curl  -s http://169.254.169.254/latest/dynamic/instance-identity/document | awk -F"\"" '/accountId/ {print$4}' `
    ### 获取本机的region
    Region=` curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | awk -F"\"" '/region/ {print $4}' `
    ### 获取本机的instance_id
    InstanceId=` curl -s  http://169.254.169.254/latest/meta-data/instance-id `
    ### 获取主机名
    IP1=`hostname | awk -F '-' '{print $3}'`
    IP2=`hostname | awk -F '-' '{print $4}'`
    IP3=`hostname | awk -F '-' '{print $5}'`
    HostName="amz-sin${IP1}-sdk-${IP2}-${IP3}"
    ### 获取IP
    IP=` curl http://169.254.169.254/latest/meta-data/local-ipv4`
    curl -s -u 'xxxxxxxxxxxx:xxxxxxxxxxxxxx*' -d "ip=$IP&hostname=$HostName&account=$Account&region=$Region&instanceid=$InstanceId&platform=$PLATFORM"  ${Jump}   &>> /tmp/osinit.log
    if [ $? == 0 ];then
      touch /run/jumpserver_osinit.pid
    fi
fi
