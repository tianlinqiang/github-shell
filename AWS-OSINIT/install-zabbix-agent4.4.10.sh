#!/bin/bash
# Author: TLQ
# Date: 2020-10-30


filename="zabbix-4.4.10-compiled-staticlib.tgz"
new_zabbix="/opt/zabbix-4.4.10-compiled-staticlib/sbin/zabbix_agentd"

copy_zabbix-agent4()
{
  wget -P /tmp/ http://10.17.10.100:9000/public.tar.gz >/dev/null 2>&1
  tar -zxvf /tmp/public.tar.gz -C /tmp/>/dev/null 2>&1
  if [ ! -d /tmp/public/ ];then
    echo "copy public fail." >>/tmp/osinit.log
    exit 2
  fi

  if [ -e /tmp/public/${filename} ];then
    tar zxvf /tmp/public/${filename} -C /opt/ >/dev/null
  fi

  if [ -e ${new_zabbix} ];then
    echo "cpoy zabbix-4.4.10-compiled-staticlib success." >>/tmp/osinit.log
  else
    echo "cpoy zabbix-4.4.10-compiled-staticlib fail." >>/tmp/osinit.log
  fi
}

system_zabbixagent_conf(){
  mv /tmp/public/zabbix-agent.service /usr/lib/systemd/system/zabbix-agent.service && chmod 644 /usr/lib/systemd/system/zabbix-agent.service
  systemctl daemon-reload
}

service_zabbixagent_conf(){
 rsync -aqur /tmp/public/zabbix-agent /etc/init.d/zabbix-agent
 chmod 755 /etc/init.d/zabbix-agent
}


install_zabbixagent_conf(){
  id zabbix
  if [ $? != 0 ];then
  /usr/sbin/useradd -U zabbix -s /sbin/nologin -d /var/lib/zabbix
  fi
cat >/etc/logrotate.d/zabbix-agent<<EOF
/var/log/zabbix/zabbix_agentd.log {
	missingok
	monthly
	notifempty
	compress
	su zabbix zabbix
	create 0664 zabbix zabbix
}
EOF

  IP1=`hostname | awk -F '-' '{print $3}'`
  IP2=`hostname | awk -F '-' '{print $4}'`
  IP3=`hostname | awk -F '-' '{print $5}'`
  HOSTNAME="amz-sin${IP1}-sdk-${IP2}-${IP3}"
  # update zabbix configuration
[ ! -d /etc/zabbix ] && mkdir /etc/zabbix && chown -R zabbix:zabbix zabbix:zabbix
[ ! -d /run/zabbix/ ] && mkdir /run/zabbix && chown -R zabbix:zabbix  /run/zabbix
[ ! -d /var/run/zabbix ] && mkdir /var/run/zabbix
chown -R zabbix:zabbix /var/run/zabbix
rsync -aqur /tmp/public/zabbix/scripts/ /etc/zabbix/scripts/
rsync -aqur  /tmp/public/zabbix/zabbix_agentd.d/ /etc/zabbix/zabbix_agentd.d/
chown zabbix:zabbix -R /etc/zabbix/scripts
chown zabbix:zabbix -R /etc/zabbix/zabbix_agentd.d/*
chmod a+x /etc/zabbix/scripts/*
if [ ! -d /var/log/zabbix ]
then
  mkdir /var/log/zabbix
  chown zabbix:zabbix /var/log/zabbix
fi
cat > /etc/zabbix/zabbix_agentd.conf <<EOF
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Include=/etc/zabbix/zabbix_agentd.d/
UnsafeUserParameters=1
Server=10.17.10.100
ServerActive=10.17.10.100
Hostname=${HOSTNAME}
Timeout=3
EOF
chown -R zabbix:zabbix /etc/zabbix  /var/log/zabbix
}



Install_zabbix-agent(){
  path_zabbix_agentd="/usr/sbin/zabbix_agentd"
  ln -s ${new_zabbix} ${path_zabbix_agentd}
  zabbix_agentd_ver=`zabbix_agentd -V| head  -n 1| awk '{print $4}'`
  echo "Install_zabbix_agent_ver:${zabbix_agentd_ver}" >>/tmp/osinit.log
}

zabbix-agent-status(){
  status=`ps -ef | grep zabbix_agentd|grep -v grep |wc -l`
  if [[ "${status}" > 1 ]];then
    echo "zabbix-agent-${zabbix_agentd_ver} running." >>/tmp/osinit.log
  else
    echo "zabbix-agent-${zabbix_agentd_ver} run fail." >>/tmp/osinit.log
  fi
}


Start_zabbix-agent_Service(){
  copy_zabbix-agent4
  Install_zabbix-agent
  install_zabbixagent_conf
  service_zabbixagent_conf
  service zabbix-agent start
  zabbix-agent-status
}

Start_zabbix-agent_System(){
  copy_zabbix-agent4
  Install_zabbix-agent
  install_zabbixagent_conf
  system_zabbixagent_conf
  systemctl start zabbix-agent.service
  zabbix-agent-status
}


Start_zabbix-agent(){

  if [ -e /etc/redhat-release ];then
    PLATFORM=$(cat /etc/redhat-release|awk -F' ' {'print $1'}|head -1)
  else
      PLATFORM=$(cat /etc/issue|awk -F' ' {'print $1'}|head -1)
      cat /etc/issue|grep -Eq "Amazon"
      if [ $? -eq 0 ];then
          PLATFORM='Amazon'
      fi
      CentOS7_Ver=0
  fi

  if [ "${PLATFORM}" == "CentOS" ];then
      /bin/uname -r | cut -d '.' -f 6 > /tmp/version
  elif [ "${PLATFORM}" == "Ubuntu" ];then
      cat /etc/issue|awk -F' ' {'print $2'}|head -1>/tmp/version
  elif [ "${PLATFORM}" == "Amazon" ];then
      echo "Amazon Linux AMI"
  else
      echo "The image is error." >> /tmp/osinit.log
  fi

  if [ "${PLATFORM}" == "CentOS" ];then
    if grep -q 6 /tmp/version;then
      Start_zabbix-agent_Service
      echo "Centos 6" >> /tmp/osinit.log
    elif grep -q 7 /tmp/version;then
      Start_zabbix-agent_System
      echo "Centos 7" >> /tmp/osinit.log
    else
      Start_zabbix-agent_Service
      echo "Other Centos" >> /tmp/osinit.log
    fi
  elif [ "${PLATFORM}" == "Ubuntu" ];then
    if grep -q 14 /tmp/version;then
      Start_zabbix-agent_Service
      echo "Ubuntu 14" >> /tmp/osinit.log
    elif grep -q 16 /tmp/version;then
      Start_zabbix-agent_System
      echo "Ubuntu 16" >> /tmp/osinit.log
    elif grep -q 18 /tmp/version;then
      Start_zabbix-agent_System
      echo "Ubuntu 18" >> /tmp/osinit.log
    else
      Start_zabbix-agent_Service
      echo "other ubuntu" >> /tmp/osinit.log
    fi
  elif [ "${PLATFORM}" == "Amazon" ];then
      Start_zabbix-agent_Service
      echo "Amazon system" >> /tmp/osinit.log
  else
    echo "wrong..." >> /tmp/osinit.log
  fi
}

Start_zabbix-agent
