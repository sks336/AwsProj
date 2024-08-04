#!/bin/bash

########################################################
export KAFKA_HOME_DIR=/home/kafka
export KAFKA_HOME=/home/kafka/softwares/kafka
########################################################

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Inside the setup_grafana shell script.....pwd is: $(pwd), running as : [$(whoami)]"


sudo systemctl stop grafana

sudo rm -rf /var/log/grafana
sudo mkdir -p /var/log/grafana
sudo chown -R kafka:kafka /var/log/grafana

rm -rf ${HOME}/softwares/grafana
rm -rf ${HOME}/softwares/dist/grafana-v11.1.0
rm -rf ${HOME}/softwares/dist/grafana-11.1.0.linux-amd64.tar.gz

tar -xvf ${HOME}/resources_00_tmp/lib/grafana-11.1.0.linux-amd64.tar.gz -C ${HOME}/softwares/dist
ln -s ${HOME}/softwares/dist/grafana-v11.1.0 ${HOME}/softwares/grafana


setupService_grafana() {

    echo  "

    [Unit]
    Description=grafana
    Wants=network-online.target
    After=network-online.target

    [Service]
    User=kafka
    Type=simple
    ExecStart=${HOME}/softwares/grafana/bin/grafana server --homepath ${HOME}/softwares/grafana cfg:default.paths.logs=/var/log/grafana/grafana.log

    [Install]
    WantedBy=multi-user.target
    " |  sudo tee /etc/systemd/system/grafana.service

    echo "==========>>>>>> Content of file /etc/systemd/system/grafana.service"
    sudo cat /etc/systemd/system/grafana.service
}


setupService_grafana

sudo systemctl daemon-reload
sudo systemctl enable grafana
sudo systemctl start grafana