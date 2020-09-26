#!/bin/bash

count=0
hcmd="/opt/hadoop/bin/hadoop fs -ls /"
$hcmd &> /dev/null
while [ $? -ne 0 ]; do
	echo "trying again"
	$hcmd 2> /dev/null
	count=$((count+1))
	if [ $count -gt 4 ]; then
		echo "failed to connect to hadoop"
		exit -1
	fi
done
echo "continuing startup"
exec /init
