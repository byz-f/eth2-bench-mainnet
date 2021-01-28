#!/usr/bin/env bash

rm -vrf /srv/chain/lighthouse/beacon/chain_db
rm -vrf /srv/chain/prysm/beaconchaindata
rm -vrf /srv/chain/teku/beacon/db
rm -vrf /srv/chain/nimbus/db
rm -vrf /srv/chain/lodestar/chain-db

rm -vf ../dat/*.csv
rm -vf ../log/*.log
rm -vf ./*.log
