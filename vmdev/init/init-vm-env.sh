#!/bin/sh

# Update apt.
sudo apt-get update

# Install git
sudo apt-get install git cmake -y

# download seastar
git clone https://github.com/duanjp8617/seastar.git

# Prepare to compile seastar
cd ./seastar
sudo ./install-dependencies.sh
git submodule update --init
./configure.py --enable-dpdk --compiler=g++-5 --mode=release
ninja

# clone async-nf and build a workable dpdk
cd ~/
git clone https://github.com/duanjp8617/async-nf.git
cd ./async-nf/vmdev/
./dpdk-build.sh

# After scp this file to the virtual machine, boot
# into the virtual machine. Perform the following steps
# 1. Open /etc/default/grub
# 2. In GRUB_CMDLINE_LINUX_DEFAULT, add "console=ttyS0,115200"
# 3. execute "update-grub"
# 4. From now on, use "virsh console vm-name" to log in to the vm.
