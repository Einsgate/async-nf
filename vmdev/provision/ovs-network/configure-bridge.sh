#!/bin/sh

# Reference:
# http://docs.openvswitch.org/en/latest/intro/install/dpdk/
# https://wiki.qemu.org/Documentation/vhost-user-ovs-dpdk
# http://docs.openvswitch.org/en/latest/topics/dpdk/vhost-user/

sudo ovs-vsctl add-br ovsbr0 -- set bridge ovsbr0 datapath_type=netdev

sudo ovs-vsctl add-port ovsbr0 vhost-user1 -- set Interface vhost-user1 type=dpdkvhostuser

sudo ovs-vsctl add-port ovsbr0 vhost-user2 -- set Interface vhost-user2 type=dpdkvhostuser
