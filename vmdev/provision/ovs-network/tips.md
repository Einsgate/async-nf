Several references for creating a ovs-dpdk network.

1. Build dpdk first using the provided script in /provision

2. Build ovs using the provided script in /provision/ovs-network

3. Create a sample ovs bridge using the provided script in /provision/ovs-network

4. Then go on to configure the virtual machine.

   4.1, Add <domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
   to the domain tag.

   4.2 Add
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
						

5. Change the user and group to booth root for libvirt.
Reference: http://docs.openvswitch.org/en/latest/topics/dpdk/vhost-user/

This is enabled by:

   5.1 open /etc/libvirt/qemu.conf, add user = "root" and  group = "root"
   5.2 Install aa-complain by: apt-get install apparmor-utils
   5.3 Put libvirtb and vms into complain mode:
       sudo aa-complain /usr/sbin/libvirtd
       sudo aa-complain /etc/apparmor.d/libvirt/*

6. Then we can launch the VM.