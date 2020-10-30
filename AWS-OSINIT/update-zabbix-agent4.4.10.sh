#!/bin/bash
# Author: TLQ
# Date: 2020-10-30


filename="zabbix-4.4.10-compiled-staticlib.tgz"
new_zabbix_path="/opt/zabbix-4.4.10-compiled-staticlib/sbin"
new_zabbix="/opt/zabbix-4.4.10-compiled-staticlib/sbin/zabbix_agentd"


new_sinip="10.17.10.100"
file_path='/etc/zabbix/zabbix_agentd.conf'

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
    echo "cpoy zabbix-4.4.10-compiled-staticlib fail."
  fi
}

stop_disable_zabbix-agent(){
  if [ -e /etc/redhat-release ]
  then
      PLATFORM=$(cat /etc/redhat-release|awk -F' ' {'print $1'}|head -1)
      cat /etc/redhat-release| grep -Eq "Aliyun Linux release.*LTS (Hunting Beagle)"
      if [ $? -eq 0 ];then
          PLATFORM='Aliyun'
      fi
  # Test if OS is CentOS7
  else
      PLATFORM=$(cat /etc/issue|awk -F' ' {'print $1'}|head -1)
      cat /etc/issue|grep -Eq "Kernel"
      if [ $? -eq 0 ];then
          PLATFORM='Otheros6'
      fi
      CentOS7_Ver=0
  fi

  #Generate version file
  if [ "${PLATFORM}" == "CentOS" ];then
      /bin/uname -r | cut -d '.' -f 6 > /tmp/version
  elif [ "${PLATFORM}" == "Ubuntu" ];then
      cat /etc/issue|awk -F' ' {'print $2'}|head -1>/tmp/version
  elif [ "${PLATFORM}" == "Otheros6" ];then
      echo "other centos 6"
  else
      echo "The image is Amazon or aliyun image." >> /tmp/osinit.log
      echo "The image is Amazon or aliyun image."
  fi

  if [ "${PLATFORM}" == "CentOS" ];then
    if grep -q 6 /tmp/version;then
      service zabbix-agent stop >/dev/null
      if [ $? != 0 ];then
        echo "stop_disable_zabbix-agent(),systemctl stop fail" >>/tmp/osinit.log
        echo "stop_disable_zabbix-agent(),systemctl stop fail"
        exit 2
      fi
          backet_zabbix_centos6
    echo "centos 6" >> /tmp/osinit.log
    echo "centos 6"
    elif grep -q 7 /tmp/version;then
      systemctl stop zabbix-agent.service >/dev/null
      if [ $? != 0 ];then
        echo "stop_disable_zabbix-agent(),systemctl stop fail" >>/tmp/osinit.log
        echo "stop_disable_zabbix-agent(),systemctl stop fail"
        exit 2
      fi
      backet_zabbix_centos7
            echo "centos 7" >> /tmp/osinit.log
            echo "centos 7"
    else
          /etc/init.d/zabbix-agent stop >/dev/null
          if [ $? != 0 ];then
        echo "stop_disable_zabbix-agent(),systemctl stop fail" >>/tmp/osinit.log
        echo "stop_disable_zabbix-agent(),systemctl stop fail"
        exit 2
    fi
          backet_zabbix_ubuntu
      echo "other centos " >> /tmp/osinit.log
      echo "other centos "
    fi

  elif [ "${PLATFORM}" == "Ubuntu" ];then
    if grep -q 14 /tmp/version;then
       service zabbix-agent stop >/dev/null
            if [ $? != 0 ];then
        echo "stop_disable_zabbix-agent(),systemctl stop fail" >>/tmp/osinit.log
        echo "stop_disable_zabbix-agent(),systemctl stop fail"
        exit 2
      fi
          backet_zabbix_ubuntu14
          echo "ubuntu 14"
    echo "ubuntu 14" >> /tmp/osinit.log

    elif grep -q 16 /tmp/version;then
      /etc/init.d/zabbix-agent stop >/dev/null
        if [ $? != 0 ];then
        echo "stop_disable_zabbix-agent(),systemctl stop fail" >>/tmp/osinit.log
        echo "stop_disable_zabbix-agent(),systemctl stop fail exit 2"
        exit 2
      fi
          backet_zabbix_ubuntu
          echo "ubuntu 16"
    echo "ubuntu 16" >> /tmp/osinit.log
    else
          /etc/init.d/zabbix-agent stop >/dev/null
          if [ $? != 0 ];then
        echo "stop_disable_zabbix-agent(),systemctl stop fail" >>/tmp/osinit.log
        echo "stop_disable_zabbix-agent(),systemctl stop fail exit 2"
        exit 2
      fi
          backet_zabbix_ubuntu
          echo "other ubuntu"
    echo "other ubuntu" >> /tmp/osinit.log
    fi
  elif [ "${PLATFORM}" == "Amazon" ];then
    /etc/init.d/zabbix-agent stop >/dev/null
            if [ $? != 0 ];then
        echo "stop_disable_zabbix-agent(),systemctl stop fail" >>/tmp/osinit.log
        echo "stop_disable_zabbix-agent(),systemctl stop fail exit 2"
        exit 2
      fi
          backet_zabbix_ubuntu14
          echo "Amazon system"
    echo "Amazon system" >> /tmp/osinit.log
  elif [ "${PLATFORM}" == "Aliyun" ];then
    systemctl stop zabbix-agent.service >/dev/null
      if [ $? != 0 ];then
        echo "stop_disable_zabbix-agent(),systemctl stop fail" >>/tmp/osinit.log
        echo "stop_disable_zabbix-agent(),systemctl stop fail"
        exit 2
      fi
      backet_zabbix_centos7
          echo "Aliyun os centos7" >> /tmp/osinit.log
          echo "Aliyun os centos7"
  elif [ "${PLATFORM}" == "Otheros6" ];then
    service zabbix-agent stop >/dev/null
    if [ $? != 0 ];then
        echo "stop_disable_zabbix-agent(),systemctl stop fail" >>/tmp/osinit.log
        echo "stop_disable_zabbix-agent(),systemctl stop fail"
        exit 2
    fi
    backet_zabbix_centos6
    echo "other centos 6" >> /tmp/osinit.log
    echo "other centos 6"
  else
    /etc/init.d/zabbix-agent stop >/dev/null
            if [ $? != 0 ];then
        echo "stop_disable_zabbix-agent(),systemctl stop fail" >>/tmp/osinit.log
        echo "stop_disable_zabbix-agent(),systemctl stop fail exit 2"
        exit 2
      fi
        backet_zabbix_ubuntu14
        echo "wrong..."
    echo "wrong..." >> /tmp/osinit.log
  fi
}


update_zabbixagent(){
  sed -i 's/Server/#Server/g' ${file_path}
  sed -i "/Hostname/i\Server=${new_sinip}" ${file_path}
  sed -i "/Hostname/i\ServerActive=${new_sinip}" ${file_path}
  IP1=`hostname | awk -F '-' '{print $3}'`
  IP2=`hostname | awk -F '-' '{print $4}'`
  IP3=`hostname | awk -F '-' '{print $5}'`
  HOSTNAME="amz-sin${IP1}-sdk-${IP2}-${IP3}"
  sed -i 's/Hostname/#Hostname/g' ${file_path}
  echo "Hostname=${HOSTNAME}" >> ${file_path}
  echo "Timeout=3" >> ${file_path}

}


backet_zabbix_centos7()
{
  path_zabbix_agent=`which zabbix_agent`
  path_zabbix_agentd=`which zabbix_agentd`
  if [ -n "${path_zabbix_agent}" ];then
    mv $path_zabbix_agent $path_zabbix_agent.back
  fi

  if [ -n "${path_zabbix_agentd}" ];then
    mv $path_zabbix_agentd $path_zabbix_agentd.back
  fi

  ln -s ${new_zabbix} ${path_zabbix_agentd}
  zabbix_agentd_ver=`zabbix_agentd -V| head  -n 1| awk '{print $4}'`
  echo "zabbix_agent_ver:${zabbix_agentd_ver}" >>/tmp/osinit.log
  echo "ln -s zabbix_agent_ver:${zabbix_agentd_ver}"
  codfile_file='/lib/systemd/system/zabbix-agent.service'

  if [ -e ${codfile_file} ];then
    confile_status=`cat ${codfile_file}| grep CONFFILE`
    EnvironmentFile=`cat ${codfile_file}| grep EnvironmentFile`
    if [ -z "${EnvironmentFile}" ];then
          sed -i '/Service/a\EnvironmentFile=-\/etc\/default\/zabbix-agent' ${codfile_file}
    fi

    if [ -z "${confile_status}" ];then
          sed -i '/Service/a\Environment="CONFFILE=\/etc\/zabbix\/zabbix_agentd.conf"' ${codfile_file}
          sed -i '/ExecStart/ s/$/ -c \$CONFFILE/'  ${codfile_file}
    fi
        systemctl daemon-reload
  else
    if [ -d /lib/systemd/system/ ];then
        cat > /lib/systemd/system/zabbix-agent.service <<EOF
[Unit]
Description=Zabbix Agent
After=syslog.target
After=network.target

[Service]
Environment="CONFFILE=/etc/zabbix/zabbix_agentd.conf"
EnvironmentFile=-/etc/sysdefault/zabbix-agent
Type=forking
Restart=on-failure
PIDFile=/run/zabbix/zabbix_agentd.pid
KillMode=control-group
ExecStart=/usr/sbin/zabbix_agentd -c \$CONFFILE
ExecStop=/bin/kill -SIGTERM \$MAINPID
RestartSec=10s

[Install]
WantedBy=multi-user.target
EOF
  chmod 644 /lib/systemd/system/zabbix-agent.service
  systemctl daemon-reload
  fi
fi
  update_zabbixagent
  systemctl start zabbix-agent.service
  status=`ps -ef | grep zabbix_agentd|grep -v grep |wc -l`
  if [[ "${status}" > 1 ]];then
    echo "zabbix-agent-${zabbix_agentd_ver} running." >>/tmp/osinit.log
  else
    echo "backet_zabbix_centos7(),zabbix-agent-${zabbix_agentd_ver} run fail." >>/tmp/osinit.log
    echo "backet_zabbix_centos7(),zabbix-agent-${zabbix_agentd_ver} run fail."
  fi
}

backet_zabbix_centos6(){   #centos 6
  path_zabbix_agent=`which zabbix_agent`
  path_zabbix_agentd=`which zabbix_agentd`
  if [ -n "${path_zabbix_agent}" ];then
    mv $path_zabbix_agent $path_zabbix_agent.back
  fi
  if [ -n "${path_zabbix_agentd}" ];then
    mv $path_zabbix_agentd $path_zabbix_agentd.back
  fi

  ln -s ${new_zabbix} ${path_zabbix_agentd}
  zabbix_agentd_ver=`zabbix_agentd -V| head  -n 1| awk '{print $4}'`
  echo "zabbix_agent_ver:${zabbix_agentd_ver}" >>/tmp/osinit.log
  #chkconfig zabbix-agent on
  #if [ $? != 0 ];then
  # echo "backet_zabbix_centos6(),zabbix-agent-${zabbix_agentd_ver} chkconfig on fail." >>/tmp/update_zabbix-4.4.10.log
  #fi
  update_zabbixagent
  service zabbix-agent start
  status=`ps -ef | grep zabbix_agentd|grep -v grep |wc -l`
  if [[ "${status}" > 1 ]];then
    echo "zabbix-agent-${zabbix_agentd_ver} running." >>/tmp/osinit.log
  else
    echo "backet_zabbix_centos6(),zabbix-agent-${zabbix_agentd_ver} run fail." >>/tmp/osinit.log
    echo "backet_zabbix_centos6(),zabbix-agent-${zabbix_agentd_ver} run fail."
  fi
}

backet_zabbix_ubuntu(){
  path_zabbix_agent=`which zabbix_agent`
  path_zabbix_agentd=`which zabbix_agentd`
  if [ -n "${path_zabbix_agent}" ];then
    mv $path_zabbix_agent $path_zabbix_agent.back
  fi
  if [ -n "${path_zabbix_agentd}" ];then
    mv $path_zabbix_agentd $path_zabbix_agentd.back
  fi

  ln -s ${new_zabbix} ${path_zabbix_agentd}
  zabbix_agentd_ver=`zabbix_agentd -V| head  -n 1| awk '{print $4}'`
  echo "zabbix_agent_ver:${zabbix_agentd_ver}" >>/tmp/osinit.log
  echo "ln -s zabbix_agent_ver:${zabbix_agentd_ver}"
  codfile_file='/lib/systemd/system/zabbix-agent.service'

  if [ -e ${codfile_file} ];then
    confile_status=`cat ${codfile_file}| grep CONFFILE`
    EnvironmentFile=`cat ${codfile_file}| grep EnvironmentFile`
    if [ -z "${EnvironmentFile}" ];then
          sed -i '/Service/a\EnvironmentFile=-\/etc\/default\/zabbix-agent' ${codfile_file}
    fi

    if [ -z "${confile_status}" ];then
          sed -i '/Service/a\Environment="CONFFILE=\/etc\/zabbix\/zabbix_agentd.conf"' ${codfile_file}
          sed -i '/ExecStart/ s/$/ -c \$CONFFILE/'  ${codfile_file}
    fi
        systemctl daemon-reload
  else
    if [ -d /lib/systemd/system/ ];then
        cat > /lib/systemd/system/zabbix-agent.service <<EOF
[Unit]
Description=Zabbix Agent
After=syslog.target
After=network.target

[Service]
Environment="CONFFILE=/etc/zabbix/zabbix_agentd.conf"
EnvironmentFile=-/etc/sysdefault/zabbix-agent
Type=forking
Restart=on-failure
PIDFile=/run/zabbix/zabbix_agentd.pid
KillMode=control-group
ExecStart=/usr/sbin/zabbix_agentd -c \$CONFFILE
ExecStop=/bin/kill -SIGTERM \$MAINPID
RestartSec=10s

[Install]
WantedBy=multi-user.target
EOF
  chmod 644 /lib/systemd/system/zabbix-agent.service
  systemctl daemon-reload
  fi
fi
  update_zabbixagent
  /etc/init.d/zabbix-agent start
  if [ $? != 0 ];then
    echo "/etc/init.d/zabbix-agent run fail." >>/tmp/osinit.log
    (/usr/sbin/zabbix_agentd -c /etc/zabbix/zabbix_agentd.conf &)
  fi
  status=`ps -ef | grep zabbix_agentd|grep -v grep |wc -l`
  if [[ "${status}" > 1 ]];then
    echo "zabbix-agent-${zabbix_agentd_ver} running." >>/tmp/osinit.log
  else
    echo "backet_zabbix_ubuntu(),zabbix-agent-${zabbix_agentd_ver} run fail." >>/tmp/osinit.log
    echo "backet_zabbix_ubuntu(),zabbix-agent-${zabbix_agentd_ver} run fail."
  fi
}

backet_zabbix_ubuntu14(){
  path_zabbix_agent=`which zabbix_agent`
  path_zabbix_agentd=`which zabbix_agentd`
  if [ -n "${path_zabbix_agent}" ];then
    mv $path_zabbix_agent $path_zabbix_agent.back
  fi
  if [ -n "${path_zabbix_agentd}" ];then
    mv $path_zabbix_agentd $path_zabbix_agentd.back
  fi

  ln -s ${new_zabbix} ${path_zabbix_agentd}
  zabbix_agentd_ver=`zabbix_agentd -V| head  -n 1| awk '{print $4}'`
  echo "zabbix_agent_ver:${zabbix_agentd_ver}" >>/tmp/osinit.log
  update_zabbixagent
  service zabbix-agent start
  if [ $? != 0 ];then
  echo "ubuntu14 service zabbix-agent start fail." >>/tmp/osinit.log
  (/usr/sbin/zabbix_agentd -c /etc/zabbix/zabbix_agentd.conf &)
  fi
  status=`ps -ef | grep zabbix_agentd|grep -v grep |wc -l`
  if [[ "${status}" > 1 ]];then
    echo "zabbix-agent-${zabbix_agentd_ver} running." >>/tmp/osinit.log
  else
    echo "backet_zabbix_ubuntu14(),zabbix-agent-${zabbix_agentd_ver} run fail." >>/tmp/osinit.log
    echo "backet_zabbix_ubuntu14(),zabbix-agent-${zabbix_agentd_ver} run fail."
  fi
}

zabbix_agentd_ver=`zabbix_agentd -V| head  -n 1| awk '{print $4}'`
if  [[ -n "${zabbix_agentd_ver}" ]];then
  if [[ "${zabbix_agentd_ver}" != "4.4.10" ]];then
    echo "####Update zabbix-agent.4.4.10####"
    copy_zabbix-agent4
    stop_disable_zabbix-agent
  else
    echo "zabbix-agent version is ${zabbix_agentd_ver} not update" >>/tmp/osinit.log
  fi
else
  echo "####Not zabbix-agent####"
fi

