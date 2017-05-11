FROM library/ubuntu:xenial
MAINTAINER Mark Lilback <mark@lilback.com>

RUN apt-get update && \
	apt-get install -y wget default-jre libpostgresql-jdbc-java postgresql-client && \
	apt-get clean

RUN cd /opt && wget --quiet http://apache.mirrors.hoobly.com/hadoop/common/hadoop-2.7.1/hadoop-2.7.1.tar.gz && \
	tar zxf hadoop-2.7.1.tar.gz && \
	ln -s hadoop-2.7.1 hadoop && \
	rm hadoop-2.7.1.tar.gz

RUN cd /opt && \
	wget --quiet http://apache.mirrors.hoobly.com/hive/hive-2.1.1/apache-hive-2.1.1-bin.tar.gz && \
	tar zxf apache-hive-2.1.1-bin.tar.gz && \
	ln -s apache-hive-2.1.1-bin hive && \
	rm apache-hive-2.1.1-bin.tar.gz && \
	ln -s /usr/share/java/postgresql-jdbc4.jar /opt/hive/lib/postgresql-jdbc4.jar && \
	ln -s /opt/hive/jdbc/hive-jdbc-2.1.1-standalone.jar /opt/hive/lib/

ADD core-site.xml /opt/hadoop/etc/hadoop/
ADD startup.sh /
ADD hive-env.sh /etc/profile.d/
ADD hive-site.xml /opt/hive/conf/

RUN useradd -u 1000 -s /bin/bash -m -d /home/rstudio rstudio

RUN echo "export CLASSPATH=/opt/hive/jdbc/hive-jdbc-2.1.1-standalone.jar" >> /.bashrc && \
	echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /.bashrc && \
	echo "export PATH=/opt/hive/bin:/opt/hadoop/bin:$PATH" >> /.bashrc


CMD ["/startup.sh"]
