# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 2.3.7"

$script = <<-SCRIPT
echo I am provisioning...
date > /etc/vagrant_provisioned_at
wget -O bootstrap-salt.sh https://bootstrap.saltproject.io
sudo sh bootstrap-salt.sh
SCRIPT

Vagrant.configure("2") do |config|
  os = "ubuntu/jammy64"
  net_ip = "192.168.56"

  config.vm.define :master, primary: true do |master_config|
    master_config.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
      vb.name = "master"
    end

    master_config.vm.box = "#{os}"
#    master_config.vm.host_name = 'saltmaster.local'
    master_config.vm.host_name = 'salt'
    master_config.vm.network "private_network", ip: "#{net_ip}.10"
    master_config.vm.synced_folder ".", "/srv/salt_states"
    master_config.vm.synced_folder "../dedfour_salt_pillar/", "/srv/salt_pillar"

   master_config.vm.provision :salt do |salt|
     salt.master_config = "./etc/master"
     salt.install_master = true
     salt.master_key = "./keys/master_minion.pem"
     salt.master_pub= "./keys/master_minion.pub"
   end





  end
end
