FROM library/ubuntu:bionic
MAINTAINER Chris Grant <chrisgrant.datascience@gmail.com>

# Define Postgres Versions
ARG pgversion=12
ARG javaversion=8
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
ARG DEBIAN_FRONTEND=noninteractive
ENV PGDATA /opt/pg-data
ENV PGDIR /usr/lib/postgresql/${pgversion}/bin/
ENV PGVERSION ${pgversion}
ENV PYTHONHASHSEED 0
ENV PYTHONIOENCODING UTF-8
ENV PIP_DISABLE_PIP_VERSION_CHECK 1
ENV R_BASE_VERSION 3.6.3
ENV JAVA_HOME /usr/lib/jvm/adoptopenjdk-8-hotspot-amd64

RUN apt-get update && \
    apt-get install -y locales && \
    dpkg-reconfigure -f noninteractive locales && \
    locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8 && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# Users with other locales should set this in their derivative image
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
# Add the PostgreSQL PGP key to verify their Debian packages.
COPY postgresKey.asc openjdkKey.asc /tmp/
RUN apt-get update && \
    apt-get install -y apt-utils apt-transport-https ca-certificates dirmngr gnupg wget curl software-properties-common && \
    apt-key add /tmp/postgresKey.asc && \
    apt-key add /tmp/openjdkKey.asc && \
    add-apt-repository --yes 'deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main' && \
	add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ && \
    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    gpg -a --export E298A3A825C0D65DFD57CBB651716619E084DAB9 | apt-key add - && \
    add-apt-repository -s 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' && \
	apt-get update && \
    apt-get install --no-install-recommends -y -V postgresql=${pgversion}* postgresql-client=${pgversion}*  \
            postgresql-contrib=${pgversion}* libpq-dev openssh-client openssh-server libpostgresql-jdbc-java \
            libicu-dev adoptopenjdk-${javaversion}-hotspot python3 python3-software-properties python3-pip && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    update-java-alternatives -s adoptopenjdk-${javaversion}-hotspot-amd64 && \
	cd /opt && \
    wget https://apache.bintray.com/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-archive-keyring-latest-$(lsb_release --codename --short).deb && \
    apt-get install -y -V ./apache-arrow-archive-keyring-latest-$(lsb_release --codename --short).deb && \
    apt-get update && \
    apt-get install -y -V libprotobuf-dev libprotobuf-c-dev protobuf-compiler protobuf-c-compiler libprotoc-dev \
            libarrow-dev libarrow-glib-dev libarrow-dataset-dev libarrow-flight-dev libplasma-dev libplasma-glib-dev \
            libgandiva-dev libgandiva-glib-dev libparquet-dev libparquet-glib-dev && \
    rm ./apache-arrow-archive-keyring-latest-$(lsb_release --codename --short).deb && \
    wget --quiet https://jdbc.postgresql.org/download/postgresql-42.2.14.jar && \
    python -m pip install py4j pyarrow && \
    echo "JAVA_HOME=/usr/lib/jvm/adoptopenjdk-${javaversion}-hotspot-amd64" >> /etc/profile && \
    echo "JAVA_HOME=/usr/lib/jvm/adoptopenjdk-${javaversion}-hotspot-amd64" >> /.bashrc && \
    export JAVA_HOME=/usr/lib/jvm/adoptopenjdk-${javaversion}-hotspot-amd64 && \
    . /.bashrc && \
    apt-get install -y -V --no-install-recommends littler r-cran-littler r-base=${R_BASE_VERSION}* \
            r-base-dev=${R_BASE_VERSION}* r-recommended=${R_BASE_VERSION}* && \
    echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site && \
    echo 'source("/etc/R/Rprofile.site")' >> /etc/littler.r && \
    ln -s /usr/share/doc/littler/examples/install.r /usr/local/bin/install.r && \
    ln -s /usr/share/doc/littler/examples/install2.r /usr/local/bin/install2.r && \
    ln -s /usr/share/doc/littler/examples/installGithub.r /usr/local/bin/installGithub.r && \
    ln -s /usr/share/doc/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r && \
    install.r docopt && \
    mkdir /entrypoint && \
    apt-get clean && \
    rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
    rm -rf /var/lib/apt/lists/*







