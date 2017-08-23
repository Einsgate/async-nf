#!/bin/sh

# Reference:
# https://wiki.qemu.org/Documentation/vhost-user-ovs-dpdk
# http://docs.openvswitch.org/en/latest/intro/install/dpdk/

CORE_MASK=0x1f
#PMD_CORE_MASK=0x1e
MEM=2048
HUGE_PAGE_DIR=/mnt/huge

sudo killall ovsdb-server ovs-vswitchd

sudo rm -f /usr/local/var/run/openvswitch/vhost-user*

sudo rm -f /usr/local/etc/openvswitch/conf.db

sudo ovsdb-tool create /usr/local/etc/openvswitch/conf.db /usr/local/share/openvswitch/vswitch.ovsschema

sudo ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock --remote=db:Open_vSwitch,Open_vSwitch,manager_options --pidfile --detach --log-file

sudo ovs-vsctl --no-wait init

sudo ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-lcore-mask=$CORE_MASK

sudo ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-socket-mem=$MEM

sudo ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-hugepage-dir=$HUGE_PAGE_DIR

#sudo ovs-vsctl --no-wait set Open_vSwitch . other_config:pmd-cpu-mask=$PMD_CORE_MASK

sudo ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true

sudo ovs-vswitchd --pidfile --detach --log-file
