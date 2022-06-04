#!/usr/bin/env sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJ_DIR=$SCRIPT_DIR/..
LOCAL_HOME_DIR="/Users/sachin"

cd $PROJ_DIR

function populateLocalSSHKey() {
  SSH_PUB_FILE="$LOCAL_HOME_DIR/.ssh/id_rsa.pub"
    if [ ! -e $SSH_PUB_FILE ]
    then
        echo "file {$SSH_PUB_FILE} does not exist, create this file first to proceed further"
        exit 0;
    fi
  SSH_KEY_PUB=$(cat $SSH_PUB_FILE)
  echo $SSH_KEY_PUB > $PROJ_DIR/remote_resources/id_rsa.pub
}

populateLocalSSHKey

packer init .
packer build -force ./pack.pkr.hcl

