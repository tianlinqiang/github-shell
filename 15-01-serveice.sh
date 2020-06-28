#!/bin/bash
. /etc/init.d/functions
while [ $1 != 'start' -a $1 != 'stop' -a $1 != 'restart' -a $1 != 'status' ];do
    echo "option is wrong.Input start|stop|restart|status"
    exit 1
done

case $1 in
start)
   if [ -e /var/lock/subsys/$0 ];then
       action "$0 service is running,not repeat start" false
   else
      if touch /var/lock/subsys/$0;then
          action $"$0 serveice start success "
      else 
          action "$0 service start fail" false
      fi
   fi
   ;;
stop)
    if [ ! -e /var/lock/subsys/$0 ];then
        action  "$0 service is stop,not repeat stop" false
    else 
        if rm -rf /var/lock/subsys/$0;then
            action  "$0 service stop success"
        else
            action  "$0 service stop file" false
        fi
    fi
    ;;
restart)
    if [ -e /var/lock/subsys/$0 ];then
        action "$0 serveice stop success" rm -rf /var/lock/subsys/$0
        action "$0 service start success" touch /var/lock/subsys/$0
    else
        action "$0 service start success" touch /var/lock/subsys/$0
    fi

    ;;
*)    if [ -e /var/lock/subsys/$0 ];then
          echo "$0 service ststus start"
      else
          echo "$0 service ststus stop"
      fi
      ;;
esac

