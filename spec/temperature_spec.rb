require 'dht-influxdb/temperature'

RSpec.describe(TemperatureMeasurement, type: :temperaturemeasurement) do
  it "expects a value" do
    expect {
      t = TemperatureMeasurement.new()
    }.to raise_error(ArgumentError)
  end
  it "has a default name of temperature" do
    t = TemperatureMeasurement.new(0.0)
    expect(t.name).to eq("temperature")
  end
  it "has a default unit of degrees" do
    t = TemperatureMeasurement.new(0.0)
    expect(t.unit).to eq("degrees")
  end
  it "has a default scale of Celsius" do
    t = TemperatureMeasurement.new(0.0)
    expect(t.scale).to eq(TemperatureScale::Celsius)
  end
  it "accepts a scale of Celsius" do
    t = TemperatureMeasurement.new(0.0, TemperatureScale::Celsius)
    expect(t.scale).to eq(TemperatureScale::Celsius)
  end
  it "converts celsius to fahrenheit" do
    t = TemperatureMeasurement.new(0.0, TemperatureScale::Celsius)
    expect(t.to_fahrenheit).to eq(32.0)
  end
  it "converts fahrenheit to celsius" do
    t = TemperatureMeasurement.new(32.0, TemperatureScale::Fahrenheit)
    expect(t.to_celsius).to eq(0.0)
  end
end
