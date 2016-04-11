#!/bin/bash
pdno=$1
vdno=$(($pdno+1))
disklist=(b c d e f g h i j k l m)
diskname=${disklist[$pdno]}
mountpath="/export/grid/`seq -f'%02g' $vdno $vdno`"

#echo $pdno
#echo $vdno
#echo $diskname
#echo $mountpath
umount /export/grid/`seq -f'%02g' $vdno $vdno`

MegaCli64  -CfgForeign -Clear -a0 

MegaCli64  -DiscardPreservedCache -l${vdno} -a0

MegaCli64 -cfgldadd -r0 [32:${pdno}] WB RA Direct CachedBadBBU -a0

#[ ! -b /dev/sd${diskname} } ] && sleep 2
sleep 3
parted -s /dev/sd${diskname} print 
parted -s /dev/sd${diskname} mklabel gpt

parted -a optimal -s /dev/sd${diskname} mkpart primary 0% 100%

parted -s /dev/sd${diskname} print 
sleep 2

mkfs.ext4  -m 0 -O dir_index,extent,sparse_super /dev/sd${diskname}1 -T largefile

olduuid=`grep $mountpath /etc/fstab |cut -f 1 -d " " |cut -f 2  -d "="`
newuuid=`ls /dev/disk/by-uuid/ -l |fgrep /sd${diskname} |cut -f 9  -d " "`

echo "old uuid : $olduuid"
echo "new uuid : $newuuid"
sed -i "s/$olduuid/$newuuid/" /etc/fstab
mount -a
chown -R hdp.hadoop $mountpath
