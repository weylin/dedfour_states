# -*- mode: ruby -*-
# vi: set ft=ruby :

pillar = 'dedfour_salt_pillar'

Vagrant.require_version ">= 2.3.7"

Vagrant.configure("2") do |config|
  os = "ubuntu/jammy64"
  net_ip = "192.168.56"

  config.vm.define :master, primary: true do |master_config|
    master_config.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 1
      vb.name = "master"
    end

    master_config.vm.box = "#{os}"
    master_config.vm.host_name = 'salt-master'
    master_config.vm.network "private_network", ip: "#{net_ip}.10"
    master_config.vm.synced_folder ".", "/srv/salt"
    master_config.vm.synced_folder "../#{pillar}/", "/srv/pillar"

    master_config.vm.provision :salt do |salt|
      salt.install_master = true
      salt.master_key = "./keys/master_minion.pem"
      salt.master_pub= "./keys/master_minion.pub"
      salt.master_config = "salt_master/files/vagrant_master.conf"
      salt.minion_config = "salt_minion/files/vagrant_minion.conf"
    end
  end

  config.vm.define :bots do |bots_config|
    bots_config.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 2
      vb.name = "bots"
    end

    bots_config.vm.box = "#{os}"
      bots_config.vm.host_name = 'bots'
      bots_config.vm.network "private_network", ip: "#{net_ip}.11"
      bots_config.vm.synced_folder ".", "/srv/salt_states"
      bots_config.vm.synced_folder "../#{pillar}/", "/srv/salt_pillar"

    bots_config.vm.provision :salt do |salt|
      salt.minion_config = "salt_minion/files/vagrant_minion.conf"
    end
  end
end
