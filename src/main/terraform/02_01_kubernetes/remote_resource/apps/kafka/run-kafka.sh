#!/bin/env bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPTS_DIR: $SCRIPTS_DIR"

NS=ns-kafka
APP_NAME=kafka

helm -n $NS delete $APP_NAME || true;
kubectl delete ns $NS || true;


kubectl get namespace $NS >/dev/null 2>&1 || kubectl create namespace $NS

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update


helm -n $NS install kafka bitnami/kafka -f $SCRIPTS_DIR/values.yaml

sleep 3

kubectl -n $NS apply -f $SCRIPTS_DIR/ingress-${APP_NAME}.yaml





