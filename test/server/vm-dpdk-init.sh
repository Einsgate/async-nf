#!/bin/sh

DPDK_DIR=/home/net/async-nf/vmdev/dpdk
HUGE_PAGE_FILE=/sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

# 2M huge page size and 512 huge pages equals 1G huge pages
HUGE_PAGE_SIZE=512

# DPDK deivce identifier
DPDK_DEVICE_ONE=00:0a.0
DPDK_DEVICE_TWO=00:0b.0

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


# Load igb_uio
sudo modprobe uio
sudo insmod $DPDK_DIR/build/kmod/igb_uio.ko

# Bind dpdk device
sudo $DPDK_DIR/usertools/dpdk-devbind.py -b igb_uio $DPDK_DEVICE_ONE
sudo $DPDK_DIR/usertools/dpdk-devbind.py -b igb_uio $DPDK_DEVICE_TWO

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
