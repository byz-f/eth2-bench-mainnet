#!/usr/bin/env bash

while true
do
  sudo ruby ./lodestar.rb 2>&1 | tee ../dat/$(date +%y%m%d%H%M%S)-lodestar.csv
  sleep 10
done
