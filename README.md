# WeCan

WeCan is a very simple script that injects itself into the GX Device's `$PATH` and overwrites the GX Device's attempt to configure its CAN-bus bitrate with its own value. Let's say you want to use the `VE.Can & CAN-bus BMS (250 kbit/s)` profile but at 500 kbit/s then you can do so with this script. It works with all the GX Devices listed below.

## Device Compatibility

- Cerbo GX
- Ekrano GX

## CAN-bus Compatibility

Please note that CAN has no bitrate auto-negioation. If you configure your interface for 500 kbit/s and connect a VE.Can device to it then it'll not work. To make it work you'll need a CAN-bus Bridge to translate between 250 kbit/s and 500 kbit/s.

## Installation

Copy the contents of the `data/wecan` directory to `/data/wecan` on your GX. Make sure the scripts are executable and execute the `install.sh` script. The WeCan script takes immediately effect but you need to either toggle on/off your CAN profile once or restart the GX.

### Configuration

All configuration values (there are only two) can be found in the `wecan.sh` script and realistically speaking only `$DEVICE` is relevant.

### Firmware Upgrade

The timing when `/data/rc.local` gets executed after a Firmware upgrade is such that the `/` filesystem is still in read-only mode and the WeCan installation will fail (you can find the errors in `/var/log/boot`). The simple fix is to restart the GX one more time. Or you can SSH into the GX and repeat the installation dance.

### Validate

You can validate the CAN-bus bitrate by invoking a command like:

```
# ip -det link show vecan1
```

```
6: vecan1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UP mode DEFAULT group default qlen 100
    link/can  promiscuity 0 minmtu 0 maxmtu 0 
    can state ERROR-PASSIVE (berr-counter tx 0 rx 135) restart-ms 100 
	  bitrate 500000 sample-point 0.875 
	  tq 25 prop-seg 34 phase-seg1 35 phase-seg2 10 sjw 5
	  mcp251xfd: tseg1 2..256 tseg2 1..128 sjw 1..128 brp 1..256 brp-inc 1
	  mcp251xfd: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 1..256 dbrp-inc 1
	  clock 40000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
```

## Uninstall / Disable

Execute the `uninstall.sh` script and repeat the installation dance (toggle the CAN-bus profile or restart the GX).