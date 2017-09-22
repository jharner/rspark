
## setup clean vagrant ubuntu image

	sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
	sudo vi /etc/apt/sources.list.d/docker.list
		deb https://apt.dockerproject.org/repo ubuntu-xenial main
	sudo apt-get update
	sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual
	sudo apt-get install docker-engine
	sudo usermod -aG docker vagrant
	sudo service docker start

exit and login again (for group change to take)

## transferring images to vagrant

	docker save -o images.tar jh-hadoop jh-hive jh-postgres jh-rstudio
	
in vagrant run

	docker load -i /vagrant/images.tar

in vagrant, run `sudo dd if=/dev/zero of=wipefile bs=1024*1024; rm wipefile` to free up disk space.

# build .box

1. with machine halted, run on mac `/Applications/VirtualBox.app/Contents/MacOS/VBoxManage showhdinfo /Users/mlilback/VirtualBox\ VMs/vagrant_default_1505941216004_67319/ubuntu-16.04-amd64-disk001.vmdk` using the appropriate path on your machine. Note the UUID.

2. use `vboxmanage clonehd /Users/mlilback/VirtualBox\ VMs/vagrant_default_1505941216004_67319/ubuntu-16.04-amd64-disk001.vmdk clone.vdi --format vdi` to create clone.vdi.

3. Use `vboxmanage modifyhd clone.vdi --compact` to minimize the size

4. `vboxmanage clonehd clone.vdi new.vmdk --format vmdk` will convert it back.

5. Update the UUID with the one noted in step 1: `vboxmanage internalcommands sethduuid new.vmdk a19b892d-684b-418c-96fa-c8768bdb9958`

5. Replace the original vmdk file with new.vmdk, using the original name.

6. `vagrant up`

7. `vagrant package --output rspark.box`






