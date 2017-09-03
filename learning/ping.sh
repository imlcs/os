#!/bin/bash
. /etc/init.d/functions
for ip in www.baidu.com www.google.com www.jd.com www.51cto.com fdfdf.mm;do
    ping -c 2 -i 0.2 $ip &>/dev/null
    if [ $? -eq 0 ];then
        action $ip true
    else
        action $ip false
    fi
done
