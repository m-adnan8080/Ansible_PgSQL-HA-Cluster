# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  # Add proxy config to VM
  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = "http://172.16.0.28:8080/"
    config.proxy.https    = "http://172.16.0.28:8080/"
    config.proxy.ftp      = "http://172.16.0.28:8080"
    config.proxy.no_proxy = "localhost,127.0.0.1"
  end

  # Add current user ssh public key to VM
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "/home/vagrant/id_rsa.pub"
  config.vm.provision "shell", inline: <<-SHELL
    cat /home/vagrant/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
    rm /home/vagrant/id_rsa.pub
  SHELL

  config.vm.provider "virtualbox" do |vb|
     vb.memory = "512"
     vb.linked_clone = true
  end

  config.vm.define "master", primary: true do |server|
    server.vm.hostname = "master.test"
    server.vm.network "private_network", ip: "172.16.10.11"
  end

  config.vm.define "slave1" do |server|
    server.vm.hostname = "slave1.test"
    server.vm.network "private_network", ip: "172.16.10.12"
  end

  config.vm.define "slave2" do |server|
    server.vm.hostname = "slave2.test"
    server.vm.network "private_network", ip: "172.16.10.13"
  end

  config.vm.define "pgbouncer" do |server|
    server.vm.hostname = "pgbouncer.test"
    server.vm.network "private_network", ip: "172.16.10.14"
  end
end
