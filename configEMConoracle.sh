#!/bin/bash
mkdir -vp {/data,/redo}

emcAsize=`parted -s /dev/emcpowera print |grep GB |grep -o -E "107|2199"`
emcBsize=`parted -s /dev/emcpowerb print |grep GB |grep -o -E "107|2199"`

if [ $emcAsize -gt $emcBsize ];then
	emcpadm renamepseudo -s emcpowera -t emcpowerc
	emcpadm renamepseudo -s emcpowerb -t emcpowera
	emcpadm renamepseudo -s emcpowerc -t emcpowerb
fi

parted -s /dev/emcpowera  mklabel gpt
parted -s /dev/emcpowerb  mklabel gpt
#parted -s /dev/emcpowera mkpart 1 1 100%
parted -s /dev/emcpowera mkpart 1 1 107G
parted -s /dev/emcpowerb mkpart 1 1 100%
#parted -s /dev/emcpowerb mkpart 1 1 2199G
mkfs.ext4 -q /dev/emcpowera1 &
mkfs.ext4 -q /dev/emcpowerb1 &


echo  "/dev/emcpowera1         /redo                   ext4    defaults        0       0" >> /etc/fstab
echo  "/dev/emcpowerb1         /data                   ext4    defaults        0       0" >> /etc/fstab

wait
mount -a
clear
#mount |grep emc

df -h |grep emc
