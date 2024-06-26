# WeCan

WeCan is a very simple script that injects itself into the GX Device's `$PATH` and overwrites the GX Device's attempt to configure its CAN-bus bitrate with its own value. Let's say you want to use the `VE.Can & CAN-bus BMS (250 kbit/s)` profile but at 500 kbit/s then you can do so with this script. It works with all the GX Devices listed below.

## Device Compatibility

- Cerbo GX
- Ekrano GX

## CAN-bus Compatibility

Please note that CAN has no bitrate auto-negioation. If you configure your interface for 500 kbit/s and connect a VE.Can device to it then it'll not work. To make it work you'll need a CAN-bus Bridge to translate between 250 kbit/s and 500 kbit/s.

## Use-Case

I have a CAN-bus BMS that communicates strictly at 500 kbit/s and I have a Wakespeed that runs by default at 250 kbit/s but can be configured to use 500 kbit/s. The traditional way of doing it is to plug the BMS into its own CAN-bus port and enable the `CAN-bus BMS (500 kbit/s)` profile and the Wakspeed into the other CAN-bus port and enable the `VE.Can & CAN-bus BMS (250 kbit/s)` profile for it. In this configuration the GX Device becomes a CAN-bus Bridge and a critical element in the system that cannot work without it.

My proposal is to configure the Wakespeed to use 500 kbit/s and connect it to the same CAN-bus as the BMS but this will break the GX Device integration because the `CAN-bus BMS (500 kbit/s)` profile will disregard non-BMS messages. The GX Device will ignore the Wakespeed and you can't make use of DVCC for example. The solution is to configure the CAN-bus port to use the `VE.Can & CAN-bus BMS (250 kbit/s)` profile at 500 kbit/s. In this scenario the GX Device can play a role in your electrical system but it's not a critical element.

Ideally Victron Energy should either replace the `CAN-bus BMS (500 kbit/s)` profile with a `VE.Can & CAN-bus BMS (500 kbit/s)` option, or offer it as a new option, or re-work the CAN-bus configuration altogether. Let the user choose which bitrate and protocols they want to run over any given CAN-bus port and offer the profiles as recommended presets.

## Installation

Copy the contents of the `data/wecan` directory to `/data/wecan` on your GX device. Make sure the scripts are executable and execute the `install.sh` script. The WeCan script takes immediately effect but you need to either toggle on/off your CAN profile once or restart the GX device.

### Configuration

All configuration values (there are only two) can be found in the `wecan.sh` script and realistically speaking only the `$CONFIG_DEVICE` property is relevant.

### Firmware Upgrades

Be aware that the GX's filesystem is mounted read only for as long as the access level isn't set to `Superuser` and the root password isn't set. The GX device will retain the selected access level from one Firmware Upgrade to the next but the root password gets reset/disabled every time. That means after a Firmware Upgrade you need to set the root password and restart the GX once more (or you can SSH into the GX device and essentially repeat the steps from the Installation). For any kind of errors see `/var/log/boot`.

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

Execute the `uninstall.sh` script and repeat the installation dance (toggle the CAN-bus profile or restart the GX Device).
