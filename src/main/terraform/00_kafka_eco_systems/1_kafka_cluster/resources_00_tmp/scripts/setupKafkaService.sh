#!/bin/bash

########################################################
export KAFKA_HOME_DIR=/home/kafka
export KAFKA_HOME=/home/kafka/softwares/kafka
########################################################


sudo systemctl stop kafka
sudo rm -rf /var/log/kafka
sudo mkdir -p /var/log/kafka
sudo chmod -R 777 /var/log/kafka
chmod 400 /home/kafka/.ssh/id_rsa

export NODE_ID=$1
export QUARUM_STR=$2
export ADVERTISE_LISTENERS=$3
export FIRST_NODE_IP=$4
export CURRENT_NODE_PUBLIC_IP=$5

echo "here quarum string is : "$QUARUM_STR
echo "FIRST_NODE_IP=$FIRST_NODE_IP"



SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Inside the setupKafkaService shell script.....pwd is: $(pwd), running as : [$(whoami)], NODE_ID=$NODE_ID"



setupKafkaConfig() {
  echo "KAFKA_HOME is: $KAFKA_HOME"
#  PRIVATE_IP=$(curl -sSX GET http://169.254.169.254/latest/meta-data/local-ipv4)
#  PUBLIC_IP=$(curl -sSX GET http://169.254.169.254/latest/meta-data/public-ipv4)

cat ${KAFKA_HOME}/config/kraft/server.properties > ${KAFKA_HOME}/config/kraft/server_${NODE_ID}.properties

  echo "
  # ---------------> Programmatic Configurations Injected!!!!
node.id=${NODE_ID}
listeners=PLAINTEXT://:9092,CONTROLLER://:9097
advertised.listeners=PLAINTEXT://${CURRENT_NODE_PUBLIC_IP}:9092
process.roles=broker,controller
controller.quorum.voters=$QUARUM_STR
inter.broker.listener.name=PLAINTEXT

  " >> ${KAFKA_HOME}/config/kraft/server_${NODE_ID}.properties

tail -10 ${KAFKA_HOME}/config/kraft/server_${NODE_ID}.properties
}



setupKafkaScript() {

#export KAFKA_HOME=$KAFKA_HOME

if [[ $NODE_ID -eq 1 ]]; then
  KAFKA_CLUSTER_ID="$(${KAFKA_HOME}/bin/kafka-storage.sh random-uuid)"
  echo $KAFKA_CLUSTER_ID > /tmp/cluster.id
  echo "Node-1 cluster id is : $KAFKA_CLUSTER_ID"
else
  scp -Cr kafka@$FIRST_NODE_IP:/tmp/cluster.id /tmp
  KAFKA_CLUSTER_ID=$(cat /tmp/cluster.id)
  echo "Other than Node-1 cluster id is : $KAFKA_CLUSTER_ID"
fi

echo '#!/bin/bash
' | sudo tee  /usr/bin/kafka.sh

echo "
export KAFKA_HOME=$KAFKA_HOME
export NODE_ID=$NODE_ID
export KAFKA_HOME_DIR=$KAFKA_HOME_DIR
export KAFKA_OPTS='-javaagent:${KAFKA_HOME_DIR}/resources_00_tmp/lib/jmx_prometheus_javaagent-1.0.1.jar=7071:${KAFKA_HOME_DIR}/resources_00_tmp/lib/kafka_kraft.yml'

export KAFKA_CLUSTER_ID=$(cat /tmp/cluster.id)
" | sudo tee -a /usr/bin/kafka.sh

echo '
echo "Inside script cluster id is : $KAFKA_CLUSTER_ID"
rm -rf /tmp/kraft-combined-logs/*
${KAFKA_HOME}/bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c ${KAFKA_HOME}/config/kraft/server_${NODE_ID}.properties
  nohup ${KAFKA_HOME}/bin/kafka-server-start.sh ${KAFKA_HOME}/config/kraft/server_${NODE_ID}.properties > /var/log/kafka/kafka.log 2>&1 &
' | sudo tee -a /usr/bin/kafka.sh

  sudo chmod +x /usr/bin/kafka.sh
}


setupService_kafka() {

    echo  "

    [Unit]
    Description=Script to run Kafka
    After=network.target

    [Service]
    User=kafka
    Type=simple
    ExecStart=/bin/bash /usr/bin/kafka.sh
    TimeoutStartSec=0
    RemainAfterExit=yes

    [Install]
    WantedBy=default.target
    " |  sudo tee /etc/systemd/system/kafka.service

    echo "==========>>>>>> Content of file /etc/systemd/system/kafka.service"
    sudo cat /etc/systemd/system/kafka.service
}



setupKafkaConfig
setupKafkaScript

setupService_kafka



sudo systemctl daemon-reload
sudo systemctl enable kafka
sudo systemctl start kafka
#sudo systemctl status kafka



