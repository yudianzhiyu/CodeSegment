#!/bin/bash 
ip=$1

function chbootmode()
{
        ip=$1
        expect  -c "
                spawn  ssh -f   root@${ip} racadm config -g cfgIpmiLan -o cfgIpmiLanEnable 1  ;
                set timeout 9;
                expect {
                        \"*continue*\"  { send  \"yes\r\"   ; exp_continue  } 
                        \"*assword*\" {send  \"calvin\r\" ; exp_continue}
                }
        "
        echo  
        expect -c "
                spawn  ssh  -f  root@${ip} racadm jobqueue create BIOS.Setup.1-1 ;
                set timeout 9;
                expect {
                        \"*continue*\"  { send  \"yes\r\"   ; exp_continue  } 
                        \"*assword*\" {send  \"calvin\r\"; exp_continue}
                }
        "
        echo 
}

chbootmode $1
