#!/bin/sh

git clone -b local-17.05 https://github.com/duanjp8617/dpdk.git

cd ./dpdk

make config T=x86_64-native-linuxapp-gcc

make -j8

export RTE_SDK=$PWD
export RTE_TARGET=build

# cd ./examples

# make -j8

cd ./app/test-pmd

make -j8
