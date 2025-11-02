#!/bin/env bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPTS_DIR: $SCRIPTS_DIR"

NS=ns-grafana

kubectl delete ns $NS

sleep 3

kubectl get namespace $NS >/dev/null 2>&1 || kubectl create namespace $NS


openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/grafana_key.key \
  -out /tmp/grafana_cert.crt \
  -subj "/CN=grafanatechlearning.me/O=Grafana"


kubectl create secret tls grafana-tls \
  --cert=/tmp/grafana_cert.crt \
  --key=/tmp/grafana_key.key \
  -n $NS


helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm -n $NS install grafana grafana/grafana

PASSWD=$(kubectl get secret grafana -n ns-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo)
echo "Access grafana at : https://grafana.techlearning.me"
echo "Credentials: admin/$PASSWD"

sleep 3

kubectl -n $NS apply -f $SCRIPTS_DIR/ingress-grafana.yaml
