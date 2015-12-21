#!/bin/bash
file="/root/ip/172.23.txt"


###########################################
PRONUM=49
tmpfile="$$.fifo"
mkfifo $tmpfile
exec 9<>$tmpfile
rm $tmpfile
for ((i=0;i<$PRONUM;i++))
do
	echo 
done >&9
###########################################

###########################################
genconfig()
{
ip=$1
if [  ${2} ];then
        idracIP=$2
else
        idracIP=`echo $1 |sed 's/172/10/'`
fi
ping -c 1 $idracIP 2>&1 > /dev/null
[ $? -eq 1 ] &&  echo "$idracIP is bad " && return 1

if [[ $ip == 172.2[34].* ]];then 
#	hostconfdir="/etc/icinga2/zones.d/jdjr-hwm-m6/hosts"
	hostconfdir="/tmp/m6/"
else
	#hostconfdir="/etc/icinga2/zones.d/jdjr-hwm-hc/hosts"
	hostconfdir="/tmp/hc/"
fi
MemNum=`snmpwalk -v 2c $idracIP -c public  1.3.6.1.4.1.674.10892.5.4.1100.50.1.8.1 |wc -l `
HDnum=`snmpwalk -v 2c $idracIP -c public   1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.2 |wc -l `
fannum=`snmpwalk -v 2c $idracIP -c public 1.3.6.1.4.1.674.10892.5.4.700.12.1.8.1 | wc -l`
servertype=`snmpwalk -v 2c $idracIP -c public 1.3.6.1.4.1.674.10892.5.4.300.10.1.9.1 |awk  ' BEGIN{FS=":"}{print  $NF}'`

cat > ${hostconfdir}/${ip}.conf <<EOF
object Host "${ip}"  {
        import "generic-host"
        vars.os="Linux"
        display_name="${ip}"
        address="${ip}"
        groups=[$servertype]
        check_command="hostalive"
        check_command="tcp"
        check_command="new_snmp-uptime"
        vars.iDracIP="${idracIP}"
        vars.vendor="DELL"
        vars.MemNum="$MemNum"
        vars.HDnum="$HDnum"
        vars.FanNum="$fannum" 
	vars.servertype=$servertype
}
EOF
}
###########################################

for line in `cat $file`
do
	read -u 9
	{
	genconfig $line 
	echo >&9
	} &
done 
wait
exec 9>&-
