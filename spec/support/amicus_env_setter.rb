RSpec.configure do |config|
  config.before(:suite) do
    ENV['AMICUS_ENV'] = 'test'
    ClusterFsck::AMICUS_ENV = 'test'
  end
end
