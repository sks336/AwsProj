#!/bin/env bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPTS_DIR: $SCRIPTS_DIR"

NS=ns-kafka

kubectl delete ns $NS || true;
kubectl get namespace $NS >/dev/null 2>&1 || kubectl create namespace $NS

kubectl apply -f $SCRIPTS_DIR/zk.yaml
sleep 1
kubectl apply -f $SCRIPTS_DIR/kafka.yaml
#sleep 1
#kubectl -n $NS apply -f $SCRIPTS_DIR/ingress-${APP_NAME}.yaml





