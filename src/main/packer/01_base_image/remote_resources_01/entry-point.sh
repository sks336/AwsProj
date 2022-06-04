#!/usr/bin/env sh

########################################################
export SACHIN_HOME=/home/sachin
########################################################

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Inside entry-point shell script.....pwd is: $(pwd), running as : [$(whoami)]"

sudo -H -u sachin mkdir -p ${SACHIN_HOME}/01_base
sudo -H -u sachin cp -rf /tmp/remote_resources_01/* ${SACHIN_HOME}/01_base/
sudo -H -u sachin ls -asl ${SACHIN_HOME}/01_base



# Execute scripts
sudo -H -u sachin chmod +x ${SACHIN_HOME}/01_base/remote_scripts/*.sh

sudo -H -u sachin ${SACHIN_HOME}/01_base/remote_scripts/install_docker.sh
sudo -H -u sachin ${SACHIN_HOME}/01_base/remote_scripts/install_kubernetes.sh
