SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#PROJ_DIR=$SCRIPT_DIR/..


cd $SCRIPT_DIR

terraform init -input=false

terraform apply -auto-approve