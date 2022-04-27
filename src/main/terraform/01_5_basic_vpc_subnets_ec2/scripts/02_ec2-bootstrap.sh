SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJ_DIR=$SCRIPT_DIR/..


DIR_02_EC2=$PROJ_DIR/02_ec2

$SCRIPT_DIR/01_basic-bootstrap.sh
$DIR_02_EC2/run-bootstrap.sh
