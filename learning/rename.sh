#!/bin/bash
#set -x
#set -u

dir="/home/lcs/lcs/"
for file in $(ls $dir);do
    temp=${file/_lcs/_LCS}
    new_file=${temp/.html/.HTML}
    mv ${dir}${file} $dir${new_file}
done
