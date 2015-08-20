#!/bin/bash
mkdir -vp {/data,/redo}

parted -s /dev/emcpowera  mklabel gpt
parted -s /dev/emcpowerb  mklabel gpt
parted -s /dev/emcpowera mkpart 1 1 100%
parted -s /dev/emcpowerb mkpart 1 1 100%
mkfs.ext4 /dev/emcpowera1
mkfs.ext4 /dev/emcpowerb1

echo  "/dev/emcpowera1         /redo                   ext4    defaults        0       0" >> /etc/fstab
echo  "/dev/emcpowerb1         /data                   ext4    defaults        0       0" >> /etc/fstab
mount -a
clear
#mount |grep emc

df -h |grep emc
