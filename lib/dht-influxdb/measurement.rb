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

class HumidityMeasurement < Measurement
  def initialize(value)
    super("humidity", value, { unit: "percent" })
  end

  def is_valid?
    @value > 10.0 && value < 95.0
  end
end

class VpdMeasurement < Measurement
  def initialize(temp, humidity)
    raise ArgumentError unless temp.is_a?(TemperatureMeasurement) && 
      humidity.is_a?(HumidityMeasurement)
    es = 0.6108 * Math.exp(17.27 * temp.to_celsius / (temp.to_celsius + 237.3))
    ea = humidity.value / 100.0 * es
    super("vpd", (ea - es).abs, { unit: "kPA" })
    @temp = temp
    @humidity = humidity
  end

  def is_valid?
    @temp.is_valid? && @humidity.is_valid?
  end
end

