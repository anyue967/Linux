#!/bin/bash
#1获取输入参数的个数，如果没有参数直接退出
pcount=$#
if((pcount==0)); then
	echo no args;
	exit;
fi
#2 获取文件名称
p1=$1
fname='basename $p1'
echo fname=$fname
#3 获取上级目录到绝对路径
pdir='cd -p $(dirname $p1);pwd'
echo pdir=$pdir
#4 获取当前用户的名称
user='whoami'
#5循环
for((host=103;host<105;host++)); do
	echo -----------hadoop$host-----------
	rsync -rvl $pdir/$fname $user@hadoop$host:$pdir
done