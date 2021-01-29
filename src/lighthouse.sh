#!/usr/bin/env bash

while true
do
  lighthouse bn \
  --datadir /srv/chain/lighthouse \
  --eth1-endpoints https://mainnet.infura.io/v3/819412e57b5943a6a12c0a335fe5f87b \
  --http --eth1 --metrics 2>&1 | tee ../log/$(date +%y%m%d%H%M%S)-lighthouse.log
  sleep 10
done
