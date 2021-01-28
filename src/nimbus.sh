#!/usr/bin/env bash

while true
do
  nimbus_beacon_node --log-level="INFO" \
  --data-dir="/srv/chain/nimbus/" \
  --web3-url="https://mainnet.infura.io/v3/9352a830436b4171b3bcd96b2f418790" \
  --non-interactive="True" \
  --status-bar="False" \
  --metrics="True" \
  --metrics-address="127.0.0.1" \
  --rpc="True" 2>&1 | tee ../log/$(date +%y%m%d%H%M%S)-nimbus.log
  sleep 10
done
