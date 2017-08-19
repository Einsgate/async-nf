Several references for creating a DPDK virtio network.

1. Build dpdk 17.02 using the provided dpdk-build.sh script.

2. Use http://fast.dpdk.org/doc/perf/DPDK_17_02_Intel_virtio_performance_report.pdf as the basic setup reference.

3. Launch vhost-switch, we provide a scipt for launching vhost-switch

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
  <qemu:arg value='-chardev'/>
  <qemu:arg value='socket,id=char0,path=/home/net/asyn-nf/provision/virtio-network/vhost-net1'/>
  <qemu:arg value='-netdev'/>
  <qemu:arg value='type=vhost-user,id=netdev0,chardev=char0,vhostforce'/>
  <qemu:arg value='-device'/>
  <qemu:arg value='virtio-net-pci,netdev=netdev0,mac=52:54:00:00:00:01'/>
</qemu:commandline>

5. Change the user and group to booth root for libvirt.
Reference: http://docs.openvswitch.org/en/latest/topics/dpdk/vhost-user/

This is enabled by:

   5.1 open /etc/libvirt/qemu.conf, add user = "root" and  group = "root"
   5.2 Install aa-complain by: apt-get install apparmor-utils
   5.3 Put libvirtb and vms into complain mode:
       sudo aa-complain /usr/sbin/libvirtd
       sudo aa-complain /etc/apparmor.d/libvirt/*

6. Then we can launch the VM.