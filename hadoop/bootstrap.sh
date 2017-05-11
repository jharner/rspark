#!/bin/bash

: ${HADOOP_PREFIX:=/usr/local/hadoop}

$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
DATA_DIR=/opt/hadoop

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

# altering the core-site configuration
#sed s/HOSTNAME/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml

if [[ ! -d ${DATA_DIR} ]]; then
	echo "hadoop data directory missing (${DATA_DIR})"
	exit 1
fi

service sshd start

chown -R rstudio ${DATA_DIR}

echo "as rstudio using hadoop ${HADOOP_PREFIX}"
CREATEDIR=0
if [[ ! -d /${DATA_DIR}/nn ]]; then
	rm -rf /${DATA_DIR}/nn /${DATA_DIR}/dfs
	echo "running namenode init"
	/usr/local/hadoop/bin/hdfs namenode -format -force
	CREATEDIR=1
fi

$HADOOP_PREFIX/sbin/start-dfs.sh
$HADOOP_PREFIX/sbin/start-yarn.sh

#add hadoop bin directory to path
PATH=/usr/local/hadoop/bin:$PATH
#if we initialized namenode's file system, create default paths
if [[ $CREATEDIR == 1 ]]; then
	sleep 2
	echo "creating hdfs directory structure"
	for aPath in /tmp /user; do
		hdfs dfs -test -d hdfs://127.0.0.1:9000/$aPath
		if [ $? == 1 ]; then
			hdfs dfs -mkdir -p $aPath
			hdfs dfs -chown rstudio:rstudio $aPath
			hdfs dfs -chmod 777 $aPath
		fi
	done
	echo "hdfs setup complete"
fi

hdfs dfs -test -d hdfs://127.0.0.1:9000/rstudio
if [ $? == 1 ]; then
	hdfs dfs -mkdir -p /user/rstudio
	hdfs dfs -chown rstudio:rstudio /user/rstudio
	hdfs dfs -chmod 777 /user/rstudio
fi

hdfs dfs -test -d hdfs://127.0.0.1:9000/hive
if [ $? == 1 ]; then
	hdfs dfs -mkdir -p /user/hive
	hdfs dfs -chown rstudio:rstudio /user/hive
	hdfs dfs -chmod 777 /user/hive
fi

if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
