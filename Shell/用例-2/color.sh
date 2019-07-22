#!/bin/bash 
#\033[1;31;40m	显示方式, 可选; 字体颜色; 字体背景颜色
#\033[0m	回复终端默认颜色, 即取消颜色设置

# 字体颜色 
for i in {30..37}; do
	echo -e "\033[$i;40mHello world!\033[0m"
done
# 背景颜色 
for i in {41..47}; do 
	echo -e "\033[47;${i}mHello world!\033[0m" 
done 
# 显示方式 
for i in {1..8}; do 
	echo -e "\033[$i;31;40mHello world!\033[0m" 
done