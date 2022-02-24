#!/usr/bin/env sh

########################################################
export CENTOS_HOME=/home/centos
export HOME_01_BASE=$CENTOS_HOME/01_base
########################################################

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Inside entry-point shell script.....pwd is: $(pwd)"

mkdir -p $HOME_01_BASE

cp -rf /tmp/remote_resources/* $HOME_01_BASE/
sudo chmod +x $HOME_01_BASE/*.sh

sudo -H -u centos bash -c  "rm -rf /home/centos/.ssh/id_rsa* && ssh-keygen -t rsa -f /home/centos/.ssh/id_rsa -q -P '' && cat /home/centos/.ssh/id_rsa.pub | cut -d '@' -f 1 >> /home/centos/.ssh/authorized_keys"

# Execute scripts
sudo $HOME_01_BASE/init.sh
sudo $HOME_01_BASE/install_docker.sh
sudo $HOME_01_BASE/install_kubernetes.sh
