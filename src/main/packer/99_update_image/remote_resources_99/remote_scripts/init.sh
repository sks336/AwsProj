#!/usr/bin/env bash

########################################################
export CENTOS_HOME=/home/centos
export HOME_01_BASE=$CENTOS_HOME/01_base
########################################################

echo "Inside script init.sh....running as :: [$(whoami)]"

###########################################################################


chmod 400 /home/sachin/.ssh/id_rsa
chmod 400 /home/sachin/.ssh/id_rsa.pub

echo 'Fixed the permission'

ls -asl /home/sachin/.ssh/*

#echo "#!/usr/bin/env bash
#
#/usr/bin/run_nginx.sh
#
#" | sudo tee /usr/bin/setup_services.sh
#
#sudo chmod +x /usr/bin/setup_services.sh


function handleNginX() {

  sudo yum install nginx -y
  sudo chown sachin. /sbin/nginx
  sudo chown -R sachin. /usr/share/nginx

  echo '
  PRIVATE_IP=$(curl -sSX GET http://169.254.169.254/latest/meta-data/local-ipv4)
  echo $PRIVATE_IP | sudo tee /usr/share/nginx/html/index.html
  sudo nginx -s stop
  sudo nginx
  ' | sudo tee /usr/bin/run_nginx.sh

  sudo chmod +x /usr/bin/run_nginx.sh


}



function enableAndStartServices() {

    echo  "

    [Unit]
    Description=Script to run at startup
    After=network.target

    [Service]
    Type=simple
    ExecStart="/usr/bin/start_all_services.sh"
    TimeoutStartSec=0

    [Install]
    WantedBy=default.target
    " |  sudo tee /etc/systemd/system/startup.service
    sudo systemctl daemon-reload
    sudo systemctl enable startup.service
    sudo systemctl restart startup.service
    sudo systemctl status startup.service

    sudo cat /etc/systemd/system/startup.service
}





#handleNginX
#enableAndStartServices




#sudo chmod +x /etc/rc.d/rc.local


#which jq
#sudo yum install -y jq
#which jq