class Grip

  attr_reader :series, :measurements, :timestamp

  def initialize(series, measurements = [], timestamp = Time.now.to_i)
    @series = series
    measurements.each do |m|
      raise ArgumentError unless m.class.superclass == Measurement
    end
    @measurements = measurements
    raise ArgumentError unless timestamp.is_a? Fixnum
    @timestamp = timestamp
  end

  def as_json
    data = {}
    data[:series] = @series
    data[:timestamp] = @timestamp
    data[:values] = {}
    data[:tags] = {}
    @measurements.each do |m|
      data[:values][m.name] = m.value
      tag_name = "valid_#{m.name}"
      data[:tags][tag_name] = m.is_valid?
    end
    data.to_json
  end
end
