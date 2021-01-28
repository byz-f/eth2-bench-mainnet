#!/usr/bin/env bash

while true
do
  lighthouse bn \
  --datadir /srv/chain/lighthouse \
  --eth1-endpoints https://mainnet.infura.io/v3/9352a830436b4171b3bcd96b2f418790 \
  --http --eth1 --metrics 2>&1 | tee ../log/$(date +%y%m%d%H%M%S)-lighthouse.log
  sleep 10
done
