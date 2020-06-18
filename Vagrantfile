# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.ssh.insert_key = false

  config.vm.define "manager", primary: true do |manager|
#    manager.vm.box="nikolovmiroslav/devops-hw1-bionic64"
#	manager.vm.box_version = "0.2"
    manager.vm.box="nikolovmiroslav/devops-docker_ubuntu-bionic64"
	manager.vm.box_version = "0.2"
    manager.vm.hostname = "manager.dob.lab"
	manager.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true
    manager.vm.network "private_network", ip: "192.168.89.100"
    manager.vm.synced_folder "swarm/", "/swarm"
	manager.vm.synced_folder "web/", "/web"
	manager.vm.synced_folder "db/", "/db"
#    manager.vm.provision "shell", path: "install_docker.sh"  # needed if devops-hw1-bionic64(bionic64+virtualbox addons) is used
	manager.vm.provision "shell", path: "swarm_common.sh"
    manager.vm.provision "shell", path: "swarm_manager.sh"
	manager.vm.provider "virtualbox" do |vb|
      vb.name = "manager"
      vb.memory = "1024"
    end
  end

	(1..2).each do |i|
	  config.vm.define "worker0#{i}" do |worker1|
#	    worker1.vm.box="nikolovmiroslav/devops-hw1-bionic64"
#		worker1.vm.box_version = "0.2"
		worker1.vm.box="nikolovmiroslav/devops-docker_ubuntu-bionic64"
		worker1.vm.box_version = "0.2"
		worker1.vm.hostname = "worker0#{i}.dob.lab"
		worker1.vm.network "private_network", ip: "192.168.89.10#{i}"
		worker1.vm.synced_folder "swarm/", "/swarm"
		worker1.vm.synced_folder "web/", "/web"
		worker1.vm.synced_folder "db/", "/db"
#	    worker1.vm.provision "shell", path: "install_docker.sh"  # needed if devops-hw1-bionic64(bionic64+virtualbox addons) is used
		worker1.vm.provision "shell", path: "swarm_common.sh"
		worker1.vm.provision "shell", path: "swarm_worker.sh"
		worker1.vm.provider "virtualbox" do |vb|
		  vb.name = "worker0#{i}"
		  vb.memory = "1024"
		end
	  end
	end

end
 
