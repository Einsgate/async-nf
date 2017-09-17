#!/bin/sh

# A good reference: https://medium.com/@john.lin/%E7%B7%A8%E8%AD%AF-open-vswitch-v2-7-0-on-ubuntu-16-04-2-lts-6df0a2f7d648

# Require autoreconf, need apt-get install autoconf

DPDK_BUILD=/home/net/async-nf/vmdev/dpdk/build

git clone -b branch-2.7 https://github.com/openvswitch/ovs.git

sudo apt-get update

sudo apt-get install -y dh-autoreconf libssl-dev libcap-ng-dev openssl python python-pip

sudo pip install six

cd ovs

./boot.sh

./configure --with-dpdk=$DPDK_BUILD --with-linux=/lib/modules/$(uname -r)/build

make -j8

sudo make install
