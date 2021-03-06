#!/bin/bash
# init centos7
# 20160818

# 检查是否为root用户，脚本必须在root权限下运行
if [[ "$(whoami)" != "root" ]]; then
    echo "please run this script as root !" >&2
    exit 1
fi
echo -e "\033[31m the script only Support CentOS_7 x86_64 \033[0m"
echo -e "\033[31m system initialization script, Please Seriously. press ctrl+C to cancel \033[0m"

# 检查是否为64位系统，这个脚本只支持64位脚本
platform=`uname -i`
if [ $platform != "x86_64" ];then
    echo "this script is only for 64bit Operating System !"
    exit 1
fi

if [ "$1" == "" ];then
    echo "The host name is empty."
    exit 1
else
	hostnamectl  --static set-hostname  $1
	hostnamectl  set-hostname  $1
fi

cat << EOF
+---------------------------------------+
|   your system is CentOS 7 x86_64      |
|           start optimizing            |
+---------------------------------------+
EOF
sleep 1

# 配置阿里云yum源以及epel源
yum_repo() {
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo  &>/dev/null
yum makecache && echo y |  yum install epel-release  && yum makecache &>/dev/null
}

# 安装必要支持工具及软件工具
yum_update(){
yum update -y &>/dev/null
yum install -y autojump-zsh tree git nmap unzip wget vim lsof xz net-tools iptables-services ntpdate ntp-doc psmisc zsh lrzsz htop ncdu  &>/dev/null
}

# 设置时间同步 set time
zone_time(){
timedatectl set-timezone Asia/Shanghai
/usr/sbin/ntpdate times.aliyun.com > /dev/null 2>&1
/usr/sbin/hwclock --systohc
/usr/sbin/hwclock -w
cat > /var/spool/cron/root << EOF
10 0 * * * /usr/sbin/ntpdate times.aliyun.com > /dev/null 2>&1
* * * * */1 /usr/sbin/hwclock -w > /dev/null 2>&1
EOF
chmod 600 /var/spool/cron/root
/sbin/service crond restart
sleep 1
}

# 修改文件打开数 set the file limit
limits_config(){
cat > /etc/rc.d/rc.local << EOF
#!/bin/bash

touch /var/lock/subsys/local
ulimit -SHn 1024000
EOF

sed -i "/^ulimit -SHn.*/d" /etc/rc.d/rc.local
echo "ulimit -SHn 1024000" >> /etc/rc.d/rc.local

sed -i "/^ulimit -s.*/d" /etc/profile
sed -i "/^ulimit -c.*/d" /etc/profile
sed -i "/^ulimit -SHn.*/d" /etc/profile
 
cat >> /etc/profile << EOF
ulimit -c unlimited
ulimit -s unlimited
ulimit -SHn 1024000
EOF
 
source /etc/profile
ulimit -a
cat /etc/profile | grep ulimit

if [ ! -f "/etc/security/limits.conf.bak" ]; then
    cp /etc/security/limits.conf /etc/security/limits.conf.bak
fi

cat > /etc/security/limits.conf << EOF
* soft nofile 1024000
* hard nofile 1024000
* soft nproc  1024000
* hard nproc  1024000
hive   - nofile 1024000
hive   - nproc  1024000
EOF

if [ ! -f "/etc/security/limits.d/20-nproc.conf.bak" ]; then
    cp /etc/security/limits.d/20-nproc.conf /etc/security/limits.d/20-nproc.conf.bak
fi

cat > /etc/security/limits.d/20-nproc.conf << EOF
*          soft    nproc     409600
root       soft    nproc     unlimited
EOF

sleep 1
}
 
# 优化内核参数 tune kernel parametres 
sysctl_config(){
if [ ! -f "/etc/sysctl.conf.bak" ]; then
    cp /etc/sysctl.conf /etc/sysctl.conf.bak
fi

#add
cat > /etc/sysctl.conf << EOF
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_keepalive_intvl =15
net.ipv4.tcp_retries1 = 3
net.ipv4.tcp_retries2 = 5
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_max_tw_buckets = 60000
net.ipv4.tcp_max_orphans = 32768
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_wmem = 4096 16384 13107200
net.ipv4.tcp_rmem = 4096 87380 17476000
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.route.gc_timeout = 100
net.nf_conntrack_max = 6553500
net.netfilter.nf_conntrack_max = 6553500
net.netfilter.nf_conntrack_tcp_timeout_established = 180
fs.file-max = 1024000
EOF
 
#reload sysctl
/sbin/sysctl -p
sleep 1
}

# 设置UTF-8   LANG="zh_CN.UTF-8"
LANG_config(){
echo "LANG=\"en_US.UTF-8\"">/etc/locale.conf
source  /etc/locale.conf
}

 
#关闭SELINUX disable selinux
selinux_config(){
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
sleep 1
}

# iptables防护墙规则设置
iptables_config(){
mkdir  -p /opt/sh
cat > /opt/sh/ipt.sh << EOF
#!/bin/bash
/sbin/iptables -F
/sbin/iptables -t raw -F

/sbin/iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
/sbin/iptables -A INPUT -s 127.0.0.1 -j ACCEPT
/sbin/iptables -A INPUT -m state --state UNTRACKED,ESTABLISHED,RELATED -j ACCEPT
/sbin/iptables -A OUTPUT -j ACCEPT
/sbin/iptables -A INPUT -s 192.168.10.152 -j ACCEPT
/sbin/iptables -A INPUT -s 192.168.20.102 -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport 80  -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport 22  -j ACCEPT
/sbin/iptables -A INPUT -s 192.168.10.0/255.255.255.0 -p tcp --dport 8080  -j ACCEPT
/sbin/iptables -A INPUT -s 192.168.20.0/255.255.255.0 -p tcp --dport 8080  -j ACCEPT
/sbin/iptables -t raw -A PREROUTING -s 192.168.10.0/255.255.255.0 -p tcp --dport 80  -j NOTRACK
/sbin/iptables -t raw -A PREROUTING -s 192.168.20.0/255.255.255.0 -p tcp --dport 80  -j NOTRACK
/sbin/iptables -t raw -A OUTPUT -s 192.168.10.0/255.255.255.0 -p tcp --sport 80  -j NOTRACK
/sbin/iptables -t raw -A OUTPUT -s 192.168.20.0/255.255.255.0 -p tcp --sport 80  -j NOTRACK
/sbin/iptables -A INPUT   -s 192.168.10.0/255.255.255.0 -p icmp -j ACCEPT
/sbin/iptables -A INPUT   -s 192.168.20.0/255.255.255.0 -p icmp -j ACCEPT

/sbin/iptables -A INPUT -j REJECT
/sbin/iptables -A FORWARD -j REJECT

/sbin/service iptables save
echo ok
EOF
chmod  +x /opt/sh/ipt.sh
/opt/sh/ipt.sh
/sbin/service iptables restart

/sbin/iptables -nL
/sbin/iptables -t raw -L -n

#echo "/opt/sh/ipt.sh"  >>/etc/rc.d/rc.local
}


# SSH配置优化 set sshd_config
sshd_config(){
if [ ! -f "/etc/ssh/sshd_config.bak" ]; then
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
fi

cat >/etc/ssh/sshd_config<<EOF
Port 22
AddressFamily inet
ListenAddress 0.0.0.0
Protocol 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
SyslogFacility AUTHPRIV
PermitRootLogin yes
MaxAuthTries 6
RSAAuthentication yes
PubkeyAuthentication yes
AuthorizedKeysFile	.ssh/authorized_keys
PasswordAuthentication yes
ChallengeResponseAuthentication no
GSSAPIAuthentication no
GSSAPICleanupCredentials no
UsePAM yes
UseDNS no
X11Forwarding yes
UsePrivilegeSeparation sandbox
AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
AcceptEnv XMODIFIERS
Subsystem       sftp    /usr/libexec/openssh/sftp-server
EOF
/sbin/service sshd restart
}


# 关闭ipv6  disable the ipv6
ipv6_config(){
echo "NETWORKING_IPV6=no">/etc/sysconfig/network
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
echo 1 > /proc/sys/net/ipv6/conf/default/disable_ipv6


for line in $(ls -lh /etc/sysconfig/network-scripts/ifcfg-* | awk -F '[ ]+' '{print $9}')  
do
if [ -f  $line ]
        then
        sed -i 's/IPV6INIT=yes/IPV6INIT=no/g' $line
                echo $i
fi
done
}


# 服务优化设置
service_config(){
/usr/bin/systemctl stop  firewalld.service 
/usr/bin/systemctl disable  firewalld.service
/usr/bin/systemctl disable iptables.service
/usr/bin/systemctl enable NetworkManager-wait-online.service
/usr/bin/systemctl start NetworkManager-wait-online.service
/usr/bin/systemctl stop postfix.service
/usr/bin/systemctl disable postfix.service
chmod +x /etc/rc.local
chmod +x /etc/rc.d/rc.local
#ls -l /etc/rc.d/rc.local
}

# VIM设置
vim_zsh_config(){
cd /usr/src && wget https://github.com/imlcs/zsh/archive/master.zip && unzip master.zip && rm -f master.zip
cd /usr/src && wget https://github.com/imlcs/vim/archive/master.zip && unzip master.zip && rm -f master.zip
mv /usr/src/vim-master/.vim /usr/src/vim-master/.vimrc $HOME && rm -fr /usr/src/vim-master
mv /usr/src/zsh-master/function.sh /etc/profile.d/function.sh $HOME
mv /usr/src/zsh-master/.zshrc /usr/src/zsh-master/.oh-my-zsh/ $HOME && rm -fr /usr/src/zsh-master/
chsh -s /bin/zsh 
}


# done
done_ok(){
cat << EOF
+-------------------------------------------------+
|               optimizer is done                 |
|   it's recommond to restart this server !       |
|             Please Reboot system                |
+-------------------------------------------------+
EOF
}

# main
main(){
    yum_repo
    yum_update
    zone_time
    limits_config
    sysctl_config
    LANG_config
    selinux_config
    sshd_config
    ipv6_config
    service_config
    vim_zsh_config
    done_ok
}
main
