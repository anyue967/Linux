#!/bin/bash
/sbin/service iptables restart
/sbin/iptables   -F INPUT	 #清除已设定的INPUT规则
/sbin/iptables   -F OUTPUT	 #清除已设定的OUTPUT规则
/sbin/iptables   -F  FORWARE	 #清除已设定的FORWARE规则
#设定默认规则
/sbin/iptables  -P  INPUT  DROP
/sbin/iptables  -P OUTPUT  ACCEPT
/sbin/iptables  -P  FORWARD  DROP

#添加访问策略
#允许本机访问
/sbin/iptables -A INPUT   -i   lo  -j   ACCEPT
#允许已建立的连接继续完成网络请求
/sbin/iptables  -A INPUT   -p  icmp  -j  ACCEPT        #允许ping
/sbin/iptables  -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
/sbin/iptables  -A  INPUT  -p  tcp  --dport  28000 -j   ACCEPT              #前台访问端口
/sbin/iptables  -A  INPUT  -p  tcp  --dport  8022  -j   ACCEPT              #ssh访问端口
#/sbin/iptables  -A  INPUT  -p  tcp  --dport  3306  -j   ACCEPT 
/sbin/iptables  -A  INPUT   -s  218.200.50.150  -p tcp  --dport  7890  -j   ACCEPT
/sbin/iptables  -A  INPUT   -s  218.206.191.49  -p tcp  --dport  7001  -j   ACCEPT
/sbin/iptables  -A  INPUT   -s  218.206.191.49  -p udp  --dport  161  -j   ACCEPT
/sbin/iptables  -A  INPUT   -s  218.206.191.49  -p udp  --dport  162  -j   ACCEPT
/sbin/iptables  -A  INPUT   -s  10.1.247.134  -p tcp  --dport  7001  -j   ACCEPT
/sbin/iptables  -A  INPUT   -s  10.1.247.134  -p udp  --dport  161  -j   ACCEPT
/sbin/iptables  -A  INPUT   -s  10.1.247.134  -p udp  --dport  162  -j   ACCEPT
#保存上述防火墙配置
service  iptables   save