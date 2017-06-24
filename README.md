# dht-influxdb

## Overview

Quick and dirty script to read environmental data from a DHT-22 sensor and store it
in an InfluxDB database.

## Dependencies

### Hardware

* raspberry pi 
* dht-22 sensor (dht-11 also supported)

### Software

* raspbian os
* ruby 2.2+
* dht-sensor-ffi gem
* influxdb gem
* kalman_filter gem

## Usage

Command line example:
```
bin/collect.rb -v

```
yields output similar to this:
```
conditions,valid_humidity=true,valid_temp=true temperature=73.03999862670898,humidity=59.79999923706055,es=2.775631105221316,ea=1.659827379745962,vpd=1.115803725475354

```
### Options
```
$ ./bin/collect.rb -h
Collects data from each sensor and optionally saves to an influx db
-s, --scale fahrenheit           temperature scale
-v, --[no-]verbose               enable verbose output
-w, --[no-]write                 write measurement to influx db
-l, --[no-]loop                  loop 5ever
-e, --sleep 2                    seconds to sleep between loops
-f, --format json                output format
-h, --help                       Show this message
-V, --version                    Print version
```
The script can take one measurement or loop.

## Telegraf

The collect-one.rb script is compatible with the Telegraf exec plugin.  It outputs the
sensor data in InfluxDB line protocol (minus the timestamp because Telegraf chokes on it).

```
$ bin/collect.rb --verbose --format line-protocol

conditions,valid_temperature=true,valid_humidity=true,valid_vpd=true temperature=71.4199993133545,humidity=60.20000076293945,vpd=1.0458877756347904

```
### Config

Sample telegraf config:
```
# Read metrics from one or more commands that can output to stdout
[[inputs.exec]]
  ## Commands array
  commands = [
    "/your/install/dir/bin/collect.rb --verbose --format line-protocol"
  ]

  ## Timeout for each command to complete.
  timeout = "5s"

  ## Data format to consume.
  data_format = "influx"

```

## Security

Take note that this script uses the default influxdb credentials, which you should
never do in a production environment :smiley_cat:

