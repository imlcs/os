#!/bin/bash
#coding:utf-8
#mysql分表备份
. /etc/init.d/functions
USER=root
PASS=123456
BACKDIR="/backup/$(date +%F)"
LOGIN="mysql -u$USER -p$PASS"
MYDUMP="mysqldump -u$USER -p$PASS"
if [ ! -d $BACKDIR ]
then
    mkdir -p $BACKDIR
fi
for database in $($LOGIN -e "show databases;" | egrep -v "mysql|*schema|Database")
do
    for table in $($LOGIN -e "use $database;show tables" | sed '1d')
    do
        $MYDUMP $database $table | gzip >${BACKDIR}/${database}_${table}_$(date +%F).bak.gz
    done
done
