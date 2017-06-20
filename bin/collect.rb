#!/usr/bin/env ruby

require 'influxdb'
require 'dht-sensor-ffi'
require 'kalman_filter'
$: << File.expand_path("../../lib", __FILE__)
require 'ambient'

VERBOSE = false
DHT_MODEL = 22  #models are dht-11 and dht-22
GPIO_PIN = 4

influxdb = InfluxDB::Client.new("logger")

temp_filter_a = KalmanFilter.new(
                  process_noise: 0.005,
                  measurement_noise: 0.5
                )
humidity_filter_a = KalmanFilter.new(
                      process_noise: 0.005,
                      measurement_noise: 0.5
                    )

while true
  val = DhtSensor.read(GPIO_PIN,DHT_MODEL)
  vpd = Ambient.VPD(val.temp, val.humidity)
  temp_filter_a.measurement = val.temp_f if Ambient.is_valid_temp?(val.temp)
  humidity_filter_a.measurement = val.humidity if Ambient.is_valid_rh?(val.humidity)

  data = {
    values: { temperature: val.temp_f,
      humidity: val.humidity,
      temp_filter_a: temp_filter_a.value,
      humidity_filter_a: humidity_filter_a.value,
      vpd: vpd },
    timestamp: Time.now.to_i,
    series: 'conditions',
    tags: { 
      valid_humidity: Ambient.is_valid_rh?(val.humidity),
      valid_temp: Ambient.is_valid_temp?(val.temp)
    }
  }

  influxdb.write_point("conditions", data)

  puts "wrote: #{data}" if VERBOSE
  sleep(2)
end

