require 'dht-influxdb/vpd'
require 'dht-influxdb/humidity'
require 'dht-influxdb/temperature'

RSpec.describe(VpdMeasurement, type: :vpdmeasurement) do
  it "expects a TemperatureMeasurement" do
    expect {
      vpd = VpdMeasurement.new( 75.0, HumidityMeasurement.new(50.0))
    }.to raise_error(ArgumentError)
  end
  it "expects a HumidityMeasurement" do
    expect {
      vpd = VpdMeasurement.new( TemperatureMeasurement.new(75.0), 50.0)
    }.to raise_error(ArgumentError)
  end
  it "has a default name of vpd" do
    vpd = VpdMeasurement.new( TemperatureMeasurement.new(75.0),
                             HumidityMeasurement.new(50.0))
    expect(vpd.name).to eq("vpd")
  end
  it "has a default unit of kPA" do
    vpd = VpdMeasurement.new( TemperatureMeasurement.new(75.0),
                             HumidityMeasurement.new(50.0))
    expect(vpd.unit).to eq("kPA")
  end
  it "reports valid if humidity and temperature are valid" do
    vpd = VpdMeasurement.new( TemperatureMeasurement.new(75.0, TemperatureScale::Fahrenheit),
                             HumidityMeasurement.new(55.0))
    expect(vpd.is_valid?).to be(true)
  end
end
