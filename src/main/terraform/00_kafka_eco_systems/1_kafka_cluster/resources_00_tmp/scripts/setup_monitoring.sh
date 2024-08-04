#!/bin/bash

########################################################
export KAFKA_HOME_DIR=/home/kafka
export KAFKA_HOME=/home/kafka/softwares/kafka
########################################################

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Inside the setup_monitoring shell script.....pwd is: $(pwd), running as : [$(whoami)]"

RESOURCE_SCRIPT_HOME=${KAFKA_HOME_DIR}/resources_00_tmp/scripts

MASTER_IP=$1
WORKER_ONE_IP=$2
WORKER_TWO_IP=$3

echo "Master IP [${MASTER_IP}], WorkerOne IP [${WORKER_ONE_IP}], WorkerTwo IP [${WORKER_TWO_IP}]"


setupService_kafka_monitoring() {

sudo systemctl stop prometheus

sudo rm -rf /var/lib/prometheus
sudo mkdir -p /var/lib/prometheus
sudo chown -R kafka:kafka /var/lib/prometheus

rm -rf ${KAFKA_HOME_DIR}/softwares/prometheus
rm -rf ${KAFKA_HOME_DIR}/softwares/dist/prometheus
rm -rf ${KAFKA_HOME_DIR}/softwares/dist/prometheus-*.tar.gz

tar -xvf  ${KAFKA_HOME_DIR}/resources_00_tmp/lib/prometheus-2.22.0.linux-amd64.tar.gz -C ${KAFKA_HOME_DIR}/softwares/dist
ln -s ${KAFKA_HOME_DIR}/softwares/dist/prometheus-2.22.0.linux-amd64 ${KAFKA_HOME_DIR}/softwares/prometheus

echo "
global:
  scrape_interval: 10s

scrape_configs:
  - job_name: 'kafka_job'
    scrape_interval: 5s
    static_configs:
      - targets: ['${MASTER_IP}:7071','${WORKER_ONE_IP}:7071','${WORKER_TWO_IP}:7071']
" > ${KAFKA_HOME_DIR}/resources_00_tmp/lib/prometheus.yml

    echo  "

    [Unit]
    Description=Prometheus
    Wants=network-online.target
    After=network-online.target

    [Service]
    User=kafka
    Type=simple
    ExecStart=${KAFKA_HOME_DIR}/softwares/prometheus/prometheus \
        --config.file ${KAFKA_HOME_DIR}/resources_00_tmp/lib/prometheus.yml \
        --storage.tsdb.path /var/lib/prometheus/ \
        --web.console.templates=${KAFKA_HOME_DIR}/softwares/prometheus/consoles \
        --web.console.libraries=${KAFKA_HOME_DIR}/softwares/prometheus/console_libraries

    [Install]
    WantedBy=multi-user.target
    " |  sudo tee /etc/systemd/system/prometheus.service

    echo "==========>>>>>> Content of file /etc/systemd/system/prometheus.service"
    sudo cat /etc/systemd/system/prometheus.service
}



setupService_kafka_monitoring


sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus






