#!/usr/bin/env sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJ_DIR=$SCRIPT_DIR/..

start=$(date +%s)
cd $PROJ_DIR

downloadLib_Locally() {

  LIB_DIR=${SCRIPT_DIR}/../resources_00_tmp/lib

  if [[ ! -f ${LIB_DIR}/prometheus-2.22.0.linux-amd64.tar.gz ]]; then
    echo 'Prometheus jar does not exists, downloading....'
    wget https://github.com/prometheus/prometheus/releases/download/v2.22.0/prometheus-2.22.0.linux-amd64.tar.gz --no-check-certificate -O ${LIB_DIR}/prometheus-2.22.0.linux-amd64.tar.gz
    else
      echo 'Prometheus Jar already available in source'
  fi

  if [[ ! -f ${LIB_DIR}/grafana-11.1.0.linux-amd64.tar.gz ]]; then
    echo 'Grafana jar does not exists, downloading....'
    wget https://dl.grafana.com/oss/release/grafana-11.1.0.linux-amd64.tar.gz --no-check-certificate -O ${LIB_DIR}/grafana-11.1.0.linux-amd64.tar.gz
    else
      echo 'Grafana Jar already available in source'
  fi
}




downloadLib_Locally

terraform init -input=false

terraform apply -input=false -auto-approve


end=$(date +%s)
timeTaken=$((end-start))
echo "Time to execute script (in seconds) is : "$timeTaken