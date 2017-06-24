require 'dht-influxdb/measurement'

class TemperatureMeasurement < Measurement

  attr_reader :scale

  def initialize(value, scale=TemperatureScale::Celsius)
    @scale = scale
    super("temperature", value, { unit: "degrees" })
  end

  def is_valid?
    scale == TemperatureScale::Celsius ?
      value > -7.0 && value < 51.0
    :
      value > 20.0 && value < 125.0
  end

  def to_fahrenheit
    scale == TemperatureScale::Fahrenheit ?
      value
    :
      value * 9 / 5 + 32
  end

  def to_celsius
    scale == TemperatureScale::Celsius ?
      value
    :
      (value - 32) * 5 / 9
  end
end

