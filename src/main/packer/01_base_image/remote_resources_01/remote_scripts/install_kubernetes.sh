#!/usr/bin/env sh

########################################################
export CENTOS_HOME=/home/centos
export HOME_01_BASE=$CENTOS_HOME/01_base
########################################################

echo "Inside install_kubernetes shell script....running as : [$(whoami)]"

########################################################
function setUpKubernetes() {
#sudo yum update -y
#sudo yum clean all -y
modprobe br_netfilter
lsmod | grep br_netfilter
cat <<EOF | tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

echo '[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl' > /etc/yum.repos.d/kubernetes.repo

#sed -i 's/^repo_gpgcheck=1$/repo_gpgcheck=0/' /etc/yum.repos.d/kubernetes.repo
echo "content of kubernetes repo file is : $(cat /etc/yum.repos.d/kubernetes.repo)"

setenforce 0
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
swapoff -a
# sed -i 's/\/swapfile/#\/swapfile1/g' /etc/fstab
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
echo "content of selinux config file is $(cat /etc/selinux/config)"




yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet
#kubeadm config images pull
}

sudo bash -c "$(declare -f setUpKubernetes); setUpKubernetes"

########################################################