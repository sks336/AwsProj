#!/usr/bin/env sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJ_DIR=$SCRIPT_DIR/..

cd $PROJ_DIR

terraform init -input=false

terraform apply -input=false -auto-approve
