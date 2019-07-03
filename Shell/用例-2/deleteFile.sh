#!usr/bin/env bash
#定期删除/data目录下修改时间大于7天的文件
back_dir=/data

find /data -mtime +2 -exec rm -rf {} \
find /data -mtime +2 |xargs rm -rf

:<<!
定期清理/data/YY-MM-DD.tar.gz
该目录仅工作日周一至周五自动生成文件YY-MM-DD.tar.gz
只保留最近2天文件
无论过几个节假日/data仍会有前2个工作日的备份文件
!

ls -t /data | awk 'NR>2' | xargs rm -rf
ls -t /data/*.tar.gz | awk 'NR>2{print "rm -rf "$0}'
