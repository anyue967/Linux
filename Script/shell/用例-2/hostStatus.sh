#!/bin/bash

#方式1:
#使用for大循环遍历ip地址
for i in `cat $(pwd)/ip.txt`
do
#定义变量count为0，每次大循环都重置count的值
    count=0
#小循环循环次数
    for j in `seq 3`
    do
    ping -c1 -W1 $i &>/dev/null
#如果成功echo;up,不成功则count++
        if [ $? -eq 0 ];then
        echo "$i is up....."
        break
        else
        let count++
        fi
    done
 #如果count的值等于3则echo;down
    if [ "$count" == "3" ];then
    echo "$i is down"
    fi
done

#方式2
#定义一个函数，Pingy一个up成功则跳出本次循环
ip_up() {
        ping -c1 -W1 $ip &>/dev/null
        if [ $? -eq 0 ];then
                echo "$ip is up....."
#continue: 在循环中不执行continue下面的代码，转而进入下一轮循环
#break: 结束并退出整个循环
#exit: 退出脚本，常带一个整数给系统，如 exit 0
#return: 在函数中将数据返回或返回一个结果给调用函数的脚本
#break: 是立马跳出循环, continue: 是跳出当前条件循环, 继续下一轮条件循环, exit: 是直接退出整个脚本
        continue
        fi
}
#while循环拿到IP, 执行函数, 三次ping失败则echo;down
while read ip
do
        ip_up
        ip_up
        ip_up
        echo "$ip is down....."
done < ip.txt

#方式3
#大循环循环IP
while read ip
do
#定义关联数组fail
    declare -A fail
#小循环循环ping的次数
    for i in `seq 3`
    do
        ping -c1 -W1 $ip &>/dev/null
#如果一次就成功，则echo:up,跳出循环，否则数组fail[ip]++
        if [ $? -eq 0 ];then
        echo "$ip is ip...."
        break
        else
        let fail[$ip]++
        fi
    done
#定义fail的次数，echo一个值，如果失败三次，那么数组索引fail[$ip]的值为3，echo这个ip,down
        sum=`echo ${fail[$ip]}`
        if [ "$sum" == "3" ];then
        echo ""$ip is down.....
        fi
done < ip.txt