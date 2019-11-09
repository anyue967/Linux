#!/bin/bash
read -p "请输入一个字符，并按Enter键确认：" KEY
case "$KEY" in
[a-z] | [A-Z])
	echo "您输入的是$KEY字母。"
;;
[0-9])
	echo "您输入的是$KEY数字。"
;;
*)
	echo "您输入的是空格、功能健或其他控制字符。"
esac
