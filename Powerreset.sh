#!/bin/bash 
ip=$1

function powerreset()
{
        ip=$1
        expect  -c "
                spawn  ssh -f   root@${ip}  racadm serveraction hardreset;
                set timeout 31;
                expect {
                        \"*assword*\" {send  \"calvin\r\" ; exp_continue}
                }
        "
        echo  
}

powerreset $1
