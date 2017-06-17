# dht-influxdb

## Overview

Quick and dirty script to read environmental data from a DHT-22 sensor and store it
in an InfluxDB database 

## Dependencies

### Hardware

* raspberry pi 
* dht-22 sensor (dht-11 also supported)

### Software

* raspbian os
* ruby 2.2+
* dht-sensor-ffi rubygem
* influxdb gem
 
## Security

Take note that this script uses the default influxdb credentials, which you should
never do in a production environment :smiley_cat:

