#!/bin/sh

# Make sure that the baseImg and destImgDir exist on this machine.
# Make sure that the baseImg is a seastar develop machine
baseImg="/data/important-do-not-touch/ubuntu-base-img/seastar-base"
destImgDir="/data/important-do-not-touch/vm-imgs/"
nCpus=10
sizeMem=16384

# The name of the vm to be created must be passed in.
if [ $# -ne 1 ]; then
    echo "The number of input arguments is not 1."
    exit 1
fi

# Create the VM image using the base image.
if ls $destImgDir$1; then
    echo "The name of the VM has already been used."
    exit 1
else
    cp $baseImg $destImgDir$1
fi

# Create the VM.
sudo virt-install \
     --import \
     --noreboot \
     --name $1 \
     --vcpus $nCpus \
     --memory $sizeMem \
     --disk path=$destImgDir$1,format=qcow2,bus=virtio \
     --accelerate \
     --network=network:default,model=virtio \
     --serial pty \
     --cpu host \
     --rng=/dev/random

# Now we can directly work on Seastar
