1.if/elif/fiѡ���֧
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
2.forѭ��
	#!/bin/bash
	sum=0
	for  ((i=1;i<=100;i=i++))
	do
	sum=$(( $sum + $i ))
	done
	echo    "1+2+3+....+100=$sum"
 
3.	whileѭ��
	#!/bin/bash
	i=1
	sum=0
	while  [ $i -le 100 ]
	do
	sum=$(( $sum + $i ))
	i=$(( $i+1 ))
	done
	echo    "1+2+3+....+100=$sum"
4.	untilѭ��
	#!/bin/bash
	#2016�� 09�� 06�� ���ڶ� 16:45:22 CST
	num=1
	sum=0
	until [ $num -gt 100 ]
	do
		let sum+=num
		let num++
	done
	echo "1+2+3+...+100=$sum"
 
5.	case�ṹ
	#!/bin/bash
	#2016�� 09�� 06�� ���ڶ� 16:51:08 CST

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
 
6.	select�ṹ
	#!/bin/bash
	#2016�� 09�� 06�� ���ڶ� 16:51:08 CST
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
7.	����ı���
	#!/bin/bash
	#2016�� 09�� 06�� ���ڶ� 15:56:04 CST
	for i in `seq 0 10`
	do
		arr[$i]="user$i"
	done
#����ı�������һ��
	#for name in ${arr[*]}
	#do
		#echo $name
	#done
#����ı�����������
	for (( i=0;i<${#arr[*]};i++ ))
	do
		echo ${arr[$i]}
	done
 
8.	ѭ����Ƕ�ף���ӡ�������Σ�
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
 
9.	�����Ķ�����Ӧ��
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

10.	������Ϸ
	#!/bin/bash
	echo "������Ϸ(1-100)֮�䣺"
	while true
	do
		num=`expr $RANDOM % 100`
		i=1
		while [ $i -eq 1 ]
		do
			read -p "��������Ʒ�۸�" price
			if [ "$price" -gt "$num" ]
			then
				echo "̫���ˣ�"
			elif [ "$price" -lt "$num" ]
			then
				echo "̫С�ˣ�"
			else
				echo "prefect!"
				read -n 1 -p  "Can you guess again ?[y/N]:" a
				echo
				[ "$a" == "y" -o "$a" == "Y" ] && i=0 || break
			fi
		done
		[ $i -eq 1 ] && break
	done

11.	�ߵ�������Զ�����ӵ���ԴIP
	#!/bin/sh
	arr[0]=0 #��������
	i=0 #����������ʼ�±�
	. /etc/init.d/functions

	IP=`w | awk 'NR>2 {print $1 "@" $3}'` #��ȡ��¼user@IP

	for Login in `echo $IP | awk '{for(i=1;i<=NF;i++){print $i}}'` #�ֱ��ÿ��user@IP��ֵ������ Login_IP
	do
		Login_IP=`echo $Login | awk -F@ '{print $2}'`	#��ȡ��¼IP
		ctrl=0 #��������
		for Allow_IP in 192.168.11.6{2..6}  #�����¼��IP�б�
		do
			if [ "$Login_IP" == "-" ] #�ж��Ƿ��Ǳ��ص�¼
			then
				user=`echo $Login | awk -F@ '{print $1}'` 
				action "${user}@localhost"
				ctrl=1
				break
			elif [ "$Login_IP" == "$Allow_IP" ] #�ж�Զ�̵�¼��IP�Ƿ��������б�
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
			arr[$i]=$Login_IP	#�Ѳ������¼��user@IPд��arr������
			arr1[$i]=$Login		#�Ѳ������¼��IPд��arr1�����У���������ߵ����������ԴIP
			let "i++"
			break
		done
	done

#��ӡ�������¼��user@IP��ַ
	if [ "${arr[0]}" != "0" ]
	then
		echo -e "\e[31mNot allow login IP:\e[0m"
		for Deny_IP in ${arr1[*]}
		do
			echo -e "\e[31m	$Deny_IP\e[0m"
		done

	echo -e "\nStart kill not allow login IP, Pls. wait..."
	
	for Deny_IP in ${arr[*]} #ɱ���������¼����ԴIP
	do
		PTS=`w | grep "$Deny_IP" |awk '{print $2}'`
		pkill -KILL -t $PTS
	done
	sleep 1
	echo "restart detection Login IP:" #���¼���¼����ԴIP
	sleep 1
	echo
	sh $0
	fi
	ʵ��Ч��
		root@192.168.11.62                                         [ȷ��]
		root@192.168.11.62                                         [ȷ��]
		Not allow login IP:
			root@192.168.11.162

		Start kill not allow login IP, Pls wait...
		restart detection Login IP:

		root@192.168.11.62                                         [ȷ��]
		root@192.168.11.62                                         [ȷ��]
	
12.	�����Զ�������û����������û��������޸�����
	#!/bin/bash

	read -p "�������û�����" Name
	read -p "�����봴���û���������" num
	read -p "�������û���Ŀ¼ǰ׺��" home 
	ADD=`which useradd`

	[ -z "$Name" ] && echo -e "\e[31m�û�������Ϊ��\e[0m" && exit 
	Num=`echo $num | sed 's/[0-9]//g'`
	[ -n "$Num" ] && echo -e "\e[31m�û������������\e[0m" && exit 
	for i in `seq $num`
	do
		unset name
		name="$Name$i"
		Home_Dir="/home/$home"$name #�û���Ŀ¼
		$ADD $name -d $Home_Dir >>/dev/null #�����û�

		if [ $? -eq 0 ] 
		then
			echo "123456" | passwd --stdin $name &>>/dev/null
			sed -i '/'$name'/s/99999/3/' /etc/shadow #�û�������޸�����
			echo -e "�˺ţ�$name\t���룺123456"
		fi
	done
	
	ʵ��Ч��
		�������û�����lcs
		�����봴���û���������2
		�������û���Ŀ¼ǰ׺��L_
		�˺ţ�lcs1	���룺123456
		�˺ţ�lcs2	���룺123456
	
		�������û�����lcs
		�����봴���û���������3
		�������û���Ŀ¼ǰ׺��L_
		useradd: user 'lcs1' already exists
		useradd: user 'lcs2' already exists
		�˺ţ�lcs3	���룺123456
13.	��������
	#!/bin/bash
	half () {
		n=$1 #����1
		s=$2 #����2
		let "n=n/s"
		echo "\$n=$n"
	}

	m=$1
	z=5
	echo "\$m=$m"
	half $m $z  #����
	echo "\$m=$m"
