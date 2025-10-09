#!/bin/env bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPTS_DIR: $SCRIPTS_DIR"

NS=ns-keycloak

kubectl delete ns $NS

sleep 3

kubectl get namespace $NS >/dev/null 2>&1 || kubectl create namespace $NS


openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/kc_key.key \
  -out /tmp/kc_cert.crt \
  -subj "/CN=keycloak.techlearning.me/O=Keycloak"


kubectl create secret tls keycloak-tls \
  --cert=/tmp/kc_cert.crt \
  --key=/tmp/kc_key.key \
  -n $NS


kubectl -n $NS apply -f $SCRIPTS_DIR/kc.yaml

sleep 3

kubectl -n $NS apply -f $SCRIPTS_DIR/ingress-keycloak.yaml

echo "Access the Keycloak at http://kube.techlearning.me:32100"
echo "Username: admin"
echo "Password: admin123"
