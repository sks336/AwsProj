#!/usr/bin/env sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

INFRA_FOLDER=$SCRIPT_DIR/infra
SETUP_ELB_FOLDER=$SCRIPT_DIR/setup_elb
SETUP_CNAME_FOLDER=$SCRIPT_DIR/setup_cname

start=`date +%s`

# ---------------------------------------------------------------------------------

$SETUP_CNAME_FOLDER/scripts/teardown.sh
echo "  =>>>>>>>>>>> DESTROYED CNAME, GOING TO DESTROY ELB
*
*
*
*
*
"
$SETUP_ELB_FOLDER/scripts/teardown-elb.sh

echo "  =>>>>>>>>>>> DESTROYED ELB, GOING TO DESTROY INFRA
*
*
*
*
*
"
$INFRA_FOLDER/scripts/teardown-infra.sh

# ---------------------------------------------------------------------------------

end=`date +%s`
execTime=$((end-start))

echo 'Execution time to Tear Down all components = '$execTime' seconds.'