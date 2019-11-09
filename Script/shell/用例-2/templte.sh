#!/bin/bash

# chkconfig: 2345 77 22
# description: Test Service

LOCKFILE=/var/locl/subsys/myservice

start(){
	if [ -e $LOCKFILE ]; then
		echo "Running..."
	else
		echo "Stopping..."
}

Usage(){
	echo "`basename $0 {start|stop|restart|status}`"
}

case $1 in
start)
	echo "Starting..."
	touch $LOCKFILE
	;;
stop)
	echo "Stopping..."
	rm -rf $LOCKFILE &>/dev/null
	;;
restart)
	echo "Restarting..."
	;;
status)
	status()
	;;
*)
	Usage()
	;;
esac
