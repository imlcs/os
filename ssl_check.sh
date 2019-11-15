#!/bin/bash

domain="dev test pre info"
Alert_Days="15"


Check()
{
    Cur_Time=$(date +%s)
    Expire_Date=$(curl -o /dev/null -m 10 --connect-timeout 10 -svIL https://${Domain} 2>&1|grep "expire date:"|sed 's/*\s\+expire date:\s\+//')
    Expire_Time=$(date -d "${Expire_Date}" +%s)
    Alert_Time=$((${Expire_Time}-${Alert_Days}*86400))
    Expire_Date_Read=$(date -d @${Expire_Time} "+%Y-%m-%d")
    echo "Domain:${Domain} Expire Date: ${Expire_Date_Read}"

    if [ ${Cur_Time} -ge ${Alert_Time} ] ; then
        TOKEN="DingDing Token"
        DING="curl -H \"Content-Type: application/json\" -X POST --data '{\"msgtype\": \"markdown\", \"markdown\": {\"title\":\"域名ssl证书将要过期\",\"text\": \"域名:  ${Domain} 过期时间:  ${Expire_Date_Read}\"}}' ${TOKEN}"
    eval $DING
    fi
    sleep 1
}

for Domain in ${domain};do
    Check ${Domain}
done
