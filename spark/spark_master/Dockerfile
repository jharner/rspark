FROM ubuntu:bionic
MAINTAINER Jim Harner <ejharner@gmail.com>

ARG hadoopversion=2.9.2
ARG hiveversion=2.1.1
ARG sparkversion=2.4.4
ARG javaversion=8
ARG javaversion_number=1.${javaversion}.0

RUN apt-get update && \
    apt-get install -y locales && \
    dpkg-reconfigure -f noninteractive locales && \
    locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8 && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# Users with other locales should set this in their derivative image
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
# Install Python 3
RUN apt-get update && \
    apt-get install -y curl unzip python3 python3-setuptools python3-pip && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    python -m pip install py4j && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# http://blog.stuart.axelbrooke.com/python-3-on-spark-return-of-the-pythonhashseed
ENV PYTHONHASHSEED 0
ENV PYTHONIOENCODING UTF-8
ENV PIP_DISABLE_PIP_VERSION_CHECK 1
# JAVA
RUN apt-get update && \
	apt-get install -y  apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common && \
	wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - && \
	add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ && \
	apt-get update && \
	apt-get install -y adoptopenjdk-8-hotspot && \
	update-java-alternatives -s /usr/lib/jvm/adoptopenjdk-8-hotspot-amd64 && \
	apt-get clean && \
    rm -rf /var/lib/apt/lists/*
#ARG JAVA_MAJOR_VERSION=8
#ARG JAVA_UPDATE_VERSION=131
#ARG JAVA_BUILD_NUMBER=11
#ENV JAVA_HOME /usr/jdk1.${JAVA_MAJOR_VERSION}.0_${JAVA_UPDATE_VERSION}

#ENV PATH $PATH:$JAVA_HOME/bin
#RUN curl -sL --retry 3 --insecure \
#  --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
#  "http://download.oracle.com/otn-pub/java/jdk/${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-b${JAVA_BUILD_NUMBER}/d54c1d3a095b4ff2b6607d096fa80163/server-jre-${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-linux-x64.tar.gz" \
#  | gunzip \
#  | tar x -C /usr/ \
#  && ln -s $JAVA_HOME /usr/java \
#  && rm -rf $JAVA_HOME/man
####################
# HADOOP
####################
ENV HADOOP_VERSION 2.9.2
ENV HADOOP_HOME /usr/hadoop-${HADOOP_VERSION}
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/etc/hadoop
ENV PATH ${HADOOP_HOME}/bin:${PATH}
ENV HADOOP_CMD ${HADOOP_HOME}/bin/hadoop
ENV HADOOP_BIN ${HADOOP_HOME}/bin
RUN curl -sL --retry 3 \
"http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" \
  | gunzip \
  | tar -x -C /usr/ \
 && rm -rf $HADOOP_HOME/share/doc \
 && chown -R root:root $HADOOP_HOME

# SPARK
ENV SPARK_VERSION 2.4.4
ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-without-hadoop
ENV SPARK_HOME /usr/spark-${SPARK_VERSION}
ENV SPARK_DIST_CLASSPATH "${HADOOP_HOME}/etc/hadoop/*:${HADOOP_HOME}/share/hadoop/common/lib/*:${HADOOP_HOME}/share/hadoop/common/*:${HADOOP_HOME}/share/hadoop/hdfs/*:${HADOOP_HOME}/share/hadoop/hdfs/lib/*:${HADOOP_HOME}/share/hadoop/hdfs/*:${HADOOP_HOME}/share/hadoop/yarn/lib/*:${HADOOP_HOME}/share/hadoop/yarn/*:${HADOOP_HOME}/share/hadoop/mapreduce/lib/*:${HADOOP_HOME}/share/hadoop/mapreduce/*:${HADOOP_HOME}/share/hadoop/tools/lib/*"
ENV PATH ${SPARK_HOME}/bin:${PATH}
RUN curl -sL --retry 3 \
  "http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_PACKAGE}.tgz" \
  | gunzip \
  | tar x -C /usr/ \
 && mv /usr/$SPARK_PACKAGE $SPARK_HOME \
 && chown -R root:root $SPARK_HOME
## Use Debian unstable via pinning -- new style via APT::Default-Release
#RUN echo "deb http://http.debian.net/debian sid main" > /etc/apt/sources.list.d/debian-unstable.list \
#    && echo 'APT::Default-Release "testing";' > /etc/apt/apt.conf.d/default
ENV R_BASE_VERSION 3.6.3
ARG DEBIAN_FRONTEND=noninteractive
RUN gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    gpg -a --export E298A3A825C0D65DFD57CBB651716619E084DAB9 | apt-key add - && \
    add-apt-repository -s 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' && \
## Now install R and littler, and create a link for littler in /usr/local/bin
## Also set a default CRAN repo, and make sure littler knows about it too
    apt-get update && \
###     apt-get install -y --no-install-recommends littler r-cran-littler r-base-${R_BASE_VERSION} r-base-dev-${R_BASE_VERSION} r-recommended=${R_BASE_VERSION} && \
    apt-get install -y --no-install-recommends littler r-cran-littler r-base r-base-dev r-recommended && \
    echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site && \
    echo 'source("/etc/R/Rprofile.site")' >> /etc/littler.r && \
    ln -s /usr/share/doc/littler/examples/install.r /usr/local/bin/install.r && \
    ln -s /usr/share/doc/littler/examples/install2.r /usr/local/bin/install2.r && \
    ln -s /usr/share/doc/littler/examples/installGithub.r /usr/local/bin/installGithub.r && \
    ln -s /usr/share/doc/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r && \
    install.r docopt && \
    rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR $SPARK_HOME
CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]

EXPOSE 7077
EXPOSE 8080
EXPOSE 8081
EXPOSE 4040



