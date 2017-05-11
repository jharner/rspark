FROM library/ubuntu:xenial
MAINTAINER Mark Lilback <mark@lilback.com>

# Define Postgres Versions
ARG pgversion=9.4

# Add the PostgreSQL PGP key to verify their Debian packages.
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
# Add PostgreSQL's repository.
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Install packages and Postgres
RUN apt-get update && apt-get install -y python-software-properties software-properties-common postgresql-${pgversion} postgresql-client-${pgversion} postgresql-contrib-${pgversion} libpq-dev


RUN mkdir -p /opt/pgdata; chown -R postgres /opt/pgdata; chmod 700 /opt/pgdata

RUN locale-gen en_US.UTF-8

# Delete default cluster and create new cluster
RUN pg_dropcluster ${pgversion} main
RUN pg_createcluster -d /opt/pgdata --locale=en_US.UTF-8 ${pgversion} main

# Copy data file
COPY dataexpo.sql /opt/

# Become user Postgres (superuser)
USER postgres

# Copy connection configuration file
COPY pg_hba.conf postgresql.conf /etc/postgresql/${pgversion}/main/

# Copy runpg shell script
COPY runpg.sh /var/lib/postgresql/runpg.sh

# Define environment variables
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

EXPOSE 5432

# Execute Postgres setup script "runpg.sh"
CMD ["var/lib/postgresql/runpg.sh", "${pgversion}"]
