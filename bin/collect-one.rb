#!/usr/bin/env ruby

require 'dht-sensor-ffi'

VERBOSE = false
DHT_MODEL = 22  #models are dht-11 and dht-22
GPIO_PIN = 4

  val = DhtSensor.read(GPIO_PIN,DHT_MODEL)
  es = 0.6108 * Math.exp(17.27 * val.temp / (val.temp + 237.3))
  ea = val.humidity / 100 * es
  vpd = (ea - es).abs
  data = {
    values: { temperature: val.temp_f,
      humidity: val.humidity,
      es: es,
      ea: ea,
      vpd: vpd },
    timestamp: Time.now.to_i,
    series: 'conditions',
    tags: { 
      valid_humidity: val.humidity > 10.0 && val.humidity < 95.0 ? true : false,
      valid_temp: val.temp_f > 20 && val.temp_f < 125 ? true : false
    }
  }

  measurement = 'conditions'
  tags = []
  tags << "valid_humidity=#{ val.humidity > 10.0 && val.humidity < 95.0 ? true : false }"
  tags << "valid_temp=#{ val.temp > 20.0 && val.temp < 125.0 ? true : false }"
  values = []
  values << "temperature=#{ val.temp_f }"
  values << "humidity=#{ val.humidity }"
  values << "es=#{ es }"
  values << "ea=#{ ea }"
  values << "vpd=#{ vpd }"

  data = "#{measurement},#{tags.join(",")} #{values.join(",")}"

  puts data

