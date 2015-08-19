#!/bin/bash

disklist=(b c d e f g h i j k l m)

for (( i=0;i<${#disklist[@]};i++ ));do
#       echo ${disklist[$i]}
        #disk=${disklist[$i]}
        mountpath="/export/grid/`seq -f'%02g' $(($i+1)) $(($i+1))`"
#       echo $mountpath
        {
        parted -s /dev/sd${disklist[$i]} mklabel gpt
        parted -a optimal -s /dev/sd${disklist[$i]} mkpart primary 0% 100%
        sleep 2
        mkfs.ext4 -q  -m 0 -O dir_index,extent,sparse_super /dev/sd${disklist[$i]}1 -T largefile
        sleep 2
        uuid=`ls /dev/disk/by-uuid/ -l |fgrep /sd${disklist[$i]} |cut -f 9  -d " "`
        echo  "UUID=$uuid    $mountpath     ext4    defaults,noatime    1    2"   >> /etc/fstab
        } &
done 
wait 
mount -a
