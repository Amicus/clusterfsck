RSpec.configure do |config|
  config.before(:suite) do
    ENV['AMICUS_ENV'] = 'test'
    ClusterFuck::AMICUS_ENV = 'test'
  end
end
