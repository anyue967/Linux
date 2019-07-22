# Jenkins
## Jenkin是什么?
> Jenkins是开源**CI&CD**软件领导者, 提供超过1000个插件来支持构建, 部署, 自动化, 满足任何项目的需要, Jenkins是一个独立的基于**Java的程序**, 可以立即运行, 包含Windows，Mac OS X和其他类Unix操作系统.
## Jenkins的特点:
> **持续集成和持续交付**作为一个可扩展的自动化服务器, Jenkins可以用作简单的CI服务器, 或者变成任何项目的连续交付中心.
> Jenkins可以通过其网页界面**轻松设置和配置**, 其中包括即时错误检查和内置帮助.
> 通过更新中心中的1000多个**插件**, Jenkins集成了持续集成和持续交付工具链中几乎所有的工具.
> Jenkins 可以通过其插件架构进行**扩展**, 从而为 Jenkins 可以做的事提供几乎无限的可能性.
> Jenkins可以轻松地在**多台机器**上分配工作，帮助更快速地**跨多个平台**推动构建，测试和部署.
## Jenkins部署:
### 选用Ubuntu进行部署
+ **建议所有操作在root下部署**
+ 关于Ubuntu设置永久DNS的方法:
  * `vim /etc/network/interfaces`	//  dns-nameserver 192.168.137.2
  * `vim /etc/systemd/resolved.conf`	// [Resolve] DNS=DNS 
+ Ubuntu的相关配置:
  * 下载git
  ```
  $ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
  libz-dev libssl-dev

  $ wget -O v2.22.0.tar.gz https://github.com/git/git/archive/v2.22.0.tar.gz

  $ tar -xzvf git-v2.22.0.tar.gz
  $ cd git-1.7.2.2
  $ make prefix=/usr/local/git all		
  $ sudo make prefix=/usr/local/git install		

  $ vim /etc/profie
  PPATH=$PATH:/usr/local/bin
  $ source /etc/profile
  $ export PATH
  ```
  * 搭建SVN
  ```
  $ apt-get install subversion
  $ mkdir /home/svn
  $ svnadmin create /home/svn/repos
  
  $ cd /home/svn/repos
  $ vim svnserve.conf
	anon-access = none
	auth-access = write
	password-db = passwd
	authz-db = authz
  
  $ vim passwd
	[users]
	test = 123456
  $ vim authz
	[repos:/]
	test = rw
  $ svnserve -d -r /home/svn
  ```
  * 安装Java
  ```
  $ mkdir /usr/local/java/jdk1.8
  $ tar -xzvf jdk-8u221-linux-x64.tar.gz
  $ mv jdk1.8.0_221/ /usr/local/java/jdk1.8
  $ vim ~/.bashrc
	JAVA_HOME=/usr/local/jdk1.8
	CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
	JAVA_JRE=$JAVA_HOME/jre
	MAVEN_HOME=/usr/local/maven3.6.1
	PATH=$PATH:$JAVA_HOME/bin:$MAVEN_HOME/bin
	export PATH=$PATH:$JAVA_HOME/bin:$MAVEN_HOME/bin
  $ source ~/.bashrc
  $ java -verison
  ```
  * 安装apache-tomcat
  ```
  $ wget http://mirror.bit.edu.cn/apache/tomcat/tomcat-8/v8.5.43/bin/apache-tomcat-8.5.43.tar.gz
  $ tar -xzvf apache-tomcat-8.5.43.tar.gz
  $ mv apache-tomcat-8.5.43 /usr/local/apache-tomcat-8
  $ chmod 755 -R /usr/local/apache-tomcat-8.5.43
  $ unzip -d jenkins jenkins.war
  $ mv jenkins /usr/local/apache-tomcat-8/webapps
  ```
  * 浏览器访问Jenkin: IP:8080/jenkins
  ```
  $ cd /usr/local/bin/apache-tomcat-8.5.43/startup.sh
  $ tail -f ../logs/catalina.out
  $ cat /root/.jenkins/secrets/initialAdminPassword
  ```
  
  
  
  
  
  
  
  
  
  