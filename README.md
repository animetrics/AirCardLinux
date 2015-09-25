# Using Sierra Aircard direct IP usb modem with Linux

This includes everything that should be needed to install and use the driver
for Sierra Aircard (tested with 313u) on a CentOS 6.4 box running the 2.6.32
kernel.  The guide from netgear is
[here.](http://kb.netgear.com/app/answers/detail/a_id/22869/~/can-i-use-a-netgear-aircard-modem-on-linux-machines-(direct-ip-modems)%3F)
It should work for the 2.6.32 kernel in general, but was only tested on CentOS.
Check the guide to download the appropriate  driver for other kernels.  Also
included are start/stop scripts for connecting.  I found that the modem is very
finicky to the sequence of steps when turning it on and connecting.  In
particular, any profile created by other software on another machine does not
work (this doesn't seem to just be a linux thing.  If you create a profile on
Windows and try to use it on a Mac, you will run into the same problem).
Therefore, starting the modem includes turning modem on -> removing whatever
profiles might be on the device -> turning off -> turning back on -> creating a
new profile -> connecting -> bringing usb0 nic up.  Make sure to edit the
StartModem.sh script to add the proper profile for your carrier.

**NOTE:** I modified the driver code was because it uses kernel logging not
available with the Centos kernel.  Original driver code is in the orig folder.

### Install

    sudo ./InstallDriver.sh

### Start modem

If installation is successful, then you may plug in the device and then run

    sudo ./StartModem.sh

If there are no errors, check nic ip:

    ifconfig

and look for usb0 entry.

### To turn off modem

    sudo ./StopModem.sh

**Note:** Bringing up the usb0 nic  will change your resolv.conf so if your
main nic has other dns entries, after stopping the modem you will likely need
to do something like:

    killall -9 dhclient
    /sbin/ifup eth0

so that your original dns entries get rewritten in /etc/resolv.conf
