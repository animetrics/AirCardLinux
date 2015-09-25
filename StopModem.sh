#!/bin/bash

#### RUN this script as sudo
if (( EUID != 0 )); then
    echo "Please rerun using sudo or as root." 1>&2
    exit 1
fi

# turn off modem

echo -n 'at+cfun=0' >> /dev/ttyUSB2

# take down network interface
/sbin/ifdown usb0
/sbin/ifconfig usb0 down
