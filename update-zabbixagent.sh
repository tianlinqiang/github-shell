#!/bin/bash
# Author: jerry.zhao@ndpmedia.com
# Date: 2016.05.03


filename="zabbix-4.4.10-compiled-staticlib.tgz"
new_zabbix_path="/opt/zabbix-4.4.10-compiled-staticlib/sbin"
new_zabbix="/opt/zabbix-4.4.10-compiled-staticlib/sbin/zabbix_agentd"

old_sinip="10.2.255.21"
old_iadip="10.1.255.21"
new_sinip="10.100.255.91"
new_iadip="10.105.255.116"
file_path='/etc/zabbix/zabbix_agentd.conf'

copy_zabbix-agent4()
{
  wget -P /tmp/ http://osinit.ymtech.info:9000/public/zabbix-4.4.10-compiled-staticlib.tgz >/dev/null 2>&1
  #rsync -aq --password-file=/etc/rsyncd.secrets rsync@ftpsin.ymtech.info::awsami/zabbix-4.4.10-compiled-staticlib.tgz /tmp/
  if [ -e /tmp/${filename} ];then
    tar zxvf /tmp/${filename} -C /opt/ >/dev/null
  fi

  if [ -e ${new_zabbix} ];then
    echo "cpoy zabbix-4.4.10-compiled-staticlib success." >>/tmp/update_zabbix-4.4.10.log
  else
    echo "cpoy zabbix-4.4.10-compiled-staticlib fail." >>/tmp/update_zabbix-4.4.10.log
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
      echo "The image is Amazon or aliyun image." >> /tmp/update_zabbix-4.4.10.log
      echo "The image is Amazon or aliyun image."
  fi

  if [ "${PLATFORM}" == "CentOS" ];then
    if grep -q 6 /tmp/version;then
      service zabbix-agent stop >/dev/null
      if [ $? != 0 ];then
        echo "stop_disable_zabbix-agent(),systemctl stop fail" >>/tmp/update_zabbix-4.4.10.log
        echo "stop_disable_zabbix-agent(),systemctl stop fail"
        exit 2
      fi
          backet_zabbix_centos6
    echo "centos 6" >> /tmp/update_zabbix-4.4.10.log
    echo "centos 6"
    elif grep -q 7 /tmp/version;then
      systemctl stop zabbix-agent.service >/dev/null
      if [ $? != 0 ];then
        echo "stop_disable_zabbix-agent(),systemctl stop fail" >>/tmp/update_zabbix-4.4.10.log
        echo "stop_disable_zabbix-agent(),systemctl stop fail"
        exit 2
      fi
      backet_zabbix_centos7
            echo "centos 7" >> /tmp/update_zabbix-4.4.10.log
            echo "centos 7"
    else
          /etc/init.d/zabbix-agent stop >/dev/null
          if [ $? != 0 ];then
        echo "stop_disable_zabbix-agent(),systemctl stop fail" >>/tmp/update_zabbix-4.4.10.log
        echo "stop_disable_zabbix-agent(),systemctl stop fail"
        exit 2
    fi
          backet_zabbix_ubuntu
      echo "other centos " >> /tmp/update_zabbix-4.4.10.log
      echo "other centos "
    fi

  elif [ "${PLATFORM}" == "Ubuntu" ];then
    if grep -q 14 /tmp/version;then
       service zabbix-agent stop >/dev/null
            if [ $? != 0 ];then
        echo "stop_disable_zabbix-agent(),systemctl stop fail" >>/tmp/update_zabbix-4.4.10.log
        echo "stop_disable_zabbix-agent(),systemctl stop fail"
        exit 2
      fi
          backet_zabbix_ubuntu14
          echo "ubuntu 14"
    echo "ubuntu 14" >> /tmp/update_zabbix-4.4.10.log

    elif grep -q 16 /tmp/version;then
      /etc/init.d/zabbix-agent stop >/dev/null
        if [ $? != 0 ];then
        echo "stop_disable_zabbix-agent(),systemctl stop fail" >>/tmp/update_zabbix-4.4.10.log
        echo "stop_disable_zabbix-agent(),systemctl stop fail exit 2"
        exit 2
      fi
          backet_zabbix_ubuntu
          echo "ubuntu 16"
    echo "ubuntu 16" >> /tmp/update_zabbix-4.4.10.log
    else
          /etc/init.d/zabbix-agent stop >/dev/null
          if [ $? != 0 ];then
        echo "stop_disable_zabbix-agent(),systemctl stop fail" >>/tmp/update_zabbix-4.4.10.log
        echo "stop_disable_zabbix-agent(),systemctl stop fail exit 2"
        exit 2
      fi
          backet_zabbix_ubuntu
          echo "other ubuntu"
    echo "other ubuntu" >> /tmp/update_zabbix-4.4.10.log
    fi
  elif [ "${PLATFORM}" == "Amazon" ];then
    /etc/init.d/zabbix-agent stop >/dev/null
            if [ $? != 0 ];then
        echo "stop_disable_zabbix-agent(),systemctl stop fail" >>/tmp/update_zabbix-4.4.10.log
        echo "stop_disable_zabbix-agent(),systemctl stop fail exit 2"
        exit 2
      fi
          backet_zabbix_ubuntu14
          echo "Amazon system"
    echo "Amazon system" >> /tmp/update_zabbix-4.4.10.log
  elif [ "${PLATFORM}" == "Aliyun" ];then
    systemctl stop zabbix-agent.service >/dev/null
      if [ $? != 0 ];then
        echo "stop_disable_zabbix-agent(),systemctl stop fail" >>/tmp/update_zabbix-4.4.10.log
        echo "stop_disable_zabbix-agent(),systemctl stop fail"
        exit 2
      fi
      backet_zabbix_centos7
          echo "Aliyun os centos7" >> /tmp/update_zabbix-4.4.10.log
          echo "Aliyun os centos7"
  elif [ "${PLATFORM}" == "Otheros6" ];then
    service zabbix-agent stop >/dev/null
    if [ $? != 0 ];then
        echo "stop_disable_zabbix-agent(),systemctl stop fail" >>/tmp/update_zabbix-4.4.10.log
        echo "stop_disable_zabbix-agent(),systemctl stop fail"
        exit 2
    fi
    backet_zabbix_centos6
    echo "other centos 6" >> /tmp/update_zabbix-4.4.10.log
    echo "other centos 6"
  else
    /etc/init.d/zabbix-agent stop >/dev/null
            if [ $? != 0 ];then
        echo "stop_disable_zabbix-agent(),systemctl stop fail" >>/tmp/update_zabbix-4.4.10.log
        echo "stop_disable_zabbix-agent(),systemctl stop fail exit 2"
        exit 2
      fi
        backet_zabbix_ubuntu14
        echo "wrong..."
    echo "wrong..." >> /tmp/update_zabbix-4.4.10.log
  fi
}


update_zabbixagent(){
  sed -i 's/Server/#Server/g' ${file_path}
  status=$(cat ${file_path}|grep ${old_sinip})
  if [ -n "${status}" ];then
    sed -i "/Hostname/i\Server=${new_sinip}" ${file_path}
    sed -i "/Hostname/i\ServerActive=${new_sinip}" ${file_path}
  else
    sed -i "/Hostname/i\Server=${new_iadip}" ${file_path}
    sed -i "/Hostname/i\ServerActive=${new_iadip}" ${file_path}
  fi
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
  echo "zabbix_agent_ver:${zabbix_agentd_ver}" >>/tmp/update_zabbix-4.4.10.log
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
    echo "zabbix-agent-${zabbix_agentd_ver} running." >>/tmp/update_zabbix-4.4.10.log
  else
    echo "backet_zabbix_centos7(),zabbix-agent-${zabbix_agentd_ver} run fail." >>/tmp/update_zabbix-4.4.10.log
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
  echo "zabbix_agent_ver:${zabbix_agentd_ver}" >>/tmp/update_zabbix-4.4.10.log
  #chkconfig zabbix-agent on
  #if [ $? != 0 ];then
  # echo "backet_zabbix_centos6(),zabbix-agent-${zabbix_agentd_ver} chkconfig on fail." >>/tmp/update_zabbix-4.4.10.log
  #fi
  update_zabbixagent
  service zabbix-agent start
  status=`ps -ef | grep zabbix_agentd|grep -v grep |wc -l`
  if [[ "${status}" > 1 ]];then
    echo "zabbix-agent-${zabbix_agentd_ver} running." >>/tmp/update_zabbix-4.4.10.log
  else
    echo "backet_zabbix_centos6(),zabbix-agent-${zabbix_agentd_ver} run fail." >>/tmp/update_zabbix-4.4.10.log
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
  echo "zabbix_agent_ver:${zabbix_agentd_ver}" >>/tmp/update_zabbix-4.4.10.log
  echo "ln -s zabbix_agent_ver:${zabbix_agentd_ver}"
  #chkconfig zabbix-agent on
  #if [ $? != 0 ];then
  # echo "backet_zabbix_centos6(),zabbix-agent-${zabbix_agentd_ver} chkconfig on fail." >>/tmp/update_zabbix-4.4.10.log
  #fi
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
    echo "/etc/init.d/zabbix-agent run fail." >>/tmp/update_zabbix-4.4.10.log
    (/usr/sbin/zabbix_agentd -c /etc/zabbix/zabbix_agentd.conf &)
  fi
  status=`ps -ef | grep zabbix_agentd|grep -v grep |wc -l`
  if [[ "${status}" > 1 ]];then
    echo "zabbix-agent-${zabbix_agentd_ver} running." >>/tmp/update_zabbix-4.4.10.log
  else
    echo "backet_zabbix_ubuntu(),zabbix-agent-${zabbix_agentd_ver} run fail." >>/tmp/update_zabbix-4.4.10.log
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
  echo "zabbix_agent_ver:${zabbix_agentd_ver}" >>/tmp/update_zabbix-4.4.10.log
  #chkconfig zabbix-agent on
  #if [ $? != 0 ];then
  # echo "backet_zabbix_centos6(),zabbix-agent-${zabbix_agentd_ver} chkconfig on fail." >>/tmp/update_zabbix-4.4.10.log
  #fi
  update_zabbixagent
  service zabbix-agent start
  if [ $? != 0 ];then
  echo "ubuntu14 service zabbix-agent start fail." >>/tmp/update_zabbix-4.4.10.log
  (/usr/sbin/zabbix_agentd -c /etc/zabbix/zabbix_agentd.conf &)
  fi
  status=`ps -ef | grep zabbix_agentd|grep -v grep |wc -l`
  if [[ "${status}" > 1 ]];then
    echo "zabbix-agent-${zabbix_agentd_ver} running." >>/tmp/update_zabbix-4.4.10.log
  else
    echo "backet_zabbix_ubuntu14(),zabbix-agent-${zabbix_agentd_ver} run fail." >>/tmp/update_zabbix-4.4.10.log
    echo "backet_zabbix_ubuntu14(),zabbix-agent-${zabbix_agentd_ver} run fail."
  fi
}

#copy_zabbix-agent4
#stop_disable_zabbix-agent



#########################
#########################

zabbix_agentd_ver=`zabbix_agentd -V| head  -n 1| awk '{print $4}'`
if  [[ -n "${zabbix_agentd_ver}" ]];then
  if [[ "${zabbix_agentd_ver}" != "4.4.10" ]];then
    copy_zabbix-agent4
    stop_disable_zabbix-agent
  else
    echo "zabbix-agent version is ${zabbix_agentd_ver} not update"
  fi
else
  echo "no zabbix-agent."
fi

#########################
#########################
#zabbix_agentd_ver=`zabbix_agentd -V| head  -n 1| awk '{print $4}'`
#if  [[ "${zabbix_agentd_ver}" != "4.4.10" ]];then
#       bash /tmp/zabbix-agent-update-4.4.10.sh
#else
#       echo "zabbix-agent version is ${zabbix_agentd_ver} not update"
#fi