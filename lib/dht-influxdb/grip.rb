class Grip

  attr_reader :series, :measurements, :timestamp

  def initialize(series, measurements = [], timestamp = Time.now.to_i)
    @series = series
    measurements.each do |m|
      raise ArgumentError unless m.class.superclass == Measurement
    end
    @measurements = measurements
    raise ArgumentError unless timestamp.is_a? Integer
    @timestamp = timestamp
  end

  def as_json
    formatted(:json)
  end

  def as_line_protocol
    formatted(:line_protocol)
  end

  private

  def formatted(format)
    data = {}
    data[:series] = series
    data[:timestamp] = timestamp
    data[:values] = {}
    data[:tags] = {}
    measurements.each do |m|
      data[:values][m.name.to_sym] = m.value
      tag_name = "valid_#{m.name}"
      data[:tags][tag_name.to_sym] = m.is_valid?
    end
    if(format == :json)
      data
    elsif(format == :line_protocol)
      tags = []
      values = []
      data[:tags].each do |k,v|
        tags << "#{k}=#{v}"
      end
      data[:values].each do |k,v|
        values << "#{k}=#{v}"
      end
      "#{series},#{tags.join(",")} #{values.join(",")}"
    else
      raise UnsupportedException
    end
  end
end
