#!/usr/bin/env bash

#############################################
HOME=/home/centos
RESOURCES_HOME=$HOME/remote_resource_m02_apicurio_registry
#############################################

echo "Entering Entrypoint...."`date +%s`


function cleanKeyCloak() {
    NS=keycloak
    kubectl -n $NS delete cm keycloak-pg-config || true;
    kubectl -n $NS delete deployment kc-pg-d keycloak || true;
    kubectl -n $NS delete svc keycloak-pg-svc keycloak || true;
    kubectl -n $NS delete ingress keycloak-ingress || true;
    kubectl delete ns $NS || true;
}

function installKeyCloak() {
  NS=keycloak
  kubectl create ns $NS || true;
  kubectl apply -f $RESOURCES_HOME/keycloak/kc.yaml
  PUBLIC_IP=$(curl -sSX GET http://169.254.169.254/latest/meta-data/public-ipv4)
  INGRESS_PORT=$(cat /home/centos/.ingress_port)
  KEYCLOAK_URL="http://${PUBLIC_IP}:${INGRESS_PORT}/auth"
  echo "Access KeyCloak at url : {$KEYCLOAK_URL} OR {http://apicurio.thesachinshukla.com:30336/auth}, username {keycloak}, password {12345678}"
}

function cleanInstallKeyCloak() {
    cleanKeyCloak
    installKeyCloak
}


function cleanApicurio() {
    NS=apicurio
    kubectl -n $NS delete cm apicurio-configmap
    kubectl delete ns $NS
}

function installApicurio() {
  NS=apicurio
  kubectl create ns $NS || true;

  PUBLIC_IP=$(curl -sSX GET http://169.254.169.254/latest/meta-data/public-ipv4)
  PRIVATE_IP=$(curl -sSX GET http://169.254.169.254/latest/meta-data/local-ipv4)
  INGRESS_PORT=$(cat /home/centos/.ingress_port)
  kubectl -n $NS create cm apicurio-configmap --from-literal=keycloak-url=http://apicurio.thesachinshukla.com:30336/auth \
    --from-literal=apicurio-ui-logout-redirect-uri=http://apicurio.thesachinshukla.com:30336/ \
    --from-literal=apicurio-ui-hub-api-url=http://apicurio.thesachinshukla.com:30336/studio-api \
    --from-literal=apicurio-ui-editing-url=ws://apicurio.thesachinshukla.com:31002 \
    --from-literal=apicurio-microcks-api-url=http://MICROCKS_URL/api \
    --from-literal=apicurio-db-connection-url=jdbc:postgresql://apicurio-pg-svc:5432/apicuriodb \
    --from-literal=apicurio-kc-client-id=apicurio-studio \
    --from-literal=apicurio-kc-realm=apicurio \
    --from-literal=apicurio-microcks-client-id=microcks-serviceaccount \
    --from-literal=apicurio-ui-feature-share-with-everyone=true \
    --from-literal=apicurio-ui-feature-microcks=false

  kubectl apply -f $RESOURCES_HOME/apicurio/k8

  echo "Access Apicurio Studio Dashboard at url {http://${PUBLIC_IP}:${INGRESS_PORT}/dashboard} OR {http://apicurio.thesachinshukla.com:30336/dashboard}"
}

function cleanInstallApicurio() {
    cleanApicurio
    installApicurio
}
# ################################################################

#cleanInstallKeyCloak
#sleep 20
#installKeyCloak
installApicurio

