#!/bin/bash
# auto mv nginx log

S_LOG=/usr/local/nginx/logs/access.log
D_LOG=/data/backup/`date +%Y-%m-%d`
echo -e "\033[32mPlease wait start cut shell scripts...\033[1m"
sleep 2
if [ ! -d $D_LOG ]; then
	mkdir -p $D_LOG
fi
mv $S_LOG $D_LOG
kill - USR1 `cat /usr/local/nginx/logs/nginx.pid`
echo "------------------------------------------------"
echo "The Nginx log Cutting Successfully!"
echo "You can access backup nginx log $D_LOG/access.log files."

# 0 0 * * * /bin/sh/data/sh/auto_nginx_log.sh >>/tmp/nginx_cut.log 2>&1