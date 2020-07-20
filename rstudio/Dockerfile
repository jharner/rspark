FROM rocker/verse:3.6.3-ubuntu18.04
MAINTAINER Jim Harner <ejharner@gmail.com>

ARG pgversion=9.6
ARG hadoopversion=2.9.2
ARG hiveversion=2.1.1
ARG sparkversion=2.4.4
ARG javaversion=8
ARG javaversion_number=1.${javaversion}.0
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
####  ENV JAVA_HOME /usr/lib/jvm/java-${java_version}-openjdk-amd64
ENV JAVA_HOME /usr/lib/jvm/adoptopenjdk-8-hotspot-amd64
COPY postgresKey.asc openjdkKey.asc /tmp/
RUN apt-get update && \
    apt-get install -y apt-utils apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common && \
    apt-key add /tmp/postgresKey.asc && \
    apt-key add /tmp/openjdkKey.asc && \
    add-apt-repository --yes 'deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main' && \
	add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ && \
# Update machine and install
    apt-get update && \
    apt-get install --no-install-recommends -y postgresql-client-${pgversion} libicu-dev adoptopenjdk-8-hotspot && \
    update-java-alternatives -s adoptopenjdk-8-hotspot-amd64 && \
    R CMD javareconf && \
    apt-get clean && \
	rm -rf /var/lib/apt/lists/*
####################
# HADOOP
####################
# Download and Install Hadoop and set Hadoop environment variable
ENV HADOOP_CMD=/opt/hadoop/bin/hadoop
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_BIN=/opt/hadoop/bin
ENV HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop
RUN cd /opt && \
    wget --quiet http://archive.apache.org/dist/hadoop/core/hadoop-${hadoopversion}/hadoop-${hadoopversion}.tar.gz && \
	tar zxf hadoop-${hadoopversion}.tar.gz && \
	ln -s hadoop-${hadoopversion} hadoop && \
	rm hadoop-${hadoopversion}.tar.gz && \
	(cd /opt/hadoop; ln -s share/hadoop/tools/lib/hadoop-streaming-${hadoopversion}.jar hadoop-streaming.jar) && \
	chown -R rstudio:rstudio /opt/hadoop && \
####################
# HIVE
####################
    cd /opt && \
	wget --quiet http://archive.apache.org/dist/hive/hive-${hiveversion}/apache-hive-${hiveversion}-bin.tar.gz && \
	tar zxf apache-hive-${hiveversion}-bin.tar.gz && \
	ln -s apache-hive-${hiveversion}-bin hive && \
	ln -s /opt/hive/jdbc/hive-jdbc-${hiveversion}-standalone.jar /opt/hive/lib/ && \
	rm apache-hive-${hiveversion}-bin.tar.gz && \
####################
# SPARK
####################
# Install Spark
    cd /opt && \
	wget --quiet http://archive.apache.org/dist/spark/spark-${sparkversion}/spark-${sparkversion}-bin-hadoop2.7.tgz && \
	tar zxf spark-${sparkversion}-bin-hadoop2.7.tgz && \
	mv spark-${sparkversion}-bin-hadoop2.7 spark && \
	rm spark-${sparkversion}-bin-hadoop2.7.tgz && \
	cp spark/conf/spark-env.sh.template spark/conf/spark-env.sh && \
	echo "export SPARK_DIST_CLASSPATH=/opt/postgresql-42.2.2.jar:$(/opt/hadoop/bin/hadoop classpath)" >> spark/conf/spark-env.sh && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
####################
# R PACKAGES
####################
# Switch to rstudio CRAN mirror (untested)
# RUN R CMD options(repos = c(CRAN = "https://cran.rstudio.com"))
# Set environment variable for rJava package installation
ENV LD_LIBRARY_PATH $JAVA_HOME/jre/lib/amd64:$JAVA_HOME/jre/lib/amd64/server
# Install R packages
RUN Rscript -e "install.packages(c(\"rjson\", \"RJSONIO\", \"jsonlite\", \"functional\", \"R.methodsS3\", \"caTools\", \"trelliscopejs\", \"RPostgreSQL\", \"RJDBC\", \"housingData\", \"Lahman\", \"nycflights13\", \"flexdashboard\", \"sparklyr\", \"glmnet\", \"reticulate\", \"tensorflow\"), repos = 'http://cran.rstudio.com')"
# Copy repository packages to filesystem
ADD rhdfs.tar.gz rmr.tar.gz /tmp/pkgs/
# Install repository packages
RUN cd /tmp/pkgs && R CMD INSTALL rmr2 rhdfs

ADD protobuf-2.5.0.tar.gz Rhipe_0.75.2_hadoop-2.tar.gz /tmp/
RUN cd /tmp/protobuf-2.5.0 && ./configure --prefix=/usr && make && make install && cd .. 	&& rm -rf protobuf-* && \
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
# Install TensorFlow Package
# RUN R -e "install.packages(\"tensorflow\")"
# USER rstudio
# Install rspark test files
# ADD rspark-tests.tar.gz /home/rstudio
RUN mkdir /home/rstudio/rspark-tests && \
git clone https://github.com/jharner/rspark-tests.git /tmp/foo && \
cd /tmp/foo && \
git archive master | tar -x -C /home/rstudio/rspark-tests  && \
cd && \
rm -rf /tmp/foo
RUN mkdir /home/rstudio/rspark-tutorial && \
git clone https://github.com/jharner/rspark-tutorial.git /tmp/foo && \
cd /tmp/foo && \
git archive master | tar -x -C /home/rstudio/rspark-tutorial  && \
cd && \
rm -rf /tmp/foo
RUN chown -R rstudio:rstudio /home/rstudio
# USER root
EXPOSE 8787
#EXPOSE 4040
#EXPOSE 4041

CMD ["/init"]


	
