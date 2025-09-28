#!/bin/bash


########################################################
export UBUNTU_HOME=/home/ubuntu
export SACHIN_HOME=/home/sachin
########################################################

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Inside init shell script.....pwd is: $(pwd), running as : [$(whoami)]"


echo "PasswordAuthentication yes" | sudo tee -a /etc/ssh/sshd_config
echo "PasswordAuthentication yes" | sudo tee /etc/ssh/sshd_config.d/60-cloudimg-settings.conf



cp -rf ${SACHIN_HOME}/01_base/lib/* ${SACHIN_HOME}/softwares/dist/

echo "Listing softwares dist!!!!!!!!"
ls -asl ${SACHIN_HOME}/softwares/dist/

mkdir -p ${SACHIN_HOME}/softwares/scripts_util
cp -rf ${SACHIN_HOME}/01_base/scripts/util/*.sh ${SACHIN_HOME}/softwares/scripts_util
chmod +x ${SACHIN_HOME}/softwares/scripts_util/*.sh


# Execute scripts

${SACHIN_HOME}/softwares/scripts_util/createUser.sh kafka kafka
sudo -H -u kafka ${SACHIN_HOME}/01_base/scripts/install_kafka.sh


