#!/usr/bin/env ruby

require 'influxdb'
require 'dht-sensor-ffi'
require 'micro-optparse'
$: << File.expand_path("../../lib", __FILE__)
require 'measurement'

options = Parser.new do |p|
  p.banner = "Collects data from each sensor and optionally saves to an influx db"
  p.version = "0.4.20"
  p.option :scale, "temperature scale", :default => "fahrenheit", :value_in_set => [ "fahrenheit", "celsius" ]
  p.option :verbose, "enable verbose output", :default => false
  p.option :write, "write measurement to influx db", :default => false
end.process!
DHT_MODEL = 22  #models are dht-11 and dht-22
GPIO_PIN = 4

influxdb = InfluxDB::Client.new("logger")

while true
  reading = DhtSensor.read(GPIO_PIN,DHT_MODEL)
  if(options[:scale] == "fahrenheit")
    temp = TemperatureMeasurement.new(reading.temp_f, TemperatureScale::Fahrenheit)
  else
    temp = TemperatureMeasurement.new(reading.temp, TemperatureScale::Celsius)
  end
  rh = HumidityMeasurement.new(reading.humidity)
  vpd = VpdMeasurement.new(temp, rh)

  data = {
    values: { temperature: temp.value,
      humidity: rh.value,
      vpd: vpd.value },
    timestamp: Time.now.to_i,
    series: 'conditions',
    tags: { 
      valid_humidity: rh.is_valid?,
      valid_temp: temp.is_valid?
    }
  }

  influxdb.write_point("conditions", data) if options[:write]

  puts "wrote: #{data}" if options[:verbose]
  sleep(2)
end

