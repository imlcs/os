#########################################################################
# File Name: iptables.sh
# Author: lcs
# mail: liuchengsheng95@qq.com
# Created Time: 2017-11-08 14:37:17
#########################################################################

#!/bin/bash

# 第一步：清空当前的所有规则和计数
iptables -F  #清空所有的防火墙规则
iptables -X  #删除用户自定义的空链
iptables -Z #清空计数


# 第二步：配置允许ssh端口连接
iptables -A INPUT -s 192.168.1.0/24 -p tcp --dport 22 -j ACCEPT  #22为你的ssh端口 

# 第三步：允许本地回环地址可以正常使用
iptables -A INPUT -i lo -j ACCEPT  #本地圆环地址就是那个127.0.0.1，是本机上使用的,它进与出都设置为允许
iptables -A OUTPUT -o lo -j ACCEPT

# 第四步：设置默认的规则
iptables -P INPUT DROP #配置默认的不让进
iptables -P FORWARD DROP #默认的不允许转发
iptables -P OUTPUT ACCEPT #默认的可以出去

# 第五步：配置白名单
iptables -A INPUT -p all -s 192.168.1.0/24 -j ACCEPT  #允许机房内网机器可以访问

# 第六步：开启相应的服务端口
iptables -A INPUT -p tcp --dport 80 -j ACCEPT #开启80端口，因为web对外都是这个端口
iptables -A INPUT -p icmp --icmp-type 8 -j ACCEPT #允许被ping
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT #已经建立的连接得让它进来
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT #已经建立的连接得让它进来
