#!/bin/env bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "inside common.sh file....SCRIPTS_DIR: $SCRIPTS_DIR"


NODE_NAME=$1
NODE_REGION=$2
NODE_AZ=$3
NODE_ID=$4

echo "NODE_NAME [${NODE_NAME}], NODE_REGION [${NODE_REGION}], NODE_AZ [${NODE_AZ}], NODE_ID [${NODE_ID}]"


kubectl patch node "$NODE_NAME" -p "{\"spec\":{\"providerID\":\"aws:///$NODE_AZ/$NODE_ID\"}}"
