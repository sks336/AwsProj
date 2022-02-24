#!/usr/bin/env bash

# --------------------------------------------
export NS=keycloak
# --------------------------------------------


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJ_DIR=$SCRIPT_DIR/..

START_WATCH="false"
FORCE_CLEAN="false"
RUN_AS_CLUSTER="false"




function commandsHelp() {
  echo "Nothing as of now!!"
}

function helpFunction() {
    echo "Keycloak can be accessible at url: http://vm-minikube:${KEYCLOAK_NODEPORT}"
    echo 'Use [-c] option to run the application as clustered'
    echo 'Use [-d] option to delete only the resources and exit'
    echo 'Use [-f] option to delete and clean the resouces previously run (should be used for a fresh clean run)'
    echo 'Use [-h] option to see the help'
    echo 'Use [-w] option to start watching the app at last'
    echo 'Use [-x] Use this Extended Help option to get kafka commands related help'
    exit 0;
}



function delete() {
#    eval $(minikube docker-env)
    kubectl delete ns $NS
    kubectl delete deployments keycloak
}


function runKeyCloak() {
#    eval $(minikube docker-env)
    kubectl delete ns $NS

    kubectl create ns $NS

    if [[ "${RUN_AS_CLUSTER}" == "true" ]]; then
            echo 'Cluster mode is not supported yet!! Exiting!!'
            exit 0;
        else
            kubectl -n $NS apply -f /$SCRIPT_DIR/k8/kc-db.yaml
            echo 'Going to apply app yaml files soon......'
            sleep 10
            kubectl -n $NS apply -f /$SCRIPT_DIR/k8/kc.yaml

            sleep 5
            kubectl -n $NS apply -f /$SCRIPT_DIR/k8/ingress.yaml
    fi

    commandsHelp
}


while getopts "cdfhwx" opt
do
   case "$opt" in
      c ) RUN_AS_CLUSTER="true" ;;
      d ) (delete || true) && exit 0;;
      f ) FORCE_CLEAN="true" ;;
      w ) START_WATCH="true" ;;
      h ) helpFunction && exit 0;; # Usage
      x ) commandsHelp && exit 0;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done


#source $PROJ_DIR/scripts/refreshMinikubeIP.sh
#MINIKUBE_IP=$(minikube ip)
#echo 'MINIKUBE_IP='$MINIKUBE_IP
#export MINIKUBE_IP="${MINIKUBE_IP}"

# ------------------------------------------------------------

echo 'START_WATCH: {'$START_WATCH'}'
echo 'FORCE_CLEAN: {'$FORCE_CLEAN'}'
echo 'RUN_AS_CLUSTER: {'$RUN_AS_CLUSTER'}'



if [[ "$FORCE_CLEAN" == "true" ]]; then
#    delete
    runKeyCloak
else
    runKeyCloak
fi


if [[ "$START_WATCH" == "true" ]]; then
    watch "kubectl -n $NS get svc,deployments,statefulset,pods,pv,pvc -o wide --show-labels"
fi

