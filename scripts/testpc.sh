#!/bin/bash
hostnamectl --static set-hostname testpc

# Config convenience
echo 'alias vi=vim' >> /etc/profile
echo "sudo su -" >> /home/vagrant/.bashrc
ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# Disable ufw & apparmor

# Install packages
apt update && apt-get install net-tools ngrep jq tree unzip apache2 -y

# local dns - hosts file
echo "192.168.10.10  k3s-s" >> /etc/hosts
echo "192.168.10.101 k3s-w1" >> /etc/hosts
echo "192.168.10.102 k3s-w2" >> /etc/hosts
echo "192.168.10.200 testpc" >> /etc/hosts
