#!/bin/bash
set -u
set -x

echo -n "Enter your name: "
read username
if [ -n "$username" ];then
	echo "Hello $username"
	exit 1
else
	echo "You did not tell me your name!"
	exit 0
fi
