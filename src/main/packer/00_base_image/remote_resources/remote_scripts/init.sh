#!/usr/bin/env sh

########################################################
########################################################


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Inside script init.sh......running as : [$(whoami)]"

# -----------
mkdir -p $HOME/scripts
echo "#!/usr/bin/env bash

/usr/bin/run_nginx.sh

" | sudo tee /usr/bin/startup.sh

sudo chmod +x /usr/bin/startup.sh

# -----------

sudo yum update -y
sudo yum clean all -y

sudo yum install java-11-openjdk -y
sudo yum -y install epel-release stress jq git telnet unzip curl wget


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
    ExecStart="/usr/bin/startup.sh"
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


function installPython {

	yum install gcc openssl-devel bzip2-devel libffi-devel zlib-devel xz-devel -y
	cd /usr/src
	wget https://www.python.org/ftp/python/3.7.11/Python-3.7.11.tgz
	tar xzf Python-3.7.11.tgz
	cd Python-3.7.11
	./configure --enable-optimizations
	make altinstall
	rm -rf /bin/python
	ln -s /usr/local/bin/python3.7 /bin/python
	rm /usr/src/Python-3.7.11.tgz
}

function installAWSCli() {
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm awscliv2.zip
}


handleNginX
enableAndStartServices
sudo bash -c "$(declare -f installPython); installPython"
installAWSCli


mkdir -p $HOME/softwares/{dist,bins}

function installMaven() {
  cd $HOME/softwares/dist
  curl -O https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz
  tar -xvf apache-maven*.tar.gz
  cd -
  ln -s $HOME/softwares/dist/apache-maven-3.8.5 $HOME/softwares/maven
}

installMaven


echo "alias c=clear
alias k=kubectl
alias kn="kubectl -n $NS'
export PATH=$HOME/softwares/bins:$HOME/softwares/maven/bin:$PATH
" >> $HOME/.bashrc