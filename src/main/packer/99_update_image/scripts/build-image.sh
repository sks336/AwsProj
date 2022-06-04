#!/usr/bin/env sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJ_DIR=$SCRIPT_DIR/..
LOCAL_HOME_DIR="/Users/sachin"

cd $PROJ_DIR

packer init .
packer build -force ./pack.pkr.hcl

