#!/bin/bash

vlan=$2
addr=$3
mask=$4
gateway=$5

function func_add_baseX()
{
	if [ -z "$vlan" ] ; then
		echo "Arguments is required!"
		echo "Input option -h to show the help!"
		exit 2;
	fi

	cp /etc/sysconfig/network-scripts/ifcfg-bond0 /etc/sysconfig/network-scripts/ifcfg-bond0.$vlan

	sed -i "s/DEVICE=bond0/DEVICE=bond0.$vlan/" /etc/sysconfig/network-scripts/ifcfg-bond0.$vlan
	echo "VLAN=yes" >> /etc/sysconfig/network-scripts/ifcfg-bond0.$vlan
	echo "ONPARENT=yes" >> /etc/sysconfig/network-scripts/ifcfg-bond0.$vlan

	# sed -i "s/^# IPADDR.*/IPADDR=$addr/" /etc/sysconfig/network-scripts/ifcfg-bond0.$vlan
	# sed -i "s/^# NETMASK.*/NETMASK=$mask/" /etc/sysconfig/network-scripts/ifcfg-bond0.$vlan
	
	# service network restart	
}

function func_add_base0()
{
	if [ -z "$vlan" ] || [ -z "$addr" ] || [ -z "$mask" ] || [ -z "$gateway" ]; then
		echo "Arguments is required!"
		echo "Input option -h to show the help!"
		exit 2;
	fi

	cp /etc/sysconfig/network-scripts/ifcfg-bond0 /etc/sysconfig/network-scripts/ifcfg-bond0.$vlan

	sed -i "s/\(IPADDR\|NETMASK\).*/# &/" /etc/sysconfig/network-scripts/ifcfg-bond0
	
	sed -i "s/DEVICE=bond0/DEVICE=bond0.$vlan/" /etc/sysconfig/network-scripts/ifcfg-bond0.$vlan
	echo "VLAN=yes" >> /etc/sysconfig/network-scripts/ifcfg-bond0.$vlan
	echo "ONPARENT=yes" >> /etc/sysconfig/network-scripts/ifcfg-bond0.$vlan

	sed -i "s/IPADDR.*/IPADDR=$addr/" /etc/sysconfig/network-scripts/ifcfg-bond0.$vlan
	sed -i "s/NETMASK.*/NETMASK=$mask/" /etc/sysconfig/network-scripts/ifcfg-bond0.$vlan
	
	sed -i "s/GATEWAY=.*/GATEWAY=$gateway/" /etc/sysconfig/network
	sed -i "/HOSTNAME/s/^/#/" /etc/sysconfig/network 
	echo "HOSTNAME=$(echo   "JXQ-`echo $addr |cut -f 2- -d . |tr . -`").h.chianbank.com.cn"  >> /etc/sysconfig/network 
	hostname  $(echo   "JXQ-`echo $addr |cut -f 2- -d . |tr . -`").h.chianbank.com.cn
	sed -i "s/id:.*/id: $addr/" /etc/salt/minion
	# service network restart	
}

function func_convert()
{
	if [ -z "$vlan" ]; then
		echo "Arguments is required!"
		echo "Input option -h to show the help!"
		exit 2;
	fi

	cp /etc/sysconfig/network-scripts/ifcfg-bond0 /etc/sysconfig/network-scripts/ifcfg-bond0.$vlan

	sed -i "s/\(IPADDR\|NETMASK\).*/# &/" /etc/sysconfig/network-scripts/ifcfg-bond0

	sed -i "s/DEVICE=bond0/DEVICE=bond0.$vlan/" /etc/sysconfig/network-scripts/ifcfg-bond0.$vlan
	echo "VLAN=yes" >> /etc/sysconfig/network-scripts/ifcfg-bond0.$vlan
	echo "ONPARENT=yes" >> /etc/sysconfig/network-scripts/ifcfg-bond0.$vlan

	# service network restart	
}

function func_rollback_bond0()
{
	echo "File rollback..."
	rm -f /etc/sysconfig/network-scripts/ifcfg-bond0.*
	sed -i 's/# //' /etc/sysconfig/network-scripts/ifcfg-bond0	
	#service network restart
}

function func_rollback_bondX()
{
	if [ -z "$vlan" ]; then
		echo "Arguments is required!"
		echo "Input option -h to show the help!"
		exit 2;
	fi

	echo "File rollback..."
	rm -f /etc/sysconfig/network-scripts/ifcfg-bond0.$vlan
	#service network restart
}

function func_help()
{
	echo "Usage: Mgmt-vlan.sh <option> <VLAN-NAME> [IP-ADDR <>]
	-a) Add mulit bond0.X
	-b) Add bond0.X base bond0
	-c) Convert bond0 to bond0.X
	-h) show help
	-R) rollback to bond0
	-r) rollback to bond0.X(Convert to bond0.X)
	*)  show help"
}

case $1 in
	-a) func_add_baseX;;
	-b) func_add_base0;;
	-c) func_convert;;
	-h) func_help;;
	-R) func_rollback_bond0;;
	-r) func_rollback_bondX;;
	*)  func_help;;
esac
