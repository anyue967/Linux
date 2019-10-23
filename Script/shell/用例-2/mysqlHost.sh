#!/usr/bin/env/bash
#####################
#  Mysql Install    #
#####################
while read ip
do
    {
        ssh root@$ip "rm -rf /etc/yum.repo.d/*"
        ssh root@$ip "wget ftp:// . . ./yumrepo/centos7.repo -P /etc/yum.repo.d"
        ssh root@$ip "wget ftp:// . . ./yumrepo/mysql57.repo -P /etc/yum.repo.d"
        #scp -r centos7.repo root@$ip:/etc/yum.repo.d/

        #Firewalld & SELiunx
        ssh root@$ip "systemctl stop firewall; systemctl disabled firewalld"
        ssh root@$ip "setenforce 0; sed -ri '/^SELINUX/c\SELINUX=disabled' /etc/selinux/config"

        #ntp
        ssh root@$ip "yum -y install chrony"
        ssh root@$ip "sed -ri '/3.centos/a\server 172.16.8.100 iburst' /etc/chrony.conf"
        ssh root@$ip "systemctl start chronyd; systemctl enable chronyd"

        #install mysql5.7
        ssh root@$ip "yum -y install mysql-community-server"
        ssh root@$ip "systemctl start mysqld; systemctl enable mysqld"
        ssh root@$ip "grep 'temporay password' /var/log/mysqld.log | awk '{print \$NF}'>/root/mysqlOldPass.txt"
        ssh root@$ip 'mysqladmin -uroot -p"`cat /root/mysqlOldPass.txt`" password"(newPassword)"'
    }&
    #默认情况下, 进程是前台进程, 这时就把Shell给占据了, 我们无法进行其他操作, 对于那些没有交互的进程,很多时候, 希望将其在后台启动, 可以在启动参数的时候加一个'&'实现这个目的
done <ip.txt
wait
echo "All Host Finished."