#!/usr/bin/env bash

########################################################
export CENTOS_HOME=/home/centos
export HOME_01_BASE=$CENTOS_HOME/01_base
########################################################

echo "Inside script init.sh....running as : [$(whoami)]"

###########################################################################


echo 'test' > $HOME/.ssh/me.txt

echo 'content of file.....'
cat $HOME/.ssh/me.txt

