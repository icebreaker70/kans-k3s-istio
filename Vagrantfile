# for MacBook Air - M1 with vmware-fusion
BOX_IMAGE = "bento/ubuntu-22.04-arm64"
BOX_VERSION = "202401.31.0"

# max number of worker nodes : Ex) N = 3
N = 3

# Version : Ex) k8s_V = '1.31'
k8s_V = '1.30'
proj_N = 'kans'

Vagrant.configure("2") do |config|
#-----Manager Node
    config.vm.define "k3s-s" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.box_version = BOX_VERSION
      subconfig.vm.provider "vmare_desktop" do |v|
        v.customize ["modifyvm", :id, "--groups", "/#{proj_N}"]
        v.customize ["modifyvm", :id, "--nicpromisc2", "allow-vms"]
        v.name = "#{proj_N}-k3s-s"
        v.memory = 2048
        v.cpus = 2
        v.linked_clone = true
      end
      subconfig.vm.hostname = "k3s-s"
      subconfig.vm.synced_folder "./", "/vagrant", disabled: true
      subconfig.vm.network "private_network", ip: "192.168.10.10"
      subconfig.vm.network "forwarded_port", guest: 22, host: 50010, auto_correct: true, id: "ssh"
      subconfig.vm.provision "shell", path: "scripts/k3s-s.sh", args: [ k8s_V ]
    end

#-----Worker Node Subnet1
  (1..N).each do |i|
    config.vm.define "k3s-w#{i}" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.box_version = BOX_VERSION
      subconfig.vm.provider "vmare_desktop" do |v|
        v.customize ["modifyvm", :id, "--groups", "/#{proj_N}"]
        v.customize ["modifyvm", :id, "--nicpromisc2", "allow-vms"]
        v.name = "#{proj_N}-k3s-w#{i}"
        v.memory = 2048
        v.cpus = 1
        v.linked_clone = true
      end
      subconfig.vm.hostname = "k3s-w#{i}"
      subconfig.vm.synced_folder "./", "/vagrant", disabled: true
      subconfig.vm.network "private_network", ip: "192.168.10.10#{i}"
      subconfig.vm.network "forwarded_port", guest: 22, host: "5001#{i}", auto_correct: true, id: "ssh"
      subconfig.vm.provision "shell", path: "scripts/k3s-w.sh", args: [ i, k8s_V ]
    end
  end

end
