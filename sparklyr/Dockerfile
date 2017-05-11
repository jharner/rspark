FROM rocker/verse
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Update machine and install 
RUN apt-get update && apt-get install -y postgresql-client-9.4 libicu-dev && apt-get clean

####################
# JAVA
####################
# Install Open-JDK-8 from debian:jessie backports
RUN echo "deb http://http.debian.net/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN apt-get update && apt-get install -y -t jessie-backports openjdk-8-jdk
# Reconfigure java for Rjava Installation
RUN sudo R CMD javareconf
ENV LD_LIBRARY_PATH $JAVA_HOME/jre/lib/amd64:$JAVA_HOME/jre/lib/amd64/server


####################
# HADOOP
####################
ENV HADOOP_VERSION		2.7.2
ENV HADOOP_CMD 			/opt/hadoop/bin/hadoop
# Download Hadoop
RUN cd /opt && wget http://apache.mirrors.hoobly.com/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz && \
	tar zxf hadoop-$HADOOP_VERSION.tar.gz && \
	ln -s hadoop-$HADOOP_VERSION hadoop && rm hadoop-$HADOOP_VERSION.tar.gz
# Download and inject native library
RUN mkdir native && cd native && wget https://github.com/sequenceiq/docker-hadoop-build/releases/download/v2.7.1/hadoop-native-64-2.7.1.tgz && tar zxf hadoop-native-64-2.7.1.tgz && rm hadoop-native-64-2.7.1.tgz && cd ..
RUN rm -rf /opt/hadoop/lib/native && mv native /opt/hadoop/lib


####################
# R PACKAGES
####################
# Install R packages (removed hbase)
RUN Rscript -e "install.packages(c(\"rsparkling\", \"sparklyr\", \"rJava\", \"flexdashboard\"))"
# Install rhdfs
ADD rhdfs.tar.gz /tmp/pkgs/
RUN cd /tmp/pkgs && R CMD INSTALL rhdfs


####################
# SPARK
####################
RUN cd /opt && \
	wget --quiet http://apache.osuosl.org/spark/spark-2.0.1/spark-2.0.1-bin-hadoop2.7.tgz && \
	tar zxf spark-2.0.1-bin-hadoop2.7.tgz && \
	mv spark-2.0.1-bin-hadoop2.7 spark && \
	cp spark/conf/spark-env.sh.template spark/conf/spark-env.sh && \
	echo "export SPARK_DIST_CLASSPATH=$(/opt/hadoop/bin/hadoop classpath)" >> spark/conf/spark-env.sh


####################
# HIVE
####################
#RUN cd /opt && \
#	wget --quiet http://apache.mesi.com.ar/hive/hive-2.1.1/apache-hive-2.1.1-bin.tar.gz && \
#	tar zxf apache-hive-2.1.1-bin.tar.gz && \
#	ln -s apache-hive-2.1.1-bin hive && \
#	ln -s /opt/hive/jdbc/hive-jdbc-2.1.1-standalone.jar /opt/hive/lib/ && \
#	rm apache-hive-2.1.1-bin.tar.gz


####################
# ENVIRONMENT CONFIG
####################
#add necessary mods to Renviron file
ADD Renviron /usr/local/lib/R/etc/
#ADD hdfs-site.xml /opt/hadoop/etc/hadoop/
#ADD core-site.xml /opt/hadoop/etc/hadoop/
#ADD log4j.properties /opt/hadoop/etc/hadoop/
# Create symlink to actual Rscript
RUN ln -s /usr/local/bin/Rscript /usr/bin/Rscript



EXPOSE 8787
#VOLUME /home/rstudio

CMD ["/init"]


	
