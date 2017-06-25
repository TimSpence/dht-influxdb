require 'dht-influxdb/measurement'

# Measurement with name = 'vpd'. Derives value of Vapor Pressure Deficit from
# temperature and relative humidity.
class VpdMeasurement < Measurement

  # Creates a new VpdMeasurement
  # @param [TemperatureMeasurement] temp an instance of temperature.
  # @param [HumidityMeasurement] humidity an instance of humidity.
  # @raise [ArgumentError] if params are wrong type.
  # @return [VpdMeasurement] an instance of VpdMeasurement.
  def initialize(temp, humidity)
    raise ArgumentError unless temp.is_a?(TemperatureMeasurement) && 
      humidity.is_a?(HumidityMeasurement)
    es = 0.6108 * Math.exp(17.27 * temp.to_celsius / (temp.to_celsius + 237.3))
    ea = humidity.value / 100.0 * es
    super("vpd", (ea - es).abs, { unit: "kPA" })
    @temp = temp
    @humidity = humidity
  end

  # The temperature and humidity are in valid ranges.
  # @return [Boolean]
  def is_valid?
    @temp.is_valid? && @humidity.is_valid?
  end
end

