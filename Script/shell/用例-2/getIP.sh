#!/usr/bin/bash
################
####getIP.sh####
################

#!/bin/bash
#检查IP的合法性
check_ipaddr()
{
    echo $1|grep "^[0-9]\{1,3\}\.\([0-9]\{1,3\}\.\)\{2\}[0-9]\{1,3\}$" > /dev/null;
    if [ $? -ne 0 ]
    then
        #echo "IP地址必须全部为数字" 
        return 1
    fi
    ipaddr=$1
    a=`echo $ipaddr|awk -F . '{print $1}'`  #以"."分隔，取出每个列的值 
    b=`echo $ipaddr|awk -F . '{print $2}'`
    c=`echo $ipaddr|awk -F . '{print $3}'`
    d=`echo $ipaddr|awk -F . '{print $4}'`
    for num in $a $b $c $d
    do
        if [ $num -gt 255 ] || [ $num -lt 0 ]    #每个数值必须在0-255之间 
        then
            #echo $ipaddr "中，字段"$num"错误" 
            return 1
        fi
   done
   #echo $ipaddr "地址合法"
   return 0
}

host=ns1.dnspod.net
port=16666
ip=`cat</dev/tcp/$host/$port`

check_ipaddr "$ip"

if [ "$?"x = "0"x ]; then
   echo "外网IP地址：$ip"
else
   echo "获取IP地址失败！"
fi
