FROM base-image:bionic
MAINTAINER Mark Lilback <mark@lilback.com>

ARG hadoopversion=2.10.0
ARG hiveversion=2.1.1
ARG javaversion=8
ARG pgversion=12

ENV HIVE_HOME /opt/hive

RUN cd /opt && \
	wget --quiet http://archive.apache.org/dist/hive/hive-${hiveversion}/apache-hive-${hiveversion}-bin.tar.gz && \
	tar zxf apache-hive-${hiveversion}-bin.tar.gz && \
	ln -s apache-hive-${hiveversion}-bin hive && \
	ln -s /usr/share/java/postgresql-jdbc4.jar /opt/hive/lib/postgresql-jdbc4.jar && \
	ln -s /opt/hive/jdbc/hive-jdbc-${hiveversion}-standalone.jar /opt/hive/lib/ && \
	rm apache-hive-${hiveversion}-bin.tar.gz && \
	chown -R root:root /opt/hive && \
	mkdir /opt/hive-data && \
    mkdir /scripts && \
    chown -R root:root /opt/hive-data && \
    chmod 700 /opt/hive-data

# Set Configuration for Hive service.
ADD entrypoint-hive.sh /entrypoint
ADD hive-env.sh /etc/profile.d/
ADD hive-site.xml /opt/hive/conf/
COPY waitfor.sh /scripts/

RUN useradd -u 1000 -s /bin/bash -m -d /home/rstudio rstudio && \
    chmod 777 /scripts/waitfor.sh && \
    echo "CLASSPATH=/opt/hive/jdbc/hive-jdbc-${hiveversion}-standalone.jar" >> /.bashrc && \
    echo "PATH='/opt/hive/bin:$PATH'" >> /etc/profile && \
    export PATH=/opt/hive/bin:$PATH && \
	echo "PATH=/opt/hive/bin:$PATH" >> /.bashrc && \
    . /.bashrc

