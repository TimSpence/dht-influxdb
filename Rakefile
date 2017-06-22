begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'
require 'rake'
require 'rspec/core/rake_task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'dht-influxdb'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Default: run the specs'
task default: %w(spec:unit)

namespace :spec do
  desc "Run unit specs"
  RSpec::Core::RakeTask.new('unit') do |t|
    t.pattern = 'spec/**/*_spec.rb'
  end
end





Bundler::GemHelper.install_tasks

