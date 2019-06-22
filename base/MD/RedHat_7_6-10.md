## 目录	<div id="back"></div>
* [分区/格式化/挂载/卸载](#fdisk)
* [磁盘容量配额技术 uquota](#uquota)
* [RAID 磁盘阵列](#RAID)
* [LVM 逻辑卷管理](#LVM)
* [iptables 参数 规则链 动作](#iptables)
* [firewall-cmd 防火墙](#firewalld)
* [SSH 服务](#SSH)
* [scp 远程传输](#scp)
* [apache 服务](#Apache)

### 1. 一切从  / 开始
                                     根目录 /                  
        /root	/bin	/dev	/etc	/home	/lib	/usr	/media	/tmp

- /boot　　**开机所需文件——内核、开机菜单以及所需配置文件**  ✔  
- /dev　　**以文件形式存放任何设备及接口**  ✔
- /etc　　**配置文件**  ✔
- /home　　**用户家目录**  ✔
- /bin　**存放单用户模式下还可以操作的命令**   
- /lib　**开机时用到的函数库**   
- /sbin　**开机过程中用到的命令**  
- /media　 **挂载设备文件的目录**  ✔
- /opt　**第三方软件**  
- /root　**系统管理员家目录**  ✔
- /srv	　 **网络服务的数据文件目录**  
- /tmp　 **任何人均可使用的“共享”临时目录**  
- /proc　 **虚拟文件系统**  
- /usr/local　 **用户自行安装的软件**  ✔
- /usr/sbin　**开机不会使用的软件及脚本**  
- /usr/share　 **帮助与说明文件**  
- /var	　**经常变化文件,日志**  ✔
- /lost+found	　**当文件系统发生错误，存放丢失的文件片段**  

### 2. 路径   
绝对路径：从根目录(/)开始写起的文件或目录  
相对路径：相对于当前路径的写法  `./  ../  ~`

### 3. 物理设备的命名规则  
- IDE　/dev/hd[a-d]   ✔ 
- SCSI/SATA/U盘　 /dev/sd[a-p]  ✔
- 软驱　/dev/fd[0-1]  
- 打印机　/dev/lp[0-15]  
- 光驱　/dev/cdrom  ✔
- 鼠标　 /dev/mouse  
- 磁带机　 /dev/st0   /dev/ht0   
- **注:** **主分区/扩展分区编号从1开始，到4结束　逻辑分区从编号5开始**  
  
硬盘设备是由大量扇区组成的，**每个扇区的容量为512字节**。其中**第一个扇区最重要**，它里面保存了**主引导记录与分区表信息**。第一个扇区,主引导记录需要占用446字节，分区表为64字节，结束符占用2字节；分区表每记录一个**分区信息需要16字节**，这样就最多只有4个分区信息可以写到第一个扇区中，这四个分区就是4个主分区。 

为了解决分区个数不够,可以将第一个扇区分区表中16字节(原本写入主分区信息)的空间(称为扩展分区)拿出来指向另外一个分区表。**扩展分区不是一个真正的分区**,是一个占用16字节分区表空间的指针。所以,**用户一般会选择3个主分区加1个扩展分区,在扩展分区中建立数个逻辑分区**。
 
### 4. 文件系统与数据资料
- Ext3：日志文件系统  
- Ext4：Ext3改进版,RHEL6系统默认文件管理系统,支持存储容量高达1EB  
- XFS：高性能的日志文件系统,RHEL7默认文件管理系统,最大支持存储容量18EB  

### 5. 挂载硬件设备 
**注：** mount -a 会自动检查/etc/fstab文件有无疏漏的挂载设备，若有则自动进行挂载

`[root@xy ~]# mount /dev/sdb2 /backup`	　**挂载目录需要挂载前创建好，mount[设备文件 挂在目录]**  
`[root@xy ~]# vim /etc/fstab`			     　 **开机自动挂载sdb2**  
1  #  
2  # /etc/fstab  
3  # Created by anaconda on Fri Jul  6 08:44:38 2018  
4  #  
5  # Accessible filesystems, by reference, are maintained under '/dev/disk'  
6  # See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info  
7  #  
8  /dev/mapper/rhel-root                      /         xfs       defaults        1 1  
9  UUID=28d7b2f5-a322-4990-ab6c-5936d156fce7 /boot      xfs       defaults        1 2  
10 /dev/mapper                              /rhel-swap  swap swap defaults        0 0  
11 /dev/cdrom                              /media/cdrom iso9660   defaults        0 0  
12 /dev/sdb2								/backup		 ext4      defaults        0 0  

### 6. 撤销挂载设备  <div id="fdisk"></div>
`[root@xy ~]# umount /dev/sdb2`　**umount [设备文件/挂在目录]**  
### 7. 分区-格式化-挂载:  
#### fdisk    
    -m 查看全部可用参数　-n 添加新的分区　
    -d 删除某个分区信息　-q 不保存退出　  
    -l ✔列出所以可用的分区类型　-t ✔改变某个分区的信息　　　
    -p ✔查看分区信息　-w 保存并退出   
 
#### 7.1 分区： 
`[root@xy ~]# fdisk /dev/sdb`  
Welcome to fdisk (util-linux 2.23.2).  

Changes will remain in memory only, until you decide to write them.  
Be careful before using the write command.  

Device does not contain a recognized partition table  
Building a new DOS disklabel with disk identifier 0x301a431a.  

`Command (m for help): p` 		　**查看分区信息**  

Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors  
Units = sectors of 1 * 512 = 512 bytes  
Sector size (logical/physical): 512 bytes / 512 bytes  
I/O size (minimum/optimal): 512 bytes / 512 bytes  
Disk label type: dos  
Disk identifier: 0x301a431a  

   Device Boot      Start         End      Blocks   Id  System  

`Command (m for help): n` 		　**添加新的分区**  
Partition type:  
   p   primary (0 primary, 0 extended, 4 free)  
   e   extended  
`Select (default p): p` 	　**此时输入参数primary创建主分区 / extended创建扩展分区**  
`Partition number (1-4, default 1): 1`  
First sector (2048-41943039, default 2048): 	　**默认按回车即可**  
Using default value 2048  
Last sector, +sectors or +size{K,M,G} (2048-41943039, default 41943039): +2G　 **创建2GB分区**  
                                                  
Partition 1 of type Linux and of size 2 GiB is set  

`Command (m for help): p` 		　**查看分区信息**  

Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors  
Units = sectors of 1 * 512 = 512 bytes  
Sector size (logical/physical): 512 bytes / 512 bytes  
I/O size (minimum/optimal): 512 bytes / 512 bytes  
Disk label type: dos  
Disk identifier: 0x301a431a  

   Device Boot      Start         End      Blocks   Id  System  
/dev/sdb1            2048     4196351     2097152   83  Linux  
`Command (m for help): w` 			         　**保存分区信息并退出**  
The partition table has been altered!  

Calling ioctl() to re-read partition table.  
Syncing disks.  
`[root@xy ~]# file /dev/sdb`　**file 查看 /dev/sdb1 文件属性**  
/dev/sdb1: cannot open (No such file or directory)  
`[root@xy ~]# partprobe`  
`[root@xy ~]# partprobe`　**partprobe 同步分区信息到系统内核**  
`[root@xy ~]# file /dev/sdb1`  
/dev/sdb1: block special  

#### 7.2 格式化： mkfs.文件类型名称 /dev/sdb1   
`[root@xy ~]# mkfs`　**分区完后用 mkfs 格式化**  
mkfs         mkfs.cramfs  mkfs.ext3    mkfs.fat     mkfs.msdos   mkfs.xfs  
mkfs.btrfs   mkfs.ext2    mkfs.ext4    mkfs.minix   mkfs.vfat      
`[root@xy ~]# mkfs -t xfs /dev/sdb1`  
meta-data=/dev/sdb1              isize=256    agcount=4, agsize=131072 blks  
         =                       sectsz=512   attr=2, projid32bit=1  
         =                       crc=0  
data     =                       bsize=4096   blocks=524288, imaxpct=25  
         =                       sunit=0      swidth=0 blks  
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0  
log      =internal log           bsize=4096   blocks=2560, version=2  
         =                       sectsz=512   sunit=0 blks, lazy-count=1  
realtime =none                   extsz=4096   blocks=0, rtextents=0  

#### 7.3 挂载分区： 
`[root@xy ~]# mkdir /newFS`  
`[root@xy ~]# mount /dev/sdb1 /newFS/`  
`[root@xy ~]# df -h` 	　 **查看挂载状态及设备 建议 df -Th 命令信息更全**  
Filesystem             Size  Used Avail Use% Mounted on  
/dev/mapper/rhel-root   28G  3.0G   25G  11% /  
devtmpfs               985M     0  985M   0% /dev  
tmpfs                  994M  148K  994M   1% /dev/shm  
tmpfs                  994M  8.8M  986M   1% /run  
tmpfs                  994M     0  994M   0% /sys/fs/cgroup  
/dev/sr0               3.5G  3.5G     0 100% /media/cdrom  
/dev/sda1              497M  119M  379M  24% /boot  
/dev/sdb1              2.0G   33M  2.0G   2% /newFS  

`[root@xy ~]# cp -rf /etc/* /newFS`  
`[root@xy ~]# ls /newFS`  
abrt hosts pulse  
adjtime host.allow purple  
........省略部分信息........  
`[root@xy ~]# du -sh /newFS/` 　 **du -sh  查看空间占用情况**  
33M /newFS/  

### 8. 添加交换分区swap  
交换分区是把内存中暂时不用的数据临时存放到硬盘中,解决物理内存不足问题,交换分区一般为物理内存的1.5~2倍  ，mkswap 与 swapon  
#### 8.1 分区：
`[root@xy ~]# fdisk /dev/sdb` 　 **分区**  
Welcome to fdisk (util-linux 2.23.2).  

Changes will remain in memory only, until you decide to write them.  
Be careful before using the write command.  


`Command (m for help): n`
Partition type:
   p   primary (1 primary, 0 extended, 3 free)  
   e   extended  
`Select (default p): p`  
Partition number (2-4, default 2): 2  
First sector (4196352-41943039, default 4196352):   
Using default value 4196352  
Last sector, +sectors or +size{K,M,G} (4196352-41943039, default 41943039): +5G  
Partition 2 of type Linux and of size 5 GiB is set  

`Command (m for help): p`  

Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors  
Units = sectors of 1 * 512 = 512 bytes  
Sector size (logical/physical): 512 bytes / 512 bytes  
I/O size (minimum/optimal): 512 bytes / 512 bytes  
Disk label type: dos  
Disk identifier: 0x301a431a  

   Device Boot      Start         End      Blocks   Id  System  
/dev/sdb1            2048     4196351     2097152   83  Linux  
/dev/sdb2         4196352    14682111     5242880   83  Linux  

`Command (m for help): w`  
The partition table has been altered!  

Calling ioctl() to re-read partition table.  

WARNING: Re-reading the partition table failed with error 16: Device or resource busy.  
The kernel still uses the old table. The new table will be used at  
the next reboot or after you run partprobe(8) or kpartx(8)  
Syncing disks.  
#### 8.2 格式化： 
`[root@xy ~]# mkswap /dev/sdb2`  　**格式化 mkswap**  
/dev/sdb2: No such file or directory  
`[root@xy ~]# partprobe`  
`[root@xy ~]# partprobe`  
`[root@xy ~]# mkswap /dev/sdb2`  
Setting up swapspace version 1, size = 5242876 KiB  
no label, UUID=ffe8494a-c2f5-4af4-becf-985b130d395c  
`[root@xy ~]# free -m`  
             total       used       free     shared    buffers     cached  
Mem:          1987       1137        850          9          1        279  
-/+ buffers/cache:        856       1131  
Swap:            0          0          0  
#### 8.3 挂载分区： 
`[root@xy ~]# swapon /dev/sdb2`    　**挂载使用**  
`[root@xy ~]# free -m`  
             total       used       free     shared    buffers     cached  
Mem:          1987       1141        846          9          1        279  
-/+ buffers/cache:        860       1127  
Swap:         5119          0       5119  
`[root@xy ~]# vim /etc/fstab` 　**设置自动挂载**      
1  #  
2  # /etc/fstab  
3  # Created by anaconda on Fri Jul  6 08:44:38 2018  
4  #  
5  # Accessible filesystems, by reference, are maintained under '/dev/disk'  
6  # See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info  
7  #  
/dev/mapper/rhel-root                  /         xfs       defaults        1 1    
UUID=28d7b2f5-a322-4990-ab6c-5936d156fce7 /boot  xfs       defaults        1 2    
/dev/mapper                          /rhel-swap  swap swap defaults        0 0  
/dev/cdrom                          /media/cdrom iso9660   defaults        0 0    
/dev/sdb1                          /newFS        xfs       defaults        0 0    
/dev/sdb2                          swap          swap      defaults        0 0    

### 9. 删除手动增加的交换分区swap    
`[root@xy ~]# /sbin/swapoff /dev/sdb2`  
`[root@xy ~]# vim /etc/fstab`   
/dev/sdb2    swap     swap     defaults       0 0 　**删除**  
`[root@xy ~]# swapon -s`  
Filename        Type    Size  Used  Priority  
/dev/dm-0                               partition 2113532 0 -1  

### 10. 磁盘容量配额技术  <div id="uquota"></div>
    UUID=28d7b2f5-a322-4990-ab6c-5936d156fce7 /boot    xfs    defaults,uquota 1 2 　
**配置/etc/fstab,使/boot目录支持uquota,磁盘容量配额技术** 
 
`[root@xy ~]# reboot`  
`[root@xy ~]# mount | grep boot`  
/dev/sda1 on /boot type xfs (rw,relatime,seclablel,attr2,inode64,usrquota)  
`[root@xy ~]# useradd tom`    
`[root@xy ~]# chmod -Rf o+w /boot` 　**other write**  
`[root@xy ~]# xfs_quota -x -c 'limit bsoft=3m bhard=6m isoft=3 ihard=6 tom' /boot`  
`[root@xy ~]# xfs_quota -x -c report /boot`　**xfs_quota -x -c**  
User quota on /boot (/dev/sda1)	  Blocks  
User ID Used Soft Hard Warn/Grace  
`----------- ----------------------------------------------`  
root 95084   0     0    00 [--------]  
tom  0       3072  6144 00 [--------]  
`[root@xy ~]# su - tom`  
`[tom@xy ~]$ dd if=/dev/zero of=/boot/tom bs=5M count=1`  
1+0 records in  
1+0 records out  
5242880 bytes (5.2 MB) copied, 0.123996 s, 42.3 MB/s  
`[tom@xy ~]$ dd if=/dev/zero of=/boot/tom bs=8M count=1`
dd: error writing '/boot/tom': Disk quato exceeded 　 **限制**  
1+0 records in  
1+0 records out  
6291456 bytes (6.3 MB) copied, 0.0201596s, 312MB/s  

`[root@xy ~]# edquota -u tom` 　 **edquota -u 按需修改配额**    
Disk quotas for user tom (uid 1001):  
 Filesystem blocks   soft   hard   inodes   soft   hard  
 /dev/sda   6114     3072   8192   1        3      6  
`[root@xy ~]# su - tom`  
`[tom@xy ~]$ dd if=/dev/zero of=/boot/tom bs=8M count=1`  
1+0 records in  
1+0 records out  
8388608 bytes (8.4 MB) copied, 0.0238044s, 313MB/s  

`[tom@xy ~]$ dd if=/dev/zero of=/boot/tom bs=10M count=1`  
dd: error writing '/boot/tom': Disk quato exceeded  
1+0 records in  
1+0 records out  
8388608 bytes (8.4 MB) copied, 0.0238044s, 313MB/s  

### 11. 创建链接文件ln  
    -s **创建符号链接(不带-s,默认创建硬链接)**✔　  
    -f **强制创建文件/目录的链接** 　✔
    -i **覆盖前先询问** 　 
    -v **显示创建链接的过程**  

### 12. RAID与LVM磁盘阵列技术  <div id="RAID"></div>
    RAID(Redundant Array of Independent Disks,独立冗余磁盘阵列)

    RAID 0:把多块物理硬件设备(至少2块)通过硬件或软件凡事串联在一起,组成一个大的卷组,
    提升了硬盘数据的吞吐量,但不具备数据备份和错误修复能力  
![RAID 0](../img/RAID0.png)

    RAID 1:数据写到多块硬盘设备上,当某一块硬盘发生故障后,一般会立即以热交换方式来恢复数据的正常使用,
    但硬盘的使用率却下降了,只有33%左右 ✔   
![RAID 1](../img/raid1.jpg)  

    RAID 5:将硬盘设备的数据奇偶校验信息保存到除自身外每一块硬盘设备上,当硬盘出现问题,
    通过奇偶校验信息来尝试重建损坏的数据  ✔
![RAID 5](../img/raid5.gif)  
 
    RAID 10：RAID10=RAID 1 + RAID 0
![RAID 10](../img/raid-10-1024x508.png)     
    
#### 12.1 部署磁盘阵列RAID 10:  
    mdadm [模式] <RAID设备名称> [选项][成员设备名称]　
    -a 检测设备名称　  -n 指定设备数量 ✔　 
    -l 指定RAID级别　-C 创建 ✔
    -v 显示过程　    -f 模拟设备损坏　
    -r 移除设备 　   -Q 查看摘要信息　
    -D 查看详细信息 ✔　  -S 停止RAID磁盘阵列  　
 
##### 1) 创建 RAID 10:
`[root@xy ~]# mdadm -Cv /dev/md0 -a yes -n 4 -l 10 /dev/sdc /dev/sdd /dev/sde /dev/sdf`                **名字**                      
mdadm: layout defaults to n2  
mdadm: layout defaults to n2  
mdadm: chunk size defaults to 512K  
mdadm: size set to 20954624K  
mdadm: Defaulting to version 1.2 metadata  
mdadm: array /dev/md0 started. 
 
##### 2) 格式化 RAID 10:
`[root@xy ~]# mkfs.ext4 /dev/md0`　**格式化 ext4**  
mke2fs 1.42.9 (28-Dec-2013)  
Filesystem label=  
OS type: Linux  
Block size=4096 (log=2)  
Fragment size=4096 (log=2)  
Stride=128 blocks, Stripe width=256 blocks  
2621440 inodes, 10477312 blocks  
523865 blocks (5.00%) reserved for the super user  
First data block=0  
Maximum filesystem blocks=2157969408  
320 block groups  
32768 blocks per group, 32768 fragments per group  
8192 inodes per group  
Superblock backups stored on blocks:   
  32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,  
  4096000, 7962624  

Allocating group tables: done                              
Writing inode tables: done                              
Creating journal (32768 blocks): done  
Writing superblocks and filesystem accounting information: done   
##### 3) 挂载 RAID 10:
`[root@xy ~]# mkdir /RAID` 　**挂载 /dev/md0**  
`[root@xy ~]# mount /dev/md0 /RAID/`  
`[root@xy ~]# df -h`  
Filesystem             Size  Used Avail Use% Mounted on  
/dev/mapper/rhel-root   28G  3.0G   25G  11% /  
devtmpfs               985M     0  985M   0% /dev  
tmpfs                  994M  148K  994M   1% /dev/shm  
tmpfs                  994M  8.8M  986M   1% /run  
tmpfs                  994M     0  994M   0% /sys/fs/cgroup  
/dev/sdb1              2.0G   33M  2.0G   2% /newFS  
/dev/sr0               3.5G  3.5G     0 100% /media/cdrom  
/dev/sda1              497M  119M  379M  24% /boot  
/dev/md0                40G   49M   38G   1% /RAID  

##### 4) 查看 RAID 10 信息:  
`[root@xy ~]# mdadm -D /dev/md0` 　**查看 /dev/md0 磁盘阵列详细信息**  
/dev/md0:  
        Version : 1.2  
  Creation Time : Mon Jul  9 20:07:08 2018  
     Raid Level : raid10  
     Array Size : 41909248 (39.97 GiB 42.92 GB)  
  Used Dev Size : 20954624 (19.98 GiB 21.46 GB)  
   Raid Devices : 4  
  Total Devices : 4  
    Persistence : Superblock is persistent  

    Update Time : Mon Jul  9 20:10:35 2018  
          State : active, resyncing   
 Active Devices : 4  
Working Devices : 4  
 Failed Devices : 0  
  Spare Devices : 0  

         Layout : near=2  
     Chunk Size : 512K  

  Resync Status : 96% complete  

           Name : xy.com:0  (local to host xy.com)  
           UUID : 111c244f:e080b0c1:3316b6f2:986fa663  
         Events : 16  

    Number   Major   Minor   RaidDevice State  
       0       8       32        0      active sync   /dev/sdc  
       1       8       48        1      active sync   /dev/sdd  
       2       8       64        2      active sync   /dev/sde  
       3       8       80        3      active sync   /dev/sdf  

#### 12.2 模拟损坏磁盘阵列及修复：    
`[root@xy ~]# mdadm /dev/md0 -f /dev/sdc`　**-f 模拟设备损坏**  
mdadm: set /dev/sdc faulty in /dev/md0   
`[root@xy ~]# mdadm -D /dev/md0`   
/dev/md0:  
        Version : 1.2  
  Creation Time : Mon Jul  9 20:07:08 2018  
     Raid Level : raid10  
     Array Size : 41909248 (39.97 GiB 42.92 GB)  
  Used Dev Size : 20954624 (19.98 GiB 21.46 GB)  
   Raid Devices : 4  
  Total Devices : 4  
    Persistence : Superblock is persistent  

    Update Time : Mon Jul  9 20:23:34 2018  
          State : clean, degraded   
 Active Devices : 3  
Working Devices : 3  
 Failed Devices : 1  
  Spare Devices : 0  

         Layout : near=2  
     Chunk Size : 512K  

           Name : xy.com:0  (local to host xy.com)  
           UUID : 111c244f:e080b0c1:3316b6f2:986fa663  
         Events : 21  

    Number   Major   Minor   RaidDevice State 
       0       0        0        0      removed  
       1       8       48        1      active sync   /dev/sdd  
       2       8       64        2      active sync   /dev/sde  
       3       8       80        3      active sync   /dev/sdf  

       0       8       32        -      faulty   /dev/sdc  
`[root@xy ~]# reboot`  
`[root@xy ~]# umount /dev/RAID`  
`[root@xy ~]# mdadm /dev/md0 -a /dev/sdc`
mdadm: added /dev/sdc  
`[root@xy ~]# mdadm -D /dev/md0`  
/dev/md0:  
        Version : 1.2  
  Creation Time : Mon Jul  9 20:07:08 2018  
     Raid Level : raid10  
     Array Size : 41909248 (39.97 GiB 42.92 GB)  
  Used Dev Size : 20954624 (19.98 GiB 21.46 GB)  
   Raid Devices : 4  
  Total Devices : 4  
    Persistence : Superblock is persistent  

    Update Time : Mon Jul  9 21:04:28 2018 
          State : clean, degraded, recovering   
 Active Devices : 3  
Working Devices : 4  
 Failed Devices : 0  
  Spare Devices : 1  

         Layout : near=2  
     Chunk Size : 512K  

 Rebuild Status : 19% complete  
 
           Name : xy.com:0  (local to host xy.com)  
           UUID : 111c244f:e080b0c1:3316b6f2:986fa663  
         Events : 32 

    Number   Major   Minor   RaidDevice State  
       4       8       32        0      spare rebuilding   /dev/sdc  
       1       8       48        1      active sync   /dev/sdd  
       2       8       64        2      active sync   /dev/sde  
       3       8       80        3      active sync   /dev/sdf  

### 12.3 部署磁盘阵列RAID 5 
 
#### 1)创建RAID 5：
`[root@xy ~]# mdadm -Cv /dev/md0 -n 3 -l 5 -x 1 /dev/sdc /dev/sdd /dev/sde /dev/sdf`  
mdadm: layout defaults to left-symmetric  
mdadm: layout defaults to left-symmetric  
mdadm: chunk size defaults to 512K  
mdadm: Defaulting to version 1.2 metadata  
mdadm: array /dev/md0 started.  

#### 2)查看RAID 5：
`[root@xy ~]# mdadm -D /dev/md0`  
/dev/md0:  
Version : 1.2  
Creation Time : Fri May 8 09:20:35 2018  
Raid Level : raid5  
Array Size : 41909248 (39.97 GiB 42.92 GB)  
Used Dev Size : 20954624 (19.98 GiB 21.46 GB)  
Raid Devices : 3   
Total Devices : 4  
Persistence : Superblock is Persistence  
Update Time : Fri May 8 09:22:22 2018  
State : clean  
Active Devices : 3  
Working Devices : 4  
Failed Devices : 0  
Spare Devices : 1  
Layout : left-symmetric  
Chunk Size : 512K   
Name : xy.com:0 (local to host xy.com)  
UUID : 111c244f:e080b0c1:3316b6f2:986fa663  
Events : 18  
Number Major Minor RaidDevice State  
     0   8    16       0      active sync /dev/sdc  
     1   8    32       1      active sync /dev/sdd  
     4   8    48       2      active sync /dev/sde  
     3   8    64       -      spare       /dev/sdf 

#### 3)格式化RAID 5： 
`[root@xy ~]# mkfs.ext4 /dev/md0`  
mke2fs 1.42.9 (28-Dec-2013)  
Filesystem label=  
OS type: Linux  
Block size=4096 (log=2)  
Fragment size=4096 (log=2)  
Stride=128 blocks, Stripe width=256 blocks  
2621440 inodes, 10477312 blocks  
523865 blocks (5.00%) reserved for the super user  
First data block=0  
Maximum filesystem blocks=2157969408  
320 block groups  
32768 blocks per group, 32768 fragments per group  
8192 inodes per group  
Superblock backups stored on blocks:   
  32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,   
  4096000, 7962624  

Allocating group tables: done                              
Writing inode tables: done                              
Creating journal (32768 blocks): done  
Writing superblocks and filesystem accounting information: done 
 
#### 4)挂载 RAID 5
`[root@xy ~]# echo "/dev/md0 /RAID ext4 defaults 0 0" >> /etc/fstab`   
`[root@xy ~]# mkdir /RAID`  
`[root@xy ~]# mount -a`  

`[root@xy ~]# mdadm /dev/md0 -f /dev/sdc`  
mdadm: set /dev/sdc faulty in /dev/md0  
[root@xy ~]# mdadm -D /dev/md0  
/dev/md0:  
Version : 1.2  
Creation Time : Fri May 8 09:20:35 2018  
Raid Level : raid5  
Array Size : 41909248 (39.97 GiB 42.92 GB)  
Used Dev Size : 20954624 (19.98 GiB 21.46 GB)  
Raid Devices : 3  
Total Devices : 4  
Persistence : Superblock is Persistence  
Update Time : Fri May 8 09:23:51 2018  
State : active, degraded, resering  
Active Devices : 2  
Working Devices :3  
Failed Devices : 1  
Spare Devices : 1  
Layout : left-symmetric  
Chunk Size : 512K  
Rebuild Status : 0% complete  
Name : xy.com:0 (local to host xy.com)  
UUID : 111c244f:e080b0c1:3316b6f2:986fa663  
Events : 21  
Number Major Minor RaidDevice Status  
     3   8    64       0      spare rebuilding /dev/sdf  
     1   8    32       1      active sync      /dev/sdd  
     4   8    48       2      active sync      /dev/sde   
     0   8    16       -      faulty           /dev/sdc  

### 13. LVM (Logical Volume Manager，逻辑卷管理器)  <div id="LVM"></div>
在硬盘分区和文件系统之间添加了一个逻辑层,提供了一个抽象的卷组，可以把多块硬盘进行卷合并实现对硬盘分区的**动态调整**    

+   物理卷(PV) 就是真正的**物理硬盘或者分区**；  
+   卷组(VG)  将多个物理卷合起来组成卷组，组成同一个卷组的物理卷可以是同一个硬盘的不同分区，也可以是不同硬盘的不同分区，**抽象为一个逻辑硬盘**；  
+   逻辑卷(LV) 卷组是一个逻辑硬盘，硬盘分区后才可以使用，类似的，从卷组出来的分区为逻辑卷，**可以抽象为分区**；

![LVM图示](../img/逻辑卷.png)

#### 13.1 常用LVM部署命令  
- 功能　PV(物理卷管理)　VG(卷组管理)　LV(逻辑卷管理)  
- 扫描　pvscan　vgscan　lvscan   
- 建立　pvcreate　vgcreate　lvcreate  
- 显示　pvdisplay　vgdisplay　lvdisplay  
- 删除　pvremove　vgremove　lvremove  
- 扩展　vgextend　lvextend  
- 缩小　vgreduce　lvreduce  

#### 13.2 创建LVM: PV -> VG -> LV -> mkfs.ext4 /dev/storage/vo -> monut
##### 1) pvcrate 创建物理卷：
`[root@xy ~]# pvcreate /dev/sdc /dev/sdd`　**pvcreate 添加两块硬盘支持LVM技术**  
  Physical volume "/dev/sdc" successfully created  
  Physical volume "/dev/sdd" successfully created  
##### 2) vgcrate 创建卷组管理：
`[root@xy ~]# vgcreate storage /dev/sdc /dev/sdd`　**添加到storage卷组中**  
  Volume group "storage" successfully created  
##### 3) vgdisplay 显示卷组管理：
`[root@xy ~]# vgdisplay`　**vgdisplay**  
  --- Volume group ---  
  VG Name               rhel  
  System ID               
  Format                lvm2  
  Metadata Areas        1  
  Metadata Sequence No  3  
  VG Access             read/write  
  VG Status             resizable  
  MAX LV                0  
  Cur LV                2  
  Open LV               1  
  Max PV                0  
  Cur PV                1  
  Act PV                1  
  VG Size               29.51 GiB  
  PE Size               4.00 MiB  
  Total PE              7554  
  Alloc PE / Size       7554 / 29.51 GiB  
  Free  PE / Size       0 / 0     
  VG UUID               EZSSpY-Smrr-VLOy-zFs7-Yegf-eW4M-g90qT5  
   
  --- Volume group ---  
  VG Name               storage  
  System ID               
  Format                lvm2  
  Metadata Areas        2  
  Metadata Sequence No  1  
  VG Access             read/write  
  VG Status             resizable  
  MAX LV                0  
  Cur LV                0  
  Open LV               0  
  Max PV                0  
  Cur PV                2  
  Act PV                2  
  VG Size               39.99 GiB  
  PE Size               4.00 MiB  
  Total PE              10238  
  Alloc PE / Size       0 / 0    
  Free  PE / Size       10238 / 39.99 GiB  
  VG UUID               pjR9cJ-VoyM-TZsz-NdMb-s05a-0VQZ-wHhEBo 
##### 4) lvcrate 创建逻辑卷：   
`[root@xy ~]# lvcreate -n vo -l 37 storage`　**从卷组里边 创建逻辑卷 lvcreate**    

    -L **以容量为单位**　-l **以基本单元4MB为单位**  
##### 5) lvdisplay 显示逻辑卷：
  Logical volume "vo" created  
`[root@xy ~]# lvdisplay`　**显示 lvdisplay**               
  --- Logical volume ---  
  LV Path                /dev/rhel/swap  
  LV Name                swap  
  VG Name                rhel  
  LV UUID                9kkihZ-qQhh-96il-YlfZ-FNUX-IKTq-2tbAwv  
  LV Write Access        read/write  
  LV Creation host, time localhost, 2018-07-06 16:44:30 +0800  
  LV Status              available  
  `# open                 0`  
  LV Size                2.02 GiB  
  Current LE             516  
  Segments               1  
  Allocation             inherit  
  Read ahead sectors     auto  
  - currently set to     256  
  Block device           253:1  
   
  --- Logical volume ---  
  LV Path                /dev/rhel/root  
  LV Name                root  
  VG Name                rhel  
  LV UUID                3VpHjH-UG42-wA0y-Vn2L-Y5gm-4BpO-iKeKIg  
  LV Write Access        read/write
  LV Creation host, time localhost, 2018-07-06 16:44:32 +0800   
  LV Status              available  
  `# open                 1`  
  LV Size                27.49 GiB  
  Current LE             7038  
  Segments               1  
  Allocation             inherit  
  Read ahead sectors     auto  
  - currently set to     256  
  Block device           253:0  
   
  --- Logical volume ---  
  LV Path                /dev/storage/vo  
  LV Name                vo  
  VG Name                storage  
  LV UUID                bDRxSW-f9X3-KkjE-UPJL-wsrj-2zXm-pCNpcq  
  LV Write Access        read/write  
  LV Creation host, time xy.com, 2018-07-10 10:03:43 +0800  
  LV Status              available  
  `# open                 0`  
  LV Size                148.00 MiB  
  Current LE             37  
  Segments               1  
  Allocation             inherit  
  Read ahead sectors     auto  
  - currently set to     8192  
  Block device           253:2  
##### 6) 格式化逻辑卷：
`[root@xy ~]# mkfs.ext4 /dev/storage/vo`　**格式化**  
mke2fs 1.42.9 (28-Dec-2013)  
Filesystem label=  
OS type: Linux  
Block size=1024 (log=0)  
Fragment size=1024 (log=0)  
Stride=0 blocks, Stripe width=0 blocks  
38000 inodes, 151552 blocks  
7577 blocks (5.00%) reserved for the super user  
First data block=1  
Maximum filesystem blocks=33816576  
19 block groups  
8192 blocks per group, 8192 fragments per group   
2000 inodes per group  
Superblock backups stored on blocks:   
  8193, 24577, 40961, 57345, 73729  

Allocating group tables: done                              
Writing inode tables: done                              
Creating journal (4096 blocks): done  
Writing superblocks and filesystem accounting information: done  
##### 7) 挂载使用逻辑卷：
`[root@xy ~]# mkdir /LVM`  
`[root@xy ~]# mount /dev/storage/vo /LVM/`　**挂载使用**  
`[root@xy ~]# vim /etc/fstab`  
/dev/storage/vo              /LVM         ext4          defaults   0 0   

### 14. 扩容逻辑卷: umount -> lvextend -> e2fsck -> mount
`[root@xy ~]# umount /LVM`  
`[root@xy ~]# lvextend -L 290M /dev/storage/vo`　**lvextend:扩容逻辑卷**  
  Rounding size to boundary between physical extents: 292.00 MiB  
  Extending logical volume vo to 292.00 MiB  
  Logical volume vo successfully resized  
`[root@xy ~]# e2fsck -f /dev/storage/vo`　**e2fsck:检查硬盘完整性**  
e2fsck 1.42.9 (28-Dec-2013)  
Pass 1: Checking inodes, blocks, and sizes  
Pass 2: Checking directory structure  
Pass 3: Checking directory connectivity  
Pass 4: Checking reference counts  
Pass 5: Checking group summary information  
/dev/storage/vo: 11/38000 files (0.0% non-contiguous), 10453/151552 blocks  
`[root@xy ~]# resize2fs /dev/storage/vo`          **resize2fs:重置硬盘容量**  
resize2fs 1.42.9 (28-Dec-2013)  
Resizing the filesystem on /dev/storage/vo to 299008 (1k) blocks.  
The filesystem on /dev/storage/vo is now 299008 blocks long.  
`[root@xy ~]# mount -a`  
`[root@xy ~]# df -h`  
Filesystem              Size  Used Avail Use% Mounted on  
/dev/mapper/rhel-root    28G  3.0G   25G  11% /  
devtmpfs                985M     0  985M   0% /dev  
tmpfs                   994M  148K  994M   1% /dev/shm  
tmpfs                   994M  8.8M  986M   1% /run
tmpfs                   994M     0  994M   0% /sys/fs/cgroup  
/dev/sr0                3.5G  3.5G     0 100% /media/cdrom  
/dev/sdb1               2.0G   33M  2.0G   2% /newFS  
/dev/sda1               497M  119M  379M  24% /boot  
/dev/mapper/storage-vo  279M  2.1M  259M   1% /LVM  

### 15. 缩小逻辑卷: umount -> e2fsck -> resize2fs -> mount  
`[root@xy ~]# umount /LVM`  
`[root@xy ~]# e2fsck -f /dev/storage/vo`
e2fsck 1.42.9 (28-Dec-2013)  
Pass 1: Checking inodes, blocks, and sizes  
Pass 2: Checking directory structure  
Pass 3: Checking directory connectivity  
Pass 4: Checking reference counts    
Pass 5: Checking group summary information  
/dev/storage/vo: 11/74000 files (0.0% non-contiguous), 15507/299008 blocks  
[root@xy ~]# resize2fs /dev/storage/vo 120M  
resize2fs 1.42.9 (28-Dec-2013)  
Resizing the filesystem on /dev/storage/vo to 122880 (1k) blocks.  
The filesystem on /dev/storage/vo is now 122880 blocks long.  

`[root@xy ~]# lvreduce -L 120M /dev/storage/vo`  
  WARNING: Reducing active logical volume to 120.00 MiB  
  THIS MAY DESTROY YOUR DATA (filesystem etc.)  
Do you really want to reduce vo? [y/n]: y  
  Reducing logical volume vo to 120.00 MiB  
  Logical volume vo successfully resized  
`[root@xy ~]# mount -a`  
`[root@xy ~]# df -h`  
Filesystem              Size  Used Avail Use% Mounted on  
/dev/mapper/rhel-root    28G  3.0G   25G  11% /  
devtmpfs                985M     0  985M   0% /dev  
tmpfs                   994M  148K  994M   1% /dev/shm  
tmpfs                   994M  8.8M  986M   1% /run  
tmpfs                   994M     0  994M   0% /sys/fs/cgroup  
/dev/sr0                3.5G  3.5G     0 100% /media/cdrom  
/dev/sdb1               2.0G   33M  2.0G   2% /newFS  
/dev/sda1               497M  119M  379M  24% /boot  
/dev/mapper/storage-vo  113M  1.6M  103M   2% /LVM  

### 16. 逻辑卷快照:类似于虚拟机快照,特点:快照卷容量必须等同于逻辑卷容量;快照卷是一次性的,执行后会立即自动删除   
`[root@xy ~]# vgdisplay`         
  --- Volume group ---  
  VG Name               storage  
  System ID             
  Format                lvm2  
  Metadata Areas        2  
  Metadata Sequence No  2  
  VG Access             read/write  
  VG Status             resizable  
  MAX LV                0  
  Cur LV                1  
  Open LV               1  
  Max PV                0  
  Cur PV                2
  Act PV                2
  VG Size               39.99 GiB  
  PE Size               4.00 MiB  
  Total PE              10238  
  Alloc PE / Size       37 / 148.00 MiB　**创建快照大小依据**  
  Free  PE / Size       10201 / 39.85 GiB  
  VG UUID               6YZPns-qgdy-yEFx-hEZ3-bLwe-2eDd-PFEip8  
   
  --- Volume group ---  
  VG Name               rhel  
  System ID               
  Format                lvm2  
  Metadata Areas        1  
  Metadata Sequence No  3  
  VG Access             read/write  
  VG Status             resizable  
  MAX LV                0  
  Cur LV                2  
  Open LV               2  
  Max PV                0  
  Cur PV                1  
  Act PV                1  
  VG Size               29.51 GiB  
  PE Size               4.00 MiB  
  Total PE              7554  
  Alloc PE / Size       7554 / 29.51 GiB  
  Free  PE / Size       0 / 0     
  VG UUID               EZSSpY-Smrr-VLOy-zFs7-Yegf-eW4M-g90qT5  
`[root@xy ~]# echo "Welcome to linux" > /LVM/readme.txt`    
`[root@xy ~]# ls -l /LVM/`
total 14  
drwx------. 2 root root 12288 Jul 10 13:52 lost+found  
-rw-r--r--. 1 root root    17 Jul 10 13:58 readme.txt  
`[root@xy ~]# lvcreate -L 148M -s -n SNAP /dev/storage/vo` 　**-s创建快照卷**  
  Logical volume "SNAP" created  
`[root@xy ~]# lvdisplay`   
  --- Logical volume ---  
  LV Path                /dev/storage/vo  
  LV Name                vo  
  VG Name                storage  
  LV UUID                t6dIBg-QqoI-xKM3-zMWB-DaBX-yOF6-jiZyFf  
  LV Write Access        read/write  
  LV Creation host, time xy.com, 2018-07-10 13:52:15 +0800  
  LV snapshot status     source of  
                         SNAP [active]  
  LV Status              available  
  `# open                 1`  
  LV Size                148.00 MiB  
  Current LE             37  
  Segments               1  
  Allocation             inherit  
  Read ahead sectors     auto  
  - currently set to     8192  
  Block device           253:2  
   
  --- Logical volume ---  
  LV Path                /dev/storage/SNAP 
  LV Name                SNAP  
  VG Name                storage  
  LV UUID                dERsif-hvjx-20JJ-1BLn-dPxb-aYtw-n1zetn  
  LV Write Access        read/write  
  LV Creation host, time xy.com, 2018-07-10 14:00:46 +0800  
  LV snapshot status     active destination for vo  
  LV Status              available  
  `# open                 0`  
  LV Size                148.00 MiB  
  Current LE             37  
  COW-table size         148.00 MiB  
  COW-table LE           37  
  Allocated to snapshot  0.01%  
  Snapshot chunk size    4.00 KiB  
  Segments               1  
  Allocation             inherit  
  Read ahead sectors     auto  
  - currently set to     8192  
  Block device           253:3  

`[root@xy ~]# dd if=/dev/zero of=/LVM/files count=1 bs=100M`  
  1+0 records in  
  1+0 records out  
  104857600 bytes (105 MB) copied, 4.32264 s, 24.3 MB/s  
`[root@xy ~]# lvdisplay`  
  --- Logical volume ---  
  LV Path                /dev/storage/vo  
  LV Name                vo  
  VG Name                storage
  LV UUID                t6dIBg-QqoI-xKM3-zMWB-DaBX-yOF6-jiZyFf  
  LV Write Access        read/write  
  LV Creation host, time xy.com, 2018-07-10 13:52:15 +0800  
  LV snapshot status     source of  
                         SNAP [active]  
  LV Status              available  
  `# open                 1`  
  LV Size                148.00 MiB  
  Current LE             37  
  Segments               1  
  Allocation             inherit  
  Read ahead sectors     auto  
  - currently set to     8192  
  Block device           253:2  
   
  --- Logical volume ---  
  LV Path                /dev/storage/SNAP  
  LV Name                SNAP  
  VG Name                storage  
  LV UUID                dERsif-hvjx-20JJ-1BLn-dPxb-aYtw-n1zetn  
  LV Write Access        read/write  
  LV Creation host, time xy.com, 2018-07-10 14:00:46 +0800  
  LV snapshot status     active destination for vo  
  LV Status              available  
  `# open                 0`  
  LV Size                148.00 MiB  
  Current LE             37  
  COW-table size         148.00 MiB  
  COW-table LE           37  
  Allocated to snapshot  46.22%  
  Snapshot chunk size    4.00 KiB  
  Segments               1  
  Allocation             inherit  
  Read ahead sectors     auto  
  - currently set to     8192  
  Block device           253:3  
`[root@xy ~]# umount /LVM`  
`[root@xy ~]# lvconvert --merge /dev/storage/SNAP` 　**快照还原**  
  Merging of volume SNAP started.  
  vo: Merged: 33.5%  
  vo: Merged: 100.0%  
  Merge of snapshot into logical volume vo has finished.  
  Logical volume "SNAP" successfully removed  
`[root@xy ~]# mount /dev/storage/vo /LVM/`    
`[root@xy ~]#`   
`[root@xy ~]# ls /LVM/`  
lost+found  readme.txt  

### 16. 删除逻辑卷: LV -> VG -> PV
`[root@xy ~]# umount /LVM/`  
`[root@xy ~]# lvremove /dev/storage/vo`　**lvremove**  
Do you really want to remove active logical volume vo? [y/n]: y  
  Logical volume "vo" successfully removed  
`[root@xy ~]# vgremove storage`　**vgremove**  
  Volume group "storage" successfully removed  
`[root@xy ~]# pvremove /dev/sdc /dev/sdd` 　**pvremove**  
  Labels on physical volume "/dev/sdc" successfully wiped  
  Labels on physical volume "/dev/sdd" successfully wiped  

### 17. iptables 与 firewalld 防火墙(四表五链)  
#### 17.1 iptables命令  参数 + 策略规则链 + 动作 ：  
> **iptables  [-t 表名]  选项 [链名]    [条件]    [-j 控制类型]**    
> `表名   参数   链名   条件   动作`
> **默认filter表**   
> **默认表内所有链**  
> **选项、链名、控制类型使用大写字母，其余均为小写**

     -P　　设置默认策略   ✔  
     -F 　　清空规则链  ✔  
     -L　　查看规则链  ✔  
     -A　　在规则链的 末尾 添加新规则   ✔  
     -I num　　在规则链的 头部 添加新规则    ✔
     -D num　　删除某一条规则  ✔
     -s　　匹配来源地址IP/MASK,加!表示除这个IP外  
     -d　　匹配目标地址  
     -i 网卡名称　　匹配从这块网卡流入的数据  
     -o 网卡名称　　匹配从这块网卡流出的数据  
     -p　　匹配协议,如:TCP/UDP/ICMP  
     --dport num　　匹配目标端口号  
     --sport num　　匹配来源端口号  
     -v         数据报文 字节数显示
     -n        以数字形式显示地址、端口
     --line-numbers         查看规则，显示序号   
     -m multiport --sport    源端口列表  
     -m multiport --dport    目的端口列表  
     -m iprange --src-range  IP范围
     -m mac --macl-source   MAC地址
     -m state --state 连接状态  
     -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
#### 17.2 策略规则链[iptables]服务把用于处理或过滤流量的策略条目称为规则,多条规则可组成一个规则链,而规则链则依据数据包处理位置的不同进行分类,具体如下：<div id="iptables"></div>
    raw表：确定是否对该数据包进行状态跟踪
    mangle表：为数据包设置标记
    nat表：修改数据包中的源、目标IP地址或者端口
    filter表：确定是否放行该数据包

    PREROUTING链：在进行路由选择前处理数据包  
    INPUT链：处理流入数据包  
    OUTPUT链：处理流出数据包  
    FORWARD链：处理转发数据包  
    POSTROUTING链：在进行路由选择后处理数据包 
#### 17.3 动作：
    ACCEPT　
    REJECT(拒绝请求，同时返回拒绝信息)　
    LOG(记录日志信息，然后传给下一条规则继续匹配)
    DROP(丢包，不响应)  
    SNAT(修改数据包源地址)
    DNAT(修改数据包目的地址)
    REDIRECT(重定向)

`[root@xy ~]# iptables -L`　**-L 查看规则链 Look**  
Chain INPUT (policy ACCEPT)  
target     prot opt source               destination           
ACCEPT     all  --  anywhere             anywhere             ctstate RELATED,ESTABLISHED  
ACCEPT     all  --  anywhere             anywhere              
INPUT_direct  all  --  anywhere             anywhere                         
........省略部分输出信息........  

`[root@xy ~]# iptables -F` 　**-F 清空规则链**  
`[root@xy ~]# iptables -L`  
Chain INPUT (policy ACCEPT)  
target     prot opt source               destination           

Chain FORWARD (policy ACCEPT)  
target     prot opt source               destination           

Chain OUTPUT (policy ACCEPT)  
target     prot opt source               destination                             
........省略部分输出信息........  

`[root@xy ~]# iptables -P INPUT DROP`　**iptables -P参数默认策略 INPUT规则链 DROP动作**  
`[root@xy ~]# iptables -L`  
Chain INPUT (policy DROP)    
........省略部分输出信息........  
`[root@xy ~]# iptables -I INPUT -p icmp -j ACCEPT`　**iptables -I头部添加新规则 INPUT规则链 -p icmp ACCEPT动作**  
`[root@xy ~]# iptables -D INPUT 1`　**iptables -D删除某一条规则 INPUT规则链 序号**  
`[root@xy ~]# iptables -P INPUT ACCEPT`　**iptables -P默认策略 INPUT规则链 ACCEPT动作**  
`[root@xy ~]# iptables -L`  
Chain INPUT (policy ACCEPT)    
........省略部分输出信息........  

#### 17.4 仅允许指定网段的主机访问本机的22端口 SSH 
`[root@xy ~]# iptables -I INPUT -s 192.168.37.0/24 -p tcp --dport 22 -j ACCEPT`　　
 **iptables -I头部添加新规则 INPUT规则链 源IP -p tcp --dport 22 ACCEPT动作**    
`[root@xy ~]# iptables -A INPUT -p tcp --dport 22 -j REJECT`  
**iptables -A尾部添加新规则 INPUT规则链 -p tcp --dport 22 REJECT动作**  
`[root@xy ~]# iptables -L`  
Chain INPUT (policy ACCEPT)  
target     prot opt source               destination           
ACCEPT     tcp  --  192.168.37.0/24      anywhere             tcp dpt:ssh  
REJECT     tcp  --  anywhere             anywhere             tcp dpt:ssh   
reject-with icmp-port-unreachable  
........省略部分输出信息........   
`[root@clientA ~]# ssh 192.168.37.10`　**网段192.168.37.0/24 是可以的**  
`[root@clientA ~]# ssh 192.168.37.10`　**网段192.168.20.0/24 XXXXXXXX**  
Connecting to 192.168.37.10:22...  
Could not connect to '192.168.37.10'(port 22): Connection failed  

#### 17.5 INPUT 规则链加入拒绝所有人访问本机12345端口的策略规则  
`[root@xy ~]# iptables -I INPUT -p tcp --dport 12345 -j REJECT`   
`[root@xy ~]# iptables -I INPUT -p udp --dport 12345 -j REJECT`  
`[root@xy ~]# iptables -L`  
Chain INPUT (policy ACCEPT)  
target     prot opt source               destination           
REJECT     udp  --  anywhere             anywhere             udp dpt:italk   
reject-with icmp-port-unreachable  
REJECT     tcp  --  anywhere             anywhere             tcp dpt:italk   
reject-with icmp-port-unreachable  
ACCEPT     tcp  --  192.168.37.0/24      anywhere             tcp dpt:ssh  
REJECT     tcp  --  anywhere             anywhere             tcp dpt:ssh   
reject-with icmp-port-unreachable  
........省略部分输出信息........  

#### 17.6 INPUT 规则链加入拒绝所有人访问本机1000:1024端口的策略规则  
`[root@xy ~]# iptables -A INPUT -p tcp --dport 1000:1024 -j REJECT`   
`[root@xy ~]# iptables -A INPUT -p udp --dport 1000:1024 -j REJECT`   
`[root@xy ~]# iptables -L`  
Chain INPUT (policy ACCEPT)  
target     prot opt source               destination           
REJECT     udp  --  anywhere             anywhere             udp dpt:italk   
reject-with icmp-port-unreachable  
REJECT     tcp  --  anywhere             anywhere             tcp dpt:italk   
reject-with icmp-port-unreachable  
ACCEPT     tcp  --  192.168.37.0/24      anywhere             tcp dpt:ssh  
REJECT     tcp  --  anywhere             anywhere             tcp dpt:ssh   
........省略部分输出信息........  

#### 17.7 INPUT 规则链加入拒绝192.168.37.5访问本机80端口的策略规则  
`[root@xy ~]# iptables -I INPUT -p tcp -s 192.168.37.5 --dport 80 -j REJECT`  
`[root@xy ~]# iptables -L`
Chain INPUT (policy ACCEPT)  
target     prot opt source               destination           
REJECT     tcp  --  192.168.37.5         anywhere             tcp dpt:http   
reject-with icmp-port-unreachable
........省略部分输出信息........  
`[root@xy ~]# service iptables save`　 **永久生效**  
iptables: Saving firewall rules to /etc/sysconfig/iptables:[  OK  ]   

####  禁止源自192.168.10.0/24 网段的流量访问本机sshd服务：
`[root@xy ~]# iptables -I INPUT -s 192.168.10.0/24 -p tcp --dport 22 -j REJECT`  
`[root@xt ~]# service iptables save`
####  SNAT 转换规则：内网访问外网(路由后交给SNAT)
`[root@xy ~]# iptables -t nat -A  POSTROUTING -s 10.10.10.0/24 -o eth1 -j SNAT --to-source 192.168.239.129`   
`[root@xy ~]# iptables -t nat -A  POSTROUTING -s 10.10.10.0/24 -o eth1 -j MASQUERADE`  
`[root@xt ~]# service iptables save`
`[root@xt ~]# vim /etc/sysconfig/iptables`  
DNS1=114.144.114.114 8.8.8.8  
####  DNAT 转换规则：外网访问内网(路由前交给DNAT)
`[root@xy ~]# iptables -t nat -A  PREROUTING -i eth0 -d 218.29.30.31 -p tcp --dport 80 -j DNAT --to-destination 192.168.1.6`    
`[root@xt ~]# service iptables save`

`[root@xy ~]# iptables-save > 1.iptables`  
`[root@xy ~]# iptables-restore < 1.iptables`  


### 17.8 firewalld(Dynamic Firewall Manager of Linux system):Linux动态防火墙管理器  <div id="firewalld"></div>
管理方式:CLI(命令行界面) 与 GUI(图形用户界面)
                             
#### 17.8.1 firewalld中常用的区域名及策略规则:    
	trusted      允许所有数据包    
	home         拒绝流入的流量,除非与流出的流量相关;而如果流量与ssh,mdns,ipp-client,amba-client与dhcpv6-client服务相关,则允许流量  
	internal     等同于home区域  
	work         拒绝流入的流量,除非与流出的流量数相关;而如果流量与ssh,mdns,ipp-client,amba-client与dhcpv6-client服务相关,则允许流量         
	public       拒绝流入的流量,除非与流出的流量相关;而如果流量与ssh,mdns,ipp-client,amba-client与dhcpv6-client服务相关,则允许流量  
	external     拒绝流入的流量,除非与流出的流量相关;而如果流量与ssh,则允许流量  
	dmz          拒绝流入的流量,除非与流出的流量相关;而如果流量与ssh,则允许流量  
	block        拒绝流入的流量,除非与流出的流量相关     
  	drop         拒绝流入的流量,除非与流出的流量相关  

#### 17.8.2 firewall-cmd 命令:  
     --get-default-zone                查询默认区域名称
	 --set-default-zone=<区域名称>      设置默认区域,使其永久生效
	 --get-zones                       显示可用区域
	 --get-services                    显示预先定义服务
	 --get-active-zones                显示当前正使用的区域与网卡名称
	 --add-source=                     将源自此IP/子网流量导向某个指定区域
	 --remove-source=                  不再将源自此IP/子网流量导向某个指定区域
     --add-interface=<网卡名称>         将源自此网卡所有流量导向某个指定区域
	 --change-interface=<网卡名称>      将某个网卡与区域进行关联
	 --list-all                        显示当前区域网卡配置参数/资源/端口/服务
   	 --list-all-zones                  显示所有区域网卡配置参数/资源/端口/服务
	 --add-service=<服务名>             设置默认区域允许该服务的流量
     --add-port=<端口号/协议>           设置默认区域允许该端口的流量
     --remove-service=<服务名>          设置默认区域不再允许该服务的流量
     --remove-port=<端口号/协议>        设置默认区域不再允许该端口的流量
     --reload                          让永久生效的配置规则立即生效,覆盖当前配置规则
     --panic-on                        开启应急状况模式
     --panic-off                       关闭应急状况模式

`[root@xy ~]# firewall-cmd --get-default-zone`  
public  
`[root@xy ~]# firewall-cmd --get-zone-of-interface=eno16777736`  
public  
`[root@xy ~]# firewall-cmd --permanent --zone=external --change-interface=eno167`  
736  
success　**重启后生效**  
`[root@xy ~]# firewall-cmd --get-zone-of-interface=eno16777736`  
external 
 
`[root@xy ~]# firewall-cmd --set-default-zone=public`   
**firewall当前服务设置为public**  
success 
 
`[root@xy ~]# firewall-cmd --panic-on`     
**启动/关闭防火墙应急状况模式,阻断一切网络连接**  
success  
`[root@xy ~]# firewall-cmd --panic-off`  
success  

**查询public区域是否允许请求SSH和HTTPS协议流量**  
`[root@xy ~]# firewall-cmd --zone=public --query-service=ssh`  
yes  
`[root@xy ~]# firewall-cmd --zone=public --query-service=https`  
no   

**firewalld服务中请求HTTPS协议流量设置永久允许,立即生效**  
`[root@xy ~]# firewall-cmd --zone=public --add-service=https`  
success  
`[root@xy ~]# firewall-cmd --permanent --zone=public --add-service=https`  
success  
`[root@xy ~]# firewall-cmd --reload`　**更改设置立即生效**  
success  

**firewalld服务中请求HTTP协议流量设置永久拒绝,立即生效**  
`[root@xy ~]# firewall-cmd --permanent --zone=public --remove-service=http` **permanent 永久、常驻**  
success  
`[root@xy ~]# firewall-cmd --reload`  
success  

**firewalld　服务中访问8080 8081端口流量策略设置允许,仅当前生效**  
`[root@xy ~]# firewall-cmd --zone=public --add-port=8080-8081/tcp`  
success  
`[root@xy ~]# firewall-cmd --zone=public --list-ports`   
8080-8081/tcp  

**流量转发**  
`[root@xy ~]# firewall-cmd --permanent --zone=public --add-forward-port=port=888:proto=tcp:toport=22:toaddr=192.168.37.10`  
`[root@xy ~]# firewall-cmd --reload`  
success  

**服务的ACL**  
`[root@xy ~]# vim /etc/hosts.deny`  
`[root@xy ~]# vim /etc/host.allow`  

### 18. 使用SSH服务管理远程主机  
`[root@xy ~]# nmtui`　**GUI配置网络参数**   
`[root@xy ~]# cd /etc/sysconfig/network-scripts/`  
`[root@xy network-scripts]# vim ifcfg-eno16777736`  

`[root@xy network-scripts]# systemctl restart network`  
`[root@xy network-scripts]# ping -c 4 192.168.37.10`  
PING 192.168.37.10 (192.168.37.10) 56(84) bytes of data.  
64 bytes from 192.168.37.10: icmp_seq=1 ttl=64 time=31.3 ms  
64 bytes from 192.168.37.10: icmp_seq=2 ttl=64 time=0.272 ms    
64 bytes from 192.168.37.10: icmp_seq=3 ttl=64 time=0.245 ms    

--- 192.168.37.10 ping statistics ---  
4 packets transmitted, 4 received, 0% packet loss, time 3005ms  
rtt min/avg/max/mdev = 0.183/8.006/31.325/13.463 ms  

`[root@xy network-scripts]# nmcli connection show`　 **管理Network Manager服务**  
NAME         UUID                                  TYPE            DEVICE        
eno16777736  e1fa8452-091b-429e-adce-ecea92a845c7  802-3-ethernet  eno16777736   
`[root@xy network-scripts]# nmcli con show eno16777736`    
connection.id:                          eno16777736  
connection.uuid:                        e1fa8452-091b-429e-adce-ecea92a845c7  
connection.interface-name:  
........省略部分输出信息........  
`[root@xy ~]# nmcli connection add con-name company ifname eno16777736`   
autoconnect   
no type ethernet ip4 192.168.37.10/24 gw4 192.168.37.1  
Connection 'company' (a8b3a029-5c7b-4ec7-b519-69f6862e616f) successfully added.  
`[root@xy ~]# nmcli connection add con-name house type ethernet ifname eno16777736`   
Connection 'house' (00a825ae-b1c2-4130-a1f6-c693de73783c) successfully added.  
`[root@xy ~]# nmcli connection show`  
NAME         UUID                                  TYPE            DEVICE        
house        00a825ae-b1c2-4130-a1f6-c693de73783c  802-3-ethernet  --            
company      a8b3a029-5c7b-4ec7-b519-69f6862e616f  802-3-ethernet  --            
eno16777736  e1fa8452-091b-429e-adce-ecea92a845c7  802-3-ethernet  eno16777736  
`[root@xy ~]# nmcli connection up house`  
Connection successfully actived (D-Bus activ path: /org/freedesktop/NetworkMana  
ger/ActiveConnection/2)  

### 19. 绑定两块网卡  
`[root@xy ~]# vim /etc/sysconfig/network-scripts/ifcfg-eno16777736`  
   TYPE=Ethernet  
   BOOTPROTO=none  
   ONBOOT=yes  
   USERCTL=no  
   DEVICE=eno16777736   
   MASTER=bond0  
   SLAVE=yes  
`[root@xy ~]# vim /etc/sysconfig/network-scripts/ifcfg-eno33554984`    
   TYPE=Ethernet
   BOOTPROTO=none
   ONBOOT=yes
   USERCTL=no
   DEVICE=eno16777736
   MASTER=bond0
   SLAVE=yes  
`[root@xy ~]# vim /etc/sysconfig/network-scripts/ifcfg-bond0`    
   TYPE=Ethernet  
   BOOTPROTO=none  
   ONBOOT=yes  
   USERCTL=no   
   DEVICE=bond0  
   IPADDR=192.168.37.10  
   PREFIX=24  
   DNS=192.168.37.1  
   NM_CONTROLLED=no  
**常见网卡绑定驱动有三种模式**  
    mode0:平衡负载模式,平时两块网卡同时工作,且自动备援,但需要在与服务器本地网卡相连的交换机设备上进行端口聚合来支持绑定技术  

    mode1:自动备援模式,平时仅一块网卡工作,故障后自动替换为另外网卡  

    mode6:平衡负载模式,平时两块网卡同时工作,自动备援,无须交换机设备提供辅助支持

`[root@xy ~]# vim /etc/modprobe.d/bond.conf`　**创建绑定网卡文件**    
   alias bond0 bonding
   options bond0 miiimon=100 mode=6  
`[root@xy ~]# systemctl restart network`  
`[root@xy ~]# ifconfig` 　 **正常情况下仅仅bond0网卡设备显示IP等信息**  
   bond0: flags=5187<UP,BR0ADCAST,RUNNING,MASTER,MULTICAST> mtu 1500  
   inet 192.168.37.10 network 255.255.255.0 broadcast 192.168.37.255  
   inet6 fe80:20c:29ff:fe9c:637d prefixlen 64 scopeid 0x20<link>  
   ........省略部分信息........  
   eno16777736: flags=5187<UP,BR0ADCAST,RUNNING,MASTER,MULTICAST> mtu 1500  
   ........省略部分信息........  
   eno33554984: flags=5187<UP,BR0ADCAST,RUNNING,MASTER,MULTICAST> mtu 1500  
   ........省略部分信息........  
`[root@xy ~]# ping 192.168.37.10`  
**断开其中一块网卡,另一块会继续为用户提供服务** 

### 20. 配置sshd服务:    <div id="SSH"></div>
`[root@xy ~]# vim /etc/ssh/sshd_config`   

    Port 22                               sshd服务默认端口  
    ListenAddress 0.0.0.0                　设定sshd服务监听的IP地址  
    Protocol 2                            SSH协议的版本号  
    HostKey /etc/ssh/ssh_host_key         SSH协议的版本1,DES私钥存放位置  
    HostKey /etc/ssh/ssh_host_rsa_key     SSH协议的版本2,RSA私钥存放位置  
    HostKey /etc/ssh/ssh_host_dsa_key     SSH协议的版本2,DSA私钥存放位置  
    PermitRootLogin no                    设定是否允许管理员直接登陆  
    StrictModes yes                       当远程用户的私钥改变时直接拒接登陆  
    MaxAuthTries 6                        最大密码尝试次数  
    MaxSessions 10                        最大终端数  
    PasswordAuthentication yes            是否允许密码验证  
    PermitEmptyPasswords no               是否允许空密码登录  
`[root@xy ~]# systemctl restart sshd`　 **service sshd start**   
`[root@xy ~]# systemctl enable sshd` 　 **chkconfig sshd enable**  

**安全密钥验证**  
*客户端主机生成“密钥对”*  
`[root@xy ~]# ssh-keygen -t rsa -b 2048`  // 用此命令的 留下 私钥
Generating public/private rsa key pair. 
Enter file in which to save the key (/root/.ssh/id_rsa):　**回车或设置密钥存储路径**  
Enter passphrase (empty for no passphrase): 　**直接按回车或设置密钥密码**  
Enter same passphrase again: 　**再次按回车或设置密钥密码**  
Your identification has been saved in /root/.ssh/id_rsa.  
Your public key has been saved in /root/.ssh/id_rsa.pub.  
The key fingerprint is:  
81:e1:46:ce:a2:1a:a2:45:e2:5e:46:05:9f:ce:c1:12 root@xy.com  
The key's randomart image is:  
+--[ RSA 2048]----+  
|   E..o          |  
|    ==.o         |  
|. .o.=* .        |  
|.o..+o.  .       |  
|o.oo o  S        |  
|++o              |  
|o.               |  
|                 |  
|                 |  
+-----------------+  

* 客户端主机生成的公钥传送至远程主机上  
`[root@xy ~]# ssh-copy-id 192.168.37.10`  // ssh-copy-ip 只能拷贝公钥
Number of key(s) added: 1  
Now try logging into the machine, with:   "ssh '192.168.37.10'"  
and check to make sure that only the key(s) you wanted were added.  

* 对服务器进行设置只允许密钥验证  
`[root@xy ~]# vim /etc/ssh/sshd_config`   
PasswordAuthentication no  

### 21. 远程传输命令scp(secure copy) 基于SSH协议 Liunx主机之间:  <div id="scp"></div>

     scp [参数] 本地文件 远程用户@远程IP地址:远程目录	上传到远程主机

     scp [参数] 远程用户@远程IP地址:远程文件 本地目录    下载到本地主机
  
     -v         显示详细的链接进度

     -P         指定远程主机的sshd端口号

     -r         用于传送文件

     -6         使用ipv6协议
`[root@xy ~]# echo "Hello World" > readme.txt`  
`[root@xy ~]# scp /root/readme.txt 192.168.37.10:/home`　　　　// 上传  

`[root@xy ~]# scp 192.168.37.10:/home/readme.txt /root`　　　　// 下载

**不间断回话服务screen**  
-S **创建回话窗口**　 -d **指定回话进行离线处理**　-r **恢复指定回话**   
-x **一次性恢复所有会话**　-ls **显示当前已经有的会话**　-wipe **目前无法使用的会话删除**  
`[root@xy ~]# screen -S backup` 　 **屏幕快速闪动进入回话**   
`[root@xy ~]# screen -ls`  
There is a screen on:  
        3127.backup     (Attached)  
1 Socket in /var/run/screen/S-root.  

### 22. Apache 服务部署静态网站  <div id="Apache"></div>
+ Web 服务程序:IIS、Nginx、Apache  
`[root@xy ~]# yum install httpd`  
`[root@xy ~]# systemctl start httpd`  
`[root@xy ~]# systemctl enable httpd`  
#### 22.1 httpd服务程序配置文件及存放位置  
    服务目录                              /etc/httpd  
    主配置文件                            /etc/httpd/conf/httpd.conf     
    网站数据目录DocumentRoot              /var/www/html  
    访问日志                              /var/log/httpd/access_log  
    错误日志                              /var/log/httpd/error_log  

`[root@xy ~]# vim /etc/httpd/conf/httpd.conf` 
 
    ServerRoot                   服务目录  ✔
    ServerAdmin                  管理员邮箱  
    User                         运行服务的用户  
    Group                        运行服务的用户组  
    ServerName                   网站服务器的域名  
    DocumentRoot                 网站数据目录  ✔
    Directory                    网站数据目录的权限  
    Listen                       监听IP与端口号  ✔
    DirectoryIndex               默认索引页面  ✔
    ErrorLog                     错误日志文件  
    CustomLog                    访问日志文件   
    Timeout                      网页超时时间,默认300s  

> SELinux(Security-Enhances Linux),强制反问控制(MAC)安全子系统,三种服务配置模式enforccing  peimissing  disabled,当改变DocumentRoot路径后,违反了SELinux监管规则,所以在新的路径下Index.html无法访问

`[root@xy ~]# vim  /etc/selinux/config`　**SELinux 配置文件路径**  
1  #This file controls the state of SELinux on the system.  
2  # SELINUX= can take one of these three values:  
3  #     enforcing - SELinux security policy is enforced.   'enforce'  
4  #     permissive - SELinux prints warnings instead of enforcing.  'permissive'  
5  #     disabled - No SELinux policy is loaded.  'disabled  
SELINUX=enforcing  
6  # SELINUXTYPE= can take one of these two values:  
7  #     targeted - Targeted processes are protected,  
8  #     minimum - Modification of targeted policy. Only selected processes are protected.   
9  #     mls - Multi Level Security protection.  
#### 22.2 SELinux 安全上下文由用户段、角色段、类型段共同组成     
`[root@xy ~]# setenforce 0`　**setenforce**  
`[root@xy ~]# getenforce`　**getenforce**  
Permissive  
`[root@xy ~]# setenforce 1`    
`[root@xy ~]# getenforce`  
Enforcing  
`[root@xy ~]# ls -Zd /var/www/html/` 　**ls -Zd  用户段 角色段 类型段**  
drwxr-xr-x. root root system_u:object_r:httpd_sys_content_t:s0 /var/www/html/  
`[root@xy ~]# ls -Zd /home/wwwroot/`  
drwxr-xr-x. root root unconfined_u:object_r:home_root_t:s0 /home/wwwroot/  

#### 22.3 semanage [参数] [选项] [文件]
    -l **用于查询**　-a **用于添加**　-m **用于修改**　-d **用于删除**  
    semanage fcontext -a -t 用于添加新的SELinux安全上下文 ✔     
`[root@xy ~]# semanage fcontext -a -t httpd_sys_content_t /home/wwwroot`    
`[root@xy ~]# semanage fcontext -a -t httpd_sys_content_t /home/wwwroot/*`  
`[root@xy ~]# restorecon -Rv /home/wwwroot/`　**restorcon -Rv 更新安全上下文** 

    restorecon reset /home/wwwroot context unconfined_u:object_r:home_root_t:s0->  
    unconfined_u:object_r:httpd_sys_content_t:s0  
    restorecon reset /home/wwwroot/index.html context   
    unconfined_u:object_r:home_root_t:s0->unconfined_u:object_r:httpd_sys_content_t:s0  

#### 22.4 个人用户主页功能  
`[root@xy ~]# vim /etc/httpd/conf.d/userdir.conf`   
   #UserDir disabled  
   UserDir public_html　　24行 去掉#   网站在用户家目录中保存的名称 
 
`[root@xy ~]# su - xy`  
`[xy@xy ~]$ mkdir public_html`  
`[xy@xy ~]$ echo "This is xy's website" > public_html/index.html`  
`[xy@xy ~]$ chmod -Rf 755 /home/xy`  

`[root@xy ~]# getsebool -a | grep http`　**getsebool -a 获取安全策略**  
    *httpd_enable_homedirs --> off*  
`[root@xy ~]# setsebool -P httpd_enable_homedirs=on`　 **setsebool -P**  

`[root@xy ~]# htpasswd -c /etc/httpd/passwd xy`  
New password:  
Re-type new password:  
Adding password for user xy  
`[root@xy ~]# vim /etc/httpd/conf.d/userdir.conf`  
*31-35* 
   
    <Directory "/home/*/public_html">  
	    AllowOverride all  
	    authuserfile "/etc/httpd/passwd"  
	    authname "My privately website"  
	    authtype basic  
	    require user xy  
    </Directory>  

#### 22.5 虚拟主机(VPS:Virtual Private Server)功能  
    利用该功能可以把一台物理服务器分割为多个"虚拟服务器",VPS共享物理服务器硬件
    资源,Apache的VPS是基于用户请求不同IP、主机域名、端口号,实现提供多个网站同时为外部提供访问服务技术  
##### 1. 基于多个IP地址(192.168.37.10 ; 192.168.37.20 ; 192.168.37.30)  
`[root@xy ~]# mkdir -p /home/wwwroot/10`  
`[root@xy ~]# echo "IP:192.168.37.10" > /home/wwwroot/10/index.html`  
`[root@xy ~]# vim /etc/httpd/conf/httpd.conf` 
  
        <VirtualHost 192.168.37.10>  
        <DocumentRoot "/home/wwwroot/10">  
        ServerName tech.xy.com  
        <Directory "/home/wwwroot/10">  
        AllowOverride None  
        Require all granted  
        </Directory>  
        </VirtualHost>   
`[root@xy ~]# systemctl restart httpd`  
`[root@xy ~]# semanage fcontext -a -t httpd_sys_content_t /home/wwwroot`  
`[root@xy ~]# semanage fcontext -a -t httpd_sys_content_t /home/wwwroot/10`  
`[root@xy ~]# semanage fcontext -a -t httpd_sys_content_t /home/wwwroot/10/*`  
`[root@xy ~]# restorecon -Rv /home/wwwroot`  

##### 2. 基于主机域名(192.168.37.10 www.xy.com bbs.xy.com tech.xy.com)  
`[root@xy ~]# vim /etc/hosts`  

        127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4  
        ::1 localhost localhost.localdomain localhost6 localhost6.localdomain6  
        192.168.37.10 www.xy.com bbs.xy.com tech.xy.com  

`[root@xy ~]# mkdir -p /home/wwwroot/www`
  
    <VirtualHost 192.168.37.10>  
    DocumentRoot "/home/wwwroot/www"  
	  ServerName tech.xy.com  
	  <Directory "/home/wwwroot/www">  
	  AllowOverride None  
	  Require all granted  
    </Directory>  
	  </VirtualHost>  

`[root@xy ~]# systemctl restart httpd`  
`[root@xy ~]# semanage fcontext -a -t httpd_sys_content_t /home/wwwroot/`  
`[root@xy ~]# semanage fcontext -a -t httpd_sys_content_t /home/wwwroot/bbs`  
`[root@xy ~]# semanage fcontext -a -t httpd_sys_content_t /home/wwwroot/bbs/*`  
`[root@xy ~]# restorecon -Rv /home/wwwroot`  

##### 3. 基于端口号80 443 8080比较合理  (测试:6111 6222)  
`[root@xy ~]# mkdir -p /home/wwwroot/6111`
`[root@xy ~]# echo "port:6111" > /home/wwwroot/6111/index.html`
`[root@xy ~]# vim /etc/httpd/conf/httpd.conf` 

	 Listen 6111  
    	<VirtualHost 192.168.37.10:6111>  
    	DocumentRoot "/home/wwwroot/6111"  
    	ServerName www.xy.com  
    	<Directory "/home/wwwroot/6111">  
    	AllowOverride None  
    	Require all granted  
    	</Directory>  
    	</VirtualHost>  

`[root@xy ~]# semanage fcontext -a -t httpd_sys_content_t /home/wwwroot`  
`[root@xy ~]# semanage fcontext -a -t httpd_sys_content_t /home/wwwroot/6111`  
`[root@xy ~]# semanage fcontext -a -t httpd_sys_content_t /home/wwwroot/6111/*`  
`[root@xy ~]# restorecon -Rv /home/wwwroot`  
`[root@xy ~]# semanage port -l | grep http` **semanage port -l 查询端口**
  
	http_cache_port_t            tcp      8080, 8118, 8123, 10001-10010  
	http_cache_port_t            udp      3130  
	http_port_t                  tcp      80, 81, 443, 488, 8008, 8009, 8443, 9000  
	pegasus_http_port_t          tcp      5988  
	pegasus_https_port_t         tcp      5989  
`[root@xy ~]# semanage port -a -t http_port_t -p tcp 6111`  **semanage port -a -t**  
`[root@xy ~]# semanage port -l | grep http` 
 
	http_cache_port_t    tcp   8080, 8118, 8123, 10001-10010  
	http_cache_port_t    udp   3130  
	http_port_t          tcp   6111, 80, 81, 443, 488, 8008, 8009, 8443, 9000  
	pegasus_http_port_t  tcp   5988  
	pegasus_https_port_t tcp   5989  
`[root@xy ~]# systemctl restart httpd`  

[返回目录](#back)
