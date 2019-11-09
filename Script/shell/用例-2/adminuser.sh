#!/bin/bash

DEBUG=0
ADD=0
DEL=0

for I in `seq 0 $#`; do
case $1 in
-v|--verbose)
	DEBUG=1
	shift ;;	# $1剔除，$2成为$1
-h|--help)
	echo "Usage:`basename $0` --add USER_LIST --del USER_LIST -v| --verbose -h| --help"
	exit 0
	;;
--add)
	ADD=1
	ADDUSERS=$2
	shift 2
	;;
--del)
	DEL=1
	DELUSERS=$2
	shift 2
	;;
*)
	echo "Usage:`basename $0` --add USER_LIST --del USER_LIST -v| --verbose -h| --help"
	exit 7
	;;
esac
done

if [ $ADD -eq 1 ]; then
	for USER in `echo $ADDUSERS |sed 's/,/ /g'`; do
		if id $USER &>/dev/null; then	
			[ $DEBUG -eq 1 ] && echo "$USER exits."
		else
			useradd $USER
			echo $USER |passwd --stdin $USER &>/dev/null
			[ $DEBUG -eq 1 ] && "add $USER finished."
		fi
	done
elif [ $DEL == 1 ]; then	
	for USER in `echo $DELUSERS |sed 's/,/ /g'`; do
		if id $USER &>dev/null; then
			userdel -r $USER 
			[ $DEBUG -eq 1 ] && "Delete $I finished."
		else	
			[ $DEBUG -eq 1 ] && "$USER NOT exits."
		fi
		done 
elif [ $1 == "--help" ]; then
	echo "Usage: $0 --add USER1,USER2,... |--del USER1,USER2,... |--help"
else
	echo "Unknow options."
fi