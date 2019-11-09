#!/bin/bash

PRICE=$(expr $RANDOM % 1000)
TIMES=0
echo "商品的实际价格在0-999之间,猜猜看是多少?"
while true
do
	read -p "请输入您猜测的价格:" INT
	let TIMES++
if [ $INT -eq $PRICE ]; then
	echo "恭喜您答对了,实际价格是 $PRICE"
	echo "您总共猜测了 $TIMES 次"
	exit 0
elif [ $INT -gt $PRICE ] ; then
	echo "太高了!"
else
	echo "太低了!"
fi
done
