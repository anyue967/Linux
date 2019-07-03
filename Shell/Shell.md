# Shell
## 流编辑器sed
+ 地址(定址)  
  ```
  sed -r 'd' /etc/passwd  // 删除第n行
  sed -r '3d' /etc/passwd
  sed -r '1,3d' /etc/passwd
  sed -r '/root/d' /etc/passwd
  sed -r '/root/,5d' /etc/passwd
  sed -r 's/root/alice/g' /etc/passwd   // 替换

  sed -r '/^adm/,20d' /etc/passwd   // 删除到第20行 
  sed -r '/^adm/,+20d' /etc/passwd  // 再删除20行

  sed -r '1~2d' /etc/passwd // 删除奇数行
  sed -r '0-2d' /etc/passwd
  ```
+ sed命令
  - 删除命令: `d` 
  `sed -r '3{h;d}' /etc/passwd`
  - 替换命令: s
  ```  
  sed -r 's/west/north/g' datafile
  sed -r 's/^west/north/g' datafile
  sed -r 's/[0-9][0-9]$/&.5/' datafile    // & 在查找串中匹配到的内容  
  :3,5s/\(.*)\#\1/
  ```
  - 读文件命令: `r` 
  ``` 
  sed -r '/Suan/r /etc/newfile' datafile
  sed -r '/2/r /etc/host' a.txt
  sed -r '2r /etc/host' a.txt
  ```
  - 写文件命令: `w`
  ```
  sed -r '/north/w newfile' datafile
  sed -r '3,$w /new1.txt' datafile 
  ```
  - 追加命令: `a`
  ```
  sed -r '2a\11111111' /etc/hosts
  sed -r '2a111111111\
  > 2222222\
  > 333333333' /etc/host
  ```
  - 插入命令: `i`
  ```
  sed -r '2i\11111111' /etc/hosts
  sed -r '2i111111111\
  > 2222222\
  > 333333333' /etc/host
  ```
  - 修改命令: `c`
  ```
  sed -r '2c\11111111' /etc/hosts
  sed -r '2c111111111\
  > 2222222\
  > 333333333' /etc/host
  ```
  - 获取下一行命令: `n`  
  `sed -r '/easttern/{n;d}' datafile`
  - 暂存和取用: 
    + `h` --模式空间内容复制到暂存(覆盖)
    + `H` --取出模式空间内容追加到暂存+ `g` --取出暂存内容, 复制到模式(覆盖原内容) 
    + `G` --取出暂存内容, 追加到原有内容
    ```
    sed -r '1h;$G' /etc/hosts
    sed -r '1{h;d};$G' /etc/hosts
    sed -r '1h;2,$g' /etc/hosts    
    sed -r '1h;2,3H; $G' /etc/hosts
    ```
  - 暂存与模式互换: `x`  
  `sed -r '4h;5x;6G' /etc/hosts`
  - 反向选择: `!`
  `sed -r '3d' /etc/hosts`
  `sed -r '3!d' /etc/hosts`
+ sed例子:
  ```
  sed -ri '/^[\t]*#/d' file.conf // 删除配置文件#号注释行
  sed -ri '\Y^[\t]*//Yd' file.conf  // 以 / 开始
  sed -ri '/^[\t]*$/d/' file.conf
  ```  

  ```
  sed -ri '/^[\t]*#/d;/^[\t]*$/d' /etc/vsftpd/vsftpd.conf   // 删除配置文件中注释行及空行
  sed -ri '/^[\t]*#|^[\t]*$/d' /etc/vsftpd/vsftpd.con
  sed -ri '/^[\t]*($|#)/d' /etc/vsftpd/vsftpd.con
  ```

  ```
  sed -ri '$a\chroot_local_user=YES' /etc/vsftpd/vsftpd.conf    // 修改文件
  sed -ri '/^SELINUX=cSELINUX=disabled/' /etc/vsftpd/vsftpd.con
  sed -ri '/UserDNS/cUserDNS no' /etc/selinux/config
  sed -ri '/GSSAPIAuthentication/cGSSAPIAUthentication no' /etc/ssh/sshd_config
  ```

  ```
  sed -r '2,6s/^/#/' a.txt  // 添加注释
  sed -r '2,6s/(.*)#\1/' a.txt
  sed -r '2,6/.*/#&' a.txt
  sed -r '1,5s/^[ \t]*#*/#/' a.txt
 
## 行文本处理awk
> awk [option] 'commands' filenames  
> awk [option] -f awk-script-file filenames

+ option   
`awk -F ":" '{print $1,$2}' passwd    // 默认空格或制表符分隔`
+ command  
`awk 'BEGIN{print 1/2} {print "ok"} END{print "--------"}' /etc/hosts`
`awk 'BEGIN{FS=":";OFS="---"} {print $1,$2}' passwd    ==>root---x`
+ 记录与字段相关的内部变量:
  - $0: awk变量$0保存当前记录的内容
    * `awk -F ":" '{print $0}' /etc/passwd`
  - NR: total number of input record
    * `awk -F ":" '{print NR,$0}' /etc/passwd /etc/hosts`
  - FNR: current input record
    * `awk -F ":" '{print FNR,$0}' /etc/passwd /etc/hosts`
  - NF: 保存记录的字段数($NF: 最后一列): $1, $2, ..., $100
    * `awk -F ":" '{print $0,NF}' /etc/passwd`
  - FS: 输入字段分隔符, 默认空格
    * `awk -F 'BEGIN{FS=":"} {print $1,$3}' /etc/passwd`
  - OFS: 输出字段分隔符:
    * `awk -F 'BEGIN{FS=":"} /^root/{print $1,$2,$3,$4}' passwd`
  - RS: input record spearator
    * `awk -F ":" 'BEGIN{RS=" "} {print $0}' a.txt`
  - ORS: output
    * `awk -F ":" 'BEGIN{ORS=" "} {print $0}' passwd`
> 字段分隔符: FS OFS 默认空格/制表符
> 记录字段分隔符: RS ORS 默认换行符

+ 格式化输出: print printf
  ```
  date | awk '{print "Month: " $2 "\nYear: " $NF}'
  awk -F ":" '{printf "%-15s %-10s %-15s\n", $1,$2,$3}' passwd
  awk -F ":" '{printf "|%-15s| |%-10s| |%-15s|\n", $1,$2,$3}' passwd
  ```
+ awk 脚本编程:
+ if-elseif-else
  - `awk -F ":" '{if($3==0){count++} else if($3>999){k++} else{j++} END{print "管理员个数: "count; print "普通用户个数: "k; print "系统用户数: "j}}' /etc/passwd`
+ while
  - `awk -F ":" '{i=1; while(i<=NF){print $i; i++}}' /etc/hosts`
  - `awk '{i=1; while(i<NF){print $i; i++}}'`   // 分别打印每一行的每列
+ for
  - `awk -F ":" '{for(i=1;i<=NF;i++){print $0}}' passwd`
+ 数组:
  - `awk -F ":" '{usernme[x++]=$1} END{for(i in username) {print i,username[i]}}' passwd`
  - `awk -F ":" '{usernme[++x]=$1} END{for(i in username) {print i,username[i]}}' passwd`

## Nginx 日志分析:
> 114.242.26.65 - - [22/Mar/2017:08:41:08 +0800] "GET /css/20151103Style.css HTTP/1.1" 200 9041 "http://sz.cdn-my.mobiletrain.org/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) ApplwWebKit/537.36 (HTML, like Gecko) Chrome/50.02661.102 Safari/537.36"  

+ 1.统计2017年9月5日 PV量
`grep '05/Sep/2017' cd.mobiletrain.org.log | wc -l`  
`awk '$4>="[05/sep/2017:08:00:00" && "[05/sep/2017:09:00:00" {print $0}' sz.mobiletrain.log | wc -l`    

+ 2.统计2017年9月5日 一天访问最多的10个IP(top 10)  
`grep '05/Sep/2017' sz.mobiletrain.org.log | awk '{ips[$1]++} END{for(i in ips){print i,ips[i]}}' | sort -k2 -rn | head -n10`    
`awk '05\/Sep\/2017' sz.mobiletrain.org.log | awk '{ips[$1]++} END{for(i in ips){print i,ips[i]}}' | sort -k2 -rn | head -n10`

+ 3.统计2017年9月5日 访问>100次的IP
`grep '05/Sep/2017' sz.mobiletrain.org.log | awk '{ips[$1]++} END{for(i in ips){if(ips[i]>100){print i,ips[i]}}}'`  

+ 4.统计2017年9月5日 访问最多的10个页面($request top 10)  
`awk '/05\/Sep\/2017/ {urls[$7]++} END{for(i in urls){print i,urls[i]}}' sz.mobiletrain.org.log | sort -k1 -rn | head -n10`  

+ 5.统计2017年9月5日 每个url访问内容总大小($body_bytes_sent)  
`awk '/05\/Sep\/2017/ {urls[$7]++; size[$7]+=$10} END{for(i in urls){print urls[i],size[i],i}}' sz.mobiletrain.org.log | sort -k1 -rn | head -n10`  

+ 6.统计2017年9月5日 每个IP访问状态码数量($status)  
`awk '/05\/Sep/\2017/ {ip_code[$1" "$9]++} END{for(i in ip_code){print i,ip_code[i]}}' sz.mobiletrain.org | sort -k1 -rn | head -n10`  

+ 7.统计2017年9月5日 访问状态码为404及出现次数($status)
`awk '/05\/Sep\/2017/ {if($9=="404"){ip_code[$1" "$9]++} END{for(i in ip_code){print i,ip_code[i]}}}' sz.mobiletrain.org.log`

+ 8.统计前一分钟的PV量(带入外部变量)
`date=$(date -d '-1 minute' +%d/%b/%Y:%H:%M); awk -v date=$date '$0 ~ date {i++} END{print i}' sz.mobiletrain.org.log`

+ 9.统计2017年9月5日 8:30-9:00, 访问状态码是404  
`awk '$4>="[05/Sep/2017:08:30:00 && [05/Sep/2017:09:00:00" {if($9=="404"){ip_code[$1" "$9]++} for(i in ip_code){print i,ip_code[i]}}' sz.mobiletrain.org.log`

+ 10.统计2017年9月5日各种状态码数量  
`awk '/05\/09\/2017/ {code[$9]++;total++} END{for(i in code){printf i"\t"; printf code[i]"\t"; printf "%.2f",code[i]/total*100; print "%"}}' sz.mobiletrain.org.log`  





