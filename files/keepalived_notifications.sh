#!/bin/bash

#TYPE=$1
#NAME=$2
NOW=`date "+%Y-%m-%d %H:%M:%S"`
NEWSTATE=$3

echo "$NEWSTATE" > /var/run/keepalived.state

case $NEWSTATE in
        "FAULT") echo "$NOW Trying to restart haproxy to get out"\
                  "of faulty state" >> /var/log/keepalived-notifications.log
                 /etc/init.d/haproxy stop
                 /etc/init.d/haproxy start
                 exit 0
                 ;;
        *) echo "$NOW Unknown state" >> /var/log/keepalived-notifications.log
           exit 1
           ;;

esac
