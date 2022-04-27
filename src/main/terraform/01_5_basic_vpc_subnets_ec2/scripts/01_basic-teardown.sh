SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJ_DIR=$SCRIPT_DIR/..

DIR_01_BASIC=$PROJ_DIR/01_basic
DIR_02_EC2=$PROJ_DIR/02_ec2


$DIR_02_EC2/run-teardown.sh
$DIR_01_BASIC/run-teardown.sh

