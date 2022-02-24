#!/usr/bin/env bash

#############################################
HOME=/home/centos
RESOURCES_HOME=$HOME/remote_resource_m03_zk_kafka
#############################################

echo "Entering Entrypoint...."`date +%s`

AWS_MACHINE_IP=$(curl -sSX GET http://169.254.169.254/latest/meta-data/public-ipv4)

export NS_KAFKA=kafka
export NS_ZK=zookeeper
export KAFDROP_BROKER_CONNECT_STR="${AWS_MACHINE_IP}:30092"

function deleteZK() {
    kubectl -n $NS_ZK patch pvc datadir-zookeeper-0 -p '{"metadata":{"finalizers": []}}' --type=merge || true;
    kubectl -n $NS_ZK delete pvc datadir-zookeeper-0  || true;
    kubectl delete pv $(kubectl get pv | grep zoo | cut -d ' ' -f 1)
    kubectl delete ns $NS_ZK
}

function runZK() {
    kubectl create ns $NS_ZK
    kubectl apply -f $RESOURCES_HOME/k8/zk-micro.yaml
}


function deleteKafka() {
    kubectl -n $NS_KAFKA delete statefulset.apps/kafka-d-0 service/kafka-0
    kubectl delete ns $NS_KAFKA
}

function runKafka() {
    kubectl create ns $NS_KAFKA
    echo 'Going to create the kafka cluster under node {n1}: '
    kubectl apply -f $RESOURCES_HOME/k8/kafka-singlenode.yaml
}

function runCleanKafDrop() {
    kubectl delete svc kafdrop || true;
    kubectl delete deployment.apps/kafdrop || true;
    rm -rf /tmp/kafdrop && mkdir -p /tmp/kafdrop &&  cd /tmp/kafdrop && git clone https://github.com/obsidiandynamics/kafdrop && cd kafdrop
    echo 'KAFDROP_BROKER_CONNECT_STR='$KAFDROP_BROKER_CONNECT_STR
    helm upgrade -i kafdrop chart --set image.tag=3.27.0 --set kafka.brokerConnect="${KAFDROP_BROKER_CONNECT_STR}" --set server.servlet.contextPath="/"  --set jvm.opts="-Xms32M -Xmx64M"
    export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services kafdrop)
    echo "Access KafDrop at : http://kube0:$NODE_PORT"
}


function isZKStarted() {
    CMD="kubectl -n $NS_ZK get pod zookeeper-0 | tail -1 | cut -d ' ' -f 1"
    RESULT=$(/bin/sh -c "$CMD")
    if [[ "$RESULT" == "zookeeper-0" ]]; then
        return 0;
    else
        return 1;
    fi
    return 1;
}


function isZKHealthy() {
    CMD="kubectl -n $NS_ZK get pod zookeeper-0 | tail -1 | cut -d ' ' -f 4 | cut -d '/' -f 1"
    STATUS=$(/bin/sh -c "$CMD")
    echo 'CMD='$CMD
    IS_HEALTHY="false"
    if [[ "$STATUS" == "1" ]]; then
        return 0;
     else
        return 1;
    fi
}

function waitForZKToUpAndRunning {
    echo 'Going to check the status of ZK health!!!!'
    i=1
    TIMEOUT=300
    INTERVAL=10
    ATTEMPT_COUNT=$(($TIMEOUT/$INTERVAL))
    echo "TIMEOUT=$TIMEOUT, INTERVAL=$INTERVAL, ATTEMPT_COUNT=$ATTEMPT_COUNT"

        while [ "$i" -le "$ATTEMPT_COUNT" ]; do
            if [ "$ATTEMPT_COUNT" = "$i" ]; then
                echo 'Reached Time Out!!!!'
                exit 0;
            fi

            if isZKHealthy; then
                echo 'ZK Node is healthy..'
                return 0;
            fi
            echo '['$i'] - ZK not available yet, would be attempted again in '$INTERVAL' seconds'
            sleep $INTERVAL
            i=$(($i + 1))
        done

}

# ----------

deleteZK
runZK

waitForZKToUpAndRunning

deleteKafka
runKafka

sleep 10

runCleanKafDrop



