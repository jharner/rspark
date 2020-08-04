FROM ubuntu:bionic
MAINTAINER Chris Grant <chrisgrant.datascience@gmail.com>

# Started 2020-07-29
# Try to create Arrow services for R and Python

RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils wget curl ca-certificates apt-transport-https ca-certificates \
                                               dirmngr gnupg software-properties-common lsb-release && \
    wget https://apache.bintray.com/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-archive-keyring-latest-$(lsb_release --codename --short).deb && \
    apt-get install -y -V ./apache-arrow-archive-keyring-latest-$(lsb_release --codename --short).deb && \
    apt-get update && \
    apt-get install -y -V libarrow-dev libarrow-glib-dev libarrow-dataset-dev libarrow-flight-dev libplasma-dev libplasma-glib-dev libgandiva-dev libgandiva-glib-dev libparquet-dev libparquet-glib-dev && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

## wget --quiet https://www.apache.org/dyn/closer.lua/arrow/arrow-1.0.0/apache-arrow-1.0.0.tar.gz