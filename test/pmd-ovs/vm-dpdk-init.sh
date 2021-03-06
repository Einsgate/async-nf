#!/bin/sh

DPDK_DIR=/home/net/async-nf/vmdev/dpdk
HUGE_PAGE_FILE=/sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

# 2M huge page size and 1024 huge pages equals 2G/2048M huge pages
HUGE_PAGE_SIZE=1024

# DPDK deivce identifier
DPDK_DEVICE_ONE=00:0a.0
#DEVICE_NAME_ONE=ens10
#QUEUES_ONE=2

# Reserve huge pages
echo "echo $HUGE_PAGE_SIZE > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages" > .echo_tmp
sudo sh .echo_tmp
rm -f .echo_tmp

# Unmount huge pages
sudo umount /mnt/huge
sudo rm -R /mnt/huge

# Mount huge pages
sudo mkdir -p /mnt/huge
grep -s '/mnt/huge' /proc/mounts > /dev/null
if [ $? -ne 0 ] ; then
    sudo mount -t hugetlbfs nodev /mnt/huge
fi

# Update device
# sudo ethtool -L $DPDK_NAME_ONE combined $QUEUES_ONE

# Load uio_pci_generic
sudo modprobe uio_pci_generic

# Bind dpdk device
sudo $DPDK_DIR/usertools/dpdk-devbind.py -b uio_pci_generic $DPDK_DEVICE_ONE

# Then run test-pmd using the command
# sudo /home/net/async-nf/vmdev/provision/dpdk/app/test-pmd/testpmd 0x1F -n 4 --socket-mem 2048 -- --burst=64 -i --txqflags=0xf00 --rxq=4 --txq=4 --nb-cores=4

# On the receive machine, run the following commands:
# set stat_qmap rx 0 0 0
# set stat_qmap rx 0 1 1
# set stat_qmap rx 0 2 2
# set stat_qmap rx 0 0 0
# set fwd rxonly
# start

# On the send machine, run the following commands:
# set stat_qmap rx 0 0 0
# set stat_qmap rx 0 1 1
# set stat_qmap rx 0 2 2
# set stat_qmap rx 0 0 0
# set fwd txonly
# start

# Finally, on the receive machine, run the following commands to see the throughput:
# show port stats 0
