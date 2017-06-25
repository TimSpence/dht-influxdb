require 'dht-influxdb/measurement'

# Measurement with name = 'temperature'. Provides conversion methods.
class TemperatureMeasurement < Measurement

  # @attr_reader [TemperatureScale::Celsius, TemperatureScale::Fahrenheit] scale
  attr_reader :scale

  # Creates a new TemperatureMeasurement
  # @param [Float,Fixnum] value the temperature measurement
  # @param [TemperatureScale::Celsius,TemperatureScale::Fahrenheit] scale
  # @returns [TemperatureMeasurement] the object created
  def initialize(value, scale=TemperatureScale::Celsius)
    @scale = scale
    super("temperature", value, { unit: "degrees" })
  end

  # The temperature value is in a valid range for its scale.
  # @return [Boolean]
  def is_valid?
    scale == TemperatureScale::Celsius ?
      value > -7.0 && value < 51.0
    :
      value > 20.0 && value < 125.0
  end

  # Converts a Celsius temperature value to Fahrenheit. If the scale is Fahrenheit,
  # returns the unaltered value.
  # @return [Float,Fixnum] the converted value
  def to_fahrenheit
    scale == TemperatureScale::Fahrenheit ?
      value
    :
      value * 9 / 5 + 32
  end

  # Converts a Fahrenheit temperature value to Celsius. If the scale is Celsius,
  # returns the unaltered value.
  # @return [Float,Fixnum] the converted value
  def to_celsius
    scale == TemperatureScale::Celsius ?
      value
    :
      (value - 32) * 5 / 9
  end
end

