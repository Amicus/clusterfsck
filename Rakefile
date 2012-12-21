require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

begin
  require 'ci/reporter/rake/rspec'
rescue LoadError => ex
  puts "Failed to load the ci_reporter gem. Make sure it is available in your loadpaths"
end
