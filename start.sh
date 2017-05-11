#!/bin/sh

while [[ $# -gt 0 ]]
do
key=$1

case $key in
	-b|--build|build)
	shift
	docker build -t jh-postgres postgres
	docker build -t jh-hadoop hadoop
	docker build -t jh-hive hive
	docker build -t jh-rstudio rstudio
	;;
	-r|--reset)
	echo "resetting data"
	docker rm hadoop_hadoop_1 hadoop_hive_1 hadoop_postgres_1 hadoop_rstudio_1
	rm -rf data/pg-data data/hadoop
	shift
	;;
	*)
	echo "unknown option $key"
	exit 1
	;;
esac
done

if [[ ! -e data ]]; then
	mkdir data
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
