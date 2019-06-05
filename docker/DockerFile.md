## DockerFile 语法
### 1. FROM -- 指定基础image
+ 构建指令，必须指定且需要在 DockerFile 其他指令的前面，后续指令依赖指定的 image，FROM指定的基础 image 既可以是本地 Repo 也可以是官方的远程仓
    * `FROM centos:7.2`
    * `FROM centos`
### 2. MAINTAINER --指定镜像创建者信息
+ 构建指令，用于将 image 的制作者相关信息写入到 image 中，当执行`docker inspect`，输出中有相应的字段记录该信息
    * `MAINTAINER xingyue "xingyue@163.com"`
### 3. RUN --安装软件用
+ 构建指令，RUN 可以运行任何被基础 image 支持的命令，若基础 image 为 centos，则软件管理部分只能使用 centos 的包管理命令
    * `RUN cd /tmp && curl -L 'http://archive.apache.org.dist/tomcat/tomcat-7/v7.0.8/bin/apache-tomcat-7.0.8.tar.gz' | tar -xz`
    * `RUN [ "/bin/bash", "-c", "echo helllo" ]`
### 4. CMD --设置 container 启动时执行的操作
+ 设置指令，用于 container 启动时指定的操作，该操可以是自定义的脚本，也可以是执行系统的命令，该指令只能在文件中存在一次，若有多个，只执行最后一条
    * `CMD echo "Hello，World！"`
### 5. ENTRYPOINT --设置 container 启动执行的操作
+ 设置指令，指定容器启动时执行的操作，可以多次设置，但是只有最后一个有效
    * `ENTRYPOINT ls -l`
+ 该指令独自使用，若还有CMD命令且CMD是一条完整的可执行的命令，则CMD指令和ENTRYPOINT会相互覆盖，只有最后一个CMD 或 ENTRYPOINT 有效
    * `CMD echo "Hello World"`
    * `ENTRYPOINT ls -l`
    * CMD 不会执行，ENTRYPOINT有效
+ 该指令与CMD配合使用指定 ENTRYPOINT 的默认参数，则 CMD 指令不是完整的可执行命令，仅仅是参数部分；ENTRYPOINT 指令只能使用 JSON 方式 指定执行命令，而不能指定参数
    * `FROＭ ubuntu`
    * `CMD ["-l"]`
    * `ENTRYPOINT ["/usr/bin/ls"]`
### 6. USER --设置 container 用户
+ 设置指令，设置启动容器的用户，默认 root 用户
    * `USER daemon = ENTRYPOINT ["memcached", "-u", "daemon"]`
### 7. EXPOSE --指定容器需要映射到宿主机的端口
+ 设置指令，会将容器中端口映射成宿主机中的某个端口
    * `EXPOSE 22`
    * `docker run -p port1 image`
    * -------------------------------------
    * `EXPOSE port1 port2 port3`
    * `docker run -p port1 port2 port3 image`
    * `docker run -p host_port1:port1 -p host_port2:port2 -p host_port3:port3 image`
### 8. ENV --用于设置环境变量
+ 构建指令，在 image 中设置一个环境变量，后续的 RUN 可以使用，container 启动后，通过 `docker inspect` 查看环境变量，或者 `docker run --env key=value` 时设置或修改环境变量
    * `ENV JAVA_HOME /path/to/java/dirent`
### 9. ADD --从 src 复制文件到 container 的 dest 路径
+ ADD [src] [dest]
    * [src] 是相对被构建的源目录的相对路径，可以是 文件或目录 路径，也可以是
远程的文件 url
    * [dest] 是container 中的绝对路径
### 10. COPY --从 src 复制文件到 container 的 dest 路径
+ COPY [src] [dest]
### 11. VOLUME --指定挂载点
+ 设置指令，使容器中的一个目录具有持久化存储数据的功能，该目录可以被容器本身使用，也可以共享给其他容器使用，因为容器使用的是UFS技术，这种文件系统不能持久化，当容器关闭后，所有更改都会丢失
    * `FROM base`
    * `VOLUME ["/tmp/data"]`
### 12. WORKDIR --切换目录
+ 设置指令，可以多次切换，等同于 cd，对RUN、CMD、ENTRYPOINT生效
    * `WORKDIR /p1 WORKDIR p2 RUN vim a.txt`  === `RUN cd /p1/p2 && vim a.txt`
### 13.ONBUILD --在子镜像中执行
+ 在构建镜像时并不执行，而是在它的子镜像中执行
    * `ONBUILD ADD . /app/src`
    * `ONBUILD RUN /usr/local/bin/python-build --dir /app/src`
            
            docker build -t imagename
            FROM hub.c.163.com/public/centos:6.7
            MAINTAINER xingyue@163.com
            ADD ./apache-tomcat-7.0.42.tar.gz /root
            ADD ./jdk-7u25-linux-x64.tar.gz /root
            ENV JAVA_HOME /root/jdk1.7.0_25
            ENV PATH $JAVA_HOME/bin:$PATH
            EXPOSE 8080
            ENTRYPOINT /root/apache-tomcat-7.0.42/bin/startup.sh && tailf /root/apache-tomcat-7.0.42/logs/catalina.out
            
    


































