#!/bin/bash

########################################################
export UBUNTU_HOME=/home/ubuntu
export SACHIN_HOME=/home/sachin
########################################################

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Inside entry-point shell script.....pwd is: $(pwd), running as : [$(whoami)]"


createUser_Sachin() {
  SACHIN_HOME=/home/sachin
  sudo adduser sachin
  echo -e 'Shukla@0336\nShukla@0336' |sudo passwd sachin
  echo '%sachin ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

  sudo -H -u sachin bash -c "ssh-keygen -t rsa -f ${SACHIN_HOME}/.ssh/id_rsa -q -P ''"

  mkdir -p ${SACHIN_HOME}/00_base
  cp -rf /tmp/remote_resources/* ${SACHIN_HOME}/00_base/
  ls -asl ${SACHIN_HOME}/00_base

  # To take care self ssh.
  echo "$(cat ${SACHIN_HOME}/.ssh/id_rsa.pub)" >> ${SACHIN_HOME}/.ssh/authorized_keys
  echo '' >> ${SACHIN_HOME}/.ssh/authorized_keys

  # To take care ssh from local machine.
  echo 'Going to copy the local public key content to authorized keys'
  echo "$(cat ${SACHIN_HOME}/00_base/id_rsa.pub)" >> ${SACHIN_HOME}/.ssh/authorized_keys
  echo '' >> ${SACHIN_HOME}/.ssh/authorized_keys

  echo "
Host *
    StrictHostKeyChecking no
" > $SACHIN_HOME/.ssh/config

  chown -R sachin:sachin ${SACHIN_HOME}
  chmod -R 755 $SACHIN_HOME

  chmod 400 $SACHIN_HOME/.ssh/id_rsa
  chmod 400 $SACHIN_HOME/.ssh/id_rsa.pub
}

sudo bash -c "$(declare -f createUser_Sachin); createUser_Sachin"





# Execute scripts
sudo chmod +x ${SACHIN_HOME}/00_base/init.sh ${SACHIN_HOME}/00_base/scripts/*.sh
sudo -H -u sachin ${SACHIN_HOME}/00_base/init.sh
