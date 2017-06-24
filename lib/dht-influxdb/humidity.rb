require 'dht-influxdb/measurement'

class HumidityMeasurement < Measurement
  def initialize(value)
    super("humidity", value, { unit: "percent" })
  end

  def is_valid?
    value > 10.0 && value < 95.0
  end
end

