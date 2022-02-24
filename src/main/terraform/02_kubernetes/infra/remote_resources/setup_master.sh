#!/usr/bin/env bash

########################################################
export CENTOS_HOME=/home/centos
export HOME_DIR=/home/centos

########################################################

echo "Executing setup for Kubernetes....as user : $(whoami)"
swapoff -a

#export KUBE_MASTER_IP=$(curl -sSX GET http://169.254.169.254/latest/meta-data/public-ipv4)
export KUBE_MASTER_IP=$(curl -sSX GET http://169.254.169.254/latest/meta-data/local-ipv4)
echo "Private IP of kube master is: ${KUBE_MASTER_IP}"

kubeadm config images pull
nohup kubeadm init --apiserver-advertise-address=${KUBE_MASTER_IP} --pod-network-cidr=10.32.0.0/12 > /tmp/vm_kubeadm_init.log &
#nohup kubeadm init --apiserver-advertise-address=192.168.10.101 --pod-network-cidr=10.244.0.0/16 > /tmp/vm_kubeadm_init.log &

while :; do
  FILE=/var/lib/kubelet/config.yaml
  if [ -f "$FILE" ]; then
      echo "File {$FILE} is available."
      break;
  else
      echo "File {$FILE} is not available yet"
      sleep 5
  fi
done

cat /var/lib/kubelet/config.yaml | grep cgroup
sed -i 's/^cgroupDriver: systemd$/cgroupDriver: cgroupfs/' /var/lib/kubelet/config.yaml
cat /var/lib/kubelet/config.yaml | grep cgroup


sudo -H -u centos bash -c "/bin/sh ${CENTOS_HOME}/remote_resources/set_kube_in_master.sh"



