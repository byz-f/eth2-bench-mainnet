#!/usr/bin/env bash

while true
do
  sudo ruby ./nimbus.rb 2>&1 | tee ../dat/$(date +%y%m%d%H%M%S)-nimbus.csv
  sleep 10
done
