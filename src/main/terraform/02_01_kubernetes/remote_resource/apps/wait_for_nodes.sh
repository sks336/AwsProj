#!/bin/bash

TIMEOUT=$1
echo "TIMEOUT is : $TIMEOUT"

# Polling interval in seconds
INTERVAL=5
# Expected number of nodes
EXPECTED_NODES=3

elapsed=0

echo "Waiting for all $EXPECTED_NODES nodes to be Ready..."

while true; do
    ready_nodes=$(kubectl get nodes --no-headers | awk '{if($2=="Ready") print $0}' | wc -l)

    if [[ "$ready_nodes" -eq "$EXPECTED_NODES" ]]; then
        echo "All $EXPECTED_NODES nodes are Ready!"
        break
    fi

    if [[ "$elapsed" -ge "$TIMEOUT" ]]; then
        echo "Timeout reached after $TIMEOUT seconds. Not all nodes are Ready."
        exit 1
    fi

    echo "Currently $ready_nodes/$EXPECTED_NODES nodes are Ready. Waiting..."
    sleep $INTERVAL
    elapsed=$((elapsed + INTERVAL))
done

