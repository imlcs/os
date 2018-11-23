#########################################################################
# File Name: mysql_database_back.sh
# Author: lcs
# mail: liuchengsheng95@qq.com
# Created Time: 2018-11-07 14:51:54
#########################################################################

#!/bin/bash
# MySQL 分库备份,备份文件保留7天

BACKDIR="/data/backup/"
EXPIRE=7
USER="root"
PASS="123456"
HOST="127.0.0.1"
LOGIN="mysql -u$USER -p$PASS -h $HOST"
DUMP="mysqldump -u$USER -p$PASS -h $HOST"

mkdir -p ${BACKDIR}$(date +%F)
for database in $($LOGIN -e "show databases;" | egrep -v "mysql|*schema|Database|*found|backup")
do
    $DUMP $database | gzip >/data/backup/$(date +%F)/${database}.gz
done
find $BACKDIR -type d  -mtime +${EXPIRE} -exec rm -rf {} \;
