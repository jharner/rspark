FROM ubuntu:xenial

ARG hadoopversion=2.9.1

RUN apt-get update && apt-get install -y wget curl default-jre openssh-client openssh-server postgresql-client libpostgresql-jdbc-java vim && apt-get clean
RUN curl -s http://apache.mirrors.hoobly.com/hadoop/common/hadoop-${hadoopversion}/hadoop-${hadoopversion}.tar.gz | tar -xz -C /usr/local
RUN cd /usr/local && ln -s ./hadoop-${hadoopversion} hadoop

ENV HADOOP_PREFIX /usr/local/hadoop
ENV HADOOP_COMMON_HOME /usr/local/hadoop
ENV HADOOP_HDFS_HOME /usr/local/hadoop
ENV HADOOP_MAPRED_HOME /usr/local/hadoop
ENV HADOOP_YARN_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV JAVA_HOME /usr/lib/jvm/default-java

ADD bootstrap.sh /etc/
ADD core-site.xml hdfs-site.xml /usr/local/hadoop/etc/hadoop/
ADD log4j.properties /usr/local/hadoop/etc/hadoop/

RUN mkdir -p /scripts /opt/hadoop
ADD waitfor.sh /scripts/
RUN chmod 777 /scripts/waitfor.sh
RUN echo "StrictHostKeyChecking no\nPasswordAuthentication yes\n" >> /etc/ssh/ssh_config
RUN ssh-keygen -t rsa -P ""  -f $HOME/.ssh/id_rsa
RUN cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
RUN echo "JAVA_HOME=/usr/lib/jvm/default-java" >> /etc/profile
RUN echo "JAVA_HOME=/usr/lib/jvm/default-java" >> $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

VOLUME ["/data"]

RUN useradd -u 1000 -s /bin/bash -m -d /home/rstudio rstudio

CMD ["/etc/bootstrap.sh", "-d"]
