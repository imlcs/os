1. 处理以下一段文字
cat /server/script/word
the squid project provides a number of resources toassist users design,implement and support squid installations. Please browsethe documentation and support sections for more infomation the squid
    （1）.按照单词出现的频率排序，从大到小（不区分大小写）
		tr -d ",." < /server/script/word | tr "A-Z" "a-z" | tr " " "\n" | sort | uniq -c | sort -nr
		
	（2）.按照字母出现的频率排序，从大到小（不区分大小写）
		$cat char.sh 
		#!/bin/bash
		for char in a b c d e f g h i g k l m n o p q r s t u v w x y z
		do
		temp=`tr "A-Z" "a-z" < /server/script/word | tr -d -c "$char"` #去掉所有除了a-z的字符
		num=${#temp} #计算temp变量的长度
		echo -e "$char\t$num"
		done
		结果
		sh char.sh | sort -rnk2
		s	20
		e	18
		o	16
		t	15
2. 生成10个以下格式的文件（10个随机小写字母，_lcs.html）
	例：accjeebaff_lcs.html  chageabeae_lcs.html
		#!/bin/bash
		mkdir file
		for ((i=1;i<=10;i++))
		do
			#生成10个小写字母的字符串
			file=`echo $RANDOM | md5sum | tr   "0123456789" "abcdefghij" | cut -c1-10`
			touch ./file/${file}_lcs.html
		done
3. 把上一题中的文件名（accjeebaff_lcs.html）改为（accjeebaff_LCS.HTML）
	方法一：
		#!/bin/bash
		for name in `ls`
		do
			rename=`echo $name | sed 's/lcs\.html/LCS\.HTML/'`
			#方法二
			#rename=`echo ${name/%LCS.HTML/lcs.html}`
			mv $name $rename
		done
	

