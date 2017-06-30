#!/bin/bash
#check MySQL_Slave Status
#crontab time 00:1
MYSQLPORT="3306"
MYSQLIP="192.168.48.20"
user="sync"
pass="123456"
sock="/var/lib/mysql/mysql.sock"
#STATUS=$(mysql -u$user -p$pass -S $sock -e "show slave status\G;" | grep -i "running:") 
STATUS=$(mysql -S $sock -e "show slave status\G;" | grep -i "running:") 
IO_env=$(echo $STATUS | grep IO | awk  ' {print $2}')
SQL_env=$(echo $STATUS | grep SQL | awk  '{print $2}')
DATA=$(date +"%F %T")

if [ "$IO_env" = "Yes" -a "$SQL_env" = "Yes" ]
then
  	echo "Slave is running!"
    echo "1" >/tmp/mysql_slave_ctrl
else
  	echo "####### $DATA #########">> /tmp/check_mysql_slave.log
  	echo "Slave is not running!" >>    /tmp/check_mysql_slave.log
    ctrl=$(cat /tmp/mysql_slave_ctrl)
    if [ $ctrl -eq 1 ];then
  	    echo "Slave is not running!" | mail -s "warn! $MYSQLIP MySQL Slave is not running" 992874270@qq.com
    fi
    echo "0" >/tmp/mysql_slave_ctrl
fi
