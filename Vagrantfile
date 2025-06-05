# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.synced_folder "./share", "/mnt/host_machine", create: true
  config.vm.provider :virtualbox do |vb|
      vb.memory = "4096"
      vb.cpus = 2
  end
  config.vm.provision "shell", path: "provisioning/install.sh"
end