FROM ubuntu:16.04

# This dockerfile assumes that you are running Ubuntu 16.04 with ansible and git already installed

# RUN useradd -ms /bin/bash dockerboy

# RUN groupadd docker
# RUN usermod -G docker -a 'dockerboy'



RUN apt-get update
RUN apt-get -y install ansible git



ADD setup.yml /
ADD install-docker.yml /
#CMD ["ansible-playbook", "setup.yml"]

#CMD ["ansible-playbook", "setup.yml"]
RUN ansible-playbook setup.yml

CMD ["/bin/bash"]