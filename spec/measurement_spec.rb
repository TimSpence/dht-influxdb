require 'dht-influxdb/measurement'

RSpec.describe(Measurement, type: :measurement) do
  it "expects a name" do
    expect {
      measurement = Measurement.new()
    }.to raise_error(ArgumentError)
  end
  it "expects a value" do
    expect {
      measurement = Measurement.new("some name")
    }.to raise_error(ArgumentError)
  end
  it "expects a numeric value" do
    expect {
      measurement = Measurement.new("some name", "free text")
    }.to raise_error(ArgumentError)
  end
  it "accepts a name and a value" do
    expect {
      m = Measurement.new("some name", 0.0)
    }.to_not raise_error(ArgumentError)
  end
  it "has a name" do
    name = "name"
    m = Measurement.new(name, 0.0)
    expect(m.name).to equal(name)
  end
  it "has a value" do
    value = 0.0
    m = Measurement.new("name", value)
    expect(m.value).to equal(value)
  end
end
