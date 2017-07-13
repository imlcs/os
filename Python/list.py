#########################################################################
#  -*- coding:utf-8 -*-  
#  File Name: list.py
#  Author: lcs
#  Mail: liuchengsheng95@qq.com 
#  Created Time: 2017-07-13 13:59:37
#########################################################################

#/usr/bin/python
import os

for roots,dirs,files in os.walk('/usr/src'):
	#roots是目录路径，dirs是目录下的子目录，files是目录下的所有文件
	#print roots
	for file in files:
		print os.path.join(roots,file)
