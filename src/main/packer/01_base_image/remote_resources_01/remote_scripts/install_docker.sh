#!/usr/bin/env bash

########################################################
export CENTOS_HOME=/home/centos
export HOME_01_BASE=$CENTOS_HOME/01_base
########################################################

echo "Inside script install_docker.sh....running as : [$(whoami)]"

###########################################################################
function installHelm() {
    cd /tmp
    wget https://get.helm.sh/helm-v3.6.0-linux-amd64.tar.gz
    tar -xvf helm-v3.6.0-linux-amd64.tar.gz
    mv linux-amd64/helm $HOME/softwares/bins
}

installHelm
###########################################################################

sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
echo 'Config manage added the repo.....'
sudo yum install -y yum-utils device-mapper-persistent-data lvn2
echo 'Install docker utils......'


# sudo yum install docker-ce-18.06.1.ce-3.el7 -y
sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin


echo 'Installed Docker.....'
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker centos
sudo usermod -aG docker sachin

#################### DO Docker login so that [root] and [centos] user are authenticated everytime VM is provisioned ###################
sudo chmod -R 755 /etc/docker
sudo systemctl restart docker
##########


###########################################################################
function installDockerCompose() {
    curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o $HOME/softwares/bins/docker-compose
    chmod +x $HOME/softwares/bins/docker-compose
}

installDockerCompose
###########################################################################


echo "Exiting script install_docker.sh...."