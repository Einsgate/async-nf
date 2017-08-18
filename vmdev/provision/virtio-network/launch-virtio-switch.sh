#!/bin/sh

DPDK_DIR=/home/net/async-nf/vmdev/dpdk-build/dpdk
CORE_MASK=0x00007

$DPDK_DIR/examples/vhost/vhost/build/vhost-switch \
-c $CORE_MASK \
-n 4 \
--socket-mem 2048 \
-- -p 0x1 \
--mergeable 1 \
--vm2vm 1 2 \
--tso 1 \
--tx-csum 1 \
--dequeue-zero-copy \
--socket-file ./vhost-net1 \
--socket-file ./vhost-net2
