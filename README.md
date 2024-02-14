# WeCan

WeCan is a very simple script that injects itself into the Victron Energy Cerbo GX `$PATH` and overwrites the Cerbo's CAN-bus bitrate. Let's say you want to use the `VE.Can & CAN-bus BMS (250 kbit/s)` profile but at 500 kbit/s then you can do so with this script.

## Installation

Copy the contents of the `data/wecan` directory to `/data/wecan` on your Cerbo GX. Make sure the scripts are executable and execute the `install.sh` script. The WeCan script takes immediately effect but you need to either toggle on/off your CAN profile or restart the Cerbo GX.

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