#!/bin/bash

umount /export/grid/*
mkdir -p /exportfs
#rm -rf /export/*
sed -i '/grid/d' /etc/fstab

for i in `seq 12`;do
    MegaCli64  -CfgLdDel  -l$i -force -a0
done

MegaCli64 -CfgspanAdd -r10 -array0[32:0,32:1] -array1[32:2,32:3] -array2[32:4,32:5] -array3[32:6,32:7] -array4[32:8,32:9] -array5[32:10,32:11] WB Direct -a0
yum -y install xfsprogs
parted -s /dev/sdb mklabe gpt
parted -s /dev/sdb mkpart 1 1 100%
mkfs.xfs /dev/sdb1
mount /dev/sdb1 /exportfs
echo "UUID=`ls /dev/disk/by-uuid/ -l |grep sdb1|awk '{print $9}'`       /exportfs       xfs     defaults,noatime        1       2" >> /etc/fstab
