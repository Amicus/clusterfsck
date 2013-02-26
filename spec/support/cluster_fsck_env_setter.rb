RSpec.configure do |config|
  config.before(:suite) do
    ENV['CLUSTER_FSCK_ENV'] = 'test'
    #redefine constant warning when setting ClusterFsck::CLUSTER_FSCK_ENV constant here
    def ClusterFsck.cluster_fsck_env
      'test'
    end
    ENV['CLUSTER_FSCK_BUCKET'] = 'test'
    ClusterFsck::CLUSTER_FSCK_BUCKET = 'test'
  end
end
