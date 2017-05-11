#!/bin/sh

if [[ ! -e sparklyr/data ]]; then
	mkdir sparklyr/data
fi

if [[ ! -e sparklyr/data/rstudio ]]; then
	mkdir sparklyr/data/rstudio
fi

cd sparklyr
docker-compose up