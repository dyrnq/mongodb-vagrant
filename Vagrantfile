# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/focal64"

    config.vm.box_check_update = false
    config.ssh.insert_key = false
    # insecure_private_key download from https://github.com/hashicorp/vagrant/blob/master/keys/vagrant
    config.ssh.private_key_path = "insecure_private_key"




    my_machines = {
        'vm214'   => '192.168.55.214',
        'vm215'   => '192.168.55.215',
        'vm216'   => '192.168.55.216',
    }

    my_machines.each do |name, ip|
        config.vm.define name do |machine|
            machine.vm.network "private_network", ip: ip

            machine.vm.hostname = name
            machine.vm.provider :virtualbox do |vb|
                vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
                vb.customize ["modifyvm", :id, "--vram", "128"]
                vb.customize ["modifyvm", :id, "--ioapic", "on"]
                vb.customize ["modifyvm", :id, "--cpus", "2"]
                vb.customize ["modifyvm", :id, "--memory", "3072"]
            end

            machine.vm.provision "shell", inline: <<-SHELL
                echo "root:vagrant" | sudo chpasswd
                timedatectl set-timezone "Asia/Shanghai"
                curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/dyrnq/install-docker/main/install-docker.sh | bash -s docker \
                --mirror sjtu \
                --version 20.10.23 \
                --systemd-mirror ghproxy && \
                usermod -aG docker vagrant
            SHELL
        end
    end


end