#!/bin/bash


########################################################
export UBUNTU_HOME=/home/ubuntu
export SACHIN_HOME=/home/sachin
########################################################

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Inside createUser shell script.....pwd is: $(pwd), running as : [$(whoami)]"

username=$1
password=$2

sudo adduser --gecos "" --disabled-password $username
echo "${username}:${password}" | sudo chpasswd

echo "%${username} ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

sudo -H -u ${username} bash -c "ssh-keygen -t rsa -f /home/${username}/.ssh/id_rsa -q -P ''"

echo "
Host *
    StrictHostKeyChecking no
" | sudo tee /home/${username}/.ssh/config


KEY=$(sudo cat /home/${username}/.ssh/id_rsa.pub)
KEY=$(echo $KEY | cut -d ' ' -f 2)

echo "ssh-rsa $KEY" | sudo tee /home/${username}/.ssh/authorized_keys

