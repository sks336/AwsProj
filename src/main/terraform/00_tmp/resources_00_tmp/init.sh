#!/bin/bash

########################################################
export SACHIN_HOME=/home/sachin
########################################################

echo "Counter value is : "$1

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Inside the init shell script.....pwd is: $(pwd), running as : [$(whoami)]"

rm -rf ${SACHIN_HOME}/resources_00_tmp

cp -rf /tmp/resources_00_tmp ${SACHIN_HOME}/
RESOURCE_SCRIPT_HOME=${SACHIN_HOME}/resources_00_tmp/scripts

chmod +x ${RESOURCE_SCRIPT_HOME}/*.sh

#Execute Scripts

${RESOURCE_SCRIPT_HOME}/setupKafkaService.sh $1 $2 $3 $4

echo 'Hello.....'




