#!/usr/bin/env bash

########################################################
export CENTOS_HOME=/home/centos
export HOME_01_BASE=$CENTOS_HOME/01_base
########################################################

echo "Inside script install_docker.sh...."

#This below line should ideally goto some init.sh file

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
echo 'Config manage added the repo.....'
yum install -y yum-utils device-mapper-persistent-data lvn2
echo 'Install docker utils......'
yum install docker-ce-18.06.1.ce-3.el7 -y
echo 'Installed Docker.....'
systemctl enable docker
systemctl start docker
usermod -aG docker centos
#usermod -aG docker sachin

#################### DO Docker login so that [root] and [centos] user are authenticated everytime VM is provisioned ###################
chmod -R 755 /etc/docker
sudo systemctl restart docker
##########

echo "Exiting script install_docker.sh...."