#!/bin/bash

time=`date "+%F  %H:%M:%S"`
echo -e "$time    ------notify_backup------\n" >> /etc/keepalived/logs/notify_backup.log
/sbin/service nfs stop &>> /etc/keepalived/logs/notify_backup.log
/bin/umount /dev/drbd1 &>> /etc/keepalived/logs/notify_backup.log
/sbin/drbdadm secondary test1 &>> /etc/keepalived/logs/notify_backup.log
echo -e "\n" >> /etc/keepalived/logs/notify_backup.log
