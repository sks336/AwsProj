#!/bin/bash


enableAndStartServices() {

    echo  "

    [Unit]
    Description=Script to run at startup
    After=network.target

    [Service]
    Type=simple
    ExecStart=/usr/bin/startup.sh
    TimeoutStartSec=0
    RemainAfterExit=yes

    [Install]
    WantedBy=default.target
    " |  sudo tee /etc/systemd/system/startup.service

    echo "==========>>>>>> Content of file /etc/systemd/system/startup.service"
    sudo cat /etc/systemd/system/startup.service
}

enableAndStartServices

