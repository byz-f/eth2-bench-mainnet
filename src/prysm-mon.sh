#!/usr/bin/env bash

while true
do
  sudo ruby ./prysm.rb 2>&1 | tee ../dat/$(date +%y%m%d%H%M%S)-prysm.csv
  sleep 10
done
