#!/usr/bin/env sh

########################################################
########################################################


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Inside script init.sh......running as : [$(whoami)]"


# -----------

sudo yum update -y
sudo yum clean all -y

sudo yum install java-11-openjdk -y
sudo yum -y install epel-release stress jq git telnet unzip curl wget


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
alias kn='kubectl -n $NS'
export PATH=$HOME/softwares/bins:$HOME/softwares/maven/bin:$PATH
" >> $HOME/.bashrc