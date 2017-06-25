require 'dht-influxdb/grip'

RSpec.describe(Grip, type: :grip) do
  it "accepts an array of measurements" do
    t = TemperatureMeasurement.new(25.0)
    g = Grip.new("weather", [ t ])
    expect(g.measurements[0]).to eq(t)
  end
  it "accepts an optional timestamp" do
    t = TemperatureMeasurement.new(25.0)
    ts = Time.now.to_i
    g = Grip.new("weather", [ t ], ts)
    expect(g.timestamp).to eq(ts)
  end
  it "expects the optional timestamp to be Fixnum" do
    t = TemperatureMeasurement.new(25.0)
    ts = Time.now
    expect {
      g = Grip.new("weather", [ t ], ts)
    }.to raise_error(ArgumentError)
  end
  it "has a series" do
    t = TemperatureMeasurement.new(25.0)
    g = Grip.new("weather", [ t ])
    expect(g.series).to eq("weather")
  end
  it "outputs json" do
    t = TemperatureMeasurement.new(25.0)
    g = Grip.new("weather", [ t ])
    j = g.as_json
    expect(j.class).to be(Hash)
  end
  it "outputs line protocol" do
    t = TemperatureMeasurement.new(25.0)
    h = HumidityMeasurement.new(8.0)
    g = Grip.new("weather", [t, h])
    lp = g.as_line_protocol
    expect(lp).to eq("weather,valid_temperature=true,valid_humidity=false temperature=25.0,humidity=8.0")
  end
end
