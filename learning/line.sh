#!/bin/bash
file=$1
num=0
while read line
do
    num=$((num + 1))
done < $file

echo -e "\033[31;5;42m$num\033[0m"
