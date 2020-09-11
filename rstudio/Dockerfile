FROM rocker/verse:3.6.3-ubuntu18.04
MAINTAINER Jim Harner <ejharner@gmail.com>

ARG pgversion=12
ARG hadoopversion=2.10.0
ARG hiveversion=2.1.1
ARG sparkversion=3.0.0
ARG javaversion=8
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

#  ENV JAVA_HOME /usr/lib/jvm/java-${java_version}-openjdk-amd64
ENV JAVA_HOME /usr/lib/jvm/adoptopenjdk-8-hotspot-amd64

## OpenJDK, Postgres client, and Arrow
COPY postgresKey.asc openjdkKey.asc /tmp/
RUN apt-get update && \
    apt-get install -y apt-utils apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common autoconf automake libtool curl make g++ unzip && \
    apt-key add /tmp/postgresKey.asc && \
    apt-key add /tmp/openjdkKey.asc && \
    add-apt-repository --yes 'deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main' && \
	add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ && \
# Update machine and install postgresql and jdk
    apt-get update && \
    apt-get install --no-install-recommends -y postgresql-client-${pgversion} libicu-dev adoptopenjdk-${javaversion}-hotspot && \
    update-java-alternatives -s adoptopenjdk-${javaversion}-hotspot-amd64 && \
    R CMD javareconf && \
    cd /opt && \
# Get Arrow, protobuf libraries, and postgresql-jdbc driver
    wget https://apache.bintray.com/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-archive-keyring-latest-$(lsb_release --codename --short).deb && \
    apt-get install -y -V ./apache-arrow-archive-keyring-latest-$(lsb_release --codename --short).deb && \
    apt-get update && \
    apt-get install -y -V libprotobuf-dev libprotobuf-c-dev protobuf-compiler protobuf-c-compiler libprotoc-dev \
                          libarrow-dev libarrow-glib-dev libarrow-dataset-dev libarrow-flight-dev libplasma-dev libplasma-glib-dev \
                          libgandiva-dev libgandiva-glib-dev libparquet-dev libparquet-glib-dev && \
    rm ./apache-arrow-archive-keyring-latest-$(lsb_release --codename --short).deb && \
    wget --quiet https://jdbc.postgresql.org/download/postgresql-42.2.14.jar && \
    apt-get clean && \
	rm -rf /var/lib/apt/lists/*

## HADOOP
# Download and Install Hadoop and set Hadoop environment variable
ENV HADOOP_CMD=/opt/hadoop/bin/hadoop
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_BIN=/opt/hadoop/bin
ENV HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop
ENV HIVE_HOME=/opt/hive
ENV SPARK_HOME=/opt/spark
RUN cd /opt && \
    wget --quiet http://archive.apache.org/dist/hadoop/core/hadoop-${hadoopversion}/hadoop-${hadoopversion}.tar.gz && \
	tar zxf hadoop-${hadoopversion}.tar.gz && \
	ln -s hadoop-${hadoopversion} hadoop && \
	rm hadoop-${hadoopversion}.tar.gz && \
	(cd /opt/hadoop; ln -s share/hadoop/tools/lib/hadoop-streaming-${hadoopversion}.jar hadoop-streaming.jar) && \
	chown -R rstudio:rstudio /opt/hadoop && \

## HIVE
    cd /opt && \
	wget --quiet http://archive.apache.org/dist/hive/hive-${hiveversion}/apache-hive-${hiveversion}-bin.tar.gz && \
	tar zxf apache-hive-${hiveversion}-bin.tar.gz && \
	ln -s apache-hive-${hiveversion}-bin hive && \
	ln -s /opt/hive/jdbc/hive-jdbc-${hiveversion}-standalone.jar /opt/hive/lib/ && \
	chown -R rstudio:rstudio /opt/hive && \
	rm apache-hive-${hiveversion}-bin.tar.gz && \

## SPARK
# Install Spark
    cd /opt && \
	wget --quiet http://archive.apache.org/dist/spark/spark-${sparkversion}/spark-${sparkversion}-bin-hadoop2.7.tgz && \
	tar zxf spark-${sparkversion}-bin-hadoop2.7.tgz && \
	mv spark-${sparkversion}-bin-hadoop2.7 spark && \
	chown -R rstudio:rstudio /opt/spark && \
	rm spark-${sparkversion}-bin-hadoop2.7.tgz && \
	cp spark/conf/spark-env.sh.template spark/conf/spark-env.sh && \
	echo "export SPARK_DIST_CLASSPATH=/opt/postgresql-42.2.14.jar:$(/opt/hadoop/bin/hadoop classpath)" >> spark/conf/spark-env.sh && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

## R PACKAGES
# Switch to rstudio CRAN mirror
# Set environment variable for rJava package installation
ENV LD_LIBRARY_PATH $JAVA_HOME/jre/lib/amd64:$JAVA_HOME/jre/lib/amd64/server

# Install R packages
RUN Rscript -e "install.packages(c(\"microbenchmark\", \"arrow\", \"rjson\", \"RJSONIO\", \"jsonlite\", \"functional\", \"R.methodsS3\", \"caTools\", \"trelliscopejs\", \"RPostgreSQL\", \"RJDBC\", \"housingData\", \"Lahman\", \"nycflights13\", \"flexdashboard\", \"sparklyr\", \"glmnet\", \"reticulate\", \"tensorflow\"), repos = 'http://cran.rstudio.com')"
# Copy repository packages to filesystem
ADD rhdfs.tar.gz rmr.tar.gz /tmp/pkgs/
# Install repository packages
RUN cd /tmp/pkgs && R CMD INSTALL rmr2 rhdfs

RUN echo "JAVA_HOME=/usr/lib/jvm/adoptopenjdk-${javaversion}-hotspot-amd64" >> /etc/profile
RUN echo "JAVA_HOME=/usr/lib/jvm/adoptopenjdk-${javaversion}-hotspot-amd64" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
RUN export JAVA_HOME=/usr/lib/jvm/adoptopenjdk-${javaversion}-hotspot-amd64

# Add necessary mods to Renviron file
ADD Renviron /usr/local/lib/R/etc/
ADD hdfs-site.xml core-site.xml log4j.properties /opt/hadoop/etc/hadoop/
ENV PATH=/opt/hadoop/bin:/opt/spark/bin:/opt/hive/bin:$PATH
# Create symlink to actual Rscript
RUN ln -s /usr/local/bin/Rscript /usr/bin/Rscript && \
# Add path to profile so commands are found if attached to the container
    echo "PATH='/opt/hadoop/bin:/opt/spark/bin:/opt/hive/bin:$PATH'" >> /etc/profile && \
    export PATH=/opt/hadoop/bin:/opt/spark/bin:/opt/hive/bin:$PATH && \
    echo "PATH='/opt/hadoop/bin:/opt/spark/bin:/opt/hive/bin:$PATH'" >> /home/rstudio/.bashrc && \
    . /home/rstudio/.bashrc
# Get tests and tutorial from Github.
RUN cd /home/rstudio && \
    git clone https://github.com/jharner/rspark-tests && \
    git clone https://github.com/jharner/rspark-tutorial

RUN chown -R rstudio:rstudio /home/rstudio
# USER root
EXPOSE 8787
EXPOSE 4040
EXPOSE 4041

CMD ["/init"]
