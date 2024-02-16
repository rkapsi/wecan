#!/bin/bash

#
# This is the script that injects itself into the GX Device's PATH
# and intercepts calls for the can-set-rate script.
#

#
# Configuration values
#
# Cerbo GX:
#    Mk1:
#        - vecan0: VE.Can
#        - vecan1: CAN-bus BMS
#
#    Mk2:
#        - vecan0: VE.Can 1
#        - vecan1: VE.Can 2
#
# Ekrano GX:
#    Same as Cerbo GX Mk2
#
 
CONFIG_DEVICE="vecan1"
CONFIG_BITRATE=500000

#
# The two arguments that are being passed in by venus-platform.
#
device=$1
bitrate=$2

#
# Replacing the caller's bitrate with our bitrate
#
if [ $device = $CONFIG_DEVICE ] && [ $bitrate -ne $CONFIG_BITRATE ]; then
    echo "Overriding the ${device} bitrate from ${bitrate} to ${CONFIG_BITRATE} bit/s"
    bitrate=$CONFIG_BITRATE
fi

#
# Calling the actual 'can-set-rate' script
#
/usr/bin/can-set-rate $device $bitrate
