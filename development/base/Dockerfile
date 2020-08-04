FROM ubuntu:bionic
MAINTAINER Chris Grant <chrisgrant.datascience@gmail.com>

ENV pgversion=9.6
ENV hadoopversion=2.9.2
ENV hiveversion=2.1.1
ENV sparkversion=2.4.6
ENV javaversion=8
ENV javaversion_number=1.${javaversion}.0
ENV rversion=3.6.3
ENV PGDATA /opt/pg-data
ENV PGDIR /usr/lib/postgresql/${pgversion}/bin/
ENV PGVERSION ${pgversion}
ENV HADOOP_PREFIX /opt/hadoop
ENV HADOOP_COMMON_HOME /opt/hadoop
ENV HADOOP_HDFS_HOME /opt/hadoop
ENV HADOOP_MAPRED_HOME /opt/hadoop
ENV HADOOP_YARN_HOME /opt/hadoop
ENV HADOOP_CONF_DIR /opt/hadoop/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV JAVA_HOME /usr/lib/jvm/graalvm-ce-java8-20.1.0

ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
ARG DEBIAN_FRONTEND=noninteractive
ENV HADOOP_CMD=/opt/hadoop/bin/hadoop
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_BIN=/opt/hadoop/bin
ENV HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop
ENV SPARK_VERSION 2.4.6
ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-without-hadoop
ENV SPARK_HOME /opt/spark
COPY postgresKey.asc /tmp/

RUN sed -i '/deb-src/s/^# //' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends apt-utils wget curl ca-certificates apt-transport-https ca-certificates \
                                               dirmngr gnupg software-properties-common lsb-release \
                                               gcc zlib1g-dev build-essential unzip git java-common gfortran gcc g++ && \
	apt-key add /tmp/postgresKey.asc && \
	add-apt-repository --yes 'deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main' && \
    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    gpg -a --export E298A3A825C0D65DFD57CBB651716619E084DAB9 | apt-key add - && \
    add-apt-repository -s 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' && \
    apt-get update && \
    apt-get install -y --no-install-recommends python3-software-properties python3-all-dev python3-dev python3-pip postgresql-${pgversion} postgresql-client-${pgversion} postgresql-contrib-${pgversion} libpq-dev && \
    cd /opt && \
    wget --quiet https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-20.1.0/graalvm-ce-java8-linux-amd64-20.1.0.tar.gz && \
    git clone https://github.com/chrishantha/install-java && \
    yes | ./install-java/install-java.sh -f graalvm-ce-java8-linux-amd64-20.1.0.tar.gz && \
#    source ~/.bashrc && \
    export JAVA_HOME=/usr/lib/jvm/graalvm-ce-java8-20.1.0 && \
    rm graalvm-ce-java8-linux-amd64-20.1.0.tar.gz && \
# HADOOP
    wget --quiet http://archive.apache.org/dist/hadoop/core/hadoop-${hadoopversion}/hadoop-${hadoopversion}.tar.gz && \
	tar zxf hadoop-${hadoopversion}.tar.gz && \
	mv hadoop-${hadoopversion} hadoop && \
	rm hadoop-${hadoopversion}.tar.gz && \
	(cd /opt/hadoop; ln -s share/hadoop/tools/lib/hadoop-streaming-${hadoopversion}.jar hadoop-streaming.jar) && \
# HIVE
	wget --quiet http://archive.apache.org/dist/hive/hive-${hiveversion}/apache-hive-${hiveversion}-bin.tar.gz && \
	tar zxf apache-hive-${hiveversion}-bin.tar.gz && \
	mv apache-hive-${hiveversion}-bin hive && \
	ln -s /opt/hive/jdbc/hive-jdbc-${hiveversion}-standalone.jar /opt/hive/lib/ && \
	rm apache-hive-${hiveversion}-bin.tar.gz && \
# SPARK
	wget --quiet http://archive.apache.org/dist/spark/spark-${sparkversion}/${SPARK_PACKAGE}.tgz && \
	tar zxf ${SPARK_PACKAGE}.tgz && \
	mv ${SPARK_PACKAGE} spark && \
	rm ${SPARK_PACKAGE}.tgz && \
	cp spark/conf/spark-env.sh.template spark/conf/spark-env.sh && \
	wget --quiet https://jdbc.postgresql.org/download/postgresql-42.2.14.jar && \
	echo "export SPARK_DIST_CLASSPATH=/opt/postgresql-42.2.14.jar:$(/opt/hadoop/bin/hadoop classpath)" >> spark/conf/spark-env.sh && \
    apt-get install -y --no-install-recommends r-base-dev r-recommended && \
    R CMD javareconf && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*




#      apt-get install apt-utils apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common  apt-utils apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common tzdata gpg file libexpat1 libmagic-mgc libmagic1 libmpdec2 libreadline7 libsqlite3-0 libssl1.1 mime-support readline-common xz-utils  && \

#   apt-transport-https apt-utils ca-certificates dirmngr gnupg gnupg-l10n gnupg-utils gpg gpg-agent gpg-wks-client gpg-wks-server gpgconf gpgsm libapt-inst2.0
  #  libasn1-8-heimdal libassuan0 libgssapi3-heimdal libhcrypto4-heimdal libheimbase1-heimdal libheimntlm0-heimdal libhx509-5-heimdal libkrb5-26-heimdal libksba8
  #  libldap-2.4-2 libldap-common libnpth0 libpsl5 libreadline7 libroken18-heimdal libsasl2-2 libsasl2-modules-db libsqlite3-0 libssl1.1 libwind0-heimdal openssl
  #  pinentry-curses readline-common wget