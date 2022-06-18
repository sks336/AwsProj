#!/usr/bin/env bash

########################################################
export CENTOS_HOME=/home/centos
export HOME_01_BASE=$CENTOS_HOME/01_base
########################################################

echo "Inside script init.sh....running as :: [$(whoami)]"

###########################################################################


function handleNginX() {

  sudo yum install nginx -y
  sudo chown sachin. /sbin/nginx
  sudo chown -R sachin. /usr/share/nginx
  mkdir -p $HOME/scripts

  echo '
  PRIVATE_IP=$(curl -sSX GET http://169.254.169.254/latest/meta-data/local-ipv4)
  echo $PRIVATE_IP | sudo tee /usr/share/nginx/html/index.html
  sudo nginx -s stop
  sudo nginx
  '>$HOME/scripts/run_nginx.sh

  chmod +x $HOME/scripts/*.sh

  sudo sed -i '/run_nginx.sh/d' /etc/rc.local
  echo '/home/sachin/scripts/run_nginx.sh' | sudo tee -a /etc/rc.local

}


handleNginX


#which jq
#sudo yum install -y jq
#which jq