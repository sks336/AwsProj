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
  ' | sudo tee /usr/bin/run_nginx.sh

  sudo chmod +x /usr/bin/run_nginx.sh
}


handleNginX