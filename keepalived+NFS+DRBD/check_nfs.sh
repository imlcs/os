#!/bin/sh

###检查nfs可用性：进程和是否能够挂载
/sbin/service nfs status &>/dev/null
if [ $? -ne 0 ];then
    ###如果服务状态不正常，先尝试重启服务
    /sbin/service nfs restart
    /sbin/service nfs status &>/dev/null
    if [ $? -ne 0 ];then
        ###若重启nfs服务后，仍不正常
        ###卸载drbd设备
        umount /dev/drbd1
        ###将drbd主降级为备
        drbdadm secondary test1
        #关闭keepalived
        /sbin/service keepalived stop
    fi
fi
