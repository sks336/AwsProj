#!/bin/bash

########################################################
export KAFKA_HOME_DIR=/home/kafka
########################################################


echo "Counter value is : "$1

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Inside the init shell script.....pwd is: $(pwd), running as : [$(whoami)]"

rm -rf ${KAFKA_HOME_DIR}/resources_00_tmp

cp -rf /tmp/resources_00_tmp ${KAFKA_HOME_DIR}/
RESOURCE_SCRIPT_HOME=${KAFKA_HOME_DIR}/resources_00_tmp/scripts

chmod +x ${RESOURCE_SCRIPT_HOME}/*.sh

#Execute Scripts

${RESOURCE_SCRIPT_HOME}/setupKafkaService.sh $1 $2 $3 $4 $5




