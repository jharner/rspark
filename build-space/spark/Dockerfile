FROM rhive:2.1.1
MAINTAINER Jim Harner <ejharner@gmail.com>

ARG hadoopversion=2.10.0
ARG hiveversion=2.1.1
ARG sparkversion=3.0.0
ARG javaversion=8
ARG pgversion=12
ARG DEBIAN_FRONTEND=noninteractive

ENV SPARK_VERSION 3.0.0
ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-without-hadoop
ENV SPARK_HOME /opt/spark
ENV SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*"

## HADOOP
RUN (cd /opt/hadoop; ln -s share/hadoop/tools/lib/hadoop-streaming-${hadoopversion}.jar hadoop-streaming.jar)
## SPARK
RUN cd /opt  && \
	wget --quiet http://archive.apache.org/dist/spark/spark-${sparkversion}/${SPARK_PACKAGE}.tgz  && \
	tar zxvf ${SPARK_PACKAGE}.tgz  && \
	mv ${SPARK_PACKAGE} spark  && \
	rm ${SPARK_PACKAGE}.tgz  && \
    mkdir /opt/spark-data && \
    chown -R root:root /opt/spark-data && \
	cp /opt/spark/conf/spark-env.sh.template /opt/spark/conf/spark-env.sh && \
	echo 'export SPARK_DIST_CLASSPATH=/opt/postgresql-42.2.14.jar:$(/opt/hadoop/bin/hadoop classpath)' >> /opt/spark/conf/spark-env.sh && \
    mkdir /entrypoint && \
    chown -R root:root $SPARK_HOME && \
    echo "PATH='/opt/spark/bin:$PATH'" >> /etc/profile && \
    export PATH=/opt/spark/bin:$PATH && \
    echo "PATH='/opt/spark/bin:$PATH'" >> /.bashrc && \
    . /.bashrc
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

ADD entrypoint-spark-master.sh /entrypoint
ADD entrypoint-spark-worker.sh /entrypoint

#WORKDIR $SPARK_HOME
#CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]
#
#EXPOSE 7077
#EXPOSE 8080



