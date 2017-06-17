# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "trusty64"
  config.vm.provision :shell, :path => "et_setup.sh", :privileged => false
  config.ssh.username = 'vagrant'
  config.ssh.forward_agent = true

  config.vm.synced_folder "host-share", "/home/vagrant/host-share"

  config.vm.provider "virtualbox" do |v, override|
    override.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
    v.customize ["modifyvm", :id, "--memory", "4096"]
  end

  config.vm.provider "vmware_fusion" do |v, override|
    override.vm.box = "bento/ubuntu-14.04"
    v.vmx['memsize'] = 4096
  end

  config.vm.provider "vmware_desktop" do |v, override|
    override.vm.box = "bento/ubuntu-14.04"
    v.vmx['memsize'] = 4096
  end

  config.vm.provider "vmware_workstation" do |v, override|
    override.vm.box = "bento/ubuntu-14.04"
    v.vmx['memsize'] = 4096
  end
end

