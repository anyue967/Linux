### 1. 使用LNMP架构部署动态网站环境  
+ 源码安装:  
	- 解压:`tar -xzvf FileName.tar.gz`         //.tar.bz2  
    - 编译:`.configure --prefix=/usr/local/program`  
    - 生成二进制安装程序:`make`  
    - 运行二进制服务程序包:`make install`  // 默认/usr/local/bin  
 	- 清理:make clean

`[root@linuxprobe ~]# yum install -y apr* autoconf automake bison bzip2 bzip2* compat* cpp curl curl-devel fontconfig fontconfig-devel freetype freetype* freetype-devel gcc gcc-c++ gd gettext gettext-devel glibc kernel kernel-headers keyutils keyutils-libs-devel krb5-devel libcom_err-devel libpng libpng-devel libjpeg* libsepol-devel libselinux-devel libstdc++-devel libtool* libgomp libxml2 libxml2-devel libXpm* libtiff libtiff* make mpfr ncurses* ntp openssl openssl-devel patch pcre-devel perl php-common php-gd policycoreutils telnet t1lib t1lib* nasm nasm* wget zlib-devel`

### 2.LNMP动态网站部署架构所需要的16个源码包和1个用于检查效果的论坛网站系统在/usr/local/src  
`[root@xy src]# tar -xzvf cmake-2.8.11.2.tar.gz`
`[root@xy src]# cd cmake-2.8.11.2/`
`[root@xy cmake-2.8.11.2]# ./configure`
`[root@xy cmake-2.8.11.2]# make`
`[root@xy cmake-2.8.11.2]# make install`

### 3. 配置MySQL服务  
`[root@xy src]# useradd mysql -s /sbin/nologin`
`[root@xy src]# mkdir -p /usr/local/mysql/var`
`[root@xy src]# chown -Rf mysql:mysql /usr/local/mysql`
`[root@xy src]# tar -xzvf mysql-5.6.19.tar.gz`
`[root@xy src]# cd mysql-5.6.19/` 
`[root@xy mysql-5.6.19]# cmake . -DCMAKE_INSTALL-PREFIX=/usr/local/mysql -DMYSQL_DATA`
  
    DIR=/usr/local/mysql/var -DSYSCONFDIR=/etc  
	 	-DCMAKE_INSTALL-PREFIX=       定义数据库服务程序保存目录  
	 	-DMYSQL_DATADIR=			   定义真实数据库文件目录  
	 	-DSYSCONFDIR= 			       定义数据库配置文件保存目录   
`[root@xy mysql-5.6.19]# make`
`[root@xy mysql-5.6.19]# make install`
`[root@xy mysql-5.6.19]# rm -rf /etc/my.cnf`    
`[root@xy mysql-5.6.19]# cd /usr/local/mysql`  
`[root@xy mysql]# ./scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/var`
`[root@xy mysql]# ln -s my.cnf /etc/my.cnf`
`[root@xy mysql]# cp ./support-files/mysql.server /etc/rc.d/init.d/mysqld`
`[root@xy mysql]# chmod 755 /etc/rc.d/init.d/mysqld`
`[root@xy mysql]# vim /etc/rc.d/init.d/mysql`

    basedir=/usr/local/mysql   					// 46  
    datadir=/usr/local/mysql/var 				// 47  
`[root@xy mysql]# service mysqld start`
Starting MySQL..... SUCCESS!   
`[root@xy mysql]# chkconfig mysqld on`	//mysqld 增加到开机启动  
`[root@xy mysql]# vim /etc/profile`
   export PATH=$PATH:/usr/local/mysql/bin 		// 74 增加mysql命令  
`[root@xy mysql]# source /etc/profile` 
`[root@xy mysql]# mkdir /var/lib/mysql`            //链接函数库 程序文件  
`[root@xy mysql]# ln -s /usr/local/mysql/lib/mysql /usr/lib/mysql`
`[root@xy mysql]# ln -s /tmp/mysql.sock /var/lib/mysql.sock`
`[root@xy mysql]# ln -s /usr/local/mysql/include/mysql /usr/include/mysql`
`[root@xy mysql]# mysql_secure_installation`

### 4. 配置Nginx服务  
`[root@xy ~]# cd /usr/locals/src/Softerware`
`[root@xy Softerware]# tar -xzvf pcre-8.35.tar.gz` //源码安装pcre,解决软件包依赖关系  
`[root@xy Softerware]# cd pcre-8.35/` 
`[root@xy pcre-8.35]# ./configure --prefix=/usr/local/pcre`
`[root@xy pcre-8.35]# make`
`[root@xy pcre-8.35]# make install`
`[root@xy pcre-8.35]# cd /usr/local/src/Softerware`
`[root@xy Softerware]# tar -xzvf openssl-1.0.1h.tar.gz` //提供网站加密证书服务程序  
`[root@xy Softerware]# cd openssl-1.0.1h/`
`[root@xy openssl-1.0.1h]# ./config --prefix=/usr/local/openssl`
`[root@xy openssl-1.0.1h]# make`
`[root@xy openssl-1.0.1h]# make install` 
`[root@xy openssl-1.0.1h]# vim /etc/profile`
   export PATH=$PATH:/usr/local/mysql/bin:/usr/local/openssl/bin  
`[root@xy openssl-1.0.1h]# source profile`

`[root@xy pcre-8.35]# cd /usr/local/src/Softerware`
`[root@xy Softerware]# tar -xzvf zlib-1.2.8.tar.gz`
`[root@xy Softerware]# cd zlib-1.2.8/`
`[root@xy zlib-1.2.8]# ./configure --prefix=/usr/local/zlib`
`[root@xy zlib-1.2.8]# make`
`[root@xy zlib-1.2.8]# make install`  
`[root@xy zlib-1.2.8]# cd ..`
`[root@xy src]# useradd www -s /sbin/nologin` 

`[root@xy src]# cd Software/`
`[root@xy Software]# tar -xzvf nginx-1.6.0.tar.gz` 
`[root@xy Software]# cd nginx-1.6.0/`
`[root@xy nginx-1.6.0]# ./configure --prefix=/usr/local/nginx`
 
	 --without-http_memcached_module 
	 --user=www 
	 --group=www 
	 --with-http_stub_status_module 
	 --with-http_ssl_module 
	 --with-http_gzip_static_module 
	 --with-openssl=/usr/local/src/Software/openssl-1.0.1h //软件源码包的解压路径  
	 --with-zlib=/usr/local/src/Software/zlib-1.2.8  
	 --with-pcre=/usr/local/src/Software/pcre-8.35  
`[root@xy nginx-1.6.0]# make`
`[root@xy nginx-1.6.0]# make install`
`[root@xy nginx-1.6.0]# vim /etc/rc.d/init.d/nginx`
`[root@xy nginx-1.6.0]# chmod 755 /etc/rc.d/init.d/nginx` 
`[root@xy nginx-1.6.0]# /etc/rc.d/init.d/nginx restart`
Restarting nginx (via systemctl):                          [  OK  ]  

### 5. 配置PHP  
`[root@xy Software]# tar -xzvf yasm-1.2.0.tar.gz` 	//yasm 开源汇编器  
`[root@xy Software]# cd yasm-1.2.0/`
`[root@xt yasm-1.2.0]# ./configure`
`[root@xy yasm-1.2.0]# make`
`[root@xy yasm-1.2.0]# make install`

`[root@xy Software]# tar -xzvf libmcrypt-2.5.8.tar.gz`  //libmcrypt加密算法扩展库程序  
`[root@xy Software]# cd libmcrypt-2.5.8/`
`[root@xt libmcrypt-2.5.8]# ./configure`
`[root@xy libmcrypt-2.5.8]# make`
`[root@xy libmcrypt-2.5.8]# make install`

`[root@xy Software]# tar -xzvf tiff-4.0.3.tar.gz` //tiff 提供标签图像文件格式服务  
`[root@xy Software]# cd tiff-4.0.3/`
`[root@xt tiff-4.0.3]# ./configure --prefix=/usr/local/tiff --enable-shared`
`[root@xy tiff-4.0.3]# make`
`[root@xy tiff-4.0.3]# make install`

`[root@xy Software]# tar -xzvf libpng-1.6.12.tar.gz` //libpng提供png图片格式支持函数库  
`[root@xy Software]# cd libpng-1.6.12/`
`[root@xt libpng-1.6.12]# ./configure --prefix=/usr/local/libpng --enable-shared`
`[root@xy libpng-1.6.12]# make`
`[root@xy libpng-1.6.12]# make install`

`[root@xy Software]# tar -xzvf freetype-2.5.3.tar.gz`   //freetype字体支持引擎服务  
`[root@xy Software]# cd freetype-2.5.3/`
`[root@xt freetype-2.5.3]# ./configure --prefix=/usr/local/freetype --enable-shared`
`[root@xy freetype-2.5.3]# make`
`[root@xy freetype-2.5.3]# make install`

`[root@xy Software]# tar -xzvf jepgsrc.v9a.tar.gz`  	//提供jepg图片格式支持函数库  
`[root@xy Software]# cd jepgsrc-v9a/`
`[root@xt jepgsrc-v9a]# ./configure --prefix=/usr/local/freetype --enable-shared`
`[root@xy jepgsrc-v9a]# make`
`[root@xy jepgsrc-v9a]# make install`

`[root@xy Software]# tar -xzvf libgd-2.1.0.tar.gz` 	//libgd 提供图形处理服务  
`[root@xy Software]# cd libgd-2.1.0/`
`[root@xt libgd-2.1.0]# ./configure --prefix=/usr/local/libgd --enable-shared` 

	 --with-jepg=/usr/local/jepg   
	 --with-png=/usr/local/libpng   
	 --with-freetype=/usr/local/freetype 
	 --with-fontconfig=/usr/local/freetype  
	 --with-xpm=/usr/ 
	 --with-tiff=/usr/local/tiff  
	 --with-vpx=/usr/local/libvpx  
`[root@xy libgd-2.1.0]# make`
`[root@xy libgd-2.1.0]# make install`

`[root@xy Software]# tar -xzvf t1lib-5.1.2.tar.gz` //t1lib 提供图片生成函数库服务  
`[root@xy Software]# cd t1lib-5.1.2/`
`[root@xt t1lib-5.1.2]# ./configure --prefix=/usr/local/t1lib --enable-shared`
`[root@xy t1lib-5.1.2]# make`
`[root@xy t1lib-5.1.2]# make install`
`[root@xy t1lib-5.1.2]# ln -s /usr/lib64/liblt`

`[root@xy Software]# tar -xzvf php-5.5.14.tar.gz`
`[root@xy Software]# cd php-5.5.14/`
`[root@xy php-5.5.14]# export LD_LIBRARY_PATH=/usr/local/libgd/lib` //创建全局变量  
`[root@xy php-5.5.14]# ./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --with-mysql=/usr/local/mysql --with-mysqli=/usr/local/mysql/bin/mysql_config --with-mysql-sock=/tmp/mysql.sock --with-pdo-mysql=/usr/local/mysql --with-gd --with-png-dir=/usr/local/libpng --with-jpeg-dir=/usr/local/jpeg --with-freetype-dir=/usr/local/freetype --with-xpm-dir=/usr/ --with-vpx-dir=/usr/local/libvpx/ --with-zlib-dir=/usr/local/zlib --with-t1lib=/usr/local/t1lib --with-iconv --enable-libxml --enable-xml --enable-bcmath --enable-shmop --enable -sysvsem --enable-inline-optimization --enable-opcache --enable-mbregex --enable-fpm --enable-mbstring --enable-ftp --enable-gd-native-ttf --with-openssl --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --without-pear --with-gettext --enable-session --with-mcrypt --with-curl --enable-ctype`
`[root@xy php-5.5.14]# make`
`[root@xy php-5.5.14]# make install`

`[root@xy php-5.5.14]# rm -rf /etc/php.ini` 	//删除默认配置文件  
`[root@xy php-5.5.14]# ln -s /usr/local/php/etc/php.ini /etc/php.ini`
`[root@xy php-5.5.14]# cp php.ini-production /usr/local/php/etc/php.ini`
`[root@xy php-5.5.14]# cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf`
`[root@xy php-5.5.14]# ln -s /usr/local/php/etc/php-fpm.conf /etc/php-fpm.conf`
`[root@linuxprobe php-5.5.14]# vim /usr/local/php/etc/php-fpm.conf`

    pid = run/php-fpm.pid   //25  
    user = www 				//148  
    group = www				//149  
`[root@xy php-5.5.14]# cp sapi/fpm/init.d.php-fpm /etc/rc.d/init.d/php-fpm`
`[root@xy php-5.5.14]# chmod 755 /etc/rc.d/init.d/php-fpm`
`[root@xy php-5.5.14]# chkconfig php-fpm on`
`[root@xy php-5.5.14]# vim /usr/local/php/etc/php.ini`
disable_functions = passthru,exec,system,chroot,scandir,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_alter,ini_restor e,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server,escapeshellcmd,dll,popen,disk_free_space,checkdnsrr,checkdnsrr,g etservbyname,getservbyport,disk_total_space,posix_ctermid,posix_get_last_error,posix_getcwd,posix_getegid,posix_geteuid,posix_getgid,po six_getgrgid,posix_getgrnam,posix_getgroups,posix_getlogin,posix_getpgid,posix_getpgrp,posix_getpid,posix_getppid,posix_getpwnam,posix_ getpwuid,posix_getrlimit,posix_getsid,posix_getuid,posix_isatty,posix_kill,posix_mkfifo,posix_setegid,posix_seteuid,posix_setgid,posix_ setpgid,posix_setsid,posix_setuid,posix_strerror,posix_times,posix_ttyname,posix_uname     //35行  
`[root@xy php-5.5.14]# vim /usr/local/nginx/conf/nginx.conf` 
 1   
 2 user www www;  
 3 worker_processes 1;  
 4   
 5 #error_log logs/error.log;  
 6 #error_log logs/error.log notice;  
 7 #error_log logs/error.log info;  
 8   
 9 #pid logs/nginx.pid;  
 10   
 11   
………………省略部分输出信息………………  
 40   
 41 #access_log logs/host.access.log main;  
 42   
 43 location / {  
 44 root html;  
 45 index index.html index.htm index.php;  
 46 }  
 47 
………………省略部分输出信息………………  
 62   
 63 #pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000  
 64   
 65 location ~ \.php$ {        //启用  
 66 root html;  
 67 fastcgi_pass 127.0.0.1:9000;  
 68 fastcgi_index index.php;  
 69 fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;  
 70 include fastcgi_params;  
 71 }  
 72   
………………省略部分输出信息………………  
`[root@xy php-5.5.14]# systemctl restart nginx`
`[root@xy php-5.5.14]# systemctl restart php-fpm`
`[root@xy php-5.5.14 ]# cd /usr/local/src/`
`[root@xy src]# unzip Discuz_X3.2_SC_GBK.zip`
`[root@xy src]# rm -rf /usr/local/nginx/html/{index.html,50x.html}*`
`[root@xy src]# mv upload/* /usr/local/nginx/html/`
`[root@xy src]# chown -Rf www:www /usr/local/nginx/html`
`[root@xy src]# chmod -Rf 755 /usr/local/nginx/html`