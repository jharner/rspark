FROM library/ubuntu:bionic
MAINTAINER Chris Grant <chrisgrant.datascience@gmail.com>

# Define Postgres Versions
ARG pgversion=12
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
ARG DEBIAN_FRONTEND=noninteractive
ENV PGDATA /opt/pg-data
ENV PGDIR /usr/lib/postgresql/${pgversion}/bin/
ENV PGVERSION ${pgversion}

# Add the PostgreSQL PGP key to verify their Debian packages.
COPY postgresKey.asc openjdkKey.asc /tmp/
RUN apt-get update && \
    apt-get install -y apt-utils apt-transport-https ca-certificates dirmngr gnupg wget curl software-properties-common && \
    apt-key add /tmp/postgresKey.asc && \
    apt-key add /tmp/openjdkKey.asc && \
    add-apt-repository --yes 'deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main' && \
	add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ && \
	apt-get update && \
    apt-get install --no-install-recommends -y -V postgresql=${pgversion}* postgresql-client=${pgversion}*  \
            postgresql-contrib=${pgversion}* libpq-dev openssh-client openssh-server libpostgresql-jdbc-java \
            libicu-dev adoptopenjdk-${javaversion}-hotspot python3 python3-software-properties python3-pip && \
    update-java-alternatives -s adoptopenjdk-${javaversion}-hotspot-amd64 && \
# Install packages and Postgres
    mkdir -p /opt/pg-data && \
    mkdir /entrypoint && \
    chown -R postgres /opt/pg-data && \
    chmod 700 /opt/pg-data && \
    locale-gen en_US.UTF-8 && \
# Delete default cluster and create new cluster
    pg_dropcluster ${pgversion} main && \
#RUN pg_createcluster -d $PGDATA --locale=en_US.UTF-8 ${pgversion} main
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy data file
COPY dataexpo.sql nycflights13.sql.gz init.sh /opt/
# Copy connection configuration file
COPY pg_hba.conf postgresql.conf /etc/postgresql/${pgversion}/main/
COPY entrypoint-postgres.sh entrypoint-hadoop.sh entrypoint-hive.sh entrypoint-spark-architect.sh entrypoint-spark-tecton.sh /entrypoint/
# Define environment variables
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

## Become user postgres (superuser)
#USER postgres
#RUN /opt/init.sh


