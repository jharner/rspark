
FROM ubuntu:bionic
MAINTAINER Jim Harner <ejharner@gmail.com>

ARG hadoopversion=2.9.2
ARG hiveversion=2.1.1
ARG sparkversion=2.4.6
ARG javaversion=8
ARG javaversion_number=1.${javaversion}.0
# Users with other locales should set this in their derivative image
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
# http://blog.stuart.axelbrooke.com/python-3-on-spark-return-of-the-pythonhashseed
ENV PYTHONHASHSEED 0
ENV PYTHONIOENCODING UTF-8
ENV PIP_DISABLE_PIP_VERSION_CHECK 1
ENV HADOOP_VERSION hadoopversion
ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/etc/hadoop
ENV PATH ${HADOOP_HOME}/bin:${PATH}
ENV HADOOP_CMD ${HADOOP_HOME}/bin/hadoop
ENV HADOOP_BIN ${HADOOP_HOME}/bin
ENV SPARK_VERSION sparkversion
ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-without-hadoop
ENV SPARK_HOME /opt/spark
ENV SPARK_DIST_CLASSPATH "${HADOOP_HOME}/etc/hadoop/*:${HADOOP_HOME}/share/hadoop/common/lib/*:${HADOOP_HOME}/share/hadoop/common/*:${HADOOP_HOME}/share/hadoop/hdfs/*:${HADOOP_HOME}/share/hadoop/hdfs/lib/*:${HADOOP_HOME}/share/hadoop/hdfs/*:${HADOOP_HOME}/share/hadoop/yarn/lib/*:${HADOOP_HOME}/share/hadoop/yarn/*:${HADOOP_HOME}/share/hadoop/mapreduce/lib/*:${HADOOP_HOME}/share/hadoop/mapreduce/*:${HADOOP_HOME}/share/hadoop/tools/lib/*"
ENV PATH ${SPARK_HOME}/bin:${PATH}
ENV R_BASE_VERSION 3.6.3
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y locales && \
    dpkg-reconfigure -f noninteractive locales && \
    locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8 && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen && \
# Install Python 3
    apt-get install -y --no-install-recommends curl unzip python3 python3-setuptools python3-pip apt-utils wget ca-certificates apt-transport-https dirmngr gnupg software-properties-common lsb-release && \
    ln -s /usr/bin/python3 /usr/bin/python && \
# JAVA
	wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - && \
	add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ && \
	apt-get update && \
	apt-get install -y adoptopenjdk-8-hotspot && \
	update-java-alternatives -s /usr/lib/jvm/adoptopenjdk-8-hotspot-amd64 && \
	cd /opt && \
    wget https://apache.bintray.com/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-archive-keyring-latest-$(lsb_release --codename --short).deb && \
    apt-get install -y -V ./apache-arrow-archive-keyring-latest-$(lsb_release --codename --short).deb && \
    apt-get update && \
    apt-get install -y -V libarrow-dev libarrow-glib-dev libarrow-dataset-dev libarrow-flight-dev libplasma-dev libplasma-glib-dev libgandiva-dev libgandiva-glib-dev libparquet-dev libparquet-glib-dev && \
    rm ./apache-arrow-archive-keyring-latest-$(lsb_release --codename --short).deb && \
    python -m pip install py4j pyarrow && \
	apt-get clean && \
    rm -rf /var/lib/apt/lists/*
####################
# HADOOP
####################
RUN cd /opt && \
    wget --quiet http://archive.apache.org/dist/hadoop/core/hadoop-${hadoopversion}/hadoop-${hadoopversion}.tar.gz && \
	tar zxf hadoop-${hadoopversion}.tar.gz && \
	mv hadoop-${hadoopversion} hadoop && \
    rm -rf $HADOOP_HOME/share/doc  && \
	rm hadoop-${hadoopversion}.tar.gz && \
	(cd /opt/hadoop; ln -s share/hadoop/tools/lib/hadoop-streaming-${hadoopversion}.jar hadoop-streaming.jar) && \
    chown -R root:root $HADOOP_HOME && \
####################
# HIVE
####################
    cd /opt && \
	wget --quiet http://archive.apache.org/dist/hive/hive-${hiveversion}/apache-hive-${hiveversion}-bin.tar.gz && \
	tar zxf apache-hive-${hiveversion}-bin.tar.gz && \
	ln -s apache-hive-${hiveversion}-bin hive && \
	ln -s /opt/hive/jdbc/hive-jdbc-${hiveversion}-standalone.jar /opt/hive/lib/ && \
	rm apache-hive-${hiveversion}-bin.tar.gz && \
# SPARK
    cd /opt && \
	wget --quiet http://archive.apache.org/dist/spark/spark-${sparkversion}/${SPARK_PACKAGE}.tgz && \
	tar zxf ${SPARK_PACKAGE}.tgz && \
	mv ${SPARK_PACKAGE} spark && \
	rm ${SPARK_PACKAGE}.tgz && \
	cp spark/conf/spark-env.sh.template spark/conf/spark-env.sh && \
	echo "export SPARK_DIST_CLASSPATH=/opt/postgresql-42.2.2.jar:$(/opt/hadoop/bin/hadoop classpath)" >> spark/conf/spark-env.sh && \
    chown -R root:root $SPARK_HOME && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

## Use Debian unstable via pinning -- new style via APT::Default-Release
#RUN echo "deb http://http.debian.net/debian sid main" > /etc/apt/sources.list.d/debian-unstable.list \
#    && echo 'APT::Default-Release "testing";' > /etc/apt/apt.conf.d/default
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
    Rscript -e "install.packages(c(\"arrow\"), repos = 'http://cran.rstudio.com')" && \
    rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
ADD protobuf-2.5.0.tar.gz Rhipe_0.75.2_hadoop-2.tar.gz /tmp/
RUN cd /tmp/protobuf-2.5.0 && ./configure --prefix=/usr && make && make install && cd .. 	&& rm -rf protobuf-* && \
	cd /tmp/Rhipe && R CMD INSTALL . && cd .. && rm -rf Rhipe
ADD postgresql-42.2.2.jar /opt
ADD Renviron /usr/local/lib/R/etc/
ADD hdfs-site.xml core-site.xml log4j.properties /opt/hadoop/etc/hadoop/

WORKDIR $SPARK_HOME
CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]

EXPOSE 7077
EXPOSE 8080
EXPOSE 8081
EXPOSE 4040

###########################################################################################
#
#FROM ubuntu:bionic
#MAINTAINER Jim Harner <ejharner@gmail.com>
#
#ARG hadoopversion=2.9.2
#ARG hiveversion=2.1.1
#ARG sparkversion=2.4.6
#ARG javaversion=8
#ARG javaversion_number=1.${javaversion}.0
#
#RUN apt-get update && \
#    apt-get install -y locales && \
#    dpkg-reconfigure -f noninteractive locales && \
#    locale-gen en_US.UTF-8 && \
#    /usr/sbin/update-locale LANG=en_US.UTF-8 && \
#    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
#    locale-gen && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/*
## Users with other locales should set this in their derivative image
#ENV LANG en_US.UTF-8
#ENV LANGUAGE en_US:en
#ENV LC_ALL en_US.UTF-8
## Install Python 3
#RUN apt-get update && \
#    apt-get install -y --no-install-recommends curl unzip python3 python3-setuptools python3-pip && \
#    ln -s /usr/bin/python3 /usr/bin/python && \
#    python -m pip install py4j && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/*
## http://blog.stuart.axelbrooke.com/python-3-on-spark-return-of-the-pythonhashseed
#ENV PYTHONHASHSEED 0
#ENV PYTHONIOENCODING UTF-8
#ENV PIP_DISABLE_PIP_VERSION_CHECK 1
## JAVA
#RUN apt-get update && \
#	apt-get install -y --no-install-recommends apt-utils apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common lsb-release && \
#	wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - && \
#	add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ && \
#	apt-get update && \
#	apt-get install -y adoptopenjdk-8-hotspot && \
#	update-java-alternatives -s /usr/lib/jvm/adoptopenjdk-8-hotspot-amd64 && \
#	apt-get clean && \
#    rm -rf /var/lib/apt/lists/*
#####################
## HADOOP
#####################
#ENV HADOOP_VERSION 2.9.2
#ENV HADOOP_HOME /usr/hadoop-${HADOOP_VERSION}
#ENV HADOOP_CONF_DIR ${HADOOP_HOME}/etc/hadoop
#ENV PATH ${HADOOP_HOME}/bin:${PATH}
#ENV HADOOP_CMD ${HADOOP_HOME}/bin/hadoop
#ENV HADOOP_BIN ${HADOOP_HOME}/bin
#RUN curl -sL --retry 3 \
#"http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" \
#  | gunzip \
#  | tar -x -C /usr/ \
# && rm -rf $HADOOP_HOME/share/doc \
# && chown -R root:root $HADOOP_HOME
#
## SPARK
#ENV SPARK_VERSION 2.4.6
#ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-without-hadoop
#ENV SPARK_HOME /usr/spark-${SPARK_VERSION}
#ENV SPARK_DIST_CLASSPATH "${HADOOP_HOME}/etc/hadoop/*:${HADOOP_HOME}/share/hadoop/common/lib/*:${HADOOP_HOME}/share/hadoop/common/*:${HADOOP_HOME}/share/hadoop/hdfs/*:${HADOOP_HOME}/share/hadoop/hdfs/lib/*:${HADOOP_HOME}/share/hadoop/hdfs/*:${HADOOP_HOME}/share/hadoop/yarn/lib/*:${HADOOP_HOME}/share/hadoop/yarn/*:${HADOOP_HOME}/share/hadoop/mapreduce/lib/*:${HADOOP_HOME}/share/hadoop/mapreduce/*:${HADOOP_HOME}/share/hadoop/tools/lib/*"
#ENV PATH ${SPARK_HOME}/bin:${PATH}
#RUN curl -sL --retry 3 \
#  "http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_PACKAGE}.tgz" \
#  | gunzip \
#  | tar x -C /usr/ \
# && mv /usr/$SPARK_PACKAGE $SPARK_HOME \
# && chown -R root:root $SPARK_HOME \
# && mkdir /opt/spark-data \
# && chown -R root:root /opt/spark-data && \
### Use Debian unstable via pinning -- new style via APT::Default-Release
##RUN echo "deb http://http.debian.net/debian sid main" > /etc/apt/sources.list.d/debian-unstable.list \
##    && echo 'APT::Default-Release "testing";' > /etc/apt/apt.conf.d/default
#
#    wget https://apache.bintray.com/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-archive-keyring-latest-$(lsb_release --codename --short).deb && \
#    apt-get install -y -V ./apache-arrow-archive-keyring-latest-$(lsb_release --codename --short).deb && \
#    apt-get update && \
#    apt-get install -y -V libarrow-dev libarrow-glib-dev libarrow-dataset-dev libarrow-flight-dev libplasma-dev libplasma-glib-dev libgandiva-dev libgandiva-glib-dev libparquet-dev libparquet-glib-dev && \
#	apt-get clean && \
#    rm -rf /var/lib/apt/lists/*
#
#ENV R_BASE_VERSION 3.6.3
#ARG DEBIAN_FRONTEND=noninteractive
#RUN gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
#    gpg -a --export E298A3A825C0D65DFD57CBB651716619E084DAB9 | apt-key add - && \
#    add-apt-repository -s 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' && \
### Now install R and littler, and create a link for littler in /usr/local/bin
### Also set a default CRAN repo, and make sure littler knows about it too
#    apt-get update && \
####     apt-get install -y --no-install-recommends littler r-cran-littler r-base-${R_BASE_VERSION} r-base-dev-${R_BASE_VERSION} r-recommended=${R_BASE_VERSION} && \
#    apt-get install -y --no-install-recommends littler r-cran-littler r-base r-base-dev r-recommended && \
#    echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site && \
#    echo 'source("/etc/R/Rprofile.site")' >> /etc/littler.r && \
#    ln -s /usr/share/doc/littler/examples/install.r /usr/local/bin/install.r && \
#    ln -s /usr/share/doc/littler/examples/install2.r /usr/local/bin/install2.r && \
#    ln -s /usr/share/doc/littler/examples/installGithub.r /usr/local/bin/installGithub.r && \
#    ln -s /usr/share/doc/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r && \
#    install.r docopt && \
#    rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/*
#
#WORKDIR $SPARK_HOME
#CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]
#
#EXPOSE 7077
#EXPOSE 8080
#EXPOSE 8081
#EXPOSE 4040
#
#
