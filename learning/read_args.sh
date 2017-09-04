#!/bin/bash

function show_usage() 
{
	echo "Usage: $0 source_dir dest_dir"
	exit 1
}

#判定参数个数
if [ $# -ne 2 ];then
	show_usage
else
	#判定第一个参数的类型
	if [ -d $1 ];then 
		source_dir=$1
	else
		echo "Invalid source directory"
		show_usage
	fi
	#判定第二个参数的类型
	if [ -d $2 ];then
		dest_dir=$2
	else
		echo "Invalid dest directory"
		show_usage
	fi
fi

printf "$source_dir\n"
echo "$dest_dir"
