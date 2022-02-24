#!/usr/bin/env sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJ_DIR=$SCRIPT_DIR/..


cd $PROJ_DIR

terraform init -input=false

terraform apply -input=false -auto-approve

echo 'If all goes well, access the test app url at : http://kube.thesachinshukla.com:30336/test'

