#!/bin/env bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPTS_DIR: $SCRIPTS_DIR"

NS=ns-harbor
APP_NAME=harbor

helm -n $NS delete $APP_NAME || true;
kubectl delete ns $NS || true;


kubectl get namespace $NS >/dev/null 2>&1 || kubectl create namespace $NS


openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/harbor_key.key \
  -out /tmp/harbor_cert.crt \
  -subj "/CN=harbor.techlearning.me/O=Harbor"


kubectl create secret tls harbor-tls \
  --cert=/tmp/harbor_cert.crt \
  --key=/tmp/harbor_key.key \
  -n $NS


helm repo add harbor https://helm.goharbor.io
helm repo update




helm -n $NS install $APP_NAME harbor/harbor \
  -f $SCRIPTS_DIR/values.yaml \
  --create-namespace


echo "Access Harbor UI at : http://kube.techlearning.me:30003"
echo "Username: admin"
echo "Password: admin123"



