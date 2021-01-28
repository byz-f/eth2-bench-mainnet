#!/usr/bin/env bash

while true
do
  lodestar beacon --testnet mainnet \
  --metrics.enabled \
  --eth1.providerUrl https://mainnet.infura.io/v3/9352a830436b4171b3bcd96b2f418790 \
  --rootDir /srv/chain/lodestar 2>&1 | tee ../log/$(date +%y%m%d%H%M%S)-lodestar.log
  sleep 10
done
