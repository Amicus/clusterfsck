require 'spec_helper'
require 'commander'
require 'cluster-fuck/cli'

module ClusterFuck::Commands
  class DummyClass
    include AmicusEnvArgumentParser
  end

  describe AmicusEnvArgumentParser do
    subject { DummyClass.new }

    it "should use the key when only one arg" do
      subject.set_amicus_env_and_key_from_args(["test-key"])
      subject.key.should == "test-key"
      subject.amicus_env.should == 'test'
    end

    it "should set amicus_env and key when two args" do
      subject.set_amicus_env_and_key_from_args(["a_different_env", "test-key"])
      subject.key.should == "test-key"
      subject.amicus_env.should == "a_different_env"
    end

  end
end
