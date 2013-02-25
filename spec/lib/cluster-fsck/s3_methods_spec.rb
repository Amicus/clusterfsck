require 'spec_helper'

module ClusterFsck
  class DummyClass
    include S3Methods

    def cluster_fsck_env
      "test"
    end
  end

  describe S3Methods do
    let(:cluster_fsck_env) { 'test' }
    let(:config_bucket) { ClusterFsck::CONFIG_BUCKET }
    let(:key) { 'test_key' }
    let(:dummy_instance) { DummyClass.new }

    let(:mock_listing) { mock('obj', key: "#{cluster_fsck_env}/#{key}") }
    let(:bucket_objects) { mock('bucket_objects', with_prefix: [mock_listing]) }
    let(:mock_bucket) { mock(:bucket, objects: bucket_objects) }

    before do
      DummyClass.any_instance.stub(:bucket).and_return(mock_bucket)
    end

    it "should qualify the keys it gets with the namespace" do
      mock_bucket.stub(:objects) { { key => 'fail',
                                    "#{cluster_fsck_env}/#{key}" => 'pass'} }
      dummy_instance.stub(:bucket) { mock_bucket }
      dummy_instance.s3_object(key).should == 'pass'
    end

    it "should enumerate all files with the prefix" do
      bucket_objects.should_receive(:with_prefix).with(cluster_fsck_env).and_return([mock_listing])
      dummy_instance.all_files.should == [mock_listing.key]
    end

  end
end
