#!/bin/sh


echo "💥 [CLEAN] Resetting Kubernetes..."

sudo kubeadm reset -f
sudo systemctl stop kubelet
sudo systemctl stop docker

sudo rm -rf ~/.kube
sudo rm -rf /etc/kubernetes
sudo rm -rf /etc/cni/net.d
sudo rm -rf /var/lib/etcd
sudo rm -rf /var/lib/kubelet
sudo rm -rf /etc/systemd/system/kubelet.service.d

sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl restart kubelet

echo "✅ Reset complete. You can now run kubeadm init again."