#!/bin/bash
src=/home/htdocs/heLanCMS       # 需要同步的源路径
des=/home/htdocs/heLanCMS       # 目标服务器上的路径
dst_ip=192.168.7.13             # 目标服务器
user=root						# 同步的用户
cd ${src}           
/usr/local/bin/inotifywait -mrq --format  '%Xe %w%f' -e modify,create,delete,attrib,close_write,move ./ | while read file         # 把监控到有发生更改的"文件路径列表"循环
do
	INO_EVENT=$(echo $file | awk '{print $1}')      # 把inotify输出切割 把事件类型部分赋值给INO_EVENT
	INO_FILE=$(echo $file | awk '{print $2}')       # 把inotify输出切割 把文件路径部分赋值给INO_FILE
	echo "-------------------------------$(date)------------------------------------" >>/var/log/rsync.log
	echo $file >>/var/log/rsync.log
	#增加、修改、写入完成、移动进事件
	#增、改放在同一个判断，因为他们都肯定是针对文件的操作，即使是新建目录，要同步的也只是一个空目录，不会影响速度。
	if [[ $INO_EVENT =~ 'CREATE' ]] || [[ $INO_EVENT =~ 'MODIFY' ]] || [[ $INO_EVENT =~ 'CLOSE_WRITE' ]] || [[ $INO_EVENT =~ 'MOVED_TO' ]]         # 判断事件类型
	then
		#echo 'CREATE or MODIFY or CLOSE_WRITE or MOVED_TO'
		rsync -avzcpR  $(dirname ${INO_FILE}) ${user}@${dst_ip}:${des}       # INO_FILE变量代表路径  -c校验文件内容
		#上面的rsync同步命令 源是用了$(dirname ${INO_FILE})变量 即每次只针对性的同步发生改变的文件的目录(只同步目标文件的方法在生产环境的某些极端环境下会漏文件 现在可以在不漏文件下也有不错的速度 做到平衡) 然后用-R参数把源的目录结构递归到目标后面 保证目录结构一致性
	fi
	#删除、移动出事件
	if [[ $INO_EVENT =~ 'DELETE' ]] || [[ $INO_EVENT =~ 'MOVED_FROM' ]]
	then
		#echo 'DELETE or MOVED_FROM'
		rsync -avzpR --delete $(dirname ${INO_FILE}) ${user}@${dst_ip}:${des}
		#直接同步已删除的路径${INO_FILE}会报no such or directory错误 ，并加上--delete来删除目标上有而源中没有的文件。
	fi

	#修改属性事件 指 touch chgrp chmod chown等操作
	if [[ $INO_EVENT =~ 'ATTRIB' ]]
	then
		#echo 'ATTRIB'
		if [ ! -d "$INO_FILE" ]                 # 如果修改属性的是目录 则不同步，因为同步目录会发生递归扫描，等此目录下的文件发生同步时，rsync会顺带更新此目录。
		then
			rsync -avzcpR $(dirname ${INO_FILE}) ${user}@${dst_ip}:${des} 
		fi
	fi
done
