#!/bin/bash
LOG_PATH='/usr/local/nginx/logs/' #日志的路径
EXPIRED=30                       #保存30天前的日志
PID='/usr/local/nginx/logs/nginx.pid'    #httpd pid路径
 
if [ ! -d ${LOG_PATH}oldlog ]; then
mkdir ${LOG_PATH}oldlog
fi
 
datetime=$(date -d yesterday +%F) #昨天的日期
logs=`find $LOG_PATH -maxdepth 1 -type f -name '*log'`
 
for log in $logs
do
fname=`echo $log | awk -F "/" '{print $NF}'`
mv ${log} ${LOG_PATH}oldlog/${datetime}"."${fname}
done
 
kill -USR1 $(cat ${PID})
find ${LOG_PATH}oldlog -type f -mtime +${EXPIRED} -exec rm -f {}
sleep 5