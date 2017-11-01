#
# Cookbook:: bootstrap
# Recipe:: default
#
# Copyright:: 2017, Travis N. Thomsen for Linux Academy, All Rights Reserved.

include_recipe 'sshd::default'

service 'sshd' do
  action :stop
end

if node['platform_family'] == "debian"
  execute 'Update Debian based operating systems' do
    command 'apt-get update -y'
  end

  execute 'Install git and wget on Debian' do
    command 'apt-get install git wget -y'
  end

  user 'cloud_user' do
    home '/home/cloud_user'
    manage_home true
    shell '/bin/bash'
    password '$1$linuxaca$iGMxZ4g4lbPmfEDPhW3lw1'
    salt 'linuxacademy'
    gid 'sudo'
  end

  group 'cloud_user' do
    members 'cloud_user'
  end

  execute 'add cloud_user to sudoers' do
    command '/bin/echo \'cloud_user ALL=(ALL:ALL) NOPASSWD: ALL\' >> /etc/sudoers'
  end

  openssh_server '/etc/ssh/sshd_config' do
    PasswordAuthentication yes
  end
end

if node['platform_family'] == "rhel"
  execute 'Update RHEL based operatings systems' do
    command 'yum update -y'
  end

  execute 'Install git and wget on RHEL' do
    command 'yum install git wget -y'
  end

  execute 'add cloud_user to sudoers' do
    command '/bin/echo \'cloud_user  ALL=(ALL)  NOPASSWD: ALL\' >> /etc/sudoers'
  end
end

if node['platform_family'] == "amazon"
  execute 'Update Amazon based operatings systems' do
    command 'yum update -y'
  end

  execute 'Install git and wget on Amazon' do
    command 'yum install git wget -y'
  end

  user 'cloud_user' do
    home '/home/cloud_user'
    manage_home true
    shell '/bin/bash'
    password '$1$linuxaca$iGMxZ4g4lbPmfEDPhW3lw1'
    salt 'linuxacademy'
  end

  group 'cloud_user' do
    members 'cloud_user'
  end
  openssh_server '/etc/ssh/sshd_config' do
    PasswordAuthentication yes
  end

  execute 'add cloud_user to sudoers' do
    command '/bin/echo \'cloud_user  ALL=(ALL)  NOPASSWD: ALL\' >> /etc/sudoers'
  end
end

service 'sshd' do
  action :start
end
