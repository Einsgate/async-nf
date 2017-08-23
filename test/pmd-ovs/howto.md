1. Configure the two VMs with 4Gb RAM and 5 cores.

2. Execute onfigure-bridge.sh to set up the bridge.

3. Configure the XML file for the VMs.

   3.1, Add <domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
   to the domain tag.

   3.2 Add
   Note: queues should be equal with the number of PMD used by ovs-dpdk.
   Also Note: The vectors should be 2*queues+2
   <qemu:commandline>
      <qemu:arg value='-chardev'/>
      <qemu:arg value='socket,id=char0,path=/usr/local/var/run/openvswitch/vhost-user1'/>
      <qemu:arg value='-netdev'/>
      <qemu:arg value='type=vhost-user,id=netdev0,chardev=char0,vhostforce,queues=2'/>
      <qemu:arg value='-device'/>
      <qemu:arg value='virtio-net-pci,netdev=netdev0,mac=52:54:00:00:00:01,mq=on,vectors=6'/>
      <qemu:arg value='-object'/>
      <qemu:arg value='memory-backend-file,id=mem,size=2048M,mem-path=/mnt/huge,share=on'/>
      <qemu:arg value='-numa'/>
      <qemu:arg value='node,memdev=mem'/>
      <qemu:arg value='-mem-prealloc'/>
    </qemu:commandline>
						

4. Change the user and group to booth root for libvirt.
Reference: http://docs.openvswitch.org/en/latest/topics/dpdk/vhost-user/

This is enabled by:

   4.1 open /etc/libvirt/qemu.conf, add user = "root" and  group = "root"
   4.2 Install aa-complain by: apt-get install apparmor-utils
   4.3 Put libvirtb and vms into complain mode:
       sudo aa-complain /usr/sbin/libvirtd
       sudo aa-complain /etc/apparmor.d/libvirt/*

5. In the two VMs, execute ./vm-dpdk-init.sh

6. Then run test-pmd using the command
sudo /home/net/async-nf/vmdev/provision/dpdk/app/test-pmd/testpmd 0x1F -n 4 --socket-mem 2048 -- --burst=64 -i --txqflags=0xf00 --rxq=4 --txq=4 --nb-cores=4

On the receive machine, run the following commands:
set stat_qmap rx 0 0 0
set stat_qmap rx 0 1 1
set stat_qmap rx 0 2 2
set stat_qmap rx 0 0 0
set fwd rxonly
start

On the send machine, run the following commands:
set stat_qmap rx 0 0 0
set stat_qmap rx 0 1 1
set stat_qmap rx 0 2 2
set stat_qmap rx 0 0 0
set fwd txonly
start

Finally, on the receive machine, run the following commands to see the throughput:
show port stats 0
