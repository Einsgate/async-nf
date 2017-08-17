#!/bin/sh

git clone -b local-17.02 https://github.com/duanjp8617/dpdk.git

make -C dpdk RTE_OUTPUT=$PWD/build/ config T=x86_64-native-linuxapp-gcc

make -C build
