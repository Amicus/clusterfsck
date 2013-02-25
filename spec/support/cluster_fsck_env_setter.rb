RSpec.configure do |config|
  config.before(:suite) do
    ENV['CLUSTER_FSCK_ENV'] = 'test'
    ClusterFsck::CLUSTER_FSCK_ENV = 'test'
  end
end
