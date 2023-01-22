#!/bin/bash


set -e

IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=kube-master" --filters "Name=instance-state-name,Values=running" | jq -r '.Reservations[].Instances[0].PublicIpAddress')
INGRESS_PORT=$(ssh -o StrictHostKeyChecking=no -i /Users/sachin/work/keys/aws/sachin-aws-kp3.pem centos@${IP} cat /home/centos/.ingress_port)

while :; do
  if [ ! -z "$INGRESS_PORT" ]; then
      break;
  else
      sleep 5
  fi
done



echo -n "{\"ingress_port\":\"${INGRESS_PORT}\"}"

