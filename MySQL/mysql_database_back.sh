#!/bin/bash
#coding:utf-8
#mysql分库备份
PWD="/data/backup/"
EXPIRE=30
mkdir -p /data/backup/$(date +%F)
USER=root
PASS=123456
LOGIN="mysql -u$USER -p$PASS"
MYDUMP="mysqldump -u$USER -p$PASS"
for database in `$LOGIN -e "show databases;" | egrep -v "mysql|*schema|Database|*found|backup"`
do
    #$MYDUMP $database | gzip >/data/backup/$(date +%F)/${database}_$(date +%F).bak.gz
    $MYDUMP $database | gzip >/data/backup/$(date +%F)/${database}.bak.gz
done
find $PWD -type d  -mtime +${EXPIRED} -exec rm -rf {} \;