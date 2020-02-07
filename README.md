![logo](./rsparklogo.jpg)

## RSpark Development Repository

This repo is used to build docker images for R/RStudio, Postgres, Hadoop, Hive, and Spark. Building the images and deploying the images as Docker containers can be done in several ways as described below.  

### Versions info

Operating Systems Requirements:  

* Mac OS 10.11 or greater  
* Windows 10 Enterprise or Professional  

Versions built:  

* R			3.6.1  
* Java		OpenJDK 8  
* Hadoop 	2.9.2
* Hive 		2.1.1  
* Postgres	9.6   
* Spark		2.4.4 (for Hadoop 2.7.1 or greater)  

### Building `rspark` from this repo

Clone this `rspark` repo using the following `git` command:  

git clone https://github.com/jharner/rspark.git

`rspark` can then be built in one of two ways on your local computer (assuming you meet the system requirements):

1. Spark integrated into the `rstudio` container as a single node

This single-node Spark environment can be built by running the following `bash` script in the `rspark` directory (`cd` as necessary):

./start.sh build

2. Spark deployed as a small cluster

This "cluster" Spark environment can be built by running the following `bash` script (assuming you are in the `rspark` directory):

./startspark.sh build

Building the images and launching the containers will take time, but once complete, leave the shell script running in your terminal, i.e., do not quit or close the terminal window. Open a browser and enter `localhost:8787` as the URL:port and login with credential `rstudio` for the user name and and `rstudiojh` as the password.

Use Control-C to stop the containers.

To restart the containers type:  

./start.sh  

without the `build` option.

#### Deleting containers, images, and volumes

If you are modifying Dockerfiles, which are used to build images, and something goes wrong or if you get into trouble for whatever reason, you often want to destroy the containers and images. To do this, from the `rspark` directory, run:  

./dockill.sh

Click on the return or the enter key for interactive choices. Note that containers are running instances of images. Therefore, you should stop and delete containers before deleting images and volumes.

At this point, you will need to rebuild `rspark` from scratch, i.e., execute `./start.sh build`.

### Debugging containers

You can `ssh` into any container and run a bash shell to debug issues within the container. First you meed to identify the name or ID of the container you wish to enter. The following Docker command provides this information: 

docker ps

Then you can run an interactive bash shell by the `docker exec` command by specifying the container name and the program name `bash`. For example, to run bash inside the `rstudio` container, execute the following: 

docker exec -it rspark_rstudio_1 bash

which provides you root access.

You can also run the bash shell built into the `rstudio` container directly from the terminal in RStudio.

### Building `rspark` from the DockerHub Images.

The method presented in this section is the preferred way to run `rspark` The above approaches are primarily for development purposes. However, using the pre-built images in DockerHub only allows a single node version of Spark to be built. The "cluster" version must be built from scratch, at least for now.

The `rspark` Docker images, built from the `rspark` repo, are available on DockerHub. Go to [DockerHub](https://hub.docker.com) and search for `jharner`.

However, it is not necessary to manually download the tagged images from DockerHub. The `rspark-docker` repo will do this for you. The directions for building and launching the Docker containers are available in the README file here:  

https://github.com/jharner/rspark-docker  

The `start` shell script will download the Docker images from DockerHub and launch the containers. If any of the Docker images have been upgraded, the newer version will be used.

### Building `rspark` using Vagrant

Running `rspark` in Docker containers is only possible if a hypervisor is available. All platforms have a hypervisor, e.g., Hypervisor in macOS and Hyper-V in Windows. However, Hyper-V is only available for the Professional and Enterprise versions of Windows 10. 

An alternative is to run `rspark` in Docker containers within a virtual machine (VirtualBox here) running Linux provisioned by Vagrant. VirtualBox and Vagrant run on recent versions of all platforms. 

The directions for running `rspark` using Vagrant are found in the README file of the `rspark-vagrant` repo found here:

https://github.com/jharner/rspark-vagrant

The docker images are pre-loaded within the virtual machine. Thus, it is only necessary to run the `start` shell script.

This may be be the best option for Windows users. Another option is to run `rspark` using Amazon Web Services (AWS). Here, only a modern web browser is needed.

### Running `rspark` on AWS

AWS allows users to create virtual machines in the AWS cloud among other services. The cost of using AWS services is based on the computing power required, the amount of storage, and the run-time of the service. However, this cost is minimal for the services needed in this course. Thus, to use `rspark` with AWS, you need to be prepared to pay for the cloud services you utilize unless you have received an academic free allocation.

Prerequisites:  

* Amazon Web Services Account  
* Modern Browser (Safari, Chrome, or Firefox)

Detailed instructions for running `rspark` an AWS are available here:  

[rspark on AWS](https://github.com/jharner/rspark/blob/master/AWS/README.md)

The pre-built image on AWS is called `rsparkbox3` and it contains the `rspark-tutorial`. Once you follow the steps in the README, connect to your `rspark` server through a web browser.

**Note** If you are given an IP address for you instance, enter it into your browser's URL bar as 'http://0.0.0.0:8787' replacing '0.0.0.0' with the IP address of your instance. In this case you do not need an AWS account. Log into RStudio with the credentials:

		username: rstudio
		password: rstudiojh

**IMPORTANT:** When you have finished using `rspark`, you need to stop or terminate your EC2 instance. If you neglect to do this, you will be charged by Amazon for the duration it is left running.

### Future plans

Building the docker images needs to be more robust. In particular, the container dependencies can be violated depending on the processing power of the installation computer and the network speeds among other issues not under the control of the developer.

The plan is to scale `rspark` up, e.g., the size of the Spark cluster, and to mangage dependencies using Kubernetes.  Kubernetes is being built into Spark by the core team and an external team is working on scaling up HDFS for distributed storage. 



 




