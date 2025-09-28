#!/usr/bin/env sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJ_DIR=$SCRIPT_DIR/..
LOCAL_HOME_DIR="/Users/sachin"

cd $PROJ_DIR

downloadLib_Locally() {

  LIB_DIR=${SCRIPT_DIR}/../remote_resources_01/lib

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

  if [[ ! -f ${LIB_DIR}/kafka_2.12-3.7.1.tgz ]]; then
    echo 'Kafka jar does not exists, downloading....'
    wget https://downloads.apache.org/kafka/3.7.1/kafka_2.12-3.7.1.tgz --no-check-certificate -O ${LIB_DIR}/kafka_2.12-3.7.1.tgz
    else
      echo 'Kafka Jar already available in source'
  fi

  if [[ ! -f ${LIB_DIR}/jmx_prometheus_javaagent-1.0.1.jar ]]; then
    echo 'JMX Prometheus Agent jar does not exists, downloading....'
    wget https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/1.0.1/jmx_prometheus_javaagent-1.0.1.jar --no-check-certificate -O ${LIB_DIR}/jmx_prometheus_javaagent-1.0.1.jar
    else
      echo 'JMX Prometheus Agent jar already available in source'
  fi

}




downloadLib_Locally

packer init .
packer build -force ./pack.pkr.hcl

