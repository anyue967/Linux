#!/bin/bash                    	
#HLIST=$(cat ~/ipadds.txt)

FILE=`mktemp /tmp/file.xxxx`
cleanup(){
	echo "quit..."	
	rm -f $FILE
	exit 1
}

trap 'cleaup' INT
for IP in `cat ipadds.txt`		#for IP in $HLIST
do
	ping -c 3 -i 0.2 -W 3 $IP &> /dev/null		
	if [ $? -eq 0 ]; then
		echo "Host $IP is On-line." |tee >>$FILE
	else
		echo "Host $IP is Off-line."
	fi
done
