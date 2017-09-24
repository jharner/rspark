#!/bin/bash

function finish {
	vagrant halt
}
trap finish EXIT

vagrant up
vagrant ssh -c "docker-compose up"

