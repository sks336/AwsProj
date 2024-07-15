#!/bin/bash

handleNginX() {
  sudo apt-get install nginx -y
  sudo chown sachin:sachin /sbin/nginx
  sudo chown -R sachin:sachin /usr/share/nginx

  echo '
  PRIVATE_IP=$(curl -sSX GET http://169.254.169.254/latest/meta-data/local-ipv4)
  echo $PRIVATE_IP | sudo tee /var/www/html/index.nginx-debian.html
  sudo nginx -s stop
  sudo nginx
  ' | sudo tee /usr/bin/nginx.sh

  sudo chmod +x /usr/bin/nginx.sh
}



setupService_nginx() {

    echo  "

    [Unit]
    Description=Nginx Service
    After=network.target
    User=sachin

    [Service]
    Type=simple
    ExecStart=/bin/bash /usr/bin/nginx.sh
    TimeoutStartSec=0
    RemainAfterExit=yes

    [Install]
    WantedBy=default.target
    " |  sudo tee /etc/systemd/system/nginx.service
}

handleNginX

setupService_nginx