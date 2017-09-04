#!/bin/bash

read -p "Pls. input first num:" num1
read -p "Pls. input second num:" num2

temp1=$(echo $num1 | tr -d "0-9")
temp2=$(echo $num2 | tr -d "0-9")

if [ -n "$temp1" -o -n "$temp2" ];then
    echo "Error: num1 or num2 not number!"
    exit 1
fi

[ $num1 -gt $num2 ] && echo "$num1 > $num2" && exit 0 || [ $num1 -eq $num2 ] && echo "$num1 = $num2" && exit 0 || echo "$num1 < $num2" && exit 0
