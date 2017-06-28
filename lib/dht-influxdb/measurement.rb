# TemperatureScale for supporting temperatures in Celsius and Fahrenheit
module TemperatureScale
  class Celsius
  end
  class Fahrenheit
  end
end

# Base class for all named measurements.
class Measurement
  require 'json'

  # @attr_reader [String] name name of measurement
  # @attr_reader [Float,Fixnum] value of measurement
  # @attr_reader [String] unit unit of measurement
  attr_reader :name, :value, :unit

  # Create a new measurement
  # @param [String] name name to create the measurement with
  # @param [Float,Fixnum] value value of the measurement
  # @param [Hash] options the optional measurement attributes
  # @raise [ArgumentError] if the value is not numeric
  # @return [Measurement]
  def initialize(name, value, options={})
    @name = name
    raise ArgumentError unless(value.is_a? Float or value.is_a? Fixnum)
    @value = value
    @unit = options.has_key?(:unit) ? options[:unit] : "none"
  end

  # The measurement value is valid
  # @return [true]
  def is_valid?
    true
  end

  # The measurement in json
  # @return [String]
  def as_json
    { name => value}.to_json
  end

  # The measurement in InfluxDB line protocol
  # @example m.as_line_protocol => "temp=81.0"
  # @return [String]
  def as_line_protocol
    "#{name}=#{value}"
  end
end

