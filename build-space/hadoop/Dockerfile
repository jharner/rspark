FROM base-image:bionic
MAINTAINER Chris Grant <chrisgrant.datascience@gmail.com>

ARG hadoopversion=2.10.0
ARG javaversion=8
ARG pgversion=12

ENV HADOOP_PREFIX /opt/hadoop
ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_COMMON_HOME ${HADOOP_HOME}
ENV HADOOP_HDFS_HOME ${HADOOP_HOME}
ENV HADOOP_MAPRED_HOME ${HADOOP_HOME}
ENV HADOOP_YARN_HOME ${HADOOP_HOME}
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/etc/hadoop
ENV YARN_CONF_DIR ${HADOOP_HOME}/etc/hadoop
ENV JAVA_HOME /usr/lib/jvm/adoptopenjdk-8-hotspot-amd64

ENV PATH=/opt/hadoop/bin:$PATH

RUN curl -s http://archive.apache.org/dist/hadoop/core/hadoop-${hadoopversion}/hadoop-${hadoopversion}.tar.gz | tar -xz -C /opt && \
    cd /opt && \
    ln -s ./hadoop-${hadoopversion} hadoop && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD core-site.xml hdfs-site.xml ${HADOOP_HOME}/etc/hadoop/
ADD log4j.properties ${HADOOP_HOME}/etc/hadoop/

RUN mkdir -p /scripts /opt/hadoop && \
    mkdir -p /opt/hadoop-data && \
    chown -R root:root /opt/hadoop-data && \
    chmod -R 700 /opt/hadoop-data

ADD waitfor.sh /scripts/ 
ADD entrypoint-hadoop.sh /entrypoint

RUN chmod 777 /scripts/waitfor.sh && \
    echo "StrictHostKeyChecking no\nPasswordAuthentication yes\n" >> /etc/ssh/ssh_config && \
    ssh-keygen -t rsa -P ""  -f $HOME/.ssh/id_rsa && \
    cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys && \
    echo "JAVA_HOME=/usr/lib/jvm/adoptopenjdk-${javaversion}-hotspot-amd64" >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh && \
    echo "PATH='/opt/hadoop/bin:$PATH'" >> /etc/profile && \
    export PATH=/opt/hadoop/bin:$PATH && \
    echo "PATH='/opt/hadoop/bin:$PATH'" >> /.bashrc && \
    . /.bashrc && \
    useradd -u 1000 -s /bin/bash -m -d /home/rstudio rstudio
