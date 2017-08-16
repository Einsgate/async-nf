#!/bin/sh

# Update apt.
sudo apt-get update

# Install git
sudo apt-get install git cmake -y

# download seastar
git clone https://github.com/duanjp8617/seastar.git

# Prepare to compile seastar
cd ./seastar
sudo ./install-dependencies.sh
git submodule update --init
./configure.py --enable-dpdk --compiler=g++-5 --mode=release
ninja
