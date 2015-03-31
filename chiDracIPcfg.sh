#!/bin/bash

#newip=`awk '/id:/ {print $2}' /etc/salt/minion |sed "s/172.23.32./10.23.30./"`
newip=`awk '/id:/ {print $2}' /etc/salt/minion |sed "s/172.24.33./10.23.57./"`
ipmitool  -I open lan  set 1 ipaddr  $newip    
ipmitool  -I open lan  set 1 netmask 255.255.254.0 
ipmitool  -I open lan  set 1 defgw ipaddr 10.23.57.254
#ipmitool -H $oldip -U root -P calvin -I lanplus lan   set ipaddr  $newip    netmask 255.255.254.0 defgw 10.23.57.254

