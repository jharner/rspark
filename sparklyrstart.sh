#!/bin/bash

if [[ ! -e sparklyr/data ]]; then
	mkdir sparklyr/data
fi

if [[ ! -e sparklyr/data/rstudio ]]; then
	mkdir sparklyr/data/rstudio
fi

docker-compose -f sparklyr.yml up