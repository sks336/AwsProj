#!/bin/env bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPTS_DIR: $SCRIPTS_DIR"

NS=ns-keycloak


kubectl -n $NS apply -f $SCRIPTS_DIR/kc.yaml


echo "Access the Keycloak at http://kube.techlearning.me:32100"
echo "Username: admin"
echo "Password: admin123"
