#!/usr/bin/env bash

while true
do
  teku --config-file="./teku.yaml" 2>&1 | tee ../log/$(date +%y%m%d%H%M%S)-teku.log
  sleep 10
done
