#!/usr/bin/env ruby

require 'influxdb'
require 'dht-sensor-ffi'
require 'kalman_filter'
$: << File.expand_path("../../lib", __FILE__)
require 'ambient'
require 'measurement'

VERBOSE = false
DHT_MODEL = 22  #models are dht-11 and dht-22
GPIO_PIN = 4

influxdb = InfluxDB::Client.new("logger")

while true
  reading = DhtSensor.read(GPIO_PIN,DHT_MODEL)
  temp = TemperatureMeasurement.new(reading.temp_f, TemperatureScale::Fahrenheit)
  rh = HumidityMeasurement.new(reading.humidity)
  vpd = VpdMeasurement.new(temp, rh)

  data = {
    values: { temperature: temp.to_fahrenheit,
      humidity: rh.value,
      vpd: vpd.value },
    timestamp: Time.now.to_i,
    series: 'conditions',
    tags: { 
      valid_humidity: rh.is_valid?,
      valid_temp: temp.is_valid?
    }
  }

  influxdb.write_point("conditions", data)

  puts "wrote: #{data}" if VERBOSE
  sleep(2)
end

