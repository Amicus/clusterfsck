require 'spec_helper'

module ClusterFuck
  class DummyClass
    include S3Methods
  end

  describe S3Methods do
    let(:amicus_env) { 'development' }
    let(:config_bucket) { ClusterFuck::CONFIG_BUCKET }
    let(:key) { 'test_key' }
    let(:dummy_instance) { DummyClass.new }
    let(:mock_bucket) { mock(:bucket) }

    it "should qualify the keys it gets with the namespace" do
      mock_bucket.stub(:objects) { { key => 'fail',
                                    "#{amicus_env}/#{key}" => 'pass'} }
      dummy_instance.stub(:bucket) { mock_bucket }
      dummy_instance.s3_object(key).should == 'pass'
    end
  end
end
