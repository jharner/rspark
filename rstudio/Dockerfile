FROM rocker/verse:3.4.4
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

ARG pgversion=9.6
ARG hadoopversion=2.7.1
ARG sparkversion=2.2.2
ARG hiveversion=2.3.3


# Update machine and install 
# RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get update && apt-get install -y postgresql-client-${pgversion} libicu-dev && apt-get clean

####################
# JAVA
####################
RUN echo "deb http://http.debian.net/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN apt-get update && apt-get install -y -t jessie-backports openjdk-8-jdk
# config Java within R for rJava installation
RUN sudo R CMD javareconf
# Install Google Protocol Buffer
# ADD protobuf-2.5.0.tar.gz /tmp
# RUN cd /tmp/protobuf-2.5.0 && ./configure && make -j4 && make install && cd .. && rm -rf protobuf-*

####################
# HADOOP
####################
# Download and Install Hadoop and set Hadoop environment variable
RUN cd /opt && wget --quiet http://archive.apache.org/dist/hadoop/core/hadoop-${hadoopversion}/hadoop-${hadoopversion}.tar.gz && \
	tar zxf hadoop-${hadoopversion}.tar.gz && \
	ln -s hadoop-${hadoopversion} hadoop && \
	rm hadoop-${hadoopversion}.tar.gz && \
	(cd /opt/hadoop; ln -s share/hadoop/tools/lib/hadoop-streaming-${hadoopversion}.jar hadoop-streaming.jar)
RUN mkdir native && cd native && \
	wget --quiet https://github.com/sequenceiq/docker-hadoop-build/releases/download/v2.7.1/hadoop-native-64-2.7.1.tgz && \
	tar zxf hadoop-native-64-2.7.1.tgz && \
	rm hadoop-native-64-2.7.1.tgz && \
	cd ..
RUN rm -rf /opt/hadoop/lib/native && mv native /opt/hadoop/lib && chown -R rstudio:rstudio /opt/hadoop
ENV HADOOP_CMD=/opt/hadoop/bin/hadoop HADOOP_HOME=/opt/hadoop HADOOP_BIN=/opt/hadoop/bin HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop

####################
# SPARK
####################
# Install Spark
RUN cd /opt && \
	wget http://apache.mirrors.pair.com/spark/spark-${sparkversion}/spark-${sparkversion}-bin-hadoop2.7.tgz && \
	tar zxf spark-${sparkversion}-bin-hadoop2.7.tgz && \
	mv spark-${sparkversion}-bin-hadoop2.7 spark && \
	cp spark/conf/spark-env.sh.template spark/conf/spark-env.sh && \
	echo "export SPARK_DIST_CLASSPATH=/opt/postgresql-42.2.2.jar:$(/opt/hadoop/bin/hadoop classpath)" >> spark/conf/spark-env.sh


####################
# HIVE
####################
RUN cd /opt && \
	wget http://apache.mirrors.pair.com/hive/hive-${hiveversion}/apache-hive-${hiveversion}-bin.tar.gz && \
	tar zxf apache-hive-${hiveversion}-bin.tar.gz && \
	ln -s apache-hive-${hiveversion}-bin hive && \
	ln -s /opt/hive/jdbc/hive-jdbc-${hiveversion}-standalone.jar /opt/hive/lib/ && \
	rm apache-hive-${hiveversion}-bin.tar.gz

####################
# R PACKAGES
####################
# Switch to rstudio CRAN mirror (untested)
# RUN R CMD options(repos = c(CRAN = "https://cran.rstudio.com"))
# Set environment variable for rJava package installation
ENV LD_LIBRARY_PATH $JAVA_HOME/jre/lib/amd64:$JAVA_HOME/jre/lib/amd64/server
# Install R packages (removed hbase)
RUN Rscript -e "install.packages(c(\"rjson\",\"bit64\",\"bit\",\"functional\",\"RJSONIO\",\"R.methodsS3\",\"reshape2\",\"datadr\",\"trelliscope\",\"DBI\",\"RPostgreSQL\",\"RJDBC\",\"glmnet\",  \"testthat\", \"roxygen2\", \"XML\", \"housingData\", \"flexdashboard\", \"dbplyr\", \"sparklyr\"), repos = 'http://cran.rstudio.com')"
# Copy repository packages to filesystem
ADD rhdfs.tar.gz ravro.tar.gz rmr.tar.gz plyrmr.tar.gz rjava.tar.gz /tmp/pkgs/
# Install repository packages
RUN cd /tmp/pkgs && R CMD INSTALL rJava ravro rmr2 plyrmr rhdfs

ADD protobuf-2.5.0.tar.gz Rhipe_0.75.2_hadoop-2.tar.gz /tmp/
RUN cd /tmp/protobuf-2.5.0 && ./configure --prefix=/usr && make && make install && cd .. && rm -rf protobuf-* && \
	cd /tmp/Rhipe && R CMD INSTALL . && cd .. && rm -rf Rhipe

ADD postgresql-42.2.2.jar /opt

####################
# ENVIRONMENT CONFIG
####################
# Add necessary mods to Renviron file
ADD Renviron /usr/local/lib/R/etc/
ADD hdfs-site.xml core-site.xml log4j.properties /opt/hadoop/etc/hadoop/
# Create symlink to actual Rscript
RUN ln -s /usr/local/bin/Rscript /usr/bin/Rscript

# Add path to profile so commands are found if attach to the container
RUN echo "PATH='/opt/hadoop/bin:/opt/spark/bin:/opt/hive/bin:$PATH'" >> /etc/profile
# this is useless because it only sets it for the following commands in the Dockerfile
#ENV PATH /opt/hadoop/bin:/opt/spark/bin:/opt/hive/bin::$PATH


# Install Python3
# NOTE: python 3 uses the command 'python3'
RUN easy_install pip && apt-get install -y python3 && pip install virtualenv

# Install TensorFlow
RUN R -e "install.packages(\"tensorflow\")"

# USER rstudio
ADD rspark-tests /home/rstudio/
# ADD rspark-notes /home/rstudio/
RUN chown -R rstudio:rstudio /home/rstudio

# USER root
EXPOSE 8787
# VOLUME /home/rstudio

CMD ["/init"]


	
