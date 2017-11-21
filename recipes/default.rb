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
    command 'apt-get install git wget ruby -y'
  end

  execute 'Install Ruby on Debian' do
    command 'apt-get install ruby -y'
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

  #openssh_server '/etc/ssh/sshd_config' do
  #  PasswordAuthentication yes
  #end
end

if node['platform_family'] == "rhel"
  execute 'Update RHEL based operatings systems' do
    command 'yum update -y'
  end

  execute 'Install git and wget on RHEL' do
    command 'yum install git wget -y'
  end

  bash 'install rvm' do
    code <<-EOH
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    curl -sSL https://get.rvm.io | sudo bash -s stable
    usermod -a -G rvm `whoami`
    if sudo grep -q secure_path /etc/sudoers; then sudo sh -c "echo export rvmsudo_secure_path=1 >> /etc/profile.d/rvm_secure_path.sh" && echo Environment variable installed; fi
    source /etc/profile.d/rvm.sh
    rvm install 2.2.
    echo $'\nsource /etc/profile.d/rvm.sh' > /root/.bashrc
    EOH
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
    command 'yum install git wget openssl-devel readline-devel zlib-devel -y'
  end

  #bash 'install rvm' do
  #  code <<-EOH
  #  cd ~/
  #  git clone git://github.com/sstephenson/rbenv.git .rbenv
  #  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
  #  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
  #  exec $SHELL
  #  git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  #  echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile
  #  exec $SHELL
  #  source ~/.bash_profile
  #  rbenv install 2.4.1
  #  rbenv global 2.4.1
  #  EOH
  #end

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
    command '/bin/echo \'cloud_user ALL=(ALL) NOPASSWD: ALL\' >> /etc/sudoers'
  end
end

service 'sshd' do
  action :start
end
