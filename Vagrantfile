# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(2) do |config|
  config.vm.box = "opscode-ubuntu-14.04"
  config.vm.define "master" do |master|
    master.vm.hostname = "ldapconsole-test.example.com"
    master.vm.network "forwarded_port", guest: 4567, host: 4567
  end
end

