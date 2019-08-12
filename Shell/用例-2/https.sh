#!/bin/bash
# chkconfig:12345 80 90
# description:Apache httpd
function start_http()
{
	/usr/local/apache24/bin/apachectl  start
}
function stop_http()
{
	/usr/local/apache24/bin/apachectl  stop
}
case "$1" in
start)
	start_http
;;  
stop)
    stop_http
;;  
restart)
	stop_http
    start_http
;;
*)
echo "Usage : start | stop | restart"
;;
esac