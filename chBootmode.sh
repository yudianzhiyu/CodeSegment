#!/bin/bash 
ip=$1

function chbootmode()
{
        ip=$1
        expect  -c "
                spawn  ssh -f   root@${ip} racadm set BIOS.BiosBootSettings.BootMode Bios ;
                set timeout 31;
                expect {
                        \"*assword*\" {send  \"calvin\r\" ; exp_continue}
                }
        "
        echo  
        expect -c "
                spawn  ssh  -f  root@${ip} racadm jobqueue create BIOS.Setup.1-1 ;
                set timeout 30;
                expect {
                        \"*assword*\" {send  \"calvin\r\"; exp_continue}
                }
        "
        echo 
}

chbootmode $1
