#!/usr/bin/env bash

# docker login -u username -p password
USERNAME="jharner"
IMAGE=$1
REPONAME=$USERNAME/$IMAGE
TAG=1.0.1

docker tag $IMAGE:latest $REPONAME:$TAG
docker push $REPONAME:$TAG

# postgres: 1.0.1: digest: sha256:c2f437e07ab3c24b2b01764c3c7ba9b859e6d294ea18d315d09d29fd301d0f29 size: 2201
# hadoop: 1.0.1: digest: sha256:c9b0119e7df6de7cadfbb3a0c9c17f2794c1127b95fc7719e14a173457c73bb8 size: 4483
# hive: 1.0.1: digest: sha256:87a1a5b8c091ec84ee0063f4d00b092990745b1a3039d2586a8542d1bba469bc size: 3451
# rstudio: 1.0.1: digest: sha256:5980938dd7b6448abe16cc237a65684acafa1bf8dba262d588abc868718c5270 size: 5152