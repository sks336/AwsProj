#!/bin/env bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPTS_DIR: $SCRIPTS_DIR"

NS=ns-kafka

kubectl -n $NS delete -f $SCRIPTS_DIR/svc.yaml || true

kubectl delete ns $NS || true;
kubectl get namespace $NS >/dev/null 2>&1 || kubectl create namespace $NS

kubectl apply -f $SCRIPTS_DIR/zk.yaml
sleep 1

kubectl apply -f $SCRIPTS_DIR/kafka.yaml
sleep 3

kubectl apply -f $SCRIPTS_DIR/svc.yaml

echo "export BROKERS=kafka-0.techlearning.me:9094,kafka-1.techlearning.me:9094,kafka-2.techlearning.me:9094"

echo ""

echo "\$KAFKA_HOME/bin/kafka-console-producer.sh --broker-list \$BROKERS --topic t1"
echo "\$KAFKA_HOME/bin/kafka-console-producer.sh --bootstrap-server \$BROKERS --topic t1"

echo ""

echo "\$KAFKA_HOME/bin/kafka-console-consumer.sh --bootstrap-server \$BROKERS --topic t1 --from-beginning"


echo "Deploying Kafdrop....."

sleep 1

kubectl apply -f $SCRIPTS_DIR/kafdrop.yaml

echo "Deploying Kafdrop Ingress....."
sleep 5
kubectl apply -f $SCRIPTS_DIR/kafdrop-ingress.yaml

echo "Access Kafdrop at: https://kafdrop.techlearning.me"





