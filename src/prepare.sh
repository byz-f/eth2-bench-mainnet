#!/usr/bin/env bash

# @manually: prepare sudo, `user` to run the node.

# operating system
sudo pacman -Syu
sudo pacman -S base-devel git tmux zsh make cmake pkgconf sysstat nethogs
git clone https://aur.archlinux.org/pikaur.git /tmp/pikaur
cd /tmp/pikaur
makepkg -fsri
cd

# rust tool chains
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup default stable
rustup update

# go tool chains
pikaur -S go bazel

# java tool chains
pikaur -S jdk11-openjdk jre11-openjdk-headless gradle

# nodejs tool chains
pikaur -S nvm
nvm install v12.20.1
nvm use v12.20.1
npm install -g npm yarn lerna

# lighthouse
git clone https://github.com/sigp/lighthouse.git
cd lighthouse
git checkout v1.1.0
cargo build --release
cd

# prysm
git clone https://github.com/prysmaticlabs/prysm.git
cd prysm
git checkout v1.1.0
./prysm.sh beacon-chain
cd

# teku
git clone https://github.com/ConsenSys/teku.git
cd teku
git checkout 21.1.1
./gradlew installDist
cd

# nimbus
git clone https://github.com/status-im/nimbus-eth2.git
cd nimbus-eth2
git checkout v1.0.6
NIMFLAGS="-d:insecure -d:release" make -j $(nproc) nimbus_beacon_node
cd

# lodestar
git clone https://github.com/chainsafe/lodestar.git
cd lodestar
git checkout v0.14.0
lerna bootstrap
cd

# scripts
git clone https://github.com/byz-f/eth2-bench-mainnet.git bench

# prepare
sudo mkdir -p /srv/chain
sudo chown user:users /srv/chain -R
