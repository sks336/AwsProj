#!/usr/bin/env bash

########################################################
export SACHIN_HOME=/home/sachin
export KAFKA_HOME_DIR=/home/kafka
########################################################

# This script must be run as a user [kafka]
echo "Inside script install_kafka.sh....running as : [$(whoami)]"


mkdir -p ${KAFKA_HOME_DIR}/softwares/dist

tar -xvf ${SACHIN_HOME}/softwares/dist/kafka_2.12-3.7.1.tgz -C ${KAFKA_HOME_DIR}/softwares/dist
tar -xvf ${SACHIN_HOME}/softwares/dist/prometheus-2.22.0.linux-amd64.tar.gz -C ${KAFKA_HOME_DIR}/softwares/dist
tar -xvf ${SACHIN_HOME}/softwares/dist/grafana-11.1.0.linux-amd64.tar.gz -C ${KAFKA_HOME_DIR}/softwares/dist



ln -s ${KAFKA_HOME_DIR}/softwares/dist/kafka_2.12-3.7.1 ${KAFKA_HOME_DIR}/softwares/kafka
ln -s ${KAFKA_HOME_DIR}/softwares/dist/prometheus-2.22.0.linux-amd64 ${KAFKA_HOME_DIR}/softwares/prometheus
ln -s ${KAFKA_HOME_DIR}/softwares/dist/grafana-v11.1.0 ${KAFKA_HOME_DIR}/softwares/grafana



sed  -i "1i export KAFKA_HOME=${KAFKA_HOME_DIR}/softwares/kafka" ${KAFKA_HOME_DIR}/.bashrc
echo 'export PATH=${KAFKA_HOME}/bin:$PATH' >> ${KAFKA_HOME_DIR}/.bashrc


echo "Exiting script install_kafka.sh...."