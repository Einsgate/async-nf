Several references for creating a DPDK virtio network.

1. Build dpdk 17.02 using the provided dpdk-build.sh script.

2. Use http://fast.dpdk.org/doc/perf/DPDK_17_02_Intel_virtio_performance_report.pdf as the basic setup reference.

3. Launch vhost-switch:

 /path-to-dpdk/examples/vhost \
 -c 0x1c00 \
 -n 4 \
 --socket-mem 2048 \
 -- -p 0x1 \
 --mergeable 1 \
 --vm2vm 1 2 \
 --tso 1 \
 --tx-csum 1 \
 --dequeue-zero-copy \
 --socket-file ./first-vhost-net \
 --socket-file ./second-vhost-net1

Note: The first core specified in the core mask is used by the master process and does no work.
The rest of the cores will actually do the job and keeps busy. The created vhost-net device are
round-robined by all the worker threads.

4. Then go on to configure the virtual machine.

   4.1, Add <domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
   to the domain tag.

   4.2 Add
<qemu:commandline>
  <qemu:arg value='-chardev socket,id=char0,path=/home/net/asyn-nf/provision/virtio-network/vhost-net1'/>
  <qemu:arg value='-netdev type=vhostuser,id=netdev0,chardev=char0,vhostforce'/>
  <qemu:arg value='-device virtio-netpci,netdev=netdev0,mac=52:54:00:00:00:01'/>
</qemu:commandline>