# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provision "file", source: "docker/decompile", destination: "/home/vagrant/decompile"
  config.vm.provision :shell, :path => "et_setup.sh", :privileged => false

  config.ssh.username = "vagrant"
  config.ssh.forward_agent = true

  config.vm.synced_folder "host-share", "/home/vagrant/host-share"

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "4096"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end
end
