#!/usr/bin/env bash

while true
do
  sudo ruby ./lighthouse.rb 2>&1 | tee ../dat/$(date +%y%m%d%H%M%S)-lighthouse.csv
  sleep 10
done
