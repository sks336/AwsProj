#!/bin/env bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPTS_DIR: $SCRIPTS_DIR"

NS=ns-harbor
APP_NAME=harbor

helm -n $NS delete $APP_NAME || true;
kubectl delete ns $NS || true;


helm repo add harbor https://helm.goharbor.io
helm repo update




helm -n $NS install $APP_NAME harbor/harbor \
  -f $SCRIPTS_DIR/values.yaml \
  --create-namespace


echo "Access Harbor UI at : http://kube.techlearning.me:30003/"
echo "Username: admin"
echo "Password: admin123"



