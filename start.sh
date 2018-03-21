#!/bin/bash

while [[ $# -gt 0 ]]
do
key=$1

case $key in
	-b|--build|build)
	shift
	docker-compose build
	shift
	;;
	*)
	echo "unknown option $key"
	exit 1
	;;
esac
done 

docker-compose up
