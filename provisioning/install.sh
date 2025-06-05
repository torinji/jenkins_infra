#!/bin/bash

VAGRANT_HOST_DIR=/mnt/host_machine

sudo apt update > /dev/null 2>&1
sudo apt-get install -y mc make
########################
# Docker
########################

echo "Installing Docker"
# Add Docker's official GPG key:
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Postinstall
sudo usermod -aG docker vagrant
sudo usermod -aG docker ubuntu
sudo systemctl enable docker 
sudo systemctl start docker

########################
# nginx
########################
echo "Installing nginx"
sudo apt-get -y install nginx > /dev/null 2>&1

# Postinstall
echo "Configuring nginx"
cd /etc/nginx/sites-available
sudo rm default ../sites-enabled/default
sudo cp $VAGRANT_HOST_DIR/nginx/* /etc/nginx/sites-available/
list=$(ls -1 $VAGRANT_HOST_DIR/nginx/)
for item in $list; do
    sudo ln -s /etc/nginx/sites-available/$item /etc/nginx/sites-enabled/
done
sudo systemctl enable nginx 
sudo systemctl start nginx


########################
# Finishing
########################
echo "127.0.0.1 jenkins.local grafana.local prometheus.local dev.local prod.local registry" >> /etc/hosts
echo "Success"
