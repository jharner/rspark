#!/bin/sh

#while true; do sleep 1000; done

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
export HIVE_HOME=/opt/hive
export HADOOP_HOME=/opt/hadoop 

sleep 10

until psql -h postgres -U hive -c 'select 1' >/dev/null 2>&1; do
	>2& echo "waiting on postgres"
	sleep 4
done

psql -h postgres -U hive -c 'select count(*) from BUCKETING_COLS' >/dev/null 2>&1
if [ $? -gt 0 ]; then
	echo "initing hive schema"
	su -lc "/opt/hive/bin/schematool -initSchema -dbType postgres" rstudio
	/opt/hive/bin/hive -S -e "create database if not exists rstudio;"
fi

/opt/hadoop/bin/hdfs dfs -chown -R rstudio:rstudio /user/hive

echo "starrting hiveserver2"

su -lc /opt/hive/bin/hiveserver2 rstudio
