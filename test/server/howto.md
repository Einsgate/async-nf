1. Add intel_iommu=on to kernel boot parameters in /etc/default/grub, sudo update-grub and reboot the system.

2. Compile the dpdk directory in vmdev.

3. Guarantee that the physical NICs that we are going to assign to the VMs are not active, and that they are using the default i40e driver.

4. Use rep-seastar-vm.sh to create a VM called dev.

5. virsh edit dev. Then append the following XML scripts, update the domain-bus-slot-function tuple to the corresponding value of the physical NICs.

<hostdev mode='subsystem' type='pci' managed='yes'>
  <source>
    <address domain='0x0000' bus='0x05' slot='0x00' function='0x0'/>
  </source>
</hostdev>


6. Log in to dev VM and execute vm-dpdk-init.sh script in this directory to setup the basic DPDK environment.

7. Ready to roll!
