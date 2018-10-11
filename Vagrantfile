# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  PORTS = {
    8080 => 8080,
    #5666 => 5600,
    #3000 => 3001,
    #6379 => 6379,
    #80   => 80,
    #443  => 443,
    #22   => 22
  }

  PORTS.each_pair do |guest, host|
    config.vm.network "forwarded_port", guest: guest, host: host
  end

  config.vm.synced_folder ".", "/srv/dashboard-tool"
  if Etc.getlogin == "josh" && Dir.exist?("../etl")
    config.vm.synced_folder "../etl", "/srv/etl"
  end

  config.vm.provider "virtualbox" do |vb|
    # Don't boot with headless mode
    # vb.gui = true
    vb.customize ["modifyvm", :id, "--memory", "4096"]
  end

  config.vm.provision :shell, :path => "vagrant/provision.sh"

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = './cookbooks'

    chef.add_recipe 'git'
    chef.add_recipe 'ruby_build'
    chef.add_recipe 'redis::default'
    chef.add_recipe 'redis::server'
    chef.add_recipe 'redis::client'
    chef.add_recipe 'memcached'
  end

  config.vm.provision :shell, :path => "vagrant/install-ruby.sh"
  config.vm.provision :shell, :path => "vagrant/setup-ssh.sh"
  config.ssh.forward_agent = true
  config.ssh.private_key_path = ["~/.vagrant.d/insecure_private_key", "~/.ssh/id_rsa"]
  config.ssh.insert_key = false
  config.vm.provision :shell, :path => "vagrant/install-karma.sh"
end
