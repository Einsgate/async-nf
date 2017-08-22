#!/bin/sh

# Reference:
# http://docs.openvswitch.org/en/latest/intro/install/dpdk/
# https://wiki.qemu.org/Documentation/vhost-user-ovs-dpdk
# http://docs.openvswitch.org/en/latest/topics/dpdk/vhost-user/

PMD_CORE_MASK=0xc
NUM_OF_QUEUE=2

sudo ovs-vsctl add-br ovsbr0 -- set bridge ovsbr0 datapath_type=netdev

sudo ovs-vsctl add-port ovsbr0 vhost-user1 -- set Interface vhost-user1 type=dpdkvhostuser

sudo ovs-vsctl add-port ovsbr0 vhost-user2 -- set Interface vhost-user2 type=dpdkvhostuser

sudo ovs-vsctl set Open_vSwitch . other_config:pmd-cpu-mask=$PMD_CORE_MASK

sudo ovs-vsctl set Interface vhost-user1 options:n_rxq=$NUM_OF_QUEUE

sudo ovs-vsctl set Interface vhost-user2 options:n_rxq=$NUM_OF_QUEUE
