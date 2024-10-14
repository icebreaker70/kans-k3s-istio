#!/bin/bash
hostnamectl --static set-hostname k3s-w$1

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

# Install k3s-agent
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.10.10:6443 K3S_TOKEN=kanstoken  sh -s - --node-ip 192.168.10.10$1
