#!/usr/bin/env sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

INFRA_FOLDER=$SCRIPT_DIR/infra
SETUP_ELB_FOLDER=$SCRIPT_DIR/setup_elb
SETUP_CNAME_FOLDER=$SCRIPT_DIR/setup_cname

start=`date +%s`

# ---------------------------------------------------------------------------------

$INFRA_FOLDER/scripts/bootstrap-infra.sh

echo "  =>>>>>>>>>>> INFRA APPLIED, GOING TO SETTING UP ELB
*
*
*
*
*
"
$SETUP_ELB_FOLDER/scripts/bootstrap-elb.sh
echo "  =>>>>>>>>>>> ELB APPLIED, GOING TO SETTING UP CNAME
*
*
*
*
*
"
$SETUP_CNAME_FOLDER/scripts/bootstrap.sh


# ---------------------------------------------------------------------------------


function updateHostFileForMiniKubeIP() {
    IP=$1
    sed -i '' '/aws-kube-vm/d' /private/etc/hosts
    echo "$IP    aws-kube-vm" >> /private/etc/hosts
    cat /private/etc/hosts
}


echo "Once terraform is applied, update the kube master ip to host file....."

KUBE_MASTER_IP=$(cd $INFRA_FOLDER && terraform output kube-master-public-ip)
echo "KUBE_MASTER_IP : ${KUBE_MASTER_IP}"

FUNC=$(declare -f updateHostFileForMiniKubeIP)
sudo bash -c "$FUNC; updateHostFileForMiniKubeIP $KUBE_MASTER_IP"


# ---------------------------------------------------------------------------------


end=`date +%s`
execTime=$((end-start))

echo 'Execution time to BootStrap all components = '$execTime' seconds.'