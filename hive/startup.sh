#!/bin/bash

#while true; do sleep 1000; done

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
export HIVE_HOME=/opt/hive
export HADOOP_HOME=/opt/hadoop 
export HADOOP=/opt/hadoop/bin/hadoop

sleep 25

echo "** Checking Postgres Connection **"
/scripts/waitfor.sh -h postgres -p 5432 -t 120

# Add code to more effectively wait on hadoop
sleep 50

psql -h postgres -U hive -c 'select count(*) from BUCKETING_COLS' >/dev/null 2>&1
if [ $? -gt 0 ]; then
	echo "initing hive schema"
	su -lc "/opt/hive/bin/schematool -initSchema -dbType postgres" rstudio
	/opt/hive/bin/hive -S -e "create database if not exists rstudio;"
fi

/opt/hadoop/bin/hdfs dfs -chown -R rstudio:rstudio /user/hive

echo "starting hiveserver2"

su -lc /opt/hive/bin/hiveserver2 rstudio
