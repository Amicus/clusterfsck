require 'spec_helper'
require 'commander'
require 'clusterfsck/cli'

module ClusterFsck::Commands
  class DummyClass
    include ClusterFsckEnvArgumentParser
  end

  describe ClusterFsckEnvArgumentParser do
    subject { DummyClass.new }

    it "should use the key when only one arg" do
      subject.set_cluster_fsck_env_and_key_from_args(["test-key"])
      subject.key.should == "test-key"
      subject.cluster_fsck_env.should == 'test'
    end

    it "should set cluster_fsck_env and key when two args" do
      subject.set_cluster_fsck_env_and_key_from_args(["a_different_env", "test-key"])
      subject.key.should == "test-key"
      subject.cluster_fsck_env.should == "a_different_env"
    end

  end
end
