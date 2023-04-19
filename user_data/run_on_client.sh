#!/bin/bash

# Currently only SUSE is supported by the bootstrap scripts

LOGFILE="/root/user_data.log"

instance_target_host=$(cat /opt/server_ip)
sudo echo "Server IP: $instance_target_host" | sudo tee -a $${LOGFILE}

rke2_version=$(cat /opt/rke2_version)
sudo echo "RKE2 Version: $rke2_version" | sudo tee -a $${LOGFILE}

echo "" | sudo tee -a $${LOGFILE}
curl http://169.254.169.254/latest/meta-data/local-ipv4 | sudo tee -a $${LOGFILE}
echo "" | sudo tee -a $${LOGFILE}

sudo zypper update -y | sudo tee -a $${LOGFILE}

sudo systemctl disable apparmor.service | sudo tee -a $${LOGFILE}
sudo systemctl disable firewalld.service | sudo tee -a $${LOGFILE}
sudo systemctl stop apparmor.service | sudo tee -a $${LOGFILE}
sudo systemctl stop firewalld.service | sudo tee -a $${LOGFILE}

sudo systemctl disable swap.target | sudo tee -a $${LOGFILE}
sudo swapoff -a | sudo tee -a $${LOGFILE}

#rke2 setup
#rke2 versions - https://github.com/rancher/rke2/releases
sudo curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION=$rke2_version INSTALL_RKE2_TYPE="agent" sh - | sudo tee -a $${LOGFILE}

sudo mkdir -p /etc/rancher/rke2 | sudo tee -a $${LOGFILE}

instance_target_host=$(cat /opt/server_ip)

sudo cat << EOF >/etc/rancher/rke2/config.yaml
token: SET_MY_TOKEN_HERE
server: https://$instance_target_host:9345
EOF

sudo systemctl enable rke2-agent.service | sudo tee -a $${LOGFILE}

sudo cat << EOF >/root/.bashrc
export PATH=$PATH:/opt/rke2/bin:/var/lib/rancher/rke2/bin
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
EOF


sudo echo "done" | sudo tee -a $${LOGFILE}
sudo init 6 | sudo tee -a $${LOGFILE}
