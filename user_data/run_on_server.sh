#!/bin/bash
LOGFILE="/root/user_data.log"

rke2_version=$(cat /opt/rke2_version)
sudo echo "RKE2 Version: $rke2_version" | sudo tee -a $${LOGFILE}

curl http://169.254.169.254/latest/meta-data/local-ipv4 | sudo tee -a $${LOGFILE}

sudo zypper update -y | sudo tee -a $${LOGFILE}

sudo systemctl disable apparmor.service | sudo tee -a $${LOGFILE}
sudo systemctl disable firewalld.service | sudo tee -a $${LOGFILE}
sudo systemctl stop apparmor.service | sudo tee -a $${LOGFILE}
sudo systemctl stop firewalld.service | sudo tee -a $${LOGFILE}

sudo systemctl disable swap.target | sudo tee -a $${LOGFILE}
sudo swapoff -a | sudo tee -a $${LOGFILE}

#rke2 setup
#rke2 version - https://github.com/rancher/rke2/releases
sudo curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION=$rke2_version sh - | sudo tee -a $${LOGFILE}

sudo mkdir -p /etc/rancher/rke2 | sudo tee -a $${LOGFILE}

sudo cat << EOF >/etc/rancher/rke2/config.yaml
token: 0da8c856ded54b075553cf93bf6af75ec92491732425058fead463b970656d3a
EOF

sudo systemctl enable rke2-server.service | sudo tee -a $${LOGFILE}

sudo cat << EOF >/root/.bashrc
export PATH=$PATH:/opt/rke2/bin:/var/lib/rancher/rke2/bin
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
EOF


sudo echo "done" | sudo tee -a $${LOGFILE}
sudo init 6 | sudo tee -a $${LOGFILE}
