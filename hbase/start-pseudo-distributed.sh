#!/bin/bash

count=0
#hcmd="/opt/hbase/bin/hadoop fs -ls /"
hcmd="java -jar /opt/testConnection.jar hdfs://hadoop:9000/"
echo "testing hadoop connection"
$hcmd &> /dev/null
result=$?
while [ $result -ne 0 ]; do
	sleep 5
	echo "trying hadoop connection again"
	$hcmd #2> /dev/null
	result=$?
	count=$((count+1))
	if [ $count -gt 4 ]; then
		echo "failed to connect to hadoop 5 times, bailing"
		exit -1
	fi
done
echo "supposedly hadoop connect success ($result)"

/opt/hbase/bin/hbase zookeeper > logzoo.log 2>&1 &
/opt/hbase/bin/hbase regionserver start > logregion.log 2>&1 &

/opt/hbase/bin/hbase thrift start &
/opt/hbase/bin/hbase master start --localRegionServers=0
