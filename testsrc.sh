#!/bin/bash
#
#chkconfig: - 19 90 
#description: test service script
. /etc/init.d/functions


service=$(basename $0)
lockfile=/var/lock/subsys/$service

usage(){
   echo "* Usage: $service service {start|stop|restart|status}"
   exit 1
}

start(){
   if [ -e $lockfile ];then
       action "$service service is running,not repeat start" false
   else
      if touch $lockfile;then
          action "$service serveice start success "
      else 
          action "$service service start fail" false
      fi
   fi

}
stop(){
    if [ ! -e $lockfile ];then
        action  "$service service is stop,not repeat stop" false
    else 
        if rm -f $lockfile;then
            action  "$service service stop success"
        else
            action  "$service service stop file" false
        fi
    fi
}

status(){
    if [ -e $lockfile ];then
          echo "$service service ststus start"
      else
          echo "$service service ststus stop"
      fi
}

restart(){
    if [ -e $lockfile ];then
        stop
        start
    else
        start
    fi
}
#while [ $1 != 'start' -a $1 != 'stop' -a $1 != 'restart' -a $1 != 'status' ];do
#    echo "option is wrong.Input start|stop|restart|status"
#    exit 1
#done
if (($# !=1));then
    usage
fi


case $1 in
start)
    start
    ;;
stop)
    stop
    ;;
restart)
    restart
    ;;
status)
    status
    ;;
*)
    usage
    ;;
esac

