module TemperatureScale
  class Celsius
  end
  class Fahrenheit
  end
end

class Measurement
  require 'json'

  attr_reader :name, :value, :unit

  def initialize(name, value, options={})
    @name = name
    raise ArgumentError unless(value.is_a? Float or value.is_a? Fixnum)
    @value = value
    @unit = options.has_key?(:unit) ? options[:unit] : "none"
  end

  def is_valid?
    true
  end

  def as_json
    { @name => @value}.to_json
  end

  def as_line_protocol
    "#{@name}=#{@value}"
  end
end

