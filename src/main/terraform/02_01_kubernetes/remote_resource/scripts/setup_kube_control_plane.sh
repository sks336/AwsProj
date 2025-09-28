#!/bin/bash

SCRIPTS_DIR=/tmp/remote_resource/scripts

echo "Setting up kube master..."

sudo chmod -R 755 /home/sachin #TODO Move this command to Image

#sudo hostnamectl set-hostname master0

#MASTER_IP=$(/home/kube/sachin/get_ip.sh )
MASTER_IP=$(ip a | tail -4 | head -1 | cut -d ' ' -f 6 | cut -d '/' -f 1)

echo "MASTER_IP=$MASTER_IP"


$SCRIPTS_DIR/clean_kube.sh

sudo kubeadm init \
  --control-plane-endpoint "$MASTER_IP:6443" \
  --upload-certs \
  --pod-network-cidr=192.168.0.0/16 \
  > /home/sachin/kube.log 2>&1

sleep 5

CONTROL_CMD=$(awk '/You can now join any number of the control-plane node/{flag=1; next} flag && NF {gsub(/\\/, "", $0); printf "%s ", $0} /--certificate-key/ {print ""; exit}' /home/sachin/kube.log)
WORKER_CMD=$(awk '/Then you can join any number of worker nodes/{found=1; next} found && /kubeadm join/,EOF {gsub(/\\/, "", $0); printf "%s ", $0}' /home/sachin/kube.log)

echo "CONTROL_CMD = $CONTROL_CMD"
echo "WORKER_CMD = $WORKER_CMD"

echo "sudo $CONTROL_CMD" > ~/join_master.out
echo "sudo $WORKER_CMD" > ~/join_worker.out

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml

sleep 5

sudo systemctl daemon-reexec
sudo systemctl restart containerd kubelet