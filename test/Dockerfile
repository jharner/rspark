FROM openjdk:8
FROM rocker/verse:4.0.0
RUN apt-get update && \
    apt-get install -y  apt-utils apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common  && \
    update-java-alternatives -s /usr/local/openjdk-8 && \
    R CMD javareconf && \
    JAVA_HOME=/usr/local/openjdk-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 8787