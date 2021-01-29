#!/usr/bin/env bash

while true
do
  beacon-chain \
  --accept-terms-of-use \
  --datadir /srv/chain/prysm \
  --http-web3provider https://mainnet.infura.io/v3/492f687207ad4d9eb6a9f27ebeb73e5a 2>&1 | tee ../log/$(date +%y%m%d%H%M%S)-prysm.log
  sleep 10
done
