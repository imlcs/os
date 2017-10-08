#!/bin/bash

time=`date "+%F  %H:%M:%S"`
echo -e "$time    ------notify_master------\n" >> /etc/keepalived/logs/notify_master.log
/sbin/drbdadm primary test1 &>> /etc/keepalived/logs/notify_master.log
/bin/mount /dev/drbd1 /drbd &>> /etc/keepalived/logs/notify_master.log
/sbin/service nfs restart &>> /etc/keepalived/logs/notify_master.log
echo -e "\n" >> /etc/keepalived/logs/notify_master.log
