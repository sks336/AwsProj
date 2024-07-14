#!/bin/bash


########################################################
export UBUNTU_HOME=/home/ubuntu
export SACHIN_HOME=/home/sachin
########################################################

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

curl https://downloads.apache.org/kafka/3.7.1/kafka_2.12-3.7.1.tgz -o ${SACHIN_HOME}/softwares/dist/kafka_2.12-3.7.1.tgz


tar -xvf ${SACHIN_HOME}/softwares/dist/kafka_2.12-3.7.1.tgz -C ${SACHIN_HOME}/softwares/dist

ln -s ${SACHIN_HOME}/softwares/dist/kafka_2.12-3.7.1 ${SACHIN_HOME}/softwares/kafka



sed  -i "1i export KAFKA_HOME=${SACHIN_HOME}/softwares/kafka" ${SACHIN_HOME}/.bashrc
echo 'export PATH=${KAFKA_HOME}/bin:$PATH' >> ${SACHIN_HOME}/.bashrc
