1.if/elif/fi选择分支
	#!/bin/bash
	read -p "Pls. input a number:" num
	if [ $num -lt 0 ]
	then
	echo "This is a negative."
	elif [ $num -gt 0 ] 
	then
		echo "This is a positive number."
	else
		echo "This is zero."
	fi
2.for循环
	#!/bin/bash
	sum=0
	for  ((i=1;i<=100;i=i++))
	do
	sum=$(( $sum + $i ))
	done
	echo    "1+2+3+....+100=$sum"
 
3.	while循环
	#!/bin/bash
	i=1
	sum=0
	while  [ $i -le 100 ]
	do
	sum=$(( $sum + $i ))
	i=$(( $i+1 ))
	done
	echo    "1+2+3+....+100=$sum"
4.	until循环
	#!/bin/bash
	#2016年 09月 06日 星期二 16:45:22 CST
	num=1
	sum=0
	until [ $num -gt 100 ]
	do
		let sum+=num
		let num++
	done
	echo "1+2+3+...+100=$sum"
 
5.	case结构
	#!/bin/bash
	#2016年 09月 06日 星期二 16:51:08 CST

	read -p "Pls. input (A-E):" score
	case $score in 
		A)
			echo "The range of score is from 90 to 100 !" ;;
		B)
			echo "The range of score is from 80 to 90 !" ;;
		C)
			echo "The range of score is from 70 to 80 !" ;;
		D)
			echo "The range of score is from 60 to 70 !" ;;
		E)
			echo "The range of score is from 0 to 59 !" ;;
		*)
			echo "Input is error, Pls. again input !" ;;
	esac
 
6.	select结构
	#!/bin/bash
	#2016年 09月 06日 星期二 16:51:08 CST
	echo "Pls. choose your score:"
	select score in A B C D E
	do
		break
	done
	case $score in 
		A)
			echo "The range of score is from 90 to 100 !" ;;
		B)
			echo "The range of score is from 80 to 90 !" ;;
		C)
			echo "The range of score is from 70 to 80 !" ;;
		D)
			echo "The range of score is from 60 to 70 !" ;;
		E)
			echo "The range of score is from 0 to 59 !" ;;
		*)
			echo "Input is error, Pls. again input !" ;;
	esac
7.	数组的遍历
	#!/bin/bash
	#2016年 09月 06日 星期二 15:56:04 CST
	for i in `seq 0 10`
	do
		arr[$i]="user$i"
	done
	#数组的赋值
	a=0
	for b in 0 1 2 ;do 
    		arr[${a}]=$b
    		a=$((a + 1))
	done
	#数组的遍历方法一：
	for name in ${arr[*]}
	do
		echo $name
	done
	#数组的遍历方法二：
	for (( i=0;i<${#arr[*]};i++ ))
	do
		echo ${arr[$i]}
	done
 
8.	循环的嵌套（打印正三角形）
	#!/bin/bash
	m=8
	n=8
	for i in `seq 15`
	do
		for j in `seq 15`
		do
			if [ $j -ge $m -a $j -le $n ]
			then
				echo -n "*"
			else
				echo -n " "
			fi
		done
		let "m--"
		let "n++"
		echo
		[ $m -eq 0 ] && break
	done
 
9.	函数的定义与应用
		#!/bin/bash
		function sm () {
                sum=0
                for  ((i=1;i<=$aa;i++))
                        do
                                sum=$(( $sum + $i ))
                        done
                echo    "1+2+3+....+$aa=$sum"
		}

		read -p "please input cishu:" aa

		bb=$( echo $aa | sed 's/[0-9]//g')
		if [ -z "$bb" ]
		then
			sm 
		else
			echo "$aa is not number! "
		fi

10.	猜数游戏
	#!/bin/bash
	echo "猜数游戏(1-100)之间："
	while true
	do
		num=`expr $RANDOM % 100`
		i=1
		while [ $i -eq 1 ]
		do
			read -p "请输入商品价格：" price
			if [ "$price" -gt "$num" ]
			then
				echo "太大了！"
			elif [ "$price" -lt "$num" ]
			then
				echo "太小了！"
			else
				echo "prefect!"
				read -n 1 -p  "Can you guess again ?[y/N]:" a
				echo
				[ "$a" == "y" -o "$a" == "Y" ] && i=0 || break
			fi
		done
		[ $i -eq 1 ] && break
	done

11.	踢掉不允许远程连接的来源IP
	#!/bin/sh
	arr[0]=0 #控制条件
	i=0 #定义数组起始下标
	. /etc/init.d/functions

	IP=`w | awk 'NR>2 {print $1 "@" $3}'` #获取登录user@IP

	for Login in `echo $IP | awk '{for(i=1;i<=NF;i++){print $i}}'` #分别把每个user@IP赋值给变量 Login_IP
	do
		Login_IP=`echo $Login | awk -F@ '{print $2}'`	#提取登录IP
		ctrl=0 #控制条件
		for Allow_IP in 192.168.11.6{2..6}  #允许登录的IP列表
		do
			if [ "$Login_IP" == "-" ] #判断是否是本地登录
			then
				user=`echo $Login | awk -F@ '{print $1}'` 
				action "${user}@localhost"
				ctrl=1
				break
			elif [ "$Login_IP" == "$Allow_IP" ] #判断远程登录的IP是否在允许列表
			then
				action "$Login" 
				ctrl=1
				break
			else
				continue
			fi
		done
		while [ $ctrl -eq 0 ] 
		do
			arr[$i]=$Login_IP	#把不允许登录的user@IP写入arr数组中
			arr1[$i]=$Login		#把不允许登录的IP写入arr1数组中，方便后面踢掉不允许的来源IP
			let "i++"
			break
		done
	done

#打印不允许登录的user@IP地址
	if [ "${arr[0]}" != "0" ]
	then
		echo -e "\e[31mNot allow login IP:\e[0m"
		for Deny_IP in ${arr1[*]}
		do
			echo -e "\e[31m	$Deny_IP\e[0m"
		done

	echo -e "\nStart kill not allow login IP, Pls. wait..."
	
	for Deny_IP in ${arr[*]} #杀死不允许登录的来源IP
	do
		PTS=`w | grep "$Deny_IP" |awk '{print $2}'`
		pkill -KILL -t $PTS
	done
	sleep 1
	echo "restart detection Login IP:" #重新检测登录的来源IP
	sleep 1
	echo
	sh $0
	fi
	实现效果
		root@192.168.11.62                                         [确定]
		root@192.168.11.62                                         [确定]
		Not allow login IP:
			root@192.168.11.162

		Start kill not allow login IP, Pls wait...
		restart detection Login IP:

		root@192.168.11.62                                         [确定]
		root@192.168.11.62                                         [确定]
	
12.	批量自定义添加用户，并且新用户三天内修改密码
	#!/bin/bash

	read -p "请输入用户名：" Name
	read -p "请输入创建用户的数量：" num
	read -p "请输入用户家目录前缀：" home 
	ADD=`which useradd`

	[ -z "$Name" ] && echo -e "\e[31m用户名不能为空\e[0m" && exit 
	Num=`echo $num | sed 's/[0-9]//g'`
	[ -n "$Num" ] && echo -e "\e[31m用户数量定义错误\e[0m" && exit 
	for i in `seq $num`
	do
		unset name
		name="$Name$i"
		Home_Dir="/home/$home"$name #用户家目录
		$ADD $name -d $Home_Dir >>/dev/null #创建用户

		if [ $? -eq 0 ] 
		then
			echo "123456" | passwd --stdin $name &>>/dev/null
			sed -i '/'$name'/s/99999/3/' /etc/shadow #用户三天后修改密码
			echo -e "账号：$name\t密码：123456"
		fi
	done
	
	实现效果
		请输入用户名：lcs
		请输入创建用户的数量：2
		请输入用户家目录前缀：L_
		账号：lcs1	密码：123456
		账号：lcs2	密码：123456
	
		请输入用户名：lcs
		请输入创建用户的数量：3
		请输入用户家目录前缀：L_
		useradd: user 'lcs1' already exists
		useradd: user 'lcs2' already exists
		账号：lcs3	密码：123456
13.	函数传参
	#!/bin/bash
	half () {
		n=$1 #参数1
		s=$2 #参数2
		let "n=n/s"
		echo "\$n=$n"
	}

	m=$1
	z=5
	echo "\$m=$m"
	half $m $z  #传参
	echo "\$m=$m"
