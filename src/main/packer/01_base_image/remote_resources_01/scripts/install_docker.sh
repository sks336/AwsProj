#!/usr/bin/env bash

########################################################
export SACHIN_HOME=/home/sachin
########################################################

echo "Inside script install_docker.sh....running as : [$(whoami)]"

sudo apt update -y

sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" -y
apt-cache policy docker-ce
sudo apt install docker-ce -y

sudo usermod -aG docker sachin
sudo usermod -aG docker kafka
echo "Exiting script install_docker.sh...."