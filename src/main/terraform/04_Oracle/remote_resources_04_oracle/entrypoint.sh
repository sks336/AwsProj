#!/usr/bin/env bash

#############################################
HOME=/home/centos
RESOURCES_HOME=$HOME/remote_resources_04_oracle
#############################################

echo "Entering Entrypoint...."`date +%s`

#export DOCKER_IMG=absolutapps/oracle-12c-ee:latest
export DOCKER_IMG=doctorkirk/oracle-19c:19.9
export PORT=31521
export CONTAINER_NAME=oracle_c


export ORACLE_ALLOW_REMOTE=true
export ORACLE_DISABLE_ASYNCH_IO=true # Improve performance
export ORACLE_ENABLE_XDB=true # Enable XDB User with default password as xdb

function cleanStartOracleContainer() {
 ################### [START ORACLE] ##############################
 docker kill $CONTAINER_NAME || true;

 sleep 3

 docker run -d --rm \
   --privileged \
   --name $CONTAINER_NAME \
   -v $RESOURCES_HOME/oracle_data:/home/oracle/oracle_data \
   -p $PORT:1521 \
   $DOCKER_IMG

 echo 'Running the docker container.....'

}


cleanStartOracleContainer

echo 'Going to automatically execute the setup script after oracle is running....'

TEXT_TO_LOOK="DATABASE IS READY TO USE"
CMD="docker logs $CONTAINER_NAME | grep '$TEXT_TO_LOOK' | tail -1"
echo ">>>>>>>>CMD=$CMD"
while :; do
  OUT=$(/bin/sh -c "$CMD")
  if [ ! -z "$OUT" ]; then
      echo "Oracle seems to be Running!!, Going to setup Oracle"
      break;
  else
      echo "Oracle is still not available, going to sleep....."
      sleep 15
  fi
done

 docker exec  $CONTAINER_NAME /bin/sh -c "mkdir -p /opt/oracle/oradata; chown -R oracle. /opt/oracle/oradata"
 docker exec --user oracle $CONTAINER_NAME /home/oracle/oracle_data/setup_oracle.sh

echo 'Oracle setup is Over, would apply the init script now....'
sleep 5
docker exec --user oracle $CONTAINER_NAME /home/oracle/oracle_data/init_sql.sh
echo 'Init Script applied.....!!'

