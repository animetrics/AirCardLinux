#!/bin/bash

#### RUN this script as sudo
if (( EUID != 0 )); then
    echo "Please rerun using sudo or as root." 1>&2
    exit 1
fi

function get_response
{
#        local ECHO
        # cat will read the response, then die on timeout
        cat <&5 >$TMP &
        echo "$1" >&5
        # wait for cat to die
        wait $!

        exec 6<$TMP
        read ECHO <&6
				read RESPONSE <&6
        exec 6<&-
        return 0
}

TMP="./response"

# Clear out old response
: > $TMP

# Set modem with timeout of 2 seconds
stty -F /dev/ttyUSB2 9600 -echo igncr -icanon min 0 time 20

# Open modem on FD 5
exec 5<>/dev/ttyUSB2

echo

echo "Turning on echo... "
get_response "ate1" || echo "Bad response"
echo "sent: 'ate1' response: '${RESPONSE}'"

echo

echo "Turning Modem on... "
get_response "at+cfun=1" || echo "Bad response"
echo "sent: '${ECHO}' response: '${RESPONSE}'"

echo

echo "Listing profiles... "
get_response 'at+cgdcont?' || echo "Bad response"
echo "sent: '${ECHO}' response: '${RESPONSE}'"

echo "Clearing profile 1... "
get_response "at+cgdcont=1" || echo "Bad response"
echo "sent: '${ECHO}'  response: '${RESPONSE}'" 

echo

echo "Clearing profile 2... "
get_response "at+cgdcont=2" || echo "Bad response"
echo "sent: '${ECHO}' response:  '${RESPONSE}'"

echo

echo "Turning Modem off... "
get_response "at+cfun=0" || echo "Bad response"
echo "sent: '${ECHO}' response: '${RESPONSE}'"

echo

echo "Turning Modem back on... "
get_response "at+cfun=1" || echo "Bad response"
echo "sent: '${ECHO}' response: '${RESPONSE}'"

echo

## Example profile for AT&T
#
#echo "Setting profile 1... "
#get_response 'at+cgdcont=1,"IP","broadband"' || echo "Bad response"
#echo "sent: '${ECHO}' response: '${RESPONSE}'"

## Example profile for Telcel Mexico
#

echo "Setting profile 1... "
get_response 'at+cgdcont=1,"IP","internet.itelcel.com"' || echo "Bad response"
echo "sent: '${ECHO}' response: '${RESPONSE}'"

## skip the following if your APN doesn't require a password
get_response 'AT$QCPDPP=1,1,"webgprs2002","webgprs"' || echo "Bad response"
echo "sent: '${ECHO}' response: '${RESPONSE}'"

echo

# The following shouldn't be needed.  It sets the default profile and auto-connect
# but uncomment if things don't work.
#
#get_response 'at!scdftprof=1' || echo "Bad response"
#echo "sent: '${ECHO}' response: '${RESPONSE}'"
#get_response 'at!scprof=1,"",0,0,0,0' || echo "Bad response"
#echo "sent: '${ECHO}' response: '${RESPONSE}'"

echo "Starting connection... "
get_response 'at!scact=1,1' || echo "Bad response"
echo "sent: '${ECHO}' response: '${RESPONSE}'"

echo

exec 5<&-

echo "Starting network interface..."
/sbin/ifconfig usb0 up
/sbin/ifup usb0


#### Below will work as well instead of above script but you don't get any output #####

## turn modem on
#echo -n 'at+cfun=1' >> /dev/ttyUSB2
#sleep 2
## remove profiles
#echo -n 'at+cgdcont=1' >> /dev/ttyUSB2
#sleep 2
## turn modem off
#echo -n 'at+cfun=0' >> /dev/ttyUSB2
#sleep 2
## turn modem back on
#echo -n 'at+cfun=1' >> /dev/ttyUSB2
#sleep 2
## add profile
#echo -n 'at+cgdcont=1,"IP","broadband"' >> /dev/ttyUSB2
#sleep 2
## 
#echo -n 'at!scact=1,1' >> /dev/ttyUSB2
