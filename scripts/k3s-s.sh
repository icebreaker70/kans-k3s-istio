#!/bin/bash
hostnamectl --static set-hostname k3s-s

# swap disable
echo "Swap Disable"
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab


# Config convenience
echo 'alias vi=vim' >> /etc/profile
echo "sudo su -" >> /home/vagrant/.bashrc
ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# Disable ufw & apparmor
systemctl stop ufw && systemctl disable ufw
systemctl stop apparmor && systemctl disable apparmor

# Install packages
apt update && apt-get install bridge-utils net-tools conntrack ngrep jq tree unzip kubecolor kubetail -y

# local dns - hosts file
echo "192.168.10.10  k3s-s" >> /etc/hosts
echo "192.168.10.101 k3s-w1" >> /etc/hosts
echo "192.168.10.102 k3s-w2" >> /etc/hosts
echo "192.168.10.103 k3s-w3" >> /etc/hosts

# Install k3s-server
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC=" --disable=traefik"  sh -s - server --token kanstoken --bind-address 192.168.10.10 --node-ip 192.168.10.10 --cluster-cidr "172.16.0.0/16" --service-cidr "10.10.200.0/24" --write-kubeconfig-mode 644

# Change kubeconfig
echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >> /etc/profile

# Install Helm
curl -s https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Alias kubectl to k
echo 'alias kc=kubecolor' >> /etc/profile
echo 'alias k=kubectl' >> /etc/profile
echo 'complete -o default -F __start_kubectl k' >> /etc/profile

# kubectl Source the completion
source <(kubectl completion bash)
echo 'source <(kubectl completion bash)' >> /etc/profile

# Install Kubectx & Kubens
git clone https://github.com/ahmetb/kubectx /opt/kubectx
ln -s /opt/kubectx/kubens /usr/local/bin/kubens
ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx

# Install Kubeps & Setting PS1
git clone https://github.com/jonmosco/kube-ps1.git /root/kube-ps1
cat <<"EOT" >> ~/.bash_profile
source /root/kube-ps1/kube-ps1.sh
KUBE_PS1_SYMBOL_ENABLE=true
function get_cluster_short() {
  echo "$1" | cut -d . -f1
}
KUBE_PS1_CLUSTER_FUNCTION=get_cluster_short
KUBE_PS1_SUFFIX=') '
PS1='$(kube_ps1)'$PS1
EOT
