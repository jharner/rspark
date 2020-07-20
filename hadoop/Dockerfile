FROM ubuntu:bionic

ARG hadoopversion=2.9.2
ARG javaversion=8
ARG javaversion_number=1.${javaversion}.0

COPY postgresKey.asc openjdkKey.asc /tmp/
RUN apt-get update && \
    apt-get install -y apt-utils apt-transport-https ca-certificates dirmngr gnupg wget curl software-properties-common && \
    apt-key add /tmp/postgresKey.asc && \
    apt-key add /tmp/openjdkKey.asc && \
    add-apt-repository --yes 'deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main' && \
	add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ && \
	apt-get update && \
    apt-get install --no-install-recommends -y postgresql-client-${pgversion} openssh-client openssh-server libpostgresql-jdbc-java libicu-dev adoptopenjdk-8-hotspot && \
    update-java-alternatives -s adoptopenjdk-8-hotspot-amd64 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN curl -s http://archive.apache.org/dist/hadoop/core/hadoop-${hadoopversion}/hadoop-${hadoopversion}.tar.gz | tar -xz -C /usr/local
RUN cd /usr/local && ln -s ./hadoop-${hadoopversion} hadoop

ENV HADOOP_PREFIX /usr/local/hadoop
ENV HADOOP_COMMON_HOME /usr/local/hadoop
ENV HADOOP_HDFS_HOME /usr/local/hadoop
ENV HADOOP_MAPRED_HOME /usr/local/hadoop
ENV HADOOP_YARN_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV JAVA_HOME /usr/lib/jvm/adoptopenjdk-8-hotspot-amd64

ADD bootstrap.sh /etc/
ADD core-site.xml hdfs-site.xml /usr/local/hadoop/etc/hadoop/
ADD log4j.properties /usr/local/hadoop/etc/hadoop/

RUN mkdir -p /scripts /opt/hadoop
ADD waitfor.sh /scripts/
RUN chmod 777 /scripts/waitfor.sh
RUN echo "StrictHostKeyChecking no\nPasswordAuthentication yes\n" >> /etc/ssh/ssh_config
RUN ssh-keygen -t rsa -P ""  -f $HOME/.ssh/id_rsa
RUN cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
RUN echo "JAVA_HOME=/usr/lib/jvm/adoptopenjdk-8-hotspot-amd64" >> /etc/profile
RUN echo "JAVA_HOME=/usr/lib/jvm/adoptopenjdk-8-hotspot-amd64" >> $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

VOLUME ["/data"]

RUN useradd -u 1000 -s /bin/bash -m -d /home/rstudio rstudio

CMD ["/etc/bootstrap.sh", "-d"]

EXPOSE 9000
EXPOSE 8088
EXPOSE 50070
EXPOSE 50075