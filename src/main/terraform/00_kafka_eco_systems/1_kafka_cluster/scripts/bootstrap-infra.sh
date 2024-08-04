#!/usr/bin/env sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJ_DIR=$SCRIPT_DIR/..

start=$(date +%s)
cd $PROJ_DIR



terraform init -input=false

terraform apply -input=false -auto-approve


end=$(date +%s)
timeTaken=$((end-start))
echo "Time to execute script (in seconds) is : "$timeTaken