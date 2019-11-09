#!/bin/bash

:'
给定用户，获取其密码警告期限，而后判断用户最近一次修改
密码时间据是否已经小于警告期限

算数运算：
	let c=$a+$b
	c=$[$a+$b]
	c=$(($a+$b))
	c=`expr $a + $b` 
	
退出脚本：exit 1
'

read -p "请输入用户：" $1
WARNDAY=`grep "$1" /etc/shadow |cut -d: -f6`
TIMETEMP=`date +%s`
DAYS=$(($TIMETEMP/86400))	# 今天距19700101的天数
SHORTDAY=`grep "$1" cat /etc/shadow |cut -d: -f3`
LONGDAY=$(grep "$1" cat /etc/shadow |cut -d: -f5)
SY=$[$LONGDAY-$[$TIMETEMP-$SHORTDAY]]

if [ $SY -lt $WARNDAY ]; then
	echo "Warining"
else
	echo "Ok"



