#!/usr/bin/env ruby

require 'influxdb'
require 'dht-sensor-ffi'
require 'micro-optparse'
$: << File.expand_path("../../lib", __FILE__)
require 'dht-influxdb/temperature'
require 'dht-influxdb/humidity'
require 'dht-influxdb/vpd'
require 'dht-influxdb/grip'

options = Parser.new do |p|
  p.banner = "Collects data from each sensor and optionally saves to an influx db"
  p.version = "0.4.20"
  p.option :scale, "temperature scale", :default => "fahrenheit", :value_in_set => [ "fahrenheit", "celsius" ]
  p.option :verbose, "enable verbose output", :default => false
  p.option :write, "write measurement to influx db", :default => false
  p.option :loop, "loop 5ever", :default => false
  p.option :sleep, "seconds to sleep between loops", :default => 2,
    :value_satisfies => lambda { |x| x > 0 }
  p.option :format, "output format", :default => "line-protocol", 
    :value_in_set => [ "json", "line-protocol" ]
end.process!
DHT_MODEL = 22  #models are dht-11 and dht-22
GPIO_PIN = 4

def collect_data(opts)
  reading = DhtSensor.read(GPIO_PIN,DHT_MODEL)
  if(opts[:scale] == "fahrenheit")
    temp = TemperatureMeasurement.new(reading.temp_f, TemperatureScale::Fahrenheit)
  else
    temp = TemperatureMeasurement.new(reading.temp, TemperatureScale::Celsius)
  end
  rh = HumidityMeasurement.new(reading.humidity)
  vpd = VpdMeasurement.new(temp, rh)

  grip = Grip.new("conditions", [temp, rh, vpd], Time.now.to_i)
  data = ""
  if(opts[:format] == "line-protocol")
     data = grip.as_line_protocol
  else
    data = grip.as_json
  end
  if(opts[:write])
    influxdb = InfluxDB::Client.new("logger")
    influxdb.write_point("conditions", data)
  end
  puts "#{data}" if opts[:verbose]
end

if(options[:loop])
  while true
    collect_data(options)
    sleep(options[:sleep])
  end
else
  collect_data(options)
end

