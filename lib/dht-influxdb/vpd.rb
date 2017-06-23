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

