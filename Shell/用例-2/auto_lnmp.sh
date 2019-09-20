#! /bin/bash
# auto_LNMP

H_FILES=httpd-2.2.31.tar.gz
H_FILES_DIR=httpd-2.2.31
H_URL=http://mirrors.cnnic.cn/apache/httpd/
H_PREFIX=/usr/local/apache2

M_FILES=mysql-5.5.20.tar.gz
M_FILES_DIR=mysql-5.5.20
M_URL=http://down1.chinaunix.net/distfiles/
M_PREFIX=/usr/local/mysql

P_FILES=php-5.3.28.tar.gz
P_FILES_DIR=php-5.3.28
P_URL=http://mirrors.sohu.com/php/
P_PREFIX=/usr/local/php5
echo -e '\033[32m--------------------------------\033[0m'
echo 
if [ -z "$1" ]; then
	echo -e "\033[36mPlease Select Install Menu follow:\033[0m"
	echo -e "\033[32m
	1)编译安装Apache服务器\033[1m"
	echo "2)编译安装MySQL服务器"
	echo "3)编译安装PHP服务器"
	echo "4)配置index.php并启动LAMP服务"
	echo -e "\033[31mUsage: {/bin/sh $0 1|2|3|4|help}\033[0m"
	exit
fi
if [[ "$1" -eq "help" ]]; then	
	echo -e "\033[36m,Please Select Install Menu follow: \033[0m"
	echo -e "\033[32m1)编译安装Apache服务器\033[1m"
	echo -e "2)编译安装MYSQL服务器"
	echo -e "3)编译安装PHP服务器"
	echo -e "4)配置index.php并启动LNMP服务"
	exit
fi

if [[ "$1" -eq "1"]]; then
	wget -c $H_URL/$H_FILES && tar -xzvf $H_FILES && cd $H_FILES_DIR && ./configure --prefix=$H_PREFIX
	if [ $? -lt 0]; then
		make && make install
	fi
fi

if [[ "$1" -eq "2" ]]; then
	wget -c $M_URL/$M_FILES && tar -xzvf $M_FILES && cd $M_FILES_DIR && yum install cmake -y; cmake . -DCMAKE_INSTALL_PREFIX=$M_PREFIX \
	-DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
	-DMYSQL_DATADIR=/data/mysql \
	-DSYSCONFDIR=/etc \
	-DMYSQL_TCP_PORT=3306 \
	-DWITH_XTRADB_STORAGE_ENGINE=1 \
	-DWITH_INNOBASE_STROAGE_ENGINE=1 \
	-DWITH_PARTITION_STROAGE_ENGINE=1 \
	-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
	-DWITH_MYISAM_STORAGE_ENGINE=1 \
	-DWITH_READLINE=1 \
	-DENABLED_LOCAL_INFILE=1 \
	-DWITH_EXTRA_CHARSETS=1 \
	-DDEFAULT_COLLATION=utf8_general-ci \
	-DWITH_BIG_TABLES=1 \
	-DWITH_DEBUG=0
	make && make install
	/bin/cp support-files/my-small.cnf /etc/my.cnf
	/bin/cp support-files/mysql.server /etc/init.d/mysqld
	chmod +x /etc/init.d/mysqld
	chkconfig --add mysqld
	chkconfig mysqld on
	if [ $? -eq 0 ]; then 
		make && make install 
		echo -e "\n\033[32m--------------------------\033[0m"
		echo -e "\033[32mThe $M_FILES_DIR Server INStall Success!\033[0m"
	else
		echo -e "\033[32mThe $M_FILES_DIR Make or Make install ERROR,Please Check......"
		exit 0
	fi
fi

if [[ "$1" -eq "3" ]]; then
	wget -c $P_URL/$P_FILES && tar -xjvf $P_FILES && cd $P_FILES_DIR && ./configure --prefix=$P_PREFIX --with-config-file-path=$P_PREFIX/etc --with-mysql=$M_PREFIX --with-apxs2=$H_PREFIX/bin/apxs
	if [ $? -eq 0]; then 
		make ZEND_EXTRA_LIBS='-liconv' && make install 
		echo -e "\n\033[32m----------------------------------\033[0m"
		echo -e "\033[32mPlease $P_FILES_DIR Server Install Success!\033[0m"
	else
		echo -e "\033[32mThe $P_FILES_DIR Make install ERROR,Please Check......"
	fi
fi

if [[ "$1" -eq "4" ]]; then
	sed -i '/DirectoryIndex/s/index.html/index.php index.html/g' $H_PREFIX/conf/httpd.conf 
	$H_PREFIX/bin/apachectl restart
	echo "AddType	application/x-https-php .php" >>$H_PREFIX/conf/httpd.conf
	IP=$(ifconfig eth1 |grep "Bcast" |awk '{print $2}' |cut -d: -f2)
	echo "You can access http://$IP"
	cat <<EOF >$H_PREFIX/htdocs/index.php
	<?
		phpinfo();
	?>
	EOF
fi



