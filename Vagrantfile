#!/usr/bin/env ruby
# vagrant development environment

# read settings file
require "yaml"
cd = File.dirname(__FILE__)
settings = YAML.load_file("#{cd}/settings.yaml")

# check for requried plugins
settings["plugins"].each do |plugin|
  unless Vagrant.has_plugin?(plugin)
    raise "Missing plugin! Run: vagrant plugin install #{plugin}"
  end
end

Vagrant.configure(2) do |config|

  # virtual box settings
  config.vm.box = settings["box"]
  config.vm.hostname = settings["hostname"]
  config.vm.provider :virtualbox do |vb|
    vb.name = "LDAP Development"
    vb.memory = 1024
    vb.cpus = 2
  end

  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

  # install puppet agent
  config.vm.provision :shell, inline: <<-SHELL
    if ! type -p puppet >/dev/null 2>&1; then
      rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
      yum install -y puppet-agent
    fi
  SHELL

  # install puppet modules
  settings["modules"].each do |mod|
    config.vm.provision :shell, inline: "puppet module install " + mod
  end

  # apply puppet configuration
  config.vm.provision :shell, inline: "puppet apply /vagrant/default.pp"

end
