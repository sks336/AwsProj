#!/bin/bash


########################################################
export UBUNTU_HOME=/home/ubuntu
export SACHIN_HOME=/home/sachin
########################################################

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Inside init shell script.....pwd is: $(pwd), running as : [$(whoami)]"


# Execute scripts
${SACHIN_HOME}/01_base/scripts/startup.sh
${SACHIN_HOME}/01_base/scripts/install_kafka.sh