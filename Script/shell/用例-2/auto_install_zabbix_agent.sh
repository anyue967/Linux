#!/bin/bash
# auto install zabbix

ZABBIX_SOFT = "zabbix-3.2.6.tar.gz"
INSTALL_DIR = "/usr/local/zabbix"
SERVER_IP = "192.168.37.10"
IP = 'ifconfig |grep Bcast |awk '{print $2}' |sed 's/addr://g''

AGENT_INSTALL(){
	yum -y install curl curl-devel net-snmp net-snmp-devel perl-DBI 
	groupadd zabbix; useradd -g zabbix zabbix; usermod -s /sbin/nologin zabbix
	tar -xzf $ZABBIX_SOFT; cd 'echo $ZABBIX_SOFT |sed 's/.tar.*//g''
	./configure --prefix=/usr/local/zabbix --enable-agent && make install
	if [ $? -eq 0 ]; then
		ln -s /usr/local/zabbix/sbin/zabbix_* /usr/local/sbin
	fi
	cd -; cd zabbix-3.2.6
	cp misc/init.d/tru64/zabbix_agentd /etc/init.d/zabbix_agentd; chmod o+x /etc/init.d/zabbix_agentd

	cat >$INSTALL_DIR/etc/zabbix_agentd.conf <<EOF
	LogFile=/tmp/zabbix_agentd.log
	Server = $SERVER_IP
	ServerActive = $SERVER_IP
	Hostname = $IP
	EOF

	/etc/init.d/zabbix_agentd restart
	/etc/init.d/iptables stop
	setenforce 0
}
AGRNT_INSTALL