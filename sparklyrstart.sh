#!/bin/bash

if [[ ! -e data ]]; then
	mkdir data
	# possibly Add Git pull here
fi

if [[ ! -e data/pg-data ]]; then
	mkdir data/pg-data
fi

if [[ ! -e sparklyr/data ]]; then
	mkdir sparklyr/data
fi

if [[ ! -e sparklyr/data/rstudio ]]; then
	mkdir sparklyr/data/rstudio
fi

docker-compose -f sparklyr.yml up