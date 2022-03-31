# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version '>= 1.8.0'

Vagrant.configure('2') do |config|
    config.vm.box = 'bento/ubuntu-20.04'

    config.vm.provider :virtualbox do |vb|
        vb.name = 'chef-tutorial';
        vb.customize ['modifyvm', :id, '--cpus', 2]
        vb.customize ['modifyvm', :id, '--ioapic', 'on']
        vb.customize ['modifyvm', :id, '--memory', 2048]
        vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
    end

    config.vm.provision :chef_solo do |chef|
        chef.version = '16.17.51'
        chef.arguments = '--chef-license accept'
        chef.install = true
        chef.channel = 'stable'
        chef.log_level = :info
        chef.add_recipe 'welcome_message::default'
    end
end
