require 'spec_helper'

module ClusterFuck
  class DummyClass
    include S3Methods
  end

  describe S3Methods do
    let(:dummy_instance) { DummyClass.new }
    let(:amicus_env) { 'development' }
    let(:config_bucket) { ClusterFuck::CONFIG_BUCKET }
    let(:key) { 'test_key' }

    it "should qualify the keys it gets with the namespace" do
      object = dummy_instance.s3_object(key)
      object.key.should == "#{amicus_env}/#{key}"
    end
  end
end
