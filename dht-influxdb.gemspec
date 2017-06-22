$: << File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dht-influxdb"
  s.version     = "0.1.1"
  s.authors     = ["Tim Spence"]
  s.email       = ["yogi.wan.kenobi@gmail.com"]
  s.summary     = "Collects sensor data from Raspberry Pi"
  s.description = "dht-influxdb is a library for collecting, processing, /
  and storing environmental sensor data."
  s.license     = "GPL-3.0"

  s.files = Dir["{bin,lib}/**/*", "Gemfile", "LICENSE.txt", "Rakefile", "README.md"]

  s.required_ruby_version = "~> 2.2"
end
