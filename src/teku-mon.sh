#!/usr/bin/env bash

while true
do
  sudo ruby ./teku.rb 2>&1 | tee ../dat/$(date +%y%m%d%H%M%S)-teku.csv
  sleep 10
done
