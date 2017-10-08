#!/bin/bash

time=`date "+%F  %H:%M:%S"`
echo -e "$time  ------notify_stop------\n" >> /etc/keepalived/logs/notify_stop.log
/sbin/service nfs stop &>> /etc/keepalived/logs/notify_stop.log
/bin/umount /drbd &>> /etc/keepalived/logs/notify_stop.log
/sbin/drbdadm secondary test1 &>> /etc/keepalived/logs/notify_stop.log
echo -e "\n" >> /etc/keepalived/logs/notify_stop.log
