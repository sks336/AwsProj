#!/bin/env bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPTS_DIR: $SCRIPTS_DIR"

NS=ns-redis

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm install -n $NS redis bitnami/redis \
  -f $SCRIPTS_DIR/values.yaml \
  --create-namespace \
  --set global.security.allowInsecureImages=true








