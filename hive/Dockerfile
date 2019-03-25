FROM library/ubuntu:xenial
MAINTAINER Mark Lilback <mark@lilback.com>

ARG hadoopversion=2.9.1
ARG hiveversion=2.1.1

RUN apt-get update && \
	apt-get install -y wget default-jre libpostgresql-jdbc-java postgresql-client && \
	apt-get clean

RUN cd /opt && wget --quiet http://archive.apache.org/dist/hadoop/common/hadoop-${hadoopversion}/hadoop-${hadoopversion}.tar.gz && \
	tar zxf hadoop-${hadoopversion}.tar.gz && \
	ln -s hadoop-${hadoopversion} hadoop && \
	rm hadoop-${hadoopversion}.tar.gz

RUN cd /opt && \
	wget --quiet http://archive.apache.org/dist/hive/hive-${hiveversion}/apache-hive-${hiveversion}-bin.tar.gz && \
	tar zxf apache-hive-${hiveversion}-bin.tar.gz && \
	ln -s apache-hive-${hiveversion}-bin hive && \
	rm apache-hive-${hiveversion}-bin.tar.gz && \
	ln -s /usr/share/java/postgresql-jdbc4.jar /opt/hive/lib/postgresql-jdbc4.jar && \
	ln -s /opt/hive/jdbc/hive-jdbc-${hiveversion}-standalone.jar /opt/hive/lib/

ADD core-site.xml log4j.properties /opt/hadoop/etc/hadoop/
ADD startup.sh /
ADD hive-env.sh /etc/profile.d/
ADD hive-site.xml /opt/hive/conf/

RUN useradd -u 1000 -s /bin/bash -m -d /home/rstudio rstudio

RUN mkdir /scripts
COPY waitfor.sh /scripts/
RUN chmod 777 /scripts/waitfor.sh

RUN echo "export CLASSPATH=/opt/hive/jdbc/hive-jdbc-${hiveversion}-standalone.jar" >> /.bashrc && \
	echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /.bashrc && \
	echo "export PATH=/opt/hive/bin:/opt/hadoop/bin:$PATH" >> /.bashrc


CMD ["/startup.sh"]
