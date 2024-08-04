#!/bin/bash

########################################################
export UBUNTU_HOME=/home/ubuntu
export SACHIN_HOME=/home/sachin
########################################################


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Inside script init.sh......running as : [$(whoami)]"

sudo apt-get update && sudo apt-get upgrade
sudo apt-get -y install git unzip curl wget

echo "Going to Install Java"
sudo apt-get install openjdk-11-jdk -y


mkdir -p $HOME/softwares/dist
mkdir -p $HOME/softwares/bins


echo "alias c=clear
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export MAVEN_HOME=/home/sachin/softwares/maven
alias k=kubectl
alias kn='kubectl -n $NS'
export PATH=$HOME/softwares/bins:$HOME/softwares/maven/bin:$PATH
" >> $HOME/.bashrc




# Execute scripts

${SACHIN_HOME}/00_base/scripts/install_nginx.sh
${SACHIN_HOME}/00_base/scripts/install_maven.sh
${SACHIN_HOME}/00_base/scripts/install_awscli.sh

${SACHIN_HOME}/00_base/scripts/setup_services.sh
