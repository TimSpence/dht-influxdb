# Measurement with name = 'humidity'.
class HumidityMeasurement < Measurement

  # Creates an instance of HumidityMeasurement.
  # @param [Float,Fixnum] value the relative humidity in percent.
  # @return [HumidityMeasurement]
  def initialize(value)
    super("humidity", value, { unit: "percent" })
  end

  # The humidiy value is in a valid range.
  # @return [Boolean]
  def is_valid?
    value > 10.0 && value < 95.0
  end
end

