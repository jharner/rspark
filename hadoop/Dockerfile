FROM sequenceiq/hadoop-docker:2.7.1

ADD bootstrap.sh /etc/
ADD core-site.xml hdfs-site.xml /usr/local/hadoop/etc/hadoop/
ADD log4j.properties /usr/local/hadoop/etc/hadoop/

VOLUME ["/data"]

RUN useradd -u 1000 -s /bin/bash -m -d /home/rstudio rstudio
