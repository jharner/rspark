## create a vagrant VM to use as a template

1. Copy the Vagrantfile to a new directory

2. In that directory, run `vagrant up` followed by `vagrant ssh`

## Run the following commands inside the vagrant VM:

		sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
		sudo vi /etc/apt/sources.list.d/docker.list
			deb https://apt.dockerproject.org/repo ubuntu-xenial main
		sudo apt-get update
		sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual
		sudo apt-get install docker-engine
		sudo usermod -aG docker vagrant
		sudo service docker start
		exit

You should now be back at the macOS terminal.

## transfer images to vagrant

		docker save -o images.tar rsprk-hadoop rsprk-hive rsprk-postgres rsprk-rstudio`	
		vagrant ssh
		docker load -i /vagrant/images.tar
		sudo dd if=/dev/zero of=wipefile bs=1024*1024; rm wipefile (#to free up disk space)
		exit

## build the .box (all on macOS)

1. `vagrant halt`
	
2. `/Applications/VirtualBox.app/Contents/MacOS/VBoxManage showhdinfo /Users/mlilback/VirtualBox\ VMs/vagrant_default_1505941216004_67319/ubuntu-16.04-amd64-disk001.vmdk`

	*(use the appropriate path for your machine. Note the UUID for later.)*

3.  `vboxmanage clonehd /Users/mlilback/VirtualBox\ VMs/vagrant_default_1505941216004_67319/ubuntu-16.04-amd64-disk001.vmdk clone.vdi --format vdi` *(to create clone.vdi)*

4. Use `vboxmanage modifyhd clone.vdi --compact` to minimize the size

5. `vboxmanage clonehd clone.vdi new.vmdk --format vmdk` will convert it back.

6. Update the UUID with the one noted in step 1: `vboxmanage internalcommands sethduuid new.vmdk a19b892d-684b-418c-96fa-c8768bdb9958`

7. Replace the original vmdk file with new.vmdk, using the original name.

8. `vagrant up`

9. `vagrant package --output rspark.box`

10. Upload the box to vagrantcloud.com





