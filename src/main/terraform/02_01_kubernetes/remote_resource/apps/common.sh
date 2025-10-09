#!/bin/env bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "inside common.sh file....SCRIPTS_DIR: $SCRIPTS_DIR"


echo "Going to create Local Path Provisoner...."
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
echo "Local Path Provisoner created...."


echo "Deploying Nginx Ingress Controller!!!"
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

kubectl apply -f $SCRIPTS_DIR/nginx_ingress_controller.yaml
