#!/bin/bash
# Automatic Backup Linux System Files
# auto_backup_system.sh

# Define Variable
SOURCE_DIR = (
	$*
)
TARGET_DIR = /data/backup
YEAR = $(date + %Y)
MONTH = $(date + %m)
DAY = $(date + d)
WEEK = $(date + %d)
FILES = `date + %u`
CODE = $?
if [ -z $SOURCE_DIR ]; then
	echo -e "Please Enter a file or Directory You Need to Backup:\n------------------------------ \nExample $0 /boot/etc ......"
	exit
fi

# Determine Whether the Target Directory Exists
if [ ! -d $TARGET_DIR/$YEAR/$MONTH/$DAY ]; then
	mkdir -p $TARGET_DIR/$YEAR/$MONTH/$DAY
	echo "This $TARGET_DIR Create Successfuly!"
fi

# Exec Full_Backup Function Command
Full_Backup () {
	if [ "$WEEK" -eq "7" ]; then 
		rm -rf $TARGET_DIR/snapshot
		cd $TARGET_DIR/$YEAR/$MONTH/$DAY; tar -g $TARGET_DIR/snapshot -czvf $FILES 'echo ${SOURCE_DIR[@]}'
		[ "$CODE" == "0" ] && echo -e "--------------------------------- \nFull_Backup System Files Backup Successfully!"
	fi
}

# Perform incremental Backup Function Command
Add_Backup () {
	cd $TARGET_DIR/$YEAR/$MONTH/$DAY/$FILES
	if [ -f $TARGET_DIR/$YEAR/$MONTH/$DAY/$FILES ]; then 
		read -p "$FILES Already Exists, overwrite confirmation yes or no? : " SURE
		if [ $SURE == 'no' -o $SURE == 'n' ]; then	
			sleep 1; exit 0
		fi
	# Add_Backup Files System
		if [ $WEEK -ne '7' ]; then 
			cd $TARGET_DIR/$YEAR/$WEEK/$DAY; tar -g $TARGET_DIR/snapshot -czvf $ $_ $FILES 
			'echo ${SOURCE_DIR[@]}'
			[ "$CODE" == "0" ] && echo -e "---------------------------------- \nAdd_Backup System Files Backup Successfuly!" 
		fi
	else
		if [ $WEEK -ne '7' ]; then 
			cd $TARGET_DIR/$YEAR/$WEEK/$DAY; tar -g $TARGET_DIR/$snapshot -czvf $FILES 'echo $- \nAdd_Backup System Files Backup Succesfuly!'
		fi
	fi
}
Full_Backup; Add_Backup







































