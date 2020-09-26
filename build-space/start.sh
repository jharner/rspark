#! /bin/bash

docker build -t base-image:bionic ./base-image
while [[ $# -gt 0 ]]
do
key=$1

case $key in
	-b|--build|build)
	docker-compose build
	;;
	*)
	echo "unknown option $key"
	exit 1
	;;
esac
shift
done 

docker-compose up -d


