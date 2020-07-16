#!/usr/bin/env bash

while true
do
  teku --config-file="/root/altona/teku.yaml" \
    --network="altona" &> /root/gather/teku.log
  sleep 10
done
