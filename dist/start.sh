#!/bin/bash

if [[ ! -e data ]]; then
	mkdir data
	# possibly Add Git pull here
fi

if [[ ! -e data/pg-data ]]; then
	mkdir data/pg-data
fi

if [[ ! -e data/rstudio ]]; then
	mkdir data/rstudio
fi

if [[ ! -e data/hadoop ]]; then
	mkdir data/hadoop
fi

docker-compose up
