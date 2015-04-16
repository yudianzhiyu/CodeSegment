#!/bin/bash

if [ -z $1 ]; then
	echo "User is required."
	exit 2
fi

USER=$1
GROUP=sftponly
HOMEDIR=/export/sftp/$USER
PORT=20000
HOST=` cat /etc/sysconfig/network-scripts/ifcfg-*  |grep IPADDR=172 |cut -f 2 -d =`
PASSWD=`mkpasswd -l 12 -s 0`


if ! grep -q 20000 /etc/ssh/sshd_config;then
	echo "Port=20000" >> /etc/ssh/sshd_config
	echo "restart sshd service"
fi

if ! grep -q internal-sftp /etc/ssh/sshd_cofig; then
	sed -i '/sftp-server/s/^S/^#S/' /etc/ssh/sshd_config
	echo "Subsystem       sftp     internal-sftp" >> /etc/ssh/ssd_config
        echo " 		Match Group sftponly "        >> /etc/ssh/sshd_config
        echo " 		ChrootDirectory %h"           >> /etc/ssh/sshd_config
fi

if ! grep -q sftponly /etc/groups;then
	groupadd $GROUP
fi

grep -q $USER /etc/passwd
if [ $? -eq 0 ]; then
	echo "User $USER is exist"
	exit 127
fi

useradd -G $GROUP -d $HOMEDIR -s /sbin/nologin $USER
mkdir -p $HOMEDIR/upload
chown root:root $HOMEDIR/
chmod 755 $HOMEDIR
chown $USER:$GROUP $HOMEDIR/upload
chmod 755 $HOMEDIR/upload

echo "$PASSWD" |passwd --stdin $USER
echo "..."
echo "---------------------------------------------"
echo "OK. Generate password is $PASSWD and testing."
echo "sftp -oPort=$PORT $USER@$HOST"
echo "---------------------------------------------"
