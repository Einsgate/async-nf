1. Create the following directories:
   /data/important-do-not-touch/ubuntu-base-img
   /data/important-do-not-touch/vm-imgs

2. Create a base vm image with ubuntu 16.04, rename it into ubuntu-16.04.qcow2

3. ./provision/create-vm.sh dev

4. scp ./init/init-vm-env.sh to dev

5. run init-vm-env.sh on dev.

6. ./dpdk-build.sh

7. ./ovs-network/build-ovs.sh

8. ./ovs-network/start-ovs.sh
