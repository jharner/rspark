FROM library/ubuntu:bionic
MAINTAINER Mark Lilback <mark@lilback.com>

# Define Postgres Versions
ARG pgversion=12
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
ARG DEBIAN_FRONTEND=noninteractive
ENV PGDATA /opt/pg-data
ENV PGDIR /usr/lib/postgresql/${pgversion}/bin/
ENV PGVERSION ${pgversion}

# Define environment variables
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

## This code initializes the postgresql server.
# Install packages and Postgres
RUN mkdir -p /opt/pg-data && \
    mkdir /entrypoint && \
    chown -R postgres /opt/pg-data && \
    chmod 700 /opt/pg-data && \
    locale-gen en_US.UTF-8 && \
# Delete default cluster and create new cluster
    pg_dropcluster ${pgversion} main \
#RUN pg_createcluster -d $PGDATA --locale=en_US.UTF-8 ${pgversion} main
# Define environment variables
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

COPY dataexpo.sql nycflights13.sql.gz init.sh /opt/
# Become user postgres (superuser)
USER postgres

# Copy connection configuration file
COPY pg_hba.conf postgresql.conf /etc/postgresql/${pgversion}/main/
COPY entrypoint-postgres.sh /entrypoint

RUN /opt/init.sh

