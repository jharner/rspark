![logo](./rsparklogo.jpg)

## RSpark Development Repository

This repo is used to build docker images for R/RStudio, Postgres, Hadoop, Hive, and Spark.  

### Versions Info

Operating Systems Requirements:  

* Mac OS 10.11 or greater  
* Windows 10 Enterprise or Professional  

Versions built:  

* Java		OpenJDK 8  
* Hadoop 	2.7.4  
* Hive 		2.1.1  
* Postgres	2.4  
* Spark		2.2.1 (for Hadoop 2.7.1 or greater)  

### Building `rspark` from this repo

Clone this `rspark` repo first using the following `git` command:  

git clone https://github.com/jharner/rspark.git

`rspark` can then be built in one of two ways on your local computer as long as you meet the system requirements:

1. Spark integrated into the `rstudio` container as a single node

This single-node Spark environment can be built by running the following `bash` script (assuming you are in the `rspark` directory):

./start.sh build

2. Spark deployed as a small cluster

This "cluster" Spark environment can be built by running the following `bash` script (assuming you are in the `rspark` directory):

./startspark.sh build

Once the build is done (leave the shell script running in your terminal), open a browser with `localhost:8787` and login with credential `rstudio` for both the user name and password.

Use Control-C to stop the containers.

To restart the containers type:  

./start.sh  

With the `build` option.

### Building `rspark` from the DockerHub Images.

The `rspark` Docker images are available on DockerHub. Go to [DockerHub](https://hub.docker.com) and search for `jharner`.


