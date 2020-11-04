#!/bin/bash
# Author: TLQ
# Date: 2020-8
check_zabbix(){
  zabbix_agentd_ver=`zabbix_agentd -V| head  -n 1| awk '{print $4}'`
  if  [[ -n "${zabbix_agentd_ver}" ]];then
    if [[ "${zabbix_agentd_ver}" != "4.4.10" ]];then
      echo "####Begin Update zabbix-agent.4.4.10####">>/tmp/osinit.log
      wget -P /tmp/ http://10.17.10.100:9000/update-zabbix-agent4.4.10.sh >/dev/null 2>&1
      if [ -e /tmp/update-zabbix-agent4.4.10.sh ];then
        bash /tmp/update-zabbix-agent4.4.10.sh
        echo "####Update zabbix-agent.4.4.10 End####">>/tmp/osinit.log
      else
        echo "Down load update-zabbix-agent4.4.10.sh faild">> /tmp/osinit.log
      fi
    else
      echo "zabbix-agent version is ${zabbix_agentd_ver} not update">>/tmp/osinit.log
      IP1=`hostname | awk -F '-' '{print $3}'`
      IP2=`hostname | awk -F '-' '{print $4}'`
      IP3=`hostname | awk -F '-' '{print $5}'`
      HOSTNAME="amz-sin${IP1}-sdk-${IP2}-${IP3}"
      grep -w "${HOSTNAME}" /etc/zabbix/zabbix_agentd.conf>/dev/null 2>&1
      if [ $? != 0 ];then
        echo "add zabbix_agentd.conf Hostname" >>/tmp/osinit.log
        sed -i 's/Hostname/#Hostname/g' /etc/zabbix/zabbix_agentd.conf
        echo "Hostname=${HOSTNAME}" >> /etc/zabbix/zabbix_agentd.conf
        service zabbix-agent restart
      fi
      grep -w "10.17.10.100" /etc/zabbix/zabbix_agentd.conf>/dev/null 2>&1
      if [ $? != 0 ];then
        echo "Add zabbix_agentd.conf Server=10.17.10.100" >>/tmp/osinit.log
        sed -i 's/Server/#Server/g' /etc/zabbix/zabbix_agentd.conf
        sed -i "/#Hostname/i\Server=10.17.10.100" /etc/zabbix/zabbix_agentd.conf
        sed -i "/#Hostname/i\ServerActive=10.17.10.100" /etc/zabbix/zabbix_agentd.conf
        service zabbix-agent restart
      fi
    fi
  else
    echo "####Begin Install zabbix-agent.4.4.10####">>/tmp/osinit.log
    wget -P /tmp/ http://10.17.10.100:9000/install-zabbix-agent4.4.10.sh >/dev/null 2>&1
     if [ -e /tmp/install-zabbix-agent4.4.10.sh ];then
        bash /tmp/install-zabbix-agent4.4.10.sh
        echo "####Install zabbix-agent.4.4.10 End####">>/tmp/osinit.log
     else
        echo "Down load install-zabbix-agent4.4.10.sh faild">> /tmp/osinit.log
     fi
  fi
}

check_users(){
  echo "####Check ops,deploy,dev####">> /tmp/osinit.log
  A=$(id ops)
  if [ -z "${A}" ];then
    echo "####Add user ops,deploy,dev####">> /tmp/osinit.log
    wget -P /tmp/ http://10.17.10.100:9000/add-user.sh
    bash /tmp/add-user.sh
    echo "####User add success.####">> /tmp/osinit.log
  else
    echo "Not add user ops...">> /tmp/osinit.log
  fi
}

check_jumpserver(){
  if [ -e /run/jumpserver_osinit.pid ];then
    echo "Jumpserver Not Register" >> /tmp/osinit.log
  else
    echo "Begin Register Jumpserver..." >> /tmp/osinit.log
    wget -P /tmp/ http://10.17.10.100:9000/jumpserver_osinit_client.sh >/dev/null 2>&1
    if [ -e /tmp/jumpserver_osinit_client.sh ];then
      bash  /tmp/jumpserver_osinit_client.sh &>> /tmp/osinit.log
      echo "Register Jumpserver End" >> /tmp/osinit.log
    else
      echo "Down load jumpserver_osinit_client.sh faild">> /tmp/osinit.log
    fi
fi
}

check_zabbix
check_users
check_jumpserver

[ -e /tmp/update-zabbix-agent4.4.10.sh ] && rm -rf /tmp/update-zabbix-agent4.4.10.sh
[ -e /tmp/install-zabbix-agent4.4.10.sh ] && rm -rf /tmp/install-zabbix-agent4.4.10.sh
[ -e /tmp/jumpserver_osinit_client.sh ] && rm -rf /tmp/jumpserver_osinit_client.sh
[ -e /tmp/add-user.sh ] && rm -rf /tmp/add-user.sh
[ -e /tmp/public.tar.gz ] && rm -rf /tmp/public.tar.gz
[ -e /tmp/public ] && rm -rf /tmp/public


