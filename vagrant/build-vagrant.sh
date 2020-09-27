#! /bin/bash

docker-compose build

mkdir ../../rspark-vagrant
mv Vangrantfile ../../rspark-vagrant
cd ../../rspark/vagrant

vagrant up
vagrant ssh

gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
gpg -a --export 58118E89F3A912897C070ADBF76221572C52609D| apt-key add -
add-apt-repository -s 'deb https://apt.dockerproject.org/repo ubuntu-bionic main'
sudo apt-get update
sudo apt-get install linux-image-extra-virtual
sudo apt-get install docker-engine docker-compose
sudo usermod -aG docker vagrant
sudo service docker start
exit

# docker save -o images.tar rspark-hadoop rspark-hive rspark-postgres rspark-rstudio
docker save -o images.tar rhadoop:2.10.0 rcompute:bionic-R.3.6.3 rhive:2.1.1 rhive:2.1.1
vagrant up
vagrant ssh
docker load -i /vagrant/images.tar
exit

#vagrant package --output rspark.box
#
#vagrant box remove jharner/rspark
#vagrant box add rspark.box --name jharner/rspark.box
