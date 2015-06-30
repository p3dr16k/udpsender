#!/bin/bash
#===============================================================================
#
#          FILE:  udpsender.sh
# 
#         USAGE:  ./udpsender.sh ipaddress port concurrency interval file
# 
#   DESCRIPTION:  It sends udp packets for test purposes.  
#				  Each line of the specified files becomes a payload for
#				  a packets.
#      
#  REQUIREMENTS:  GNU Netcat, GNU bc
#        AUTHOR:  Patrick Facco (facco@csp.it), 
#       COMPANY:  CSP s.c. a r.l. "Innovazione nelle ICT"
#       VERSION:  1.0
#       CREATED:  26/06/2015 17:02:51 CEST
#      LICENSE:   GNU/GPLv3
#===============================================================================

IPADDRESS=$1
PORT=$2
CONCURRENCY=$3
INTERVAL=$4
FILE=$5
extraparam="-w1"

if [ xLinux = x$(uname) ]
then 
	extraparam="-q1"
fi


if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters"
    echo "launch " $0 " ipaddress port concurrency interval file"
    exit
fi

echo parameters: $IPADDRESS $PORT $CONCURRENCY $INTERVAL $FILE

#save lines in array
declare -a rowsasarray
j=0
for i in $(cat $FILE)
do
	rowsasarray[$j]=$i
	let "j++"
done

z=0
while [ true ]
do
	k=0
	while [ $k -le $CONCURRENCY ]
	do		
		(echo -n ${rowsasarray[$z]} | nc -4u $extraparam $IPADDRESS $PORT)&
		sleep $INTERVAL
		let "k++"		
		let "z=(z+1)%${#rowsasarray[@]}"
		echo $z
	done	
done

