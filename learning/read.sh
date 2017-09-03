#!/bin/bash
read -n 5 -s -t 10 -p  "Pls. input UserName:" UserName

[ -z $UserName ] && exit 6
grep -q "^$UserName" /etc/passwd
[ $? -ne 0 ] && echo -e "\n$UserName is not exsist!" && exit 5

#Uid = $(id -u $UserName)
Uid=$(grep "^$UserName" /etc/passwd | cut -d: -f3)

echo $Uid
if [ "$Uid" -lt 500 ];then
    echo "System User!"
else
    echo "Putong User!"
fi
