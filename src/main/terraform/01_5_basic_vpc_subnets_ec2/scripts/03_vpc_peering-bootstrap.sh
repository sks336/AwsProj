SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJ_DIR=$SCRIPT_DIR/..


DIR_03_VPC_PEERING=$PROJ_DIR/03_vpc_peering

$DIR_03_VPC_PEERING/run-bootstrap.sh
