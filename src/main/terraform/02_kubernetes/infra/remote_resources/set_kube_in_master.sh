#!/usr/bin/env bash

########################################################
export CENTOS_HOME=/home/centos
export HOME_DIR=$CENTOS_HOME

########################################################

function checkKubectlCommandAvailability() {
  echo 'Inside checkKubectlCommandAvailability()....'
   while :; do
     KUBELET_CM_NAME=$(kubectl get cm -n kube-system -o json | jq -r '.items[] | select(.metadata.name | test("^kubelet-config")).metadata.name')
     echo "KUBELET_CM_NAME={$KUBELET_CM_NAME}"
     if [ "$(echo $KUBELET_CM_NAME | cut -d '-' -f 1)" == "kubelet" ]; then
         echo "Kube config is available, going to replace the cgroupDriver....."
         break;
     else
         echo "Would be again checking for kubectl cavailability....."
        export KUBECONFIG=$CENTOS_HOME/.kube/config
     fi
     sleep 5;
  done
  echo 'Done with kubectl command availability check.....'
}

function handleCgroupDriver() {
    echo 'Fixing the cgroupDriver......So the Slave nodes when join we do not have to replace it then'
    KUBELET_CM_NAME=$(kubectl get cm -n kube-system -o json | jq -r '.items[] | select(.metadata.name | test("^kubelet-config")).metadata.name')
    kubectl -n kube-system get cm $KUBELET_CM_NAME -o yaml > /tmp/.cm.kubelet.yaml
    sed -i -e 's/cgroupDriver: systemd/cgroupDriver: cgroupfs/g' /tmp/.cm.kubelet.yaml
    kubectl -n kube-system replace -f /tmp/.cm.kubelet.yaml
    echo '\n'
    kubectl -n kube-system get cm $KUBELET_CM_NAME -o yaml | grep -iC 2 cgroupDriver
    echo '\n'
}



echo "Inside setting up kube in master script as user : $(whoami)"

sudo mkdir -p $HOME/.kube && sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && sudo chown centos:centos $HOME/.kube/config
checkKubectlCommandAvailability
handleCgroupDriver

echo 'Current taint status of master node....'
kubectl get nodes $(kubectl get nodes -o json | jq -r '.items[].metadata.name') -o yaml | grep -iC 4 "taint"
kubectl taint nodes --all node-role.kubernetes.io/master-
echo 'Taint status of master node after removing the taints....'
kubectl get nodes $(kubectl get nodes -o json | jq -r '.items[].metadata.name') -o yaml | grep -iC 4 "taint"


kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')" > /tmp/vm_network.log
#kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml > /tmp/vm_network.log
echo 'Network applied......, check the logs at /tmp/vm_network.log'

sleep 10


# Deploy Metric server so "kubectl top nodes", "kubectl top pods" can be issued..
kubectl apply -f ${CENTOS_HOME}/remote_resources/k8/metric-server.yaml
sleep 3

# Enable Ingress Controller to Kubernetes Cluster
kubectl label nodes $(kubectl get nodes -o json | jq -r '.items[0].metadata.name') ingress-ready=true --overwrite
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.0/deploy/static/provider/kind/deploy.yaml
sleep 2
kubectl -n ingress-nginx patch svc ingress-nginx-controller --type merge --patch '{"spec":{"ports": [{"port": 80,"nodePort":30336}]}}'

kubectl run busybox --image=busybox -- /bin/sh -c "echo '<h2>hello Sachin!!!!</h2>'>index.html && nohup httpd -f -p 8080 && sleep 86400"
kubectl expose pod busybox --port=8080 --type=NodePort


# Execute Dashboard.......
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml
kubectl apply -f ${CENTOS_HOME}/remote_resources/k8/dashboard.yaml

DASHBOARD_TOKEN=$(kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}")
echo "
------------------------------------------------------------
# TO access the dashboard, run
kubectl proxy
# And then access below URL.
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
# And enter below token.
$DASHBOARD_TOKEN
------------------------------------------------------------
"

echo "Apply Ingress Resources [START]........"
# THIS (deleting validating webhook conf) IS A WORKAROUND TO GET IT WORKING...
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission
sleep 2
kubectl apply -f ${CENTOS_HOME}/remote_resources/k8/minimal-ingress.yaml
echo "Apply Ingress Resources [START]........"

INGRESS_SVC_PORT=$(kubectl -n ingress-nginx get svc ingress-nginx-controller -o json | jq -r '.spec.ports[0].nodePort')
echo "$INGRESS_SVC_PORT">$CENTOS_HOME/.ingress_port

