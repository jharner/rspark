FROM library/ubuntu:bionic
MAINTAINER Mark Lilback <mark@lilback.com>

ARG hadoopversion=2.10.0
ARG hiveversion=2.1.1
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
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# Install HADOOP
RUN cd /opt && wget --quiet http://archive.apache.org/dist/hadoop/common/hadoop-${hadoopversion}/hadoop-${hadoopversion}.tar.gz && \
	tar zxf hadoop-${hadoopversion}.tar.gz && \
	ln -s hadoop-${hadoopversion} hadoop && \
	rm hadoop-${hadoopversion}.tar.gz && \
	mkdir -p /opt/hadoop-data; chown -R root:root /opt/hadoop-data; chmod 700 /opt/hadoop-data

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
ADD core-site.xml log4j.properties /opt/hadoop/etc/hadoop/
ADD startup.sh /
ADD hive-env.sh /etc/profile.d/
ADD hive-site.xml /opt/hive/conf/

RUN useradd -u 1000 -s /bin/bash -m -d /home/rstudio rstudio

COPY waitfor.sh /scripts/
RUN chmod 777 /scripts/waitfor.sh /startup.sh

RUN echo "export CLASSPATH=/opt/hive/jdbc/hive-jdbc-${hiveversion}-standalone.jar" >> /.bashrc && \
	echo "export JAVA_HOME=/usr/lib/jvm/adoptopenjdk-${javaversion}-hotspot-amd64" >> /.bashrc && \
	echo "export PATH=/opt/hive/bin:/opt/hadoop/bin:$PATH" >> /.bashrc && \
    echo "JAVA_HOME=/usr/lib/jvm/adoptopenjdk-${javaversion}-hotspot-amd64" >> /etc/profile && \
    . /.bashrc


CMD ["/startup.sh"]
