# Create rspark box

These are instructions to Create a vagrant box with the rspark docker images ready to run on a system without a hypervisor (windows home)

## create a vagrant VM to use as a template

1. In the same rspark directory (should be parent of the directory with this file), execute: `docker-compose build`.

2. Copy the Vagrantfile to a new directory outside the git tree

3. In that directory, run `vagrant up` followed by `vagrant ssh`

## Run the following commands inside the vagrant VM:

# 		sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys #58118E89F3A912897C070ADBF76221572C52609D

#		sudo apt-get update
#		sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
		sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
		sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs)  stable"
		sudi apt-get update
		sudo apt-get install -y linux-image-extra-virtual
		sudo apt-get install -y docker-ce
		sudo usermod -aG docker vagrant
		sudo service docker start
		exit
		
		vagrant halt

You should now be back at the macOS terminal.

Steps 1--9 not needed with ubuntu-18.04 (Storage now 64GB).

execute `PATH=$PATH:/Applications/VirtualBox.app/Contents/MacOS/` to aid in next steps.

## increase capacity of VM disk (Under 18.04 the capacity is ok.)

1. Find the filename for the VM: it will be in a subfolder of `~/VirtualBox VMs/` It should end in `.vmdk` and be 10 GB in size. For example: `VirtualBox VMs/vagrant-rspark-dev_default_1600982441001_35535/ubuntu-18.04-amd64-disk001.vmdk`

2. Note the UUID for the drive: `VBoxManage showhdinfo <PATH from #1>`, first line of output.

3. Clone the drive to vdi format. `VBoxManage clonehd <PATH from #1> cloned.vdi --format vdi`

4. Resize it: `VBoxManage modifyhd cloned.vdi --resize 20000`

5. Convert back to vmdk: `VBoxmManager clonehd cloned.vdi cloned.vmdk --format vmdk`

6. Reset the UUID: `VBoxManage internalcommands sethduuid cloned.vmdk <UUID from #2>`

7. Copy back modified drive: `cp cloned.vmdk <PATH from #1>`

8. Delete cloned.vmdk, cloned.vdi

9. Step 2 should now show the drive size being 20 GB.

## transfer images to vagrant

docker save -o images.tar rspark-hadoop rspark-hive rspark-postgres rspark-rstudio
vagrant up
vagrant ssh
docker load -i /vagrant/images.tar
exit

## build the .box

1. `vagrant package --output rspark.box`
	
2. Upload the box to vagrantcloud.com

## test locally

vagrant box remove jharner/rspark
vagrant box add rspark.box --name jharner/rspark.box


# TODO: download docker-compose binary

