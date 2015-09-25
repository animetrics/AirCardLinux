#!/bin/bash

#### RUN this script as sudo
if (( EUID != 0 )); then
    echo "Please rerun using sudo or as root." 1>&2
    exit 1
fi

rpm -Uvh kernel-devel-2.6.32-573.7.1.el6.x86_64.rpm 
[ $? -ne 0 ] && echo "Failed to install kernel-devel.  Exiting" && exit 1
cp ifcfg-usb0 /etc/sysconfig/network-scripts
[ $? -ne 0 ] && echo "Failed to cp usb0 network config file.  Exiting" && exit 1
rm /lib/modules/2.6.32-358.el6.x86_64/build
[ $? -ne 0 ] && echo "Failed to remove faulty link.  Exiting" && exit 1
ln -s /usr/src/kernels/2.6.32-573.7.1.el6.x86_64 /lib/modules/2.6.32-358.el6.x86_64/build
[ $? -ne 0 ] && echo "Failed to add symbolic link.  Exiting" && exit 1
make
[ $? -ne 0 ] && echo "Failed to build driver. Exiting" && exit 1
make install
[ $? -ne 0 ] && echo "Failed to install driver. Exiting" && exit 1
