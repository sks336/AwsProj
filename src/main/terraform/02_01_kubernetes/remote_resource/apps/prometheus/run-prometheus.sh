#!/bin/env bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPTS_DIR: $SCRIPTS_DIR"

NS=ns-prometheus

kubectl delete ns $NS

sleep 3

kubectl get namespace $NS >/dev/null 2>&1 || kubectl create namespace $NS


openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/prometheus_key.key \
  -out /tmp/prometheus_cert.crt \
  -subj "/CN=prometheus.techlearning.me/O=Prometheus"


kubectl create secret tls prometheus-tls \
  --cert=/tmp/prometheus_cert.crt \
  --key=/tmp/prometheus_key.key \
  -n $NS


helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update


helm -n $NS install prometheus prometheus-community/prometheus


sleep 3

kubectl -n $NS apply -f $SCRIPTS_DIR/ingress-prometheus.yaml
