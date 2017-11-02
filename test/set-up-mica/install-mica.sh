#!/bin/sh

# down load dpdk 16.11
wget http://fast.dpdk.org/rel/dpdk-16.11.3.tar.xz

tar -xvf ./dpdk-16.11.3.tar.xz

cd ./dpdk-stable-16.11.3

make config T=x86_64-native-linuxapp-gcc

make -j

cd ../

git clone https://github.com/duanjp8617/mica2.git

cd mica2/build

ln -s ../../dpdk-stable-16.11.3 ./dpdk

cmake ..

make -j

ln -s ../src/mica/test/*.json .

# possibly execute sudo killall etcd to restart etcd
