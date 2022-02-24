#!/usr/bin/env sh

########################################################
export CENTOS_HOME=/home/centos
export HOME_01_BASE=$CENTOS_HOME/01_base
########################################################


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo 'Inside script init.sh......'


yum update -y
yum clean all -y

#yum install java-1.8.0-openjdk -y
#yum install stress -y
#yum install jq -y

yum install java-11-openjdk -y

yum -y install epel-release stress jq git telnet unzip

yum -y install wget


cd /tmp
wget https://get.helm.sh/helm-v3.6.0-linux-amd64.tar.gz
tar -xvf helm-v3.6.0-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin

echo "alias c=clear
alias k=kubectl
alias kn='kubectl -n $NS'
" >> $CENTOS_HOME/.bashrc