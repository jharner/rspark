FROM rocker/verse
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
# Update machine and install 
RUN apt-get update && apt-get install -y postgresql-client-9.4 libicu-dev && apt-get clean

####################
# JAVA
####################
RUN echo "deb http://http.debian.net/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN apt-get update && apt-get install -y -t jessie-backports openjdk-8-jdk
# config Java within R for rJava installation
RUN sudo R CMD javareconf
# Install Google Protocol Buffer
#ADD protobuf-2.5.0.tar.gz /tmp
#RUN cd /tmp/protobuf-2.5.0 && ./configure && make -j4 && make install && cd .. && rm -rf protobuf-*

####################
# HADOOP
####################
# Download and Install Hadoop and set Hadoop environment variable
RUN cd /opt && wget --quiet http://apache.mirrors.hoobly.com/hadoop/common/hadoop-2.7.1/hadoop-2.7.1.tar.gz && \
	tar zxf hadoop-2.7.1.tar.gz && ln -s hadoop-2.7.1 hadoop && rm hadoop-2.7.1.tar.gz
RUN mkdir native && cd native && wget --quiet https://github.com/sequenceiq/docker-hadoop-build/releases/download/v2.7.1/hadoop-native-64-2.7.1.tgz && tar zxf hadoop-native-64-2.7.1.tgz && rm hadoop-native-64-2.7.1.tgz && cd ..
RUN rm -rf /opt/hadoop/lib/native && mv native /opt/hadoop/lib
ENV HADOOP_CMD /opt/hadoop/bin/hadoop


####################
# R PACKAGES
####################
# Set environment variable for rJava package installation
ENV LD_LIBRARY_PATH $JAVA_HOME/jre/lib/amd64:$JAVA_HOME/jre/lib/amd64/server
# Install R packages (removed hbase)
RUN Rscript -e "install.packages(c(\"rjson\",\"bit64\",\"bit\",\"functional\",\"RJSONIO\",\"R.methodsS3\",\"reshape2\",\"datadr\",\"trelliscope\",\"DBI\",\"RPostgreSQL\",\"RJDBC\", \"rsparkling\", \"testthat\", \"roxygen2\", \"sparklyr\", \"XML\", \"housingData\", \"flexdashboard\"))"
#Copy repository packages to filesystem
ADD rhdfs.tar.gz ravro.tar.gz rmr.tar.gz plyrmr.tar.gz rjava.tar.gz /tmp/pkgs/
# Install repository packages
RUN cd /tmp/pkgs && R CMD INSTALL rJava ravro rmr2 plyrmr rhdfs

ADD protobuf-2.5.0.tar.gz Rhipe_0.75.2_hadoop-2.tar.gz /tmp/
RUN cd /tmp/protobuf-2.5.0 && ./configure --prefix=/usr && make && make install && cd .. && rm -rf protobuf-*
RUN cd /tmp/Rhipe && R CMD INSTALL . && cd .. && rm -rf Rhipe

####################
# SPARK
####################
# Install Spark
RUN cd /opt && \
	wget --quiet http://apache.osuosl.org/spark/spark-2.1.0/spark-2.1.0-bin-hadoop2.7.tgz && \
	tar zxf spark-2.1.0-bin-hadoop2.7.tgz && \
	mv spark-2.1.0-bin-hadoop2.7 spark && \
	cp spark/conf/spark-env.sh.template spark/conf/spark-env.sh && \
	echo "export SPARK_DIST_CLASSPATH=$(/opt/hadoop/bin/hadoop classpath)" >> spark/conf/spark-env.sh


####################
# HIVE
####################
RUN cd /opt && \
	wget --quiet http://apache.mesi.com.ar/hive/hive-2.1.1/apache-hive-2.1.1-bin.tar.gz && \
	tar zxf apache-hive-2.1.1-bin.tar.gz && \
	ln -s apache-hive-2.1.1-bin hive && \
	ln -s /opt/hive/jdbc/hive-jdbc-2.1.1-standalone.jar /opt/hive/lib/ && \
	rm apache-hive-2.1.1-bin.tar.gz


####################
# ENVIRONMENT CONFIG
####################
#add necessary mods to Renviron file
ADD Renviron /usr/local/lib/R/etc/
ADD hdfs-site.xml /opt/hadoop/etc/hadoop/
ADD core-site.xml /opt/hadoop/etc/hadoop/
ADD log4j.properties /opt/hadoop/etc/hadoop/
# Create symlink to actual Rscript
RUN ln -s /usr/local/bin/Rscript /usr/bin/Rscript
ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_BIN /opt/hadoop/bin
ENV HADOOP_CONF_DIR /opt/hadoop/etc/hadoop



EXPOSE 8787
#VOLUME /home/rstudio

CMD ["/init"]


	
