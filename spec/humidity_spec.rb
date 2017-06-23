require 'dht-influxdb/measurement'
require 'dht-influxdb/humidity'

RSpec.describe(HumidityMeasurement, type: :humiditymeasurement) do
  it "expects a value" do
    expect {
      h = HumidityMeasurement.new()
    }.to raise_error(ArgumentError)
  end
  it "has a default name of humidity" do
    h = HumidityMeasurement.new(50.0)
    expect(h.name).to eq("humidity")
  end
  it "has a default unit of percent" do
    h = HumidityMeasurement.new(50.0)
    expect(h.unit).to eq("percent")
  end
  it "reports valid if humidity in valid range" do
    h = HumidityMeasurement.new(50.0)
    expect(h.is_valid?).to be(true)
  end
  it "reports not valid if humidity below valid range" do
    h = HumidityMeasurement.new(96.0)
    expect(h.is_valid?).to be(false)
  end
  it "reports not valid if humidity above valid range" do
    h = HumidityMeasurement.new(9.0)
    expect(h.is_valid?).to be(false)
  end
end
