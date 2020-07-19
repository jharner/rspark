FROM library/ubuntu:bionic
MAINTAINER Mark Lilback <mark@lilback.com>

ARG hadoopversion=2.9.2
ARG hiveversion=2.1.1
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

#RUN apt-get update && \
#	apt-get install -y apt-utils wget openjdk-${javaversion}-jdk libpostgresql-jdbc-java postgresql-client && \
#	update-java-alternatives -s /usr/lib/jvm/java-${javaversion_number}-openjdk-amd64 && \
#	apt-get clean

RUN cd /opt && wget --quiet http://archive.apache.org/dist/hadoop/common/hadoop-${hadoopversion}/hadoop-${hadoopversion}.tar.gz && \
	tar zxf hadoop-${hadoopversion}.tar.gz && \
	ln -s hadoop-${hadoopversion} hadoop && \
	rm hadoop-${hadoopversion}.tar.gz

RUN cd /opt && \
	wget --quiet http://archive.apache.org/dist/hive/hive-${hiveversion}/apache-hive-${hiveversion}-bin.tar.gz && \
	tar zxf apache-hive-${hiveversion}-bin.tar.gz && \
	ln -s apache-hive-${hiveversion}-bin hive && \
	ln -s /usr/share/java/postgresql-jdbc4.jar /opt/hive/lib/postgresql-jdbc4.jar && \
	ln -s /opt/hive/jdbc/hive-jdbc-${hiveversion}-standalone.jar /opt/hive/lib/ && \
	rm apache-hive-${hiveversion}-bin.tar.gz

ADD core-site.xml log4j.properties /opt/hadoop/etc/hadoop/
ADD startup.sh /
ADD hive-env.sh /etc/profile.d/
ADD hive-site.xml /opt/hive/conf/

RUN useradd -u 1000 -s /bin/bash -m -d /home/rstudio rstudio

RUN mkdir /scripts
COPY waitfor.sh /scripts/
RUN chmod 777 /scripts/waitfor.sh

RUN echo "export CLASSPATH=/opt/hive/jdbc/hive-jdbc-${hiveversion}-standalone.jar" >> /.bashrc && \
	echo "export JAVA_HOME=/usr/lib/jvm/adoptopenjdk-8-hotspot-amd64" >> /.bashrc && \
	echo "export PATH=/opt/hive/bin:/opt/hadoop/bin:$PATH" >> /.bashrc && \
    echo "JAVA_HOME=/usr/lib/jvm/adoptopenjdk-8-hotspot-amd64" >> /etc/profile


CMD ["/startup.sh"]
