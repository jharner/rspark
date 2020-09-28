#!/usr/bin/env bash

# docker login -u username -p password
USERNAME="jharner"
IMAGE=$1
REPONAME=$USERNAME/$IMAGE
TAG=1.0.0

docker tag $IMAGE:latest $REPONAME:$TAG
docker push $REPONAME:$TAG