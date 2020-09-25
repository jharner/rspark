FROM ubuntu:bionic

ARG hadoopversion=2.10.0
ARG javaversion=8
ARG pgversion=12

COPY postgresKey.asc openjdkKey.asc /tmp/
RUN apt-get update && \
    apt-get install -y apt-utils apt-transport-https ca-certificates dirmngr gnupg wget curl software-properties-common && \
    apt-key add /tmp/postgresKey.asc && \
    apt-key add /tmp/openjdkKey.asc && \
    add-apt-repository --yes 'deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main' && \
	add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ && \
	apt-get update && \
    apt-get install --no-install-recommends -y postgresql-client-${pgversion} openssh-client openssh-server libpostgresql-jdbc-java libicu-dev adoptopenjdk-${javaversion}-hotspot && \
    update-java-alternatives -s adoptopenjdk-${javaversion}-hotspot-amd64 && \
    curl -s http://archive.apache.org/dist/hadoop/core/hadoop-${hadoopversion}/hadoop-${hadoopversion}.tar.gz | tar -xz -C /opt && \
    cd /opt && \
    ln -s ./hadoop-${hadoopversion} hadoop && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


ENV HADOOP_PREFIX /opt/hadoop
ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_COMMON_HOME ${HADOOP_HOME}
ENV HADOOP_HDFS_HOME ${HADOOP_HOME}
ENV HADOOP_MAPRED_HOME ${HADOOP_HOME}
ENV HADOOP_YARN_HOME ${HADOOP_HOME}
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/etc/hadoop
ENV YARN_CONF_DIR ${HADOOP_HOME}/etc/hadoop
ENV JAVA_HOME /usr/lib/jvm/adoptopenjdk-8-hotspot-amd64

ADD bootstrap.sh /etc/
ADD core-site.xml hdfs-site.xml ${HADOOP_HOME}/etc/hadoop/
ADD log4j.properties ${HADOOP_HOME}/etc/hadoop/

RUN mkdir -p /scripts /opt/hadoop && \
    mkdir /entrypoint && \
    mkdir -p /opt/hadoop-data && \
    chown -R root:root /opt/hadoop-data && \
    chmod -R 700 /opt/hadoop-data
ADD waitfor.sh /scripts/ 
ADD entrypoint-hadoop.sh /entrypoint
RUN chmod 777 /scripts/waitfor.sh && \
    echo "StrictHostKeyChecking no\nPasswordAuthentication yes\n" >> /etc/ssh/ssh_config && \
    ssh-keygen -t rsa -P ""  -f $HOME/.ssh/id_rsa && \
    cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys && \
    echo "JAVA_HOME=/usr/lib/jvm/adoptopenjdk-${javaversion}-hotspot-amd64" >> /etc/profile && \
    echo "JAVA_HOME=/usr/lib/jvm/adoptopenjdk-${javaversion}-hotspot-amd64" >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh && \
    useradd -u 1000 -s /bin/bash -m -d /home/rstudio rstudio

VOLUME ["/data"]


#CMD ["/etc/bootstrap.sh", "-d"]
#
#EXPOSE 9000
#EXPOSE 8088
#EXPOSE 50070
#EXPOSE 50075