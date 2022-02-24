#!/usr/bin/env bash

#############################################
HOME=/home/centos
RESOURCES_HOME=$HOME/remote_resources_05_apicurio
#############################################

echo "Entering Entrypoint...."`date +%s`


function cleanStartApicurioStudio() {
  export PATH=/usr/lib/jvm/java-11-openjdk-11.0.13.0.8-1.el7_9.x86_64/bin:$PATH
  java -version
  cd $RESOURCES_HOME
  sudo rm -rf apicurio-studio-0.2.51.Final
  unzip apicurio-studio-0.2.51.Final-quickstart.zip
  cd $RESOURCES_HOME/apicurio-studio-0.2.51.Final
  echo 'Going to run the Apicurio studio inside directory....'`pwd`
 nohup ./bin/standalone.sh -c standalone-apicurio.xml -b 0.0.0.0 > /tmp/vm_apicurio_startup.log 2>&1 &
 echo 'Running the Apicurio studio....'
}


cleanStartApicurioStudio

