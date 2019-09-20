#!/bin/bash
# auto_backup_mysql

BAKDIR=/data/backup/mysql/`date +%Y-%m-%d`
MYSQLDB=webapp
MYSQLPW=backup
MYSQLUSR=backup

if [ $UID -ne 0 ]; then
	echo "This script must the root user!!!"
	sleep2
	exit 0
fi

if [ ! -d $BAKDIR ]; then
	mkdir -p $BAKDIR
fi

/usr/bin/mysqldump -u$MYSQLUSR -p$MYSQLPW -d$MYSQLDB >$BAKDIR/webapp_db.sql
echo "The mysql backup successdully!"