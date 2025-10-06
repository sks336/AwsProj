#!/bin/env bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPTS_DIR: $SCRIPTS_DIR"

NS=ns-redis
helm -n $NS delete redis || true;

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm install -n $NS redis bitnami/redis \
  -f $SCRIPTS_DIR/values.yaml \
  --create-namespace \
  --set global.security.allowInsecureImages=true

sleep 3

kubectl patch svc redis -n $NS -p '{
  "spec": {
    "type": "NodePort",
    "ports": [
      {"port": 6379, "nodePort": 32000, "protocol": "TCP", "name": "redis"},
      {"port": 26379, "nodePort": 32001, "protocol": "TCP", "name": "sentinel"}
    ]
  }
}'






