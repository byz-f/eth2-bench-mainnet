#!/usr/bin/env bash

while true
do
  beacon-chain \
  --datadir /srv/chain/prysm \
  --http-web3provider https://mainnet.infura.io/v3/9352a830436b4171b3bcd96b2f418790 2>&1 | tee ../log/$(date +%y%m%d%H%M%S)-prysm.log
  sleep 10
done
