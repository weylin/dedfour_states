# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Salt Master Container
  config.vm.define "master" do |master|
    master.vm.network "private_network", ip: "172.28.128.3"
    master.vm.hostname = "salt-master"
    master.vm.provider "docker" do |d|
      d.image = "ubuntu:22.04"
      d.name = "salt-master"
      d.ports = ["4505:4505", "4506:4506"]
      d.volumes = [
        ".:/srv/salt",
        "../dedfour_salt_pillar:/srv/pillar",
      ]
      d.remains_running = true
      d.cmd = ["tail", "-f", "/dev/null"]
      d.create_args = ["--memory=2g", "--cpus=1"]
    end

    master.vm.provision "shell", inline: "echo '172.17.0.3 salt-master' >> /etc/hosts"
    master.vm.provision "shell", inline: "apt-get update && apt-get install -y salt-master salt-minion"
    master.vm.provision "shell", inline: "cp /vagrant/vagrant/files/vagrant_master.conf /etc/salt/master.d/master.conf && cp /vagrant/vagrant/files/vagrant_master_roles /etc/salt/grains"
    master.vm.provision "shell", inline: "service salt-master start"
    master.vm.provision "shell", inline: "service salt-minion start"
    master.vm.provision "salt" do |salt|
      salt.install_master = true
      salt.install_type = "stable"
      salt.version = "3006.1"
      salt.master_config = "vagrant/files/vagrant_master.conf"
      salt.minion_config = "vagrant/files/vagrant_minion.conf"
      salt.seed_master = {
        "bots" => "keys/bots.pub"
      }
      salt.grains_config = "vagrant/files/vagrant_master_roles"
    end
  end

  # Salt Minion Container ("bots")
  config.vm.define "bots" do |bots|
    bots.vm.hostname = "bots"
    bots.vm.provision :shell, inline: "sleep 2"
    bots.vm.provision "shell", inline: "echo '172.17.0.3 salt-master' >> /etc/hosts"
    bots.vm.provision "shell", inline: "apt-get update && apt-get install -y salt-minion"
    bots.vm.provision "shell", inline: "cp /vagrant/vagrant/files/vagrant_minion.conf /etc/salt/minion.d/minion.conf && cp /vagrant/vagrant/files/vagrant_bots_roles /etc/salt/grains"
    bots.vm.provision "shell", inline: "service salt-minion start"
    bots.vm.provider "docker" do |d|
      d.image = "ubuntu:22.04"
      d.name = "salt-minion-bots"
      d.volumes = [
        ".:/srv/salt",
        "../dedfour_salt_pillar:/srv/pillar",
      ]
      d.remains_running = true
      d.cmd = ["tail", "-f", "/dev/null"]
      d.create_args = ["--memory=2g", "--cpus=1"]
    end

    bots.vm.provision "salt" do |salt|
      salt.install_type = "stable"
      salt.version = "3006.1"
      salt.minion_config = "vagrant/files/vagrant_minion.conf"
      salt.minion_key = "keys/bots.pem"
      salt.minion_pub = "keys/bots.pub"
      salt.grains_config = "vagrant/files/vagrant_bots_roles"
    end
  end
end