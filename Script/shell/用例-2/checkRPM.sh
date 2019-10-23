#!/bin/bash

$pwd = cd /etc/yum.repo.d
$pwd
mkdir bak && mv *.repo ./bak 
cat >/$pwd/base.repo <<EOF
[base]
name=cdrom_repo
baseurl=file:///misc/cd
gpgkey=file:///misc/cd/RPM-GPG-KEY-CentOS-7
EOF
rpm -q $1 &>/dev/null || yum install $1