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
#  REQUIREMENTS:  GNU Netcat
#        AUTHOR:  Patrick Facco (facco@csp.it), 
#       COMPANY:  CSP s.c. a r.l. "Innovazione nelle ICT"
#       VERSION:  1.0
#       CREATED:  26/06/2015 17:02:51 CEST
#      LICENSE:      GNU/GPLv3
#===============================================================================

IPADDRESS=$1
PORT=$2
CONCURRENCY=$3
INTERVAL=$4
FILE=$5

if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters"
    echo "launch " $0 " ipaddress port concurrency interval file"
    exit
fi

echo parameters: $IPADDRESS $PORT $CONCURRENCY $INTERVAL $FILE

#save line in array
declare -a rowsasarray
j=0
for i in $(cat $FILE)
do
	rowsasarray[$j]=$i
	let "j++"
done

while [ true ]
do
	k=0
	while [ $k -lt $CONCURRENCY ]
	do
		randomindex=$(echo "$RANDOM %${#rowsasarray[@]} " | bc)
		(echo -n ${rowsasarray[$randomindex]} | nc -4u -q1 $IPADDRESS $PORT)&
		sleep $INTERVAL
		let "k++"		
	done	
done

